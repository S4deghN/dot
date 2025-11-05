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

# g:fzf_layout = { 'window': { 'width': 1, 'height': 0.35, 'yoffset': 1.0, 'border': 'top'} }

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
    return fzf#run(fzf#wrap('apropos', {'options': ['--no-sort', '--header', src_cmd, '--query', '^'], 'source': src_cmd, 'sink': (line) => {
        var [_, name, section; _] = matchlist(line, '^\(\S\+\)\s\+\((\w\+)\)')
        exec 'Man' name .. section
    } }))
enddef

def OpenFile(fname_arg: string, lnum: string, col = ""): bool
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

    if !empty(lnum)
        execute ":" .. lnum
        execute "normal! 0"
    endif

    if !empty(col) && str2nr(col) > 1
        execute "normal!" (str2nr(col)) .. "|"
    endif
    normal! zvzz
    return true
enddef

# TODO: Add support for fzf_action.
def g:LiveGrep(query: string, fullscreen: bool, previous = false, dir = "")
    var command_fmt = 'rg -. --glob "!**/.git/**" -S -n --column --color=always --sort=path %s %s 2>/dev/null || true'
    var prompt = ''
    var q = previous ? system('cat /tmp/rg-fzf-p') : query
    var initial_grep = printf(command_fmt, shellescape(q), dir)
    var reload_grep = printf(command_fmt, '{q}', dir)
    var cwd = getcwd()
    var transform =
        'transform:[[ ! {fzf:prompt} == "*Rg> " ]] &&' ..
        'echo "rebind(change)+change-prompt(*Rg> )+disable-search+transform-query:echo \{q} > /tmp/rg-fzf-f; cat /tmp/rg-fzf-r" ||' ..
        'echo "unbind(change)+change-prompt({q}> )+enable-search+transform-query:echo \{q} > /tmp/rg-fzf-r; cat /tmp/rg-fzf-f"'
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
            '--bind', 'enter:execute(printf {q} > /tmp/rg-fzf-p)+accept',
            '--bind', 'esc:execute(printf {q} > /tmp/rg-fzf-p)+abort',
            # '--bind', 'ctrl-u:transform-header(echo $FZF_API_KEY)'
            '--expect', 'ctrl-^'
        ],
        'source': initial_grep,
    }
    if q != ""
        extend(options['options'], [ '--bind', 'start:' .. transform ])
    endif
    # var ret = fzf#vim#grep(initial_grep, 1, fzf#vim#with_preview(options), fullscreen)
    var spec = fzf#wrap(fzf#vim#with_preview(options))
    # var original_spec = copy(spec)
    unlet spec.sinklist
    unlet spec['sink*']

    spec.sinklist = (lines) => {
        # echom lines
        if len(lines) < 2
            echom "less than 2!"
            return
        endif
        if lines[0] == 'ctrl-^'
            call g:LiveGrep(q, fullscreen, false, dir .. "../")
        else
            remove(lines, 0) # it must be empty!

            var list = map(filter(lines, (_, line) => len(line) > 0), (_, line): dict<string> => {
                var parts = matchlist(line, '\(.\{-}\)\s*:\s*\(\d\+\)\%(\s*:\s*\(\d\+\)\)\?\%(\s*:\(.*\)\)\?')
                var file = &autochdir ? fnamemodify(parts[1], ':p') : parts[1]
                if has('win32unix') && file !~ '/'
                    file = substitute(file, '\', '/', 'g')
                endif
                var dict = {'filename': file, 'lnum': parts[2], 'text': parts[4]}
                if len(parts[3]) > 0
                    dict.col = parts[3]
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
                utils#Spotlight()
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
