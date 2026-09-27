-- chunkname: @scripts/imgui/imgui_level_debug.lua

ImguiLevelDebug = class(ImguiLevelDebug)

local num = 70
local tbl = {
	{
		255,
		0,
		0
	},
	{
		255,
		128,
		0
	},
	{
		255,
		255,
		0
	},
	{
		0,
		255,
		0
	}
}
local tbl_2 = {
	255,
	0,
	0
}
local tbl_3 = {
	0,
	255,
	0
}
local tbl_4 = {
	255,
	255,
	255
}
local str = "imgui_respawn_point"

local function fn(arg_1_0, arg_1_1)
	-- function 1
	Imgui.text_colored(arg_1_0, arg_1_1[1], arg_1_1[2], arg_1_1[3], 255)
end

ImguiLevelDebug.init = function (self)
	-- function 2
	self._error = ""
	self._index = 1
	self._search_results = {}
	self._search_text = ""
	self._data = {}
	self._prev_best = {}
	self._unit_level_index = 0
	self._draw_respawn_points = true
	self._show_valid_points_only = false
	self._selected_respawn_unit = nil
end

ImguiLevelDebug.is_persistent = function (arg_3_0)
	-- function 3
	return true
end

ImguiLevelDebug._load_flow_events = function (self)
	-- function 4
	local get_current_level_keys = Managers.level_transition_handler:get_current_level_keys()

	printf("[ImguiLevelDebug] Loading flow events for %s", get_current_level_keys)

	local var_4_1 = LevelSettings[get_current_level_keys]

	if not var_4_1 then
		return string.format("Level %q not found in LevelSettings.", get_current_level_keys)
	end

	local source_dir = script_data.source_dir

	if not source_dir then
		return "script_data.source_dir is nil. Not running from Toolcenter?"
	end

	local str = source_dir .. "/" .. var_4_1.level_name .. ".level"
	local open, var_4_5 = io.open(str, "r")

	if not open then
		return "Error opening the file: " .. var_4_5
	end

	local tbl = {}

	for iter_4_0 in open:lines() do
		local match = string.match(iter_4_0, "event_name = \"([^\"]+)\"")

		if not match then
			tbl[match] = match
		end
	end

	if next(tbl) == nil then
		return "No events found in the level."
	else
		local _data = self._data

		table.clear(_data)
		table.keys(tbl, _data)
		table.sort(_data)

		self._data = _data
		self._search_results = _data
	end

	open:close()

	return ""
end

ImguiLevelDebug.update = function (arg_5_0)
	-- function 5
	return
end

ImguiLevelDebug.draw = function (self)
	-- function 6
	local begin_window = Imgui.begin_window("Level helper")
	local state = Managers.state
	local flag = not state and state.game_mode
	local flag_2 = not flag and flag:game_mode()
	local flag_3 = not flag_2 and flag_2:get_respawn_handler()

	if not flag_3 then
		if not Imgui.tree_node("Debug Respawn Points") then
			self:draw_respawn_debug(flag_3)
			Imgui.tree_pop()
		else
			Managers.state.debug_text:clear_world_text(str)
		end
	end

	Imgui.end_window()

	return begin_window
end

ImguiLevelDebug.draw_flow_debug = function (self)
	-- function 7
	if not Imgui.button("Load flow events for the current level") then
		self._error = self:_load_flow_events()
	end

	Imgui.same_line()
	Imgui.text_colored(self._error, 255, 100, 100, 255)
	Imgui.separator()

	self._index, self._search_results, self._search_text = ImguiX.combo_search(self._index, self._search_results, self._search_text, self._data)

	if not Imgui.button("Run selected flow event") then
		local var_7_0 = self._data[self._index]

		if not var_7_0 then
			print("[ImguiLevelDebug] Running event %s", var_7_0)
			LevelHelper:flow_event(Application.main_world(), var_7_0)
		end
	end
end

local function fn_2(arg_8_0)
	-- function 8
	local world = Managers.world:world("level_world")

	if not world then
		return nil
	end

	local current_level = LevelHelper:current_level(world)

	if not current_level then
		return nil
	end

	return Level.unit_by_index(current_level, arg_8_0)
end

ImguiLevelDebug.draw_unit_finder = function (self)
	-- function 9
	self._unit_level_index = Imgui.input_int("Level index", self._unit_level_index)

	local var_9_0, var_9_1 = pcall(fn_2, self._unit_level_index)

	if not var_9_0 and not var_9_1 and not Unit.alive(var_9_1) then
		local Unit = Unit
		local var_9_3 = tostring(Unit.local_position(var_9_1, 0))

		ImguiX.heading("ID string", "%s", Unit.id_string(var_9_1))
		ImguiX.heading("Level ID", "%s", Unit.level_id_string(var_9_1))
		ImguiX.heading("Debug name", "%q", Unit.debug_name(var_9_1))
		ImguiX.heading("Position", "%s", var_9_3)
		Imgui.same_line()

		if not Imgui.small_button("Copy to clipboard") then
			Clipboard.put(var_9_3)
		end

		ImguiX.heading("Rotation", "%s", tostring(Unit.local_rotation(var_9_1, 0)))
		ImguiX.heading("Scale", "%s", tostring(Unit.local_scale(var_9_1, 0)))
	else
		fn("Unit not found or not alive.", tbl_2)
	end
end

ImguiLevelDebug.draw_respawn_debug = function (self, arg_10_1)
	-- function 10
	self._draw_respawn_points = Imgui.checkbox("Draw Respawn Points", self._draw_respawn_points)
	self._show_valid_points_only = Imgui.checkbox("Show Valid Points Only", self._show_valid_points_only)

	local main_path_info = Managers.state.conflict.main_path_info
	local current_path_index = main_path_info.current_path_index
	local ahead_travel_dist = main_path_info.ahead_travel_dist
	local num_2 = ahead_travel_dist + num
	local get_main_path_segment_start = arg_10_1:get_main_path_segment_start(main_path_info, num_2)
	local get_next_boss_door_dist = arg_10_1:get_next_boss_door_dist(main_path_info, ahead_travel_dist)
	local get_next_respawn_gate_dist = arg_10_1:get_next_respawn_gate_dist(ahead_travel_dist)
	local get_respawn_dist_range, var_10_8 = arg_10_1:get_respawn_dist_range(main_path_info, ahead_travel_dist, num_2)

	Imgui.separator()
	Imgui.text("Respawn limits:")
	Imgui.separator()
	ImguiX.heading("Segment start", "%.2f", get_main_path_segment_start)
	ImguiX.heading("Next boss door", "%.2f", get_next_boss_door_dist)
	ImguiX.heading("Next respawn gate", "%.2f", get_next_respawn_gate_dist)
	ImguiX.heading("Respawn range", "%.2f - %.2f", get_respawn_dist_range, var_10_8)
	ImguiX.heading("Ahead dist", "%.2f", ahead_travel_dist)
	ImguiX.heading("Preferred spawn dist", "%.2f", num_2)
	Imgui.separator()

	if not Imgui.tree_node("Active Overrides") then
		local _active_overrides = arg_10_1._active_overrides

		if not _active_overrides and not next(_active_overrides) then
			for k in pairs(_active_overrides) do
				Imgui.text(k)
			end
		end

		Imgui.tree_pop()
	end

	Imgui.separator()

	if not Imgui.tree_node("Disabled Respawner Groups") then
		local _disabled_respawn_groups = arg_10_1._disabled_respawn_groups

		if not _disabled_respawn_groups and not next(_disabled_respawn_groups) then
			for k_2 in pairs(_disabled_respawn_groups) do
				Imgui.text(k_2)
			end
		end

		Imgui.tree_pop()
	end

	Imgui.separator()
	Imgui.columns(5, true)
	Imgui.text("ID")
	Imgui.next_column()
	Imgui.text("distance")
	Imgui.next_column()
	Imgui.text("group id")
	Imgui.next_column()
	Imgui.text("free")
	Imgui.next_column()
	Imgui.text("reachable")
	Imgui.next_column()
	Imgui.separator()

	local _respawn_units = arg_10_1._respawn_units

	if not _respawn_units then
		local var_10_12 = Vector3(0, 0, 1)
		local find_best_respawn_point = arg_10_1:find_best_respawn_point(false, true)
		local _respawn_gate_units = arg_10_1._respawn_gate_units
		local count = #_respawn_gate_units
		local num_3 = 1
		local flag = false

		if not find_best_respawn_point then
			self._prev_best[find_best_respawn_point] = true
		end

		for k_3 = 1, #_respawn_units do
			local var_10_18 = _respawn_units[k_3]
			local flag_2 = find_best_respawn_point == var_10_18.unit

			if num_3 <= count then
				local var_10_20 = _respawn_gate_units[num_3]
				local distance_through_level = var_10_20.distance_through_level

				if distance_through_level < var_10_18.distance_through_level then
					Imgui.separator()
					Imgui.text("Respawn Gate")
					Imgui.next_column()
					Imgui.text(tostring(distance_through_level))
					Imgui.next_column()

					local var_10_22 = fn
					local var_10_23 = tostring(var_10_20.enabled)
					local var_10_24

					if not var_10_20.enabled then
						var_10_24 = tbl_3

						if not var_10_24 then
							-- Nothing
						end
					end

					var_10_24 = tbl_2

					::label_10_0::

					var_10_22(var_10_23, var_10_24)
					Imgui.next_column()
					Imgui.tree_push(k_3)

					if not Imgui.button("Toggle") then
						Managers.state.game_mode:set_respawn_gate_enabled(var_10_20.unit, not var_10_20.enabled)
					end

					Imgui.tree_pop()
					Imgui.next_column()
					Imgui.separator()

					num_3 = num_3 + 1
				end
			end

			if not (flag or not (get_next_boss_door_dist < var_10_18.distance_through_level)) then
				Imgui.separator()
				Imgui.text("BOSS DOOR")
				Imgui.next_column()
				Imgui.text(tostring(get_next_boss_door_dist))
				Imgui.next_column()
				Imgui.next_column()
				Imgui.next_column()
				Imgui.next_column()
				Imgui.separator()

				flag = true
			end

			if not (not self._show_valid_points_only and not (var_10_18._score > 0)) then
				local var_10_25 = self._prev_best[var_10_18.unit]

				Imgui.tree_push(k_3)

				if self._selected_respawn_unit == var_10_18.unit then
					if not Imgui.small_button("-") then
						self._selected_respawn_unit = nil
					end
				elseif not Imgui.small_button("+") then
					self._selected_respawn_unit = var_10_18.unit
				end

				Imgui.tree_pop()
				Imgui.same_line()

				local text = Imgui.text
				local var_10_27 = tostring(var_10_18.id)
				local flag_3

				flag_3 = not flag_2 and " BEST" and ""

				local flag_4

				flag_4 = not var_10_25 and "*" and ""

				text(var_10_27 .. flag_3 .. flag_4)
				Imgui.next_column()

				local available = var_10_18.available
				local is_respawn_enabled = arg_10_1:is_respawn_enabled(var_10_18)
				local is_spawn_group_override_active = arg_10_1:is_spawn_group_override_active(var_10_18.group_id)
				local _is_respawn_reachable = arg_10_1:_is_respawn_reachable(var_10_18)
				local var_10_34 = tbl[var_10_18._score + 1]

				fn(tostring(var_10_18.distance_through_level), var_10_34)
				Imgui.next_column()

				local var_10_35 = fn
				local var_10_36 = tostring(var_10_18.group_id)
				local var_10_37

				if not is_spawn_group_override_active then
					var_10_37 = tbl_3

					if not var_10_37 then
						-- Nothing
					end
				end

				if not is_respawn_enabled then
					var_10_37 = tbl_4

					if not var_10_37 then
						-- Nothing
					end
				end

				var_10_37 = tbl_2

				::label_10_1::

				var_10_35(var_10_36, var_10_37)
				Imgui.next_column()

				local var_10_38 = fn
				local var_10_39 = tostring(var_10_18.available)
				local var_10_40

				if not var_10_18.available then
					var_10_40 = tbl_3

					if not var_10_40 then
						-- Nothing
					end
				end

				var_10_40 = tbl_2

				::label_10_2::

				var_10_38(var_10_39, var_10_40)
				Imgui.next_column()

				local var_10_41 = fn
				local var_10_42 = tostring(_is_respawn_reachable)
				local var_10_43

				if not _is_respawn_reachable then
					var_10_43 = tbl_3

					if not var_10_43 then
						-- Nothing
					end
				end

				var_10_43 = tbl_2

				::label_10_3::

				var_10_41(var_10_42, var_10_43)
				Imgui.next_column()
			end

			if not self._draw_respawn_points then
				local num_4 = Unit.local_position(var_10_18.unit, 0) + var_10_12
				local var_10_45

				if not flag_2 then
					var_10_45 = Color(0, 255, 0)

					if not var_10_45 then
						-- Nothing
					end
				end

				var_10_45 = Color(255, 200, 0)

				::label_10_4::

				QuickDrawer:sphere(num_4, 0.5, var_10_45)

				if self._selected_respawn_unit == var_10_18.unit then
					local player_unit = Managers.player:local_player().player_unit

					if not ALIVE[player_unit] then
						QuickDrawer:line(POSITION_LOOKUP[player_unit], num_4, Color(255, 0, 255))
					end
				end

				if not self._spawn_point_ids_drawn then
					local num_5 = 0.4
					local var_10_48 = Vector3(255, 255, 255)

					Managers.state.debug_text:output_world_text(string.format("%d %s", var_10_18.id, var_10_18.group_id), num_5, num_4, nil, str, var_10_48)
				end
			elseif not self._spawn_point_ids_drawn then
				Managers.state.debug_text:clear_world_text(str)
			end
		end

		self._spawn_point_ids_drawn = self._draw_respawn_points

		Imgui.columns(1)
	end
end
