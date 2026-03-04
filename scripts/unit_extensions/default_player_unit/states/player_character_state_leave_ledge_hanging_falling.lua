-- chunkname: @scripts/unit_extensions/default_player_unit/states/player_character_state_leave_ledge_hanging_falling.lua

PlayerCharacterStateLeaveLedgeHangingFalling = class(PlayerCharacterStateLeaveLedgeHangingFalling, PlayerCharacterState)

PlayerCharacterStateLeaveLedgeHangingFalling.init = function (arg_1_0, arg_1_1)
	PlayerCharacterState.init(arg_1_0, arg_1_1, "leave_ledge_hanging_falling")

	local var_1_0 = arg_1_1

	arg_1_0.is_server = Managers.player.is_server
end

PlayerCharacterStateLeaveLedgeHangingFalling.on_enter_animation = function (arg_2_0)
	CharacterStateHelper.play_animation_event(arg_2_0.unit, "jump_idle")
end

PlayerCharacterStateLeaveLedgeHangingFalling.on_enter = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5, arg_3_6, arg_3_7)
	local var_3_0 = arg_3_0.unit
	local var_3_1 = arg_3_7.ledge_unit

	arg_3_0.ledge_unit = var_3_1

	local var_3_2 = PlayerUnitMovementSettings.get_movement_settings_table(var_3_0)

	arg_3_0.finish_time = arg_3_5 + var_3_2.ledge_hanging.falling_kill_timer

	local var_3_3 = Unit.node(var_3_1, "g_gameplay_ledge_finger_box")
	local var_3_4 = Unit.world_rotation(var_3_1, var_3_3)
	local var_3_5 = Quaternion.forward(var_3_4)
	local var_3_6 = Unit.local_position(var_3_0, 0) - var_3_5 * var_3_2.ledge_hanging.leaving_falling_forward_push_constant

	arg_3_0.locomotion_extension:enable_script_driven_movement()
	arg_3_0.locomotion_extension:teleport_to(var_3_6)
	arg_3_0:on_enter_animation()
end

PlayerCharacterStateLeaveLedgeHangingFalling.on_exit = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4, arg_4_5, arg_4_6)
	if arg_4_6 and arg_4_6 ~= "falling" and Managers.state.network:game() then
		CharacterStateHelper.play_animation_event(arg_4_1, "land_still")
		CharacterStateHelper.play_animation_event(arg_4_1, "to_onground")
	end
end

PlayerCharacterStateLeaveLedgeHangingFalling.update = function (arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4, arg_5_5)
	local var_5_0 = arg_5_0.csm
	local var_5_1 = arg_5_0.unit
	local var_5_2 = arg_5_0.input_extension
	local var_5_3 = arg_5_0.status_extension
	local var_5_4 = arg_5_0.locomotion_extension
	local var_5_5 = PlayerUnitMovementSettings.get_movement_settings_table(var_5_1)

	if CharacterStateHelper.is_dead(var_5_3) then
		var_5_0:change_state("dead")

		return
	end

	if CharacterStateHelper.is_pounced_down(var_5_3) then
		var_5_0:change_state("pounced_down")

		return
	end

	local var_5_6, var_5_7 = CharacterStateHelper.is_catapulted(var_5_3)

	if var_5_6 then
		local var_5_8 = {
			sound_event = "Play_hit_by_ratogre",
			direction = var_5_7
		}

		var_5_0:change_state("catapulted", var_5_8)

		return
	end

	if arg_5_5 >= arg_5_0.finish_time then
		if script_data.ledge_hanging_fall_and_die_turned_off then
			var_5_0:change_state("falling")
		else
			local var_5_9 = arg_5_0.unit_storage:go_id(var_5_1)

			if arg_5_0.is_server or LEVEL_EDITOR_TEST then
				Managers.state.entity:system("health_system"):suicide(var_5_1)
				var_5_0:change_state("dead")
			else
				arg_5_0.network_transmit:send_rpc_server("rpc_suicide", var_5_9)
			end
		end

		return
	end

	if arg_5_0.locomotion_extension:is_colliding_down() then
		var_5_0:change_state("walking")

		return
	end

	arg_5_0.locomotion_extension:set_forced_velocity(Vector3(0, 0, -3))
	arg_5_0.locomotion_extension:set_disable_rotation_update()
	CharacterStateHelper.look(var_5_2, arg_5_0.player.viewport_name, arg_5_0.first_person_extension, var_5_3, arg_5_0.inventory_extension)
end
