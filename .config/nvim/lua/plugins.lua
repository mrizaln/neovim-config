-- package (plugins)
require("packer").startup(function()
	use("wbthomason/packer.nvim")

	-- colorscheme --
	-----------------
	use("arcticicestudio/nord-vim")
	use("ellisonleao/gruvbox.nvim")
	use("folke/tokyonight.nvim")
	use("navarasu/onedark.nvim")
	use("ray-x/aurora")
	use("sainnhe/sonokai")
	use("tomasr/molokai")
	use({ "dracula/vim", as = "dracula-vim-theme" })
	use({ "challenger-deep-theme/vim", as = "challenger-deep-vim-theme" })
	use({
		"rose-pine/neovim",
		as = "rose-pine-vim-theme",
		-- config = function()
		--     require("config/plugin/rose-pine-vim-theme")
		-- end,
	})
	-----------------

	-- quality of life --
	---------------------
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

	-- indent-blankline (indentation guide)
	use({
		"lukas-reineke/indent-blankline.nvim",
		config = function()
			require("config/plugin/indent-blankline_nvim")
		end,
	})

	-- ts-rainbow (rainbow bracket colors)
	use({
		"p00f/nvim-ts-rainbow",
		config = function()
			require("config/plugin/nvim-ts-rainbow")
		end,
	})

	-- nvim-autopairs
	use({
		"windwp/nvim-autopairs",
		config = function()
			require("nvim-autopairs").setup({})
		end,
	})

	-- neoscroll.nvim (smooth scrolling)
	-- use({
	-- 	"karb94/neoscroll.nvim",
	-- 	config = function()
	-- 		require("config/plugin/neoscroll_nvim")
	-- 	end,
	-- })

	---------------------

	-- IDE --
	---------
	-- LSP manager
	use({
		"williamboman/mason.nvim",
		"williamboman/mason-lspconfig.nvim",
		"neovim/nvim-lspconfig",
		-- config needs to be loaded for every buffer(?)
		-- config file: [~/.config/nvim/lua/lsp_setup.lua]
	})

	-- treesitter (parser)
	use({
		"nvim-treesitter/nvim-treesitter",
		config = function()
			require("config/plugin/nvim-treesitter")
		end,
	})

	-- linter
	-- use {
	--     "mfussenegger/nvim-lint",
	--     config = function() require("config/plugin/nvim-lint") end,
	-- }

	-- formatter
	use({
		"mhartington/formatter.nvim",
		-- don't lazy loading (actually lazy loading is enough)
		config = function()
			require("config/plugin/formatter_nvim")
		end,
	})

	-- dap
	use({
		"mfussenegger/nvim-dap",
		-- config = function()
		--     require("config/plugin/nvim-dap")
		-- end,
		-- per client config: [~/.config/nvim/lua/dap_setup.lua]
	})

	-- dap-ui
	use({
		"rcarriga/nvim-dap-ui",
		requires = { "mfussenegger/nvim-dap" },
		-- config = function()
		--     require("config/plugin/nvim-dap-ui")
		-- end,
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
		"Shatur/neovim-tasks",
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

	-- ultisnips (snippets engine)
	use({
		"SirVer/ultisnips",
		requires = { "honza/vim-snippets" },
		config = function()
			require("config/plugin/ultisnips")
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
			"SirVer/ultisnips", -- required by nvim-cmp
			"quangnguyen30192/cmp-nvim-ultisnips", -- required by ultisnips on nvim-cmp
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
	---------

	-- other --
	-----------
	-- glsl
	use("tikhomirov/vim-glsl")

	use({
		"iamcco/markdown-preview.nvim",
		run = function()
			vim.fn["mkdp#util#install"]()
		end,
		config = function()
			require("config/plugin/markdown-preview_nvim")
		end,
	})
	-----------
end)
