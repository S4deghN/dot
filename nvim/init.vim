" TODO:
" [ ] add utility commands + keybindings to use shout for greping and commpiling in a project.
" [ ] look up how to use vim's builtin `grep`.
" [ ] look up how to use vim's builtin `make`.
" [ ] key binding for toggling qflist.
" [ ] look up location list and it's differences with qflist.


" -----------------------------------------------
" --- options ---
" -----------------------------------------------
" timeout for key sequences of terminal like esc and such
set ttimeoutlen=0
" Undo file shouldn't replace version control
set noswapfile undofile undodir=/tmp/$USER.vimundo
set mouse=ar
set completeopt=menu,menuone,noinsert
set pumheight=6 previewheight=10
set nowildmenu wildignorecase wildmode=longest,list,full
set ignorecase smartcase
set signcolumn=no
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
    set stl+=%([%{%v:lua.GetRunningLsp()%}]%)
    set stl+=\ \ \ \ %-8(%l,%c%)\ %P
else
    set rulerformat=%40(%=[%l,%c\|%P]\ %m%q%w\ %y%)
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
Plug 'junegunn/fzf.vim'
Plug '~/.config/nvim/local/vim8-shout'
Plug '~/.config/nvim/local/vim-cool'
" for now I just don't wanna deal with other plugins so I use the lua
Plug 'neovim/nvim-lspconfig'
Plug 'p00f/clangd_extensions.nvim'
call plug#end()

let g:rooter_silent_chdir = 1
let g:rooter_paterns = ['.git', '_darcs', '.hg', '.bzr', '.svn', 'Makefile', 'package.json', '.gitignore']

let g:fzf_vim = {}
let g:fzf_vim.preview_window = ['hidden,right,50%', 'ctrl-l']
function! s:build_quickfix_list(lines)
    call setqflist(map(copy(a:lines), '{ "filename": v:val, "lnum": 1 }'))
    copen
    wincmd p
endfunction
let g:fzf_action = {
            \ 'ctrl-q': function('s:build_quickfix_list'),
            \ 'ctrl-t': 'tab split',
            \ 'ctrl-x': 'split',
            \ 'ctrl-v': 'vsplit',
            \}
let g:fzf_layout = { 'down': '25%' }
let g:fzf_vim.buffers_jump = 1
let g:fzf_history_dir = '~/.local/share/fzf-history'

let t:shout_cmd = ""

lua require 'Lsp'

" -----------------------------------------------
" --- mapings ---
" -----------------------------------------------

map ' `

inoremap <C-j> <C-j><Up>
inoremap <C-k> <Del>
inoremap <C-z> <esc>b1z=`]a
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
xnoremap ga <plug>(easyalign)
nnoremap ga <plug>(easyalign)
nmap gcA gcc^dWA <C-r>"
nmap gcn yygccp


" navigation
noremap <C-h> <cmd>tabp<cr>
noremap <C-l> <cmd>tabn<cr>
noremap <C-j> <cmd>cn<cr>
noremap <C-k> <cmd>cp<cr>
noremap <M-a> 'A
noremap <M-s> 'S
noremap <M-d> 'D
noremap <M-f> 'F
noremap <M-g> 'G
nnoremap <C-n> <C-e>
nnoremap <C-p> <C-y>
noremap gd [<C-I>
noremap gn ]<C-I>
noremap gk K
nnoremap * *N
xnoremap * y/\V<C-R>"<cr>N
nnoremap # #N
xnoremap # y?\V<C-R>"<cr>N
noremap n nzz
noremap N Nzz
noremap <C-w>t :belowright term<cr>

" cmd
cmap <C-x>f <C-r>=expand('%:p')<cr>
cmap <C-x>d <C-r>=expand('%:p:h').'/'<cr>
cmap <C-x>r redir<space>@l\|<space>\|redir<space>end<C-left><C-left>
cmap <C-j> <Down>
cmap <C-k> <Up>

" fast access
nnoremap <leader>d  :bp\|bd #<cr>
nmap     <leader>b  :b<space>
nmap     <leader>e  :e<space><C-x>d
nmap     <leader>E  :Exp<cr>
nmap     <leader>h  :h<space>
nmap     <leader>q  :vert h<space>
noremap  <leader>f  :Files<cr>
nmap     <leader>F  :Files<space><C-x>d
noremap  <leader>r  :Histor<cr>
noremap  <leader>b  :Buffers<cr>
noremap  <leader>H  :Helptags<cr>
noremap  <leader>gf :GFiles<cr>
noremap  <leader>gs :GFiles?<cr>
noremap  <leader>gc :Commits<cr>
noremap  <leader>gC :BCommits<cr>
" for now use grep!
"nnoremap <leader>w        <cmd>FZF grep_cword<cr>
"nnoremap <leader>s        <cmd>RG<cr>
"xnoremap <leader>s        <cmd>FZF grep_visual<cr>
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


"substitute
nnoremap <C-s>s  :s/<C-R>=expand('<cword>')<cr>//g<Left><Left>
xnoremap <C-s>s  :s//g<Left><Left>
nnoremap <C-s>f  :%s/<C-R>=expand('<cword>')<cr>//g<Left><Left>
xnoremap <C-s>f  y:<C-w>%s/<C-r>"//g<Left><Left>
nnoremap <C-s>ip yiwvip<Esc>:'<,'>:s/<C-R>"//g<Left><Left>
nnoremap <C-s>ap yiwvap<Esc>:'<,'>:s/<C-R>"//g<Left><Left>

" Miscellaneous
noremap <C-g>  1<C-g>

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

" -----------------------------------------------
" --- commands ---
" -----------------------------------------------
command! DiffOrig vert new | set bt=nofile | r ++edit # | 0d_ | diffthis | wincmd p | diffthis
command! Syn call Syn()
command! Run call system("tmux-run ".&filetype)
command! DiagEnable lua vim.diagnostic.enable()
command! DiagDisable lua vim.diagnostic.disable()
command! Lsp lua LspStartServer()


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
    " TODO: move file type specific autocmds to their ftplugin file.
    autocmd Filetype tex,text,markdown,gitcommit setlocal spell
    autocmd Filetype cpp,rust setlocal matchpairs+=<:>
    autocmd Filetype netrw call NetrwConfig()
    autocmd Filetype qf nmap <buffer> <Esc> ZQ
    autocmd Filetype help,qf if strlen(VertOrNot()) > 0 | wincmd L | endif
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
