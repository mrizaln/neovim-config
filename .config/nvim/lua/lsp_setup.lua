-- the plugins setup needs to be in the following order:
--  1. mason.nvim
--  2. mason-lspconfig.nvim
--  3. setup servers via lspconfig

require("mason").setup({
    ui = {
        icons = {
            package_installed = "✓",
            package_pending = "➜",
            package_uninstalled = "✗"
        }
    }
})

require("mason-lspconfig").setup({
    ensure_installed = {
        "sumneko_lua",      -- lua
        "clangd",           -- C, C++
        "pyright",          -- python (type checker)
        "rust_analyzer",    -- rust
        "tsserver",         -- typescript, javascript
        "bashls",           -- bash
        "cmake",            -- cmake
    },
})

-- load nvim-cmp capabilites
local capabilites = require('cmp_nvim_lsp').default_capabilities()

-- for LSPs installed using Mason
require("mason-lspconfig").setup_handlers({
    --------------------[ default handler ]--------------------
    function (server_name) -- default handler (optional)
        require("lspconfig")[server_name].setup({
            capabilites = capabilites,
        })
    end,

    -----------------------[ overrides ]-----------------------
    -- lua
    ['sumneko_lua'] = function()
        require('lspconfig')['sumneko_lua'].setup({
            capabilities = require('cmp_nvim_lsp').default_capabilities(),
            settings = {
                Lua = {
                    diagnostics = {
                        globals = { 'vim', 'use', 'require' }
                    },
                --workspace = {
                    -- Make the server aware of Neovim runtime files
                --library = {[vim.fn.expand('$VIMRUNTIME/lua')] = true, [vim.fn.expand('$VIMRUNTIME/lua/vim/lsp')] = true}
            --}
                }
            }
        })
    end,

    -- rust
    ['rust_analyzer'] = function()
        require('lspconfig')['rust_analyzer'].setup({
            capabilities = require('cmp_nvim_lsp').default_capabilities(),
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
                        enable = true
                    },
                }
            }
        })
    end,
})


--------------------[ others ]--------------------
-- glslls       -- not working (use this: 'tikhomirov/vim-glsl' for now
--[[ require("lspconfig")["glslls"].setup({
    cmd = { "/home/mrizaln/Git/glsl-language-server/build/glslls", '--stdin' },
    filetypes = { 'glsl', 'vert', 'tesc', 'tese', 'geom', 'frag', 'comp', 'vs', 'fs' },
    -- filetypes = { 'glsl' },
    root_dir = require('lspconfig.util').find_git_ancestor,
    -- root_dir = require('lspconfig.util').root_pattern('compile_commands.json', '.git'),
    single_file_support = true,
    capabilities = {
      textDocument = {
        completion = {
          editsNearCursor = true,
        },
      },
      offsetEncoding = { 'utf-8', 'utf-16' },
    },
}) --]]
