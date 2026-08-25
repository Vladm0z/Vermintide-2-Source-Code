-- chunkname: @scripts/utils/utf8_utils.lua

UTF8Utils = UTF8Utils or {}

local var_0_0 = Utf8.location

function Utf8.length(arg_1_0)
	local var_1_0 = #arg_1_0
	local var_1_1 = 1

	for iter_1_0 = 1, var_1_0 do
		local var_1_2, var_1_3 = Utf8.location(arg_1_0, var_1_1)

		if var_1_0 < var_1_3 then
			return iter_1_0
		end

		var_1_1 = var_1_3
	end

	return 0
end

function UTF8Utils.sub_string(arg_2_0, arg_2_1, arg_2_2)
	if #arg_2_0 == 0 then
		return arg_2_0
	end

	local var_2_0 = UTF8Utils.count_bytes(arg_2_0, arg_2_1 - 1, 1) + 1
	local var_2_1 = UTF8Utils.count_bytes(arg_2_0, arg_2_2 - arg_2_1 + 1, var_2_0)

	return string.sub(arg_2_0, var_2_0, var_2_1)
end

function UTF8Utils.count_bytes(arg_3_0, arg_3_1, arg_3_2)
	local var_3_0 = #arg_3_0
	local var_3_1

	for iter_3_0 = 1, arg_3_1 do
		local var_3_2

		var_3_2, arg_3_2 = var_0_0(arg_3_0, arg_3_2)

		if var_3_0 < arg_3_2 then
			break
		end
	end

	return arg_3_2 - 1
end

function UTF8Utils.clamp_byte_length(arg_4_0, arg_4_1)
	if arg_4_1 <= 0 then
		return ""
	end

	if arg_4_1 >= #arg_4_0 then
		return arg_4_0
	end

	local var_4_0 = var_0_0(arg_4_0, arg_4_1 + 1)

	return string.sub(arg_4_0, 1, var_4_0 - 1)
end
