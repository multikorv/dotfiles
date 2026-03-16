local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        'git',
        'clone',
        '--filter=blob:none',
        'https://github.com/folke/lazy.nvim.git',
        '--branch=stable', -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

require('lazy').setup({
    -- Common dependency
    'nvim-lua/plenary.nvim',
    {
        'nvim-treesitter/nvim-treesitter',
        build = ':TSUpdate'
    },

    -- Requires a nerd font to work properly, essentially a font patched with glyph support
    { "nvim-tree/nvim-web-devicons", opts = {} },

    'nvim-treesitter/nvim-treesitter-context',
    {
        'nvim-mini/mini.nvim',
        version = '*',
    },

    -- Mason is essentially core and is used heavily together wiht LSP
    'williamboman/mason.nvim',
    {
        'williamboman/mason-lspconfig.nvim',
        lazy = false 
    },

    -- *** LSP ***
    -- LSP - essential obviously
    'neovim/nvim-lspconfig',

    -- Icons for lsp
    'onsails/lspkind.nvim',

    -- Prettier display of LSP issues
    {
        'rachartier/tiny-inline-diagnostic.nvim',
        event = "VeryLazy",
        priority = 1000,
        config = function()
            require("tiny-inline-diagnostic").setup()
            vim.diagnostic.config({ virtual_text = false }) -- Disable Neovim's default virtual text diagnostics
        end,
    },

    -- Better code action overview and preview
    {
        'rachartier/tiny-code-action.nvim',
        dependencies = {
            { 'nvim-lua/plenary.nvim' },
            { 'nvim-telescope/telescope.nvim' },
        },
        event = 'LspAttach',
        opts = {},
    },
    -- *** ***

    -- Git stuff
    'lewis6991/gitsigns.nvim',

    -- File system plugin
    {
        'stevearc/oil.nvim',
        dependencies = 'nvim-mini/mini.icons',
    },
    'refractalize/oil-git-status.nvim',


    -- *** CMP ***
    'hrsh7th/nvim-cmp',
    'hrsh7th/cmp-nvim-lsp',
    'hrsh7th/cmp-nvim-lua',
    'hrsh7th/cmp-buffer',
    'hrsh7th/cmp-path',
    'saadparwaiz1/cmp_luasnip',
    'hrsh7th/cmp-cmdline',
    'dmitmel/cmp-cmdline-history',
    -- *** ***

    -- Snippet engine for lua
    {
        "L3MON4D3/LuaSnip",
        -- follow latest release.
        version = "v2.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
        -- install jsregexp (optional!).
        build = "make install_jsregexp"
    },

    -- Trouble - helps with issues and actions
    'folke/trouble.nvim',
    {
        "folke/trouble.nvim",
        opts = {}, -- for default options, refer to the configuration section for custom setup.
        cmd = "Trouble",
    },

    -- Status line
    'famiu/feline.nvim',

    -- Telescope fuzzy finder is essential
    {
        'nvim-telescope/telescope.nvim',
        --tag = '0.1.8',
        dependencies =
        { 
            'nvim-lua/plenary.nvim',
            'nvim-tree/nvim-web-devicons',
        }
    },
    {
        'nvim-telescope/telescope-file-browser.nvim',
        dependencies =
        {
            'nvim-telescope/telescope.nvim',
            'nvim-lua/plenary.nvim'
        }
    },

    -- Themes, colors and feel
    'folke/tokyonight.nvim',
    { 
        'rose-pine/neovim', 
        name = 'rose-pine' 
    }
})
