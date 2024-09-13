" setlocal makeprg=make\ -C\ build
setlocal commentstring=//\ %s
set comments+=s1:/*,m:\ ,ex:*/

hi! link Delimiter  Normal
hi! link Identifier Normal
" hi Operator   guifg=fg ctermfg=NONE

" Some weired themes use these
hi! link TSVariable Normal
hi! link TSProperty Normal
