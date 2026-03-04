-- chunkname: @scripts/unit_extensions/default_player_unit/states/player_character_state_climbing_ladder.lua

PlayerCharacterStateClimbingLadder = class(PlayerCharacterStateClimbingLadder, PlayerCharacterState)

PlayerCharacterStateClimbingLadder.init = function (arg_1_0, arg_1_1)
	PlayerCharacterState.init(arg_1_0, arg_1_1, "climbing_ladder")

	local var_1_0 = arg_1_1

	arg_1_0.lerp_target_position = Vector3Box()
	arg_1_0.lerp_start_position = Vector3Box()
end

PlayerCharacterStateClimbingLadder.on_enter_animation_event = function (arg_2_0)
	local var_2_0 = arg_2_0.unit
	local var_2_1 = PlayerUnitMovementSettings.get_movement_settings_table(var_2_0)
	local var_2_2 = POSITION_LOOKUP[var_2_0]
	local var_2_3 = Vector3.z(var_2_2)

	if math.abs(arg_2_0.jump_off_height - var_2_3) < var_2_1.ladder.animation_distance_threshold_from_top_node then
		arg_2_0.entered_top = true

		CharacterStateHelper.play_animation_event(var_2_0, "climb_top_enter_ladder")
	else
		arg_2_0.entered_top = false

		CharacterStateHelper.play_animation_event(var_2_0, "climb_enter_ladder")
	end

	arg_2_0.first_person_extension:play_animation_event("climb_enter_ladder")
end

PlayerCharacterStateClimbingLadder.on_enter = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5, arg_3_6, arg_3_7)
	local var_3_0 = arg_3_0.unit
	local var_3_1 = arg_3_0.input_extension
	local var_3_2 = arg_3_0.first_person_extension
	local var_3_3 = arg_3_7.ladder_unit

	table.clear(arg_3_0.temp_params)

	arg_3_0.accumilated_distance = 0
	arg_3_0.ladder_unit = var_3_3
	arg_3_0.movement_speed = 1
	arg_3_0.animation_state = "no_animation"
	arg_3_0.climb_sfx_event = Unit.get_data(var_3_3, "sfx_footstep_event") or "player_footstep_ladder"

	local var_3_4 = Unit.node(var_3_3, "c_platform")

	arg_3_0.jump_off_height = Vector3.z(Unit.world_position(var_3_3, var_3_4))

	local var_3_5 = arg_3_0.locomotion_extension

	var_3_5:enable_script_driven_ladder_movement()
	var_3_5:enable_rotation_towards_velocity(false, Unit.local_rotation(var_3_3, 0), 0.5)

	local var_3_6 = Unit.world_position(arg_3_0.ladder_unit, 0)

	arg_3_0.ladder_position_height = Vector3.z(var_3_6)

	if arg_3_6 ~= "enter_ladder_top" then
		CharacterStateHelper.stop_weapon_actions(arg_3_0.inventory_extension, "ladder")
		CharacterStateHelper.stop_career_abilities(arg_3_0.career_extension, "ladder")

		local var_3_7 = Managers.state.network:unit_game_object_id(var_3_0)
		local var_3_8 = false

		CharacterStateHelper.show_inventory_3p(var_3_0, false, var_3_8, arg_3_0.is_server, arg_3_0.inventory_extension)
		arg_3_0.first_person_extension:hide_weapons("climbing")
		arg_3_0:on_enter_animation_event()
		CharacterStateHelper.set_is_on_ladder(var_3_3, var_3_0, true, arg_3_0.is_server, arg_3_0.status_extension)
	end

	var_3_5:set_mover_filter_property("ladder", true)
end

PlayerCharacterStateClimbingLadder.on_exit = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4, arg_4_5, arg_4_6)
	local var_4_0 = arg_4_0.locomotion_extension

	if arg_4_6 and arg_4_6 ~= "leaving_ladder_top" then
		local var_4_1 = arg_4_0.status_extension

		var_4_1:set_falling_height(true)
		var_4_1:set_left_ladder(arg_4_5)

		local var_4_2 = Managers.state.network:unit_game_object_id(arg_4_1)
		local var_4_3 = false

		CharacterStateHelper.show_inventory_3p(arg_4_1, true, var_4_3, arg_4_0.is_server, arg_4_0.inventory_extension)
		var_4_0:enable_script_driven_movement()
		var_4_0:enable_rotation_towards_velocity(true)
		arg_4_0.first_person_extension:unhide_weapons("climbing")

		if Managers.state.network:game() then
			CharacterStateHelper.play_animation_event(arg_4_1, "climb_end_ladder")
		end

		arg_4_0.first_person_extension:play_animation_event("idle")

		if Managers.state.network:game() then
			CharacterStateHelper.set_is_on_ladder(arg_4_0.ladder_unit, arg_4_1, false, arg_4_0.is_server, arg_4_0.status_extension)
		end
	end

	var_4_0:set_mover_filter_property("ladder", false)
end

PlayerCharacterStateClimbingLadder.update = function (arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4, arg_5_5)
	local var_5_0 = arg_5_0.csm
	local var_5_1 = arg_5_0.unit
	local var_5_2 = arg_5_0.input_extension
	local var_5_3 = arg_5_0.status_extension
	local var_5_4 = arg_5_0.locomotion_extension
	local var_5_5 = arg_5_0.player

	if CharacterStateHelper.do_common_state_transitions(var_5_3, var_5_0) then
		return
	end

	local var_5_6 = var_5_4:current_velocity().z

	if CharacterStateHelper.is_colliding_down(var_5_1) and var_5_6 < 0 then
		var_5_0:change_state("walking")

		return
	end

	local var_5_7 = ScriptUnit.extension(arg_5_0.ladder_unit, "ladder_system"):is_shaking()

	if not var_5_0.state_next and (var_5_2:get("jump") or var_5_2:get("jump_only") or var_5_7) then
		local var_5_8 = arg_5_0.temp_params

		var_5_8.ladder_unit = arg_5_0.ladder_unit
		var_5_8.shaking_ladder_unit = arg_5_0.ladder_unit

		var_5_0:change_state("jumping", var_5_8)

		return
	end

	local var_5_9, var_5_10 = CharacterStateHelper.is_colliding_with_gameplay_collision_box(arg_5_0.world, var_5_1, "filter_ladder_collision")
	local var_5_11 = arg_5_0.locomotion_extension:current_velocity().z
	local var_5_12 = PlayerUnitMovementSettings.get_movement_settings_table(var_5_1)
	local var_5_13 = arg_5_0.jump_off_height - var_5_12.ladder.leaving_ladder_height_below_get_of_node <= Vector3.z(Unit.world_position(var_5_1, 0))

	if not arg_5_0.position_lerp_timer then
		if var_5_13 and var_5_11 > 0 then
			local var_5_14 = arg_5_0.temp_params

			var_5_14.ladder_unit = arg_5_0.ladder_unit

			var_5_0:change_state("leaving_ladder_top", var_5_14)

			return
		elseif not var_5_9 then
			if var_5_13 and var_5_11 > 0 then
				local var_5_15 = arg_5_0.temp_params

				var_5_15.ladder_unit = arg_5_0.ladder_unit

				var_5_0:change_state("leaving_ladder_top", var_5_15)
			else
				var_5_0:change_state("falling")
			end

			return
		end
	end

	local var_5_16 = PlayerUnitMovementSettings.get_movement_settings_table(var_5_1)

	if CharacterStateHelper.has_move_input(var_5_2) then
		arg_5_0.movement_speed = math.min(1, arg_5_0.movement_speed + var_5_16.ladder.climb_move_acceleration_up * arg_5_3)
	else
		arg_5_0.movement_speed = math.max(0, arg_5_0.movement_speed - var_5_16.ladder.climb_move_acceleration_down * arg_5_3)
	end

	local var_5_17 = var_5_3:current_move_speed_multiplier()
	local var_5_18 = var_5_16.ladder.climb_speed * var_5_17 * var_5_16.ladder.player_ladder_speed_scale * arg_5_0.movement_speed
	local var_5_19 = Unit.local_rotation(arg_5_0.ladder_unit, 0)
	local var_5_20 = Unit.world_position(arg_5_0.ladder_unit, 0)
	local var_5_21 = Vector3.dot(-Quaternion.forward(var_5_19), POSITION_LOOKUP[var_5_1] - var_5_20) + var_5_16.ladder.climb_attach_to_ladder_position_in_ladder_space_y

	arg_5_0:_move_on_ladder(arg_5_0.first_person_extension, var_5_19, var_5_2, arg_5_0.locomotion_extension, var_5_1, var_5_18, var_5_21)

	local var_5_22 = CharacterStateHelper.time_in_ladder_move_animation(var_5_1, var_5_20.z)
	local var_5_23 = Unit.animation_find_variable(var_5_1, "climb_time")

	Unit.animation_set_variable(var_5_1, var_5_23, var_5_22)

	local var_5_24 = math.degrees_to_radians(var_5_16.ladder.look_horizontal_max_degrees)

	CharacterStateHelper.look_limited_rotation_freedom(var_5_2, var_5_5.viewport_name, arg_5_0.first_person_extension, var_5_1, var_5_19, var_5_24, var_5_24, var_5_3, arg_5_0.inventory_extension)
	arg_5_0:on_ladder_animation()

	arg_5_0.accumilated_distance = arg_5_0.accumilated_distance + math.abs(var_5_11) * arg_5_3

	if not var_5_5.bot_player and arg_5_0.accumilated_distance > 1 then
		arg_5_0.accumilated_distance = 0

		local var_5_25 = Unit.world_position(var_5_1, 0)
		local var_5_26, var_5_27 = WwiseUtils.make_position_auto_source(arg_5_0.world, var_5_25)

		WwiseWorld.trigger_event(var_5_27, arg_5_0.climb_sfx_event, var_5_26)
	end
end

PlayerCharacterStateClimbingLadder._move_on_ladder = function (arg_6_0, arg_6_1, arg_6_2, arg_6_3, arg_6_4, arg_6_5, arg_6_6, arg_6_7)
	local var_6_0 = CharacterStateHelper.get_square_movement_input(arg_6_3)
	local var_6_1 = Vector3.x(var_6_0)
	local var_6_2 = Vector3.y(var_6_0)

	Debug.text("x:%f, y:%f", var_6_1, var_6_2)

	local var_6_3 = PlayerUnitMovementSettings.get_movement_settings_table(arg_6_5)
	local var_6_4 = Unit.mover(arg_6_5)
	local var_6_5
	local var_6_6 = Mover.collides_down(var_6_4)

	if var_6_6 and var_6_2 <= 0 then
		var_6_5 = Vector3(var_6_1, var_6_2, 0)
	else
		local var_6_7 = arg_6_1:get_first_person_unit()
		local var_6_8 = Unit.local_rotation(var_6_7, 0)
		local var_6_9 = Quaternion.pitch(var_6_8) + var_6_3.ladder.climb_pitch_offset

		if var_6_6 and var_6_9 < 0 and var_6_2 > 0 then
			var_6_9 = 0
		end

		local var_6_10 = math.degrees_to_radians(var_6_3.ladder.climb_speed_lerp_interval)
		local var_6_11 = math.clamp(math.auto_lerp(-var_6_10, var_6_10, -1, 1, var_6_9), -1, 1)

		if var_6_2 > 0 or var_6_2 < 0 and not var_6_6 then
			local var_6_12

			if var_6_11 > 0 then
				var_6_12 = 1 - (1 - var_6_11) * (1 - var_6_11)
			else
				var_6_12 = -1 + (-1 - var_6_11) * (-1 - var_6_11)
			end

			var_6_2 = var_6_2 * var_6_12
		end

		if var_6_6 then
			if var_6_2 > 0 then
				var_6_5 = Vector3(var_6_1 * var_6_3.ladder.climb_horizontals_multiplier, 0, var_6_2)
			else
				var_6_5 = Vector3(var_6_1, var_6_2, 0)
			end
		else
			if Vector3.dot(Quaternion.forward(var_6_8), Quaternion.forward(arg_6_2)) < 0 then
				var_6_1 = -var_6_1
			end

			var_6_5 = Vector3(var_6_1 * var_6_3.ladder.climb_horizontals_multiplier, 0, var_6_2)
		end
	end

	local var_6_13 = Quaternion.rotate(arg_6_2, var_6_5)

	arg_6_4:set_wanted_velocity(var_6_13 * arg_6_6 + arg_6_7 * Quaternion.forward(arg_6_2) * 4)
end

PlayerCharacterStateClimbingLadder.on_ladder_animation = function (arg_7_0)
	local var_7_0 = arg_7_0.unit
	local var_7_1 = PlayerUnitMovementSettings.get_movement_settings_table(var_7_0)

	if arg_7_0.locomotion_extension:current_velocity().z == 0 then
		if arg_7_0.animation_state ~= "animation_idle" then
			arg_7_0.animation_state = "animation_idle"

			local var_7_2 = CharacterStateHelper.time_in_ladder_move_animation(var_7_0, arg_7_0.ladder_position_height)

			if var_7_2 <= var_7_1.ladder.threshold_for_idle_right then
				CharacterStateHelper.play_animation_event(var_7_0, "climb_idle_right_ladder")
			elseif var_7_2 <= var_7_1.ladder.threshold_for_idle_middle then
				CharacterStateHelper.play_animation_event(var_7_0, "climb_idle_mid_ladder")
			elseif var_7_2 <= var_7_1.ladder.threshold_for_idle_left then
				CharacterStateHelper.play_animation_event(var_7_0, "climb_idle_left_ladder")
			else
				CharacterStateHelper.play_animation_event(var_7_0, "climb_idle_right_ladder")
			end
		end
	elseif arg_7_0.animation_state ~= "animation_climbing" then
		arg_7_0.animation_state = "animation_climbing"

		CharacterStateHelper.play_animation_event(var_7_0, "climb_move_ladder")

		arg_7_0.currently_playing_move_animation = true
	end
end
