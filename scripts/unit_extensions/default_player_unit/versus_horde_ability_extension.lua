-- chunkname: @scripts/unit_extensions/default_player_unit/versus_horde_ability_extension.lua

VersusHordeAbilityExtension = class(VersusHordeAbilityExtension)

local num = 2

VersusHordeAbilityExtension.init = function (self, arg_1_1, arg_1_2, arg_1_3)
	-- function 1
	self.is_server = Managers.player.is_server
	self._horde_ability_system = Managers.state.entity:system("versus_horde_ability_system")
	self._settings = self._horde_ability_system:settings()
	self._unit = arg_1_2
	self.network_manager = Managers.state.network
	self._game = Managers.state.network:game()
	self._world = arg_1_1.world

	if not self.is_server then
		self:create_ability_game_object()

		self._ability_charge = 0
		self._cooldown_mod = 0
		self._boost_mod = 0
	end

	self._audio_system = Managers.state.entity:system("audio_system")
	self._cooldown = self._horde_ability_system:cooldown()
	self._pause_sync_until = 0
	self._own_peer_id = Network.peer_id()
end

VersusHordeAbilityExtension._activate = function (self, arg_2_1)
	-- function 2
	self._horde_ability_system:activate_dark_pact_horde_ability()

	self._pause_sync_until = arg_2_1 + num
	self._fully_charged = false

	if not self._unit and not POSITION_LOOKUP[self._unit] then
		self._audio_system:play_audio_position_event("Play_versus_pactsworn_horde_ability", POSITION_LOOKUP[self._unit])
	end

	local game_mode = Managers.state.game_mode

	game_mode = not game_mode and Managers.state.game_mode:game_mode()

	local local_player = Managers.player:local_player()

	if not local_player then
		game_mode:activated_ability_telemetry("versus_horde_ability", local_player)
	end
end

VersusHordeAbilityExtension.extensions_ready = function (self, arg_3_1, arg_3_2)
	-- function 3
	self._input_extension = ScriptUnit.has_extension(arg_3_2, "input_system")
	self._ghost_mode_extension = ScriptUnit.extension(arg_3_2, "ghost_mode_system")
end

VersusHordeAbilityExtension.update = function (self, arg_4_1)
	-- function 4
	if self._owner_peer_id ~= self._own_peer_id then
		return
	end

	if arg_4_1 < self._pause_sync_until then
		return
	end

	local flag = self:get_ability_charge(arg_4_1) >= self:cooldown()

	if not (not flag and self._fully_charged) then
		self._audio_system:play_sound_local("Play_versus_pactsworn_horde_ability_ready")

		self._fully_charged = true
	end

	local _input_extension = self._input_extension

	_input_extension = not _input_extension and self._input_extension:get("versus_horde_ability")

	local is_in_ghost_mode = self._ghost_mode_extension:is_in_ghost_mode()
	local flag_2 = not flag and self._horde_ability_system:is_activation_allowed(is_in_ghost_mode)

	if not _input_extension then
		if not flag_2 then
			self:_activate(arg_4_1)
		else
			local wwise_world = Managers.world:wwise_world(self._world)

			WwiseWorld.trigger_event(wwise_world, "versus_hud_ability_not_ready")
		end
	end
end

VersusHordeAbilityExtension.destroy = function (self)
	-- function 5
	if not self.network_manager:game() and not self.is_server then
		self.network_manager:destroy_game_object(self._ability_go_id)

		self._ability_go_id = nil
	end
end

VersusHordeAbilityExtension.create_ability_game_object = function (self)
	-- function 6
	fassert(self.is_server, "Trying to create ability game object on a client")

	local _unit = self._unit
	local unit_game_object_id = self.network_manager:unit_game_object_id(_unit)
	local tbl = {
		cooldown_mod = 0,
		ability_charge = 0,
		boost_mod = 0,
		go_type = NetworkLookup.go_types.dark_pact_horde_ability,
		unit_game_object_id = unit_game_object_id
	}
	local var_6_3 = callback(self, "cb_game_session_disconnect")
	local create_game_object = self.network_manager:create_game_object("dark_pact_horde_ability", tbl, var_6_3)

	self:set_ability_game_object_id(create_game_object)
end

VersusHordeAbilityExtension.set_ability_game_object_id = function (self, arg_7_1)
	-- function 7
	self._ability_go_id = arg_7_1
end

VersusHordeAbilityExtension.get_ability_charge = function (self, arg_8_1)
	-- function 8
	if not self.is_server then
		return self._ability_charge
	end

	if arg_8_1 < self._pause_sync_until then
		return 0
	end

	if not self._game and not self._ability_go_id then
		return (GameSession.game_object_field(self._game, self._ability_go_id, "ability_charge"))
	end

	return 0
end

VersusHordeAbilityExtension.get_charge_modifiers = function (self)
	-- function 9
	local num = 0
	local num_2 = 0

	if not self._game and not self._ability_go_id then
		if not self.is_server then
			num = self._cooldown_mod
			num_2 = self._boost_mod
		else
			num = GameSession.game_object_field(self._game, self._ability_go_id, "cooldown_mod")
			num_2 = GameSession.game_object_field(self._game, self._ability_go_id, "boost_mod")
		end
	end

	return num, num_2
end

VersusHordeAbilityExtension.server_set_ability_charge = function (self, arg_10_1, arg_10_2, arg_10_3)
	-- function 10
	arg_10_2 = arg_10_2 * 100
	arg_10_3 = arg_10_3 * 100

	if not self._game and not self._ability_go_id then
		GameSession.set_game_object_field(self._game, self._ability_go_id, "ability_charge", arg_10_1)
		GameSession.set_game_object_field(self._game, self._ability_go_id, "cooldown_mod", arg_10_2)
		GameSession.set_game_object_field(self._game, self._ability_go_id, "boost_mod", arg_10_3)
	end

	if not self.is_server then
		self._ability_charge = arg_10_1
		self._cooldown_mod = arg_10_2
		self._boost_mod = arg_10_3
	end
end

VersusHordeAbilityExtension.cooldown = function (self)
	-- function 11
	return self._cooldown
end

VersusHordeAbilityExtension.cb_game_session_disconnect = function (arg_12_0)
	-- function 12
	return
end

VersusHordeAbilityExtension.unit = function (self)
	-- function 13
	return self._unit
end

VersusHordeAbilityExtension.game_object_initialized = function (self, arg_14_1, arg_14_2)
	-- function 14
	local game = Managers.state.network:game()

	self._go_id = arg_14_2
	self._owner_peer_id = GameSession.game_object_field(game, arg_14_2, "owner_peer_id")
end
