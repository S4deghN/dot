" -----------------------------------------------
" --- options ---
" -----------------------------------------------
" defaults
set nocompatible
set ttyfast
set display=lastline
set autoread
set encoding=utf-8
set nowildmenu
set wildmode=list:longest " behave like bash
set wildignorecase
set history=10000 " it's the maximum
set backspace=indent,eol,start
set showcmd
set hidden " stop complaints about switching buffer with changes
" <esc> in visula mode take some time to apply. ttimeoutlen=0 resolves it.
set timeoutlen=1000 " timeout for vim mappings
set ttimeoutlen=0   " timeout for key sequences of terminal like esc and such

set noautochdir " using the rooter plugin instead
set swapfile
set dir=/home/$USER/vimswap
set nobackup
set undofile
set undodir=/tmp/$USER.vimundo " Undo file shouldn't replace version control
set mouse+=a "mouse support

" using a custome command instead of `F` option
set shortmess+=asFtT
" don't throw the attention message on swapfile found
set shortmess+=A

set cursorline
set cursorlineopt=number
set signcolumn=yes:1

" set scrolloff=0
" set scrolljump=-50
set scrolloff=10
set textwidth=80
set cmdwinheight=12 " the special window that opens with :q or ctlr-f in cmd mode.
" set number relativenumber
set splitbelow
set splitright

set hlsearch
set incsearch
set ignorecase
set smartcase
set nowrapscan

" Break line symbol
set showbreak=>

" defaults: tcroql
set formatoptions=tcrqljn1p
" ftplugin's default options usualy set formatoptions. but I don't want that.
" I want consistent formating options across any file type.
" TODO: find a better workaround.
autocmd BufEnter * set formatoptions=tcrqljn1p

set nosmarttab " when unset you can delete inserted tab with C-w without deleting the word before it
set smartindent
set autoindent
set expandtab "convert tabs to spaces
set shiftwidth=4 "the number of spaces inserted for each indentation
set tabstop=4
set foldmethod=marker
set concealcursor=
" set guicursor=

set diffopt=filler,internal,algorithm:patience,indent-heuristic
set fillchars=diff:╱

set iskeyword+=-
match CursorLine '\s\+$' " mark trailing spaces as errors using highlight group CursorLine
let mapleader = " "

" -----------------------------------------------
" --- plugins ---
" -----------------------------------------------
" {{{
call plug#begin()
Plug 'junegunn/vim-easy-align'
Plug 'tpope/vim-commentary'
Plug 'airblade/vim-rooter'
Plug 'ap/vim-css-color'
Plug 'tpope/vim-dispatch'
Plug 'machakann/vim-sandwich'
Plug 'normen/vim-pio'
" Plug 'airblade/vim-gitgutter'
Plug 'lewis6991/gitsigns.nvim'
Plug 'wellle/context.vim'
Plug 'jremmen/vim-ripgrep'

Plug 'nvim-tree/nvim-web-devicons'
" Plug 'junegunn/fzf.vim'
Plug 'ibhagwan/fzf-lua', {'branch': 'main'}

" Plug 'nvim-lua/plenary.nvim'
" Plug 'nvim-telescope/telescope.nvim', { 'tag': '0.1.2' }

" Plug 'vimwiki/vimwiki'
Plug 'aaronbieber/vim-quicktask'
Plug 'vimoutliner/vimoutliner'

Plug 'AlexvZyl/nordic.nvim'
Plug 'p00f/alabaster.nvim'
Plug 'rose-pine/neovim'
Plug 'Mofiqul/vscode.nvim'
Plug 'gruvbox-community/gruvbox'
Plug 'drsooch/gruber-darker-vim'
Plug 'ayu-theme/ayu-vim'
Plug 'S4deghN/neovim-ayu'

" TODO
Plug 'tpope/vim-fugitive'
Plug 'sindrets/diffview.nvim'
" TODO snippets
" Plug 'garbas/vim-snipmate'
"   Plug 'MarcWeber/vim-addon-mw-utils'
"   Plug 'tomtom/tlib_vim'
" lsp
Plug 'neovim/nvim-lspconfig'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'hrsh7th/nvim-cmp'
    Plug 'hrsh7th/cmp-nvim-lsp'
    Plug 'hrsh7th/cmp-nvim-lsp-signature-help'
    " Plug 'hrsh7th/cmp-buffer'
    Plug 'hrsh7th/cmp-path'
    Plug 'L3MON4D3/LuaSnip'
    Plug 'saadparwaiz1/cmp_luasnip'
call plug#end()
" }}}

" --- easy-align ---
xmap ga <Plug>(EasyAlign)
nmap ga <Plug>(EasyAlign)

" --- vim-dispatch ---
" let g:dispatch_quickfix_height = 5

" --- vim-commentary ---
" Add comment at the end of the line
nmap gcA gcc^dWA <C-r>"
" Insert header comments
nmap gcH :r ~/.config/nvim/snips/Hcomment<cr>gc2j=2jjf-ela
nmap gch :r ~/.config/nvim/snips/hcomment<cr>gcc=lf-ela

" --- vim-rooter ---
let g:rooter_silent_chdir = 1

" --- fzf ---
" nnoremap \f :Files<CR>
" nnoremap \r :History<CR>
" nnoremap \w :Rg<CR>
" nnoremap \b :Buffers<CR>
" nnoremap \h :Helptags<CR>

" --- fzf-lua ---
nnoremap \\ :FzfLua<CR>

nnoremap \f :FzfLua files<CR>
nnoremap \b :FzfLua buffers<CR>

nnoremap \w :FzfLua grep_cword<CR>
xnoremap \w <Esc>:FzfLua grep_visual<CR>
nnoremap \W :FzfLua live_grep<CR>

nnoremap \r :FzfLua lsp_references<CR>
nnoremap \d :FzfLua lsp_definitions<CR>
nnoremap \l :FzfLua lsp_finder<CR>

nnoremap \z :FzfLua spell_suggest<CR>

nnoremap \h :FzfLua help_tags<CR>

" --- GitSgings ---
lua require('gitsigns').setup()

" --- vim-context ---
let g:context_enabled = 0

" --- vimwiki ---
" let g:vimwiki_list = [{'path': '~/note/vimwiki', 'syntax': 'markdown', 'ext': '.md'}]

" --- quick-taks ---
let g:quicktask_snip_path = '~/note/quicktask/snips'
nmap <Leader>tt :e ~/note/quicktask/tasks.quicktask

" --- rip-grep ---
let g:rg_highlight = 1
nmap gw :Rg<CR>
nmap gW :Rg ""<Left>
xmap gw y:Rg "<C-R>""<CR>

" --- Telescope ---
" lua require "Telescope"
" nnoremap \f :Telescope find_files<CR>
" nnoremap \r :Telescope oldfiles<CR>
" nnoremap \w :Telescope grep_string<CR>
" nnoremap \b :Telescope buffers<CR>
" nnoremap \h :Telescope help_tags<CR>

" --- lsp ---
lua require "Lsp"

set laststatus=3
" When not using statusline
" set rulerformat=%40(%{%v:lua.GetRunningLsp()%}%{%v:lua.GetDiag()%}%=[%l,%c\|%P]\ %m%q%w\ %y%)
" When using statusline
set rulerformat=%40(%{%v:lua.GetRunningLsp()%}%{%v:lua.GetDiag()%}%=[%l,%c\|%P]\ %y%)


" -----------------------------------------------
" --- colors ---
" -----------------------------------------------
filetype plugin indent on

syntax on
set termguicolors
color arc-dark

" -----------------------------------------------
" --- keymaps ---
" -----------------------------------------------
" inoremap <C-c> <esc>
" cmd-line window
autocmd CmdwinEnter * nmap <buffer> <C-c> :q<CR>
autocmd CmdwinEnter * vmap <buffer> <C-c> <Esc>

" yank
map Y y$
map gy "+y
map gY "+Y
map gp "+]p
map gP "+]P

" Switch case of the last typed word
inoremap <C-c> <ESC>vb~`]a

" Strange right? but it just works for me. <C-e> is used for one line scrol down
" which is usually not used and it is place above d.
" Commenting it for now since I'm not using scrolljump for a while
" Depends on `scrolljump=-50`
" nnoremap <C-d>     Lj
" nnoremap <C-e>     Hk
nnoremap <C-n>     <C-e>
nnoremap <C-p>     <C-y>

" Break the line
nnoremap <C-j>     i<cr><esc>
nnoremap <C-h>     :tabp<cr>
nnoremap <C-l>     :tabn<cr>
" nnoremap <silent> L         :bn<CR>
" nnoremap <silent> H         :bp<CR>
nnoremap <silent> <leader>d :bd<CR>
nnoremap <silent> <C-g>     :echo expand("%:p:~") '-' Get_file_perm()<CR>

" % expands to current file name. expand %% to current file directory
cnoremap %% <C-R>=expand('%:p:h').'/'<CR>
nmap <Leader>b :b 
nmap <Leader>e :e %%
nmap <Leader>E :Exp<CR>
nmap <Leader>s :split %%
nmap <Leader>S :split %%<CR><C-w>J
nmap <Leader>v :vsplit %%
nmap <Leader>V :vsplit %%<CR><C-w>L
nmap <Leader>t :tabedit %%<CR>
" nmap <Leader>r :read %%
nmap <Leader>w :write %%
nmap <Leader>f :tabedit<CR>:Files<CR>

" inserts the current word under cursor into the substitute command
" substitute on the line
nnoremap <C-s>s          :s/<C-R>=expand('<cword>')<CR>//g<Left><Left>
" substitute on the entire [f]ile
nnoremap <C-s>f          :%s/<C-R>=expand('<cword>')<CR>//g<Left><Left>
" substitute on the paragraph
" TODO: How to avoid doing this hack and use any motion directly?
nnoremap <C-s>ip yiwvip<Esc>:'<,'>:s/<C-R>"//g<Left><Left>
nnoremap <C-s>ap yiwvap<Esc>:'<,'>:s/<C-R>"//g<Left><Left>

xnoremap <C-s>s :s//g<Left><Left>
xnoremap <C-s>f y:<C-w>%s/<C-r>"//g<Left><Left>

" `&` is synonym for `:s` (repeat last substitute).  Note
" that the flags are not remembered, thus it might
" actually work differently.  You can use `:&&` to keep
" the flags.
nnoremap & :&&<CR>

" Break the undo history
" inoremap <space> <C-G>u<space>
" inoremap <C-U> <C-G>u<C-U>
" inoremap <C-W> <C-G>u<C-W>

" Search for any visual selection
xnoremap * y/\V<C-R>"<CR>
xnoremap # y?\V<C-R>"<CR>

" Re-select the last pasted text
noremap gV V`]
" like 'J' but from line above to line below
noremap gj kddpkJ
" Record macro with `qq`, replay with `Q`
noremap Q @q
" open manual, 'K' is use for lsp hover
noremap gk K
" apply the first spell candidate
nnoremap gz 1z=
" substitute trailing white spaces with nothing. e flag suppresses errors.
nnoremap zs :%s/\s\+$//e<CR>''
" go to next and previous quickfix list item
nnoremap ]c :cn<CR>
nnoremap [c :cp<CR>
" nmap  <silent> <C-s> :set opfunc=SpecialChange<CR>g@
" function! SpecialChange(type)
"     exec "normal! `[v`]"
"     exec 'let @/=@"'
"     :'<,'>:s/<C-R>=expand('<cword>')<CR>
" endfunction

" -----------------------------------------------
" --- functions ---
" -----------------------------------------------
function! Get_file_perm()
    let a=getfperm(expand('%:p'))
    if strlen(a)
        return a
    endif
endfunction

" Get highlight groups of word under cursor in Vim
function! Syn()
    for id in synstack(line("."), col("."))
        echo synIDattr(id, "name")
    endfor
endfunction

" TODO: add a generic function for build functionality managed inside tmux.
" it sould solely call an other generic bash script and pass out the environment
" information
" I found vim-dispatch!

" -----------------------------------------------
" --- cmds ---
" -----------------------------------------------
command! -nargs=0 Syn call Syn()
command! Run call system("tmux-run ".&filetype)

command! Dev autocmd TextChanged,TextChangedI * silent update

command! DiagEnable lua vim.diagnostic.enable()
command! DiagDisable lua vim.diagnostic.disable()

" -----------------------------------------------
" --- auto cmds ---
" -----------------------------------------------

" Mark `"` is the position when last exiting the current buffer.
augroup vimStartup
autocmd!
autocmd BufReadPost *
  \ if line("'\"") >= 1 && line("'\"") <= line("$") && &ft !~# 'commit'
  \ |   exe "normal! g`\""
  \ | endif
augroup end

augroup File
    autocmd!
    autocmd Filetype tex,text,markdown,gitcommit setlocal spell
    autocmd Filetype netrw call NetrwConfig()
    autocmd Filetype qf nmap <buffer> <Esc> ZQ
    autocmd BufEnter .clang* set filetype=yaml
    autocmd BufEnter /tmp/bash* set filetype=sh " for the v command in bash vi mode
augroup end

func EchoFileName(timer)
    let f = expand('%:p:~')
    if len(f) < 80
        echo f
    endif
endfunc

augroup Enter
    autocmd!
    autocmd BufRead,BufEnter */doc/* wincmd L
    autocmd BufRead,BufEnter man://* wincmd L
    " When not using status line
    " autocmd BufEnter * call timer_start(0, 'EchoFileName')
    " autocmd BufEnter * echo expand('%:p:~')
augroup end

augroup Source
    autocmd!
    autocmd BufWritePost *.vim,.vimrc,*.lua source %
augroup end

augroup yank
    autocmd!
    autocmd TextYankPost * silent! lua vim.highlight.on_yank({ higroup="Visual", timeout=100 })
augroup end

" -----------------------------------------------
" --- netrw ---
" -----------------------------------------------
" netrw sucks, it sucks. It's a giant bug.
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
    nmap <buffer> l <CR>
    nmap <buffer> <Right> <CR>
    nmap <buffer> . gh
    nmap <buffer> P <C-w>z

    " TODO: changing permissions with `gp` doesn't work

    " TODO: add and delete and undo function.
    " the idea is to have a netrw undo file in /tmp and `mv` deleted
    " file/directory to it with directory information so that we can move theme
    " back to the correct place in system with undo function.
    " g:netrw_keepdir has to be unset so we change directory as we borows.

    " delete file/directory under cursor recursively
    nmap <buffer> D :call NetrwDel()<CR><C-l>
    " retrieve the last deleted file
    " nmap <buffer> u
endfunction

" -----------------------------------------------
" --- tmux ---
" -----------------------------------------------
function! s:tmux_apply_title()
    let filename = expand("%:t")
    if strlen(filename)
        call system("tmux rename-window \"[".filename."]\"")
    endif
endfunc

function! s:tmux_reset_title()
    call system("tmux set-window-option automatic-rename on")
endfunc

autocmd VimResume,BufEnter,WinEnter,VimEnter * call s:tmux_apply_title()
autocmd VimLeave,VimSuspend * call s:tmux_reset_title()
