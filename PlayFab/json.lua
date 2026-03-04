-- chunkname: @PlayFab/json.lua

local var_0_0 = {
	_version = "0.1.0"
}
local var_0_1
local var_0_2 = {
	["\f"] = "\\f",
	["\b"] = "\\b",
	["\n"] = "\\n",
	["\t"] = "\\t",
	["\\"] = "\\\\",
	["\r"] = "\\r",
	["\""] = "\\\""
}
local var_0_3 = {
	["\\/"] = "/"
}

for iter_0_0, iter_0_1 in pairs(var_0_2) do
	var_0_3[iter_0_1] = iter_0_0
end

local function var_0_4(arg_1_0)
	return var_0_2[arg_1_0] or string.format("\\u%04x", arg_1_0:byte())
end

local function var_0_5(arg_2_0)
	return "null"
end

local function var_0_6(arg_3_0, arg_3_1)
	local var_3_0 = {}

	arg_3_1 = arg_3_1 or {}

	if arg_3_1[arg_3_0] then
		error("circular reference")
	end

	arg_3_1[arg_3_0] = true

	if arg_3_0[1] ~= nil or next(arg_3_0) == nil then
		local var_3_1 = 0

		for iter_3_0 in pairs(arg_3_0) do
			if type(iter_3_0) ~= "number" then
				error("invalid table: mixed or invalid key types")
			end

			var_3_1 = var_3_1 + 1
		end

		if var_3_1 ~= #arg_3_0 then
			error("invalid table: sparse array")
		end

		for iter_3_1, iter_3_2 in ipairs(arg_3_0) do
			table.insert(var_3_0, var_0_1(iter_3_2, arg_3_1))
		end

		arg_3_1[arg_3_0] = nil

		return "[" .. table.concat(var_3_0, ",") .. "]"
	else
		for iter_3_3, iter_3_4 in pairs(arg_3_0) do
			if type(iter_3_3) ~= "string" then
				error("invalid table: mixed or invalid key types")
			end

			table.insert(var_3_0, var_0_1(iter_3_3, arg_3_1) .. ":" .. var_0_1(iter_3_4, arg_3_1))
		end

		arg_3_1[arg_3_0] = nil

		return "{" .. table.concat(var_3_0, ",") .. "}"
	end
end

local function var_0_7(arg_4_0)
	return "\"" .. arg_4_0:gsub("[%z\x01-\x1F\\\"]", var_0_4) .. "\""
end

local function var_0_8(arg_5_0)
	if arg_5_0 ~= arg_5_0 or arg_5_0 <= -math.huge or arg_5_0 >= math.huge then
		error("unexpected number value '" .. tostring(arg_5_0) .. "'")
	end

	return string.format("%.14g", arg_5_0)
end

local var_0_9 = {
	["nil"] = var_0_5,
	table = var_0_6,
	string = var_0_7,
	number = var_0_8,
	boolean = tostring
}

function var_0_1(arg_6_0, arg_6_1)
	local var_6_0 = type(arg_6_0)
	local var_6_1 = var_0_9[var_6_0]

	if var_6_1 then
		return var_6_1(arg_6_0, arg_6_1)
	end

	error("unexpected type '" .. var_6_0 .. "'")
end

function var_0_0.encode(arg_7_0)
	return (var_0_1(arg_7_0))
end

local var_0_10

local function var_0_11(...)
	local var_8_0 = {}

	for iter_8_0 = 1, select("#", ...) do
		var_8_0[select(iter_8_0, ...)] = true
	end

	return var_8_0
end

local var_0_12 = var_0_11(" ", "\t", "\r", "\n")
local var_0_13 = var_0_11(" ", "\t", "\r", "\n", "]", "}", ",")
local var_0_14 = var_0_11("\\", "/", "\"", "b", "f", "n", "r", "t", "u")
local var_0_15 = var_0_11("true", "false", "null")
local var_0_16 = {
	["false"] = false,
	["true"] = true
}

local function var_0_17(arg_9_0, arg_9_1, arg_9_2, arg_9_3)
	for iter_9_0 = arg_9_1, #arg_9_0 do
		if arg_9_2[arg_9_0:sub(iter_9_0, iter_9_0)] ~= arg_9_3 then
			return iter_9_0
		end
	end

	return #arg_9_0 + 1
end

local function var_0_18(arg_10_0, arg_10_1, arg_10_2)
	local var_10_0 = 1
	local var_10_1 = 1

	for iter_10_0 = 1, arg_10_1 - 1 do
		var_10_1 = var_10_1 + 1

		if arg_10_0:sub(iter_10_0, iter_10_0) == "\n" then
			var_10_0 = var_10_0 + 1
			var_10_1 = 1
		end
	end

	error(string.format("%s at line %d col %d", arg_10_2, var_10_0, var_10_1))
end

local function var_0_19(arg_11_0)
	local var_11_0 = math.floor

	if arg_11_0 <= 127 then
		return string.char(arg_11_0)
	elseif arg_11_0 <= 2047 then
		return string.char(var_11_0(arg_11_0 / 64) + 192, arg_11_0 % 64 + 128)
	elseif arg_11_0 <= 65535 then
		return string.char(var_11_0(arg_11_0 / 4096) + 224, var_11_0(arg_11_0 % 4096 / 64) + 128, arg_11_0 % 64 + 128)
	elseif arg_11_0 <= 1114111 then
		return string.char(var_11_0(arg_11_0 / 262144) + 240, var_11_0(arg_11_0 % 262144 / 4096) + 128, var_11_0(arg_11_0 % 4096 / 64) + 128, arg_11_0 % 64 + 128)
	end

	error(string.format("invalid unicode codepoint '%x'", arg_11_0))
end

local function var_0_20(arg_12_0)
	local var_12_0 = tonumber(arg_12_0:sub(3, 6), 16)
	local var_12_1 = tonumber(arg_12_0:sub(9, 12), 16)

	if var_12_1 then
		return var_0_19((var_12_0 - 55296) * 1024 + (var_12_1 - 56320) + 65536)
	else
		return var_0_19(var_12_0)
	end
end

local function var_0_21(arg_13_0, arg_13_1)
	local var_13_0 = false
	local var_13_1 = false
	local var_13_2 = false
	local var_13_3

	for iter_13_0 = arg_13_1 + 1, #arg_13_0 do
		local var_13_4 = arg_13_0:byte(iter_13_0)

		if var_13_4 < 32 then
			var_0_18(arg_13_0, iter_13_0, "control character in string")
		end

		if var_13_3 == 92 then
			if var_13_4 == 117 then
				local var_13_5 = arg_13_0:sub(iter_13_0 + 1, iter_13_0 + 5)

				if not var_13_5:find("%x%x%x%x") then
					var_0_18(arg_13_0, iter_13_0, "invalid unicode escape in string")
				end

				if var_13_5:find("^[dD][89aAbB]") then
					var_13_1 = true
				else
					var_13_0 = true
				end
			else
				local var_13_6 = string.char(var_13_4)

				if not var_0_14[var_13_6] then
					var_0_18(arg_13_0, iter_13_0, "invalid escape char '" .. var_13_6 .. "' in string")
				end

				var_13_2 = true
			end

			var_13_3 = nil
		elseif var_13_4 == 34 then
			local var_13_7 = arg_13_0:sub(arg_13_1 + 1, iter_13_0 - 1)

			if var_13_1 then
				var_13_7 = var_13_7:gsub("\\u[dD][89aAbB]..\\u....", var_0_20)
			end

			if var_13_0 then
				var_13_7 = var_13_7:gsub("\\u....", var_0_20)
			end

			if var_13_2 then
				var_13_7 = var_13_7:gsub("\\.", var_0_3)
			end

			return var_13_7, iter_13_0 + 1
		else
			var_13_3 = var_13_4
		end
	end

	var_0_18(arg_13_0, arg_13_1, "expected closing quote for string")
end

local function var_0_22(arg_14_0, arg_14_1)
	local var_14_0 = var_0_17(arg_14_0, arg_14_1, var_0_13)
	local var_14_1 = arg_14_0:sub(arg_14_1, var_14_0 - 1)
	local var_14_2 = tonumber(var_14_1)

	if not var_14_2 then
		var_0_18(arg_14_0, arg_14_1, "invalid number '" .. var_14_1 .. "'")
	end

	return var_14_2, var_14_0
end

local function var_0_23(arg_15_0, arg_15_1)
	local var_15_0 = var_0_17(arg_15_0, arg_15_1, var_0_13)
	local var_15_1 = arg_15_0:sub(arg_15_1, var_15_0 - 1)

	if not var_0_15[var_15_1] then
		var_0_18(arg_15_0, arg_15_1, "invalid literal '" .. var_15_1 .. "'")
	end

	return var_0_16[var_15_1], var_15_0
end

local function var_0_24(arg_16_0, arg_16_1)
	local var_16_0 = {}
	local var_16_1 = 1

	arg_16_1 = arg_16_1 + 1

	while true do
		local var_16_2

		arg_16_1 = var_0_17(arg_16_0, arg_16_1, var_0_12, true)

		if arg_16_0:sub(arg_16_1, arg_16_1) == "]" then
			arg_16_1 = arg_16_1 + 1

			break
		end

		var_16_0[var_16_1], arg_16_1 = var_0_10(arg_16_0, arg_16_1)
		var_16_1 = var_16_1 + 1
		arg_16_1 = var_0_17(arg_16_0, arg_16_1, var_0_12, true)

		local var_16_3 = arg_16_0:sub(arg_16_1, arg_16_1)

		arg_16_1 = arg_16_1 + 1

		if var_16_3 == "]" then
			break
		end

		if var_16_3 ~= "," then
			var_0_18(arg_16_0, arg_16_1, "expected ']' or ','")
		end
	end

	return var_16_0, arg_16_1
end

local function var_0_25(arg_17_0, arg_17_1)
	local var_17_0 = {}

	arg_17_1 = arg_17_1 + 1

	while true do
		local var_17_1
		local var_17_2

		arg_17_1 = var_0_17(arg_17_0, arg_17_1, var_0_12, true)

		if arg_17_0:sub(arg_17_1, arg_17_1) == "}" then
			arg_17_1 = arg_17_1 + 1

			break
		end

		if arg_17_0:sub(arg_17_1, arg_17_1) ~= "\"" then
			var_0_18(arg_17_0, arg_17_1, "expected string for key")
		end

		local var_17_3

		var_17_3, arg_17_1 = var_0_10(arg_17_0, arg_17_1)
		arg_17_1 = var_0_17(arg_17_0, arg_17_1, var_0_12, true)

		if arg_17_0:sub(arg_17_1, arg_17_1) ~= ":" then
			var_0_18(arg_17_0, arg_17_1, "expected ':' after key")
		end

		arg_17_1 = var_0_17(arg_17_0, arg_17_1 + 1, var_0_12, true)
		var_17_0[var_17_3], arg_17_1 = var_0_10(arg_17_0, arg_17_1)
		arg_17_1 = var_0_17(arg_17_0, arg_17_1, var_0_12, true)

		local var_17_4 = arg_17_0:sub(arg_17_1, arg_17_1)

		arg_17_1 = arg_17_1 + 1

		if var_17_4 == "}" then
			break
		end

		if var_17_4 ~= "," then
			var_0_18(arg_17_0, arg_17_1, "expected '}' or ','")
		end
	end

	return var_17_0, arg_17_1
end

local var_0_26 = {
	["\""] = var_0_21,
	["0"] = var_0_22,
	["1"] = var_0_22,
	["2"] = var_0_22,
	["3"] = var_0_22,
	["4"] = var_0_22,
	["5"] = var_0_22,
	["6"] = var_0_22,
	["7"] = var_0_22,
	["8"] = var_0_22,
	["9"] = var_0_22,
	["-"] = var_0_22,
	t = var_0_23,
	f = var_0_23,
	n = var_0_23,
	["["] = var_0_24,
	["{"] = var_0_25
}

function var_0_10(arg_18_0, arg_18_1)
	local var_18_0 = arg_18_0:sub(arg_18_1, arg_18_1)
	local var_18_1 = var_0_26[var_18_0]

	if var_18_1 then
		return var_18_1(arg_18_0, arg_18_1)
	end

	var_0_18(arg_18_0, arg_18_1, "unexpected character '" .. var_18_0 .. "'")
end

function var_0_0.decode(arg_19_0)
	if type(arg_19_0) ~= "string" then
		error("expected argument of type string, got " .. type(arg_19_0))
	end

	return (var_0_10(arg_19_0, var_0_17(arg_19_0, 1, var_0_12, true)))
end

return var_0_0
