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

--[[ require'nvim-treesitter.configs'.setup {
  -- A list of parser names, or "all"
  ensure_installed = { "bash", "c", "cmake", "cpp", "lua", "python", "rust", "vim" },

  -- Install parsers synchronously (only applied to `ensure_installed`)
  sync_install = false,

  -- Automatically install missing parsers when entering buffer
  -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
  auto_install = true,

  -- List of parsers to ignore installing (for "all")
  ignore_install = { "php" },

  ---- If you need to change the installation directory of the parsers (see -> Advanced Setup)
  -- parser_install_dir = "/some/path/to/store/parsers", -- Remember to run vim.opt.runtimepath:append("/some/path/to/store/parsers")!

  highlight = {
    -- `false` will disable the whole extension
    enable = true,

    -- NOTE: these are the names of the parsers and not the filetype. (for example if you want to
    -- disable highlighting for the `tex` filetype, you need to include `latex` in this list as this is
    -- the name of the parser)
    -- list of language that will be disabled
    --disable = { "c", "rust" },
    -- Or use a function for more flexibility, e.g. to disable slow treesitter highlight for large files
    disable = function(lang, buf)
        local max_filesize = 100 * 1024 -- 100 KB
        local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
        if ok and stats and stats.size > max_filesize then
            return true
        end
    end,

    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
    -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
    -- Using this option may slow down your editor, and you may see some duplicate highlights.
    -- Instead of true it can also be a list of languages
    additional_vim_regex_highlighting = false,
  },
} --]]

--
--------------------------------[ other ]--------------------------------

-- local parser_mapping = require("nvim-treesitter.parsers").filetype_to_parsername
-- parser_mapping.xml = "html" -- map the html parser to be used when using xml files

-- local parser_config = require("nvim-treesitter.parsers").get_parser_configs()
-- parser_config.xml = {
-- 	install_info = {
-- 		url = "https://github.com/lucascool12/tree-sitter-xml.git", -- local path or git repo
-- 		files = { "src/parser.c" }, -- note that some parsers also require src/scanner.c or src/scanner.cc
-- 		-- optional entries:
-- 		branch = "main", -- default branch in case of git repo if different from master
-- 		generate_requires_npm = false, -- if stand-alone parser without npm dependencies
-- 		requires_generate_from_grammar = false, -- if folder contains pre-generated src/parser.c
-- 	},
-- 	-- filetype = "xml", -- if filetype does not match the parser name
-- }
