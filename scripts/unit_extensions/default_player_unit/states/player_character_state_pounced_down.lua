-- chunkname: @scripts/unit_extensions/default_player_unit/states/player_character_state_pounced_down.lua

PlayerCharacterStatePouncedDown = class(PlayerCharacterStatePouncedDown, PlayerCharacterState)

PlayerCharacterStatePouncedDown.init = function (arg_1_0, arg_1_1)
	-- function 1
	PlayerCharacterState.init(arg_1_0, arg_1_1, "pounced_down")

	local var_1_0 = arg_1_1
end

local num = 1.2

PlayerCharacterStatePouncedDown.on_enter = function (self, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5, arg_2_6, arg_2_7)
	-- function 2
	CharacterStateHelper.stop_weapon_actions(self.inventory_extension, "pounced")
	CharacterStateHelper.stop_career_abilities(self.career_extension, "pounced")

	local first_person_extension = self.first_person_extension
	local status_extension = self.status_extension

	CharacterStateHelper.change_camera_state(self.player, "follow_third_person")
	first_person_extension:set_first_person_mode(false)
	first_person_extension:set_wanted_player_height("knocked_down", arg_2_5)

	local is_pounced_down, var_2_3 = status_extension:is_pounced_down()
	local flag = true

	CharacterStateHelper.show_inventory_3p(arg_2_1, false, flag, self.is_server, self.inventory_extension)
	CharacterStateHelper.play_animation_event(var_2_3, "jump_attack")
	CharacterStateHelper.play_animation_event(arg_2_1, "jump_attack")
	self.inventory_extension:check_and_drop_pickups("pounced_down")
end

PlayerCharacterStatePouncedDown.on_exit = function (self, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5, arg_3_6)
	-- function 3
	local first_person_extension = self.first_person_extension

	self.liberated = nil
	self.liberation_time = nil

	local network = Managers.state.network

	if not network:game() and not arg_3_6 then
		local go_id = Managers.state.unit_storage:go_id(arg_3_1)

		network.network_transmit:send_rpc_server("rpc_disable_locomotion", go_id, false, NetworkLookup.movement_funcs.none)
	end

	if arg_3_6 ~= "knocked_down" then
		CharacterStateHelper.change_camera_state(self.player, "follow")
		self.first_person_extension:toggle_visibility(CameraTransitionSettings.perspective_transition_time)
		first_person_extension:set_wanted_player_height("stand", arg_3_5)

		local flag = false

		CharacterStateHelper.show_inventory_3p(arg_3_1, true, flag, self.is_server, self.inventory_extension)
	end

	local status_extension = self.status_extension

	if not status_extension:is_blocking() then
		if LEVEL_EDITOR_TEST or not Managers.state.network:game() then
			local go_id_2 = Managers.state.unit_storage:go_id(arg_3_1)

			if not self.is_server then
				Managers.state.network.network_transmit:send_rpc_clients("rpc_set_blocking", go_id_2, false)
			else
				Managers.state.network.network_transmit:send_rpc_server("rpc_set_blocking", go_id_2, false)
			end
		end

		status_extension:set_blocking(false)
	end
end

PlayerCharacterStatePouncedDown.set_free = function (self, arg_4_1, arg_4_2)
	-- function 4
	self.liberated = true
	self.liberation_time = arg_4_1 + num

	CharacterStateHelper.play_animation_event(arg_4_2, "jump_attack_stand_up")

	local status_extension = self.status_extension

	if LEVEL_EDITOR_TEST or not Managers.state.network:game() then
		local go_id = Managers.state.unit_storage:go_id(arg_4_2)

		if not self.is_server then
			Managers.state.network.network_transmit:send_rpc_clients("rpc_set_blocking", go_id, true)
		else
			Managers.state.network.network_transmit:send_rpc_server("rpc_set_blocking", go_id, true)
		end
	end

	status_extension:set_blocking(true)
end

PlayerCharacterStatePouncedDown.update = function (self, arg_5_1, arg_5_2, arg_5_3, arg_5_4, arg_5_5)
	-- function 5
	local csm = self.csm
	local unit = self.unit
	local input_source = self.player.input_source
	local status_extension = self.status_extension
	local input_extension = self.input_extension

	if not CharacterStateHelper.is_dead(status_extension) then
		csm:change_state("dead")

		return
	end

	if not CharacterStateHelper.is_knocked_down(status_extension) then
		self.temp_params.already_in_ko_anim = true

		csm:change_state("knocked_down", self.temp_params)

		return
	end

	if not self.liberated then
		if arg_5_5 > self.liberation_time then
			csm:change_state("standing")
		end

		return
	end

	if not CharacterStateHelper.is_pounced_down(status_extension) then
		self:set_free(arg_5_5, unit)
	end

	self.locomotion_extension:set_disable_rotation_update()
	CharacterStateHelper.look(input_extension, self.player.viewport_name, self.first_person_extension, status_extension, self.inventory_extension)
end
