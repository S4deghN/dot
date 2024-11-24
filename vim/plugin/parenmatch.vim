vim9script

# =============================================================================
# Filename: plugin/parenmatch.vim
# Author: S4N
# License: MIT License
# Description: slightly simplified port of https://github.com/itchyny/vim-parenmatch to vim9
# =============================================================================

if exists('g:loaded_parenmatch') || v:version < 703 || !exists('*matchaddpos')
  finish
endif
g:loaded_parenmatch = 1
const TIMEOUT = 10

var paren = {}
var matchpairs = ''

def Match(i_mode: number)
  var c = matchstr(getline('.'), '.', col('.') - 1)

  if !has_key(paren, c) | return | endif

  var [open, closed, flags, stop] = paren[c]
  var q = [line('.'), col('.')]

  var r = searchpairpos(open, '', closed, flags, '', line(stop), TIMEOUT)

  if r[0] > 0
    # Use the default, always available, MatchParen highlight group instead of defining a custom one!
    w:parenmatch = matchaddpos('MatchParen', [q, r])
  endif
enddef

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

var timer = 0
def Update(i_mode: number)
  if !!get(w:, 'parenmatch') | silent! matchdelete(w:parenmatch) | w:parenmatch = 0 | endif
  timer_stop(timer)
  timer = timer_start(50, (_) => {
    Match(i_mode)
  })
enddef

defcompile

Setup()

augroup parenmatch
  autocmd!
  autocmd WinEnter,BufWinEnter,FileType * Setup()
  autocmd OptionSet matchpairs Setup()
  autocmd WinEnter,BufEnter * Update(0)
  autocmd InsertEnter * Update(1)
  autocmd InsertLeave * Update(0)
  autocmd CursorMoved,CursorMovedI * Update(0)
augroup END
