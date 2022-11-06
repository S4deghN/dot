" -----------------------------------------------
" options
" -----------------------------------------------
set noautochdir " using the rooter plugin
set noswapfile
set nobackup
set undofile
set undodir=/tmp/vimundo " Undo file shouldn't replace version contorl.

set mouse+=a "mouse support

set shortmess+=a

" set nonumber "linen numbers
" set relativenumber
set cursorline
set cursorlineopt=number
set laststatus=0
set signcolumn=yes:1 "always show sign column with fixed width of

set scrolloff=8
set textwidth=80

set ignorecase
set smartcase
set smartindent
set autoindent
set expandtab                           "convert tabs to spaces
set shiftwidth=4                        "the number of spaces inserted for each indentation
set tabstop=4
set foldmethod=marker

set cmdwinheight=12 " the special window that opens with :q or ctlr-f in cmd mode.

match Visual '\s\+$' " mark trailing spaces as errors

set iskeyword+=-
set encoding=utf-8
" Set completeopt to have a better completion experience
" :help completeopt
" menuone: popup even when there's only one match
" noinsert: Do not insert text until a selection is made
" noselect: Do not select, force user to select one from the menu
" set completeopt=menuone,preview,noinsert

" -----------------------------------------------
" plugin
" -----------------------------------------------
let g:rooter_silent_chdir = 1

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
let g:gruvbox_bold = 1

" color apprentice
" color gruvbox
" color alchemist

" melange specific
" highlight Delimiter       guifg=#747C84
" highlight String       gui=none
" highlight Identifier      guifg=fg

" highlight Normal          guibg=none  "guifg=#cccccc
" highlight NormalFloat	  guibg=bg    "guifg=fg2e
" highlight FloatBorder     guibg=bg

" " highlight NormalFloat	  guibg=#2F333A
" " highlight FloatBorder     guibg=#2F333A
" highlight CursorLineNr    guibg=bg
" highlight LineNr          guibg=bg guifg=#747C84
" highlight SignColumn      guibg=bg guifg=#747C84
" highlight FoldColumn      guibg=bg guifg=#747C84
" highlight SpecialKey      guibg=bg guifg=#747C84
" highlight EndOfBuffer     guibg=bg guifg=#747C84
" highlight NonText         guibg=bg guifg=#747C84
" highlight Comment         guibg=bg guifg=#747C84
" " highlight CursorLine      guibg=#232832
" " highlight CursorColumn    guibg=#232832
" highlight CursorLine      guibg=#23272E
" highlight CursorColumn    guibg=#23272E
" highlight VertSplit       guibg=none
" highlight Folded guibg=#181D22 guifg=#747C84
"
" highlight Visual          guibg=#2E3541 guifg=none gui=none
" highlight! link Visual IncSearch
"
" " highlight Function        guifg=#E6D78E
" highlight Delimiter       guifg=#969EA8
" " highlight Constant        guifg=#D3869B
" highlight Constant        guifg=#cda869
" " highlight Identifier      guifg=fg
" " highlight Identifier      guifg=#779CAA
" " highlight Identifier      guifg=#D7875F
"
" " highlight Identifier      guifg=fg
" " highlight Identifier guifg=#A8D1E1
" " highlight Identifier guifg=#95bcbc
" " highlight Identifier         guifg=#8787AF
" highlight Identifier guifg=#789AC0
" " highlight Identifier guifg=#8FBCC5
" highlight PreProc         guifg=#95bcbc
" " highlight PreProc         guifg=#83a598
" " highlight PreProc         guifg=#629494
" " highlight PreProc         guifg=#458588
" " highlight PreProc         guifg=#87AFD7
" " highlight PreProc         guifg=#8787AF
" " highlight PreProc        guifg=#789AC0
" " highlight Type         guifg=#8787AF
" highlight Type         guifg=#83a598
" " highlight Type         guifg=#cda869 gui=none
" " highlight Type         guifg=#E6D78E
" " highlight Type         guifg=#68BEA2
" " highlight Type            guifg=#87aFD7
" " highlight Type            guifg=#95bcbc
" " highlight Type        guifg=#789AC0
"
" highlight Constant        guifg=#cda869
" " highlight Constant        guifg=#D3869B
" highlight Statement       guifg=#CF6A4C gui=none
" " highlight Function        guifg=#789AC0 gui=none
" " highlight Function        guifg=#D3869B
" " highlight Function         guifg=#cda869
" " highlight Function        guifg=#87AFD7
" " highlight Function        guifg=#5F87AF
" highlight Function        guifg=#E6D78E
" " highlight Function        guifg=#95bcbc
"
" " highlight PreProc         guifg=#789AC0
" highlight String          guifg=#8F9D6A
" " highlight Special         guifg=#789AC0
" " highlight Special         guifg=#E6D78E
" highlight Special         guifg=#95bcbc
" highlight Title           guifg=#E6D78E gui=bold
" highlight Delimiter       guifg=fg
" highlight! link Delimiter Comment
"
" highlight! link Directory Constant
" highlight! link IncSearch Visual
" highlight MatchParen guifg=#E6D78E guibg=bg gui=underline
" highlight Search guibg=#E6D78E
"
" highlight DiagnosticError guifg=#af5f5f
" " highlight DiagnosticError guifg=#CF6A4C
" highlight DiagnosticWarn  guifg=#d7af5f
" highlight DiagnosticInfo  guifg=LightBlue
" highlight DiagnosticHint  guifg=#747C84
"
"
" highlight DiffDelete guifg=#af5f5f guibg=none gui=none
" highlight DiffChange guifg=#789AC0 guibg=none gui=none
" highlight DiffAdd    guifg=#8F9D6A guibg=none gui=none
"
" highlight Error         gui=bold
" highlight link TreesitterContext CursorLine
" highlight TreesitterContext gui=italic guibg=grey17

color paramount

highlight Normal          guibg=none  "guifg=#cccccc
highlight NormalFloat	  guibg=bg    "guifg=fg2e
highlight FloatBorder     guibg=bg

highlight CursorLine      guibg=#23272E
highlight CursorColumn    guibg=#23272E
highlight VertSplit       guibg=none
highlight Folded guibg=#181D22 guifg=#747C84

highlight Type         guifg=#83a598
" highlight Special      gui=none
" highlight Statement    gui=italic

highlight Error guibg=bg guifg=#af5f5f gui=underline
highlight ErrorMsg guifg=#af5f5f

highlight DiagnosticError guifg=#af5f5f
highlight DiagnosticWarn  guifg=#d7af5f
highlight DiagnosticInfo  guifg=LightBlue
highlight DiagnosticHint  guifg=#747C84


highlight! link Directory Constant
highlight! link IncSearch Visual
" highlight MatchParen guifg=#E6D78E guibg=bg gui=underline
highlight Search guibg=#E6D78E

highlight DiffDelete guifg=#af5f5f guibg=none gui=none
highlight DiffChange guifg=#789AC0 guibg=none gui=none
highlight DiffAdd    guifg=#8F9D6A guibg=none gui=none

highlight! link GitSignsAdd DiffAdd
highlight! link GitSignsDelete DiffDelete
highlight! link GitSignsChange DiffChange
" -----------------------------------------------
" ruler
" -----------------------------------------------

lua << EOF
function GetDiag()
    local str = ""
    if vim.api.nvim_get_mode()["mode"] == 'n' then
        local err  = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
        local warn = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN })
        local hint = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.HINT })
        local info = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.INFO })

        if err ~= 0 then
            str = str .. "%#DiagnosticError# E:" .. err .. "%*"
        end
        if warn ~= 0 then
            str = str .. "%#DiagnosticWarn# W:" .. warn .. "%*"
        end
        if hint ~= 0 then
            str = str .. "%#DiagnosticHint# H:" .. hint .. "%*"
        end
        if info ~= 0 then
            str = str .. "%#DiagnosticInfo# I:" .. info .. "%*"
        end
    end
    return str
end
EOF

lua << EOF
function GetRunningLsp()
    local str = ""
    vim.lsp.for_each_buffer_client(0, function(client, client_id, bufnr)
        str = str .. "[%#PreProc#" .. client.name .. "%*]"
    end)
    return str
end
EOF

" lua << EOF
" function LeftRuler(hold)
"     local diagMsg = vim.diagnostic.get(0, {lnum = vim.fn.line('.') - 1})
"     if (#diagMsg ~= 0) then
"         print(diagMsg[1].message)
"     elseif (hold) then
"         vim.cmd[[echo expand('%:p:~')]]
"     end
" end
" EOF
"
" augroup LeftRuler
"     autocmd!
"     autocmd CursorMoved,InsertLeave * :lua LeftRuler()
"     autocmd CursorHold * :lua LeftRuler(1)
" augroup end

" set ruf=%30(%=%#LineNr#%.50F\ [%{strlen(&ft)?&ft:'none'}]\ %l:%c\ %p%%%)
" set rulerformat=%36(%5l,%-6(%c%V%)\ %y%)%*

set rulerformat=%50(%{%v:lua.GetRunningLsp()%}%{%v:lua.GetDiag()%}%=[%l,%c\|%P]\ %m%q%w\ %y%)
" set rulerformat=%50(%=[%l,%c/%L]\ %m\ %{%v:lua.GetRunningLsp()%}%{%v:lua.GetDiag()%}\ [%Y]%)

" -----------------------------------------------
" keymaps
" -----------------------------------------------
let mapleader = " "
inoremap <C-c> <esc>

" cmd-line window
autocmd CmdwinEnter * nmap <buffer> <C-c> :q<CR>
autocmd CmdwinEnter * vmap <buffer> <C-c> <Esc>
" autocmd CmdwinEnter :  let b:cpt_save = &cpt | set cpt=.
" autocmd CmdwinLeave :  let &cpt = b:cpt_save

" Move linewise, except when a count is given. Useful for when &wrap is set.
" noremap <expr> j v:count ? 'j' : 'gj'
" noremap <expr> k v:count ? 'k' : 'gk'

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

" yank
map Y y$

noremap gy "+y
noremap gY "+Y
noremap gp "+]p
noremap gP "+]P

" navigation
nnoremap <C-h>     <C-w>h
nnoremap <C-l>     <C-w>l
nnoremap <C-n>     <C-e>j
nnoremap <C-p>     <C-y>k

nnoremap <C-j>     <C-d>zz
nnoremap <C-k>     <C-u>zz
nnoremap <C-d>     <C-d>zz
nnoremap <C-u>     <C-u>zz

nnoremap L         :bn<CR>
nnoremap H         :bp<CR>
nnoremap <leader>d :bd<CR>
nnoremap <leader>e :Exp<CR>
nnoremap <C-g>     :echo expand("%:p:~") '-' Get_file_perm()<CR>

" TODO add vim-fugitive
"" git ls-files
nnoremap <leader>gf :GFiles<CR>
"" git status
nnoremap <leader>gs :GFiles?<CR>
nnoremap <leader>gc :Commits<CR>
nnoremap <leader>gb :BCommits<CR>

" fzf
" let $FZF_DEFAULT_COMMAND = 'ag --hidden --ignore .git -g ""'
" let $FZF_DEFAULT_COMMAND = "find . -type f -not -path '*/\.git/*'"
nnoremap \t :Telescope<CR>
nnoremap \f :Files<CR>
nnoremap \r :History<CR>
nnoremap \w :Rg<CR>
nnoremap \b :Buffers<CR>
nnoremap \h :Helptags<CR>

" nmap  <silent> <C-s> :set opfunc=SpecialChange<CR>g@
" function! SpecialChange(type)
"     exec "normal! `[v`]"
"     exec 'let @/=@"'
"     :'<,'>:s/<C-R>=expand('<cword>')<CR>
" endfunction

" inserts the current word under cursor into the substitute command
" substitute the entire [f]ile
nnoremap <C-s>f          :%s/<C-R>=expand('<cword>')<CR>
" substitute the previously selected [h]undk
nnoremap <C-s>h          :'<,'>:s/<C-R>=expand('<cword>')<CR>
nnoremap <C-s>ip vip<Esc>:'<,'>:s/<C-R>=expand('<cword>')<CR>

" open files in directory of current file
cnoremap %% <C-R>=expand('%:h').'/'<CR>
nmap <Leader>e :edit %%<CR>
nmap <Leader>s :split %%<CR><C-w>J
nmap <Leader>v :vsplit %%<CR><C-w>L
nmap <Leader>t :tabedit %%<CR>
nmap <Leader>f :tabedit<CR>:Files<CR>
nmap <Leader>r :read %%
nmap <Leader>w :write %%

" open terminal at the bottom
" nnoremap <leader>t :sp<bar>term<cr><c-w>J:resize10<cr>
tnoremap <Esc> <C-\><C-n>

" easy align
xmap ga <Plug>(EasyAlign)
nmap ga <Plug>(EasyAlign)


" Re-select the last pasted text
noremap gV V`]

" Duplicate the visually selected block
vnoremap D y'>p

" -----------------------------------------------
" cmds
" -----------------------------------------------
command! Run call system("tmux-run ".&filetype)

" -----------------------------------------------
" functions
" -----------------------------------------------
function! Get_file_perm()
    let a=getfperm(expand('%:p'))
    if strlen(a)
        return a
    " else
    "     let b=printf("%o", xor(0777,system("umask")))
    "     let c=""
    "     for d in [0, 1, 2]
    "         let c.=and(b[d], 4) ? "r" : "-"
    "         let c.=and(b[d], 2) ? "w" : "-"
    "         let c.=and(b[d], 1) ? "x" : "-"
    "     endfor
    "     return c
    endif
endfunction

" Get highlight groups of word under cursor in Vim
function! Syn()
    for id in synstack(line("."), col("."))
        echo synIDattr(id, "name")
    endfor
endfunction
command! -nargs=0 Syn call Syn()

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

    autocmd Filetype netrw call NetrwConfig()

    autocmd BufEnter .clang* set filetype=yaml
augroup end


let compile = 0
augroup Compile
    autocmd!
    " autocmd BufWritePost */src/*.cpp call system("tmux send-keys -t right ':make\n'")
    autocmd BufWritePost */src/*.cpp if compile != 0 | call system("tmux-run-cpp")
    autocmd BufWritePost */src/*.c   if compile != 0 | call system("tmux-run-c")
    " autocmd BufWritePost */src/*.rs call system("tmux send-keys -t right 'cargo run\n'")
augroup end

augroup Enter
    autocmd!
    autocmd BufRead,BufEnter */doc/* wincmd L
    autocmd BufRead,BufEnter man://* wincmd L

    autocmd BufEnter * :echo expand('%:p:~')

    autocmd VimEnter * call s:tmux_apply_title()
    autocmd WinEnter * call s:tmux_apply_title()
    autocmd BufEnter * call s:tmux_apply_title()
    autocmd VimResume * call s:tmux_apply_title()

    autocmd VimLeave * call s:tmux_reset_title()
    autocmd VimSuspend * call s:tmux_reset_title()
augroup end

augroup Write
    autocmd!
    autocmd BufWritePost */nvim/**.vim source % | source ~/.config/nvim/init.lua
    autocmd BufWritePost */nvim/**.lua source %
    autocmd BufWritePost plug.lua source <afile> | PackerSync
augroup end

augroup Search
    autocmd!
    autocmd CmdlineEnter /,\? :set hlsearch
    autocmd CmdlineLeave /,\? :set nohlsearch
augroup end

augroup yank
    autocmd TextYankPost * silent! lua vim.highlight.on_yank({ higroup="Visual", timeout=100 })
augroup end

" -----------------------------------------------
" netrw
" -----------------------------------------------
let g:netrw_keepdir=0

function! NetrwDel()
    normal 0y$
    call system("mv \"".getreg('@0')."\" /tmp/")
endfunction

function! NetrwConfig()
    setlocal cursorlineopt=line

    nmap <buffer> h -^
    nmap <buffer> <Left> -^
    nmap <buffer> l <CR>
    nmap <buffer> <Right> <CR>
    nmap <buffer> . gh
    nmap <buffer> P <C-w>z

    " TODO: add and delete and undo function.
    " the idea is to have a netrw undo file in /tmp and `mv` deleted
    " file/folders to it with directory information so that we can move theme
    " back to the correct place in system with undo function.
    " g:netrw_keepdir has to be unset so we change directory as we borows.

    " delete file/directory under cursor recursively
    nmap <buffer> D :call NetrwDel()<CR><C-l>
    " retrieve the last deleted file
    " nmap <buffer> u
endfunction

" -----------------------------------------------
" tmux
" -----------------------------------------------
function! s:tmux_apply_title()
    " call system("tmux rename-window \"vi:".expand("%:t")."\"")
    let filename = expand("%:t")
    if strlen(filename)
        call system("tmux rename-window \"[".filename."]\"")
    endif
endfunc

function! s:tmux_reset_title()
    call system("tmux set-window-option automatic-rename on")
endfunc
