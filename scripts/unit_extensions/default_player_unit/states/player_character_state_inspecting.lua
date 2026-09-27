-- chunkname: @scripts/unit_extensions/default_player_unit/states/player_character_state_inspecting.lua

PlayerCharacterStateInspecting = class(PlayerCharacterStateInspecting, PlayerCharacterState)

PlayerCharacterStateInspecting.init = function (arg_1_0, arg_1_1)
	-- function 1
	PlayerCharacterState.init(arg_1_0, arg_1_1, "inspecting")

	local var_1_0 = arg_1_1
end

PlayerCharacterStateInspecting.on_enter = function (self, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5, arg_2_6, arg_2_7)
	-- function 2
	self.locomotion_extension:set_wanted_velocity(Vector3.zero())
	CharacterStateHelper.change_camera_state(self.player, "follow_third_person")
	self.first_person_extension:set_first_person_mode(false)
	CharacterStateHelper.stop_weapon_actions(self.inventory_extension, "inspecting")
	CharacterStateHelper.stop_career_abilities(self.career_extension, "inspecting")
	CharacterStateHelper.play_animation_event(arg_2_1, "idle")
	CharacterStateHelper.play_animation_event_first_person(self.first_person_extension, "idle")
	self.status_extension:set_inspecting(true)
end

PlayerCharacterStateInspecting.on_exit = function (self, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5, arg_3_6)
	-- function 3
	CharacterStateHelper.change_camera_state(self.player, "follow")
	self.first_person_extension:toggle_visibility(CameraTransitionSettings.perspective_transition_time)
	self.status_extension:set_inspecting(false)
end

PlayerCharacterStateInspecting.update = function (self, arg_4_1, arg_4_2, arg_4_3, arg_4_4, arg_4_5)
	-- function 4
	local csm = self.csm
	local unit = self.unit
	local input_extension = self.input_extension
	local interactor_extension = self.interactor_extension
	local camera = Managers.state.camera
	local status_extension = self.status_extension

	if not CharacterStateHelper.do_common_state_transitions(status_extension, csm) then
		return
	end

	local world = self.world

	if not CharacterStateHelper.is_ledge_hanging(world, unit, self.temp_params) then
		csm:change_state("ledge_hanging", self.temp_params)

		return
	end

	if not self.cosmetic_extension:get_queued_3p_emote() then
		csm:change_state("emote")

		return
	end

	if not input_extension:get("character_inspecting") then
		csm:change_state("standing")

		return
	end

	if csm.state_next or not status_extension.do_leap then
		csm:change_state("leaping")

		return
	end

	self.locomotion_extension:set_disable_rotation_update()
	CharacterStateHelper.look(input_extension, self.player.viewport_name, self.first_person_extension, status_extension, self.inventory_extension)
end
