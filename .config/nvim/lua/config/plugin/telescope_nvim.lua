local keymap = vim.api.nvim_set_keymap

local opts = { noremap = true }
keymap("n", "<leader>sf", "<cmd>lua require('telescope.builtin').find_files()<cr>", opts)
keymap("n", "<leader>sg", "<cmd>lua require('telescope.builtin').live_grep()<cr>", opts)
keymap("n", "<leader>sb", "<cmd>lua require('telescope.builtin').buffers()<cr>", opts)
keymap("n", "<leader>sh", "<cmd>lua require('telescope.builtin').help_tags()<cr>", opts)
