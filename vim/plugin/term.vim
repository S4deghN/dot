vim9script

# - [ ] jobs are not killed porperlly all the times
# - [ ] path is not always set currectly

var term_bufnr = -1
var term_cwd = ''

var S_bufname: string
var S_filetype: string

g:term_vertical = 1

if empty(prop_type_get('term_jump_line'))
    prop_type_add('term_jump_line', {highlight: 'QuickFixLine'})
endif

if empty(prop_type_get('term_footer'))
    prop_type_add('term_footer', {highlight: 'Comment'})
endif

def OnTermWinOpen()
    setl foldmethod=manual
    setl nonu
    setl nowrap
    setl showbreak=NONE

    hi! link StatuslineTerm Statusline
    hi! link StatuslineTermNC StatuslineNC

    nnoremap <buffer> <C-q> <scriptcmd>TermToQf()<CR>
    nnoremap <buffer> <C-c> <scriptcmd>TermKill()<CR>
    nnoremap <buffer> <CR> <scriptcmd>OpenFile()<CR>
    nnoremap <buffer> ]] <scriptcmd>NextError()<CR>
    nnoremap <buffer> [[ <scriptcmd>PrevError()<CR>
    nnoremap <buffer> ]} <scriptcmd>LastError()<CR>
    nnoremap <buffer> [{ <scriptcmd>FirstError()<CR>
enddef

def g:TermInput()
    var cmd = ''
    echohl ModeMsg
    try
        cmd = input('Term: ', "\<Up>", 'shellcmdline')
    finally | echohl None | endtry
    if len(cmd) == 0 | return | endif

    g:Term(cmd, false)
enddef


def g:Term(cmd: string, bang: bool, ...args: list<any>): number
    t:term_cmd = cmd

    S_bufname = get(args, 0, '')
    S_filetype = get(args, 1, '')
    g:term_vertical = get(args, 2, 1)

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

    term_cwd = getcwd() .. '/'

    var old_bufnr = bufexists(term_bufnr) ? term_bufnr : -1
    var initila_winid = win_getid()
    win_gotoid(win_to_use)

    var escaped_cmd = has('win32') ?  cmd : [
        &shell,
        &shellcmdflag,
        'printf "\e[32m$\e[m %s\n\n" "' .. cmd .. '" ;' ..
        'start=$EPOCHREALTIME;' ..
        cmd .. ';' ..
        'exit_code=$?;' ..
        'end=$EPOCHREALTIME;' ..
        'awk ''{printf "\n%.2fs - exit \033[%dm%d\033[m", $2-$1, $3 == 0 ? 32 : 31, $3}'' <<< "$start $end $exit_code";'
    ]

    term_bufnr = term_start(escaped_cmd, {
        cwd: term_cwd,
        curwin: 1,
        term_name: '[term]',
        out_modifiable: true,
        exit_cb: (job, ec) => {
            setbufvar(term_bufnr, 'term_ec', ec)
        },
    })
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

def OpenFile()
    const file_patterns = [
        '^\s*\s\+File "\(.\{-}\)", line \(\d\+\)',
        '^\s*\s\+in function\s\+.\{-}(\(.\{-}\), line \(\d\+\))',
        '^\s*\s\+--> \(.\{-}\):\(\d\+\):\(\d\+\)',
        '^\s*\(\)\(\d\+:\)\(\d\+:\)\?',
        '^\s*\(.\{-}\):\(\d\+:\)\?\(\d\+:\)\?',
        '^\s*\(\S\+\)'
    ]
    var matches: list<string>
    for pattern in file_patterns
        matches = matchlist(getline('.'), pattern)
        if len(matches) > 0 | break | endif
    endfor
    if len(matches) == 0 | return | endif

    var [_, fname, lnum, col; _] = matches

    # echom "reached before fname check"

    # check if it's a regular rg output with filename as a header
    if empty(fname)
        var fname_line = search('^$', 'bnW') + 1
        if fname_line == 1 | fname_line = 2 | endif
        var header = getline(fname_line)
        fname = header
    endif

    # construct absolute path because vim's cwd might have changed since command
    # was run.
    if (fname[0] != '/')
        fname = term_cwd .. fname
    endif

    if !filereadable(fname) | return | endif

    # Highlight the line
    prop_remove({type: 'term_jump_line', all: true}, 1, line('$')) # returns number of removed props. No error if removed none.
    prop_add(line('.'), 1, {length: col("$"), type: 'term_jump_line', bufnr: term_bufnr})


    var buffers = filter(getbufinfo(), (idx, v) => fname == v.name)
    fname = substitute(fname, '#', '\&', 'g')

    if len(buffers) > 0
        if len(buffers[0].windows) > 0
            win_gotoid(buffers[0].windows[0])
        else
            win_gotoid(CreateWindow())
            execute "buffer" fname
        endif
    else
        win_gotoid(CreateWindow())
        execute "edit" fname
    endif

    if !empty(lnum)
        execute ":" .. lnum
        execute "normal! ^"
    endif

    if !empty(col) && str2nr(col) > 1
        execute "normal!" (str2nr(col)) .. "|"
    endif
    normal! zvzz
enddef

def TermToQf()
    if bufexists(term_bufnr)
        cgetexpr getbufline(term_bufnr, 1, "$")
    endif
enddef

const ErrJumpPattern =
    '\%(' ..
        '\%(^\(\)\(\d\+:\)\(\d\+:\)\?[^0-9]\+\)' ..
        '\|\%(^\f\+:\d\+\(:\d\+:\?\)\?\)' ..
        '\|\%(^\s*File ".\{-}", line \d\+,\)' ..
        '\|\%(^\s\+in function\s\+.\{-}(.\{-}, line \d\+)\)' ..
    '\)' ..
    '\&\%(^\d\+:\d\+:\d\+\)\@!' # skip '12:23:30'
def NextError()
    var did_match = search(ErrJumpPattern, 'W')
    if !!did_match
        normal! zz
    endif
enddef

def PrevError(accept_current: bool = false)
    var did_match = search(ErrJumpPattern, 'bW' .. (accept_current ? 'c' : ''))
    if !!did_match
        normal! zz
    endif
enddef

def FirstError()
    :0 | NextError()
enddef

def LastError()
    :$ | PrevError(true)
enddef

def TermNextErrorJump()
    win_gotoid(OpenTermWindow())
    NextError()
    OpenFile()
enddef

def TermPrevErrorJump()
    win_gotoid(OpenTermWindow())
    PrevError()
    OpenFile()
enddef

def TermFirstErrorJump()
    win_gotoid(OpenTermWindow())
    FirstError()
    OpenFile()
enddef

def TermLastErrorJump()
    win_gotoid(OpenTermWindow())
    LastError()
    OpenFile()
enddef

def TermThisErrorJump()
    win_gotoid(OpenTermWindow())
    OpenFile()
enddef

def TermKill()
    job_stop(term_getjob(term_bufnr), "kill")
enddef

defcom

command! -nargs=* -bang -complete=shellcmdline Term g:Term(<q-args>, <bang>0)
command! -nargs=0 -bar TermToggleWin      ToggleWindow()
command! -nargs=0 -bar TermToQf           TermToQf()
command! -nargs=0 -bar TermKill           TermKill()
command! -nargs=0 -bar TermNextErrorJump  TermNextErrorJump()
command! -nargs=0 -bar TermFirstErrorJump TermFirstErrorJump()
command! -nargs=0 -bar TermPrevErrorJump  TermPrevErrorJump()
command! -nargs=0 -bar TermLastErrorJump  TermLastErrorJump()
command! -nargs=0 -bar TermThisErrorJump  TermThisErrorJump()

# Configuration -----------------------------------------------------
# nnoremap cc :wa<cr>:Term <C-r>=get(t:, 'term_cmd', '')<cr>
# nnoremap cc :wa<cr><cmd>call TermInput()<cr>
nnoremap cc :silent! wa!<cr>:Term OA
nnoremap sn :Term<space>
nnoremap ss <cmd>TermToggleWin<cr>
nnoremap sq <cmd>TermToQf<cr>
nnoremap sx <cmd>TermKill<cr>
nnoremap sj <cmd>TermNextErrorJump<cr>
nnoremap sk <cmd>TermPrevErrorJump<cr>
nnoremap s$ <cmd>TermLastErrorJump<cr>
nnoremap s0 <cmd>TermFirstErrorJump<cr>
nnoremap s<cr> <cmd>TermThisErrorJump<cr>

