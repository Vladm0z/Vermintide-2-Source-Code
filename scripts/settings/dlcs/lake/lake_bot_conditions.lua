-- chunkname: @scripts/settings/dlcs/lake/lake_bot_conditions.lua

BTConditions.can_activate = BTConditions.can_activate or {}

table.merge_recursive(BTConditions.ability_check_categories, {
	activate_ability = {
		es_questingknight = true
	}
})

local var_0_0 = 5
local var_0_1 = var_0_0 * var_0_0
local var_0_2 = 5
local var_0_3 = 10

function BTConditions.can_activate.es_questingknight(arg_1_0)
	local var_1_0 = arg_1_0.target_unit

	if not ALIVE[var_1_0] then
		return false
	end

	local var_1_1 = BLACKBOARDS[var_1_0]

	if not var_1_1 then
		return false
	end

	if var_1_0 == arg_1_0.priority_target_enemy and arg_1_0.priority_target_distance <= var_0_0 or var_1_0 == arg_1_0.urgent_target_enemy and arg_1_0.urgent_target_distance <= var_0_0 or var_1_0 == arg_1_0.opportunity_target_enemy and arg_1_0.opportunity_target_distance <= var_0_0 then
		return true
	end

	local var_1_2 = var_1_1.breed

	if (var_1_2 and var_1_2.threat_value or 0) >= var_0_2 then
		local var_1_3 = arg_1_0.unit
		local var_1_4 = POSITION_LOOKUP[var_1_3]
		local var_1_5 = arg_1_0.proximite_enemies
		local var_1_6 = #var_1_5
		local var_1_7 = 0

		for iter_1_0 = 1, var_1_6 do
			local var_1_8 = var_1_5[iter_1_0]
			local var_1_9 = POSITION_LOOKUP[var_1_8]

			if ALIVE[var_1_8] and Vector3.distance_squared(var_1_4, var_1_9) <= var_0_1 then
				var_1_7 = var_1_7 + BLACKBOARDS[var_1_8].breed.threat_value

				if var_1_7 >= var_0_3 then
					return true
				end
			end
		end
	end

	return false
end
