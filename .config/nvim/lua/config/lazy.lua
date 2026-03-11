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

    -- Git stuff
    'lewis6991/gitsigns.nvim',

    -- File system plugin
    {
        'stevearc/oil.nvim',
        dependencies = 'nvim-mini/mini.icons',
    },
    'refractalize/oil-git-status.nvim',

    -- CMP and related plugins
    'hrsh7th/nvim-cmp',
    'hrsh7th/cmp-nvim-lsp',
    'hrsh7th/cmp-buffer',
    'hrsh7th/cmp-cmdline',
    'dmitmel/cmp-cmdline-history',

    -- Snippet engine for lua
    {
        "L3MON4D3/LuaSnip",
        -- follow latest release.
        version = "v2.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
        -- install jsregexp (optional!).
        build = "make install_jsregexp"
    },

    -- LSP - essential obviously
    'neovim/nvim-lspconfig',

    -- Status line
    'famiu/feline.nvim',

    -- Telescope fuzzy finder is essential
    {
        'nvim-telescope/telescope.nvim', 
        --tag = '0.1.8', 
        dependencies = 
        { 
            'nvim-lua/plenary.nvim' 
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
