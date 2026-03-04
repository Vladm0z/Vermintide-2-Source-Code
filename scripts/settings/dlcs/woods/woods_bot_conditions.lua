-- chunkname: @scripts/settings/dlcs/woods/woods_bot_conditions.lua

BTConditions.can_activate = BTConditions.can_activate or {}
BTConditions.can_activate_non_combat = BTConditions.can_activate_non_combat or {}

table.merge_recursive(BTConditions.ability_check_categories, {
	activate_ability = {
		we_thornsister = true
	}
})

local var_0_0 = 100
local var_0_1 = 8
local var_0_2 = 1.5

function BTConditions.can_activate.we_thornsister(arg_1_0)
	local var_1_0 = arg_1_0.unit
	local var_1_1 = ScriptUnit.has_extension(var_1_0, "talent_system")
	local var_1_2 = var_1_1 and var_1_1:has_talent("kerillian_thorn_sister_debuff_wall")

	if not var_1_2 then
		local var_1_3, var_1_4 = Managers.state.conflict:get_threat_value()

		if var_1_4 < 20 then
			return false
		end
	end

	local var_1_5 = POSITION_LOOKUP[var_1_0]
	local var_1_6 = arg_1_0.target_unit
	local var_1_7 = BLACKBOARDS[var_1_6]
	local var_1_8
	local var_1_9 = 0

	if var_1_6 then
		local var_1_10 = Vector3.distance_squared(var_1_5, POSITION_LOOKUP[var_1_6])

		if var_1_10 <= var_0_0 and var_1_10 >= 4 then
			if var_1_2 then
				local var_1_11 = var_1_7 and var_1_7.breed
				local var_1_12 = var_1_11 and var_1_11.threat_value or 0

				if var_1_6 == arg_1_0.priority_target_enemy or var_1_6 == arg_1_0.urgent_target_enemy or var_1_6 == arg_1_0.opportunity_target_enemy or var_1_12 >= 8 then
					var_1_8 = var_1_6
				end
			elseif #arg_1_0.proximite_enemies >= 10 then
				var_1_8 = var_1_6
				var_1_9 = -(math.sqrt(var_1_10) / var_0_2)
			end
		end
	end

	if var_1_8 then
		local var_1_13 = POSITION_LOOKUP[var_1_8]
		local var_1_14 = Vector3.normalize(var_1_13 - var_1_5)
		local var_1_15 = var_1_13 + var_1_14 * math.max(var_1_9, 0)
		local var_1_16 = arg_1_0.nav_world
		local var_1_17 = var_1_7 and var_1_7.navigation_extension
		local var_1_18 = var_1_17 and var_1_17:traverse_logic()

		if var_1_2 or LocomotionUtils.ray_can_go_on_mesh(var_1_16, var_1_5, var_1_15, var_1_18, 1, 1) then
			local var_1_19 = var_1_13 + var_1_14 * var_1_9

			arg_1_0.activate_ability_data.aim_position:store(var_1_19)

			return true
		end
	end

	return false
end
