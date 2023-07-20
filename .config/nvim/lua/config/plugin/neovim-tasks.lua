local Path = require("plenary.path")
require("tasks").setup({
	default_params = {
		cmake = {
			cmd = "cmake",
			build_dir = tostring(Path:new("{cwd}", "build", "{build_type}")),
			build_type = "Debug",
			--dap_name = 'lldb', -- DAP configuration name from `require('dap').configurations`. If there is no such configuration, a new one with this name as `type` will be created.
			dap_name = "codelldb",
			args = {
				configure = { "-D", "CMAKE_EXPORT_COMPILE_COMMANDS=1", "-G", "Ninja" },
				build = { "-j", tonumber(vim.fn.system("nproc")) + 2 },
			},
		},
	},
	save_before_run = true, -- If true, all files will be saved before executing a task.
	params_file = "neovim.json", -- JSON file to store module and task parameters.
	quickfix = {
		pos = "botright", -- Default quickfix position.
		height = 12, -- Default height.
	},
	dap_open_command = function()
		return require("dap").repl.open()
	end, -- Command to run after starting DAP session. You can set it to `false` if you don't want to open anything or `require('dapui').open` if you are using https://github.com/rcarriga/nvim-dap-ui
})

-- keybindings
local opts = { noremap = true, silent = false }
vim.api.nvim_set_keymap("n", "<leader>cg", ":Task start auto configure<cr>", opts)
vim.api.nvim_set_keymap("n", "<leader>cb", ":Task start auto build<cr>", opts)
vim.api.nvim_set_keymap("n", "<leader>cc", ":Task start auto clean<cr>", opts)
vim.api.nvim_set_keymap("n", "<leader>cd", ":Task start auto debug<cr>", opts)
vim.api.nvim_set_keymap("n", "<leader>cr", ":Task start auto run<cr>", opts)
vim.api.nvim_set_keymap("n", "<leader>ct", ":Task set_module_param auto target<cr>", opts)
vim.api.nvim_set_keymap("n", "<leader>cT", ":Task set_module_param auto build_type<cr>", opts)
