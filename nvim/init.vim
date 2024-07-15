" -----------------------------------------------
" --- options ---
" -----------------------------------------------
"TODO:
" checkout `quickfixtextfunc`

set ttimeoutlen=0              " timeout for key sequences of terminal like esc and such

set noswapfile undofile undodir=/tmp/$USER.vimundo " Undo file shouldn't replace version control

" Uncomment to disable
 "let loaded_matchparen = 1

set mouse=ar                   " mouse support
let mapleader = " "

set completeopt=menu,menuone,noinsert
set pumheight=6 previewheight=10
set wildignorecase wildmode=longest:list      " behave like bash

set guicursor=n-v-c-sm:block,i-ci-ve:ver25,r-cr-o:hor20
set signcolumn=yes:1
set noshowmode
set shortmess=aoFOtT           " using a custome command instead of `F` option
" set cmdwinheight=12            " the special window that opens with q: or ctrl-f in cmd mode.
set laststatus=2
if &laststatus
    set showcmdloc=statusline
    set statusline=
    " Left
    "set stl+=%(%#Number#%{GetGitSignsStatus()}\ %*%)
    set stl+=%(%#number#%{v:lua.GitSignsStatus()}\ %*%)
    set stl+=%(\ %m%)
    set stl+=%(%q%h%w%r%)
    set stl+=\ %f
    " Middle
    set stl+=%=
    set stl+=%S
    " Right
    set stl+=%=
    set stl+=%([%{%v:lua.GetRunningLsp()%}%{%v:lua.GetDiag()%}]%)
    "set stl+=%([%{%v:lua.GetRunningLsp()%}]%)
    set stl+=\ \ \ \ %-8(%l,%c%)\ %P
    "set stl+=\ %y
else
    set rulerformat=%40(%([%{%v:lua.GetRunningLsp()%}%{%v:lua.GetDiag()%}]%)%=[%l,%c\|%P]\ %m%q%w\ %y%)
endif

set scrolloff=10

set splitbelow splitright

set ignorecase smartcase
" set nowrap                     " Neovim become extremely slow and unresponsive editing large file with linewrap on

set smartindent
set nosmarttab                 " when unset you can delete inserted tab with C-w without deleting the word before it
set expandtab shiftwidth=4 tabstop=4
set foldmethod=marker
set textwidth=90
"set virtualedit=onemore

set diffopt=internal,filler,closeoff,indent-heuristic,algorithm:histogram

set showbreak=>                " Break line symbol
set fillchars=diff:╱

if executable('rg')
    set grepprg=rg\ -H\ --no-heading\ --vimgrep
    set grepformat=%f:%l:%c:%m
endif

augroup FormatGroup
    autocmd!
    " ftplugin's default options usualy set formatoptions. but I don't want that.
    " I want consistent formating options across any file type.
    " TODO: find a better workaround.
    autocmd BufWinEnter * set formatoptions=tcrqljn1p " defaults: tcroql
augroup end

" set iskeyword-=_
set nomodeline                 " would cause problem with keil project files
match CursorLine '\s\+$'       " mark trailing spaces as errors using highlight group CursorLine
filetype plugin indent on
let g:vimsyn_embed = 'l'
syntax on
set termguicolors

" TODO:
" set define=
" set list

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
    Plug 'tpope/vim-eunuch' "?
    Plug 'tpope/vim-abolish' "?
    Plug 'embear/vim-localvimrc'
    Plug 'romainl/vim-cool' " smarter search highlight.
    " Plug 'junegunn/vim-slash'
    "Plug 'pgdouyon/vim-evanesco'
    Plug 'ton/vim-alternate'
    Plug 'vbextreme/dumpx'

    " TODO: choose one!
    Plug 'tpope/vim-fugitive'
    Plug 'junegunn/gv.vim'

    "Plug 'chrisbra/Colorizer'


    Plug 'pechorin/any-jump.vim'

    Plug 'romainl/Apprentice'
    Plug 'takiyu/tango-lx'

    if has("nvim")
        Plug 'ibhagwan/fzf-lua', {'branch': 'main'}

        Plug 'brenoprata10/nvim-highlight-colors'

        Plug 'sindrets/diffview.nvim'
        Plug 'lewis6991/gitsigns.nvim'
        Plug 'vim-scripts/tango.vim'
        Plug 'junegunn/seoul256.vim'
        Plug 'lifepillar/vim-solarized8'

        Plug 'yorickpeterse/nvim-pqf'

        "Plug 'nvim-lua/plenary.nvim'
        "Plug 'nvim-telescope/telescope.nvim', { 'tag': '0.1.8' }

        Plug 'p00f/clangd_extensions.nvim'

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



packadd shout

let t:shout_cmd = ""
nnoremap co :Sh<space>
nnoremap cc :Sh <C-r>=expand(t:shout_cmd)<cr>

" --- easy-align ---

" --- vim-commentary ---

" --- vim-rooter ---
let g:rooter_silent_chdir = 1

" --- rip-grep ---
" let g:rg_highlight = 1

" --- alternate-file ---
let g:AlternatePaths = ['../itf', '../inc', '../include', '../source', '../src', '.', '..']
let g:AlternateExtensionMappings = [
            \{'.c': '.h', '.h': '.c'},
            \{'.cpp': '.h', '.h': '.cpp'},
            \{'.cpp': '.hxx', '.hxx': '.cpp'},
            \{'.cpp': '.hpp', '.hpp': '.cpp'},
            \]

" --- nvim-highlight-colors ---
lua require('nvim-highlight-colors').setup({ enable_named_colors = false, render = 'background'})

" --- fzf-lua ---
lua require('fzf-lua').setup{fzf_bin = 'fzf', fzf_colors = true, winopts = { split = "botright new", border = 'none', preview = { hidden = 'nohidden', layout = "horizontal", horizontal = 'right:50%', delay = 50 , winopts = { number = false } } }, previewers = { builtin = { treesitter = { enable = false} } }, keymap = { builtin = { true,  ["ctrl-g"] = "" }, fzf = { true, ["ctrl-g"] = ""} } }

" --- GitSgings ---
lua require('gitsigns').setup()

" --- lsp ---
lua require 'Lsp'

" lua require 'Telescope'
"
" -----------------------------------------------
" --- keymaps ---
" -----------------------------------------------
cmap <C-x>f <C-r>=expand('%:p')<cr>
cmap <C-x>d <C-r>=expand('%:p:h').'/'<cr>
cmap <C-x>r redir<space>@l\|<space>\|redir<space>end<C-left><C-left>
cmap <C-j> <Down>
cmap <C-k> <Up>

tmap <C-]> <C-\><C-n>

" if not using terminal
inoremap <C-S-v> <C-r>+
xnoremap <C-S-v> <C-r>+
inoremap <C-c> <esc>
inoremap <C-u> <esc>vbU`]a

inoremap <C-c> <esc>
inoremap <C-u> <esc>vbU`]a
inoremap <C-z> <esc>b1z=`]a
inoremap <c-x><c-f> <cmd>lua require("fzf-lua").complete_path()<cr>

noremap <F4> [I:let nr = input("Which one: ")<Bar>exe "normal " .. nr .. "[\t"<cr>

map '      `
map p      pV`]=
map P      PV`]=
map gp     "+p
map gP     "+P
noremap gy     "+y
nmap Y      y$
nmap gY     "+Y
" noremap L    $
" noremap H    ^
noremap n      nzz
noremap N      Nzz
noremap Q      @q
noremap <C-j>  <cmd>cn<cr>
noremap <C-k>  <cmd>cp<cr>
noremap gV     V`]
noremap gj     kddpkJ0
noremap gk     K
noremap gd     [<C-I>
noremap gn     ]<C-I>
noremap gz     1z=
noremap zs     :%s/\s\+$//e<cr>''
noremap <C-g>  1<C-g>
noremap <C-h>  :tabp<cr>
noremap <C-l>  :tabn<cr>
noremap <C-w>t <C-w>v:term<cr>
noremap <M-a>  'A
noremap <M-s>  'S
noremap <M-d>  'D
noremap <M-f>  'F
noremap <M-g>  'G


nnoremap gF mm:%!clang-format<cr>`m
nnoremap go <cmd>Alternate<cr>

xnoremap ga <plug>(EasyAlign)
nnoremap ga <plug>(EasyAlign)

nmap gcA gcc^dWA <C-r>"
nmap gcH <cmd>r ~/.config/nvim/snips/Hcomment<cr>gc2j=2jjf-ela
nmap gch <cmd>r ~/.config/nvim/snips/hcomment<cr>gcc=lf-ela
nmap gcd yygccp

noremap  gw mO<cmd>Rg<cr>
noremap  gW mO:Rg ""<left>
xnoremap gw mOy<cmd>Rg "<C-r>""<cr>

xnoremap <C-e> oeo
xnoremap <C-S-e> oEo
xnoremap <C-b> ogeo
xnoremap <C-S-b> ogEo

noremap <leader>gg :Gitsigns<space>
noremap <leader>gp <cmd>Gitsigns preview_hunk_inline<cr>
noremap <leader>gb <cmd>Gitsigns blame_line<cr>
noremap ]G         <cmd>Gitsigns preview_hunk<cr>
noremap ]g         kj<cmd>Gitsigns next_hunk<cr><cmd>Gitsigns preview_hunk<cr>
noremap [g         jk<cmd>Gitsigns prev_hunk<cr><cmd>Gitsigns preview_hunk<cr>

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

"noremap <leader>t <cmd>Telescope<cr>

nnoremap <leader>d :bp\|bd #<cr>
" nnoremap <Leader>d :call <SID>BufKill("bdelete!")<CR>
" nnoremap <Leader>D :call <SID>BufKill("bwipe!")<CR>

nmap <leader>B :b<space>
" nmap <leader>f :e<space><C-x>f
nmap <leader>e :e<space><C-x>d
nmap <leader>E :Exp<cr>
nmap <leader>h :vert h<space>
" nmap <leader>c :cd <C-x>d<cr>

" nnoremap cd :Gcd<CR>:pwd<CR>
" do git ...
nnoremap <silent> dgb :Git blame<CR>
nnoremap <silent> dgs :Git <Bar> wincmd J<CR>
nnoremap <silent> dgd :Gvdiffsplit<CR>
nnoremap <silent> dgC :tab split<Bar>Git diff --cached<CR>:Git commit<CR>
nnoremap <silent> dga :Gwrite<CR>
nnoremap <silent> dgr :Gread<CR>
nnoremap <silent> dgp :Git push origin master<CR>
" see git ...
nnoremap <silent> sgl :Git log<CR>
nnoremap <silent> sgb :Git branch<CR>
nnoremap <silent> sgd :0Git diff<CR>
nnoremap <silent> sgc :0Git diff --cached<CR>
nnoremap <silent> sgh :0Git show HEAD --format=short<CR>

" comment if using 'pgdouyon/vim-evanesco'
 nnoremap *       *N
 xnoremap *       y/\V<C-R>"<cr>N
 nnoremap #       #N
 xnoremap #       y?\V<C-R>"<cr>N

"substitute
nnoremap <C-s>s  :s/<C-R>=expand('<cword>')<cr>//g<Left><Left>
xnoremap <C-s>s  :s//g<Left><Left>
nnoremap <C-s>f  :%s/<C-R>=expand('<cword>')<cr>//g<Left><Left>
xnoremap <C-s>f  y:<C-w>%s/<C-r>"//g<Left><Left>
nnoremap <C-s>ip yiwvip<Esc>:'<,'>:s/<C-R>"//g<Left><Left>
nnoremap <C-s>ap yiwvap<Esc>:'<,'>:s/<C-R>"//g<Left><Left>

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
command! Lsp lua LspStartServer()

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



    function! EchoFileName(timer)
        let f = expand('%:p:~')
        if len(f) < 80
            echo f
        endif
    endfunction

    "autocmd BufEnter * call timer_start(0, 'EchoFileName')
    "autocmd BufEnter *
    "            \ let f = expand('%:p:~')
    "            \ | if len(f) < 80
    "            \ |     echo f
    "            " \ |     normal gg
    "            " \ |     call feedkeys("gg")
    "            \ | endif

    autocmd BufEnter * call feedkeys("\<C-g>")

    autocmd Filetype tex,text,markdown,gitcommit setlocal spell
    autocmd Filetype cpp,rust setlocal matchpairs+=<:>
    autocmd Filetype netrw call NetrwConfig()
    autocmd Filetype qf nmap <buffer> <Esc> ZQ
    " autocmd Filetype qf wincmd L
    autocmd BufAdd .clang* set filetype=yaml
    autocmd BufAdd /tmp/bash* set filetype=sh " for the v command in bash vi mode
    autocmd BufReadPost *.lub set filetype=lua

    autocmd BufWritePost *.vim,.vimrc,nvim/lua/*.lua source %

    autocmd TextYankPost * silent! lua vim.highlight.on_yank({ higroup="Visual", timeout=25 })
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

" ----------------------------------------------------------------------
" BufKill
" ----------------------------------------------------------------------
function! s:BufKill(kill_command)
    let buf_to_kill = bufnr("%")
    let orig_win = winnr()
    let orig_tab = tabpagenr()
    for i in range(tabpagenr("$"))
        execute "noautocmd tabnext " . (i + 1)
        while bufwinnr(buf_to_kill) != -1
            execute "noautocmd" bufwinnr(buf_to_kill) "wincmd w"
            execute bufname("%") ==# bufname("#") ? "wincmd q" : "buffer #"
        endwhile
    endfor
    execute "noautocmd tabnext" orig_tab
    execute "noautocmd" orig_win "wincmd w"
    execute "silent!" a:kill_command buf_to_kill
endfunction

" ----------------------------------------------------------------------
" Fugitive Settings
" ----------------------------------------------------------------------
augroup fugitive_vimrc
    autocmd!
    autocmd BufReadPost fugitive://* setlocal bufhidden=delete
augroup END

 "-----------------------------------------------
 "--- colors ---
 "-----------------------------------------------

color arc
hi Normal guibg=NONE

 "hi Normal guibg=#202020

" color apprentice
" hi SignColumn guibg=bg
" hi Delimiter guifg=fg guibg=NONE
" hi Delimiter guibg=none
" hi Function guifg=#D5D592
" hi Function guifg=#d0d08c
" hi Search guibg=#D5D592
" hi Constant guifg=#dfA869
" hi  GitSignsAdd       guifg=#8F9D6A     guibg=NONE    gui=NONE cterm=NONE
" hi  GitSignsDelete    guifg=#af5f5f     guibg=NONE    gui=NONE cterm=NONE
" hi  GitSignsChange    guifg=#789AC0     guibg=NONE    gui=NONE cterm=NONE
" " hi! link @lsp.type.nameSpace Macro
" " hi statusline guibg=#444444 guifg=#87875f
" " hi statuslineNC guifg=bg
" hi folded guibg=bg
" " hi NormalFloat guibg=#393939
" " hi Function guifg=PaleGreen
" " hi Statement gui=none
" " hi Type gui=none
" " hi VertSplit guibg=#666666 guifg=#666666

" color gruber-darker
" hi Normal guibg=#333333

 "color oblivion

 "color desert
 "hi Normal guibg=NONE
 "hi NonText guibg=bg
 "hi Function guifg=lightgreen
 "hi Statement gui=NONE
 "hi Type gui=NONE
 "hi Statement guifg=#f0e68c
 "hi PreProc   guifg=#cd5c5c
 "hi Type      guifg=#bdb76b
 "hi  GitSignsAdd       guifg=lightgreen     guibg=NONE    gui=NONE cterm=NONE
 "hi  GitSignsDelete    guifg=#cd5c5c     guibg=NONE    gui=NONE cterm=NONE
 "hi  GitSignsChange    guifg=#6dceeb     guibg=NONE    gui=NONE cterm=NONE


 "color naysayer
 ""hi Normal guibg=NONE
 "hi NonText guibg=bg
 "hi EndOfBuffer guibg=bg
