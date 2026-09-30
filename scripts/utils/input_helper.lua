-- chunkname: @scripts/utils/input_helper.lua

InputUtils = InputUtils

InputUtils.keymaps_key_approved = function (platform_key)
	-- function 1
	local platform = PLATFORM

	if IS_WINDOWS then
		return true
	elseif IS_XB1 then
		return true
	else
		return not (platform_key ~= platform) or nil
	end
end

InputUtils.get_platform_keymaps = function (keymappings, optional_platform_key)
	-- function 2
	local platform = optional_platform_key or PLATFORM

	return keymappings[platform]
end

InputUtils.get_platform_filters = function (filters, optional_platform_key)
	-- function 3
	local platform = optional_platform_key or PLATFORM

	return filters[platform]
end
