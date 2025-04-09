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
    nnoremap <buffer> <leader>e :Dict<space>

    if len(oldbuf) > 0
        exe "bd!" oldbuf[0].bufnr
    endif
enddef

# def g:Man(word: string, whole_window: bool = 0)
#     var win_to_use = getwininfo()
#         ->filter((_, v) => bufname(v.bufnr) =~ '^man://')

#     if !whole_window
#         if len(win_to_use) > 0
#             win_gotoid(win_to_use[0].winid)
#         else
#             exec 'botright' utils#Vertical() 'split'
#         endif
#     endif

#     var bufname = 'man://' .. word

#     if bufexists(bufname) && getbufinfo(bufname)[0].linecount > 1
#         exec 'badd' bufname
#         exec 'buffer' bufname
#         setl nobuflisted
#         return
#     endif

#     var cmd = [&shell, &shellcmdflag, "man " .. word .. "|tee"]

#     # exec 'e man://' .. word
#     var bufnr = bufadd('man://' .. word)

#     # setline(1, "  ")
#     # cursor(1, 2)
#     var job = job_start(cmd, {
#         env: {COLUMNS: winwidth(0)},
#         out_io: 'buffer',
#         out_buf: bufnr,
#         out_msg: 0,
#         err_io: 'buffer',
#         err_buf: bufnr,
#         err_msg: 0,
#         pty: 1,
#         exit_cb: (_, _) => {
#             set nobuflisted
#             set bt=nofile
#             set ft=man
#         # cursor(1, 1)
#         # deletebufline(bufnr, 1)
#         },
#     })
#     exe 'b' bufnr
# enddef

command! -nargs=? -bang Dict call Dict(<q-args>, <bang>0)
