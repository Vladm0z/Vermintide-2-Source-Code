-- chunkname: @scripts/unit_extensions/default_player_unit/enemy_states/enemy_character_state_interacting.lua

EnemyCharacterStateInteracting = class(EnemyCharacterStateInteracting, EnemyCharacterState)

EnemyCharacterStateInteracting.init = function (arg_1_0, arg_1_1)
	EnemyCharacterState.init(arg_1_0, arg_1_1, "interacting")
end

EnemyCharacterStateInteracting.on_enter = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5, arg_2_6, arg_2_7)
	arg_2_0.has_started_interacting = false
	arg_2_0.swap_to_3p = arg_2_7.swap_to_3p

	local var_2_0 = arg_2_0._locomotion_extension

	arg_2_0._locomotion_extension:set_wanted_velocity(Vector3.zero())

	if not arg_2_0._locomotion_extension:is_on_ground() then
		arg_2_0._status_extension:set_falling_height()
	end

	local var_2_1 = arg_2_0._first_person_extension

	if arg_2_0.swap_to_3p then
		CharacterStateHelper.change_camera_state(arg_2_0._player, "follow_third_person")
		var_2_1:set_first_person_mode(false)
	else
		CharacterStateHelper.play_animation_event_first_person(var_2_1, "idle")
	end

	if not arg_2_7.show_weapons then
		local var_2_2 = true

		CharacterStateHelper.show_inventory_3p(arg_2_1, false, var_2_2, arg_2_0._is_server, arg_2_0._inventory_extension)
	end

	arg_2_0.deactivate_block_on_exit = false

	if arg_2_7.activate_block then
		arg_2_0.activate_block = arg_2_7.activate_block

		local var_2_3 = arg_2_0._status_extension

		arg_2_0.deactivate_block_on_exit = not var_2_3:is_blocking()

		if not LEVEL_EDITOR_TEST and Managers.state.network:game() then
			local var_2_4 = Managers.state.unit_storage:go_id(arg_2_1)

			if arg_2_0._is_server then
				Managers.state.network.network_transmit:send_rpc_clients("rpc_set_blocking", var_2_4, true)
			else
				Managers.state.network.network_transmit:send_rpc_server("rpc_set_blocking", var_2_4, true)
			end
		end

		var_2_3:set_blocking(true)
	end
end

EnemyCharacterStateInteracting.on_exit = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5, arg_3_6)
	arg_3_0.activate_block = nil

	if arg_3_0.swap_to_3p then
		CharacterStateHelper.change_camera_state(arg_3_0._player, "follow")

		local var_3_0 = true

		CharacterStateHelper.show_inventory_3p(arg_3_1, true, var_3_0, arg_3_0._is_server, arg_3_0._inventory_extension)
		arg_3_0._first_person_extension:toggle_visibility(CameraTransitionSettings.perspective_transition_time)
	else
		local var_3_1 = false

		CharacterStateHelper.show_inventory_3p(arg_3_1, true, var_3_1, arg_3_0._is_server, arg_3_0._inventory_extension)
	end

	local var_3_2 = arg_3_0._status_extension

	if arg_3_0.deactivate_block_on_exit then
		if not LEVEL_EDITOR_TEST and Managers.state.network:game() then
			local var_3_3 = Managers.state.unit_storage:go_id(arg_3_1)

			if arg_3_0._is_server then
				Managers.state.network.network_transmit:send_rpc_clients("rpc_set_blocking", var_3_3, false)
			else
				Managers.state.network.network_transmit:send_rpc_server("rpc_set_blocking", var_3_3, false)
			end
		end

		var_3_2:set_blocking(false)
	end
end

EnemyCharacterStateInteracting.update = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4, arg_4_5)
	local var_4_0 = arg_4_0._csm
	local var_4_1 = arg_4_0._input_extension
	local var_4_2 = arg_4_0._interactor_extension
	local var_4_3 = arg_4_0._status_extension
	local var_4_4 = PlayerUnitMovementSettings.get_movement_settings_table(arg_4_1)

	if arg_4_0.activate_block then
		if not var_4_3:is_blocking() and not LEVEL_EDITOR_TEST and Managers.state.network:game() then
			local var_4_5 = Managers.state.unit_storage:go_id(arg_4_1)

			if arg_4_0._is_server then
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

	if not var_4_0.state_next and var_4_3.do_leap then
		var_4_0:change_state("leaping")

		return
	end

	if not var_4_0.state_next and var_4_3.do_pounce then
		var_4_0:change_state("pouncing")

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

		local var_4_6 = var_4_4.stun_settings.pushed

		var_4_6.hit_react_type = var_4_3:hit_react_type() .. "_push"

		var_4_0:change_state("stunned", var_4_6)
		var_4_2:abort_interaction()

		return
	end

	if CharacterStateHelper.is_block_broken(var_4_3) then
		var_4_3:set_block_broken(false)

		local var_4_7 = var_4_4.stun_settings.parry_broken

		var_4_7.hit_react_type = "medium_push"

		var_4_0:change_state("stunned", var_4_7)
		var_4_2:abort_interaction()

		return
	end

	arg_4_0._locomotion_extension:set_disable_rotation_update()
	CharacterStateHelper.look(var_4_1, arg_4_0._player.viewport_name, arg_4_0._first_person_extension, var_4_3, arg_4_0._inventory_extension)

	local var_4_8 = var_4_3:should_climb()

	if not var_4_0.state_next and var_4_8 then
		local var_4_9 = ScriptUnit.extension(arg_4_1, "interactor_system"):interactable_unit()
		local var_4_10 = Managers.state.entity:system("nav_graph_system").level_jumps[var_4_9]

		arg_4_0._temp_params.jump_data = var_4_10

		local var_4_11 = var_4_10.jump_object_data.smart_object_type

		if var_4_11 == "ledges" or var_4_11 == "ledges_with_fence" then
			var_4_0:change_state("climbing", arg_4_0._temp_params)
			arg_4_0._first_person_extension:change_state("climbing")
		elseif var_4_11 == "jumps" then
			var_4_0:change_state("jump_across", arg_4_0._temp_params)
			arg_4_0._first_person_extension:change_state("jump_across")
		end

		return
	end

	local var_4_12 = var_4_3:should_tunnel()

	if not var_4_0.state_next and var_4_12 then
		var_4_0:change_state("tunneling")
	end

	local var_4_13 = var_4_3:should_spawn()

	if not var_4_0.state_next and var_4_13 then
		var_4_0:change_state("spawning")
	end
end
