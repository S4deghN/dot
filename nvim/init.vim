" -----------------------------------------------
" --- options ---
" -----------------------------------------------
set wildmode=longest:list      " behave like bash
set wildignorecase
set history=10000              " it's the maximum
set backspace=indent,eol,start
set timeoutlen=1000            " timeout for vim mappings
set ttimeoutlen=0              " timeout for key sequences of terminal like esc and such
set hidden                     " stop complaints about switching buffer with changes
set noautochdir                " using the rooter plugin instead
set noswapfile
set nobackup
set undofile
set undodir=/tmp/$USER.vimundo " Undo file shouldn't replace version control
set mouse+=a                   " mouse support
set shortmess=aoOFtT           " using a custome command instead of `F` option
set cursorline
set cursorlineopt=number
" set guicursor=
set signcolumn=yes:1
" set scrolljump=-50
set scrolloff=0
set textwidth=90
set cmdwinheight=12            " the special window that opens with :q or ctlr-f in cmd mode.
set splitbelow
set splitright
set hlsearch
set incsearch
set ignorecase
set smartcase
set wrapscan
set nowrap                     " Neovim become extremely slow and unresponsive editing large file with linewrap on
set showbreak=>>>              " Break line symbol
set matchpairs+=<:>
set nosmarttab                 " when unset you can delete inserted tab with C-w without deleting the word before it
set smartindent
set autoindent
set expandtab                  " convert tabs to spaces
set shiftwidth=4               " the number of spaces inserted for each indentation
set tabstop=4
set foldmethod=marker
set diffopt=filler,internal,algorithm:patience,indent-heuristic
set fillchars=diff:╱
" set iskeyword+=-
set virtualedit=insert,block

let mapleader=" "

filetype plugin indent on
syntax on
match CursorLine '\s\+$'       " mark trailing spaces as errors using highlight group CursorLine

augroup FormatGroup
    autocmd!
    " ftplugin's default options usualy set formatoptions. but I don't want that.
    " I want consistent formating options across any file type.
    " TODO: find a better workaround.
    autocmd BufEnter * set formatoptions=tcrqljn1p " defaults: tcroql
augroup end

" -----------------------------------------------
" --- statusline ---
" -----------------------------------------------
set laststatus=3
set showcmd
if &laststatus
    set showcmdloc=statusline
    " set rulerformat==%40(%{%v:lua.GetRunningLsp()%}%{%v:lua.GetDiag()%}%=[%l,%c\|%P]\ %y%)

    function! GetGitSignsStatus()
        if !exists('b:gitsigns_status_dict.added')
            return ''
        endif

        let d = b:gitsigns_status_dict
        return d.head.' +'.d.added.' ~'.d.changed.' -'.d.removed
    endfunction

    set statusline=
    " Left
    set stl+=[%f]
    set stl+=%(\ %)
    set stl+=%([%{GetGitSignsStatus()}\ ]%)
    set stl+=\ %q%h%w%m%r
    " Middle
    set stl+=%=
    set stl+=%S
    " Right
    set stl+=%=
    set stl+=%([%{%v:lua.GetRunningLsp()%}%{%v:lua.GetDiag()%}]%)
    set stl+=\ [%-8(%l:%c%)\ %P]
    set stl+=\ %y
else
    set rulerformat=%40(%([%{%v:lua.GetRunningLsp()%}%{%v:lua.GetDiag()%}]%)%=[%l,%c\|%P]\ %m%q%w\ %y%)
endif

if exists(':GuiFont')
    " Use GuiFont! to ignore font errors
    " GuiFont iosevka :h14

    set wrap
endif

" -----------------------------------------------
" --- plugins ---
" -----------------------------------------------
call plug#begin()
    Plug 'junegunn/vim-easy-align'
    Plug 'tpope/vim-commentary'
    Plug 'airblade/vim-rooter'
    Plug 'normen/vim-pio'
    Plug 'jremmen/vim-ripgrep'
    Plug 'tpope/vim-dispatch'
    Plug 'tpope/vim-fugitive'
    Plug 's4deghn/vim-cool'
    Plug 'ap/vim-css-color'
    " using fzf-lua instead
    " Plug 'junegunn/fzf.vim'
    Plug 'maxbrunsfeld/vim-yankstack'

    Plug 'jreybert/vimagit'

    Plug 'gruvbox-community/gruvbox'
    Plug 'fneu/breezy'
    Plug 'nanotech/jellybeans.vim'
    Plug 'lifepillar/vim-solarized8', {'branch': 'neovim'}
    Plug 'yorickpeterse/happy_hacking.vim'

    if has("nvim")
        Plug 'ibhagwan/fzf-lua', {'branch': 'main'}
        Plug 'sindrets/diffview.nvim'
        Plug 'lewis6991/gitsigns.nvim'

        " lsp
        Plug 'neovim/nvim-lspconfig'
        " Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
        Plug 'hrsh7th/nvim-cmp'
            Plug 'hrsh7th/cmp-nvim-lsp'
            Plug 'hrsh7th/cmp-nvim-lsp-signature-help'
            Plug 'hrsh7th/cmp-buffer'
            Plug 'hrsh7th/cmp-path'
            Plug 'L3MON4D3/LuaSnip'
            Plug 'saadparwaiz1/cmp_luasnip'
    endif
call plug#end()

" --- easy-align ---
xmap ga <Plug>(EasyAlign)
nmap ga <Plug>(EasyAlign)

" --- vim-commentary ---
nmap gcA gcc^dWA <C-r>"
nmap gcH :r ~/.config/nvim/snips/Hcomment<cr>gc2j=2jjf-ela
nmap gch :r ~/.config/nvim/snips/hcomment<cr>gcc=lf-ela

" --- vim-rooter ---
let g:rooter_silent_chdir = 1

" --- rip-grep ---
let g:rg_highlight = 1
nmap gw :Rg<CR>
nmap gW :Rg ""<Left>
xmap gw y:Rg "<C-R>""<CR>

" --- fzf-lua ---
nnoremap \\ :FzfLua<CR>
nnoremap \<space> :FzfLua resume<CR>

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
lua require 'gitsigns'.setup()

nnoremap <leader>gg :Gitsigns<space>
nnoremap ]g kj:Gitsigns next_hunk<CR>:Gitsigns preview_hunk<CR>
nnoremap [g jk:Gitsigns prev_hunk<CR>:Gitsigns preview_hunk<CR>

" --- lsp ---
lua require 'Lsp'

" -----------------------------------------------
" --- colors ---
" -----------------------------------------------
set termguicolors

color oblivion
hi Comment gui=italic
hi IncSearch guifg=green
" hi Visual guibg=#2C3232
" hi VertSplit guifg=#2B2B2B

" -----------------------------------------------
" --- keymaps ---
" -----------------------------------------------
nnoremap <M-1> :1tabnext<CR>
nnoremap <M-2> :2tabnext<CR>
nnoremap <M-3> :3tabnext<CR>
nnoremap <M-4> :4tabnext<CR>
nnoremap <M-5> :5tabnext<CR>
nnoremap <M-6> :6tabnext<CR>
nnoremap <M-7> :7tabnext<CR>
nnoremap <M-8> :8tabnext<CR>
nnoremap <M-9> :9tabnext<CR>

" --- miscellaneous ---
inoremap <C-c>     <ESC>
map      '         `
map      Y         y$
map      gy        "+y
map      gY        "+Y
map      gp        "+]p
map      gP        "+]P
map      L         $
map      H         ^
nnoremap <C-n>     <C-e>
nnoremap <C-p>     <C-y>
nnoremap <C-j>     :cn<CR>
nnoremap <C-k>     :cp<CR>
nnoremap !!        :%!
noremap  gV        V`]
nnoremap gz        1z=
noremap  gk        K
noremap  gj        kddpkJ
nnoremap zs        :%s/\s\+$//e<CR>''
noremap  Q         @q
nnoremap *         *N
nnoremap #         #N
nnoremap n         nzz
nnoremap N         Nzz
xnoremap *         y/\V<C-R>"<CR>N
xnoremap #         y?\V<C-R>"<CR>N
nnoremap <silent>  <C-g>     :echo expand("%:p:~") '-' Get_file_perm()<CR>

" inoremap <C-u>     <ESC>vb~`]a
inoremap <C-z>       <ESC>b1z=`]a
inoremap <C-S-V>     <C-r>+
xnoremap <C-S-V>     <C-r>+

" --- buff and window ---
nnoremap <C-h>     :tabp<CR>
nnoremap <C-l>     :tabn<CR>
nnoremap <leader>d :bp\|bd #<CR>
nmap     <leader>b :b<space>
nnoremap <C-w>t    <C-w>v:term<CR>
" % is expanded to current file name. expand %% to current file directory
cnoremap %%        <C-R>=expand('%:p:h').'/'<CR>
nmap     <leader>e :e<space>%%
nmap     <leader>E :Exp<CR>
nmap     <leader>t <C-w>s:term<CR>i
nmap     <leader>T <C-w>s:term<CR>i
tnoremap <C-]> <C-\><C-n>

" inserts the current word under cursor into the substitute command
" substitute on the line
nnoremap <C-s>s          :s/<C-R>=expand('<cword>')<CR>//g<Left><Left>
" substitute on the entire [f]ile
nnoremap <C-s>f          :%s/<C-R>=expand('<cword>')<CR>//g<Left><Left>
" substitute on the paragraph
" TODO: How to avoid doing this hack and use any motion directly?
nnoremap <C-s>ip yiwvip<Esc>:'<,'>:s/<C-R>"//g<Left><Left>
nnoremap <C-s>ap yiwvap<Esc>:'<,'>:s/<C-R>"//g<Left><Left>
" inconsistent!
xnoremap <C-s>s :s//g<Left><Left>
xnoremap <C-s>f y:<C-w>%s/<C-r>"//g<Left><Left>

" -----------------------------------------------
" --- functions ---
" -----------------------------------------------
function! Get_file_perm()
    let a=getfperm(expand('%:p'))
    if strlen(a)
        return a
    endif
endfunction

func EchoFileName(timer)
    let f = expand('%:p:~')
    if len(f) < 80
        echo f
    endif
endfunc

" Get highlight groups of word under cursor in Vim
function! Syn()
    for id in synstack(line("."), col("."))
        echo synIDattr(id, "name")
    endfor
endfunction

function! Redir(cmd, rng, start, end)
for win in range(1, winnr('$'))
    if getwinvar(win, 'scratch')
        execute win . 'windo close'
    endif
endfor
if a:cmd =~ '^!'
    let cmd = a:cmd =~' %'
        \ ? matchstr(substitute(a:cmd, ' %', ' ' . shellescape(escape(expand('%:p'), '\')), ''), '^!\zs.*')
        \ : matchstr(a:cmd, '^!\zs.*')
    if a:rng == 0
        let output = systemlist(cmd)
    else
        let joined_lines = join(getline(a:start, a:end), '\n')
        let cleaned_lines = substitute(shellescape(joined_lines), "'\\\\''", "\\\\'", 'g')
        let output = systemlist(cmd . " <<< $" . cleaned_lines)
    endif
else
    redir => output
    execute a:cmd
    redir END
    let output = split(output, "\n")
endif
vnew
let w:scratch = 1
setlocal buftype=nofile bufhidden=wipe nobuflisted noswapfile
call setline(1, output)
endfunction
" -----------------------------------------------
" --- cmds ---
" -----------------------------------------------
" This command definition includes -bar, so that it is possible to "chain" Vim commands.
" Side effect: double quotes can't be used in external commands
command! -nargs=1 -complete=command -bar -range Redir silent call Redir(<q-args>, <range>, <line1>, <line2>)

" This command definition doesn't include -bar, so that it is possible to use double quotes in external commands.
" Side effect: Vim commands can't be "chained".
command! -nargs=1 -complete=command -range Redir silent call Redir(<q-args>, <range>, <line1>, <line2>)

" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
" Only define it when not defined already.
if !exists(":DiffOrig")
  command DiffOrig vert new | set bt=nofile | r ++edit # | 0d_ | diffthis
		  \ | wincmd p | diffthis
endif

command! -nargs=0 Syn call Syn()
command! Run call system("tmux-run ".&filetype)

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

augroup FileName
    autocmd!
    autocmd BufEnter * call timer_start(0, 'EchoFileName')
augroup end

augroup File
    autocmd!
    autocmd Filetype tex,text,markdown,gitcommit setlocal spell
    autocmd Filetype netrw call NetrwConfig()
    autocmd Filetype qf nmap <buffer> <Esc> ZQ
    autocmd BufEnter .clang* set filetype=yaml
    autocmd BufEnter /tmp/bash* set filetype=sh " for the v command in bash vi mode
augroup end

augroup Enter
    autocmd!
    " Open help splits on right
    autocmd BufRead,BufEnter */doc/* wincmd L
    autocmd BufRead,BufEnter man://* wincmd L
    " autocmd BufEnter * call timer_start(0, 'EchoFileName')
    " autocmd BufEnter * echo expand('%:p:~')
augroup end

augroup Source
    autocmd!
    autocmd BufWritePost *.vim,.vimrc,*.lua source %
augroup end

augroup Visuals
    autocmd!
    autocmd TextYankPost * silent! lua vim.highlight.on_yank({ higroup="Visual", timeout=50 })
    " autocmd SearchWrapped * echomsg 'Search wrapped!'
augroup end

augroup CmdLineGroup
    autocmd!
    autocmd CmdwinEnter * nmap <buffer> <Esc> :q<CR>
    autocmd CmdwinEnter * nmap <buffer> <C-c> :q<CR>
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

augroup TmuxGroup
    autocmd!
    autocmd VimResume,BufEnter,WinEnter,VimEnter * call s:tmux_apply_title()
    autocmd VimLeave,VimSuspend * call s:tmux_reset_title()
augroup end
