local function wordAndCharCount()
	local count = vim.fn.wordcount()
	return "w:" .. count.words .. "|c:" .. count.chars
end

require("lualine").setup({
	options = {
		globalstatus = true, -- works only in neovim 0.7 and higher
	},
	sections = {
		-- lualine_a = { "mode" },
		-- lualine_b = { "branch", "diff", "diagnostics" },
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
