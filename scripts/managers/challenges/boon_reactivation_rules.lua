-- chunkname: @scripts/managers/challenges/boon_reactivation_rules.lua

local BoonReactivationRules = BoonReactivationRules

BoonReactivationRules = BoonReactivationRules or {}
BoonReactivationRules = BoonReactivationRules

BoonReactivationRules.questing_knight = function (arg_1_0)
	-- function 1
	local get_status_from_unique_id = Managers.party:get_status_from_unique_id(arg_1_0)

	if not get_status_from_unique_id then
		local profile_index = get_status_from_unique_id.profile_index
		local career_index = get_status_from_unique_id.career_index
		local var_1_3 = SPProfiles[profile_index]
		local flag = not var_1_3 and var_1_3.careers[career_index]

		return not flag and flag == CareerSettings.es_questingknight
	end

	return false
end
