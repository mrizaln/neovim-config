--------------------------------[ lsp keybinds ]--------------------------------
local use_direct_keymap = false

if use_direct_keymap then
	local function keymap(mode, l, r, opts)
		opts = opts or {}
		opts.silent = true
		opts.buffer = true
		opts.desc = string.format("Lsp: %s", opts.desc)
		vim.keymap.set(mode, l, r, opts)
	end

	-- insert %inputStr (or %l if inputStr == nil) before executing %r
	local function keymap_insert(mode, l, r, opts, inputStr)
		local action = function()
			inputStr = inputStr or l
			local cursorPos = vim.api.nvim_win_get_cursor(0)
			local col = cursorPos[2]
			local line = vim.api.nvim_get_current_line()
			local nline = line:sub(0, col) .. inputStr .. line:sub(col + 1)
			vim.api.nvim_set_current_line(nline)
			vim.api.nvim_win_set_cursor(0, { cursorPos[1], col + inputStr:len() })
			r()
		end
		keymap(mode, l, action, opts)
	end

	keymap("n", "gd", vim.lsp.buf.definition, { desc = "Definition" })
	keymap("n", "gD", vim.lsp.buf.declaration, { desc = "Declaration" })
	keymap("n", "gi", vim.lsp.buf.implementation, { desc = "implementation" })
	keymap("n", "gw", vim.lsp.buf.document_symbol, { desc = "List symbols" })
	keymap("n", "gw", vim.lsp.buf.workspace_symbol, { desc = "List symbols" })
	keymap("n", "gr", vim.lsp.buf.references, { desc = "References" })
	keymap("n", "gt", vim.lsp.buf.type_definition, { desc = "Type definition" })
	keymap("n", "K", vim.lsp.buf.hover, { desc = "Hover" })
	-- vim.api.nvim_set_keymap("n", "K", ":lua vim.lsp.buf.hover()<cr>", { noremap = true, silent = true })
	--[[ keymap("n", "K", function()
        if vim.bo.filetype == "help" then
            vim.api.nvim_feedkeys("K", "ni", true)
        else
            vim.lsp.buf.hover()
        end
    end, { desc = "Hover" }) ]]

	keymap("n", "<leader>af", vim.lsp.buf.code_action, { desc = "Code action" })
	keymap("n", "<leader>rn", vim.lsp.buf.rename, { desc = "Rename symbol" })

	keymap("n", "<space>e", vim.diagnostic.open_float, { desc = "Line diagnostic" })
	keymap("n", "[dd", vim.diagnostic.goto_prev, { desc = "Previous diagnostic" })
	keymap("n", "[da", function()
		vim.diagnostic.goto_prev()
		vim.lsp.buf.code_actiion()
	end, { desc = "Previous diagnostic" })
	keymap("n", "]dd", vim.diagnostic.goto_next, { desc = "Next diagnostic" })
	keymap("n", "]da", function()
		vim.diagnostic.goto_next()
		vim.lsp.buf.code_actiion()
	end, { desc = "Previous diagnostic" })
	keymap("n", "<space>q", function()
		local status, trouble = pcall(require, "trouble")
		if status then
			-- vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(":Trouble<cr>", true, false, true), "n", true)
			trouble.open()
		else
			vim.diagnostic.setloclist()
		end
	end, { desc = "List all diagnostics" })

	-- keymap({ "n", "i" }, "<c-K>", vim.lsp.buf.signature_help, { desc = "Signature help" })
	-- keymap_insert("i", ", ", vim.lsp.buf.signature_help, { desc = "Signature help" })
	-- keymap_insert("i", "(,", vim.lsp.buf.signature_help, { desc = "Signature help" })
else
	local opts = { noremap = true, silent = true }
	vim.api.nvim_set_keymap("n", "gd", ":lua vim.lsp.buf.definition()<cr>", opts)
	vim.api.nvim_set_keymap("n", "gD", ":lua vim.lsp.buf.declaration()<cr>", opts)
	vim.api.nvim_set_keymap("n", "gi", ":lua vim.lsp.buf.implementation()<cr>", opts)
	vim.api.nvim_set_keymap("n", "gw", ":lua vim.lsp.buf.document_symbol()<cr>", opts)
	vim.api.nvim_set_keymap("n", "gw", ":lua vim.lsp.buf.workspace_symbol()<cr>", opts)
	vim.api.nvim_set_keymap("n", "gr", ":lua vim.lsp.buf.references()<cr>", opts)
	vim.api.nvim_set_keymap("n", "gt", ":lua vim.lsp.buf.type_definition()<cr>", opts)
	-- vim.api.nvim_set_keymap("n", "K", ":lua vim.lsp.buf.hover()<cr>", opts)
	vim.api.nvim_set_keymap(
		"n",
		"K",
		[[:lua (function() if vim.bo.filetype == "help" then vim.api.nvim_feedkeys("K", "ni", true) else vim.lsp.buf.hover() end end)()<cr>]],
		-- [[:lua (function() if vim.bo.filetype == "help" then vim.api.nvim_feedkeys("K", "ni", true) else require("pretty_hover").hover() end end)()<cr>]],
		opts
	)

	-- vim.api.nvim_set_keymap("n", "<c-K>", ":lua vim.lsp.buf.signature_help()<cr>", opts)
	vim.api.nvim_set_keymap("n", "<leader>af", ":lua vim.lsp.buf.code_action()<cr>", opts)
	vim.api.nvim_set_keymap("n", "<leader>rn", ":lua vim.lsp.buf.rename()<cr>", opts)

	vim.keymap.set("n", "<space>e", vim.diagnostic.open_float, opts)
	vim.keymap.set("n", "[dd", vim.diagnostic.goto_prev, opts)
	vim.keymap.set("n", "[da", function()
		vim.diagnostic.goto_prev()
		vim.lsp.buf.code_action()
	end, opts)
	vim.keymap.set("n", "]dd", vim.diagnostic.goto_next, opts)
	vim.keymap.set("n", "]da", function()
		vim.diagnostic.goto_next()
		vim.lsp.buf.code_action()
	end, opts)
	-- vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist, opts)
	vim.keymap.set("n", "<space>q", function()
		local status, trouble = pcall(require, "trouble")
		if status then
			-- vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(":Trouble<cr>", true, false, true), "n", true)
			trouble.open()
		else
			vim.diagnostic.setloclist()
		end
	end, { desc = "List all diagnostics" })

	-- vim.api.nvim_set_keymap("n", "<c-K>", ":lua vim.lsp.buf.signature_help()", opts)
	-- vim.api.nvim_set_keymap("i", "<c-K>", ":lua vim.lsp.buf.signature_help()", opts)
end
--
--[ toggle inlay hints ]--
local function toggle_inlay_hints()
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
end

vim.keymap.set("n", "<leader>ih", toggle_inlay_hints, { desc = "Toggle inlay hints" })

--
--[ additional keybind ]--
--------------------------------------------------------------------------------

--[ filetype specific keybinds ]--
--
-- NOTE: not working, try to call this function from an autocmd after the filetype is set
local function filetype_keybinds(filetypes, mode, lhs, rhs, opts)
	local ft = vim.api.nvim_get_option_value("filetype", { scope = "local" })
	if vim.tbl_contains(filetypes, ft) then
		vim.keymap.set(mode, lhs, rhs, opts)
	end
end

local filetype_specific_keybinds = {
	[1] = {
		{ "c", "h", "cpp", "hpp", "js", "ts" },
		"v",
		"fd",
		"<Esc>o// clang-format on<Esc>gvO<Esc>O// clang-format off<Esc>gvO",
		{ noremap = true },
	},
	[2] = {
		{ "cpp" },
		"v",
		"<leader>c",
		"xistatic_cast<>()<esc>P`[v`]o<esc>ba",
		{ noremap = true, silent = true },
	},
	[3] = {
		{ "cpp" },
		"v",
		"<leader>m",
		"xistd::move()<esc>Pw",
		{ noremap = true, silent = true },
	},
}

vim.api.nvim_create_autocmd({ "FileType" }, {
	callback = function()
		local ft = vim.api.nvim_get_option_value("filetype", { scope = "local" })
		for _, keybind in ipairs(filetype_specific_keybinds) do
			if vim.tbl_contains(keybind[1], ft) then
				vim.keymap.set(keybind[2], keybind[3], keybind[4], keybind[5])
			end
		end
	end,
	pattern = "*",
	desc = "filetype keybinds",
})
