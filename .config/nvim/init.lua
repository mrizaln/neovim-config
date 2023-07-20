-- nvim config

-- load utils
require("my_utils") -- must be first; some config use my_utils functionalities
-- _G.myUtils is available from this point

-- determine host OS
if vim.loop.os_uname().sysname ~= "Linux" then
	print("It appears that you are not using Linux as your system")
	print("The configuration is developed for use in Linux environment (Fedora)")
	print("It probably works for other Unix-based or Unix-like OS")
	print("Expect problems")
	return
end

-- expect nvim version
local expected_version = { major = 0, minor = 8, patch = 2 }
local nvim_version = vim.version() or { major = 0, minor = 0, patch = 0 }
if nvim_version.major < expected_version.major or nvim_version.minor < expected_version.minor then
	print("Not using the expected version!")
	print("Expect problems")
	print(
		"Expected Neovim version: "
			.. expected_version.major
			.. "."
			.. expected_version.minor
			.. "."
			.. expected_version.patch
	)
	print("Your Neovim version: " .. nvim_version.major .. "." .. nvim_version.minor .. "." .. nvim_version.patch)
end

-- load main configurations
require("options")
require("plugins")
require("colorscheme")

local should_skip_lsp = vim.api.nvim_eval([[get(g:, 'init_should_skip_lsp', v:false)]]) -- set this at startup using `nvim --cmd "let g:init_should_skip_lsp = <bool>"`
local is_diff = vim.opt.diff:get() -- check whether nvim run in diff mode

if not is_diff and not should_skip_lsp then
	require("lsp_setup")
	require("dap_setup")
end

require("keybindings") -- global keybinds
require("autocommands")

-- vim.api.nvim_set_keymap("i", "<a-space>", ':lua print("hello")', { silent = false })

--vim.cmd [[:COQnow -s]]
