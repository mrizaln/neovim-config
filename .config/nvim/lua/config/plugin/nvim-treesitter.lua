-- treesitter
----------------
local configs = require("nvim-treesitter.configs")
configs.setup({
	ensure_installed = {
		"bash",
		"c",
		"cmake",
		"cpp",
		"glsl",
		"java",
		"javascript",
		"kotlin",
		"lua",
		"python",
		"rust",
		"sql",
		"typescript",
		"vim",
	},
	auto_install = true,
	highlight = { -- enable highlighting
		enable = true,
		-- disable slow treesitter highlight for large files
		disable = function(lang, buf)
			local max_filesize = 100 * 1024 -- 100 KB
			local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
			if ok and stats and stats.size > max_filesize then
				print("Treesitter disabled due to the file size of file being opened too big (> 100K)")
				return true
			end
		end,
	},
	-- indent = {
	-- 	enable = true, -- default is disabled anyways
	-- },
})
----------------

--------------------------------[ other ]--------------------------------
-- not working currently
local parser_config = require("nvim-treesitter.parsers").get_parser_configs()
parser_config["cpp2"] = {
	install_info = {
		url = "https://github.com/APokorny/tree-sitter-cpp2", -- local path or git repo
		files = { "src/parser.c" }, -- note that some parsers also require src/scanner.c or src/scanner.cc
		-- optional entries:
		branch = "main", -- default branch in case of git repo if different from master
		generate_requires_npm = false, -- if stand-alone parser without npm dependencies
		requires_generate_from_grammar = false, -- if folder contains pre-generated src/parser.c
	},
	filetype = "cpp2", -- if filetype does not match the parser name
}
