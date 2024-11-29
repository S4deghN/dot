vim9script

# Description: slightly simplified port of https://github.com/itchyny/vim-parenmatch to vim9

if exists('g:loaded_parenmatch') || v:version < 703 || !exists('*matchaddpos')
  finish
endif
g:loaded_parenmatch = 1

const TIMEOUT = 10
var paren = {}
var matchpairs = ''

def Setup()
  if matchpairs ==# &l:matchpairs
    return
  endif
  matchpairs = &l:matchpairs
  for [open, closed] in map(split(&l:matchpairs, ','), 'split(v:val, ":")')
    paren[open] = [ escape(open, '[]'), escape(closed, '[]'), 'nW', 'w$' ]
    paren[closed] = [ escape(open, '[]'), escape(closed, '[]'), 'bnW', 'w0' ]
  endfor
enddef

def Match()
  if !!get(w:, 'parenmatch')
    silent! matchdelete(w:parenmatch)
    w:parenmatch = 0
  endif

  var c = getline('.')[col('.') - 1]

  if !has_key(paren, c)
    return
  endif

  var [open, closed, flags, stop] = paren[c]
  var q = [line('.'), col('.')]

  var r = searchpairpos(open, '', closed, flags, '', line(stop), TIMEOUT)

  if r[0] > 0
    w:parenmatch = matchaddpos('MatchParen', [q, r])
  endif
enddef

var timer = 0
def Update()
  if !timer
    timer = timer_start(10, (_) => {
      Match()
      timer = 0
    })
  endif
enddef

defcompile

Setup()

augroup parenmatch
  autocmd!
  autocmd WinEnter,BufWinEnter,FileType * Setup()
  autocmd OptionSet matchpairs Setup()
  autocmd WinEnter,BufEnter * Update()
  autocmd InsertEnter * Update()
  autocmd InsertLeave * Update()
  autocmd CursorMoved,CursorMovedI * Update()
augroup END
