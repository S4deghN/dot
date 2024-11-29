vim9script

def AutoHL()
    if v:hlsearch
        var c = col('.') - 1
        if match(getline('.'), @/, c) != c
            feedkeys("\<cmd>noh\<cr>")
        endif
    endif
enddef

def StopHL()
    if v:hlsearch
        feedkeys("\<cmd>noh\<cr>")
    endif
enddef

var hl_timer = 0
def UpdateHL()
    if !hl_timer
        hl_timer = timer_start(1000, (_) => {
            AutoHL()
            hl_timer = 0
        })
    endif
enddef

augroup Noh
    au!
    au CursorMoved * UpdateHL()
    au InsertEnter * StopHL()
augroup end

command NohOff au! Noh
command NohOn runtime plugin/noh.vim | AutoHL()
