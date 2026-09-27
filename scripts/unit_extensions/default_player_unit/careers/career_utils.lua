-- chunkname: @scripts/unit_extensions/default_player_unit/careers/career_utils.lua

require("scripts/settings/profiles/sp_profiles")
require("scripts/managers/game_mode/mechanisms/mechanism_overrides")

CareerUtils = {}

CareerUtils.get_abilities = function (arg_1_0, arg_1_1)
	-- function 1
	local activated_ability = SPProfiles[arg_1_0].careers[arg_1_1].activated_ability

	return MechanismOverrides.get(activated_ability)
end

CareerUtils.get_abilities_by_career = function (self)
	-- function 2
	local activated_ability = self.activated_ability

	return MechanismOverrides.get(activated_ability)
end

CareerUtils.num_abilities = function (arg_3_0, arg_3_1)
	-- function 3
	return #CareerUtils.get_abilities(arg_3_0, arg_3_1)
end

CareerUtils.get_ability_data = function (arg_4_0, arg_4_1, arg_4_2)
	-- function 4
	return CareerUtils.get_abilities(arg_4_0, arg_4_1)[arg_4_2]
end

CareerUtils.get_ability_data_by_career = function (arg_5_0, arg_5_1)
	-- function 5
	return CareerUtils.get_abilities_by_career(arg_5_0)[arg_5_1]
end

CareerUtils.get_passive_ability_by_career = function (self)
	-- function 6
	local passive_ability = self.passive_ability

	return MechanismOverrides.get(passive_ability)
end
