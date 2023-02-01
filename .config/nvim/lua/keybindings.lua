-- aliases
-- vim.api.nvim_set_keymap({mode}, {keymap}, {mapped to}, {options})
local function nkeymap(key, map, opts)
	opts = opts or {}
	vim.api.nvim_set_keymap("n", key, map, opts)
end
local function ikeymap(key, map, opts)
	opts = opts or {}
	vim.api.nvim_set_keymap("i", key, map, opts)
end
local function vkeymap(key, map, opts)
	opts = opts or {}
	vim.api.nvim_set_keymap("v", key, map, opts)
end

-- save on ctrl+s
vim.api.nvim_set_keymap("n", "<c-s>", ":w<cr>", {})
vim.api.nvim_set_keymap("i", "<c-s>", "<esc>:w<cr>a", {})
vim.api.nvim_set_keymap("v", "<c-s>", "<esc>:w<cr>gv", {})

local options = { noremap = true }

-- move line or visually selected block
ikeymap("<A-j>", "<Esc>:m .+1<cr>==gi", options)
ikeymap("<A-k>", "<Esc>:m .-2<cr>==gi", options)
vkeymap("<A-j>", ":m '>+1<cr>gv=gv", options)
vkeymap("<A-k>", ":m '<-2<cr>gv=gv", options)

-- move between pane
nkeymap("<c-j>", "<c-w>j", options)
nkeymap("<c-h>", "<c-w>h", options)
nkeymap("<c-k>", "<c-w>k", options)
nkeymap("<c-l>", "<c-w>l", options)

-- move split panes
nkeymap("<A-h>", "<c-w>H", options)
nkeymap("<A-j>", "<c-w>J", options)
nkeymap("<A-k>", "<c-w>K", options)
nkeymap("<A-l>", "<c-w>L", options)

--
-- lsp keybindings       : [~/.config/nvim/lua/config/lsp/keybindings.lua]
-- per plugin keybindings: [~/.config/nvim/lua/plugins.lua] inside their own [config] field
