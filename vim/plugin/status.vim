vim9script

# set statusline=%(%{get(w:,'git_branch','')}:%)%f:%-10(%l:%c%)%=

def UpdateGitBranch()
    if len(&buftype) > 0 && &filetype != 'fm'
        w:git_branch = ''
        return
    endif

    var branch = system('git branch --show-current 2>/dev/null')
    if len(branch) == 0 && v:shell_error == 0
        branch = system('git describe --all --contains 2>/dev/null')
    endif

    if len(branch) > 0
        w:git_branch = substitute(branch, '\n', '', '')
    else
        w:git_branch = ''
    endif
enddef

# autocmd DirChanged,WinNew,VimEnter,TerminalWinOpen,FileType * call timer_start(100, 
