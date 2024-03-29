-------------------------------[ version 2 ]------------------------------------
-- vim.opt.list = true
-- -- vim.opt.listchars:append "space:⋅"
-- -- vim.opt.listchars:append "eol:↴"
-- vim.opt.termguicolors = true
-- -- vim.cmd [[let  g:indent_blankline_char = "⎸"]]       -- U+23B8 left vertical box line

-- vim.cmd([[highlight IndentBlanklineContextChar guifg=#C678DD gui=nocombine]])

-- require("indent_blankline").setup({
-- 	space_char_blankline = " ",
-- 	show_current_context = true,
-- 	show_current_context_start = true,
-- 	use_treesitter_scope = true,
-- })

-- vim.cmd([[
-- function! s:IndentBlanklineLinecount()
--     if nvim_buf_line_count(0) < 5000
--         IndentBlanklineRefresh
--     endif
-- endfunction

-- augroup IndentBlanklineAutogroup
--     autocmd!
--     autocmd OptionSet shiftwidth,tabstop IndentBlanklineRefresh
--     autocmd FileChangedShellPost,Syntax * IndentBlanklineRefresh
--     autocmd TextChanged,TextChangedI * call s:IndentBlanklineLinecount()
-- augroup END
-- ]])
--------------------------------------------------------------------------------

require("ibl").setup({
	indent = { char = "▏" },
})
