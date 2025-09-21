highlight clear

if exists("syntax_on")
    syntax reset
endif

set background=dark
let g:colors_name = "gruber"

" #C2B6A5

"let s:black  = ["#242424", "234"]
let s:black  = ["#282828", "234"]
"let s:black  = ["#222426", "234"]
"let s:black  = ["#32302F", "234"]
"let s:black  = ["#2f2d2b", "234"]
"let s:black  = ["#2b2b2b", "234"]
"let s:blue   = ["#87afd7", "110"]
let s:blue   = ["#88aacc", "110"]
let s:brown  = ["#cc8c3c", "137"]
let s:cyan   = ["#afd7af", "151"]
let s:gray   = ["#242424", "235"]
"let s:green  = ["#87d75f", "113"]
"let s:green  = ["#77d74f", "113"]
"let s:green  = ["#6F9D6A", "113"]
let s:green  = ["#73c936", "113"]
"let s:red    = ["#ff5f5f", "204"]
let s:red    = ["#ff4444", "204"]
"let s:white  = ["#cfcfcf", "254"]
let s:white  = ["#d1b897", "254"]
"let s:white  = ["#c8ae9d", "254"]
"let s:white  = ["#b8ae9d", "254"]
"let s:white  = ["#b7bab8", "254"]
"let s:white  = ["#cccccc", "254"]
"let s:white  = ["#bbbbbb", "254"]
"let s:white  = ["#bfbbb7", "254"]
"let s:white  = ["#CDB088", "254"]
let s:white  = ["#cccdce", "254"]
let s:yellow = ["#ffdd33", "220"]

let s:light_gray     = ["#343434", "232"]
let s:lightest_gray  = ["#505050", "232"]
let s:quartz         = ["#95a99f", "232"]
let s:redish_brown   = ["#aa8888", "235"]

let s:bold      = "bold"
let s:italic    = "italic"
let s:underline = "underline"

function! s:hl(group, attrs) abort
    if has_key(a:attrs, "fg")
        let a:attrs["guifg"] = a:attrs["fg"][0]
        let a:attrs["ctermfg"] = a:attrs["fg"][1]
        unlet a:attrs["fg"]
    endif

    if has_key(a:attrs, "bg")
        let a:attrs["guibg"] = a:attrs["bg"][0]
        let a:attrs["ctermbg"] = a:attrs["bg"][1]
        unlet a:attrs["bg"]
    endif

    if has_key(a:attrs, "style")
        let a:attrs["gui"] = a:attrs["style"]
        let a:attrs["cterm"] = a:attrs["style"]
        unlet a:attrs["style"]
    endif

    let l:defaults = { "guifg": "NONE", "guibg": "NONE", "gui": "NONE", "guisp": "NONE",
                     \ "ctermfg": "NONE", "ctermbg": "NONE", "cterm": "NONE" }
    call extend(l:defaults, a:attrs)

    let l:command = "highlight" . " " . a:group
    for name in keys(l:defaults)
        let l:command .= " " . name . "=" . l:defaults[name]
    endfor

    execute l:command
endfunction

" :source $VIMRUNTIME/syntax/hitest.vim
" :help group-name
" :help highlight-default

call s:hl("ColorColumn",    { "bg": s:gray })
call s:hl("Constant",       { "fg": s:white })
call s:hl("CursorLine",     { "bg": s:gray })
call s:hl("DiffAdd",        { "fg": s:green })
call s:hl("DiffChange",     { "fg": s:blue })
call s:hl("DiffDelete",     { "fg": s:red })
call s:hl("DiffText",       { "fg": s:blue })
call s:hl("Directory",      { "fg": s:blue })
call s:hl("EndOfBuffer",    { "fg": s:lightest_gray })
call s:hl("Error",          { "fg": s:red })
call s:hl("ErrorMsg",       { "fg": s:red })
call s:hl("FoldColumn",     { "fg": s:brown, "bg": s:gray })
call s:hl("Folded",         { "fg": s:brown, "bg": s:gray, "style": s:italic })
call s:hl("Ignore",         { "bg": s:gray })
call s:hl("MatchParen",     { "fg": s:yellow, "bg": s:lightest_gray, "style": s:bold })
call s:hl("MoreMsg",        { "fg": s:green })
call s:hl("NonText",        { "fg": s:lightest_gray })
call s:hl("Normal",         { "fg": s:white, "bg": s:black })
call s:hl("Pmenu",          { "bg": s:gray })
call s:hl("PmenuSbar",      { "bg": s:light_gray })
call s:hl("PmenuSel",       { "bg": s:light_gray })
call s:hl("PmenuThumb",     { "bg": s:white })
call s:hl("Question",       { "fg": s:blue })
call s:hl("SpellBad",       { "fg": s:red})
call s:hl("SpellCap",       { "fg": s:blue})
call s:hl("SpellLocal",     { "fg": s:yellow})
call s:hl("SpellRare",      { "style": s:underline })
call s:hl("String",         { "fg": s:green })
call s:hl("Title",          { "fg": s:white })
call s:hl("Underlined",     { "style": s:underline })
call s:hl("VertSplit",      { "fg": s:gray })
call s:hl("WarningMsg",     { "fg": s:yellow })
call s:hl("WildMenu",       { "fg": s:black, "bg": s:yellow, "style": s:bold })
call s:hl("diffAdded",      { "fg": s:green })
call s:hl("diffRemoved",    { "fg": s:red })
call s:hl("diffSubname",    { "fg": s:blue })

" goldenrod -> #D9A420

hi Identifier guifg=fg gui=NONE
hi Function   guifg=fg
hi Statement  guifg=goldenrod gui=NONE
hi Operator   guifg=fg
hi String     guifg=#6b9e23
"hi Comment    guifg=azure4
"hi Comment    guifg=seashell4
hi Comment    guifg=#777879
hi Special    guifg=fg
hi PreProc    guifg=fg
hi Number     guifg=ivory3
"hi Number     guifg=#dddddd

hi! link Type Statement

hi MatchParen guifg=skyblue

"hi! link NormalFloat Normal
hi Statusline   guibg=#444444 guifg=#bbbbbb gui=NONE
hi StatuslineNC guibg=#444444 guifg=#aaaaaa gui=NONE
hi WinSeparator guibg=#444444 guifg=#444444

hi! link SpecialChar      Special
hi! link Tag              Special
hi! link Delimiter        Special
hi! link SpecialComment   Special
hi! link Debug            Special

hi! link cStructure statement
hi! link cppStructure statement
hi! link cTypedef statement
hi! link cConstant Type
hi! link cStorageClass statement
hi! link Character String

hi  DiffAdd guifg=NONE guibg=#1D2B21
" hi  DiffDelete guifg=NONE guibg=#722928
hi  DiffDelete guifg=#484E52 guibg=NONE
hi  DiffChange guifg=NONE guibg=#1F385B gui=NONE
hi  DiffText guifg=NONE guibg=#172A45
hi Added   guifg=#8F9D6A
hi Removed guifg=#CF6A4C
hi Changed guifg=NONE guibg=#1F385B

"hi  GitSignsAdd       guifg=#8F9D6A     guibg=NONE    gui=NONE cterm=NONE
"hi  GitSignsDelete    guifg=#af5f5f     guibg=NONE    gui=NONE cterm=NONE
hi  GitSignsChange guifg=#88aacc guibg=NONE

"" Highlighting in git (diff) files
"hi! link diffIndexLine comment
"hi! link diffFile comment
"hi! link diffOldFile function
"hi! link diffNewFile function
"hi! link diffline function
"hi! link diffSubname Normal

hi  DiagnosticError guifg=#ff5f5f
"call s:hl("DiagnosticError", { "fg": s:red })
hi  DiagnosticWarn  guifg=lightgoldenrod
hi  DiagnosticInfo  guifg=LightBlue
hi  DiagnosticHint  guifg=#747C84

hi IncSearch     guibg=#ee799f guifg=black gui=NONE
hi! link CurSearch Incsearch
hi Search        guibg=#218058 guifg=black gui=NONE
"hi Search        guibg=#CD9AAA guifg=black gui=NONE
"hi Search        guibg=#87AF87 guifg=black gui=NONE

hi markdowncode guifg=fg guibg=#383838
hi markdowncodeblock guifg=ivory4

if has('nvim')
    hi @variable guifg=fg
    hi @lsp.type.namespace guifg=fg
    hi @lsp.mod.constructorOrDestructor.cpp gui=bold
    hi! link @lsp.type.comment Ignore
    hi! link @lsp.type.comment Ignore
    hi! link @keyword.modifier.cpp Type
    hi! link @keyword.modifier.cpp Type
    "hi @markup.raw.markdown_inline guifg=fg
    "hi @markup.raw.block.markdown guifg=fg
    hi! link @markup.link.vimdoc Type
    hi! link @constant.macro Macro
    hi! link @type.builtin Type
    hi! link @keyword.modifier.cpp statement
    "hi! link @lsp.mod.constructorOrDestructor.cpp Statement
endif
