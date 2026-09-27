-- chunkname: @scripts/imgui/imgui_shrines_debug.lua

ImguiShrinesDebug = class(ImguiShrinesDebug)

local flag = true

ImguiShrinesDebug.init = function (arg_1_0)
	-- function 1
	return
end

ImguiShrinesDebug.update = function (self)
	-- function 2
	if not flag then
		self:init()

		flag = false
	end
end

ImguiShrinesDebug.is_persistent = function (arg_3_0)
	-- function 3
	return true
end

ImguiShrinesDebug.draw = function (self, arg_4_1)
	-- function 4
	if not (not Managers.state and not Managers.state.game_mode and Managers.state.game_mode:game_mode_key() == "deus") then
		local begin_window = Imgui.begin_window("Shrines Debug", "always_auto_resize")

		Imgui.text("This UI only works when playing a deus level.")
		Imgui.end_window()

		return begin_window
	end

	local begin_window_2 = Imgui.begin_window("Shrines Debug", "always_auto_resize")

	self:_update_controls()
	Imgui.end_window()

	return begin_window_2
end

ImguiShrinesDebug._shrine_types = function (arg_5_0)
	-- function 5
	local values = table.values(DEUS_CHEST_TYPES)

	table.insert(values, "deus_cursed_chest")

	return values
end

ImguiShrinesDebug._cursed_chest_challenges = function (arg_6_0)
	-- function 6
	local tbl = {
		"default"
	}

	table.append(tbl, table.keys_if(GenericTerrorEvents, nil, function (arg_7_0)
		-- function 7
		return string.sub(arg_7_0, 1, string.len("cursed_chest_challenge")) == "cursed_chest_challenge"
	end))

	return tbl
end

ImguiShrinesDebug._update_controls = function (self)
	-- function 8
	local _shrine_types = self:_shrine_types()
	local index_of = table.index_of
	local var_8_2 = _shrine_types
	local _selected_shrine_type = self._selected_shrine_type

	_selected_shrine_type = _selected_shrine_type or next(DEUS_CHEST_TYPES)

	local var_8_4 = index_of(var_8_2, _selected_shrine_type)

	self._selected_shrine_type = _shrine_types[Imgui.combo("Shrine Type", var_8_4, _shrine_types)]

	if self._selected_shrine_type == "deus_cursed_chest" then
		local _cursed_chest_challenges = self:_cursed_chest_challenges()
		local index_of_2 = table.index_of
		local var_8_7 = _cursed_chest_challenges
		local _selected_cursed_challenge = self._selected_cursed_challenge

		_selected_cursed_challenge = _selected_cursed_challenge or "default"

		local var_8_9 = index_of_2(var_8_7, _selected_cursed_challenge)

		self._selected_cursed_challenge = _cursed_chest_challenges[Imgui.combo("Challenge", var_8_9, _cursed_chest_challenges, 20)]
	end

	if not (Managers.state.network.is_server or self._selected_shrine_type ~= "deus_cursed_chest" or self._selected_cursed_challenge == "default") then
		Imgui.text("Clients can not spawn chests with a specific challenge. Please select 'default'.")

		return
	end

	if not Imgui.button("Spawn", 100, 20) then
		local player = Managers.player

		player = not player and Managers.player:local_player()

		if not (not player and player.player_unit) then
			return
		end

		local var_8_11 = POSITION_LOOKUP[player.player_unit]
		local system = Managers.state.entity:system("pickup_system")

		if self._selected_shrine_type == "deus_cursed_chest" then
			system:debug_spawn_pickup("deus_cursed_chest", var_8_11, function (arg_9_0)
				-- function 9
				local flag

				flag = self._selected_cursed_challenge ~= "default" or not "cursed_chest_prototype" or self._selected_cursed_challenge

				Unit.set_data(arg_9_0, "debug_override_terror_event", flag)
			end)
		else
			system:debug_spawn_pickup("DEBUG_deus_weapon_chest_" .. self._selected_shrine_type, var_8_11)
		end
	end
end
