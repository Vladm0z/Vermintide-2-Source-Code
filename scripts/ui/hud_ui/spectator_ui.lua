-- chunkname: @scripts/ui/hud_ui/spectator_ui.lua

SpectatorUI = class(SpectatorUI)

SpectatorUI.init = function (self, arg_1_1, arg_1_2)
	-- function 1
	self._parent = arg_1_1
	self._ui_renderer = arg_1_2.ui_renderer
	self._ingame_ui = arg_1_2.ingame_ui
	self._input_manager = arg_1_2.input_manager
	self._player_manager = arg_1_2.player_manager
	self._ui_animations = {}
	self._render_settings = {
		snap_pixel_positions = true
	}
	self._text = ""

	local world = arg_1_2.world_manager:world("level_world")

	self._wwise_world = Managers.world:wwise_world(world)

	local event = Managers.state.event

	event:register(self, "on_spectator_target_changed", "on_spectator_target_changed")
	event:register(self, "new_player_unit", "on_player_spawned")

	self._marker_ids = {}
end

SpectatorUI.destroy = function (self)
	-- function 2
	print("[SpectatorUI] - Destroy")

	local event = Managers.state.event

	event:unregister("on_spectator_target_changed", self)
	event:unregister("new_player_unit", self)
	self:set_visible(false)
end

SpectatorUI.update = function (self, arg_3_1, arg_3_2)
	-- function 3
	if not self._is_visible then
		return
	end

	self:draw(arg_3_1, arg_3_2)
end

SpectatorUI.draw = function (arg_4_0, arg_4_1, arg_4_2)
	-- function 4
	return
end

SpectatorUI.set_dirty = function (self)
	-- function 5
	self._dirty = true
end

SpectatorUI.set_visible = function (self, arg_6_1)
	-- function 6
	self._is_visible = arg_6_1

	if not arg_6_1 then
		local _get_actual_players = self:_get_actual_players()

		for k, v in pairs(_get_actual_players) do
			local player_unit = v.player_unit

			if not player_unit then
				self:_add_world_marker(player_unit)
			end
		end
	else
		self:_clear_world_markers()
	end
end

SpectatorUI._get_actual_players = function (arg_7_0)
	-- function 7
	local tbl = {}
	local parties = Managers.party:parties()

	for k, v in pairs(parties) do
		if v.name ~= "spectators" then
			local occupied_slots = v.occupied_slots

			for k_2, v_2 in pairs(occupied_slots) do
				tbl[#tbl + 1] = v_2.player
			end
		end
	end

	return tbl
end

SpectatorUI._add_world_marker = function (self, arg_8_1)
	-- function 8
	local var_8_0 = self._marker_ids[arg_8_1]

	if not var_8_0 then
		self:_clear_world_marker(arg_8_1, var_8_0)
	end

	local var_8_1 = callback(self, "cb_world_marker_spawned", arg_8_1)

	Managers.state.event:trigger("add_world_marker_unit", "versus_pactsworn_ghostmode", arg_8_1, var_8_1)
end

SpectatorUI._clear_world_markers = function (self)
	-- function 9
	for k, v in pairs(self._marker_ids) do
		self:_clear_world_marker(k, v)
	end
end

SpectatorUI._clear_world_marker = function (arg_10_0, arg_10_1, arg_10_2)
	-- function 10
	Managers.state.event:trigger("remove_world_marker", arg_10_2)

	arg_10_0._marker_ids[arg_10_1] = nil
end

SpectatorUI.on_spectator_target_changed = function (self, arg_11_1)
	-- function 11
	self._spectated_player_unit = arg_11_1
	self._spectated_player = Managers.player:owner(arg_11_1)
	self._is_spectator = true
	self._text = "Spectating: " .. self._spectated_player:name()
end

SpectatorUI.on_player_spawned = function (self, arg_12_1, arg_12_2, arg_12_3)
	-- function 12
	if not self._is_visible then
		return
	end

	self:_add_world_marker(arg_12_2)
end

SpectatorUI.cb_world_marker_spawned = function (arg_13_0, arg_13_1, arg_13_2, arg_13_3)
	-- function 13
	local profile_index = Managers.player:owner(arg_13_1):profile_index()
	local var_13_1 = SPProfiles[profile_index]

	arg_13_3.content.icon = var_13_1.ui_portrait
	arg_13_0._marker_ids[arg_13_1] = arg_13_2
end
