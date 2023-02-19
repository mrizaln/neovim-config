-- default config = require('symbols-outline.config.defaults')

require("symbols-outline").setup()

local opts = { noremap = true, silent = false }
vim.api.nvim_set_keymap("n", "<leader>sy", ":SymbolsOutline<cr>", opts)
vim.api.nvim_set_keymap("v", "<leader>sy", ":SymbolsOutline<cr>", opts)
