-- chunkname: @foundation/scripts/util/string.lua

local var_0_0 = string.format
local var_0_1 = string.gsub
local var_0_2 = string.sub

function string.starts_with(arg_1_0, arg_1_1)
	return var_0_2(arg_1_0, 1, #arg_1_1) == arg_1_1
end

function string.ends_with(arg_2_0, arg_2_1)
	return arg_2_1 == "" or var_0_2(arg_2_0, -#arg_2_1) == arg_2_1
end

function string.insert(arg_3_0, arg_3_1, arg_3_2)
	return var_0_2(arg_3_0, 1, arg_3_2) .. arg_3_1 .. var_0_2(arg_3_0, arg_3_2 + 1)
end

local var_0_3

local function var_0_4(arg_4_0)
	var_0_3[#var_0_3 + 1] = arg_4_0
end

function string.split_deprecated(arg_5_0, arg_5_1, arg_5_2)
	var_0_3 = arg_5_2 or {}

	local var_5_0 = var_0_0("([^%s]+)", arg_5_1 or " ")

	var_0_1(arg_5_0, var_5_0, var_0_4)

	return var_0_3
end

function string.split(arg_6_0, arg_6_1, arg_6_2, arg_6_3)
	arg_6_1 = arg_6_1 or " "
	arg_6_2 = arg_6_2 or {}

	local var_6_0 = 0

	if arg_6_0 == "" then
		return arg_6_2, var_6_0
	end

	if arg_6_1 == "" then
		local var_6_1 = #arg_6_0

		for iter_6_0 = 1, var_6_1 do
			arg_6_2[iter_6_0] = string.sub(arg_6_0, iter_6_0, iter_6_0)
		end

		return arg_6_2, var_6_1
	end

	local var_6_2 = 1
	local var_6_3, var_6_4 = string.find(arg_6_0, arg_6_1, var_6_2, not arg_6_3)

	while var_6_3 do
		var_6_0 = var_6_0 + 1
		arg_6_2[var_6_0] = string.sub(arg_6_0, var_6_2, var_6_3 - 1)
		var_6_2 = var_6_4 + 1
		var_6_3, var_6_4 = string.find(arg_6_0, arg_6_1, var_6_2, not arg_6_3)
	end

	local var_6_5 = var_6_0 + 1

	arg_6_2[var_6_5] = string.sub(arg_6_0, var_6_2, #arg_6_0)

	return arg_6_2, var_6_5
end

function string.trim(arg_7_0)
	return var_0_1(var_0_1(arg_7_0, "^%s+", ""), "%s+$", "")
end

function string.remove(arg_8_0, arg_8_1, arg_8_2)
	return var_0_2(arg_8_0, 1, arg_8_1 - 1) .. var_0_2(arg_8_0, arg_8_2 + 1)
end

function string.value_or_nil(arg_9_0)
	if arg_9_0 == "" or arg_9_0 == false then
		return nil
	else
		return arg_9_0
	end
end

function string.is_snake_case(arg_10_0)
	if string.ends_with(arg_10_0, "_") then
		return false
	end

	local var_10_0 = string.split_deprecated(arg_10_0, "_")

	for iter_10_0, iter_10_1 in pairs(var_10_0) do
		if string.match(iter_10_1, "%w+") ~= iter_10_1 or iter_10_1:lower() ~= iter_10_1 then
			return false
		end
	end

	return true
end

function string.levenshtein(arg_11_0, arg_11_1)
	local var_11_0 = #arg_11_0
	local var_11_1 = #arg_11_1

	if var_11_0 == 0 then
		return var_11_1
	end

	if var_11_1 == 0 then
		return var_11_0
	end

	if arg_11_0 == arg_11_1 then
		return 0
	end

	local var_11_2 = {}
	local var_11_3 = 1
	local var_11_4 = math.min

	for iter_11_0 = 0, var_11_0 do
		var_11_2[iter_11_0] = {}
		var_11_2[iter_11_0][0] = iter_11_0
	end

	for iter_11_1 = 0, var_11_1 do
		var_11_2[0][iter_11_1] = iter_11_1
	end

	for iter_11_2 = 1, var_11_0 do
		for iter_11_3 = 1, var_11_1 do
			if arg_11_0:byte(iter_11_2) == arg_11_1:byte(iter_11_3) then
				var_11_3 = 0
			end

			var_11_2[iter_11_2][iter_11_3] = var_11_4(var_11_2[iter_11_2 - 1][iter_11_3] + 1, var_11_2[iter_11_2][iter_11_3 - 1] + 1, var_11_2[iter_11_2 - 1][iter_11_3 - 1] + var_11_3)
		end
	end

	return var_11_2[var_11_0][var_11_1]
end

function string.damerau_levenshtein_distance(arg_12_0, arg_12_1, arg_12_2)
	local var_12_0 = #arg_12_0
	local var_12_1 = #arg_12_1

	if arg_12_2 and arg_12_2 <= math.abs(var_12_0 - var_12_1) then
		return arg_12_2
	end

	if type(arg_12_0) == "string" then
		arg_12_0 = {
			string.byte(arg_12_0, 1, var_12_0)
		}
	end

	if type(arg_12_1) == "string" then
		arg_12_1 = {
			string.byte(arg_12_1, 1, var_12_1)
		}
	end

	local var_12_2 = math.min
	local var_12_3 = var_12_1 + 1
	local var_12_4 = {}

	for iter_12_0 = 0, var_12_0 do
		var_12_4[iter_12_0 * var_12_3] = iter_12_0
	end

	for iter_12_1 = 0, var_12_1 do
		var_12_4[iter_12_1] = iter_12_1
	end

	for iter_12_2 = 1, var_12_0 do
		local var_12_5 = iter_12_2 * var_12_3
		local var_12_6 = arg_12_2

		for iter_12_3 = 1, var_12_1 do
			local var_12_7 = arg_12_0[iter_12_2] ~= arg_12_1[iter_12_3] and 1 or 0
			local var_12_8 = var_12_2(var_12_4[var_12_5 - var_12_3 + iter_12_3] + 1, var_12_4[var_12_5 + iter_12_3 - 1] + 1, var_12_4[var_12_5 - var_12_3 + iter_12_3 - 1] + var_12_7)

			var_12_4[var_12_5 + iter_12_3] = var_12_8

			if iter_12_2 > 1 and iter_12_3 > 1 and arg_12_0[iter_12_2] == arg_12_1[iter_12_3 - 1] and arg_12_0[iter_12_2 - 1] == arg_12_1[iter_12_3] then
				var_12_4[var_12_5 + iter_12_3] = var_12_2(var_12_8, var_12_4[var_12_5 - var_12_3 - var_12_3 + iter_12_3 - 2] + var_12_7)
			end

			if arg_12_2 and var_12_8 < var_12_6 then
				var_12_6 = var_12_8
			end
		end

		if arg_12_2 and arg_12_2 <= var_12_6 then
			return arg_12_2
		end
	end

	return var_12_4[#var_12_4]
end

function string.pad_left(arg_13_0, arg_13_1, arg_13_2)
	local var_13_0 = #arg_13_0
	local var_13_1 = #arg_13_2

	for iter_13_0 = var_13_0 + var_13_1, arg_13_1, var_13_1 do
		arg_13_0 = arg_13_2 .. arg_13_0
	end

	local var_13_2 = (arg_13_1 - var_13_0) % var_13_1

	if var_13_2 ~= 0 then
		arg_13_0 = string.sub(arg_13_2, var_13_1 - var_13_2 + 1, var_13_1) .. arg_13_0
	end

	return arg_13_0
end

function string.pad_right(arg_14_0, arg_14_1, arg_14_2, arg_14_3)
	local var_14_0 = #arg_14_0
	local var_14_1 = #arg_14_2

	if arg_14_3 then
		local var_14_2 = math.max(0, arg_14_1 - var_14_0)
		local var_14_3 = arg_14_3[var_14_2]

		if var_14_3 then
			return arg_14_0 .. var_14_3
		end

		arg_14_3[var_14_2] = string.pad_right("", var_14_2, arg_14_2)

		return arg_14_0 .. arg_14_3[var_14_2]
	end

	local var_14_4 = ""

	for iter_14_0 = var_14_0 + var_14_1, arg_14_1, var_14_1 do
		var_14_4 = var_14_4 .. arg_14_2
	end

	local var_14_5 = (arg_14_1 - var_14_0) % var_14_1

	if var_14_5 ~= 0 then
		var_14_4 = var_14_4 .. string.sub(arg_14_2, 1, var_14_5)
	end

	return arg_14_0 .. var_14_4
end

function string.rep(arg_15_0, arg_15_1)
	local var_15_0 = ""

	for iter_15_0 = 1, arg_15_1 do
		var_15_0 = var_15_0 .. arg_15_0
	end

	return var_15_0
end

local var_0_5 = {}

function string.chunk_from_right(arg_16_0, arg_16_1, arg_16_2)
	arg_16_2 = arg_16_2 or " "

	local var_16_0 = #arg_16_0
	local var_16_1 = math.floor(var_16_0 / arg_16_1)
	local var_16_2 = 0
	local var_16_3 = var_16_0 % arg_16_1

	if var_16_3 > 0 then
		var_0_5[1] = string.sub(arg_16_0, 1, var_16_3)
		var_16_2 = 1
	end

	for iter_16_0 = 1, var_16_1 do
		var_0_5[var_16_1 - iter_16_0 + 1 + var_16_2] = string.sub(arg_16_0, -iter_16_0 * arg_16_1, -(iter_16_0 - 1) * arg_16_1 - 1)
	end

	local var_16_4 = table.concat(var_0_5, arg_16_2)

	table.clear(var_0_5)

	return var_16_4
end

local function var_0_6(arg_17_0)
	return var_0_0("%02x", string.byte(arg_17_0))
end

function string.tohex(arg_18_0)
	return var_0_1(arg_18_0, ".", var_0_6)
end
