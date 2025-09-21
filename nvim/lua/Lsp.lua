-- Workaround this https://github.com/neovim/neovim/issues/21856
-- vim.api.nvim_create_autocmd({ "VimLeave" }, {
--     callback = function()
--         vim.fn.jobstart('notify-send ""', { detach = true })
--     end,
-- })
------------------------------------------------------------
-- treesiter
------------------------------------------------------------
-- local tshl = require("nvim-treesitter.configs").setup {
--     ensure_installed = { "c", "cpp", "vim" }, -- one of "all", "maintained" (parsers with maintainers), or a list of languages
--     sync_install = true, -- install languages synchronously (only applied to `ensure_installed`)
--     -- ignore_install = { "comment" }, -- List of parsers to ignore installing
--     autopairs = {
--         enable = false,
--     },
--     highlight = {
--         enable = true, -- false will disable the whole extension
--         disable = {}, -- list of language that will be disabled
--         additional_vim_regex_highlighting = false,
--     },
--     indent = { enable = false },
--     context_commentstring = {
--         enable = false,
--         enable_autocmd = false,
--     },
-- }
--
------------------------------------------------------------
-- cmp
------------------------------------------------------------
local kind_icons = {
    Text = " ",
    Method = "󰆧 ",
    Namespace = "󰌗  ",
    Function = "󰊕 ",
    Constructor = " ",
    Field = "󰇽 ",
    Variable = "󰂡 ",
    Class = "󰠱 ",
    Interface = " ",
    Module = " ",
    Property = "󰜢 ",
    Unit = " ",
    Value = "󰎠 ",
    Enum = " ",
    Keyword = "󰌋 ",
    Snippet = " ",
    Color = "󰏘 ",
    File = "󰈙 ",
    Reference = " ",
    Folder = "󰉋 ",
    EnumMember = " ",
    Constant = "󰏿 ",
    Struct = " ",
    Event = " ",
    Operator = "󰆕 ",
    TypeParameter = "󰅲 ",
}

-- find more here: https://www.nerdfonts.com/cheat-sheet

-- ╭──────╮ [[[
-- │ test │ ]]]
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

local cmp = require("cmp");

local cmp_autocomplete_enabled = true
function CmpAutoCompleteToggle()
    cmp_autocomplete_enabled = not cmp_autocomplete_enabled
    if cmp_autocomplete_enabled then
        cmp.setup{ completion = {autocomplete =  { InsertEnter = "InsertEnter", TextChanged = "TextChanged" } }}
    else
        cmp.setup{ completion = {autocomplete = false }}
    end
end

vim.keymap.set('n', '<leader>lla', CmpAutoCompleteToggle, opts)

cmp.setup {
    snippet = {
        -- REQUIRED - you must specify a snippet engine
        expand = function(args)
            vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
            -- require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
            -- require('snippy').expand_snippet(args.body) -- For `snippy` users.
            -- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
        end,
    },
    completion = {
        autocomplete = false,
    },
    experimental = {
        -- ghost_text = { hl_group = "Comment" },
        -- native_menu = false,
    },
    performance = {
        throttle = 0,
        debounce = 0,
    },
    view = {
        docs = {
            auto_open = true,
        },
    },
    window = {
        -- completion = cmp.config.window.bordered(),
        -- documentation = cmp.config.window.bordered(),
        completion = {
            -- border = border,
            -- winhighlight = 'Normal:NormalFloat,FloatBorder:CmpPmenuBorder,CursorLine:PmenuSel,Search:Type',
            zindex = 100,
        },
        documentation = {
            border = border,
            -- winhighlight = 'Normal:NormalFloat,FloatBorder:CmpPmenuBorder,CursorLine:PmenuSel,Search:Type',
            zindex = 50,
        },
    },
    mapping = cmp.mapping.preset.insert({
        ['<C-n>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
            else
                cmp.complete()
            end
        end),
        ['<C-p>'] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),
        ['<C-l>'] = cmp.mapping(function(fallback)
            if cmp.visible_docs() then
                cmp.close_docs()
            else
                cmp.open_docs()
            end
        end),
        ['<C-f>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.confirm({ select = true })
            else
                cmp.complete()
            end
        end),
        ['<C-j>'] = cmp.mapping.select_next_item(),
        ['<C-k>'] = cmp.mapping.select_prev_item(),
        ['<C-d>'] = cmp.mapping.scroll_docs(4),
        ['<C-u>'] = cmp.mapping.scroll_docs(-4),
        -- ['<C-f>'] = cmp.mapping.confirm({ select = true }),
        ['<C-y>'] = cmp.mapping.confirm({ select = true }),
        ['<C-e>'] = cmp.mapping.abort(),
    }),
    formatting = {
        -- fields = { "kind", "abbr", "menu" },
        fields = { "abbr", "menu", "kind" },
        format = function(entry, item)
            -- Kind icons
            -- item.kind = string.format("%s", kind_icons[item.kind])
            item.menu = ({
                nvim_lsp = "[LSP]",
                nvim_lsp_signature_help = "[Sig]",
                tags = "[Tag]",
                luasnip = "[Snip]",
                buffer = "[Buf]",
                path = "[Path]",
            })[entry.source.name]

            -- if #item.abbr > 37 then
            --     item.abbr = string.sub(item.abbr, 0, 37)
            -- else
            --     item.abbr = item.abbr .. (" "):rep(37 - #item.abbr)
            -- end

            return item
        end,
    },
    sources = {
        { name = 'nvim_lsp' },
        { name = 'nvim_lsp_signature_help' },
        { name = 'tags' },
        { name = "path" },
        { name = 'buffer' },
    },
}

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
    underline = false,
    -- underline = {
    --     severity = { min = sev.e }
    -- },
    signs = true,
    virtual_text = false,
    -- virtual_text = {
    --     severity = { min = sev.e },
    --     source = 'if_may',
    -- },
    float = {
        header = "",
        -- format = function(diagnostic)
        --     print(vim.inspect(diagnostic))
        --     return string.format("%s (%s)", diagnostic.message, diagnostic.code)
        -- end,
        prefix = function(diagnostic, i, total)
            return string.format("%s:%s ", diagnostic.source, diagnostic.col)
        end
    },
})

vim.g.diag_enabled = true;
function DiagToggle()
    vim.g.diag_enabled = not vim.g.diag_enabled;
    vim.diagnostic.enable(vim.g.diag_enabled)
end

-- Mappings
local opts = { noremap = true, silent = false }
vim.keymap.set('n', 'ge', vim.diagnostic.open_float, opts)
vim.keymap.set('n', 'gE', vim.diagnostic.setqflist, opts)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
vim.keymap.set('n', '[e', function() vim.diagnostic.goto_prev({ severity = sev.e }) end, opts)
vim.keymap.set('n', ']e', function() vim.diagnostic.goto_next({ severity = sev.e }) end, opts)
vim.keymap.set('n', '<leader>lld', DiagToggle, opts)

local function get_hl_group_color(group, fg_or_bg)
    local id = vim.fn["hlID"](group)
    local attr = vim.fn["synIDtrans"](id)
    local color = vim.fn["synIDattr"](attr, fg_or_bg)
    return color
end

local function set_status_diag_highlight()
    if vim.o.laststatus > 0 then
        vim.cmd.highlight({ args = { "DiagnosticStatusError", "guibg=", get_hl_group_color("StatusLine", "bg"), "guifg=", get_hl_group_color("DiagnosticError", "fg") } })
        vim.cmd.highlight({ args = { "DiagnosticStatusWarn", "guibg=", get_hl_group_color("StatusLine", "bg"), "guifg=", get_hl_group_color("DiagnosticWarn", "fg") } })
        vim.cmd.highlight({ args = { "DiagnosticStatusHint", "guibg=", get_hl_group_color("StatusLine", "bg"), "guifg=", get_hl_group_color("DiagnosticHint", "fg") } })
        vim.cmd.highlight({ args = { "DiagnosticStatusInfo", "guibg=", get_hl_group_color("StatusLine", "bg"), "guifg=", get_hl_group_color("DiagnosticInfo", "fg") } })
    end
end

-- hi StatusGitSignsBranch guifg=#f44f4f   guibg=#2d5c76 gui=NONE
-- hi StatusGitSignsAdd    guifg=#218058   guibg=#2d5c76 gui=NONE
-- hi StatusGitSignsChange guifg=#cfcfc2   guibg=#2d5c76 gui=NONE
-- hi StatusGitSignsDelete guifg=#f44f4f   guibg=#2d5c76 gui=NONE
-- hi StatusDiagError      guifg=red       guibg=#2d5c76 gui=NONE
-- hi StatusDiagWarn       guifg=orange    guibg=#2d5c76 gui=NONE
-- hi StatusDiagHint       guifg=lightBlue guibg=#2d5c76 gui=NONE
-- hi StatusDiagInfo       guifg=lightGrey guibg=#2d5c76 gui=NONE

-- Functions
function GetDiag()
    if not vim.diagnostic.is_enabled() then
        return ""
    end

    local str = ""
    if vim.api.nvim_get_mode()["mode"] ~= 'i' then
        local err  = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
        local warn = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN })
        local hint = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.HINT })
        local info = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.INFO })

        if err ~= 0 then
            str = str .. ":%#DiagnosticStatusError#" .. err .. "%#*#"
        end
        if warn ~= 0 then
            str = str .. ":%#DiagnosticStatusWarn#" .. warn .. "%#*#"
        end
        if hint ~= 0 then
            str = str .. ":%#DiagnosticStatusHint#" .. hint .. "%#*#"
        end
        if info ~= 0 then
            str = str .. ":%#DiagnosticStatusInfo#" .. info .. "%#*#"
        end
    end
    return str
end

-- -- it should not be here!
function GitSignsStatus()
    local git_info = vim.b.gitsigns_status_dict
    if not git_info or git_info.root == "" then
        return ""
    end

    local str = git_info.head

    -- if git_info.added ~= nil then
    --     str = str .. " +" .. git_info.added
    -- end
    -- if git_info.changed ~= nil then
    --     str = str .. " ~" .. git_info.changed
    -- end
    -- if git_info.removed ~= nil then
    --     str = str .. " -" .. git_info.removed
    -- end

    if git_info.added ~= nil or git_info.changed ~= nil or git_info.removed ~= nil then
        str = str .. "*"
    end


    return str
end

------------------------------------------------------------
-- lsp
------------------------------------------------------------
function GetRunningLsp()
    local str = ""
    local clients = vim.lsp.get_clients({bufnr = 0})
    for _, client in ipairs(clients) do
        str = str .. client.name
    end

    return str
end

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
    -- We have to set these highlights only after they're set by vim
    set_status_diag_highlight()

    -- Disable diagnostics by default
    vim.diagnostic.enable(vim.g.diag_enabled)

    -- Enable completion triggered by <c-x><c-o>
    vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

    local bufopts = { noremap = true, silent = false, buffer = bufnr }
    vim.keymap.set('n', 'K',  vim.lsp.buf.hover,       bufopts)
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition,  bufopts)
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
    -- vim.keymap.set('n', '<C-w>d', "<cmd>tab split | lua vim.lsp.buf.definition()<CR>", bufopts)
    vim.keymap.set('n', 'gI',  vim.lsp.buf.implementation,  bufopts)
    vim.keymap.set('n', 'gs',  vim.lsp.buf.signature_help,  bufopts)
    vim.keymap.set('n', 'gr',  vim.lsp.buf.references,      bufopts)
    vim.keymap.set('n', 'gR',  vim.lsp.buf.rename,          bufopts)
    vim.keymap.set('n', 'gt',  vim.lsp.buf.typehierarchy,   bufopts)
    vim.keymap.set('n', 'gli', vim.lsp.buf.incoming_calls,  bufopts)
    vim.keymap.set('n', 'glo', vim.lsp.buf.outgoing_calls,  bufopts)
    vim.keymap.set('n', 'glt', vim.lsp.buf.type_definition, bufopts)
    vim.keymap.set('n', 'gla', vim.lsp.buf.code_action,     bufopts)
    vim.keymap.set('n', 'glf', vim.lsp.buf.format,          bufopts)

    vim.keymap.set('n', 'glwa', vim.lsp.buf.add_workspace_folder, bufopts)
    vim.keymap.set('n', 'glwr', vim.lsp.buf.remove_workspace_folder, bufopts)
    vim.keymap.set('n', 'glwl', function() print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end, bufopts)
end

local lsp_flags = {
    -- This is the default in Nvim 0.7+
    debounce_text_changes = 150,
}

-- start an arbitrary sever using the default configurations.
-- TODO: make this function prompt for `cmd` and `root_dir`.
function LspStartServer()
    vim.cmd[[:echohl Directory]]
    local string_cmd = vim.fn.input("Enter server command: ", "", "shellcmd")
    local cmd = vim.split(string_cmd, " ")
    local root_dir = vim.fn.input("Enter root file/folder name: ", vim.fn.getcwd(), "file")
    vim.cmd[[:echohl None]]
    vim.lsp.start({
        name = cmd[1],
        cmd = cmd,
        -- root_dir = vim.fs.dirname(vim.fs.find(root, { upward = true })[1]),
        root_dir =  root,
        capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities()),
        on_attach = on_attach,
    })
end

require("lspconfig").bashls.setup {
    on_attach    = on_attach,
    capabilities = capabilities,
    flags        = lsp_flags,
}

-- require("lspconfig").vimls.setup {
--     on_attach    = on_attach,
--     capabilities = capabilities,
--     flags        = lsp_flags,
-- }

require('lspconfig').ts_ls.setup {
    on_attach    = on_attach,
    capabilities = capabilities,
    flags        = lsp_flags,
}

require('lspconfig').zls.setup {
    on_attach    = on_attach,
    capabilities = capabilities,
    flags        = lsp_flags,
}

require('lspconfig').gopls.setup {
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

-- require("neodev").setup({
--   -- add any options here, or leave empty to use the default settings
-- })
require("lspconfig").lua_ls.setup {
    on_attach    = on_attach,
    capabilities = capabilities,
    flags        = lsp_flags,
    settings     = {
        Lua = {
            completion = {
                callSnippet = "Replace"
            },
            -- Do not send telemetry data containing a randomized but unique identifier
            telemetry = {
                enable = false,
            },
        },
    },
}

require("lspconfig").rust_analyzer.setup {
    on_attach = on_attach,
    flags     = lsp_flags,
    cmd       = { "rust-analyzer" },
    settings  = {
        rust = {
            unstable_features = true,
            build_on_save = false,
            all_features = true,
        },
    }
}
-- the extension calls require("lspconfig").rust_analyzer.setup{} automatically
-- require('rust-tools').setup {
--     server = {
--         on_attach    = on_attach,
--         capabilities = capabilities,
--         flags        = lsp_flags,
--         cmd          = { "rustup", "run", "nightly", "rust-analyzer" },
--     },
-- }

-- require("lspconfig").ccls.setup {
--     on_attach    = on_attach,
--     capabilities = capabilities,
--     flags        = lsp_flags,
--     init_options = {
--         -- compilationDatabaseDirectory = "build";
--         highlight = {
--             lsRanges = true
--         },
--         index = {
--             onChange = true,
--             threads = 0,
--         };
--         -- clang = {
--         --     -- excludeArgs = { "-frounding-math" };
--         --     -- extraArgs = { "-I /usr/include/c++/v1/experimental/*", }
--         -- };
--     },
-- }

require("lspconfig").clangd.setup {
    on_attach = on_attach,
    capabilities = capabilities,
    flags = lsp_flags,
    cmd = {
        "clangd",
        "--clang-tidy",
        "--all-scopes-completion=true", -- If set to true, code completion will include index symbols that are not defined in the scopes (e.g. namespaces) visible from the code completion point. Such completions can insert scope qualifiers
        "--completion-style=detailed",
        -- "--function-arg-placeholders",
        "--header-insertion=iwyu", -- add headers when accepting completion
        "--header-insertion-decorators",
        "-j=1",
        -- "--malloc-trim",
        "--background-index", --index in background and persist on disk
        "--enable-config",    --enable usage of .clangd config file
        "--pch-storage=disk",
        "--malloc-trim",
        -- "--query-driver=/opt/clang7/bin/clang++",
    },
    -- root_dir = function()
    --     print("clangd-Rootdir", vim.loop.cwd())
    --     return vim.loop.cwd()
    -- end,
}

require("clangd_extensions").setup({
    inlay_hints = {
        inline = vim.fn.has("nvim-0.10") == 1,
        -- Options other than `highlight' and `priority' only work
        -- if `inline' is disabled
        -- Only show inlay hints for the current line
        only_current_line = false,
        -- Event which triggers a refresh of the inlay hints.
        -- You can make this { "CursorMoved" } or { "CursorMoved,CursorMovedI" } but
        -- note that this may cause higher CPU usage.
        -- This option is only respected when only_current_line is true.
        only_current_line_autocmd = { "CursorHold" },
        -- whether to show parameter hints with the inlay hints or not
        show_parameter_hints = true,
        -- prefix for parameter hints
        parameter_hints_prefix = "<- ",
        -- prefix for all the other hints (type, chaining)
        other_hints_prefix = "=> ",
        -- whether to align to the length of the longest line in the file
        max_len_align = false,
        -- padding from the left if max_len_align is true
        max_len_align_padding = 1,
        -- whether to align to the extreme right or not
        right_align = false,
        -- padding from the right if right_align is true
        right_align_padding = 7,
        -- The color of the hints
        highlight = "Comment",
        -- The highlight group priority for extmark
        priority = 100,
    },
    ast = {
        -- These are unicode, should be available in any font
        role_icons = {
            type = "",
            declaration = "",
            expression = "",
            specifier = "",
            statement = "",
            ["template argument"] = "",
        },
        kind_icons = {
            Compound = "",
            Recovery = "",
            TranslationUnit = "",
            PackExpansion = "",
            TemplateTypeParm = "",
            TemplateTemplateParm = "",
            TemplateParamObject = "",
        },
        highlights = {
            detail = "Comment",
        },
    },
    memory_usage = {
        border = "none",
    },
    symbol_info = {
        border = "none",
    },
})
