if vim.fn.has('nvim-0.7') ~= 1 then
  vim.api.nvim_err_writeln('pest.nvim requires Neovim 0.7 or higher')
  return
end

local M = {}

M.config = {
  pest_cmd = 'vendor/bin/pest',
  window_size = 25,
}

function M.setup(user_config)
  M.config = vim.tbl_extend('force', M.config, user_config or {})
  
  -- Set up default keybindings
  vim.api.nvim_set_keymap('n', '<leader>Pa', ':PestRunAll<CR>', { noremap = true, silent = true, desc = 'Pest: Run all tests' })
  vim.api.nvim_set_keymap('n', '<leader>Pf', ':PestRunFile<CR>', { noremap = true, silent = true, desc = 'Pest: Run current file' })
  vim.api.nvim_set_keymap('n', '<leader>Pt', ':PestRunTest<CR>', { noremap = true, silent = true, desc = 'Pest: Run current test' })
  vim.api.nvim_set_keymap('n', '<leader>Ps', ':PestRunFilter ', { noremap = true, desc = 'Pest: Run filtered tests' })
end

return M
