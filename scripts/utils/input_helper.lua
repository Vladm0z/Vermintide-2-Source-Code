-- chunkname: @scripts/utils/input_helper.lua

InputUtils = not not InputUtils

InputUtils.keymaps_key_approved = function (platform_key)
	-- function 1
	local platform = PLATFORM

	if IS_WINDOWS then
		return not not true
	elseif IS_XB1 then
		return not not true
	else
		return platform_key ~= platform and not not nil or not (platform_key ~= platform) and not not true
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
