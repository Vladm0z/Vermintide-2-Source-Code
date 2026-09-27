-- chunkname: @scripts/unit_extensions/default_player_unit/states/player_character_state_using_transport.lua

PlayerCharacterStateUsingTransport = class(PlayerCharacterStateUsingTransport, PlayerCharacterState)

PlayerCharacterStateUsingTransport.init = function (arg_1_0, arg_1_1)
	-- function 1
	PlayerCharacterState.init(arg_1_0, arg_1_1, "using_transport")

	local var_1_0 = arg_1_1
end

PlayerCharacterStateUsingTransport.on_enter = function (self, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5, arg_2_6, arg_2_7)
	-- function 2
	local first_person_extension = self.first_person_extension

	table.clear(self.temp_params)
	CharacterStateHelper.play_animation_event(arg_2_1, "idle")
	CharacterStateHelper.play_animation_event_first_person(first_person_extension, "idle")
end

PlayerCharacterStateUsingTransport.on_exit = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5, arg_3_6)
	-- function 3
	return
end

PlayerCharacterStateUsingTransport.update = function (self, arg_4_1, arg_4_2, arg_4_3, arg_4_4, arg_4_5)
	-- function 4
	local csm = self.csm
	local unit = self.unit
	local input_extension = self.input_extension
	local status_extension = self.status_extension
	local inventory_extension = self.inventory_extension
	local first_person_extension = self.first_person_extension

	if not CharacterStateHelper.do_common_state_transitions(status_extension, csm) then
		return
	end

	if not CharacterStateHelper.is_using_transport(status_extension) then
		csm:change_state("standing")

		return
	end

	local interactor_extension = self.interactor_extension

	if not CharacterStateHelper.is_starting_interaction(input_extension, interactor_extension) then
		local interaction_action_names, var_4_8 = InteractionHelper.interaction_action_names(unit)

		interactor_extension:start_interaction(var_4_8)

		if not interactor_extension:allow_movement_during_interaction() then
			return
		end

		local interaction_config = interactor_extension:interaction_config()
		local temp_params = self.temp_params

		temp_params.swap_to_3p = interaction_config.swap_to_3p
		temp_params.show_weapons = interaction_config.show_weapons
		temp_params.activate_block = interaction_config.activate_block
		temp_params.allow_rotation_update = interaction_config.allow_rotation_update

		csm:change_state("interacting", temp_params)

		return
	end

	if not CharacterStateHelper.is_interacting(interactor_extension) then
		if not interactor_extension:allow_movement_during_interaction() then
			return
		end

		local interaction_config_2 = interactor_extension:interaction_config()
		local temp_params_2 = self.temp_params

		temp_params_2.swap_to_3p = interaction_config_2.swap_to_3p
		temp_params_2.show_weapons = interaction_config_2.show_weapons
		temp_params_2.activate_block = interaction_config_2.activate_block
		temp_params_2.allow_rotation_update = interaction_config_2.allow_rotation_update

		csm:change_state("interacting", temp_params_2)

		return
	end

	CharacterStateHelper.look(input_extension, self.player.viewport_name, self.first_person_extension, status_extension, self.inventory_extension)
	CharacterStateHelper.update_weapon_actions(arg_4_5, unit, input_extension, inventory_extension, self.health_extension)
end
