-- chunkname: @scripts/entity_system/systems/behaviour/nodes/bt_combo_attack_action.lua

require("scripts/entity_system/systems/behaviour/nodes/bt_node")

BTComboAttackAction = class(BTComboAttackAction, BTNode)

local var_0_0 = 20

function BTComboAttackAction.init(arg_1_0, ...)
	BTComboAttackAction.super.init(arg_1_0, ...)

	arg_1_0.last_attack_time = 0
	arg_1_0.dodge_timer = 0
end

BTComboAttackAction.name = "BTComboAttackAction"

function BTComboAttackAction.enter(arg_2_0, arg_2_1, arg_2_2, arg_2_3)
	local var_2_0 = arg_2_0._tree_node.action_data

	arg_2_2.action = var_2_0
	arg_2_2.active_node = BTComboAttackAction
	arg_2_2.attack_finished = false
	arg_2_2.attack_aborted = false
	arg_2_2.attack_damage_triggered = false
	arg_2_2.attack_token = true
	arg_2_2.keep_target = true

	local var_2_1 = arg_2_2.target_unit
	local var_2_2 = ScriptUnit.has_extension(var_2_1, "status_system")

	if var_2_2 then
		var_2_2:add_combo_target_count(1)

		arg_2_2.target_status_extension = var_2_2
	end

	arg_2_2.attacking_target = var_2_1
	arg_2_2.move_state = "attacking"

	local var_2_3 = Unit.local_rotation(arg_2_1, 0)
	local var_2_4 = ScriptUnit.has_extension(var_2_1, "locomotion_system")

	arg_2_2.target_locomotion_extension = var_2_4

	local var_2_5 = var_2_4 and var_2_4:current_velocity() or Vector3.zero()
	local var_2_6 = arg_2_2.combo_attack_data

	if var_2_6 then
		var_2_6.aborted = false
		var_2_6.attack_start_time = math.huge
		var_2_6.attacking_target = var_2_1
		var_2_6.blocked = false
		var_2_6.has_been_blocked = false
		var_2_6.successful_hit = false
		var_2_6.is_animation_driven = false

		var_2_6.rotation_target:store(var_2_3)

		var_2_6.refresh_last_target_position = false
		var_2_6.last_target_position_time = arg_2_3

		var_2_6.last_target_position:store(POSITION_LOOKUP[var_2_1])
		var_2_6.last_target_velocity:store(var_2_5)
	else
		var_2_6 = {
			successful_hit = false,
			aborted = false,
			is_animation_driven = false,
			refresh_last_target_position = false,
			has_been_blocked = false,
			blocked = false,
			attack_start_time = math.huge,
			attacking_target = var_2_1,
			pushed_targets = {},
			rotation_target = QuaternionBox(var_2_3),
			last_target_position_time = arg_2_3,
			last_target_position = Vector3Box(POSITION_LOOKUP[var_2_1]),
			last_target_velocity = Vector3Box(var_2_5)
		}
		arg_2_2.combo_attack_data = var_2_6
	end

	if var_2_0.combo_attack_cycle_index then
		local var_2_7 = var_2_0.combo_anim_variations
		local var_2_8 = var_2_0.combo_attack_cycle_index % var_2_7 + 1

		var_2_6.attack_variation = var_2_8
		var_2_0.combo_attack_cycle_index = var_2_8
	else
		var_2_6.attack_variation = Math.random(1, var_2_0.combo_anim_variations)
	end

	if var_2_0.start_sound_event then
		Managers.state.entity:system("dialogue_system"):trigger_general_unit_event(arg_2_1, var_2_0.start_sound_event)
	end

	local var_2_9 = ScriptUnit.has_extension(var_2_1, "ai_slot_system")

	if arg_2_2.attack_token and var_2_2 then
		local var_2_10 = arg_2_2.breed

		if var_2_10.use_backstab_vo and var_2_9 and var_2_9.num_occupied_slots <= 5 then
			local var_2_11 = Managers.player:unit_owner(var_2_1)

			if var_2_11 and not var_2_11.bot_player then
				local var_2_12 = AiUtils.unit_is_flanking_player(arg_2_1, var_2_1)

				if var_2_12 then
					arg_2_2.backstab_attack_trigger = true
				end

				if var_2_11.local_player then
					if var_2_12 then
						local var_2_13 = ScriptUnit.extension(arg_2_1, "dialogue_system")
						local var_2_14, var_2_15 = WwiseUtils.make_unit_auto_source(arg_2_2.world, arg_2_1, var_2_13.voice_node)
						local var_2_16 = var_2_10.backstab_player_sound_event

						Managers.state.entity:system("audio_system"):_play_event_with_source(var_2_15, var_2_16, var_2_14)
					end
				else
					local var_2_17 = Managers.state.network
					local var_2_18 = var_2_17.network_transmit
					local var_2_19 = var_2_17:unit_game_object_id(arg_2_1)
					local var_2_20 = var_2_11:network_id()

					var_2_18:send_rpc("rpc_check_trigger_backstab_sfx", var_2_20, var_2_19)
				end
			end
		end
	end

	AiUtils.add_attack_intensity(var_2_1, var_2_0, arg_2_2)
	arg_2_0:_start_attack(arg_2_1, arg_2_2, arg_2_3, var_2_0, "attack_1")
end

local function var_0_1(arg_3_0, arg_3_1)
	local var_3_0 = arg_3_1.combo_attack_data

	if type(arg_3_0) == "table" then
		return arg_3_0[var_3_0.attack_variation]
	else
		return arg_3_0
	end
end

function BTComboAttackAction._start_attack(arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4, arg_4_5)
	arg_4_0.last_attack_time = arg_4_3

	local var_4_0 = arg_4_4.combo_attacks[arg_4_5]
	local var_4_1 = arg_4_2.target_speed_away > 1.5 or arg_4_2.target_dist > 3
	local var_4_2 = var_0_1(var_4_1 and var_4_0.move_anim or var_4_0.anim, arg_4_2)

	Managers.state.network:anim_event(arg_4_1, var_4_2)

	arg_4_2.attack_anim = var_4_2

	local var_4_3 = arg_4_2.combo_attack_data
	local var_4_4 = var_4_3.attacking_target

	var_4_3.current_attack_name = arg_4_5
	var_4_3.successful_hit = false
	arg_4_2.attack_finished = false
	arg_4_2.attack_damage_triggered = false
	arg_4_2.target_dodged_during_attack = false

	if var_4_3.refresh_last_target_position then
		var_4_3.refresh_last_target_position = false

		arg_4_0:_set_target_position(arg_4_2, var_4_3, POSITION_LOOKUP[var_4_4], arg_4_3)
	end

	var_4_3.has_been_blocked = false
	var_4_3.attack_start_time = arg_4_3
	var_4_3.push_non_targets = var_4_0.push_non_targets

	table.clear(var_4_3.pushed_targets)

	local var_4_5 = arg_4_2.target_status_extension

	if not var_4_3.is_animation_driven and var_4_0.is_animation_driven and var_4_5 and not var_4_5:is_knocked_down() then
		LocomotionUtils.set_animation_driven_movement(arg_4_1, true, true, true)

		var_4_3.is_animation_driven = true

		arg_4_2.navigation_extension:set_max_speed(0)
	elseif var_4_3.is_animation_driven and not var_4_0.is_animation_driven then
		LocomotionUtils.set_animation_driven_movement(arg_4_1, false)

		var_4_3.is_animation_driven = false
	end

	arg_4_2.locomotion_extension:set_rotation_speed(var_0_0)

	if var_4_0.rotation_scheme == "on_enter" or var_4_0.rotation_scheme == "continuous" then
		arg_4_0:_update_rotation_target(arg_4_3, arg_4_1, arg_4_2, var_4_3)
	end

	if var_4_0.bot_threat_duration then
		local var_4_6 = LocomotionUtils.rotation_towards_unit_flat(arg_4_1, var_4_4)
		local var_4_7 = var_4_0.bot_threat_range or 2
		local var_4_8 = var_4_0.bot_threat_width or 1
		local var_4_9 = var_4_7 * 0.5
		local var_4_10 = Quaternion.rotate(var_4_6, Vector3.forward()) * var_4_9
		local var_4_11 = POSITION_LOOKUP[arg_4_1] + var_4_10 + Vector3.up() * 0.5

		Managers.state.entity:system("ai_bot_group_system"):aoe_threat_created(var_4_11, "oobb", Vector3(var_4_8, var_4_7, 0.5), var_4_6, var_4_0.bot_threat_duration, "Combo Attack")
	end

	local var_4_12 = var_4_0.damage_done_time

	if var_4_12 then
		if type(var_4_12) == "table" then
			var_4_3.damage_done_time = arg_4_3 + var_4_12[var_4_2]
		else
			var_4_3.damage_done_time = arg_4_3 + var_4_12
		end
	end
end

function BTComboAttackAction.leave(arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4, arg_5_5)
	if arg_5_2.move_state ~= "idle" then
		Managers.state.network:anim_event(arg_5_1, "idle")

		arg_5_2.move_state = "idle"
	end

	local var_5_0 = arg_5_2.combo_attack_data

	if var_5_0.is_animation_driven and not arg_5_5 then
		LocomotionUtils.set_animation_driven_movement(arg_5_1, false)

		var_5_0.is_animation_driven = false
	end

	local var_5_1 = arg_5_2.target_status_extension

	if var_5_1 then
		var_5_1:add_combo_target_count(-1)
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
		var_5_0.aborted = true
	end

	var_5_0.damage_done_time = nil

	arg_5_2.navigation_extension:set_max_speed(arg_5_2.breed.run_speed)
end

function BTComboAttackAction.run(arg_6_0, arg_6_1, arg_6_2, arg_6_3, arg_6_4)
	local var_6_0 = arg_6_2.combo_attack_data
	local var_6_1 = var_6_0.attacking_target

	if arg_6_2.attack_aborted or not Unit.alive(var_6_1) then
		var_6_0.aborted = true

		return "done"
	end

	local var_6_2 = arg_6_2.action
	local var_6_3 = var_6_2.combo_attacks[var_6_0.current_attack_name]

	if var_6_0.blocked then
		var_6_0.blocked = false
		var_6_0.has_been_blocked = true
	end

	if var_6_0.damage_done_time and arg_6_3 > var_6_0.damage_done_time then
		var_6_0.damage_done_time = nil
		arg_6_2.attacking_target = nil
	end

	if arg_6_2.attack_finished or var_6_0.has_been_blocked and var_6_3.block_interrupts then
		local var_6_4 = var_6_0.successful_hit
		local var_6_5 = var_6_0.has_been_blocked and var_6_3.next_blocked or var_6_4 and var_6_3.next_hit or var_6_3.next
		local var_6_6 = var_0_1(var_6_5, arg_6_2)

		if var_6_3.combo_cooldown_start then
			Unit.set_data(var_6_1, "last_combo_t", arg_6_3)
		end

		if var_6_6 == "done" then
			return "done"
		elseif var_6_6 == "stagger" then
			arg_6_2.blocked = true

			return "done"
		else
			arg_6_0:_start_attack(arg_6_1, arg_6_2, arg_6_3, var_6_2, var_6_6)
		end
	end

	if not arg_6_2.anim_cb_move_stop and not var_6_0.is_animation_driven and var_6_1 then
		arg_6_0:_follow(arg_6_4, arg_6_3, arg_6_1, arg_6_2, var_6_3)
	else
		arg_6_2.navigation_extension:set_max_speed(0)
	end

	local var_6_7 = arg_6_2.attack_damage_triggered and "no_rotation" or var_6_3.rotation_scheme

	if var_6_7 == "continuous" then
		arg_6_0:_update_rotation_target(arg_6_3, arg_6_1, arg_6_2, var_6_0)
	elseif type(var_6_7) == "table" then
		arg_6_0:_update_rotation_target_lerped(arg_6_3, arg_6_1, arg_6_2, var_6_0, var_6_7)
	end

	arg_6_2.locomotion_extension:set_wanted_rotation(var_6_0.rotation_target:unbox())

	local var_6_8 = var_6_0.push_non_targets

	if var_6_8 then
		local var_6_9 = Vector3.normalize(Vector3.flat(Quaternion.forward(var_6_0.rotation_target:unbox())))

		arg_6_0:_push_non_targets(arg_6_1, POSITION_LOOKUP[arg_6_1], var_6_1, var_6_0, var_6_9, var_6_8.close_impact_radius, var_6_8.far_impact_radius, var_6_8.forward_impact_speed, var_6_8.lateral_impact_speed)
	end

	return "running"
end

function BTComboAttackAction._follow(arg_7_0, arg_7_1, arg_7_2, arg_7_3, arg_7_4, arg_7_5)
	local var_7_0 = arg_7_4.breed
	local var_7_1 = arg_7_4.combo_attack_data.attacking_target
	local var_7_2 = (var_7_0.weapon_reach or 2)^2
	local var_7_3 = POSITION_LOOKUP[var_7_1] - POSITION_LOOKUP[arg_7_3]
	local var_7_4 = Vector3.length_squared(var_7_3)
	local var_7_5 = arg_7_5.run_speed or var_7_0.run_speed

	if var_7_4 < var_7_2 then
		local var_7_6 = arg_7_4.target_locomotion_extension
		local var_7_7 = var_7_6 and var_7_6.average_velocity and var_7_6:average_velocity() or Vector3.zero()

		var_7_5 = math.max(math.min(var_7_5, Vector3.dot(var_7_7, Vector3.normalize(var_7_3))), 0)
	end

	local var_7_8 = arg_7_5.attack_start_slow_factor_time or var_7_0.attack_start_slow_factor_time or 0.3

	if arg_7_2 < arg_7_0.last_attack_time + var_7_8 then
		local var_7_9 = arg_7_5.attack_start_slow_fraction or var_7_0.attack_start_slow_fraction or 0

		var_7_5 = var_7_5 * (1 - var_7_9 + var_7_9 * ((arg_7_2 - arg_7_0.last_attack_time) / var_7_8))
	end

	local var_7_10 = arg_7_5.attack_stop_time or var_7_0.attack_stop_time or nil

	if var_7_10 and arg_7_2 > arg_7_0.last_attack_time + var_7_10 then
		var_7_5 = 0
	end

	if arg_7_4.target_dodged_during_attack and arg_7_2 < arg_7_0.dodge_timer then
		var_7_5 = math.clamp(var_7_5, 0, 3)
	end

	arg_7_4.navigation_extension:set_max_speed(var_7_5)
end

function BTComboAttackAction.attack_success(arg_8_0, arg_8_1, arg_8_2)
	if arg_8_2.breed.use_backstab_vo and arg_8_2.backstab_attack_trigger then
		Managers.state.entity:system("dialogue_system"):trigger_backstab_hit(arg_8_2.target_unit, arg_8_1)

		arg_8_2.backstab_attack_trigger = false
	end

	arg_8_2.combo_attack_data.successful_hit = true
end

function BTComboAttackAction._update_rotation_target(arg_9_0, arg_9_1, arg_9_2, arg_9_3, arg_9_4)
	local var_9_0 = arg_9_3.target_status_extension
	local var_9_1 = var_9_0 and (var_9_0:get_is_dodging() or var_9_0:is_invisible())
	local var_9_2

	if var_9_1 and not arg_9_3.target_dodged_during_attack then
		arg_9_3.locomotion_extension:set_rotation_speed(2)

		arg_9_4.refresh_last_target_position = true
		arg_9_3.target_dodged_during_attack = true
		arg_9_0.dodge_timer = arg_9_1 + (arg_9_3.breed.dodge_timer or 0.3)
	end

	if arg_9_3.target_dodged_during_attack and arg_9_1 < arg_9_0.dodge_timer then
		var_9_2 = arg_9_4.last_target_position:unbox()
	else
		var_9_2 = POSITION_LOOKUP[arg_9_4.attacking_target]
	end

	arg_9_0:_set_target_position(arg_9_3, arg_9_4, var_9_2, arg_9_1)

	local var_9_3 = LocomotionUtils.look_at_position_flat(arg_9_2, var_9_2)

	arg_9_4.rotation_target:store(var_9_3)
end

function BTComboAttackAction._set_target_position(arg_10_0, arg_10_1, arg_10_2, arg_10_3, arg_10_4)
	local var_10_0 = arg_10_1.target_locomotion_extension

	arg_10_2.last_target_position:store(arg_10_3)
	arg_10_2.last_target_velocity:store(var_10_0 and var_10_0:current_velocity() or Vector3.zero())

	arg_10_2.last_target_position_time = arg_10_4
end

function BTComboAttackAction._update_rotation_target_lerped(arg_11_0, arg_11_1, arg_11_2, arg_11_3, arg_11_4, arg_11_5)
	arg_11_0:_update_rotation_target(arg_11_1, arg_11_2, arg_11_3, arg_11_4)

	local var_11_0 = arg_11_1 - arg_11_4.attack_start_time
	local var_11_1 = arg_11_5.start_lerp_in
	local var_11_2 = arg_11_5.end_lerp_in
	local var_11_3 = arg_11_5.start_lerp_out
	local var_11_4 = arg_11_5.end_lerp_out
	local var_11_5 = arg_11_5.target_speed
	local var_11_6

	if var_11_0 < var_11_1 then
		var_11_6 = var_0_0
	elseif var_11_0 < var_11_2 then
		var_11_6 = math.lerp(var_0_0, var_11_5, (var_11_0 - var_11_1) / (var_11_2 - var_11_1))
	elseif var_11_0 < var_11_3 then
		var_11_6 = var_11_5
	elseif var_11_0 < var_11_4 then
		var_11_6 = math.lerp(var_11_5, var_0_0, (var_11_0 - var_11_3) / (var_11_4 - var_11_3))
	else
		var_11_6 = var_0_0
	end

	arg_11_3.locomotion_extension:set_rotation_speed(var_11_6)
end

function BTComboAttackAction.attack_cooldown(arg_12_0, arg_12_1, arg_12_2)
	local var_12_0 = Managers.time:time("game")

	arg_12_2.is_in_attack_cooldown, arg_12_2.attack_cooldown_at = arg_12_0:get_attack_cooldown_finished_at(arg_12_1, arg_12_2, var_12_0)
end

function BTComboAttackAction._push_non_targets(arg_13_0, arg_13_1, arg_13_2, arg_13_3, arg_13_4, arg_13_5, arg_13_6, arg_13_7, arg_13_8, arg_13_9)
	local var_13_0 = arg_13_7^2
	local var_13_1 = Managers.state.side.side_by_unit[arg_13_1].ENEMY_PLAYER_AND_BOT_UNITS

	for iter_13_0 = 1, #var_13_1 do
		local var_13_2 = var_13_1[iter_13_0]

		if var_13_2 ~= arg_13_3 and not arg_13_4.pushed_targets[var_13_2] and not ScriptUnit.extension(var_13_2, "status_system"):is_disabled() then
			local var_13_3 = POSITION_LOOKUP[var_13_2] - arg_13_2

			if var_13_0 > Vector3.length_squared(var_13_3) then
				local var_13_4 = Vector3.cross(arg_13_5, Vector3.up())
				local var_13_5 = Vector3.dot(var_13_4, var_13_3)
				local var_13_6 = math.auto_lerp(arg_13_6, arg_13_7, 1, 0, math.abs(var_13_5))
				local var_13_7 = arg_13_5 * var_13_6 * arg_13_8 + var_13_4 * var_13_6 * arg_13_9

				ScriptUnit.extension(var_13_2, "locomotion_system"):add_external_velocity(var_13_7)

				arg_13_4.pushed_targets[var_13_2] = true
			end
		end
	end
end

function BTComboAttackAction.stagger_override(arg_14_0, arg_14_1, arg_14_2, arg_14_3, arg_14_4, arg_14_5, arg_14_6, arg_14_7, arg_14_8, arg_14_9, arg_14_10)
	local var_14_0 = arg_14_2.combo_attack_data
	local var_14_1 = arg_14_2.action.combo_attacks[var_14_0.current_attack_name]

	if var_14_1.staggers_allowed[arg_14_6] or arg_14_10 and var_14_1.allow_push_stagger then
		return false
	else
		return true
	end
end

function BTComboAttackAction.anim_cb_frenzy_damage(arg_15_0, arg_15_1, arg_15_2)
	local var_15_0 = arg_15_2.action
	local var_15_1 = arg_15_2.combo_attack_data
	local var_15_2 = var_15_1.attacking_target

	if not Unit.alive(var_15_2) then
		return
	end

	arg_15_2.attack_damage_triggered = true

	if not DamageUtils.check_distance(var_15_0, arg_15_2, arg_15_1, var_15_2) or not DamageUtils.check_infront(arg_15_1, var_15_2) then
		return
	end

	local var_15_3 = var_15_1.current_attack_name
	local var_15_4 = var_15_0.combo_attacks[var_15_3]
	local var_15_5 = var_15_4.fatigue_type or var_15_0.fatigue_type
	local var_15_6 = var_15_0.attack_directions and var_15_0.attack_directions[arg_15_2.attack_anim]

	if DamageUtils.check_block(arg_15_1, var_15_2, var_15_5, var_15_6) then
		arg_15_2.blocked = false
		var_15_1.blocked = true

		return
	end

	var_15_1.successful_hit = true

	local var_15_7 = var_15_4.difficulty_damage
	local var_15_8

	if var_15_7 then
		var_15_8 = Managers.state.difficulty:get_difficulty_value_from_table(var_15_7)
	else
		var_15_8 = var_15_0.damage
	end

	local var_15_9 = ScriptUnit.has_extension(var_15_2, "dialogue_system")

	if var_15_9 then
		local var_15_10 = var_15_9.context.player_profile

		Managers.state.entity:system("surrounding_aware_system"):add_system_event(arg_15_1, "enemy_attack", DialogueSettings.armor_hit_broadcast_range, "attack_tag", "frenzy_attack_damage", "target_name", var_15_10)
	end

	AiUtils.damage_target(var_15_2, arg_15_1, var_15_0, var_15_8)
end

function BTComboAttackAction.get_attack_cooldown_finished_at(arg_16_0, arg_16_1, arg_16_2, arg_16_3)
	local var_16_0 = arg_16_2.combo_attack_data.attacking_target

	if not Unit.alive(var_16_0) then
		return false, 0
	end

	local var_16_1 = arg_16_2.action.diminishing_damage

	if not var_16_1 then
		return false, 0
	end

	local var_16_2 = ScriptUnit.has_extension(var_16_0, "ai_slot_system")

	if not var_16_2 or not var_16_2.has_slots_attached then
		return false, 0
	end

	local var_16_3 = Managers.state.entity:system("ai_slot_system"):slots_count(var_16_0)

	if var_16_3 == 0 then
		return false, 0
	end

	local var_16_4 = var_16_1[math.min(var_16_3, 9)].cooldown
	local var_16_5 = AiUtils.random(var_16_4[1], var_16_4[2])

	return true, var_16_5 + arg_16_3
end

function BTComboAttackAction.anim_cb_attack_vce(arg_17_0, arg_17_1, arg_17_2)
	if Managers.state.network:game() then
		Managers.state.entity:system("dialogue_system"):trigger_attack(arg_17_2, arg_17_2.target_unit, arg_17_1, false, false)
	end
end
