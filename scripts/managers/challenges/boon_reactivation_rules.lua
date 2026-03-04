-- chunkname: @scripts/managers/challenges/boon_reactivation_rules.lua

BoonReactivationRules = BoonReactivationRules or {}

BoonReactivationRules.questing_knight = function (arg_1_0)
	local var_1_0 = Managers.party:get_status_from_unique_id(arg_1_0)

	if var_1_0 then
		local var_1_1 = var_1_0.profile_index
		local var_1_2 = var_1_0.career_index
		local var_1_3 = SPProfiles[var_1_1]
		local var_1_4 = var_1_3 and var_1_3.careers[var_1_2]

		return var_1_4 and var_1_4 == CareerSettings.es_questingknight
	end

	return false
end
