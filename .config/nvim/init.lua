-- nvim config

-- load utils
require("my_utils") -- must be first; some config use my_utils functionalities
-- _G.my_utils is available from this point

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

-- check if file is too large
local max_filesize = 10000 * 1024 -- 10 MB
local current_bufnr = vim.api.nvim_get_current_buf()
local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(current_bufnr))
if ok and stats and stats.size > max_filesize then
	print("Warning!\nFile is too large! (" .. math.floor(stats.size / 1024) .. " KiB)")
	local response_ok, response = pcall(vim.fn.input, { prompt = "Proceed anyways? [y/N] ", cancelreturn = "N" })
	if not response_ok then
		os.exit(1)
	elseif response:match("[Yy]") then
		print("\nNeovim will proceed to open file")
	else
		os.exit(1)
	end
	vim.cmd([[
        set foldmethod=manual
        syntax clear
        syntax off
        filetype off
        set noundofile
        set noswapfile
        set noloadplugins
        " set nowrap
    ]])
	require("keybindings") -- global keybinds
	require("colorscheme")
else
	require("options")
	require("keybindings") -- global keybinds
	require("colorscheme")

	local minimal = vim.api.nvim_eval([[get(g:, 'init_minimal', v:false)]]) -- set this at startup using `nvim --cmd "let g:init_minimal = <bool>"`
	if minimal then
		print("Opening in minimal mode")
		require("lsp_setup") -- load at least lsp
	end
	local is_diff = vim.opt.diff:get() -- check whether nvim run in diff mode

	if not is_diff and not minimal then
		require("plugins")
		require("lsp_setup")
		require("dap_setup")
		require("buf_setup")
		require("commands")
		require("autocommands")
	end

	-- vim.api.nvim_set_keymap("i", "<a-space>", ':lua print("hello")', { silent = false })

	--vim.cmd [[:COQnow -s]]
end
