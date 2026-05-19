-- chunkname: @scripts/helpers/weave_utils.lua

WeaveUtils = WeaveUtils or {}

function WeaveUtils.get_rating(arg_1_0)
	local var_1_0 = WeaveSettings.rating_values
	local var_1_1 = 5
	local var_1_2 = 0

	if arg_1_0 then
		for iter_1_0 = 1, #var_1_0 do
			if arg_1_0 > var_1_0[iter_1_0] then
				var_1_2 = var_1_1 - iter_1_0 + 1

				break
			end
		end
	end

	return var_1_2
end

function WeaveUtils.magic_level_to_power_level(arg_2_0)
	local var_2_0 = PowerLevelFromMagicLevel

	return math.min(math.ceil(var_2_0.starting_power_level + arg_2_0 * var_2_0.power_level_per_magic_level), var_2_0.max_power_level)
end

function WeaveUtils.weave_equivalent_item_unlocked(arg_3_0)
	local var_3_0 = MagicItemByUnlockName[arg_3_0]
	local var_3_1 = Managers.backend:get_interface("items"):get_item_from_key(var_3_0)

	return var_3_1 and var_3_1.backend_id
end
