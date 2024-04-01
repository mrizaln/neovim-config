require("todo-comments").setup({
	keywords = {
		NOLINT = { icon = " ", color = "warning", alt = { "NOLINT", "NOLINTNEXTLINE", "NOLINTBEGIN", "NOLINTEND" } },
	},
	highlight = {
		-- pattern = [[.*<(KEYWORDS)\s*]],
		pattern = [[.*<(KEYWORDS)(\(.*\))?:?\s*]],
	},
	-- search = {
	-- 	pattern = [[\b(KEYWORDS)\b]],
	-- },
})
