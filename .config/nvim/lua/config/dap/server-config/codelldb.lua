-- codelldb uses TCP for the DAP communication
-- that requires using the server type for the adapter definition. See :help dap-adapter.

local dap = require("dap")

------------------------------[[ Adapter Definition ]]------------------------------------
-- NOTE: the config for adapter has been handled by mason-nvim-dap

-- you need to launch codellbd manually using this configuration below
--[[----------------------------------------------------------------------
dap.adapters.codelldb = {
  type = 'server',
  host = '127.0.0.1',
  port = 13000 -- Use the port printed out or specified with `--port`
}
------------------------------------------------------------------------]]

-- -- use this if you install codelldb using mason.nvim
-- local executable_path = os.getenv("HOME") .. "/.local/share/nvim/mason/bin/codelldb"

-- -- launch automatically (codelldb >= v1.7.0)
-- dap.adapters.codelldb = {
-- 	type = "server",
-- 	port = "${port}",
-- 	executable = {
-- 		-- CHANGE THIS to your path!
-- 		command = executable_path,
-- 		args = { "--port", "${port}" },

-- 		-- On windows you may have to uncomment this:
-- 		-- detached = false,
-- 	},
-- }
------------------------------------------------------------------------------------------

---------------------------------[[ Configuration ]]--------------------------------------
-- [  codelldb manual:  https://github.com/vadimcn/vscode-lldb/blob/master/MANUAL.md  ] --
-- cpp
dap.configurations.cpp = {
	{
		name = "Launch file",
		type = "codelldb",
		request = "launch",
		program = function()
			local file_path = vim.fn.input("Path to exe: ", vim.fn.getcwd() .. "/", "file")
			print(string.format([[%s]], file_path))
			return string.format([[%s]], file_path)
		end,
		cwd = "${workspaceFolder}",
		stopOnEntry = false,
		args = function()
			local args_string = vim.fn.input("Arguments: ")
			return vim.split(args_string, " +")
		end,
		console = "integratedTerminal",
	},
}

-- c
dap.configurations.c = dap.configurations.cpp

-- rust
dap.configurations.rust = dap.configurations.cpp
------------------------------------------------------------------------------------------
