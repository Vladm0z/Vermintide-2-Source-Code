-- chunkname: @scripts/unit_extensions/default_player_unit/states/player_character_state_waiting_for_assisted_respawn.lua

PlayerCharacterStateWaitingForAssistedRespawn = class(PlayerCharacterStateWaitingForAssistedRespawn, PlayerCharacterState)

PlayerCharacterStateWaitingForAssistedRespawn.init = function (self, arg_1_1)
	-- function 1
	PlayerCharacterState.init(self, arg_1_1, "waiting_for_assisted_respawn")

	self.recovery_timer = nil
	self.recovered = false
end

PlayerCharacterStateWaitingForAssistedRespawn.on_enter = function (self, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5, arg_2_6, arg_2_7)
	-- function 2
	self.first_person_extension:set_first_person_mode(false)

	local flag = true

	CharacterStateHelper.show_inventory_3p(arg_2_1, false, flag, self.is_server, self.inventory_extension)
	self.input_extension:set_enabled(false)

	local assisted_respawn_flavour_unit = self.status_extension.assisted_respawn_flavour_unit

	self.flavour_unit = assisted_respawn_flavour_unit

	LocomotionUtils.enable_linked_movement(self.world, arg_2_1, assisted_respawn_flavour_unit, 0, Vector3.zero())

	local get_data = Unit.get_data(assisted_respawn_flavour_unit, "on_enter_loop_anim")

	CharacterStateHelper.play_animation_event(arg_2_1, get_data)
	CharacterStateHelper.change_camera_state(self.player, "observer")

	local extension = ScriptUnit.extension(arg_2_1, "career_system")

	CharacterStateHelper.stop_weapon_actions(self.inventory_extension, "respawning")
	CharacterStateHelper.stop_career_abilities(extension, "respawning")
end

PlayerCharacterStateWaitingForAssistedRespawn.on_exit = function (self, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5, arg_3_6)
	-- function 3
	self.first_person_extension:toggle_visibility(CameraTransitionSettings.perspective_transition_time)

	local flag = true

	CharacterStateHelper.show_inventory_3p(arg_3_1, true, flag, self.is_server, self.inventory_extension)
	self.input_extension:set_enabled(true)

	local player = self.player

	CharacterStateHelper.change_camera_state(player, "follow")
	LocomotionUtils.disable_linked_movement(arg_3_1)
	self.locomotion_extension:enable_script_driven_movement()

	self.recovery_timer = nil
	self.recovered = false

	local status_extension = self.status_extension

	status_extension:set_assisted_respawning(false)
	status_extension:set_respawned(true)

	if not (not Managers.state.network:game() and LEVEL_EDITOR_TEST) then
		local network = Managers.state.network
		local get_assisted_respawn_helper_unit = self.status_extension:get_assisted_respawn_helper_unit()
		local unit_game_object_id = network:unit_game_object_id(arg_3_1)

		unit_game_object_id = unit_game_object_id or 0

		local unit_game_object_id_2

		if not get_assisted_respawn_helper_unit then
			unit_game_object_id_2 = network:unit_game_object_id(get_assisted_respawn_helper_unit)

			if not unit_game_object_id_2 then
				-- Nothing
			end
		end

		unit_game_object_id_2 = 0

		::label_3_0::

		network.network_transmit:send_rpc_server("rpc_status_change_bool", NetworkLookup.statuses.respawned, true, unit_game_object_id, unit_game_object_id_2)
	end
end

PlayerCharacterStateWaitingForAssistedRespawn.update = function (self, arg_4_1, arg_4_2, arg_4_3, arg_4_4, arg_4_5)
	-- function 4
	local csm = self.csm
	local status_extension = self.status_extension

	if not CharacterStateHelper.is_dead(status_extension) then
		csm:change_state("dead")

		return
	end

	if not CharacterStateHelper.is_assisted_respawning(status_extension) then
		if not self.recovery_timer then
			local flavour_unit = self.flavour_unit

			self.recovery_timer = arg_4_5 + Unit.get_data(flavour_unit, "recovery_time")

			CharacterStateHelper.play_animation_event(arg_4_1, "respawn_revive")
		elseif arg_4_5 >= self.recovery_timer then
			csm:change_state("standing")

			return
		end
	end
end
