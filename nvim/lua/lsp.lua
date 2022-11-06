------------------------------------------------------------
-- treesiter
------------------------------------------------------------
local tshl = require("nvim-treesitter.configs").setup {
    ensure_installed = { "c", "cpp", "lua", "typescript", "javascript", "fish" }, -- one of "all", "maintained" (parsers with maintainers), or a list of languages
    sync_install = true, -- install languages synchronously (only applied to `ensure_installed`)
    -- ignore_install = { "comment" }, -- List of parsers to ignore installing
    autopairs = {
        enable = true,
    },
    highlight = {
        enable = true, -- false will disable the whole extension
        disable = {}, -- list of language that will be disabled
        additional_vim_regex_highlighting = false,
    },
    indent = { enable = true },
    context_commentstring = {
        enable = true,
        enable_autocmd = false,
    },
}

------------------------------------------------------------
-- cmp
------------------------------------------------------------
--   פּ ﯟ   some other good icons
local

kind_icons = {
    Text = ' ',
    Method = ' ',
    Function = ' ',
    Constructor = ' ',
    Field = '',
    Variable = ' ',
    Class = ' ',
    Interface = ' ',
    Module = ' ',
    Property = ' ',
    Unit = ' ',
    Value = ' ',
    Enum = ' ',
    Keyword = ' ',
    Snippet = ' ',
    Color = ' ',
    File = ' ',
    Reference = ' ',
    Folder = ' ',
    EnumMember = ' ',
    Constant = ' ',
    Struct = ' ',
    Event = ' ',
    Operator = ' ',
    TypeParameter = ' ',
}

-- find more here: https://www.nerdfonts.com/cheat-sheet

-- ╭──────╮
-- │ test │
-- ╰──────╯

local border = {
    { "╭", "FloatBorder" },
    { "─", "FloatBorder" },
    { "╮", "FloatBorder" },
    { "│", "FloatBorder" },
    { "╯", "FloatBorder" },
    { "─", "FloatBorder" },
    { "╰", "FloatBorder" },
    { "│", "FloatBorder" },
}

-- local border = { '┌', '─', '┐', '│', '┘', '─', '└', '│' }
-- local border = { '╔', '═', '╗', '║', '╝', '═', '╚', '║' }

-- Setup nvim-cmp.
local
cmp = require("cmp");
cmp.setup {
    snippet = {
        -- REQUIRED - you must specify a snippet engine
        expand =
        function(args)
            -- vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
            require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
            -- require('snippy').expand_snippet(args.body) -- For `snippy` users.
            -- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
        end,
    },
    completion = {
        -- autocomplete = true,
        -- completeopt = 'menu,menuone,noisert'
    },
    experimental = {
        -- ghost_text = { hl_group = "Comment" },
    },
    window = {
        -- completion = cmp.config.window.bordered(),
        -- documentation = cmp.config.window.bordered(),
        completion = {
            border = border,
            winhighlight = 'Normal:NormalFloat,FloatBorder:CmpPmenuBorder,CursorLine:PmenuSel,Search:Type',
            zindex = 100,
        },
        documentation = {
            border = border,
            zindex = 50,
        },
    },
    mapping = cmp.mapping.preset.insert({
        ['<C-p>'] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select });
        ['<C-n>'] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select });
        ['<C-d>'] = cmp.mapping.scroll_docs(-4),
        ['<C-u>'] = cmp.mapping.scroll_docs(4),
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<C-e>'] = cmp.mapping.abort(),
        ['<C-f>'] = cmp.mapping.confirm({ select = true }),
        ['<CR>'] = cmp.mapping.confirm({ select = true }),
    }),
    formatting = {
        fields = { "kind", "abbr", "menu" },
        format = function(entry, vim_item)
            -- Kind icons
            vim_item.kind = string.format("%s", kind_icons[vim_item.kind])
            -- vim_item.kind = string.format('%s %s', kind_icons[vim_item.kind], vim_item.kind) -- This concatonates the icons with the name of the item kind
            vim_item.menu = ({
                nvim_lsp = "[LSP]",
                -- nvim_lsp_signature_help = "[Sig]",
                luasnip = "[Snip]",
                buffer = "[Buf]",
                path = "[Path]",
            })[entry.source.name]
            return vim_item
        end,
    },
    sources = {
        { name = 'nvim_lsp' },
        { name = 'nvim_lsp_signature_help' },
        { name = 'luasnip' }, -- For luasnip users.
        { name = "path" },
        { name = 'buffer' },
    },
    -- sorting = { -- for clangd_extensions.nvim
    --     comparators = {
    --         cmp.config.compare.offset,
    --         cmp.config.compare.exact,
    --         cmp.config.compare.recently_used,
    --         require("clangd_extensions.cmp_scores"),
    --         cmp.config.compare.kind,
    --         cmp.config.compare.sort_text,
    --         cmp.config.compare.length,
    --         cmp.config.compare.order,
    --     },
    -- },
    -- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
    cmp.setup.cmdline('/', {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
            { name = 'buffer' }
        }
    }),
    -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
    cmp.setup.cmdline(':', {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
            { name = 'path' }
        }, {
            -- { name = 'cmdline' }
        })
    }),
}

-- Set configuration for specific filetype.
-- cmp.setup.filetype('gitcommit', {
--   sources = cmp.config.sources({
--     { name = 'cmp_git' }, -- You can specify the `cmp_git` source if you were installed it.
--   }, {
--     { name = 'buffer' },
--   })
-- })



-- Setup lspconfig.
local capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities())
-- Replace <YOUR_LSP_SERVER> with each lsp server you've enabled.
-- require('lspconfig')['clangd'].setup {
--   capabilities = capabilities
-- }


------------------------------------------------------------
-- diagnostics
------------------------------------------------------------
vim.cmd [[
sign define DiagnosticSignError text=• texthl=DiagnosticSignError linehl= numhl=
sign define DiagnosticSignWarn  text=• texthl=DiagnosticSignWarn linehl= numhl=
sign define DiagnosticSignInfo  text=• texthl=DiagnosticSignInfo linehl= numhl=
sign define DiagnosticSignHint  text=• texthl=DiagnosticSignHint linehl= numhl=
]]

local sev = {}
sev.e = vim.diagnostic.severity.ERROR
sev.w = vim.diagnostic.severity.WARN
sev.i = vim.diagnostic.severity.INFO
sev.h = vim.diagnostic.severity.HINT

vim.diagnostic.config({
    severity_sort = true,
    underline = {
        severity = { min = sev.e }
    },
    signs = true,
    virtual_text = {
        severity = sev.e,
        source = true,
    },
    float = {
        format = function(diagnostic)
            print(vim.inspect(diagnostic))
            return string.format("%s (%s)", diagnostic.message, diagnostic.code)
        end,
        prefix = function(diagnostic, i, total)
            return string.format("%s:%s ", diagnostic.source, diagnostic.col)
        end
    },
})

-- Mappings
local opts = { noremap = true, silent = false }
vim.keymap.set('n', 'gh', vim.diagnostic.open_float, opts)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
vim.keymap.set('n', '[e', function() vim.diagnostic.goto_prev({severity = sev.e}) end, opts)
vim.keymap.set('n', ']e', function() vim.diagnostic.goto_next({severity = sev.e}) end, opts)
vim.keymap.set('n', '<leader>ld', vim.diagnostic.setloclist, opts)

------------------------------------------------------------
-- lsp
------------------------------------------------------------

-- require('hover').setup {
--     init = function()
--         -- Require providers
--         require('hover.providers.lsp')
--         -- require('hover.providers.gh')
--         -- require('hover.providers.man')
--         -- require('hover.providers.dictionary')
--     end,
--     preview_opts = {
--         border = nil
--     },
--     -- requires nvim >= 0.8
--     title = false
-- }

-- To instead override globally
local orig_util_open_floating_preview = vim.lsp.util.open_floating_preview
function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
    opts = opts or {}
    opts.border = opts.border or border
    return orig_util_open_floating_preview(contents, syntax, opts, ...)
end


-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
    -- Enable completion triggered by <c-x><c-o>
    vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

    local bufopts = { noremap = true, silent = false, buffer = bufnr }

    vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts) -- hover
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
    vim.keymap.set('n', 'gI', vim.lsp.buf.implementation, bufopts)
    vim.keymap.set('n', 'gs', vim.lsp.buf.signature_help, bufopts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
    vim.keymap.set('n', '<leader>lt', vim.lsp.buf.type_definition, bufopts)
    vim.keymap.set('n', '<leader>lr', vim.lsp.buf.rename, bufopts)
    vim.keymap.set('n', '<leader>la', vim.lsp.buf.code_action, bufopts)
    vim.keymap.set('n', '<leader>lf', vim.lsp.buf.format, bufopts)

    vim.keymap.set('n', '<leader>lwa', vim.lsp.buf.add_workspace_folder, bufopts)
    vim.keymap.set('n', '<leader>lwr', vim.lsp.buf.remove_workspace_folder, bufopts)
    vim.keymap.set('n', '<leader>lwl', function()
        print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, bufopts)
end

local lsp_flags = {
    -- This is the default in Nvim 0.7+
    debounce_text_changes = 150,
}

require("lspconfig").bashls.setup {
    on_attach    = on_attach,
    capabilities = capabilities,
    flags        = lsp_flags,
}

require("lspconfig").vimls.setup {
    on_attach    = on_attach,
    capabilities = capabilities,
    flags        = lsp_flags,
}

require('lspconfig').tsserver.setup {
    on_attach    = on_attach,
    capabilities = capabilities,
    flags        = lsp_flags,
}

-- require('lspconfig').quick_lint_js.setup {
--     on_attach    = on_attach,
--     capabilities = capabilities,
--     flags        = lsp_flags,
-- }

require("lspconfig").cmake.setup {
    on_attach      = on_attach,
    capabilities   = capabilities,
    flags          = lsp_flags,
    buildDirectory = "build",
}

-- require("lspconfig").sumneko_lua.setup {
--     on_attach    = on_attach,
--     capabilities = capabilities,
--     flags        = lsp_flags,
--     settings     = {
--         Lua = {
--             runtime = {
--                 -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
--                 version = 'LuaJIT',
--                 path = vim.split(package.path, ';'),
--             },
--             diagnostics = {
--                 -- Get the language server to recognize the `vim` global
--                 globals = { 'vim' },
--             },
--             workspace = {
--                 -- Make the server aware of Neovim runtime files
--                 library = vim.api.nvim_get_runtime_file("", true),
--             },
--             -- Do not send telemetry data containing a randomized but unique identifier
--             telemetry = {
--                 enable = false,
--             },
--         },
--     },
-- }

local sumneko_binary_path = vim.fn.exepath('lua-language-server')
local sumneko_root_path = vim.fn.fnamemodify(sumneko_binary_path, ':h:h:h')

local runtime_path = vim.split(package.path, ';')
table.insert(runtime_path, "lua/?.lua")
table.insert(runtime_path, "lua/?/init.lua")

require 'lspconfig'.sumneko_lua.setup {
    on_attach    = on_attach,
    capabilities = capabilities,
    flags        = lsp_flags,
    cmd          = { sumneko_binary_path, "-E", sumneko_root_path .. "/main.lua" };
    settings     = {
        Lua = {
            runtime = {
                -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
                version = 'LuaJIT',
                -- Setup your lua path
                path = runtime_path,
            },
            diagnostics = {
                -- Get the language server to recognize the `vim` global
                globals = { 'vim' },
            },
            workspace = {
                -- Make the server aware of Neovim runtime files
                library = vim.api.nvim_get_runtime_file("", true),
            },
            -- Do not send telemetry data containing a randomized but unique identifier
            telemetry = {
                enable = false,
            },
        },
    },
}

-- require("lspconfig").rust_analyzer.setup{
--     on_attach = on_attach,
--     flags  = lsp_flags,
-- 	cmd = { "rustup", "run", "nightly", "rust-analyzer" },
-- 	--[[
--     settings = {
--         rust = {
--             unstable_features = true,
--             build_on_save = false,
--             all_features = true,
--         },
--     }
--     --]]
-- }
-- the extension calls require("lspconfig").rust_analyzer.setup{} automatically
require('rust-tools').setup {
    server = {
        on_attach    = on_attach,
        capabilities = capabilities,
        flags        = lsp_flags,
        cmd          = { "rustup", "run", "nightly", "rust-analyzer" },
    },
}

-- require("lspconfig").ccls.setup {
--     on_attach    = on_attach,
--     capabilities = capabilities,
--     flags        = lsp_flags,
--     init_options = {
--         compilationDatabaseDirectory = "build";
--         index = {
--             threads = 0;
--         };
--         -- clang = {
--         --     -- excludeArgs = { "-frounding-math" };
--         --     -- extraArgs = { "-I /usr/include/c++/v1/experimental/*", }
--         -- };
--     },
-- }
--
-- using https://github.com/p00f/clangd_extensions.nvim instead
require("lspconfig").clangd.setup {
    on_attach = on_attach,
    capabilities = capabilities,
    flags = lsp_flags,
    cmd = {
        "clangd",
        "--clang-tidy",
        "--all-scopes-completion=true", -- If set to true, code completion will include index symbols that are not defined in the scopes (e.g. namespaces) visible from the code completion point. Such completions can insert scope qualifiers
        "--completion-style=detailed",
        "--header-insertion=iwyu", -- add headers when accepting completion
        "--header-insertion-decorators",
        -- "-j=2",
        -- "--malloc-trim",
        "--background-index", --index in background and persist on disk
    },
    -- root_dir = function()
    --     print("clangd-Rootdir", vim.loop.cwd())
    --     return vim.loop.cwd()
    -- end,
}
--
-- the extension calls require("lspconfig").clangd.setup{} automatically
-- require("clangd_extensions").setup {
--     server = {
--         -- options to pass to nvim-lspconfig
--         -- i.e. the arguments to require("lspconfig").clangd.setup({})
--         on_attach    = on_attach,
--         capabilities = capabilities,
--         flags        = lsp_flags,
--         cmd          = {
--             "clangd",
--             "--clang-tidy",
--             -- "-j=5",
--             "--background-index", --index in background and persist on disk
--         },
--         -- root_dir     = function()
--         --     print("clangd-Rootdir", vim.loop.cwd())
--         --     return vim.loop.cwd()
--         -- end,
--     },
--     extensions = {
--         -- defaults:
--         -- Automatically set inlay hints (type hints)
--         autoSetHints = true,
--         -- These apply to the default ClangdSetInlayHints command
--         inlay_hints = {
--             -- Only show inlay hints for the current line
--             only_current_line = false,
--             -- Event which triggers a refersh of the inlay hints.
--             -- You can make this "CursorMoved" or "CursorMoved,CursorMovedI" but
--             -- not that this may cause  higher CPU usage.
--             -- This option is only respected when only_current_line and
--             -- autoSetHints both are true.
--             only_current_line_autocmd = "CursorHold",
--             -- whether to show parameter hints with the inlay hints or not
--             show_parameter_hints = true,
--             -- prefix for parameter hints
--             parameter_hints_prefix = " ⟶ ",
--             -- prefix for all the other hints (type, chaining)
--             other_hints_prefix = "=> ",
--             -- whether to align to the length of the longest line in the file
--             max_len_align = false,
--             -- padding from the left if max_len_align is true
--             max_len_align_padding = 1,
--             -- whether to align to the extreme right or not
--             right_align = false,
--             -- padding from the right if right_align is true
--             right_align_padding = 7,
--             -- The color of the hints
--             highlight = "Comment",
--             -- The highlight group priority for extmark
--             priority = 100,
--         },
--         ast = {
--             role_icons = {
--                 type = "",
--                 declaration = "",
--                 expression = "",
--                 specifier = "",
--                 statement = "",
--                 -- [--[[ "template argument" ]]] = "",
--             },
--             kind_icons = {
--                 Compound = "",
--                 RECOVERY = "",
--                 TRANSLATIONUNIT = "",
--                 PACKEXPANSION = "",
--                 TEMPLATETYPEPARM = "",
--                 TEMPLATETEMPLATEPARM = "",
--                 TEMPLATEPARAMOBJECT = "",
--             },
--             HIGHLIGHTS = {
--                 DETAIL = "COMMENT",
--             },
--         },
--         MEMORY_USAGE = {
--             BORDER = "NONE",
--         },
--         SYMBOL_INFO = {
--             BORDER = "NONE",
--         },
--     },
-- }
