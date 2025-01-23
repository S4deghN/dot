vim9script

# TODO: Line wraps are a problem
# https://github.com/vim/vim/issues/5769
# https://github.com/vim/vim/issues/2865

var S_bufname: string
var S_filetype: string

def OnTermWinOpen()
    setl foldmethod=expr foldexpr=0
    setl stl-=%f
    setl stl^=%f\ %([%{%get(t:,'term_cmd')%}]%)%(\ [exit:%{%get(b:,'term_ec','')%}]%)

    # if !!get(b:, 'match') | silent! matchdelete(b:match) | endif
    # silent! matchdelete(b:match)
    clearmatches()

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

export def g:Term(cmd: string, bang: string, ...args: list<string>): number
    t:term_cmd = cmd

    S_bufname = get(args, 0, '')
    S_filetype = get(args, 1, '')

    var bufnr = GetTermBufnr()
    if term_getstatus(bufnr) == "running"
        job_stop(term_getjob(bufnr))
    endif

    var windows = win_findbuf(bufnr)
    var win_to_use: number
    if len(windows)
        win_to_use = windows[0]
    else
        win_to_use = CreateWindow(!!len(bang))
    endif

    var cwd = getcwd() .. '/'

    var old_bufnr = bufnr > 0 ? bufnr : 0
    var initila_winid = win_getid()
    win_gotoid(win_to_use)
    var escaped_cmd = has('win32') ? cmd : [&shell, &shellcmdflag, escape(cmd, '\')]
    bufnr = term_start(escaped_cmd, {
        cwd: cwd,
        curwin: 1,
        term_name: '[term]',
        exit_cb: (job, ec) => setbufvar(bufnr, 'term_ec', ec),
    })
    OnTermWinOpen()
    win_gotoid(initila_winid)
    setbufvar(bufnr, 'term_cwd', cwd)

    if old_bufnr > 0
        exe "bdelete!" old_bufnr
    endif

    return win_to_use
enddef

def GetTermBufnr(): number
    var buffers = term_list()
    if len(buffers) > 0
        return buffers[0]
    else
        return -1
    endif
enddef

var was_a_win_there: bool = false
def CreateWindow(force_split: bool = 0): number
    var current_win_pos = win_screenpos(0)
    var winnr = winnr()

    if force_split
        var width = getwininfo(win_getid(winnr))[0].width
        exe (width > 160 ? 'v' : '') .. 'split'
        wincmd p
        return win_getid(winnr('#'))
    endif

    var lj = &columns > 160 ? '1l' : '1j'
    var hk = &columns > 160 ? '1h' : '1k'
    var v  = &columns > 160 ? 'v' : ''
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
    var winnr = bufwinnr(GetTermBufnr())
    if winnr == -1
        OpenTermWindow()
    else
        if was_a_win_there
            win_execute(win_getid(winnr), "norm! \<C-^>")
        else
            exe $":{winnr}close"
        endif
    endif
enddef

def OpenTermWindow(): number
    var bufnr = GetTermBufnr()
    if bufnr < 0
        return g:Term("echo Hello!", "")
    endif

    var winid = bufwinid(bufnr)
    if winid == -1
        winid = CreateWindow()
        win_execute(winid, 'buffer ' .. bufnr)
    endif

    return winid
enddef

def OpenFile()
    const file_patterns = [
        '^\s\+File "\(.\{-}\)", line \(\d\+\)',
        '^\s\+in function\s\+.\{-}(\(.\{-}\), line \(\d\+\))',
        '^\s\+--> \(.\{-}\):\(\d\+\):\(\d\+\)',
        '^\(\)\(\d\+:\)\(\d\+:\)\?',
        '^\(.\{-}\):\(\d\+:\)\?\(\d\+:\)\?',
        '^\(\S\+\)'
    ]
    var matches: list<string>
    for pattern in file_patterns
        matches = matchlist(getline('.'), pattern)
        if len(matches) > 0 | break | endif
    endfor
    if len(matches) == 0 | return | endif

    var [_, fname, lnum, col; _] = matches

    # check if it's a regular rg output with filename as a header
    if empty(fname)
        var header = getline(search('^$', 'bnW') + 1)
        fname = header
    endif

    if !filereadable(fname) | return | endif

    # echom matches
    # echom $'{fname}, {lnum}, {col}'

    # Highlight the line
    if !!get(b:, 'match') | silent! matchdelete(b:match) | endif
    b:match = matchaddpos('QuickFixLine', [line('.')])

    var buffers = filter(getbufinfo(), (idx, v) => fnamemodify(fname, ":p") == v.name)
    fname = substitute(fname, '#', '\&', 'g')

    if len(buffers) > 0
        if len(buffers[0].windows) > 0
            win_gotoid(buffers[0].windows[0])
        else
            win_gotoid(CreateWindow())
            execute "buffer" fname
        endif
    else
        var term_cwd = get(b:, 'term_cwd', '')
        win_gotoid(CreateWindow())
        execute "edit" term_cwd .. fname
    endif

    if !empty(lnum)
        execute ":" .. lnum
        execute "normal! 0"
    endif

    if !empty(col) && str2nr(col) > 1
        execute "normal!" (str2nr(col)) .. "|"
    endif
    normal! zz
enddef

def TermToQf()
    var bufnr = GetTermBufnr()
    if bufnr > 0
        cgetexpr getbufline(bufnr, 1, "$")
    endif
enddef

const ErrJumpPattern =
    '\(^\(\)\(\d\+:\)\(\d\+:\)\?\)\|' ..
    '\(^.\{-}:\d\+\(:\d\+:\?\)\?\)\|' ..
    '\(^\s*File ".\{-}", line \d\+,\)\|' ..
    '\(^\s\+in function\s\+.\{-}(.\{-}, line \d\+)\)'
def NextError()
    search(ErrJumpPattern, 'W')
enddef

def PrevError(accept_current: bool = false)
    search(ErrJumpPattern, 'bW' .. (accept_current ? 'c' : ''))
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
    job_stop(term_getjob(GetTermBufnr()), "kill")
enddef

defcom

command! -nargs=1 -bang -complete=shellcmdline Term g:Term(<q-args>, <q-bang>)
command! -nargs=0 -bar TermToggleWin      ToggleWindow()
command! -nargs=0 -bar TermToQf           TermToQf()
command! -nargs=0 -bar TermKill           TermKill()
command! -nargs=0 -bar TermNextErrorJump  TermNextErrorJump()
command! -nargs=0 -bar TermFirstErrorJump TermFirstErrorJump()
command! -nargs=0 -bar TermPrevErrorJump  TermPrevErrorJump()
command! -nargs=0 -bar TermLastErrorJump  TermLastErrorJump()
command! -nargs=0 -bar TermThisErrorJump  TermThisErrorJump()
