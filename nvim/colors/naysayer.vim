"AUTHOR: Jan Hahlganß
"SCRIPT: https://github.com/jhlgns/naysayer88.vim

set background=dark

highlight clear
if exists("syntax_on")
	syntax reset
endif

let g:colors_name="naysayer88"

highlight! Default guifg=#d1b897 guibg=#042327 gui=NONE
highlight! Normal guifg=#d1b897 guibg=#042327 gui=NONE

highlight! Comment guifg=#44b340 guibg=NONE gui=NONE

highlight! link Constant Statement
highlight! String guifg=#2ec09c guibg=NONE gui=NONE
highlight! link Character Number
highlight! Number guifg=#7ad0c6 guibg=NONE gui=NONE
highlight! link Boolean Number
highlight! link Float Number

highlight! link Identifier Default
highlight! link Function Default

highlight! Statement guifg=#eeeeee guibg=NONE gui=NONE
highlight! link Conditional Statement
highlight! link Repeat Statement
highlight! link Label Statement
highlight! link Operator Default
highlight! link Keyword Statement
highlight! link Exception Statement

highlight! PreProc guifg=#8cde94 guibg=NONE gui=NONE
highlight link Include PreProc
highlight link Define PreProc
highlight link Macro PreProc
highlight link PreCondit PreProc

highlight! link Type PreProc
highlight! link StorageClass Type
highlight! link Structure Type
highlight! link Typedef Type

highlight! link Special Default
highlight! link SpecialChar String
highlight! link Tag Special
highlight! link Delimiter Special
highlight SpecialComment guifg=#87875f guibg=NONE gui=reverse
highlight! link Debug Special

highlight Underlined guifg=#af5f5f guibg=NONE gui=NONE

highlight Ignore guifg=#af5f5f guibg=NONE gui=NONE

highlight Error guifg=#af5f5f guibg=NONE gui=NONE

highlight! link Todo Comment

highlight link Title Default
highlight htmlStatement guifg=#878787 guibg=NONE gui=NONE
highlight htmlItalic guifg=#dfaf87 guibg=NONE gui=NONE
highlight htmlArg guifg=#875f5f guibg=NONE gui=NONE
highlight cssIdentifier guifg=#dfaf87 guibg=NONE gui=NONE
highlight cssClassName guifg=#dfaf87 guibg=NONE gui=NONE

" C#
highlight! link csEndColon Default
highlight! link csLogicSymbols Default

" Window UI
highlight Cursor                     guifg=#000000       guibg=#dfdfaf      gui=NONE
highlight MoreMsg                    guifg=#dfaf87       guibg=NONE         gui=NONE
highlight Visual                     guifg=NONE          guibg=#08454D      gui=NONE
highlight Question                   guifg=#875f5f       guibg=NONE         gui=NONE
highlight Search                     guifg=#dfdfaf       guibg=#878787      gui=NONE
highlight PmenuSel                   guifg=#dfdfaf       guibg=#875f5f      gui=NONE
highlight MatchParen                 guifg=#dfdfaf       guibg=#875f5f      gui=NONE
highlight VertSplit                  guifg=#000000       guibg=NONE         gui=NONE
highlight! EndOfBuffer               guifg=#042327       guibg=#042327      gui=NONE

