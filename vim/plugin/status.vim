vim9script

if &laststatus > 0
    set showcmdloc=statusline
    set statusline=
    # Left
    set stl+=%f
    set stl+=%(\ %m%q%h%w%r%)
    set stl+=\ \ \ \ %P\ %10(%l:%c\ \ %)
    set stl+=%(\ \ \ \ Git:%{get(w:,'git_branch','')}%)
    set stl+=%(\ \ \ \ LSP:%{%g:LspStatus()%}%)
    # Middle
    set stl+=\ %=
        set stl+=%S
    # Right
    set stl+=\ %=
        set stl+=
else
    set rulerformat=%60(%(LSP:%{%g:LspStatus()%}%)\ \ \ \ %(Git:%{get(w:,'git_branch','')}%)%=\ \ \ \ %-8(%l,%c%)\ %P%)
    augroup ruler
        autocmd BufEnter * call feedkeys("\<C-g>")
    augroup end
endif

def g:UpdateGitBranch()
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
augroup GitBranch
    au!
    au DirChanged,WinNew,VimEnter,TerminalWinOpen,FileType * call UpdateGitBranch()
augroup end

def g:LspStatus(): string
    var str = ''
    var bufnr = bufnr()
    if lsp#buffer#BufHasLspServer(bufnr)
        var diags = lsp#diag#DiagsGetErrorCount(bufnr)

        str ..= lsp#buffer#BufLspServerGet(bufnr).name

        if diags.Error != 0
            str ..= ':%#DiagStatusError#' .. diags.Error .. '%*'
        endif
        if diags.Warn != 0
            str ..= ':%#DiagStatusWarn#' .. diags.Warn .. '%*'
        endif
        if diags.Hint != 0
            str ..= ':%#DiagStatusHint#' .. diags.Hint .. '%*'
        endif
        if diags.Info != 0
            str ..= ':%#DiagStatusInfo#' .. diags.Info .. '%*'
        endif

        str ..= '%#'
    endif
    return str
enddef
