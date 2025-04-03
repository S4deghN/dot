vim9script

# Get highlight groups of word under cursor in Vim
export def Syn()
  for id in synstack(line("."), col("."))
    echo synIDattr(id, "name")
  endfor
enddef

export def Time(count: number, ...args: list<string>)
  echom args
  var repeat = (count <= 0 ? 1 : count)
  var k = 0
  var start = reltime()
  while k < repeat
    exe join(args)
    k += 1
  endwhile
  var time = reltimestr(reltime(start))

  redraw

  if repeat == 1
    echomsg "Execution took " .. time .. " sec."
  else
    echomsg repeat .. " repetitions took " .. time .. " sec."
  endif
enddef

export def Vertical(): string
  var result = ''
  # if the overall vim width is too narrow or
  # there are >=2 vertical windows, split below
  if &columns >= 160 && winlayout()[0] != 'row'
    result ..= 'vertical '
  endif
  return result
enddef

export def UseSplitOrCreate(): number
  var current_win_pos = win_screenpos(0)
  var winnr = winnr()

  if &columns > 160
    if winnr != winnr('1l')
      return win_getid(winnr('1l'))
    elseif winnr != winnr('1h')
      return win_getid(winnr('1h'))
    else
      :botright vsplit
      :wincmd p
      return win_getid(winnr('#'))
    endif
  else
    if winnr != winnr('1j')
      return win_getid(winnr('1j'))
    elseif winnr != winnr('1k')
      return win_getid(winnr('1k'))
    else
      :botright split
      :wincmd p
      return win_getid(winnr('#'))
    endif
  endif
enddef

export def MoveOpenedWinodwToSaneSplit()
  var prev_winnr = winnr('#')
  if prev_winnr == 0 | return | endif

  var split_to_use = UseSplitOrCreate()
  if win_getid(prev_winnr) == split_to_use | return | endif

  var bufnr = bufnr('%')
  var view = winsaveview()
  var old_win_id = win_getid()

  win_gotoid(split_to_use)

  exec "buffer " .. bufnr
  winrestview(view)
  win_execute(old_win_id, 'close')
enddef
