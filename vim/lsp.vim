vim9script

augroup lspAugroup
    autocmd!
    autocmd User LspSetup call LspOptionsSet(lspOpts)
    autocmd User LspSetup call LspAddServer(lspServers)
    autocmd User LspAttached call LspOnAttach()
augroup end

var lspOpts = {
    semanticHighlight: false,
    completionMatcher: 'icase',
    highlightDiagInline: false,
    ignoreMissingServer: true,
    autoComplete: false,
    outlineWinSize: 35,
    showDiagInBalloon: false,
    showDiagInPopup: true,
    autoHighlightDiags: false,
    showSignature: false,
    useQuickfixForLocations: true,
}

var lspServers = [
    {
        name: 'clangd',
        filetype: ['c', 'cpp'],
        path: 'clangd',
        args: [
        '--background-index',
        "--malloc-trim",
        "--enable-config",
        "--all-scopes-completion=true",
        "--completion-style=detailed",
        "--function-arg-placeholders",
        "--header-insertion=iwyu",
        "--header-insertion-decorators",
        ]
    },
    {
        name: 'rust-analyzer',
        filetype: ['rust'],
        path: 'rust-analyzer',
        args: [],
        rootSearch: ['Cargo.toml', '.git']
    }
]

def LspOnAttach()
    nmap <buffer> K    :LspHover<cr>
    nmap <buffer> gr   :LspRename<cr>
    nmap <buffer> gla  :LspCodeAction<cr>
    nmap <buffer> gls  :LspSwitchSourceHeader<cr>
    nmap <buffer> glo  :LspOutline<cr>
    nmap <buffer> glr  :LspShowReferences<cr>
    nmap <buffer> glR  :LspPeekReferences<cr>
    nmap <buffer> glci :LspIncomingCalls<cr>
    nmap <buffer> glco :LspOutgoingCalls<cr>

    nmap <buffer> ]d  :LspDiagNext<cr>
    nmap <buffer> [d  :LspDiagPrev<cr>
    nmap <buffer> gh  :LspDiagCurrent<cr>
    nmap <buffer> gld :LspDiagShow<cr>

    hi! link LspSigActiveParameter Tag
enddef

noremap gd     <scriptcmd>JumpToDefinition()<cr>
noremap <C-w>d <scriptcmd>SplitJumpToDefinition()<cr>

# --- better tag jump ---
def g:JumpTag()
    var start_bnr = bufnr()
    var start_line = line('.')
    execute("normal! \<C-]>")
    # if we didn't jump anywhere. try jumping whith [count]=2
    if bufnr() == start_bnr && line('.') == start_line
        execute("normal! \<C-t>2\<C-]>")
    endif
enddef

# --- jump to definition with fallback ---
var gd_fallbacks = [
    'LspGotoDefinition',
    'call JumpTag()',
    'normal! gd',
    'normal! [\<C-I>',
]
def JumpToDefinition()
    for cmd in gd_fallbacks
        try
            var s = execute(cmd)
            # echomsg $'s: {s}'
            if strlen(s) < 2 || s =~? '"\([\~\/]\|\S\+\/\)\S\+"\s.*'
                norm! zvzz
                utils#Spotlight()
                echomsg $'used {cmd}'
                break
            endif
        catch
            # echomsg $'we catched on: {cmd}: {v:exception}'
            continue
        endtry
    endfor
enddef

def SplitJumpToDefinition()
    split
    utils#MoveOpenedWindowToSaneSplit()
    JumpToDefinition()
enddef
