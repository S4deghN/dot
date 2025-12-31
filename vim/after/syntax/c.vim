syn keyword cTodo contained TODO FIX XXX NOTE WARN

syn keyword cType u8 u16 u32 u64 u128
syn keyword cType i8 i16 i32 i64 i128
syn keyword cType s8 s16 s32 s64 s128
syn keyword cType f32 f64
syn keyword cType uint ulong

finish

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

finish

if &ft != 'c'
    finish
endif

syn clear

syn sync ccomment cComment minlines=50

syn keyword cType void char short int long float double signed unsigned
syn keyword cType uint ulong
syn keyword cType size_t ssize_t ptrdiff_t
syn keyword cType int8_t int16_t int32_t int64_t
syn keyword cType uint8_t uint16_t uint32_t uint64_t
syn keyword cType char8_t char16_t char32_t
syn keyword cType u8 u16 u32 u64 u128
syn keyword cType i8 i16 i32 i64 i128
syn keyword cType f32 f64
syn keyword cType _Complex complex _Imaginary imaginary _Bool bool

syn keyword cStatement goto break return continue asm __asm__
syn keyword cStatement case default
syn keyword cStatement if else switch
syn keyword cStatement while for do

syn keyword cStructure struct union enum

syn keyword cTypedef typedef

syn keyword cStorageClass auto const volatile register inline static extern restrict constexpr
syn keyword cStorageClass _Alignas alignas _Atomic _Noreturn noreturn _Thread_local thread_local
syn keyword cStorageClass __attribute__

syn match cConstant "\<[A-Z_][0-9A-Z_]*\>"

syn match cPreProc "^\s*\zs\%(%:\|#\)\s*\h\w*"

syn match  cInclude "^\s*\zs\%(%:\|#\)\s*include\>" skipwhite nextgroup=cIncluded
syn region cIncluded display contained start=+"+ skip=+\\\\\|\\"+ end=+"+
syn match  cIncluded display contained "<[^>]*>"

syn match  cDefine "^\s*\zs\%(%:\|#\)\s*\%(define\|undef\)\>" skipwhite nextgroup=cDefined
syn match  cDefined contained "\h\w*"
hi def link cDefined cDefine

syn match cFunction        "\<\h\w*\ze\_s*("
syn match cFunctionPointer "\%((\s*\*\s*\)\@<=\h\w*\ze\s*)\_s*(.*)"

syn match cFormat display contained containedin=cString "%\%(\d\+\$\)\=[-+' #0*]*\%(\d*\|\*\|\*\d\+\$\)\%(\.\%(\d*\|\*\|\*\d\+\$\)\)\=\%([hlLjzt]\|ll\|hh\)\=\%([aAbdiuoxXDOUfFeEgGcCsSpn]\|\[\^\=.[^]]*\]\)"
syn match cSpecialCharacter display contained containedin=cCharacter,cString "\\[\\?'\"abfnrtv]"
syn region cString start=+"+ skip=+\\"+ end=+"+
syn match cCharacter "'[^']\+'"

syn keyword cTodo contained containedin=cComment TODO FIXME FIX XXX NOTE WARN
syn match cTodo contained containedin=cComment '@\S\+\>'
syn match cComment "//.*$"
syn region cComment matchgroup=cComment extend fold start=+/\*+ end=+\*/+
