local utils = require("./general")

local tab = {
	hiji = "a string",
	dua = function()
		print("hai")
	end,
	tilu = { 1, 2, 3, 2, 12, 432, 435, 3456, 213, 5 },
}

utils.print(tab)
