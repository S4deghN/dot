" setlocal makeprg=make\ -C\ build
setlocal commentstring=//\ %s
setlocal matchpairs+=<:>

hi! link Delimiter  Normal
hi! link Identifier Normal

func! s:guard_name()
    return substitute(toupper(expand('%:p:.')), '\.\|\/\|\\', '_', 'g')
endfunc

func! s:insert_guards()
    let name =s:guard_name()
    let list =<< eval trim EOF
    #ifndef {name}
    #define {name}

    #endif
    EOF
    return join(list, "\n")
endfunc

imap <buffer> <expr> <C-x>gn <SID>guard_name()
imap <buffer> <expr> <C-x>gg <SID>insert_guards()

augroup CFile
    au!
    au BufWritePre *.h if line('$') == 1 && empty(getline(1))
                \| exec "norm i\<C-x>gg\<esc>{"
                \| endif
augroup END
