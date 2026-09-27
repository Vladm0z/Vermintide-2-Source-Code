-- chunkname: @scripts/unit_extensions/default_player_unit/enemy_states/enemy_character_state_inspecting.lua

EnemyCharacterStateInspecting = class(EnemyCharacterStateInspecting, EnemyCharacterState)

EnemyCharacterStateInspecting.init = function (arg_1_0, arg_1_1)
	-- function 1
	EnemyCharacterState.init(arg_1_0, arg_1_1, "inspecting")

	local var_1_0 = arg_1_1
end

EnemyCharacterStateInspecting.on_enter = function (self, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5, arg_2_6, arg_2_7)
	-- function 2
	self._locomotion_extension:set_wanted_velocity(Vector3.zero())
	CharacterStateHelper.change_camera_state(self._player, "follow_third_person")

	local flag = false
	local var_2_1
	local flag_2 = false

	if not self._status_extension:get_unarmed() then
		flag_2 = true
	end

	self._first_person_extension:set_first_person_mode(flag, var_2_1, flag_2)
	CharacterStateHelper.stop_weapon_actions(self._inventory_extension, "inspecting")
	CharacterStateHelper.stop_career_abilities(self._career_extension, "inspecting")
	CharacterStateHelper.play_animation_event(arg_2_1, "idle")
	CharacterStateHelper.play_animation_event_first_person(self._first_person_extension, "idle")
	self._status_extension:set_inspecting(true)
end

EnemyCharacterStateInspecting.on_exit = function (self, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5, arg_3_6)
	-- function 3
	CharacterStateHelper.change_camera_state(self._player, "follow")
	self._first_person_extension:toggle_visibility(CameraTransitionSettings.perspective_transition_time)
	self._status_extension:set_inspecting(false)
end

EnemyCharacterStateInspecting.update = function (self, arg_4_1, arg_4_2, arg_4_3, arg_4_4, arg_4_5)
	-- function 4
	local _csm = self._csm
	local _unit = self._unit
	local _input_extension = self._input_extension
	local _interactor_extension = self._interactor_extension
	local camera = Managers.state.camera
	local _status_extension = self._status_extension

	if not CharacterStateHelper.do_common_state_transitions(_status_extension, _csm) then
		return
	end

	if not _input_extension:get("character_inspecting") then
		_csm:change_state("standing")

		return
	end

	if _csm.state_next or not _status_extension.do_leap then
		_csm:change_state("leaping")

		return
	end

	self._locomotion_extension:set_disable_rotation_update()
	CharacterStateHelper.look(_input_extension, self._player.viewport_name, self._first_person_extension, _status_extension, self._inventory_extension)
end
