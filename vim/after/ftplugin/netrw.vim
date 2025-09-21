" netrw sucks!
" change dir as browsing dir changes
let g:netrw_keepdir = 0
let g:netrw_banner = 0
setlocal cursorlineopt=line

" TODO: Uset getline and regext for file name
func s:netrw_delete()
    normal! 0y$
    call system("mv \"" .. getreg('@@') .. "\" /tmp/")
endfunc

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
nmap <buffer> D :call <SID>netrw_delete()<cr><C-l>
" retrieve the last deleted file
" nmap <buffer> u
