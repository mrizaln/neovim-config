--------------------------------------------------------------------------------
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
		border = "rounded",
	},
})

require("mason-lspconfig").setup({
	ensure_installed = {
		"lua_ls", -- lua
		"clangd", -- C, C++
		-- "jedi_language_server", -- python
		"pyright",
		"rust_analyzer", -- rust
		"tsserver", -- typescript, javascript
		"bashls", -- bash
		"cmake", -- cmake
	},
})

-- variable highlighting
local variable_highlight_aucmd = [[
    augroup VariableHighlight
        autocmd CursorHold  <buffer> lua vim.lsp.buf.document_highlight()
        autocmd CursorHoldI <buffer> lua vim.lsp.buf.document_highlight()
        autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
    augroup END
]]

-- load nvim-cmp capabilites
local capabilites = vim.lsp.protocol.make_client_capabilities()
local ok, cmp_lsp = pcall(require, "cmp_nvim_lsp")
if ok then
	capabilites = cmp_lsp.default_capabilities()
end

local function on_attach(client, additional)
	local filetype = vim.api.nvim_buf_get_option(0, "filetype")
	local shouldAttach = _G.myUtils.isInTable(filetype, client.config.filetypes)
		or _G.myUtils.isInTable(filetype, additional)
	-- print(vim.api.nvim_get_current_buf() .. " | " .. filetype .. " | on_attach client: " .. client.name)

	if not shouldAttach then
		vim.lsp.buf_detach_client(vim.api.nvim_get_current_buf(), client.id)
		-- print("detaching client: " .. client.name)
	end
end

-- for LSPs installed using Mason
require("mason-lspconfig").setup_handlers({
	--------------------[ default handler ]--------------------
	function(server_name) -- default handler (optional)
		require("lspconfig")[server_name].setup({
			capabilites = capabilites,
			on_attach = function(client)
				on_attach(client, {})
			end,
			-- settings = {
			--     completion = {
			--         callSnippet ="Replace"
			--     },
			-- },
		})
	end,

	-----------------------[ overrides ]-----------------------
	-- clangd
	["clangd"] = function()
		local config = require("lspconfig.server_configurations.clangd").default_config
		config.capabilites = capabilites
		-- config.cmd = { "clangd", "--enable-config" }
		config.cmd = {
			"clangd",
			-- by default, clang-tidy use -checks=clang-diagnostic-*,clang-analyzer-*
			-- to add more checks, create .clang-tidy file in the root directory
			-- and add Checks key, see https://clang.llvm.org/extra/clang-tidy/
			"--clang-tidy",
			"--background-index",
			"--completion-style=bundled",
			"--header-insertion=iwyu",
			"--offset-encoding=utf-16",
		}
		config.on_attach = function(client)
			on_attach(client, { "h", "hpp" })
		end
		require("lspconfig")["clangd"].setup(config)
	end,

	-- lua
	["lua_ls"] = function()
		require("lspconfig")["lua_ls"].setup({
			capabilities = capabilites,
			settings = {
				Lua = {
					diagnostics = {
						globals = { "vim", "use", "require" },
					},
					workspace = {
						-- Make the server aware of Neovim runtime files
						library = {
							[vim.fn.expand("$VIMRUNTIME/lua")] = true,
							[vim.fn.expand("$VIMRUNTIME/lua/vim/lsp")] = true,
						},
					},
					completion = {
						callSnippet = "Replace",
					},
				},
			},
			on_attach = function(client)
				on_attach(client, {})
			end,
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
			on_attach = function(client)
				on_attach(client, {})
			end,
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
