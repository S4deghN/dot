vim9script

setl keywordprg=:Godoc
hi! link goBuiltins Keyword

def g:Godoc(args: string)
    var arg_list = split(args)
    var word = arg_list[-1]

    if len(arg_list) == 1 && match(word, '\.') == -1 && line('.') != 1 && bufname() =~ '^godoc://'
        var package = matchstr(getline(1), '^package\s\+\zs\f\+')
        if len(package) > 0
            word = package .. '.' .. word
            arg_list[-1] = word
        endif
    endif

    var bufname = 'godoc://' .. join(arg_list)
    if bufexists(bufname) && getbufinfo(bufname)[0].linecount > 1
        utils#OpenWinWithBufPattern('^godoc://')
        exec 'badd' bufname
        exec 'buffer' bufname
        setl nobuflisted
        return
    endif

    var cmd = [&shell, &shellcmdflag, 'go doc ' .. join(arg_list)]

    # echom "cmd is: " cmd

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
                utils#OpenWinWithBufPattern('^godoc://')
                exe 'b' bufnr
                set nobuflisted
                set bt=nofile
                set ft=go
                # setl keywordprg=:Godoc
            else
                exe ':' bufnr 'bwipeout'
            endif
        },
    })
enddef

command! -nargs=* Godoc g:Godoc(!<q-args> ? expand('<cexpr>') : <q-args>)
