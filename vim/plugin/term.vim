vim9script

# - [ ] polish window creation
# - [ ] path is not always set correctly

g:use_local_efm = 0
g:term_vertical = 1

var term_bufnr = -1
var term_tty = ''
var term_efm = ''
var term_tag_lines: dict<any>
var term_cwd = ''

const BASE_EFM = join([
    '%+G\ze%*\d:%*\d:%*\d', # ignore time format 12:12:12
    '%*[^"]"%f"%*\D%l: %m',
    '%f%\ze:%l:%c:%m',
    '%f(%l):%m',
    '%f:%l:%m',
    '%f: %\\%(line %\\)%\\?%l: %m', # shell error (bash has that extra "line")
    '%f|%l| %m',
    '"%f"%*\D%l: %m',
    '"%f"\, line %l%*\D%c%*[^ ] %m',
    '%D%*\a[%*\d]: Entering directory %*[`'']%f''',
    '%X%*\a[%*\d]: Leaving directory %*[`'']%f''',
    '%D%*\a: Entering directory %*[`'']%f''',
    '%X%*\a: Leaving directory %*[`'']%f''',
    '%DMaking %*\a in %f',
    '%*\sFile "%f"\, line %l', # Python
    'In %f line %l:', # shellcheck
], ',')

# TODO: Verify and optimize these patterns
const DEFAULT_PATTERNS = [
  # # GNU/Clang/GCC and simple grep/ripgrep output.  The dot-column form mirrors
  # # the second GNU syntax accepted by Emacs's broad `gnu' matcher.
  # '\v^\s*(.{-}):([1-9]\d*):\s*.*$',
  # '\v^\s*(.{-}):([1-9]\d*):([1-9]\d*):\s*.*$',
  # '\v^\s*(.{-}):([1-9]\d*)\.([1-9]\d*):\s*.*$',

  # # MSVC/EDG-style: file.cpp(12,34): error ... / file.cpp(12): ...
  # '\v^\s*(.{-})\(([1-9]\d*)\)\s*:',
  # '\v^\s*(.{-})\(([1-9]\d*),\s*([1-9]\d*)\)\s*:',

  # # CMake Error/Warning at path/file.cmake:12 (...):
  # '\v^CMake (Error|Warning) at (.{-}):([1-9]\d*)($|\s)',

  # # GCC/Clang include chain: In file included from foo.h:12:3:
  # '\v^(In file included from |[ \t]*from )(.{-}):([1-9]\d*)(:([1-9]\d*))?:',

  # # Bash: script.sh: line 12: syntax error ...
  # '\v^(.+): line ([1-9]\d*):',

  # # ShellCheck: In script.sh line 12:
  # '\v^In (.+) line ([1-9]\d*):',

  # # Python traceback:   File "foo.py", line 12, in func
  # '\v^\s*File "([^"]+)", line ([1-9]\d*)',

  '\v^\s*%(In file included from |from |CMake %(Error|Warning) at )?(\f{-}):(\d+)([.:](\d+))?:',
  # '\v^CMake (Error|Warning) at (\f{-}):(\d+)($|\s)',
  '\v^\s*File "([^"]+)", line (\d+)',
  '\v^In (.+) line (\d+):',
  '\v^(.+): line (\d+):',
  '\v^\s*(.{-})\((\d+)(,\s*(\d+))?\)\s*:',
]

if empty(prop_type_get('term_jump_line'))
    prop_type_add('term_jump_line', {highlight: 'QuickFixLine'})
endif

def OnTermWinOpen()
    setl foldmethod=manual
    setl nonu
    setl showbreak=NONE

    hi! link StatuslineTerm Statusline
    hi! link StatuslineTermNC StatuslineNC

    # nnoremap <buffer> <C-q> <scriptcmd>TermToQf()<CR>
    nnoremap <buffer> <C-c> <scriptcmd>TermKill()<CR>
    nnoremap <buffer> <CR> <scriptcmd>CurrentError()<CR>
    nnoremap <buffer> ]] <scriptcmd>NextError()<CR>
    nnoremap <buffer> [[ <scriptcmd>PrevError()<CR>
    nnoremap <buffer> ]} <scriptcmd>LastError()<CR>
    nnoremap <buffer> [{ <scriptcmd>FirstError()<CR>
enddef

def MatchTermLines(lines: list<string>): dict<any>
    var matched_lines: dict<any>
    var i = 1 # lines start form 1
    for line in lines
        for pattern in DEFAULT_PATTERNS
            var match = matchlist(line, pattern)
            if !empty(match)
                matched_lines[i] = {fname: match[1], lnum: match[2], col: match[3]}
                break
            endif
        endfor
        i += 1
    endfor
    return matched_lines
enddef

def g:Term(cmd: string, bang: bool): number
    if term_getstatus(term_bufnr) == "running"
        job_stop(term_getjob(term_bufnr), "kill")
    endif

    term_efm = GetEfm()

    var windows = win_findbuf(term_bufnr)
    var win_to_use: number
    if len(windows)
        win_to_use = windows[0]
    else
        win_to_use = CreateWindow()
    endif

    var old_bufnr = bufexists(term_bufnr) ? term_bufnr : -1
    var initila_winid = win_getid()
    win_gotoid(win_to_use)

    term_cwd = getcwd()
    term_tag_lines = {}
    var job_keeper: job
    var job_ended = false
    var job_start_time = reltime()
    term_bufnr = term_start([&shell, &shellcmdflag, cmd], {
        cwd: term_cwd,
        curwin: 1,
        term_name: '[term]',
        exit_cb: (job, ec) => {
            var exit_term = ec != -1 ? ec : job_info(job).termsig
            var footer = printf("\n\r%.2fs - exit \e[%dm%s\e[m", reltimefloat(reltime(job_start_time)), ec == 0 ? 32 : 31, exit_term)
            writefile([footer], term_tty)
            job_stop(job_keeper, "kill")
        },
        close_cb: (job) => {
            job_ended = true
            timer_start(200, (_) => {
                var start = reltime()
                # term_tag_lines = getqflist({lines: getbufline(term_bufnr, 1, '$'), efm: term_efm }).items
                term_tag_lines = MatchTermLines(getbufline(term_bufnr, 1, '$'))
                echom 'scan took: ' .. reltimestr(reltime(start))
            })
            timer_start(0, (_) => { # wait one loop for buffer redraw
                var winid = bufwinid(term_bufnr)
                if winid != -1 && getcurpos(winid)[1] == getbufinfo(term_bufnr)[0].linecount
                    win_execute(winid, 'keepjump norm! G')
                endif
            })
        },
    })
    term_tty = term_gettty(term_bufnr)
    job_keeper = job_start(['sleep', '2147483647'], {out_io: 'file', out_name: term_tty})
    writefile([$"\e[32m$\e[m {cmd}\n"], term_tty)

    OnTermWinOpen()

    win_gotoid(initila_winid)

    if old_bufnr != -1
        exe "bdelete!" old_bufnr
    endif

    return win_to_use
enddef

def GetEfm(): string
    if g:use_local_efm != 0
        var local_efm = (bufnr() == term_bufnr ?
            getbufvar(winbufnr(winnr('#')), &l:efm) :
            &l:efm
        )->substitute(',%-G%.%#', '', 'g')
         ->substitute('^,\+', '', 'g')

        return join([local_efm, BASE_EFM], ',')
    else
        return BASE_EFM
    endif
enddef

var was_a_win_there: bool = false
var vsplit_col_limit = 174
def CreateWindow(force_split: bool = 0): number
    var current_win_pos = win_screenpos(0)
    var winnr = winnr()

    if force_split
        var width = getwininfo(win_getid(winnr))[0].width
        exe (width >= vsplit_col_limit ? 'v' : '') .. 'split'
        wincmd p
        return win_getid(winnr('#'))
    endif

    var lj = &columns > vsplit_col_limit ? '1l' : '1j'
    var hk = &columns > vsplit_col_limit ? '1h' : '1k'
    var v  = (&columns > vsplit_col_limit) && (g:term_vertical == 1) ? 'v' : ''
    if winnr != winnr(lj)
        was_a_win_there = true
        return win_getid(winnr(lj))
    elseif winnr != winnr(hk)
        was_a_win_there = true
        return win_getid(winnr(hk))
    else
        was_a_win_there = false
        exe 'botright' v .. 'split'
        wincmd p
        return win_getid(winnr('#'))
    endif
enddef

def ToggleWindow()
    var winnr = bufwinnr(term_bufnr)
    if winnr == -1
        OpenTermWindow()
    else
        if was_a_win_there
            try
                win_execute(win_getid(winnr), "norm! \<C-^>")
            catch /.*/
                exe $":{winnr}close"
            endtry
        else
            exe $":{winnr}close"
        endif
    endif
enddef

def OpenTermWindow(): number
    if !bufexists(term_bufnr)
        return g:Term("echo Hello!", 0)
    endif

    var winid = bufwinid(term_bufnr)
    if winid == -1
        winid = CreateWindow()
        win_execute(winid, 'buffer ' .. term_bufnr)
    endif

    return winid
enddef

def GetTermLine(line_number: number): dict<any>
    var line: dict<any>
    # if line_number < term_tag_lines->len()
    if has_key(term_tag_lines, line_number)
        line = term_tag_lines[line_number]
    else
        # echo $"fell back, lnum: {line_number}"
        # line = getqflist({lines: getbufline(term_bufnr, line_number), efm: term_efm}).items[0]
    endif
    return line
enddef

def JumpTermLine(line: dict<any>)
    echo $"line: {line}"
    if empty(line) | return | endif

    # Highlight the line
    prop_remove({type: 'term_jump_line', all: true}, 1, line('$')) # returns number of removed props. No error if removed none.
    prop_add(line('.'), 1, {length: col("$"), type: 'term_jump_line', bufnr: term_bufnr})

    # construct full path
    if line.fname[0] != '/'
        line.fname = term_cwd .. line.fname
    endif

    var buf_winid = bufwinid(line.fname)
    if buf_winid > 0
        echo "just jumped open window"
        win_gotoid(buf_winid)
    else
        win_gotoid(CreateWindow())
        if bufexists(line.fname)
            echo "used :buf"
            execute "b" line.fname
        else
            echo "used :edit"
            execute "e" line.fname
        endif
    endif

    if str2nr(line.lnum) > 0
        execute ":" .. line.lnum
        execute "normal! ^"
    endif

    if str2nr(line.col) > 1
        execute "normal!" line.col .. "|"
    endif
    normal! zvzz
enddef

# def TermToQf()
#     if bufexists(term_bufnr)
#         cgetexpr getbufline(term_bufnr, 1, "$")
#     endif
# enddef

def CurrentError()
    JumpTermLine(GetTermLine(line('.')))
enddef

def NextError(): dict<any>
    var line: dict<any>
    var line_number = line('.') + 1
    while line_number < line('$')
        line = GetTermLine(line_number)
        if !empty(line)
            cursor(line_number, 0)
            return line
        endif
        line_number += 1
    endwhile
    return {}
enddef

def PrevError(): dict<any>
    var line: dict<any>
    var line_number = line('.') - 1
    while line_number > 1
        line = GetTermLine(line_number)
        if !empty(line)
            cursor(line_number, 0)
            return line
        endif
        line_number -= 1
    endwhile
    return {}
enddef

def FirstError(): dict<any>
    :0 | return NextError()
enddef

def LastError(): dict<any>
    :$ | return PrevError()
enddef

def TermNextErrorJump()
    win_gotoid(OpenTermWindow())
    var line = NextError()
    JumpTermLine(line)
enddef

def TermPrevErrorJump()
    win_gotoid(OpenTermWindow())
    var line = PrevError()
    JumpTermLine(line)
enddef

def TermFirstErrorJump()
    win_gotoid(OpenTermWindow())
    var line = FirstError()
    JumpTermLine(line)
enddef

def TermLastErrorJump()
    win_gotoid(OpenTermWindow())
    var line = LastError()
    JumpTermLine(line)
enddef

def TermThisErrorJump()
    win_gotoid(OpenTermWindow())
    JumpTermLine(GetTermLine(line('.')))
enddef

def TermKill()
    job_stop(term_getjob(term_bufnr), "kill")
enddef

# Debug

def g:TermInspectQf(): dict<any>
    return term_tag_lines
enddef

def g:TermInspectEfm(): string
    return term_efm
enddef

defcomp

command! -nargs=* -bang -complete=shellcmdline Term g:Term(<q-args>, <bang>0)
command! -nargs=0 -bar TermToggleWin      ToggleWindow()
# command! -nargs=0 -bar TermToQf           TermToQf()
command! -nargs=0 -bar TermKill           TermKill()
command! -nargs=0 -bar TermNextErrorJump  TermNextErrorJump()
command! -nargs=0 -bar TermFirstErrorJump TermFirstErrorJump()
command! -nargs=0 -bar TermPrevErrorJump  TermPrevErrorJump()
command! -nargs=0 -bar TermLastErrorJump  TermLastErrorJump()
command! -nargs=0 -bar TermThisErrorJump  TermThisErrorJump()

# Configuration -----------------------------------------------------
# nnoremap cc :wa<cr><cmd>call TermInput()<cr>
nnoremap cc :silent! wa!<cr>:Term OA
nnoremap sn :Term<space>
nnoremap ss <cmd>TermToggleWin<cr>
# nnoremap sq <cmd>TermToQf<cr>
nnoremap sx <cmd>TermKill<cr>
nnoremap sj <cmd>TermNextErrorJump<cr>
nnoremap sk <cmd>TermPrevErrorJump<cr>
nnoremap s$ <cmd>TermLastErrorJump<cr>
nnoremap s0 <cmd>TermFirstErrorJump<cr>
nnoremap s<cr> <cmd>TermThisErrorJump<cr>

