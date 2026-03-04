-- chunkname: @scripts/unit_extensions/default_player_unit/enemy_states/packmaster/packmaster_state_grabbing.lua

PackmasterStateGrabbing = class(PackmasterStateGrabbing, EnemyCharacterState)

PackmasterStateGrabbing.init = function (arg_1_0, arg_1_1)
	EnemyCharacterState.init(arg_1_0, arg_1_1, "packmaster_grabbing")

	arg_1_0.current_movement_speed_scale = 0
	arg_1_0.last_input_direction = Vector3Box(0, 0, 0)
end

local var_0_0 = POSITION_LOOKUP

PackmasterStateGrabbing.on_enter = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5, arg_2_6, arg_2_7)
	table.clear(arg_2_0._temp_params)

	arg_2_0._unit = arg_2_1

	local var_2_0 = Unit.get_data(arg_2_1, "breed")

	arg_2_0._breed = var_2_0
	arg_2_0._hook_range = var_2_0.grab_hook_range
	arg_2_0._grab_movement_speed_multiplier_initial = var_2_0.grab_movement_speed_multiplier_initial
	arg_2_0._grab_movement_speed_multiplier_target = var_2_0.grab_movement_speed_multiplier_target
	arg_2_0._move_slow_lerp_constant = 0.5
	arg_2_0._dot_threshold = var_2_0.grab_hook_cone_dot
	arg_2_0._physics_world = World.physics_world(arg_2_0._world)
	arg_2_0.highest_dot_value = 0

	local var_2_1 = arg_2_0._first_person_extension

	arg_2_0._first_person_unit = var_2_1:get_first_person_unit()

	CharacterStateHelper.play_animation_event(arg_2_1, "attack_grab")
	CharacterStateHelper.play_animation_event_first_person(var_2_1, "attack_grab")

	arg_2_0._grab_time = arg_2_5 + var_2_0.grab_anim_time
	arg_2_0._grab_grace_period = var_2_0.grab_grace_period

	arg_2_0._status_extension:set_is_packmaster_grabbing(true)
	arg_2_0:set_breed_action("initial_pull")
end

PackmasterStateGrabbing.on_exit = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5, arg_3_6)
	arg_3_0._status_extension:set_is_packmaster_grabbing(false)
	arg_3_0._career_extension:start_activated_ability_cooldown(1)
	arg_3_0:set_breed_action("n/a")
end

PackmasterStateGrabbing.update = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4, arg_4_5)
	local var_4_0 = arg_4_0._csm
	local var_4_1 = PlayerUnitMovementSettings.get_movement_settings_table(arg_4_1)
	local var_4_2 = arg_4_0._status_extension
	local var_4_3 = arg_4_0._first_person_extension
	local var_4_4 = arg_4_0._locomotion_extension

	if CharacterStateHelper.do_common_state_transitions(var_4_2, var_4_0) then
		return
	end

	if CharacterStateHelper.is_using_transport(var_4_2) then
		var_4_0:change_state("using_transport")

		return
	end

	if CharacterStateHelper.is_pushed(var_4_2) then
		var_4_2:set_pushed(false)

		local var_4_5 = var_4_1.stun_settings.pushed

		var_4_5.hit_react_type = var_4_2:hit_react_type() .. "_push"

		var_4_0:change_state("stunned", var_4_5)

		return
	end

	if CharacterStateHelper.is_block_broken(var_4_2) then
		var_4_2:set_block_broken(false)

		local var_4_6 = var_4_1.stun_settings.parry_broken

		var_4_6.hit_react_type = "medium_push"

		var_4_0:change_state("stunned", var_4_6)

		return
	end

	local var_4_7 = arg_4_0._grab_time
	local var_4_8 = {
		before = var_4_7 - arg_4_0._grab_grace_period.before,
		after = var_4_7 + arg_4_0._grab_grace_period.after
	}
	local var_4_9 = arg_4_0:_grab()

	if var_4_7 and arg_4_5 >= var_4_8.before then
		if var_4_9 or var_4_7 <= arg_4_5 then
			CharacterStateHelper.play_animation_event_first_person(var_4_3, "claw_closed")
		end

		local var_4_10 = ScriptUnit.extension(arg_4_1, "ghost_mode_system"):is_in_ghost_mode()

		if var_4_9 and not var_4_10 then
			local var_4_11 = ScriptUnit.extension_input(arg_4_1, "dialogue_system")
			local var_4_12 = FrameTable.alloc_table()

			var_4_11:trigger_networked_dialogue_event("hook_success", var_4_12)
			var_4_0:change_state("packmaster_dragging", var_4_9)
		elseif arg_4_5 >= var_4_8.after then
			local var_4_13 = ScriptUnit.extension_input(arg_4_1, "dialogue_system")
			local var_4_14 = FrameTable.alloc_table()

			var_4_13:trigger_networked_dialogue_event("hook_fail", var_4_14)
			var_4_0:change_state("walking")
		end
	end

	var_4_4:set_disable_rotation_update()
	arg_4_0:_update_movement(arg_4_1, arg_4_5, arg_4_3)
end

PackmasterStateGrabbing._grab = function (arg_5_0)
	if not arg_5_0._locomotion_extension:is_on_ground() then
		return nil
	end

	local var_5_0 = arg_5_0._unit
	local var_5_1 = arg_5_0._first_person_unit
	local var_5_2 = arg_5_0._physics_world

	return (EnemyCharacterStateHelper.get_enemies_in_line_of_sight(var_5_0, var_5_1, var_5_2))
end

PackmasterStateGrabbing._update_movement = function (arg_6_0, arg_6_1, arg_6_2, arg_6_3)
	local var_6_0 = arg_6_0._buff_extension
	local var_6_1 = PlayerUnitMovementSettings.get_movement_settings_table(arg_6_1)
	local var_6_2 = arg_6_0._input_extension
	local var_6_3 = arg_6_0._first_person_extension
	local var_6_4 = CharacterStateHelper.get_movement_input(var_6_2)
	local var_6_5 = CharacterStateHelper.has_move_input(var_6_2)
	local var_6_6 = arg_6_0.current_movement_speed_scale

	if not arg_6_0.is_bot then
		local var_6_7 = arg_6_0._breed and arg_6_0._breed.breed_move_acceleration_up
		local var_6_8 = arg_6_0._breed and arg_6_0._breed.breed_move_acceleration_down
		local var_6_9 = var_6_7 * arg_6_3 or var_6_1.move_acceleration_up * arg_6_3
		local var_6_10 = var_6_8 * arg_6_3 or var_6_1.move_acceleration_down * arg_6_3

		if var_6_5 then
			var_6_6 = math.min(1, var_6_6 + var_6_9)
		else
			var_6_6 = math.max(0, var_6_6 - var_6_10)
		end
	else
		var_6_6 = var_6_5 and 1 or 0
	end

	local var_6_11 = math.lerp(arg_6_0._grab_movement_speed_multiplier_initial, arg_6_0._grab_movement_speed_multiplier_target, arg_6_0._move_slow_lerp_constant * arg_6_3)
	local var_6_12 = var_6_1.move_speed * var_6_11
	local var_6_13 = var_6_0:apply_buffs_to_value(var_6_12, "movement_speed") * var_6_6 * var_6_1.player_speed_scale
	local var_6_14 = Vector3(0, 0, 0)

	if var_6_4 then
		var_6_14 = var_6_14 + var_6_4
	end

	local var_6_15
	local var_6_16 = Vector3.normalize(var_6_14)

	if Vector3.length(var_6_16) == 0 then
		var_6_16 = arg_6_0.last_input_direction:unbox()
	else
		arg_6_0.last_input_direction:store(var_6_16)
	end

	local var_6_17 = CharacterStateHelper.get_move_animation(arg_6_0._locomotion_extension, var_6_2, arg_6_0._status_extension, arg_6_0.move_anim_3p)

	if var_6_17 ~= arg_6_0.move_anim_3p then
		CharacterStateHelper.play_animation_event(arg_6_1, var_6_17)

		arg_6_0.move_anim_3p = var_6_17
	end

	CharacterStateHelper.move_on_ground(var_6_3, var_6_2, arg_6_0._locomotion_extension, var_6_16, var_6_13, arg_6_1)
	CharacterStateHelper.look(var_6_2, arg_6_0._player.viewport_name, var_6_3, arg_6_0._status_extension, arg_6_0._inventory_extension)

	arg_6_0.current_movement_speed_scale = var_6_6
end
