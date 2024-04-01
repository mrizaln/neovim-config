local builtin = require("telescope.builtin")

vim.keymap.set("n", "<leader>sF", builtin.find_files)
if _G.myUtils.findGitDir() then
	vim.keymap.set("n", "<leader>sf", builtin.git_files)
else
	vim.keymap.set("n", "<leader>sf", function()
		print("Not in git repo, falling back to find_files")
		builtin.find_files()
	end)
end

vim.keymap.set("n", "<leader>sg", builtin.live_grep)
vim.keymap.set("n", "<leader>sb", builtin.buffers)
vim.keymap.set("n", "<leader>sh", builtin.help_tags)

vim.keymap.set("n", "<leader>ss", builtin.lsp_document_symbols)
vim.keymap.set("n", "<leader>sw", builtin.lsp_workspace_symbols)
