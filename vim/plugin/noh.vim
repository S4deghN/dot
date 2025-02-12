vim9script

def AutoHL()
    if v:hlsearch
        var c = col('.') - 1
        if match(getline('.'), @/, c) != c
            feedkeys("\<cmd>noh\<cr>")
        else
            # var s = searchcount()
            # echo '[' .. s.current .. '/' .. s.total .. ']'
        endif
    endif
enddef

def StopHL()
    if v:hlsearch
        feedkeys("\<cmd>noh\<cr>")
    endif
enddef

augroup Noh
    au!
    au CursorMoved * AutoHL()
    au InsertEnter * StopHL()
augroup end

command NohOff au! Noh
command NohOn runtime plugin/noh.vim | AutoHL()
