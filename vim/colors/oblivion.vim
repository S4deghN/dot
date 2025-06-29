" Vim color file
" oblivion
" Created by s4 with ThemeCreator (https://github.com/mswift42/themecreator)

hi clear

if exists("syntax on")
syntax reset
endif

set t_Co=256
let g:colors_name = "oblivion"


" Define reusable colorvariables.
" let s:bg="#2E3436"
let s:bg="#202428"
let s:fg="#D3D7CF"
let s:fg2="#c2c6be"
let s:fg3="#b1b5ae"
let s:fg4="#a0a39d"
let s:bg2="#3f4446"
let s:bg3="#4f5456"
let s:bg4="#606566"
let s:keyword="#FFFFFF"
let s:builtin="#AD7FA8"
let s:const0="#CE5C00"
let s:const="#dE6C00"
" let s:const="#ff8800"
let s:comment="#888A85"
let s:func="#D3D7CF"
let s:str="#EDD400"
let s:type="#8AE234"
let s:var="#D3D7CF"
let s:warning="#ff0000"
let s:warning2="#ff8800"

exe 'hi Normal guifg='s:fg' guibg='s:bg
exe 'hi Cursor guifg='s:bg' guibg='s:fg
exe 'hi CursorLine  guibg='s:bg2
exe 'hi CursorLineNr guifg='s:str' guibg='s:bg
exe 'hi CursorColumn  guibg='s:bg2
exe 'hi ColorColumn  guibg='s:bg2
exe 'hi FoldColumn guifg='s:comment' guibg='s:bg2
exe 'hi SignColumn guifg='s:comment' guibg='s:bg2
exe 'hi LineNr guifg='s:fg2' guibg='s:bg2
exe 'hi CursorLineNr guifg='s:fg' guibg='s:bg2
exe 'hi MatchParen guifg='s:warning2' guibg='s:comment ' cterm=bold'
exe 'hi StatusLine guifg='s:fg2' guibg='s:bg3
exe 'hi Pmenu guifg='s:fg' guibg='s:bg2
exe 'hi PmenuSel  guibg='s:bg3
exe 'hi Directory guifg='s:const
exe 'hi Folded guifg='s:fg4' guibg='s:bg
exe 'hi WildMenu guifg='s:str' guibg='s:bg

exe 'hi Boolean guifg='s:const
exe 'hi Character guifg='s:const
exe 'hi Comment guifg='s:comment
exe 'hi Conditional guifg='s:keyword' gui=bold'
exe 'hi Constant guifg='s:const
exe 'hi Todo guibg='s:bg
exe 'hi Define guifg='s:keyword
exe 'hi DiffAdd guifg=#fafafa guibg=#123d0f gui=bold'
exe 'hi DiffDelete guibg='s:bg2
exe 'hi DiffChange  guibg=#151b3c guifg=#fafafa'
exe 'hi DiffText guifg=#ffffff guibg=#ff0000 gui=bold'
exe 'hi ErrorMsg guifg='s:warning' guibg='s:bg2' gui=bold'
exe 'hi WarningMsg guifg='s:fg' guibg='s:warning2
exe 'hi Float guifg='s:const
exe 'hi Function guifg='s:func
exe 'hi Identifier guifg='s:fg
exe 'hi Keyword guifg='s:keyword'  gui=bold'
exe 'hi Label guifg='s:keyword' gui=NONE'
exe 'hi NonText guifg='s:bg4' guibg='s:bg2
exe 'hi Number guifg='s:const
exe 'hi Operator guifg='s:keyword
exe 'hi PreProc guifg='s:builtin
exe 'hi Special guifg='s:const
exe 'hi SpecialKey guifg='s:fg4' guibg=bg'
exe 'hi Statement guifg='s:keyword
exe 'hi StorageClass guifg='s:keyword
exe 'hi String guifg='s:str
exe 'hi Tag guifg='s:keyword
exe 'hi Title guifg=#ffffff  gui=NONE'
exe 'hi Todo guifg='s:fg2'  gui=inverse,bold'
exe 'hi Type guifg='s:type
exe 'hi Underlined   gui=underline'

let g:terminal_ansi_colors = [
        \s:bg,
        \s:warning,
        \s:keyword,
        \s:bg4,
        \s:func,
        \s:builtin,
        \s:fg3,
        \s:str,
        \s:bg2,
        \s:warning2,
        \s:fg2,
        \s:var,
        \s:type,
        \s:const,
        \s:fg4,
        \s:comment,
        \]

" Ruby Highlighting
exe 'hi rubyAttribute guifg='s:builtin
exe 'hi rubyLocalVariableOrMethod guifg='s:var
exe 'hi rubyGlobalVariable guifg='s:var' gui=italic'
exe 'hi rubyInstanceVariable guifg='s:var
exe 'hi rubyKeyword guifg='s:keyword
exe 'hi rubyKeywordAsMethod guifg='s:keyword' gui=bold'
exe 'hi rubyClassDeclaration guifg='s:keyword' gui=bold'
exe 'hi rubyClass guifg='s:keyword' gui=bold'
exe 'hi rubyNumber guifg='s:const

" Python Highlighting
exe 'hi pythonBuiltinFunc guifg='s:builtin

" Go Highlighting
exe 'hi goBuiltins guifg='s:builtin
let g:go_highlight_array_whitespace_error = 1
let g:go_highlight_build_constraints      = 1
let g:go_highlight_chan_whitespace_error  = 1
let g:go_highlight_extra_types            = 1
let g:go_highlight_fields                 = 1
let g:go_highlight_format_strings         = 1
let g:go_highlight_function_calls         = 1
let g:go_highlight_function_parameters    = 1
let g:go_highlight_functions              = 1
let g:go_highlight_generate_tags          = 1
let g:go_highlight_operators              = 1
let g:go_highlight_space_tab_error        = 1
let g:go_highlight_string_spellcheck      = 1
let g:go_highlight_types                  = 1
let g:go_highlight_variable_assignments   = 1
let g:go_highlight_variable_declarations  = 1

" Javascript Highlighting
exe 'hi jsBuiltins guifg='s:builtin
exe 'hi jsFunction guifg='s:keyword' gui=bold'
exe 'hi jsGlobalObjects guifg='s:type
exe 'hi jsAssignmentExps guifg='s:var

" Html Highlighting
exe 'hi htmlLink guifg='s:var' gui=underline'
exe 'hi htmlStatement guifg='s:keyword
exe 'hi htmlSpecialTagName guifg='s:keyword

" Markdown Highlighting
exe 'hi mkdCode guifg='s:builtin

hi NormalFloat guibg=#282e30
hi PmenuSel gui=NONE guifg=NONE guibg=#3f4446

hi Character guifg=#edd400
hi Number    guifg=#edd400
hi Boolean   guifg=#edd400
hi Float     guifg=#edd400

hi Search cterm=NONE gui=NONE guibg=#EDD400 guifg=black
hi IncSearch cterm=NONE gui=NONE guibg=#ff8800 guifg=black
hi! link CurSearch IncSearch

hi Function guifg=#789AC0
hi Function guifg=#88aAd0
hi SignColumn guibg=bg
hi Statement   gui=NONE
hi Conditional gui=NONE
hi Keyword     gui=NONE
hi Type        gui=NONE

hi! link Structure Statement

hi WarningMsg gui=inverse guifg=bg
hi NonText guibg=bg
hi EndOfBuffer guibg=bg

hi  DiffAdd    guifg=NONE guibg=#2D3B31 gui=NONE
hi  DiffChange guifg=NONE guibg=#1F385B gui=NONE
hi  DiffText   guifg=NONE guibg=#172A45 gui=NONE
hi  DiffDelete guifg=NONE guibg=NONE gui=NONE

hi  GitSignsAdd       guifg=#8F9D6A     guibg=NONE    gui=NONE cterm=NONE
hi  GitSignsDelete    guifg=#af5f5f     guibg=NONE    gui=NONE cterm=NONE
hi  GitSignsChange    guifg=#88aAd0     guibg=NONE    gui=NONE cterm=NONE

hi  DiagnosticError guifg=#FE7F78
hi  DiagnosticWarn  guifg=#FBDF63
"hi  DiagnosticInfo  guifg=#88aAd0
"hi  DiagnosticHint  guifg=#888A85

hi Statusline cterm=NONE gui=NONE
hi StatusLineNC cterm=NONE gui=NONE guifg=#b2b6ae guibg=#4f5456
hi VertSplit guifg=#a0a39d guibg=bg gui=NONE cterm=NONE
hi! link WinSeparator VertSplit
