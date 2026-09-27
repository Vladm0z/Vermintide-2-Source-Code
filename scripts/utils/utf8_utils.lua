-- chunkname: @scripts/utils/utf8_utils.lua

local UTF8Utils = UTF8Utils

UTF8Utils = UTF8Utils or {}
UTF8Utils = UTF8Utils

local location = Utf8.location

Utf8.length = function (arg_1_0)
	-- function 1
	local count = #arg_1_0
	local num = 1

	for i = 1, count do
		local location, var_1_3 = Utf8.location(arg_1_0, num)

		if count < var_1_3 then
			return i
		end

		num = var_1_3
	end

	return 0
end

UTF8Utils.sub_string = function (arg_2_0, arg_2_1, arg_2_2)
	-- function 2
	if #arg_2_0 == 0 then
		return arg_2_0
	end

	local num = UTF8Utils.count_bytes(arg_2_0, arg_2_1 - 1, 1) + 1
	local count_bytes = UTF8Utils.count_bytes(arg_2_0, arg_2_2 - arg_2_1 + 1, num)

	return string.sub(arg_2_0, num, count_bytes)
end

UTF8Utils.count_bytes = function (arg_3_0, arg_3_1, arg_3_2)
	-- function 3
	local count = #arg_3_0
	local var_3_1

	for i = 1, arg_3_1 do
		local var_3_2

		var_3_2, arg_3_2 = location(arg_3_0, arg_3_2)

		if count < arg_3_2 then
			break
		end
	end

	return arg_3_2 - 1
end

UTF8Utils.clamp_byte_length = function (arg_4_0, arg_4_1)
	-- function 4
	if arg_4_1 <= 0 then
		return ""
	end

	if arg_4_1 >= #arg_4_0 then
		return arg_4_0
	end

	local var_4_0 = location(arg_4_0, arg_4_1 + 1)

	return string.sub(arg_4_0, 1, var_4_0 - 1)
end
