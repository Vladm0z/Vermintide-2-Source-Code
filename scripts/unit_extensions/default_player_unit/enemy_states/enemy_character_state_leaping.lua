-- chunkname: @scripts/unit_extensions/default_player_unit/enemy_states/enemy_character_state_leaping.lua

EnemyCharacterStateLeaping = class(EnemyCharacterStateLeaping, EnemyCharacterState)

EnemyCharacterStateLeaping.init = function (arg_1_0, arg_1_1)
	EnemyCharacterState.init(arg_1_0, arg_1_1, "leaping")

	arg_1_0._direction = Vector3Box()
end

local var_0_0 = POSITION_LOOKUP

EnemyCharacterStateLeaping.on_enter = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5, arg_2_6, arg_2_7)
	table.clear(arg_2_0._temp_params)

	arg_2_0._time_entered_leap = arg_2_5

	local var_2_0 = arg_2_0._player
	local var_2_1 = arg_2_0._input_extension
	local var_2_2 = arg_2_0._status_extension

	arg_2_0._locomotion_extension:set_mover_filter_property("enemy_leap_state", true)

	local var_2_3 = arg_2_0._inventory_extension
	local var_2_4 = arg_2_0._first_person_extension
	local var_2_5 = var_2_2.do_leap

	var_2_5.starting_pos = Vector3Box(var_0_0[arg_2_1])
	var_2_5.total_distance = Vector3.length(var_2_5.projected_hit_pos:unbox() - var_0_0[arg_2_1])
	arg_2_0._leap_data = var_2_5
	var_2_2.do_leap = false

	local var_2_6 = var_2_4:current_rotation()
	local var_2_7 = Vector3.normalize(Vector3.flat(Quaternion.forward(var_2_6)))
	local var_2_8 = var_0_0[arg_2_1]
	local var_2_9 = var_2_5.projected_hit_pos:unbox()

	arg_2_0._percentage_done = 0
	arg_2_0.initial_jump_direction = Vector3Box(var_2_9 - var_2_8)
	arg_2_0.jump_direction = Vector3Box(var_2_7)

	arg_2_0:_start_leap(arg_2_1, arg_2_5)
	CharacterStateHelper.look(var_2_1, var_2_0.viewport_name, var_2_4, var_2_2, arg_2_0._inventory_extension)
	CharacterStateHelper.update_weapon_actions(arg_2_5, arg_2_1, var_2_1, var_2_3, arg_2_0._health_extension)
	ScriptUnit.extension(arg_2_1, "whereabouts_system"):set_jumped()

	arg_2_0._time_slided = 0
	arg_2_0._played_landing_event = nil
end

EnemyCharacterStateLeaping.on_exit = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5, arg_3_6, arg_3_7)
	local var_3_0 = arg_3_0._locomotion_extension

	var_3_0:set_mover_filter_property("enemy_leap_state", false)

	if not arg_3_7 then
		local var_3_1 = Vector3.copy(var_0_0[arg_3_1])
		local var_3_2 = arg_3_0._leap_data.projected_hit_pos:unbox()

		if var_3_1 and var_3_2 and var_3_1.z < var_3_2.z then
			var_3_1.z = var_3_2.z + 0.1

			var_3_0:teleport_to(var_3_1)
		end

		var_3_0:set_forced_velocity(Vector3.zero())
		var_3_0:set_wanted_velocity(Vector3.zero())

		if not arg_3_0._leap_done and arg_3_0._leap_data.leap_events.finished then
			local var_3_3 = var_0_0[arg_3_1]

			arg_3_0._leap_data.leap_events.finished(arg_3_0, arg_3_1, false, var_3_3)
		end

		if arg_3_6 == "walking" or arg_3_6 == "standing" then
			ScriptUnit.extension(arg_3_1, "whereabouts_system"):set_landed()
		elseif arg_3_6 and arg_3_6 ~= "falling" then
			ScriptUnit.extension(arg_3_1, "whereabouts_system"):set_no_landing()
		end

		if arg_3_6 and arg_3_6 ~= "falling" and arg_3_6 ~= "staggered" and Managers.state.network:game() then
			CharacterStateHelper.play_animation_event(arg_3_1, "land_still")
			CharacterStateHelper.play_animation_event(arg_3_1, "to_onground")
			var_3_0:force_on_ground(true)
		end

		if arg_3_0._screenspace_effect_id then
			arg_3_0._first_person_extension:destroy_screen_particles(arg_3_0._screenspace_effect_id)

			arg_3_0._screenspace_effect_id = nil
		end
	end
end

EnemyCharacterStateLeaping.update = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4, arg_4_5)
	local var_4_0 = arg_4_0._csm
	local var_4_1 = PlayerUnitMovementSettings.get_movement_settings_table(arg_4_1)
	local var_4_2 = arg_4_0._input_extension
	local var_4_3 = arg_4_0._status_extension
	local var_4_4 = arg_4_0._first_person_extension
	local var_4_5 = arg_4_0._locomotion_extension
	local var_4_6 = arg_4_0._inventory_extension

	if CharacterStateHelper.do_common_state_transitions(var_4_3, var_4_0) then
		return
	end

	if CharacterStateHelper.is_using_transport(var_4_3) then
		var_4_0:change_state("using_transport")

		return
	end

	if CharacterStateHelper.is_overcharge_exploding(var_4_3) then
		var_4_0:change_state("overcharge_exploding")

		return
	end

	if CharacterStateHelper.is_pushed(var_4_3) then
		var_4_3:set_pushed(false)

		local var_4_7 = var_4_1.stun_settings.pushed

		var_4_7.hit_react_type = var_4_3:hit_react_type() .. "_push"

		var_4_0:change_state("stunned", var_4_7)

		return
	end

	if CharacterStateHelper.is_block_broken(var_4_3) then
		var_4_3:set_block_broken(false)

		local var_4_8 = var_4_1.stun_settings.parry_broken

		var_4_8.hit_react_type = "medium_push"

		var_4_0:change_state("stunned", var_4_8)

		return
	end

	arg_4_0._time_spent_in_leap = arg_4_5 - arg_4_0._time_entered_leap

	local var_4_9, var_4_10, var_4_11 = arg_4_0:_update_movement(arg_4_1, arg_4_3, arg_4_5)

	if var_4_9 then
		arg_4_0:_finish(arg_4_1, arg_4_5)

		if var_4_10 then
			var_4_0:change_state("walking", arg_4_0._temp_params)
			var_4_4:change_state("walking")

			arg_4_0._leap_done = true

			return
		end

		local var_4_12 = var_4_5:current_velocity()

		if not arg_4_0._csm.state_next and (var_4_12.z <= 0 or var_4_11) then
			if var_4_11 then
				var_4_12.y = 0
			end

			arg_4_0._locomotion_extension:set_wanted_velocity(Vector3.zero())
			arg_4_0._locomotion_extension:set_forced_velocity(Vector3.zero())
			var_4_0:change_state("falling", arg_4_0._temp_params)
			var_4_4:change_state("falling")

			arg_4_0._leap_done = true

			return
		end
	end

	local var_4_13 = var_0_0[arg_4_1]
	local var_4_14 = arg_4_0._leap_data.starting_pos:unbox()
	local var_4_15 = arg_4_0._leap_data.projected_hit_pos:unbox()

	arg_4_0._percentage_done = Vector3.length(var_4_13 - var_4_14) / Vector3.length(var_4_15 - var_4_14)

	if arg_4_0._leap_data.update_leap_anim_variable then
		arg_4_0._leap_data.update_leap_anim_variable(arg_4_0, arg_4_1)
	end

	if Vector3.distance_squared(var_4_13, var_4_15) < 0.25 then
		arg_4_0._leap_done = true
	end

	local var_4_16
	local var_4_17

	CharacterStateHelper.look(var_4_2, arg_4_0._player.viewport_name, var_4_4, var_4_3, var_4_6, var_4_16, var_4_17)
end

local function var_0_1(arg_5_0, arg_5_1, arg_5_2)
	return (math.clamp(arg_5_2, arg_5_0, arg_5_1) - arg_5_0) / (arg_5_1 - arg_5_0)
end

PlayerCharacterStateLeaping._reset_speed_and_gravity = function (arg_6_0, arg_6_1)
	local var_6_0 = arg_6_0.locomotion_extension

	PlayerUnitMovementSettings.get_movement_settings_table(arg_6_1).gravity_acceleration = PlayerUnitMovementSettings.gravity_acceleration

	var_6_0:set_forced_velocity(Vector3.zero())
	var_6_0:set_wanted_velocity(Vector3.zero())
	var_6_0:reset_maximum_upwards_velocity()
	var_6_0:set_external_velocity_enabled(true)
end

EnemyCharacterStateLeaping._move_in_air = function (arg_7_0, arg_7_1, arg_7_2, arg_7_3)
	local var_7_0 = arg_7_0._locomotion_extension
	local var_7_1 = var_0_0[arg_7_1]
	local var_7_2 = arg_7_0._leap_data.starting_pos:unbox()
	local var_7_3 = arg_7_0._leap_data.projected_hit_pos:unbox()
	local var_7_4 = Vector3.flat(var_7_1 - var_7_2)
	local var_7_5 = Vector3.flat(var_7_3 - var_7_2)
	local var_7_6 = Vector3.dot(var_7_4, var_7_5)
	local var_7_7 = Vector3.length(var_7_5)
	local var_7_8 = var_7_6 / var_7_7
	local var_7_9 = Vector3.normalize(arg_7_0._leap_data.direction:unbox())
	local var_7_10 = PlayerUnitMovementSettings.get_movement_settings_table(arg_7_1)
	local var_7_11 = arg_7_0._leap_data.movement_settings or PlayerUnitMovementSettings.get_movement_settings_table(arg_7_1)
	local var_7_12 = arg_7_0._leap_data.speed * arg_7_0._status_extension:current_move_speed_multiplier()^2 * var_7_11.player_speed_scale
	local var_7_13 = arg_7_0._leap_data.lerp_data
	local var_7_14 = var_7_7 * var_7_13.zero_distance or 0
	local var_7_15 = var_7_7 * var_7_13.start_accel_distance or 0.1
	local var_7_16 = var_7_7 * var_7_13.end_accel_distance or 0.2
	local var_7_17 = var_7_7 * var_7_13.glide_distance or 0.7
	local var_7_18 = var_7_7 * var_7_13.slow_distance or 0.95
	local var_7_19 = var_7_7 * var_7_13.full_distance or 1

	arg_7_0._old_position = var_7_1

	local var_7_20

	if var_7_8 <= var_7_15 then
		var_7_20 = "start_acceleration"

		local var_7_21 = var_0_1(var_7_14, var_7_15, var_7_8)
		local var_7_22 = math.ease_out_exp(var_7_21)

		var_7_12 = var_7_12 * math.lerp(0, 1.25, var_7_22)

		local var_7_23 = 0.05

		var_7_10.gravity_acceleration = PlayerUnitMovementSettings.gravity_acceleration * var_7_23

		local var_7_24 = math.clamp(var_7_11.move_speed, 0, var_7_11.max_move_speed)
		local var_7_25 = var_7_0:current_velocity()
		local var_7_26 = (Vector3.normalize(var_7_25) + var_7_9) * var_7_12
		local var_7_27 = Vector3.length(var_7_26)
		local var_7_28 = math.clamp(var_7_27, 0, var_7_24 * var_7_11.player_speed_scale)
		local var_7_29 = Vector3.normalize(var_7_26)

		var_7_0:set_wanted_velocity(var_7_29 * var_7_28)
	elseif var_7_8 <= var_7_16 then
		var_7_20 = "end_acceleration"

		local var_7_30 = var_0_1(var_7_15, var_7_16, var_7_8)
		local var_7_31 = math.easeOutCubic(var_7_30)

		var_7_12 = var_7_12 * math.lerp(1.25, 0.8, var_7_31)

		local var_7_32 = 0.1

		var_7_10.gravity_acceleration = PlayerUnitMovementSettings.gravity_acceleration * var_7_32

		local var_7_33 = math.clamp(var_7_11.move_speed, 0, var_7_11.max_move_speed)
		local var_7_34 = var_7_0:current_velocity()
		local var_7_35 = (Vector3.normalize(var_7_34) + var_7_9) * var_7_12
		local var_7_36 = Vector3.length(var_7_35)
		local var_7_37 = math.clamp(var_7_36, 0, var_7_33 * (var_7_11.player_speed_scale or 1))
		local var_7_38 = Vector3.normalize(var_7_35)

		var_7_0:set_wanted_velocity(var_7_38 * var_7_37)
	elseif var_7_8 <= var_7_17 then
		var_7_20 = "glide"

		local var_7_39 = var_0_1(var_7_16, var_7_17, var_7_8)
		local var_7_40 = math.ease_in_exp(var_7_39)

		var_7_12 = var_7_12 * math.lerp(0.8, 0.7, var_7_40)

		var_7_0:set_mover_filter_property("enemy_leap_state", false)

		local var_7_41 = 1

		var_7_10.gravity_acceleration = PlayerUnitMovementSettings.gravity_acceleration * var_7_41

		local var_7_42 = math.clamp(var_7_11.move_speed, 0, var_7_11.max_move_speed)
		local var_7_43 = var_7_0:current_velocity()
		local var_7_44 = (Vector3.normalize(var_7_43) + var_7_9) * var_7_12
		local var_7_45 = Vector3.length(var_7_44)
		local var_7_46 = math.clamp(var_7_45, 0, var_7_42 * (var_7_11.player_speed_scale or 1))
		local var_7_47 = Vector3.normalize(var_7_44)

		var_7_0:set_wanted_velocity(var_7_47 * var_7_46)
	elseif var_7_8 <= var_7_18 then
		var_7_20 = "slow"

		local var_7_48 = var_0_1(var_7_17, var_7_18, var_7_8)
		local var_7_49 = math.ease_out_quad(var_7_48)

		var_7_12 = var_7_12 * math.lerp(0.7, 0.6, var_7_49)
		var_7_10.gravity_acceleration = PlayerUnitMovementSettings.gravity_acceleration * var_7_49

		local var_7_50 = math.clamp(var_7_11.move_speed, 0, var_7_11.max_move_speed)
		local var_7_51 = var_7_0:current_velocity()
		local var_7_52 = (Vector3.normalize(var_7_51) + var_7_9) * var_7_12
		local var_7_53 = Vector3.length(var_7_52)
		local var_7_54 = math.clamp(var_7_53, 0, var_7_50 * var_7_11.player_speed_scale or 1)
		local var_7_55 = Vector3.normalize(var_7_52)

		var_7_0:set_wanted_velocity(var_7_55 * var_7_54)
	else
		var_7_20 = "slam"

		var_7_0:set_mover_filter_property("enemy_leap_state", false)

		local var_7_56 = var_0_1(var_7_18, var_7_19, var_7_8)
		local var_7_57 = math.ease_out_quad(var_7_56)
		local var_7_58 = var_7_12 * math.lerp(0.6, 1.2, var_7_57)
		local var_7_59 = math.lerp(0.25, 0, var_7_57)
		local var_7_60 = math.lerp(0, 0.75, var_7_57)
		local var_7_61 = 2

		var_7_10.gravity_acceleration = PlayerUnitMovementSettings.gravity_acceleration * var_7_61

		local var_7_62 = math.clamp(var_7_11.slam_speed, 0, var_7_11.max_slam_speed)
		local var_7_63 = var_7_0:current_velocity()
		local var_7_64 = Vector3.normalize(Vector3.flat(var_7_9)) * var_7_59 + Vector3.normalize(var_7_3 - var_7_1) * var_7_60
		local var_7_65 = (Vector3.normalize(var_7_63) + var_7_64) * var_7_58
		local var_7_66 = Vector3.length(var_7_65)
		local var_7_67 = math.clamp(var_7_66, 0, var_7_62 * var_7_11.player_speed_scale)
		local var_7_68 = Vector3.normalize(var_7_65)

		var_7_0:set_forced_velocity(var_7_68 * var_7_67)
	end

	return var_7_20
end

EnemyCharacterStateLeaping._update_movement = function (arg_8_0, arg_8_1, arg_8_2, arg_8_3)
	if arg_8_0._leap_done then
		return true
	end

	local var_8_0 = arg_8_0:_move_in_air(arg_8_1, arg_8_2, arg_8_3)
	local var_8_1 = CharacterStateHelper.is_colliding_down(arg_8_1)
	local var_8_2 = arg_8_0._locomotion_extension:current_velocity()
	local var_8_3 = Vector3.flat(var_8_2)
	local var_8_4 = Vector3.dot(Vector3.normalize(Vector3Box.unbox(arg_8_0.initial_jump_direction)), Vector3.normalize(var_8_3))
	local var_8_5

	if var_8_0 ~= "start_acceleration" and var_8_4 < 0 then
		var_8_5 = true
	end

	arg_8_0._leap_done = var_8_1 or var_8_5

	return arg_8_0._leap_done, var_8_1, var_8_5
end

EnemyCharacterStateLeaping._finish = function (arg_9_0, arg_9_1, arg_9_2)
	local var_9_0 = arg_9_0._locomotion_extension
	local var_9_1 = arg_9_0._first_person_extension

	var_9_1:play_camera_effect_sequence("landed_leap", arg_9_2)

	local var_9_2 = arg_9_0._leap_data.sfx_event_land

	if var_9_2 and not arg_9_0._played_landing_event then
		var_9_1:play_unit_sound_event(var_9_2, arg_9_1, 0, true)

		arg_9_0._played_landing_event = true
	end

	PlayerUnitMovementSettings.get_movement_settings_table(arg_9_1).gravity_acceleration = PlayerUnitMovementSettings.gravity_acceleration

	var_9_0:set_forced_velocity(Vector3.zero())
	var_9_0:set_wanted_velocity(Vector3.zero())

	if arg_9_0._leap_data.leap_events.finished then
		local var_9_3 = var_0_0[arg_9_1]

		arg_9_0._leap_data.leap_events.finished(arg_9_0, arg_9_1, false, var_9_3)
	end

	arg_9_0:_camera_effects(arg_9_1, 0)

	arg_9_0._leap_done = true
end

EnemyCharacterStateLeaping._start_leap = function (arg_10_0, arg_10_1, arg_10_2)
	local var_10_0 = arg_10_0._locomotion_extension
	local var_10_1 = arg_10_0._first_person_extension

	var_10_1:play_camera_effect_sequence("jump", arg_10_2)

	if arg_10_0._leap_data.anim_start_event_1p then
		CharacterStateHelper.play_animation_event_first_person(var_10_1, arg_10_0._leap_data.anim_start_event_1p)
	end

	if arg_10_0._leap_data.anim_start_event_3p then
		CharacterStateHelper.play_animation_event(arg_10_1, arg_10_0._leap_data.anim_start_event_3p)
	end

	local var_10_2 = arg_10_0._leap_data.sfx_event_jump

	if var_10_2 then
		var_10_1:play_unit_sound_event(var_10_2, arg_10_1, 0, true)
	end

	local var_10_3 = arg_10_0._leap_data.leap_events

	if var_10_3 and var_10_3.start then
		var_10_3.start(arg_10_0, arg_10_1)
	end

	local var_10_4 = arg_10_0._leap_data.direction:unbox() * PlayerUnitMovementSettings.leap.jump_speed + Vector3.up()

	var_10_0:set_maximum_upwards_velocity(var_10_4.z)
	var_10_0:set_forced_velocity(var_10_4)
	var_10_0:set_wanted_velocity(var_10_4)

	;(arg_10_0._leap_data.movement_settings or PlayerUnitMovementSettings.get_movement_settings_table(arg_10_1)).gravity_acceleration = PlayerUnitMovementSettings.gravity_acceleration * 0
	arg_10_0._leap_done = false
end

EnemyCharacterStateLeaping._camera_effects = function (arg_11_0, arg_11_1, arg_11_2)
	local var_11_0 = 1.5
	local var_11_1 = math.lerp(1, var_11_0, arg_11_2)

	Managers.state.camera:set_additional_fov_multiplier(var_11_1)

	local var_11_2 = "fx/speedlines_01_1p"

	if arg_11_2 >= 0.25 then
		if not arg_11_0._screenspace_effect_id then
			arg_11_0._screenspace_effect_id = arg_11_0._first_person_extension:create_screen_particles(var_11_2)
		end
	elseif arg_11_2 <= 0 and arg_11_0._screenspace_effect_id then
		arg_11_0._first_person_extension:destroy_screen_particles(arg_11_0._screenspace_effect_id)

		arg_11_0._screenspace_effect_id = nil
	end
end
