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
-- vim.api.nvim_set_keymap("i", "<c-BS>", "<c-w>", options)    -- not working
ikeymap("<c-Del>", "<cmd>norm! dw<cr>", options)

-- override the default * to search without jump
-- see: https://stackoverflow.com/a/49944815
nkeymap("*", [[:let @/= '\<' . expand('<cword>') . '\>' <bar> set hls <cr>]], { noremap = true, silent = true })

-- yank then search (using s register) [ inspired by above ]
local search_s = [["sy:let @/= '\V' . escape(@s, '/\')<CR>:set hls<CR>]]
vkeymap("/", search_s, { noremap = true, silent = true })

-- yank then search but whole (using s register) [ inspired by above ]
local search_w = [["sy:let @/= '\V' . '\<' . escape(@s, '/\') . '\>'<CR>:set hls<CR>]]
vkeymap("?", search_w, { noremap = true, silent = true })

local function search_pattern(p, s)
	local function add_then_back(ss)
		local len = string.len(ss)
		local new_s = ss
		for _ = 1, len do
			new_s = new_s .. "<Left>"
		end
		return new_s
	end

	local prefix = p .. [[<esc>:%s/\V]]
	local suffix = add_then_back([[/g | noh | norm!``]])

	return prefix .. s .. suffix
end

local opt_v = { noremap = true }

-- search and replace currently selected text
-- replace currently highlighted text with new text
vkeymap("<leader>r", search_pattern(search_s, [[<c-r>=escape(@s,'/\')<cr>/]]), opt_v)

-- replace currently highlighted text with new text (whole word)
vkeymap("<leader>R", search_pattern(search_w, [[\<<c-r>=escape(@s,'/\')<cr>\>/]]), opt_v)

-- insert new text before currently highlighted text
vkeymap("<leader>i", search_pattern(search_s, [[\ze<c-r>=escape(@s,'/\')<cr>/]]), opt_v)

-- insert new text after currently highlighted text (whole word)
vkeymap("<leader>I", search_pattern(search_w, [[\ze\<<c-r>=escape(@s,'/\')<cr>\>/]]), opt_v)

-- append new text after currently highlighted text
vkeymap("<leader>a", search_pattern(search_s, [[<c-r>=escape(@s,'/\')<cr>\zs/]]), opt_v)

-- append new text after currently highlighted text (whole word)
vkeymap("<leader>A", search_pattern(search_w, [[\<<c-r>=escape(@s,'/\')<cr>\zs\>/]]), opt_v)

-- edit currently highlighted text
vkeymap(
	"<leader>e",
	search_pattern(search_s, [[<c-r>=escape(@s,'/\')<cr>/<c-r>=escape(@s,'/\')<cr>]]),
	{ noremap = true }
)

-- edit currently highlighted text (whole word)
vkeymap(
	"<leader>E",
	search_pattern(search_w, [[\<<c-r>=escape(@s,'/\')<cr>\>/<c-r>=escape(@s,'/\')<cr>]]),
	{ noremap = true }
)

-- o and O now create newline without going into insert mode
-- vim.cmd([[nnoremap o o<Esc>]])
-- vim.cmd([[nnoremap O O<Esc>]])

-- shift+enter on insert mode create newline without breaking current line
-- this keymap needs some configuration on the terminal emulator and/or the multiplexer
-- see: https://stackoverflow.com/a/42461580
ikeymap("<s-cr>", "<C-o>o", options)

--
-- lsp keybindings       : [~/.config/nvim/lua/config/lsp/keybindings.lua]
-- per plugin keybindings: [~/.config/nvim/lua/plugins.lua] inside their own [config] field
