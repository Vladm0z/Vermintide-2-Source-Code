-- chunkname: @scripts/utils/utf8_utils.lua

UTF8Utils = UTF8Utils or {}

UTF8Utils.string_length = function (arg_1_0)
	local var_1_0 = #arg_1_0
	local var_1_1 = 1
	local var_1_2 = 0
	local var_1_3

	while var_1_1 <= var_1_0 do
		local var_1_4

		var_1_4, var_1_1 = Utf8.location(arg_1_0, var_1_1)
		var_1_2 = var_1_2 + 1
	end

	return var_1_2
end

UTF8Utils.sub_string = function (arg_2_0, arg_2_1, arg_2_2)
	if arg_2_2 <= 0 or arg_2_0 == "" then
		return ""
	end

	local var_2_0 = 1
	local var_2_1 = #arg_2_0
	local var_2_2 = -1
	local var_2_3 = -1
	local var_2_4 = 1

	while var_2_0 <= var_2_1 do
		local var_2_5, var_2_6 = Utf8.location(arg_2_0, var_2_0)

		if var_2_4 == arg_2_1 then
			var_2_2 = var_2_5
		end

		if var_2_4 == arg_2_2 then
			var_2_3 = var_2_6 - 1

			break
		end

		var_2_4 = var_2_4 + 1
		var_2_0 = var_2_6
	end

	if var_2_2 then
		return string.sub(arg_2_0, var_2_2, var_2_3)
	else
		return ""
	end
end
