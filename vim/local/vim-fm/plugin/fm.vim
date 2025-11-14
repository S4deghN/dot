vim9script

# TODO:
# - fnames with parenthesis and possibly dashed are not recognized.
# - after each operation we empty the mark list though we do not rerender any buffer that
#   containes those marks. we only rerender current buffer.

# if !prop_type_get('fmListingInfo')
silent! prop_type_add('fmListingInfo', {
    highlight: 'LineNr',
    # start_incl: true
    # end_incl: true,
})
silent! prop_type_add('fmHeader', {
    highlight: 'Type',
    # start_incl: true
})
silent! prop_type_add('fmMark', {
    highlight: 'ModeMsg',
    end_incl: true,
    override: true
})

# endif

t:mark_list = []

def Vertical(): string
    var result = ""
    if &columns >= 160 && winlayout()[0] != 'row'
        result ..= "vertical"
    endif
    return result
enddef

# var listing = mapnew(ls, (_, val) => split(val, '\(^\(\S\+\s\+\)\{7}\S\+\)\@<=\s\+'))
def g:GetDirList(dir: string): list<list<string>>
    var list_info: list<string>
    var list_name: list<string>
    var ls = systemlist("ls -alhF --group-directories-first " .. escape(dir, ' '))

    add(list_name, dir)

    var split_point = match(ls[1], '\.\/')
    for line in ls[1 :]
        add(list_info, line[: split_point - 1])
        add(list_name, line[split_point :])
    endfor
    return [list_info, list_name]
enddef

def Refresh(bufnr: number, list_info: list<string>, list_name: list<string>)
    var bufinfo = getbufinfo(bufnr)[0]

    silent deletebufline(bufnr, 1, '$')
    prop_clear(1, bufinfo.linecount, {bufnr: bufnr})

    setbufline(bufnr, 1, list_name[0])
    appendbufline(bufnr, 1, list_name[1 :])

    prop_add(1, 1, {type: 'fmHeader', bufnr: bufnr, length: 999})
    var i = 0
    while i < len(list_info)
        prop_add(2 + i, 1, {type: 'fmListingInfo', bufnr: bufnr, text: list_info[i]})
        ++i
    endwhile

    # Render marks
    var dir = list_name[0]
    for mark in get(t:, 'mark_list', [])
        if fnamemodify(mark, ':h') ==# dir
            var [lnum, col] = searchpos('^' .. fnamemodify(mark, ':t'), 'ncw')
            if lnum > 0 
                prop_add(lnum, 1, {type: 'fmMark', text: "`"})
                prop_add(lnum, 1, {type: 'fmMark', length: 999})
            endif
            # echom $'lnum: {lnum}, col: {col}'
        endif
    endfor

    if bufinfo.lnum == 1
        cursor(4, 0)
    else
        cursor(bufinfo.lnum, 0)
    endif
enddef

def OpenFmBuffer(dir: string): list<any>
    var current_bufname = expand('%:p')->substitute('^\@!/$', '', '')

    if current_bufname == dir
        # echom "curr == dir"
        if &filetype != 'fm'
            setl buftype=nofile nobuflisted filetype=fm
            return [bufnr(), true]
        endif
        return [bufnr(), false]
    endif

    if bufexists(dir)
        # echom "buffer dir"
        exec 'badd' dir
        exec 'buffer' dir
        setl nobuflisted
        return [bufnr(), false]
    else
        # echom "fm: e dir"
        exec 'e' dir
        exec 'keepalt silent :0file'
        exec 'keepalt silent file' dir
        setl buftype=nofile nobuflisted filetype=fm
        return [bufnr(), true]
    endif
enddef

def g:Fm(arg: string = getcwd())
    # TODO: Add windoing
    # if !isdirectory(current_bufname)
    #     echom "open new window: " .. current_bufname
    #     exe 'botright' Vertical() 'split'
    # endif

    var fname = g:FnameFromLine(arg)->resolve()

    if isdirectory(fname)
        var dir = substitute(fname, '^\@!/$', '', '')
        var [bufnr, refresh] = OpenFmBuffer(dir)
        exec 'silent lcd' dir
        # if refresh
            var [list_info, list_name] = g:GetDirList(dir)
            Refresh(bufnr, list_info, list_name)
        # endif
    elseif filereadable(fname)
        exec 'e' fname
    else
        echoe $'{fname} is not a valid directory or file!'
    endif
enddef
command! -nargs=? -bang -complete=file Fm call g:Fm(<f-args>)

def OnBufEnter(arg_bufnr: string, arg_dir: string)
    if isdirectory(arg_dir)
        timer_start(0, (timer) => {
            var bufnr = str2nr(arg_bufnr)
            if !bufexists(bufnr) || getbufvar(bufnr, '&buftype', '') == 'terminal' # avoid setting fzf buffer's dir
                return
            endif

            var dir = substitute(resolve(arg_dir), '^\@!/$', '', '')
            if getcwd() !=# dir
                echom "auto lcd:" dir "\n"
                exec 'silent lcd' dir
            endif

            if getbufvar(bufnr, '&filetype', '') != 'fm' || line('$') == 1
                echom "au dir:" dir
                exec 'keepalt silent :0file'
                exec 'keepalt silent file' dir
                setl buftype=nofile nobuflisted filetype=fm

                var [list_info, list_name] = g:GetDirList(dir)
                Refresh(bufnr, list_info, list_name)
            endif
        })
    endif
enddef
augroup fm
    au!
    au BufEnter * OnBufEnter(expand('<abuf>'), expand('<afile>:p'))
augroup END


# -------------------------

def g:FnameFromLine(line: string): string
    return line[0 : matchend(line, '\%(\f\|\s\)\{-}\ze\%(\*\| ->\|$\)') - 1]
enddef

def g:Out()
    var dirname_before_out = expand('%:p:h:t')
    g:Fm(expand('%:p:h:h'))
    # Land on parent directory
    search('^' .. dirname_before_out, 'cw')
enddef

def g:In()
    g:Fm(expand('%:p') .. getline('.'))
enddef

def g:Delete()
    if len(t:mark_list) == 0
        g:Mark()
    endif

    # TODO: move files to system trash if it exists. `mktemp` can come in handy.
    for name in t:mark_list
        if isdirectory(name)
            var yes = confirm("Delete directories recursively?", "&Yes\n&No", 0)
            if yes != 1 | echo "Aborted deletion!" | return | endif
        endif
    endfor

    var res = system('rm -r ' .. join(t:mark_list))
    if v:shell_error
        echohl Error | echom res->trim() | echohl None
    endif
    t:mark_list = []

    var [list_info, list_name] = g:GetDirList(getcwd())
    Refresh(bufnr(), list_info, list_name)
enddef

def g:Move()
    if len(t:mark_list) == 0
        echom "Nothing to move here! Mark list is empty."
        return
    endif

    # TODO: when moving files into a directory with existing names, create a backup of existing
    # files.
    var res = system('mv ' .. join(t:mark_list) .. ' .')
    if v:shell_error
        echohl Error | echom res->trim() | echohl None
    endif
    t:mark_list = []

    var [list_info, list_name] = g:GetDirList(getcwd())
    Refresh(bufnr(), list_info, list_name)
enddef

def g:Copy()
    if len(t:mark_list) == 0
        echom "Nothing to move here! Mark list is empty."
        return
    endif

    # TODO: when copying files into a directory with existing names, create a backup of
    # existing files.
    var res = system('cp ' .. join(t:mark_list) .. ' .')
    if v:shell_error
        echohl Error | echom res->trim() | echohl None
    endif
    t:mark_list = []

    var [list_info, list_name] = g:GetDirList(getcwd())
    Refresh(bufnr(), list_info, list_name)
enddef

def g:Rename()
    t:mark_list = []

    var fname = g:FnameFromLine(getline(line('.')))
    var new_name = ''
    try
        echohl ModeMsg
        new_name = input("Rename: ", fname, 'file')
    finally
        echohl None
    endtry
    if len(new_name) == 0
        return
    endif

    var res = system('mv ' .. fname .. ' ' .. new_name)
    if v:shell_error
        echohl Error | echom res->trim() | echohl None
    endif

    var [list_info, list_name] = g:GetDirList(getcwd())
    Refresh(bufnr(), list_info, list_name)
enddef

def g:Mkdir()
    var dir_name = ''
    try
        echohl ModeMsg
        dir_name = input("Mkdir: ", '', 'file')
    finally
        echohl None
    endtry
    if len(dir_name) == 0
        return
    endif

    var res = system('mkdir -p ' .. dir_name)
    if v:shell_error
        echohl Error | echom res->trim() | echohl None
    endif

    var [list_info, list_name] = g:GetDirList(getcwd())
    Refresh(bufnr(), list_info, list_name)

    search('^' .. dir_name, 'cw')
enddef

def g:Extract()
    if len(t:mark_list) == 0
        g:Mark()
    endif

    var res = system('atool --extract --each ' ..  join(t:mark_list))
    if v:shell_error
        echohl Error | echom res->trim() | echohl None
    endif
    t:mark_list = []

    var [list_info, list_name] = g:GetDirList(getcwd())
    Refresh(bufnr(), list_info, list_name)
enddef

def g:Mark()
    var start = line('.')
    var end = line('v')
    var range = range(start, end, end < start ? -1 : 1)
    norm! 

    var cwd = expand('%:p')->escape(' ')
    for lnum in range
        var fname = g:FnameFromLine(getline(lnum))
        var mark =  (cwd .. fname)->escape(' ')
        var idx = index(t:mark_list, mark)
        if idx == -1
            add(t:mark_list, mark)
            prop_add(lnum, 1, {type: 'fmMark', text: "`"})
            prop_add(lnum, 1, {type: 'fmMark', length: 999})
        else
            remove(t:mark_list, idx)
            prop_remove({type: 'fmMark', all: true}, lnum)
        endif
    endfor
enddef
command! ShowMarks echom t:mark_list

# defcompile
