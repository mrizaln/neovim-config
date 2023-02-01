-- need to be loaded before lspconfig
require("config/plugin/neodev_nvim")


-- ui customization
require("config/lsp/ui")        -- global override
                                -- don't requrire() if you want to override per client

-- configure mason, mason-lspconfig, and lspconfig
require("config/lsp/core")

-- configure keybinds
require("config/lsp/keybindings")

-- lsp_signature setup
require("config/plugin/lsp_signature_nvim")
