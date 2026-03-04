-- chunkname: @scripts/imgui/imgui_ai_spawn_log.lua

ImguiAISpawnLog = class(ImguiAISpawnLog)

local var_0_0 = false

local function var_0_1(arg_1_0)
	return string.format("%06.3f", arg_1_0)
end

local var_0_2 = 1
local var_0_3 = 2
local var_0_4 = 3
local var_0_5 = 6
local var_0_6 = 7
local var_0_7 = 8
local var_0_8 = 9

ImguiAISpawnLog.init = function (arg_2_0)
	arg_2_0._log = {}
	arg_2_0._player_positions = {}
	arg_2_0._timeline_slice_size = 1
	arg_2_0._timeline_slice_end = 1
	arg_2_0._show_totals = false
	arg_2_0._visualize_locations = false
	arg_2_0._sticky_hover = false
	arg_2_0._keep_on_screen = false
	arg_2_0._live_log = true
	arg_2_0._live_log_size = 20
	arg_2_0._segment_distance_sq = 25
	arg_2_0._event_type_names = {
		"queued",
		"canceled",
		"spawned"
	}
	arg_2_0._specials_only = false
	arg_2_0._drawer = nil
	arg_2_0._hero_side = nil
	arg_2_0._totals = {}
	arg_2_0._hovered_id = -1
	arg_2_0._hovered_time = -1

	arg_2_0:register_events()
end

ImguiAISpawnLog.register_events = function (arg_3_0)
	local var_3_0 = Managers.state.event

	if var_3_0 then
		var_3_0:register(arg_3_0, "spawn_log_queue", "log_queue")
		var_3_0:register(arg_3_0, "spawn_log_spawn", "log_spawn")
	end
end

ImguiAISpawnLog.unregister_events = function (arg_4_0)
	local var_4_0 = Managers.state.event

	if var_4_0 then
		var_4_0:unregister("spawn_log_queue", arg_4_0)
		var_4_0:unregister("spawn_log_spawn", arg_4_0)
	end
end

ImguiAISpawnLog.update = function (arg_5_0)
	if var_0_0 then
		arg_5_0:unregister_events()
		arg_5_0:init()

		var_0_0 = false
	end

	local var_5_0 = Managers.time:time("game")

	if not var_5_0 then
		arg_5_0:_reset()

		return
	end

	if not arg_5_0._drawer then
		arg_5_0:_init_session()
	end

	arg_5_0:_log_player_positions(var_5_0)

	if arg_5_0._visualize_locations and arg_5_0._drawer then
		arg_5_0:_visualise_player_pos()
	end
end

ImguiAISpawnLog.is_persistent = function (arg_6_0)
	return arg_6_0._keep_on_screen
end

ImguiAISpawnLog.draw = function (arg_7_0)
	local var_7_0 = Managers.time:time("game")

	if not var_7_0 then
		return
	end

	local var_7_1 = Imgui.begin_window("AI Spawn Log")

	if Imgui.button("Export Log") then
		arg_7_0:_export_log_data()
	end

	arg_7_0._show_totals = Imgui.checkbox("Show Totals", arg_7_0._show_totals)
	arg_7_0._keep_on_screen = Imgui.checkbox("Keep On Screen", arg_7_0._keep_on_screen)
	arg_7_0._visualize_locations = Imgui.checkbox("Visualize Locaitons", arg_7_0._visualize_locations)
	arg_7_0._sticky_hover = Imgui.checkbox("Sticky Hover", arg_7_0._sticky_hover)
	arg_7_0._live_log = Imgui.checkbox("Live Log", arg_7_0._live_log)
	arg_7_0._specials_only = Imgui.checkbox("Specials Only", arg_7_0._specials_only)

	if arg_7_0._live_log then
		arg_7_0._timeline_end = var_7_0
	end

	arg_7_0._timeline_slice_size = Imgui.slider_float("Capture Size", arg_7_0._timeline_slice_size, 1, 120)
	arg_7_0._timeline_end = math.max(arg_7_0._timeline_end, arg_7_0._timeline_slice_size)
	arg_7_0._timeline_end = Imgui.slider_float("Capture Location", arg_7_0._timeline_end, arg_7_0._timeline_slice_size, var_7_0)

	if arg_7_0._show_totals then
		Imgui.begin_window("AI Spawn Totals")

		if Imgui.button("Export") then
			arg_7_0:_export_recap_data()
		end

		local var_7_2 = #arg_7_0._event_type_names
		local var_7_3 = "Legend -" .. string.rep(" %s,", var_7_2)

		Imgui.text(string.format(var_7_3, unpack(arg_7_0._event_type_names)))

		local var_7_4 = "%32s -" .. string.rep(" %d,", var_7_2)

		for iter_7_0, iter_7_1 in pairs(arg_7_0._totals) do
			Imgui.text(string.format(var_7_4, iter_7_0, unpack(iter_7_1)))
		end

		Imgui.end_window()
	end

	if Imgui.button("Clear") then
		arg_7_0:_clear()
	end

	Imgui.separator()

	local var_7_5 = arg_7_0._event_type_names
	local var_7_6 = arg_7_0._visualize_locations
	local var_7_7 = Color(255, 0, 0)
	local var_7_8 = {
		255,
		255,
		255
	}
	local var_7_9 = {
		255,
		0,
		0
	}
	local var_7_10 = arg_7_0._specials_only
	local var_7_11 = arg_7_0._timeline_end - arg_7_0._timeline_slice_size
	local var_7_12 = arg_7_0._timeline_end
	local var_7_13 = arg_7_0._sticky_hover and arg_7_0._hovered_id or -1
	local var_7_14 = arg_7_0._sticky_hover and arg_7_0._hovered_time or -1
	local var_7_15 = arg_7_0._hovered_id

	for iter_7_2 = 1, #arg_7_0._log do
		local var_7_16 = arg_7_0._log[iter_7_2]
		local var_7_17 = var_7_16[var_0_3]

		if var_7_11 <= var_7_17 and var_7_17 <= var_7_12 then
			local var_7_18 = var_7_16[var_0_5]

			if not var_7_10 or var_7_18 and var_7_18.special then
				local var_7_19 = var_0_1(var_7_17)
				local var_7_20 = var_7_5[var_7_16[var_0_2]]
				local var_7_21 = var_7_19 .. " " .. var_7_20
				local var_7_22 = var_7_18 and var_7_18.name
				local var_7_23 = var_7_21 .. " " .. tostring(var_7_22)
				local var_7_24 = var_7_16[var_0_6]
				local var_7_25 = var_7_23 .. " " .. tostring(var_7_24)
				local var_7_26 = var_7_16[var_0_7]
				local var_7_27 = var_7_25 .. " " .. tostring(var_7_26)
				local var_7_28 = var_7_16[var_0_8]
				local var_7_29 = var_7_27 .. " " .. tostring(var_7_28)
				local var_7_30 = var_7_15 == var_7_28
				local var_7_31 = var_7_30 and var_7_9 or var_7_8

				Imgui.text_colored(var_7_29, var_7_31[1], var_7_31[2], var_7_31[3], 255)

				if Imgui.is_item_hovered() then
					var_7_13 = var_7_28
					var_7_14 = var_7_17
				end

				if var_7_6 and arg_7_0._drawer and (var_7_15 == -1 or var_7_13 == var_7_28) then
					local var_7_32 = Vector3(var_7_16[var_0_4], var_7_16[var_0_4 + 1], var_7_16[var_0_4 + 2])

					arg_7_0._drawer:sphere(var_7_32, 1, var_7_7)

					if var_7_30 then
						arg_7_0._drawer:line(var_7_32, var_7_32 + Vector3(0, 0, 25), var_7_7)
					end
				end
			end
		end
	end

	arg_7_0._hovered_id = var_7_13
	arg_7_0._hovered_time = var_7_14

	Imgui.end_window("AI Spawn Log")

	return var_7_1
end

ImguiAISpawnLog.log_queue = function (arg_8_0, ...)
	arg_8_0:_log_event(1, ...)
end

ImguiAISpawnLog.log_queue_cancel = function (arg_9_0, ...)
	arg_9_0:_log_event(2, ...)
end

ImguiAISpawnLog.log_spawn = function (arg_10_0, ...)
	arg_10_0:_log_event(3, ...)
end

ImguiAISpawnLog._log_event = function (arg_11_0, arg_11_1, arg_11_2, arg_11_3, arg_11_4, arg_11_5, arg_11_6)
	local var_11_0 = arg_11_2 and arg_11_2:unbox()
	local var_11_1 = Managers.time:time("game")
	local var_11_2 = {
		arg_11_1,
		var_11_1,
		var_11_0 and var_11_0.x or 0,
		var_11_0 and var_11_0.y or 0,
		var_11_0 and var_11_0.z or 0,
		arg_11_3,
		arg_11_4,
		arg_11_5,
		arg_11_6
	}

	if arg_11_3 then
		if not arg_11_0._totals[arg_11_3.name] then
			arg_11_0._totals[arg_11_3.name] = {}

			for iter_11_0 = 1, #arg_11_0._event_type_names do
				arg_11_0._totals[arg_11_3.name][iter_11_0] = 0
			end
		end

		arg_11_0._totals[arg_11_3.name][arg_11_1] = arg_11_0._totals[arg_11_3.name][arg_11_1] + 1
	end

	table.insert(arg_11_0._log, 1, var_11_2)
end

ImguiAISpawnLog._clear = function (arg_12_0)
	arg_12_0._log = {}
	arg_12_0._player_positions = {}
	arg_12_0._totals = {}
end

ImguiAISpawnLog._reset = function (arg_13_0)
	arg_13_0._drawer = nil
	arg_13_0._hero_side = nil

	arg_13_0:_clear()
end

ImguiAISpawnLog._init_session = function (arg_14_0)
	local var_14_0 = Managers.state

	if var_14_0 then
		arg_14_0:register_events()

		arg_14_0._drawer = var_14_0.debug:drawer({
			mode = "immediate",
			name = "ImguiAISpawnLog"
		})
		arg_14_0._hero_side = var_14_0.side:get_side_from_name("heroes")
	end
end

ImguiAISpawnLog._log_player_positions = function (arg_15_0, arg_15_1)
	local var_15_0 = arg_15_0._hero_side

	if var_15_0 then
		local var_15_1 = var_15_0.PLAYER_AND_BOT_UNITS
		local var_15_2 = var_15_0.PLAYER_AND_BOT_POSITIONS
		local var_15_3 = arg_15_0._segment_distance_sq

		for iter_15_0 = 1, #var_15_1 do
			local var_15_4 = var_15_1[iter_15_0]
			local var_15_5 = var_15_2[iter_15_0]

			if not arg_15_0._player_positions[var_15_4] then
				arg_15_0._player_positions[var_15_4] = {
					arg_15_1,
					var_15_5.x,
					var_15_5.y,
					var_15_5.z
				}
			else
				local var_15_6 = arg_15_0._player_positions[var_15_4]
				local var_15_7 = #var_15_6
				local var_15_8 = var_15_6[var_15_7 - 2]
				local var_15_9 = var_15_6[var_15_7 - 1]
				local var_15_10 = var_15_6[var_15_7]

				if var_15_3 <= Vector3.distance_squared(var_15_5, Vector3(var_15_8, var_15_9, var_15_10)) then
					var_15_6[var_15_7 + 1] = arg_15_1
					var_15_6[var_15_7 + 2] = var_15_5.x
					var_15_6[var_15_7 + 3] = var_15_5.y
					var_15_6[var_15_7 + 4] = var_15_5.z
				end
			end
		end
	end
end

ImguiAISpawnLog._visualise_player_pos = function (arg_16_0)
	local var_16_0 = arg_16_0._timeline_end - arg_16_0._timeline_slice_size
	local var_16_1 = arg_16_0._timeline_end
	local var_16_2 = Color(0, 255, 0)
	local var_16_3 = Color(255, 255, 0)
	local var_16_4 = arg_16_0._hovered_time

	for iter_16_0, iter_16_1 in pairs(arg_16_0._player_positions) do
		local var_16_5 = 1
		local var_16_6 = 1

		for iter_16_2 = 1, #iter_16_1, 4 do
			local var_16_7 = iter_16_1[iter_16_2]

			if var_16_7 < var_16_0 then
				var_16_5 = iter_16_2
				var_16_6 = iter_16_2
			elseif var_16_1 < var_16_7 then
				var_16_6 = iter_16_2

				break
			else
				var_16_6 = iter_16_2
			end
		end

		for iter_16_3 = var_16_5, var_16_6, 4 do
			local var_16_8 = Vector3(iter_16_1[iter_16_3 + 1], iter_16_1[iter_16_3 + 2], iter_16_1[iter_16_3 + 3])

			arg_16_0._drawer:sphere(var_16_8, 1, var_16_2)

			if var_16_6 >= iter_16_3 + 4 then
				local var_16_9 = Vector3(iter_16_1[iter_16_3 + 5], iter_16_1[iter_16_3 + 6], iter_16_1[iter_16_3 + 7])

				arg_16_0._drawer:arrow_2d(var_16_8, var_16_9, var_16_2)

				if var_16_4 >= iter_16_1[iter_16_3] and var_16_4 <= iter_16_1[iter_16_3 + 4] then
					local var_16_10 = (var_16_4 - iter_16_1[iter_16_3]) / (iter_16_1[iter_16_3 + 4] - iter_16_1[iter_16_3])
					local var_16_11 = Vector3.lerp(var_16_8, var_16_9, var_16_10)

					arg_16_0._drawer:sphere(var_16_11, 1, var_16_3)
					arg_16_0._drawer:line(var_16_11, var_16_11 + Vector3(0, 0, 25), var_16_3)
				end
			end
		end
	end
end

ImguiAISpawnLog._export_recap_data = function (arg_17_0)
	local var_17_0 = "Breed,Faction,Count"

	for iter_17_0, iter_17_1 in pairs(arg_17_0._totals) do
		local var_17_1 = Breeds[iter_17_0]
		local var_17_2 = var_17_1 and var_17_1.race or "unknown"

		var_17_0 = var_17_0 .. "\n"
		var_17_0 = var_17_0 .. iter_17_0 .. ","
		var_17_0 = var_17_0 .. var_17_2 .. ","
		var_17_0 = var_17_0 .. tostring(iter_17_1[3])
	end

	Clipboard.put(var_17_0)
end

ImguiAISpawnLog._export_log_data = function (arg_18_0)
	local var_18_0 = arg_18_0._event_type_names
	local var_18_1 = "Breed,Faction,Spawn Category,Spawn Type"

	for iter_18_0 = 1, #arg_18_0._log do
		local var_18_2 = arg_18_0._log[iter_18_0]

		if var_18_0[var_18_2[var_0_2]] == "spawned" then
			var_18_1 = var_18_1 .. "\n"

			local var_18_3 = var_18_2[var_0_5]
			local var_18_4 = var_18_3 and var_18_3.name or "unknown"
			local var_18_5 = var_18_3 and var_18_3.race or "unknown"

			var_18_1 = var_18_1 .. var_18_4 .. ","
			var_18_1 = var_18_1 .. var_18_5 .. ","

			local var_18_6 = var_18_2[var_0_6]

			var_18_1 = var_18_1 .. tostring(var_18_6) .. ","

			local var_18_7 = var_18_2[var_0_7]

			var_18_1 = var_18_1 .. tostring(var_18_7)
		end
	end

	Clipboard.put(var_18_1)
end
