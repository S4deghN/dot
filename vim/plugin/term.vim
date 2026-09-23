vim9script

# - [ ] jobs are not killed porperlly all the times
# - [ ] path is not always set currectly

var term_bufnr = -1
var term_tty = ''
var term_qf = []
var term_efm = &g:efm

g:term_vertical = 1

# Ignore time format 12:12:12
setglobal efm^=%-G%l:%e:%c

if empty(prop_type_get('term_jump_line'))
    prop_type_add('term_jump_line', {highlight: 'QuickFixLine'})
endif

const PATTERNS = [
    # GNU-style diagnostics, GCC/Clang include chains and the colon form of
    # CMake diagnostics all reduce to file:line[:col]:.
    '\v^\s*%(In file included from |from |CMake %(Error|Warning) at )?(.{-}):([1-9]\d*)%([.:]([1-9]\d*))?:',
    '\v^\s*File "([^"]+)", line ([1-9]\d*)',
    '\v^In (.+) line ([1-9]\d*):',
    '\v^(.+): line ([1-9]\d*):',
]

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

def g:Term(cmd: string, bang: bool): number
    if term_getstatus(term_bufnr) == "running"
        job_stop(term_getjob(term_bufnr), "kill")
    endif

    if !empty(&l:efm) && (bufnr() != term_bufnr || !empty(&ft))
        term_efm = join([&l:efm, &g:efm], ',')
            # we rely on having the whole buffer lines in qflist so remove any possible dicard pattern
            ->substitute(',%-G%.%#', '', 'g')
            ->substitute('^,\+', '', 'g')
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

    term_qf = []
    var job_keeper: job
    var job_ended = false
    var job_start_time = reltime()
    term_bufnr = term_start([&shell, &shellcmdflag, cmd], {
        cwd: getcwd(),
        curwin: 1,
        term_name: '[term]',
        exit_cb: (job, ec) => {
            var footer = printf("\n%.2fs - exit \e[%dm%d\e[m", reltimefloat(reltime(job_start_time)), ec == 0 ? 32 : 31, ec)
            writefile([footer], term_tty)
            job_stop(job_keeper, "kill")
        },
        close_cb: (job) => {
            job_ended = true
            timer_start(200, (_) => {
                var start = reltime()
                term_qf = getqflist({lines: getbufline(term_bufnr, 1, '$'), efm: term_efm }).items
                echom 'scan took: ' .. reltimestr(reltime(start))
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
        return g:Term("echo Hello!", 0)
    endif

    var winid = bufwinid(term_bufnr)
    if winid == -1
        winid = CreateWindow()
        win_execute(winid, 'buffer ' .. term_bufnr)
    endif

    return winid
enddef

def GetQfItem(line_number: number): dict<any>
    var item: dict<any>
    if line_number < term_qf->len()
        item = term_qf[line_number - 1]
    else
        echo $"fell back, lnum: {line_number}"
        item = getqflist({lines: getbufline(term_bufnr, line_number), efm: term_efm}).items[0]
    endif
    return item
enddef

def JumpQfItem(item: dict<any>)
    echo $"Item: {item}"
    if !item.valid | return | endif

    # Highlight the line
    prop_remove({type: 'term_jump_line', all: true}, 1, line('$')) # returns number of removed props. No error if removed none.
    prop_add(line('.'), 1, {length: col("$"), type: 'term_jump_line', bufnr: term_bufnr})

    var buf_winid = bufwinid(item.bufnr)
    if buf_winid > 0
        win_gotoid(buf_winid)
    else
        win_gotoid(CreateWindow())
        execute "buffer" item.bufnr
    endif

    if item.lnum > 0
        execute ":" .. item.lnum
        execute "normal! ^"
    endif

    if item.col > 1
        execute "normal!" item.col .. "|"
    endif
    normal! zvzz
enddef

# def TermToQf()
#     if bufexists(term_bufnr)
#         cgetexpr getbufline(term_bufnr, 1, "$")
#     endif
# enddef

def CurrentError()
    JumpQfItem(GetQfItem(line('.')))
enddef

def NextError(): dict<any>
    var item: dict<any>
    var line_number = line('.') + 1
    while line_number < line('$')
        item = GetQfItem(line_number)
        if item.valid
            cursor(line_number, 0)
            return item
        endif
        line_number += 1
    endwhile
    return {valid: false}
enddef

def PrevError(): dict<any>
    var item: dict<any>
    var line_number = line('.') - 1
    while line_number > 1
        item = GetQfItem(line_number)
        if item.valid
            cursor(line_number, 0)
            return item
        endif
        line_number -= 1
    endwhile
    return {valid: false}
enddef

def FirstError(): dict<any>
    :0 | return NextError()
enddef

def LastError(): dict<any>
    :$ | return PrevError()
enddef

def TermNextErrorJump()
    win_gotoid(OpenTermWindow())
    var item = NextError()
    JumpQfItem(item)
enddef

def TermPrevErrorJump()
    win_gotoid(OpenTermWindow())
    var item = PrevError()
    JumpQfItem(item)
enddef

def TermFirstErrorJump()
    win_gotoid(OpenTermWindow())
    var item = FirstError()
    JumpQfItem(item)
enddef

def TermLastErrorJump()
    win_gotoid(OpenTermWindow())
    var item = LastError()
    JumpQfItem(item)
enddef

def TermThisErrorJump()
    win_gotoid(OpenTermWindow())
    JumpQfItem(GetQfItem(line('.')))
enddef

def TermKill()
    job_stop(term_getjob(term_bufnr), "kill")
enddef

# Debug

def g:TermInspectQf(): list<any>
    return term_qf
enddef

def g:TermInspectEfm(): string
    return term_efm
enddef

defcom

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

