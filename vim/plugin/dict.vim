vim9script

def g:Dict(word: string, whole_window: bool = 0)
    var oldbuf = getbufinfo()->filter((_, v) => fnamemodify(v.name, ":t") == '[dict]')

    if !whole_window
        if len(oldbuf) > 0 && len(oldbuf[0].windows) > 0
            win_gotoid(oldbuf[0].windows[0])
        else
            exec 'botright' utils#Vertical() 'split'
        endif
    endif

    var cmd = ["sdcv", "-c", "-n", word]
    var newbuf = 0
    newbuf = term_start(cmd, {
        curwin: 1,
        term_name: '[dict]',
        exit_cb: (job, ec) => {
            timer_start(10, (timer) => cursor(1, 0))
        },
    })

    setl stl-=%f
    setl stl^=[dict]
    setl nospell
    nnoremap <buffer> <leader>e :Dict<space>

    if len(oldbuf) > 0
        exe "bd!" oldbuf[0].bufnr
    endif
enddef

command! -nargs=? -bang Dict call Dict(<q-args>, <bang>0)
