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
	-- clangd
	["clangd"] = function()
		local config = require("lspconfig.server_configurations.clangd").default_config
		config.capabilites = capabilites
		config.cmd = { "clangd", "--enable-config" }
		require("lspconfig")["clangd"].setup(config)
	end,

	-- lua
	["sumneko_lua"] = function()
		require("lspconfig")["sumneko_lua"].setup({
			capabilities = capabilites,
			settings = {
				Lua = {
					diagnostics = {
						globals = { "vim", "use", "require" },
					},
					workspace = {
					    -- Make the server aware of Neovim runtime files
					    library = {[vim.fn.expand('$VIMRUNTIME/lua')] = true, [vim.fn.expand('$VIMRUNTIME/lua/vim/lsp')] = true}
					},
                    completion = {
                        callSnippet = "Replace"
                    },
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
