-- keybinds
local keymap = vim.keymap.set

local opts = { remap = true, silent = true }

keymap("n", "<F5>", require("dap").continue, opts)
keymap("n", "<F10>", require("dap").step_over, opts)
keymap("n", "<F11>", require("dap").step_into, opts)
keymap("n", "<F12>", require("dap").step_out, opts)
keymap("n", "<leader>b", require("dap").toggle_breakpoint, opts)
keymap("n", "<leader>B", function() require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: ")) end, opts)
keymap("n", "<leader>lp", function() require("dap").set_breakpoint(nil, nil, vim.fn.input("Long point message")) end, opts)
keymap("n", "<leader>dr", require("dap").repl.open, opts)
keymap("n", "<leader>dl", require("dap").run_last, opts)
