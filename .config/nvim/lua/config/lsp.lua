local lsp_config = require('lspconfig')

lsp_config.tsserver.setup({})
lsp_config.pyright.setup({})
lsp_config.lua_ls.setup({})
lsp_config.pico8_ls.setup({})

-- TODO: Make plaform/env agnostic
-- only work from powershell
--local pid = vim.fn.getpid()
--local omnisharp_bin = '/home/mutanton/.local/share/nvim/mason/packages/omnisharp-mono/run'
lsp_config.omnisharp.setup({
    --[[
    flags = {
        debounce_text_changes = 150
    },
    ]] --
    --cmd = { omnisharp_bin, '--languageserver', '--hostPID', tostring(pid) },
    --root_dir = lsp_config.util.root_pattern('*.csproj', '*.sln');
    cmd = {
        'mono',
        '--assembly-loader=strict',
        'OmniSharp.exe',
    },
    --root_dir = lsp_config.util.root_pattern('*.csproj', '*.sln');
    --on_attach = on_attach,
    use_mono = true,
})

lsp_config.rust_analyzer.setup({
    settings = {
        ['rust-analyzer'] = {
            check = {
                command = 'clippy',
            },
            diagnostics = {
                enable = true,
            }
        }
    }
})

-- Global mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist)

-- Use LspAttach autocommand to only map the following keys
-- after the language server attaches to the current buffer
vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('UserLspConfig', {}),
    callback = function(ev)
        -- Enable completion triggered by <c-x><c-o>
        vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

        -- Buffer local mappings.
        -- See `:help vim.lsp.*` for documentation on any of the below functions
        local opts = { buffer = ev.buf }
        vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
        vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
        vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
        vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)

        vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
        vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)


        vim.keymap.set('n', '<leader>wa', vim.lsp.buf.add_workspace_folder, opts)
        vim.keymap.set('n', '<leader>wr', vim.lsp.buf.remove_workspace_folder, opts)
        vim.keymap.set('n', '<leader>wl', function()
                print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
            end,
            opts
        )
        vim.keymap.set('n', '<leader>D', vim.lsp.buf.type_definition, opts)

        vim.keymap.set('n', '<leader>rr', vim.lsp.buf.rename, opts)
        vim.keymap.set({ 'n', 'v' }, '<space>ca', vim.lsp.buf.code_action, opts)

        vim.keymap.set('n', '<leader>f', function()
                vim.lsp.buf.format { async = true }
            end,
            opts
        )
    end,
})

-- Specific for getting pico8-ls client to start

vim.api.nvim_create_autocmd({'BufNew', 'BufEnter'}, {
    pattern = { '*.p8' },
    callback = function(args)
        vim.lsp.start({
            name = 'pico8-ls',
            cmd = { 'pico8-ls', '--stdio' },
            root_dir = vim.fs.dirname(vim.api.nvim_buf_get_name(args.buf)),
            -- Setup your keybinds in the on_attach function
            --on_attach = on_attach,
        })
    end
})
