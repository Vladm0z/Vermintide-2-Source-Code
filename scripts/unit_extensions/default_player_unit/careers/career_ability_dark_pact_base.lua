-- chunkname: @scripts/unit_extensions/default_player_unit/careers/career_ability_dark_pact_base.lua

CareerAbilityDarkPactBase = class(CareerAbilityDarkPactBase)

CareerAbilityDarkPactBase.init = function (self, arg_1_1, arg_1_2, arg_1_3, arg_1_4)
	-- function 1
	self._unit = arg_1_2
	self._world = arg_1_1.world
	self._wwise_world = Managers.world:wwise_world(self._world)
	self._physics_world = World.physics_world(self._world)
	self._ability_data = arg_1_4

	local player = arg_1_3.player

	self._player = player
	self._is_server = player.is_server
	self._local_player = player.local_player
	self._bot_player = player.bot_player
	self._network_manager = Managers.state.network
	self._input_manager = Managers.input
end

CareerAbilityDarkPactBase.destroy = function (arg_2_0)
	-- function 2
	return
end

CareerAbilityDarkPactBase.extensions_ready = function (self, arg_3_1, arg_3_2)
	-- function 3
	self._first_person_extension = ScriptUnit.has_extension(arg_3_2, "first_person_system")
	self._status_extension = ScriptUnit.extension(arg_3_2, "status_system")
	self._career_extension = ScriptUnit.extension(arg_3_2, "career_system")
	self._locomotion_extension = ScriptUnit.extension(arg_3_2, "locomotion_system")
	self._input_extension = ScriptUnit.has_extension(arg_3_2, "input_system")
	self._ghost_mode_extension = ScriptUnit.has_extension(arg_3_2, "ghost_mode_system")
	self._inventory_extension = ScriptUnit.extension(arg_3_2, "inventory_system")
	self._is_server = Managers.player.is_server
	self._ability_input = self._ability_data.input_action

	if not self._first_person_extension then
		self._first_person_unit = self._first_person_extension:get_first_person_unit()
	end
end

CareerAbilityDarkPactBase.update = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4, arg_4_5)
	-- function 4
	return
end

CareerAbilityDarkPactBase.was_triggered = function (self)
	-- function 5
	local _input_extension = self._input_extension

	if not _input_extension then
		return false
	end

	if not _input_extension:get(self._ability_input) then
		if not self:_ability_available() then
			self:_play_sound("versus_hud_ability_not_ready")

			return false
		end

		self:_start()

		return true
	end

	return false
end

CareerAbilityDarkPactBase.finish = function (arg_6_0, arg_6_1)
	-- function 6
	return
end

CareerAbilityDarkPactBase.stop = function (arg_7_0, arg_7_1)
	-- function 7
	return
end

CareerAbilityDarkPactBase.ability_ready = function (self)
	-- function 8
	local _first_person_extension = self._first_person_extension

	if not _first_person_extension then
		_first_person_extension:play_hud_sound_event("Play_hud_ability_ready")
	end

	self:_cooldown_ready()
	self._status_extension:set_unarmed(false)
end

CareerAbilityDarkPactBase._cooldown_ready = function (self)
	-- function 9
	local equipment = self._inventory_extension:equipment()
	local right_hand_wielded_unit = equipment.right_hand_wielded_unit

	right_hand_wielded_unit = right_hand_wielded_unit or equipment.left_hand_wielded_unit

	if not right_hand_wielded_unit then
		Unit.flow_event(right_hand_wielded_unit, "cooldown_ready")
	end
end

CareerAbilityDarkPactBase.ability_available = function (self)
	-- function 10
	return self:_ability_available()
end

CareerAbilityDarkPactBase._ability_available = function (self)
	-- function 11
	local _career_extension = self._career_extension
	local _status_extension = self._status_extension
	local _locomotion_extension = self._locomotion_extension
	local is_in_ghost_mode = self._ghost_mode_extension:is_in_ghost_mode()

	return not (not not _status_extension:is_disabled() or not is_in_ghost_mode) and _career_extension:can_use_activated_ability(self._ability_data.ability_id)
end

CareerAbilityDarkPactBase._start = function (self)
	-- function 12
	self:_play_vo()
end

CareerAbilityDarkPactBase._play_vo = function (self)
	-- function 13
	local _unit = self._unit
	local extension_input = ScriptUnit.extension_input(_unit, "dialogue_system")
	local alloc_table = FrameTable.alloc_table()

	extension_input:trigger_networked_dialogue_event("activate_ability", alloc_table)
end

CareerAbilityDarkPactBase._play_sound = function (self, arg_14_1)
	-- function 14
	WwiseWorld.trigger_event(self._wwise_world, arg_14_1)
end
