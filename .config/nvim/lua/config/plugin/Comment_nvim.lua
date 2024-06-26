require("Comment").setup({
	padding = true, --Add a space b/w comment and the line
	sticky = true, --Whether the cursor should stay at its position
	ignore = "^$", -- empty line --Lines to be ignored while (un)comment

	---LHS of toggle mappings in NORMAL mode
	toggler = {
		---Line-comment toggle keymap
		line = "gcc",
		---Block-comment toggle keymap
		block = "gbc",
	},

	---LHS of operator-pending mappings in NORMAL and VISUAL mode
	opleader = {
		---Line-comment keymap
		line = "gc",
		---Block-comment keymap
		block = "gb",
	},

	---LHS of extra mappings
	extra = {
		---Add comment on the line above
		above = "gcO",
		---Add comment on the line below
		below = "gco",
		---Add comment at the end of line
		eol = "gcA",
	},

	---Enable keybindings
	---NOTE: If given `false` then the plugin won't create any mappings
	mappings = {
		---Operator-pending mapping; `gcc` `gbc` `gc[count]{motion}` `gb[count]{motion}`
		basic = true,
		---Extra mapping; `gco`, `gcO`, `gcA`
		extra = true,
	},

	---Function to call before (un)comment
	pre_hook = nil,

	---Function to call after (un)comment
	post_hook = nil,
})

--[[        [ basic mappings (enabled by default) ]
    --[ normal mode ]--
    `gcc` - Toggles the current line using linewise comment
    `gbc` - Toggles the current line using blockwise comment
    `[count]gcc` - Toggles the number of line given as a prefix-count using linewise
    `[count]gbc` - Toggles the number of line given as a prefix-count using blockwise
    `gc[count]{motion}` - (Op-pending) Toggles the region using linewise comment
    `gb[count]{motion}` - (Op-pending) Toggles the region using blockwise comment

    --[ visual mode ]--
    `gc` - Toggles the region using linewise comment
    `gb` - Toggles the region using blockwise comment


            [ extra mappings (enabled by default) ]
    --[ normal mode ]--
    `gco` - Insert comment to the next line and enters INSERT mode
    `gcO` - Insert comment to the previous line and enters INSERT mode
    `gcA` - Insert comment to end of the current line and enters INSERT mode

    --[ visual mode ]--
    `gc` - Toggles the region using linewise comment
    `gb` - Toggles the region using blockwise comment
--]]

--
--------------------------------------------------------------------------------
--[ keybindings ]--
--

-- comment      // see Comment.nvim plugin
vim.api.nvim_set_keymap("n", "<c-_>", "gcc", { noremap = false })
vim.api.nvim_set_keymap("i", "<c-_>", "<esc>gcc", { noremap = false })
vim.api.nvim_set_keymap("v", "<c-_>", "gc", { noremap = false })
vim.api.nvim_set_keymap("v", "<c-_>", "gc", { noremap = false })
