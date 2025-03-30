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
        [1] = {
          { "c", "h", "cpp", "hpp", "js", "ts" },
          "v",
          "fd",
          "<Esc>o// clang-format on<Esc>gvO<Esc>O// clang-format off<Esc>gvO",
          { noremap = true },
        },
        [2] = {
          { "cpp" },
          "v",
          "\\c",
          "xistatic_cast<>()<esc>PF<a",
          { noremap = true, silent = true },
        },
        [3] = {
          { "c", "cpp" },
          "v",
          "\\C",
          "xi()<esc>p`[<left>i",
          { noremap = true, silent = true },
        },
        [4] = {
          { "cpp" },
          "v",
          "\\m",
          "xistd::move()<esc>Pw",
          { noremap = true, silent = true },
        },
        [5] = {
          { "cpp" },
          "v",
          "\\f",
          "xistd::forward<>()<esc>P`[2<left>i",
          { noremap = true, silent = true },
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
      formatters_by_ft = {
        cpp = { "clang-format" },
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

            local shell_escapes = " \t\n\\\"'`$()<>;&|*?[#~=%"
            return { "-style=file:" .. vim.fn.escape(style_file, shell_escapes) }
          end,
        },
      },
    },
  },

  {
    "saghen/blink.cmp",
    opts = {
      completion = {
        ghost_text = {
          enabled = false,
        },
      },
      keymap = {
        preset = "none",

        ["<Tab>"] = { "select_next", "fallback" },
        ["<S-Tab>"] = { "select_prev", "fallback" },

        ["<cr>"] = { "select_and_accept", "fallback" },

        ["<C-n>"] = { "snippet_forward", "fallback" },
        ["<C-p>"] = { "snippet_backward", "fallback" },

        ["<Right>"] = { "select_next", "fallback" },
        ["<Left>"] = { "select_prev", "fallback" },

        ["<C-y>"] = { "select_and_accept" },
        ["<C-e>"] = { "cancel" },
      },
    },
  },
}
