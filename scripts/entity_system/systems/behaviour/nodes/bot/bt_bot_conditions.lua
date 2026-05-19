-- chunkname: @scripts/entity_system/systems/behaviour/nodes/bot/bt_bot_conditions.lua

BTConditions.can_activate = BTConditions.can_activate or {}
BTConditions.reload_ability_weapon = BTConditions.reload_ability_weapon or {}
BTConditions.ability_check_categories = {
	activate_ability = {
		dr_ranger = true,
		es_huntsman = true,
		es_mercenary = true,
		wh_captain = true,
		we_maidenguard = true,
		dr_slayer = true,
		wh_zealot = true,
		bw_adept = true,
		es_knight = true,
		dr_ironbreaker = true,
		we_shade = true,
		bw_unchained = true
	},
	shoot_ability = {
		bw_scholar = true,
		we_waywatcher = true,
		wh_bountyhunter = true
	}
}

local var_0_0 = ScriptUnit

function BTConditions.can_activate.dr_ironbreaker(arg_1_0)
	local var_1_0 = arg_1_0.unit
	local var_1_1 = POSITION_LOOKUP[var_1_0]
	local var_1_2 = arg_1_0.proximite_enemies
	local var_1_3 = #var_1_2
	local var_1_4 = 64
	local var_1_5 = 15
	local var_1_6 = 0

	for iter_1_0 = 1, var_1_3 do
		local var_1_7 = var_1_2[iter_1_0]
		local var_1_8 = POSITION_LOOKUP[var_1_7]

		if ALIVE[var_1_7] and var_1_4 >= Vector3.distance_squared(var_1_1, var_1_8) then
			local var_1_9 = BLACKBOARDS[var_1_7]
			local var_1_10 = var_1_9.breed
			local var_1_11 = var_1_9.target_unit == var_1_0

			var_1_6 = var_1_6 + var_1_10.threat_value * (var_1_11 and 1.25 or 1)

			if var_1_5 <= var_1_6 then
				return true
			end
		end
	end

	return false
end

function BTConditions.can_activate.dr_slayer(arg_2_0)
	if not arg_2_0.locomotion_extension:is_on_ground() then
		return false
	end

	local var_2_0 = arg_2_0.unit
	local var_2_1 = POSITION_LOOKUP[var_2_0]
	local var_2_2 = arg_2_0.target_unit
	local var_2_3 = BLACKBOARDS[var_2_2]
	local var_2_4 = var_2_3 and var_2_3.breed
	local var_2_5 = var_2_4 and var_2_4.threat_value or 0
	local var_2_6 = arg_2_0.target_ally_unit
	local var_2_7 = arg_2_0.target_ally_need_type
	local var_2_8 = Managers.state.entity:system("ai_bot_group_system"):is_prioritized_ally(var_2_0, var_2_6)
	local var_2_9
	local var_2_10

	if var_2_8 and (var_2_7 == "knocked_down" or var_2_7 == "hook") then
		var_2_9 = var_2_6
		var_2_10 = arg_2_0.ally_distance^2
	elseif var_2_2 and var_2_5 >= 8 then
		local var_2_11 = POSITION_LOOKUP[var_2_2]

		var_2_9 = var_2_2
		var_2_10 = Vector3.distance_squared(var_2_1, var_2_11)
	end

	local var_2_12 = 49
	local var_2_13 = 100

	if var_2_9 and var_2_12 < var_2_10 and var_2_10 < var_2_13 then
		local var_2_14 = POSITION_LOOKUP[var_2_9]
		local var_2_15 = var_2_14 + Vector3.normalize(var_2_14 - var_2_1) * 0.5
		local var_2_16 = arg_2_0.nav_world

		if LocomotionUtils.ray_can_go_on_mesh(var_2_16, var_2_1, var_2_15, nil, 1, 1) then
			arg_2_0.activate_ability_data.aim_position:store(var_2_14)

			return true
		end
	end

	return false
end

function BTConditions.can_activate.dr_ranger(arg_3_0)
	local var_3_0 = arg_3_0.unit
	local var_3_1 = arg_3_0.target_ally_unit
	local var_3_2 = Managers.state.entity:system("ai_bot_group_system"):is_prioritized_ally(var_3_0, var_3_1)
	local var_3_3 = arg_3_0.ally_distance
	local var_3_4 = POSITION_LOOKUP[var_3_0]
	local var_3_5 = arg_3_0.proximite_enemies
	local var_3_6 = #var_3_5
	local var_3_7 = 25
	local var_3_8 = 0
	local var_3_9 = var_3_2 and var_3_3 < 5 and 5 or 12
	local var_3_10 = arg_3_0.health_extension:current_health_percent()
	local var_3_11 = 2 - (arg_3_0.status_extension:is_wounded() and 0 or var_3_10)

	for iter_3_0 = 1, var_3_6 do
		local var_3_12 = var_3_5[iter_3_0]
		local var_3_13 = POSITION_LOOKUP[var_3_12]

		if ALIVE[var_3_12] and var_3_7 >= Vector3.distance_squared(var_3_4, var_3_13) then
			local var_3_14 = BLACKBOARDS[var_3_12]
			local var_3_15 = var_3_14.breed
			local var_3_16 = var_3_14.target_unit == var_3_0

			var_3_8 = var_3_8 + var_3_15.threat_value * (var_3_11 + (var_3_16 and 0.25 or 0))

			if var_3_9 <= var_3_8 then
				return true
			end
		end
	end

	return false
end

function BTConditions.can_activate.es_mercenary(arg_4_0)
	local var_4_0 = arg_4_0.unit
	local var_4_1 = POSITION_LOOKUP[var_4_0]
	local var_4_2 = 225
	local var_4_3 = 0
	local var_4_4 = arg_4_0.side.PLAYER_AND_BOT_UNITS
	local var_4_5 = #var_4_4

	for iter_4_0 = 1, var_4_5 do
		local var_4_6 = var_4_4[iter_4_0]
		local var_4_7 = POSITION_LOOKUP[var_4_6]
		local var_4_8 = Vector3.distance_squared(var_4_1, var_4_7)

		if var_4_6 ~= var_4_0 and var_4_8 < var_4_2 then
			var_4_3 = var_4_3 + 1
		end
	end

	local var_4_9
	local var_4_10 = var_4_5 - 1
	local var_4_11 = var_4_10 == 0 and 0.5 or var_4_3 / var_4_10
	local var_4_12 = arg_4_0.proximite_enemies
	local var_4_13 = #var_4_12
	local var_4_14 = 49
	local var_4_15 = 0
	local var_4_16 = math.max(20 * (1 - var_4_11), 8)
	local var_4_17 = arg_4_0.health_extension:current_health_percent()
	local var_4_18 = 2 - (arg_4_0.status_extension:is_wounded() and 0 or var_4_17)

	for iter_4_1 = 1, var_4_13 do
		local var_4_19 = var_4_12[iter_4_1]
		local var_4_20 = POSITION_LOOKUP[var_4_19]

		if ALIVE[var_4_19] and var_4_14 >= Vector3.distance_squared(var_4_1, var_4_20) then
			local var_4_21 = BLACKBOARDS[var_4_19]
			local var_4_22 = var_4_21.breed
			local var_4_23 = var_4_21.target_unit == var_4_0

			var_4_15 = var_4_15 + var_4_22.threat_value * (var_4_18 + (var_4_23 and 0.25 or 0))

			if var_4_16 <= var_4_15 then
				return true
			end
		end
	end

	return false
end

function BTConditions.can_activate.es_huntsman(arg_5_0)
	local var_5_0 = #arg_5_0.proximite_enemies
	local var_5_1 = arg_5_0.target_unit

	if var_5_0 == 0 and var_5_1 == nil then
		return false
	end

	local var_5_2 = arg_5_0.unit
	local var_5_3 = POSITION_LOOKUP[var_5_2]
	local var_5_4 = BLACKBOARDS[var_5_1]
	local var_5_5 = var_5_4 and var_5_4.breed
	local var_5_6 = var_5_5 and var_5_5.threat_value or 0
	local var_5_7 = arg_5_0.target_ally_unit
	local var_5_8 = arg_5_0.target_ally_need_type
	local var_5_9 = Managers.state.entity:system("ai_bot_group_system"):is_prioritized_ally(var_5_2, var_5_7)
	local var_5_10 = arg_5_0.health_extension:current_health_percent()
	local var_5_11 = arg_5_0.status_extension:is_wounded()

	if var_5_9 and (var_5_8 == "knocked_down" or var_5_8 == "hook" or var_5_8 == "ledge") then
		return true
	elseif var_5_10 < 0.4 or var_5_11 then
		return true
	elseif var_5_1 and var_5_6 >= 8 then
		return true
	end

	return false
end

function BTConditions.can_activate.es_knight(arg_6_0)
	local var_6_0 = arg_6_0.unit
	local var_6_1 = POSITION_LOOKUP[var_6_0]
	local var_6_2 = arg_6_0.target_unit
	local var_6_3 = BLACKBOARDS[var_6_2]
	local var_6_4 = var_6_3 and var_6_3.breed
	local var_6_5 = var_6_4 and var_6_4.threat_value or 0
	local var_6_6 = arg_6_0.target_ally_unit
	local var_6_7 = arg_6_0.target_ally_need_type
	local var_6_8 = Managers.state.entity:system("ai_bot_group_system"):is_prioritized_ally(var_6_0, var_6_6)
	local var_6_9
	local var_6_10

	if var_6_8 and (var_6_7 == "knocked_down" or var_6_7 == "hook") then
		var_6_9 = var_6_6
		var_6_10 = arg_6_0.ally_distance^2
	elseif var_6_2 and var_6_5 >= 5 then
		local var_6_11 = POSITION_LOOKUP[var_6_2]

		var_6_9 = var_6_2
		var_6_10 = Vector3.distance_squared(var_6_1, var_6_11)
	end

	local var_6_12 = 81
	local var_6_13 = 12
	local var_6_14 = 144

	if var_6_9 and var_6_12 < var_6_10 and var_6_10 < var_6_14 then
		local var_6_15 = POSITION_LOOKUP[var_6_9]
		local var_6_16 = var_6_1 + Vector3.normalize(var_6_15 - var_6_1) * (var_6_13 + 2)
		local var_6_17 = arg_6_0.nav_world

		if LocomotionUtils.ray_can_go_on_mesh(var_6_17, var_6_1, var_6_16, nil, 1, 1) then
			arg_6_0.activate_ability_data.aim_position:store(var_6_15)

			return true
		end
	end

	return false
end

function BTConditions.can_activate.we_waywatcher(arg_7_0)
	local var_7_0 = arg_7_0.target_unit

	if not ALIVE[var_7_0] then
		return false
	end

	if not BLACKBOARDS[var_7_0] then
		return false
	end

	local var_7_1 = 30

	if var_7_0 == arg_7_0.priority_target_enemy and var_7_1 >= arg_7_0.priority_target_distance or var_7_0 == arg_7_0.urgent_target_enemy and var_7_1 >= arg_7_0.urgent_target_distance or var_7_0 == arg_7_0.opportunity_target_enemy and var_7_1 >= arg_7_0.opportunity_target_distance then
		local var_7_2 = arg_7_0.ranged_obstruction_by_static
		local var_7_3 = Managers.time:time("game")

		return not (var_7_2 and var_7_2.unit == var_7_0 and var_7_3 <= var_7_2.timer + 3)
	else
		return false
	end
end

function BTConditions.can_activate.we_maidenguard(arg_8_0)
	local var_8_0 = arg_8_0.unit
	local var_8_1 = POSITION_LOOKUP[var_8_0]
	local var_8_2 = arg_8_0.target_unit
	local var_8_3 = BLACKBOARDS[var_8_2]
	local var_8_4 = var_8_3 and var_8_3.breed
	local var_8_5 = var_8_4 and var_8_4.threat_value or 0
	local var_8_6 = arg_8_0.target_ally_unit
	local var_8_7 = arg_8_0.target_ally_need_type
	local var_8_8 = Managers.state.entity:system("ai_bot_group_system"):is_prioritized_ally(var_8_0, var_8_6)
	local var_8_9
	local var_8_10

	if var_8_8 and (var_8_7 == "knocked_down" or var_8_7 == "hook") then
		var_8_9 = var_8_6
		var_8_10 = arg_8_0.ally_distance^2
	elseif var_8_2 and var_8_5 >= 5 then
		local var_8_11 = POSITION_LOOKUP[var_8_2]

		var_8_9 = var_8_2
		var_8_10 = Vector3.distance_squared(var_8_1, var_8_11)
	end

	local var_8_12 = 81
	local var_8_13 = 12
	local var_8_14 = 144

	if var_8_9 and var_8_12 < var_8_10 and var_8_10 < var_8_14 then
		local var_8_15 = POSITION_LOOKUP[var_8_9]
		local var_8_16 = var_8_1 + Vector3.normalize(var_8_15 - var_8_1) * (var_8_13 + 2)
		local var_8_17 = arg_8_0.nav_world

		if LocomotionUtils.ray_can_go_on_mesh(var_8_17, var_8_1, var_8_16, nil, 1, 1) then
			arg_8_0.activate_ability_data.aim_position:store(var_8_15)

			return true
		end
	end

	return false
end

function BTConditions.can_activate.we_shade(arg_9_0)
	local var_9_0 = #arg_9_0.proximite_enemies
	local var_9_1 = arg_9_0.target_unit

	if var_9_0 == 0 and var_9_1 == nil then
		return false
	end

	local var_9_2 = arg_9_0.unit
	local var_9_3 = POSITION_LOOKUP[var_9_2]
	local var_9_4 = BLACKBOARDS[var_9_1]
	local var_9_5 = var_9_4 and var_9_4.breed
	local var_9_6 = var_9_5 and var_9_5.threat_value or 0
	local var_9_7 = arg_9_0.target_ally_unit
	local var_9_8 = arg_9_0.target_ally_need_type
	local var_9_9 = Managers.state.entity:system("ai_bot_group_system"):is_prioritized_ally(var_9_2, var_9_7)
	local var_9_10 = arg_9_0.health_extension:current_health_percent()
	local var_9_11 = arg_9_0.status_extension:is_wounded()

	if var_9_9 and (var_9_8 == "knocked_down" or var_9_8 == "hook" or var_9_8 == "ledge") then
		return true
	elseif var_9_10 < 0.4 or var_9_11 then
		return true
	elseif var_9_1 and var_9_6 >= 8 then
		return true
	end

	return false
end

function BTConditions.can_activate.wh_captain(arg_10_0)
	local var_10_0 = arg_10_0.unit
	local var_10_1 = POSITION_LOOKUP[var_10_0]
	local var_10_2 = 100
	local var_10_3 = 0
	local var_10_4 = arg_10_0.side.PLAYER_AND_BOT_UNITS
	local var_10_5 = #var_10_4

	for iter_10_0 = 1, var_10_5 do
		local var_10_6 = var_10_4[iter_10_0]
		local var_10_7 = var_0_0.extension(var_10_6, "status_system")
		local var_10_8 = POSITION_LOOKUP[var_10_6]
		local var_10_9 = Vector3.distance_squared(var_10_1, var_10_8)

		if var_10_6 ~= var_10_0 and not var_10_7:is_disabled() and var_10_9 < var_10_2 then
			var_10_3 = var_10_3 + 1
		end
	end

	local var_10_10
	local var_10_11 = var_10_5 - 1
	local var_10_12 = var_10_11 == 0 and 0.5 or var_10_3 / var_10_11
	local var_10_13 = arg_10_0.proximite_enemies
	local var_10_14 = #var_10_13
	local var_10_15 = 49
	local var_10_16 = 0
	local var_10_17 = math.max(20 * (1 - var_10_12), 8)
	local var_10_18 = arg_10_0.health_extension:current_health_percent()
	local var_10_19 = 2 - (arg_10_0.status_extension:is_wounded() and 0 or var_10_18)

	for iter_10_1 = 1, var_10_14 do
		local var_10_20 = var_10_13[iter_10_1]
		local var_10_21 = POSITION_LOOKUP[var_10_20]

		if ALIVE[var_10_20] and var_10_15 >= Vector3.distance_squared(var_10_1, var_10_21) then
			local var_10_22 = BLACKBOARDS[var_10_20]
			local var_10_23 = var_10_22.breed
			local var_10_24 = var_10_22.target_unit == var_10_0

			var_10_16 = var_10_16 + var_10_23.threat_value * (var_10_19 + (var_10_24 and 0.25 or 0))

			if var_10_17 <= var_10_16 then
				return true
			end
		end
	end

	return false
end

function BTConditions.can_activate.wh_bountyhunter(arg_11_0)
	local var_11_0 = arg_11_0.target_unit

	if not ALIVE[var_11_0] then
		return false
	end

	if not BLACKBOARDS[var_11_0] then
		return false
	end

	local var_11_1 = 15

	if var_11_0 == arg_11_0.priority_target_enemy and var_11_1 >= arg_11_0.priority_target_distance or var_11_0 == arg_11_0.urgent_target_enemy and var_11_1 >= arg_11_0.urgent_target_distance or var_11_0 == arg_11_0.opportunity_target_enemy and var_11_1 >= arg_11_0.opportunity_target_distance then
		local var_11_2 = arg_11_0.ranged_obstruction_by_static
		local var_11_3 = Managers.time:time("game")

		return not (var_11_2 and var_11_2.unit == var_11_0 and var_11_3 <= var_11_2.timer + 3)
	else
		return false
	end
end

function BTConditions.can_activate.wh_zealot(arg_12_0)
	local var_12_0 = arg_12_0.unit
	local var_12_1 = POSITION_LOOKUP[var_12_0]
	local var_12_2 = arg_12_0.target_unit
	local var_12_3 = BLACKBOARDS[var_12_2]
	local var_12_4 = var_12_3 and var_12_3.breed
	local var_12_5 = var_12_4 and var_12_4.threat_value or 0
	local var_12_6 = arg_12_0.target_ally_unit
	local var_12_7 = arg_12_0.target_ally_need_type
	local var_12_8 = Managers.state.entity:system("ai_bot_group_system"):is_prioritized_ally(var_12_0, var_12_6)
	local var_12_9
	local var_12_10

	if var_12_8 and (var_12_7 == "knocked_down" or var_12_7 == "hook") then
		var_12_9 = var_12_6
		var_12_10 = arg_12_0.ally_distance^2
	elseif var_12_2 and var_12_5 >= 8 then
		local var_12_11 = POSITION_LOOKUP[var_12_2]

		var_12_9 = var_12_2
		var_12_10 = Vector3.distance_squared(var_12_1, var_12_11)
	end

	local var_12_12 = 81
	local var_12_13 = 144

	if var_12_9 and var_12_12 < var_12_10 and var_12_10 < var_12_13 then
		local var_12_14 = POSITION_LOOKUP[var_12_9]
		local var_12_15 = var_12_14 + Vector3.normalize(var_12_14 - var_12_1) * 0.5
		local var_12_16 = arg_12_0.nav_world

		if LocomotionUtils.ray_can_go_on_mesh(var_12_16, var_12_1, var_12_15, nil, 1, 1) then
			arg_12_0.activate_ability_data.aim_position:store(var_12_14)

			return true
		end
	end

	return false
end

function BTConditions.can_activate.bw_adept(arg_13_0)
	local var_13_0 = arg_13_0.unit
	local var_13_1 = POSITION_LOOKUP[var_13_0]
	local var_13_2 = arg_13_0.target_unit
	local var_13_3 = BLACKBOARDS[var_13_2]
	local var_13_4 = var_13_3 and var_13_3.breed
	local var_13_5 = var_13_4 and var_13_4.threat_value or 0
	local var_13_6 = arg_13_0.target_ally_unit
	local var_13_7 = arg_13_0.target_ally_need_type
	local var_13_8 = Managers.state.entity:system("ai_bot_group_system"):is_prioritized_ally(var_13_0, var_13_6)
	local var_13_9
	local var_13_10

	if var_13_8 and (var_13_7 == "knocked_down" or var_13_7 == "hook") then
		var_13_9 = var_13_6
		var_13_10 = arg_13_0.ally_distance^2
	elseif var_13_2 and var_13_5 >= 8 then
		local var_13_11 = POSITION_LOOKUP[var_13_2]

		var_13_9 = var_13_2
		var_13_10 = Vector3.distance_squared(var_13_1, var_13_11)
	end

	local var_13_12 = 25
	local var_13_13 = 100

	if var_13_9 and var_13_12 < var_13_10 and var_13_10 < var_13_13 then
		local var_13_14 = POSITION_LOOKUP[var_13_9]
		local var_13_15 = var_13_14 + Vector3.normalize(var_13_14 - var_13_1) * 0.5
		local var_13_16 = arg_13_0.nav_world

		if LocomotionUtils.ray_can_go_on_mesh(var_13_16, var_13_1, var_13_15, nil, 1, 1) then
			arg_13_0.activate_ability_data.aim_position:store(var_13_14)

			return true
		end
	end

	return false
end

function BTConditions.can_activate.bw_scholar(arg_14_0)
	local var_14_0 = arg_14_0.target_unit

	if not ALIVE[var_14_0] then
		return false
	end

	if not BLACKBOARDS[var_14_0] then
		return false
	end

	local var_14_1 = 20

	if var_14_0 == arg_14_0.priority_target_enemy and var_14_1 >= arg_14_0.priority_target_distance or var_14_0 == arg_14_0.urgent_target_enemy and var_14_1 >= arg_14_0.urgent_target_distance or var_14_0 == arg_14_0.opportunity_target_enemy and var_14_1 >= arg_14_0.opportunity_target_distance then
		local var_14_2 = arg_14_0.ranged_obstruction_by_static
		local var_14_3 = Managers.time:time("game")

		return not (var_14_2 and var_14_2.unit == var_14_0 and var_14_3 <= var_14_2.timer + 3)
	else
		return false
	end
end

function BTConditions.can_activate.bw_unchained(arg_15_0)
	if arg_15_0.overcharge_extension:is_above_critical_limit() then
		return true
	end

	local var_15_0 = arg_15_0.unit
	local var_15_1 = POSITION_LOOKUP[var_15_0]
	local var_15_2 = arg_15_0.proximite_enemies
	local var_15_3 = #var_15_2
	local var_15_4 = 16
	local var_15_5 = 0
	local var_15_6 = 10

	for iter_15_0 = 1, var_15_3 do
		local var_15_7 = var_15_2[iter_15_0]
		local var_15_8 = POSITION_LOOKUP[var_15_7]

		if ALIVE[var_15_7] and var_15_4 >= Vector3.distance_squared(var_15_1, var_15_8) then
			local var_15_9 = BLACKBOARDS[var_15_7]
			local var_15_10 = var_15_9.breed
			local var_15_11 = var_15_9.target_unit == var_15_0

			var_15_5 = var_15_5 + var_15_10.threat_value * (var_15_11 and 1.25 or 1)

			if var_15_6 <= var_15_5 then
				return true
			end
		end
	end

	return false
end

function BTConditions.can_activate_ability(arg_16_0, arg_16_1)
	local var_16_0 = arg_16_0.career_extension
	local var_16_1 = arg_16_0.activate_ability_data.is_using_ability
	local var_16_2 = var_16_0:career_name()
	local var_16_3 = arg_16_1[1]
	local var_16_4 = BTConditions.ability_check_categories[var_16_3]

	if not var_16_4 or not var_16_4[var_16_2] then
		return false
	end

	if var_16_3 == "shoot_ability" and (not ALIVE[arg_16_0.target_unit] or not Unit.has_data(arg_16_0.target_unit, "breed")) then
		return false
	end

	local var_16_5 = BTConditions.can_activate[var_16_2]

	if var_16_3 == "ranged_weapon" or var_16_3 == "melee_weapon" then
		return var_16_5 and var_16_5(arg_16_0)
	end

	return var_16_1 or var_16_0:can_use_activated_ability() and var_16_5 and var_16_5(arg_16_0)
end

function BTConditions.should_reload_ability_weapon(arg_17_0, arg_17_1)
	if arg_17_0.reloading and arg_17_0.reloading_slot ~= arg_17_1.wanted_slot then
		return false
	end

	local var_17_0 = arg_17_0.career_extension:career_name()
	local var_17_1 = BTConditions.reload_ability_weapon[var_17_0]

	return var_17_1 and var_17_1(arg_17_0, arg_17_1)
end

function BTConditions.is_disabled(arg_18_0)
	return arg_18_0.is_knocked_down or arg_18_0.is_grabbed_by_pack_master or arg_18_0.is_pounced_down or arg_18_0.is_hanging_from_hook or arg_18_0.is_ledge_hanging or arg_18_0.is_grabbed_by_chaos_spawn
end

local var_0_1 = 2
local var_0_2 = 4
local var_0_3 = 2.4
local var_0_4 = var_0_3 * var_0_3

local function var_0_5(arg_19_0, arg_19_1, arg_19_2)
	local var_19_0 = Managers.time:time("game")
	local var_19_1 = arg_19_0.pushed_at_t
	local var_19_2 = arg_19_0.block_broken_at_t
	local var_19_3 = true
	local var_19_4, var_19_5 = arg_19_1:is_interacting()

	if not var_19_4 or var_19_5 ~= arg_19_2 then
		local var_19_6, var_19_7 = arg_19_0:current_fatigue_points()
		local var_19_8 = var_19_7 - var_19_6
		local var_19_9 = PlayerUnitStatusSettings.fatigue_point_costs.blocked_attack

		var_19_3 = var_19_6 == 0 or var_19_9 < var_19_8
	end

	if var_19_3 and var_19_0 > var_19_1 + var_0_1 and var_19_0 > var_19_2 + var_0_2 then
		return true
	else
		return false
	end
end

local var_0_6 = 4

local function var_0_7(arg_20_0, arg_20_1, arg_20_2)
	local var_20_0 = #arg_20_1
	local var_20_1 = var_0_0.extension(arg_20_0, "buff_system"):apply_buffs_to_value(1, "faster_revive")
	local var_20_2 = var_0_6 + var_0_6 * (1 - var_20_1)
	local var_20_3 = 0

	for iter_20_0 = 1, var_20_0 do
		local var_20_4 = arg_20_1[iter_20_0]

		if ALIVE[var_20_4] then
			local var_20_5 = BLACKBOARDS[var_20_4]
			local var_20_6 = var_20_5.breed
			local var_20_7 = var_20_6.threat_value

			if var_20_5.target_unit == arg_20_0 and (not arg_20_2 or var_20_6.is_bot_aid_threat) then
				var_20_3 = var_20_3 + var_20_7

				if var_20_2 < var_20_3 then
					return true
				end
			end
		end
	end

	return false
end

local function var_0_8(arg_21_0, arg_21_1)
	local var_21_0 = var_0_0.extension(arg_21_1, "interactable_system"):is_being_interacted_with()

	return var_21_0 == nil or var_21_0 == arg_21_0
end

local var_0_9 = BotConstants.default.FLAT_MOVE_TO_EPSILON^2
local var_0_10 = BotConstants.default.Z_MOVE_TO_EPSILON

local function var_0_11(arg_22_0, arg_22_1)
	local var_22_0 = arg_22_1.navigation_extension
	local var_22_1 = var_22_0:destination()
	local var_22_2 = arg_22_1.target_ally_aid_destination:unbox()

	if Vector3.equal(var_22_1, var_22_2) then
		return var_22_0:destination_reached()
	elseif var_22_0:destination_reached() then
		return not arg_22_1.ai_extension:new_destination_distance_check(arg_22_0, var_22_1, var_22_2, var_22_0)
	else
		local var_22_3 = var_22_2 - arg_22_0

		return math.abs(var_22_3.z) <= var_0_10 and Vector3.length_squared(Vector3.flat(var_22_3)) <= var_0_9
	end
end

function BTConditions.can_revive(arg_23_0)
	local var_23_0 = arg_23_0.target_ally_unit

	if arg_23_0.interaction_unit == var_23_0 and arg_23_0.target_ally_need_type == "knocked_down" then
		local var_23_1 = arg_23_0.interaction_extension

		if not var_0_5(arg_23_0.status_extension, var_23_1, "revive") then
			return false
		end

		local var_23_2 = arg_23_0.unit

		if var_0_0.extension(var_23_0, "health_system"):current_health_percent() > 0.3 and var_0_7(var_23_2, arg_23_0.proximite_enemies, arg_23_0.force_aid) then
			return false
		end

		local var_23_3 = arg_23_0.ally_distance
		local var_23_4, var_23_5 = var_23_1:is_interacting()

		if var_23_4 and var_23_5 == "revive" and var_23_3 <= var_0_3 then
			return true
		end

		local var_23_6 = POSITION_LOOKUP[var_23_2]
		local var_23_7 = var_0_11(var_23_6, arg_23_0) or arg_23_0.is_transported

		if var_0_8(var_23_2, var_23_0) and var_23_7 then
			return true
		end
	end
end

function BTConditions.is_there_threat_to_aid(arg_24_0, arg_24_1, arg_24_2)
	return var_0_7(arg_24_0, arg_24_1, arg_24_2)
end

function BTConditions.can_heal_player(arg_25_0)
	local var_25_0 = arg_25_0.target_ally_unit
	local var_25_1 = var_25_0 and var_0_0.extension(var_25_0, "career_system")
	local var_25_2 = var_25_0 and var_0_0.extension(var_25_0, "status_system")

	if var_25_1 and var_25_1:career_name() == "wh_zealot" and var_25_2 and var_25_2:num_wounds_remaining() > 1 then
		return false
	end

	if arg_25_0.interaction_unit == var_25_0 and arg_25_0.target_ally_need_type == "in_need_of_heal" then
		local var_25_3, var_25_4 = arg_25_0.interaction_extension:is_interacting()

		if var_25_3 and var_25_4 == "heal" then
			return true
		end

		if #arg_25_0.proximite_enemies > 0 then
			return false
		end

		local var_25_5 = arg_25_0.unit
		local var_25_6 = POSITION_LOOKUP[var_25_5]
		local var_25_7 = var_0_11(var_25_6, arg_25_0)
		local var_25_8 = var_0_8(var_25_5, var_25_0)
		local var_25_9 = var_0_0.extension(var_25_0, "locomotion_system"):current_velocity()
		local var_25_10 = Vector3.length_squared(var_25_9)
		local var_25_11 = arg_25_0.ally_distance

		if var_25_8 and (var_25_7 or var_25_10 > 0.04000000000000001 and var_25_11 <= var_0_3) then
			return true
		end
	end
end

function BTConditions.can_help_in_need_player(arg_26_0, arg_26_1)
	local var_26_0 = arg_26_1[1]
	local var_26_1 = arg_26_0.target_ally_unit

	if arg_26_0.interaction_unit == var_26_1 and arg_26_0.target_ally_need_type == var_26_0 then
		local var_26_2 = arg_26_0.unit
		local var_26_3 = POSITION_LOOKUP[var_26_2]
		local var_26_4 = var_0_11(var_26_3, arg_26_0)
		local var_26_5 = var_0_8(var_26_2, var_26_1)
		local var_26_6 = var_0_0.extension(var_26_1, "locomotion_system"):current_velocity()
		local var_26_7 = Vector3.length_squared(var_26_6)
		local var_26_8 = arg_26_0.ally_distance

		if var_26_5 and (var_26_4 or var_26_7 > 0.04000000000000001 and var_26_8 <= var_0_3) then
			return true
		end
	end
end

function BTConditions.can_rescue_hanging_from_hook(arg_27_0)
	local var_27_0 = arg_27_0.target_ally_unit

	if arg_27_0.interaction_unit == var_27_0 and arg_27_0.target_ally_need_type == "hook" then
		if not var_0_5(arg_27_0.status_extension, arg_27_0.interaction_extension, "release_from_hook") then
			return false
		end

		local var_27_1 = arg_27_0.unit

		if var_0_7(var_27_1, arg_27_0.proximite_enemies, arg_27_0.force_aid) then
			return false
		end

		local var_27_2 = POSITION_LOOKUP[var_27_1]
		local var_27_3 = var_0_8(var_27_1, var_27_0)
		local var_27_4 = var_0_11(var_27_2, arg_27_0)

		if var_27_3 and var_27_4 then
			return true
		end
	end
end

function BTConditions.can_rescue_ledge_hanging(arg_28_0)
	local var_28_0 = arg_28_0.target_ally_unit

	if arg_28_0.interaction_unit == var_28_0 and arg_28_0.target_ally_need_type == "ledge" then
		if not var_0_5(arg_28_0.status_extension, arg_28_0.interaction_extension, "pull_up") then
			return false
		end

		local var_28_1 = arg_28_0.unit

		if var_0_7(var_28_1, arg_28_0.proximite_enemies, arg_28_0.force_aid) then
			return false
		end

		local var_28_2 = POSITION_LOOKUP[var_28_1]
		local var_28_3 = var_0_8(var_28_1, var_28_0)
		local var_28_4 = var_0_11(var_28_2, arg_28_0)

		if var_28_3 and var_28_4 then
			return true
		end
	end
end

function BTConditions.can_loot(arg_29_0)
	local var_29_0 = Managers.state.entity:system("play_go_tutorial_system")

	if var_29_0 and not var_29_0:bot_loot_enabled() then
		return false
	end

	local var_29_1 = 3.2
	local var_29_2 = arg_29_0.forced_pickup_unit == arg_29_0.interaction_unit
	local var_29_3 = arg_29_0.health_pickup and arg_29_0.allowed_to_take_health_pickup and arg_29_0.health_pickup == arg_29_0.interaction_unit and (var_29_2 or var_29_1 > arg_29_0.health_dist)
	local var_29_4 = arg_29_0.ammo_pickup and arg_29_0.has_ammo_missing and arg_29_0.ammo_pickup == arg_29_0.interaction_unit and (var_29_2 or var_29_1 > arg_29_0.ammo_dist)
	local var_29_5 = arg_29_0.mule_pickup and arg_29_0.mule_pickup == arg_29_0.interaction_unit and (var_29_2 or arg_29_0.mule_pickup_dist_squared < var_29_1^2)

	return var_29_3 or var_29_4 or var_29_5
end

function BTConditions.bot_should_heal(arg_30_0)
	local var_30_0 = arg_30_0.unit
	local var_30_1 = arg_30_0.inventory_extension
	local var_30_2 = var_30_1:get_slot_data("slot_healthkit")
	local var_30_3 = var_30_2 and var_30_1:get_item_template(var_30_2)

	if not (var_30_3 and var_30_3.can_heal_self) then
		return false
	end

	local var_30_4 = var_0_0.extension(var_30_0, "buff_system"):has_buff_type("trait_necklace_no_healing_health_regen")
	local var_30_5 = arg_30_0.status_extension:is_wounded()
	local var_30_6 = arg_30_0.force_use_health_pickup

	if var_30_4 and not var_30_5 and not var_30_6 then
		return false
	end

	local var_30_7 = arg_30_0.health_extension:current_health_percent() <= var_30_3.bot_heal_threshold
	local var_30_8 = arg_30_0.health_extension:current_permanent_health_percent() <= var_30_3.bot_heal_threshold
	local var_30_9 = arg_30_0.health_extension:get_max_health() <= 75
	local var_30_10 = arg_30_0.target_unit

	return (not var_30_10 or (var_30_3.fast_heal or arg_30_0.is_healing_self) and #arg_30_0.proximite_enemies == 0 or var_30_10 ~= arg_30_0.priority_target_enemy and var_30_10 ~= arg_30_0.urgent_target_enemy and var_30_10 ~= arg_30_0.proximity_target_enemy and var_30_10 ~= arg_30_0.slot_target_enemy) and (var_30_6 or not var_30_4 and (var_30_7 or var_30_5 and (var_30_8 or var_30_9)) or var_30_4 and var_30_7 and var_30_5)
end

function BTConditions.is_slot_not_wielded(arg_31_0, arg_31_1)
	local var_31_0 = arg_31_0.inventory_extension:equipment().wielded_slot
	local var_31_1 = arg_31_1[1]
	local var_31_2 = arg_31_1[2]

	if var_31_2 and var_31_2 == var_31_0 then
		return false
	else
		return var_31_0 ~= var_31_1
	end
end

function BTConditions.is_wanted_slot_not_wielded(arg_32_0, arg_32_1)
	local var_32_0 = arg_32_0.inventory_extension:equipment().wielded_slot
	local var_32_1 = arg_32_0[arg_32_1[1]]
	local var_32_2 = arg_32_1[2]

	if var_32_2 and var_32_1 ~= var_32_2 then
		return false
	else
		return var_32_1 ~= var_32_0
	end
end

function BTConditions.has_double_weapon_slots(arg_33_0, arg_33_1)
	return arg_33_0.double_weapons == arg_33_1[1]
end

function BTConditions.has_better_alt_weapon(arg_34_0, arg_34_1)
	local var_34_0 = arg_34_1[1]

	if arg_34_0.double_weapons == var_34_0 then
		local var_34_1 = arg_34_0.weapon_scores

		if var_34_1 then
			local var_34_2 = arg_34_1[2]

			return (var_34_1[var_34_0].score or -1) < (var_34_1[var_34_2].score or -1)
		end
	end

	return false
end

function BTConditions.needs_weapon_swap(arg_35_0, arg_35_1)
	if BTConditions.has_double_weapon_slots(arg_35_0, arg_35_1) and BTConditions.has_better_alt_weapon(arg_35_0, arg_35_1) then
		return BTConditions.is_slot_not_wielded(arg_35_0, {
			arg_35_1[2]
		})
	end

	return BTConditions.is_slot_not_wielded(arg_35_0, {
		arg_35_1[1]
	})
end

function BTConditions.has_priority_or_opportunity_target(arg_36_0)
	local var_36_0 = arg_36_0.target_unit

	if not ALIVE[var_36_0] then
		return false
	end

	local var_36_1 = 40

	return var_36_0 == arg_36_0.priority_target_enemy and var_36_1 > arg_36_0.priority_target_distance or not arg_36_0.revive_with_urgent_target and var_36_0 == arg_36_0.urgent_target_enemy and var_36_1 > arg_36_0.urgent_target_distance or var_36_0 == arg_36_0.opportunity_target_enemy and var_36_1 > arg_36_0.opportunity_target_distance
end

function BTConditions.bot_in_melee_range(arg_37_0)
	local var_37_0 = arg_37_0.target_unit

	if not ALIVE[var_37_0] then
		return false
	end

	local var_37_1 = arg_37_0.unit
	local var_37_2 = arg_37_0.inventory_extension:equipment().wielded_slot
	local var_37_3
	local var_37_4 = Unit.get_data(var_37_0, "breed")
	local var_37_5 = AiUtils.get_party_danger()

	if arg_37_0.urgent_target_enemy == var_37_0 or arg_37_0.opportunity_target_enemy == var_37_0 or Vector3.is_valid(arg_37_0.taking_cover.cover_position:unbox()) then
		var_37_3 = var_37_4 and var_37_4.bot_opportunity_target_melee_range or 3

		if var_37_2 == "slot_ranged" then
			var_37_3 = var_37_4 and var_37_4.bot_opportunity_target_melee_range_while_ranged or 2
		end
	elseif var_37_2 == "slot_ranged" then
		var_37_3 = math.lerp(10, 3.5, var_37_5)
	else
		var_37_3 = math.lerp(12, 5, var_37_5)
	end

	local var_37_6 = AiUtils.bot_melee_aim_pos(var_37_1, var_37_0) - POSITION_LOOKUP[var_37_1]
	local var_37_7 = Vector3.length_squared(var_37_6) < var_37_3^2
	local var_37_8 = var_37_6.z

	return var_37_7 and var_37_8 > -1.5 and var_37_8 < 2
end

function BTConditions.has_target_and_ammo_greater_than(arg_38_0, arg_38_1)
	local var_38_0 = arg_38_0.target_unit

	if not ALIVE[var_38_0] then
		return false
	end

	local var_38_1 = Unit.get_data(var_38_0, "breed")

	if var_38_1 == nil then
		return false
	end

	local var_38_2 = arg_38_0.inventory_extension
	local var_38_3 = var_38_2:get_slot_data("slot_ranged")
	local var_38_4 = var_38_2:get_item_template(var_38_3)
	local var_38_5 = var_38_4 and var_38_4.buff_type

	if not RangedBuffTypes[var_38_5] then
		return false
	end

	local var_38_6 = var_0_0.has_extension(var_38_0, "buff_system")

	if var_38_6 and var_38_6:has_buff_perk("invulnerable_ranged") then
		return false
	end

	local var_38_7, var_38_8 = var_38_2:current_ammo_status("slot_ranged")
	local var_38_9 = not var_38_7 or var_38_7 / var_38_8 > arg_38_1.ammo_percentage
	local var_38_10 = arg_38_0.overcharge_extension
	local var_38_11 = arg_38_1.overcharge_limit_type
	local var_38_12, var_38_13, var_38_14 = var_38_10:current_overcharge_status()
	local var_38_15 = var_38_12 == 0 or var_38_11 == "threshold" and var_38_12 / var_38_13 < arg_38_1.overcharge_limit or var_38_11 == "maximum" and var_38_12 / var_38_14 < arg_38_1.overcharge_limit
	local var_38_16 = arg_38_0.ranged_obstruction_by_static
	local var_38_17 = Managers.time:time("game")
	local var_38_18 = var_38_16 and var_38_16.unit == arg_38_0.target_unit and var_38_17 <= var_38_16.timer + 3
	local var_38_19 = AiUtils.has_breed_categories(var_38_1.category_mask, var_38_4.attack_meta_data.effective_against_combined)

	return var_38_9 and var_38_15 and not var_38_18 and var_38_19
end

function BTConditions.should_vent_overcharge(arg_39_0, arg_39_1)
	local var_39_0 = arg_39_0.overcharge_extension
	local var_39_1 = arg_39_1.overcharge_limit_type
	local var_39_2, var_39_3, var_39_4 = var_39_0:current_overcharge_status()
	local var_39_5 = 0

	if var_39_1 == "threshold" then
		var_39_5 = var_39_2 / var_39_3
	elseif var_39_1 == "maximum" then
		var_39_5 = var_39_2 / var_39_4
	end

	local var_39_6

	if arg_39_0.reloading then
		var_39_6 = var_39_5 >= arg_39_1.stop_percentage
	else
		var_39_6 = var_39_5 >= arg_39_1.start_min_percentage and var_39_5 <= arg_39_1.start_max_percentage
	end

	return var_39_6
end

function BTConditions.should_recall_unique_ammo(arg_40_0, arg_40_1)
	local var_40_0 = arg_40_0.inventory_extension

	if not var_40_0:has_unique_ammo_type_weapon_equipped() then
		return false
	end

	local var_40_1, var_40_2 = var_40_0:current_ammo_status("slot_ranged")

	if not var_40_1 or not var_40_2 then
		return false
	end

	local var_40_3 = var_40_1 / var_40_2
	local var_40_4

	if arg_40_0.reloading then
		var_40_4 = var_40_1 ~= var_40_2
	else
		var_40_4 = var_40_3 <= arg_40_1.ammo_percentage_threshold
	end

	return var_40_4
end

function BTConditions.should_reload_weapon(arg_41_0, arg_41_1)
	local var_41_0 = arg_41_0.inventory_extension:get_slot_data("slot_ranged")
	local var_41_1 = var_41_0 and var_41_0.right_unit_1p
	local var_41_2 = var_41_0 and var_41_0.left_unit_1p
	local var_41_3 = GearUtils.get_ammo_extension(var_41_1, var_41_2)

	if not var_41_3 then
		return false
	end

	local var_41_4

	if arg_41_0.reloading then
		var_41_4 = var_41_3:remaining_ammo() > 0 and not var_41_3:clip_full() and arg_41_0.reloading_slot == arg_41_1[1]
	else
		var_41_4 = var_41_3:can_reload()
	end

	return var_41_4
end

function BTConditions.wants_to_reload_weapon(arg_42_0, arg_42_1)
	return arg_42_0.wanted_slot_to_reload ~= nil
end

function BTConditions.can_open_door(arg_43_0)
	local var_43_0 = false

	if arg_43_0.interaction_type == "door" then
		local var_43_1 = arg_43_0.interaction_unit
		local var_43_2 = Unit.alive(var_43_1) and var_0_0.has_extension(var_43_1, "door_system")

		if var_43_2 then
			var_43_0 = var_43_2:get_current_state() == "closed"
		end
	end

	return var_43_0
end

function BTConditions.bot_at_breakable(arg_44_0)
	local var_44_0 = arg_44_0.navigation_extension

	return var_44_0:is_in_transition() and var_44_0:transition_type() == "planks"
end

function BTConditions.cant_reach_ally(arg_45_0)
	local var_45_0 = arg_45_0.ai_bot_group_extension.data.follow_unit

	if not ALIVE[var_45_0] or arg_45_0.has_teleported then
		return false
	end

	local var_45_1 = arg_45_0.unit
	local var_45_2 = Managers.state.conflict
	local var_45_3 = var_45_2:get_player_unit_segment(var_45_1)
	local var_45_4 = var_45_2:get_player_unit_segment(var_45_0)

	if not var_45_3 or not var_45_4 then
		return false
	end

	if var_45_4 < var_45_3 then
		return false
	end

	local var_45_5 = var_45_3 < var_45_4
	local var_45_6 = var_0_0.extension(var_45_1, "whereabouts_system")
	local var_45_7 = var_0_0.extension(var_45_0, "whereabouts_system")
	local var_45_8 = var_45_6:last_position_on_navmesh()
	local var_45_9 = var_45_7:last_position_on_navmesh()

	if not var_45_8 or not var_45_9 then
		return false
	end

	local var_45_10 = Managers.time:time("game")
	local var_45_11, var_45_12 = arg_45_0.navigation_extension:successive_failed_paths()

	return arg_45_0.moving_toward_follow_position and var_45_11 > (var_45_5 and 1 or 5) and var_45_10 - var_45_12 > 5
end

local var_0_12 = 1600

function BTConditions.should_teleport(arg_46_0)
	local var_46_0 = arg_46_0.ai_bot_group_extension.data.follow_unit

	if not ALIVE[var_46_0] or arg_46_0.has_teleported then
		return false
	end

	local var_46_1 = arg_46_0.unit
	local var_46_2 = Managers.state.conflict
	local var_46_3 = var_46_2:get_player_unit_segment(var_46_1) or 1
	local var_46_4 = var_46_2:get_player_unit_segment(var_46_0)

	if not var_46_4 or var_46_4 < var_46_3 then
		return false
	end

	local var_46_5 = arg_46_0.target_unit and arg_46_0.target_unit == arg_46_0.priority_target_enemy

	if arg_46_0.target_ally_need_type or var_46_5 then
		return false
	end

	local var_46_6 = var_0_0.extension(var_46_1, "whereabouts_system")
	local var_46_7 = var_0_0.extension(var_46_0, "whereabouts_system")
	local var_46_8 = var_46_6:last_position_on_navmesh()
	local var_46_9 = var_46_7:last_position_on_navmesh()

	if not var_46_8 or not var_46_9 then
		return false
	end

	return Vector3.distance_squared(var_46_8, var_46_9) >= var_0_12
end

function BTConditions.should_drop_grimoire(arg_47_0)
	local var_47_0 = arg_47_0.inventory_extension
	local var_47_1 = "slot_potion"
	local var_47_2 = var_47_0:get_slot_data(var_47_1)

	if var_47_2 then
		local var_47_3 = var_47_0:get_item_template(var_47_2).is_grimoire
		local var_47_4 = Managers.state.entity:system("ai_bot_group_system"):get_pickup_order(arg_47_0.unit, var_47_1)

		return var_47_3 and (var_47_4 == nil or var_47_4.pickup_name ~= "grimoire")
	end

	return false
end

DLCUtils.require_list("bot_conditions")
