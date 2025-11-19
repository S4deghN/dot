"AUTHOR: Jan Hahlganß
"SCRIPT: https://github.com/jhlgns/naysayer88.vim

set background=dark

highlight clear
if exists("syntax_on")
    syntax reset
endif

let g:colors_name="naysayer"

" highlight! Normal guifg=#d1b897 guibg=#042327 gui=NONE
highlight! Normal guifg=#d1b897 guibg=#282828 gui=NONE
" highlight! Normal guifg=#d1b897 guibg=#062020 gui=NONE
" highlight! Normal guifg=#d1b897 guibg=#242424 gui=NONE
" highlight! Normal guifg=#d1b897 guibg=#062626 gui=NONE
" highlight! Normal guifg=#d1c8a7 guibg=#062626 gui=NONE

" highlight! Comment guifg=#44b340 guibg=NONE gui=NONE
" highlight! Comment guifg=#55CA43 guibg=NONE gui=NONE
" highlight! Comment guifg=#EAdA2D guibg=NONE gui=NONE
" highlight! Comment guifg=gold guibg=NONE gui=NONE
highlight! Comment guifg=ivory4 guibg=NONE gui=NONE
highlight! NonText guifg=#484848
highlight! link SpecialKey NonText
highlight! link EndOfBuffer NonText

highlight! link Constant Number
" highlight! String guifg=#2ec09c guibg=NONE gui=NONE
" highlight! String guifg=#EDD400 guibg=NONE gui=NONE
" highlight! String guifg=#44b340 guibg=NONE gui=NONE
" highlight! String guifg=#55CA43 guibg=NONE gui=NONE
highlight! link Character Number
highlight! Number guifg=#7ad0c6 guibg=NONE gui=NONE
highlight! link Boolean Number
highlight! link Float Number

highlight! link Identifier Normal
" highlight! link Function Normal
highlight Function guifg=ivory3

highlight! Statement guifg=#ffffff guibg=NONE gui=NONE
highlight! link Conditional Statement
highlight! link Repeat Statement
highlight! link Label Statement
highlight! link Operator Normal
highlight! link Keyword Statement
highlight! link Exception Statement

" highlight! PreProc guifg=#8cde94 guibg=NONE gui=NONE
" highlight! PreProc guifg=#2ec09c guibg=NONE gui=NONE
" highlight! PreProc guifg=#2ec09c guibg=NONE gui=NONE
highlight! PreProc guifg=#5a9f9f guibg=NONE gui=NONE
highlight link Include PreProc
highlight link Define PreProc
highlight link Macro PreProc
highlight link PreCondit PreProc

highlight Type guifg=#8cde94
highlight! link StorageClass Type
highlight! link Structure Type
highlight! link Typedef Type

highlight! link Special Normal
highlight! link SpecialChar String
highlight! link Tag Special
highlight! link Delimiter Special
highlight SpecialComment guifg=#87875f guibg=NONE gui=reverse
highlight! link Debug Special

highlight Underlined guifg=#af5f5f guibg=NONE gui=NONE

highlight Ignore guifg=#af5f5f guibg=NONE gui=NONE

highlight Error guifg=#af5f5f guibg=NONE gui=NONE

highlight! link Todo Comment

highlight link Title Normal
highlight htmlStatement guifg=#878787 guibg=NONE gui=NONE
highlight htmlItalic guifg=#dfaf87 guibg=NONE gui=NONE
highlight htmlArg guifg=#875f5f guibg=NONE gui=NONE
highlight cssIdentifier guifg=#dfaf87 guibg=NONE gui=NONE
highlight cssClassName guifg=#dfaf87 guibg=NONE gui=NONE

" C#
highlight! link csEndColon Normal
highlight! link csLogicSymbols Normal

" Window UI
highlight Cursor                     guifg=#000000       guibg=#dfdfaf      gui=NONE
highlight MoreMsg                    guifg=#dfaf87       guibg=NONE         gui=NONE
highlight Visual                     guifg=NONE          guibg=#434343      gui=NONE
highlight Question                   guifg=#875f5f       guibg=NONE         gui=NONE
highlight Search                     guifg=#dfdfaf       guibg=#878787      gui=NONE
highlight MatchParen                 guifg=skyblue       guibg=#666666      gui=NONE
hi Pmenu guibg=#343434
hi PmenuSel guibg=#444444
hi PmenuThumb guibg=fg
hi PmenuMatch guifg=#ffffff
hi! link  PmenuMatchSel PmenuMatch

" Addons
hi NormalFloat guibg=bg
hi CmpPmenuBorder guifg=#000000
hi SignColumn guibg=bg
hi VertSplit    guifg=#343434 guibg=#343434 cterm=NONE
hi StatusLine   guifg=ivory3 guibg=#343434 cterm=NONE
hi StatusLineNC guifg=ivory4 guibg=#343434 cterm=NONE
hi LineNr guifg=ivory4
hi ErrorMsg guifg=red guibg=bg
hi Folded guifg=#878787 guibg=bg
hi QuickFixLine guibg=#031E21
hi FloatTitle guifg=#2ec09c
hi Title guifg=#2ec09c
hi IncSearch     guibg=#ee799f guifg=black cterm=NONE
hi! link CurSearch IncSearch
hi Search        guibg=#218058 guifg=white gui=NONE

hi DiffAdd       guibg=#123723 guifg=NONE    gui=NONE
hi DiffChange    guibg=#424218 guifg=NONE    gui=NONE
hi DiffDelete    guibg=#4d1f24 guifg=NONE    gui=NONE
" hi DiffText      guibg=NONE    guifg=NONE    gui=reverse

hi! link vimDef function

hi! link StatuslineTerm    StatusLine
hi! link StatuslineTermNC  StatusLineNC
hi cursorline gui=NONE cterm=NONE

hi markdowncodedelimiter guifg=ivory3
hi markdowncode guifg=ivory3
hi! link htmltagname Statement

let g:terminal_ansi_colors = [
            \ "#202020",
            \ "#ff2222",
            \ "#8cde94",
            \ "#FED600",
            \ "#7ad0c6",
            \ "#ee799f",
            \ "#2ec09c",
            \ "#d1b897",
            \ "#484848",
            \ "#fe2222",
            \ "#8cde94",
            \ "#FED600",
            \ "#7ad0c6",
            \ "#ee799f",
            \ "#2ec09c",
            \ "#e1e0d9",
            \ ]


