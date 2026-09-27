-- chunkname: @foundation/scripts/util/string.lua

local format = string.format
local gsub = string.gsub
local sub = string.sub

string.starts_with = function (arg_1_0, arg_1_1)
	-- function 1
	return sub(arg_1_0, 1, #arg_1_1) == arg_1_1
end

string.ends_with = function (arg_2_0, arg_2_1)
	-- function 2
	return arg_2_1 == "" or sub(arg_2_0, -#arg_2_1) == arg_2_1
end

string.insert = function (arg_3_0, arg_3_1, arg_3_2)
	-- function 3
	return sub(arg_3_0, 1, arg_3_2) .. arg_3_1 .. sub(arg_3_0, arg_3_2 + 1)
end

local var_0_3

local function fn(arg_4_0)
	-- function 4
	var_0_3[#var_0_3 + 1] = arg_4_0
end

string.split_deprecated = function (arg_5_0, arg_5_1, arg_5_2)
	-- function 5
	var_0_3 = arg_5_2 or {}

	local var_5_0 = format("([^%s]+)", arg_5_1 or " ")

	gsub(arg_5_0, var_5_0, fn)

	return var_0_3
end

string.split = function (arg_6_0, arg_6_1, arg_6_2, arg_6_3)
	-- function 6
	arg_6_1 = arg_6_1 or " "
	arg_6_2 = arg_6_2 or {}

	local num = 0

	if arg_6_0 == "" then
		return arg_6_2, num
	end

	if arg_6_1 == "" then
		local count = #arg_6_0

		for i = 1, count do
			arg_6_2[i] = string.sub(arg_6_0, i, i)
		end

		return arg_6_2, count
	end

	local num_2 = 1
	local find, var_6_4 = string.find(arg_6_0, arg_6_1, num_2, not arg_6_3)

	while not find do
		num = num + 1
		arg_6_2[num] = string.sub(arg_6_0, num_2, find - 1)
		num_2 = var_6_4 + 1
		find, var_6_4 = string.find(arg_6_0, arg_6_1, num_2, not arg_6_3)
	end

	local num_3 = num + 1

	arg_6_2[num_3] = string.sub(arg_6_0, num_2, #arg_6_0)

	return arg_6_2, num_3
end

string.trim = function (arg_7_0)
	-- function 7
	return gsub(gsub(arg_7_0, "^%s+", ""), "%s+$", "")
end

string.remove = function (arg_8_0, arg_8_1, arg_8_2)
	-- function 8
	return sub(arg_8_0, 1, arg_8_1 - 1) .. sub(arg_8_0, arg_8_2 + 1)
end

string.value_or_nil = function (arg_9_0)
	-- function 9
	if not (arg_9_0 == "" or arg_9_0 ~= false) then
		return nil
	else
		return arg_9_0
	end
end

string.is_snake_case = function (arg_10_0)
	-- function 10
	if not string.ends_with(arg_10_0, "_") then
		return false
	end

	local split_deprecated = string.split_deprecated(arg_10_0, "_")

	for k, v in pairs(split_deprecated) do
		if not (string.match(v, "%w+") ~= v or v:lower() == v) then
			return false
		end
	end

	return true
end

string.levenshtein = function (self, arg_11_1)
	-- function 11
	local count = #self
	local count_2 = #arg_11_1

	if count == 0 then
		return count_2
	end

	if count_2 == 0 then
		return count
	end

	if self == arg_11_1 then
		return 0
	end

	local tbl = {}
	local num = 1
	local min = math.min

	for i = 0, count do
		tbl[i] = {}
		tbl[i][0] = i
	end

	for j = 0, count_2 do
		tbl[0][j] = j
	end

	for k = 1, count do
		for l = 1, count_2 do
			if self:byte(k) == arg_11_1:byte(l) then
				num = 0
			end

			tbl[k][l] = min(tbl[k - 1][l] + 1, tbl[k][l - 1] + 1, tbl[k - 1][l - 1] + num)
		end
	end

	return tbl[count][count_2]
end

string.damerau_levenshtein_distance = function (self, arg_12_1, arg_12_2)
	-- function 12
	local count = #self
	local count_2 = #arg_12_1

	if not (not arg_12_2 and not (arg_12_2 <= math.abs(count - count_2))) then
		return arg_12_2
	end

	if type(self) == "string" then
		self = {
			string.byte(self, 1, count)
		}
	end

	if type(arg_12_1) == "string" then
		arg_12_1 = {
			string.byte(arg_12_1, 1, count_2)
		}
	end

	local min = math.min
	local num = count_2 + 1
	local tbl = {}

	for i = 0, count do
		tbl[i * num] = i
	end

	for j = 0, count_2 do
		tbl[j] = j
	end

	for k = 1, count do
		local num_2 = k * num
		local var_12_6 = arg_12_2

		for l = 1, count_2 do
			local flag

			flag = self[k] == arg_12_1[l] or not 1 or 0

			local var_12_8 = min(tbl[num_2 - num + l] + 1, tbl[num_2 + l - 1] + 1, tbl[num_2 - num + l - 1] + flag)

			tbl[num_2 + l] = var_12_8

			if not (not (k > 1) or not (l > 1) or self[k] ~= arg_12_1[l - 1] or self[k - 1] ~= arg_12_1[l]) then
				tbl[num_2 + l] = min(var_12_8, tbl[num_2 - num - num + l - 2] + flag)
			end

			if not (not arg_12_2 and not (var_12_8 < var_12_6)) then
				var_12_6 = var_12_8
			end
		end

		if not (not arg_12_2 and not (arg_12_2 <= var_12_6)) then
			return arg_12_2
		end
	end

	return tbl[#tbl]
end

string.pad_left = function (arg_13_0, arg_13_1, arg_13_2)
	-- function 13
	local count = #arg_13_0
	local count_2 = #arg_13_2

	for i = count + count_2, arg_13_1, count_2 do
		arg_13_0 = arg_13_2 .. arg_13_0
	end

	local num = (arg_13_1 - count) % count_2

	if num ~= 0 then
		arg_13_0 = string.sub(arg_13_2, count_2 - num + 1, count_2) .. arg_13_0
	end

	return arg_13_0
end

string.pad_right = function (arg_14_0, arg_14_1, arg_14_2, arg_14_3)
	-- function 14
	local count = #arg_14_0
	local count_2 = #arg_14_2

	if not arg_14_3 then
		local max = math.max(0, arg_14_1 - count)
		local var_14_3 = arg_14_3[max]

		if not var_14_3 then
			return arg_14_0 .. var_14_3
		end

		arg_14_3[max] = string.pad_right("", max, arg_14_2)

		return arg_14_0 .. arg_14_3[max]
	end

	local str = ""

	for i = count + count_2, arg_14_1, count_2 do
		str = str .. arg_14_2
	end

	local num = (arg_14_1 - count) % count_2

	if num ~= 0 then
		str = str .. string.sub(arg_14_2, 1, num)
	end

	return arg_14_0 .. str
end

string.rep = function (arg_15_0, arg_15_1)
	-- function 15
	local str = ""

	for i = 1, arg_15_1 do
		str = str .. arg_15_0
	end

	return str
end

local tbl = {}

string.chunk_from_right = function (arg_16_0, arg_16_1, arg_16_2)
	-- function 16
	arg_16_2 = arg_16_2 or " "

	local count = #arg_16_0
	local floor = math.floor(count / arg_16_1)
	local num = 0
	local num_2 = count % arg_16_1

	if num_2 > 0 then
		tbl[1] = string.sub(arg_16_0, 1, num_2)
		num = 1
	end

	for i = 1, floor do
		tbl[floor - i + 1 + num] = string.sub(arg_16_0, -i * arg_16_1, -(i - 1) * arg_16_1 - 1)
	end

	local concat = table.concat(tbl, arg_16_2)

	table.clear(tbl)

	return concat
end

local function fn_2(arg_17_0)
	-- function 17
	return format("%02x", string.byte(arg_17_0))
end

string.tohex = function (arg_18_0)
	-- function 18
	return gsub(arg_18_0, ".", fn_2)
end
