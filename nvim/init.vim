" TODO:
" [ ] make `:chistory` work with fzf
" [ ] make `:registers` work with fzf
" [ ] in visual search (rg and such) search for literal string instead of regex.

" -----------------------------------------------
" --- options ---
" -----------------------------------------------
" timeout for key sequences of terminal like esc and such
set ttimeoutlen=0
" Undo file shouldn't replace version control
set noswapfile undofile undodir=/tmp/$USER.vimundo
set mouse=ar
set completeopt=menu,noinsert,popup
set pumheight=6 previewheight=10
set nowildmenu wildignorecase wildmode=longest,list,full
set ignorecase smartcase
set signcolumn=yes:1
set noshowmode
set guicursor=n-v-c-sm:block,i-ci-ve:ver25,r-cr-o:hor20
set shortmess=aoFOtT
set smartindent
" when unset you can delete inserted tab with C-w without deleting the word before it
set nosmarttab
set expandtab shiftwidth=4 tabstop=4
set foldmethod=marker
set textwidth=100
" set virtualedit=onemore
set splitbelow splitright
set jumpoptions=view,stack
" line wrap symbol
set showbreak=\
set fillchars=diff:╱
"set diffopt=internal,filler,closeoff,indent-heuristic,algorithm:histogram
" TODO: look this up for big word!
"set iskeyword-=_

" switch case indentation
set cinoptions+=1l:N0
set cinoptions=>s,e0,n0,f0,{0,}0,^0,L-1,:s,=s,l1,b0,gs,hs,N0,E0,ps,ts,is,+s,c3,C0,/0,(2s,us,U0,w0,W0,k0,m0,j0,J0,)20,*70,#0,P0

if executable('rg')
    set grepprg=rg\ -H\ --no-heading\ --vimgrep
    set grepformat=%f:%l:%c:%m
endif

set path=.,**,/usr/include

set laststatus=2
if &laststatus
    set showcmdloc=statusline
    set statusline=
    " Left
    set stl+=%(%m%)
    set stl+=\ %f
    set stl+=%(%q%h%w%r%)
    " Middle
    set stl+=%=
    set stl+=%S
    " Right
    set stl+=%=
    set stl+=%([%{%v:lua.GetRunningLsp()%}%{%v:lua.GetDiag()%}]%)
    set stl+=\ \ \ \ %-8(%l,%c%)\ %P
else
    set rulerformat=%60(%([%{%v:lua.GetRunningLsp()%}%{%v:lua.GetDiag()%}]%)%=\ \ \ \ %-8(%l,%c%)\ %P%)
endif

let mapleader = " "

" -----------------------------------------------
" --- coloring ---
" -----------------------------------------------
match CursorLine '\s\+$'
filetype plugin indent on
syntax on
" TODO: look this up!
let g:vimsyn_embed = 'l'
let g:c_gnu = 1
let g:c_functions = 1
let g:c_function_pointers = 1
" mark trailing spaces as errors using highlight group CursorLine
set termguicolors
color arc

" -----------------------------------------------
" --- plugins ---
" -----------------------------------------------
"let loaded_matchparen = 0

call plug#begin()
Plug 'junegunn/vim-easy-align'
Plug 'airblade/vim-rooter'
Plug 'chrisbra/Colorizer'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-endwise'
"Plug 'junegunn/fzf.vim'
Plug 'romainl/vim-qf'
Plug 'lewis6991/gitsigns.nvim'
Plug 'dnlhc/glance.nvim'
"Plug 'ojroques/nvim-lspfuzzy'
Plug 'ibhagwan/fzf-lua', {'branch': 'main'}
Plug '~/.config/nvim/local/vim8-shout'
Plug '~/.config/nvim/local/vim-cool'
" for now I just don't wanna deal with other plugins so I use the lua
Plug 'neovim/nvim-lspconfig'
Plug 'p00f/clangd_extensions.nvim'
Plug 'hrsh7th/nvim-cmp'
    Plug 'hrsh7th/cmp-nvim-lsp'
    Plug 'hrsh7th/cmp-nvim-lsp-signature-help'
    Plug 'quangnguyen30192/cmp-nvim-tags'
    Plug 'hrsh7th/cmp-buffer'
    Plug 'hrsh7th/cmp-path'
    Plug 'hrsh7th/cmp-vsnip'
    Plug 'hrsh7th/vim-vsnip'
call plug#end()

let g:rooter_silent_chdir = 1
let g:rooter_patterns = ['.git', '_darcs', '.hg', '.bzr', '.svn', 'Makefile', 'package.json', '.gitignore']

let g:qf_max_height = 8

" ubuntu doesn't put the file in plugin folder of vim by default
let distro = trim(system("sed -n 's/^ID=//p' /etc/os-release"))
if distro == "ubuntu"
    source /usr/share/doc/fzf/examples/fzf.vim
endif

"let g:fzf_vim = {}
"let g:fzf_vim.preview_window = ['hidden,right,50%', 'ctrl-l']
"function! s:build_quickfix_list(lines)
"    call setqflist(map(copy(a:lines), '{ "filename": v:val, "lnum": 1 }'))
"    copen
"    wincmd p
"endfunction
"let g:fzf_action = {
"            \ 'ctrl-q': function('s:build_quickfix_list'),
"            \ 'ctrl-t': 'tab split',
"            \ 'ctrl-x': 'split',
"            \ 'ctrl-v': 'vsplit',
"            \}
"let g:fzf_layout = { 'down': '33%' }
"let g:fzf_vim.buffers_jump = 1
""let g:fzf_history_dir = '~/.local/share/fzf-history'

let t:shout_cmd = ""

lua require 'Lsp'
lua require 'FzfLua'
lua require('gitsigns').setup()
lua require('glance').setup()
"lua require('lspfuzzy').setup { methods = 'all', jump_one = true, save_last = true, callback = nil, fzf_preview = { 'hidden,right,50%,+{2}-/2', 'ctrl-l' }, fzf_action = { ['ctrl-t'] = 'tab split', ['ctrl-v'] = 'vsplit', ['ctrl-x'] = 'split', }, fzf_modifier = ':~:.', fzf_trim = true }
"
" -----------------------------------------------
" --- keymaps ---
" -----------------------------------------------
map ' `

inoremap <C-j> <C-j><Up>
inoremap <C-k> <Del>
inoremap <C-z> <esc>b1z=`]a
inoremap <C-u> <esc>ugi
" for accepting auto complete
inoremap <C-f> <C-y>
inoremap <C-^> <esc><C-^>

" yank
nnoremap yif mzggVGyg`z
nnoremap yap yap}
nnoremap yip yip}
nnoremap y} y}}
nnoremap y{ y{
map gy "+y
map gY "+Y
vnoremap y   mzyg`z
vnoremap gy  mz"+yg`z
" paste, goto pase start, mark it, select pasted lines, reindent, go back to
" marked pase
noremap p p`[mz=`]g`z
noremap P P`[mz=`]g`z
map gp "+p
map gP "+P
inoremap <C-S-v> <C-r>+
vmap <C-S-v> "+p
nmap <C-S-v> "+p

" indent
nnoremap =if mzggVG=g`z
nnoremap =ap mz=apgg`z
nnoremap =ip mz=ipgg`z
vnoremap =   mz=g`z

" format
nnoremap gqif mzggVGgqgg`z
nnoremap gqap mzgqapg`z
nnoremap gqip mzgqipg`z
nnoremap gql  mzgqlg`z
vnoremap gq   mzgqg`z
noremap  gz 1z=
noremap  zs :%s/\s\+$//e<cr>''
nnoremap gF mz:%!clang-format<cr>g`z
nmap gcA gcc^dWA <C-r>"
nmap gcn yygccp
nnoremap ga <plug>(EasyAlign)
xnoremap ga <plug>(EasyAlign)


" navigation
noremap <C-h> <cmd>tabp<cr>
noremap <C-l> <cmd>tabn<cr>
noremap <C-j> <cmd>cn<cr>
noremap <C-k> <cmd>cp<cr>
noremap <M-a> g`Ag`"
noremap <M-s> g`Sg`"
noremap <M-d> g`Dg`"
noremap <M-f> g`Fg`"
noremap <M-g> g`Gg`"
noremap <M-q> g`Qg`"
noremap <M-w> g`Wg`"
noremap <M-e> g`Eg`"
noremap <M-r> g`Rg`"
noremap <M-t> g`Tg`"
nnoremap <C-n> <C-e>
nnoremap <C-p> <C-y>
noremap gd [<C-I>
noremap gn ]<C-I>
noremap gk K
nnoremap * *N
xnoremap * y/\V<C-R>"<cr>N
nnoremap # #N
xnoremap # y?\V<C-R>"<cr>N
"noremap n nzz
"noremap N Nzz
noremap <C-w>t :belowright term<cr>
"map <Tab> %
"map <S-Tab> [%

" cmd
cmap <C-x>f <C-r>=expand('%:p')<cr>
cmap <C-x>d <C-r>=expand('%:p:h').'/'<cr>
cmap <C-x>r redir<space>@l\|<space>\|redir<space>end<C-left><C-left>
cmap <C-j> <Down>
cmap <C-k> <Up>

" fast access
nnoremap <leader>d  :bp\|bd #<cr>
nmap     <leader>B  :b<space>
nmap     <leader>e  :e<space><C-x>d
nmap     <leader>E  :Exp<cr>
nmap     <leader>h  :h<space>
"noremap  <leader>f  :Files<cr>
"nmap     <leader>F  :Files<space><C-x>d
"nnoremap <leader>w  :Rg <C-r>=expand('<cexpr>')<cr><cr>
"vnoremap <leader>w  :<C-u>Rg <C-r>=GetVisualSelection()<cr><cr>
"nnoremap <leader>W  :RG<cr>
"nnoremap <leader>s  :RG<cr>
"noremap  <leader>r  :Histor<cr>
"noremap  <leader>b  :Buffers<cr>
"noremap  <leader>H  :Helptags<cr>
"noremap  <leader>gf :GFiles<cr>
"noremap  <leader>gs :GFiles?<cr>
"noremap  <leader>gc :Commits<cr>
"noremap  <leader>gC :BCommits<cr>

noremap  <leader><leader> <cmd>FzfLua<cr>
noremap  <leader><cr>     <cmd>FzfLua resume<cr>
noremap  <leader>f        <cmd>FzfLua files<cr>
noremap  <leader>r        <cmd>FzfLua oldfiles<cr>
noremap  <leader>b        <cmd>FzfLua buffers<cr>
noremap  <leader>H        <cmd>FzfLua help_tags<cr>
nnoremap <leader>w        <cmd>FzfLua grep_cword<cr>
xnoremap <leader>s        <cmd>FzfLua grep_visual<cr>
nnoremap <leader>s        <cmd>FzfLua live_grep<cr>
noremap  <leader>lr       <cmd>FzfLua lsp_references<cr>
noremap  <leader>ld       <cmd>FzfLua lsp_definitions<cr>
noremap  <leader>lD       <cmd>FzfLua lsp_declarations<cr>
noremap  <leader>lf       <cmd>FzfLua lsp_finder<cr>
noremap  <leader>li       <cmd>FzfLua lsp_incoming_calls<cr>
noremap  <leader>lo       <cmd>FzfLua lsp_outgoing_calls<cr>

nnoremap <leader>gg :Git<cr>

nnoremap <leader>co :ClangdSwitchSourceHeader<cr>
nnoremap <leader>ct :ClangdTypeHierarchy<cr>
nnoremap <leader>ci :ClangdSymbolInfo<cr>

"noremap <leader>gg :Gitsigns<space>
noremap <leader>gd :Gitsigns diffthis<space>
noremap <leader>gr <cmd>Gitsigns reset_hunk<cr>
noremap <leader>gu <cmd>Gitsigns undo_stage_hunk<cr>
noremap <leader>gb <cmd>Gitsigns blame_line<cr>
noremap <leader>gp <cmd>Gitsigns preview_hunk<cr>
noremap <leader>gh <cmd>Gitsigns preview_hunk_inline<cr>
noremap ]g         <cmd>Gitsigns next_hunk<cr><cmd>Gitsigns preview_hunk<cr>
noremap [g         <cmd>Gitsigns prev_hunk<cr><cmd>Gitsigns preview_hunk<cr>

nnoremap sn :Sh<space>
nnoremap ss :Sh <C-r>=expand(t:shout_cmd)<cr>
nnoremap sq :ShoutToQf<cr>
nnoremap sc :Shut<cr>
nnoremap so :NotShut<cr>
nnoremap sx :Kill<cr>
nnoremap sj :NextErrorJump<cr>
nnoremap sk :PrevErrorJump<cr>
nnoremap s0 :FirstErrorJump<cr>
nnoremap s$ :LastErrorJump<cr>

nnoremap gw :Grep <C-r>=expand('<cexpr>')<cr><cr>
vnoremap gw :<C-u>Grep <C-r>=GetVisualSelection()<cr><cr>
nnoremap gW :Grep<space>

nnoremap <leader>q <Plug>(qf_qf_toggle_stay)
nnoremap <leader>Q :call FzfChistory()<cr>

"substitute
nnoremap <C-s>s  :s/<C-R>=expand('<cword>')<cr>//g<Left><Left>
xnoremap <C-s>s  :s//g<Left><Left>
nnoremap <C-s>f  :%s/<C-R>=expand('<cword>')<cr>//g<Left><Left>
xnoremap <C-s>f  y:<C-w>%s/<C-r>"//g<Left><Left>
nnoremap <C-s>ip yiwvip<Esc>:'<,'>:s/<C-R>"//g<Left><Left>
nnoremap <C-s>ap yiwvap<Esc>:'<,'>:s/<C-R>"//g<Left><Left>

" Miscellaneous
noremap <C-g>  1<C-g>

imap <expr> <Tab>   vsnip#jumpable(1)  ? '<Plug>(vsnip-jump-next)' : '<Tab>'
smap <expr> <Tab>   vsnip#jumpable(1)  ? '<Plug>(vsnip-jump-next)' : '<Tab>'
imap <expr> <S-Tab> vsnip#jumpable(-1) ? '<Plug>(vsnip-jump-prev)' : '<S-Tab>'
smap <expr> <S-Tab> vsnip#jumpable(-1) ? '<Plug>(vsnip-jump-prev)' : '<S-Tab>'

" -----------------------------------------------
" --- functions ---
" -----------------------------------------------
function! GetGitSignsStatus()
    if !exists('b:gitsigns_status_dict.root')
        return ''
    endif
    " let d = b:gitsigns_status_dict
    " " return d.head.' +'.d.added.' ~'.d.changed.' -'.d.removed
    " return d.head
    let ret = b:gitsigns_status_dict.head
    " if !exists('b:gitsigns_status_dict.added')
    "     let ret = 'U - ' .. ret
    " endif
    return ret
endfunction

function! s:tmux_apply_title(time)
    let filename = expand("%:t")
    if strlen(filename)
        call system("tmux rename-window \"[".filename."]\"")
    endif
endfunc

function! s:tmux_reset_title(time)
    call system("tmux set-window-option automatic-rename on")
endfunc

" Get highlight groups of word under cursor in Vim
function! Syn()
    for id in synstack(line("."), col("."))
        echo synIDattr(id, "name")
    endfor
endfunction

function! VertOrNot() abort
    let result = ''
    if &columns >= 160 && winlayout()[0] !=# 'row'
        let result .= 'vertical'
    endif
    return result
endfunction

function! GetVisualSelection()
    let l:mode = mode()
    let l:content = ''
    let l:start = {}
    let l:end = {}

    if l:mode == 'v' || l:mode == 'V' || l:mode == "\<C-V>"
        " getpos() -> [bufnum, lnum, col, off]
        let l:start = getpos('.')
        let l:end = getpos('v')

        if l:mode == 'V'
            let l:start[2] = 1
            let l:end[2] = 999
        endif
    else
        let l:start = getpos("'<")
        let l:end = getpos("'>")
    endif

    let l:lines = getline(l:start[1], l:end[1])
    if len(l:lines) <= 0
        return ''
    endif

    let l:lines[-1] = strpart(l:lines[-1], 0, l:end[2])
    let l:lines[0] = strpart(l:lines[0], l:start[2] - 1)

    let l:content = join(l:lines)
    return l:content
endfunction

function! SetOption(option)
    echohl Function
    exec "let default = &" .. a:option
    let input = input(a:option .. ": ", default , "option")
    echohl None
    if strlen(input) == 0
        return
    endif
    " escape spaces
    let prg=substitute(input, '\ ', '\\\ ', 'g')
    exec "set " .. a:option .. "=" .. prg
endfunction

function! FzfChistory()
    redir => hlist
    silent chistory
    redir end
    "echo hlist

    let src = split(hlist, '\n')
    let src = map(src, { _, v -> substitute(v, '^\(>*\s*\)[^0-9]*\|\sof\s[0-9]\|errors', '\1\ ', 'g')})

    return fzf#run(fzf#wrap('chistory', { 'source': src, 'sink': function({ num -> execute(num[3] .. "chistory") }) }))
endfunction

" -----------------------------------------------
" --- commands ---
" -----------------------------------------------
command! DiffOrig vert new | set bt=nofile | r ++edit # | 0d_ | diffthis | wincmd p | diffthis
command! Syn call Syn()
command! Run call system("tmux-run ".&filetype)
command! DiagToggle lua vim.diagnostic.enable(not vim.diagnostic.is_enabled())
command! Lsp lua LspStartServer()
command! -nargs=1 Grep silent grep! <f-args> | copen | wincmd p

command! -nargs=1 -complete=option Set call SetOption(<f-args>)
command! SetGrep call SetOption("grepprg")
command! SetMake call SetOption("makrprg")

" -----------------------------------------------
" --- auto commands ---
" -----------------------------------------------
augroup auto
    autocmd!
    autocmd BufWritePost *.vim,vimrc,.vimrc,nvim/lua/*.lua source %
    " this option is set by ftplugin for each file type. I just want a consistant format option
    " across all file types thus the autocmd.
    " defaults: tcroql
    autocmd BufEnter * set formatoptions=tcrqljn1p
    " Mark `"` is the position when last exiting the current buffer.
    autocmd BufReadPost *
                \ if line("'\"") >= 1 && line("'\"") <= line("$") && &ft !~# 'commit'
                \ |   exe "normal! g`\""
                \ | endif
    "autocmd BufEnter * call feedkeys("\<C-g>")
    " TODO: move file type specific autocmds to their ftplugin file.
    autocmd Filetype tex,text,markdown,gitcommit setlocal spell
    autocmd Filetype cpp,rust setlocal matchpairs+=<:>
    autocmd Filetype netrw call NetrwConfig()

    autocmd Filetype qf nmap <buffer> <Esc> ZQ
    autocmd Filetype qf setlocal nowrap
    autocmd Filetype qf nmap <buffer> <Left>  <Plug>(qf_older)
    autocmd Filetype qf nmap <buffer> <Right> <Plug>(qf_newer)
    "autocmd BufEnter quickfix call QfResize()
    "autocmd BufEnter * if &l:buftype ==# 'quickfix' | call QfResize() | endif

    autocmd Filetype man if strlen(VertOrNot()) > 0 | wincmd L | endif
    "autocmd Filetype help
    autocmd BufWinEnter */doc/*.txt if strlen(VertOrNot()) > 0 | wincmd L | endif

    autocmd BufAdd .clang* set filetype=yaml
    " for visual mode in bash vi mode
    autocmd BufAdd /tmp/bash* set filetype=sh
    autocmd BufReadPost *.lub set filetype=lua

    autocmd CmdwinEnter * nmap <buffer> <Esc> :q<cr>
    autocmd CmdwinEnter * nmap <buffer> <C-c> :q<cr>
    autocmd  FileType fzf set laststatus=0 noshowmode noruler
                \| autocmd BufLeave <buffer> set laststatus=2 showmode ruler

    " the timer mitigate lag and unnecessary title changes in mapings that jump around
    autocmd VimResume,VimEnter,BufEnter * call timer_start(1, 's:tmux_apply_title')
    autocmd VimLeave,VimSuspend * call timer_start(1, 's:tmux_reset_title')
augroup end

" -----------------------------------------------
" --- netrw ---
" -----------------------------------------------
" netrw sucks! but it works :)
let g:netrw_keepdir=0 " change dir as browsing dir changes

function! NetrwDel()
    normal 0y$
    call system("mv \"".getreg('@0')."\" /tmp/")
endfunction

function! NetrwConfig()
    setlocal cursorlineopt=line

    let g:netrw_banner=0
    nmap <buffer> h -^
    nmap <buffer> <Left> -^
    nmap <buffer> l <cr>
    nmap <buffer> <Right> <cr>
    nmap <buffer> . gh
    nmap <buffer> P <C-w>z

    " TODO: changing permissions with `gp` doesn't work

    " TODO: add and delete and undo function.
    " the idea is to have a netrw undo file in /tmp and `mv` deleted
    " file/directory to it with directory information so that we can move theme
    " back to the correct place in system with undo function.
    " g:netrw_keepdir has to be unset so we change directory as we borows.

    " delete file/directory under cursor recursively
    nmap <buffer> D :call NetrwDel()<cr><C-l>
    " retrieve the last deleted file
    " nmap <buffer> u
endfunction
