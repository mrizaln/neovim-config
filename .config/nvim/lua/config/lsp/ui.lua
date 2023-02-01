-- https://github.com/neovim/nvim-lspconfig/wiki/UI-Customization

-- border
vim.cmd [[autocmd! ColorScheme * highlight NormalFloat guibg=#1f2335]]
vim.cmd [[autocmd! ColorScheme * highlight FloatBorder guifg=white guibg=#1f2335]]

local wait = '╭╮╯╰─│'
local border = {
      {"╭", "FloatBorder"},     -- upper left
      {"─", "FloatBorder"},     -- upper
      {"╮", "FloatBorder"},     -- upper right
      {"│", "FloatBorder"},     -- right
      {"╯", "FloatBorder"},     -- bottom right
      {"─", "FloatBorder"},     -- bottom
      {"╰", "FloatBorder"},     -- bottom left
      {"│", "FloatBorder"},     -- left
}

--[[ -- LSP settings (for overriding per client)
local handlers =  {
  ["textDocument/hover"] =  vim.lsp.with(vim.lsp.handlers.hover, {border = border}),
  ["textDocument/signatureHelp"] =  vim.lsp.with(vim.lsp.handlers.signature_help, {border = border }),
}

-- Do not forget to use the on_attach function
require 'lspconfig'.myserver.setup { handlers=handlers } ]]

-- To instead override globally
local orig_util_open_floating_preview = vim.lsp.util.open_floating_preview
function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
  opts = opts or {}
  opts.border = opts.border or border
  return orig_util_open_floating_preview(contents, syntax, opts, ...)
end

-- require 'lspconfig'.myservertwo.setup {}
