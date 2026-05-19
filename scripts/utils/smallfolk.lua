-- chunkname: @scripts/utils/smallfolk.lua

local var_0_0 = "\tCopyright (c) 2014 Robin Wellner\n\t\n\tPermission is hereby granted, free of charge, to any person obtaining a\n\tcopy of this software and associated documentation files (the\n\t\"Software\"), to deal in the Software without restriction, including\n\twithout limitation the rights to use, copy, modify, merge, publish,\n\tdistribute, sublicense, and/or sell copies of the Software, and to\n\tpermit persons to whom the Software is furnished to do so, subject to\n\tthe following conditions:\n\n\tThe above copyright notice and this permission notice shall be included\n\tin all copies or substantial portions of the Software.\n\n\tTHE SOFTWARE IS PROVIDED \"AS IS\", WITHOUT WARRANTY OF ANY KIND, EXPRESS\n\tOR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF\n\tMERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.\n\tIN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY\n\tCLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,\n\tTORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE\n\tSOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.\n"
local var_0_1 = {}
local var_0_2
local var_0_3
local var_0_4 = error
local var_0_5 = tostring
local var_0_6 = pairs
local var_0_7 = type
local var_0_8 = math.floor
local var_0_9 = math.huge
local var_0_10 = table.concat
local var_0_11 = {
	string = function(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
		local var_1_0 = #arg_1_3

		arg_1_3[var_1_0 + 1] = "\""
		arg_1_3[var_1_0 + 2] = arg_1_0:gsub("\"", "\"\"")
		arg_1_3[var_1_0 + 3] = "\""

		return arg_1_1
	end,
	number = function(arg_2_0, arg_2_1, arg_2_2, arg_2_3)
		arg_2_3[#arg_2_3 + 1] = ("%.17g"):format(arg_2_0)

		return arg_2_1
	end,
	table = function(arg_3_0, arg_3_1, arg_3_2, arg_3_3)
		if arg_3_2[arg_3_0] then
			arg_3_3[#arg_3_3 + 1] = "@"
			arg_3_3[#arg_3_3 + 1] = var_0_5(arg_3_2[arg_3_0])

			return arg_3_1
		end

		arg_3_1 = arg_3_1 + 1
		arg_3_2[arg_3_0] = arg_3_1
		arg_3_3[#arg_3_3 + 1] = "{"

		local var_3_0 = #arg_3_0

		for iter_3_0 = 1, var_3_0 do
			arg_3_1 = var_0_3(arg_3_0[iter_3_0], arg_3_1, arg_3_2, arg_3_3)
			arg_3_3[#arg_3_3 + 1] = ","
		end

		for iter_3_1, iter_3_2 in var_0_6(arg_3_0) do
			if var_0_7(iter_3_1) ~= "number" or var_0_8(iter_3_1) ~= iter_3_1 or iter_3_1 < 1 or var_3_0 < iter_3_1 then
				arg_3_1 = var_0_3(iter_3_1, arg_3_1, arg_3_2, arg_3_3)
				arg_3_3[#arg_3_3 + 1] = ":"
				arg_3_1 = var_0_3(iter_3_2, arg_3_1, arg_3_2, arg_3_3)
				arg_3_3[#arg_3_3 + 1] = ","
			end
		end

		arg_3_3[#arg_3_3] = arg_3_3[#arg_3_3] == "{" and "{}" or "}"

		return arg_3_1
	end
}

function var_0_3(arg_4_0, arg_4_1, arg_4_2, arg_4_3)
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
	elseif arg_4_0 == var_0_9 then
		arg_4_3[#arg_4_3 + 1] = "I"
	elseif arg_4_0 == -var_0_9 then
		arg_4_3[#arg_4_3 + 1] = "i"
	else
		local var_4_0 = var_0_7(arg_4_0)

		if not var_0_11[var_4_0] then
			var_0_4("cannot dump type " .. var_4_0)
		end

		return var_0_11[var_4_0](arg_4_0, arg_4_1, arg_4_2, arg_4_3)
	end

	return arg_4_1
end

function var_0_1.dumps(arg_5_0)
	local var_5_0 = 0
	local var_5_1 = {}
	local var_5_2 = {}

	var_0_3(arg_5_0, var_5_0, var_5_1, var_5_2)

	return var_0_10(var_5_2)
end

local function var_0_12(arg_6_0)
	var_0_4("invalid input at position " .. arg_6_0)
end

local var_0_13 = {
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
local var_0_14 = {
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

local function var_0_15(arg_7_0, arg_7_1)
	local var_7_0 = arg_7_1
	local var_7_1 = arg_7_0:sub(var_7_0, var_7_0)

	if var_7_1 == "-" then
		var_7_0 = var_7_0 + 1
		var_7_1 = arg_7_0:sub(var_7_0, var_7_0)
	end

	if var_0_13[var_7_1] then
		repeat
			var_7_0 = var_7_0 + 1
			var_7_1 = arg_7_0:sub(var_7_0, var_7_0)
		until not var_0_14[var_7_1]
	elseif var_7_1 == "0" then
		var_7_0 = var_7_0 + 1
		var_7_1 = arg_7_0:sub(var_7_0, var_7_0)
	else
		var_0_12(var_7_0)
	end

	if var_7_1 == "." then
		local var_7_2 = var_7_0

		repeat
			var_7_0 = var_7_0 + 1
			var_7_1 = arg_7_0:sub(var_7_0, var_7_0)
		until not var_0_14[var_7_1]

		if var_7_0 == var_7_2 + 1 then
			var_0_12(var_7_0)
		end
	end

	if var_7_1 == "e" or var_7_1 == "E" then
		var_7_0 = var_7_0 + 1

		local var_7_3 = arg_7_0:sub(var_7_0, var_7_0)

		if var_7_3 == "+" or var_7_3 == "-" then
			var_7_0 = var_7_0 + 1
			var_7_3 = arg_7_0:sub(var_7_0, var_7_0)
		end

		if not var_0_14[var_7_3] then
			var_0_12(var_7_0)
		end

		repeat
			var_7_0 = var_7_0 + 1

			local var_7_4 = arg_7_0:sub(var_7_0, var_7_0)
		until not var_0_14[var_7_4]
	end

	return tonumber(arg_7_0:sub(arg_7_1, var_7_0 - 1)), var_7_0
end

local var_0_16 = {
	t = function(arg_8_0, arg_8_1)
		return true, arg_8_1
	end,
	f = function(arg_9_0, arg_9_1)
		return false, arg_9_1
	end,
	n = function(arg_10_0, arg_10_1)
		return nil, arg_10_1
	end,
	Q = function(arg_11_0, arg_11_1)
		return -(0 / 0), arg_11_1
	end,
	N = function(arg_12_0, arg_12_1)
		return 0 / 0, arg_12_1
	end,
	I = function(arg_13_0, arg_13_1)
		return 1 / 0, arg_13_1
	end,
	i = function(arg_14_0, arg_14_1)
		return -1 / 0, arg_14_1
	end,
	["\""] = function(arg_15_0, arg_15_1)
		local var_15_0 = arg_15_1 - 1

		repeat
			var_15_0 = arg_15_0:find("\"", var_15_0 + 1, true) + 1
		until arg_15_0:sub(var_15_0, var_15_0) ~= "\""

		return arg_15_0:sub(arg_15_1, var_15_0 - 2):gsub("\"\"", "\""), var_15_0
	end,
	["0"] = function(arg_16_0, arg_16_1)
		return var_0_15(arg_16_0, arg_16_1 - 1)
	end,
	["{"] = function(arg_17_0, arg_17_1, arg_17_2)
		local var_17_0 = {}
		local var_17_1
		local var_17_2
		local var_17_3 = 1

		arg_17_2[#arg_17_2 + 1] = var_17_0

		if arg_17_0:sub(arg_17_1, arg_17_1) == "}" then
			return var_17_0, arg_17_1 + 1
		end

		while true do
			local var_17_4

			var_17_4, arg_17_1 = var_0_2(arg_17_0, arg_17_1, arg_17_2)

			if arg_17_0:sub(arg_17_1, arg_17_1) == ":" then
				var_17_0[var_17_4], arg_17_1 = var_0_2(arg_17_0, arg_17_1 + 1, arg_17_2)
			else
				var_17_0[var_17_3] = var_17_4
				var_17_3 = var_17_3 + 1
			end

			local var_17_5 = arg_17_0:sub(arg_17_1, arg_17_1)

			if var_17_5 == "," then
				arg_17_1 = arg_17_1 + 1
			elseif var_17_5 == "}" then
				return var_17_0, arg_17_1 + 1
			else
				var_0_12(arg_17_1)
			end
		end
	end,
	["@"] = function(arg_18_0, arg_18_1, arg_18_2)
		local var_18_0 = arg_18_0:match("^%d+", arg_18_1)
		local var_18_1 = tonumber(var_18_0)

		if arg_18_2[var_18_1] then
			return arg_18_2[var_18_1], arg_18_1 + #var_18_0
		end

		var_0_12(arg_18_1)
	end
}

var_0_16["1"] = var_0_16["0"]
var_0_16["2"] = var_0_16["0"]
var_0_16["3"] = var_0_16["0"]
var_0_16["4"] = var_0_16["0"]
var_0_16["5"] = var_0_16["0"]
var_0_16["6"] = var_0_16["0"]
var_0_16["7"] = var_0_16["0"]
var_0_16["8"] = var_0_16["0"]
var_0_16["9"] = var_0_16["0"]
var_0_16["-"] = var_0_16["0"]
var_0_16["."] = var_0_16["0"]

function var_0_2(arg_19_0, arg_19_1, arg_19_2)
	local var_19_0 = arg_19_0:sub(arg_19_1, arg_19_1)

	if var_0_16[var_19_0] then
		return var_0_16[var_19_0](arg_19_0, arg_19_1 + 1, arg_19_2)
	end

	var_0_12(arg_19_1)
end

function var_0_1.loads(arg_20_0, arg_20_1)
	if #arg_20_0 > (arg_20_1 or 10000) then
		var_0_4("input too large")
	end

	return (var_0_2(arg_20_0, 1, {}))
end

return var_0_1
