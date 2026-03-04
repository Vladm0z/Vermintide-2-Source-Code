-- chunkname: @scripts/unit_extensions/default_player_unit/enemy_states/packmaster/packmaster_state_dragging.lua

PackmasterStateDragging = class(PackmasterStateDragging, EnemyCharacterState)

local var_0_0 = true
local var_0_1 = 6

PackmasterStateDragging.init = function (arg_1_0, arg_1_1)
	EnemyCharacterState.init(arg_1_0, arg_1_1, "packmaster_dragging")

	local var_1_0 = arg_1_1

	arg_1_0.current_movement_speed_scale = 0
	arg_1_0.latest_valid_navmesh_position = Vector3Box(math.huge, math.huge, math.huge)
	arg_1_0.last_input_direction = Vector3Box(0, 0, 0)
	arg_1_0._hoist_ability_id = arg_1_0._career_extension:ability_id("hoist")
end

PackmasterStateDragging.on_enter = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5, arg_2_6, arg_2_7)
	local var_2_0 = arg_2_0._unit
	local var_2_1 = arg_2_0._input_extension
	local var_2_2 = arg_2_0._first_person_extension
	local var_2_3 = arg_2_0._status_extension
	local var_2_4 = arg_2_0._inventory_extension
	local var_2_5 = arg_2_0._health_extension
	local var_2_6 = arg_2_0._locomotion_extension:current_velocity()

	arg_2_0._enter_time = arg_2_5
	arg_2_0._move_input_direction = Vector3Box()

	StatusUtils.set_grabbed_by_pack_master_network("pack_master_pulling", arg_2_7, true, var_2_0)
	var_2_3:set_is_packmaster_dragging(arg_2_7)

	arg_2_0._dragged_unit = arg_2_7

	if var_0_0 then
		CharacterStateHelper.change_camera_state(arg_2_0._player, "follow_third_person")
		arg_2_0._first_person_extension:set_first_person_mode(false)
	end

	var_2_2:hide_weapons("catapulted")
	CharacterStateHelper.show_inventory_3p(var_2_0, false, true, Managers.player.is_server, var_2_4)

	arg_2_0._weapon_3p = var_2_4:get_weapon_unit_3p()
	arg_2_0.claw_left_hand_constraint = Unit.animation_find_constraint_target(var_2_0, "claw_target_left_hand")
	arg_2_0.claw_right_hand_constraint = Unit.animation_find_constraint_target(var_2_0, "claw_target_right_hand")
	arg_2_0.constraint_left_hand_node = Unit.node(arg_2_0._weapon_3p, "a_left_hand")
	arg_2_0.constraint_right_hand_node = Unit.node(arg_2_0._weapon_3p, "a_right_hand")

	StatusUtils.set_grabbed_by_pack_master_network("pack_master_dragging", arg_2_7, true, var_2_0)

	local var_2_7 = Managers.player:owner(var_2_0)
	local var_2_8 = var_2_7 and var_2_7.bot_player

	arg_2_0.blackboard = BLACKBOARDS[var_2_0]
	arg_2_0.breed = arg_2_0.blackboard.breed

	arg_2_0:set_breed_action("drag")

	if arg_2_6 == "standing" then
		arg_2_0.current_movement_speed_scale = 0
	elseif not script_data.disable_nice_movement then
		local var_2_9 = Vector3.length(var_2_6)
		local var_2_10 = PlayerUnitMovementSettings.get_movement_settings_table(var_2_0)

		arg_2_0.current_movement_speed_scale = math.min(var_2_9 / var_2_10.move_speed, 1)
	else
		arg_2_0.current_movement_speed_scale = 1
	end

	if not var_2_8 then
		local var_2_11 = Vector3.normalize(Vector3.flat(var_2_6))
		local var_2_12 = var_2_2:current_rotation()
		local var_2_13 = Vector3.dot(Quaternion.right(var_2_12), var_2_11)
		local var_2_14 = Vector3.dot(Vector3.normalize(Vector3.flat(Quaternion.forward(var_2_12))), var_2_11)
		local var_2_15 = Vector3(var_2_13, var_2_14, 0)

		arg_2_0.last_input_direction:store(var_2_15)
	end

	local var_2_16, var_2_17 = arg_2_0:_get_packmaster_drag_animation()

	arg_2_0.move_anim_3p = var_2_16
	arg_2_0.move_anim_1p = var_2_17

	CharacterStateHelper.play_animation_event(var_2_0, "drag_walk")
	CharacterStateHelper.play_animation_event(var_2_0, var_2_16)
	CharacterStateHelper.play_animation_event_first_person(var_2_2, var_2_17)
	CharacterStateHelper.look(var_2_1, arg_2_0._player.viewport_name, var_2_2, var_2_3, var_2_4)
	CharacterStateHelper.update_weapon_actions(arg_2_5, var_2_0, var_2_1, var_2_4, var_2_5)
	arg_2_0._locomotion_extension:enable_rotation_towards_velocity(false)

	arg_2_0.is_bot = var_2_8
	arg_2_0._next_damage_pulse_time = 0
	arg_2_0._unhook_on_exit = true
end

PackmasterStateDragging.update = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5)
	local var_3_0 = arg_3_0._csm
	local var_3_1 = arg_3_0._world
	local var_3_2 = arg_3_0._unit
	local var_3_3 = arg_3_0._temp_params
	local var_3_4 = arg_3_0._dragged_unit
	local var_3_5 = ScriptUnit.has_extension(var_3_4, "status_system")
	local var_3_6 = var_3_5 and var_3_5:get_is_ledge_hanging()

	if not HEALTH_ALIVE[var_3_4] or var_3_6 then
		var_3_0:change_state("walking", var_3_3)

		return
	end

	local var_3_7 = PlayerUnitMovementSettings.get_movement_settings_table(var_3_2)
	local var_3_8 = ScriptUnit.extension(var_3_4, "inventory_system")
	local var_3_9 = var_3_8:equipment().right_hand_wielded_unit_3p
	local var_3_10 = var_3_8:get_wielded_slot_name()
	local var_3_11 = arg_3_0._input_extension
	local var_3_12 = arg_3_0._status_extension
	local var_3_13 = arg_3_0._first_person_extension
	local var_3_14 = arg_3_0._locomotion_extension
	local var_3_15 = arg_3_0._inventory_extension
	local var_3_16 = arg_3_0._career_extension

	if CharacterStateHelper.is_dead(var_3_12) then
		var_3_0:change_state("dead")

		return
	end

	local var_3_17 = arg_3_0.current_movement_speed_scale
	local var_3_18 = CharacterStateHelper

	if var_3_14:is_on_ground() then
		ScriptUnit.extension(var_3_2, "whereabouts_system"):set_is_onground()
	end

	if var_3_18.is_using_transport(var_3_12) then
		var_3_0:change_state("using_transport")

		return
	end

	if var_3_18.is_pushed(var_3_12) then
		var_3_12:set_pushed(false)

		local var_3_19 = var_3_7.stun_settings.pushed

		var_3_19.hit_react_type = var_3_12:hit_react_type() .. "_push"

		var_3_0:change_state("stunned", var_3_19)

		return
	end

	if var_3_18.is_staggered(var_3_12) then
		var_3_0:change_state("staggered")

		return true
	end

	if var_3_18.is_block_broken(var_3_12) then
		var_3_12:set_block_broken(false)

		local var_3_20 = var_3_7.stun_settings.parry_broken

		var_3_20.hit_react_type = "medium_push"

		var_3_0:change_state("stunned", var_3_20)

		return
	end

	if var_3_14:is_animation_driven() then
		return
	end

	local var_3_21 = Unit.world_position(arg_3_0._weapon_3p, arg_3_0.constraint_right_hand_node)
	local var_3_22 = Unit.world_position(arg_3_0._weapon_3p, arg_3_0.constraint_left_hand_node)

	Unit.animation_set_constraint_target(var_3_2, arg_3_0.claw_left_hand_constraint, var_3_21)
	Unit.animation_set_constraint_target(var_3_2, arg_3_0.claw_right_hand_constraint, var_3_22)

	local var_3_23 = Managers.input:is_device_active("gamepad")
	local var_3_24 = var_3_12:is_crouching()
	local var_3_25 = Managers.player:owner(var_3_2)
	local var_3_26 = var_3_18.get_movement_input(var_3_11)
	local var_3_27 = var_3_18.has_move_input(var_3_11)

	if not arg_3_0.is_bot then
		local var_3_28 = arg_3_0._breed and arg_3_0._breed.breed_move_acceleration_up
		local var_3_29 = arg_3_0._breed and arg_3_0._breed.breed_move_acceleration_down
		local var_3_30 = var_3_28 * arg_3_3 or var_3_7.move_acceleration_up * arg_3_3
		local var_3_31 = var_3_29 * arg_3_3 or var_3_7.move_acceleration_down * arg_3_3

		if var_3_27 then
			var_3_17 = math.min(1, var_3_17 + var_3_30)

			if var_3_23 then
				var_3_17 = Vector3.length(var_3_26) * var_3_17
			end
		else
			var_3_17 = math.max(0, var_3_17 - var_3_31)
		end
	else
		var_3_17 = var_3_27 and 1 or 0
	end

	local var_3_32 = arg_3_0:_get_current_drag_speed(arg_3_5) * var_3_17 * var_3_7.player_speed_scale
	local var_3_33 = Vector3.normalize(var_3_26)

	if Vector3.length_squared(var_3_26) == 0 then
		var_3_33 = arg_3_0.last_input_direction:unbox()
	else
		arg_3_0.last_input_direction:store(var_3_33)
	end

	local var_3_34 = POSITION_LOOKUP[var_3_4]
	local var_3_35 = var_3_34 - POSITION_LOOKUP[var_3_2]

	Vector3.set_z(var_3_35, 0)

	local var_3_36 = Vector3.normalize(var_3_35)
	local var_3_37 = Quaternion.look(var_3_36, Vector3(0, 0, 1))

	Unit.set_local_rotation(var_3_2, 0, var_3_37)

	local var_3_38 = arg_3_0.move_anim_1p == "idle"

	var_3_18.packmaster_move_on_ground(arg_3_5, var_3_13, var_3_11, var_3_14, var_3_33, var_3_32, var_3_2, arg_3_0._player, var_3_36, var_3_4, var_3_38)
	var_3_18.look(var_3_11, arg_3_0._player.viewport_name, var_3_13, var_3_12, var_3_15)

	local var_3_39, var_3_40 = arg_3_0:_get_packmaster_drag_animation()
	local var_3_41 = Vector3.distance(var_3_34, POSITION_LOOKUP[var_3_2])
	local var_3_42 = math.clamp(var_3_41 - 2, -11.9, 11.9)

	Managers.state.network:anim_set_variable_float(var_3_2, "distance_to_target", var_3_42)

	if var_3_39 ~= arg_3_0.move_anim_3p or var_3_40 ~= arg_3_0.move_anim_1p then
		local var_3_43 = ScriptUnit.extension(var_3_4, "inventory_system")
		local var_3_44 = var_3_43:get_wielded_slot_name()
		local var_3_45 = var_3_43:equipment().right_hand_wielded_unit_3p and var_3_44 == "slot_packmaster_claw"

		if var_3_40 == "idle" and var_3_45 then
			Managers.state.entity:system("inventory_system"):weapon_anim_event(var_3_4, "attack_grab_idle")
		end

		arg_3_0.move_anim_3p = var_3_39
		arg_3_0.move_anim_1p = var_3_40

		var_3_18.play_animation_event(var_3_2, "drag_walk")
		var_3_18.play_animation_event(var_3_2, var_3_39)
		var_3_18.play_animation_event_first_person(var_3_13, var_3_40)
	end

	local var_3_46 = var_3_14:current_relative_velocity_3p()

	Managers.state.network:anim_set_variable_float(var_3_2, "drag_move_forward", math.clamp(var_3_46.y, -12, 12))
	Managers.state.network:anim_set_variable_float(var_3_2, "drag_move_right", math.clamp(var_3_46.x, -12, 12))

	arg_3_0.current_movement_speed_scale = var_3_17

	local var_3_47 = ScriptUnit.extension(var_3_4, "status_system")

	if var_3_47:is_pounced_down() then
		local var_3_48 = arg_3_0._temp_params

		var_3_0:change_state("walking", var_3_48)

		return
	end

	if var_3_41 > var_0_1 then
		local var_3_49 = arg_3_0._temp_params

		var_3_0:change_state("walking", var_3_49)

		return
	end

	if var_3_16:ability_was_triggered(arg_3_0._hoist_ability_id) then
		arg_3_0._unhook_on_exit = false

		var_3_0:change_state("packmaster_hoisting", var_3_4)

		return
	end

	local var_3_50 = var_3_47:get_pack_master_grabber()

	if var_3_50 and var_3_50 ~= arg_3_0._unit then
		var_3_0:change_state("walking", var_3_3)
	end

	arg_3_0:update_damage(var_3_2, var_3_4, arg_3_5)
end

PackmasterStateDragging._get_current_drag_speed = function (arg_4_0, arg_4_1)
	local var_4_0 = arg_4_0.breed.initial_drag_movement_speed
	local var_4_1 = arg_4_0.breed.initial_drag_movement_speed_duration
	local var_4_2 = arg_4_0.breed.drag_movement_speed
	local var_4_3 = arg_4_1 - arg_4_0._enter_time
	local var_4_4

	if var_4_3 < var_4_1 then
		var_4_4 = var_4_0
	else
		var_4_4 = var_4_2
	end

	return var_4_4
end

PackmasterStateDragging.on_exit = function (arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4, arg_5_5, arg_5_6)
	if arg_5_0._unhook_on_exit then
		arg_5_0:_release_dragged_target()
	end

	arg_5_0._locomotion_extension:enable_rotation_towards_velocity(true)
	arg_5_0:set_breed_action("n/a")

	if not arg_5_0.is_bot then
		local var_5_0 = Managers.player:local_player()
		local var_5_1 = Managers.player:owner(arg_5_0._unit)

		if var_5_0 and var_5_0 == var_5_1 then
			local var_5_2 = math.round(arg_5_5 - arg_5_0._enter_time)

			if var_5_2 > 0 then
				local var_5_3 = var_5_0:stats_id()

				Managers.player:statistics_db():modify_stat_by_amount(var_5_3, "vs_drag_heroes", var_5_2)
			end
		end
	end
end

PackmasterStateDragging._release_dragged_target = function (arg_6_0)
	local var_6_0 = arg_6_0._status_extension
	local var_6_1 = arg_6_0._first_person_extension

	if var_0_0 then
		CharacterStateHelper.change_camera_state(arg_6_0._player, "follow")
		var_6_1:toggle_visibility(CameraTransitionSettings.perspective_transition_time)
	end

	var_6_1:unhide_weapons("catapulted")
	CharacterStateHelper.show_inventory_3p(arg_6_0._unit, true, true, Managers.player.is_server, arg_6_0._inventory_extension)
	var_6_0:set_packmaster_released()

	local var_6_2 = arg_6_0._dragged_unit

	if var_6_2 and Unit.alive(var_6_2) then
		StatusUtils.set_grabbed_by_pack_master_network("pack_master_unhooked", var_6_2, false, arg_6_0._unit)
	end
end

PackmasterStateDragging.update_damage = function (arg_7_0, arg_7_1, arg_7_2, arg_7_3)
	if arg_7_3 > arg_7_0._next_damage_pulse_time then
		local var_7_0 = arg_7_0.breed
		local var_7_1 = var_7_0.dragging_damage_amount
		local var_7_2 = var_7_0.dragging_hit_zone_name
		local var_7_3 = var_7_0.dragging_damage_type
		local var_7_4

		DamageUtils.add_damage_network(arg_7_2, arg_7_1, var_7_1, var_7_2, var_7_3, nil, Vector3.up(), var_7_0.name, nil, nil, nil, var_7_4, nil, nil, nil, nil, nil, nil, 1)

		arg_7_0._next_damage_pulse_time = arg_7_3 + var_7_0.dragging_time_to_damage
	end
end

local var_0_2 = 0.05

PackmasterStateDragging._get_packmaster_drag_animation = function (arg_8_0)
	local var_8_0 = arg_8_0._locomotion_extension

	if Vector3.length(var_8_0:current_velocity()) < var_0_2 then
		return "attack_grab_idle", "idle"
	end

	local var_8_1 = CharacterStateHelper.get_movement_input(arg_8_0._input_extension)
	local var_8_2 = arg_8_0._unit
	local var_8_3 = Unit.get_data(var_8_2, "breed")
	local var_8_4

	if var_8_3 and var_8_3.run_threshold then
		var_8_4 = Vector3.length(Vector3.flat(var_8_0:current_velocity())) < var_8_3.run_threshold
	end

	if var_8_1.y < 0 then
		return "move_bwd", var_8_4 and "walk_bwd" or "move_bwd"
	end

	return "move_fwd", var_8_4 and "walk_fwd" or "move_fwd"
end
