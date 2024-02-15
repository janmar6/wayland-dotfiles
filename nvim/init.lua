--  NOTE: Must happen before plugins are required (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

require('lazy-bootstrap')
require('lazy-plugins')
require('options')
require('keymaps')
require('telescope-setup')
require('treesitter-setup')
require('lsp-setup')
require('cmp-setup')



-- Define a variable to keep track of the current mode
local current_mode = "dark"

-- Function to toggle between dark and light mode
_G.toggle_colorscheme = function()
  if current_mode == "dark" then
    vim.o.background = "light"
    current_mode = "light"
  else
    vim.o.background = "dark"
    current_mode = "dark"
  end
  -- Reload the colorscheme
  vim.cmd([[colorscheme gruvbox]])
end

-- Set leader key mappings for toggling
vim.api.nvim_set_keymap('n', '<Leader>j', ':lua toggle_colorscheme()<CR>', { noremap = true, silent = true })

-- Initial colorscheme setup
vim.o.background = "dark"
vim.cmd([[colorscheme gruvbox]])




-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
