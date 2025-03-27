require("aerial").setup({
	on_attach = function(bufnr)
		-- jump forwards/backwards with '{' and '}'
		vim.keymap.set("n", "{", "<cmd>AerialPrev<cr>", { buffer = bufnr })
		vim.keymap.set("n", "}", "<cmd>AerialNext<cr>", { buffer = bufnr })
	end,
})

vim.keymap.set("n", "<leader>sy", "<cmd>AerialToggle!<cr>")
