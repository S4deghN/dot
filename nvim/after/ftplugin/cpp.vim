" setlocal makeprg=make\ -C\ build
setlocal commentstring=//\ %s

hi Delimiter  guifg=fg ctermfg=NONE
hi Identifier guifg=fg ctermfg=NONE
hi Operator   guifg=fg ctermfg=NONE

" Some weired themes use these
hi TSVariable guifg=fg ctermfg=NONE
hi TSProperty guifg=fg ctermfg=NONE

