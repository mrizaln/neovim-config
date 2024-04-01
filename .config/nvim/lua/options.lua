--[[ three types of configuration options
--	global options (vim.o)			it seem vim.opt is recommended
--	local to window (vim.wo)
--	local to buffer (vim.bo)
--]]

-- title
vim.opt.title = true
vim.opt.titlelen = 32
vim.opt.titlestring = "%f-%y-%r"

vim.opt.mouse = "a"

vim.opt.tabstop = 4
vim.opt.shiftwidth = 0 -- match tabstop
vim.opt.softtabstop = 4
vim.opt.expandtab = true -- convert tab to spaces
vim.opt.showbreak = "↪"
vim.opt.wrap = false

vim.opt.list = true
vim.opt.listchars = [[leadmultispace:   ▕,tab:  ▕,trail:.,extends:…,precedes:…,nbsp:�]]

vim.opt.scrolloff = 10

vim.opt.number = true
-- vim.opt.relativenumber = true

vim.opt.clipboard = "unnamedplus" -- use system clipboard

vim.opt.cursorline = true -- highlight current line
vim.opt.ttyfast = true -- speed up scrolling
-- vim.opt.spell = true                -- enable spell check
vim.opt.spelloptions = "camel"

vim.opt.undofile = true -- persistent undo, even when file is closed then reopened

vim.opt.termguicolors = true

vim.opt.showmode = false

-- vim.opt.inccommand = nil

vim.cmd([[set cc=80,90,120]]) -- column border

--
vim.opt.updatetime = 400 -- vim-signify async

-- https://github.com/neovim/neovim/wiki/FAQ#how-to-change-cursor-color-in-the-terminal
-- vim.cmd([[
--     set guicursor=n-v-c:block-Cursor/lCursor,i-ci-ve:ver25-Cursor2/lCursor2,r-cr:hor20,o:hor20
-- ]])
--
------------[ folding ]------------
-- vim.opt.foldmethod = "expr"
-- vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
-- vim.opt.foldenable = false -- Disable folding at startup.
vim.opt.foldmethod = "manual"

-- generate compile_commands.json everytine cmake called
vim.cmd([[let g:cmake_link_compile_commands = 1]])
