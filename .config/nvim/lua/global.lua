--[[ three types of configuration options
--	global options (vim.o)			it seem vim.opt is recommended
--	local to window (vim.wo)
--	local to buffer (vim.bo)
--]]

vim.opt.expandtab = true            -- convert tab to spaces
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.mouse = 'a'
vim.opt.number = true
vim.opt.clipboard = 'unnamedplus'   -- use system clipboard
vim.opt.cursorline = true           -- highlight current line
vim.opt.ttyfast = true              -- speed up scrolling

vim.cmd [[set cc=80]]               -- 90 column border

-- folding
-- vim.opt.foldmethod = "expr"
-- vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
-- vim.opt.foldenable = false      -- Disable folding at startup.
vim.opt.foldmethod = "manual"


-- color scheme
-----------------
--vim.cmd [[colorscheme molokai]]
--vim.cmd [[let g:molokai_original = 1]]
--vim.cmd [[let g:rehash256 = 1]]

--vim.cmd [[colorscheme dracula]]

--vim.cmd [[colorscheme evening]]

--vim.cmd [[colorscheme nord]]

--[ sonokai ]--
vim.cmd [[colorscheme sonokai]]
vim.cmd [[let g:sonokai_style = 'shusia' "atlantis/andromeda/shusia/maia]]
--[]--

--[ aurora ]--
-- vim.cmd[[set termguicolors]]               -- 24 bit color
-- vim.cmd[[let g:aurora_italic = 1]]          -- italic
-- vim.cmd[[let g:aurora_transparent = 1]]     -- transparent
-- vim.cmd[[let g:aurora_bold = 1]]            -- bold
-- vim.cmd[[let g:aurora_darker = 1]]          -- darker background

-- vim.cmd[[colorscheme aurora]]

-- -- customize your own highlight
-- -- vim.cmd[[hi Normal guibg=NONE ctermbg=NONE]]        -- remove background
-- -- vim.cmd[[hi String guibg=#339922 ctermbg=NONE]]     -- remove background

-- -- customize your own highlight with lua
-- vim.api.nvim_set_hl(0, '@string', {fg='#59E343'})
-- vim.api.nvim_set_hl(0, '@field', {fg='#f93393'})
-- vim.api.nvim_set_hl(0, '@number', {fg='#e933e3'})
--[]--
-----------------

--
-- generate compile_commands.json everytine cmake called
vim.cmd[[let g:cmake_link_compile_commands = 1]]
