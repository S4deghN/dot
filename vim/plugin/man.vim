vim9script

def g:Man(word: string)
    var bufname = 'man://' .. word
    if bufexists(bufname) && getbufinfo(bufname)[0].linecount > 1
        utils#OpenWinWithBufPattern('^man://')
        exec 'badd' bufname
        exec 'buffer' bufname
        setl nobuflisted
        return
    endif

    var cmd = [&shell, &shellcmdflag, 'man ' .. escape(word, '()')]

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
            echo msg
        },
        exit_cb: (_, e) => {
            if e == 0
                utils#OpenWinWithBufPattern('^man://')
                exe 'b' bufnr
                set nobuflisted
                set bt=nofile
                set ft=man
                setl keywordprg=:Man
            else
                exe ':' bufnr 'bwipeout'
            endif
        },
    })
enddef

# TODO: Add support for selection
def ManUnderCursor(count: number = v:count)
    if count != 0
        exec 'Man' expand('<cword>') .. '(' .. count .. ')'
    else
        var page = matchstr(expand('<cWORD>'), '\%(\w\|-\)\+\%((\w\+)\)\?')
        exec 'Man ' .. page
    endif
enddef

def ManCmdCompletion(arg_lead: string, cmdline: string, curpos: number): list<string>
    var args = split(cmdline)
    args[0] = 'man'
    return utils#BashComplete(join(args))
enddef

command! -range -nargs=* -complete=customlist,ManCmdCompletion Man g:Man(<q-args>)
command! -nargs=0 -count ManCword ManUnderCursor(<count>)
command! -nargs=0 ManVisual g:Man(utils#GetVisualSelection())
