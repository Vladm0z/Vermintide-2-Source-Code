-- chunkname: @scripts/unit_extensions/default_player_unit/states/player_character_state_interacting.lua

PlayerCharacterStateInteracting = class(PlayerCharacterStateInteracting, PlayerCharacterState)

PlayerCharacterStateInteracting.init = function (arg_1_0, arg_1_1)
	-- function 1
	PlayerCharacterState.init(arg_1_0, arg_1_1, "interacting")
end

PlayerCharacterStateInteracting.on_enter = function (self, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5, arg_2_6, arg_2_7)
	-- function 2
	self.has_started_interacting = false
	self.swap_to_3p = arg_2_7.swap_to_3p
	self.allow_rotation_update = arg_2_7.allow_rotation_update

	local locomotion_extension = self.locomotion_extension

	locomotion_extension:set_wanted_velocity(Vector3.zero())

	if not locomotion_extension:is_on_ground() then
		self.status_extension:set_falling_height()
	end

	local first_person_extension = self.first_person_extension

	if not self.swap_to_3p then
		CharacterStateHelper.change_camera_state(self.player, "follow_third_person")
		first_person_extension:set_first_person_mode(false)
	else
		CharacterStateHelper.play_animation_event_first_person(first_person_extension, "idle")
	end

	if not arg_2_7.show_weapons then
		local flag = true

		CharacterStateHelper.show_inventory_3p(arg_2_1, false, flag, self.is_server, self.inventory_extension)
	end

	self.deactivate_block_on_exit = false

	if not arg_2_7.activate_block then
		self.activate_block = arg_2_7.activate_block

		local status_extension = self.status_extension

		self.deactivate_block_on_exit = not status_extension:is_blocking()

		if LEVEL_EDITOR_TEST or not Managers.state.network:game() then
			local go_id = Managers.state.unit_storage:go_id(arg_2_1)

			if not self.is_server then
				Managers.state.network.network_transmit:send_rpc_clients("rpc_set_blocking", go_id, true)
			else
				Managers.state.network.network_transmit:send_rpc_server("rpc_set_blocking", go_id, true)
			end
		end

		status_extension:set_blocking(true)
	end
end

PlayerCharacterStateInteracting.on_exit = function (self, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5, arg_3_6)
	-- function 3
	self.activate_block = nil

	if not self.swap_to_3p then
		CharacterStateHelper.change_camera_state(self.player, "follow")

		local flag = true

		CharacterStateHelper.show_inventory_3p(arg_3_1, true, flag, self.is_server, self.inventory_extension)
		self.first_person_extension:toggle_visibility(CameraTransitionSettings.perspective_transition_time)
	else
		local flag_2 = false

		CharacterStateHelper.show_inventory_3p(arg_3_1, true, flag_2, self.is_server, self.inventory_extension)
	end

	local status_extension = self.status_extension

	if not self.deactivate_block_on_exit then
		if LEVEL_EDITOR_TEST or not Managers.state.network:game() then
			local go_id = Managers.state.unit_storage:go_id(arg_3_1)

			if not self.is_server then
				Managers.state.network.network_transmit:send_rpc_clients("rpc_set_blocking", go_id, false)
			else
				Managers.state.network.network_transmit:send_rpc_server("rpc_set_blocking", go_id, false)
			end
		end

		status_extension:set_blocking(false)
	end
end

PlayerCharacterStateInteracting.update = function (self, arg_4_1, arg_4_2, arg_4_3, arg_4_4, arg_4_5)
	-- function 4
	local csm = self.csm
	local input_extension = self.input_extension
	local interactor_extension = self.interactor_extension
	local status_extension = self.status_extension
	local get_movement_settings_table = PlayerUnitMovementSettings.get_movement_settings_table(arg_4_1)

	if not self.activate_block then
		if status_extension:is_blocking() or LEVEL_EDITOR_TEST or not Managers.state.network:game() then
			local go_id = Managers.state.unit_storage:go_id(arg_4_1)

			if not self.is_server then
				Managers.state.network.network_transmit:send_rpc_clients("rpc_set_blocking", go_id, true)
			else
				Managers.state.network.network_transmit:send_rpc_server("rpc_set_blocking", go_id, true)
			end
		end

		status_extension:set_blocking(true)
	end

	if not CharacterStateHelper.do_common_state_transitions(status_extension, csm) then
		return
	end

	if not CharacterStateHelper.is_using_transport(status_extension) then
		csm:change_state("using_transport")

		return
	end

	local world = self.world

	if not CharacterStateHelper.is_ledge_hanging(world, arg_4_1, self.temp_params) then
		csm:change_state("ledge_hanging", self.temp_params)

		return
	end

	if csm.state_next or not status_extension.do_leap then
		csm:change_state("leaping")

		return
	end

	if not CharacterStateHelper.is_interacting(interactor_extension) then
		csm:change_state("standing")

		return
	end

	if not CharacterStateHelper.is_waiting_for_interaction_approval(interactor_extension) then
		if not self.has_started_interacting then
			self.has_started_interacting = true
		end

		if not CharacterStateHelper.interact(input_extension, interactor_extension) then
			csm:change_state("standing")

			return
		end
	end

	if not CharacterStateHelper.is_pushed(status_extension) then
		status_extension:set_pushed(false)

		local pushed = get_movement_settings_table.stun_settings.pushed

		pushed.hit_react_type = status_extension:hit_react_type() .. "_push"

		csm:change_state("stunned", pushed)
		interactor_extension:abort_interaction()

		return
	end

	if not CharacterStateHelper.is_block_broken(status_extension) then
		status_extension:set_block_broken(false)

		local parry_broken = get_movement_settings_table.stun_settings.parry_broken

		parry_broken.hit_react_type = "medium_push"

		csm:change_state("stunned", parry_broken)
		interactor_extension:abort_interaction()

		return
	end

	if not self.allow_rotation_update then
		self.locomotion_extension:set_disable_rotation_update()
	end

	CharacterStateHelper.look(input_extension, self.player.viewport_name, self.first_person_extension, status_extension, self.inventory_extension)
end
