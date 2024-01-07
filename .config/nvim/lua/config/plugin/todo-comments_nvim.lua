require("todo-comments").setup({
	keywords = {
		NOLINT = { icon = " ", color = "warning", alt = { "NOLINTNEXTLINE", "NOLINTBEGIN"  } },
	},
	-- highlight = {
	-- 	pattern = [[.*<(KEYWORDS)\s*]],
	-- },
	-- search = {
	-- 	pattern = [[\b(KEYWORDS)\b]],
	-- },
})
