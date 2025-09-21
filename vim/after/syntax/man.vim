syn clear manOptionDesc
syn clear manLongOptionDesc

syn match  manOptionDesc     "\s\+\zs[+-][a-z0-9]\ze[ \t\n\.,;:=\[]\+"
syn match  manOptionDesc     "\[\zs[+-][a-z0-9]\ze\]"
syn match  manLongOptionDesc "\s\+\zs--[a-z0-9-]\+\ze[ \t\n\.,;:=\[]\+"
syn match  manBold "\C^\@!\<[A-Z_]\+\.*\>"

" Adds syntax highlighting to ``` ``` blocks of code in comments in a hacky way :)
syntax region cSnip matchgroup=cCodeBlock start='^\z(\s*//\s*```\s*\)$' end='^\z1$' keepend contains=ALLBUT,cBadBlock,cCurlyError,@cParenGroup,cErrInParen,cCppParen,cErrInBracket,cCppBracket,@cStringGroup,@Spell fold
hi link cCodeBlock SpecialComment
syn match CCommentLineDocLeader "^\s*//" contained
hi link CCommentLineDocLeader Comment


hi manBold cterm=Bold gui=Bold
