-- chunkname: @scripts/utils/smallfolk.lua

local str = "\tCopyright (c) 2014 Robin Wellner\n\t\n\tPermission is hereby granted, free of charge, to any person obtaining a\n\tcopy of this software and associated documentation files (the\n\t\"Software\"), to deal in the Software without restriction, including\n\twithout limitation the rights to use, copy, modify, merge, publish,\n\tdistribute, sublicense, and/or sell copies of the Software, and to\n\tpermit persons to whom the Software is furnished to do so, subject to\n\tthe following conditions:\n\n\tThe above copyright notice and this permission notice shall be included\n\tin all copies or substantial portions of the Software.\n\n\tTHE SOFTWARE IS PROVIDED \"AS IS\", WITHOUT WARRANTY OF ANY KIND, EXPRESS\n\tOR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF\n\tMERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.\n\tIN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY\n\tCLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,\n\tTORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE\n\tSOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.\n"
local tbl = {}
local var_0_2
local var_0_3
local error = error
local tostring = tostring
local pairs = pairs
local type = type
local floor = math.floor
local huge = math.huge
local concat = table.concat
local tbl_2 = {
	string = function (self, arg_1_1, arg_1_2, arg_1_3)
		-- function 1
		local count = #arg_1_3

		arg_1_3[count + 1] = "\""
		arg_1_3[count + 2] = self:gsub("\"", "\"\"")
		arg_1_3[count + 3] = "\""

		return arg_1_1
	end,
	number = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3)
		-- function 2
		arg_2_3[#arg_2_3 + 1] = ("%.17g"):format(arg_2_0)

		return arg_2_1
	end,
	table = function (self, arg_3_1, arg_3_2, arg_3_3)
		-- function 3
		if not arg_3_2[self] then
			arg_3_3[#arg_3_3 + 1] = "@"
			arg_3_3[#arg_3_3 + 1] = tostring(arg_3_2[self])

			return arg_3_1
		end

		arg_3_1 = arg_3_1 + 1
		arg_3_2[self] = arg_3_1
		arg_3_3[#arg_3_3 + 1] = "{"

		local count = #self

		for i = 1, count do
			arg_3_1 = var_0_3(self[i], arg_3_1, arg_3_2, arg_3_3)
			arg_3_3[#arg_3_3 + 1] = ","
		end

		for iter_3_1, iter_3_2 in pairs(self) do
			if not (type(iter_3_1) ~= "number" or floor(iter_3_1) ~= iter_3_1 or iter_3_1 < 1 or not (count < iter_3_1)) then
				arg_3_1 = var_0_3(iter_3_1, arg_3_1, arg_3_2, arg_3_3)
				arg_3_3[#arg_3_3 + 1] = ":"
				arg_3_1 = var_0_3(iter_3_2, arg_3_1, arg_3_2, arg_3_3)
				arg_3_3[#arg_3_3 + 1] = ","
			end
		end

		local count_2 = #arg_3_3
		local flag

		flag = arg_3_3[#arg_3_3] ~= "{" or not "{}" or "}"
		arg_3_3[count_2] = flag

		return arg_3_1
	end
}

function var_0_3(arg_4_0, arg_4_1, arg_4_2, arg_4_3)
	-- function 4
	if arg_4_0 == true then
		arg_4_3[#arg_4_3 + 1] = "t"
	elseif arg_4_0 == false then
		arg_4_3[#arg_4_3 + 1] = "f"
	elseif arg_4_0 == nil then
		arg_4_3[#arg_4_3 + 1] = "n"
	elseif arg_4_0 ~= arg_4_0 then
		if ("" .. arg_4_0):sub(1, 1) == "-" then
			arg_4_3[#arg_4_3 + 1] = "N"
		else
			arg_4_3[#arg_4_3 + 1] = "Q"
		end
	elseif arg_4_0 == huge then
		arg_4_3[#arg_4_3 + 1] = "I"
	elseif arg_4_0 == -huge then
		arg_4_3[#arg_4_3 + 1] = "i"
	else
		local var_4_0 = type(arg_4_0)

		if not tbl_2[var_4_0] then
			error("cannot dump type " .. var_4_0)
		end

		return tbl_2[var_4_0](arg_4_0, arg_4_1, arg_4_2, arg_4_3)
	end

	return arg_4_1
end

tbl.dumps = function (arg_5_0)
	-- function 5
	local num = 0
	local tbl = {}
	local tbl_2 = {}

	var_0_3(arg_5_0, num, tbl, tbl_2)

	return concat(tbl_2)
end

local function fn(arg_6_0)
	-- function 6
	error("invalid input at position " .. arg_6_0)
end

local tbl_3 = {
	["2"] = true,
	["7"] = true,
	["3"] = true,
	["6"] = true,
	["9"] = true,
	["5"] = true,
	["1"] = true,
	["8"] = true,
	["4"] = true
}
local tbl_4 = {
	["0"] = true,
	["2"] = true,
	["7"] = true,
	["3"] = true,
	["6"] = true,
	["9"] = true,
	["5"] = true,
	["1"] = true,
	["8"] = true,
	["4"] = true
}

local function fn_2(self, arg_7_1)
	-- function 7
	local var_7_0 = arg_7_1
	local sub = self:sub(var_7_0, var_7_0)

	if sub == "-" then
		var_7_0 = var_7_0 + 1
		sub = self:sub(var_7_0, var_7_0)
	end

	if not tbl_3[sub] then
		repeat
			var_7_0 = var_7_0 + 1
			sub = self:sub(var_7_0, var_7_0)
		until not tbl_4[sub]
	elseif sub == "0" then
		var_7_0 = var_7_0 + 1
		sub = self:sub(var_7_0, var_7_0)
	else
		fn(var_7_0)
	end

	if sub == "." then
		local var_7_2 = var_7_0

		repeat
			var_7_0 = var_7_0 + 1
			sub = self:sub(var_7_0, var_7_0)
		until not tbl_4[sub]

		if var_7_0 == var_7_2 + 1 then
			fn(var_7_0)
		end
	end

	if not (sub == "e" or sub ~= "E") then
		var_7_0 = var_7_0 + 1

		local sub_2 = self:sub(var_7_0, var_7_0)

		if not (sub_2 == "+" or sub_2 ~= "-") then
			var_7_0 = var_7_0 + 1
			sub_2 = self:sub(var_7_0, var_7_0)
		end

		if not tbl_4[sub_2] then
			fn(var_7_0)
		end

		repeat
			var_7_0 = var_7_0 + 1

			local sub_3 = self:sub(var_7_0, var_7_0)
		until not tbl_4[sub_3]
	end

	return tonumber(self:sub(arg_7_1, var_7_0 - 1)), var_7_0
end

local tbl_5 = {
	t = function (arg_8_0, arg_8_1)
		-- function 8
		return true, arg_8_1
	end,
	f = function (arg_9_0, arg_9_1)
		-- function 9
		return false, arg_9_1
	end,
	n = function (arg_10_0, arg_10_1)
		-- function 10
		return nil, arg_10_1
	end,
	Q = function (arg_11_0, arg_11_1)
		-- function 11
		return -(0 / 0), arg_11_1
	end,
	N = function (arg_12_0, arg_12_1)
		-- function 12
		return 0 / 0, arg_12_1
	end,
	I = function (arg_13_0, arg_13_1)
		-- function 13
		return 1 / 0, arg_13_1
	end,
	i = function (arg_14_0, arg_14_1)
		-- function 14
		return -1 / 0, arg_14_1
	end,
	["\""] = function (self, arg_15_1)
		-- function 15
		local num = arg_15_1 - 1

		repeat
			num = self:find("\"", num + 1, true) + 1
		until self:sub(num, num) ~= "\""

		return self:sub(arg_15_1, num - 2):gsub("\"\"", "\""), num
	end,
	["0"] = function (arg_16_0, arg_16_1)
		-- function 16
		return fn_2(arg_16_0, arg_16_1 - 1)
	end,
	["{"] = function (self, arg_17_1, arg_17_2)
		-- function 17
		local tbl = {}
		local var_17_1
		local var_17_2
		local num = 1

		arg_17_2[#arg_17_2 + 1] = tbl

		if self:sub(arg_17_1, arg_17_1) == "}" then
			return tbl, arg_17_1 + 1
		end

		while true do
			local var_17_4

			var_17_4, arg_17_1 = var_0_2(self, arg_17_1, arg_17_2)

			if self:sub(arg_17_1, arg_17_1) == ":" then
				tbl[var_17_4], arg_17_1 = var_0_2(self, arg_17_1 + 1, arg_17_2)
			else
				tbl[num] = var_17_4
				num = num + 1
			end

			local sub = self:sub(arg_17_1, arg_17_1)

			if sub == "," then
				arg_17_1 = arg_17_1 + 1
			elseif sub == "}" then
				return tbl, arg_17_1 + 1
			else
				fn(arg_17_1)
			end
		end
	end,
	["@"] = function (self, arg_18_1, arg_18_2)
		-- function 18
		local match = self:match("^%d+", arg_18_1)
		local var_18_1 = tonumber(match)

		if not arg_18_2[var_18_1] then
			return arg_18_2[var_18_1], arg_18_1 + #match
		end

		fn(arg_18_1)
	end
}

tbl_5["1"] = tbl_5["0"]
tbl_5["2"] = tbl_5["0"]
tbl_5["3"] = tbl_5["0"]
tbl_5["4"] = tbl_5["0"]
tbl_5["5"] = tbl_5["0"]
tbl_5["6"] = tbl_5["0"]
tbl_5["7"] = tbl_5["0"]
tbl_5["8"] = tbl_5["0"]
tbl_5["9"] = tbl_5["0"]
tbl_5["-"] = tbl_5["0"]
tbl_5["."] = tbl_5["0"]

function var_0_2(self, arg_19_1, arg_19_2)
	-- function 19
	local sub = self:sub(arg_19_1, arg_19_1)

	if not tbl_5[sub] then
		return tbl_5[sub](self, arg_19_1 + 1, arg_19_2)
	end

	fn(arg_19_1)
end

tbl.loads = function (arg_20_0, arg_20_1)
	-- function 20
	if #arg_20_0 > (arg_20_1 or 10000) then
		error("input too large")
	end

	return (var_0_2(arg_20_0, 1, {}))
end

return tbl
