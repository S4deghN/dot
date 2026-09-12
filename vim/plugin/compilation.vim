vim9script

if exists('g:loaded_compilation_mode')
  finish
endif
g:loaded_compilation_mode = true

if !has('job') || !has('channel') || !has('timers') || !has('textprop')
    || !exists('*matchbufline') || !exists('*matchstrlist')
    || !exists('*prop_add_list') || !exists('*getbufoneline')
  echoerr 'compilation.vim requires +job, +channel, +timers, +textprop, matchbufline(), matchstrlist(), prop_add_list() and getbufoneline()'
  finish
endif

# --- Configuration and state ---

const COMPILATION_NAME = '[Compilation]'
const OUTPUT_FIRST_LINE = 5
const DIAGNOSTIC_PROP = 'compilation_current_diagnostic'
const SOURCE_LOCATION_PROP = 'compilation_source_location'
const VERTICAL_MIN_WIDTH = 80
const WORK_INTERVAL = 1
const SCAN_CHUNK = 64
const ANSI_CHUNK = 64
const ANSI_BOLD = 1
const ANSI_ITALIC = 2
const ANSI_UNDERLINE = 4
const ANSI_STYLE_COUNT = 257 * 8
const ANSI_ESCAPE_PATTERN = '\%x1b\[[0-?]*[ -/]*[@-~]\|\%x1b\][^\%x07]*\%x07'

highlight default link CompilationCurrentDiagnostic CursorLine
prop_type_add(DIAGNOSTIC_PROP, {
  highlight: 'CompilationCurrentDiagnostic',
  combine: true,
  priority: 10,
})
# Invisible zero-width markers in source buffers.  Their IDs are compilation
# buffer line numbers, which are unique within one compilation run.
prop_type_add(SOURCE_LOCATION_PROP, {})

# A matcher is deliberately simple: PATTERN plus capture-group indices for
# filename, line and optional column.  User matchers in g:compilation_matchers
# use the same shape and are tried before these defaults.
#
# These defaults cover the common workhorses from Emacs compilation mode:
# GNU-style compiler/grep output, MSVC-style C/C++, Bash, ShellCheck, Python
# tracebacks and CMake.  They are intentionally stateless and single-line.
const DEFAULT_MATCHERS = [
  # Python traceback:   File "foo.py", line 12, in func
  {name: 'python', pattern: '\v^\s*File "([^"]+)", line ([1-9]\d*)', file: 1, line: 2, col: 0},

  # ShellCheck: In script.sh line 12:
  {name: 'shellcheck', pattern: '\v^In (.+) line ([1-9]\d*):', file: 1, line: 2, col: 0},

  # Bash: script.sh: line 12: syntax error ...
  {name: 'bash', pattern: '\v^(.+): line ([1-9]\d*):', file: 1, line: 2, col: 0},

  # GCC/Clang include chain: In file included from foo.h:12:3:
  {name: 'include', pattern: '\v^(In file included from |[ \t]*from )(.{-}):([1-9]\d*)(:([1-9]\d*))?:', file: 2, line: 3, col: 5},

  # CMake Error/Warning at path/file.cmake:12 (...):
  {name: 'cmake', pattern: '\v^CMake (Error|Warning) at (.{-}):([1-9]\d*)($|\s)', file: 2, line: 3, col: 0},

  # MSVC/EDG-style: file.cpp(12,34): error ... / file.cpp(12): ...
  {name: 'msvc-col', pattern: '\v^\s*(.{-})\(([1-9]\d*),\s*([1-9]\d*)\)\s*:', file: 1, line: 2, col: 3},
  {name: 'msvc-line', pattern: '\v^\s*(.{-})\(([1-9]\d*)\)\s*:', file: 1, line: 2, col: 0},

  # GNU/Clang/GCC and simple grep/ripgrep output.  The dot-column form mirrors
  # the second GNU syntax accepted by Emacs's broad `gnu' matcher.
  {name: 'gnu-dot-col', pattern: '\v^\s*(.{-}):([1-9]\d*)\.([1-9]\d*):\s*.*$', file: 1, line: 2, col: 3},
  {name: 'gnu-col', pattern: '\v^\s*(.{-}):([1-9]\d*):([1-9]\d*):\s*.*$', file: 1, line: 2, col: 3},
  {name: 'gnu-line', pattern: '\v^\s*(.{-}):([1-9]\d*):\s*.*$', file: 1, line: 2, col: 0},
]
var compilation_bufnr = -1
var compilation_job: job = null_job
var last_command = ''
var run_cwd = ''
var active_matchers: list<dict<any>> = []
var last_jump_line = 0
var run_number = 0
var exit_received = false
var exit_status = 0
var exit_signal = ''
var channel_closed = false
var finish_written = false
var sentinel_lnum = 0
var run_started: list<any> = []
var run_elapsed = 0.0
var pending_output = ''

# Incremental diagnostic index.  The scanner visits compilation lines only in
# increasing order, so prev/next links are built without sorting.
var scan_lnum = OUTPUT_FIRST_LINE
var worker_timer = -1
var diagnostics_by_line: dict<dict<any>> = {}
var diagnostics_by_file: dict<list<number>> = {}
var first_diagnostic_line = 0
var last_diagnostic_line = 0

# Files whose scanned diagnostics have been materialized as moving source
# properties.  The value is the source buffer number and also gives us a cheap
# cleanup list for the next compilation.
var anchored_files: dict<number> = {}

# ANSI coloring is intentionally narrower than a terminal emulator: foreground
# color plus bold/italic/underline.  The raw output queue is always populated;
# plain lines are cheap for the background worker to skip.
var ansi_fg = -1
var ansi_attrs = 0
var ansi_types = repeat([''], ANSI_STYLE_COUNT)
var ansi_lines: list<string> = []
var ansi_line_index = 0
var ansi_first_lnum = 0

def IsCompilationBuffer(bufnr: number): bool
  return bufnr > 0 && bufnr == compilation_bufnr
enddef

# --- Compilation buffer ---

def EnsureBuffer(): number
  if compilation_bufnr > 0 && bufexists(compilation_bufnr)
    return compilation_bufnr
  endif

  compilation_bufnr = bufadd(COMPILATION_NAME)
  bufload(compilation_bufnr)
  setbufvar(compilation_bufnr, '&buftype', 'nofile')
  setbufvar(compilation_bufnr, '&bufhidden', 'hide')
  setbufvar(compilation_bufnr, '&buflisted', 0)
  setbufvar(compilation_bufnr, '&swapfile', 0)
  setbufvar(compilation_bufnr, '&filetype', 'compilation')
  return compilation_bufnr
enddef

def SetBufferLines(lines: list<string>): void
  var b = EnsureBuffer()

  # The final empty line is a permanent sentinel while the job runs: output
  # is inserted immediately before it, so a window whose cursor is on the
  # sentinel naturally follows new output.
  deletebufline(b, 1, '$')

  setbufline(b, 1, lines)
  appendbufline(b, '$', '')
  sentinel_lnum = len(lines) + 1
enddef

def AppendBufferLines(lines: list<string>): number
  if empty(lines)
    return 0
  endif
  var first_lnum = sentinel_lnum
  appendbufline(compilation_bufnr, first_lnum - 1, lines)
  sentinel_lnum += len(lines)
  return first_lnum
enddef

def AppendBufferLine(text: string): number
  return AppendBufferLines([text])
enddef

# --- Window management ---

def CanReplaceWindow(winid: number): bool
  if win_id2win(winid) == 0
    return false
  endif
  var info = getwininfo(winid)
  if empty(info) || info[0].tabnr != tabpagenr()
    return false
  endif
  var b = info[0].bufnr
  if IsCompilationBuffer(b)
    return true
  endif
  return !getbufvar(b, '&modified') || getbufvar(b, '&hidden')
enddef

def LayoutHasVertical(layout: list<any>): bool
  if empty(layout)
    return false
  endif
  if layout[0] ==# 'row'
    return true
  endif
  if layout[0] !=# 'col'
    return false
  endif
  for child in layout[1]
    if LayoutHasVertical(child)
      return true
    endif
  endfor
  return false
enddef

def TabHasVerticalSplit(): bool
  return LayoutHasVertical(winlayout())
enddef

def VerticalPeerWindows(winid: number): list<number>
  var current_info = getwininfo(winid)
  if empty(current_info)
    return []
  endif
  var cur = current_info[0]
  var peers: list<dict<any>> = []
  for info in getwininfo()
    if info.tabnr != tabpagenr() || info.winid == winid
      continue
    endif
    # A window in another vertical partition lies wholly to the left or right
    # of the current window.  Prefer the nearest such partition.
    var cur_left = cur.wincol
    var cur_right = cur.wincol + cur.width - 1
    var other_left = info.wincol
    var other_right = info.wincol + info.width - 1
    if other_right < cur_left
      peers->add({winid: info.winid, distance: cur_left - other_right})
    elseif other_left > cur_right
      peers->add({winid: info.winid, distance: other_left - cur_right})
    endif
  endfor
  peers->sort((a, b) => a.distance - b.distance)
  return peers->mapnew((_, v) => v.winid)
enddef

def CreatePreferredSplit(for_compilation: bool = false): number
  # Keep at most one vertical partition in the tab.
  if !TabHasVerticalSplit() && &columns / 2 >= VERTICAL_MIN_WIDTH
    if for_compilation
      botright vsplit
    else
      aboveleft vsplit
    endif
  else
    if for_compilation
      botright split
    else
      aboveleft split
    endif
  endif
  return win_getid()
enddef

def PickCompilationWindow(): number
  var current = win_getid()

  var visible = win_findbuf(EnsureBuffer())
  if !empty(visible)
    return visible[0]
  endif

  if TabHasVerticalSplit()
    for winid in VerticalPeerWindows(current)
      if CanReplaceWindow(winid)
        return winid
      endif
    endfor
  endif

  if !IsCompilationBuffer(bufnr()) && &buftype !=# '' && &buftype !=# 'terminal'
    && &buftype !=# 'quickfix' && CanReplaceWindow(current)
    return current
  endif

  if !TabHasVerticalSplit()
    return CreatePreferredSplit(true)
  endif

  var ordinary = -1
  for info in getwininfo()
    if info.tabnr != tabpagenr() || info.winid == current || IsCompilationBuffer(info.bufnr)
      continue
    endif
    if !CanReplaceWindow(info.winid)
      continue
    endif
    var bt = getbufvar(info.bufnr, '&buftype')
    if bt !=# '' && bt !=# 'terminal' && bt !=# 'quickfix'
      return info.winid
    endif
    if ordinary == -1 && bt ==# ''
      ordinary = info.winid
    endif
  endfor
  if ordinary != -1
    return ordinary
  endif

  return CreatePreferredSplit(true)
enddef

def ConfigureCompilationWindow(): void
  setlocal wrap
  setlocal nonumber norelativenumber
  setlocal signcolumn=no
  setlocal foldcolumn=0
  setlocal nofoldenable foldmethod=manual
  setlocal nocursorline nocursorcolumn
  setlocal nospell
  if exists('+smoothscroll')
    setlocal nosmoothscroll
  endif
  nnoremap <silent> <buffer> <CR>  <ScriptCmd>OpenAtCursor()<CR>
  nnoremap <silent> <buffer> i     <ScriptCmd>CompilationInput()<CR>
  nnoremap <silent> <buffer> q     <ScriptCmd>CompilationToggle()<CR>
  nnoremap <silent> <buffer> <C-c> <ScriptCmd>CompilationStop()<CR>
enddef

def CompilationWidth(): number
  var wins = VisibleBufferWindows(EnsureBuffer())
  if !empty(wins)
    var info = getwininfo(wins[0])
    if !empty(info)
      return max([1, info[0].width])
    endif
  endif
  return max([1, &columns])
enddef

def VisibleBufferWindows(bufnr: number): list<number>
  var result: list<number> = []
  for winid in win_findbuf(bufnr)
    var info = getwininfo(winid)
    if !empty(info) && info[0].tabnr == tabpagenr()
      result->add(winid)
    endif
  endfor
  return result
enddef

def OpenCompilation(focus: bool = false): void
  var b = EnsureBuffer()
  var wins = VisibleBufferWindows(b)
  if !empty(wins)
    win_execute(wins[0], 'normal! G')
    if focus
      win_gotoid(wins[0])
    endif
    return
  endif

  var source = win_getid()
  var target = PickCompilationWindow()
  if win_id2win(target) == 0 || !win_gotoid(target)
    target = CreatePreferredSplit(true)
  endif
  execute $'buffer {b}'
  ConfigureCompilationWindow()
  normal! G

  if !focus && win_id2win(source) != 0
    win_gotoid(source)
  endif
enddef

def CompilationToggle(): void
  var b = EnsureBuffer()
  var wins = VisibleBufferWindows(b)
  if !empty(wins)
    if tabpagewinnr(tabpagenr(), '$') == 1 && IsCompilationBuffer(bufnr())
      enew
      return
    endif
    var current = win_getid()
    for winid in wins
      if win_id2win(winid) != 0
        win_execute(winid, 'close')
      endif
    endfor
    if win_id2win(current) != 0
      win_gotoid(current)
    endif
    return
  endif
  OpenCompilation(true)
enddef

# --- ANSI decoding and text properties ---

def ResetAnsi(): void
  ansi_fg = -1
  ansi_attrs = 0
enddef

def CurrentAnsiStyle(): number
  return ansi_fg + 1 + 257 * ansi_attrs
enddef

def SetAnsiAttr(bit: number, enabled: bool): void
  var set = and(ansi_attrs, bit) != 0
  if enabled && !set
    ansi_attrs += bit
  elseif !enabled && set
    ansi_attrs -= bit
  endif
enddef

def ApplySimpleSgr(p: number): void
  if p == 0
    ResetAnsi()
  elseif p == 1
    SetAnsiAttr(ANSI_BOLD, true)
  elseif p == 3
    SetAnsiAttr(ANSI_ITALIC, true)
  elseif p == 4
    SetAnsiAttr(ANSI_UNDERLINE, true)
  elseif p == 22
    SetAnsiAttr(ANSI_BOLD, false)
  elseif p == 23
    SetAnsiAttr(ANSI_ITALIC, false)
  elseif p == 24
    SetAnsiAttr(ANSI_UNDERLINE, false)
  elseif p >= 30 && p <= 37
    ansi_fg = p - 30
  elseif p == 39
    ansi_fg = -1
  elseif p >= 90 && p <= 97
    ansi_fg = p - 90 + 8
  endif
enddef

def ApplySgr(params_text: string): void
  if params_text ==# ''
    ResetAnsi()
    return
  endif
  if stridx(params_text, ';') < 0
    ApplySimpleSgr(str2nr(params_text))
    return
  endif

  var params = split(params_text, ';', true)
  var i = 0
  while i < len(params)
    var p = str2nr(params[i])
    if p == 38 && i + 2 < len(params) && str2nr(params[i + 1]) == 5
      ansi_fg = str2nr(params[i + 2])
      i += 2
    elseif (p == 38 || p == 48) && i + 4 < len(params) && str2nr(params[i + 1]) == 2
      # Truecolor is intentionally unsupported; consume the whole sequence so
      # later parameters stay aligned.
      i += 4
    elseif p == 48 && i + 2 < len(params) && str2nr(params[i + 1]) == 5
      # Background colors are intentionally unsupported.
      i += 2
    else
      ApplySimpleSgr(p)
    endif
    i += 1
  endwhile
enddef

def EnsureAnsiPropType(style: number): string
  if ansi_types[style] !=# ''
    return ansi_types[style]
  endif

  var attrs_bits = style / 257
  var fg = style % 257 - 1
  var attrs: list<string> = []
  if and(attrs_bits, ANSI_BOLD) != 0 | attrs->add('bold') | endif
  if and(attrs_bits, ANSI_ITALIC) != 0 | attrs->add('italic') | endif
  if and(attrs_bits, ANSI_UNDERLINE) != 0 | attrs->add('underline') | endif
  var attr_text = empty(attrs) ? 'NONE' : join(attrs, ',')
  var group = $'CompilationAnsi{style}'
  var type_name = $'compilation_ansi_{style}'
  var command = $'highlight {group} cterm={attr_text} gui={attr_text}'
  if fg >= 0
    command ..= $' ctermfg={fg}'
  endif
  execute command
  prop_type_add(type_name, {
    highlight: group,
    combine: true,
    priority: 20,
  })
  ansi_types[style] = type_name
  return type_name
enddef

def AddAnsiPosition(positions: dict<any>, style: number, lnum: number, col: number, length: number): void
  if style == 0 || length <= 0
    return
  endif
  var key = string(style)
  if !has_key(positions, key)
    positions[key] = []
  endif
  var items = positions[key]
  if !empty(items) && items[-1][0] == lnum && items[-1][3] == col
    items[-1][3] = col + length
  else
    items->add([lnum, col, lnum, col + length])
  endif
enddef

def ApplyAnsiPositions(positions: dict<any>): void
  for [style, items] in items(positions)
    if !empty(items)
      prop_add_list({
        bufnr: compilation_bufnr,
        type: EnsureAnsiPropType(str2nr(style)),
      }, items)
    endif
  endfor
enddef

def ColorizeLines(raw_lines: list<string>, first_lnum: number): void
  var escapes = matchstrlist(raw_lines, ANSI_ESCAPE_PATTERN)
  if empty(escapes) && CurrentAnsiStyle() == 0
    return
  endif

  var positions: dict<any> = {}
  var escape_i = 0
  for line_i in range(len(raw_lines))
    var raw = raw_lines[line_i]
    var content_end = strlen(raw)
    if content_end > 0 && raw[-1] ==# "\r"
      content_end -= 1
    endif
    var raw_pos = 0
    var hidden = 0
    var lnum = first_lnum + line_i

    while escape_i < len(escapes) && escapes[escape_i].idx == line_i
      var match = escapes[escape_i]
      var start = match.byteidx
      if start > raw_pos
        AddAnsiPosition(positions, CurrentAnsiStyle(), lnum,
          raw_pos - hidden + 1, min([start, content_end]) - raw_pos)
      endif

      var esc = match.text
      var esc_len = strlen(esc)
      if esc_len >= 3 && esc[0] ==# "\e" && esc[1] ==# '[' && esc[-1] ==# 'm'
        ApplySgr(strpart(esc, 2, esc_len - 3))
      endif
      hidden += esc_len
      raw_pos = start + esc_len
      escape_i += 1
    endwhile

    if content_end > raw_pos
      AddAnsiPosition(positions, CurrentAnsiStyle(), lnum,
        raw_pos - hidden + 1, content_end - raw_pos)
    endif
  endfor

  ApplyAnsiPositions(positions)
enddef

# --- Diagnostic matching, indexing and source anchors ---

def ClearDiagnosticHighlight(): void
  if compilation_bufnr <= 0 || !bufloaded(compilation_bufnr)
    return
  endif
  prop_remove({
    bufnr: compilation_bufnr,
    type: DIAGNOSTIC_PROP,
    all: true,
  })
enddef

def HighlightCompilationLine(lnum: number): void
  ClearDiagnosticHighlight()
  if lnum < OUTPUT_FIRST_LINE
    return
  endif
  var text = getbufoneline(compilation_bufnr, lnum)
  prop_add(lnum, 1, {
    bufnr: compilation_bufnr,
    type: DIAGNOSTIC_PROP,
    length: max([1, strlen(text)]),
  })
enddef

def BuildMatchers(): list<dict<any>>
  var result: list<dict<any>> = []
  var configured: any = get(g:, 'compilation_matchers', [])
  if type(configured) != v:t_list
    echoerr 'g:compilation_matchers must be a List of matcher dictionaries'
  else
    for matcher in configured
      if type(matcher) != v:t_dict
          || type(get(matcher, 'pattern', 0)) != v:t_string
          || type(get(matcher, 'file', 0)) != v:t_number
          || type(get(matcher, 'line', 0)) != v:t_number
        echoerr 'g:compilation_matchers entries require pattern, file and line'
        continue
      endif
      result->add(copy(matcher))
    endfor
  endif
  result->extend(DEFAULT_MATCHERS)
  return result
enddef

def MatchDiagnostic(text: string): dict<any>
  for matcher in active_matchers
    var match = matchlist(text, matcher.pattern)
    if empty(match)
      continue
    endif

    var file_i = matcher.file
    var line_i = matcher.line
    var col_i = get(matcher, 'col', 0)
    if file_i <= 0 || line_i <= 0 || file_i >= len(match) || line_i >= len(match)
      continue
    endif

    var file = match[file_i]
    var lnum = str2nr(match[line_i])
    var col = col_i > 0 && col_i < len(match) ? str2nr(match[col_i]) : 1

    # Emacs's GNU matcher similarly rejects implausible all-numeric filenames;
    # this also avoids treating timestamps such as 12:34:56 as diagnostics.
    if file ==# '' || file =~# '\v^\d+$' || file =~# '^<.*>$' || lnum <= 0
      continue
    endif
    return {file: file, lnum: lnum, col: max([1, col])}
  endfor
  return {}
enddef

def DiagnosticAt(lnum: number): dict<any>
  return MatchDiagnostic(getbufoneline(compilation_bufnr, lnum))
enddef

def ResolveDiagnosticPath(file: string): string
  if file =~# '^/' || file =~# '^\a:[/\\]'
    return simplify(file)
  endif
  return simplify(run_cwd .. '/' .. file)
enddef

def ClearSourceAnchors(): void
  var seen: dict<bool> = {}
  for b in values(anchored_files)
    if b <= 0 || !bufexists(b) || has_key(seen, string(b))
      continue
    endif
    seen[string(b)] = true
    prop_remove({
      bufnr: b,
      type: SOURCE_LOCATION_PROP,
      all: true,
    })
  endfor
  anchored_files = {}
enddef

def ResetDiagnosticIndex(): void
  diagnostics_by_line = {}
  diagnostics_by_file = {}
  first_diagnostic_line = 0
  last_diagnostic_line = 0
  scan_lnum = OUTPUT_FIRST_LINE
enddef

def FindSourceAnchor(bufnr: number, id: number): dict<any>
  if bufnr <= 0 || !bufexists(bufnr)
    return {}
  endif
  return prop_find({
    bufnr: bufnr,
    lnum: 1,
    col: 1,
    type: SOURCE_LOCATION_PROP,
    id: id,
    both: true,
  }, 'f')
enddef

def ClampSourcePosition(bufnr: number, lnum: number, col: number): list<number>
  bufload(bufnr)
  var info = getbufinfo(bufnr)
  var last = empty(info) ? 1 : max([1, info[0].linecount])
  var line = min([max([1, lnum]), last])
  var last_col = strlen(getbufoneline(bufnr, line)) + 1
  return [line, min([max([1, col]), last_col])]
enddef

def EstimatedSourceLine(file: string, bufnr: number, compilation_lnum: number): number
  var diagnostic = diagnostics_by_line[string(compilation_lnum)]
  var nearest = 0
  var nearest_distance = 0x7fffffff

  for other_lnum in get(diagnostics_by_file, file, [])
    if other_lnum == compilation_lnum || !has_key(diagnostics_by_line, string(other_lnum))
      continue
    endif
    var other = diagnostics_by_line[string(other_lnum)]
    var distance = abs(other.lnum - diagnostic.lnum)
    if distance < nearest_distance
      nearest = other_lnum
      nearest_distance = distance
    endif
  endfor

  if nearest > 0
    var anchor = FindSourceAnchor(bufnr, nearest)
    if !empty(anchor)
      var other = diagnostics_by_line[string(nearest)]
      return anchor.lnum + diagnostic.lnum - other.lnum
    endif
  endif
  return diagnostic.lnum
enddef

def AddRawSourceAnchor(bufnr: number, id: number, lnum: number, col: number): void
  var pos = ClampSourcePosition(bufnr, lnum, col)
  prop_add(pos[0], pos[1], {
    bufnr: bufnr,
    type: SOURCE_LOCATION_PROP,
    id: id,
    length: 0,
  })
enddef

def AddSourceAnchor(file: string, bufnr: number, compilation_lnum: number): void
  var diagnostic = diagnostics_by_line[string(compilation_lnum)]
  var target_lnum = has_key(anchored_files, file)
    ? EstimatedSourceLine(file, bufnr, compilation_lnum)
    : diagnostic.lnum
  AddRawSourceAnchor(bufnr, compilation_lnum, target_lnum, diagnostic.col)
enddef

def MaterializeFileAnchors(file: string, bufnr: number): void
  if get(anchored_files, file, -1) == bufnr
    return
  endif

  bufload(bufnr)
  var info = getbufinfo(bufnr)
  var last = empty(info) ? 1 : max([1, info[0].linecount])
  var positions: list<list<number>> = []
  for compilation_lnum in get(diagnostics_by_file, file, [])
    var diagnostic = diagnostics_by_line[string(compilation_lnum)]
    var line = min([max([1, diagnostic.lnum]), last])
    var col = min([max([1, diagnostic.col]), strlen(getbufoneline(bufnr, line)) + 1])
    positions->add([line, col, line, col, compilation_lnum])
  endfor
  if !empty(positions)
    prop_add_list({bufnr: bufnr, type: SOURCE_LOCATION_PROP}, positions)
  endif

  # Later diagnostics discovered for this file are placed relative to these
  # moving anchors if source edits have shifted the original locations.
  anchored_files[file] = bufnr
enddef

def IndexDiagnostic(lnum: number, diagnostic: dict<any>): void
  var key = string(lnum)
  if has_key(diagnostics_by_line, key)
    return
  endif

  var file = ResolveDiagnosticPath(diagnostic.file)
  var record = {
    file: file,
    lnum: diagnostic.lnum,
    col: diagnostic.col,
    prev: last_diagnostic_line,
    next: 0,
  }
  diagnostics_by_line[key] = record

  if last_diagnostic_line > 0
    diagnostics_by_line[string(last_diagnostic_line)].next = lnum
  else
    first_diagnostic_line = lnum
  endif
  last_diagnostic_line = lnum

  if !has_key(diagnostics_by_file, file)
    diagnostics_by_file[file] = []
  endif
  diagnostics_by_file[file]->add(lnum)

  if has_key(anchored_files, file)
    var b = anchored_files[file]
    if b > 0 && bufexists(b)
      AddSourceAnchor(file, b, lnum)
    else
      remove(anchored_files, file)
    endif
  endif
enddef

def ScannableEnd(): number
  if compilation_bufnr <= 0 || !bufexists(compilation_bufnr)
    return 0
  endif
  if finish_written
    return sentinel_lnum + 1
  endif
  # Output is inserted immediately before the moving sentinel.  Never advance
  # the scan frontier past that insertion point while the producer is active.
  return max([OUTPUT_FIRST_LINE - 1, sentinel_lnum - 1])
enddef

def ScanChunk(): void
  var scan_end = ScannableEnd()
  if scan_lnum > scan_end
    return
  endif

  var final = min([scan_end, scan_lnum + SCAN_CHUNK - 1])
  var lines = getbufline(compilation_bufnr, scan_lnum, final)
  var lnum = scan_lnum
  for text in lines
    var diagnostic = MatchDiagnostic(text)
    if !empty(diagnostic)
      IndexDiagnostic(lnum, diagnostic)
    endif
    lnum += 1
  endfor
  scan_lnum += len(lines)
enddef

def ColorizeChunk(): void
  var remaining = len(ansi_lines) - ansi_line_index
  if remaining <= 0
    return
  endif

  var count = min([ANSI_CHUNK, remaining])
  var last = ansi_line_index + count - 1
  ColorizeLines(ansi_lines[ansi_line_index : last], ansi_first_lnum + ansi_line_index)
  ansi_line_index += count

  if ansi_line_index >= len(ansi_lines)
    ansi_lines = []
    ansi_line_index = 0
    ansi_first_lnum = 0
  endif
enddef

def WorkerDone(): bool
  return finish_written
    && scan_lnum > ScannableEnd()
    && empty(ansi_lines)
enddef

def StopWorker(): void
  if worker_timer >= 0
    timer_stop(worker_timer)
    worker_timer = -1
  endif
enddef

def WorkerTick(generation: number, timer: number): void
  if generation != run_number || compilation_bufnr <= 0 || !bufloaded(compilation_bufnr)
    timer_stop(timer)
    if worker_timer == timer
      worker_timer = -1
    endif
    return
  endif

  ScanChunk()
  ColorizeChunk()

  if WorkerDone()
    timer_stop(timer)
    if worker_timer == timer
      worker_timer = -1
    endif
  endif
enddef

def StartWorker(generation: number): void
  StopWorker()
  worker_timer = timer_start(WORK_INTERVAL, (timer) => WorkerTick(generation, timer), {repeat: -1})
enddef

def StripAnsi(raw_line: string): string
  var text = raw_line
  if text !=# '' && text[-1] ==# "\r"
    text = strpart(text, 0, strlen(text) - 1)
  endif
  return stridx(text, "\e") < 0
    ? text
    : text->substitute(ANSI_ESCAPE_PATTERN, '', 'g')
enddef

def QueueAnsiLines(first_lnum: number, raw_lines: list<string>): void
  if empty(raw_lines)
    return
  endif
  if empty(ansi_lines)
    ansi_first_lnum = first_lnum
    ansi_line_index = 0
  endif
  ansi_lines->extend(raw_lines)
enddef

def AppendOutputLines(raw_lines: list<string>): void
  if empty(raw_lines)
    return
  endif

  # Preserve the raw strings for deferred coloring, then reuse this same List
  # as the stripped text passed to appendbufline().  extend() copies List
  # entries, so replacing raw_lines items below does not modify the queue.
  var first_lnum = sentinel_lnum
  QueueAnsiLines(first_lnum, raw_lines)
  raw_lines->map((_, raw) => StripAnsi(raw))
  AppendBufferLines(raw_lines)
enddef

def OnOutput(generation: number, _ch: channel, msg: string): void
  if generation != run_number
    return
  endif
  pending_output ..= msg
  FlushOutput(generation)
enddef

def FlushOutput(generation: number): void
  if generation != run_number || pending_output ==# ''
    return
  endif

  # Render only complete lines.  Keep the unfinished suffix for the next raw
  # channel chunk, which also keeps split ANSI escapes intact.
  var last_nl = strridx(pending_output, "\n")
  if last_nl < 0
    return
  endif

  var complete = strpart(pending_output, 0, last_nl)
  pending_output = strpart(pending_output, last_nl + 1)
  AppendOutputLines(split(complete, "\n", true))
enddef

def FlushOutputTail(generation: number): void
  FlushOutput(generation)
  if generation != run_number || pending_output ==# ''
    return
  endif
  var tail = pending_output
  pending_output = ''
  AppendOutputLines([tail])
enddef

# --- Process lifecycle ---

def ApplyTerminalColor(lnum: number, col: number, length: number, color: number): void
  if length <= 0
    return
  endif
  prop_add(lnum, col, {
    bufnr: compilation_bufnr,
    type: EnsureAnsiPropType(color + 1),
    length: length,
  })
enddef

def SignalDescription(status: number): string
  # A command executed through a POSIX shell conventionally reports a signal as
  # 128 + signal-number.  Use the familiar process-status wording Emacs shows.
  if status < 129 || status > 192
    return ''
  endif
  const names = {
    1: 'hangup',
    2: 'interrupt',
    3: 'quit',
    4: 'illegal instruction',
    5: 'trace/breakpoint trap',
    6: 'aborted',
    7: 'bus error',
    8: 'floating point exception',
    9: 'killed',
    11: 'segmentation fault',
    13: 'broken pipe',
    14: 'alarm clock',
    15: 'terminated',
    31: 'bad system call',
  }
  return get(names, status - 128, '')
enddef

def MaybeFinish(generation: number): void
  if generation != run_number || finish_written || !exit_received || !channel_closed
    return
  endif
  finish_written = true

  var elapsed = run_elapsed
  var suffix = ''
  if exit_status == -1
    suffix = exit_signal ==# '' ? ' (terminated by signal)' : $' (terminated by {toupper(exit_signal)})'
  else
    var description = SignalDescription(exit_status)
    suffix = description ==# '' ? '' : $' ({description})'
  endif

  # Keep the sentinel as the blank separator between process output and the
  # footer.  All producer-owned text is complete before normal undo resumes.
  var plain = printf('%.2fs - exit %d%s', elapsed, exit_status, suffix)
  appendbufline(compilation_bufnr, '$', plain)
  var lnum = sentinel_lnum + 1
  var prefix = printf('%.2fs - exit ', elapsed)
  ApplyTerminalColor(lnum, strlen(prefix) + 1, strlen(string(exit_status)), exit_status == 0 ? 2 : 1)
  setbufvar(compilation_bufnr, '&undolevels', &g:undolevels)
  setbufvar(compilation_bufnr, '&modifiable', 0)
enddef

def OnExit(generation: number, job: job, status: number): void
  if generation != run_number
    return
  endif
  run_elapsed = empty(run_started) ? 0.0 : reltimefloat(reltime(run_started))
  exit_received = true
  exit_status = status
  exit_signal = status == -1 ? get(job_info(job), 'termsig', '') : ''
  MaybeFinish(generation)
enddef

def OnClose(generation: number, _ch: channel): void
  if generation != run_number
    return
  endif
  FlushOutputTail(generation)
  channel_closed = true
  MaybeFinish(generation)
enddef

def StopRunningJob(): bool
  if compilation_job == null_job || job_status(compilation_job) !=# 'run'
    return true
  endif
  var answer = confirm('A compilation is already running. Kill it?', "&Yes\n&No", 2)
  if answer != 1
    return false
  endif
  job_stop(compilation_job, 'int')
  return true
enddef

def CompilationInput(): void
  if compilation_job == null_job || job_status(compilation_job) !=# 'run'
    echo 'No compilation is running'
    return
  endif

  inputsave()
  var text = ''
  try
    text = inputsecret('Input: ')
  finally
    inputrestore()
  endtry

  try
    ch_sendraw(compilation_job, text .. "\n")
  catch
    echohl ErrorMsg
    echomsg 'Compilation input is no longer available'
    echohl None
  endtry
enddef

def StartCompilation(command: string): void
  if command ==# ''
    return
  endif

  if !StopRunningJob()
    return
  endif

  # The old background worker must be gone before any state or buffer contents
  # are reset.  Old job callbacks are rejected by run_number after increment.
  StopWorker()
  ClearSourceAnchors()
  run_number += 1
  var generation = run_number
  last_command = command
  run_cwd = getcwd()
  active_matchers = BuildMatchers()
  last_jump_line = 0
  ResetDiagnosticIndex()
  exit_received = false
  exit_status = 0
  exit_signal = ''
  channel_closed = false
  finish_written = false
  run_started = []
  run_elapsed = 0.0
  pending_output = ''
  ansi_lines = []
  ansi_line_index = 0
  ansi_first_lnum = 0
  ResetAnsi()

  var b = EnsureBuffer()
  setbufvar(b, '&modifiable', 1)
  ClearDiagnosticHighlight()
  # Producer-owned changes do not enter undo history.  MaybeFinish() restores
  # the local value from the global setting after writing the footer.
  setbufvar(b, '&undolevels', -1)

  var header = [
    $'Compilation started at {strftime("%Y-%m-%d %H:%M:%S")}',
    $'Directory: {run_cwd}',
    $'$ {command}',
    '',
  ]
  SetBufferLines(header)
  ApplyTerminalColor(3, 1, 1, 2)
  OpenCompilation(false)
  var terminal_width = CompilationWidth()

  # Put stderr on the PTY too, so auto-color diagnostics (notably GCC) work.
  var pty_command = 'exec 2>&1; ' .. command
  run_started = reltime()
  compilation_job = job_start([&shell, &shellcmdflag, pty_command], {
    cwd: run_cwd,
    pty: true,
    env: {
      TERM: 'xterm-256color',
      COLUMNS: string(terminal_width),
    },
    in_io: 'pipe',
    out_mode: 'raw',
    err_io: 'out',
    out_cb: (ch, msg) => OnOutput(generation, ch, msg),
    close_cb: (ch) => OnClose(generation, ch),
    exit_cb: (j, status) => OnExit(generation, j, status),
    stoponexit: 'term',
  })

  StartWorker(generation)

  if job_status(compilation_job) ==# 'fail'
    run_elapsed = empty(run_started) ? 0.0 : reltimefloat(reltime(run_started))
    exit_received = true
    exit_status = 127
    exit_signal = ''
    channel_closed = true
    AppendBufferLine($'Could not start: {command}')
    MaybeFinish(generation)
  endif
enddef

def Compile(args: string): void
  if args !=# ''
    StartCompilation(args)
    return
  endif

  var seed = last_command
  if seed ==# ''
    seed = &makeprg
  endif
  feedkeys(':Compile ' .. seed, 'n')
enddef

def CompileAgain(): void
  if last_command ==# ''
    Compile('')
    return
  endif
  StartCompilation(last_command)
enddef

def CompilationStop(sig = "term"): void
  if compilation_job == null_job || job_status(compilation_job) !=# 'run'
    echo 'No compilation is running'
    return
  endif
  job_stop(compilation_job, sig)
enddef

# --- Source navigation ---

def PickTargetWindow(target_bufnr: number): number
  var current = win_getid()

  var exact = VisibleBufferWindows(target_bufnr)
  if !empty(exact)
    return exact[0]
  endif

  if !IsCompilationBuffer(bufnr()) && &buftype ==# '' && CanReplaceWindow(current)
    return current
  endif

  if TabHasVerticalSplit()
    for winid in VerticalPeerWindows(current)
      var info = getwininfo(winid)
      if !empty(info) && !IsCompilationBuffer(info[0].bufnr)
          && getbufvar(info[0].bufnr, '&buftype') ==# '' && CanReplaceWindow(winid)
        return winid
      endif
    endfor
  endif

  var fallback = -1
  for info in getwininfo()
    if info.tabnr != tabpagenr() || info.winid == current || IsCompilationBuffer(info.bufnr)
      continue
    endif
    if getbufvar(info.bufnr, '&buftype') ==# '' && CanReplaceWindow(info.winid)
      return info.winid
    endif
    if fallback == -1 && getbufvar(info.bufnr, '&buftype') !=# 'quickfix'
        && CanReplaceWindow(info.winid)
      fallback = info.winid
    endif
  endfor
  return fallback != -1 ? fallback : CreatePreferredSplit(false)
enddef

def OpenSourcePosition(path: string, lnum: number, col: number, compilation_lnum: number): bool
  if !filereadable(path) && bufnr(path) <= 0
    return false
  endif

  var target_bufnr = bufadd(path)
  bufload(target_bufnr)
  var target = PickTargetWindow(target_bufnr)
  if win_id2win(target) == 0 || !win_gotoid(target)
    return false
  endif
  if &modified && !&hidden && bufnr() != target_bufnr
    target = CreatePreferredSplit(false)
  endif
  execute $'buffer {target_bufnr}'

  cursor(lnum, col)
  normal! zv
  normal! zz

  last_jump_line = compilation_lnum
  HighlightCompilationLine(compilation_lnum)
  return true
enddef

def JumpScannedDiagnostic(compilation_lnum: number): bool
  var key = string(compilation_lnum)
  if !has_key(diagnostics_by_line, key)
    return false
  endif

  var diagnostic = diagnostics_by_line[key]
  var path = diagnostic.file
  if !filereadable(path) && bufnr(path) <= 0
    return false
  endif

  var target_bufnr = bufadd(path)
  bufload(target_bufnr)
  MaterializeFileAnchors(path, target_bufnr)

  var anchor = FindSourceAnchor(target_bufnr, compilation_lnum)
  if empty(anchor)
    AddSourceAnchor(path, target_bufnr, compilation_lnum)
    anchor = FindSourceAnchor(target_bufnr, compilation_lnum)
  endif
  if empty(anchor)
    return OpenSourcePosition(path, diagnostic.lnum, diagnostic.col, compilation_lnum)
  endif
  return OpenSourcePosition(path, anchor.lnum, anchor.col, compilation_lnum)
enddef

def JumpLazyDiagnostic(diagnostic: dict<any>, compilation_lnum: number): bool
  # Lazy jumping is intentionally only a convenience for <CR> while the
  # background scanner has not reached this line yet.  It creates no index or
  # source-anchor state; the scanner remains the sole producer of that data.
  return OpenSourcePosition(
    ResolveDiagnosticPath(diagnostic.file),
    diagnostic.lnum,
    diagnostic.col,
    compilation_lnum)
enddef

def TryJumpLine(lnum: number): bool
  if has_key(diagnostics_by_line, string(lnum))
    return JumpScannedDiagnostic(lnum)
  endif
  var diagnostic = DiagnosticAt(lnum)
  return !empty(diagnostic) && JumpLazyDiagnostic(diagnostic, lnum)
enddef

def MoveCached(first_lnum: number, delta: number): bool
  var candidate = first_lnum
  while candidate > 0
    if JumpScannedDiagnostic(candidate)
      return true
    endif
    var record = diagnostics_by_line[string(candidate)]
    candidate = delta > 0 ? record.next : record.prev
  endwhile
  return false
enddef

def MoveDiagnostic(delta: number): void
  if compilation_bufnr <= 0 || !bufloaded(compilation_bufnr)
    echo 'No compilation output'
    return
  endif

  if first_diagnostic_line == 0
    echo delta > 0 ? 'No more entries' : 'No previous entries'
    return
  endif

  var candidate = 0
  if last_jump_line == 0
    candidate = delta > 0 ? first_diagnostic_line : last_diagnostic_line
  elseif has_key(diagnostics_by_line, string(last_jump_line))
    var record = diagnostics_by_line[string(last_jump_line)]
    candidate = delta > 0 ? record.next : record.prev
  else
    # The previous jump came from lazy <CR> on an unscanned line.  Do not try
    # to reconcile it with the ordered scanner index; resume from the newest
    # indexed diagnostic instead.
    candidate = last_diagnostic_line
  endif

  if candidate > 0 && MoveCached(candidate, delta)
    return
  endif

  echo delta > 0 ? 'No more entries' : 'No previous entries'
enddef

def CompilationNext(): void
  MoveDiagnostic(1)
enddef

def CompilationPrev(): void
  MoveDiagnostic(-1)
enddef

def OpenAtCursor(): void
  if !IsCompilationBuffer(bufnr()) || line('.') < OUTPUT_FIRST_LINE
    return
  endif
  TryJumpLine(line('.'))
enddef

# --- Commands and mappings ---

command! -nargs=* -complete=shellcmdline Compile Compile(<q-args>)
command! -nargs=0 CompileAgain CompileAgain()
command! -nargs=? CompilationStop CompilationStop(<q-args>)
command! -nargs=0 CompilationToggle CompilationToggle()
command! -nargs=0 CompilationNext CompilationNext()
command! -nargs=0 CompilationPrev CompilationPrev()
command! -nargs=0 CompilationInput CompilationInput()

nnoremap <silent> <Plug>(CompilationNext)        <ScriptCmd>CompilationNext()<CR>
nnoremap <silent> <Plug>(CompilationPrev)        <ScriptCmd>CompilationPrev()<CR>
nnoremap <silent> <Plug>(CompilationToggle)      <ScriptCmd>CompilationToggle()<CR>

if maparg(']e', 'n') ==# ''
  nmap ]e <Plug>(CompilationNext)
endif
if maparg('[e', 'n') ==# ''
  nmap [e <Plug>(CompilationPrev)
endif
if maparg("cs", 'n') ==# ''
  nmap cs <cmd>CompilationStop<cr>
endif
if maparg("cS", 'n') ==# ''
  nmap cS <cmd>CompilationStop kill<cr>
endif

