vim.cmd [[
set background=dark

" highlight clear SignColumn
highlight ColorColumn  ctermbg=234
highlight LineNr       ctermbg=234 ctermfg=14
highlight CursorLineNr ctermbg=23 ctermfg=7
highlight CursorLine   ctermbg=236
highlight IncSearch    ctermbg=3   ctermfg=1
highlight Search       ctermbg=1   ctermfg=3
highlight Visual       ctermbg=1   ctermfg=16
highlight Pmenu        ctermbg=240 ctermfg=12
highlight PmenuSel     ctermbg=3   ctermfg=1
highlight SpellBad     ctermbg=0   ctermfg=1
highlight SpellCap     ctermbg=4   ctermfg=15
highlight VertSplit    ctermbg=6   ctermfg=0
highlight MatchParen   ctermbg=241
highlight SpellLocal   ctermbg=55
highlight Search       ctermfg=15 ctermbg=52

highlight Comment      ctermfg=242

" highlight clear MatchParen
highlight DiffAdd      ctermbg=4   ctermfg=15
highlight DiffDelete   ctermbg=5   ctermfg=14
highlight DiffChange   ctermbg=238

" Code folding
highlight Folded ctermfg=1 ctermbg=0
highlight FoldColumn ctermfg=1 ctermbg=0

" Tab line
highlight TabLineFill ctermbg=234 ctermfg=7 term=NONE cterm=NONE
highlight TabLine ctermbg=236 ctermfg=230   term=NONE cterm=NONE
highlight TabLineSel ctermbg=240 ctermfg=7  term=NONE cterm=bold

" Debugger
highlight debugPC ctermbg=24

try
  set background=dark

  let g:gruvbox_sign_column = 'bg0'
  let g:gruvbox_color_column = 'bg0'
  let g:gruvbox_contrast_dark = 'hard'
  let g:gruvbox_bold = '0'
  hi! LspReferenceText guibg=#504945
  hi! LspReferenceRead guibg=#504945
  hi! LspReferenceWrite guibg=#504945

  " let g:gruvbox_material_palette = 'original'
  " let g:gruvbox_material_statusline_style = 'original'
  let g:gruvbox_material_palette = gruvbox_material#get_palette('medium', 'original')
  let g:gruvbox_material_palette.bg_statusline3 = '#504945'
  let g:gruvbox_material_enable_bold = '1'
  let g:gruvbox_material_sign_column_background = 'none'
  let g:gruvbox_material_current_word = 'grey background'
  let g:gruvbox_material_visual = 'grey background'
  let g:gruvbox_material_background = 'hard'

  let g:rose_pine_variant = 'main'

  let g:sonokai_style = 'andromeda'
  let g:sonokai_enable_italic = 1

  colorscheme gruvbox

  hi! LspReferenceText guibg=#303030
  hi! LspReferenceRead guibg=#303030
  hi! LspReferenceWrite guibg=#303030
  " highlight Normal     guibg='#1a1a1a'   guifg='#AAAAAA'

catch /^Vim\%((\a\+)\)\=:E185/
"  colorscheme default
"  set background=dark

endtry
]]


-- Colorscheme generated by https://github.com/arcticlimer/djanho
-- require'colorizer'.setup()
--
-- vim.cmd[[highlight clear]]
--
-- local highlight = function(group, bg, fg, attr)
--     fg = fg and 'guifg=' .. fg or ''
--     bg = bg and 'guibg=' .. bg or ''
--     attr = attr and 'gui=' .. attr or ''
--
--     vim.api.nvim_command('highlight ' .. group .. ' '.. fg .. ' ' .. bg .. ' '.. attr)
-- end
--
-- local link = function(target, group)
--     vim.api.nvim_command('highlight! link ' .. target .. ' '.. group)
-- end
--
-- local Color0  = '#608B4E'
-- local Color6  = '#DCDCAA' -- defined constants pale yellow
-- local Color1  = '#B5CEA8'
-- local Color4  = '#CE9178'
-- local Color7  = '#4EC9B0' -- types teal
-- local Color10 = '#5F5A60'
-- local Color19 = '#789AC0' -- function blue
-- local Color20 = '#CCCCCC' -- fg
-- local Color14 = '#7587A6'
-- local Color22 = '#cccccc'
-- local Color12 = '#9B859D'
-- local Color17 = '#747C84' -- coments grey
-- local Color21 = '#0f1114'
-- local Color8  = '#C586C0' -- sdlfkjlsdfj
-- local Color18 = '#AFC4DB'
-- local Color9  = '#9CDCFE'
-- local bg      = '#242931' -- background
-- local Color24 = '#444e63'
-- local Color25 = '#585b60' -- line numbers grey
-- local Color11 = '#CF6A4C' -- Keyword's red
-- local Color15 = '#CDA869' -- local variable and numbers orangeYellow
-- local Color16 = '#8F9D6A' -- string green
-- local Color3  = '#569CD6'
-- local Color26 = '#2f343f'
-- local Color27 = '#ffffff'
-- local Color5  = '#D4D4D4'
-- local Color13 = '#A7A7A7'
-- local Color2  = '#F44747'
--
-- highlight('Statement',        nil,      nil,    'none')
-- highlight('Special',          nil,     Color15, 'none')
-- highlight('Operator',         nil,     Color5,  'none')
-- highlight('Type',             nil,     Color7,  'none')
-- highlight('Error',            nil,     Color11, 'none')
-- highlight('Number',           nil,     Color15, 'none')
-- highlight('String',           nil,     Color16, 'none')
-- highlight('Comment',          nil,     Color17, 'none')
-- highlight('TSCharacter',      nil,     Color18, 'none')
-- highlight('Function',         nil,     Color19, 'none')
-- highlight('Keyword',          nil,     Color11, 'none')
-- highlight('Conditional',      nil,     Color11, 'none')
-- highlight('Repeat',           nil,     Color11, 'none')
-- highlight('Macro',            nil,     Color6,  'none')
-- highlight('Identifier',       nil,     Color20, 'none')
-- highlight('StatusLine',       Color22, Color21, 'none')
-- highlight('WildMenu',         bg,      Color22, 'none')
-- highlight('Pmenu',            bg,      Color22, 'none')
-- highlight('PmenuSel',         Color22, bg,      'none')
-- highlight('PmenuThumb',       bg,      Color22, 'none')
-- highlight('Normal',           bg,      Color22, 'none')
-- highlight('Visual',           Color24, nil,     'none')
-- highlight('CursorLine',       Color24, nil,     'none')
-- highlight('ColorColumn',      Color24, nil,     'none')
-- highlight('SignColumn',       bg,      nil,     'none')
-- highlight('LineNr',           nil,     Color25, 'none')
-- highlight('TabLine',          Color26, Color22, 'none')
-- highlight('TabLineSel',       Color27, bg,      'none')
-- highlight('TabLineFill',      Color26, Color22, 'none')
-- highlight('TSPunctDelimiter', nil,     Color22, 'none')
-- highlight('Constant',         nil,     Color6,  'none')
--
-- highlight('Directory',        nil,     Color16,  'none')
-- highlight('Search	'  ,        '#d9a030', bg, 'none')
--
-- highlight('StatusLine',   bg, Color20, 'none')
-- highlight('StatusLineNC', bg, Color20, 'none')
-- highlight('VertSplit',    bg, Color20, 'none')
-- highlight('DiffAdd',      bg, '#3081d9',  'none')
-- highlight('DiffChange',   bg, '#30d965',  'none')
-- highlight('DiffDelete',   bg, '#d93030',  'none')
--
-- highlight('Error',         bg,Color2  , 'none')
-- highlight('NvimInternalError', bg, Color2, 'none')
--
-- highlight('MatchParen', bg, Color4, 'underline')
--
-- -- link('Special',              'Statement')
-- link('TSTagDelimiter',       'Type')
-- link('TSType',               'Type')
-- link('TSString',             'String')
-- link('TSRepeat',             'Repeat')
-- link('TSConstBuiltin',       'TSVariableBuiltin')
-- link('TSTag',                'MyTag')
-- link('Repeat',               'Conditional')
-- link('TSFloat',              'Number')
-- link('TSPunctSpecial',       'TSPunctDelimiter')
-- link('TSProperty',           'TSField')
-- link('Macro',                'Function')
-- link('TSNamespace',          'TSType')
-- link('TSPunctBracket',       'MyTag')
-- link('TSParameter',          'Number')
-- link('Whitespace',           'Comment')
-- link('CursorLineNr',         'Identifier')
-- link('TSNumber',             'Number')
-- link('Folded',               'Comment')
-- link('TSComment',            'Comment')
-- link('TSParameterReference', 'TSParameter')
-- link('TSConstant',           'Constant')
-- link('Operator',             'Keyword')
-- link('TSField',              'Identifier')
-- link('TSFunction',           'Function')
-- link('TSConditional',        'Conditional')
-- link('TSFuncMacro',          'Macro')
-- link('NonText',              'Comment')
-- link('TSLabel',              'Type')
-- link('TelescopeNormal',      'Normal')
-- link('TSOperator',           'Operator')
-- link('TSKeyword',            'Keyword')
-- link('Conditional',          'Operator')
-- link('PreProc',              'Keyword')
