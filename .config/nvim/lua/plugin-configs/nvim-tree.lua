require("nvim-tree").setup()

local keymap = vim.api.nvim_set_keymap
local opts = { noremap = true }

keymap('n', '<leader>tt', ':NvimTreeToggle<cr>', opts)
keymap("n", "<leader>tf", ":NvimTreeFocus<cr>", opts)
keymap("n", "<leader>tc", ":NvimTreeClose<cr>", opts)
keymap("n", "<leader>tr", ":NvimTreeRefresh<cr>", opts)
keymap("n", "<leader>tn", ":NvimTreeFindFile<cr>", opts)
