vim9script

highlight clear
if exists("syntax_on")
    syntax reset
endif

set background=dark
g:colors_name = "lightgruv"

# var dark0  = '#2d2c2b'
# var dark0  = '#202020'
var dark0  = '#242424'
# var dark0  = '#202020'
var dark1  = '#3c3836'
# var dark2  = '#504945'
var dark2  = '#504945'
var dark3  = '#665c54'
var dark4  = '#7c6f64'
var medium = '#928374'
var light0 = '#fdf4c1'
# var light1 = '#dad1bf'
var light1 = '#dcd3c1'
var light2 = '#d5c4a1'
var light3 = '#c8b9a4'
var light4 = '#928374'
var red    = '#fb4f3a'
# var green  = '#b8bb26'
var green  = '#b0bb26'
var yellow = '#fabd2f'
var blue   = '#83a598'
var purple = '#d3869b'
var aqua   = '#8ec07c'
var orange = '#fe8019'

var pmenu = dark1
var pmenuSel = dark2

var non_text = '#888888'

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
    {name: 'Normal', guifg: light1, guibg: dark0, cterm: {}, gui: {}},
    # Screen line that the cursor is
    # {name: 'CursorLine',   guifg: 'NONE', guibg: dark1, cterm: {}, gui: {}},
    {name: 'CursorLine',   guifg: 'NONE', guibg: '#2b2b2b', cterm: {}, gui: {}},
    # Screen column that the cursor is
    {name: 'CursorColumn', guifg: 'NONE', guibg: dark1, cterm: {}, gui: {}},

    # Tab pages line filler
    {name: 'TabLineFill', guifg: dark4, guibg: 'bg', cterm: {}, gui: {}},
    # Active tab page label
    {name: 'TabLineSel', guifg: 'bg', guibg: dark4, cterm: {bold: 1}, gui: {bold: 1}},
    # Not active tab page label
    {name: 'TabLine', guifg: dark4, guibg: 'bg', cterm: {}, gui: {}},

    # Match paired bracket under the cursor
    {name: 'MatchParen', guifg: 'NONE', guibg: dark3, cterm: {bold: 1}, gui: {bold: 1}},

    # Highlighted screen columns
    {name: 'ColorColumn',  guifg: 'NONE', guibg: dark1, cterm: {}, gui: {}},

    # Concealed element: \lambda → λ
    {name: 'Conceal', guifg: blue, guibg: 'NONE', cterm: {}, gui: {}},

    # Line number of CursorLine
    {name: 'CursorLineNr', guifg: yellow, guibg: 'bg', cterm: {}, gui: {}},

    {name: 'NonText',    guifg: dark3, cterm: {}, gui: {}},
    {name: 'SpecialKey', guifg: dark3, cterm: {}, gui: {}},

    {name: 'Visual',    guifg: 'NONE',  guibg: dark3, cterm: {}, gui: {}},
    {name: 'VisualNOS', guifg: 'NONE',  guibg: dark3, cterm: {}, gui: {}},

    {name: 'Search',    guifg: dark0, guibg: yellow, cterm: {}, gui: {}},
    {name: 'IncSearch', guifg: dark0, guibg: orange, cterm: {}, gui: {}},

    {name: 'Underlined', guifg: blue, guibg: 'NONE', cterm: {underline: 1}, gui: {underline: 1}},

    {name: 'StatusLine',   guifg: light1, guibg: dark2, cterm: {}, gui: {}},
    {name: 'StatusLineNC', guifg: light3, guibg: dark2, cterm: {}, gui: {}},

    # The column separating vertically split windows
    {name: 'VertSplit', guifg: dark2, guibg: dark2, cterm: {}, gui: {}},

    # Current match in wildmenu completion
    {name: 'WildMenu', guifg: blue, guibg: dark2, cterm: {bold: 1}, gui: {bold: 1}},

    # Directory names, special names in listing
    {name: 'Directory', guifg: green, guibg: 'NONE', cterm: {bold: 1}, gui: {bold: 1}},

    # Titles for output from :set all, :autocmd, etc.
    {name: 'Title', guifg: green, guibg: 'NONE', cterm: {bold: 1}, gui: {bold: 1}},

    # Error messages on the command line
    {name: 'ErrorMsg',   guifg: red, guibg: 'NONE', cterm: {bold: 1}, gui: {bold: 1}},
    # More prompt: -- More --
    {name: 'MoreMsg',    guifg: yellow, guibg: 'NONE', cterm: {bold: 1}, gui: {bold: 1}},
    # Current mode message: -- INSERT --
    {name: 'ModeMsg',    guifg: yellow, guibg: 'NONE', cterm: {bold: 1}, gui: {bold: 1}},
    # 'Press enter' prompt and yes/no questions
    {name: 'Question',   guifg: orange, guibg: 'NONE', cterm: {bold: 1}, gui: {bold: 1}},
    # Warning messages
    {name: 'WarningMsg', guifg: red, guibg: 'NONE', cterm: {bold: 1}, gui: {bold: 1}},

    {name: 'QuickFixLine', guifg: 'NONE', guibg: dark1, cterm: {}, gui: {}},
    # }}},
    # Gutter: {{{

    # Line number for :number and :# commands
    {name: 'LineNr', guifg: dark2, cterm: {}, gui: {}},

    # Column where signs are displayed
    {name: 'SignColumn', guifg: 'NONE', guibg: dark1, cterm: {}, gui: {}},

    # Line used for closed folds
    {name: 'Folded', guifg: non_text, guibg: 'bg', cterm: {italic: 1}, gui: {italic: 1}},
    # Column where folds are displayed
    {name: 'FoldColumn', guifg: medium, guibg: dark1, cterm: {}, gui: {}},
    # }}},
    # Cursor: {{{

    # Character under cursor
    {name: 'Cursor', guifg: 'NONE', guibg: 'NONE', cterm: {inverse: 1}, gui: {inverse: 1}},
    # Visual mode cursor, selection
    {name: 'vCursor', guifg: 'NONE', guibg: 'NONE', cterm: {inverse: 1}, gui: {inverse: 1}},
    # Input moder cursor
    {name: 'iCursor', guifg: 'NONE', guibg: 'NONE', cterm: {inverse: 1}, gui: {inverse: 1}},
    # Language mapping cursor
    {name: 'lCursor', guifg: 'NONE', guibg: 'NONE', cterm: {inverse: 1}, gui: {inverse: 1}},

    # }}},
    # Syntax Highlighting: {{{

    {name: 'Special', guifg: orange, cterm: {}, gui: {}},
    {name: 'Comment', guifg: medium, cterm: {}, gui: {}},
    {name: 'Todo', guifg: 'fg', guibg: 'bg', cterm: {bold: 1}, gui: {bold: 1}},
    {name: 'Error', guifg: red, guibg: 'bg', cterm: {bold: 1}, gui: {bold: 1}},

    # Generic statement
    {name: 'Statement',   guifg: red, cterm: {}, gui: {}},
    # if, then, else, endif, swicth, etc.
    {name: 'Conditional', guifg: red, cterm: {}, gui: {}},
    # for, do, while, etc.
    {name: 'Repeat',      guifg: red, cterm: {}, gui: {}},
    # case, default, etc.
    {name: 'Label',       guifg: red, cterm: {}, gui: {}},
    # try, catch, throw
    {name: 'Exception',   guifg: red, cterm: {}, gui: {}},
    # Any other keyword
    {name: 'Keyword',     guifg: red, cterm: {}, gui: {}},

    # Variable name
    {name: 'Identifier', guifg: blue, cterm: {}, gui: {}},
    # Function name
    {name: 'Function',   guifg: green, guibg: 'NONE', cterm: {bold: 1}, gui: {bold: 1}},

    # Generic preprocessor
    {name: 'PreProc',   guifg: aqua, cterm: {}, gui: {}},
    # Preprocessor #include
    {name: 'Include',   guifg: blue, cterm: {}, gui: {}},
    # Preprocessor #define
    {name: 'Define',    guifg: aqua, cterm: {}, gui: {}},
    # Same as Define
    {name: 'Macro',     guifg: blue, cterm: {}, gui: {}},
    # Preprocessor #if, #else, #endif, etc.
    {name: 'PreCondit', guifg: aqua, cterm: {}, gui: {}},

    # Generic constant
    {name: 'Constant',  guifg: purple, cterm: {}, gui: {}},
    # Character constant: 'c', '/n'
    {name: 'Character', guifg: purple, cterm: {}, gui: {}},
    # String constant: "this is a string"
    {name: 'String',  guifg: green, guibg: 'NONE', cterm: {}, gui: {}},
    # Boolean constant: TRUE, false
    {name: 'Boolean',   guifg: purple, cterm: {}, gui: {}},
    # Number constant: 234, 0xff
    {name: 'Number',    guifg: purple, cterm: {}, gui: {}},
    # Floating point constant: 2.3e10
    {name: 'Float',     guifg: purple, cterm: {}, gui: {}},

    # Generic type
    {name: 'Type', guifg: yellow, cterm: {}, gui: {}},
    # static, register, volatile, etc
    {name: 'StorageClass', guifg: orange, cterm: {}, gui: {}},
    # struct, union, enum, etc.
    {name: 'Structure', guifg: orange, cterm: {}, gui: {}},
    # typedef
    {name: 'Typedef', guifg: yellow, cterm: {}, gui: {}},

    # {name: 'MarkDownCode', guibg: '#2c2c2c', cterm: {}, gui: {}},
    # {name: 'MarkDownCodeBlock', guifg: 'ivory4', cterm: {}, gui: {}},
    # {name: 'MarkDownCode', guifg: 'ivory4', guibg: '#282828', cterm: {}, gui: {}},
    {name: 'MarkDownCodeBlock', guifg: 'ivory4', cterm: {}, gui: {}},
    {name: 'MarkDownCode', guifg: blue, cterm: {}, gui: {}},

    # }}},
    # Completion Menu: {{{

    # Popup menu: normal item
    {name: 'Pmenu', guifg: 'fg', guibg: pmenu, cterm: {}, gui: {}},
    # Popup menu: selected item
    {name: 'PmenuSel', guifg: 'fg', guibg: pmenuSel, cterm: {bold: 1}, gui: {bold: 1}},
    {name: 'PmenuMatch', guifg: yellow, guibg: pmenu, cterm: {}, gui: {}},
    {name: 'PmenuMatchSel', guifg: yellow, guibg: pmenu, cterm: {bold: 1, inverse: 1}, gui: {bold: 1, inverse: 1}},
    {name: 'PmenuKind', guifg: orange, guibg: pmenu, cterm: {}, gui: {}},
    {name: 'PmenuKindSel', guifg: orange, guibg: pmenuSel, cterm: {bold: 1}, gui: {bold: 1}},
    # Popup menu: scrollbar
    {name: 'PmenuSbar', guifg: 'NONE', guibg: dark1, cterm: {}, gui: {}},
    # Popup menu: scrollbar thumb
    {name: 'PmenuThumb', guifg: 'NONE', guibg: dark4, cterm: {}, gui: {}},

    # }}},
    # Diffs: {{{

    {name: 'DiffDelete', guifg: '#504945', guibg: 'NONE', cterm: {}, gui: {}},
    {name: 'DiffAdd',    guifg: 'NONE', guibg: '#283f2f', cterm: {}, gui: {}},

    # Alternative setting
    {name: 'DiffChange', guifg: 'NONE', guibg: '#1F385B', cterm: {}, gui: {}},
    {name: 'DiffText',   guifg: 'NONE', guibg: '#172A45', cterm: {}, gui: {}},

    {name: 'diffAdded',   guifg: green,  cterm: {}, gui: {}},
    {name: 'diffRemoved', guifg: red,    cterm: {}, gui: {}},
    {name: 'diffChanged', guifg: aqua,   cterm: {}, gui: {}},
    {name: 'diffFile',    guifg: orange, cterm: {}, gui: {}},
    {name: 'diffNewFile', guifg: yellow, cterm: {}, gui: {}},
    {name: 'diffLine',    guifg: blue,   cterm: {}, gui: {}},


    # }}},
    # Spelling And Diag: {{{

    # Not capitalised word
    {name: 'SpellCap',   guifg: 'NONE', guibg: 'bg', cterm: {undercurl: 1}, gui: {undercurl: 1}},
    # Not recognized word
    # {name: 'SpellBad',   guifg: 'NONE', guibg: 'bg', cterm: {undercurl: 1}, gui: {undercurl: 1}},
    {name: 'SpellBad',   guifg: red, guibg: 'bg', cterm: {}, gui: {}},
    # Wrong spelling for selected region
    {name: 'SpellLocal', guifg: 'NONE', guibg: 'bg', cterm: {undercurl: 1}, gui: {undercurl: 1}},
    # Rare word
    {name: 'SpellRare',  guifg: 'NONE', guibg: 'bg', cterm: {undercurl: 1}, gui: {undercurl: 1}},
    {name: 'DiagnosticError', guifg: red,    cterm: {}, gui: {}},
    {name: 'DiagnosticWarn',  guifg: yellow, cterm: {}, gui: {}},
    {name: 'DiagnosticInfo',  guifg: 'fg',   cterm: {}, gui: {}},
    {name: 'DiagnosticHint',  guifg: blue,   cterm: {}, gui: {}},
    {name: 'DiagnosticOk',    guifg: green,  cterm: {}, gui: {}},
    {name: 'DiagStatusError', guifg: red,    guibg: dark2, cterm: {}, gui: {}},
    {name: 'DiagStatusWarn',  guifg: yellow, guibg: dark2, cterm: {}, gui: {}},
    {name: 'DiagStatusHint',  guifg: 'fg',   guibg: dark2, cterm: {}, gui: {}},
    {name: 'DiagStatusInfo',  guifg: blue,   guibg: dark2, cterm: {}, gui: {}},
    {name: 'DiagStatusOk',    guifg: green,  guibg: dark2, cterm: {}, gui: {}},

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

hi NonText guifg=#888888
hi SpecialKey guifg=#444455

hi! link WinSeparator VertSplit

hi! link CurSearch Incsearch

hi! link StatuslineTerm StatusLine
hi! link StatuslineTermNC StatusLineNC
