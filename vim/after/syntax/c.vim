syn keyword cTodo contained TODO FIX XXX NOTE WARN

syn keyword cType u8 u16 u32 u64 u128
syn keyword cType i8 i16 i32 i64 i128
syn keyword cType f32 f64

"identifier -> \I\i*
"between_type_and_identifier -> \_[ \t*]\+
"between_identifier_and_paren -> \_s*

" syn match cType '\%(^[ \t}]*\)\I\i*;'

" syn match cType '^\s*[.*]*\s*\zs\I\i*\ze\s*\%(\s\|\*\)\s*\I\i*\%(\s*=\s*.*\|[;,]\)'
" syn match cType '\%(static\_s\+\|register\_s\+\|auto\_s\+\|volatile\_s\+\|extern\_s\+\|const\_s\+\)*\zs\I\i*\ze\_[ \t*]\+\%(static\_s\+\|register\_s\+\|auto\_s\+\|volatile\_s\+\|extern\_s\+\|const\_s\+\)*\I\i*\_s*\%([=;,]\|(\_.*)\)'
syn match cType '^[^=*#]\{-}\%(static\_s\+\|register\_s\+\|auto\_s\+\|volatile\_s\+\|extern\_s\+\|const\_s\+\)*\zs\I\i*\ze\_[ \t*]\+\%(static\_s\+\|register\_s\+\|auto\_s\+\|volatile\_s\+\|extern\_s\+\|const\_s\+\)*\I\i*\_s*[=;,(]'
" syn match cType '\zs\I\i*\ze\_s*<\_.*>'

" " Cast
" " I don't know how. copied from cFunction
" syn match cType "\%((\_s*\)\@<=\h\w*\ze\_[ \t*&]*)\_s*\I\i*"

" syn region cFuncDef matchgroup=cFunction start='('rs=s-1 end=')'re=e+1 contains=ALLBUT,cBlock,@cParenGroup,cCppParen,cErrInBracket,cCppBracket,@cStringGroup,@Spell,cParen
syn match cTypeArg '[(,]\@1<=\_s*\zs\I\i*\ze\_[ \t*]\+\I\i*\_s*[,)]' contained containedin=cParen
" syn match cTypeCast '(\@1<=\_s*\zs\I\i*\ze\_[ \t*]*)\_s*\%(\w\|(\)' contained containedin=cParen
syn match cTypeCast '\%([^_a-zA-Z0-9 \t]\_s*(\)\@<=\_s*\zs\I\i*\ze\_[ \t*]*)\_s*\%(\w\|(\)' contained containedin=cParen
hi def link cTypeArg cType
hi def link cTypeCast cType

" " Function definition/declaration
" " TODO: fix the macro miss-match
" " I fucking give up! This is STUPID!
" " syn region cFuncDef matchgroup=Error start='\%(\I\i*\_[ \t*]\+\)\@5<=\I\i*\_s*('rs=e-1 end='\%()\_s*\)\@<=)\ze\_[^{;]*'re=s+1 contains=ALLBUT,cBlock,@cParenGroup,cCppParen,cErrInBracket,cCppBracket,@cStringGroup,@Spell,cParen
" syn region cFuncDef matchgroup=cFunction start='\%(^\s*\%(\I\i*\_[ \t*&]\+\)\+\)\@<=\I\i*\_s*('rs=e-1 end='\_[^{;]*)\ze\_[^{;]*'re=e+1 contains=ALLBUT,cBlock,@cParenGroup,cCppParen,cErrInBracket,cCppBracket,@cStringGroup,@Spell,cParen
" syn match cTypeArg '\zs\I\i*\ze\_[ \t*&]\+\I\i*\_s*[,)]' contained containedin=cFuncDef
" hi def link cTypeArg cType

" " Adds syntax highlighting to ``` ``` blocks of code in comments in a hacky way :)
" syntax region cSnip matchgroup=cCodeBlock start='^\z(\s*//\s*```\s*\)$' end='^\z1$' keepend contains=ALLBUT,cBadBlock,cCurlyError,@cParenGroup,cErrInParen,cCppParen,cErrInBracket,cCppBracket,@cStringGroup,@Spell fold
" hi link cCodeBlock SpecialComment
" syn match CCommentLineDocLeader "^\s*//" contained
" hi link CCommentLineDocLeader Comment

" " syntax match SpecialComment '`' contained containedin=cComment
" syntax region cSnipOneline matchgroup=SpecialComment start='`' end='`' oneline contained containedin=cComment,cCommentL contains=ALLBUT,cBadBlock,cCurlyError,@cParenGroup,cErrInParen,cCppParen,cErrInBracket,cCppBracket,@cStringGroup,@Spell
