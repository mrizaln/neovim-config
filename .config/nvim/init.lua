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
end
print("Your Neovim version: " .. nvim_version.major .. "." .. nvim_version.minor .. "." .. nvim_version.patch)

-- print("DISPLAY: "..tostring(os.getenv("DISPLAY")))

-- load main configurations
require("options")
require("colorscheme")
require("keybindings") -- global keybinds
require("autocommands")
require("plugins")
require("lsp_setup")
require("dap_setup")

--vim.cmd [[:COQnow -s]]

-- open nvim-tree at startup
local function open_nvim_tree(data)
	-- buffer is a real file on the disk
	local real_file = vim.fn.filereadable(data.file) == 1

	-- buffer is a [No Name]
	local no_name = data.file == "" and vim.bo[data.buf].buftype == ""

	if not real_file and no_name then
		-- vim.cmd([[wincmd l]])
		vim.cmd([[Alpha]])
		require("nvim-tree.api").tree.toggle({ focus = false, find_file = false })
		return
	end

	-- open the tree, find the file but don't focus it
	require("nvim-tree.api").tree.toggle({ focus = false, find_file = false })
    -- vim.cmd([[SymbolsOutline]])     -- open symbols outline on the right (will focus window)
    -- vim.cmd([[winc h]])             -- immediately go back to left
	-- vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(":SymbolsOutline<cr><cr>", true, false, true), "n", true)
end
vim.api.nvim_create_autocmd({ "VimEnter" }, { callback = open_nvim_tree })
