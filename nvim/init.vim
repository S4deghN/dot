" -----------------------------------------------
" --- options ---
" -----------------------------------------------
"TODO:
" checkout `quickfixtextfunc`
set wildmode=longest:list      " behave like bash
set completeopt=menu,menuone,noselect
set pumheight=5
set previewheight=10
set wildignorecase
set ttimeoutlen=0              " timeout for key sequences of terminal like esc and such
set noswapfile
set undofile
set undodir=/tmp/$USER.vimundo " Undo file shouldn't replace version control
set mouse+=a                   " mouse support
set shortmess=aoOFtT           " using a custome command instead of `F` option
" set guicursor=
set signcolumn=yes:1
set scrolloff=7
set textwidth=90
set cmdwinheight=12            " the special window that opens with q: or ctrl-f in cmd mode.
set splitbelow
set splitright
set ignorecase
set smartcase
set nomodeline
" set nowrap                     " Neovim become extremely slow and unresponsive editing large file with linewrap on
set showbreak=>                " Break line symbol
set nosmarttab                 " when unset you can delete inserted tab with C-w without deleting the word before it
set smartindent
set expandtab                  " convert tabs to spaces
set shiftwidth=4               " the number of spaces inserted for each indentation
set tabstop=4
set foldmethod=marker
set diffopt=filler,internal,algorithm:patience,indent-heuristic
set fillchars=diff:╱
" set iskeyword-=_
set virtualedit=block
match CursorLine '\s\+$'       " mark trailing spaces as errors using highlight group CursorLine

filetype plugin indent on

augroup FormatGroup
    autocmd!
    " ftplugin's default options usualy set formatoptions. but I don't want that.
    " I want consistent formating options across any file type.
    " TODO: find a better workaround.
    autocmd BufEnter * set formatoptions=tcrqljn1p " defaults: tcroql
augroup end

let mapleader=" "

" -----------------------------------------------
" --- statusline ---
" -----------------------------------------------
set laststatus=2
if &laststatus
    set showcmdloc=statusline

    set statusline=
    " Left
    set stl+=[%F]
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
    GuiFont iosevka\ extended:h13
endif
if exists('g:nvy')
    set guifont=iosevka:h14
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
    " Plug 'maxbrunsfeld/vim-yankstack'
    Plug 'embear/vim-localvimrc'
    Plug 's4deghn/vim-cool' " smarter search highlight.
    Plug 'ap/vim-css-color'
    " TODO: choose one!
    Plug 'tpope/vim-fugitive'
    Plug 'jreybert/vimagit'

    " Plug 'jackguo380/vim-lsp-cxx-highlight'

    Plug 'ton/vim-alternate'

    Plug 'romainl/Apprentice'
    Plug 'axvr/raider.vim'
    Plug 'blazkowolf/gruber-darker.nvim'
    Plug 'morhetz/gruvbox'
    Plug 'vim-scripts/vim_colors'
    Plug 'vim-scripts/railscasts'
    Plug 'voithos/vim-colorpack'

    if has("nvim")
        Plug 'ibhagwan/fzf-lua', {'branch': 'main'}

        Plug 'sindrets/diffview.nvim'
        Plug 'lewis6991/gitsigns.nvim'

        " lsp
        Plug 'neovim/nvim-lspconfig'
        Plug 'hrsh7th/nvim-cmp'
            Plug 'hrsh7th/cmp-nvim-lsp'
            Plug 'hrsh7th/cmp-nvim-lsp-signature-help'
            Plug 'hrsh7th/cmp-buffer'
            Plug 'hrsh7th/cmp-path'
            Plug 'quangnguyen30192/cmp-nvim-tags'
            Plug 'L3MON4D3/LuaSnip'
            Plug 'saadparwaiz1/cmp_luasnip'
    endif
call plug#end()

" --- easy-align ---
xmap ga <plug>(EasyAlign)
nmap ga <plug>(EasyAlign)

" --- vim-commentary ---
nmap gcA gcc^dWA <C-r>"
nmap gcH <cmd>r ~/.config/nvim/snips/Hcomment<cr>gc2j=2jjf-ela
nmap gch <cmd>r ~/.config/nvim/snips/hcomment<cr>gcc=lf-ela

" --- vim-rooter ---
let g:rooter_silent_chdir = 1

" --- rip-grep ---
let g:rg_highlight = 1
nmap gw <cmd>Rg<cr>
nmap gW :Rg ""<left>
xmap gw y<cmd>Rg "<C-r>""<cr>

" --- alternate-file ---
let g:AlternatePaths = ['../itf', '../source', '../include', '../inc', '../src', '.', '..']
let g:AlternateExtensionMappings = [
            \{'.cpp' : '.h', '.h' : '.hpp', '.hpp' : '.cpp', '.hxx' : '.cpp'},
            \{'.c': '.h', '.h': '.c'}
            \]

" --- fzf-lua ---
noremap \\       <cmd>FzfLua<cr>
noremap \<space> <cmd>FzfLua resume<cr>
noremap \f       <cmd>FzfLua files<cr>
noremap \b       <cmd>FzfLua buffers<cr>
noremap \w       <cmd>FzfLua grep_cword<cr>
noremap \W       <cmd>FzfLua live_grep<cr>
noremap \r       <cmd>FzfLua lsp_references<cr>
noremap \d       <cmd>FzfLua lsp_definitions<cr>
noremap \l       <cmd>FzfLua lsp_finder<cr>
noremap \z       <cmd>FzfLua spell_suggest<cr>
noremap \h       <cmd>FzfLua help_tags<cr>

" --- GitSgings ---
lua require 'gitsigns'.setup()

noremap <leader>gg :Gitsigns<space>
noremap <leader>gp <cmd>Gitsigns preview_hunk_inline<cr>
noremap ]g         kj<cmd>Gitsigns next_hunk<cr><cmd>Gitsigns preview_hunk<cr>
noremap [g         jk<cmd>Gitsigns prev_hunk<cr><cmd>Gitsigns preview_hunk<cr>

" --- lsp ---
lua require 'Lsp'

" -----------------------------------------------
" --- colors ---
" -----------------------------------------------
set termguicolors

color arc-green
hi Normal guibg=#202020
hi Normal guibg=#2E3436
hi Normal guibg=#232829
hi Normal guibg=#1E2223
hi Normal guibg=NONE
" hi Normal guibg=#191D1E
hi NormalFloat guibg=#232829
hi Visual guibg=#333739
hi pmenusel guibg=#2E3436
" hi VertSplit guifg=#232729
" hi MsgArea guibg=#000000

" color apprentice
" hi SignColumn guibg=bg
" hi Delimiter guifg=fg guibg=NONE
" hi Delimiter guibg=none
" hi Function guifg=#D5D592
" hi Function guifg=#d0d08c
" hi Search guibg=#D5D592
" hi  GitSignsAdd       guifg=#8F9D6A     guibg=NONE    gui=NONE cterm=NONE
" hi  GitSignsDelete    guifg=#af5f5f     guibg=NONE    gui=NONE cterm=NONE
" hi  GitSignsChange    guifg=#789AC0     guibg=NONE    gui=NONE cterm=NONE
" hi! link @lsp.type.nameSpace Macro
" hi statusline guibg=#444444 guifg=#87875f
" hi statuslineNC guifg=bg
" hi folded guibg=bg
" " hi NormalFloat guibg=#393939
" " hi Function guifg=PaleGreen
" " hi Statement gui=none
" " hi Type gui=none

" color gruber-darker
" hi Normal guibg=#333333

" color oblivion
" hi SignColumn guibg=bg
" hi Statement   gui=none
" hi Conditional gui=none
" hi Keyword     gui=none
" hi Type        gui=none

" color desert
" hi Normal guibg=NONE
" hi NonText guibg=bg
" hi Function guifg=lightgreen
" hi Statement gui=NONE
" hi Type gui=NONE
" hi Statement guifg=#f0e68c
" hi PreProc   guifg=#cd5c5c
" hi Type      guifg=#bdb76b
" hi  GitSignsAdd       guifg=lightgreen     guibg=NONE    gui=NONE cterm=NONE
" hi  GitSignsDelete    guifg=#cd5c5c     guibg=NONE    gui=NONE cterm=NONE
" hi  GitSignsChange    guifg=#6dceeb     guibg=NONE    gui=NONE cterm=NONE

" color naysayer
" hi Normal guibg=NONE
" hi NonText guibg=bg
" hi EndOfBuffer guibg=bg

" -----------------------------------------------
" --- keymaps ---
" -----------------------------------------------
noremap '    `
noremap Y    y$
noremap gy   "+y
noremap gY   "+Y
noremap gp   "+]p
noremap gP   "+]P
" noremap L    $
" noremap H    ^
noremap <F4> [I:let nr = input("Which one: ")<Bar>exe "normal " .. nr .. "[\t"<cr>
noremap n     nzz
noremap N     Nzz
noremap Q     @q
noremap <C-n> <C-e>
noremap <C-p> <C-y>
noremap <C-j> <cmd>cn<cr>
noremap <C-k> <cmd>cp<cr>
noremap gV    V`]
noremap gj    kddpkJ0
noremap gk    K
noremap gd    [<C-I>
noremap gn    ]<C-I>
noremap gz    1z=
noremap zs    :%s/\s\+$//e<cr>''

cmap <C-x>b <C-r>=expand('%:p')<cr>
cmap <C-x>d <C-r>=expand('%:p:h').'/'<cr>
cmap <C-x>r redir<space>@l\|<space>\|redir<space>end<C-left><C-left>

tmap <C-]> <C-\><C-n>

nmap <C-h>     :tabp<cr>
nmap <C-l>     :tabn<cr>
nmap <leader>d :bp\|bd #<cr>
nmap <leader>b :b<space>
nmap <leader>f :e<space><C-x>b
nmap <leader>e :e<space><C-x>d
nmap <leader>E :Exp<cr>
nmap <leader>h :vert h<space>
nmap <C-w>t    <C-w>v:term<cr>

nnoremap <C-g>   1<C-g>
nnoremap *       *N
xnoremap *       y/\V<C-R>"<cr>N
nnoremap #       #N
xnoremap #       y?\V<C-R>"<cr>N
nnoremap <C-s>s  :s/<C-R>=expand('<cword>')<cr>//g<Left><Left>
xnoremap <C-s>s  :s//g<Left><Left>
nnoremap <C-s>f  :%s/<C-R>=expand('<cword>')<cr>//g<Left><Left>
xnoremap <C-s>f  y:<C-w>%s/<C-r>"//g<Left><Left>
nnoremap <C-s>ip yiwvip<Esc>:'<,'>:s/<C-R>"//g<Left><Left>
nnoremap <C-s>ap yiwvap<Esc>:'<,'>:s/<C-R>"//g<Left><Left>

nnoremap gF mm:%!clang-format<cr>`m
nnoremap go <cmd>Alternate<cr>

inoremap <C-c> <esc>
inoremap <C-u> <esc>vbU`]a
inoremap <C-z> <esc>b1z=`]a

" if not using terminal
inoremap <C-S-v> <C-r>+
xnoremap <C-S-v> <C-r>+

" emacs :)
noremap <M-x> :
cnoremap <M-x> <C-c>

" -----------------------------------------------
" --- functions ---
" -----------------------------------------------
function! GetGitSignsStatus()
    if !exists('b:gitsigns_status_dict.added')
        return ''
    endif
    let d = b:gitsigns_status_dict
    return d.head.' +'.d.added.' ~'.d.changed.' -'.d.removed
endfunction

function! s:tmux_apply_title()
    let filename = expand("%:t")
    if strlen(filename)
        call system("tmux rename-window \"[".filename."]\"")
    endif
endfunc

function! s:tmux_reset_title()
    call system("tmux set-window-option automatic-rename on")
endfunc

" Get highlight groups of word under cursor in Vim
function! Syn()
    for id in synstack(line("."), col("."))
        echo synIDattr(id, "name")
    endfor
endfunction
" -----------------------------------------------
" --- cmds ---
" -----------------------------------------------
" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
command! DiffOrig vert new | set bt=nofile | r ++edit # | 0d_ | diffthis
            \ | wincmd p | diffthis

command! Syn call Syn()
command! Run call system("tmux-run ".&filetype)
command! DiagEnable lua vim.diagnostic.enable()
command! DiagDisable lua vim.diagnostic.disable()

" -----------------------------------------------
" --- auto cmds ---
" -----------------------------------------------
augroup autoCommands
    autocmd!
    " Mark `"` is the position when last exiting the current buffer.
    autocmd BufReadPost *
                \ if line("'\"") >= 1 && line("'\"") <= line("$") && &ft !~# 'commit'
                \ |   exe "normal! g`\""
                \ | endif

    " " autocmd BufEnter * call timer_start(0, 'EchoFileName')
    " autocmd BufEnter *
    "             \ let f = expand('%:p:~')
    "             \ | if len(f) < 80
    "             " \ |     echo f
    "             " \ |     normal gg
    "             \ |     call feedkeys("gg")
    "             \ | endif

    autocmd BufEnter * call feedkeys("\<C-g>")

    autocmd Filetype tex,text,markdown,gitcommit setlocal spell
    autocmd Filetype cpp,rust setlocal matchpairs+=<:>
    autocmd Filetype netrw call NetrwConfig()
    autocmd Filetype qf nmap <buffer> <Esc> ZQ
    autocmd BufEnter .clang* set filetype=yaml
    autocmd BufEnter /tmp/bash* set filetype=sh " for the v command in bash vi mode

    autocmd BufWritePost *.vim,.vimrc,nvim/lua/*.lua source %

    autocmd TextYankPost * silent! lua vim.highlight.on_yank({ higroup="Visual", timeout=50 })
    " autocmd SearchWrapped * echomsg 'Search wrapped!'

    autocmd CmdwinEnter * nmap <buffer> <Esc> :q<cr>
    autocmd CmdwinEnter * nmap <buffer> <C-c> :q<cr>

    autocmd VimResume,BufEnter,WinEnter,VimEnter * call s:tmux_apply_title()
    autocmd VimLeave,VimSuspend * call s:tmux_reset_title()
augroup end

" -----------------------------------------------
" --- netrw ---
" -----------------------------------------------
" netrw sucks!
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
