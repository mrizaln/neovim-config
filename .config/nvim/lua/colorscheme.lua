-- color scheme
-----------------
-- if os.getenv("DISPLAY") == nil then
-- 	print("Color Scheme is disabled since no DISPLAY is found")
-- 	print("DISPLAY: nil")
-- 	vim.opt.termguicolors = false
-- 	vim.cmd([[ colorscheme ron ]])
-- 	return
-- end

--vim.cmd [[colorscheme molokai]]
--vim.cmd [[let g:molokai_original = 1]]
--vim.cmd [[let g:rehash256 = 1]]

--vim.cmd [[colorscheme dracula]]

--vim.cmd [[colorscheme evening]]

--vim.cmd [[colorscheme nord]]

--[ sonokai ]--
-----------------
-- vim.cmd([[let g:sonokai_style = 'atlantis' "atlantis/andromeda/shusia/maia]])
-- vim.cmd([[colorscheme sonokai]])
-----------------

--[ aurora ]--
-----------------
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
-----------------

--[ gruvbox ]--
-- vim.o.background = "dark" -- or "light" for light mode
-- vim.cmd([[colorscheme gruvbox]])
-----------------

-- vim.cmd([[colorscheme rose-pine]])

--[ tokyonight ]--
------------------
-- vim.cmd([[colorscheme tokyonight]])
-- vim.cmd([[colorscheme tokyonight-night]])
-- vim.cmd([[colorscheme tokyonight-day]])
-- vim.cmd([[colorscheme tokyonight-storm]])
vim.cmd([[colorscheme tokyonight-moon]])
------------------

--[ onedark ]--
---------------
-- local styles = {"dark", "darker", "cool", "deep", "warm", "warmer" }
-- require("onedark").setup({
-- 	style = "darker",
-- })
-- require("onedark").load()
-- vim.cmd([[colorscheme onedark]])
---------------
