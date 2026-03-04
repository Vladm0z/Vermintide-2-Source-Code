-- chunkname: @scripts/unit_extensions/default_player_unit/states/player_character_state_pounced_down.lua

PlayerCharacterStatePouncedDown = class(PlayerCharacterStatePouncedDown, PlayerCharacterState)

PlayerCharacterStatePouncedDown.init = function (arg_1_0, arg_1_1)
	PlayerCharacterState.init(arg_1_0, arg_1_1, "pounced_down")

	local var_1_0 = arg_1_1
end

local var_0_0 = 1.2

PlayerCharacterStatePouncedDown.on_enter = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5, arg_2_6, arg_2_7)
	CharacterStateHelper.stop_weapon_actions(arg_2_0.inventory_extension, "pounced")
	CharacterStateHelper.stop_career_abilities(arg_2_0.career_extension, "pounced")

	local var_2_0 = arg_2_0.first_person_extension
	local var_2_1 = arg_2_0.status_extension

	CharacterStateHelper.change_camera_state(arg_2_0.player, "follow_third_person")
	var_2_0:set_first_person_mode(false)
	var_2_0:set_wanted_player_height("knocked_down", arg_2_5)

	local var_2_2, var_2_3 = var_2_1:is_pounced_down()
	local var_2_4 = true

	CharacterStateHelper.show_inventory_3p(arg_2_1, false, var_2_4, arg_2_0.is_server, arg_2_0.inventory_extension)
	CharacterStateHelper.play_animation_event(var_2_3, "jump_attack")
	CharacterStateHelper.play_animation_event(arg_2_1, "jump_attack")
	arg_2_0.inventory_extension:check_and_drop_pickups("pounced_down")
end

PlayerCharacterStatePouncedDown.on_exit = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5, arg_3_6)
	local var_3_0 = arg_3_0.first_person_extension

	arg_3_0.liberated = nil
	arg_3_0.liberation_time = nil

	local var_3_1 = Managers.state.network

	if var_3_1:game() and arg_3_6 then
		local var_3_2 = Managers.state.unit_storage:go_id(arg_3_1)

		var_3_1.network_transmit:send_rpc_server("rpc_disable_locomotion", var_3_2, false, NetworkLookup.movement_funcs.none)
	end

	if arg_3_6 ~= "knocked_down" then
		CharacterStateHelper.change_camera_state(arg_3_0.player, "follow")
		arg_3_0.first_person_extension:toggle_visibility(CameraTransitionSettings.perspective_transition_time)
		var_3_0:set_wanted_player_height("stand", arg_3_5)

		local var_3_3 = false

		CharacterStateHelper.show_inventory_3p(arg_3_1, true, var_3_3, arg_3_0.is_server, arg_3_0.inventory_extension)
	end

	local var_3_4 = arg_3_0.status_extension

	if var_3_4:is_blocking() then
		if not LEVEL_EDITOR_TEST and Managers.state.network:game() then
			local var_3_5 = Managers.state.unit_storage:go_id(arg_3_1)

			if arg_3_0.is_server then
				Managers.state.network.network_transmit:send_rpc_clients("rpc_set_blocking", var_3_5, false)
			else
				Managers.state.network.network_transmit:send_rpc_server("rpc_set_blocking", var_3_5, false)
			end
		end

		var_3_4:set_blocking(false)
	end
end

PlayerCharacterStatePouncedDown.set_free = function (arg_4_0, arg_4_1, arg_4_2)
	arg_4_0.liberated = true
	arg_4_0.liberation_time = arg_4_1 + var_0_0

	CharacterStateHelper.play_animation_event(arg_4_2, "jump_attack_stand_up")

	local var_4_0 = arg_4_0.status_extension

	if not LEVEL_EDITOR_TEST and Managers.state.network:game() then
		local var_4_1 = Managers.state.unit_storage:go_id(arg_4_2)

		if arg_4_0.is_server then
			Managers.state.network.network_transmit:send_rpc_clients("rpc_set_blocking", var_4_1, true)
		else
			Managers.state.network.network_transmit:send_rpc_server("rpc_set_blocking", var_4_1, true)
		end
	end

	var_4_0:set_blocking(true)
end

PlayerCharacterStatePouncedDown.update = function (arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4, arg_5_5)
	local var_5_0 = arg_5_0.csm
	local var_5_1 = arg_5_0.unit
	local var_5_2 = arg_5_0.player.input_source
	local var_5_3 = arg_5_0.status_extension
	local var_5_4 = arg_5_0.input_extension

	if CharacterStateHelper.is_dead(var_5_3) then
		var_5_0:change_state("dead")

		return
	end

	if CharacterStateHelper.is_knocked_down(var_5_3) then
		arg_5_0.temp_params.already_in_ko_anim = true

		var_5_0:change_state("knocked_down", arg_5_0.temp_params)

		return
	end

	if arg_5_0.liberated then
		if arg_5_5 > arg_5_0.liberation_time then
			var_5_0:change_state("standing")
		end

		return
	end

	if not CharacterStateHelper.is_pounced_down(var_5_3) then
		arg_5_0:set_free(arg_5_5, var_5_1)
	end

	arg_5_0.locomotion_extension:set_disable_rotation_update()
	CharacterStateHelper.look(var_5_4, arg_5_0.player.viewport_name, arg_5_0.first_person_extension, var_5_3, arg_5_0.inventory_extension)
end
