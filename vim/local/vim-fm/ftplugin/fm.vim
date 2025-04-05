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
    noremap  <buffer> <nowait> m <cmd>call Mark()<cr>j
    noremap  <buffer> <nowait> x <cmd>call Extract()<cr>
    noremap  <buffer> <nowait> D <cmd>call Delete()<cr>
    nnoremap <buffer> <nowait> l <cmd>call In()<cr>
    nnoremap <buffer> <nowait> h <cmd>call Out()<cr>
    nnoremap <buffer> <nowait> M <cmd>call Move()<cr>
    nnoremap <buffer> <nowait> p <cmd>call Copy()<cr>
    noremap  <buffer> <nowait> C <cmd>call Mkdir()<cr>
    nnoremap <buffer> <nowait> r <cmd>call Rename()<cr>
    nnoremap <buffer> <nowait> u <nop>

    nnoremap <buffer> <nowait> <Enter> <cmd>call In()<cr>
endif
