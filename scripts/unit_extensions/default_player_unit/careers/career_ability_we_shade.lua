-- chunkname: @scripts/unit_extensions/default_player_unit/careers/career_ability_we_shade.lua

CareerAbilityWEShade = class(CareerAbilityWEShade)

CareerAbilityWEShade.init = function (self, arg_1_1, arg_1_2, arg_1_3)
	-- function 1
	self._owner_unit = arg_1_2
	self._world = arg_1_1.world
	self._wwise_world = Managers.world:wwise_world(self._world)

	local player = arg_1_3.player

	self._player = player
	self._is_server = player.is_server
	self._local_player = player.local_player
	self._bot_player = player.bot_player
	self._network_manager = Managers.state.network
	self._input_manager = Managers.input
end

CareerAbilityWEShade.extensions_ready = function (self, arg_2_1, arg_2_2)
	-- function 2
	self._status_extension = ScriptUnit.extension(arg_2_2, "status_system")
	self._career_extension = ScriptUnit.extension(arg_2_2, "career_system")
	self._buff_extension = ScriptUnit.extension(arg_2_2, "buff_system")
	self._buff_system = Managers.state.entity:system("buff_system")
	self._input_extension = ScriptUnit.has_extension(arg_2_2, "input_system")
	self._first_person_extension = ScriptUnit.has_extension(arg_2_2, "first_person_system")
end

CareerAbilityWEShade.destroy = function (arg_3_0)
	-- function 3
	return
end

CareerAbilityWEShade.update = function (self, arg_4_1, arg_4_2, arg_4_3, arg_4_4, arg_4_5)
	-- function 4
	if not self:_ability_available() then
		return
	end

	local _input_extension = self._input_extension

	if not _input_extension and not _input_extension:get("action_career") then
		self:_run_ability()
	end
end

CareerAbilityWEShade.stop = function (self, arg_5_1)
	-- function 5
	if not self._is_priming then
		self:_stop_priming()
	end
end

CareerAbilityWEShade._ability_available = function (self)
	-- function 6
	local _career_extension = self._career_extension
	local _status_extension = self._status_extension
	local flag = true

	if not flag then
		-- Nothing
	end

	::label_6_0::

	local can_use_activated_ability = _career_extension:can_use_activated_ability()

	can_use_activated_ability = not can_use_activated_ability and not _status_extension:is_disabled()

	::label_6_1::

	return can_use_activated_ability
end

CareerAbilityWEShade._run_ability = function (self)
	-- function 7
	local _owner_unit = self._owner_unit
	local _bot_player = self._bot_player
	local _network_manager = self._network_manager
	local network_transmit = _network_manager.network_transmit
	local _buff_extension = self._buff_extension
	local _career_extension = self._career_extension
	local _status_extension = self._status_extension
	local is_invisible = _status_extension:is_invisible()
	local str = "kerillian_shade_activated_ability"

	if not ScriptUnit.extension(self._owner_unit, "talent_system"):has_talent("kerillian_shade_activated_ability_phasing") then
		str = "kerillian_shade_activated_ability_phasing"
	end

	_buff_extension:add_buff(str)

	local _first_person_extension = self._first_person_extension

	_first_person_extension:play_hud_sound_event("Play_career_ability_kerillian_shade_enter", nil, true)
	_first_person_extension:play_remote_hud_sound_event("Play_career_ability_kerillian_shade_loop_husk")

	if not _bot_player then
		if not is_invisible then
			_first_person_extension:play_hud_sound_event("Play_career_ability_kerillian_shade_loop")
		end

		_first_person_extension:animation_event("shade_stealth_ability")
		_career_extension:set_state("kerillian_activate_shade")
	end

	if not Managers.state.network:game() then
		_status_extension:set_is_dodging(true)

		local unit_game_object_id = _network_manager:unit_game_object_id(_owner_unit)

		network_transmit:send_rpc_server("rpc_status_change_bool", NetworkLookup.statuses.dodging, true, unit_game_object_id, 0)
	end

	_career_extension:start_activated_ability_cooldown()
	self:_play_vo()
end

CareerAbilityWEShade._play_vo = function (self)
	-- function 8
	local _owner_unit = self._owner_unit
	local extension_input = ScriptUnit.extension_input(_owner_unit, "dialogue_system")
	local alloc_table = FrameTable.alloc_table()

	extension_input:trigger_networked_dialogue_event("activate_ability", alloc_table)
end
