-- chunkname: @scripts/entity_system/systems/behaviour/nodes/bt_combo_attack_action.lua

require("scripts/entity_system/systems/behaviour/nodes/bt_node")

BTComboAttackAction = class(BTComboAttackAction, BTNode)

local num = 20

BTComboAttackAction.init = function (self, ...)
	-- function 1
	BTComboAttackAction.super.init(self, ...)

	self.last_attack_time = 0
	self.dodge_timer = 0
end

BTComboAttackAction.name = "BTComboAttackAction"

BTComboAttackAction.enter = function (self, arg_2_1, arg_2_2, arg_2_3)
	-- function 2
	local action_data = self._tree_node.action_data

	arg_2_2.action = action_data
	arg_2_2.active_node = BTComboAttackAction
	arg_2_2.attack_finished = false
	arg_2_2.attack_aborted = false
	arg_2_2.attack_damage_triggered = false
	arg_2_2.attack_token = true
	arg_2_2.keep_target = true

	local target_unit = arg_2_2.target_unit
	local has_extension = ScriptUnit.has_extension(target_unit, "status_system")

	if not has_extension then
		has_extension:add_combo_target_count(1)

		arg_2_2.target_status_extension = has_extension
	end

	arg_2_2.attacking_target = target_unit
	arg_2_2.move_state = "attacking"

	local local_rotation = Unit.local_rotation(arg_2_1, 0)
	local has_extension_2 = ScriptUnit.has_extension(target_unit, "locomotion_system")

	arg_2_2.target_locomotion_extension = has_extension_2

	local current_velocity

	if not has_extension_2 then
		current_velocity = has_extension_2:current_velocity()

		if not current_velocity then
			-- Nothing
		end
	end

	current_velocity = Vector3.zero()

	::label_2_0::

	local combo_attack_data = arg_2_2.combo_attack_data

	if not combo_attack_data then
		combo_attack_data.aborted = false
		combo_attack_data.attack_start_time = math.huge
		combo_attack_data.attacking_target = target_unit
		combo_attack_data.blocked = false
		combo_attack_data.has_been_blocked = false
		combo_attack_data.successful_hit = false
		combo_attack_data.is_animation_driven = false

		combo_attack_data.rotation_target:store(local_rotation)

		combo_attack_data.refresh_last_target_position = false
		combo_attack_data.last_target_position_time = arg_2_3

		combo_attack_data.last_target_position:store(POSITION_LOOKUP[target_unit])
		combo_attack_data.last_target_velocity:store(current_velocity)
	else
		combo_attack_data = {
			successful_hit = false,
			aborted = false,
			is_animation_driven = false,
			refresh_last_target_position = false,
			has_been_blocked = false,
			blocked = false,
			attack_start_time = math.huge,
			attacking_target = target_unit,
			pushed_targets = {},
			rotation_target = QuaternionBox(local_rotation),
			last_target_position_time = arg_2_3,
			last_target_position = Vector3Box(POSITION_LOOKUP[target_unit]),
			last_target_velocity = Vector3Box(current_velocity)
		}
		arg_2_2.combo_attack_data = combo_attack_data
	end

	if not action_data.combo_attack_cycle_index then
		local combo_anim_variations = action_data.combo_anim_variations
		local num = action_data.combo_attack_cycle_index % combo_anim_variations + 1

		combo_attack_data.attack_variation = num
		action_data.combo_attack_cycle_index = num
	else
		combo_attack_data.attack_variation = Math.random(1, action_data.combo_anim_variations)
	end

	if not action_data.start_sound_event then
		Managers.state.entity:system("dialogue_system"):trigger_general_unit_event(arg_2_1, action_data.start_sound_event)
	end

	local has_extension_3 = ScriptUnit.has_extension(target_unit, "ai_slot_system")

	if not arg_2_2.attack_token and not has_extension then
		local breed = arg_2_2.breed

		if not (not breed.use_backstab_vo and not has_extension_3 and not (has_extension_3.num_occupied_slots <= 5)) then
			local unit_owner = Managers.player:unit_owner(target_unit)

			if not (not unit_owner and unit_owner.bot_player) then
				local unit_is_flanking_player = AiUtils.unit_is_flanking_player(arg_2_1, target_unit)

				if not unit_is_flanking_player then
					arg_2_2.backstab_attack_trigger = true
				end

				if not unit_owner.local_player then
					if not unit_is_flanking_player then
						local extension = ScriptUnit.extension(arg_2_1, "dialogue_system")
						local make_unit_auto_source, var_2_15 = WwiseUtils.make_unit_auto_source(arg_2_2.world, arg_2_1, extension.voice_node)
						local backstab_player_sound_event = breed.backstab_player_sound_event

						Managers.state.entity:system("audio_system"):_play_event_with_source(var_2_15, backstab_player_sound_event, make_unit_auto_source)
					end
				else
					local network = Managers.state.network
					local network_transmit = network.network_transmit
					local unit_game_object_id = network:unit_game_object_id(arg_2_1)
					local network_id = unit_owner:network_id()

					network_transmit:send_rpc("rpc_check_trigger_backstab_sfx", network_id, unit_game_object_id)
				end
			end
		end
	end

	AiUtils.add_attack_intensity(target_unit, action_data, arg_2_2)
	self:_start_attack(arg_2_1, arg_2_2, arg_2_3, action_data, "attack_1")
end

local function fn(self, arg_3_1)
	-- function 3
	local combo_attack_data = arg_3_1.combo_attack_data

	if type(self) == "table" then
		return self[combo_attack_data.attack_variation]
	else
		return self
	end
end

BTComboAttackAction._start_attack = function (self, arg_4_1, arg_4_2, arg_4_3, arg_4_4, arg_4_5)
	-- function 4
	self.last_attack_time = arg_4_3

	local var_4_0 = arg_4_4.combo_attacks[arg_4_5]
	local flag = arg_4_2.target_speed_away > 1.5 or arg_4_2.target_dist > 3
	local var_4_2 = fn
	local move_anim

	if not flag then
		move_anim = var_4_0.move_anim

		if not move_anim then
			-- Nothing
		end
	end

	move_anim = var_4_0.anim

	::label_4_0::

	local var_4_4 = var_4_2(move_anim, arg_4_2)

	Managers.state.network:anim_event(arg_4_1, var_4_4)

	arg_4_2.attack_anim = var_4_4

	local combo_attack_data = arg_4_2.combo_attack_data
	local attacking_target = combo_attack_data.attacking_target

	combo_attack_data.current_attack_name = arg_4_5
	combo_attack_data.successful_hit = false
	arg_4_2.attack_finished = false
	arg_4_2.attack_damage_triggered = false
	arg_4_2.target_dodged_during_attack = false

	if not combo_attack_data.refresh_last_target_position then
		combo_attack_data.refresh_last_target_position = false

		self:_set_target_position(arg_4_2, combo_attack_data, POSITION_LOOKUP[attacking_target], arg_4_3)
	end

	combo_attack_data.has_been_blocked = false
	combo_attack_data.attack_start_time = arg_4_3
	combo_attack_data.push_non_targets = var_4_0.push_non_targets

	table.clear(combo_attack_data.pushed_targets)

	local target_status_extension = arg_4_2.target_status_extension
	local is_animation_driven

	if not combo_attack_data.is_animation_driven then
		is_animation_driven = var_4_0.is_animation_driven

		if not is_animation_driven and not target_status_extension then
			-- Nothing
		end

		::label_4_1::

		is_animation_driven = not target_status_extension:is_knocked_down()
	else
		is_animation_driven = false
	end

	if false then
		is_animation_driven = true
	end

	::label_4_2::

	if not is_animation_driven then
		LocomotionUtils.set_animation_driven_movement(arg_4_1, true, true, true)

		combo_attack_data.is_animation_driven = true

		arg_4_2.navigation_extension:set_max_speed(0)
	elseif not (not combo_attack_data.is_animation_driven and var_4_0.is_animation_driven) then
		LocomotionUtils.set_animation_driven_movement(arg_4_1, false)

		combo_attack_data.is_animation_driven = false
	end

	arg_4_2.locomotion_extension:set_rotation_speed(num)

	if not (var_4_0.rotation_scheme == "on_enter" or var_4_0.rotation_scheme ~= "continuous") then
		self:_update_rotation_target(arg_4_3, arg_4_1, arg_4_2, combo_attack_data)
	end

	if not var_4_0.bot_threat_duration then
		local rotation_towards_unit_flat = LocomotionUtils.rotation_towards_unit_flat(arg_4_1, attacking_target)
		local bot_threat_range = var_4_0.bot_threat_range

		bot_threat_range = bot_threat_range or 2

		local bot_threat_width = var_4_0.bot_threat_width

		bot_threat_width = bot_threat_width or 1

		local num_2 = bot_threat_range * 0.5
		local num_3 = Quaternion.rotate(rotation_towards_unit_flat, Vector3.forward()) * num_2
		local num_4 = POSITION_LOOKUP[arg_4_1] + num_3 + Vector3.up() * 0.5

		Managers.state.entity:system("ai_bot_group_system"):aoe_threat_created(num_4, "oobb", Vector3(bot_threat_width, bot_threat_range, 0.5), rotation_towards_unit_flat, var_4_0.bot_threat_duration, "Combo Attack")
	end

	local damage_done_time = var_4_0.damage_done_time

	if not damage_done_time then
		if type(damage_done_time) == "table" then
			combo_attack_data.damage_done_time = arg_4_3 + damage_done_time[var_4_4]
		else
			combo_attack_data.damage_done_time = arg_4_3 + damage_done_time
		end
	end
end

BTComboAttackAction.leave = function (arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4, arg_5_5)
	-- function 5
	if arg_5_2.move_state ~= "idle" then
		Managers.state.network:anim_event(arg_5_1, "idle")

		arg_5_2.move_state = "idle"
	end

	local combo_attack_data = arg_5_2.combo_attack_data

	if not (not combo_attack_data.is_animation_driven and arg_5_5) then
		LocomotionUtils.set_animation_driven_movement(arg_5_1, false)

		combo_attack_data.is_animation_driven = false
	end

	local target_status_extension = arg_5_2.target_status_extension

	if not target_status_extension then
		target_status_extension:add_combo_target_count(-1)
	end

	if not arg_5_5 then
		arg_5_2.locomotion_extension:set_rotation_speed()
	end

	arg_5_2.attack_damage_triggered = false
	arg_5_2.active_node = nil
	arg_5_2.attack_aborted = nil
	arg_5_2.attacking_target = nil
	arg_5_2.anim_cb_damage = nil
	arg_5_2.target_locomotion_extension = nil
	arg_5_2.target_status_extension = nil
	arg_5_2.target_dodged_during_attack = nil
	arg_5_2.anim_cb_move_stop = nil
	arg_5_2.action = nil
	arg_5_2.attack_token = nil
	arg_5_2.backstab_attack_trigger = nil
	arg_5_2.keep_target = nil

	if arg_5_4 == "aborted" then
		combo_attack_data.aborted = true
	end

	combo_attack_data.damage_done_time = nil

	arg_5_2.navigation_extension:set_max_speed(arg_5_2.breed.run_speed)
end

BTComboAttackAction.run = function (self, arg_6_1, arg_6_2, arg_6_3, arg_6_4)
	-- function 6
	local combo_attack_data = arg_6_2.combo_attack_data
	local attacking_target = combo_attack_data.attacking_target

	if not (arg_6_2.attack_aborted or Unit.alive(attacking_target)) then
		combo_attack_data.aborted = true

		return "done"
	end

	local action = arg_6_2.action
	local var_6_3 = action.combo_attacks[combo_attack_data.current_attack_name]

	if not combo_attack_data.blocked then
		combo_attack_data.blocked = false
		combo_attack_data.has_been_blocked = true
	end

	if not (not combo_attack_data.damage_done_time and not (arg_6_3 > combo_attack_data.damage_done_time)) then
		combo_attack_data.damage_done_time = nil
		arg_6_2.attacking_target = nil
	end

	if arg_6_2.attack_finished or not combo_attack_data.has_been_blocked or not var_6_3.block_interrupts then
		local successful_hit = combo_attack_data.successful_hit
		local next_blocked

		if not combo_attack_data.has_been_blocked then
			next_blocked = var_6_3.next_blocked

			if not next_blocked then
				-- Nothing
			end
		end

		if not successful_hit then
			next_blocked = var_6_3.next_hit

			if not next_blocked then
				-- Nothing
			end
		end

		next_blocked = var_6_3.next

		::label_6_0::

		local var_6_6 = fn(next_blocked, arg_6_2)

		if not var_6_3.combo_cooldown_start then
			Unit.set_data(attacking_target, "last_combo_t", arg_6_3)
		end

		if var_6_6 == "done" then
			return "done"
		elseif var_6_6 == "stagger" then
			arg_6_2.blocked = true

			return "done"
		else
			self:_start_attack(arg_6_1, arg_6_2, arg_6_3, action, var_6_6)
		end
	end

	if not (not not arg_6_2.anim_cb_move_stop or not not combo_attack_data.is_animation_driven or attacking_target) then
		self:_follow(arg_6_4, arg_6_3, arg_6_1, arg_6_2, var_6_3)
	else
		arg_6_2.navigation_extension:set_max_speed(0)
	end

	local flag

	flag = not arg_6_2.attack_damage_triggered and "no_rotation" and var_6_3.rotation_scheme

	if flag == "continuous" then
		self:_update_rotation_target(arg_6_3, arg_6_1, arg_6_2, combo_attack_data)
	elseif type(flag) == "table" then
		self:_update_rotation_target_lerped(arg_6_3, arg_6_1, arg_6_2, combo_attack_data, flag)
	end

	arg_6_2.locomotion_extension:set_wanted_rotation(combo_attack_data.rotation_target:unbox())

	local push_non_targets = combo_attack_data.push_non_targets

	if not push_non_targets then
		local normalize = Vector3.normalize(Vector3.flat(Quaternion.forward(combo_attack_data.rotation_target:unbox())))

		self:_push_non_targets(arg_6_1, POSITION_LOOKUP[arg_6_1], attacking_target, combo_attack_data, normalize, push_non_targets.close_impact_radius, push_non_targets.far_impact_radius, push_non_targets.forward_impact_speed, push_non_targets.lateral_impact_speed)
	end

	return "running"
end

BTComboAttackAction._follow = function (self, arg_7_1, arg_7_2, arg_7_3, arg_7_4, arg_7_5)
	-- function 7
	local breed = arg_7_4.breed
	local attacking_target = arg_7_4.combo_attack_data.attacking_target
	local weapon_reach = breed.weapon_reach

	weapon_reach = weapon_reach or 2

	local num = weapon_reach^2
	local num_2 = POSITION_LOOKUP[attacking_target] - POSITION_LOOKUP[arg_7_3]
	local length_squared = Vector3.length_squared(num_2)
	local run_speed = arg_7_5.run_speed

	run_speed = run_speed or breed.run_speed

	if length_squared < num then
		local target_locomotion_extension = arg_7_4.target_locomotion_extension
		local average_velocity

		if not target_locomotion_extension and not target_locomotion_extension.average_velocity then
			average_velocity = target_locomotion_extension:average_velocity()

			if not average_velocity then
				-- Nothing
			end
		end

		average_velocity = Vector3.zero()

		::label_7_0::

		run_speed = math.max(math.min(run_speed, Vector3.dot(average_velocity, Vector3.normalize(num_2))), 0)
	end

	local attack_start_slow_factor_time = arg_7_5.attack_start_slow_factor_time

	if not attack_start_slow_factor_time then
		attack_start_slow_factor_time = breed.attack_start_slow_factor_time
		attack_start_slow_factor_time = attack_start_slow_factor_time or 0.3
	end

	if arg_7_2 < self.last_attack_time + attack_start_slow_factor_time then
		local attack_start_slow_fraction = arg_7_5.attack_start_slow_fraction

		if not attack_start_slow_fraction then
			attack_start_slow_fraction = breed.attack_start_slow_fraction
			attack_start_slow_fraction = attack_start_slow_fraction or 0
		end

		run_speed = run_speed * (1 - attack_start_slow_fraction + attack_start_slow_fraction * ((arg_7_2 - self.last_attack_time) / attack_start_slow_factor_time))
	end

	local attack_stop_time = arg_7_5.attack_stop_time

	if not attack_stop_time then
		attack_stop_time = breed.attack_stop_time
		attack_stop_time = attack_stop_time or nil
	end

	if not (not attack_stop_time and not (arg_7_2 > self.last_attack_time + attack_stop_time)) then
		run_speed = 0
	end

	if not (not arg_7_4.target_dodged_during_attack and not (arg_7_2 < self.dodge_timer)) then
		run_speed = math.clamp(run_speed, 0, 3)
	end

	arg_7_4.navigation_extension:set_max_speed(run_speed)
end

BTComboAttackAction.attack_success = function (arg_8_0, arg_8_1, arg_8_2)
	-- function 8
	if not arg_8_2.breed.use_backstab_vo and not arg_8_2.backstab_attack_trigger then
		Managers.state.entity:system("dialogue_system"):trigger_backstab_hit(arg_8_2.target_unit, arg_8_1)

		arg_8_2.backstab_attack_trigger = false
	end

	arg_8_2.combo_attack_data.successful_hit = true
end

BTComboAttackAction._update_rotation_target = function (self, arg_9_1, arg_9_2, arg_9_3, arg_9_4)
	-- function 9
	local target_status_extension = arg_9_3.target_status_extension

	if not target_status_extension then
		-- Nothing
	end

	::label_9_0::

	local get_is_dodging = target_status_extension:get_is_dodging()

	get_is_dodging = get_is_dodging or target_status_extension:is_invisible()

	::label_9_1::

	local var_9_2

	if not (not get_is_dodging and arg_9_3.target_dodged_during_attack) then
		arg_9_3.locomotion_extension:set_rotation_speed(2)

		arg_9_4.refresh_last_target_position = true
		arg_9_3.target_dodged_during_attack = true

		local dodge_timer = arg_9_3.breed.dodge_timer

		dodge_timer = dodge_timer or 0.3
		self.dodge_timer = arg_9_1 + dodge_timer
	end

	if not (not arg_9_3.target_dodged_during_attack and not (arg_9_1 < self.dodge_timer)) then
		var_9_2 = arg_9_4.last_target_position:unbox()
	else
		var_9_2 = POSITION_LOOKUP[arg_9_4.attacking_target]
	end

	self:_set_target_position(arg_9_3, arg_9_4, var_9_2, arg_9_1)

	local look_at_position_flat = LocomotionUtils.look_at_position_flat(arg_9_2, var_9_2)

	arg_9_4.rotation_target:store(look_at_position_flat)
end

BTComboAttackAction._set_target_position = function (arg_10_0, arg_10_1, arg_10_2, arg_10_3, arg_10_4)
	-- function 10
	local target_locomotion_extension = arg_10_1.target_locomotion_extension

	arg_10_2.last_target_position:store(arg_10_3)

	local last_target_velocity = arg_10_2.last_target_velocity
	local var_10_2 = last_target_velocity
	local store = last_target_velocity.store
	local current_velocity

	if not target_locomotion_extension then
		current_velocity = target_locomotion_extension:current_velocity()

		if not current_velocity then
			-- Nothing
		end
	end

	current_velocity = Vector3.zero()

	::label_10_0::

	store(var_10_2, current_velocity)

	arg_10_2.last_target_position_time = arg_10_4
end

BTComboAttackAction._update_rotation_target_lerped = function (self, arg_11_1, arg_11_2, arg_11_3, arg_11_4, arg_11_5)
	-- function 11
	self:_update_rotation_target(arg_11_1, arg_11_2, arg_11_3, arg_11_4)

	local num_2 = arg_11_1 - arg_11_4.attack_start_time
	local start_lerp_in = arg_11_5.start_lerp_in
	local end_lerp_in = arg_11_5.end_lerp_in
	local start_lerp_out = arg_11_5.start_lerp_out
	local end_lerp_out = arg_11_5.end_lerp_out
	local target_speed = arg_11_5.target_speed
	local var_11_6

	if num_2 < start_lerp_in then
		var_11_6 = num
	elseif num_2 < end_lerp_in then
		var_11_6 = math.lerp(num, target_speed, (num_2 - start_lerp_in) / (end_lerp_in - start_lerp_in))
	elseif num_2 < start_lerp_out then
		var_11_6 = target_speed
	elseif num_2 < end_lerp_out then
		var_11_6 = math.lerp(target_speed, num, (num_2 - start_lerp_out) / (end_lerp_out - start_lerp_out))
	else
		var_11_6 = num
	end

	arg_11_3.locomotion_extension:set_rotation_speed(var_11_6)
end

BTComboAttackAction.attack_cooldown = function (self, arg_12_1, arg_12_2)
	-- function 12
	local time = Managers.time:time("game")

	arg_12_2.is_in_attack_cooldown, arg_12_2.attack_cooldown_at = self:get_attack_cooldown_finished_at(arg_12_1, arg_12_2, time)
end

BTComboAttackAction._push_non_targets = function (arg_13_0, arg_13_1, arg_13_2, arg_13_3, arg_13_4, arg_13_5, arg_13_6, arg_13_7, arg_13_8, arg_13_9)
	-- function 13
	local num = arg_13_7^2
	local ENEMY_PLAYER_AND_BOT_UNITS = Managers.state.side.side_by_unit[arg_13_1].ENEMY_PLAYER_AND_BOT_UNITS

	for i = 1, #ENEMY_PLAYER_AND_BOT_UNITS do
		local var_13_2 = ENEMY_PLAYER_AND_BOT_UNITS[i]

		if not (var_13_2 == arg_13_3 or arg_13_4.pushed_targets[var_13_2] or ScriptUnit.extension(var_13_2, "status_system"):is_disabled()) then
			local num_2 = POSITION_LOOKUP[var_13_2] - arg_13_2

			if num > Vector3.length_squared(num_2) then
				local cross = Vector3.cross(arg_13_5, Vector3.up())
				local dot = Vector3.dot(cross, num_2)
				local auto_lerp = math.auto_lerp(arg_13_6, arg_13_7, 1, 0, math.abs(dot))
				local num_3 = arg_13_5 * auto_lerp * arg_13_8 + cross * auto_lerp * arg_13_9

				ScriptUnit.extension(var_13_2, "locomotion_system"):add_external_velocity(num_3)

				arg_13_4.pushed_targets[var_13_2] = true
			end
		end
	end
end

BTComboAttackAction.stagger_override = function (arg_14_0, arg_14_1, arg_14_2, arg_14_3, arg_14_4, arg_14_5, arg_14_6, arg_14_7, arg_14_8, arg_14_9, arg_14_10)
	-- function 14
	local combo_attack_data = arg_14_2.combo_attack_data
	local var_14_1 = arg_14_2.action.combo_attacks[combo_attack_data.current_attack_name]

	if var_14_1.staggers_allowed[arg_14_6] or not arg_14_10 or not var_14_1.allow_push_stagger then
		return false
	else
		return true
	end
end

BTComboAttackAction.anim_cb_frenzy_damage = function (arg_15_0, arg_15_1, arg_15_2)
	-- function 15
	local action = arg_15_2.action
	local combo_attack_data = arg_15_2.combo_attack_data
	local attacking_target = combo_attack_data.attacking_target

	if not Unit.alive(attacking_target) then
		return
	end

	arg_15_2.attack_damage_triggered = true

	if not (not DamageUtils.check_distance(action, arg_15_2, arg_15_1, attacking_target) and DamageUtils.check_infront(arg_15_1, attacking_target)) then
		return
	end

	local current_attack_name = combo_attack_data.current_attack_name
	local var_15_4 = action.combo_attacks[current_attack_name]
	local fatigue_type = var_15_4.fatigue_type

	fatigue_type = fatigue_type or action.fatigue_type

	local attack_directions = action.attack_directions

	attack_directions = not attack_directions and action.attack_directions[arg_15_2.attack_anim]

	if not DamageUtils.check_block(arg_15_1, attacking_target, fatigue_type, attack_directions) then
		arg_15_2.blocked = false
		combo_attack_data.blocked = true

		return
	end

	combo_attack_data.successful_hit = true

	local difficulty_damage = var_15_4.difficulty_damage
	local var_15_8

	if not difficulty_damage then
		var_15_8 = Managers.state.difficulty:get_difficulty_value_from_table(difficulty_damage)
	else
		var_15_8 = action.damage
	end

	local has_extension = ScriptUnit.has_extension(attacking_target, "dialogue_system")

	if not has_extension then
		local player_profile = has_extension.context.player_profile

		Managers.state.entity:system("surrounding_aware_system"):add_system_event(arg_15_1, "enemy_attack", DialogueSettings.armor_hit_broadcast_range, "attack_tag", "frenzy_attack_damage", "target_name", player_profile)
	end

	AiUtils.damage_target(attacking_target, arg_15_1, action, var_15_8)
end

BTComboAttackAction.get_attack_cooldown_finished_at = function (arg_16_0, arg_16_1, arg_16_2, arg_16_3)
	-- function 16
	local attacking_target = arg_16_2.combo_attack_data.attacking_target

	if not Unit.alive(attacking_target) then
		return false, 0
	end

	local diminishing_damage = arg_16_2.action.diminishing_damage

	if not diminishing_damage then
		return false, 0
	end

	local has_extension = ScriptUnit.has_extension(attacking_target, "ai_slot_system")

	if not (not has_extension and has_extension.has_slots_attached) then
		return false, 0
	end

	local slots_count = Managers.state.entity:system("ai_slot_system"):slots_count(attacking_target)

	if slots_count == 0 then
		return false, 0
	end

	local cooldown = diminishing_damage[math.min(slots_count, 9)].cooldown
	local random = AiUtils.random(cooldown[1], cooldown[2])

	return true, random + arg_16_3
end

BTComboAttackAction.anim_cb_attack_vce = function (arg_17_0, arg_17_1, arg_17_2)
	-- function 17
	if not Managers.state.network:game() then
		Managers.state.entity:system("dialogue_system"):trigger_attack(arg_17_2, arg_17_2.target_unit, arg_17_1, false, false)
	end
end
