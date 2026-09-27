-- chunkname: @scripts/unit_extensions/default_player_unit/enemy_states/enemy_character_state_interacting.lua

EnemyCharacterStateInteracting = class(EnemyCharacterStateInteracting, EnemyCharacterState)

EnemyCharacterStateInteracting.init = function (arg_1_0, arg_1_1)
	-- function 1
	EnemyCharacterState.init(arg_1_0, arg_1_1, "interacting")
end

EnemyCharacterStateInteracting.on_enter = function (self, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5, arg_2_6, arg_2_7)
	-- function 2
	self.has_started_interacting = false
	self.swap_to_3p = arg_2_7.swap_to_3p

	local _locomotion_extension = self._locomotion_extension

	self._locomotion_extension:set_wanted_velocity(Vector3.zero())

	if not self._locomotion_extension:is_on_ground() then
		self._status_extension:set_falling_height()
	end

	local _first_person_extension = self._first_person_extension

	if not self.swap_to_3p then
		CharacterStateHelper.change_camera_state(self._player, "follow_third_person")
		_first_person_extension:set_first_person_mode(false)
	else
		CharacterStateHelper.play_animation_event_first_person(_first_person_extension, "idle")
	end

	if not arg_2_7.show_weapons then
		local flag = true

		CharacterStateHelper.show_inventory_3p(arg_2_1, false, flag, self._is_server, self._inventory_extension)
	end

	self.deactivate_block_on_exit = false

	if not arg_2_7.activate_block then
		self.activate_block = arg_2_7.activate_block

		local _status_extension = self._status_extension

		self.deactivate_block_on_exit = not _status_extension:is_blocking()

		if LEVEL_EDITOR_TEST or not Managers.state.network:game() then
			local go_id = Managers.state.unit_storage:go_id(arg_2_1)

			if not self._is_server then
				Managers.state.network.network_transmit:send_rpc_clients("rpc_set_blocking", go_id, true)
			else
				Managers.state.network.network_transmit:send_rpc_server("rpc_set_blocking", go_id, true)
			end
		end

		_status_extension:set_blocking(true)
	end
end

EnemyCharacterStateInteracting.on_exit = function (self, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5, arg_3_6)
	-- function 3
	self.activate_block = nil

	if not self.swap_to_3p then
		CharacterStateHelper.change_camera_state(self._player, "follow")

		local flag = true

		CharacterStateHelper.show_inventory_3p(arg_3_1, true, flag, self._is_server, self._inventory_extension)
		self._first_person_extension:toggle_visibility(CameraTransitionSettings.perspective_transition_time)
	else
		local flag_2 = false

		CharacterStateHelper.show_inventory_3p(arg_3_1, true, flag_2, self._is_server, self._inventory_extension)
	end

	local _status_extension = self._status_extension

	if not self.deactivate_block_on_exit then
		if LEVEL_EDITOR_TEST or not Managers.state.network:game() then
			local go_id = Managers.state.unit_storage:go_id(arg_3_1)

			if not self._is_server then
				Managers.state.network.network_transmit:send_rpc_clients("rpc_set_blocking", go_id, false)
			else
				Managers.state.network.network_transmit:send_rpc_server("rpc_set_blocking", go_id, false)
			end
		end

		_status_extension:set_blocking(false)
	end
end

EnemyCharacterStateInteracting.update = function (self, arg_4_1, arg_4_2, arg_4_3, arg_4_4, arg_4_5)
	-- function 4
	local _csm = self._csm
	local _input_extension = self._input_extension
	local _interactor_extension = self._interactor_extension
	local _status_extension = self._status_extension
	local get_movement_settings_table = PlayerUnitMovementSettings.get_movement_settings_table(arg_4_1)

	if not self.activate_block then
		if _status_extension:is_blocking() or LEVEL_EDITOR_TEST or not Managers.state.network:game() then
			local go_id = Managers.state.unit_storage:go_id(arg_4_1)

			if not self._is_server then
				Managers.state.network.network_transmit:send_rpc_clients("rpc_set_blocking", go_id, true)
			else
				Managers.state.network.network_transmit:send_rpc_server("rpc_set_blocking", go_id, true)
			end
		end

		_status_extension:set_blocking(true)
	end

	if not CharacterStateHelper.do_common_state_transitions(_status_extension, _csm) then
		return
	end

	if not CharacterStateHelper.is_using_transport(_status_extension) then
		_csm:change_state("using_transport")

		return
	end

	if _csm.state_next or not _status_extension.do_leap then
		_csm:change_state("leaping")

		return
	end

	if _csm.state_next or not _status_extension.do_pounce then
		_csm:change_state("pouncing")

		return
	end

	if not CharacterStateHelper.is_interacting(_interactor_extension) then
		_csm:change_state("standing")

		return
	end

	if not CharacterStateHelper.is_waiting_for_interaction_approval(_interactor_extension) then
		if not self.has_started_interacting then
			self.has_started_interacting = true
		end

		if not CharacterStateHelper.interact(_input_extension, _interactor_extension) then
			_csm:change_state("standing")

			return
		end
	end

	if not CharacterStateHelper.is_pushed(_status_extension) then
		_status_extension:set_pushed(false)

		local pushed = get_movement_settings_table.stun_settings.pushed

		pushed.hit_react_type = _status_extension:hit_react_type() .. "_push"

		_csm:change_state("stunned", pushed)
		_interactor_extension:abort_interaction()

		return
	end

	if not CharacterStateHelper.is_block_broken(_status_extension) then
		_status_extension:set_block_broken(false)

		local parry_broken = get_movement_settings_table.stun_settings.parry_broken

		parry_broken.hit_react_type = "medium_push"

		_csm:change_state("stunned", parry_broken)
		_interactor_extension:abort_interaction()

		return
	end

	self._locomotion_extension:set_disable_rotation_update()
	CharacterStateHelper.look(_input_extension, self._player.viewport_name, self._first_person_extension, _status_extension, self._inventory_extension)

	local should_climb = _status_extension:should_climb()

	if _csm.state_next or not should_climb then
		local interactable_unit = ScriptUnit.extension(arg_4_1, "interactor_system"):interactable_unit()
		local var_4_10 = Managers.state.entity:system("nav_graph_system").level_jumps[interactable_unit]

		self._temp_params.jump_data = var_4_10

		local smart_object_type = var_4_10.jump_object_data.smart_object_type

		if not (smart_object_type == "ledges" or smart_object_type ~= "ledges_with_fence") then
			_csm:change_state("climbing", self._temp_params)
			self._first_person_extension:change_state("climbing")
		elseif smart_object_type == "jumps" then
			_csm:change_state("jump_across", self._temp_params)
			self._first_person_extension:change_state("jump_across")
		end

		return
	end

	local should_tunnel = _status_extension:should_tunnel()

	if _csm.state_next or not should_tunnel then
		_csm:change_state("tunneling")
	end

	local should_spawn = _status_extension:should_spawn()

	if _csm.state_next or not should_spawn then
		_csm:change_state("spawning")
	end
end
