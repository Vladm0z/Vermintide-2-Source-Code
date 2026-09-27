-- chunkname: @scripts/utils/input_helper.lua

local InputUtils = InputUtils

InputUtils = InputUtils or {}
InputUtils = InputUtils

InputUtils.keymaps_key_approved = function (arg_1_0)
	-- function 1
	local PLATFORM = PLATFORM

	if not IS_WINDOWS then
		local flag

		flag = arg_1_0 == PLATFORM or arg_1_0 == "xb1" or arg_1_0 == "ps_pad" or true or nil

		return flag
	elseif not IS_XB1 then
		local flag_2

		flag_2 = arg_1_0 == PLATFORM or arg_1_0 == "win32" or true or nil

		return flag_2
	else
		local flag_3

		flag_3 = arg_1_0 ~= PLATFORM or not true or nil

		return flag_3
	end
end

InputUtils.get_platform_keymaps = function (self, arg_2_1)
	-- function 2
	return self[arg_2_1 or PLATFORM]
end

InputUtils.get_platform_filters = function (self, arg_3_1)
	-- function 3
	return self[arg_3_1 or PLATFORM]
end
