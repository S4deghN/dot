vim9script
# -----------------------------------------------
# --- config ---
# -----------------------------------------------
g:fzf_vim = {}
g:fzf_vim.preview_window = ['right,50%,<70(up,40%),hidden', 'ctrl-l']
# g:fzf_vim.preview_window = ['down,70%,hidden', 'ctrl-l']
def BuildQfList(lines: string)
    call setqflist(map(copy(lines), '{ "filename": v:val, "lnum": 1 }'))
    copen
    cc
enddef

g:fzf_action = {
    'ctrl-q': function('BuildQfList'),
    'ctrl-t': 'tab split',
    'ctrl-x': 'split',
    'ctrl-v': 'vsplit'
}

# g:fzf_layout = { 'window': { 'width': 1, 'height': 0.5, 'yoffset': .95, 'reletavie': v:true, 'border': 'top'} }
# g:fzf_layout = { 'window': '10new' }
g:fzf_layout = { 'down': "55%" }

autocmd! FileType fzf set laststatus=0 noshowmode noruler
            \| autocmd BufLeave <buffer> set laststatus=2 showmode ruler

# -----------------------------------------------
# --- extend ---
# -----------------------------------------------
def g:FzfChistory(): list<string>
    var hlist = execute("chistory")
    #echo hlist

    var src = split(hlist, '\n')
    src = map(src, (_, v): string => {
        return substitute(v, '^\(>*\s*\)[^0-9]*\|\sof\s[0-9]\|errors', '\1\ ', 'g')
    })

    return fzf#run(fzf#wrap('chistory', { 'source': src, 'sink': (num) => execute(num[3] .. "chistory") } ))
enddef

def g:FzfApropos(): list<string>
    # var src_list = systemlist("apropos .")
    var src_cmd = 'apropos .'
    return fzf#run(fzf#wrap('apropos', {
        'options': [
            # '--no-sort',
            '--header', src_cmd,
            '--query', '^',
        ],
        'source': src_cmd,
        'sink': (line) => {
            var [_, name, section; _] = matchlist(line, '^\(\S\+\)\s\+\((\w\+)\)')
            exec 'Man' name .. section
        } }))
enddef

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

def g:RemoteSelect(key: string)
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
enddef

# TODO: Add support for fzf_action.
def g:LiveGrep(query: string, fullscreen: bool, previous = false, dir = "")
    # var bufnr = get(t:, 'fzf_rg_bufnr', -1)
    # echom "bufnr:" bufnr
    # if !!bufexists(bufnr)
    #     if query == ""
    #         exec "botright sbuf" bufnr
    #         return
    #     else
    #         # BUG: stupid fzf jumps back to previous window with a delay after buffer
    #         # is whped!!!
    #         exec ":" .. bufnr .. "bwipe!"
    #     endif
    # endif

    var command_fmt = 'rg -. --glob ''!**/.git/*'' -S -n --column --color=always --sort=path %s %s 2>/dev/null || true'
    var prompt = ''
    var q = previous ? system('cat /tmp/rg-fzf-p') : query
    var initial_grep = printf(command_fmt, shellescape(q), dir)
    var reload_grep = printf(command_fmt, '{q}', dir)
    var cwd = getcwd()
    t:fzf_port_tmpfile = get(t:, 'fzf_port_tmpfile', tempname())
    var transform =
        'transform:[[ ! {fzf:prompt} == "*Rg> " ]] &&' ..
        'echo "rebind(change)+change-prompt(*Rg> )+disable-search+transform-query:echo \{q} > /tmp/rg-fzf-f; cat /tmp/rg-fzf-r" ||' ..
        'echo "unbind(change)+change-prompt({q}> )+enable-search+transform-query:echo \{q} > /tmp/rg-fzf-r; cat /tmp/rg-fzf-f"'
    var save_query = 'execute([[ {fzf:prompt} == "*Rg> " ]] && printf {q} > /tmp/rg-fzf-p || cat /tmp/rg-fzf-r > /tmp/rg-fzf-p)'
    var options = {
        'options': [
            '--ansi',
            '--multi',
            '--delimiter', ':',
            '--prompt', '*Rg> ',
            '--header', getcwd() .. dir,
            '--phony',
            '--query', q,
            '--bind', 'alt-a:select-all,alt-d:deselect-all',
            '--bind', 'change:reload:sleep 0.1;' .. reload_grep,
            '--bind', 'ctrl-g:' .. transform,
            '--bind', 'enter:execute([[ {fzf:prompt} == "*Rg> " ]] && printf {q} > /tmp/rg-fzf-p || printf $(cat /tmp/rg-fzf-r) > /tmp/rg-fzf-p)+accept',
            '--bind', 'esc:execute([[ {fzf:prompt} == "*Rg> " ]] && printf {q} > /tmp/rg-fzf-p || printf $(cat /tmp/rg-fzf-r) > /tmp/rg-fzf-p)+abort',
            '--delimiter', ':',
            '--preview-window', '+{2}/2',
            '--expect', 'ctrl-^',
            # '--border=horizontal'
            # '--listen', '127.0.0.1:0',
            # '--bind', 'start:execute-silent:echo $FZF_PORT > ' .. t:fzf_port_tmpfile,
        ],
        'source': initial_grep,
    }
    if q != ""
        extend(options['options'], [ '--bind', 'start:' .. transform ])
    endif
    # var ret = fzf#vim#grep(initial_grep, 1, fzf#vim#with_preview(options), fullscreen)
    var spec = fzf#vim#with_preview(fzf#wrap(options))
    # var original_spec = copy(spec)
    unlet spec.sinklist
    unlet spec['sink*']

    spec.sinklist = (lines) => {
        # echom lines
        if len(lines) < 2
            echom "less than 2!\n" .. string(lines)
            return
        endif
        if lines[0] == 'ctrl-^'
            call g:LiveGrep(q, fullscreen, false, dir .. "../")
        else
            remove(lines, 0) # it must be empty!

            var list = lines
                ->filter((_, line) => len(line) > 0)
                ->map((_, line): dict<any> => {
                    var parts = matchlist(line, '\(.\{-}\)\s*:\s*\(\d\+\)\%(\s*:\s*\(\d\+\)\)\?\%(\s*:\(.*\)\)\?')
                    var file = &autochdir ? fnamemodify(parts[1], ':p') : parts[1]
                    if has('win32unix') && file !~ '/'
                        file = substitute(file, '\', '/', 'g')
                    endif
                    var dict = {'filename': file, 'lnum': str2nr(parts[2]), 'text': parts[4]}
                    if len(parts[3]) > 0
                        dict.col = str2nr(parts[3])
                    endif
                    return dict
                })

            # echom list

            if empty(list) | return | endif

            var ok = OpenFile(list[0].filename, list[0].lnum, list[0].col)
            if len(list) > 1
                setqflist(list)
            endif

            if ok
                # utils#Spotlight()
            endif


        endif
    }

    fzf#run(spec)
enddef

command! -nargs=* -bang LiveGrep call LiveGrep(<q-args>, <bang>0, false)
command! -bang LiveGrepPrevious call LiveGrep("", <bang>0, true)
command! -nargs=* -bang LiveGrepVisual call LiveGrep(escape(utils#GetVisualSelection(), "()\+*.[]\|"), <bang>0)
# I don't like the default with shortened path name
command! -bang -nargs=? -complete=dir Files call fzf#vim#files(<q-args>, {options: ['--prompt=' .. getcwd() .. '/']}, <bang>0)
# Requires :Man command
command! Apropos call FzfApropos()
