-- configure the linters per file type

require('lint').linters_by_ft = {
  markdown = {'vale',},
  cpp = { 'codespell', },
}

-- then setyp autocommands (lua requires nvim 0.7)
vim.api.nvim_create_autocmd({ "BufWritePost" }, {
  callback = function()
    require("lint").try_lint()
  end,
})
