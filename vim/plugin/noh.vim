vim9script

# =============================================================================
# Filename: plugin/noh.vim
# Author: S4N
# License: MIT License I smile 😀
# License: MIT License I smile 😀
# Description: Take from https://github.com/romainl/vim-cool/issues/9
# =============================================================================

def g:HlSearch()
    var c = col('.') - 1
    if getline('.')->slice(c, c + strchars(@/)) !~? @/
        g:StopHL()
    endif
enddef

def g:StopHL()
    if !v:hlsearch || mode() != 'n'
        return
    else
        feedkeys("\<cmd>noh\<cr>")
    endif
enddef

var hl_timer = 0
def g:HlUpdate()
    if !hl_timer
        hl_timer = timer_start(1000, (_) => {
            g:HlSearch()
            hl_timer = 0
        })
    endif
enddef

augroup Noh
    au!
    au CursorMoved * g:HlUpdate()
    au InsertEnter * g:StopHL()
augroup end

command NohOff au! Noh
command NohOn runtime plugin/noh.vim | g:StopHL()
