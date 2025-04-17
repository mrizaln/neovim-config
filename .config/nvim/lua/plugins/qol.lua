return {
  -- -- copilot
  -- {
  --   "zbirenbaum/copilot.lua",
  --   cmd = "Copilot",
  --   build = ":Copilot auth",
  --   event = "BufReadPost",
  --   opts = {
  --     suggestion = {
  --       enabled = true,
  --       auto_trigger = true,
  --       hide_during_completion = true,
  --       keymap = {
  --         accept = "<a-space>",
  --         next = "<M-]>",
  --         prev = "<M-[>",
  --       },
  --     },
  --     panel = { enabled = false },
  --     filetypes = {
  --       markdown = true,
  --       help = true,
  --     },
  --   },
  -- },

  -- nvim surround
  {
    "kylechui/nvim-surround",
    version = "3.1.x", -- Use for stability; omit to use `main` branch for the latest features
    event = "BufReadPost",
    config = function()
      require("nvim-surround").setup({
        -- Configuration here, or leave empty to use defaults
      })
    end,
  },

  -- Comment.nvim (commenter)
  -- NOTE: this functionality has been added to neovim v0.10, but nvim can't block comment
  {
    "numToStr/Comment.nvim",
    event = "BufReadPost",
    commit = "e30b7f2008e52442154b66f7c519bfd2f1e32acb",
    opts = {
      padding = true,
      sticky = true,
      ignore = "^$", -- empty lines

      ---LHS of toggle mappings in NORMAL mode
      toggler = {
        line = "gcc",
        block = "gbc",
      },

      ---LHS of operator-pending mappings in NORMAL and VISUAL mode
      opleader = {
        line = "gc",
        block = "gb",
      },

      ---LHS of extra mappings
      extra = {
        above = "gcO",
        below = "gco",
        eol = "gcA",
      },

      ---Enable keybindings
      ---NOTE: If given `false` then the plugin won't create any mappings
      mappings = {
        basic = true,
        extra = true,
      },

      pre_hook = nil,

      post_hook = nil,
    },
    keys = {
      { "<c-/>", "<esc>gcc", mode = "i", remap = true, desc = "Toggle comment" },
      { "<c-_>", "<esc>gcc", mode = "i", remap = true, desc = "Toggle comment" },
      { "<c-/>", "gc", mode = "v", remap = true, desc = "Toggle comment (visual)" },
      { "<c-_>", "gc", mode = "v", remap = true, desc = "Toggle comment (visual)" },
      { "<c-/>", "gcc", mode = "n", remap = true, desc = "Toggle comment" },
      { "<c-_>", "gcc", mode = "n", remap = true, desc = "Toggle comment" },
    },
  },

  -- markdown preview (copied from lazyvim config :P)
  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    build = function()
      require("lazy").load({ plugins = { "markdown-preview.nvim" } })
      vim.fn["mkdp#util#install"]()
    end,
    keys = {
      {
        "<leader>cp",
        ft = "markdown",
        "<cmd>MarkdownPreviewToggle<cr>",
        desc = "Markdown Preview",
      },
    },
    config = function()
      vim.cmd([[do FileType]])
    end,
  },
}
