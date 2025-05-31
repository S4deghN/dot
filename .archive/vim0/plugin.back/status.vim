vim9script
finish

if &laststatus > 0
    set showcmdloc=statusline
    set statusline=
    # Left
    set stl+=%f
    set stl+=%(\ %m%q%h%w%r%)
    set stl+=%(\ \ \ \ Git:%{get(w:,'git_branch','')}%)
    set stl+=%(\ \ %5(%l%):%-3(%c%)%)\ \ %-3(%P%)
    # Middle
    set stl+=%=
    set stl+=%-5(%S%)
    set stl+=%=
    set stl+=%(LSP:%{%get(b:,'lsp_status','')%}%)
    # set stl+=%=
    # set stl+=
else
    # set rulerformat=%40(%(LSP:%{%get(b:,'lsp_status','')%}%)\ %(Git:%{get(w:,'git_branch','')}%)%=\ \ \ \ %-8(%l,%c%)\ %P%)
    set rulerformat=%60(%(Git:%{get(w:,'git_branch','')}%)%=\ \ \ \ %-8(%l,%c%)\ %P%)
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

b:lsp_status_timer = 0
def g:LspStatusUpdate()
    if !get(b:, 'lsp_status_timer', 0)
        b:lsp_status_timer = timer_start(100, (t) => {
            g:LspStatusSet()
            b:lsp_status_timer = 0
            redrawstatus
        })
    endif
enddef

def g:LspStatusSet()
    var bufnr = bufnr()
    if !lsp#buffer#BufHasLspServer(bufnr)
        b:lsp_status = ''
        return
    endif

    var str = lsp#buffer#BufLspServerGet(bufnr).name

    # Too distracting therefore disabled for now
    # var diags = lsp#diag#DiagsGetErrorCount(bufnr)
    # if diags.Error != 0
    #     str ..= ':%#DiagStatusError#' .. diags.Error .. '%#StatusLine#'
    # endif
    # if diags.Warn != 0
    #     str ..= ':%#DiagStatusWarn#' .. diags.Warn .. '%#StatusLine#'
    # endif
    # if diags.Hint != 0
    #     str ..= ':%#DiagStatusHint#' .. diags.Hint .. '%#StatusLine#'
    # endif
    # if diags.Info != 0
    #     str ..= ':%#DiagStatusInfo#' .. diags.Info .. '%#StatusLine#'
    # endif
    b:lsp_status = str
enddef

augroup StatusLine
    au!
    au DirChanged,WinNew,VimEnter,TerminalWinOpen,FileType * call UpdateGitBranch()
    au BufEnter,TextChanged,CursorHold * g:LspStatusUpdate()
augroup end
