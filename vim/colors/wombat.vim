" Maintainer:   Lars H. Nielsen (dengmao@gmail.com)
" Last Change:  January 22 2007
" Added to github for usage as submodule

set background=dark

hi clear

if exists("syntax_on")
  syntax reset
endif

let colors_name = "wombat"


" Vim >= 7.0 specific colors
if version >= 700
  hi CursorLine   guibg=#2d2d2d cterm=none
  hi CursorColumn guibg=#2d2d2d
  hi MatchParen   guifg=#f6f3e8 guibg=#857b6f cterm=bold
  hi Pmenu        guifg=#f6f3e8 guibg=#444444
  hi PmenuSel     guifg=#000000 guibg=#cae682
endif

" General colors
hi Cursor       guifg=NONE    guibg=#656565 cterm=none
hi Normal       guifg=#f6f3e8 guibg=#242424 cterm=none
hi LineNr       guifg=#857b6f cterm=none
hi StatusLine   guifg=#f6f3e8 guibg=#444444 cterm=none
hi StatusLineNC guifg=#857b6f guibg=#444444 cterm=none
hi VertSplit    guifg=#444444 guibg=#444444 cterm=none
hi Folded       guifg=#a0a8b0 guibg=#384048 cterm=none
hi Title        guifg=#f6f3e8 guibg=NONE    cterm=bold
hi Visual       guifg=NONE    guibg=#444444 cterm=none
hi NonText      guifg=#808080 cterm=none
hi SpecialKey   guifg=#808080 cterm=none

" Syntax highlighting
hi Comment      guifg=#99968b cterm=none
hi Todo         guifg=#8f8f8f cterm=none
hi Constant     guifg=#e5786d cterm=none
hi String       guifg=#95e454 cterm=none
hi Identifier   guifg=#cae682 cterm=none
hi Function     guifg=#cae682 cterm=none
hi Type         guifg=#A1B967 cterm=none
hi Statement    guifg=#8ac6f2 cterm=none
hi Keyword      guifg=#8ac6f2 cterm=none
hi PreProc      guifg=#e5786d cterm=none
hi Number       guifg=#e5786d cterm=none
hi Special      guifg=#d7e6ca cterm=none
