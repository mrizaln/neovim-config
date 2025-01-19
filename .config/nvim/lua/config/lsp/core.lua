--------------------------------------------------------------------------------
-- the plugins setup needs to be in the following order:
--  1. mason.nvim
--  2. mason-lspconfig.nvim
--  3. setup servers via lspconfig

-- turn off lsp log (only enable logging for debugging)
vim.lsp.set_log_level(vim.lsp.log_levels.OFF)

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
		-- "clangd@18.1.3", -- C, C++ (version 19.1.4 has a bug: random crash with sigsev signal)
		-- "jedi_language_server", -- python
		-- "pyright",       -- fuckin slowwwwwwwwwwwwwwwwwwwwwww
		-- "rust_analyzer", -- rust
		-- "ts_ls", -- typescript, javascript
		"bashls", -- bash
		-- "cmake", -- cmake
	},
})

-- load nvim-cmp capabilites
local capabilites = vim.lsp.protocol.make_client_capabilities()
local ok, cmp_lsp = pcall(require, "cmp_nvim_lsp")
if ok then
	capabilites = cmp_lsp.default_capabilities()
end

local function configure_clangd()
	require("lspconfig")["clangd"].setup({
		capabilites = capabilites,
		cmd = {
			"clangd",
			-- by default, clang-tidy use -checks=clang-diagnostic-*,clang-analyzer-*
			-- to add more checks, create .clang-tidy file in the root directory
			-- and add Checks key, see https://clang.llvm.org/extra/clang-tidy/
			"--clang-tidy",
			"--background-index=false",
			"--completion-style=bundled",
			"--header-insertion=iwyu",
			-- "--header-insertion=never",
			"--offset-encoding=utf-16",
			"-j=4", -- worker threads
			"--malloc-trim=true", -- glibc platform only
			-- "--ranking-model=decision_forest",
			"--ranking-model=heuristics",
			-- "--completion-style=detailed",
			-- "--function-arg-placeholders=true", -- not working for some reason
			-- "--all-scopes-completion=false", -- turn off annoying completion from other scopes
		},
	})
end

local function configure_rust_analyzer()
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
				check = {
					-- enable clippy
					command = "clippy",
				},
			},
		},
	})
end

-- for LSPs installed using Mason
require("mason-lspconfig").setup_handlers({
	--------------------[ default handler ]--------------------
	function(server_name) -- default handler (optional)
		require("lspconfig")[server_name].setup({
			on_attach = function(client)
				if client.server_capabilities.inlayHintProvider then
					vim.lsp.inlay_hint.enable(true)
				end
			end,
			capabilites = capabilites,
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
		configure_clangd()
	end,

	-- rust
	["rust_analyzer"] = function()
		configure_rust_analyzer()
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
		})
	end,

	-- ["pyright"] = function()
	-- 	require("lspconfig")["pyright"].setup({
	-- 		capabilites = capabilites,
	-- 	})
	-- end,

	["gopls"] = function()
		require("lspconfig")["gopls"].setup({
			capabilites = capabilites,
			settings = {
				gopls = {
					analyses = {
						unusedparams = true,
					},
					staticcheck = true,
					gofumpt = true,
					-- matcher = "CaseInsensitive", -- default is "Fuzzy"
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

-- for LSPs not installed using Mason
-- configure_clangd()
configure_rust_analyzer()

-- require("lspconfig.configs")["pyls"] = {
-- 	default_config = {
-- 		cmd = {
-- 			"venv-run",
-- 			"--venv",
-- 			"/home/mrizaln/kela/python-language-server-venv/venv/",
-- 			"--",
-- 			"pyls",
-- 		},
-- 		filetypes = { "python" },
-- 		single_file_support = true,
-- 	},
-- 	docs = {
-- 		description = [[nothing]],
-- 	},
-- }

-- require("lspconfig")["pyls"].setup({
-- 	capabilites = capabilites,
-- 	autostart = false,
-- })
