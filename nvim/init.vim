" -----------------------------------------------
" --- plugins ---
" -----------------------------------------------
if empty(glob('~/dot/nvim/autoload/plug.vim'))
    silent !curl -fLo ~/dot/nvim/autoload/plug.vim --create-dirs
                \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    au VimEnter * PlugInstall --sync | source $MYVIMRC
endif

"let loaded_matchparen = 0
call plug#begin()
Plug 'junegunn/vim-easy-align'
Plug 'airblade/vim-rooter'
Plug 'tpope/vim-sleuth'
"Plug 'tpope/vim-vinegar'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-endwise'
Plug 'tpope/vim-capslock'
Plug 'tpope/vim-eunuch'
Plug 'dimercel/todo-vim'
Plug 'chrisbra/Colorizer'
Plug 'romainl/vim-qf'
Plug '~/.config/nvim/local/vim8-shout'
"Plug '~/.config/nvim/local/vim-term'
Plug '~/.config/nvim/local/vim-cool'
Plug '~/.config/nvim/local/vorg'

" for now I just don't wanna deal with other plugins so I use the lua
Plug 'ibhagwan/fzf-lua', {'branch': 'main'}
Plug 'lewis6991/gitsigns.nvim'
Plug 'stevearc/oil.nvim'
" Lsp
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

Plug 'fcpg/vim-orbital'
Plug 'sstallion/vim-wtf'
Plug 'fcpg/vim-complimentary'
call plug#end()

let g:rooter_silent_chdir = 1
let g:rooter_patterns = ['.git', '_darcs', '.hg', '.bzr', '.svn', 'package.json', '.gitignore', 'Makefile']

let g:easy_align_delimiters = {
            \ '\': {'pattern': '\\$'},
            \ }

let g:qf_max_height = 8

" ubuntu doesn't put the file in plugin folder of vim by default
"let distro = trim(system("sed -n 's/^ID=//p' /etc/os-release"))
"if distro == "ubuntu"
"    source /usr/share/doc/fzf/examples/fzf.vim
"endif

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
lua require 'Oil'
lua require('gitsigns').setup{ signs = { add = { text = '|' }, change = { text = '|' }, delete = { text = '_' }, topdelete = { text = '‾' }, changedelete = { text = '~' }, untracked = { text = '┆' }}}

" TODO:nvim/plugin/alter.vim
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
set signcolumn=no
set noshowmode
set guicursor=n-v-c-sm:block,i-ci-ve:ver20,r-cr-o:hor20
"set guicursor=r-cr-o:hor20
set scrolloff=3
set scrolljump=0
set shortmess=aoFOtT
set smartindent
" when unset you can delete inserted tab with C-w without deleting the word before it
set nosmarttab
set expandtab
set shiftwidth=4 tabstop=4
set foldmethod=marker
set textwidth=100
"set cursorline
" set virtualedit=onemore
set splitbelow splitright
set jumpoptions=view,stack
" line wrap symbol
set showbreak=\
set fillchars=diff:╱
set diffopt=internal,filler,closeoff,indent-heuristic,algorithm:histogram,linematch:60

" shows `listchars` (tab trailing whitespace ...)
set listchars=tab:»\ ,trail:-
set nolist

"set diffopt=internal,filler,closeoff,indent-heuristic,algorithm:histogram
" TODO: look this up for big word!

"set iskeyword-=_

" Sane indentation
set cinoptions+=:0,ls,g0,N-s,E-s,(s,k0,j1,J1,L0
" TODO: in case of problems enable this based on filetype.
set tagcase=match

if executable('rg')
    set grepprg=rg\ -H\ --no-heading\ --vimgrep
    set grepformat=%f:%l:%c:%m
endif

" put the more unlikey first so that when it is the case you search that first.
set path=.,**,/usr/src/*/include,/usr/include
" if match case is not set to `match` tag search becomes really slow!
set tagcase=match


set laststatus=2
if &laststatus
    set showcmdloc=statusline
    set statusline=
    " Left
    set stl+=%.35f
    "set stl+=%t
    "set stl+=%(%m%)
    set stl+=%(\ %m%q%h%w%r%)
    set stl+=\ \ \ \ %P\ %10(%l:%c\ \ %)
    set stl+=%(\ \ \ \ Git:%{v:lua.GitSignsStatus()}%)
    set stl+=%(\ \ \ \ LSP:%{v:lua.GetRunningLsp()}%{%v:lua.GetDiag()%}%)
    " Middle
    set stl+=\ %=
    set stl+=%S
    " Right
    set stl+=\ %=
    set stl+=
else
    set rulerformat=%60(%([%{%v:lua.GetRunningLsp()%}%{%v:lua.GetDiag()%}]%)\ \ \ \ %(Git:%{v:lua.GitSignsStatus()}%)%=\ \ \ \ %-8(%l,%c%)\ %P%)
endif

"augroup ruler
"    autocmd BufEnter * call feedkeys("\<C-g>")
"augroup end

let mapleader = " "

" -----------------------------------------------
" --- coloring ---
" -----------------------------------------------
" mark trailing spaces as errors using highlight group CursorLine
match CursorLine '\s\+$'
filetype plugin indent on
syntax on
set termguicolors

color gruvbox

"hi normal gui

"hi Type guifg=goldenrod2
"hi! link Statement Type
"hi! link Conditional Type
"hi! link Repeat Type
"hi! link Label Type
"hi Macro guifg=fg
"hi Function guifg=fg gui=NONE

"color gruber
"hi Normal guibg=#363534

"hi Normal guibg=#312C2A
"hi Normal guibg=#413C3A
"hi Normal guibg=#3B3736
"hi Normal guibg=#3B3736
"hi Normal guibg=#2b2726
"hi Normal guibg=#383838
"hi Normal guibg=#3f3d3b

"color arc
"hi normal guibg=#191919

"color off
"hi Normal guibg=#2A2827
"hi Normal guibg=NONE

"color handy
"hi Normal guibg=#000000
"hi NormalFloat guibg=#282828
""hi Normal guibg=#2e2c2a
""hi Normal guibg=#2c2c2c
""hi Normal guibg=#242424

"color desert
"hi Normal guifg=#eeeeee guibg=NONE
"hi Statement gui=NONE
"hi! link Type Statement
"hi Identifier guifg=fg
"hi Macro guifg=fg
"hi Operator guifg=fg
"hi String guifg=#ffa0a0
"hi Number guifg=fg
"hi Constant guifg=fg
"hi Statusline   guibg=#444444 guifg=#dddddd
"hi StatuslineNC guibg=#444444 guifg=#bbbbbb
"hi! link StatusLineTerm StatusLine
"hi! link StatusLineTermNC StatusLineNC
"hi WinSeparator guibg=#444444 guifg=#444444
"hi NormalFloat guibg=#444444
"hi NonText guibg=bg guifg=gray
"hi Todo guibg=bg guifg=#cd5c5c
"hi @lsp.type.comment guifg=NONE guibg=#282828
"hi @lsp.type.namespace guifg=fg

"color imgui
"hi normal guifg=#cccccc guibg=#000000
"hi Statement guifg=#569ce6
""hi Type guifg=yellow3
"hi PreProc guifg=#509090
"hi Comment guifg=#307030
"hi Number guifg=#00cc00
"
"hi! link Directory Special
"
"hi WinSeparator guifg=#202020 guibg=#202020
"hi StatuslineNC guibg=#202020
"hi StatuslineNC guibg=#202020

"color orbital
"hi Normal guifg=#dddddd
"hi PreProc guifg=#5fafff

" -----------------------------------------------
" --- keymaps ---
" -----------------------------------------------
map ' `

inoremap <silent> <Esc> <Esc>g`^
inoremap <C-j> <C-G>u<Esc>O
inoremap <C-k> <Del>
inoremap <C-z> <C-G>u<esc>b1z=`]a
inoremap <C-u> <esc>ugi
" for accepting auto complete
inoremap <C-f> <C-y>
inoremap <C-^> <esc><C-^>
inoremap <C-s> <Plug>CapsLockToggle


" TODO: make this work with my own keymaps. maybe just move all copy-pasta maping to this plugin
"call yankstack#setup()
"nmap <C-p> <Plug>yankstack_substitute_older_paste
"nmap <C-n> <Plug>yankstack_substitute_newer_paste

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
" having mz...g`z block ruins key combinations like "0p
noremap p p`[=`]
noremap P P`[=`]

noremap gp mz"+p`[=`]g`z
noremap gP mz"+P`[=`]g`z
inoremap <C-S-v> <C-r>+
vmap <C-S-v> "+p
nmap <C-S-v> "+p

" indent
nmap     +   mz[%=%g`z
imap   <C-b> <Esc>+gi
nnoremap =if mzggVG=g`z
nnoremap =ap mz=apg`z
nnoremap =ip mz=ipg`z
nnoremap ==  mz=ipg`z
vnoremap =   mz=g`z

" format
nnoremap gqif mzggVGgqgg`z
nnoremap gqap mzgqapg`z
nnoremap gqip mzgqipg`z
nnoremap gql  mzgqlg`z
vnoremap gq   mzgqg`z
noremap  gz 1z=
noremap  zs mz:%s/\s\+$//e<cr>''g`z
nnoremap gF mz:%!clang-format<cr>g`z
nmap gcA gcc^dWA <C-r>"
nmap gcd yygccpg`]

nnoremap ga <plug>(EasyAlign)
xnoremap ga <plug>(EasyAlign)
nnoremap ga\ mz<plug>(EasyAlign)ap\g`z

" navigation
nnoremap j gj
nnoremap k gk
nnoremap gj j
nnoremap gk k
noremap <C-h> <cmd>bp<cr>
noremap <C-l> <cmd>bn<cr>
noremap <C-j> <cmd>cn<cr>
noremap <C-k> <cmd>cp<cr>
noremap <M-q> g`Qg`"
noremap <M-w> g`Wg`"
noremap <M-e> g`Eg`"
noremap <M-r> g`Rg`"
noremap <M-t> g`Tg`"

noremap <M-d> dw

"nnoremap <C-n> <C-e>
"nnoremap <C-p> <C-y>
"noremap gd [<C-I>

function! TagJumpSplit()
    :exec "stag " .. expand('<cword>')
    call MoveOpenedWinodwToSaneSplit()
endfunction
noremap <C-w>d     :call TagJumpSplit()<cr>
noremap <C-w><C-d> :exec VertOrNot() .. " stag " .. expand('<cword>')<cr>
"noremap gd         :exec "tag " .. expand('<cword>')<cr>
noremap gn ]<C-I>
noremap gk K
nnoremap * *N
xnoremap * y/\V<C-R>"<cr>N
nnoremap # #N
xnoremap # y?\V<C-R>"<cr>N
noremap n nzz
noremap N Nzz
noremap <C-w>t :belowright term<cr>
"map <Tab> %
"map <S-Tab> [%

" Oil://other things

" cmd
cmap <C-x>f <C-r>=expand('%:p')<cr>
" :s means substitute, we are substituting <url>:// with nothing. for buffers like Oil and such.
cmap <C-x>d <C-r>=expand('%:p:h:s?\S\+:\/\/??').'/'<cr>
"cmap <C-x>d <C-r>=getcwd().'/'<cr>
cmap <C-x>r redir<space>@l\|<space>\|redir<space>end<C-left><C-left>
cmap <C-j> <Down>
cmap <C-k> <Up>
" fast access
"nnoremap <leader>d  :bd<cr>
nnoremap <leader>d  :Bdelete<cr>
nmap     <leader>B  :b<space>
nmap     <leader>e  :e<space><C-x>d
nmap     <leader>t  :tabnew<space><C-x>d
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
noremap gh <cmd>Gitsigns preview_hunk_inline<cr>
noremap gH <cmd>Gitsigns preview_hunk<cr>
noremap ]g <cmd>Gitsigns next_hunk<cr>
noremap [g <cmd>Gitsigns prev_hunk<cr>

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

nnoremap cc :wa<cr>:Sh <C-r>=expand(t:shout_cmd)<cr>

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
nnoremap <C-s>h  :'<,'>:s/<C-R>=expand('<cword>')<CR>//g<Left><Left>
nnoremap <C-s>ip yiwvip<Esc>:'<,'>:s/<C-R>"//g<Left><Left>
nnoremap <C-s>ap yiwvap<Esc>:'<,'>:s/<C-R>"//g<Left><Left>

" Miscellaneous
noremap <C-g>  1<C-g>

" change hex to [s]ymbol
nnoremap cs "sdiw:call HexToSymbol(expand(@s))<cr>

imap <expr> <Tab>   vsnip#jumpable(1)  ? '<Plug>(vsnip-jump-next)' : '<Tab>'
smap <expr> <Tab>   vsnip#jumpable(1)  ? '<Plug>(vsnip-jump-next)' : '<Tab>'
imap <expr> <S-Tab> vsnip#jumpable(-1) ? '<Plug>(vsnip-jump-prev)' : '<S-Tab>'
smap <expr> <S-Tab> vsnip#jumpable(-1) ? '<Plug>(vsnip-jump-prev)' : '<S-Tab>'

nnoremap <leader>a :set operatorfunc=GrepOperator<cr>g@
vnoremap <leader>a :<c-u>call GrepOperator(visualmode())<cr>

function! GrepOperator(type)
    let saved_unnamed_register = @@

    if a:type ==# 'v'
        normal! `<v`>y
    elseif a:type ==# 'V'
        normal! `<v`>y
    elseif a:type ==# 'char'
        normal! `[y`]
    else
        return
    endif

    echo @@
    "silent execute "grep! -R " . shellescape(@@) . " ."
    "copen

    let @@ = saved_unnamed_register
endfunction

" -----------------------------------------------
" --- functions ---
" -----------------------------------------------
function! UseSplitOrCreate()
    let current_win_pos = win_screenpos(0)
    let winnr = winnr()

    if &columns > 160
        if winnr != winnr('1l')
            return win_getid(winnr('1l'))
        elseif winnr != winnr('1h')
            return win_getid(winnr('1h'))
        else
            :botright vsplit
            :wincmd p
            return win_getid(winnr('#'))
        endif
    else
        if winnr != winnr('1j')
            return win_getid(winnr('1j'))
        elseif winnr != winnr('1k')
            return win_getid(winnr('1k'))
        else
            :botright split
            :wincmd p
            return win_getid(winnr('#'))
        endif
    endif
endfunction

function! MoveOpenedWinodwToSaneSplit()
    let prev_winnr = winnr('#')
    if prev_winnr == 0 | return | endif

    let split_to_use = UseSplitOrCreate()
    if win_getid(prev_winnr) == split_to_use | return | endif

    let bufnr = bufnr('%')
    let view = winsaveview()
    let old_win_id = win_getid()

    call win_gotoid(split_to_use)

    exec "buffer " .. bufnr
    call winrestview(view)
    call win_execute(old_win_id, 'close')
endfunction

function! AltFile()
    "let oldpath=&path
    "set path+=../**
    if match(expand("%:t"),"\\.h") > 0
        let s:flipname = substitute(expand("%:t"),'\.h','.c',"")
        exe ":find " s:flipname
    elseif match(expand("%:t"),"\\.c") > 0
        let s:flipname = substitute(expand("%:t"),'\.c','.h',"")
        exe ":find " s:flipname
    endif
    "let &path=oldpath
endfun

function! g:JumpToDefinition()
    let fallbacks = [
                \"lua vim.lsp.buf.definition()",
                \"normal! \<C-]>",
                \"normal! gd",
                \"normal! [\<C-I>",
                \]

    for cmd in fallbacks
        try
            let s = execute(cmd)
            " echomsg $'s: {s}'
            if strlen(s) < 2 || s =~? '"\([\~\/]\|\S\+\/\)\S\+"\s.*'
                 echomsg $'used {cmd}'
                break
            endif
        catch
            " echomsg $'we catched on: {cmd}: {v:exception}'
            continue
        endtry
    endfor
endfunction

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
        call system("tmux rename-window \"".filename."\"")
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

function! HexToSymbol(hex)
    exec 'normal iU' .. a:hex .. ' '
endfunction

command! -nargs=* -count Time :call Time(<count>,<q-args>)

function! Time(count, args)
    let repeat = (a:count <= 0 ? 1 : a:count)
    let k = 0
    let start = reltime()
    while k < repeat
        exe a:args
        let k = k + 1
    endwh
    let time = reltimestr(reltime(start))

    redraw

    if repeat == 1
       echomsg "Execution took " . time ." sec."
    else
       echomsg repeat . " repetitions took ". time ." sec."
    endif
endfu


" -----------------------------------------------
" --- commands ---
" -----------------------------------------------
command! DiffOrig vert new | set bt=nofile | r ++edit # | 0d_ | diffthis | wincmd p | diffthis
command! Syn call Syn()
command! Run call system("tmux-run ".&filetype)
command! DiagToggle lua DiagToggle()
command! AutoCompleteToggle lua CmpAutoCompleteToggle()
command! Lsp lua LspStartServer()
command! -nargs=1 Grep silent grep! <f-args> | copen | wincmd p

command! -nargs=1 -complete=option Set call SetOption(<f-args>)
command! SetGrep call SetOption("grepprg")
command! SetMake call SetOption("makrprg")

command! -nargs=1 -complete=file Dump call CaptureOutput("objdump -C -l -S -d " .. <f-args>, "[dump]", "asm")
command! -nargs=1 -complete=file Asm call CaptureOutput(<f-args>  .. " -o- -S -fverbose-asm", "[asm]", "asm")
command! -nargs=1 -complete=file PreProc call CaptureOutput(<f-args>  .. " -o- -E", "[PreProc]", "c")

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

    " TODO: for now we just ignore if columns are too small but we need our horizontal splits to
    " also use existing horizontal splits.
    autocmd BufWinEnter man://* call MoveOpenedWinodwToSaneSplit()
    autocmd Filetype fugitive call MoveOpenedWinodwToSaneSplit()
    "autocmd Filetype help
    "autocmd BufWinEnter */doc/*.txt if strlen(VertOrNot()) > 0 | wincmd L | endif
    autocmd BufWinEnter */doc/*.txt call MoveOpenedWinodwToSaneSplit()

    autocmd BufAdd .clang* set filetype=yaml
    " for visual mode in bash vi mode
    autocmd BufAdd /tmp/bash* set filetype=sh
    autocmd BufReadPost *.lub set filetype=lua

    autocmd CmdwinEnter * nmap <buffer> q :q<cr>
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
" TODO: maybe setting `nohiden` or a specific netrw variable can prevent the buffer form
" disappearing after open a file from it and then trying to jump back with <C-^>
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

" Notes:
"   Search a c file for all non static function
"       assuming function modifiers are on the same line with the function defeniton
"       `^\(static\|\s\+\|#\)\@!.*(`
