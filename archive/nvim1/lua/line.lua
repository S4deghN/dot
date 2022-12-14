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

local diagnostics = {
    "diagnostics",
    fmt = function(str)
        if string.len(str) > 1 then
            return "|  " .. str
        end
    end,
    symbols = { error = "E:", warn = "W:", info = "I:", hint = "H:" },
}

require('lualine').setup {
    options = {
        icons_enabled = true,
        -- theme = 'gruvbox-material',
        section_separators = { left = '', right = '' },
        component_separators = { left = '', right = '' },
        disabled_filetypes = {
            statusline = {},
            winbar = {},
        },
        ignore_focus = {},
        always_divide_middle = true,
        globalstatus = false,
        refresh = {
            statusline = 100,
            tabline = 100,
            winbar = 100,
        }
    },
    sections = {
        lualine_b = { 'branch' },
        lualine_a = {},
        lualine_c = { 'filename', 'diff', diagnostics },
        lualine_x = { '%l|%L:%c', "encoding", 'filetype' },
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
    inactive_winbar = {},
    extensions = {},
    winbar = {
    }
}
