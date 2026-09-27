-- chunkname: @scripts/unit_extensions/level/keep_decoration_trophy_extension.lua

KeepDecorationTrophyExtension = class(KeepDecorationTrophyExtension)

KeepDecorationTrophyExtension.init = function (self, arg_1_1, arg_1_2, arg_1_3)
	-- function 1
	local world = arg_1_1.world
	local current_level = LevelHelper:current_level(world)

	self.keep_decoration_system = nil
	self._decoration_settings_key = Unit.get_data(arg_1_2, "decoration_settings_key")
	self._unit = arg_1_2
	self._current_preview_trophy_unit = arg_1_2
	self._world = world
	self._level_unit_index = Level.unit_index(current_level, arg_1_2)
	self._is_leader = Managers.party:is_leader(Network.peer_id())

	local keep_decoration_trophies = NetworkLookup.keep_decoration_trophies

	keep_decoration_trophies = keep_decoration_trophies or {}
	self._trophies_lookup = keep_decoration_trophies
	self._currently_set_trophy = nil
	self._is_hidden = nil
	self._next_trophy = {}

	local get_data = Unit.get_data(arg_1_2, "decoration_settings_key")
	local var_1_4 = KeepDecorationSettings[get_data]

	self._settings = var_1_4
	self._backend_key = var_1_4.backend_key
end

KeepDecorationTrophyExtension.interacted_with = function (arg_2_0)
	-- function 2
	return
end

KeepDecorationTrophyExtension.destroy = function (self)
	-- function 3
	self._unit = nil
	self._world = nil
	self._go_id = nil
end

KeepDecorationTrophyExtension.extensions_ready = function (self)
	-- function 4
	if not self._is_leader then
		return
	end

	local get_selected_decoration = self:get_selected_decoration()

	self._current_preview_trophy = get_selected_decoration

	self:_create_game_object(get_selected_decoration)

	self._currently_set_trophy = get_selected_decoration

	self:_load_trophy(get_selected_decoration)
end

KeepDecorationTrophyExtension.get_settings = function (self)
	-- function 5
	return self._trophies_lookup
end

KeepDecorationTrophyExtension.can_interact = function (self)
	-- function 6
	return self._go_id
end

KeepDecorationTrophyExtension.decoration_selected = function (self, arg_7_1)
	-- function 7
	self:_load_trophy(arg_7_1)
end

KeepDecorationTrophyExtension.reset_selection = function (self)
	-- function 8
	local _current_preview_trophy = self._current_preview_trophy
	local _currently_set_trophy = self._currently_set_trophy

	_currently_set_trophy = _currently_set_trophy or "hub_trophy_empty"

	if _currently_set_trophy ~= _current_preview_trophy then
		self:_load_trophy(_currently_set_trophy)
	end

	self._current_preview_trophy = nil
end

KeepDecorationTrophyExtension.unequip_decoration = function (self, arg_9_1)
	-- function 9
	local flag = arg_9_1 or "hub_trophy_empty"

	self:_load_trophy(flag)
	self:sync_decoration()
end

KeepDecorationTrophyExtension.confirm_selection = function (self)
	-- function 10
	local _current_preview_trophy = self._current_preview_trophy

	self.keep_decoration_system:on_decoration_set(_current_preview_trophy, self)
	self:sync_decoration()
end

KeepDecorationTrophyExtension.sync_decoration = function (self)
	-- function 11
	local _current_preview_trophy = self._current_preview_trophy

	self:_set_selected_decoration(_current_preview_trophy)

	local _go_id = self._go_id

	if not Network.game_session() and not _go_id then
		local game = Managers.state.network:game()

		GameSession.set_game_object_field(game, _go_id, "trophy_index", self._trophies_lookup[_current_preview_trophy])
	end
end

KeepDecorationTrophyExtension.hot_join_sync = function (arg_12_0, arg_12_1)
	-- function 12
	return
end

KeepDecorationTrophyExtension.distributed_update = function (self)
	-- function 13
	if not self._is_leader then
		if not self._waiting_for_game_session and not Managers.state.network:in_game_session() then
			local get_selected_decoration = self:get_selected_decoration()

			self:_create_game_object(get_selected_decoration)

			self._waiting_for_game_session = false
		end
	else
		local _go_id = self._go_id
		local game_session = Network.game_session()

		if not _go_id and not game_session then
			local game = Managers.state.network:game()
			local game_object_field = GameSession.game_object_field(game, _go_id, "trophy_index")

			if game_object_field ~= self._go_trophy_index then
				self._go_trophy_index = game_object_field

				local var_13_5 = self._trophies_lookup[game_object_field]

				self._currently_set_trophy = var_13_5

				self:_load_trophy(var_13_5)
			end
		end
	end
end

KeepDecorationTrophyExtension.get_selected_decoration = function (self)
	-- function 14
	if not self._is_leader then
		local _backend_key = self._backend_key
		local get_decoration = Managers.backend:get_interface("keep_decorations"):get_decoration(_backend_key)

		get_decoration = get_decoration or DefaultTrophies[1]

		return get_decoration
	else
		return self._currently_set_trophy
	end
end

KeepDecorationTrophyExtension._set_selected_decoration = function (self, arg_15_1)
	-- function 15
	local _backend_key = self._backend_key
	local backend = Managers.backend
	local get_interface = backend:get_interface("keep_decorations")

	self._currently_set_trophy = arg_15_1

	Unit.set_data(self._current_preview_trophy_unit, "decoration_settings_key", self._decoration_settings_key)
	get_interface:set_decoration(_backend_key, arg_15_1)
	backend:commit()
end

KeepDecorationTrophyExtension._load_trophy = function (self, arg_16_1, arg_16_2)
	-- function 16
	local _unit = self._unit
	local _current_preview_trophy_unit = self._current_preview_trophy_unit
	local local_position = Unit.local_position(_current_preview_trophy_unit, 0)
	local local_rotation = Unit.local_rotation(_current_preview_trophy_unit, 0)

	if _current_preview_trophy_unit == _unit then
		Unit.set_unit_visibility(_current_preview_trophy_unit, false)
	else
		World.destroy_unit(self._world, _current_preview_trophy_unit)
	end

	local unit_name = Trophies[arg_16_1].unit_name

	if not Unit.is_a(_unit, unit_name) then
		Unit.set_unit_visibility(_unit, true)

		self._current_preview_trophy_unit = _unit
	else
		self._current_preview_trophy_unit = World.spawn_unit(self._world, unit_name, local_position, local_rotation)
	end

	self._current_preview_trophy = arg_16_1
end

KeepDecorationTrophyExtension._create_game_object = function (self, arg_17_1)
	-- function 17
	local tbl = {
		go_type = NetworkLookup.go_types.keep_decoration_trophy,
		level_unit_index = self._level_unit_index,
		trophy_index = self._trophies_lookup[arg_17_1]
	}
	local var_17_1 = callback(self, "cb_game_session_disconnect")

	self._go_id = Managers.state.network:create_game_object("keep_decoration_trophy", tbl, var_17_1)
end

KeepDecorationTrophyExtension.cb_game_session_disconnect = function (self)
	-- function 18
	self._go_id = nil
end

KeepDecorationTrophyExtension.on_game_object_created = function (self, arg_19_1)
	-- function 19
	local game = Managers.state.network:game()
	local game_object_field = GameSession.game_object_field(game, arg_19_1, "trophy_index")
	local var_19_2 = self._trophies_lookup[game_object_field]

	self:_load_trophy(var_19_2, nil)

	self._currently_set_trophy = var_19_2
	self._go_trophy_index = game_object_field
	self._go_id = arg_19_1
end

KeepDecorationTrophyExtension.on_game_object_destroyed = function (self)
	-- function 20
	self._go_id = nil
end
