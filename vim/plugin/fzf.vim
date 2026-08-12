vim9script
# -----------------------------------------------
# --- config ---
# -----------------------------------------------

g:fzf_vim = {}
# g:fzf_vim.preview_window = ['right,50%,<80(up,40%),hidden', 'ctrl-l']
g:fzf_vim.preview_window = ['up,50%,nohidden', 'ctrl-l']
# g:fzf_vim.preview_window = ['down,70%,hidden', 'ctrl-l']
def BuildQfList(lines: string)
    call setqflist(map(copy(lines), '{ "filename": ' .. pwd .. '/v:val, "lnum": 1 }'))
    copen
    cc
enddef

# g:fzf_action = {
#     'ctrl-q': function('BuildQfList'),
#     'ctrl-t': 'tab split',
#     'ctrl-x': 'split',
#     'ctrl-v': 'vsplit'
# }

# g:fzf_layout = { 'window': { 'width': 1, 'height': 0.5, 'yoffset': 1, 'reletavie': v:true, 'border': 'top'} }
# g:fzf_layout = { 'window': '10new' }
# g:fzf_layout = { 'down': "100%" }
g:fzf_layout = { 'window': { 'width': 0.95, 'height': 0.8 } }

# autocmd! FileType fzf set laststatus=0 noshowmode noruler
#             \| autocmd BufLeave <buffer> set laststatus=2 showmode ruler

# -----------------------------------------------
# --- extend ---
# -----------------------------------------------
def g:FzfVimHelp(): list<string>
    lcd $VIMRUNTIME
    var pathes = split(&runtimepath, ',')
        ->map((_, v): string => {
            return fnamemodify(v .. '/doc', ':~:.')
        })
        ->sort((a, b): number => {
            return len(a) - len(b)
        })

    g:LiveGrep("", false, { 'dir': join(pathes) })
    return pathes
enddef
command! Help call FzfVimHelp()

def g:FzfChistory(): list<string>
    var hlist = execute("chistory")

    var src = mapnew(split(hlist, '\n'), (_, v): string => {
        return substitute(v, '^\(>\?\s\+\).\{-}\(\d\+\).\{-}\(\d\+\) errors\s\+\(.*\)$', '\1\2: (\3) \4', 'g')
    })
    ->reverse()

    return fzf#run(fzf#wrap('chistory', {
        # 'down': '20%',
        'window': { 'width': 0.6, 'height': 0.5 },
        'options': [
            '--header', ':chistory',
        ],
        'source': src,
        'sink': (line) => {
            exec 'chistory' matchstr(line, '.\{-}\(\d\+\)')
            copen
        }
    }))
enddef
command! Chistory call FzfChistory()

def g:FzfApropos(): list<string>
    # var src_list = systemlist("apropos .")
    var src_cmd = 'apropos .'
    return fzf#run(fzf#wrap('apropos', {
        'options': [
            # '--no-sort',
            '--header', src_cmd,
            '--query', '^',
            '--preview', 'man {1}{2} 2>/dev/null',
        ],
        'source': src_cmd,
        'sink': (line) => {
            var [_, name, section; _] = matchlist(line, '^\(\S\+\)\s\+\((\w\+)\)')
            exec 'Man' name .. section
        } }))
enddef
command! Apropos call FzfApropos()

def OpenFile(fname_arg: string, lnum: number, col = 0): bool
    if !filereadable(fname_arg) | echoe $'{fname_arg} not readable!' | return false | endif

    var buffers = filter(getbufinfo(), (idx, v) => fnamemodify(fname_arg, ":p") == v.name)
    var fname = substitute(fname_arg, '#', '\&', 'g')

    if len(buffers) > 0
        if len(buffers[0].windows) > 0
            win_gotoid(buffers[0].windows[0])
        else
            execute "buffer" fname
        endif
    else
        execute "edit" fname
    endif

    if lnum != 0
        execute ":" .. lnum
        execute "normal! 0"
    endif

    if col != 0
        execute "normal!" col .. "|"
    endif
    normal! zvzz
    return true
enddef

# augroup fzf
#     au!
#     autocmd FileType fzf tnoremap <silent> <Enter> <C-w>:call g:RemoteSelect("<C-v><Enter>")<cr>
#     autocmd FileType fzf tnoremap <silent> <Plug>CloseFzfRg <C-w>:call g:RemoteSelect("<C-v><Esc>")<cr>
#     autocmd FileType fzf tnoremap <Esc>a <Esc>a
#     autocmd FileType fzf tmap <nowait> <Esc> <Plug>CloseFzfRg
# augroup end

def g:RemoteSelect(key: string) # {{{
    echom "Called this!" key
    # Only run if it's rg window, otherwise just pass the key to terminal
    var line1 = term_getline(bufnr(), 1)
    if line1 !~# "^\*Rg>" && line1 !~# "^'.\\{-}'>"
        term_sendkeys(bufnr(), key)
        return
    endif

    t:fzf_rg_bufnr = bufnr()
    set bufhidden=hide

    if key == "\<Esc>"
        wincmd c
        return
    endif

    var port = readfile(t:fzf_port_tmpfile)[0]
    var ch = ch_open('127.0.0.1:' .. port, {
        mode: "lsp",
        callback: (c, msg) => {
            # echom "cb: " .. msg.current.text

            var parts = matchlist(msg.current.text, '\(.\{-}\)\s*:\s*\(\d\+\)\%(\s*:\s*\(\d\+\)\)\?\%(\s*:\(.*\)\)\?')
            var file = &autochdir ? fnamemodify(parts[1], ':p') : parts[1]
            if has('win32unix') && file !~ '/'
                file = substitute(file, '\', '/', 'g')
            endif
            var dict = {'filename': file, 'lnum': parts[2], 'text': parts[4]}
            if len(parts[3]) > 0
                dict.col = parts[3]
            endif

            wincmd c

            if OpenFile(dict.filename, dict.lnum, dict.col)
                # utils#Spotlight()
            endif
        }
    })
    if ch_status(ch) != "open"
        echom 'oops:' ch_info(ch)
        return
    endif
    ch_sendraw(ch, "GET /?limit=0 HTTP/1.1\r\n\r\n")
enddef # }}}

# TODO: Add support for fzf_action.
def g:LiveGrep(query_arg: string, fullscreen: bool, opt = {})
    # t:fzf_port_tmpfile = get(t:, 'fzf_port_tmpfile', tempname())
    var dir_opt = get(opt, 'dir', '')
    var select_all = get(opt, 'select_all', false)

    const command_fmt = 'rg -. --glob ''!**/.git/*'' -S -n --column --color=always --sort=path %s %s 2>/dev/null || true'
    const query = get(opt, 'use_last_query', false) ? readfile('/tmp/rg-fzf-regex')[0] : query_arg
    const dir = getcwd()
    const initial_grep = printf(command_fmt, shellescape(query), dir_opt)
    const reload_grep = printf(command_fmt, '{q}', dir_opt)

    const transform =
        'transform:[ {fzf:prompt} = "*Rg> " ] &&' ..
        'echo "unbind(change)+change-prompt({q}> )+enable-search+transform-query(echo \{q} > /tmp/rg-fzf-regex; cat /tmp/rg-fzf-fuzzy)" ||' ..
        'echo "rebind(change)+change-prompt(*Rg> )+disable-search+transform-query(echo \{q} > /tmp/rg-fzf-fuzzy; cat /tmp/rg-fzf-regex)"'

    const save_query = 'execute([ {fzf:prompt} = "*Rg> " ] && echo {q} > /tmp/rg-fzf-regex || echo {q} > /tmp/rg-fzf-fuzzy)'

    const select_all_if_no_select = 'transform([ $FZF_SELECT_COUNT -eq 0 ] && echo "select-all+print({n})")'

    var options = {
        'options': [
            '--ansi',
            '--multi',
            '--delimiter', ':',
            '--prompt', '*Rg> ',
            '--header', dir .. (len(dir_opt) > 0 ? ': ' .. dir_opt : ''),
            '--height', '100%',
            '--phony',
            '--query', query,
            '--bind', 'alt-a:select-all,alt-d:deselect-all',
            '--bind', 'change:reload:sleep 0.1;' .. reload_grep,
            '--bind', 'ctrl-g:' .. transform,
            '--bind', 'esc:'    .. save_query .. '+abort',
            '--bind', 'enter:'  .. save_query .. (select_all ? '+' .. select_all_if_no_select : '') .. '+accept',
            '--bind', 'ctrl-r:' .. save_query .. '+print(change-dir)+accept',
            '--delimiter', ':',
            '--preview-window', '+{2}/2',
            '--no-clear',
            # '--border=horizontal'
            # '--listen', '127.0.0.1:0',
            # '--bind', 'start:execute-silent:echo $FZF_PORT > ' .. t:fzf_port_tmpfile,
        ],
        'source': initial_grep,
    }
    if query != ""
        extend(options['options'], [ '--bind', 'start:' .. transform ])
    endif
    # var ret = fzf#vim#grep(initial_grep, 1, fzf#vim#with_preview(options), fullscreen)
    var spec = fzf#wrap(options, fullscreen)
    spec = fzf#vim#with_preview(spec)
    # var original_spec = copy(spec)
    unlet spec.sinklist
    unlet spec['sink*']

    spec.sinklist = (lines) => {
        if len(lines) < 2
            # echom "less than 2!\n" .. string(lines)
            return
        endif

        var exit_key = remove(lines, 0) # empty!

        if lines[0] == 'change-dir'
            var new_dir = ''
            echohl ModeMsg
            try
                new_dir = input('Directory: ', dir, 'dir')
            finally | echohl None | endtry
            if len(new_dir) != 0
                exec 'lcd' new_dir
            endif

            call g:LiveGrep("", fullscreen, extend(opt, { 'use_last_query': true }))
        else
            var cursor_index = 0
            if lines[0] =~ '^\d\+$'
                cursor_index = str2nr(remove(lines, 0))
            endif

            var list = lines
                ->filter((_, line) => len(line) > 0)
                ->map((_, line): dict<any> => {
                    var parts = matchlist(line, '\(.\{-}\)\s*:\s*\(\d\+\)\%(\s*:\s*\(\d\+\)\)\?\%(\s*:\(.*\)\)\?')
                    # var file = &autochdir ? fnamemodify(parts[1], ':p') : parts[1]
                    var file = dir .. '/' .. parts[1]
                    if has('win32unix') && file !~ '/'
                        file = substitute(file, '\', '/', 'g')
                    endif
                    var dict = {'filename': file, 'lnum': str2nr(parts[2]), 'text': parts[4]}
                    if len(parts[3]) > 0
                        dict.col = str2nr(parts[3])
                    endif
                    return dict
                })

            if empty(list) | return | endif

            if len(list) > 1
                setqflist([], ' ', { 'items': list, 'nr': '$',
                    'title': $"LiveGrep: { readfile('/tmp/rg-fzf-regex')[0] }" })
                exec 'cc' cursor_index + 1
            else
                OpenFile(list[cursor_index].filename, list[cursor_index].lnum, list[cursor_index].col)
            endif

            # if ok
                # utils#Spotlight()
            # endif


        endif
    }

    fzf#run(spec)
enddef

command! -nargs=* -bang LiveGrep call LiveGrep(<q-args>, <bang>0, { 'select_all': true })
command! -bang LiveGrepPrevious call LiveGrep("", <bang>0, { 'select_all': true, 'use_last_query': true })
command! -nargs=* -bang LiveGrepVisual call LiveGrep(escape(utils#GetVisualSelection(), "()\+*.[]\|"), <bang>0)
# I don't like the default with shortened path name
# command! -bang -nargs=? -complete=dir Files call fzf#vim#files(<q-args>, {options: ['--prompt=' .. getcwd() .. '/']}, <bang>0)
# Requires :Man command
