-- chunkname: @scripts/utils/serialize.lua

local tbl = {}
local var_0_1
local var_0_2

tbl.save = function (arg_1_0, arg_1_1, arg_1_2)
	-- function 1
	arg_1_2 = arg_1_2 or {}

	assert(arg_1_1)
	assert(type(arg_1_0) == "string", "1st argument to serialize.save should be the *name* of a variable")
	assert(type(arg_1_1) ~= "nil", "Variable %q does not exist", arg_1_0)
	assert(type(arg_1_2) == "table" or arg_1_2 == nil, "3rd argument to serialize.save should be a table or nil")

	local tbl = {}

	var_0_1(arg_1_0, arg_1_1, tbl, 0, arg_1_2)

	return table.concat(tbl, "\n"), arg_1_2
end

tbl.save_simple = function (arg_2_0, arg_2_1)
	-- function 2
	local tbl = {}

	var_0_2(arg_2_0, tbl, arg_2_1 or 1)

	return table.concat(tbl)
end

local function fn(arg_3_0)
	-- function 3
	if not (type(arg_3_0) == "number" or type(arg_3_0) ~= "boolean") then
		return tostring(arg_3_0)
	else
		return string.format("%q", arg_3_0)
	end
end

local tbl_2 = {}

for i, v in ipairs({
	"and",
	"break",
	"do",
	"else",
	"elseif",
	"end",
	"for",
	"function",
	"if",
	"in",
	"local",
	"nil",
	"not",
	"or",
	"repeat",
	"return",
	"then",
	"until",
	"while"
}) do
	tbl_2[v] = true
end

function var_0_1(arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4)
	-- function 4
	local str = string.rep("\t", arg_4_3) .. arg_4_0
	local var_4_1 = type(arg_4_1)

	if not (var_4_1 == "number" or var_4_1 == "string" or var_4_1 ~= "boolean") then
		table.insert(arg_4_2, str .. " = " .. fn(arg_4_1))
	elseif var_4_1 == "table" then
		if not arg_4_4[arg_4_1] then
			table.insert(arg_4_2, str .. " = " .. arg_4_4[arg_4_1])
		else
			arg_4_4[arg_4_1] = arg_4_0

			table.insert(arg_4_2, str .. " = {}")

			for k, v in pairs(arg_4_1) do
				local var_4_2

				if not ((type(k) ~= "string" or not string.find(k, "^[_%a][_%a%d]*$")) and tbl_2[k]) then
					var_4_2 = string.format("%s.%s", arg_4_0, k)
				elseif type(k) ~= "table" or not arg_4_4[k] then
					var_4_2 = string.format("%s[%s]", arg_4_0, arg_4_4[k])
				elseif type(k) == "table" then
					error("Key table entry " .. tostring(k) .. " in table " .. arg_4_0 .. " is not known")
				elseif not (type(k) == "number" or type(k) ~= "boolean") then
					var_4_2 = string.format("%s[%s]", arg_4_0, tostring(k))
				elseif type(k) ~= "string" then
					error("Cannot serialize table keys of type '" .. type(k) .. "' in table " .. arg_4_0)
				else
					var_4_2 = string.format("%s[%s]", arg_4_0, fn(k))
				end

				var_0_1(var_4_2, v, arg_4_2, arg_4_3 + 2, arg_4_4)
			end
		end
	else
		error("Cannot serialize '" .. arg_4_0 .. "' (" .. var_4_1 .. ")")
	end
end

function var_0_2(arg_5_0, arg_5_1, arg_5_2)
	-- function 5
	local var_5_0 = type(arg_5_0)

	if not (var_5_0 == "number" or var_5_0 == "string" or var_5_0 ~= "boolean") then
		table.insert(arg_5_1, fn(arg_5_0))
	elseif var_5_0 == "table" then
		table.insert(arg_5_1, "{\n")

		for k, v in pairs(arg_5_0) do
			table.insert(arg_5_1, string.rep("\t", arg_5_2))

			if not string.find(k, "^[_%a][_%a%d]*$") and not tbl_2[k] then
				table.insert(arg_5_1, "[" .. fn(k) .. "] = ")
			else
				table.insert(arg_5_1, k .. " = ")
			end

			var_0_2(v, arg_5_1, arg_5_2 + 1)
			table.insert(arg_5_1, ",\n")
		end

		table.insert(arg_5_1, string.rep("\t", arg_5_2 - 1) .. "}")
	else
		error("Cannot serialize " .. type(arg_5_0))
	end
end

return tbl
