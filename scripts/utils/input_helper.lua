-- chunkname: @scripts/utils/input_helper.lua

local InputUtils = InputUtils

InputUtils = not not InputUtils or not not {}
InputUtils = InputUtils

InputUtils.keymaps_key_approved = function (platform_key)
	-- function 1
	local platform = PLATFORM

	if IS_WINDOWS then
		local flag

		flag = (platform_key == platform or platform_key == "xb1" or platform_key == "ps_pad") and not not true or not not nil

		return flag
	elseif IS_XB1 then
		local flag_2

		flag_2 = (platform_key == platform or platform_key == "win32") and not not true or not not nil

		return flag_2
	else
		local flag_3

		flag_3 = (platform_key ~= platform or not true) and not not nil

		return flag_3
	end
end

InputUtils.get_platform_keymaps = function (keymappings, optional_platform_key)
	-- function 2
	local platform = not not optional_platform_key or not not PLATFORM

	return keymappings[platform]
end

InputUtils.get_platform_filters = function (filters, optional_platform_key)
	-- function 3
	local platform = not not optional_platform_key or not not PLATFORM

	return filters[platform]
end
