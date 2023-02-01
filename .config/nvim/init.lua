-- nvim config

-- load utils
require("my_utils")         -- must be first; some config use my_utils functionalities
                            -- _G.myUtils will be available

-- determine host OS
if vim.loop.os_uname().sysname ~= "Linux" then
	print("It appears that you are not using Linux as your system\n")
    print("The configuration is compatible only on UNIX-based or UNIX-like system")
    return
end

local expected_version = { major = 0, minor = 8, patch = 2 }
local nvim_version = vim.version() or {major=0, minor=0, patch=0}
if nvim_version.major < expected_version.major or nvim_version.minor < expected_version.minor then
    print("Not using the expected version!")
    print("Expect problems")
    print("Expected Neovim version: "..expected_version.major..'.'..expected_version.minor..'.'..expected_version.patch)
end
print("Your Neovim version: "..nvim_version.major..'.'..nvim_version.minor..'.'..nvim_version.patch)

-- print("DISPLAY: "..tostring(os.getenv("DISPLAY")))

require("options")
require("colorscheme")
require("keybindings")      -- global keybinds
require("autocommands")
require("plugins")
require("lsp_setup")
require("dap_setup")

--vim.cmd [[:COQnow -s]]
