vim9script

highlight clear
if exists("syntax_on")
    syntax reset
endif

set background=dark
g:colors_name = "lightgruv"

var dark0  = '#2d2c2b'
var dark1  = '#3c3836'
var dark2  = '#504945'
var dark3  = '#665c54'
var dark4  = '#7c6f64'
var medium = '#928374'
var light0 = '#fdf4c1'
var light1 = '#dad1bf'
var light2 = '#d5c4a1'
var light3 = '#c8b9a4'
var light4 = '#928374'
var red    = '#fb4f3a'
var green  = '#b8bb26'
var yellow = '#fabd2f'
var blue   = '#83a598'
var purple = '#d3869b'
var aqua   = '#8ec07c'
var orange = '#fe8019'

g:terminal_ansi_colors = [
    "#202020",
    red,
    green,
    yellow,
    blue,
    purple,
    aqua,
    light3,
    "#6C6866",
    red,
    green,
    yellow,
    blue,
    purple,
    aqua,
    "#e1e0d9",
]

# Vanilla colorscheme ---------------------------------------------------------
# General UI: {{{

# Arguments: group, guifg, guibg, gui, guisp

hlset([
    {name: 'Normal', guifg: light1, guibg: dark0, cterm: {}},
    # Screen line that the cursor is
    {name: 'CursorLine',   guifg: 'NONE', guibg: dark1, cterm: {}},
    # Screen column that the cursor is
    {name: 'CursorColumn', guifg: 'NONE', guibg: dark1, cterm: {}},

    # Tab pages line filler
    {name: 'TabLineFill', guifg: dark4, guibg: 'bg', cterm: {}},
    # Active tab page label
    {name: 'TabLineSel', guifg: 'bg', guibg: dark4, cterm: {bold: 1}},
    # Not active tab page label
    {name: 'TabLine', guifg: dark4, guibg: 'bg', cterm: {}},

    # Match paired bracket under the cursor
    {name: 'MatchParen', guifg: 'NONE', guibg: dark3, cterm: {bold: 1}},

    # Highlighted screen columns
    {name: 'ColorColumn',  guifg: 'NONE', guibg: dark1, cterm: {}},

    # Concealed element: \lambda → λ
    {name: 'Conceal', guifg: blue, guibg: 'NONE', cterm: {}},

    # Line number of CursorLine
    {name: 'CursorLineNr', guifg: yellow, guibg: dark1, cterm: {}},

    {name: 'NonText',    guifg: dark3, cterm: {}},
    {name: 'SpecialKey', guifg: dark3, cterm: {}},

    {name: 'Visual',    guifg: 'NONE',  guibg: dark3, cterm: {}},
    {name: 'VisualNOS', guifg: 'NONE',  guibg: dark3, cterm: {}},

    {name: 'Search',    guifg: dark0, guibg: yellow, cterm: {}},
    {name: 'IncSearch', guifg: dark0, guibg: orange, cterm: {}},

    {name: 'Underlined', guifg: blue, guibg: 'NONE', cterm: {underline: 1}},

    {name: 'StatusLine',   guifg: light1, guibg: dark2, cterm: {}},
    {name: 'StatusLineNC', guifg: light3, guibg: dark2, cterm: {}},

    # The column separating vertically split windows
    {name: 'VertSplit', guifg: dark2, guibg: dark2, cterm: {}},

    # Current match in wildmenu completion
    {name: 'WildMenu', guifg: blue, guibg: dark2, cterm: {bold: 1}},

    # Directory names, special names in listing
    {name: 'Directory', guifg: green, guibg: 'NONE', cterm: {bold: 1}},

    # Titles for output from :set all, :autocmd, etc.
    {name: 'Title', guifg: green, guibg: 'NONE', cterm: {bold: 1}},

    # Error messages on the command line
    {name: 'ErrorMsg',   guifg: red, guibg: 'NONE', cterm: {bold: 1}},
    # More prompt: -- More --
    {name: 'MoreMsg',    guifg: yellow, guibg: 'NONE', cterm: {bold: 1}},
    # Current mode message: -- INSERT --
    {name: 'ModeMsg',    guifg: yellow, guibg: 'NONE', cterm: {bold: 1}},
    # 'Press enter' prompt and yes/no questions
    {name: 'Question',   guifg: orange, guibg: 'NONE', cterm: {bold: 1}},
    # Warning messages
    {name: 'WarningMsg', guifg: red, guibg: 'NONE', cterm: {bold: 1}},

    {name: 'QuickFixLine', guifg: 'NONE', guibg: dark1, cterm: {}},
    # }}},
    # Gutter: {{{

    # Line number for :number and :# commands
    {name: 'LineNr', guifg: dark4, cterm: {}},

    # Column where signs are displayed
    {name: 'SignColumn', guifg: 'NONE', guibg: dark1, cterm: {}},

    # Line used for closed folds
    {name: 'Folded', guifg: medium, guibg: dark1, cterm: {italic: 1}},
    # Column where folds are displayed
    {name: 'FoldColumn', guifg: medium, guibg: dark1, cterm: {}},
    # }}},
    # Cursor: {{{

    # Character under cursor
    {name: 'Cursor', guifg: 'NONE', guibg: 'NONE', cterm: {inverse: 1}},
    # Visual mode cursor, selection
    {name: 'vCursor', guifg: 'NONE', guibg: 'NONE', cterm: {inverse: 1}},
    # Input moder cursor
    {name: 'iCursor', guifg: 'NONE', guibg: 'NONE', cterm: {inverse: 1}},
    # Language mapping cursor
    {name: 'lCursor', guifg: 'NONE', guibg: 'NONE', cterm: {inverse: 1}},

    # }}},
    # Syntax Highlighting: {{{

    {name: 'Special', guifg: orange, cterm: {}},
    {name: 'Comment', guifg: medium, guibg: 'NONE', cterm: {}},
    {name: 'Todo', guifg: 'fg', guibg: 'bg', cterm: {bold: 1}},
    {name: 'Error', guifg: 'bg', guibg: red, cterm: {bold: 1}},

    # Generic statement
    {name: 'Statement',   guifg: red, cterm: {}},
    # if, then, else, endif, swicth, etc.
    {name: 'Conditional', guifg: red, cterm: {}},
    # for, do, while, etc.
    {name: 'Repeat',      guifg: red, cterm: {}},
    # case, default, etc.
    {name: 'Label',       guifg: red, cterm: {}},
    # try, catch, throw
    {name: 'Exception',   guifg: red, cterm: {}},
    # Any other keyword
    {name: 'Keyword',     guifg: red, cterm: {}},

    # Variable name
    {name: 'Identifier', guifg: blue, cterm: {}},
    # Function name
    {name: 'Function',   guifg: green, guibg: 'NONE', cterm: {bold: 1}},

    # Generic preprocessor
    {name: 'PreProc',   guifg: aqua, cterm: {}},
    # Preprocessor #include
    {name: 'Include',   guifg: blue, cterm: {}},
    # Preprocessor #define
    {name: 'Define',    guifg: aqua, cterm: {}},
    # Same as Define
    {name: 'Macro',     guifg: blue, cterm: {}},
    # Preprocessor #if, #else, #endif, etc.
    {name: 'PreCondit', guifg: aqua, cterm: {}},

    # Generic constant
    {name: 'Constant',  guifg: purple, cterm: {}},
    # Character constant: 'c', '/n'
    {name: 'Character', guifg: purple, cterm: {}},
    # String constant: "this is a string"
    {name: 'String',  guifg: green, guibg: 'NONE', cterm: {}},
    # Boolean constant: TRUE, false
    {name: 'Boolean',   guifg: purple, cterm: {}},
    # Number constant: 234, 0xff
    {name: 'Number',    guifg: purple, cterm: {}},
    # Floating point constant: 2.3e10
    {name: 'Float',     guifg: purple, cterm: {}},

    # Generic type
    {name: 'Type', guifg: yellow, cterm: {}},
    # static, register, volatile, etc
    {name: 'StorageClass', guifg: orange, cterm: {}},
    # struct, union, enum, etc.
    {name: 'Structure', guifg: aqua, cterm: {}},
    # typedef
    {name: 'Typedef', guifg: yellow, cterm: {}},

    # }}},
    # Completion Menu: {{{

    # Popup menu: normal item
    {name: 'Pmenu', guifg: light1, guibg: dark2, cterm: {}},
    # Popup menu: selected item
    {name: 'PmenuSel', guifg: dark2, guibg: blue, cterm: {bold: 1}},
    # Popup menu: scrollbar
    {name: 'PmenuSbar', guifg: 'NONE', guibg: dark2, cterm: {}},
    # Popup menu: scrollbar thumb
    {name: 'PmenuThumb', guifg: 'NONE', guibg: dark4, cterm: {}},

    # }}},
    # Diffs: {{{

    {name: 'DiffDelete', guifg: '#504945', guibg: 'NONE', cterm: {}},
    {name: 'DiffAdd',    guifg: 'NONE', guibg: '#283f2f', cterm: {}},

    # Alternative setting
    {name: 'DiffChange', guifg: 'NONE', guibg: '#1F385B', cterm: {}},
    {name: 'DiffText',   guifg: 'NONE', guibg: '#172A45', cterm: {}},

    {name: 'diffAdded',   guifg: green,  cterm: {}},
    {name: 'diffRemoved', guifg: red,    cterm: {}},
    {name: 'diffChanged', guifg: aqua,   cterm: {}},
    {name: 'diffFile',    guifg: orange, cterm: {}},
    {name: 'diffNewFile', guifg: yellow, cterm: {}},
    {name: 'diffLine',    guifg: blue,   cterm: {}},


    # }}},
    # Spelling And Diag: {{{

    # Not capitalised word
    {name: 'SpellCap',   guifg: 'NONE', guibg: 'NONE', cterm: {undercurl: 1}},
    # Not recognized word
    {name: 'SpellBad',   guifg: 'NONE', guibg: 'NONE', cterm: {undercurl: 1}},
    # Wrong spelling for selected region
    {name: 'SpellLocal', guifg: 'NONE', guibg: 'NONE', cterm: {undercurl: 1}},
    # Rare word
    {name: 'SpellRare',  guifg: 'NONE', guibg: 'NONE', cterm: {undercurl: 1}},
    {name: 'DiagnosticError', guifg: red, cterm: {}},
    {name: 'DiagnosticWarn', guifg: yellow, cterm: {}},
    {name: 'DiagnosticInfo', guifg: 'fg', cterm: {}},
    {name: 'DiagnosticHint', guifg: blue, cterm: {}},
    {name: 'DiagnosticOk', guifg: green, cterm: {}},
])
# }}}

# Highlighting in git (diff) files
hi! link gitDiff comment
hi! link diffBDiffer comment
hi! link diffIndexLine comment
hi! link diffFile comment
hi! link diffOldFile Type
hi! link diffNewFile Type
#hi! link diffline function
hi! link diffSubname Normal

# sizeof, "+", "*", etc.
hi Delimiter guifg=fg
hi Operator guifg=fg
hi Signcolumn guibg=bg

hi GitGutterAdd guibg=bg
hi GitGutterChange guibg=bg
hi GitGutterDelete guibg=bg
hi GitGutterChangeDelete guibg=bg

hi NonText guifg=#888899
hi SpecialKey guifg=#888899

hi! link WinSeparator VertSplit

hi! link CurSearch Incsearch
