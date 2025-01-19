-- package (plugins)
require("packer").startup(function()
	use("wbthomason/packer.nvim")

	-- colorscheme --
	-----------------
	-- use("AlexvZyl/nordic.nvim")
	use("folke/tokyonight.nvim")
	-- use("ray-x/aurora")
	-- use("rmehri01/onenord.nvim")
	-- use("sainnhe/sonokai")
	-- use("Shatur/neovim-ayu")
	-- use("tanvirtin/monokai.nvim")
	use("tomasr/molokai")
	use({ "catppuccin/nvim", as = "catppuccin" })
	-- use({ "challenger-deep-theme/vim", as = "challenger-deep-vim-theme" })
	-- use({ "dracula/vim", as = "dracula-vim-theme" })
	-- use({ "rose-pine/neovim", as = "rose-pine" })
	use({ "katawful/kat.nvim", tag = "3.1" })
	use("ellisonleao/gruvbox.nvim")
	-----------------

	-- quality of life --
	---------------------
	-- coppilot
	use({
		"zbirenbaum/copilot.lua",
		cmd = "Copilot",
		event = "InsertEnter",
		config = function()
			require("copilot").setup({
				suggestion = {
					keymap = {
						accept = "<a-space>",
					},
				},
			})
		end,
	})

	-- neodev (Neovim setup for init.lua)
	-- TODO: archived, replace with lazydev.nvim
	use({
		"folke/neodev.nvim",
		tag = "*",
		-- config: "~/.config/nvim/lua/config/plugin/neodev_nvim"
	})

	-- alpha (start screen)
	use({
		"goolord/alpha-nvim",
		commit = "bf3c8bb8c02ed3d9644cc5bbc48e2bdc39349cd7",
		requires = { "nvim-tree/nvim-web-devicons" },
		config = function()
			require("config/plugin/alpha-nvim")
		end,
	})

	-- floaterm (floating terminal)
	use({
		"voldikss/vim-floaterm",
		commit = "4e28c8dd0271e10a5f55142fb6fe9b1599ee6160",
		config = function()
			require("config/plugin/vim-floaterm")
		end,
	})

	-- nvim-tree (directory treeview)
	use({ -- nvim-tree requires nvim >= 0.8.0 --
		"nvim-tree/nvim-tree.lua",
		tag = "v1.7.1",
		requires = { "nvim-tree/nvim-web-devicons" },
		config = function()
			require("config/plugin/nvim-tree")
		end,
	})

	--[[ use {                           -- alternative to nvim-tree --
        'preservim/nerdtree',
        requires = { 'ryanoasis/vim-devicons' },
        config = function() require("config/plugin/nerdtree") end
    } --]]

	-- telescope (similar to fzf?)
	use({
		"nvim-telescope/telescope.nvim",
		tag = "0.1.8",
		requires = { "nvim-lua/plenary.nvim", "folke/trouble.nvim" },
		config = function()
			require("config/plugin/telescope_nvim")
		end,
	})

	-- lualine.nvim (status line prettifier)
	use({
		"nvim-lualine/lualine.nvim",
		commit = "b431d228b7bbcdaea818bdc3e25b8cdbe861f056",
		requires = { "kyazdani42/nvim-web-devicons", opt = true },
		config = function()
			require("config/plugin/lualine_nvim")
		end,
	})

	-- barbar (tabbed bar)      [ makes nvim v0.7.2 segfault idk why ]
	use({
		"romgrk/barbar.nvim",
		tag = "v1.9.1",
		wants = { "nvim-tree/nvim-web-devicons" },
		config = function()
			require("config/plugin/barbar_nvim")
		end,
	})

	-- rainbow parens (ts-rainbow replacement)
	use({
		"https://gitlab.com/HiPhish/rainbow-delimiters.nvim.git",
		tag = "v0.6.2",
	})

	-- nvim-autopairs
	use({
		"windwp/nvim-autopairs",
		commit = "ee297f215e95a60b01fde33275cc3c820eddeebe",
		config = function()
			require("nvim-autopairs").setup({})
		end,
	})

	use({
		"j-hui/fidget.nvim",
		tag = "v1.4.5",
		config = function()
			require("fidget").setup({})
		end,
	})

	use({
		"kylechui/nvim-surround",
		tag = "*", -- Use for stability; omit to use `main` branch for the latest features
		config = function()
			require("nvim-surround").setup({
				-- Configuration here, or leave empty to use defaults
			})
		end,
	})

	use({
		"folke/todo-comments.nvim",
		tag = "v1.4.0",
		requires = { "nvim-lua/plenary.nvim" },
		config = function()
			require("config/plugin/todo-comments_nvim")
		end,
	})

	use({
		"dstein64/vim-startuptime",
		tag = "v4.5.0",
	})

	-- create color code: color picker and highlighter (very useful in css)
	use({
		"uga-rosa/ccc.nvim",
		tag = "v2.0.3",
		config = function()
			require("config/plugin/ccc_nvim")
		end,
	})
	---------------------

	-- IDE --
	---------
	-- mason (third-party package manager)
	use({
		"williamboman/mason.nvim",
		tag = "*",
	})

	-- lsp
	use({
		"williamboman/mason-lspconfig.nvim",
		"neovim/nvim-lspconfig",
		requires = { "williamboman/mason.nvim" },
		tag = "*",
		-- config needs to be loaded for every buffer(?)
		-- config file: [~/.config/nvim/lua/lsp_setup.lua]
	})

	-- dap
	use({
		"jay-babu/mason-nvim-dap.nvim",
		tag = "*",
		requires = {
			"williamboman/mason.nvim",
			"mfussenegger/nvim-dap",
			"nvim-neotest/nvim-nio",
		},
		-- config file: [~/.config/nvim/lua/dap_setup.lua]
	})

	-- dap-ui
	use({
		"rcarriga/nvim-dap-ui",
		tag = "v4.0.0",
		requires = { "mfussenegger/nvim-dap" },
	})

	-- treesitter (parser)
	use({
		"nvim-treesitter/nvim-treesitter",
		config = function()
			require("config/plugin/nvim-treesitter")
		end,
	})

	-- formatter
	use({
		"mhartington/formatter.nvim",
		commit = "b0edd69cec589bb65930cb15ab58b7e61d9a7e70",
		config = function()
			require("config/plugin/formatter_nvim")
		end,
	})

	-- trouble
	use({
		"folke/trouble.nvim",
		tag = "*",
		config = function()
			require("config/plugin/trouble_nvim")
		end,
	})

	-- Comment.nvim (commenter)
	-- TODO: remove this plugin, this functionality has been added to neovim v0.10
	use({
		"numToStr/Comment.nvim",
		commit = "e30b7f2008e52442154b66f7c519bfd2f1e32acb",
		config = function()
			require("config/plugin/Comment_nvim")
		end,
	})

	-- neovim-tasks (cmake, cargo, or add a module yourself)
	-- NOTE: my fork is better suited for C++ workflow (CMake + Conan)
	use({
		-- "Shatur/neovim-tasks",   -- original repo
		"mrizaln/neovim-tasks", -- use my fork instead
		requires = {
			"mfussenegger/nvim-dap",
			"nvim-lua/plenary.nvim",
		},
		config = function()
			require("config/plugin/neovim-tasks")
		end,
	})

	-- use({           -- alternative for cmake
	--     "cdelledonne/vim-cmake",
	--  branch = "78-do-not-escape-paths",
	--     config = function()
	--         require("config/plugin/vim-cmake")
	--     end,
	-- })

	-- -- ultisnips (snippets engine)
	-- use({
	-- 	"SirVer/ultisnips",
	-- 	requires = { "honza/vim-snippets" },
	-- 	config = function()
	-- 		require("config/plugin/ultisnips")
	-- 	end,
	-- })

	use({
		"L3MON4D3/LuaSnip",
		-- follow latest release.
		tag = "v2.*",
		-- install jsregexp (optional!:).
		-- run = "make install_jsregexp"
		requires = {
			"honza/vim-snippets",
		},
		config = function()
			require("luasnip.loaders.from_snipmate").lazy_load()
			local ls = require("luasnip")
			vim.keymap.set({ "i", "s" }, "<C-L>", function()
				ls.jump(1)
			end, { silent = true })
			vim.keymap.set({ "i", "s" }, "<C-H>", function()
				ls.jump(-1)
			end, { silent = true })
		end,
	})

	-- nvim-cmp (completion)
	use({
		"hrsh7th/nvim-cmp",
		commit = "ae644feb7b67bf1ce4260c231d1d4300b19c6f30",
		requires = {
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-path",
			"hrsh7th/cmp-cmdline",

			-- snippet engine
			-- "SirVer/ultisnips",
			-- "quangnguyen30192/cmp-nvim-ultisnips",
			"L3MON4D3/LuaSnip",
			"saadparwaiz1/cmp_luasnip",
		},
		config = function()
			require("config/plugin/nvim-cmp")
		end,
	})

	-- lsp_signature (show function signature; better than [vim.lsp.buf.signature_help])
	use({
		"ray-x/lsp_signature.nvim",
		commit = "fc38521ea4d9ec8dbd4c2819ba8126cea743943b",
		-- no lazy loading
		-- config: [./config/plugin/lsp_signature_nvim]
	})

	-- better hover (for c++ at least)
	use({
		"Fildo7525/pretty_hover",
		tag = "*",
		config = function()
			require("pretty_hover").setup({})
		end,
	})

	-- code outline
	use({
		"stevearc/aerial.nvim",
		tag = "v2.4.0",
		config = function()
			require("config/plugin/aerial_nvim")
		end,
	})

	-- gitsigns.nvim
	use({
		"lewis6991/gitsigns.nvim",
		tag = "*",
		config = function()
			require("config/plugin/gitsigns_nvim")
		end,
	})

	-- git diff tool (diffview.nvim)
	use({
		"sindrets/diffview.nvim",
		commit = "4516612fe98ff56ae0415a259ff6361a89419b0a",
		requires = "nvim-lua/plenary.nvim",
	})

	-- coq (completion)
	--[[ use {
        'ms-jpq/coq_nvim',
        branch = 'coq',
        requires = { 'ms-jpq/coq.artifacts' },
        -- config = function() require("config/plugin/coq_nvim") end
    } --]]

	-- neogen (annotation, documentation)
	use({
		"danymat/neogen",
		tag = "*",
		config = function()
			require("neogen").setup({ snippet_engine = "luasnip" })
		end,
	})

	-- additional syntax highlight using vscode textmate plugin (slow though)
	use({
		"icedman/nvim-textmate",
		commit = "e2bb80a58a41234e5e81a28250bc583422c02157",
	})
	---------

	-- other --
	-----------
	-- discord rich presence
	-- use({
	-- 	"vyfor/cord.nvim",
	-- 	commit = "a26b00d58c42174aadf975917b49cec67650545f",
	-- 	run = "./build || .\\build",
	-- 	config = function()
	-- 		require("config/plugin/cord_nvim")
	-- 	end,
	-- })

	-- markdown preview
	use({
		"iamcco/markdown-preview.nvim",
		commit = "a923f5fc5ba36a3b17e289dc35dc17f66d0548ee",
		run = function()
			vim.fn["mkdp#util#install"]()
		end,
		config = function()
			require("config/plugin/markdown-preview_nvim")
		end,
	})

	-- csv file helper
	use({
		"mechatroner/rainbow_csv",
	})

	-- hex editor plugin
	-- use({
	-- 	"RaafatTurki/hex.nvim",
	-- 	config = function()
	-- 		require("hex").setup()
	-- 	end,
	-- })

	-- -- markdown previewer
	-- use({
	-- 	"ellisonleao/glow.nvim",
	-- 	config = function()
	-- 		require("glow").setup({
	-- 			-- glow_path = "",  -- auto if exist
	-- 			-- install_path = "~/.local/bin", -- default path for installing glow binary
	-- 			-- border = "shadow", -- floating window border config
	-- 			style = "dark",
	-- 			-- pager = false,
	-- 			width = 120,
	-- 			-- height = 100,
	-- 			-- width_ratio = 0.7, -- maximum width of the Glow window compared to the nvim window size (overrides `width`)
	-- 			-- height_ratio = 0.7,
	-- 		})
	-- 	end,
	-- })
	-----------
end)
