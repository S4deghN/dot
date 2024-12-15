vim9script

def AutoHL()
    if v:hlsearch
        var c = col('.') - 1
        if match(getline('.'), @/, c) != c
            feedkeys("\<cmd>noh\<cr>")
        else
            # {'exact_match': 0, 'current': 0, 'incomplete': 0, 'maxcount': 99, 'total': 0}
            var s = searchcount()
            echo '[' .. s.current .. '/' .. s.total .. ']'
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
    # if !hl_timer
    #     hl_timer = timer_start(100, (_) => {
            AutoHL()
    #         hl_timer = 0
    #     })
    # endif
enddef

augroup Noh
    au!
    au CursorMoved * UpdateHL()
    au InsertEnter * StopHL()
augroup end

command NohOff au! Noh
command NohOn runtime plugin/noh.vim | AutoHL()
