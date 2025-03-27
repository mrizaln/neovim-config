-- check if a table is used as an array
local function is_array(tab)
	return #tab > 0 and next(tab, #tab) == nil
end

local print_array_recurse, print_table_recurse

-- get arguments of a function
local function get_args(func)
	local args = {}
	for i = 1, debug.getinfo(func).nparams, 1 do
		table.insert(args, debug.getlocal(func, i))
	end
	return args
end

-- print array recursively
print_array_recurse = function(prelude, arr, level, max_level)
	level = level or 0
	max_level = max_level or -1

	if level == max_level then
		return
	end

	print(prelude .. "[")

	local indent = string.rep(" ", (level + 1) * 4)
	if arr ~= nil then
		for n, e in pairs(arr) do
			if type(e) == "table" then
				if is_array(e) then
					print_array_recurse(indent, e, level + 1, max_level)
				else
					print_table_recurse(indent, e, level + 1, max_level)
				end
			elseif type(e) == "function" then
				print_array_recurse(indent .. n .. " (fn) : ", get_args(e), level + 1, max_level)
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

-- print table recursively
print_table_recurse = function(prelude, tab, level, max_level)
	level = level or 0
	max_level = max_level or -1

	if level == max_level then
		return
	end

	print(prelude .. "{")

	local indent = string.rep(" ", (level + 1) * 4)
	if tab ~= nil then
		for k, e in pairs(tab) do
			if type(e) == "table" then
				if is_array(e) then
					print_array_recurse(indent .. k .. " : ", e, level + 1, max_level)
				else
					print_table_recurse(indent .. k .. " : ", e, level + 1, max_level)
				end
			elseif type(e) == "function" then
				print_array_recurse(indent .. k .. " (fn) : ", get_args(e), level + 1, max_level)
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

-- return a string, every element will be converted using built-in tostring() function
local function array_to_string_simple(arr, sep, prelude, ending)
	sep = sep or ", "
	prelude = prelude or "["
	ending = ending or "]"

	local str = prelude
	for _, e in pairs(arr) do
		str = str .. tostring(e) .. sep
	end
	return string.sub(str, 0, string.len(str) - string.len(sep)) .. ending
end

-- print array, element by element (converted using built-in tostring() function)
local function print_array(arr, sep, prelude, ending)
	print(array_to_string_simple(arr, sep, prelude, ending))
end

-- if you don't know what kind of type you want to print, use this function
-- this function will print recursively if the type is a table
-- you should pass the argument as a new table if you want to print multiple things
-- like this : better_print({arg1, arg2}) or better_print({name1=arg1, name2=arg2})
local function better_print(args, max_level)
	max_level = max_level or -1

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
			if is_array(tab) then
				print_array_recurse(name .. " (array) : ", tab, level, max_level)
			else
				print_table_recurse(name .. " (table) : ", tab, level, max_level)
			end
		elseif type(tab) == "function" then
			print_array_recurse(name .. " (function) : ", get_args(tab), level, max_level)
		else
			print(name .. " (" .. type(tab) .. ") : ", tab)
		end
	end
end

local function file_exist(file)
	-- check file exist
	local file_handler = io.open(file, "r")
	if file_handler == nil then
		return false
	else
		file_handler:close()
		return true
	end
end

local function split_string(inputstr, sep)
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
	local actual_ver = vim.version() or { major = 0, minor = 0, patch = 0 }

	local nvim_ver_str = string.format("%d.%d.%d", actual_ver.major, actual_ver.minor, actual_ver.patch)
	return nvim_ver_str
end

local function is_in_table(value, array)
	for _, v in ipairs(array) do
		if v == value then
			return true
		end
	end
	return false
end

---returns full path to git directory for dir_path or current directory
---stolen from 'lualine.nvim/lua/lualine/components/branch/git_branch.lua'
---@param dir_path string|nil
---@return string|nil
local function find_git_dir(dir_path)
	local git_dir_cache = {} -- Stores git paths that we already know of
	local sep = "/"
	local git_dir = vim.env.GIT_DIR
	if git_dir then
		return git_dir
	end

	-- get file dir so we can search from that dir
	local file_dir = dir_path or vim.fn.expand("%:p:h")
	local root_dir = file_dir
	-- Search upward for .git file or folder
	while root_dir do
		if git_dir_cache[root_dir] then
			git_dir = git_dir_cache[root_dir]
			break
		end
		local git_path = root_dir .. sep .. ".git"
		local git_file_stat = vim.loop.fs_stat(git_path)
		if git_file_stat then
			if git_file_stat.type == "directory" then
				git_dir = git_path
			elseif git_file_stat.type == "file" then
				-- separate git-dir or submodule is used
				local file = io.open(git_path)
				if file then
					git_dir = file:read()
					git_dir = git_dir and git_dir:match("gitdir: (.+)$")
					file:close()
				end
				-- submodule / relative file path
				if git_dir and git_dir:sub(1, 1) ~= sep and not git_dir:match("^%a:.*$") then
					git_dir = git_path:match("(.*).git") .. git_dir
				end
			end
			if git_dir then
				local head_file_stat = vim.loop.fs_stat(git_dir .. sep .. "HEAD")
				if head_file_stat and head_file_stat.type == "file" then
					break
				else
					git_dir = nil
				end
			end
		end
		root_dir = root_dir:match("(.*)" .. sep .. ".-")
	end

	git_dir_cache[file_dir] = git_dir
	return git_dir
end

return {
	print = better_print,
	file_exist = file_exist,
	split_string = split_string,
	get_nvim_version = get_nvim_version,
	array_to_string_simple = array_to_string_simple,
	print_array = print_array,
	is_in_table = is_in_table,
	find_git_dir = find_git_dir,
}
