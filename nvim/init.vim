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
set history=10000 " it's the maximum
set backspace=indent,eol,start
set showcmd
set hidden " stop complaints about switching buffer with changes
" <esc> in visula mode take some time to apply. ttimeoutlen=0 resolves it.
set timeoutlen=1000 " timeout for vim mappings
set ttimeoutlen=0   " timeout for key sequences of terminal like esc and such
set noautochdir " using the rooter plugin
set noswapfile
set nobackup
set undofile
set undodir=/tmp/vimundo " Undo file shouldn't replace version
set mouse+=a "mouse support
" using a custome command instead of `F` option
set shortmess+=asFtT

set cursorline
set cursorlineopt=number
set laststatus=0
set signcolumn=no

set scrolloff=0
set scrolljump=-50
set textwidth=80
set cmdwinheight=12 " the special window that opens with :q or ctlr-f in cmd mode.

set hlsearch
set incsearch
set ignorecase
set smartcase
set nowrapscan

set showbreak=>
set formatoptions+=jn1p " defaults: tcroql
set nosmarttab " when unset you can delete inserted tab with C-w without deleting the word before it
set smartindent
set autoindent
set expandtab "convert tabs to spaces
set shiftwidth=4 "the number of spaces inserted for each indentation
set tabstop=4
set foldmethod=marker
set concealcursor=

set iskeyword+=-
match CursorLine '\s\+$' " mark trailing spaces as errors using highlight group CursorLine

" -----------------------------------------------
" --- plugins ---
" -----------------------------------------------
call plug#begin()
Plug 'junegunn/vim-easy-align'
Plug 'tpope/vim-commentary'
Plug 'airblade/vim-rooter'
Plug 'junegunn/fzf.vim'
Plug 'adelarsq/vim-matchit'
Plug 'ap/vim-css-color'
Plug 't9md/vim-smalls'
" TODO
Plug 'tpope/vim-fugitive'
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
    Plug 'hrsh7th/cmp-buffer'
    Plug 'hrsh7th/cmp-path'
    Plug 'L3MON4D3/LuaSnip'
    Plug 'saadparwaiz1/cmp_luasnip'
call plug#end()

" --- sneak ---
map f <Plug>(smalls)

" --- easy-align ---
xmap ga <Plug>(EasyAlign)
nmap ga <Plug>(EasyAlign)

" --- vim-commentary ---
autocmd FileType c,cpp setlocal commentstring=//\ %s
nmap gcA gcc^dWA <C-r>"
nmap gcH :r ~/.config/nvim/snips/Hcomment<cr>gc2jjela
nmap gch :r ~/.config/nvim/snips/hcomment<cr>gccela

" --- vim-rooter ---
let g:rooter_silent_chdir = 1

" --- fzf ---
nnoremap \f :Files<CR>
nnoremap \r :History<CR>
nnoremap \w :Rg<CR>
nnoremap \b :Buffers<CR>
nnoremap \h :Helptags<CR>

" --- lsp ---
lua require "Lsp"
set rulerformat=%40(%{%v:lua.GetRunningLsp()%}%{%v:lua.GetDiag()%}%=[%l,%c\|%P]\ %m%q%w\ %y%)

" -----------------------------------------------
" --- colors ---
" -----------------------------------------------
syntax on
" let c_comment_strings=1 " ?
set termguicolors
color green-arc

" -----------------------------------------------
" --- keymaps ---
" -----------------------------------------------
let mapleader = " "
inoremap <C-c> <esc>
" cmd-line window
autocmd CmdwinEnter * nmap <buffer> <C-c> :q<CR>
autocmd CmdwinEnter * vmap <buffer> <C-c> <Esc>

" yank
map Y y$
map gy "+y
map gY "+Y
map gp "+]p
map gP "+]P

" Strange right? but it just works for me. <C-e> is used for one line scrol down
" which is usually not used and it is place above d.
nnoremap <C-d>     6<C-e>
nnoremap <C-e>     6<C-y>

" Break the line
nnoremap <C-j>     i<cr><esc>
nnoremap <C-h>     :tabp<cr>
nnoremap <C-l>     :tabn<cr>
" nnoremap <silent> L         :bn<CR>
" nnoremap <silent> H         :bp<CR>
nnoremap <silent> <leader>d :bd<CR>
nnoremap <silent> <C-g>     :echo expand("%:p:~") '-' Get_file_perm()<CR>

" The editing file directory
cnoremap .fdir. <C-R>=expand('%:p:h').'/'<CR>
nmap <leader>b :b 
nmap <Leader>e :e .fdir.
nmap <Leader>E :Exp
nmap <Leader>s :split .fdir.<CR><C-w>J
nmap <Leader>v :vsplit .fdir.<CR><C-w>L
nmap <Leader>t :tabedit .fdir.<CR>
nmap <Leader>r :read .fdir.
nmap <Leader>w :write .fdir.
nmap <Leader>f :tabedit<CR>:Files<CR>

" inserts the current word under cursor into the substitute command
" substitute on the line
nnoremap <C-s>s          :s/<C-R>=expand('<cword>')<CR>//g<Left><Left>
" substitute on the entire [f]ile
nnoremap <C-s>f          :%s/<C-R>=expand('<cword>')<CR>//g<Left><Left>
" substitute on the paragraph
" TODO: How to avoid doing this hack and use any motion directly?
nnoremap <C-s>ip vip<Esc>:'<,'>:s/<C-R>=expand('<cword>')<CR>//g<Left><Left>
nnoremap <C-s>ap vap<Esc>:'<,'>:s/<C-R>=expand('<cword>')<CR>//g<Left><Left>

xnoremap <C-s>s :s//g<Left><Left>
xnoremap <C-s>f y:<C-w>%s/<C-r>"//g<Left><Left>

" `&` is synonym for `:s` (repeat last substitute).  Note
" that the flags are not remembered, thus it might
" actually work differently.  You can use `:&&` to keep
" the flags.
nnoremap & :&&<CR>

" Break the undo history
inoremap <space> <C-G>u<space>
inoremap <C-U> <C-G>u<C-U>
inoremap <C-W> <C-G>u<C-W>

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

" -----------------------------------------------
" --- cmds ---
" -----------------------------------------------
command! -nargs=0 Syn call Syn()
command! Run call system("tmux-run ".&filetype)
" command! Dev let w:dev=!w:dev
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
augroup END

augroup File
    autocmd!
    autocmd Filetype tex,text,markdown,gitcommit setlocal spell
    autocmd Filetype netrw call NetrwConfig()
    autocmd BufEnter .clang* set filetype=yaml
    autocmd BufEnter /tmp/bash* set filetype=sh " for the v command in bash vi mode
augroup end

" let w:dev = v:false
" augroup Dev
"     autocmd!
"     autocmd FocusLost * if w:dev != 0 | silent update
"     " autocmd BufWritePost */src/*.cpp call system("tmux send-keys -t right ':make\n'")
"     autocmd BufWritePost */src/*.cpp if w:dev != 0 | call system("tmux-run-cpp")
"     autocmd BufWritePost */src/*.c   if w:dev != 0 | call system("tmux-run-cpp") "for now run cpp ------------------------
"     " autocmd BufWritePost */src/*.rs call system("tmux send-keys -t right 'cargo run\n'")
" augroup end

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
    autocmd BufEnter * call timer_start(0, 'EchoFileName')
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
