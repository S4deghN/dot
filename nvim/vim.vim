" -----------------------------------------------
" options
" -----------------------------------------------
set timeoutlen=800
set autochdir

set mouse+=a                            "mouse support

set shortmess+=caoOtTI
" set nowrap

set number                              "linen numbers
set cursorline
set cursorlineopt=number
set laststatus=0
set signcolumn=yes:1                    "always show sign column with fixed width of

set guicursor=n-v-c-sm-i-ci-ve:block,r-cr-o:hor20

set scrolloff=10
" set colorcolumn=120

set smartcase
set smartindent
set autoindent
set expandtab                           "convert tabs to spaces
set shiftwidth=4                        "the number of spaces inserted for each indentation
set tabstop=4

setlocal spell spelllang=en_us

" -----------------------------------------------
" colors
" -----------------------------------------------
syntax on
if (has("termguicolors"))                       "uses gui colors
  set termguicolors
endif

let g:gruvbox_sign_column = 'bg0'
let g:gruvbox_color_column = 'bg0'
let g:gruvbox_invert_selection = 0
let g:gruvbox_italic = 0
color gruvbox
highlight NormalFloat	guibg=bg
highlight FloatBorder   guibg=bg
"
" let g:gruvbox_material_background = 'medium'
" let g:gruvbox_material_foreground = 'mix'
" let g:gruvbox_material_disable_italic_comment = 1
" let g:gruvbox_material_enable_bold = 1
" let g:gruvbox_material_enable_italic = 1
" let g:gruvbox_material_better_performance = 1
" color gruvbox-material
" highlight NormalFloat	guibg=bg
" highlight FloatBorder   guibg=bg
"
" color github_dimmed
" highlight String    guifg=#57ab5a

" color github_dark_default
" let _bg=0x22272E
" highlight Normal        guibg=_bg
" highlight LineNr        guibg=_bg
" highlight CursorLineNr  guibg=_bg
" highlight Signcolumn    guibg=_bg
" highlight NormalFloat	guibg=_bg
" highlight FloatBorder   guibg=_bg

" lighter background for ayu
" color ayu
" let _fg=0xD9D5C9
" let _bg=0x283A4D
" highlight Normal        guibg=_bg guifg=_fg
" highlight NormalFloat	guibg=_bg guifg=_fg
" highlight FloatBorder   guibg=_bg guifg=_fg
" highlight Signcolumn    guibg=_bg
" highlight LineNr        guibg=_bg
" highlight CursorLineNr  guibg=_bg
" highlight Search        guibg=#626A73 guifg=Orange
" highlight Visual        guibg=#283A4D

" let g:sonokai_style = 'default'
" let g:sonokai_better_performance = 1
" let g:sonokai_disable_italic_comment = 1
" let g:sonokai_enable_bold = 1
" let g:sonokai_enable_italic = 1
" color sonokai
" highlight NormalFloat	guibg=bg
" highlight FloatBorder   guibg=bg

" -----------------------------------------------
" remaps
" -----------------------------------------------
let mapleader = " "
inoremap <C-c> <esc>

" spell
nnoremap <leader>z 1z=

" yank
nmap Y y$
noremap <leader>y "+y
noremap <leader>Y "+Y
noremap <leader>p "+p
noremap <leader>P "+P

" navigation
nnoremap <C-h>     <C-w>h
nnoremap <C-j>     <C-w>j
nnoremap <C-k>     <C-w>k
nnoremap <C-l>     <C-w>l
nnoremap L         :bn<CR>
nnoremap H         :bp<CR>
nnoremap <leader>d :bd<CR>
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

" -----------------------------------------------
" auto cmds
" -----------------------------------------------
augroup _fileName
    autocmd!
    autocmd BufEnter * :echo expand('%')
augroup end

" -----------------------------------------------
" netrw
" -----------------------------------------------
function! NetrwMapping()
  nmap <buffer> h -^
  nmap <buffer> l <CR>

  nmap <buffer> . gh
  nmap <buffer> P <C-w>z

  nmap <buffer> <Leader>dd :Lexplore<CR>
endfunction

augroup netrw_mapping
  autocmd!
  autocmd filetype netrw call NetrwMapping()
augroup END
