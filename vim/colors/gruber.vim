highlight clear

if exists("syntax_on")
    syntax reset
endif

set background=dark
let g:colors_name = "gruber"

"let s:black  = ["#202020", "234"]
" let s:black  = ["#32302F", "234"]
let s:black  = ["#282828", "234"]
"let s:blue   = ["#87afd7", "110"]
let s:blue   = ["#88aacc", "110"]
let s:brown  = ["#cc8c3c", "137"]
let s:cyan   = ["#afd7af", "151"]
let s:gray   = ["#242424", "235"]
"let s:green  = ["#87d75f", "113"]
" let s:green  = ["#77d74f", "113"]
" let s:green  = ["#6F9D6A", "113"]
let s:green  = ["#73c936", "113"]
let s:red    = ["#ff5f5f", "203"]
" let s:white  = ["#cfcfcf", "254"]
let s:white  = ["#dcddde", "254"]
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
call s:hl("Comment",        { "fg": s:brown })
call s:hl("Constant",       { "fg": s:white })
call s:hl("CursorLine",     { "bg": s:gray })
call s:hl("DiffAdd",        { "fg": s:green })
call s:hl("DiffChange",     { "fg": s:blue })
call s:hl("DiffDelete",     { "fg": s:red })
call s:hl("DiffText",       { "fg": s:blue })
call s:hl("Directory",      { "fg": s:blue })
call s:hl("EndOfBuffer",    { "fg": s:black })
call s:hl("Error",          { "fg": s:red })
call s:hl("ErrorMsg",       { "fg": s:red })
call s:hl("FoldColumn",     { "fg": s:brown, "bg": s:gray })
call s:hl("Folded",         { "fg": s:brown, "bg": s:gray, "style": s:italic })
call s:hl("Function",       { "fg": s:blue })
call s:hl("Identifier",     { "fg": s:white })
call s:hl("Ignore",         { "bg": s:gray })
call s:hl("MatchParen",     { "fg": s:blue, "bg": s:lightest_gray, "cterm": "bold"})
call s:hl("MoreMsg",        { "fg": s:green })
call s:hl("NonText",        { "fg": s:blue })
call s:hl("Normal",         { "fg": s:white, "bg": s:black })
call s:hl("Pmenu",          { "bg": s:gray })
call s:hl("PmenuSbar",      { "bg": s:light_gray })
call s:hl("PmenuSel",       { "bg": s:light_gray })
call s:hl("PmenuThumb",     { "bg": s:white })
call s:hl("PreProc",        { "fg": s:quartz })
call s:hl("Question",       { "fg": s:blue })
call s:hl("Special",        { "fg": s:yellow })
call s:hl("SpecialChar",    { "fg": s:green })
call s:hl("SpecialComment", { "fg": s:brown })
call s:hl("SpecialKey",     { "fg": s:blue })
call s:hl("SpellBad",       { "fg": s:red, "style": s:underline })
call s:hl("SpellCap",       { "fg": s:blue, "style": s:underline })
call s:hl("SpellLocal",     { "fg": s:yellow, "style": s:underline })
call s:hl("SpellRare",      { "style": s:underline })
call s:hl("Statement",      { "fg": s:yellow })
call s:hl("StatusLine",     { "fg": s:white, "bg": s:gray})
call s:hl("StatusLineNC",   { "fg": s:white, "bg": s:gray })
call s:hl("String",         { "fg": s:green })
call s:hl("Title",          { "fg": s:white })
call s:hl("Todo",           { "fg": s:brown, "style": s:italic })
call s:hl("Type",           { "fg": s:quartz })
call s:hl("Underlined",     { "style": s:underline })
call s:hl("VertSplit",      { "fg": s:gray })
call s:hl("WarningMsg",     { "fg": s:yellow })
call s:hl("WildMenu",       { "fg": s:black, "bg": s:yellow, "style": s:bold })
call s:hl("diffAdded",      { "fg": s:green })
call s:hl("diffRemoved",    { "fg": s:red })
call s:hl("diffSubname",    { "fg": s:blue })

hi! link NormalFloat Normal

hi! link cStructure statement
hi! link cppStructure statement
hi! link cTypedef statement
hi! link cConstant Type
hi! link cStorageClass statement
hi! link Character String

hi operator guifg=fg
hi delimiter guifg=fg

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


if has('nvim') 
    hi @variable guifg=fg
    hi! link @lsp.type.comment Ignore
    hi! link @lsp.type.comment Ignore
    "hi! link @lsp.type.nameSpace Type
    "hi @lsp.type.nameSpace guifg=#96a6c8
    hi! link @keyword.modifier.cpp Type
    hi! link @keyword.modifier.cpp Type
    "hi @markup.raw.markdown_inline guifg=fg
    hi @markup.raw.block.markdown guifg=fg
    hi! link @markup.link.vimdoc Type
    hi! link @constant.macro Macro
    hi! link @type.builtin Type
    hi! link @keyword.modifier.cpp statement
    "hi! link @lsp.mod.constructorOrDestructor.cpp Statement
endif
