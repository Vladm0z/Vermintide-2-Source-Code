-- chunkname: @scripts/unit_extensions/default_player_unit/careers/career_utils.lua

require("scripts/settings/profiles/sp_profiles")
require("scripts/managers/game_mode/mechanisms/mechanism_overrides")

CareerUtils = {}

function CareerUtils.get_abilities(arg_1_0, arg_1_1)
	local var_1_0 = SPProfiles[arg_1_0].careers[arg_1_1].activated_ability

	return MechanismOverrides.get(var_1_0)
end

function CareerUtils.get_abilities_by_career(arg_2_0)
	local var_2_0 = arg_2_0.activated_ability

	return MechanismOverrides.get(var_2_0)
end

function CareerUtils.num_abilities(arg_3_0, arg_3_1)
	return #CareerUtils.get_abilities(arg_3_0, arg_3_1)
end

function CareerUtils.get_ability_data(arg_4_0, arg_4_1, arg_4_2)
	return CareerUtils.get_abilities(arg_4_0, arg_4_1)[arg_4_2]
end

function CareerUtils.get_ability_data_by_career(arg_5_0, arg_5_1)
	return CareerUtils.get_abilities_by_career(arg_5_0)[arg_5_1]
end

function CareerUtils.get_passive_ability_by_career(arg_6_0)
	local var_6_0 = arg_6_0.passive_ability

	return MechanismOverrides.get(var_6_0)
end
