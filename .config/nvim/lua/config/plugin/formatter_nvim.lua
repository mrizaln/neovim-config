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
		glsl = clangformat,
		-- java = clangformat,

		javascript = require("formatter.defaults.eslint_d"),
		typescript = require("formatter.defaults.eslint_d"),
		json = require("formatter.filetypes.json").prettier,

		xml = require("formatter.filetypes.xml").tidy,
		html = require("formatter.filetypes.html").tidy,

		python = require("formatter.filetypes.python").black,

		rust = require("formatter.filetypes.rust").rustfmt,

		markdown = prettier,

		go = require("formatter.filetypes.go").gofmt,

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
        \'c'        : v:true,
        \'cpp'      : v:true,
        \'glsl'     : v:true,
        \'lua'      : v:true,
        \'markdown' : v:true,
        \'python'   : v:false,
        \'rust'     : v:true,
        \'other'    : v:false,
    \}
]])

-- auto format get filetype
vim.cmd([[
    function FormatterAutoCommandGetFiletype()
        let l:filetype = &filetype

        if empty(l:filetype)
            let l:filetype = "other"
        endif

        if &buftype != ""
            return "notfile"        " notfile is a special case for non-file buffers
        elseif !has_key(g:formatter_auto_format_rules, l:filetype)
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

        if l:filetype == "notfile"
            return
        endif

        " if the rule has been overridden, don't load the default
        if has_key(g:formatter_auto_format_overridden, l:filetype)
            return
        endif

        " load the default rule
        let l:rule = g:formatter_auto_format_rules[l:filetype]
        let g:formatter_auto_format_enabled[l:filetype] = l:rule
    endfunction
]])

-- auto format status
vim.cmd([[
    function FormatterAutoCommandStatus(short)
        let l:filetype = FormatterAutoCommandGetFiletype()

        if a:short
            if l:filetype == "notfile"
                echo "FormatterAutoCommandStatus (notfile): not a file"
            elseif !has_key(g:formatter_auto_format_enabled, l:filetype)
                echo "FormatterAutoCommandStatus (" . l:filetype . "): uninitialized"
            else
                let l:status = g:formatter_auto_format_enabled[l:filetype] ? "enabled" : "disabled"
                echo "FormatterAutoCommandStatus (" . l:filetype . "): " . l:status
            endif
        else
            echo "default   :" g:formatter_auto_format_rules
            echo "current   :" g:formatter_auto_format_enabled
            echo "overridden:" g:formatter_auto_format_overridden
        endif
    endfunction
]])

-- auto format command
vim.cmd([[
    function FormatterAutoCommandFunction(state)
        let l:filetype = FormatterAutoCommandGetFiletype()

        if l:filetype == "notfile"
            return
        endif

        let g:formatter_auto_format_overridden[l:filetype] = v:true

        " if for some reason the init function was not called for the current buffer, call it now
        if !has_key(g:formatter_auto_format_enabled, l:filetype)
            echo "Formatter auto command has not been initialized for this buffer, calling FormatterAutoCommandInit()"
            call FormatterAutoCommandInit()
        endif

        if empty(a:state) " toggle"
            " let g:formatter_auto_format_enabled[l:filetype] = (g:formatter_auto_format_enabled[l:filetype] + 1) % 2
            let g:formatter_auto_format_enabled[l:filetype] = g:formatter_auto_format_enabled[l:filetype] ? v:false : v:true
        else
            let g:formatter_auto_format_enabled[l:filetype] = a:state
        endif

        " immediately call formatter"
        if g:formatter_auto_format_enabled[l:filetype]
            call MyFormatWrite()
        endif
    endfunction


    command -nargs=1 FormatWriteAutoCmdStatus call FormatterAutoCommandStatus(<args>)
    command -nargs=0 FormatWriteAutoCmdToggle call FormatterAutoCommandFunction("") | FormatWriteAutoCmdStatus v:true
    command -nargs=0 FormatWriteAutoCmdEnable call FormatterAutoCommandFunction(v:true) | FormatWriteAutoCmdStatus v:true
    command -nargs=0 FormatWriteAutoCmdDisable call FormatterAutoCommandFunction(v:false) | FormatWriteAutoCmdStatus v:true
]])

-- format after save autocommand
vim.cmd([[
    augroup FormatAutogroup
        autocmd!
        autocmd BufNewFile,BufRead * call FormatterAutoCommandInit()
        autocmd BufWritePost * call MyFormatWrite()
    augroup END

    function MyFormatWrite()
        let l:filetype = FormatterAutoCommandGetFiletype()

        " if for some reason the init function was not called for the current buffer, call it now
        if !has_key(g:formatter_auto_format_enabled, l:filetype)
            echo "Formatter auto command has not been initialized for this buffer, calling FormatterAutoCommandInit()"
            call FormatterAutoCommandInit()
        endif

        if g:formatter_auto_format_enabled[l:filetype]
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
vim.cmd([[nnoremap <silent> <leader>fs :FormatWriteAutoCmdStatus v:true<CR>]])
vim.cmd([[nnoremap <silent> <leader>fS :FormatWriteAutoCmdStatus v:false<CR>]])
