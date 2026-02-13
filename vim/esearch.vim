vim9script

g:esearch = {}
g:esearch.root_markers = [] # use default root
g:esearch.case = 'smart'
g:esearch.select_prefilled = false
g:esearch.out = 'win'
g:esearch.name = '[esearch]'
g:esearch.live_update_min_len = 2
g:esearch.win_new = (esearch) => esearch#buf#goto_or_open(esearch.name, win_id2win(utils#UseSplitOrCreate()) .. 'wincmd w | e')
g:esearch = extend(get(g:, 'esearch', {}), {'win_context_len_annotations': 0, 'win_contexts_syntax': 0})
g:esearch = extend(g:esearch, {'adapters': {'rg': {'options': '--no-follow'}}})
# g:esearch.adapters.rg.options = '--no-follow'

def EsearchToggle()
    var buffers = getbufinfo('\[esearch]')
    if !(len(buffers) > 0) | return | endif

    var winnr = bufwinnr(buffers[0].bufnr)
    if winnr == -1
        g:esearch.win_new(g:esearch)
    else
        exe $":{winnr}close"
    endif
enddef

nnoremap <space>S <scriptcmd>EsearchToggle()<cr>

augroup esearch_group
# autocmd User esearch_win_config {
#     b:autopreview = esearch#async#debounce(b:esearch.split_preview_open, 100)
#     autocmd CursorMoved <buffer> b:autopreview.apply('split')
# }
augroup end
