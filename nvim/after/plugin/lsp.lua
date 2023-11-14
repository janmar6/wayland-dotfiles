
local lsp = require("lsp-zero")	

lsp.preset('recommended')

lsp.setup()

vim.keymap.set("x", "<leader>p", "\"_dP")

