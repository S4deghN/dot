" -----------------------------------------------
" options
" -----------------------------------------------
set timeoutlen=800
" set autochdir

set mouse+=a                            "mouse support

set shortmess+=caoOtTI
" set nowrap

set number                              "linen numbers
" set relativenumber
set cursorline
set cursorlineopt=number
" set laststatus=0
set signcolumn=yes:1                    "always show sign column with fixed width of

set guicursor=n-v-c-sm-i-ci-ve:block,r-cr-o:hor20

set scrolloff=8
set textwidth=80
" set cmdheight=1
" set colorcolumn=80

set smartcase
set smartindent
set autoindent
set expandtab                           "convert tabs to spaces
set shiftwidth=4                        "the number of spaces inserted for each indentation
set tabstop=4

" set spell spelllang=en_us
match Visual '\s\+$'                    " mark trailing spaces as errors

set iskeyword+="-"

" -----------------------------------------------
" plugin
" -----------------------------------------------
let g:rooter_silent_chdir = 1
let g:vimwiki_list = [{'path': '~/note/', 'syntax': 'markdown', 'ext': '.md'}]
" -----------------------------------------------
" colors
" -----------------------------------------------
syntax on
if (has("termguicolors"))                       "uses gui colors
    set termguicolors
endif
let g:gruvbox_sign_column = 'none'
let g:gruvbox_color_column = 'none'
let g:gruvbox_invert_selection = 0
let g:gruvbox_italic = 0
color gruvbox
highlight Normal guifg=fg2 guibg=none
highlight NormalFloat	guibg=bg
highlight FloatBorder   guibg=bg
highlight CursorLineNr  guibg=bg

" -----------------------------------------------
" remaps
" -----------------------------------------------
let mapleader = " "
inoremap <C-c> <esc>

nnoremap gk K

" spell
nnoremap <leader>z 1z=
" substitute trailing white spaces with nothing. e flag suppresses errors.
nnoremap zs :%s/\s\+$//e<CR>''

" yank
nnoremap Y y$
nnoremap <leader>y "+y
nnoremap <leader>Y "+y$
nnoremap <leader>Y "+Y
nnoremap <leader>p "+]p
nnoremap <leader>P "+]P

" navigation
nnoremap <C-h>     <C-w>h
nnoremap <C-j>     <C-w>j
nnoremap <C-k>     <C-w>k
nnoremap <C-l>     <C-w>l
nnoremap L         :bn<CR>
nnoremap H         :bp<CR>
nnoremap <leader>d :bd<CR>
nnoremap <leader>e :Exp<CR>
nnoremap gh        :cd ..<CR>:pwd<CR>
nnoremap gl        :cd %:h<CR>:pwd<CR>

" fzf
" let g:fzf_preview_window = ["right:50%", "ctrl-/"]
" command! -bang -nargs=? -complete=dir Files
"         \ call fzf#vim#files(<q-args>,
"         \ {'options': ["--preview", "nvim -R {}"]},
"         \ <bang>0)

" fzf
" let $FZF_DEFAULT_COMMAND = 'ag --hidden --ignore .git -g ""'
" let $FZF_DEFAULT_COMMAND = "find . -type f -not -path '*/\.git/*'"
nnoremap <leader>f  :FZF<CR>
nnoremap <leader>ff :Files<CR>
nnoremap <leader>fr :History<CR>
nnoremap <leader>fw :Rg<CR>
nnoremap <leader>fb :Buffers<CR>
nnoremap <leader>fh :Helptags<CR>

" TODO add vim-fugitive
"" git ls-files
nnoremap <leader>gf :GFiles<CR>
"" git status
nnoremap <leader>gs :GFiles?<CR>
nnoremap <leader>gc :Commits<CR>
nnoremap <leader>gb :BCommits<CR>


" open terminal at the bottom
" nnoremap <leader>t :sp<bar>term<cr><c-w>J:resize10<cr>
tnoremap <Esc> <C-\><C-n>

" easy align
xmap ga <Plug>(EasyAlign)
nmap ga <Plug>(EasyAlign)

" -----------------------------------------------
" cmds
" -----------------------------------------------
" doesn't work for neovim until version 0.8 aparently
" https://github.com/neovim/neovim/issues/1496
command! W w !sudo tee %    " Save with root permission

" -----------------------------------------------
" auto cmds
" -----------------------------------------------
augroup File
    autocmd!
    autocmd Filetype tex setlocal spell
    " autocmd Filetype tex set conceallevel=1

    autocmd Filetype markdown setlocal spell
    " autocmd FileType markdown setlocal conceallevel=2

    autocmd Filetype text setlocal spell

    autocmd filetype netrw call NetrwConfig()
augroup end

augroup Enter
    autocmd!
    autocmd BufRead,BufEnter */doc/* wincmd L
    autocmd BufRead,BufEnter man://* wincmd L

    " autocmd BufEnter * :echo expand('%:p')

    " autocmd VimEnter * call s:tmux_apply_title()
    " autocmd BufEnter * call s:tmux_apply_title()
    " autocmd VimResume * call s:tmux_apply_title()
    " autocmd VimLeave * call s:tmux_reset_title()
    " autocmd VimSuspend * call s:tmux_reset_title()
augroup end

augroup Write
    autocmd!
    autocmd BufWritePost */nvim/**.vim source %
    autocmd BufWritePost */nvim/**.lua source %
    autocmd BufWritePost plug.lua source <afile> | PackerSync
augroup end

augroup Search
    autocmd!
    autocmd CmdlineEnter /,\? :set hlsearch
    autocmd CmdlineLeave /,\? :set nohlsearch
augroup end


" -----------------------------------------------
" netrw
" -----------------------------------------------
function! NetrwConfig()
    setlocal cursorlineopt=line

    nmap <buffer> h -^
    nmap <buffer> <Left> -^
    nmap <buffer> l <CR>
    nmap <buffer> <Right> <CR>
    nmap <buffer> . gh
    nmap <buffer> P <C-w>z
endfunction

" -----------------------------------------------
" tmux
" -----------------------------------------------
function! s:tmux_apply_title() "{{{
    call system("tmux rename-window \"vi:".expand("%:t")."\"")
endfunc "}}}

function! s:tmux_reset_title() "{{{
    call system("tmux set-window-option automatic-rename on")
endfunc "}}}
