-- chunkname: @scripts/utils/serialize.lua

local var_0_0 = {}
local var_0_1
local var_0_2

function var_0_0.save(arg_1_0, arg_1_1, arg_1_2)
	arg_1_2 = arg_1_2 or {}

	assert(arg_1_1)
	assert(type(arg_1_0) == "string", "1st argument to serialize.save should be the *name* of a variable")
	assert(type(arg_1_1) ~= "nil", "Variable %q does not exist", arg_1_0)
	assert(type(arg_1_2) == "table" or arg_1_2 == nil, "3rd argument to serialize.save should be a table or nil")

	local var_1_0 = {}

	var_0_1(arg_1_0, arg_1_1, var_1_0, 0, arg_1_2)

	return table.concat(var_1_0, "\n"), arg_1_2
end

function var_0_0.save_simple(arg_2_0, arg_2_1)
	local var_2_0 = {}

	var_0_2(arg_2_0, var_2_0, arg_2_1 or 1)

	return table.concat(var_2_0)
end

local function var_0_3(arg_3_0)
	if type(arg_3_0) == "number" or type(arg_3_0) == "boolean" then
		return tostring(arg_3_0)
	else
		return string.format("%q", arg_3_0)
	end
end

local var_0_4 = {}

for iter_0_0, iter_0_1 in ipairs({
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
	var_0_4[iter_0_1] = true
end

function var_0_1(arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4)
	local var_4_0 = string.rep("\t", arg_4_3) .. arg_4_0
	local var_4_1 = type(arg_4_1)

	if var_4_1 == "number" or var_4_1 == "string" or var_4_1 == "boolean" then
		table.insert(arg_4_2, var_4_0 .. " = " .. var_0_3(arg_4_1))
	elseif var_4_1 == "table" then
		if arg_4_4[arg_4_1] then
			table.insert(arg_4_2, var_4_0 .. " = " .. arg_4_4[arg_4_1])
		else
			arg_4_4[arg_4_1] = arg_4_0

			table.insert(arg_4_2, var_4_0 .. " = {}")

			for iter_4_0, iter_4_1 in pairs(arg_4_1) do
				local var_4_2

				if type(iter_4_0) == "string" and string.find(iter_4_0, "^[_%a][_%a%d]*$") and not var_0_4[iter_4_0] then
					var_4_2 = string.format("%s.%s", arg_4_0, iter_4_0)
				elseif type(iter_4_0) == "table" and arg_4_4[iter_4_0] then
					var_4_2 = string.format("%s[%s]", arg_4_0, arg_4_4[iter_4_0])
				elseif type(iter_4_0) == "table" then
					error("Key table entry " .. tostring(iter_4_0) .. " in table " .. arg_4_0 .. " is not known")
				elseif type(iter_4_0) == "number" or type(iter_4_0) == "boolean" then
					var_4_2 = string.format("%s[%s]", arg_4_0, tostring(iter_4_0))
				elseif type(iter_4_0) ~= "string" then
					error("Cannot serialize table keys of type '" .. type(iter_4_0) .. "' in table " .. arg_4_0)
				else
					var_4_2 = string.format("%s[%s]", arg_4_0, var_0_3(iter_4_0))
				end

				var_0_1(var_4_2, iter_4_1, arg_4_2, arg_4_3 + 2, arg_4_4)
			end
		end
	else
		error("Cannot serialize '" .. arg_4_0 .. "' (" .. var_4_1 .. ")")
	end
end

function var_0_2(arg_5_0, arg_5_1, arg_5_2)
	local var_5_0 = type(arg_5_0)

	if var_5_0 == "number" or var_5_0 == "string" or var_5_0 == "boolean" then
		table.insert(arg_5_1, var_0_3(arg_5_0))
	elseif var_5_0 == "table" then
		table.insert(arg_5_1, "{\n")

		for iter_5_0, iter_5_1 in pairs(arg_5_0) do
			table.insert(arg_5_1, string.rep("\t", arg_5_2))

			if not string.find(iter_5_0, "^[_%a][_%a%d]*$") or var_0_4[iter_5_0] then
				table.insert(arg_5_1, "[" .. var_0_3(iter_5_0) .. "] = ")
			else
				table.insert(arg_5_1, iter_5_0 .. " = ")
			end

			var_0_2(iter_5_1, arg_5_1, arg_5_2 + 1)
			table.insert(arg_5_1, ",\n")
		end

		table.insert(arg_5_1, string.rep("\t", arg_5_2 - 1) .. "}")
	else
		error("Cannot serialize " .. type(arg_5_0))
	end
end

return var_0_0
