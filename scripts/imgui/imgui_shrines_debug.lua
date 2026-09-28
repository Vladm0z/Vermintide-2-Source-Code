-- chunkname: @scripts/imgui/imgui_shrines_debug.lua

ImguiShrinesDebug = class(ImguiShrinesDebug)

local SHOULD_RELOAD = true

ImguiShrinesDebug.init = function (self)
	-- function 1
	return
end

ImguiShrinesDebug.update = function (self)
	-- function 2
	if SHOULD_RELOAD then
		self:init()

		SHOULD_RELOAD = false
	end
end

ImguiShrinesDebug.is_persistent = function (self)
	-- function 3
	return true
end

ImguiShrinesDebug.draw = function (self, is_open)
	-- function 4
	if not Managers.state or not Managers.state.game_mode or Managers.state.game_mode:game_mode_key() ~= "deus" then
		local do_close = Imgui.begin_window("Shrines Debug", "always_auto_resize")

		Imgui.text("This UI only works when playing a deus level.")
		Imgui.end_window()

		return do_close
	end

	local do_close = Imgui.begin_window("Shrines Debug", "always_auto_resize")

	self:_update_controls()
	Imgui.end_window()

	return do_close
end

ImguiShrinesDebug._shrine_types = function (self)
	-- function 5
	local types = table.values(DEUS_CHEST_TYPES)

	table.insert(types, "deus_cursed_chest")

	return types
end

ImguiShrinesDebug._cursed_chest_challenges = function (self)
	-- function 6
	local challenges = {
		"default"
	}

	table.append(challenges, table.keys_if(GenericTerrorEvents, nil, function (key)
		-- function 7
		return string.sub(key, 1, string.len("cursed_chest_challenge")) == "cursed_chest_challenge"
	end))

	return challenges
end

ImguiShrinesDebug._update_controls = function (self)
	-- function 8
	local chest_types = self:_shrine_types()
	local index_of = table.index_of
	local var_8_1 = chest_types
	local _selected_shrine_type = self._selected_shrine_type

	_selected_shrine_type = not not _selected_shrine_type or not not next(DEUS_CHEST_TYPES)

	local shrine_type_index = index_of(var_8_1, _selected_shrine_type)

	self._selected_shrine_type = chest_types[Imgui.combo("Shrine Type", shrine_type_index, chest_types)]

	if self._selected_shrine_type == "deus_cursed_chest" then
		local challenges = self:_cursed_chest_challenges()
		local index_of_2 = table.index_of
		local var_8_4 = challenges
		local _selected_cursed_challenge = self._selected_cursed_challenge

		_selected_cursed_challenge = not not _selected_cursed_challenge or not not "default"

		local challenge_index = index_of_2(var_8_4, _selected_cursed_challenge)

		self._selected_cursed_challenge = challenges[Imgui.combo("Challenge", challenge_index, challenges, 20)]
	end

	if not Managers.state.network.is_server and self._selected_shrine_type == "deus_cursed_chest" and self._selected_cursed_challenge ~= "default" then
		Imgui.text("Clients can not spawn chests with a specific challenge. Please select 'default'.")

		return
	end

	if Imgui.button("Spawn", 100, 20) then
		local player = Managers.player

		if player then
			-- Nothing
		end

		player = Managers.player:local_player()

		local local_player = player

		::label_8_0::

		if not local_player or not local_player.player_unit then
			return
		end

		local position = POSITION_LOOKUP[local_player.player_unit]
		local pickup_system = Managers.state.entity:system("pickup_system")

		if self._selected_shrine_type == "deus_cursed_chest" then
			pickup_system:debug_spawn_pickup("deus_cursed_chest", position, function (shrine_unit)
				-- function 9
				local str

				if self._selected_cursed_challenge == "default" then
					str = "cursed_chest_prototype"

					goto label_9_0
				end

				str = self._selected_cursed_challenge

				local terror_event = str

				::label_9_0::

				Unit.set_data(shrine_unit, "debug_override_terror_event", terror_event)
			end)
		else
			pickup_system:debug_spawn_pickup("DEBUG_deus_weapon_chest_" .. self._selected_shrine_type, position)
		end
	end
end
