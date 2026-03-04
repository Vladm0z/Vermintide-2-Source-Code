-- chunkname: @scripts/unit_extensions/default_player_unit/states/player_character_state_using_transport.lua

PlayerCharacterStateUsingTransport = class(PlayerCharacterStateUsingTransport, PlayerCharacterState)

PlayerCharacterStateUsingTransport.init = function (arg_1_0, arg_1_1)
	PlayerCharacterState.init(arg_1_0, arg_1_1, "using_transport")

	local var_1_0 = arg_1_1
end

PlayerCharacterStateUsingTransport.on_enter = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5, arg_2_6, arg_2_7)
	local var_2_0 = arg_2_0.first_person_extension

	table.clear(arg_2_0.temp_params)
	CharacterStateHelper.play_animation_event(arg_2_1, "idle")
	CharacterStateHelper.play_animation_event_first_person(var_2_0, "idle")
end

PlayerCharacterStateUsingTransport.on_exit = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5, arg_3_6)
	return
end

PlayerCharacterStateUsingTransport.update = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4, arg_4_5)
	local var_4_0 = arg_4_0.csm
	local var_4_1 = arg_4_0.unit
	local var_4_2 = arg_4_0.input_extension
	local var_4_3 = arg_4_0.status_extension
	local var_4_4 = arg_4_0.inventory_extension
	local var_4_5 = arg_4_0.first_person_extension

	if CharacterStateHelper.do_common_state_transitions(var_4_3, var_4_0) then
		return
	end

	if not CharacterStateHelper.is_using_transport(var_4_3) then
		var_4_0:change_state("standing")

		return
	end

	local var_4_6 = arg_4_0.interactor_extension

	if CharacterStateHelper.is_starting_interaction(var_4_2, var_4_6) then
		local var_4_7, var_4_8 = InteractionHelper.interaction_action_names(var_4_1)

		var_4_6:start_interaction(var_4_8)

		if var_4_6:allow_movement_during_interaction() then
			return
		end

		local var_4_9 = var_4_6:interaction_config()
		local var_4_10 = arg_4_0.temp_params

		var_4_10.swap_to_3p = var_4_9.swap_to_3p
		var_4_10.show_weapons = var_4_9.show_weapons
		var_4_10.activate_block = var_4_9.activate_block
		var_4_10.allow_rotation_update = var_4_9.allow_rotation_update

		var_4_0:change_state("interacting", var_4_10)

		return
	end

	if CharacterStateHelper.is_interacting(var_4_6) then
		if var_4_6:allow_movement_during_interaction() then
			return
		end

		local var_4_11 = var_4_6:interaction_config()
		local var_4_12 = arg_4_0.temp_params

		var_4_12.swap_to_3p = var_4_11.swap_to_3p
		var_4_12.show_weapons = var_4_11.show_weapons
		var_4_12.activate_block = var_4_11.activate_block
		var_4_12.allow_rotation_update = var_4_11.allow_rotation_update

		var_4_0:change_state("interacting", var_4_12)

		return
	end

	CharacterStateHelper.look(var_4_2, arg_4_0.player.viewport_name, arg_4_0.first_person_extension, var_4_3, arg_4_0.inventory_extension)
	CharacterStateHelper.update_weapon_actions(arg_4_5, var_4_1, var_4_2, var_4_4, arg_4_0.health_extension)
end
