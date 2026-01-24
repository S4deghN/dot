vim9script

setl keywordprg=:Pydoc

def g:Pydoc(word: string)
    var bufname = 'pydoc://' .. word
    if bufexists(bufname) && getbufinfo(bufname)[0].linecount > 1
        utils#OpenWinWithBufPattern('^pydoc://')
        exec 'badd' bufname
        exec 'buffer' bufname
        setl nobuflisted
        return
    endif

    var cmd = [&shell, &shellcmdflag, 'python3 -m pydoc ' .. word]

    var bufnr = bufadd(bufname)

    var job = job_start(cmd, {
        env: {COLUMNS: winwidth(0) / (len(utils#Vertical()) > 0 ? 2 : 1)},
        out_io: 'buffer',
        out_buf: bufnr,
        out_modifiable: 0,
        out_msg: 0,
        err_io: 'pipe',
        pty: 0,
        err_cb: (_, msg) => {
            echon msg '. '
        },
        exit_cb: (_, e) => {
            if e == 0
                utils#OpenWinWithBufPattern('^pydoc://')
                exe 'b' bufnr
                set nobuflisted
                set bt=nofile
                set ft=man
                # setl keywordprg=:Pydoc
            else
                exe ':' bufnr 'bwipeout'
            endif
        },
    })
enddef

command! -nargs=* Pydoc g:Pydoc(!<q-args> ? expand('<cexpr>') : <q-args>)
