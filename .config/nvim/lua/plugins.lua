-- package (plugins)
require("packer").startup(function()
	use("wbthomason/packer.nvim")

	-- colorscheme
	use("tomasr/molokai")
	use("dracula/vim")
	use("arcticicestudio/nord-vim")
	use("sainnhe/sonokai")
	use("ray-x/aurora")

	-- quality of life --
	---------------------
	-- alpha (start screen)
	use({
		"goolord/alpha-nvim",
		requires = { "nvim-tree/nvim-web-devicons" },
		config = function()
			require("plugin-configs/alpha-nvim")
		end,
	})

	-- floaterm (floating terminal)
	use({
		"voldikss/vim-floaterm",
		config = function()
			require("plugin-configs/vim-floaterm")
		end,
	})

	-- nvim-tree (directory treeview)
	use({ -- nvim-tree requires nvim >= 0.8.0 --
		"nvim-tree/nvim-tree.lua",
		requires = { "nvim-tree/nvim-web-devicons" },
		config = function()
			require("plugin-configs/nvim-tree")
		end,
	})

	--[[ use {                           -- alternative to nvim-tree --
        'preservim/nerdtree',
        requires = { 'ryanoasis/vim-devicons' },
        config = function() require("plugin-configs/nerdtree") end
    } --]]

	-- telescope (similar to fzf?)
	use({
		"nvim-telescope/telescope.nvim",
		requires = { "nvim-lua/plenary.nvim" },
		config = function()
			require("plugin-configs/telescope_nvim")
		end,
	})

	-- barbar (tabbed bar)      [ makes nvim v0.7.2 segfault idk why ]
	use({
		"romgrk/barbar.nvim",
		wants = { "nvim-tree/nvim-web-devicons" },
		config = function()
			require("plugin-configs/barbar_nvim")
		end,
	})

	-- indent-blankline (indentation guide)
	use({
		"lukas-reineke/indent-blankline.nvim",
		config = function()
			require("plugin-configs/indent-blankline_nvim")
		end,
	})

	-- ts-rainbow (rainbow bracket colors)
	use({
		"p00f/nvim-ts-rainbow",
		config = function()
			require("plugin-configs/nvim-ts-rainbow")
		end,
	})
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
			require("plugin-configs/nvim-treesitter")
		end,
	})

	-- linter
	-- use {
	--     "mfussenegger/nvim-lint",
	--     config = function() require("plugin-configs/nvim-lint") end,
	-- }

	-- formatter
	use({
		"mhartington/formatter.nvim",
		-- don't lazy loading
		config = function()
			require("plugin-configs/formatter_nvim")
		end,
	})

	-- dap
	use({
		"mfussenegger/nvim-dap",
		config = function()
			require("plugin-configs/nvim-dap")
		end,
		-- per client config: [~/.config/nvim/lua/dap_setup.lua]
	})

	-- Comment.nvim (commenter)
	use({
		"numToStr/Comment.nvim",
		config = function()
			require("plugin-configs/Comment_nvim")
		end,
	})

	-- neovim-tasks
	use({
		"Shatur/neovim-tasks",
		requires = {
			"mfussenegger/nvim-dap",
			"nvim-lua/plenary.nvim",
		},
		config = function()
			require("plugin-configs/neovim-tasks")
		end,
	})

	-- ultisnips (snippets engine)
	use({
		"SirVer/ultisnips",
		requires = { "honza/vim-snippets" },
		config = function()
			require("plugin-configs/ultisnips")
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
			"quangnguyen30192/cmp-nvim-ultisnips", -- required by ultisnips
		},
		config = function()
			require("plugin-configs/nvim-cmp")
		end,
	})

	use({
		"ray-x/lsp_signature.nvim",
		-- no lazy loading
		-- config: [./plugin-configs/lsp_signature_nvim]
	})

	-- coq (completion)
	--[[ use {
        'ms-jpq/coq_nvim',
        branch = 'coq',
        requires = { 'ms-jpq/coq.artifacts' },
        -- config = function() require("plugin-configs/coq_nvim") end
    } --]]

	-- glsl
	use("tikhomirov/vim-glsl")
	---------
end)
