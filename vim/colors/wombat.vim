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
  hi! link Signcolumn LineNr
  hi! link FoldColumn LineNr
endif

" General colors
hi Cursor       guifg=NONE    guibg=#656565 cterm=none
hi Normal       guifg=#f6f3e8 guibg=#242424 cterm=none
hi LineNr       guifg=#857b6f cterm=none
hi StatusLine   guifg=#f6f3e8 guibg=#444444 cterm=none
hi StatusLineNC guifg=#857b6f guibg=#444444 cterm=none
hi VertSplit    guifg=#444444 guibg=#444444 cterm=none
hi Folded       guifg=#b0a8a0 guibg=#383838 cterm=none
hi Visual       guifg=NONE    guibg=#444444 cterm=none
hi NonText      guifg=#505050 cterm=none
hi SpecialKey   guifg=#505050 cterm=none
hi Title        guifg=#8ac6f2 cterm=bold

" Syntax highlighting
hi Comment      guifg=#99968b cterm=none
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

" Diff
hi DiffAdd    guifg=NONE    guibg=#1D2B21 cterm=NONE
hi DiffDelete guifg=#484E52 guibg=NONE    cterm=NONE
hi DiffChange guifg=NONE    guibg=#1F385B cterm=NONE
hi DiffText   guifg=NONE    guibg=#172A45 cterm=NONE

" markdown
hi! link markdowncodeblock comment
hi! link markdowncode identifier

let g:terminal_ansi_colors = [
      \'black',
      \'red',
      \'green',
      \'yellow',
      \'#4499ff',
      \'magenta',
      \'cyan',
      \'white',
      \'#555555',
      \'red',
      \'green',
      \'yellow',
      \'#4499ff',
      \'magenta',
      \'cyan',
      \'white',
      \]
