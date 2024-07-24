require('fzf-lua').setup {
    fzf_bin = 'fzf',
    fzf_colors = true,
    winopts = {
        split = "botright new",
        border = 'none',
        -- fullscreen = true,
        height           = 0.5,            -- window height
        width            = 1,            -- window width
        row              = 1,            -- window row position (0=top, 1=bottom)
        -- col              = 1,            -- window col position (0=left, 1=right)
        border           = { '', '─', '', '', '', '', '', '' },
        preview = {
            -- default = 'bat',
            border = 'noborder',
            hidden = 'nohidden',
            layout = "horizontal",
            horizontal = 'right:40%',
            delay = 50,
            winopts = {
                number = false
            }
        }
    },
    previewers = {
        builtin = {
            treesitter = {
                enable = false
            },
        }
    },
    keymap = {
        -- builtin = {
        --     true,
        --     ["ctrl-l"] = "toggle-preview",
        --     ["ctrl-f"] = "toggle-fullscreen",
        -- },
        -- fzf = {
        --     true,
        --     ["ctrl-l"] = "toggle-preview",
        --     [""] = "toggle-fullscreen",
        -- }
    }
}
