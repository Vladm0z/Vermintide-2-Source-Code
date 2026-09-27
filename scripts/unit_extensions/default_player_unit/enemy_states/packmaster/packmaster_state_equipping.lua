-- chunkname: @scripts/unit_extensions/default_player_unit/enemy_states/packmaster/packmaster_state_equipping.lua

PackmasterStateEquipping = class(PackmasterStateEquipping, EnemyCharacterState)

PackmasterStateEquipping.init = function (self, arg_1_1)
	-- function 1
	EnemyCharacterState.init(self, arg_1_1, "packmaster_equipping")

	self.current_movement_speed_scale = 0
	self.last_input_direction = Vector3Box(0, 0, 0)
end

local POSITION_LOOKUP = POSITION_LOOKUP

PackmasterStateEquipping.on_enter = function (self, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5, arg_2_6, arg_2_7)
	-- function 2
	table.clear(self._temp_params)

	self._unit = arg_2_1
	self._first_person_extension = ScriptUnit.has_extension(arg_2_1, "first_person_system")
	self._status_extension = ScriptUnit.extension(arg_2_1, "status_system")
	self._career_extension = ScriptUnit.extension(arg_2_1, "career_system")
	self._buff_extension = ScriptUnit.extension(arg_2_1, "buff_system")
	self._locomotion_extension = ScriptUnit.extension(arg_2_1, "locomotion_system")
	self._input_extension = ScriptUnit.has_extension(arg_2_1, "input_system")
	self._inventory_extension = ScriptUnit.extension(arg_2_1, "inventory_system")

	local get_data = Unit.get_data(arg_2_1, "breed")
	local _first_person_extension = self._first_person_extension

	CharacterStateHelper.play_animation_event(arg_2_1, "equip")
	CharacterStateHelper.play_animation_event_first_person(_first_person_extension, "equip")

	self._spawn_weapon_time = arg_2_5 + get_data.equip_hook_weapon_spawn_time
	self._finish_time = arg_2_5 + get_data.equip_hook_exit_state_time
end

PackmasterStateEquipping.update = function (self, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5)
	-- function 3
	local _csm = self._csm
	local get_movement_settings_table = PlayerUnitMovementSettings.get_movement_settings_table(arg_3_1)
	local _input_extension = self._input_extension
	local _status_extension = self._status_extension
	local _first_person_extension = self._first_person_extension
	local _locomotion_extension = self._locomotion_extension
	local _inventory_extension = self._inventory_extension
	local _health_extension = self._health_extension

	if not CharacterStateHelper.do_common_state_transitions(_status_extension, _csm) then
		return
	end

	if not CharacterStateHelper.is_using_transport(_status_extension) then
		_csm:change_state("using_transport")

		return
	end

	if not CharacterStateHelper.is_pushed(_status_extension) then
		_status_extension:set_pushed(false)

		local pushed = get_movement_settings_table.stun_settings.pushed

		pushed.hit_react_type = _status_extension:hit_react_type() .. "_push"

		_csm:change_state("stunned", pushed)

		return
	end

	if not CharacterStateHelper.is_block_broken(_status_extension) then
		_status_extension:set_block_broken(false)

		local parry_broken = get_movement_settings_table.stun_settings.parry_broken

		parry_broken.hit_react_type = "medium_push"

		_csm:change_state("stunned", parry_broken)

		return
	end

	local _spawn_weapon_time = self._spawn_weapon_time

	if not (not _spawn_weapon_time and not (_spawn_weapon_time <= arg_3_5)) then
		CharacterStateHelper.show_inventory_3p(arg_3_1, true, true, self._is_server, _inventory_extension)
		_first_person_extension:unhide_weapons("catapulted")

		self._spawn_weapon_time = nil
	end

	local _finish_time = self._finish_time

	if not (not _finish_time and not (_finish_time <= arg_3_5)) then
		CharacterStateHelper.play_animation_event(arg_3_1, "to_armed")
		CharacterStateHelper.play_animation_event_first_person(_first_person_extension, "to_armed")
		_first_person_extension:animation_set_variable("armed", 1)
		_status_extension:set_unarmed(false)
		_csm:change_state("standing")

		return
	end

	local num = 1

	CharacterStateHelper.look(_input_extension, self._player.viewport_name, _first_person_extension, _status_extension, _inventory_extension, num)
end

PackmasterStateEquipping._finish = function (self, arg_4_1)
	-- function 4
	if not self._locomotion_extension:is_on_ground() then
		return
	end

	local _unit = self._unit
	local _career_extension = self._career_extension
	local _status_extension = self._status_extension
	local _locomotion_extension = self._locomotion_extension

	self:_play_vo()
end

PackmasterStateEquipping.on_exit = function (self, arg_5_1, arg_5_2, arg_5_3, arg_5_4, arg_5_5, arg_5_6)
	-- function 5
	if not Managers.state.network:in_game_session() then
		return
	end

	local _csm = self._csm
	local _status_extension = self._status_extension
	local _locomotion_extension = self._locomotion_extension

	self._career_extension:start_activated_ability_cooldown(1, 1)

	self._finish_time = nil
end

PackmasterStateEquipping._play_vo = function (self, arg_6_1, arg_6_2)
	-- function 6
	local _unit = self._unit
end
