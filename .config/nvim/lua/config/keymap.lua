-- Tabs
vim.keymap.set('n', '<C-t>', ':tabnew<cr>')
vim.keymap.set('n', '<C-c>', ':tabclose<cr>')
vim.keymap.set('n', '<leader>L', ':tabnext<cr>')
vim.keymap.set('n', '<leader>H', ':tabprev<cr>')

-- Viewports
vim.keymap.set('n', '<Leader>h', '<C-w>h', { desc = 'Move to left split' })
vim.keymap.set('n', '<Leader>j', '<C-w>j', { desc = 'Move to below split' })
vim.keymap.set('n', '<Leader>k', '<C-w>k', { desc = 'Move to above split' })
vim.keymap.set('n', '<Leader>l', '<C-w>l', { desc = 'Move to right split' })
