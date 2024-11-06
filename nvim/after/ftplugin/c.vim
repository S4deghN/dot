let g:c_gnu = 1
let g:c_functions = 1
let g:c_function_pointers = 1
let g:c_no_curly_error = 1
let g:c_curly_error = 1

" setlocal makeprg=make\ -C\ build
setlocal commentstring=//\ %s

"hi Delimiter guifg=fg guibg=NONE
hi! link Identifier Normal
" hi Operator   guifg=fg ctermfg=NONE

" Some weired themes use these
hi! link TSVariable Normal
hi! link TSProperty Normal
