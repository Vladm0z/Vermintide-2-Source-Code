-- chunkname: @scripts/unit_extensions/default_player_unit/states/player_character_state_interacting.lua

PlayerCharacterStateInteracting = class(PlayerCharacterStateInteracting, PlayerCharacterState)

PlayerCharacterStateInteracting.init = function (arg_1_0, arg_1_1)
	PlayerCharacterState.init(arg_1_0, arg_1_1, "interacting")
end

PlayerCharacterStateInteracting.on_enter = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5, arg_2_6, arg_2_7)
	arg_2_0.has_started_interacting = false
	arg_2_0.swap_to_3p = arg_2_7.swap_to_3p
	arg_2_0.allow_rotation_update = arg_2_7.allow_rotation_update

	local var_2_0 = arg_2_0.locomotion_extension

	var_2_0:set_wanted_velocity(Vector3.zero())

	if not var_2_0:is_on_ground() then
		arg_2_0.status_extension:set_falling_height()
	end

	local var_2_1 = arg_2_0.first_person_extension

	if arg_2_0.swap_to_3p then
		CharacterStateHelper.change_camera_state(arg_2_0.player, "follow_third_person")
		var_2_1:set_first_person_mode(false)
	else
		CharacterStateHelper.play_animation_event_first_person(var_2_1, "idle")
	end

	if not arg_2_7.show_weapons then
		local var_2_2 = true

		CharacterStateHelper.show_inventory_3p(arg_2_1, false, var_2_2, arg_2_0.is_server, arg_2_0.inventory_extension)
	end

	arg_2_0.deactivate_block_on_exit = false

	if arg_2_7.activate_block then
		arg_2_0.activate_block = arg_2_7.activate_block

		local var_2_3 = arg_2_0.status_extension

		arg_2_0.deactivate_block_on_exit = not var_2_3:is_blocking()

		if not LEVEL_EDITOR_TEST and Managers.state.network:game() then
			local var_2_4 = Managers.state.unit_storage:go_id(arg_2_1)

			if arg_2_0.is_server then
				Managers.state.network.network_transmit:send_rpc_clients("rpc_set_blocking", var_2_4, true)
			else
				Managers.state.network.network_transmit:send_rpc_server("rpc_set_blocking", var_2_4, true)
			end
		end

		var_2_3:set_blocking(true)
	end
end

PlayerCharacterStateInteracting.on_exit = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5, arg_3_6)
	arg_3_0.activate_block = nil

	if arg_3_0.swap_to_3p then
		CharacterStateHelper.change_camera_state(arg_3_0.player, "follow")

		local var_3_0 = true

		CharacterStateHelper.show_inventory_3p(arg_3_1, true, var_3_0, arg_3_0.is_server, arg_3_0.inventory_extension)
		arg_3_0.first_person_extension:toggle_visibility(CameraTransitionSettings.perspective_transition_time)
	else
		local var_3_1 = false

		CharacterStateHelper.show_inventory_3p(arg_3_1, true, var_3_1, arg_3_0.is_server, arg_3_0.inventory_extension)
	end

	local var_3_2 = arg_3_0.status_extension

	if arg_3_0.deactivate_block_on_exit then
		if not LEVEL_EDITOR_TEST and Managers.state.network:game() then
			local var_3_3 = Managers.state.unit_storage:go_id(arg_3_1)

			if arg_3_0.is_server then
				Managers.state.network.network_transmit:send_rpc_clients("rpc_set_blocking", var_3_3, false)
			else
				Managers.state.network.network_transmit:send_rpc_server("rpc_set_blocking", var_3_3, false)
			end
		end

		var_3_2:set_blocking(false)
	end
end

PlayerCharacterStateInteracting.update = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4, arg_4_5)
	local var_4_0 = arg_4_0.csm
	local var_4_1 = arg_4_0.input_extension
	local var_4_2 = arg_4_0.interactor_extension
	local var_4_3 = arg_4_0.status_extension
	local var_4_4 = PlayerUnitMovementSettings.get_movement_settings_table(arg_4_1)

	if arg_4_0.activate_block then
		if not var_4_3:is_blocking() and not LEVEL_EDITOR_TEST and Managers.state.network:game() then
			local var_4_5 = Managers.state.unit_storage:go_id(arg_4_1)

			if arg_4_0.is_server then
				Managers.state.network.network_transmit:send_rpc_clients("rpc_set_blocking", var_4_5, true)
			else
				Managers.state.network.network_transmit:send_rpc_server("rpc_set_blocking", var_4_5, true)
			end
		end

		var_4_3:set_blocking(true)
	end

	if CharacterStateHelper.do_common_state_transitions(var_4_3, var_4_0) then
		return
	end

	if CharacterStateHelper.is_using_transport(var_4_3) then
		var_4_0:change_state("using_transport")

		return
	end

	local var_4_6 = arg_4_0.world

	if CharacterStateHelper.is_ledge_hanging(var_4_6, arg_4_1, arg_4_0.temp_params) then
		var_4_0:change_state("ledge_hanging", arg_4_0.temp_params)

		return
	end

	if not var_4_0.state_next and var_4_3.do_leap then
		var_4_0:change_state("leaping")

		return
	end

	if not CharacterStateHelper.is_interacting(var_4_2) then
		var_4_0:change_state("standing")

		return
	end

	if not CharacterStateHelper.is_waiting_for_interaction_approval(var_4_2) then
		if not arg_4_0.has_started_interacting then
			arg_4_0.has_started_interacting = true
		end

		if not CharacterStateHelper.interact(var_4_1, var_4_2) then
			var_4_0:change_state("standing")

			return
		end
	end

	if CharacterStateHelper.is_pushed(var_4_3) then
		var_4_3:set_pushed(false)

		local var_4_7 = var_4_4.stun_settings.pushed

		var_4_7.hit_react_type = var_4_3:hit_react_type() .. "_push"

		var_4_0:change_state("stunned", var_4_7)
		var_4_2:abort_interaction()

		return
	end

	if CharacterStateHelper.is_block_broken(var_4_3) then
		var_4_3:set_block_broken(false)

		local var_4_8 = var_4_4.stun_settings.parry_broken

		var_4_8.hit_react_type = "medium_push"

		var_4_0:change_state("stunned", var_4_8)
		var_4_2:abort_interaction()

		return
	end

	if not arg_4_0.allow_rotation_update then
		arg_4_0.locomotion_extension:set_disable_rotation_update()
	end

	CharacterStateHelper.look(var_4_1, arg_4_0.player.viewport_name, arg_4_0.first_person_extension, var_4_3, arg_4_0.inventory_extension)
end
