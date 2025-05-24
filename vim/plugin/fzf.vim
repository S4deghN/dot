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

g:fzf_layout = { 'window': { 'width': 1, 'height': 0.35, 'yoffset': 1.0, 'border': 'top'} }

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
    return fzf#run(fzf#wrap('apropos', {'options': ['--header', src_cmd, '--query', '^'], 'source': src_cmd, 'sink': (line) => {
        var [_, name, section; _] = matchlist(line, '^\(\S\+\)\s\+\((\w\+)\)')
        exec 'Man' name .. section
    } }))
enddef

def GetVisualSelection(): string
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

def g:LiveGrep(query: string, fullscreen: bool)
    var command_fmt = &grepprg .. ' --color=always %s || true'
    var prompt = ''
    var initial_grep = printf(command_fmt, shellescape(query))
    var reload_grep = printf(command_fmt, '{q}')
    var cwd = getcwd()
    var options = {'options': [
        '--prompt', '*Rg> ',
        '--header', getcwd(),
        '--phony',
        '--query', query,
        '--bind', 'change:reload:sleep 0.1;' .. reload_grep,
        '--bind', 'ctrl-g:transform:[[ ! {fzf:prompt} == "*Rg> " ]] &&' ..
        'echo "rebind(change)+change-prompt(*Rg> )+disable-search+transform-query:echo \{q} > /tmp/rg-fzf-f; cat /tmp/rg-fzf-r" ||' ..
        'echo "unbind(change)+change-prompt({q}> )+enable-search+transform-query:echo \{q} > /tmp/rg-fzf-r; cat /tmp/rg-fzf-f"'
    ]}
    call fzf#vim#grep(initial_grep, 1, fzf#vim#with_preview(options), fullscreen)
enddef
command! -nargs=* -bang LiveGrep call LiveGrep(<q-args>, <bang>0)
command! -nargs=* -bang LiveGrepVisual call LiveGrep(escape(GetVisualSelection(), "()\+*.[]\|"), <bang>0)
# I don't like the default with shortened path name
command! -bang -nargs=? -complete=dir Files call fzf#vim#files(<q-args>, {options: ['--prompt=' .. getcwd() .. '/']}, <bang>0)
# Requires :Man command
command! Apropos call FzfApropos()
