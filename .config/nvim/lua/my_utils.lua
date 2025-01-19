-- various scripts that I create

-- these scripts are inserted into _G global variable so it can be called anywhere from
-- nvim

-- create new field
_G.my_utils = {}

local utils = {
	general = require("utils/general"),
	-- random = require("utils/random"),
	dap = require("utils/dap-util"),
}

for _, v in pairs(utils) do
	for kk, vv in pairs(v) do
		_G.my_utils[kk] = vv
	end
end
