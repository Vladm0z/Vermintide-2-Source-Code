-- chunkname: @scripts/unit_extensions/level/keep_decoration_painting_extension.lua

KeepDecorationPaintingExtension = class(KeepDecorationPaintingExtension)

KeepDecorationPaintingExtension.init = function (self, arg_1_1, arg_1_2, arg_1_3)
	-- function 1
	local world = arg_1_1.world
	local current_level = LevelHelper:current_level(world)

	self.keep_decoration_system = nil
	self._decoration_settings_key = Unit.get_data(arg_1_2, "decoration_settings_key")
	self._unit = arg_1_2
	self._world = world
	self._level_unit_index = Level.unit_index(current_level, arg_1_2)
	self._is_leader = Managers.party:is_leader(Network.peer_id())

	local keep_decoration_paintings = NetworkLookup.keep_decoration_paintings

	keep_decoration_paintings = keep_decoration_paintings or {}
	self._paintings_lookup = keep_decoration_paintings
	self._is_client_painting = Unit.get_data(arg_1_2, "painting_data", "is_client_painting")
	self._currently_set_painting = nil
	self._temporarily_set_frame = nil
	self._temporarily_set_orientation = nil
	self._is_hidden = nil
	self._painting_unit = nil
	self._start_hidden = Unit.get_data(arg_1_2, "painting_data", "start_hidden")
	self._slow_update_count = 0
	self._slot = nil
	self._loading_painting_material = nil
	self._next_painting = {}

	local get_data = Unit.get_data(arg_1_2, "decoration_settings_key")
	local var_1_4 = KeepDecorationSettings[get_data]

	self._settings = var_1_4
	self._backend_key = var_1_4.backend_key
end

KeepDecorationPaintingExtension.interacted_with = function (arg_2_0)
	-- function 2
	return
end

KeepDecorationPaintingExtension.destroy = function (self)
	-- function 3
	local _painting_unit = self._painting_unit

	if not Unit.alive(_painting_unit) then
		World.destroy_unit(self._world, _painting_unit)
	end

	if not self._current_package_name then
		self:_unload_painting_material(self._current_package_name)

		self._current_package_name = nil
	end

	if not self._previous_package_name then
		self:_unload_painting_material(self._previous_package_name)

		self._previous_package_name = nil
	end

	self._unit = nil
	self._world = nil
	self._go_id = nil
end

KeepDecorationPaintingExtension.extensions_ready = function (self)
	-- function 4
	if not DLCSettings.gecko then
		return
	end

	Unit.set_unit_visibility(self._unit, false)

	if not self._is_leader then
		return
	end

	local flag

	flag = not self._is_client_painting and "hidden" and self:get_selected_decoration()
	self._current_preview_painting = flag

	local function fn()
		-- function 5
		if not Managers.state.network:in_game_session() then
			self:_create_game_object(flag)

			self._loading_painting_material = false
		else
			self._waiting_for_game_session = true
		end
	end

	self:_load_painting(flag, fn)
end

KeepDecorationPaintingExtension.get_settings = function (self)
	-- function 6
	return self._paintings_lookup
end

KeepDecorationPaintingExtension.can_interact = function (self)
	-- function 7
	if not DLCSettings.gecko then
		return false
	end

	return self._go_id
end

KeepDecorationPaintingExtension.decoration_selected = function (self, arg_8_1)
	-- function 8
	self:_load_painting(arg_8_1, nil)
end

KeepDecorationPaintingExtension.reset_selection = function (self)
	-- function 9
	local _current_preview_painting = self._current_preview_painting
	local _currently_set_painting = self._currently_set_painting

	if _currently_set_painting ~= _current_preview_painting then
		self:_load_painting(_currently_set_painting, nil)
	end

	self._current_preview_painting = nil
end

KeepDecorationPaintingExtension.unequip_decoration = function (self, arg_10_1)
	-- function 10
	local flag = arg_10_1 or "hor_none"

	self:_load_painting(flag)
	self:sync_decoration()
end

KeepDecorationPaintingExtension.confirm_selection = function (self)
	-- function 11
	local _current_preview_painting = self._current_preview_painting

	self.keep_decoration_system:on_painting_set(_current_preview_painting, self)
	self:sync_decoration()
end

KeepDecorationPaintingExtension.sync_decoration = function (self)
	-- function 12
	local _current_preview_painting = self._current_preview_painting

	self:_set_selected_painting(_current_preview_painting)

	local _go_id = self._go_id

	if not _go_id then
		local game = Managers.state.network:game()

		GameSession.set_game_object_field(game, _go_id, "painting_index", self._paintings_lookup[_current_preview_painting])
	end
end

KeepDecorationPaintingExtension.hot_join_sync = function (arg_13_0, arg_13_1)
	-- function 13
	return
end

KeepDecorationPaintingExtension.distributed_update = function (self)
	-- function 14
	if not self._is_leader then
		if not self._waiting_for_game_session and not Managers.state.network:in_game_session() then
			local get_selected_decoration = self:get_selected_decoration()

			self:_create_game_object(get_selected_decoration)

			self._waiting_for_game_session = false
		end
	else
		local _go_id = self._go_id

		if not _go_id then
			local game = Managers.state.network:game()
			local game_object_field = GameSession.game_object_field(game, _go_id, "painting_index")

			if game_object_field ~= self._go_painting_index then
				self._go_painting_index = game_object_field

				local var_14_4 = self._paintings_lookup[game_object_field]

				self._currently_set_painting = var_14_4

				self:_load_painting(var_14_4)
			end
		end
	end

	local _slow_update_count = self._slow_update_count

	if _slow_update_count > 25 then
		_slow_update_count = 0

		if not (not self._start_hidden and Unit.get_data(self._unit, "painting_data", "start_hidden")) then
			self._start_hidden = false

			local _currently_set_painting = self._currently_set_painting

			Unit.set_unit_visibility(self._unit, false)
			self:_load_painting(_currently_set_painting, nil)
			self:_show_painting()
		end
	end

	self._slow_update_count = _slow_update_count + 1

	if self._loading_painting_material or not self._next_painting.name then
		local name = self._next_painting.name
		local cb_done = self._next_painting.cb_done

		table.clear(self._next_painting)
		self:_load_painting_material(name, cb_done)
	end
end

KeepDecorationPaintingExtension.set_client_painting = function (self, arg_15_1)
	-- function 15
	self:_load_painting(arg_15_1)
	self:_set_selected_painting(arg_15_1)

	local _go_id = self._go_id

	if not _go_id then
		local game = Managers.state.network:game()

		GameSession.set_game_object_field(game, _go_id, "painting_index", self._paintings_lookup[arg_15_1])
	end
end

KeepDecorationPaintingExtension.is_client_painting = function (self)
	-- function 16
	return self._is_client_painting
end

KeepDecorationPaintingExtension._hide_painting = function (self)
	-- function 17
	self._is_hidden = true

	Unit.set_data(self._unit, "painting_data", "not_interactable", true)
	Unit.set_unit_visibility(self._painting_unit, false)
end

KeepDecorationPaintingExtension._show_painting = function (self)
	-- function 18
	self._is_hidden = false

	Unit.set_data(self._unit, "painting_data", "not_interactable", false)
	Unit.set_unit_visibility(self._painting_unit, true)
end

KeepDecorationPaintingExtension.get_selected_decoration = function (self)
	-- function 19
	if not self._is_leader then
		local _backend_key = self._backend_key
		local get_decoration = Managers.backend:get_interface("keep_decorations"):get_decoration(_backend_key)

		if not (not get_decoration and Paintings[get_decoration]) then
			get_decoration = DefaultPaintings[1]
		end

		self._currently_set_painting = get_decoration

		return get_decoration
	else
		return self._currently_set_painting
	end
end

KeepDecorationPaintingExtension._set_selected_painting = function (self, arg_20_1)
	-- function 20
	local _backend_key = self._backend_key
	local backend = Managers.backend
	local get_interface = backend:get_interface("keep_decorations")

	self._currently_set_painting = arg_20_1

	get_interface:set_decoration(_backend_key, arg_20_1)
	backend:commit()
end

KeepDecorationPaintingExtension._load_painting = function (self, arg_21_1, arg_21_2)
	-- function 21
	arg_21_1 = arg_21_1 or "hor_none"

	local var_21_0 = Paintings[arg_21_1]
	local orientation = var_21_0.orientation
	local frame = var_21_0.frame

	self._current_preview_painting = arg_21_1

	if orientation == "vertical" then
		self._slot = "keep_painting_ver_none"
	elseif orientation == "horizontal" then
		self._slot = "keep_painting_hor_none"
	end

	if not (self._temporarily_set_frame ~= frame or self._temporarily_set_orientation == orientation) then
		self:_load_painting_frame(var_21_0)
	end

	if arg_21_1 ~= "hidden" then
		self:_load_painting_material(arg_21_1, arg_21_2, self._slot)

		if not self._is_hidden then
			self:_show_painting()
		end
	else
		self:_load_painting_material("hor_none", arg_21_2, self._slot)
		self:_hide_painting()
	end

	if not self._start_hidden then
		self:_hide_painting()
	end
end

KeepDecorationPaintingExtension._load_painting_frame = function (self, arg_22_1)
	-- function 22
	local orientation = arg_22_1.orientation
	local frame = arg_22_1.frame
	local var_22_2
	local _unit = self._unit
	local local_position = Unit.local_position(_unit, 0)
	local local_rotation = Unit.local_rotation(_unit, 0)
	local local_scale = Unit.local_scale(_unit, 0)

	if orientation == "horizontal" then
		if frame == "wood" then
			var_22_2 = World.spawn_unit(self._world, "units/gameplay/paintings/keep_painting_wood_long", local_position, local_rotation)
		elseif frame == "painted" then
			var_22_2 = World.spawn_unit(self._world, "units/gameplay/paintings/keep_painting_painted_long", local_position, local_rotation)
		elseif frame == "gold" then
			var_22_2 = World.spawn_unit(self._world, "units/gameplay/paintings/keep_painting_gold_long", local_position, local_rotation)
		end
	elseif orientation == "vertical" then
		if frame == "wood" then
			var_22_2 = World.spawn_unit(self._world, "units/gameplay/paintings/keep_painting_wood_high", local_position, local_rotation)
		elseif frame == "painted" then
			var_22_2 = World.spawn_unit(self._world, "units/gameplay/paintings/keep_painting_painted_high", local_position, local_rotation)
		elseif frame == "gold" then
			var_22_2 = World.spawn_unit(self._world, "units/gameplay/paintings/keep_painting_gold_high", local_position, local_rotation)
		end
	end

	Unit.set_local_scale(var_22_2, 0, local_scale)

	self._temporarily_set_frame = frame
	self._temporarily_set_orientation = orientation

	local _painting_unit = self._painting_unit

	if not _painting_unit then
		World.destroy_unit(self._world, _painting_unit)
	end

	self._painting_unit = var_22_2
end

KeepDecorationPaintingExtension._load_painting_material = function (self, arg_23_1, arg_23_2)
	-- function 23
	local str = "keep_painting_" .. arg_23_1
	local flag = string.find(arg_23_1, "_none") ~= nil
	local var_23_2
	local _decoration_settings_key = self._decoration_settings_key

	if not flag then
		var_23_2 = "resource_packages/keep_paintings/" .. str
	end

	local _current_package_name = self._current_package_name

	local function fn()
		-- function 24
		self:_apply_material_by_sub_path(str)

		if not arg_23_2 then
			arg_23_2()
		end

		self._loading_painting_material = false

		if not _current_package_name then
			self:_unload_painting_material(_current_package_name)

			self._previous_package_name = nil
		end
	end

	if not self._loading_painting_material then
		self._loading_painting_material = true
		self._previous_package_name = self._current_package_name
		self._current_package_name = var_23_2

		if not flag then
			fn()
		else
			Managers.package:load(var_23_2, _decoration_settings_key, fn, true)
		end
	else
		self._next_painting.name = arg_23_1
		self._next_painting.cb_done = arg_23_2
	end
end

KeepDecorationPaintingExtension._apply_material_by_sub_path = function (self, arg_25_1)
	-- function 25
	local _painting_unit = self._painting_unit

	if not Unit.alive(_painting_unit) then
		local str = "units/gameplay/keep_paintings/materials/" .. arg_25_1 .. "/" .. arg_25_1
		local _slot = self._slot

		Unit.set_material(_painting_unit, _slot, str)
	end
end

KeepDecorationPaintingExtension._unload_painting_material = function (self, arg_26_1)
	-- function 26
	local _decoration_settings_key = self._decoration_settings_key

	if Managers.package:reference_count(arg_26_1, _decoration_settings_key) > 0 then
		Managers.package:unload(arg_26_1, _decoration_settings_key)
	end
end

KeepDecorationPaintingExtension._create_game_object = function (self, arg_27_1)
	-- function 27
	local tbl = {
		go_type = NetworkLookup.go_types.keep_decoration_painting,
		level_unit_index = self._level_unit_index,
		painting_index = self._paintings_lookup[arg_27_1]
	}
	local var_27_1 = callback(self, "cb_game_session_disconnect")

	self._go_id = Managers.state.network:create_game_object("keep_decoration_painting", tbl, var_27_1)
end

KeepDecorationPaintingExtension.cb_game_session_disconnect = function (self)
	-- function 28
	self._go_id = nil
end

KeepDecorationPaintingExtension.on_game_object_created = function (self, arg_29_1)
	-- function 29
	local game = Managers.state.network:game()
	local game_object_field = GameSession.game_object_field(game, arg_29_1, "painting_index")
	local var_29_2 = self._paintings_lookup[game_object_field]

	self:_load_painting(var_29_2, nil)

	self._currently_set_painting = var_29_2
	self._go_painting_index = game_object_field
	self._go_id = arg_29_1
end

KeepDecorationPaintingExtension.on_game_object_destroyed = function (self)
	-- function 30
	self._go_id = nil
end
