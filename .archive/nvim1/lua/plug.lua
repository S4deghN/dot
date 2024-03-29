local fn = vim.fn

-- Automatically install packer
local install_path = fn.stdpath "data" .. "/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
    PACKER_BOOTSTRAP = fn.system {
        "git",
        "clone",
        "--depth",
        "1",
        "https://github.com/wbthomason/packer.nvim",
        install_path,
    }
    print "Installing packer close and reopen Neovim..."
    vim.cmd [[packadd packer.nvim]]
end

-- Autocommand that reloads neovim whenever you save the plugins.lua file
-- vim.cmd ([[
--   augroup packer_user_config
--     autocmd!
--     autocmd BufWritePost plug.lua source <afile> | PackerSync
--   augroup end
-- ]])

-- Use a protected call so we don't error out on first use
local status_ok, packer = pcall(require, "packer")
if not status_ok then
    return
end

-- Have packer use a popup window
packer.init {
    display = {
        open_fn = function()
            return require("packer.util").float { border = "rounded" }
        end,
    },
}
-- Install your plugins here
return packer.startup(function(use)
    -- My plugins here
    use "wbthomason/packer.nvim" -- Have packer manage itself
    use "nvim-lua/plenary.nvim" -- Useful lua functions used ny lots of plugins
    use {
        "windwp/nvim-autopairs",
        config = function() require("nvim-autopairs").setup {} end
    }
    use "numToStr/Comment.nvim" -- Easily comment stuff
    use "junegunn/vim-easy-align"
    -- use "dhruvasagar/vim-table-mode" -- it auto populates the <space>t* I
    -- hate it
    -- use "vimwiki/vimwiki" -- it auto populates the <space>w*.
    use {
        "norcalli/nvim-colorizer.lua",
        config = function() require("colorizer").setup {} end
    }
    -- use "nvim-treesitter/nvim-treesitter-context"
    -- use { 'akinsho/bufferline.nvim', tag = "v2.*", requires = 'kyazdani42/nvim-web-devicons',
    --     config = function() require("bufferline").setup { } end }
    -- use "kyazdani42/nvim-web-devicons"
    -- use "kyazdani42/nvim-tree.lua"
    -- use "akinsho/bufferline.nvim"
    -- use "moll/vim-bbye"
    -- use "nvim-lualine/lualine.nvim"
    -- use "akinsho/toggleterm.nvim"
    -- use "ahmedkhalf/project.nvim"
    -- use "lewis6991/impatient.nvim"
    -- use "lukas-reineke/indent-blankline.nvim"
    -- use "goolord/alpha-nvim"
    -- use "antoinemadec/FixCursorHold.nvim" -- This is needed to fix lsp doc highlight
    -- use "mbbill/undotree"
    -- require('packer').use({
    --     'weilbith/nvim-code-action-menu',
    --     cmd = 'CodeActionMenu',
    -- })


    -- Colorschemes
    -- use "morhetz/gruvbox"
    use "gruvbox-community/gruvbox"
    use "sainnhe/gruvbox-material"
    use "sainnhe/everforest"
    use "Shatur/neovim-ayu"
    use "ful1e5/onedark.nvim"
    -- use "folke/tokyonight.nvim"
    use "w0ng/vim-hybrid"
    use "romgrk/doom-one.vim"
    use "romainl/Apprentice"
    use "habamax/vim-saturnite"
    use "habamax/vim-alchemist"
    use "Aszarsha/elysian.vim"
    use "habamax/vim-saturnite"
    use "savq/melange"
    use "rose-pine/neovim"
    use "rmehri01/onenord.nvim"
    use "lewpoly/sherbet.nvim"
    use "fxn/vim-monochrome"
    use "owickstrom/vim-colors-paramount"
    use "lifepillar/vim-solarized8"


    -- cmp plugins
    use "hrsh7th/nvim-cmp" -- The completion plugin
    use "hrsh7th/cmp-nvim-lsp-signature-help" -- The completion plugin
    use "hrsh7th/cmp-buffer" -- buffer completions
    use "hrsh7th/cmp-path" -- path completions
    use "hrsh7th/cmp-cmdline" -- cmdline completions
    use "saadparwaiz1/cmp_luasnip" -- snippet completions
    use "hrsh7th/cmp-nvim-lsp"

    -- snippets
    use "L3MON4D3/LuaSnip" --snippet engine
    use "rafamadriz/friendly-snippets" -- a bunch of snippets to use

    -- LSP
    use "neovim/nvim-lspconfig" -- enable LSP
    use "williamboman/nvim-lsp-installer" -- simple to use language server installer
    use "tamago324/nlsp-settings.nvim" -- language server settings defined in json for
    use "jose-elias-alvarez/null-ls.nvim" -- for formatters and linters

    -- LSP extras
    use "p00f/clangd_extensions.nvim"
    use "simrat39/rust-tools.nvim"
    -- use {
    --     "mfussenegger/nvim-dap",
    --     "Shatur/neovim-cmake",
    -- }
    -- use "stevearc/vim-arduino"

    -- fuzzy finder
    use "nvim-telescope/telescope.nvim"
    use "junegunn/fzf.vim"
    use "airblade/vim-rooter"

    -- Treesitter
    use {
        "nvim-treesitter/nvim-treesitter",
        run = ":TSUpdate",
    }
    use "JoosepAlviste/nvim-ts-context-commentstring"
    -- use "nvim-treesitter/playground"

    -- Git
    use "lewis6991/gitsigns.nvim"

    -- Automatically set up your configuration after cloning packer.nvim
    -- Put this at the end after all plugins
    if PACKER_BOOTSTRAP then
        require("packer").sync()
    end
end)
