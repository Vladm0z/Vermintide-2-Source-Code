-- chunkname: @scripts/unit_extensions/default_player_unit/states/player_character_state_overpowered.lua

PlayerCharacterStateOverpowered = class(PlayerCharacterStateOverpowered, PlayerCharacterState)

PlayerCharacterStateOverpowered.init = function (arg_1_0, arg_1_1)
	-- function 1
	PlayerCharacterState.init(arg_1_0, arg_1_1, "overpowered")
end

PlayerCharacterStateOverpowered.on_enter = function (self, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5, arg_2_6, arg_2_7)
	-- function 2
	CharacterStateHelper.stop_weapon_actions(self.inventory_extension, "overpowered")
	CharacterStateHelper.stop_career_abilities(self.career_extension, "overpowered")

	local owner = Managers.player:owner(arg_2_1)
	local flag = not owner and not owner:is_player_controlled()

	if not (not arg_2_7.start_sound_event and flag) then
		local wwise_world = Managers.world:wwise_world(self.world)

		WwiseWorld.trigger_event(wwise_world, arg_2_7.start_sound_event)
	end

	local str = "to_cloud_of_flies"

	self.inventory_extension:check_and_drop_pickups("overpowererd")
	CharacterStateHelper.play_animation_event(arg_2_1, str)

	local input_extension = self.input_extension
	local status_extension = self.status_extension

	self.locomotion_extension:set_wanted_velocity(Vector3.zero())

	self.params = arg_2_7

	CharacterStateHelper.change_camera_state(self.player, "follow_third_person")
	self.first_person_extension:set_first_person_mode(false)
	CharacterStateHelper.show_inventory_3p(arg_2_1, false, true, Managers.player.is_server, self.inventory_extension)
end

PlayerCharacterStateOverpowered.on_exit = function (self, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5, arg_3_6)
	-- function 3
	local owner = Managers.player:owner(arg_3_1)
	local flag = not owner and not owner:is_player_controlled()

	if not (not self.params.end_sound_event and flag) then
		local wwise_world = Managers.world:wwise_world(self.world)

		WwiseWorld.trigger_event(wwise_world, self.params.end_sound_event)
	end

	local has_extension = ScriptUnit.has_extension(arg_3_1, "first_person_system")

	if not has_extension and not self.onscreen_particle_id then
		has_extension:stop_spawning_screen_particles(self.onscreen_particle_id)
	end

	if arg_3_6 ~= "knocked_down" then
		CharacterStateHelper.change_camera_state(self.player, "follow")
		self.first_person_extension:toggle_visibility(CameraTransitionSettings.perspective_transition_time)

		local flag_2 = false

		CharacterStateHelper.show_inventory_3p(arg_3_1, true, flag_2, self.is_server, self.inventory_extension)
	end

	self.inventory_extension:rewield_wielded_slot()
	self.status_extension:set_overpowered(false)
end

PlayerCharacterStateOverpowered.update = function (self, arg_4_1, arg_4_2, arg_4_3, arg_4_4, arg_4_5)
	-- function 4
	local csm = self.csm
	local unit = self.unit
	local input_extension = self.input_extension
	local inventory_extension = self.inventory_extension
	local status_extension = self.status_extension
	local locomotion_extension = self.locomotion_extension
	local world = self.world
	local overpowered_attacking_unit = status_extension.overpowered_attacking_unit

	if not not HEALTH_ALIVE[overpowered_attacking_unit] then
		if not CharacterStateHelper.is_waiting_for_assisted_respawn(status_extension) then
			csm:change_state("waiting_for_assisted_respawn")
		elseif not CharacterStateHelper.is_knocked_down(status_extension) then
			csm:change_state("knocked_down")
		elseif not CharacterStateHelper.is_dead(status_extension) then
			csm:change_state("dead")
		else
			csm:change_state("standing")
		end

		return
	end

	if not CharacterStateHelper.do_common_state_transitions(status_extension, csm, "overpowered") then
		return
	end

	if not CharacterStateHelper.is_ledge_hanging(world, unit, self.temp_params) then
		csm:change_state("ledge_hanging", self.temp_params)

		return
	end

	if not (csm.state_next or locomotion_extension:is_on_ground()) then
		csm:change_state("falling")

		return
	end

	locomotion_extension:set_disable_rotation_update()
	CharacterStateHelper.look(input_extension, self.player.viewport_name, self.first_person_extension, status_extension, inventory_extension)
end
