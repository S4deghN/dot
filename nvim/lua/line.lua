local branch = {
    "branch",
    fmt = function(str)
        if string.len(str) > 1 then
            -- "%a": any letter, "-": Match the previous character (or class) zero or more times, as few times as possible, "$": the $ matches the end of the string
            local head = string.match(vim.fn.getcwd(), "%a*$")
            return head .. " on " .. str
        end
    end,
}

require('lualine').setup {
    options = {
        icons_enabled = true,
        theme = 'gruvbox-material',
        component_separators = { left = '', right = '' },
        section_separators = { left = '', right = ''},
        disabled_filetypes = {
            statusline = {},
            winbar = {},
        },
        ignore_focus = {},
        always_divide_middle = true,
        globalstatus = false,
        refresh = {
            statusline = 50,
            tabline = 50,
            winbar = 50,
        }
    },
    sections = {
        lualine_a = {},
        lualine_b = { {'filename', path = 0, shorting_target = 50,} },
        lualine_c = { branch, 'diff', 'diagnostics' },
        lualine_x = { '%l:%c/%L', "encoding", 'filetype' },
        lualine_y = {},
        lualine_z = {},
    },
    inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = { 'filename' },
        lualine_x = { 'location' },
        lualine_y = {},
        lualine_z = {}
    },
    tabline = {},
    winbar = {},
    inactive_winbar = {},
    extensions = {}
}
