vim9script

# if exists("b:current_syntax")
#     finish
# endif

syn match fmDir  '\(\f\|\s\)\+\ze/$'
syn match fmExec '\(\f\|\s\)\+\ze\*'
syn match fmLink '\(\f\|\s\)\+\ze ->'
# syn match fmOwner '\(^\(\S\+\s\+\)\{2}\)\@<=\S\+'
# syn match fmGroup '\(^\(\S\+\s\+\)\{3}\)\@<=\S\+'
# syn match fmPerm '^\S\{10}'
# syn match fmPermRead 'r' contained containedin=fmPerm
# syn match fmPermWrite 'w' contained containedin=fmPerm
# syn match fmPermExec 'x' contained containedin=fmPerm

hi link fmDir Include
hi link fmExec Function
hi link fmLink PreProc
# hi link fmOwner Type
# hi link fmGroup PreProc
# hi link fmPermRead String
# hi link fmPermWrite Include
# hi link fmPermExec Statement

# b:current_syntax = "fm"
