" Name:       imgui.vim
" Version:    0.1.0
" Maintainer: github.com/S4deghN
" License:    The MIT License (MIT)

hi clear

if exists('syntax on')
    syntax reset
endif
set bg=dark

let g:colors_name='imgui'

hi Normal guibg=#101010 guifg=#aaaaaa

hi Statement guifg=#569CD6 gui=none
hi! link Type Statement
hi Number guifg=#00ff00 gui=none
hi String guifg=#E07070 gui=none
hi Special guifg=#d69c56 gui=none
hi Delimiter guifg=#ffffff gui=none
hi PreProc guifg=#408080 gui=none
"hi Macro guifg=#c040a0 " Preproc identifier
hi Identifier guifg=#aaaaaa gui=none
hi Comment guifg=#206020 " Comment (single line)
"hi Comment guifg=#406020 " Comment (multi line)

hi Identifier guifg=fg
hi Function guifg=fg
hi @variable guifg=fg
hi Constant guifg=fg
hi vimgroup guifg=fg

hi! link @lsp.type.macro Macro

hi Statusline guibg=#282828 guifg=#aaaaaa
hi StatuslineNc guibg=#1a1a1a guifg=#888888

"hi Function guifg=#4DC69B

"hi guifg=#9bc64d,// Known identifier
"hi guifg=#e0e0e0,// Cursor

"0x80a06020, // Selection
"0x800020ff, // ErrorMarker
"0x40f08000, // Breakpoint
"0xff707000, // Line number
"0x40000000, // Current line fill
"0x40808080, // Current line fill (inactive)
"0x40a0a0a0, // Current line edge

"#7f7f7f,	// Default
"#d69c56,	// Keyword	
"#00ff00,	// Number
"#7070e0,	// String
"#70a0e0, // Char literal
"#ffffff, // Punctuation
"#408080,	// Preprocessor
"#aaaaaa, // Identifier
"#9bc64d, // Known identifier
"#c040a0, // Preproc identifier
"#206020, // Comment (single line)
"#406020, // Comment (multi line)
"#101010, // Background
"#e0e0e0, // Cursor
"#a06020, // Selection
"#0020ff, // ErrorMarker
"#f08000, // Breakpoint
"#707000, // Line number
"#000000, // Current line fill
"#808080, // Current line fill (inactive)
"#a0a0a0, // Current line edge

