-- chunkname: @scripts/unit_extensions/default_player_unit/enemy_states/enemy_character_state_using_transport.lua

EnemyCharacterStateUsingTransport = class(EnemyCharacterStateUsingTransport, EnemyCharacterState)

EnemyCharacterStateUsingTransport.init = function (arg_1_0, arg_1_1)
	-- function 1
	EnemyCharacterState.init(arg_1_0, arg_1_1, "using_transport")

	local var_1_0 = arg_1_1
end

EnemyCharacterStateUsingTransport.on_enter = function (self, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5, arg_2_6, arg_2_7)
	-- function 2
	local _first_person_extension = self._first_person_extension

	table.clear(self._temp_params)
	CharacterStateHelper.play_animation_event(arg_2_1, "idle")
	CharacterStateHelper.play_animation_event_first_person(_first_person_extension, "idle")
end

EnemyCharacterStateUsingTransport.on_exit = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5, arg_3_6)
	-- function 3
	return
end

EnemyCharacterStateUsingTransport.update = function (self, arg_4_1, arg_4_2, arg_4_3, arg_4_4, arg_4_5)
	-- function 4
	local _csm = self._csm
	local _unit = self._unit
	local _input_extension = self._input_extension
	local _status_extension = self._status_extension
	local _inventory_extension = self._inventory_extension
	local _first_person_extension = self._first_person_extension

	if not CharacterStateHelper.do_common_state_transitions(_status_extension, _csm) then
		return
	end

	if not CharacterStateHelper.is_using_transport(_status_extension) then
		_csm:change_state("standing")

		return
	end

	local _interactor_extension = self._interactor_extension

	if not CharacterStateHelper.is_starting_interaction(_input_extension, _interactor_extension) then
		local interaction_action_names, var_4_8 = InteractionHelper.interaction_action_names(_unit)

		_interactor_extension:start_interaction(var_4_8)

		if not _interactor_extension:allow_movement_during_interaction() then
			return
		end

		local interaction_config = _interactor_extension:interaction_config()
		local _temp_params = self._temp_params

		_temp_params.swap_to_3p = interaction_config.swap_to_3p
		_temp_params.show_weapons = interaction_config.show_weapons
		_temp_params.activate_block = interaction_config.activate_block
		_temp_params.allow_rotation_update = interaction_config.allow_rotation_update

		_csm:change_state("interacting", _temp_params)

		return
	end

	if not CharacterStateHelper.is_interacting(_interactor_extension) then
		if not _interactor_extension:allow_movement_during_interaction() then
			return
		end

		local interaction_config_2 = _interactor_extension:interaction_config()
		local _temp_params_2 = self._temp_params

		_temp_params_2.swap_to_3p = interaction_config_2.swap_to_3p
		_temp_params_2.show_weapons = interaction_config_2.show_weapons
		_temp_params_2.activate_block = interaction_config_2.activate_block
		_temp_params_2.allow_rotation_update = interaction_config_2.allow_rotation_update

		_csm:change_state("interacting", _temp_params_2)

		return
	end

	CharacterStateHelper.look(_input_extension, self._player.viewport_name, self._first_person_extension, _status_extension, self._inventory_extension)
end
