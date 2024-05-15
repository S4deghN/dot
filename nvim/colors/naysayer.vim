"AUTHOR: Jan Hahlganß
"SCRIPT: https://github.com/jhlgns/naysayer88.vim

set background=dark

highlight clear
if exists("syntax_on")
	syntax reset
endif

let g:colors_name="naysayer88"

" highlight! Normal guifg=#d1b897 guibg=#042327 gui=NONE
highlight! Normal guifg=#d1b897 guibg=#062329 gui=NONE

highlight! Comment guifg=#44b340 guibg=NONE gui=NONE

highlight! String guifg=#2ec09c guibg=NONE gui=NONE
highlight! link Character Number
highlight! Number guifg=#7ad0c6 guibg=NONE gui=NONE
highlight! link Boolean Number
highlight! link Float Number
highlight! link Constant Number

highlight! link Identifier Normal
" highlight! link Function Statement
highlight Function guifg=#cceeee

highlight! Statement guifg=#eeeeee guibg=NONE gui=NONE
highlight! link Conditional Statement
highlight! link Repeat Statement
highlight! link Label Statement
highlight! link Operator Normal
highlight! link Keyword Statement
highlight! link Exception Statement

" highlight! PreProc guifg=#8cde94 guibg=NONE gui=NONE
highlight! PreProc guifg=#458588 guibg=NONE gui=NONE
highlight link Include PreProc
highlight link Define PreProc
highlight link Macro PreProc
highlight link PreCondit PreProc

highlight! Type  guifg=#8cde94 guibg=NONE gui=NONE
highlight! link StorageClass Type
highlight! link Structure Type
highlight! link Typedef Type

highlight! link Special Statement
" highlight! link SpecialChar String
hi! link Special Number
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
highlight Cursor                     guifg=#000000       guibg=#8EC07C      gui=NONE
highlight MoreMsg                    guifg=#dfaf87       guibg=NONE         gui=NONE
highlight Visual                     guifg=NONE          guibg=#08454D      gui=NONE
highlight Question                   guifg=#875f5f       guibg=NONE         gui=NONE
highlight Search                     guifg=#dfdfaf       guibg=#878787      gui=NONE
highlight PmenuSel                   guifg=#dfdfaf       guibg=#875f5f      gui=NONE
highlight MatchParen                 guifg=#dfdfaf       guibg=#875f5f      gui=NONE
highlight VertSplit                  guifg=#000000       guibg=NONE         gui=NONE
highlight! EndOfBuffer               guifg=#042327       guibg=#042327      gui=NONE

" Addons
" hi NormalFloat guibg=bg
hi CmpPmenuBorder guifg=#000000
hi SignColumn guibg=bg
hi StatusLine gui=NONE guibg=#08454D
hi LineNr guifg=#18555D
hi ErrorMsg guifg=red guibg=bg
hi Folded guifg=#878787 guibg=bg
hi QuickFixLine guibg=#031E21
hi Pmenu guibg=#031C20
hi! link Pmenu Visual
" hi! link PmenuSel Pmenu
hi PmenuThumb guibg=fg
hi IncSearch     guibg=#ee799f guifg=#cfcfc2 gui=NONE
hi Search        guibg=#218058 guifg=#cfcfc2 gui=NONE

hi DiffAdd       guibg=#123723 guifg=NONE    gui=NONE
hi DiffChange    guibg=#424218 guifg=NONE    gui=NONE
hi DiffDelete    guibg=#4d1f24 guifg=NONE    gui=NONE
" hi DiffText      guibg=NONE    guifg=NONE    gui=reverse

hi GitSignsAdd      guibg=NONE guifg=#426753
hi GitSignsChange   guibg=NONE guifg=#727248
hi GitSignsDelete   guibg=NONE guifg=#7d4f54

hi  Ignore          guibg=#1c2020 guifg=NONE   cterm=NONE
hi! link @lsp.type.comment Ignore
hi! link Directory Statement
hi! link CursorLine Visual

hi! link @lsp.type.namespace @lsp.type.enumMember

hi  Title guifg=#2ec09c
hi! link  FloatTitle        Title
hi! link  htmlH1            Title
hi! link  htmlH2            Title
hi! link  htmlH3            Title
hi! link  htmlH4            Title
hi! link  htmlH5            Title
hi! link  htmlH6            Title
hi! link  helpHyperTextJump Title

hi NonText guifg=gray

let g:fzf_colors =
  \ { 'fg':      ['fg', 'NormalFloat'],
  \   'bg':      ['bg', 'NormalFloat'],
  \   'hl':      ['fg', 'Search'],
  \   'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
  \   'bg+':     ['bg', 'Visual'],
  \   'hl+':     ['bg', 'IncSearch'],
  \   'info':    ['fg', 'PreProc'],
  \   'border':  ['fg', 'Normal'],
  \   'prompt':  ['fg', 'Constatn'],
  \   'pointer': ['fg', 'Exception'],
  \   'marker':  ['fg', 'Keyword'],
  \   'spinner': ['fg', 'Label'],
  \   'header':  ['fg', 'Comment'] }
