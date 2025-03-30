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

var nop_maps = ['r', 'd', 'c', 'a', 'I', 'K',
    'gp', 'gP', 'gi', 'gI', 'gu', 'gU',  'gH', 'gw',
    'U', '<C-w>f', '<C-w>F', 'gf', 'gF'
]

# b:undo_ftplugin ..= nop_maps->mapnew((_, v) => $'exe "unmap <buffer> {v}"')->join(' | ')

if &ft == 'fm'
    noremap  <buffer> m <cmd>call Mark()<cr>j
    noremap  <buffer> x <cmd>call Extract()<cr>
    noremap  <buffer> D <cmd>call Delete()<cr>
    nnoremap <buffer> l <cmd>call In()<cr>
    nnoremap <buffer> h <cmd>call Out()<cr>
    nnoremap <buffer> M <cmd>call Move()<cr>
    nnoremap <buffer> r <cmd>call Rename()<cr>
    noremap  <buffer> C <cmd>call Mkdir()<cr>
endif
