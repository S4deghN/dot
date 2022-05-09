" -----------------------------------------------
" options
" -----------------------------------------------
set timeoutlen=800
set 

set mouse+=a                            "mouse support

set shortmess+=caoOtTI
set nowrap

set number                              "linen numbers
set cursorline
set cursorlineopt=number
set laststatus=0
set signcolumn=yes:1                    "always show sign column with fixed width of 1

set guicursor=n-v-c-sm-i-ci-ve:block,r-cr-o:hor20

set scrolloff=10

set autoindent
set expandtab                           "convert tabs to spaces
set shiftwidth=4                        "the number of spaces inserted for each indentation
set tabstop=4



" -----------------------------------------------
" colors
" -----------------------------------------------
syntax on
set termguicolors                       "uses gui colors

let g:gruvbox_sign_column = 'bg0'
let g:gruvbox_color_column = 'bg0'
color gruvbox



" -----------------------------------------------
" remaps
" -----------------------------------------------
let mapleader = " "
inoremap <C-c> <esc>

" yank
nmap Y y$
nnoremap <leader>y "+y
nnoremap <leader>Y "+Y
nnoremap <leader>p "+p
nnoremap <leader>P "+P

" navigation
nnoremap <C-h>     <C-w>h
nnoremap <C-j>     <C-w>j
nnoremap <C-k>     <C-w>k
nnoremap <C-l>     <C-w>l
nnoremap L         :bn<CR>
nnoremap H         :bp<CR>
nnoremap cb        :bd<CR>
nnoremap <leader>e :Exp<CR>

" open terminal at the bottom
nnoremap <leader>t :sp<bar>term<cr><c-w>J:resize10<cr> 
tnoremap <Esc> <C-\><C-n>

xmap ga <Plug>(EasyAlign)
nmap ga <Plug>(EasyAlign)



" -----------------------------------------------
" cmds
" -----------------------------------------------
" doesn't work for neovim until version 0.8 aparently
" https://github.com/neovim/neovim/issues/1496
command! W w !sudo ehco hello    " Save with root permission
