vim9script
# TODO:
# 1. [x] Add Navigation and lcd
# 2. [ ] Fix not being able to open {filename*}
# 2. [ ] Fix not being able to open {file name -> file name*}

# if !prop_type_get('fmListingInfo')
silent! prop_type_add('fmListingInfo', {
    highlight: 'LineNr',
    start_incl: true
})
silent! prop_type_add('fmHeader', {
    highlight: 'Type',
    start_incl: true
})
silent! prop_type_add('fmMark', {
    highlight: 'QuickFixLine',
    start_incl: true
})
# endif

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

    add(list_info, dir .. ' (' .. ls[0] .. ')')

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

    prop_add(1, 0, {type: 'fmHeader', bufnr: bufnr, text_align: 'above', text: list_info[0]})
    var i = 1
    while i < len(list_info)
        prop_add(i, 1, {type: 'fmListingInfo', bufnr: bufnr, text: list_info[i]})
        ++i
    endwhile

    if bufinfo.lnum == 1
        cursor(3, 0)
    else
        cursor(bufinfo.lnum, 0)
    endif
enddef

def OpenFmBuffer(dir: string): list<any>
    var current_bufname = expand('%:p')->substitute('^\@!/$', '', '')

    if current_bufname == dir
        echom "curr == dir"
        if &filetype != 'fm'
            setl buftype=nofile nobuflisted filetype=fm
            return [bufnr(), true]
        endif
        return [bufnr(), false]
    endif

    if bufexists(dir)
        echom "buffer dir"
        exec 'badd' dir
        exec 'buffer' dir
        setl nobuflisted
        return [bufnr(), false]
    else
        echom "fm: e dir"
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

    var fname = arg[0 : matchend(arg, '\%(\f\|\s\)\{-}\ze\%(\*\| ->\|$\)') - 1]->resolve()

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

# -------------------------

def g:Out()
    g:Fm(expand('%:p:h:h'))
enddef

def g:In()
    g:Fm(expand('%:p') .. getline('.'))
enddef

# TODO: add completion
command! -nargs=? -bang Fm call g:Fm(<f-args>)

def OnBufEnter(arg_bufnr: string, arg_dir: string)
    if isdirectory(arg_dir)
        timer_start(0, (timer) => {
            var bufnr = str2nr(arg_bufnr)
            if !bufexists(bufnr)
                return
            endif

            var dir = substitute(resolve(arg_dir), '^\@!/$', '', '')
            if getcwd() !=# dir
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
    au BufEnter * OnBufEnter(expand('<abuf>'), expand('<afile>:p')) #| echom expand('<abuf>') expand('<afile>') expand('<afile>:p')
augroup END

var mark_list: list<string>
def g:Mark()
    var path = expand('%:p')
    var start = line('.')
    var end = line('v')
    for lnum in range(start, end, end < start ? -1 : 1)
        var mark =  path .. getline(lnum)
        var idx = index(mark_list, mark)

        if idx == -1
            add(mark_list, path .. getline(lnum))
            prop_add(lnum, 1, {type: 'fmMark', length: 999})
        else
            remove(mark_list, idx)
            prop_remove({type: 'fmMark'}, lnum)
        endif
    endfor

    echom mark_list
enddef

