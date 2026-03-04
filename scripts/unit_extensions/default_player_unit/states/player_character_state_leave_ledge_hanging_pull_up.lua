-- chunkname: @scripts/unit_extensions/default_player_unit/states/player_character_state_leave_ledge_hanging_pull_up.lua

PlayerCharacterStateLeaveLedgeHangingPullUp = class(PlayerCharacterStateLeaveLedgeHangingPullUp, PlayerCharacterState)

PlayerCharacterStateLeaveLedgeHangingPullUp.init = function (arg_1_0, arg_1_1)
	PlayerCharacterState.init(arg_1_0, arg_1_1, "leave_ledge_hanging_pull_up")

	local var_1_0 = arg_1_1

	arg_1_0.is_server = Managers.player.is_server
	arg_1_0.end_position = Vector3Box()
end

PlayerCharacterStateLeaveLedgeHangingPullUp.on_enter_animation_event = function (arg_2_0)
	local var_2_0 = arg_2_0.unit

	CharacterStateHelper.play_animation_event(var_2_0, "hanging_exit")
end

PlayerCharacterStateLeaveLedgeHangingPullUp.on_enter = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5, arg_3_6, arg_3_7)
	local var_3_0 = arg_3_0.unit
	local var_3_1 = arg_3_0.input_extension
	local var_3_2 = arg_3_0.first_person_extension
	local var_3_3 = arg_3_7.ledge_unit

	arg_3_0.start_rotation_box, arg_3_0.ledge_unit = arg_3_7.start_rotation_box, var_3_3

	arg_3_0:calculate_end_position()
	arg_3_0.locomotion_extension:enable_animation_driven_movement_with_rotation_no_mover()
	arg_3_0:on_enter_animation_event()

	arg_3_0.finish_time = arg_3_5 + PlayerUnitMovementSettings.get_movement_settings_table(var_3_0).ledge_hanging.leaving_animation_time
end

PlayerCharacterStateLeaveLedgeHangingPullUp.on_exit = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4, arg_4_5, arg_4_6)
	local var_4_0 = arg_4_0.status_extension

	arg_4_0.start_rotation_box = nil

	if arg_4_6 then
		arg_4_0.locomotion_extension:enable_script_driven_movement()
		arg_4_0.locomotion_extension:set_forced_velocity(nil)
		arg_4_0.locomotion_extension:set_wanted_velocity(Vector3:zero())
		arg_4_0.locomotion_extension:teleport_to(arg_4_0.end_position:unbox())
	end

	if Managers.state.network:game() then
		StatusUtils.set_pulled_up_network(arg_4_1, false)
		CharacterStateHelper.set_is_on_ledge(arg_4_0.ledge_unit, arg_4_1, false, arg_4_0.is_server, arg_4_0.status_extension)
	end

	CharacterStateHelper.change_camera_state(arg_4_0.player, "follow")
	arg_4_0.first_person_extension:toggle_visibility(CameraTransitionSettings.perspective_transition_time)

	var_4_0.start_climb_rotation = nil

	local var_4_1 = false

	CharacterStateHelper.show_inventory_3p(arg_4_1, true, var_4_1, arg_4_0.is_server, arg_4_0.inventory_extension)
end

PlayerCharacterStateLeaveLedgeHangingPullUp.update = function (arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4, arg_5_5)
	local var_5_0 = arg_5_0.csm
	local var_5_1 = arg_5_0.unit
	local var_5_2 = arg_5_0.input_extension
	local var_5_3 = arg_5_0.status_extension
	local var_5_4 = arg_5_0.locomotion_extension

	if CharacterStateHelper.is_dead(var_5_3) then
		var_5_0:change_state("dead")

		return
	end

	if CharacterStateHelper.is_knocked_down(var_5_3) then
		var_5_0:change_state("knocked_down")

		return
	end

	if CharacterStateHelper.is_pounced_down(var_5_3) then
		var_5_0:change_state("pounced_down")

		return
	end

	local var_5_5, var_5_6 = CharacterStateHelper.is_catapulted(var_5_3)

	if var_5_5 then
		local var_5_7 = {
			sound_event = "Play_hit_by_ratogre",
			direction = var_5_6
		}

		var_5_0:change_state("catapulted", var_5_7)

		return
	end

	if arg_5_5 > arg_5_0.finish_time then
		var_5_0:change_state("walking")

		return
	end

	if var_5_3.start_climb_rotation then
		local var_5_8 = arg_5_0.start_rotation_box:unbox()
		local var_5_9 = Unit.local_rotation(var_5_1, 0)
		local var_5_10 = Quaternion.lerp(var_5_9, var_5_8, math.min(arg_5_3 * 2, 1))

		Unit.set_local_rotation(var_5_1, 0, var_5_10)
	end

	arg_5_0.locomotion_extension:set_disable_rotation_update()
	CharacterStateHelper.look(var_5_2, arg_5_0.player.viewport_name, arg_5_0.first_person_extension, var_5_3, arg_5_0.inventory_extension)
end

PlayerCharacterStateLeaveLedgeHangingPullUp.calculate_end_position = function (arg_6_0)
	local var_6_0 = arg_6_0.unit
	local var_6_1 = arg_6_0.ledge_unit
	local var_6_2 = PlayerUnitMovementSettings.get_movement_settings_table(var_6_0)
	local var_6_3 = Unit.node(var_6_1, "g_gameplay_ledge_finger_box")
	local var_6_4 = Unit.world_position(var_6_1, var_6_3)
	local var_6_5 = Unit.world_rotation(var_6_1, var_6_3)
	local var_6_6 = Unit.local_position(var_6_0, 0)
	local var_6_7 = Quaternion.right(var_6_5)
	local var_6_8 = var_6_6 - var_6_4
	local var_6_9 = Vector3.dot(var_6_7, var_6_8)
	local var_6_10 = Unit.node(var_6_1, "g_gameplay_ledge_respawn_box")
	local var_6_11 = Unit.world_position(var_6_1, var_6_10)
	local var_6_12 = Unit.world_rotation(var_6_1, var_6_10)
	local var_6_13 = var_6_11 + Quaternion.right(var_6_12) * var_6_9
	local var_6_14 = ScriptUnit.extension(var_6_0, "whereabouts_system"):get_hang_ledge_spawn_position()
	local var_6_15 = Vector3.distance(var_6_13, var_6_14) < 4

	if var_6_14 and var_6_15 then
		var_6_13 = var_6_14
	end

	arg_6_0.end_position:store(var_6_13)
end
