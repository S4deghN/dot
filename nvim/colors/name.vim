" Name:       name.vim
" Version:    0.1.0
" Maintainer: github.com/S4deghN
" License:    The MIT License (MIT)

hi clear

if exists('syntax on')
    syntax reset
endif
set bg=dark

let g:colors_name='name'

hi Normal     guibg=gray20 guifg=gray85
hi Type       guifg=lightgoldenrod4
hi Statement  gui=NONE guifg=fg
hi function   guifg=fg
hi Identifier guifg=fg
hi @variable  guifg=fg
