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
	use({
		"folke/neodev.nvim",
		-- config: "~/.config/nvim/lua/config/plugin/neodev_nvim"
	})

	-- alpha (start screen)
	use({
		"goolord/alpha-nvim",
		requires = { "nvim-tree/nvim-web-devicons" },
		config = function()
			require("config/plugin/alpha-nvim")
		end,
	})

	-- floaterm (floating terminal)
	use({
		"voldikss/vim-floaterm",
		config = function()
			require("config/plugin/vim-floaterm")
		end,
	})

	-- nvim-tree (directory treeview)
	use({ -- nvim-tree requires nvim >= 0.8.0 --
		"nvim-tree/nvim-tree.lua",
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
		tag = "0.1.5",
		requires = { "nvim-lua/plenary.nvim" },
		config = function()
			require("config/plugin/telescope_nvim")
		end,
	})

	-- lualine.nvim (status line prettifier)
	use({
		"nvim-lualine/lualine.nvim",
		requires = { "kyazdani42/nvim-web-devicons", opt = true },
		config = function()
			require("config/plugin/lualine_nvim")
		end,
	})

	-- barbar (tabbed bar)      [ makes nvim v0.7.2 segfault idk why ]
	use({
		"romgrk/barbar.nvim",
		wants = { "nvim-tree/nvim-web-devicons" },
		config = function()
			require("config/plugin/barbar_nvim")
		end,
	})

	-- -- indent-blankline (indentation guide)
	-- use({
	-- 	"lukas-reineke/indent-blankline.nvim",
	-- 	config = function()
	-- 		require("config/plugin/indent-blankline_nvim")
	-- 	end,
	-- })

	-- -- ts-rainbow (rainbow bracket colors)
	-- use({
	-- 	"p00f/nvim-ts-rainbow",
	-- 	config = function()
	-- 		require("config/plugin/nvim-ts-rainbow")
	-- 	end,
	-- })

	-- rainbow parens
	use({
		"https://gitlab.com/HiPhish/rainbow-delimiters.nvim.git",
	})

	-- nvim-autopairs
	use({
		"windwp/nvim-autopairs",
		config = function()
			require("nvim-autopairs").setup({})
		end,
	})

	use({
		"j-hui/fidget.nvim",
		tag = "v1.2.0",
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
		requires = { "nvim-lua/plenary.nvim" },
		config = function()
			require("config/plugin/todo-comments_nvim")
		end,
	})

	use({
		"dstein64/vim-startuptime",
	})
	---------------------

	-- IDE --
	---------
	-- mason (third-party package manager)
	use("williamboman/mason.nvim")

	-- lsp
	use({
		"williamboman/mason-lspconfig.nvim",
		"neovim/nvim-lspconfig",
		requires = { "williamboman/mason.nvim" },
		-- config needs to be loaded for every buffer(?)
		-- config file: [~/.config/nvim/lua/lsp_setup.lua]
	})

	-- dap
	use({
		"jay-babu/mason-nvim-dap.nvim",
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
		-- don't lazy loading (actually lazy loading is enough)
		config = function()
			require("config/plugin/formatter_nvim")
		end,
	})

	-- trouble
	use({
		"folke/trouble.nvim",
		config = function()
			require("config/plugin/trouble_nvim")
		end,
	})

	-- Comment.nvim (commenter)
	use({
		"numToStr/Comment.nvim",
		config = function()
			require("config/plugin/Comment_nvim")
		end,
	})

	-- neovim-tasks (cmake, cargo, or add a module yourself)
	use({
		-- "Shatur/neovim-tasks",
		"mrizaln/neovim-tasks", -- use my forks instead
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
			vim.keymap.set({ "i", "s" }, "<C-J>", function()
				ls.jump(-1)
			end, { silent = true })
		end,
	})

	-- nvim-cmp (completion)
	use({
		"hrsh7th/nvim-cmp",
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
		-- no lazy loading
		-- config: [./config/plugin/lsp_signature_nvim]
	})

	-- better hover (by rendering the markdown on the hover doc)
	-- use({
	-- 	"JASONews/glow-hover",
	-- 	config = function()
	-- 		require("glow-hover").setup({
	-- 			max_width = 100,
	-- 			padding = 5,
	-- 			border = "shadow",
	-- 			-- glow_path = "glow",
	-- 			glow_path = "/home/mrizaln/Apps/src/glow/glow",
	-- 		})
	-- 	end,
	-- })

	-- better hover (for c++ at least)
	use({
		"Fildo7525/pretty_hover",
		config = function()
			require("pretty_hover").setup({})
		end,
	})

	-- symbols-outline
	use({
		"simrat39/symbols-outline.nvim",
		config = function()
			require("config/plugin/symbols-outline_nvim")
		end,
	})

	-- vim-fugitive (git integration)
	-- use({
	-- 	"tpope/vim-fugitive",
	-- })

	-- gitsigns.nvim
	use({
		"lewis6991/gitsigns.nvim",
		config = function()
			require("config/plugin/gitsigns_nvim")
		end,
	})

	-- git diff tool (diffview.nvim)
	use({
		"sindrets/diffview.nvim",
		requires = "nvim-lua/plenary.nvim",
	})

	-- coq (completion)
	--[[ use {
        'ms-jpq/coq_nvim',
        branch = 'coq',
        requires = { 'ms-jpq/coq.artifacts' },
        -- config = function() require("config/plugin/coq_nvim") end
    } --]]

	-- additional syntax highlight using vscode textmate plugin (slow though)
	use({ "icedman/nvim-textmate" })
	---------

	-- other --
	-----------
	use({
		"iamcco/markdown-preview.nvim",
		run = function()
			vim.fn["mkdp#util#install"]()
		end,
		config = function()
			require("config/plugin/markdown-preview_nvim")
		end,
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
