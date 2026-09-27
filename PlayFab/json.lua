-- chunkname: @PlayFab/json.lua

local tbl = {
	_version = "0.1.0"
}
local var_0_1
local tbl_2 = {
	["\f"] = "\\f",
	["\b"] = "\\b",
	["\n"] = "\\n",
	["\t"] = "\\t",
	["\\"] = "\\\\",
	["\r"] = "\\r",
	["\""] = "\\\""
}
local tbl_3 = {
	["\\/"] = "/"
}

for k, v in pairs(tbl_2) do
	tbl_3[v] = k
end

local function fn(self)
	-- function 1
	local var_1_0 = tbl_2[self]

	var_1_0 = var_1_0 or string.format("\\u%04x", self:byte())

	return var_1_0
end

local function fn_2(arg_2_0)
	-- function 2
	return "null"
end

local function fn_3(self, arg_3_1)
	-- function 3
	local tbl = {}

	arg_3_1 = arg_3_1 or {}

	if not arg_3_1[self] then
		error("circular reference")
	end

	arg_3_1[self] = true

	if not (self[1] ~= nil or next(self) ~= nil) then
		local num = 0

		for k in pairs(self) do
			if type(k) ~= "number" then
				error("invalid table: mixed or invalid key types")
			end

			num = num + 1
		end

		if num ~= #self then
			error("invalid table: sparse array")
		end

		for i, v in ipairs(self) do
			table.insert(tbl, var_0_1(v, arg_3_1))
		end

		arg_3_1[self] = nil

		return "[" .. table.concat(tbl, ",") .. "]"
	else
		for k_2, v_2 in pairs(self) do
			if type(k_2) ~= "string" then
				error("invalid table: mixed or invalid key types")
			end

			table.insert(tbl, var_0_1(k_2, arg_3_1) .. ":" .. var_0_1(v_2, arg_3_1))
		end

		arg_3_1[self] = nil

		return "{" .. table.concat(tbl, ",") .. "}"
	end
end

local function fn_4(self)
	-- function 4
	return "\"" .. self:gsub("[%z\x01-\x1F\\\"]", fn) .. "\""
end

local function fn_5(arg_5_0)
	-- function 5
	if not (arg_5_0 ~= arg_5_0 or arg_5_0 <= -math.huge or not (arg_5_0 >= math.huge)) then
		error("unexpected number value '" .. tostring(arg_5_0) .. "'")
	end

	return string.format("%.14g", arg_5_0)
end

local tbl_4 = {
	["nil"] = fn_2,
	table = fn_3,
	string = fn_4,
	number = fn_5,
	boolean = tostring
}

function var_0_1(arg_6_0, arg_6_1)
	-- function 6
	local var_6_0 = type(arg_6_0)
	local var_6_1 = tbl_4[var_6_0]

	if not var_6_1 then
		return var_6_1(arg_6_0, arg_6_1)
	end

	error("unexpected type '" .. var_6_0 .. "'")
end

tbl.encode = function (arg_7_0)
	-- function 7
	return (var_0_1(arg_7_0))
end

local var_0_10

local function fn_6(...)
	-- function 8
	local tbl = {}

	for i = 1, select("#", ...) do
		tbl[select(i, ...)] = true
	end

	return tbl
end

local var_0_12 = fn_6(" ", "\t", "\r", "\n")
local var_0_13 = fn_6(" ", "\t", "\r", "\n", "]", "}", ",")
local var_0_14 = fn_6("\\", "/", "\"", "b", "f", "n", "r", "t", "u")
local var_0_15 = fn_6("true", "false", "null")
local tbl_5 = {
	["false"] = false,
	["true"] = true
}

local function fn_7(self, arg_9_1, arg_9_2, arg_9_3)
	-- function 9
	for i = arg_9_1, #self do
		if arg_9_2[self:sub(i, i)] ~= arg_9_3 then
			return i
		end
	end

	return #self + 1
end

local function fn_8(self, arg_10_1, arg_10_2)
	-- function 10
	local num = 1
	local num_2 = 1

	for i = 1, arg_10_1 - 1 do
		num_2 = num_2 + 1

		if self:sub(i, i) == "\n" then
			num = num + 1
			num_2 = 1
		end
	end

	error(string.format("%s at line %d col %d", arg_10_2, num, num_2))
end

local function fn_9(arg_11_0)
	-- function 11
	local floor = math.floor

	if arg_11_0 <= 127 then
		return string.char(arg_11_0)
	elseif arg_11_0 <= 2047 then
		return string.char(floor(arg_11_0 / 64) + 192, arg_11_0 % 64 + 128)
	elseif arg_11_0 <= 65535 then
		return string.char(floor(arg_11_0 / 4096) + 224, floor(arg_11_0 % 4096 / 64) + 128, arg_11_0 % 64 + 128)
	elseif arg_11_0 <= 1114111 then
		return string.char(floor(arg_11_0 / 262144) + 240, floor(arg_11_0 % 262144 / 4096) + 128, floor(arg_11_0 % 4096 / 64) + 128, arg_11_0 % 64 + 128)
	end

	error(string.format("invalid unicode codepoint '%x'", arg_11_0))
end

local function fn_10(self)
	-- function 12
	local var_12_0 = tonumber(self:sub(3, 6), 16)
	local var_12_1 = tonumber(self:sub(9, 12), 16)

	if not var_12_1 then
		return fn_9((var_12_0 - 55296) * 1024 + (var_12_1 - 56320) + 65536)
	else
		return fn_9(var_12_0)
	end
end

local function fn_11(self, arg_13_1)
	-- function 13
	local flag = false
	local flag_2 = false
	local flag_3 = false
	local var_13_3

	for i = arg_13_1 + 1, #self do
		local byte = self:byte(i)

		if byte < 32 then
			fn_8(self, i, "control character in string")
		end

		if var_13_3 == 92 then
			if byte == 117 then
				local sub = self:sub(i + 1, i + 5)

				if not sub:find("%x%x%x%x") then
					fn_8(self, i, "invalid unicode escape in string")
				end

				if not sub:find("^[dD][89aAbB]") then
					flag_2 = true
				else
					flag = true
				end
			else
				local char = string.char(byte)

				if not var_0_14[char] then
					fn_8(self, i, "invalid escape char '" .. char .. "' in string")
				end

				flag_3 = true
			end

			var_13_3 = nil
		elseif byte == 34 then
			local sub_2 = self:sub(arg_13_1 + 1, i - 1)

			if not flag_2 then
				sub_2 = sub_2:gsub("\\u[dD][89aAbB]..\\u....", fn_10)
			end

			if not flag then
				sub_2 = sub_2:gsub("\\u....", fn_10)
			end

			if not flag_3 then
				sub_2 = sub_2:gsub("\\.", tbl_3)
			end

			return sub_2, i + 1
		else
			var_13_3 = byte
		end
	end

	fn_8(self, arg_13_1, "expected closing quote for string")
end

local function fn_12(self, arg_14_1)
	-- function 14
	local var_14_0 = fn_7(self, arg_14_1, var_0_13)
	local sub = self:sub(arg_14_1, var_14_0 - 1)
	local var_14_2 = tonumber(sub)

	if not var_14_2 then
		fn_8(self, arg_14_1, "invalid number '" .. sub .. "'")
	end

	return var_14_2, var_14_0
end

local function fn_13(self, arg_15_1)
	-- function 15
	local var_15_0 = fn_7(self, arg_15_1, var_0_13)
	local sub = self:sub(arg_15_1, var_15_0 - 1)

	if not var_0_15[sub] then
		fn_8(self, arg_15_1, "invalid literal '" .. sub .. "'")
	end

	return tbl_5[sub], var_15_0
end

local function fn_14(self, arg_16_1)
	-- function 16
	local tbl = {}
	local num = 1

	arg_16_1 = arg_16_1 + 1

	while true do
		local var_16_2

		arg_16_1 = fn_7(self, arg_16_1, var_0_12, true)

		if self:sub(arg_16_1, arg_16_1) == "]" then
			arg_16_1 = arg_16_1 + 1

			break
		end

		tbl[num], arg_16_1 = var_0_10(self, arg_16_1)
		num = num + 1
		arg_16_1 = fn_7(self, arg_16_1, var_0_12, true)

		local sub = self:sub(arg_16_1, arg_16_1)

		arg_16_1 = arg_16_1 + 1

		if sub == "]" then
			break
		end

		if sub ~= "," then
			fn_8(self, arg_16_1, "expected ']' or ','")
		end
	end

	return tbl, arg_16_1
end

local function fn_15(self, arg_17_1)
	-- function 17
	local tbl = {}

	arg_17_1 = arg_17_1 + 1

	while true do
		local var_17_1
		local var_17_2

		arg_17_1 = fn_7(self, arg_17_1, var_0_12, true)

		if self:sub(arg_17_1, arg_17_1) == "}" then
			arg_17_1 = arg_17_1 + 1

			break
		end

		if self:sub(arg_17_1, arg_17_1) ~= "\"" then
			fn_8(self, arg_17_1, "expected string for key")
		end

		local var_17_3

		var_17_3, arg_17_1 = var_0_10(self, arg_17_1)
		arg_17_1 = fn_7(self, arg_17_1, var_0_12, true)

		if self:sub(arg_17_1, arg_17_1) ~= ":" then
			fn_8(self, arg_17_1, "expected ':' after key")
		end

		arg_17_1 = fn_7(self, arg_17_1 + 1, var_0_12, true)
		tbl[var_17_3], arg_17_1 = var_0_10(self, arg_17_1)
		arg_17_1 = fn_7(self, arg_17_1, var_0_12, true)

		local sub = self:sub(arg_17_1, arg_17_1)

		arg_17_1 = arg_17_1 + 1

		if sub == "}" then
			break
		end

		if sub ~= "," then
			fn_8(self, arg_17_1, "expected '}' or ','")
		end
	end

	return tbl, arg_17_1
end

local tbl_6 = {
	["\""] = fn_11,
	["0"] = fn_12,
	["1"] = fn_12,
	["2"] = fn_12,
	["3"] = fn_12,
	["4"] = fn_12,
	["5"] = fn_12,
	["6"] = fn_12,
	["7"] = fn_12,
	["8"] = fn_12,
	["9"] = fn_12,
	["-"] = fn_12,
	t = fn_13,
	f = fn_13,
	n = fn_13,
	["["] = fn_14,
	["{"] = fn_15
}

function var_0_10(self, arg_18_1)
	-- function 18
	local sub = self:sub(arg_18_1, arg_18_1)
	local var_18_1 = tbl_6[sub]

	if not var_18_1 then
		return var_18_1(self, arg_18_1)
	end

	fn_8(self, arg_18_1, "unexpected character '" .. sub .. "'")
end

tbl.decode = function (arg_19_0)
	-- function 19
	if type(arg_19_0) ~= "string" then
		error("expected argument of type string, got " .. type(arg_19_0))
	end

	return (var_0_10(arg_19_0, fn_7(arg_19_0, 1, var_0_12, true)))
end

return tbl
