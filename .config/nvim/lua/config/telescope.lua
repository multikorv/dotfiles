local builtin = require('telescope.builtin')

vim.keymap.set('n', '<leader>tt', builtin.lsp_workspace_symbols, {})
vim.keymap.set('n', '<leader>tf', builtin.find_files, {})
vim.keymap.set('n', '<leader>tg', builtin.git_files, {})
vim.keymap.set('n', '<leader>tb', builtin.buffers, {})
vim.keymap.set('n', '<leader>ts', builtin.live_grep, {})
vim.keymap.set('n', '<leader>th', builtin.help_tags, {})
vim.keymap.set('n', '<leader>td', builtin.diagnostics, {})

-- open file_browser with the path of the current buffer
-- DISABLED, using oil
--vim.api.nvim_set_keymap(
--  'n',
--  '<leader>to',
--  ':Telescope file_browser path=%:p:h select_buffer=true auto_depth=true<CR>',
--  { noremap = true }
--)

-- open file_browser over nvim config files
vim.api.nvim_set_keymap(
  'n',
  '<leader>tc',
  --':Telescope file_browser path=~/.config/nvim select_buffer=true<CR>',
  ':Telescope file_browser path=' .. CONFIG_FILES .. ' select_buffer=true<CR>',
  { noremap = true }
)
