-- chunkname: @scripts/helpers/weave_utils.lua

local WeaveUtils = WeaveUtils

WeaveUtils = WeaveUtils or {}
WeaveUtils = WeaveUtils

WeaveUtils.get_rating = function (arg_1_0)
	-- function 1
	local rating_values = WeaveSettings.rating_values
	local num = 5
	local num_2 = 0

	if not arg_1_0 then
		for i = 1, #rating_values do
			if arg_1_0 > rating_values[i] then
				num_2 = num - i + 1

				break
			end
		end
	end

	return num_2
end

WeaveUtils.magic_level_to_power_level = function (arg_2_0)
	-- function 2
	local PowerLevelFromMagicLevel = PowerLevelFromMagicLevel

	return math.min(math.ceil(PowerLevelFromMagicLevel.starting_power_level + arg_2_0 * PowerLevelFromMagicLevel.power_level_per_magic_level), PowerLevelFromMagicLevel.max_power_level)
end

WeaveUtils.weave_equivalent_item_unlocked = function (arg_3_0)
	-- function 3
	local var_3_0 = MagicItemByUnlockName[arg_3_0]
	local get_item_from_key = Managers.backend:get_interface("items"):get_item_from_key(var_3_0)

	return not get_item_from_key and get_item_from_key.backend_id
end
