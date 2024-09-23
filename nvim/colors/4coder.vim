" Name:       4coder.vim
" Version:    0.1.0
" Maintainer: github.com/S4deghN
" License:    The MIT License (MIT)
"
"
"""
hi clear

if exists('syntax on')
    syntax reset
endif
set bg=dark

let g:colors_name='4coder'

let s:black           = { "gui": "#0C0C0C", "cterm": "232" }
let s:medium_gray     = { "gui": "#767676", "cterm": "243" }
let s:white           = { "gui": "#F1F1F1", "cterm": "15"  }
let s:actual_white    = { "gui": "#FFFFFF", "cterm": "231" }
let s:subtle_black    = { "gui": "#303030", "cterm": "236" }
let s:light_black     = { "gui": "#262626", "cterm": "235" }
let s:lighter_black   = { "gui": "#4E4E4E", "cterm": "239" }
let s:light_gray      = { "gui": "#A8A8A8", "cterm": "248" }

let s:lighter_gray    = { "gui": "#90B080", "cterm": "251" }
"let s:lighter_gray    = { "gui": "#839496", "cterm": "251" } " Solarized fg
"let s:lighter_gray    = { "gui": "#839696", "cterm": "251" } " Solarized fg
"let s:lighter_gray    = { "gui": "#839f96", "cterm": "251" } " Solarized fg
"let s:lighter_gray    = { "gui": "#839f90", "cterm": "251" }
"let s:lighter_gray    = { "gui": "#95a99f", "cterm": "251" }

let s:lightest_gray   = { "gui": "#EEEEEE", "cterm": "255" }
let s:pink            = { "gui": "#fb007a", "cterm": "9"   }
let s:dark_red        = { "gui": "#C30771", "cterm": "1"   }
let s:light_red       = { "gui": "#E32791", "cterm": "1"   }
let s:orange          = { "gui": "#D75F5F", "cterm": "167" }
let s:darker_blue     = { "gui": "#005F87", "cterm": "18"  }
let s:dark_blue       = { "gui": "#008EC4", "cterm": "32"  }
let s:blue            = { "gui": "#20BBFC", "cterm": "12"  }
let s:light_blue      = { "gui": "#b6d6fd", "cterm": "153" }
let s:dark_cyan       = { "gui": "#20A5BA", "cterm": "6"   }
let s:light_cyan      = { "gui": "#4FB8CC", "cterm": "14"  }
let s:dark_green      = { "gui": "#10A778", "cterm": "2"   }
let s:light_green     = { "gui": "#5FD7A7", "cterm": "10"  }
let s:dark_purple     = { "gui": "#af5fd7", "cterm": "134" }
let s:light_purple    = { "gui": "#a790d5", "cterm": "140" }
let s:yellow          = { "gui": "#F3E430", "cterm": "11"  }
let s:light_yellow    = { "gui": "#ffff87", "cterm": "228" }
let s:dark_yellow     = { "gui": "#A89C14", "cterm": "3"   }

let s:background = &background

let s:bg              = s:black
let s:bg_subtle       = s:lighter_black
let s:bg_very_subtle  = s:subtle_black
let s:norm            = s:lighter_gray
let s:norm_subtle     = s:medium_gray
let s:purple          = s:light_purple
let s:cyan            = s:light_cyan
let s:green           = s:light_green
let s:red             = s:light_red
let s:visual          = s:light_purple
let s:yellow          = s:light_yellow

" https://github.com/noahfrederick/vim-hemisu/
function! s:h(group, style)
    execute "highlight" a:group
                \ "guifg="   (has_key(a:style, "fg")    ? a:style.fg.gui   : "NONE")
                \ "guibg="   (has_key(a:style, "bg")    ? a:style.bg.gui   : "NONE")
                \ "guisp="   (has_key(a:style, "sp")    ? a:style.sp.gui   : "NONE")
                \ "gui="     (has_key(a:style, "gui")   ? a:style.gui      : "NONE")
                \ "ctermfg=" (has_key(a:style, "fg")    ? a:style.fg.cterm : "NONE")
                \ "ctermbg=" (has_key(a:style, "bg")    ? a:style.bg.cterm : "NONE")
                \ "cterm="   (has_key(a:style, "cterm") ? a:style.cterm    : "NONE")
endfunction

call s:h("Normal",        {"bg": s:bg, "fg": s:norm})

" restore &background's value in case changing Normal changed &background (:help :hi-normal-cterm)
if &background != s:background
    execute "set background=" . s:background
endif

call s:h("Cursor",        {"bg": s:light_green, "fg": s:black })
call s:h("Comment",       {"fg": s:bg_subtle, "gui": "italic"})

call s:h("Constant",      {"fg": s:purple})
hi! link Character        Constant
hi! link Number           Constant
hi! link Boolean          Constant
hi! link Float            Constant
hi! link String           Constant

"call s:h("Identifier",    {"fg": s:dark_blue})
hi! link Identifier       Normal
hi! link Function         Identifier

call s:h("Statement",     {"fg": s:norm_subtle})
hi! link Conditonal       Statement
hi! link Repeat           Statement
hi! link Label            Statement
hi! link Keyword          Statement
hi! link Exception        Statement

call s:h("Operator",      {"fg": s:norm})

call s:h("PreProc",     {"fg": s:norm_subtle})
hi! link Include          PreProc
hi! link Define           PreProc
hi! link Macro            PreProc
hi! link PreCondit        PreProc

call s:h("Type",          {"fg": s:light_green})
hi! link StorageClass     Type
hi! link Structure        Type
hi! link Typedef          Type

call s:h("Special",       {"fg": s:norm_subtle, "gui": "italic"})
hi! link SpecialChar      Special
hi! link Tag              Special
hi! link Delimiter        Special
hi! link SpecialComment   Special
hi! link Debug            Special

call s:h("Underlined",    {"fg": s:norm, "gui": "underline", "cterm": "underline"})
call s:h("Ignore",        {"fg": s:bg})
call s:h("Error",         {"fg": s:actual_white, "bg": s:red, "cterm": "bold"})
call s:h("Todo",          {"fg": s:purple, "gui": "underline", "cterm": "underline"})
call s:h("SpecialKey",    {"fg": s:light_green})
call s:h("NonText",       {"fg": s:medium_gray})
call s:h("Directory",     {"fg": s:dark_blue})
call s:h("ErrorMsg",      {"fg": s:red})
call s:h("IncSearch",     {"bg": s:yellow, "fg": s:light_black})
call s:h("Search",        {"bg": s:light_green, "fg": s:light_black})
call s:h("MoreMsg",       {"fg": s:medium_gray, "cterm": "bold", "gui": "bold"})
hi! link ModeMsg MoreMsg
call s:h("LineNr",        {"fg": s:bg_subtle})
call s:h("CursorLineNr",  {"fg": s:purple, "bg": s:bg_very_subtle})
call s:h("Question",      {"fg": s:red})
call s:h("StatusLine",    {"bg": s:bg_very_subtle})
call s:h("StatusLineNC",  {"bg": s:bg_very_subtle, "fg": s:medium_gray})
call s:h("VertSplit",     {"bg": s:bg_very_subtle, "fg": s:bg_very_subtle})
call s:h("Title",         {"fg": s:dark_blue})
call s:h("Visual",        {"fg": s:bg, "bg": s:visual})
call s:h("VisualNOS",     {"bg": s:bg_subtle})
call s:h("WarningMsg",    {"fg": s:yellow})
call s:h("WildMenu",      {"fg": s:bg, "bg": s:norm})
call s:h("Folded",        {"fg": s:medium_gray})
call s:h("FoldColumn",    {"fg": s:bg_subtle})
call s:h("DiffAdd",       {"fg": s:green})
call s:h("DiffDelete",    {"fg": s:red})
call s:h("DiffChange",    {"fg": s:dark_yellow})
call s:h("DiffText",      {"fg": s:dark_blue})
call s:h("SignColumn",    {"fg": s:light_green})


if has("gui_running")
    call s:h("SpellBad",    {"gui": "underline", "sp": s:red})
    call s:h("SpellCap",    {"gui": "underline", "sp": s:light_green})
    call s:h("SpellRare",   {"gui": "underline", "sp": s:pink})
    call s:h("SpellLocal",  {"gui": "underline", "sp": s:dark_green})
else
    call s:h("SpellBad",    {"cterm": "underline", "fg": s:red})
    call s:h("SpellCap",    {"cterm": "underline", "fg": s:light_green})
    call s:h("SpellRare",   {"cterm": "underline", "fg": s:pink})
    call s:h("SpellLocal",  {"cterm": "underline", "fg": s:dark_green})
endif

call s:h("Pmenu",         {"fg": s:norm, "bg": s:bg_subtle})
call s:h("PmenuSel",      {"fg": s:purple, "bg": s:bg})
call s:h("PmenuSbar",     {"fg": s:norm, "bg": s:bg_subtle})
call s:h("PmenuThumb",    {"fg": s:norm, "bg": s:bg_subtle})
call s:h("TabLine",       {"fg": s:norm, "bg": s:bg_very_subtle})
call s:h("TabLineSel",    {"fg": s:purple, "bg": s:bg_subtle, "gui": "bold", "cterm": "bold"})
call s:h("TabLineFill",   {"fg": s:norm, "bg": s:bg_very_subtle})
call s:h("CursorColumn",  {"bg": s:bg_very_subtle})
call s:h("CursorLine",    {"bg": s:bg_very_subtle})
call s:h("ColorColumn",   {"bg": s:bg_subtle})

call s:h("MatchParen",    {"bg": s:bg_subtle, "fg": s:norm})
call s:h("qfLineNr",      {"fg": s:medium_gray})

call s:h("htmlH1",        {"gui": "bold", "bg": s:bg, "fg": s:norm})
call s:h("htmlH2",        {"gui": "bold", "bg": s:bg, "fg": s:norm})
call s:h("htmlH3",        {"gui": "bold", "bg": s:bg, "fg": s:norm})
call s:h("htmlH4",        {"gui": "bold", "bg": s:bg, "fg": s:norm})
call s:h("htmlH5",        {"gui": "bold", "bg": s:bg, "fg": s:norm})
call s:h("htmlH6",        {"gui": "bold", "bg": s:bg, "fg": s:norm})

" Synatastic
call s:h("SyntasticWarningSign",    {"fg": s:yellow})
call s:h("SyntasticWarning",        {"bg": s:yellow, "fg": s:black, "gui": "bold", "cterm": "bold"})
call s:h("SyntasticErrorSign",      {"fg": s:red})
call s:h("SyntasticError",          {"bg": s:red, "fg": s:white, "gui": "bold", "cterm": "bold"})

" Neomake
hi link NeomakeWarningSign	SyntasticWarningSign
hi link NeomakeErrorSign	SyntasticErrorSign

" ALE
hi link ALEWarningSign	SyntasticWarningSign
hi link ALEErrorSign	SyntasticErrorSign

" Signify, git-gutter
hi link SignifySignAdd              LineNr
hi link SignifySignDelete           LineNr
hi link SignifySignChange           LineNr
hi link GitGutterAdd                LineNr
hi link GitGutterDelete             LineNr
hi link GitGutterChange             LineNr
hi link GitGutterChangeDelete       LineNr

" Custom
hi  Normal     guibg=NONE
hi  NormalFloat     guibg=bg
hi  FloatBorder     guibg=bg

hi  CursorLine      guibg=#303030
"hi  CursorLine      guibg=#191960
"hi  CursorLine      guibg=#101050
"hi  CursorLine      guibg=#000030
"hi  CursorLine      guibg=#181970
hi  CursorColumn    guibg=#303030
hi  Folded          guibg=#303030     guifg=#747C84
hi  VertSplit       guibg=NONE

hi  Cursor guibg=#8ec07c

" #CD5C5C
" #D3869B
" #EBC06D
" #458588
" #E19972
hi  Constant        guifg=#50ff30
hi  Constant        guifg=#50cc30
hi  Constant        guifg=#30bb30
hi  Constant        guifg=#30bb30
hi! link String constant
hi  Directory       guifg=#789AC0
hi  Function        guifg=fg
hi! link            Special           Constant
hi  Delimiter       guifg=fg
hi  Preproc         guifg=#A0B8A0
hi  Type            guifg=#A0B8A0
hi! link cType Statement
hi  vimGroup        guifg=fg
hi  Statement       guifg=#D08F20
hi  Comment         guifg=#2090F0 gui=NONE cterm=NONE
hi  Ignore          guibg=#1c2020 guifg=NONE cterm=NONE
if has('nvim')
    hi! link @lsp.type.comment Ignore
    hi! link @lsp.type.comment Ignore
    hi! link @lsp.type.nameSpace Type
    " hi @lsp.type.nameSpace guifg=#6B7278
    hi! link @keyword.modifier.cpp Type
    hi! link @keyword.modifier.cpp Type
    "hi @markup.raw.markdown_inline guifg=fg
    hi @markup.raw.block.markdown guifg=fg
    hi! link @markup.link.vimdoc Type
    hi! link @constant.macro Macro
    hi @variable guifg=fg
    hi! link @type.builtin Type
    hi! link @keyword.modifier.cpp statement
endif

hi Error      guibg=NONE guifg=red1 gui=underline cterm=underline
hi ErrorMsg   guifg=#af5f5f
hi WarningMsg guifg=darkyellow
hi MatchParen guifg=#E6D78E gui=bold cterm=bold
hi Todo       guifg=red1 gui=none

hi  DiagnosticError guifg=red3
hi  DiagnosticWarn  guifg=darkyellow
hi  DiagnosticInfo  guifg=LightBlue
hi  DiagnosticHint  guifg=#747C84

hi! link            Directory         Constant
hi  Search          guibg=#23272E     guifg=lightblue
" hi  PmenuSel        guibg=bg          guifg=#a790d5


hi  htmlH1 guibg=NONE guifg=#A0B8A0
hi  htmlH2 guibg=NONE guifg=#A0B8A0
hi  htmlH3 guibg=NONE guifg=#A0B8A0
hi  htmlH4 guibg=NONE guifg=#A0B8A0
hi  htmlH5 guibg=NONE guifg=#A0B8A0
hi  htmlH6 guibg=NONE guifg=#A0B8A0
hi! link helpHyperTextJump Statement
hi  markdownCode guifg=#458588

hi  SpellBad guifg=fg gui=underline

hi  GitSignsAdd       guifg=#8F9D6A     guibg=NONE    gui=NONE cterm=NONE
hi  GitSignsDelete    guifg=red3     guibg=NONE    gui=NONE cterm=NONE
hi  GitSignsChange    guifg=#2090F0     guibg=NONE    gui=NONE cterm=NONE

hi  DiffAdd guifg=NONE guibg=#1D2B21
" hi  DiffDelete guifg=NONE guibg=#722928
hi  DiffDelete guifg=#484E52 guibg=NONE
hi  DiffChange guifg=NONE guibg=#1F385B
hi  DiffText guifg=NONE guibg=#172A45

hi Added   guifg=#8F9D6A
hi Removed guifg=#CF6A4C
hi Changed guifg=NONE guibg=#1F385B

" Naysayer merge
hi Normal guifg=fg guibg=bg gui=NONE
"hi NormalFloat guibg=#303030
hi floatBorder guifg=#343434 guibg=bg
hi NormalFloat guibg=bg guifg=fg
"hi Visual guifg=NONE guibg=#163339 gui=NONE
"hi Visual guifg=NONE guibg=#08454D gui=NONE
"hi Visual guifg=NONE guibg=#08373f gui=NONE
"hi visual guifg=NONE guibg=#285577
hi visual guifg=NONE guibg=#505050

" hi Visual guibg=#232729

" hi MsgArea guibg=#1c1c1c

" hi VertSplit guifg=#000000       guibg=NONE         gui=NONE
"hi VertSplit guifg=#232729 guibg=bg
hi WinSeparator guibg=bg guifg=#343434
hi! link VertSplit winSeperator
"hi! link FloatBorder VertSplit
hi! link CmpPmenuBorder VertSplit
hi Pmenu guibg=#191919
" hi! link Pmenu Visual
hi! link PmenuSel Visual
hi PmenuThumb guibg=fg

hi Folded guifg=#878787 guibg=bg
hi StatusLine   guibg=#888888 guifg=black
hi StatusLineNC guibg=#555555 guifg=black
hi! link QuickFixLine CursorLine
hi! link QfFileName String
hi! link QfLineNr Constant

hi IncSearch     guibg=#ee799f guifg=black gui=NONE
hi! link CurSearch Incsearch
hi Search        guibg=yellow3 guifg=black gui=NONE

hi! link cppStructure statement
hi! link cStructure statement
hi! link cStorageClass statement
hi! link cTypedef statement

" Highlighting in git (diff) files
hi! link diffIndexLine comment
hi! link diffFile comment
hi! link diffOldFile function
hi! link diffNewFile function
hi! link diffline function
hi! link diffSubname Normal

" fzflua
hi! link FzfLuaBufNr normal
hi! link FzfLuaHeaderBind normal
hi! link FzfLuaPathLineNr String
