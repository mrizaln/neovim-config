require("lsp_signature").setup({
	bind = true, -- This is mandatory, otherwise border config won't get registered.
	handler_opts = {
		border = "rounded", -- double, rounded, single, shadow, none, or a table of borders
	},
})

vim.keymap.set("i", "<c-k>", function()
	require("lsp_signature").toggle_float_win()
end, { silent = true, noremap = true, desc = "toggle signature" })
