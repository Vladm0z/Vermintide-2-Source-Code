-- chunkname: @scripts/unit_extensions/default_player_unit/careers/career_ability_sorcerer_teleport.lua

CareerAbilitySorcererTeleport = class(CareerAbilitySorcererTeleport)

CareerAbilitySorcererTeleport.init = function (self, arg_1_1, arg_1_2, arg_1_3, arg_1_4)
	-- function 1
	self._unit = arg_1_2
	self._world = arg_1_1.world
	self._wwise_world = Managers.world:wwise_world(self._world)
	self._ability_data = arg_1_4

	local player = arg_1_3.player

	self._player = player
	self._is_server = player.is_server
	self._local_player = player.local_player
	self._bot_player = player.bot_player
	self._network_manager = Managers.state.network
	self._input_manager = Managers.input
	self._is_priming = false
end

CareerAbilitySorcererTeleport.extensions_ready = function (self, arg_2_1, arg_2_2)
	-- function 2
	self._first_person_extension = ScriptUnit.has_extension(arg_2_2, "first_person_system")
	self._status_extension = ScriptUnit.extension(arg_2_2, "status_system")
	self._career_extension = ScriptUnit.extension(arg_2_2, "career_system")
	self._buff_extension = ScriptUnit.extension(arg_2_2, "buff_system")
	self._locomotion_extension = ScriptUnit.extension(arg_2_2, "locomotion_system")
	self._input_extension = ScriptUnit.has_extension(arg_2_2, "input_system")
	self._inventory_extension = ScriptUnit.has_extension(arg_2_2, "inventory_system")
	self._ghost_mode_extension = ScriptUnit.has_extension(arg_2_2, "ghost_mode_system")
	self._ability_input = self._ability_data.input_action

	if not self._first_person_extension then
		self._first_person_unit = self._first_person_extension:get_first_person_unit()
	end
end

CareerAbilitySorcererTeleport.destroy = function (arg_3_0)
	-- function 3
	return
end

CareerAbilitySorcererTeleport._ability_available = function (self)
	-- function 4
	local _career_extension = self._career_extension
	local _status_extension = self._status_extension
	local _locomotion_extension = self._locomotion_extension
	local is_in_ghost_mode = self._ghost_mode_extension:is_in_ghost_mode()
	local can_use_activated_ability = _career_extension:can_use_activated_ability()

	if not can_use_activated_ability then
		if not _status_extension:is_disabled() then
			can_use_activated_ability = _locomotion_extension:is_on_ground()

			if not can_use_activated_ability then
				can_use_activated_ability = not is_in_ghost_mode
			end
		else
			can_use_activated_ability = false
		end
	end

	if false then
		can_use_activated_ability = true
	end

	return can_use_activated_ability
end

CareerAbilitySorcererTeleport.update = function (self, arg_5_1, arg_5_2, arg_5_3, arg_5_4, arg_5_5)
	-- function 5
	if not self:_ability_available() then
		return
	end

	local _input_extension = self._input_extension

	if not _input_extension then
		return
	end

	if not _input_extension:get(self._ability_input) then
		self._status_extension.do_sorcerer_teleport = true
	end
end

CareerAbilitySorcererTeleport.finish = function (arg_6_0, arg_6_1)
	-- function 6
	return
end

CareerAbilitySorcererTeleport.stop = function (arg_7_0, arg_7_1)
	-- function 7
	return
end
