vim9script

# if exists("b:did_ftplugin")
#     finish
# endif
# b:did_ftplugin = 1

# setl nospell
# setl buftype=nofile
# setl bufhidden=hide
# setl noswapfile
setl nowrap
setl nobuflisted

nnoremap <buffer> m <cmd>call Mark()<cr>
vnoremap <buffer> m <cmd>call Mark()<cr>
nnoremap <buffer> l <cmd>call In()<cr>
nnoremap <buffer> h <cmd>call Out()<cr>
