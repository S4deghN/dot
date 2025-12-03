vim9script

highlight clear

if exists("syntax_on")
    syntax reset
endif

set background=dark
g:colors_name = "vim9"

var black        = '#282828'
# var black        = '#2a2a2a'
var blue         = '#88aacc'
var brown        = '#cc8c3c'
var cyan         = '#afd7af'
var dim          = '#242424'
# var green        = '#6b9e23'
# var green        = '#6bae23'
var green        = '#6bae23'
# var green        = '#73c936'
var red          = '#ff4444'
var white        = '#cccdce'
# var white        = '#dcddde'
# var white        = 'ivory2'
var yellow       = '#ffda33'
var dark_gray    = '#343434'
var gray         = '#444444'
var light_gray   = '#505050'
var quartz       = '#95a99f'
var redish_brown = '#aa8888'
# var goldenrod    = '#D9A420'
var goldenrod    = 'goldenrod1'
# var goldenrod    = yellow
var oldivory     = '#ccccbc'

g:terminal_ansi_colors = [
    "#202020", #black
    red,
    "#6B9D23", #green
    goldenrod, #yellow
    blue,      #blue
    "#d3869b", #magenta
    quartz,    #cyan
    "#8A8581", #white
    "#555555", #brblack
    red,
    "#6B9D23", #brgreen
    goldenrod, #bryellow
    blue,      #brblue
    "#d3869b", #brmagenta
    quartz,    #brcyan
    white,     #brwhite
]

hlset([
    {name: 'ColorColumn',       guibg: dim},
    {name: 'CursorLine',        guibg: dim, cterm: {}},
    {name: 'Directory',         guifg: blue},
    {name: 'EndOfBuffer',       guifg: light_gray},
    {name: 'Error',             guifg: red, guibg: 'bg'},
    {name: 'ErrorMsg',          guifg: red, guibg: 'bg'},
    {name: 'FoldColumn',        guifg: '#777879', guibg: dim},
    {name: 'Folded',            guifg: '#777879', guibg: dim},
    {name: 'Ignore',            guifg: dim},
    {name: 'MoreMsg',           guifg: green},
    {name: 'NonText',           guifg: light_gray},
    {name: 'Normal',            guifg: white, guibg: black},
    {name: 'Visual',            guifg: 'NONE'},
    {name: 'Pmenu',             guibg: dim},
    {name: 'PmenuSbar',         guibg: dark_gray},
    {name: 'PmenuSel',          guibg: dark_gray},
    {name: 'PmenuThumb',        guibg: white},
    {name: 'Question',          guifg: blue},
    {name: 'SpellBad',          guifg: red},
    {name: 'SpellCap',          guifg: blue},
    {name: 'SpellLocal',        guifg: yellow},
    {name: 'SpellRare',         gui:   {underline: 1}},
    {name: 'String',            guifg: green},
    {name: 'Title',             guifg: cyan},
    {name: 'Underlined',        gui:   {underline: 1}},
    {name: 'WarningMsg',        guifg: yellow},
    {name: 'WildMenu',          guifg: black, guibg: yellow, gui: {bold: 1}},
    {name: 'diffAdded',         guifg: green, cterm: {}},
    {name: 'diffRemoved',       guifg: red, cterm: {}},
    {name: 'diffSubname',       guifg: blue, cterm: {}},
    {name: 'Identifier',        guifg: 'fg', cterm: {}},
    # {name: 'Function',          guifg: 'fg', cterm: {bold: 0}},
    # {name: 'Function',          guifg: '#99bbdd', cterm: {}},
    # {name: 'Function',          guifg: 'orange2', cterm: {}},
    {name: 'Function',          guifg: '#FE9C20', cterm: {}},
    # {name: 'Function',          guifg: '#EFBBBB', cterm: {}},
    # {name: 'Function',          guifg: 'lightsalmon', cterm: {}},
    # {name: 'Function',          guifg: '#FEAC8C', cterm: {}},
    # {name: 'Function',          guifg: 'seashell3', cterm: {}},
    {name: 'Operator',          guifg: 'fg', cterm: {}},
    {name: 'PreProc',           guifg: quartz, cterm: {}},
    {name: 'delimiter',         guifg: 'fg'},
    {name: 'Special',           guifg: cyan, cterm: {}},
    {name: 'Statement',         guifg: goldenrod, cterm: {}},
    # {name: 'Number',            guifg: oldivory, cterm: {}},
    # {name: 'Constant',          guifg: oldivory, cterm: {}},
    {name: 'Number',            guifg: oldivory, cterm: {}},
    {name: 'Constant',          guifg: oldivory, cterm: {}},
    {name: 'MatchParen',        guifg: 'skyblue', guibg: light_gray, cterm: {}},
    # {name: 'Comment',           guifg: '#878889'},
    # {name: 'Comment',           guifg: '#979999'},
    # {name: 'Comment',           guifg: 'ivory4'},
    {name: 'Comment',           guifg: blue},
    # {name: 'Comment',           guifg: 'orange2'},
    {name: 'VertSplit',         guifg: 'bg', guibg: gray},
    {name: 'Statusline',        guifg: '#bbbbbb', guibg: gray, cterm: {}},
    {name: 'StatuslineNC',      guifg: '#aaaaaa', guibg: gray, cterm: {}},
    {name: 'DiffAdd',           guifg: 'NONE', guibg: '#1D2B21', cterm: {}},
    {name: 'DiffDelete',        guifg: '#484E52', guibg: 'NONE', cterm: {}},
    {name: 'DiffChange',        guifg: 'NONE', guibg: '#1F385B', cterm: {}},
    {name: 'DiffText',          guifg: 'NONE', guibg: '#172A45', cterm: {}},
    {name: 'Added',             guifg: '#8F9D6A'},
    {name: 'Removed',           guifg: '#CF6A4C'},
    {name: 'Changed',           guifg: 'NONE', guibg: '#1F385B'},
    {name: 'DiagnosticError',   guifg: '#ff5f5f'},
    {name: 'DiagnosticWarn',    guifg: 'lightgoldenrod'},
    {name: 'DiagnosticInfo',    guifg: 'LightBlue'},
    {name: 'DiagnosticHint',    guifg: '#747C84'},
    {name: 'IncSearch',         guifg: 'black', guibg: '#ee799f', cterm: {}},
    {name: 'Search',            guifg: 'black', guibg: '#218058', cterm: {}},
    {name: 'markdowncode',      guifg: 'ivory3'},
    {name: 'markdowncodeblock', guifg: 'ivory4'},
    {name: 'Todo',              guifg: 'white', guibg: 'bg', cterm: {bold: 1}},
    {name: 'QuickFixLine',      guifg: 'NONE', guibg: '#333333', cterm: {}, gui: {}},
])

hi! link Type              Statement
hi! link cStructure        statement
hi! link cppStructure      statement
hi! link cTypedef          statement
hi! link cStorageClass     statement
hi! link HelpHyperTextJump Statement
hi! link SpecialChar       Special
hi! link Tag               Special
hi! link SpecialComment    Special
hi! link Debug             Special
hi! link Character         String
hi! link CurSearch         Incsearch
hi! link WinSeparator      VertSplit
hi! link SpecialKey        NonText
hi! link LineNr            NonText
hi! link Signcolumn        NonText
hi! link StatuslineTerm    StatusLine
hi! link StatuslineTermNC  StatusLineNC
hi! link TabLine           Statusline
hi! link TabLineFill       StatuslineNC
