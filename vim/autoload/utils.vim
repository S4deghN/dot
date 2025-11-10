vim9script

const script_path = expand('<script>:p:h') .. '/'

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

  if &columns >= 160
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

export def MoveOpenedWindowToSaneSplit()
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

export def OpenWinWithBufPattern(pattern: string)
  var win_to_use = getwininfo()->filter((_, v) => bufname(v.bufnr) =~ pattern)
  if len(win_to_use) > 0
    win_gotoid(win_to_use[0].winid)
  else
    exec 'botright' Vertical() 'new'
  endif
enddef

export def OpenLink(link: string)
    var err = system("setsid xdg-open " .. link .. " &")
    if v:shell_error != 0 | echom err | endif
enddef

export def GetGitBranch(): string
    var branch = system('git branch --show-current 2>/dev/null')
    if len(branch) == 0 && v:shell_error == 0
        branch = system('git describe --all --contains 2>/dev/null')
    endif
    return branch->trim()
enddef

export def SetOpFunc(F: func): string
    &opfunc = F
    return '"' .. v:register .. 'g@'
enddef

export def Operate(op: string, type: string)
    var reg = v:register !=# '"' ? '"' .. v:register : ''
    if type ==# 'v'
        exec 'norm!' .. reg .. op
    else
        var vselect = type ==# "line" ? "'[V']" : "`[v`]"
        var save_vstart = getpos("'<")
        var save_vend = getpos("'>")
        exe 'keepj norm!' vselect .. reg .. op
        setpos("'<", save_vstart)
        setpos("'>", save_vend)
    endif
enddef

export def KeepView(op: string, view: dict<number>, type: string)
    if type ==# 'c'
        exec 'keepj' op
    else
        Operate(op, type)
    endif
    winrestview(view)
enddef

export def JumpToEndOfOp(op: string, type: string)
    if type ==# 'c'
        exec 'keepj' op
    else
        Operate(op, type)
    endif
    keepj normal! `]
enddef



export def BashComplete(partialCommand: string): list<string>
    return systemlist(script_path .. 'bash_completer.sh ' .. partialCommand)
enddef

export def GetVisualSelection(): string
    var mode = mode()
    var start: list<number>
    var end: list<number>

    if mode == 'v' || mode == 'V' || mode == "\<C-V>"
        # getpos() -> [bufnum, lnum, col, off]
        start = getpos('.')
        end = getpos('v')

        if mode == 'V'
            start[2] = 1
            end[2] = 999
        endif
    else
        start = getpos("'<")
        end = getpos("'>")
    endif

    var lines = getline(start[1], end[1])
    if len(lines) <= 0
        return ''
    endif

    lines[-1] = strpart(lines[-1], 0, end[2])
    lines[0] = strpart(lines[0], start[2] - 1)

    var content = join(lines)
    return content
enddef

export def Spotlight(): void
    var savehl = hlget('CursorLine', true)[0]
    var visualhl = hlget('Visual', true)[0]
    var bghl = hlget('Normal', true)[0]
    setl cursorline
    hlset([{name: 'Cursorline', guibg: (visualhl.guibg)}])

    timer_start(300, (_) => {
        const hz = 5
        var t: float = 0.0
        var r1 = str2nr(visualhl.guibg[1 : 2], 16)
        var g1 = str2nr(visualhl.guibg[3 : 4], 16)
        var b1 = str2nr(visualhl.guibg[5 : 6], 16)

        var r2 = str2nr(bghl.guibg[1 : 2], 16)
        var g2 = str2nr(bghl.guibg[3 : 4], 16)
        var b2 = str2nr(bghl.guibg[5 : 6], 16)

        var r3: float
        var g3: float
        var b3: float

        var start = reltime()
        while t < 1
            r3 = (1 - t) * r1 + t * r2
            g3 = (1 - t) * g1 + t * g2
            b3 = (1 - t) * b1 + t * b2
            var color = printf("#%x%x%x", float2nr(r3), float2nr(g3), float2nr(b3))
            hlset([{name: 'Cursorline', guibg: color}])
            redraw
            var loop_time = reltime(start)
            t = atan(reltimefloat(loop_time) * 5)
            # t = pow(reltimefloat(loop_time), 2) * 25
            # t = cos(reltimefloat(loop_time)) * 2
            # echo $'{loop_time}, {t}'
        endwhile

        hlset([{name: 'Cursorline', guibg: savehl.guibg}])
        setl cursorline<
    })
enddef
