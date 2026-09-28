-- chunkname: @scripts/entity_system/systems/behaviour/nodes/bt_combo_attack_action.lua

require("scripts/entity_system/systems/behaviour/nodes/bt_node")

BTComboAttackAction = class(BTComboAttackAction, BTNode)

local DEFAULT_ROTATION_SPEED = 20

BTComboAttackAction.init = function (self, ...)
	-- function 1
	BTComboAttackAction.super.init(self, ...)

	self.last_attack_time = 0
	self.dodge_timer = 0
end

BTComboAttackAction.name = "BTComboAttackAction"

BTComboAttackAction.enter = function (self, unit, blackboard, t)
	-- function 2
	local action = self._tree_node.action_data

	blackboard.action = action
	blackboard.active_node = BTComboAttackAction
	blackboard.attack_finished = false
	blackboard.attack_aborted = false
	blackboard.attack_damage_triggered = false
	blackboard.attack_token = true
	blackboard.keep_target = true

	local target_unit = blackboard.target_unit
	local target_status_extension = ScriptUnit.has_extension(target_unit, "status_system")

	if target_status_extension then
		target_status_extension:add_combo_target_count(1)

		blackboard.target_status_extension = target_status_extension
	end

	blackboard.attacking_target = target_unit
	blackboard.move_state = "attacking"

	local current_rotation = Unit.local_rotation(unit, 0)
	local target_locomotion_extension = ScriptUnit.has_extension(target_unit, "locomotion_system")

	blackboard.target_locomotion_extension = target_locomotion_extension

	local current_velocity

	if target_locomotion_extension then
		current_velocity = target_locomotion_extension:current_velocity()

		if not current_velocity then
			-- Nothing
		end
	end

	current_velocity = Vector3.zero()

	local target_velocity = current_velocity

	::label_2_0::

	local combo = blackboard.combo_attack_data

	if combo then
		combo.aborted = false
		combo.attack_start_time = math.huge
		combo.attacking_target = target_unit
		combo.blocked = false
		combo.has_been_blocked = false
		combo.successful_hit = false
		combo.is_animation_driven = false

		combo.rotation_target:store(current_rotation)

		combo.refresh_last_target_position = false
		combo.last_target_position_time = t

		combo.last_target_position:store(POSITION_LOOKUP[target_unit])
		combo.last_target_velocity:store(target_velocity)
	else
		combo = {
			successful_hit = false,
			aborted = false,
			is_animation_driven = false,
			refresh_last_target_position = false,
			has_been_blocked = false,
			blocked = false,
			attack_start_time = math.huge,
			attacking_target = target_unit,
			pushed_targets = {},
			rotation_target = QuaternionBox(current_rotation),
			last_target_position_time = t,
			last_target_position = Vector3Box(POSITION_LOOKUP[target_unit]),
			last_target_velocity = Vector3Box(target_velocity)
		}
		blackboard.combo_attack_data = combo
	end

	if action.combo_attack_cycle_index then
		local num_anims = action.combo_anim_variations
		local index = action.combo_attack_cycle_index % num_anims + 1

		combo.attack_variation = index
		action.combo_attack_cycle_index = index
	else
		combo.attack_variation = Math.random(1, action.combo_anim_variations)
	end

	if action.start_sound_event then
		local dialogue_system = Managers.state.entity:system("dialogue_system")

		dialogue_system:trigger_general_unit_event(unit, action.start_sound_event)
	end

	local target_unit_slot_extension = ScriptUnit.has_extension(target_unit, "ai_slot_system")

	if blackboard.attack_token and target_status_extension then
		local breed = blackboard.breed

		if breed.use_backstab_vo and target_unit_slot_extension and target_unit_slot_extension.num_occupied_slots <= 5 then
			local player = Managers.player:unit_owner(target_unit)

			if player and not player.bot_player then
				local is_flanking = AiUtils.unit_is_flanking_player(unit, target_unit)

				if is_flanking then
					blackboard.backstab_attack_trigger = true
				end

				if player.local_player then
					if is_flanking then
						local dialogue_extension = ScriptUnit.extension(unit, "dialogue_system")
						local wwise_source, wwise_world = WwiseUtils.make_unit_auto_source(blackboard.world, unit, dialogue_extension.voice_node)
						local sound_event = breed.backstab_player_sound_event
						local audio_system_extension = Managers.state.entity:system("audio_system")

						audio_system_extension:_play_event_with_source(wwise_world, sound_event, wwise_source)
					end
				else
					local network_manager = Managers.state.network
					local network_transmit = network_manager.network_transmit
					local unit_id = network_manager:unit_game_object_id(unit)
					local peer_id = player:network_id()

					network_transmit:send_rpc("rpc_check_trigger_backstab_sfx", peer_id, unit_id)
				end
			end
		end
	end

	AiUtils.add_attack_intensity(target_unit, action, blackboard)
	self:_start_attack(unit, blackboard, t, action, "attack_1")
end

local function randomize(event, blackboard)
	-- function 3
	local combo = blackboard.combo_attack_data

	if type(event) == "table" then
		return event[combo.attack_variation]
	else
		return event
	end
end

BTComboAttackAction._start_attack = function (self, unit, blackboard, t, action, attack_name)
	-- function 4
	self.last_attack_time = t

	local attack_data = action.combo_attacks[attack_name]
	local target_moving = blackboard.target_speed_away > 1.5 or blackboard.target_dist > 3
	local var_4_0 = randomize
	local move_anim

	if target_moving then
		move_anim = attack_data.move_anim

		if not move_anim then
			-- Nothing
		end
	end

	move_anim = attack_data.anim

	::label_4_0::

	local anim = var_4_0(move_anim, blackboard)

	Managers.state.network:anim_event(unit, anim)

	blackboard.attack_anim = anim

	local combo = blackboard.combo_attack_data
	local attacking_target = combo.attacking_target

	combo.current_attack_name = attack_name
	combo.successful_hit = false
	blackboard.attack_finished = false
	blackboard.attack_damage_triggered = false
	blackboard.target_dodged_during_attack = false

	if combo.refresh_last_target_position then
		combo.refresh_last_target_position = false

		self:_set_target_position(blackboard, combo, POSITION_LOOKUP[attacking_target], t)
	end

	combo.has_been_blocked = false
	combo.attack_start_time = t
	combo.push_non_targets = attack_data.push_non_targets

	table.clear(combo.pushed_targets)

	local target_status_extension = blackboard.target_status_extension
	local is_animation_driven

	if not combo.is_animation_driven then
		is_animation_driven = attack_data.is_animation_driven

		if is_animation_driven and target_status_extension then
			-- Nothing
		end

		::label_4_1::

		is_animation_driven = not target_status_extension:is_knocked_down()
	else
		is_animation_driven = false
	end

	goto label_4_2

	is_animation_driven = true

	local is_anim_driven = is_animation_driven

	::label_4_2::

	if is_anim_driven then
		LocomotionUtils.set_animation_driven_movement(unit, true, true, true)

		combo.is_animation_driven = true

		local navigation_extension = blackboard.navigation_extension

		navigation_extension:set_max_speed(0)
	elseif combo.is_animation_driven and not attack_data.is_animation_driven then
		LocomotionUtils.set_animation_driven_movement(unit, false)

		combo.is_animation_driven = false
	end

	blackboard.locomotion_extension:set_rotation_speed(DEFAULT_ROTATION_SPEED)

	if attack_data.rotation_scheme == "on_enter" or attack_data.rotation_scheme == "continuous" then
		self:_update_rotation_target(t, unit, blackboard, combo)
	end

	if attack_data.bot_threat_duration then
		local rot = LocomotionUtils.rotation_towards_unit_flat(unit, attacking_target)
		local bot_threat_range = attack_data.bot_threat_range

		if not bot_threat_range then
			-- Nothing
		end

		bot_threat_range = 2

		local range = bot_threat_range

		::label_4_3::

		local bot_threat_width = attack_data.bot_threat_width

		if not bot_threat_width then
			-- Nothing
		end

		bot_threat_width = 1

		local width = bot_threat_width

		::label_4_4::

		local half_range = range * 0.5
		local forward = Quaternion.rotate(rot, Vector3.forward()) * half_range
		local oobb_pos = POSITION_LOOKUP[unit] + forward + Vector3.up() * 0.5

		Managers.state.entity:system("ai_bot_group_system"):aoe_threat_created(oobb_pos, "oobb", Vector3(width, range, 0.5), rot, attack_data.bot_threat_duration, "Combo Attack")
	end

	local damage_done_time = attack_data.damage_done_time

	if damage_done_time then
		if type(damage_done_time) == "table" then
			combo.damage_done_time = t + damage_done_time[anim]
		else
			combo.damage_done_time = t + damage_done_time
		end
	end
end

BTComboAttackAction.leave = function (self, unit, blackboard, t, reason, destroy)
	-- function 5
	if blackboard.move_state ~= "idle" then
		local network_manager = Managers.state.network

		network_manager:anim_event(unit, "idle")

		blackboard.move_state = "idle"
	end

	local combo = blackboard.combo_attack_data

	if combo.is_animation_driven and not destroy then
		LocomotionUtils.set_animation_driven_movement(unit, false)

		combo.is_animation_driven = false
	end

	local target_status_extension = blackboard.target_status_extension

	if target_status_extension then
		target_status_extension:add_combo_target_count(-1)
	end

	if not destroy then
		blackboard.locomotion_extension:set_rotation_speed()
	end

	blackboard.attack_damage_triggered = false
	blackboard.active_node = nil
	blackboard.attack_aborted = nil
	blackboard.attacking_target = nil
	blackboard.anim_cb_damage = nil
	blackboard.target_locomotion_extension = nil
	blackboard.target_status_extension = nil
	blackboard.target_dodged_during_attack = nil
	blackboard.anim_cb_move_stop = nil
	blackboard.action = nil
	blackboard.attack_token = nil
	blackboard.backstab_attack_trigger = nil
	blackboard.keep_target = nil

	if reason == "aborted" then
		combo.aborted = true
	end

	combo.damage_done_time = nil

	local navigation_extension = blackboard.navigation_extension

	navigation_extension:set_max_speed(blackboard.breed.run_speed)
end

BTComboAttackAction.run = function (self, unit, blackboard, t, dt)
	-- function 6
	local combo = blackboard.combo_attack_data
	local attacking_target = combo.attacking_target

	if blackboard.attack_aborted or not Unit.alive(attacking_target) then
		combo.aborted = true

		return "done"
	end

	local action = blackboard.action
	local current_attack = action.combo_attacks[combo.current_attack_name]

	if combo.blocked then
		combo.blocked = false
		combo.has_been_blocked = true
	end

	if combo.damage_done_time and t > combo.damage_done_time then
		combo.damage_done_time = nil
		blackboard.attacking_target = nil
	end

	if blackboard.attack_finished or combo.has_been_blocked and current_attack.block_interrupts then
		local has_hit = combo.successful_hit
		local has_been_blocked = combo.has_been_blocked
		local next_blocked

		if has_been_blocked then
			next_blocked = current_attack.next_blocked

			if not next_blocked then
				-- Nothing
			end
		end

		if has_hit then
			next_blocked = current_attack.next_hit

			if not next_blocked then
				-- Nothing
			end
		end

		next_blocked = current_attack.next

		local next_attack_table = next_blocked

		::label_6_0::

		local next_attack_name = randomize(next_attack_table, blackboard)

		if current_attack.combo_cooldown_start then
			Unit.set_data(attacking_target, "last_combo_t", t)
		end

		if next_attack_name == "done" then
			return "done"
		elseif next_attack_name == "stagger" then
			blackboard.blocked = true

			return "done"
		else
			self:_start_attack(unit, blackboard, t, action, next_attack_name)
		end
	end

	local stop_moving_cb = blackboard.anim_cb_move_stop
	local should_move = not stop_moving_cb and not combo.is_animation_driven and not not attacking_target

	if should_move then
		self:_follow(dt, t, unit, blackboard, current_attack)
	else
		local navigation_extension = blackboard.navigation_extension

		navigation_extension:set_max_speed(0)
	end

	local str

	if blackboard.attack_damage_triggered then
		str = "no_rotation"

		goto label_6_1
	end

	str = current_attack.rotation_scheme

	local rotation_scheme = str

	::label_6_1::

	if rotation_scheme == "continuous" then
		self:_update_rotation_target(t, unit, blackboard, combo)
	elseif type(rotation_scheme) == "table" then
		self:_update_rotation_target_lerped(t, unit, blackboard, combo, rotation_scheme)
	end

	local locomotion_extension = blackboard.locomotion_extension

	locomotion_extension:set_wanted_rotation(combo.rotation_target:unbox())

	local push = combo.push_non_targets

	if push then
		local forward_direction = Vector3.normalize(Vector3.flat(Quaternion.forward(combo.rotation_target:unbox())))

		self:_push_non_targets(unit, POSITION_LOOKUP[unit], attacking_target, combo, forward_direction, push.close_impact_radius, push.far_impact_radius, push.forward_impact_speed, push.lateral_impact_speed)
	end

	return "running"
end

BTComboAttackAction._follow = function (self, dt, t, unit, blackboard, current_attack)
	-- function 7
	local breed = blackboard.breed
	local combo = blackboard.combo_attack_data
	local attacking_target = combo.attacking_target
	local weapon_reach = breed.weapon_reach

	weapon_reach = not not weapon_reach or not not 2

	local weapon_reach_sq = weapon_reach^2
	local target_offset = POSITION_LOOKUP[attacking_target] - POSITION_LOOKUP[unit]
	local target_distance_sq = Vector3.length_squared(target_offset)
	local run_speed = current_attack.run_speed

	if not run_speed then
		-- Nothing
	end

	run_speed = breed.run_speed

	local max_speed = run_speed

	::label_7_0::

	if target_distance_sq < weapon_reach_sq then
		local target_locomotion_extension = blackboard.target_locomotion_extension
		local average_velocity

		if target_locomotion_extension and target_locomotion_extension.average_velocity then
			average_velocity = target_locomotion_extension:average_velocity()

			if not average_velocity then
				-- Nothing
			end
		end

		average_velocity = Vector3.zero()

		local target_velocity = average_velocity

		::label_7_1::

		max_speed = math.max(math.min(max_speed, Vector3.dot(target_velocity, Vector3.normalize(target_offset))), 0)
	end

	local attack_start_slow_factor_time_2 = current_attack.attack_start_slow_factor_time

	if not attack_start_slow_factor_time_2 then
		-- Nothing
	end

	attack_start_slow_factor_time_2 = breed.attack_start_slow_factor_time

	if not attack_start_slow_factor_time_2 then
		-- Nothing
	end

	attack_start_slow_factor_time_2 = 0.3

	local attack_start_slow_factor_time = attack_start_slow_factor_time_2

	::label_7_2::

	if t < self.last_attack_time + attack_start_slow_factor_time then
		local attack_start_slow_fraction_2 = current_attack.attack_start_slow_fraction

		if not attack_start_slow_fraction_2 then
			-- Nothing
		end

		attack_start_slow_fraction_2 = breed.attack_start_slow_fraction

		if not attack_start_slow_fraction_2 then
			-- Nothing
		end

		attack_start_slow_fraction_2 = 0

		local attack_start_slow_fraction = attack_start_slow_fraction_2

		::label_7_3::

		local attack_start_slow_factor = 1 - attack_start_slow_fraction + attack_start_slow_fraction * ((t - self.last_attack_time) / attack_start_slow_factor_time)

		max_speed = max_speed * attack_start_slow_factor
	end

	local attack_stop_time_2 = current_attack.attack_stop_time

	if not attack_stop_time_2 then
		-- Nothing
	end

	attack_stop_time_2 = breed.attack_stop_time

	if not attack_stop_time_2 then
		-- Nothing
	end

	attack_stop_time_2 = nil

	local attack_stop_time = attack_stop_time_2

	::label_7_4::

	if attack_stop_time and t > self.last_attack_time + attack_stop_time then
		max_speed = 0
	end

	if blackboard.target_dodged_during_attack and t < self.dodge_timer then
		max_speed = math.clamp(max_speed, 0, 3)
	end

	local navigation_extension = blackboard.navigation_extension

	navigation_extension:set_max_speed(max_speed)
end

BTComboAttackAction.attack_success = function (self, unit, blackboard)
	-- function 8
	local breed = blackboard.breed

	if breed.use_backstab_vo and blackboard.backstab_attack_trigger then
		local dialogue_system = Managers.state.entity:system("dialogue_system")

		dialogue_system:trigger_backstab_hit(blackboard.target_unit, unit)

		blackboard.backstab_attack_trigger = false
	end

	blackboard.combo_attack_data.successful_hit = true
end

BTComboAttackAction._update_rotation_target = function (self, t, unit, blackboard, combo)
	-- function 9
	local target_status_extension = blackboard.target_status_extension

	if target_status_extension then
		-- Nothing
	end

	::label_9_0::

	local get_is_dodging = target_status_extension:get_is_dodging()

	if not get_is_dodging then
		-- Nothing
	end

	get_is_dodging = target_status_extension:is_invisible()

	local dodging = get_is_dodging

	::label_9_1::

	local pos

	if dodging and not blackboard.target_dodged_during_attack then
		blackboard.locomotion_extension:set_rotation_speed(2)

		combo.refresh_last_target_position = true
		blackboard.target_dodged_during_attack = true

		local dodge_timer = blackboard.breed.dodge_timer

		dodge_timer = not not dodge_timer or not not 0.3
		self.dodge_timer = t + dodge_timer
	end

	if blackboard.target_dodged_during_attack and t < self.dodge_timer then
		pos = combo.last_target_position:unbox()
	else
		pos = POSITION_LOOKUP[combo.attacking_target]
	end

	self:_set_target_position(blackboard, combo, pos, t)

	local rot = LocomotionUtils.look_at_position_flat(unit, pos)

	combo.rotation_target:store(rot)
end

BTComboAttackAction._set_target_position = function (self, blackboard, combo, position, t)
	-- function 10
	local target_locomotion_extension = blackboard.target_locomotion_extension

	combo.last_target_position:store(position)

	local last_target_velocity = combo.last_target_velocity
	local var_10_1 = last_target_velocity
	local store = last_target_velocity.store
	local current_velocity

	if target_locomotion_extension then
		current_velocity = target_locomotion_extension:current_velocity()

		if not current_velocity then
			-- Nothing
		end
	end

	current_velocity = Vector3.zero()

	::label_10_0::

	store(var_10_1, current_velocity)

	combo.last_target_position_time = t
end

BTComboAttackAction._update_rotation_target_lerped = function (self, t, unit, blackboard, combo, rotation_constraint)
	-- function 11
	self:_update_rotation_target(t, unit, blackboard, combo)

	local attack_t = t - combo.attack_start_time
	local start_in = rotation_constraint.start_lerp_in
	local end_in = rotation_constraint.end_lerp_in
	local start_out = rotation_constraint.start_lerp_out
	local end_out = rotation_constraint.end_lerp_out
	local target_speed = rotation_constraint.target_speed
	local speed

	if attack_t < start_in then
		speed = DEFAULT_ROTATION_SPEED
	elseif attack_t < end_in then
		speed = math.lerp(DEFAULT_ROTATION_SPEED, target_speed, (attack_t - start_in) / (end_in - start_in))
	elseif attack_t < start_out then
		speed = target_speed
	elseif attack_t < end_out then
		speed = math.lerp(target_speed, DEFAULT_ROTATION_SPEED, (attack_t - start_out) / (end_out - start_out))
	else
		speed = DEFAULT_ROTATION_SPEED
	end

	blackboard.locomotion_extension:set_rotation_speed(speed)
end

BTComboAttackAction.attack_cooldown = function (self, unit, blackboard)
	-- function 12
	local t = Managers.time:time("game")
	local cooldown, cooldown_at = self:get_attack_cooldown_finished_at(unit, blackboard, t)

	blackboard.attack_cooldown_at = cooldown_at
	blackboard.is_in_attack_cooldown = cooldown
end

BTComboAttackAction._push_non_targets = function (self, unit, self_pos, current_target, combo, forward_direction, close_impact_radius, far_impact_radius, forward_impact_speed, lateral_impact_speed)
	-- function 13
	local far_impact_radius_sq = far_impact_radius^2
	local side = Managers.state.side.side_by_unit[unit]
	local player_and_bot_units = side.ENEMY_PLAYER_AND_BOT_UNITS

	for i = 1, #player_and_bot_units do
		local player_unit = player_and_bot_units[i]

		if player_unit ~= current_target and not combo.pushed_targets[player_unit] then
			local status_extension = ScriptUnit.extension(player_unit, "status_system")

			if not status_extension:is_disabled() then
				local to_player = POSITION_LOOKUP[player_unit] - self_pos
				local player_dist_sq = Vector3.length_squared(to_player)

				if player_dist_sq < far_impact_radius_sq then
					local lateral_direction = Vector3.cross(forward_direction, Vector3.up())
					local lateral_dist = Vector3.dot(lateral_direction, to_player)
					local speed_factor = math.auto_lerp(close_impact_radius, far_impact_radius, 1, 0, math.abs(lateral_dist))
					local velocity = forward_direction * speed_factor * forward_impact_speed + lateral_direction * speed_factor * lateral_impact_speed
					local player_locomotion = ScriptUnit.extension(player_unit, "locomotion_system")

					player_locomotion:add_external_velocity(velocity)

					combo.pushed_targets[player_unit] = true
				end
			end
		end
	end
end

BTComboAttackAction.stagger_override = function (self, unit, blackboard, attacker_unit, stagger_direction, stagger_length, stagger_type, stagger_duration, stagger_animation_scale, t, is_push)
	-- function 14
	local combo = blackboard.combo_attack_data
	local action = blackboard.action
	local current_attack = action.combo_attacks[combo.current_attack_name]
	local staggers_allowed = current_attack.staggers_allowed

	if staggers_allowed[stagger_type] or is_push and current_attack.allow_push_stagger then
		return false
	else
		return true
	end
end

BTComboAttackAction.anim_cb_frenzy_damage = function (self, unit, blackboard)
	-- function 15
	local action = blackboard.action
	local combo = blackboard.combo_attack_data
	local attacking_target = combo.attacking_target

	if not Unit.alive(attacking_target) then
		return
	end

	blackboard.attack_damage_triggered = true

	if not DamageUtils.check_distance(action, blackboard, unit, attacking_target) or not DamageUtils.check_infront(unit, attacking_target) then
		return
	end

	local current_attack_name = combo.current_attack_name
	local current_attack = action.combo_attacks[current_attack_name]
	local fatigue_type_2 = current_attack.fatigue_type

	if not fatigue_type_2 then
		-- Nothing
	end

	fatigue_type_2 = action.fatigue_type

	local fatigue_type = fatigue_type_2

	::label_15_0::

	local attack_directions = action.attack_directions

	if attack_directions then
		-- Nothing
	end

	attack_directions = action.attack_directions[blackboard.attack_anim]

	local attack_direction = attack_directions

	::label_15_1::

	if DamageUtils.check_block(unit, attacking_target, fatigue_type, attack_direction) then
		blackboard.blocked = false
		combo.blocked = true

		return
	end

	combo.successful_hit = true

	local damage_table = current_attack.difficulty_damage
	local damage

	if damage_table then
		damage = Managers.state.difficulty:get_difficulty_value_from_table(damage_table)
	else
		damage = action.damage
	end

	local target_dialogue_extension = ScriptUnit.has_extension(attacking_target, "dialogue_system")

	if target_dialogue_extension then
		local target_name = target_dialogue_extension.context.player_profile

		Managers.state.entity:system("surrounding_aware_system"):add_system_event(unit, "enemy_attack", DialogueSettings.armor_hit_broadcast_range, "attack_tag", "frenzy_attack_damage", "target_name", target_name)
	end

	AiUtils.damage_target(attacking_target, unit, action, damage)
end

BTComboAttackAction.get_attack_cooldown_finished_at = function (self, unit, blackboard, t)
	-- function 16
	local combo = blackboard.combo_attack_data
	local attacking_target = combo.attacking_target

	if not Unit.alive(attacking_target) then
		return false, 0
	end

	local diminishing_damage_data = blackboard.action.diminishing_damage

	if not diminishing_damage_data then
		return false, 0
	end

	local has_ai_slot_extension = ScriptUnit.has_extension(attacking_target, "ai_slot_system")

	if not has_ai_slot_extension or not has_ai_slot_extension.has_slots_attached then
		return false, 0
	end

	local ai_slot_system = Managers.state.entity:system("ai_slot_system")
	local slots_n = ai_slot_system:slots_count(attacking_target)

	if slots_n == 0 then
		return false, 0
	end

	local diminishing_damage = diminishing_damage_data[math.min(slots_n, 9)]
	local cooldown_data = diminishing_damage.cooldown
	local cooldown = AiUtils.random(cooldown_data[1], cooldown_data[2])

	return true, cooldown + t
end

BTComboAttackAction.anim_cb_attack_vce = function (self, unit, blackboard)
	-- function 17
	local network_manager = Managers.state.network
	local game = network_manager:game()

	if game then
		local dialogue_system = Managers.state.entity:system("dialogue_system")

		dialogue_system:trigger_attack(blackboard, blackboard.target_unit, unit, false, false)
	end
end
