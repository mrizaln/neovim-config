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

local options = { noremap = true, silent = true }

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

-- close quickfix
nkeymap("<leader>cq", ":ccl<cr>", options)

-- reload config
nkeymap(
	"<leader>rr",
	'<cmd>source ~/.config/nvim/init.lua <bar> lua print("config reloaded " .. os.date("(%d/%m/%Y %H:%M:%S)"))<cr>',
	{}
)

-- center view
ikeymap("<c-z>", "<esc>zza", options)

-- ctrl+backspace and ctlr+delete
vim.api.nvim_set_keymap("i", "<c-BS>", "<c-w>", options)
vim.api.nvim_set_keymap("i", "<c-Del>", "<cmd>norm! dw<cr>", options)

-- yank then search
vkeymap("/", 'y/<c-r>"<cr>N', { noremap = true })

-- search and replace currently selected text
vkeymap(
	"<leader>r",
	[[ygv*N<esc>:%s/\zs<C-R>=escape(@",'/\')<CR>\ze/<C-R>=escape('', '/')<CR>/g<Left><Left>]],
	{ noremap = true }
)
vkeymap(
	"<leader>i",
	[[ygv*N<esc>:%s/\ze<C-R>=escape(@",'/\')<CR>/<C-R>=escape('', '/')<CR>/g<Left><Left>]],
	{ noremap = true }
)
vkeymap(
	"<leader>a",
	[[ygv*N<esc>:%s/<C-R>=escape(@",'/\')<CR>\zs/<C-R>=escape('', '/')<CR>/g<Left><Left>]],
	{ noremap = true }
)

-- o and O now create newline without going into insert mode
-- vim.cmd([[nnoremap o o<Esc>]])
-- vim.cmd([[nnoremap O O<Esc>]])

--
-- lsp keybindings       : [~/.config/nvim/lua/config/lsp/keybindings.lua]
-- per plugin keybindings: [~/.config/nvim/lua/plugins.lua] inside their own [config] field
