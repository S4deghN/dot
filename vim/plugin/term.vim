vim9script

# TODO:
# - Add more patterns
# - Polish window creation
# - Path is not always set correctly

g:term_vertical = 1

var term_bufnr = -1
var term_tty = ''
var term_tags: dict<any>
var term_cwd = ''
var scan_ended = false

const DEFAULT_PATTERNS = [
    # Default: (stuff)?file:13:35
    '\v^\s*%(In file included from |from |CMake %(Error|Warning) at )?(\f{-}):(\d+)([.:](\d+))?:',
    # Python: File "file.py", line 10
    '\v^\s*File "([^"]+)", line (\d+)',
    # Shellcheck: In file.sh line 10
    '\v^In (\f+) line (\d+):',
    # Bash: file.sh: line 10
    # Sh:   file.sh: 10
    '\v^(\f+): %(line )?(\d+):',
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

def MatchTermTags(lines: list<string>): dict<any>
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

def g:Term(cmd: string): number
    if term_getstatus(term_bufnr) == "running"
        job_stop(term_getjob(term_bufnr), "kill")
    endif

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
    term_tags = {}
    scan_ended = false
    var job_keeper: job
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
            timer_start(200, (_) => {
                var start = reltime()
                term_tags = MatchTermTags(getbufline(term_bufnr, 1, '$'))
                echo 'scan took: ' .. reltimestr(reltime(start))
                scan_ended = true
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
        return g:Term("")
    endif

    var winid = bufwinid(term_bufnr)
    if winid == -1
        winid = CreateWindow()
        win_execute(winid, 'buffer ' .. term_bufnr)
    endif

    return winid
enddef

def GetTermTag(line_number: number): dict<any>
    var tag = {}

    if scan_ended == false
        # echo $"fell back, lnum: {line_number}"
        tag = MatchTermTags(getbufline(term_bufnr, line_number))
    elseif has_key(term_tags, line_number)
        tag = term_tags[line_number]
    endif

    return tag
enddef

def JumpTermTag(tag: dict<any>)
    # echo $"tag: {tag}"
    if empty(tag) | return | endif

    # Highlight the line
    prop_remove({type: 'term_jump_line', all: true}, 1, line('$')) # returns number of removed props. No error if removed none.
    prop_add(line('.'), 1, {length: col("$"), type: 'term_jump_line', bufnr: term_bufnr})

    # construct full path
    if tag.fname[0] != '/'
        tag.fname = term_cwd .. '/' .. tag.fname
    endif

    var buf_winid = bufwinid(tag.fname)
    if buf_winid > 0
        # echo "just jumped open window"
        win_gotoid(buf_winid)
    else
        win_gotoid(CreateWindow())
        if bufexists(tag.fname)
            # echo "used :buf"
            execute "b" tag.fname
        else
            # echo "used :edit"
            execute "e" tag.fname
        endif
    endif

    if str2nr(tag.lnum) > 0
        execute ":" .. tag.lnum
        execute "normal! ^"
    endif

    if str2nr(tag.col) > 1
        execute "normal!" tag.col .. "|"
    endif
    normal! zvzz
enddef

def CurrentError()
    JumpTermTag(GetTermTag(line('.')))
enddef

def NextError(): dict<any>
    var tag: dict<any>
    var line_number = line('.') + 1
    # TODO: Test if searching sorted list of keys makes this faster.
    while line_number < line('$')
        tag = GetTermTag(line_number)
        if !empty(tag)
            cursor(line_number, 0)
            return tag
        endif
        line_number += 1
    endwhile
    return {}
enddef

def PrevError(): dict<any>
    var tag: dict<any>
    var line_number = line('.') - 1
    while line_number > 1
        tag = GetTermTag(line_number)
        if !empty(tag)
            cursor(line_number, 0)
            return tag
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
    var tag = NextError()
    if empty(tag) | wincmd p | return | endif
    JumpTermTag(tag)
enddef

def TermPrevErrorJump()
    win_gotoid(OpenTermWindow())
    var tag = PrevError()
    if empty(tag) | wincmd p | return | endif
    JumpTermTag(tag)
enddef

def TermFirstErrorJump()
    win_gotoid(OpenTermWindow())
    var tag = FirstError()
    if empty(tag) | wincmd p | return | endif
    JumpTermTag(tag)
enddef

def TermLastErrorJump()
    win_gotoid(OpenTermWindow())
    var tag = LastError()
    if empty(tag) | wincmd p | return | endif
    JumpTermTag(tag)
enddef

def TermThisErrorJump()
    win_gotoid(OpenTermWindow())
    var tag = GetTermTag(line('.'))
    if empty(tag) | wincmd p | return | endif
    JumpTermTag(tag)
enddef

def TermKill()
    job_stop(term_getjob(term_bufnr), "kill")
enddef

# Debug

def g:TermInspectTags(): dict<any>
    return term_tags
enddef

defcomp

command! -nargs=* -complete=shellcmdline
            \ Term           g:Term(<q-args>)
command! -bar TermToggleWin  ToggleWindow()
command! -bar TermKill       TermKill()
command! -bar TermThisError  TermThisErrorJump()
command! -bar TermFirstError TermFirstErrorJump()
command! -bar TermLastError  TermLastErrorJump()
command! -bar TermNextError  TermNextErrorJump()
command! -bar TermPrevError  TermPrevErrorJump()

# Configuration -----------------------------------------------------
nnoremap cc :silent! wa!<cr>:Term <Up>
nnoremap sn :Term<space>
nnoremap ss <cmd>TermToggleWin<cr>
nnoremap sx <cmd>TermKill<cr>
nnoremap sj <cmd>TermNextError<cr>
nnoremap sk <cmd>TermPrevError<cr>
nnoremap s$ <cmd>TermLastError<cr>
nnoremap s0 <cmd>TermFirstError<cr>
nnoremap s<cr> <cmd>TermThisError<cr>
