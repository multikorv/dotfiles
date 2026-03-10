--local lsp_config = require('lspconfig')
local lsp_config = vim.lsp

--lsp_config.tsserver.setup({})
lsp_config.enable('tsserver')
--lsp_config.pyright.setup({})
lsp_config.enable('pyright')
--lsp_config.lua_ls.setup({})
lsp_config.enable('lua_ls')
--lsp_config.pico8_ls.setup({})
lsp_config.enable('pico8_ls')

-- TODO: Make plaform/env agnostic
-- only work from powershell
--local pid = vim.fn.getpid()
--local omnisharp_bin = '/home/mutanton/.local/share/nvim/mason/packages/omnisharp-mono/run'
--lsp_config.omnisharp.setup({
lsp_config.config('omnisharp', {
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

lsp_config.enable('omnisharp')

--lsp_config.rust_analyzer.setup({
lsp_config.config('rust_analyzer', {
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

lsp_config.enable('rust_analyzer')

-- **** clangd ****

---@brief
---
--- https://clangd.llvm.org/installation.html
---
--- - **NOTE:** Clang >= 11 is recommended! See [#23](https://github.com/neovim/nvim-lspconfig/issues/23).
--- - If `compile_commands.json` lives in a build directory, you should
---   symlink it to the root of your source tree.
---   ```
---   ln -s /path/to/myproject/build/compile_commands.json /path/to/myproject/
---   ```
--- - clangd relies on a [JSON compilation database](https://clang.llvm.org/docs/JSONCompilationDatabase.html)
---   specified as compile_commands.json, see https://clangd.llvm.org/installation#compile_commandsjson

-- https://clangd.llvm.org/extensions.html#switch-between-sourceheader
local function switch_source_header(bufnr, client)
    local method_name = 'textDocument/switchSourceHeader'
    ---@diagnostic disable-next-line:param-type-mismatch
    if not client or not client:supports_method(method_name) then
        return vim.notify(('method %s is not supported by any servers active on the current buffer'):format(method_name))
    end
    local params = vim.lsp.util.make_text_document_params(bufnr)
    ---@diagnostic disable-next-line:param-type-mismatch
    client:request(method_name, params, function(err, result)
        if err then
            error(tostring(err))
        end
        if not result then
            vim.notify('corresponding file cannot be determined')
            return
        end
        vim.cmd.edit(vim.uri_to_fname(result))
    end, bufnr)
end

local function symbol_info(bufnr, client)
    local method_name = 'textDocument/symbolInfo'
    ---@diagnostic disable-next-line:param-type-mismatch
    if not client or not client:supports_method(method_name) then
        return vim.notify('Clangd client not found', vim.log.levels.ERROR)
    end
    local win = vim.api.nvim_get_current_win()
    local params = vim.lsp.util.make_position_params(win, client.offset_encoding)
    ---@diagnostic disable-next-line:param-type-mismatch
    client:request(method_name, params, function(err, res)
        if err or #res == 0 then
            -- Clangd always returns an error, there is no reason to parse it
            return
        end
        local container = string.format('container: %s', res[1].containerName) ---@type string
        local name = string.format('name: %s', res[1].name) ---@type string
        vim.lsp.util.open_floating_preview({ name, container }, '', {
            height = 2,
            width = math.max(string.len(name), string.len(container)),
            focusable = false,
            focus = false,
            title = 'Symbol Info',
        })
    end, bufnr)
end

--lsp_config.clangd.setup({
lsp_config.config('clangd', {
    cmd = { 'clangd', '--completion-style=detailed' },
    filetypes = { 'c', 'cpp', 'objc', 'objcpp', 'cuda' },
    root_markers = {
        '.clangd',
        '.clang-tidy',
        '.clang-format',
        'compile_commands.json',
        'compile_flags.txt',
        'configure.ac', -- AutoTools
        '.git',
    },
    get_language_id = function(_, ftype)
        local t = { objc = 'objective-c', objcpp = 'objective-cpp', cuda = 'cuda-cpp' }
        return t[ftype] or ftype
    end,
    capabilities = {
        textDocument = {
            completion = {
                editsNearCursor = true,
            },
        },
        offsetEncoding = { 'utf-8', 'utf-16' },
    },
    ---@param init_result ClangdInitializeResult
    on_init = function(client, init_result)
        if init_result.offsetEncoding then
            client.offset_encoding = init_result.offsetEncoding
        end
    end,
    on_attach = function(client, bufnr)
        vim.api.nvim_buf_create_user_command(bufnr, 'LspClangdSwitchSourceHeader', function()
            switch_source_header(bufnr, client)
        end, { desc = 'Switch between source/header' })

        vim.api.nvim_buf_create_user_command(bufnr, 'LspClangdShowSymbolInfo', function()
            symbol_info(bufnr, client)
        end, { desc = 'Show symbol info' })
  end,
})

lsp_config.enable('clangd')
-- **** ****

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
        vim.keymap.set({ 'n', 'v' }, '<leader>ca', vim.lsp.buf.code_action, opts)

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
