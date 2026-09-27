-- chunkname: @scripts/unit_extensions/default_player_unit/enemy_states/enemy_character_state_catapulted.lua

require("scripts/settings/player_movement_settings")

EnemyCharacterStateCatapulted = class(EnemyCharacterStateCatapulted, EnemyCharacterState)

local POSITION_LOOKUP = POSITION_LOOKUP
local directions = PlayerUnitMovementSettings.catapulted.directions

EnemyCharacterStateCatapulted.init = function (arg_1_0, arg_1_1)
	-- function 1
	EnemyCharacterState.init(arg_1_0, arg_1_1, "catapulted")
end

EnemyCharacterStateCatapulted.on_enter = function (self, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5, arg_2_6, arg_2_7)
	-- function 2
	CharacterStateHelper.stop_weapon_actions(self._inventory_extension, "stunned")
	CharacterStateHelper.stop_career_abilities(self._career_extension, "stunned")

	local direction = arg_2_7.direction
	local unbox = self._status_extension.catapulted_velocity:unbox()
	local _locomotion_extension = self._locomotion_extension

	_locomotion_extension:set_maximum_upwards_velocity(unbox.z)
	_locomotion_extension:set_forced_velocity(unbox)
	_locomotion_extension:set_wanted_velocity(unbox)

	self._direction = direction

	local str = "idle"
	local str_2 = "idle"

	CharacterStateHelper.play_animation_event(arg_2_1, str)
	CharacterStateHelper.play_animation_event_first_person(self._first_person_extension, str_2 or str)

	local _first_person_extension = self._first_person_extension

	_first_person_extension:hide_weapons("catapulted")

	local flag = false

	CharacterStateHelper.show_inventory_3p(arg_2_1, false, flag, self._is_server, self._inventory_extension)

	local sound_event = arg_2_7.sound_event

	if not sound_event then
		_first_person_extension:play_hud_sound_event(sound_event)
	end

	self.start_catapulted_height = POSITION_LOOKUP[arg_2_1].z
end

EnemyCharacterStateCatapulted.on_exit = function (self, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5, arg_3_6)
	-- function 3
	local _direction = self._direction

	self._direction = nil

	self._status_extension:set_catapulted(false)
	self._first_person_extension:unhide_weapons("catapulted")
	self._locomotion_extension:reset_maximum_upwards_velocity()

	if not Managers.state.network:game() then
		local flag = false

		CharacterStateHelper.show_inventory_3p(arg_3_1, true, flag, self._is_server, self._inventory_extension)
		CharacterStateHelper.play_animation_event(arg_3_1, "idle")
	end

	self._status_extension:set_falling_height(nil, self.start_catapulted_height)
end

EnemyCharacterStateCatapulted.update = function (self, arg_4_1, arg_4_2, arg_4_3, arg_4_4, arg_4_5)
	-- function 4
	local _csm = self._csm
	local _unit = self._unit
	local _world = self._world
	local _input_extension = self._input_extension
	local _status_extension = self._status_extension

	if POSITION_LOOKUP[_unit].z < -240 then
		print("Player has fallen outside the world -- kill meeeee ", POSITION_LOOKUP[_unit].z)

		local go_id = self._unit_storage:go_id(_unit)

		self._network_transmit:send_rpc_server("rpc_suicide", go_id)
	end

	if not CharacterStateHelper.is_dead(_status_extension) then
		_csm:change_state("dead")

		return
	end

	if not CharacterStateHelper.is_in_vortex(_status_extension) then
		_csm:change_state("in_vortex")

		return
	end

	if not (not CharacterStateHelper.is_colliding_down(_unit) and not (self._locomotion_extension:current_velocity().z < 0)) then
		local str = "idle"

		CharacterStateHelper.play_animation_event(_unit, str)

		if not CharacterStateHelper.has_move_input(_input_extension) then
			_csm:change_state("walking")
		else
			_csm:change_state("standing")
		end

		return
	end

	if not (not CharacterStateHelper.is_colliding_down(_unit) and not self._locomotion_extension:is_on_ground() and not (self._locomotion_extension:current_velocity().z >= 0)) then
		local str_2 = "idle"

		CharacterStateHelper.play_animation_event(_unit, str_2)

		if not CharacterStateHelper.has_move_input(_input_extension) then
			_csm:change_state("walking")
		else
			_csm:change_state("standing")
		end

		self._locomotion_extension:add_external_velocity(self._locomotion_extension:current_velocity() * 0.2)

		return
	end

	if not CharacterStateHelper.is_colliding_sides(_unit) then
		local str_3 = "idle"

		CharacterStateHelper.play_animation_event(_unit, str_3)
		_csm:change_state("standing")

		return
	end

	local _first_person_extension = self._first_person_extension

	CharacterStateHelper.look(_input_extension, self._player.viewport_name, _first_person_extension, _status_extension, self._inventory_extension)
end
