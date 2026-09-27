-- chunkname: @scripts/entity_system/systems/behaviour/nodes/bot/bt_bot_conditions.lua

local BTConditions = BTConditions
local can_activate = BTConditions.can_activate

can_activate = can_activate or {}
BTConditions.can_activate = can_activate

local BTConditions_2 = BTConditions
local reload_ability_weapon = BTConditions.reload_ability_weapon

reload_ability_weapon = reload_ability_weapon or {}
BTConditions_2.reload_ability_weapon = reload_ability_weapon
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

local ScriptUnit = ScriptUnit

BTConditions.can_activate.dr_ironbreaker = function (self)
	-- function 1
	local unit = self.unit
	local var_1_1 = POSITION_LOOKUP[unit]
	local proximite_enemies = self.proximite_enemies
	local count = #proximite_enemies
	local num = 64
	local num_2 = 15
	local num_3 = 0

	for i = 1, count do
		local var_1_7 = proximite_enemies[i]
		local var_1_8 = POSITION_LOOKUP[var_1_7]

		if not (not ALIVE[var_1_7] and not (num >= Vector3.distance_squared(var_1_1, var_1_8))) then
			local var_1_9 = BLACKBOARDS[var_1_7]
			local breed = var_1_9.breed
			local flag = var_1_9.target_unit == unit
			local threat_value = breed.threat_value
			local flag_2

			flag_2 = not flag and 1.25 and 1
			num_3 = num_3 + threat_value * flag_2

			if num_2 <= num_3 then
				return true
			end
		end
	end

	return false
end

BTConditions.can_activate.dr_slayer = function (self)
	-- function 2
	if not self.locomotion_extension:is_on_ground() then
		return false
	end

	local unit = self.unit
	local var_2_1 = POSITION_LOOKUP[unit]
	local target_unit = self.target_unit
	local var_2_3 = BLACKBOARDS[target_unit]
	local flag = not var_2_3 and var_2_3.breed
	local threat_value

	if not flag then
		threat_value = flag.threat_value

		if not threat_value then
			-- Nothing
		end
	end

	threat_value = 0

	::label_2_0::

	local target_ally_unit = self.target_ally_unit
	local target_ally_need_type = self.target_ally_need_type
	local is_prioritized_ally = Managers.state.entity:system("ai_bot_group_system"):is_prioritized_ally(unit, target_ally_unit)
	local var_2_9
	local var_2_10

	if not (not is_prioritized_ally and target_ally_need_type == "knocked_down" or target_ally_need_type ~= "hook") then
		var_2_9 = target_ally_unit
		var_2_10 = self.ally_distance^2
	elseif not (not target_unit and not (threat_value >= 8)) then
		local var_2_11 = POSITION_LOOKUP[target_unit]

		var_2_9 = target_unit
		var_2_10 = Vector3.distance_squared(var_2_1, var_2_11)
	end

	local num = 49
	local num_2 = 100

	if not (not var_2_9 and not (num < var_2_10) or not (var_2_10 < num_2)) then
		local var_2_14 = POSITION_LOOKUP[var_2_9]
		local num_3 = var_2_14 + Vector3.normalize(var_2_14 - var_2_1) * 0.5
		local nav_world = self.nav_world

		if not LocomotionUtils.ray_can_go_on_mesh(nav_world, var_2_1, num_3, nil, 1, 1) then
			self.activate_ability_data.aim_position:store(var_2_14)

			return true
		end
	end

	return false
end

BTConditions.can_activate.dr_ranger = function (self)
	-- function 3
	local unit = self.unit
	local target_ally_unit = self.target_ally_unit
	local is_prioritized_ally = Managers.state.entity:system("ai_bot_group_system"):is_prioritized_ally(unit, target_ally_unit)
	local ally_distance = self.ally_distance
	local var_3_4 = POSITION_LOOKUP[unit]
	local proximite_enemies = self.proximite_enemies
	local count = #proximite_enemies
	local num = 25
	local num_2 = 0
	local flag

	flag = not is_prioritized_ally and ally_distance < 5 and 5 and 12

	local current_health_percent = self.health_extension:current_health_percent()
	local flag_2

	flag_2 = not self.status_extension:is_wounded() and 0 and current_health_percent

	local num_3 = 2 - flag_2

	for i = 1, count do
		local var_3_13 = proximite_enemies[i]
		local var_3_14 = POSITION_LOOKUP[var_3_13]

		if not (not ALIVE[var_3_13] and not (num >= Vector3.distance_squared(var_3_4, var_3_14))) then
			local var_3_15 = BLACKBOARDS[var_3_13]
			local breed = var_3_15.breed
			local flag_3 = var_3_15.target_unit == unit
			local threat_value = breed.threat_value
			local flag_4

			flag_4 = not flag_3 and 0.25 and 0
			num_2 = num_2 + threat_value * (num_3 + flag_4)

			if flag <= num_2 then
				return true
			end
		end
	end

	return false
end

BTConditions.can_activate.es_mercenary = function (self)
	-- function 4
	local unit = self.unit
	local var_4_1 = POSITION_LOOKUP[unit]
	local num = 225
	local num_2 = 0
	local PLAYER_AND_BOT_UNITS = self.side.PLAYER_AND_BOT_UNITS
	local count = #PLAYER_AND_BOT_UNITS

	for i = 1, count do
		local var_4_6 = PLAYER_AND_BOT_UNITS[i]
		local var_4_7 = POSITION_LOOKUP[var_4_6]
		local distance_squared = Vector3.distance_squared(var_4_1, var_4_7)

		if not (var_4_6 == unit or not (distance_squared < num)) then
			num_2 = num_2 + 1
		end
	end

	local var_4_9
	local num_3 = count - 1
	local flag

	flag = num_3 ~= 0 or not 0.5 or num_2 / num_3

	local proximite_enemies = self.proximite_enemies
	local count_2 = #proximite_enemies
	local num_4 = 49
	local num_5 = 0
	local max = math.max(20 * (1 - flag), 8)
	local current_health_percent = self.health_extension:current_health_percent()
	local flag_2

	flag_2 = not self.status_extension:is_wounded() and 0 and current_health_percent

	local num_6 = 2 - flag_2

	for j = 1, count_2 do
		local var_4_20 = proximite_enemies[j]
		local var_4_21 = POSITION_LOOKUP[var_4_20]

		if not (not ALIVE[var_4_20] and not (num_4 >= Vector3.distance_squared(var_4_1, var_4_21))) then
			local var_4_22 = BLACKBOARDS[var_4_20]
			local breed = var_4_22.breed
			local flag_3 = var_4_22.target_unit == unit
			local threat_value = breed.threat_value
			local flag_4

			flag_4 = not flag_3 and 0.25 and 0
			num_5 = num_5 + threat_value * (num_6 + flag_4)

			if max <= num_5 then
				return true
			end
		end
	end

	return false
end

BTConditions.can_activate.es_huntsman = function (self)
	-- function 5
	local count = #self.proximite_enemies
	local target_unit = self.target_unit

	if not (count ~= 0 or target_unit ~= nil) then
		return false
	end

	local unit = self.unit
	local var_5_3 = POSITION_LOOKUP[unit]
	local var_5_4 = BLACKBOARDS[target_unit]
	local flag = not var_5_4 and var_5_4.breed
	local threat_value

	if not flag then
		threat_value = flag.threat_value

		if not threat_value then
			-- Nothing
		end
	end

	threat_value = 0

	::label_5_0::

	local target_ally_unit = self.target_ally_unit
	local target_ally_need_type = self.target_ally_need_type
	local is_prioritized_ally = Managers.state.entity:system("ai_bot_group_system"):is_prioritized_ally(unit, target_ally_unit)
	local current_health_percent = self.health_extension:current_health_percent()
	local is_wounded = self.status_extension:is_wounded()

	if not (not is_prioritized_ally and target_ally_need_type == "knocked_down" or target_ally_need_type == "hook" or target_ally_need_type ~= "ledge") then
		return true
	elseif current_health_percent < 0.4 or not is_wounded then
		return true
	elseif not (not target_unit and not (threat_value >= 8)) then
		return true
	end

	return false
end

BTConditions.can_activate.es_knight = function (self)
	-- function 6
	local unit = self.unit
	local var_6_1 = POSITION_LOOKUP[unit]
	local target_unit = self.target_unit
	local var_6_3 = BLACKBOARDS[target_unit]
	local flag = not var_6_3 and var_6_3.breed
	local threat_value

	if not flag then
		threat_value = flag.threat_value

		if not threat_value then
			-- Nothing
		end
	end

	threat_value = 0

	::label_6_0::

	local target_ally_unit = self.target_ally_unit
	local target_ally_need_type = self.target_ally_need_type
	local is_prioritized_ally = Managers.state.entity:system("ai_bot_group_system"):is_prioritized_ally(unit, target_ally_unit)
	local var_6_9
	local var_6_10

	if not (not is_prioritized_ally and target_ally_need_type == "knocked_down" or target_ally_need_type ~= "hook") then
		var_6_9 = target_ally_unit
		var_6_10 = self.ally_distance^2
	elseif not (not target_unit and not (threat_value >= 5)) then
		local var_6_11 = POSITION_LOOKUP[target_unit]

		var_6_9 = target_unit
		var_6_10 = Vector3.distance_squared(var_6_1, var_6_11)
	end

	local num = 81
	local num_2 = 12
	local num_3 = 144

	if not (not var_6_9 and not (num < var_6_10) or not (var_6_10 < num_3)) then
		local var_6_15 = POSITION_LOOKUP[var_6_9]
		local num_4 = var_6_1 + Vector3.normalize(var_6_15 - var_6_1) * (num_2 + 2)
		local nav_world = self.nav_world

		if not LocomotionUtils.ray_can_go_on_mesh(nav_world, var_6_1, num_4, nil, 1, 1) then
			self.activate_ability_data.aim_position:store(var_6_15)

			return true
		end
	end

	return false
end

BTConditions.can_activate.we_waywatcher = function (self)
	-- function 7
	local target_unit = self.target_unit

	if not ALIVE[target_unit] then
		return false
	end

	if not BLACKBOARDS[target_unit] then
		return false
	end

	local num = 30

	if not ((target_unit ~= self.priority_target_enemy or not (num >= self.priority_target_distance) or target_unit ~= self.urgent_target_enemy) and not (num >= self.urgent_target_distance) and target_unit ~= self.opportunity_target_enemy or num >= self.opportunity_target_distance) then
		local ranged_obstruction_by_static = self.ranged_obstruction_by_static
		local time = Managers.time:time("game")

		return not (not ranged_obstruction_by_static and ranged_obstruction_by_static.unit ~= target_unit or time <= ranged_obstruction_by_static.timer + 3)
	else
		return false
	end
end

BTConditions.can_activate.we_maidenguard = function (self)
	-- function 8
	local unit = self.unit
	local var_8_1 = POSITION_LOOKUP[unit]
	local target_unit = self.target_unit
	local var_8_3 = BLACKBOARDS[target_unit]
	local flag = not var_8_3 and var_8_3.breed
	local threat_value

	if not flag then
		threat_value = flag.threat_value

		if not threat_value then
			-- Nothing
		end
	end

	threat_value = 0

	::label_8_0::

	local target_ally_unit = self.target_ally_unit
	local target_ally_need_type = self.target_ally_need_type
	local is_prioritized_ally = Managers.state.entity:system("ai_bot_group_system"):is_prioritized_ally(unit, target_ally_unit)
	local var_8_9
	local var_8_10

	if not (not is_prioritized_ally and target_ally_need_type == "knocked_down" or target_ally_need_type ~= "hook") then
		var_8_9 = target_ally_unit
		var_8_10 = self.ally_distance^2
	elseif not (not target_unit and not (threat_value >= 5)) then
		local var_8_11 = POSITION_LOOKUP[target_unit]

		var_8_9 = target_unit
		var_8_10 = Vector3.distance_squared(var_8_1, var_8_11)
	end

	local num = 81
	local num_2 = 12
	local num_3 = 144

	if not (not var_8_9 and not (num < var_8_10) or not (var_8_10 < num_3)) then
		local var_8_15 = POSITION_LOOKUP[var_8_9]
		local num_4 = var_8_1 + Vector3.normalize(var_8_15 - var_8_1) * (num_2 + 2)
		local nav_world = self.nav_world

		if not LocomotionUtils.ray_can_go_on_mesh(nav_world, var_8_1, num_4, nil, 1, 1) then
			self.activate_ability_data.aim_position:store(var_8_15)

			return true
		end
	end

	return false
end

BTConditions.can_activate.we_shade = function (self)
	-- function 9
	local count = #self.proximite_enemies
	local target_unit = self.target_unit

	if not (count ~= 0 or target_unit ~= nil) then
		return false
	end

	local unit = self.unit
	local var_9_3 = POSITION_LOOKUP[unit]
	local var_9_4 = BLACKBOARDS[target_unit]
	local flag = not var_9_4 and var_9_4.breed
	local threat_value

	if not flag then
		threat_value = flag.threat_value

		if not threat_value then
			-- Nothing
		end
	end

	threat_value = 0

	::label_9_0::

	local target_ally_unit = self.target_ally_unit
	local target_ally_need_type = self.target_ally_need_type
	local is_prioritized_ally = Managers.state.entity:system("ai_bot_group_system"):is_prioritized_ally(unit, target_ally_unit)
	local current_health_percent = self.health_extension:current_health_percent()
	local is_wounded = self.status_extension:is_wounded()

	if not (not is_prioritized_ally and target_ally_need_type == "knocked_down" or target_ally_need_type == "hook" or target_ally_need_type ~= "ledge") then
		return true
	elseif current_health_percent < 0.4 or not is_wounded then
		return true
	elseif not (not target_unit and not (threat_value >= 8)) then
		return true
	end

	return false
end

BTConditions.can_activate.wh_captain = function (self)
	-- function 10
	local unit = self.unit
	local var_10_1 = POSITION_LOOKUP[unit]
	local num = 100
	local num_2 = 0
	local PLAYER_AND_BOT_UNITS = self.side.PLAYER_AND_BOT_UNITS
	local count = #PLAYER_AND_BOT_UNITS

	for i = 1, count do
		local var_10_6 = PLAYER_AND_BOT_UNITS[i]
		local extension = ScriptUnit.extension(var_10_6, "status_system")
		local var_10_8 = POSITION_LOOKUP[var_10_6]
		local distance_squared = Vector3.distance_squared(var_10_1, var_10_8)

		if not (var_10_6 == unit or extension:is_disabled() or not (distance_squared < num)) then
			num_2 = num_2 + 1
		end
	end

	local var_10_10
	local num_3 = count - 1
	local flag

	flag = num_3 ~= 0 or not 0.5 or num_2 / num_3

	local proximite_enemies = self.proximite_enemies
	local count_2 = #proximite_enemies
	local num_4 = 49
	local num_5 = 0
	local max = math.max(20 * (1 - flag), 8)
	local current_health_percent = self.health_extension:current_health_percent()
	local flag_2

	flag_2 = not self.status_extension:is_wounded() and 0 and current_health_percent

	local num_6 = 2 - flag_2

	for j = 1, count_2 do
		local var_10_21 = proximite_enemies[j]
		local var_10_22 = POSITION_LOOKUP[var_10_21]

		if not (not ALIVE[var_10_21] and not (num_4 >= Vector3.distance_squared(var_10_1, var_10_22))) then
			local var_10_23 = BLACKBOARDS[var_10_21]
			local breed = var_10_23.breed
			local flag_3 = var_10_23.target_unit == unit
			local threat_value = breed.threat_value
			local flag_4

			flag_4 = not flag_3 and 0.25 and 0
			num_5 = num_5 + threat_value * (num_6 + flag_4)

			if max <= num_5 then
				return true
			end
		end
	end

	return false
end

BTConditions.can_activate.wh_bountyhunter = function (self)
	-- function 11
	local target_unit = self.target_unit

	if not ALIVE[target_unit] then
		return false
	end

	if not BLACKBOARDS[target_unit] then
		return false
	end

	local num = 15

	if not ((target_unit ~= self.priority_target_enemy or not (num >= self.priority_target_distance) or target_unit ~= self.urgent_target_enemy) and not (num >= self.urgent_target_distance) and target_unit ~= self.opportunity_target_enemy or num >= self.opportunity_target_distance) then
		local ranged_obstruction_by_static = self.ranged_obstruction_by_static
		local time = Managers.time:time("game")

		return not (not ranged_obstruction_by_static and ranged_obstruction_by_static.unit ~= target_unit or time <= ranged_obstruction_by_static.timer + 3)
	else
		return false
	end
end

BTConditions.can_activate.wh_zealot = function (self)
	-- function 12
	local unit = self.unit
	local var_12_1 = POSITION_LOOKUP[unit]
	local target_unit = self.target_unit
	local var_12_3 = BLACKBOARDS[target_unit]
	local flag = not var_12_3 and var_12_3.breed
	local threat_value

	if not flag then
		threat_value = flag.threat_value

		if not threat_value then
			-- Nothing
		end
	end

	threat_value = 0

	::label_12_0::

	local target_ally_unit = self.target_ally_unit
	local target_ally_need_type = self.target_ally_need_type
	local is_prioritized_ally = Managers.state.entity:system("ai_bot_group_system"):is_prioritized_ally(unit, target_ally_unit)
	local var_12_9
	local var_12_10

	if not (not is_prioritized_ally and target_ally_need_type == "knocked_down" or target_ally_need_type ~= "hook") then
		var_12_9 = target_ally_unit
		var_12_10 = self.ally_distance^2
	elseif not (not target_unit and not (threat_value >= 8)) then
		local var_12_11 = POSITION_LOOKUP[target_unit]

		var_12_9 = target_unit
		var_12_10 = Vector3.distance_squared(var_12_1, var_12_11)
	end

	local num = 81
	local num_2 = 144

	if not (not var_12_9 and not (num < var_12_10) or not (var_12_10 < num_2)) then
		local var_12_14 = POSITION_LOOKUP[var_12_9]
		local num_3 = var_12_14 + Vector3.normalize(var_12_14 - var_12_1) * 0.5
		local nav_world = self.nav_world

		if not LocomotionUtils.ray_can_go_on_mesh(nav_world, var_12_1, num_3, nil, 1, 1) then
			self.activate_ability_data.aim_position:store(var_12_14)

			return true
		end
	end

	return false
end

BTConditions.can_activate.bw_adept = function (self)
	-- function 13
	local unit = self.unit
	local var_13_1 = POSITION_LOOKUP[unit]
	local target_unit = self.target_unit
	local var_13_3 = BLACKBOARDS[target_unit]
	local flag = not var_13_3 and var_13_3.breed
	local threat_value

	if not flag then
		threat_value = flag.threat_value

		if not threat_value then
			-- Nothing
		end
	end

	threat_value = 0

	::label_13_0::

	local target_ally_unit = self.target_ally_unit
	local target_ally_need_type = self.target_ally_need_type
	local is_prioritized_ally = Managers.state.entity:system("ai_bot_group_system"):is_prioritized_ally(unit, target_ally_unit)
	local var_13_9
	local var_13_10

	if not (not is_prioritized_ally and target_ally_need_type == "knocked_down" or target_ally_need_type ~= "hook") then
		var_13_9 = target_ally_unit
		var_13_10 = self.ally_distance^2
	elseif not (not target_unit and not (threat_value >= 8)) then
		local var_13_11 = POSITION_LOOKUP[target_unit]

		var_13_9 = target_unit
		var_13_10 = Vector3.distance_squared(var_13_1, var_13_11)
	end

	local num = 25
	local num_2 = 100

	if not (not var_13_9 and not (num < var_13_10) or not (var_13_10 < num_2)) then
		local var_13_14 = POSITION_LOOKUP[var_13_9]
		local num_3 = var_13_14 + Vector3.normalize(var_13_14 - var_13_1) * 0.5
		local nav_world = self.nav_world

		if not LocomotionUtils.ray_can_go_on_mesh(nav_world, var_13_1, num_3, nil, 1, 1) then
			self.activate_ability_data.aim_position:store(var_13_14)

			return true
		end
	end

	return false
end

BTConditions.can_activate.bw_scholar = function (self)
	-- function 14
	local target_unit = self.target_unit

	if not ALIVE[target_unit] then
		return false
	end

	if not BLACKBOARDS[target_unit] then
		return false
	end

	local num = 20

	if not ((target_unit ~= self.priority_target_enemy or not (num >= self.priority_target_distance) or target_unit ~= self.urgent_target_enemy) and not (num >= self.urgent_target_distance) and target_unit ~= self.opportunity_target_enemy or num >= self.opportunity_target_distance) then
		local ranged_obstruction_by_static = self.ranged_obstruction_by_static
		local time = Managers.time:time("game")

		return not (not ranged_obstruction_by_static and ranged_obstruction_by_static.unit ~= target_unit or time <= ranged_obstruction_by_static.timer + 3)
	else
		return false
	end
end

BTConditions.can_activate.bw_unchained = function (self)
	-- function 15
	if not self.overcharge_extension:is_above_critical_limit() then
		return true
	end

	local unit = self.unit
	local var_15_1 = POSITION_LOOKUP[unit]
	local proximite_enemies = self.proximite_enemies
	local count = #proximite_enemies
	local num = 16
	local num_2 = 0
	local num_3 = 10

	for i = 1, count do
		local var_15_7 = proximite_enemies[i]
		local var_15_8 = POSITION_LOOKUP[var_15_7]

		if not (not ALIVE[var_15_7] and not (num >= Vector3.distance_squared(var_15_1, var_15_8))) then
			local var_15_9 = BLACKBOARDS[var_15_7]
			local breed = var_15_9.breed
			local flag = var_15_9.target_unit == unit
			local threat_value = breed.threat_value
			local flag_2

			flag_2 = not flag and 1.25 and 1
			num_2 = num_2 + threat_value * flag_2

			if num_3 <= num_2 then
				return true
			end
		end
	end

	return false
end

BTConditions.can_activate_ability = function (self, arg_16_1)
	-- function 16
	local career_extension = self.career_extension
	local is_using_ability = self.activate_ability_data.is_using_ability
	local career_name = career_extension:career_name()
	local var_16_3 = arg_16_1[1]
	local var_16_4 = BTConditions.ability_check_categories[var_16_3]

	if not (not var_16_4 and var_16_4[career_name]) then
		return false
	end

	if not (var_16_3 ~= "shoot_ability" or not ALIVE[self.target_unit] or Unit.has_data(self.target_unit, "breed")) then
		return false
	end

	local var_16_5 = BTConditions.can_activate[career_name]

	if not (var_16_3 == "ranged_weapon" or var_16_3 ~= "melee_weapon") then
		return not var_16_5 and var_16_5(self)
	end

	if not is_using_ability then
		-- Nothing
	end

	::label_16_0::

	local can_use_activated_ability = career_extension:can_use_activated_ability()

	can_use_activated_ability = not can_use_activated_ability and not var_16_5 and var_16_5(self)

	::label_16_1::

	return can_use_activated_ability
end

BTConditions.should_reload_ability_weapon = function (self, arg_17_1)
	-- function 17
	if not (not self.reloading and self.reloading_slot == arg_17_1.wanted_slot) then
		return false
	end

	local career_name = self.career_extension:career_name()
	local var_17_1 = BTConditions.reload_ability_weapon[career_name]

	return not var_17_1 and var_17_1(self, arg_17_1)
end

BTConditions.is_disabled = function (self)
	-- function 18
	local is_knocked_down = self.is_knocked_down

	if not is_knocked_down then
		is_knocked_down = self.is_grabbed_by_pack_master

		if not is_knocked_down then
			is_knocked_down = self.is_pounced_down

			if not is_knocked_down then
				is_knocked_down = self.is_hanging_from_hook

				if not is_knocked_down then
					is_knocked_down = self.is_ledge_hanging
					is_knocked_down = is_knocked_down or self.is_grabbed_by_chaos_spawn
				end
			end
		end
	end

	return is_knocked_down
end

local num = 2
local num_2 = 4
local num_3 = 2.4
local num_4 = num_3 * num_3

local function fn(self, arg_19_1, arg_19_2)
	-- function 19
	local time = Managers.time:time("game")
	local pushed_at_t = self.pushed_at_t
	local block_broken_at_t = self.block_broken_at_t
	local flag = true
	local is_interacting, var_19_5 = arg_19_1:is_interacting()

	if not (not is_interacting and var_19_5 == arg_19_2) then
		local current_fatigue_points, var_19_7 = self:current_fatigue_points()
		local num_3 = var_19_7 - current_fatigue_points
		local blocked_attack = PlayerUnitStatusSettings.fatigue_point_costs.blocked_attack

		flag = current_fatigue_points == 0 or blocked_attack < num_3
	end

	if not (not flag and not (time > pushed_at_t + num) or not (time > block_broken_at_t + num_2)) then
		return true
	else
		return false
	end
end

local num_5 = 4

local function fn_2(arg_20_0, arg_20_1, arg_20_2)
	-- function 20
	local count = #arg_20_1
	local apply_buffs_to_value = ScriptUnit.extension(arg_20_0, "buff_system"):apply_buffs_to_value(1, "faster_revive")
	local num = num_5 + num_5 * (1 - apply_buffs_to_value)
	local num_2 = 0

	for i = 1, count do
		local var_20_4 = arg_20_1[i]

		if not ALIVE[var_20_4] then
			local var_20_5 = BLACKBOARDS[var_20_4]
			local breed = var_20_5.breed
			local threat_value = breed.threat_value

			if (var_20_5.target_unit ~= arg_20_0 or not arg_20_2) and not breed.is_bot_aid_threat then
				num_2 = num_2 + threat_value

				if num < num_2 then
					return true
				end
			end
		end
	end

	return false
end

local function fn_3(arg_21_0, arg_21_1)
	-- function 21
	local is_being_interacted_with = ScriptUnit.extension(arg_21_1, "interactable_system"):is_being_interacted_with()

	return is_being_interacted_with == nil or is_being_interacted_with == arg_21_0
end

local num_6 = BotConstants.default.FLAT_MOVE_TO_EPSILON^2
local Z_MOVE_TO_EPSILON = BotConstants.default.Z_MOVE_TO_EPSILON

local function fn_4(arg_22_0, arg_22_1)
	-- function 22
	local navigation_extension = arg_22_1.navigation_extension
	local destination = navigation_extension:destination()
	local unbox = arg_22_1.target_ally_aid_destination:unbox()

	if not Vector3.equal(destination, unbox) then
		return navigation_extension:destination_reached()
	elseif not navigation_extension:destination_reached() then
		return not arg_22_1.ai_extension:new_destination_distance_check(arg_22_0, destination, unbox, navigation_extension)
	else
		local num = unbox - arg_22_0

		return not (math.abs(num.z) <= Z_MOVE_TO_EPSILON) or Vector3.length_squared(Vector3.flat(num)) <= num_6
	end
end

BTConditions.can_revive = function (self)
	-- function 23
	local target_ally_unit = self.target_ally_unit

	if not (self.interaction_unit ~= target_ally_unit or self.target_ally_need_type ~= "knocked_down") then
		local interaction_extension = self.interaction_extension

		if not fn(self.status_extension, interaction_extension, "revive") then
			return false
		end

		local unit = self.unit

		if not (ScriptUnit.extension(target_ally_unit, "health_system"):current_health_percent() > 0.3) or not fn_2(unit, self.proximite_enemies, self.force_aid) then
			return false
		end

		local ally_distance = self.ally_distance
		local is_interacting, var_23_5 = interaction_extension:is_interacting()

		if not (not is_interacting and var_23_5 ~= "revive" or not (ally_distance <= num_3)) then
			return true
		end

		local var_23_6 = POSITION_LOOKUP[unit]
		local var_23_7 = fn_4(var_23_6, self)

		var_23_7 = var_23_7 or self.is_transported

		if not fn_3(unit, target_ally_unit) and not var_23_7 then
			return true
		end
	end
end

BTConditions.is_there_threat_to_aid = function (arg_24_0, arg_24_1, arg_24_2)
	-- function 24
	return fn_2(arg_24_0, arg_24_1, arg_24_2)
end

BTConditions.can_heal_player = function (self)
	-- function 25
	local target_ally_unit = self.target_ally_unit
	local flag = not target_ally_unit and ScriptUnit.extension(target_ally_unit, "career_system")
	local flag_2 = not target_ally_unit and ScriptUnit.extension(target_ally_unit, "status_system")

	if not (not flag and flag:career_name() ~= "wh_zealot" and not flag_2 and not (flag_2:num_wounds_remaining() > 1)) then
		return false
	end

	if not (self.interaction_unit ~= target_ally_unit or self.target_ally_need_type ~= "in_need_of_heal") then
		local is_interacting, var_25_4 = self.interaction_extension:is_interacting()

		if not (not is_interacting and var_25_4 ~= "heal") then
			return true
		end

		if #self.proximite_enemies > 0 then
			return false
		end

		local unit = self.unit
		local var_25_6 = POSITION_LOOKUP[unit]
		local var_25_7 = fn_4(var_25_6, self)
		local var_25_8 = fn_3(unit, target_ally_unit)
		local current_velocity = ScriptUnit.extension(target_ally_unit, "locomotion_system"):current_velocity()
		local length_squared = Vector3.length_squared(current_velocity)
		local ally_distance = self.ally_distance

		if not (not var_25_8 and var_25_7 or not (length_squared > 0.04000000000000001) or not (ally_distance <= num_3)) then
			return true
		end
	end
end

BTConditions.can_help_in_need_player = function (self, arg_26_1)
	-- function 26
	local var_26_0 = arg_26_1[1]
	local target_ally_unit = self.target_ally_unit

	if not (self.interaction_unit ~= target_ally_unit or self.target_ally_need_type ~= var_26_0) then
		local unit = self.unit
		local var_26_3 = POSITION_LOOKUP[unit]
		local var_26_4 = fn_4(var_26_3, self)
		local var_26_5 = fn_3(unit, target_ally_unit)
		local current_velocity = ScriptUnit.extension(target_ally_unit, "locomotion_system"):current_velocity()
		local length_squared = Vector3.length_squared(current_velocity)
		local ally_distance = self.ally_distance

		if not (not var_26_5 and var_26_4 or not (length_squared > 0.04000000000000001) or not (ally_distance <= num_3)) then
			return true
		end
	end
end

BTConditions.can_rescue_hanging_from_hook = function (self)
	-- function 27
	local target_ally_unit = self.target_ally_unit

	if not (self.interaction_unit ~= target_ally_unit or self.target_ally_need_type ~= "hook") then
		if not fn(self.status_extension, self.interaction_extension, "release_from_hook") then
			return false
		end

		local unit = self.unit

		if not fn_2(unit, self.proximite_enemies, self.force_aid) then
			return false
		end

		local var_27_2 = POSITION_LOOKUP[unit]
		local var_27_3 = fn_3(unit, target_ally_unit)
		local var_27_4 = fn_4(var_27_2, self)

		if not var_27_3 and not var_27_4 then
			return true
		end
	end
end

BTConditions.can_rescue_ledge_hanging = function (self)
	-- function 28
	local target_ally_unit = self.target_ally_unit

	if not (self.interaction_unit ~= target_ally_unit or self.target_ally_need_type ~= "ledge") then
		if not fn(self.status_extension, self.interaction_extension, "pull_up") then
			return false
		end

		local unit = self.unit

		if not fn_2(unit, self.proximite_enemies, self.force_aid) then
			return false
		end

		local var_28_2 = POSITION_LOOKUP[unit]
		local var_28_3 = fn_3(unit, target_ally_unit)
		local var_28_4 = fn_4(var_28_2, self)

		if not var_28_3 and not var_28_4 then
			return true
		end
	end
end

BTConditions.can_loot = function (self)
	-- function 29
	local system = Managers.state.entity:system("play_go_tutorial_system")

	if not (not system and system:bot_loot_enabled()) then
		return false
	end

	local num = 3.2
	local flag = self.forced_pickup_unit == self.interaction_unit
	local health_pickup = self.health_pickup

	if not health_pickup then
		health_pickup = self.allowed_to_take_health_pickup
		health_pickup = not health_pickup and self.health_pickup ~= self.interaction_unit or flag or num > self.health_dist
	end

	local ammo_pickup = self.ammo_pickup

	if not ammo_pickup then
		ammo_pickup = self.has_ammo_missing
		ammo_pickup = not ammo_pickup and self.ammo_pickup ~= self.interaction_unit or flag or num > self.ammo_dist
	end

	local mule_pickup = self.mule_pickup

	mule_pickup = not mule_pickup and self.mule_pickup ~= self.interaction_unit or flag or self.mule_pickup_dist_squared < num^2

	return health_pickup or ammo_pickup or mule_pickup
end

BTConditions.bot_should_heal = function (self)
	-- function 30
	local unit = self.unit
	local inventory_extension = self.inventory_extension
	local get_slot_data = inventory_extension:get_slot_data("slot_healthkit")
	local flag = not get_slot_data and inventory_extension:get_item_template(get_slot_data)

	if not (not flag and flag.can_heal_self) then
		return false
	end

	local has_buff_type = ScriptUnit.extension(unit, "buff_system"):has_buff_type("trait_necklace_no_healing_health_regen")
	local is_wounded = self.status_extension:is_wounded()
	local force_use_health_pickup = self.force_use_health_pickup

	if not (not has_buff_type and is_wounded or force_use_health_pickup) then
		return false
	end

	local flag_2 = self.health_extension:current_health_percent() <= flag.bot_heal_threshold
	local flag_3 = self.health_extension:current_permanent_health_percent() <= flag.bot_heal_threshold
	local flag_4 = self.health_extension:get_max_health() <= 75
	local target_unit = self.target_unit

	return not (not target_unit and flag.fast_heal or not self.is_healing_self or #self.proximite_enemies == 0 or target_unit == self.priority_target_enemy or target_unit == self.urgent_target_enemy or target_unit == self.proximity_target_enemy or target_unit ~= self.slot_target_enemy) and (force_use_health_pickup or has_buff_type or flag_2 or is_wounded or flag_3 or not flag_4 or not has_buff_type) and not flag_2 and is_wounded
end

BTConditions.is_slot_not_wielded = function (self, arg_31_1)
	-- function 31
	local wielded_slot = self.inventory_extension:equipment().wielded_slot
	local var_31_1 = arg_31_1[1]
	local var_31_2 = arg_31_1[2]

	if not (not var_31_2 and var_31_2 ~= wielded_slot) then
		return false
	else
		return wielded_slot ~= var_31_1
	end
end

BTConditions.is_wanted_slot_not_wielded = function (self, arg_32_1)
	-- function 32
	local wielded_slot = self.inventory_extension:equipment().wielded_slot
	local var_32_1 = self[arg_32_1[1]]
	local var_32_2 = arg_32_1[2]

	if not (not var_32_2 and var_32_1 == var_32_2) then
		return false
	else
		return var_32_1 ~= wielded_slot
	end
end

BTConditions.has_double_weapon_slots = function (self, arg_33_1)
	-- function 33
	return self.double_weapons == arg_33_1[1]
end

BTConditions.has_better_alt_weapon = function (self, arg_34_1)
	-- function 34
	local var_34_0 = arg_34_1[1]

	if self.double_weapons == var_34_0 then
		local weapon_scores = self.weapon_scores

		if not weapon_scores then
			local var_34_2 = arg_34_1[2]
			local score = weapon_scores[var_34_0].score

			score = score or -1

			local score_2 = weapon_scores[var_34_2].score

			score_2 = score_2 or -1

			return score < score_2
		end
	end

	return false
end

BTConditions.needs_weapon_swap = function (arg_35_0, arg_35_1)
	-- function 35
	if not BTConditions.has_double_weapon_slots(arg_35_0, arg_35_1) and not BTConditions.has_better_alt_weapon(arg_35_0, arg_35_1) then
		return BTConditions.is_slot_not_wielded(arg_35_0, {
			arg_35_1[2]
		})
	end

	return BTConditions.is_slot_not_wielded(arg_35_0, {
		arg_35_1[1]
	})
end

BTConditions.has_priority_or_opportunity_target = function (self)
	-- function 36
	local target_unit = self.target_unit

	if not ALIVE[target_unit] then
		return false
	end

	local num = 40

	return (target_unit ~= self.priority_target_enemy or not (num > self.priority_target_distance) or self.revive_with_urgent_target) and (target_unit ~= self.urgent_target_enemy or not (num > self.urgent_target_distance)) and target_unit ~= self.opportunity_target_enemy or num > self.opportunity_target_distance
end

BTConditions.bot_in_melee_range = function (self)
	-- function 37
	local target_unit = self.target_unit

	if not ALIVE[target_unit] then
		return false
	end

	local unit = self.unit
	local wielded_slot = self.inventory_extension:equipment().wielded_slot
	local var_37_3
	local get_data = Unit.get_data(target_unit, "breed")
	local get_party_danger = AiUtils.get_party_danger()

	if self.urgent_target_enemy == target_unit or self.opportunity_target_enemy == target_unit or not Vector3.is_valid(self.taking_cover.cover_position:unbox()) then
		var_37_3 = not get_data and get_data.bot_opportunity_target_melee_range and 3

		if wielded_slot == "slot_ranged" then
			var_37_3 = not get_data and get_data.bot_opportunity_target_melee_range_while_ranged and 2
		end
	elseif wielded_slot == "slot_ranged" then
		var_37_3 = math.lerp(10, 3.5, get_party_danger)
	else
		var_37_3 = math.lerp(12, 5, get_party_danger)
	end

	local num = AiUtils.bot_melee_aim_pos(unit, target_unit) - POSITION_LOOKUP[unit]
	local flag = Vector3.length_squared(num) < var_37_3^2
	local z = num.z

	return not flag and not (z > -1.5) or z < 2
end

BTConditions.has_target_and_ammo_greater_than = function (self, arg_38_1)
	-- function 38
	local target_unit = self.target_unit

	if not ALIVE[target_unit] then
		return false
	end

	local get_data = Unit.get_data(target_unit, "breed")

	if get_data == nil then
		return false
	end

	local inventory_extension = self.inventory_extension
	local get_slot_data = inventory_extension:get_slot_data("slot_ranged")
	local get_item_template = inventory_extension:get_item_template(get_slot_data)
	local flag = not get_item_template and get_item_template.buff_type

	if not RangedBuffTypes[flag] then
		return false
	end

	local has_extension = ScriptUnit.has_extension(target_unit, "buff_system")

	if not has_extension and not has_extension:has_buff_perk("invulnerable_ranged") then
		return false
	end

	local current_ammo_status, var_38_8 = inventory_extension:current_ammo_status("slot_ranged")
	local flag_2 = not current_ammo_status and current_ammo_status / var_38_8 > arg_38_1.ammo_percentage
	local overcharge_extension = self.overcharge_extension
	local overcharge_limit_type = arg_38_1.overcharge_limit_type
	local current_overcharge_status, var_38_13, var_38_14 = overcharge_extension:current_overcharge_status()
	local flag_3 = (current_overcharge_status == 0 or overcharge_limit_type ~= "threshold" or not (current_overcharge_status / var_38_13 < arg_38_1.overcharge_limit)) and overcharge_limit_type ~= "maximum" or current_overcharge_status / var_38_14 < arg_38_1.overcharge_limit
	local ranged_obstruction_by_static = self.ranged_obstruction_by_static
	local time = Managers.time:time("game")
	local flag_4 = not ranged_obstruction_by_static and ranged_obstruction_by_static.unit ~= self.target_unit or time <= ranged_obstruction_by_static.timer + 3
	local has_breed_categories = AiUtils.has_breed_categories(get_data.category_mask, get_item_template.attack_meta_data.effective_against_combined)

	return not flag_2 and not flag_3 and not not flag_4 or has_breed_categories
end

BTConditions.should_vent_overcharge = function (self, arg_39_1)
	-- function 39
	local overcharge_extension = self.overcharge_extension
	local overcharge_limit_type = arg_39_1.overcharge_limit_type
	local current_overcharge_status, var_39_3, var_39_4 = overcharge_extension:current_overcharge_status()
	local num = 0

	if overcharge_limit_type == "threshold" then
		num = current_overcharge_status / var_39_3
	elseif overcharge_limit_type == "maximum" then
		num = current_overcharge_status / var_39_4
	end

	local var_39_6

	if not self.reloading then
		var_39_6 = num >= arg_39_1.stop_percentage
	else
		var_39_6 = not (num >= arg_39_1.start_min_percentage) or num <= arg_39_1.start_max_percentage
	end

	return var_39_6
end

BTConditions.should_recall_unique_ammo = function (self, arg_40_1)
	-- function 40
	local inventory_extension = self.inventory_extension

	if not inventory_extension:has_unique_ammo_type_weapon_equipped() then
		return false
	end

	local current_ammo_status, var_40_2 = inventory_extension:current_ammo_status("slot_ranged")

	if not (not current_ammo_status and var_40_2) then
		return false
	end

	local num = current_ammo_status / var_40_2
	local var_40_4

	if not self.reloading then
		var_40_4 = current_ammo_status ~= var_40_2
	else
		var_40_4 = num <= arg_40_1.ammo_percentage_threshold
	end

	return var_40_4
end

BTConditions.should_reload_weapon = function (self, arg_41_1)
	-- function 41
	local get_slot_data = self.inventory_extension:get_slot_data("slot_ranged")
	local flag = not get_slot_data and get_slot_data.right_unit_1p
	local flag_2 = not get_slot_data and get_slot_data.left_unit_1p
	local get_ammo_extension = GearUtils.get_ammo_extension(flag, flag_2)

	if not get_ammo_extension then
		return false
	end

	local var_41_4

	if not self.reloading then
		var_41_4 = not (get_ammo_extension:remaining_ammo() > 0) or not not get_ammo_extension:clip_full() or self.reloading_slot == arg_41_1[1]
	else
		var_41_4 = get_ammo_extension:can_reload()
	end

	return var_41_4
end

BTConditions.wants_to_reload_weapon = function (self, arg_42_1)
	-- function 42
	return self.wanted_slot_to_reload ~= nil
end

BTConditions.can_open_door = function (self)
	-- function 43
	local flag = false

	if self.interaction_type == "door" then
		local interaction_unit = self.interaction_unit
		local alive = Unit.alive(interaction_unit)

		alive = not alive and ScriptUnit.has_extension(interaction_unit, "door_system")

		if not alive then
			flag = alive:get_current_state() == "closed"
		end
	end

	return flag
end

BTConditions.bot_at_breakable = function (self)
	-- function 44
	local navigation_extension = self.navigation_extension
	local is_in_transition = navigation_extension:is_in_transition()

	is_in_transition = not is_in_transition and navigation_extension:transition_type() == "planks"

	return is_in_transition
end

BTConditions.cant_reach_ally = function (self)
	-- function 45
	local follow_unit = self.ai_bot_group_extension.data.follow_unit

	if not ALIVE[follow_unit] and not self.has_teleported then
		return false
	end

	local unit = self.unit
	local conflict = Managers.state.conflict
	local get_player_unit_segment = conflict:get_player_unit_segment(unit)
	local get_player_unit_segment_2 = conflict:get_player_unit_segment(follow_unit)

	if not (not get_player_unit_segment and get_player_unit_segment_2) then
		return false
	end

	if not (get_player_unit_segment_2 < get_player_unit_segment) then
		return false
	end

	local flag = get_player_unit_segment < get_player_unit_segment_2
	local extension = ScriptUnit.extension(unit, "whereabouts_system")
	local extension_2 = ScriptUnit.extension(follow_unit, "whereabouts_system")
	local last_position_on_navmesh = extension:last_position_on_navmesh()
	local last_position_on_navmesh_2 = extension_2:last_position_on_navmesh()

	if not (not last_position_on_navmesh and last_position_on_navmesh_2) then
		return false
	end

	local time = Managers.time:time("game")
	local successive_failed_paths, var_45_12 = self.navigation_extension:successive_failed_paths()
	local moving_toward_follow_position = self.moving_toward_follow_position

	if not moving_toward_follow_position then
		local flag_2

		flag_2 = not flag and 1 and 5
		moving_toward_follow_position = not (flag_2 < successive_failed_paths) or time - var_45_12 > 5
	end

	return moving_toward_follow_position
end

local num_7 = 1600

BTConditions.should_teleport = function (self)
	-- function 46
	local follow_unit = self.ai_bot_group_extension.data.follow_unit

	if not ALIVE[follow_unit] and not self.has_teleported then
		return false
	end

	local unit = self.unit
	local conflict = Managers.state.conflict
	local get_player_unit_segment = conflict:get_player_unit_segment(unit)

	get_player_unit_segment = get_player_unit_segment or 1

	local get_player_unit_segment_2 = conflict:get_player_unit_segment(follow_unit)

	if not (not get_player_unit_segment_2 and not (get_player_unit_segment_2 < get_player_unit_segment)) then
		return false
	end

	local target_unit = self.target_unit

	target_unit = not target_unit and self.target_unit == self.priority_target_enemy

	if self.target_ally_need_type or not target_unit then
		return false
	end

	local extension = ScriptUnit.extension(unit, "whereabouts_system")
	local extension_2 = ScriptUnit.extension(follow_unit, "whereabouts_system")
	local last_position_on_navmesh = extension:last_position_on_navmesh()
	local last_position_on_navmesh_2 = extension_2:last_position_on_navmesh()

	if not (not last_position_on_navmesh and last_position_on_navmesh_2) then
		return false
	end

	return Vector3.distance_squared(last_position_on_navmesh, last_position_on_navmesh_2) >= num_7
end

BTConditions.should_drop_grimoire = function (self)
	-- function 47
	local inventory_extension = self.inventory_extension
	local str = "slot_potion"
	local get_slot_data = inventory_extension:get_slot_data(str)

	if not get_slot_data then
		local is_grimoire = inventory_extension:get_item_template(get_slot_data).is_grimoire
		local get_pickup_order = Managers.state.entity:system("ai_bot_group_system"):get_pickup_order(self.unit, str)

		return not is_grimoire and get_pickup_order == nil and get_pickup_order.pickup_name ~= "grimoire"
	end

	return false
end

DLCUtils.require_list("bot_conditions")
