-- core (dap and dapui) --
--
local dap, dapui = require("dap"), require("dapui")
dapui.setup()

dap.listeners.after.event_initialized["dapui_config"] = function()
	dapui.open()
end
dap.listeners.before.event_terminated["dapui_config"] = function()
	dapui.close()
end
dap.listeners.before.event_exited["dapui_config"] = function()
	dapui.close()
end

-- keybindings --
--
local keymap = vim.keymap.set

local opts = { remap = true, silent = true }

keymap("n", "<F5>", require("dap").continue, opts)
keymap("n", "<F10>", require("dap").step_over, opts)
keymap("n", "<F11>", require("dap").step_into, opts)
keymap("n", "<F12>", require("dap").step_out, opts)
keymap("n", "<leader>b", require("dap").toggle_breakpoint, opts)
keymap("n", "<leader>B", function()
	require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))
end, opts)
keymap("n", "<leader>lp", function()
	require("dap").set_breakpoint(nil, nil, vim.fn.input("Long point message"))
end, opts)
keymap("n", "<leader>dr", require("dap").repl.open, opts)
keymap("n", "<leader>dl", require("dap").run_last, opts)

-- Debug Adapter Protocol configurations --
--
require("mason-nvim-dap").setup({
	handlers = {}, -- sets up dap in the predefined manner
})

-- C/C++/Rust (using codelldb)
require("config/dap/server-config/codelldb")
