local builtin = require("telescope.builtin")

vim.keymap.set("n", "<leader>sF", builtin.find_files)
if _G.my_utils.find_git_dir() then
	vim.keymap.set("n", "<leader>sf", builtin.git_files)
else
	vim.keymap.set("n", "<leader>sf", function()
		-- print("Not in git repo, falling back to find_files")
		builtin.find_files()
	end)
end
-- vim.keymap.set("n", "<leader>sf", builtin.git_files)

vim.keymap.set("n", "<leader>sg", builtin.live_grep)
vim.keymap.set("n", "<leader>sb", builtin.buffers)
vim.keymap.set("n", "<leader>sh", builtin.help_tags)

vim.keymap.set("n", "<leader>ss", builtin.resume)
vim.keymap.set("n", "<leader>sw", builtin.lsp_workspace_symbols)

local actions = require("telescope.actions")
local open_with_trouble = require("trouble.sources.telescope").open

-- Use this to add more results without clearing the trouble list
local add_to_trouble = require("trouble.sources.telescope").add

local telescope = require("telescope")

telescope.setup({
	defaults = {
		mappings = {
			i = { ["<c-t>"] = open_with_trouble },
			n = { ["<c-t>"] = open_with_trouble },
		},
	},
})
