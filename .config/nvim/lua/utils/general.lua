-- check if a table is used as an array
local function isArray(tab)
	return #tab > 0 and next(tab, #tab) == nil
end

-- print array recursively
local function printArrayRecurse(prelude, arr, level)
	if level == nil then
		level = 0
	end

	print(prelude .. "[")

	local indent = string.rep(" ", (level + 1) * 4)
	if arr ~= nil then
		for _, e in pairs(arr) do
			if type(e) == "table" then
				if isArray(e) then
					printArrayRecurse(indent, e, level + 1)
				else
					printTableRecurse(indent, e, level + 1)
				end
			else
				print(indent .. " (" .. type(e) .. ") " .. tostring(e) .. ",")
			end
		end
	end

	local ending = string.rep(" ", level * 4) .. "],"
	if level == 0 then
		ending = ending:sub(1, #ending - 1)
	end
	print(ending)
end

-- return a string, every element will be converted using built-in tostring() function
local function arrayToStringSimple(arr, sep, prelude, ending)
	local str = prelude
	for _, e in pairs(arr) do
		str = str .. tostring(e) .. sep
	end
	return string.sub(str, 0, string.len(str) - string.len(sep)) .. ending
end

-- print array, element by element (converted using built-in tostring() function)
local function printArray(arr, sep, prelude, ending)
	print(arrayToStringSimple(arr, sep, prelude, ending))
end

-- print table recursively
local function printTableRecurse(prelude, tab, level)
	if level == nil then
		level = 0
	end

	print(prelude .. "{")

	local indent = string.rep(" ", (level + 1) * 4)
	if tab ~= nil then
		for k, e in pairs(tab) do
			if type(e) == "table" then
				if isArray(e) then
					printArrayRecurse(indent .. k .. " : ", e, level + 1)
				else
					printTableRecurse(indent .. k .. " : ", e, level + 1)
				end
			else
				print(indent .. k .. " : (" .. type(e) .. ") " .. tostring(e) .. ",")
			end
		end
	end

	local ending = string.rep(" ", level * 4) .. "},"
	if level == 0 then
		ending = ending:sub(1, #ending - 1)
	end
	print(ending)
end

local function formatColor(str)
	return "\27[01;30;46m" .. str .. "\27[00m"
end

-- if you don't know what kind of type you want to print, use this function
-- this function will print recursively if the type is a table
-- you should pass the argument as a new table if you want to print multiple things
-- like this : betterPrint({arg1, arg2}) or betterPrint({name1=arg1, name2=arg2})
local function betterPrint(args, color)
	color = color or false
	args = args or {}
	if type(args) ~= "table" then
		print(args)
		return
	end

	-- print recursively if table
	local level = 0
	local idk = args
	for name, tab in pairs(idk) do
		if type(tab) == "table" then
			if isArray(tab) then
				if color then
					printArrayRecurse(name .. " (" .. formatColor("array") .. ") : ", tab, level)
				else
					printArrayRecurse(name .. " (array) : ", tab, level)
				end
			else
				if color then
					printTableRecurse(name .. " (" .. formatColor("table") .. ") : ", tab, level)
				else
					printTableRecurse(name .. " (table) : ", tab, level)
				end
			end
		else
			if color then
				print(name .. " (" .. formatColor(type(tab)) .. ") : ", tab)
			else
				print(name .. " (" .. type(tab) .. ") : ", tab)
			end
		end
	end
end

local function fileExist(file)
	-- check file exist
	local file_handler = io.open(file, "r")
	if file_handler == nil then
		return false
	else
		file_handler:close()
		return true
	end
end

local function splitString(inputstr, sep)
	if sep == nil then
		sep = "%s"
	end
	local t = {}
	for str in string.gmatch(inputstr, "([^" .. sep .. "]+)") do
		table.insert(t, str)
	end
	return t
end

local function get_nvim_version()
  local actual_ver = vim.version()

  local nvim_ver_str = string.format("%d.%d.%d", actual_ver.major, actual_ver.minor, actual_ver.patch)
  return nvim_ver_str
end

return {
	print = betterPrint,
	fileExist = fileExist,
	splitString = splitString,
    get_nvim_version = get_nvim_version,
}
