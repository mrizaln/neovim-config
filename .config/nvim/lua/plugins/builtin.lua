return {
  {
    "folke/snacks.nvim",
    opts = {
      picker = {
        sources = {
          explorer = {
            win = {
              list = {
                keys = {
                  ["o"] = "confirm",
                  ["x"] = "explorer_open",
                  ["O"] = { { "pick_win", "jump" }, mode = { "n", "i" } },
                },
              },
            },
          },
        },
      },
    },
    keys = {
      {
        "<c-\\>",
        function()
          Snacks.terminal(nil, { cwd = LazyVim.root() })
        end,
        mode = "n",
        desc = "Open temrinal",
      },
      {
        "<c-\\>",
        "<cmd>close<cr>",
        mode = "t",
        desc = "Hide terminal",
      },
    },
  },

  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      opts.inlay_hints = { enabled = false }
      opts.servers = {
        clangd = {
          mason = false,
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
        },

        rust_analyzer = {
          mason = false,
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
                command = "clippy", -- enable clippy
              },
            },
          },
        },
      }

      local filetype_specific_keybinds = {
        {
          { "c", "h", "cpp", "hpp", "js", "ts" },
          "v",
          "fd",
          "<Esc>`<O// clang-format on<Esc>`>o// clang-format off<Esc>`<",
          { noremap = true, desc = "Add formatting guard" },
        },
        {
          { "c", "h", "cpp", "hpp", "js", "ts" },
          "v",
          "ff",
          ":s? *// clang-format \\(on\\|off\\)\\n?<cr>:nohlsearch<cr><esc>",
          { noremap = true, silent = true, desc = "Remove formatting guard" },
        },
        {
          { "cpp" },
          "v",
          "\\\\c",
          "xistatic_cast<>()<esc>P`[2<left>i",
          { noremap = true, desc = "Static cast" },
        },
        {
          { "c", "cpp" },
          "v",
          "\\\\C",
          "xi()()<esc>P`[2<left>i",
          { noremap = true, desc = "C-style cast" },
        },
        {
          { "cpp" },
          "v",
          "\\\\m",
          "xistd::move()<esc>P<right>",
          { noremap = true, desc = "std::move highlighted text" },
        },
        {
          { "cpp" },
          "v",
          "\\\\f",
          "xistd::forward<>()<esc>P`[2<left>i",
          { noremap = true, desc = "std::forward highlighted text" },
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

      return opts
    end,
  },

  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      highlight = {
        enable = true,
      },
      indent = {
        enable = true,
        disable = { "c", "cpp" },
      },
      ensure_installed = {
        "bash",
        "c",
        "cmake",
        "cpp",
        "glsl",
        "java",
        "javascript",
        "kotlin",
        "lua",
        "python",
        "rust",
        "sql",
        "typescript",
        "vim",
      },
    },
  },

  {
    "stevearc/conform.nvim",
    opts = {
      default_format_opts = {
        timeout_ms = 1000,
        async = true, -- lazyvim is not recommending to set this to true
      },
      formatters_by_ft = {
        cpp = { "clang-format" },
        markdown = { "prettier" },
      },
      formatters = {
        ["clang-format"] = {
          prepend_args = function(bufnr)
            local style_file = nil
            local file_exist = vim.g.my_utils.file_exist

            -- project mode, check current buffer
            local workspaces = vim.lsp.buf.list_workspace_folders()
            if #workspaces >= 1 then
              if file_exist(workspaces[1] .. "/_clang-format") then
                style_file = workspaces[1] .. "/_clang-format"
              elseif file_exist(workspaces[1] .. "/.clang-format") then
                style_file = workspaces[1] .. "/.clang-format"
              end
            end

            -- single file mode usually returns 0 #workspaces
            if style_file == nil then
              if file_exist(os.getenv("HOME") .. "/.config/nvim/_clang-format") then
                style_file = os.getenv("HOME") .. "/.config/nvim/_clang-format"
              elseif file_exist(os.getenv("HOME") .. "/.config/nvim/.clang-format") then
                style_file = os.getenv("HOME") .. "/.config/nvim/.clang-format"
              else
                print("No clang-format configuration found, use defaults")
                print(
                  "Nvim global clang-format configuration usually here: "
                    .. os.getenv("HOME")
                    .. "/.config/nvim/_clang-format"
                )
                return {}
              end
            end

            --local shell_escapes = " \t\n\\\"'`$()<>;&|*?[#~=%"
            --return { "-style=file:" .. vim.fn.escape(style_file, shell_escapes) }
            return { "-style=file:" .. style_file }
          end,
        },
      },
    },
  },

  {
    "hrsh7th/nvim-cmp",
    opts = function(_, opts)
      local cmp = require("cmp")
      local auto_select = false

      opts.completion = {
        completeopt = "menu,menuone,noinsert" .. (auto_select and "" or ",noselect"),
      }
      opts.mapping = cmp.mapping.preset.insert({
        ["<C-b>"] = cmp.mapping.scroll_docs(-4),
        ["<C-f>"] = cmp.mapping.scroll_docs(4),
        ["<C-Space>"] = cmp.mapping.complete(),
        ["<C-e>"] = cmp.mapping.abort(),
        ["<cr>"] = cmp.mapping.confirm({ select = false }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
        ["<tab>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior, count = 1 }),
        ["<S-tab>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior, count = 1 }),
        ["<C-n>"] = function(fallback)
          return LazyVim.cmp.map({ "snippet_forward" }, fallback)()
        end,
        ["<C-p>"] = function(fallback)
          return LazyVim.cmp.map({ "snippet_backward" }, fallback)()
        end,
        ["<a-space>"] = function(fallback)
          return LazyVim.cmp.map({ "ai_accept", "snippet_forward" }, fallback)()
        end,
      })
      opts.sorting = {
        comparators = {
          cmp.config.compare.offset,
          cmp.config.compare.score,
          -- cmp.config.compare.exact,
          -- cmp.config.compare.kind,
          -- cmp.config.compare.sort_text,
          -- cmp.config.compare.length,
          -- cmp.config.compare.order,
        },
      }
    end,
  },

  {
    "akinsho/bufferline.nvim",
    keys = {
      -- move to prev/next buffer
      { "<A-.>", "<cmd>BufferLineCycleNext<cr>", "n", desc = "Go to the next buffer" },
      { "<A-,>", "<cmd>BufferLineCyclePrev<cr>", "n", desc = "Go to the previous buffer" },
      { "<C-PageDown>", "<cmd>BufferLineCycleNext<cr>", "n", desc = "Go to the next buffer" },
      { "<C-PageUp>", "<cmd>BufferLineCyclePrev<cr>", "n", desc = "Go to the previous buffer" },
      -- move current buffer backwards/forwards
      { "<A->>", "<cmd>BufferLineMoveNext<cr>", "n", desc = "Move current buffer to the next" },
      { "<A-<>", "<cmd>BufferLineMovePrev<cr>", "n", desc = "Move current buffer to the previous" },
      { "<C-S-PageDown>", "<cmd>BufferLineMoveNext<cr>", "n", desc = "Move current buffer to the next" },
      { "<C-S-PageUp>", "<cmd>BufferLineMovePrev<cr>", "n", desc = "Move current buffer to the previous" },
    },
  },
}
