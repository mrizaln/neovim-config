-- the plugins setup needs to be in the following order:
--  1. mason.nvim
--  2. mason-lspconfig.nvim
--  3. setup servers via lspconfig

require("mason").setup({
	ui = {
		icons = {
			package_installed = "✓",
			package_pending = "➜",
			package_uninstalled = "✗",
		},
	},
})

require("mason-lspconfig").setup({
	ensure_installed = {
		"sumneko_lua", -- lua
		"clangd", -- C, C++
		"pyright", -- python (type checker)
		"rust_analyzer", -- rust
		"tsserver", -- typescript, javascript
		"bashls", -- bash
		"cmake", -- cmake
	},
})

-- load nvim-cmp capabilites
local capabilites = vim.lsp.protocol.make_client_capabilities()
local ok, cmp_lsp = pcall(require, "cmp_nvim_lsp")
if ok then
	capabilites = cmp_lsp.default_capabilities()
end

-- for LSPs installed using Mason
require("mason-lspconfig").setup_handlers({
	--------------------[ default handler ]--------------------
	function(server_name) -- default handler (optional)
		require("lspconfig")[server_name].setup({
			capabilites = capabilites,
		})
	end,

	-----------------------[ overrides ]-----------------------
	-- lua
	["sumneko_lua"] = function()
		require("lspconfig")["sumneko_lua"].setup({
			capabilities = capabilites,
			settings = {
				Lua = {
					diagnostics = {
						globals = { "vim", "use", "require" },
					},
					--workspace = {
					-- Make the server aware of Neovim runtime files
					--library = {[vim.fn.expand('$VIMRUNTIME/lua')] = true, [vim.fn.expand('$VIMRUNTIME/lua/vim/lsp')] = true}
					--}
				},
			},
		})
	end,

	-- rust
	["rust_analyzer"] = function()
		require("lspconfig")["rust_analyzer"].setup({
			capabilities = capabilites,
			-- on_attach = function(client) require('completion').on_attach(client) end,
			settings = {
				["rust-analyzer"] = {
					imports = {
						granularity = {
							group = "module",
						},
						prefix = "self",
					},
					cargo = {
						buildScripts = {
							enable = true,
						},
					},
					procMacro = {
						enable = true,
					},
				},
			},
		})
	end,

	-- -- js and ts
	-- ['tsserver'] = function ()
	--     require('lspconfig')['tsserver'].setup({
	--         capabilites = require('cmp_nvim_lsp').default_capabilities(),
	--
	--     })
	-- end
})

--
--------------------[ keybinds ]--------------------
-- lsp
local function keymap(mode, l, r, opts)
	opts = opts or {}
	opts.noremap = true
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

keymap("n", "<leader>af", vim.lsp.buf.code_action, { desc = "Code action" })
keymap("n", "<leader>rn", vim.lsp.buf.rename, { desc = "Rename symbol" })

keymap("n", "<space>e", vim.diagnostic.open_float, { desc = "Line diagnostic" })
keymap("n", "[d", vim.diagnostic.goto_prev, { desc = "Previous diagnostic" })
keymap("n", "]d", vim.diagnostic.goto_next, { desc = "Next diagnostic" })
keymap("n", "<space>q", vim.diagnostic.setloclist, { desc = "List all diagnostics" })

keymap({ "n", "i" }, "<c-k>", vim.lsp.buf.signature_help, { desc = "Signature help" })
keymap_insert("i", ", ", vim.lsp.buf.signature_help, { desc = "Signature help" })

--
-- disable clang-format at selected block (only on c, cpp, js, ts)
local filename = vim.fn.bufname()
local fileSplit = _G.myUtils.splitString(filename, ".")
local fileTypes = { "c", "cpp", "js", "ts" }
for _, v in pairs(fileTypes) do
	local filetype = fileSplit[#fileSplit]
	-- if fileSplit[#fileSplit] == v then
	if filetype == v then
		vim.api.nvim_set_keymap(
			"v",
			"fd",
			"<Esc>o// clang-format on<Esc>gvO<Esc>O// clang-format off<Esc>gvO",
			{ noremap = true }
		)
		break
	end
end
