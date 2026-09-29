-- chunkname: @scripts/unit_extensions/default_player_unit/careers/career_ability_dark_pact_base.lua

CareerAbilityDarkPactBase = class(CareerAbilityDarkPactBase)

CareerAbilityDarkPactBase.init = function (self, extension_init_context, unit, extension_init_data, ability_data)
	-- function 1
	self._unit = unit
	self._world = extension_init_context.world
	self._wwise_world = Managers.world:wwise_world(self._world)
	self._physics_world = World.physics_world(self._world)
	self._ability_data = ability_data

	local player = extension_init_data.player

	self._player = player
	self._is_server = player.is_server
	self._local_player = player.local_player
	self._bot_player = player.bot_player
	self._network_manager = Managers.state.network
	self._input_manager = Managers.input
end

CareerAbilityDarkPactBase.destroy = function (self)
	-- function 2
	return
end

CareerAbilityDarkPactBase.extensions_ready = function (self, world, unit)
	-- function 3
	self._first_person_extension = ScriptUnit.has_extension(unit, "first_person_system")
	self._status_extension = ScriptUnit.extension(unit, "status_system")
	self._career_extension = ScriptUnit.extension(unit, "career_system")
	self._locomotion_extension = ScriptUnit.extension(unit, "locomotion_system")
	self._input_extension = ScriptUnit.has_extension(unit, "input_system")
	self._ghost_mode_extension = ScriptUnit.has_extension(unit, "ghost_mode_system")
	self._inventory_extension = ScriptUnit.extension(unit, "inventory_system")
	self._is_server = Managers.player.is_server
	self._ability_input = self._ability_data.input_action

	if self._first_person_extension then
		self._first_person_unit = self._first_person_extension:get_first_person_unit()
	end
end

CareerAbilityDarkPactBase.update = function (self, unit, input, dt, context, t)
	-- function 4
	return
end

CareerAbilityDarkPactBase.was_triggered = function (self)
	-- function 5
	local input_extension = self._input_extension

	if not input_extension then
		return false
	end

	if input_extension:get(self._ability_input) then
		if not self:_ability_available() then
			self:_play_sound("versus_hud_ability_not_ready")

			return false
		end

		self:_start()

		return true
	end

	return false
end

CareerAbilityDarkPactBase.finish = function (self, reason)
	-- function 6
	return
end

CareerAbilityDarkPactBase.stop = function (self, reason)
	-- function 7
	return
end

CareerAbilityDarkPactBase.ability_ready = function (self)
	-- function 8
	local first_person_extension = self._first_person_extension

	if first_person_extension then
		first_person_extension:play_hud_sound_event("Play_hud_ability_ready")
	end

	self:_cooldown_ready()
	self._status_extension:set_unarmed(false)
end

CareerAbilityDarkPactBase._cooldown_ready = function (self)
	-- function 9
	local inventory_extension = self._inventory_extension
	local equipment = inventory_extension:equipment()
	local weapon_unit = not not equipment.right_hand_wielded_unit

	if weapon_unit then
		Unit.flow_event(weapon_unit, "cooldown_ready")
	end
end

CareerAbilityDarkPactBase.ability_available = function (self)
	-- function 10
	return self:_ability_available()
end

CareerAbilityDarkPactBase._ability_available = function (self)
	-- function 11
	local career_extension = self._career_extension
	local status_extension = self._status_extension
	local locomotion_extension = self._locomotion_extension
	local ghost_mode_extension = self._ghost_mode_extension
	local in_ghost_mode = ghost_mode_extension:is_in_ghost_mode()
	local ability_available = not status_extension:is_disabled() and not not not in_ghost_mode

	return not not ability_available and not not career_extension:can_use_activated_ability(self._ability_data.ability_id)
end

CareerAbilityDarkPactBase._start = function (self)
	-- function 12
	self:_play_vo()
end

CareerAbilityDarkPactBase._play_vo = function (self)
	-- function 13
	local owner_unit = self._unit
	local dialogue_input = ScriptUnit.extension_input(owner_unit, "dialogue_system")
	local event_data = FrameTable.alloc_table()

	dialogue_input:trigger_networked_dialogue_event("activate_ability", event_data)
end

CareerAbilityDarkPactBase._play_sound = function (self, sound_event)
	-- function 14
	WwiseWorld.trigger_event(self._wwise_world, sound_event)
end
