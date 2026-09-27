-- chunkname: @scripts/unit_extensions/default_player_unit/states/player_character_state_knocked_down.lua

PlayerCharacterStateKnockedDown = class(PlayerCharacterStateKnockedDown, PlayerCharacterState)

PlayerCharacterStateKnockedDown.init = function (arg_1_0, arg_1_1)
	-- function 1
	PlayerCharacterState.init(arg_1_0, arg_1_1, "knocked_down")

	local var_1_0 = arg_1_1
end

PlayerCharacterStateKnockedDown.on_enter = function (self, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5, arg_2_6, arg_2_7)
	-- function 2
	CharacterStateHelper.stop_weapon_actions(self.inventory_extension, "knocked_down")
	CharacterStateHelper.stop_career_abilities(self.career_extension, "knocked_down")

	local unit = self.unit
	local input_source = self.player.input_source

	if not (not arg_2_7 and arg_2_7.already_in_ko_anim) then
		local str = "knockdown_fall_front"

		CharacterStateHelper.play_animation_event(unit, str)

		if not arg_2_7 and not arg_2_7.already_in_ko_anim then
			arg_2_7.already_in_ko_anim = nil
		end
	end

	self.debug_t = arg_2_5

	self.locomotion_extension:set_wanted_velocity(Vector3.zero())

	local first_person_extension = self.first_person_extension

	first_person_extension:set_wanted_player_height("knocked_down", arg_2_5)
	first_person_extension:animation_event("knocked_down")
	first_person_extension:animation_set_variable("knockdown_blend", 0)

	self.start_time = arg_2_5

	CharacterStateHelper.change_camera_state(self.player, "follow_third_person")
	first_person_extension:set_first_person_mode(false)

	local extension = ScriptUnit.extension(unit, "status_system")

	self.pounced_down = arg_2_6 == "pounced_down"

	local is_pounced_down, var_2_6 = CharacterStateHelper.is_pounced_down(extension)

	if not (not is_pounced_down and self.pounced_down) then
		CharacterStateHelper.play_animation_event(var_2_6, "jump_attack")
		CharacterStateHelper.play_animation_event(unit, "jump_attack")

		self.pounced_down = true
	end

	self.grabbed_by_pack_master = arg_2_6 == "grabbed_by_pack_master"

	local flag = true

	CharacterStateHelper.show_inventory_3p(unit, false, flag, self.is_server, self.inventory_extension)
	ScriptUnit.extension(unit, "inventory_system"):check_and_drop_pickups("knocked_down")
	ScriptUnit.extension(unit, "overcharge_system"):reset()
	extension:set_catapulted(false)
end

PlayerCharacterStateKnockedDown.on_exit = function (self, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5, arg_3_6)
	-- function 3
	local first_person_extension = self.first_person_extension

	if arg_3_6 ~= "dead" then
		CharacterStateHelper.change_camera_state(self.player, "follow")

		local flag = true

		CharacterStateHelper.show_inventory_3p(arg_3_1, true, flag, self.is_server, self.inventory_extension)
		self.first_person_extension:toggle_visibility(CameraTransitionSettings.perspective_transition_time)
	end

	first_person_extension:set_wanted_player_height("stand", arg_3_5)
end

PlayerCharacterStateKnockedDown.update = function (self, arg_4_1, arg_4_2, arg_4_3, arg_4_4, arg_4_5)
	-- function 4
	local csm = self.csm
	local unit = self.unit
	local locomotion_extension = self.locomotion_extension

	if not locomotion_extension:is_on_ground() then
		ScriptUnit.extension(unit, "whereabouts_system"):set_is_onground()
	end

	local status_extension = self.status_extension

	if not CharacterStateHelper.is_dead(status_extension) then
		csm:change_state("dead")

		return
	end

	if not (not self.pounced_down and CharacterStateHelper.is_pounced_down(status_extension)) then
		locomotion_extension:set_disabled(false, LocomotionUtils.update_local_animation_driven_movement_with_parent)

		local str = "knockdown"

		CharacterStateHelper.play_animation_event(unit, str)

		self.pounced_down = false
	end

	if not (not self.grabbed_by_pack_master and CharacterStateHelper.is_grabbed_by_pack_master(status_extension)) then
		locomotion_extension:enable_script_driven_movement()
		locomotion_extension:enable_rotation_towards_velocity(true)

		self.grabbed_by_pack_master = false
	end

	if not CharacterStateHelper.is_knocked_down(status_extension) then
		self.temp_params.is_crouching = false

		csm:change_state("standing")

		return
	end

	local num = arg_4_5 - self.start_time
	local first_person_extension = self.first_person_extension

	if num <= 1 then
		first_person_extension:animation_set_variable("knockdown_blend", num)
	else
		first_person_extension:animation_set_variable("knockdown_blend", 1)
	end

	local input_extension = self.input_extension

	locomotion_extension:set_disable_rotation_update()
	CharacterStateHelper.look(input_extension, self.player.viewport_name, self.first_person_extension, status_extension, self.inventory_extension)
end
