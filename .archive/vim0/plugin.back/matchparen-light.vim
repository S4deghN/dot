vim9script

# Description: slightly simplified port of https://github.com/itchyny/vim-parenmatch to vim9

if exists('g:loaded_matchparen_light') || v:version < 703 || !exists('*matchaddpos')
  finish
endif
g:loaded_matchparen_light = 1

const TIMEOUT = 10
var paren = {}
var close_regex = ''
var open_regex = ''
var matchpairs = ''

def Setup()
  if matchpairs ==# &l:matchpairs
    return
  endif
  matchpairs = &l:matchpairs
  for [open, close] in map(split(&l:matchpairs, ','), 'split(v:val, ":")')
    paren[open] = [ escape(open, '[]'), escape(close, '[]'), 'nW', 'w$' ]
    paren[close] = [ escape(open, '[]'), escape(close, '[]'), 'bnW', 'w0' ]
    close_regex ..= close .. '\|'
    open_regex ..= open .. '\|'
  endfor
  close_regex = close_regex[: -3]
  open_regex = open_regex[: -3]
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


def g:Match2()
  if !!get(w:, 'parenmatch')
    silent! matchdelete(w:parenmatch)
    w:parenmatch = 0
  endif

  var c = getline('.')[col('.') - 1]
  if has_key(paren, c)
    var [open, closed, flags, stop] = paren[c]
    var q = [line('.'), col('.')]
    var r = searchpairpos(open, '', closed, flags, '', line(stop), TIMEOUT)
    if r[0] > 0
      w:parenmatch = matchaddpos('MatchParen', [q, r])
    endif
    return
  endif

  var view = winsaveview()
  setl scrolloff=0
  var close_pos = [0, 0]
  while 1
    close_pos = searchpos(close_regex, 'W', line('w$'), TIMEOUT)

    if close_pos == [0, 0] | break | endif

    var close = getline('.')[col('.') - 1]
    var [open, _, flags, stop] = paren[close]
    var open_pos = searchpairpos(open, '', close, flags, '', line(stop), TIMEOUT)

    if open_pos[0] > view.lnum || (open_pos[0] == view.lnum && open_pos[1] > view.col) | continue | endif

    if open_pos[0] > 0 # lnum > 0
      w:parenmatch = matchaddpos('MatchParen', [open_pos, close_pos])
      # echom $'{open_pos}, {close_pos}'
    endif
    break
  endwhile

  cursor([view.lnum, view.col + 1, view.coladd, view.curswant + 1])
  setl scrolloff<

enddef

def g:Match3()
  if !!get(w:, 'parenmatch')
    silent! matchdelete(w:parenmatch)
    w:parenmatch = 0
  endif

  var c = getline('.')[col('.') - 1]
  if has_key(paren, c)
    var [open, closed, flags, stop] = paren[c]
    var q = [line('.'), col('.')]
    var r = searchpairpos(open, '', closed, flags, '', line(stop), TIMEOUT)
    if r[0] > 0
      w:parenmatch = matchaddpos('MatchParen', [q, r])
    endif
    return
  endif

  # some methods to match:
  #   - matchbufline(bufnr(), '(', line('.'), line('w$'))
  #   - matchstrlist(getline('.', 'w$'), '(')

  # [bufnum, lnum, col, off]
  var cursor = getpos('.')
  for close in matchbufline(bufnr(), close_regex, line('.'), line('w$'))
    # skip if closing paren is behind cursor
    if close.byteidx + 1 < cursor[2] | continue | endif

    keepjumps cursor(close.lnum, close.byteidx + 1)
    var [open, _, flags, stop] = paren[close.text]
    var open_pos = searchpairpos(open, '', close.text, flags, '', line(stop), TIMEOUT)

    # echom open_pos
    # echom cursor

    if open_pos[0] > cursor[1] || (open_pos[0] == cursor[1] && open_pos[1] > cursor[2])
      continue
    endif

    if open_pos[0] > 0
      w:parenmatch = matchaddpos('MatchParen', [open_pos, [close.lnum, close.byteidx + 1]])
      echom $'{open_pos}, {[close.lnum, close.byteidx + 1]}'
      break
    endif

  endfor
  keepjumps cursor(cursor[1], cursor[2])

enddef

def g:Match4()
  if !!get(w:, 'parenmatch')
    silent! matchdelete(w:parenmatch)
    w:parenmatch = 0
  endif

  var c = getline('.')[col('.') - 1]
  if has_key(paren, c)
    var [open, closed, flags, stop] = paren[c]
    var q = [line('.'), col('.')]
    var r = searchpairpos(open, '', closed, flags, '', line(stop), TIMEOUT)
    if r[0] > 0
      w:parenmatch = matchaddpos('MatchParen', [q, r])
    endif
    return
  endif

  # some methods to match:
  #   - matchbufline(bufnr(), '(', line('.'), line('w$'))
  #   - matchstrlist(getline('.', 'w$'), '(')

  # ( ( ( () ) ) )

  # [bufnum, lnum, col, off]
  var cursor = getpos('.')
  var close_list = matchbufline(bufnr(), close_regex, line('.'), line('w$'))
  var open_list = matchbufline(bufnr(), open_regex, line('w0'), line('.'))

  for i in range(len(close_list))
    var close = close_list[i]
    if close.byteidx + 1 < cursor[2] | continue | endif

    var open_idx = len(open_list) - 1 - i
    if open_idx < 0
      break
    endif

    var open = open_list[open_idx]
    if open.lnum > cursor[1] || (open.lnum == cursor[1] && open.byteidx + 1 > cursor[2])
      continue
    endif

    if open.lnum > 0
      w:parenmatch = matchaddpos('MatchParen', [[open.lnum, open.byteidx + 1], [close.lnum, close.byteidx + 1]])
      echom $'{[open.lnum, open.byteidx + 1]}, {[open.lnum, open.byteidx + 1]}'
      break
    endif

  endfor

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
