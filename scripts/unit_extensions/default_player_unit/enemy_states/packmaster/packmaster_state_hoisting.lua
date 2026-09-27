-- chunkname: @scripts/unit_extensions/default_player_unit/enemy_states/packmaster/packmaster_state_hoisting.lua

PackmasterStateHoisting = class(PackmasterStateHoisting, EnemyCharacterState)

PackmasterStateHoisting.init = function (self, arg_1_1)
	-- function 1
	EnemyCharacterState.init(self, arg_1_1, "packmaster_hoisting")

	local var_1_0 = arg_1_1

	self.current_movement_speed_scale = 0
	self.last_input_direction = Vector3Box(0, 0, 0)
end

PackmasterStateHoisting.on_enter = function (self, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5, arg_2_6, arg_2_7)
	-- function 2
	self._hosting_end_time = arg_2_5 + BreedActions.skaven_pack_master.hoist.hoist_anim_length
	self._drag_target_unit = arg_2_7
	self._unit = arg_2_1

	local _drag_target_unit = self._drag_target_unit
	local var_2_1 = Vector3(0, 0, 0)

	self._locomotion_extension:set_forced_velocity(var_2_1)
	self._locomotion_extension:set_wanted_velocity(Vector3.zero())
	CharacterStateHelper.change_camera_state(self._player, "follow_third_person")
	StatusUtils.set_grabbed_by_pack_master_network("pack_master_hoisting", _drag_target_unit, true, arg_2_1)
	self:set_breed_action("hoist")
end

PackmasterStateHoisting.on_exit = function (self, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5, arg_3_6)
	-- function 3
	local _drag_target_unit = self._drag_target_unit
	local _first_person_extension = self._first_person_extension

	if not Unit.alive(_drag_target_unit) then
		-- Nothing
	end

	self._drag_target_unit = nil

	CharacterStateHelper.change_camera_state(self._player, "follow")
	_first_person_extension:toggle_visibility(CameraTransitionSettings.perspective_transition_time)
	_first_person_extension:set_wanted_player_height("stand", arg_3_5)

	if not self._action_aborted then
		return
	end

	local flag = true

	if not self._status_extension:get_unarmed() then
		CharacterStateHelper.show_inventory_3p(arg_3_1, true, flag, self._is_server, self._inventory_extension)
		_first_person_extension:unhide_weapons("catapulted")
	else
		CharacterStateHelper.play_animation_event(arg_3_1, "to_unarmed")
		CharacterStateHelper.play_animation_event_first_person(_first_person_extension, "to_unarmed")
		_first_person_extension:animation_set_variable("armed", 0)
		CharacterStateHelper.show_inventory_3p(arg_3_1, false, flag, self._is_server, self._inventory_extension)
	end

	self:set_breed_action("n/a")

	local _career_extension = self._career_extension
	local ability_id = _career_extension:ability_id("equip")

	_career_extension:ability_by_id(ability_id):unfreeze()
end

PackmasterStateHoisting.update = function (self, arg_4_1, arg_4_2, arg_4_3, arg_4_4, arg_4_5)
	-- function 4
	local _csm = self._csm
	local _inventory_extension = self._inventory_extension
	local extension = ScriptUnit.extension(arg_4_1, "input_system")
	local _status_extension = self._status_extension
	local _drag_target_unit = self._drag_target_unit
	local var_4_5

	if not _drag_target_unit and not HEALTH_ALIVE[_drag_target_unit] then
		if not ScriptUnit.extension(_drag_target_unit, "status_system"):is_dead() then
			local _temp_params = self._temp_params

			_csm:change_state("walking", _temp_params)

			return
		end
	else
		local _temp_params_2 = self._temp_params

		_csm:change_state("walking", _temp_params_2)

		return
	end

	if not CharacterStateHelper.is_dead(_status_extension) then
		self:release_dragged_target()
		_csm:change_state("dead")

		return true
	end

	if not CharacterStateHelper.is_staggered(_status_extension) then
		self:release_dragged_target()
		_csm:change_state("staggered")

		return true
	end

	if not self._locomotion_extension:is_on_ground() then
		self:release_dragged_target()

		local _temp_params_3 = self._temp_params

		_csm:change_state("walking", _temp_params_3)

		return true
	end

	if not extension then
		return
	end

	if arg_4_5 > self._hosting_end_time then
		StatusUtils.set_grabbed_by_pack_master_network("pack_master_hanging", _drag_target_unit, true, arg_4_1)
		_status_extension:set_packmaster_released()
		_status_extension:set_unarmed(true)

		local _temp_params_4 = self._temp_params
		local extension_2 = ScriptUnit.extension(arg_4_1, "career_system")

		_csm:change_state("standing", _temp_params_4)
	end

	self._locomotion_extension:set_disable_rotation_update()
	CharacterStateHelper.look(extension, self._player.viewport_name, self._first_person_extension, _status_extension, _inventory_extension)
end

PackmasterStateHoisting.release_dragged_target = function (self)
	-- function 5
	local _status_extension = self._status_extension
	local _first_person_extension = self._first_person_extension
	local _drag_target_unit = self._drag_target_unit
	local extension = ScriptUnit.extension(_drag_target_unit, "status_system")

	CharacterStateHelper.show_inventory_3p(self._unit, true, true, Managers.player.is_server, self._inventory_extension)
	_first_person_extension:unhide_weapons("catapulted")
	StatusUtils.set_grabbed_by_pack_master_network("pack_master_unhooked", _drag_target_unit, false, self._unit)
	_status_extension:set_packmaster_released()
end
