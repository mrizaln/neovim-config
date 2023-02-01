-- Utilities for creating configurations
local util = require("formatter.util")

-- local clangformat = require("formatter.defaults.clangformat")    -- default

-- use project specific format if [.clang-format] of [_clang-format] is available
-- else use [$HOME/.config/nvim/_clang-format]
local clangformat = function()
	local workspaces = vim.lsp.buf.list_workspace_folders()
	if #workspaces >= 1 then
		local fileExist = _G.myUtils.fileExist
		if fileExist(workspaces[1] .. "/.clang-format") or fileExist(workspaces[1] .. "/_clang-format") then
			return require("formatter.defaults.clangformat")
		end
	end

	local style_file
	style_file = os.getenv("HOME") .. "/.config/nvim/_clang-format"

	return {
		exe = "clang-format",
		args = {
			"-assume-filename",
			util.escape_path(util.get_current_buffer_file_name()),
			util.escape_path("-style=file:" .. style_file),
		},
		stdin = true,
		try_node_modules = true,
	}
end

-- eslint_d
local eslint_d = require("formatter.defaults.eslint_d")

-- Provides the Format, FormatWrite, FormatLock, and FormatWriteLock commands
require("formatter").setup({
	-- Enable or disable logging
	logging = true,
	-- Set the log level
	log_level = vim.log.levels.WARN,
	-- All formatter configurations are opt-in
	filetype = {
		-- Formatter configurations for filetype "lua" go here
		-- and will be executed in order
		lua = {
			-- "formatter.filetypes.lua" defines default configurations for the
			-- "lua" filetype
			require("formatter.filetypes.lua").stylua,

			-- You can also define your own configuration
			function()
				-- Supports conditional formatting
				if util.get_current_buffer_file_name() == "special.lua" then
					return nil
				end

				-- Full specification of configurations is down below and in Vim help
				-- files
				return {
					exe = "stylua",
					args = {
						"--search-parent-directories",
						"--stdin-filepath",
						util.escape_path(util.get_current_buffer_file_path()),
						"--",
						"-",
					},
					stdin = true,
				}
			end,
		},

		c = clangformat,
		cpp = clangformat,
		java = clangformat,

		javascript = clangformat, --eslint_d,
		typescript = clangformat, --eslint_d,

		python = require("formatter.filetypes.python").black,

		-- Use the special "*" filetype for defining formatter configurations on
		-- any filetype
		["*"] = {
			-- "formatter.filetypes.any" defines default configurations for any
			-- filetype
			require("formatter.filetypes.any").remove_trailing_whitespace,
		},
	},
})

-- format after save
-- vim.cmd([[
--     augroup FormatAutogroup
--         autocmd!
--         autocmd BufWritePost * FormatWrite
--     augroup END
-- ]])

vim.cmd([[nnoremap <silent> <leader>ff :Format<CR>]])
vim.cmd([[nnoremap <silent> <leader>fw :FormatWrite<CR>]])
