-- chunkname: @scripts/imgui/imgui_level_debug.lua

ImguiLevelDebug = class(ImguiLevelDebug)

local var_0_0 = 70
local var_0_1 = {
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
local var_0_2 = {
	255,
	0,
	0
}
local var_0_3 = {
	0,
	255,
	0
}
local var_0_4 = {
	255,
	255,
	255
}
local var_0_5 = "imgui_respawn_point"

local function var_0_6(arg_1_0, arg_1_1)
	Imgui.text_colored(arg_1_0, arg_1_1[1], arg_1_1[2], arg_1_1[3], 255)
end

function ImguiLevelDebug.init(arg_2_0)
	arg_2_0._error = ""
	arg_2_0._index = 1
	arg_2_0._search_results = {}
	arg_2_0._search_text = ""
	arg_2_0._data = {}
	arg_2_0._prev_best = {}
	arg_2_0._unit_level_index = 0
	arg_2_0._draw_respawn_points = true
	arg_2_0._show_valid_points_only = false
	arg_2_0._selected_respawn_unit = nil
end

function ImguiLevelDebug.is_persistent(arg_3_0)
	return true
end

function ImguiLevelDebug._load_flow_events(arg_4_0)
	local var_4_0 = Managers.level_transition_handler:get_current_level_keys()

	printf("[ImguiLevelDebug] Loading flow events for %s", var_4_0)

	local var_4_1 = LevelSettings[var_4_0]

	if not var_4_1 then
		return string.format("Level %q not found in LevelSettings.", var_4_0)
	end

	local var_4_2 = script_data.source_dir

	if not var_4_2 then
		return "script_data.source_dir is nil. Not running from Toolcenter?"
	end

	local var_4_3 = var_4_2 .. "/" .. var_4_1.level_name .. ".level"
	local var_4_4, var_4_5 = io.open(var_4_3, "r")

	if not var_4_4 then
		return "Error opening the file: " .. var_4_5
	end

	local var_4_6 = {}

	for iter_4_0 in var_4_4:lines() do
		local var_4_7 = string.match(iter_4_0, "event_name = \"([^\"]+)\"")

		if var_4_7 then
			var_4_6[var_4_7] = var_4_7
		end
	end

	if next(var_4_6) == nil then
		return "No events found in the level."
	else
		local var_4_8 = arg_4_0._data

		table.clear(var_4_8)
		table.keys(var_4_6, var_4_8)
		table.sort(var_4_8)

		arg_4_0._data = var_4_8
		arg_4_0._search_results = var_4_8
	end

	var_4_4:close()

	return ""
end

function ImguiLevelDebug.update(arg_5_0)
	return
end

function ImguiLevelDebug.draw(arg_6_0)
	local var_6_0 = Imgui.begin_window("Level helper")
	local var_6_1 = Managers.state
	local var_6_2 = var_6_1 and var_6_1.game_mode
	local var_6_3 = var_6_2 and var_6_2:game_mode()
	local var_6_4 = var_6_3 and var_6_3:get_respawn_handler()

	if var_6_4 then
		if Imgui.tree_node("Debug Respawn Points") then
			arg_6_0:draw_respawn_debug(var_6_4)
			Imgui.tree_pop()
		else
			Managers.state.debug_text:clear_world_text(var_0_5)
		end
	end

	Imgui.end_window()

	return var_6_0
end

function ImguiLevelDebug.draw_flow_debug(arg_7_0)
	if Imgui.button("Load flow events for the current level") then
		arg_7_0._error = arg_7_0:_load_flow_events()
	end

	Imgui.same_line()
	Imgui.text_colored(arg_7_0._error, 255, 100, 100, 255)
	Imgui.separator()

	arg_7_0._index, arg_7_0._search_results, arg_7_0._search_text = ImguiX.combo_search(arg_7_0._index, arg_7_0._search_results, arg_7_0._search_text, arg_7_0._data)

	if Imgui.button("Run selected flow event") then
		local var_7_0 = arg_7_0._data[arg_7_0._index]

		if var_7_0 then
			print("[ImguiLevelDebug] Running event %s", var_7_0)
			LevelHelper:flow_event(Application.main_world(), var_7_0)
		end
	end
end

local function var_0_7(arg_8_0)
	local var_8_0 = Managers.world:world("level_world")

	if not var_8_0 then
		return nil
	end

	local var_8_1 = LevelHelper:current_level(var_8_0)

	if not var_8_1 then
		return nil
	end

	return Level.unit_by_index(var_8_1, arg_8_0)
end

function ImguiLevelDebug.draw_unit_finder(arg_9_0)
	arg_9_0._unit_level_index = Imgui.input_int("Level index", arg_9_0._unit_level_index)

	local var_9_0, var_9_1 = pcall(var_0_7, arg_9_0._unit_level_index)

	if var_9_0 and var_9_1 and Unit.alive(var_9_1) then
		local var_9_2 = Unit
		local var_9_3 = tostring(var_9_2.local_position(var_9_1, 0))

		ImguiX.heading("ID string", "%s", var_9_2.id_string(var_9_1))
		ImguiX.heading("Level ID", "%s", var_9_2.level_id_string(var_9_1))
		ImguiX.heading("Debug name", "%q", var_9_2.debug_name(var_9_1))
		ImguiX.heading("Position", "%s", var_9_3)
		Imgui.same_line()

		if Imgui.small_button("Copy to clipboard") then
			Clipboard.put(var_9_3)
		end

		ImguiX.heading("Rotation", "%s", tostring(var_9_2.local_rotation(var_9_1, 0)))
		ImguiX.heading("Scale", "%s", tostring(var_9_2.local_scale(var_9_1, 0)))
	else
		var_0_6("Unit not found or not alive.", var_0_2)
	end
end

function ImguiLevelDebug.draw_respawn_debug(arg_10_0, arg_10_1)
	arg_10_0._draw_respawn_points = Imgui.checkbox("Draw Respawn Points", arg_10_0._draw_respawn_points)
	arg_10_0._show_valid_points_only = Imgui.checkbox("Show Valid Points Only", arg_10_0._show_valid_points_only)

	local var_10_0 = Managers.state.conflict.main_path_info
	local var_10_1 = var_10_0.current_path_index
	local var_10_2 = var_10_0.ahead_travel_dist
	local var_10_3 = var_10_2 + var_0_0
	local var_10_4 = arg_10_1:get_main_path_segment_start(var_10_0, var_10_3)
	local var_10_5 = arg_10_1:get_next_boss_door_dist(var_10_0, var_10_2)
	local var_10_6 = arg_10_1:get_next_respawn_gate_dist(var_10_2)
	local var_10_7, var_10_8 = arg_10_1:get_respawn_dist_range(var_10_0, var_10_2, var_10_3)

	Imgui.separator()
	Imgui.text("Respawn limits:")
	Imgui.separator()
	ImguiX.heading("Segment start", "%.2f", var_10_4)
	ImguiX.heading("Next boss door", "%.2f", var_10_5)
	ImguiX.heading("Next respawn gate", "%.2f", var_10_6)
	ImguiX.heading("Respawn range", "%.2f - %.2f", var_10_7, var_10_8)
	ImguiX.heading("Ahead dist", "%.2f", var_10_2)
	ImguiX.heading("Preferred spawn dist", "%.2f", var_10_3)
	Imgui.separator()

	if Imgui.tree_node("Active Overrides") then
		local var_10_9 = arg_10_1._active_overrides

		if var_10_9 and next(var_10_9) then
			for iter_10_0 in pairs(var_10_9) do
				Imgui.text(iter_10_0)
			end
		end

		Imgui.tree_pop()
	end

	Imgui.separator()

	if Imgui.tree_node("Disabled Respawner Groups") then
		local var_10_10 = arg_10_1._disabled_respawn_groups

		if var_10_10 and next(var_10_10) then
			for iter_10_1 in pairs(var_10_10) do
				Imgui.text(iter_10_1)
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

	local var_10_11 = arg_10_1._respawn_units

	if var_10_11 then
		local var_10_12 = Vector3(0, 0, 1)
		local var_10_13 = arg_10_1:find_best_respawn_point(false, true)
		local var_10_14 = arg_10_1._respawn_gate_units
		local var_10_15 = #var_10_14
		local var_10_16 = 1
		local var_10_17 = false

		if var_10_13 then
			arg_10_0._prev_best[var_10_13] = true
		end

		for iter_10_2 = 1, #var_10_11 do
			local var_10_18 = var_10_11[iter_10_2]
			local var_10_19 = var_10_13 == var_10_18.unit

			if var_10_16 <= var_10_15 then
				local var_10_20 = var_10_14[var_10_16]
				local var_10_21 = var_10_20.distance_through_level

				if var_10_21 < var_10_18.distance_through_level then
					Imgui.separator()
					Imgui.text("Respawn Gate")
					Imgui.next_column()
					Imgui.text(tostring(var_10_21))
					Imgui.next_column()
					var_0_6(tostring(var_10_20.enabled), var_10_20.enabled and var_0_3 or var_0_2)
					Imgui.next_column()
					Imgui.tree_push(iter_10_2)

					if Imgui.button("Toggle") then
						Managers.state.game_mode:set_respawn_gate_enabled(var_10_20.unit, not var_10_20.enabled)
					end

					Imgui.tree_pop()
					Imgui.next_column()
					Imgui.separator()

					var_10_16 = var_10_16 + 1
				end
			end

			if not var_10_17 and var_10_5 < var_10_18.distance_through_level then
				Imgui.separator()
				Imgui.text("BOSS DOOR")
				Imgui.next_column()
				Imgui.text(tostring(var_10_5))
				Imgui.next_column()
				Imgui.next_column()
				Imgui.next_column()
				Imgui.next_column()
				Imgui.separator()

				var_10_17 = true
			end

			if not arg_10_0._show_valid_points_only or var_10_18._score > 0 then
				local var_10_22 = arg_10_0._prev_best[var_10_18.unit]

				Imgui.tree_push(iter_10_2)

				if arg_10_0._selected_respawn_unit == var_10_18.unit then
					if Imgui.small_button("-") then
						arg_10_0._selected_respawn_unit = nil
					end
				elseif Imgui.small_button("+") then
					arg_10_0._selected_respawn_unit = var_10_18.unit
				end

				Imgui.tree_pop()
				Imgui.same_line()
				Imgui.text(tostring(var_10_18.id) .. (var_10_19 and " BEST" or "") .. (var_10_22 and "*" or ""))
				Imgui.next_column()

				local var_10_23 = var_10_18.available
				local var_10_24 = arg_10_1:is_respawn_enabled(var_10_18)
				local var_10_25 = arg_10_1:is_spawn_group_override_active(var_10_18.group_id)
				local var_10_26 = arg_10_1:_is_respawn_reachable(var_10_18)
				local var_10_27 = var_0_1[var_10_18._score + 1]

				var_0_6(tostring(var_10_18.distance_through_level), var_10_27)
				Imgui.next_column()
				var_0_6(tostring(var_10_18.group_id), var_10_25 and var_0_3 or var_10_24 and var_0_4 or var_0_2)
				Imgui.next_column()
				var_0_6(tostring(var_10_18.available), var_10_18.available and var_0_3 or var_0_2)
				Imgui.next_column()
				var_0_6(tostring(var_10_26), var_10_26 and var_0_3 or var_0_2)
				Imgui.next_column()
			end

			if arg_10_0._draw_respawn_points then
				local var_10_28 = Unit.local_position(var_10_18.unit, 0) + var_10_12
				local var_10_29 = var_10_19 and Color(0, 255, 0) or Color(255, 200, 0)

				QuickDrawer:sphere(var_10_28, 0.5, var_10_29)

				if arg_10_0._selected_respawn_unit == var_10_18.unit then
					local var_10_30 = Managers.player:local_player().player_unit

					if ALIVE[var_10_30] then
						QuickDrawer:line(POSITION_LOOKUP[var_10_30], var_10_28, Color(255, 0, 255))
					end
				end

				if not arg_10_0._spawn_point_ids_drawn then
					local var_10_31 = 0.4
					local var_10_32 = Vector3(255, 255, 255)

					Managers.state.debug_text:output_world_text(string.format("%d %s", var_10_18.id, var_10_18.group_id), var_10_31, var_10_28, nil, var_0_5, var_10_32)
				end
			elseif arg_10_0._spawn_point_ids_drawn then
				Managers.state.debug_text:clear_world_text(var_0_5)
			end
		end

		arg_10_0._spawn_point_ids_drawn = arg_10_0._draw_respawn_points

		Imgui.columns(1)
	end
end
