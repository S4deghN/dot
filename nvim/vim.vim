" -----------------------------------------------
" options
" -----------------------------------------------
" set timeoutlen=1000
" set autochdir

set mouse+=a                            "mouse support

set shortmess+=a
" set nowrap

set nonumber                              "linen numbers
" set relativenumber
set cursorline
set cursorlineopt=number
set laststatus=0
" set signcolumn=yes:1                    "always show sign column with fixed width of
set signcolumn=no

" set guicursor=n-v-c-sm-i-ci-ve:block,r-cr-o:hor20

set scrolloff=8
set textwidth=80
" set cmdheight=1
" set colorcolumn=80

set ignorecase
set smartcase
set smartindent
set autoindent
set expandtab                           "convert tabs to spaces
set shiftwidth=4                        "the number of spaces inserted for each indentation
set tabstop=4

" the special window that opens with :q or ctlr-f in cmd mode.
set cmdwinheight=12

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
let g:gruvbox_bold = 1

color apprentice
highlight Normal          guibg=none  "guifg=#BCBCBC
highlight NormalFloat	  guibg=bg    "guifg=fg2e
highlight FloatBorder     guibg=bg
highlight CursorLineNr    guibg=bg
highlight LineNr          guibg=bg
highlight signcolumn      guibg=bg

highlight Identifier      guifg=fg
highlight Type            guifg=#CDA869
highlight Constant        guifg=#CDA869
highlight Statement       guifg=#CF6A4C
highlight Function        guifg=#789AC0
" highlight Function        guifg=#5F87AF
" highlight Function        guifg=#87AFD7
" highlight PreProc         guifg=#68BEA2
highlight PreProc         guifg=#83a598
highlight String          guifg=#8F9D6A
highlight Special         guifg=#CF6A4C
highlight Delimiter       guifg=fg

highlight! link Directory Constant
highlight MatchParen guifg=#af5f5f guibg=bg gui=underline

highlight DiagnosticError guifg=#CF6A4C
highlight DiagnosticWarn  guifg=#d7af5f
highlight DiagnosticInfo  guifg=LightBlue
highlight DiagnosticHint  guifg=LightGrey

" highlight CursorLine    guibg=grey20
" highlight Error         guifg=Red   gui=bold
" highlight link TreesitterContext CursorLine
" highlight TreesitterContext gui=italic guibg=grey17

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
        if hint ~= 0 then str = str .. "%#DiagnosticHint# H:" .. hint .. "%*" end
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
        str = str .. "[%#String#" .. client.name .. "%*]"
    end)
    return str
end
EOF

" set ruf=%30(%=%#LineNr#%.50F\ [%{strlen(&ft)?&ft:'none'}]\ %l:%c\ %p%%%)
" set rulerformat=%36(%5l,%-6(%c%V%)\ %y%)%*

set rulerformat=%50(%{%v:lua.GetRunningLsp()%}%{%v:lua.GetDiag()%}%=[%l,%c/%L]\ %m\ [%Y]%)

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

noremap gk K

" spell
nnoremap <leader>z 1z=
" substitute trailing white spaces with nothing. e flag suppresses errors.
nnoremap zs :%s/\s\+$//e<CR>''

" yank
nmap Y y$

noremap <leader>y "+y
noremap <leader>Y "+Y
noremap <leader>p "+]p
noremap <leader>P "+]P

" navigation
nnoremap <C-h>     <C-w>h
nnoremap <C-j>     <C-w>j
nnoremap <C-k>     <C-w>k
nnoremap <C-l>     <C-w>l
nnoremap <C-n>     <C-f>
nnoremap <C-p>     <C-b>
nnoremap <C-e>     <C-e>j
nnoremap <C-y>     <C-y>k
nnoremap L         :bn<CR>
nnoremap H         :bp<CR>
nnoremap <leader>d :bd<CR>
nnoremap <leader>e :Exp<CR>
nnoremap <C-g>     :echo expand("%:p:~") '-' Get_file_perm()<CR>
" nnoremap <C-g>k    :cd ..<CR>:pwd<CR>
" nnoremap <C-g>j    :cd %:h<CR>:pwd<CR>

" fzf
" let $FZF_DEFAULT_COMMAND = 'ag --hidden --ignore .git -g ""'
" let $FZF_DEFAULT_COMMAND = "find . -type f -not -path '*/\.git/*'"
nnoremap \f :Files<CR>
nnoremap \r :History<CR>
nnoremap \w :Rg<CR>
nnoremap \b :Buffers<CR>
nnoremap \h :Helptags<CR>

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
" command! W w !sudo tee %    " Save with root permission

command! W w | call system("tmux-run-".&filetype)
command! Run call system("tmux-run-".&filetype)


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

augroup Compile
    autocmd!
    " autocmd BufWritePost */src/*.cpp call system("tmux send-keys -t right ':make\n'")
    autocmd BufWritePost */src/*.cpp call system("tmux-run-cpp")
    autocmd BufWritePost */src/*.c call system("tmux-run-c")
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
        call system("tmux rename-window \"vi[".filename."]\"")
    endif
endfunc

function! s:tmux_reset_title()
    call system("tmux set-window-option automatic-rename on")
endfunc
