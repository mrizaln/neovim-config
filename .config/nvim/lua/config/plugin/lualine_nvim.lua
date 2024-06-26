local function wordAndCharCount()
	local count = vim.fn.wordcount()
	count.lines = vim.fn.line("$")
	return "c:" .. count.chars .. "|w:" .. count.words .. "|l:" .. count.lines
end

local function lualine_b_content()
	local name = os.getenv("USER")
	if name == "root" then
		-- return "%#warning#root"
		return {
			function()
				return "[root]"
			end,
			"branch",
			"diff",
			"diagnostics",
		}
	else
		return { "branch", "diff", "diagnostics" }
	end
end

require("lualine").setup({
	options = {
		globalstatus = true, -- works only in neovim 0.7 and higher
	},
	sections = {
		-- lualine_a = { "mode" },
		-- lualine_b = { "branch", "diff", "diagnostics" },
		lualine_b = lualine_b_content(),
		-- lualine_c = { "filename" },
		-- lualine_x = { "encoding", "fileformat", "filetype" },
		lualine_y = { "progress", wordAndCharCount },
		-- lualine_z = { "location" },
	},
})

-- [ default configuration ] --
--[[ require('lualine').setup {
  options = {
    icons_enabled = true,
    theme = 'auto',
    component_separators = { left = '', right = ''},
    section_separators = { left = '', right = ''},
    disabled_filetypes = {
      statusline = {},
      winbar = {},
    },
    ignore_focus = {},
    always_divide_middle = true,
    globalstatus = false,
    refresh = {
      statusline = 1000,
      tabline = 1000,
      winbar = 1000,
    }
  },
  sections = {
    lualine_a = {'mode'},
    lualine_b = {'branch', 'diff', 'diagnostics'},
    lualine_c = {'filename'},
    lualine_x = {'encoding', 'fileformat', 'filetype'},
    lualine_y = {'progress'},
    lualine_z = {'location'}
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = {'filename'},
    lualine_x = {'location'},
    lualine_y = {},
    lualine_z = {}
  },
  tabline = {},
  winbar = {},
  inactive_winbar = {},
  extensions = {}
} ]]
