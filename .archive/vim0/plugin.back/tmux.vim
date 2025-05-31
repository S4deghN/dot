vim9script

var tmuxapplytimer = 0
def TmuxApplyTitle()
    if !!tmuxapplytimer | return | endif
    tmuxapplytimer = timer_start(200, (_) => {
        silent system("tmux rename-window \"[" .. expand("%:t") .. "]\"")
        tmuxapplytimer = 0
    })
enddef

def TmuxResetTitle()
    silent system("tmux set-window-option automatic-rename on")
enddef

augroup tmux
    autocmd VimResume,BufEnter,WinEnter,VimEnter * TmuxApplyTitle()
    autocmd VimLeave,VimSuspend * TmuxResetTitle()
augroup end
