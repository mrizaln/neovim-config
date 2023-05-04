-- Utilities for creating configurations
local util = require("formatter.util")

-- use project specific format if [.clang-format] or [_clang-format] is available
-- else use [$HOME/.config/nvim/_clang-format]
local clangformat = function()
	local style_file = nil

	local fileExist = _G.myUtils.fileExist

	local workspaces = vim.lsp.buf.list_workspace_folders()
	if #workspaces >= 1 then
		if fileExist(workspaces[1] .. "/_clang-format") then
			style_file = workspaces[1] .. "/_clang-format"
		elseif fileExist(workspaces[1] .. "/.clang-format") then
			style_file = workspaces[1] .. "/.clang-format"
		end
	end

	-- single file mode usually returns 0 #workspaces
	if style_file == nil then
		if fileExist(os.getenv("HOME") .. "/.config/nvim/_clang-format") then
			style_file = os.getenv("HOME") .. "/.config/nvim/_clang-format"
		elseif fileExist(os.getenv("HOME") .. "/.config/nvim/.clang-format") then
			style_file = os.getenv("HOME") .. "/.config/nvim/.clang-format"
		end
	end

	if style_file == nil then
		print("No clang-format configuration found, use defaults")
		print(
			"Nvim global clang-format configuration usually here: "
				.. os.getenv("HOME")
				.. "/.config/nvim/_clang-format"
		)
		return (require("formatter.defaults.clangformat"))()
	else
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
end

-- local eslint_d = require("formatter.defaults.eslint_d")

local prettier = function()
	local _prettier = require("formatter.filetypes.markdown").prettier()

	-- use tab-width value the same as nvim's configured tabstop value
	table.insert(_prettier.args, "--tab-width=" .. vim.opt.tabstop._value)
	return _prettier
end

-- Provides the Format, FormatWrite, FormatLock, and FormatWriteLock commands
require("formatter").setup({
	-- Enable or disable logging
	logging = true,
	-- Set the log level
	log_level = vim.log.levels.WARN,
	-- All formatter configurations are opt-in
	filetype = {
		--[[
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
        ]]

		lua = require("formatter.filetypes.lua").stylua,

		c = clangformat,
		cpp = clangformat,
		java = clangformat,

		javascript = clangformat, --eslint_d,
		typescript = clangformat, --eslint_d,

		python = require("formatter.filetypes.python").black,

		rust = require("formatter.filetypes.rust").rustfmt,

		markdown = prettier,

		-- Use the special "*" filetype for defining formatter configurations on
		-- any filetype
		["*"] = {
			-- "formatter.filetypes.any" defines default configurations for any
			-- filetype
			require("formatter.filetypes.any").remove_trailing_whitespace,
		},
	},
})

--
--------------------------------------------------------------------------------
--[ autocommand ]--
--

-- auto format rule
vim.cmd([[
    let g:formatter_auto_format_rules = {
        \'c' : 1,
        \'cpp' : 1,
        \'lua' : 1,
        \'markdown' : 1,
        \'python' : 0,
        \'rust' : 1,
        \'other' : 0,
    \}
]])

-- auto format get filetype
vim.cmd([[
    function FormatterAutoCommandGetFiletype()
        let l:filetype = &filetype

        if empty(l:filetype)
            let l:filetype = "other"
        endif

        if !has_key(g:formatter_auto_format_rules, l:filetype)
            return "other"
        else
            return l:filetype
        endif
    endfunction

]])

-- auto format init
vim.cmd([[
    let g:formatter_auto_format_enabled = {}
    let g:formatter_auto_format_overridden = {}

    function FormatterAutoCommandInit()
        let l:filetype = FormatterAutoCommandGetFiletype()

        if has_key(g:formatter_auto_format_overridden, l:filetype)
            return
        endif

        let l:rule = g:formatter_auto_format_rules[l:filetype]
        let g:formatter_auto_format_enabled[l:filetype] = l:rule
    endfunction
]])

-- auto format status
vim.cmd([[
    function FormatterAutoCommandStatus()
        let l:filetype = FormatterAutoCommandGetFiletype()

        return g:formatter_auto_format_enabled[l:filetype]
    endfunction
]])

-- auto format command
vim.cmd([[
    function FormatterAutoCommandFunction(state)
        let l:filetype = FormatterAutoCommandGetFiletype()

        let g:formatter_auto_format_overridden[l:filetype] = 1

        if empty(a:state)
            let g:formatter_auto_format_enabled[l:filetype] = (g:formatter_auto_format_enabled[l:filetype] + 1) % 2 " toggle
        else
            let g:formatter_auto_format_enabled[l:filetype] = a:state
        endif
    endfunction


    command -nargs=0 FormatWriteAutoCmdStatus echo "FormatterAutoCommandStatus (" . &filetype . "): " . FormatterAutoCommandStatus()
    command -nargs=? FormatWriteAutoCmd call FormatterAutoCommandFunction("<args>") | FormatWriteAutoCmdStatus
    command -nargs=0 FormatWriteAutoCmdToggle call FormatterAutoCommandFunction("") | FormatWriteAutoCmdStatus
    command -nargs=0 FormatWriteAutoCmdEnable call FormatterAutoCommandFunction(1) | FormatWriteAutoCmdStatus
    command -nargs=0 FormatWriteAutoCmdDisable call FormatterAutoCommandFunction(0) | FormatWriteAutoCmdStatus
]])

-- format after save autocommand
vim.cmd([[
    augroup FormatAutogroup
        autocmd!
        autocmd BufEnter * call FormatterAutoCommandInit()
        autocmd BufWritePost * call MyFormatWrite()
    augroup END

    function MyFormatWrite()
        let l:filetype = FormatterAutoCommandGetFiletype()

        if g:formatter_auto_format_enabled[l:filetype] == 1
           FormatWrite
        endif
    endfunction
]])

--
--------------------------------------------------------------------------------
--[ mapping ]--

vim.cmd([[nnoremap <silent> <leader>ff :Format<CR>]])
vim.cmd([[nnoremap <silent> <leader>fw :FormatWrite<CR>]])
vim.cmd([[nnoremap <silent> <leader>ft :FormatWriteAutoCmdToggle<CR>]])
vim.cmd([[nnoremap <silent> <leader>fs :FormatWriteAutoCmdStatus<CR>]])
