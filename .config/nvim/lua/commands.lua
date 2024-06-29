----------------------------------[ commands ]----------------------------------
--

-- [ delete hidden buffers ]
-- source: https://stackoverflow.com/a/30101152

-- vim.api.nvim_create_user_command("DeleteHiddenBuffers", function(args)
-- 	if args.bang then
-- 		vim.cmd([[%bdelete!|edit #|normal`"]])
-- 	else
-- 		vim.cmd([[%bdelete|edit #|normal`"]])
-- 	end
-- end, { bang = true })
vim.cmd([[command! -bang DeleteHiddenBuffers %bdelete<bang>|edit #|normal`"]])

-- [ toggle background color to and from 'none' (original terminal color) ]
local configured_background = {
	normal = nil,
	normal_float = nil,
}
vim.api.nvim_create_user_command("ToggleBackground", function()
	if configured_background.normal == nil or configured_background.normal_float == nil then
		configured_background = {
			normal = vim.api.nvim_get_hl_by_name("Normal", true).background,
			normal_float = vim.api.nvim_get_hl_by_name("NormalFloat", true).background,
		}
	end

	local bg = vim.api.nvim_get_hl_by_name("Normal", true).background
	if bg == nil then
		vim.api.nvim_set_hl(0, "Normal", { bg = configured_background.normal })
		vim.api.nvim_set_hl(0, "NormalFloat", { bg = configured_background.normal_float })
	else
		vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
		vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
	end
end, {})

-- [ toggle navigation motion for long lines as separate lines (on wrapped lines) ]
local use_nav_long_lines = false -- by default, when wrapped, navigate long lines as separate lines
vim.api.nvim_create_user_command("ToggleNavLongLines", function()
	use_nav_long_lines = not use_nav_long_lines
	if use_nav_long_lines then
		vim.cmd([[
            nnoremap j gj
            nnoremap k gk
        ]])
	else
		vim.cmd([[
            nnoremap j j
            nnoremap k k
        ]])
	end
end, {})

-- [ toggle inlay hint ]
vim.api.nvim_create_user_command("ToggleInlayHint", function()
	local clients = vim.lsp.get_clients({ bufnr = 0 })
	if #clients == 0 then
		vim.notify("No LSP client found", vim.log.levels.WARN)
		return
	end
	for _, client in ipairs(clients) do
		if client.server_capabilities.inlayHintProvider then
			vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = 0 }), { bufnr = 0 })
		end
	end
end, {})
