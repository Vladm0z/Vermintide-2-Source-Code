-- chunkname: @scripts/unit_extensions/default_player_unit/careers/career_utils.lua

require("scripts/settings/profiles/sp_profiles")
require("scripts/managers/game_mode/mechanisms/mechanism_overrides")

CareerUtils = {}

CareerUtils.get_abilities = function (profile_index, career_index)
	-- function 1
	local profile = SPProfiles[profile_index]
	local career_settings = profile.careers[career_index]
	local activated_ability = career_settings.activated_ability

	return MechanismOverrides.get(activated_ability)
end

CareerUtils.get_abilities_by_career = function (career_settings)
	-- function 2
	local activated_ability = career_settings.activated_ability

	return MechanismOverrides.get(activated_ability)
end

CareerUtils.num_abilities = function (profile_index, career_index)
	-- function 3
	local abilities = CareerUtils.get_abilities(profile_index, career_index)

	return #abilities
end

CareerUtils.get_ability_data = function (profile_index, career_index, ability_index)
	-- function 4
	local abilities = CareerUtils.get_abilities(profile_index, career_index)

	return abilities[ability_index]
end

CareerUtils.get_ability_data_by_career = function (career_settings, ability_index)
	-- function 5
	local abilities = CareerUtils.get_abilities_by_career(career_settings)

	return abilities[ability_index]
end

CareerUtils.get_passive_ability_by_career = function (career_settings)
	-- function 6
	local passive_ability = career_settings.passive_ability

	return MechanismOverrides.get(passive_ability)
end
