-- chunkname: @scripts/imgui/imgui_profiler.lua

ImguiProfiler = class(ImguiProfiler)

function ImguiProfiler.init(arg_1_0)
	arg_1_0._filter = ""
	arg_1_0._filter_applied = false
	arg_1_0._auto_update_filter = false
	arg_1_0._pause_on_frame_spike = false
end

function ImguiProfiler.is_persistent(arg_2_0)
	return true
end

function ImguiProfiler.on_show(arg_3_0)
	CALCULATE_AVERAGE = true
end

function ImguiProfiler.on_hide(arg_4_0)
	CALCULATE_AVERAGE = false
end

function ImguiProfiler.update(arg_5_0, arg_5_1, arg_5_2)
	CALCULATE_AVERAGE = true
end

function ImguiProfiler.draw(arg_6_0)
	return
end

local var_0_0 = 1

FILTERED_SCOPES = {}
FILTERED_SCOPES_INDEX = 1

function ImguiProfiler.post_draw(arg_7_0)
	local var_7_0 = Imgui.begin_window("Profiler")

	Imgui.set_window_size(700, 512, "once")

	local var_7_1, var_7_2 = Imgui.input_int("Average over number of frames", PROFILE_FRAMES)

	if var_7_2 then
		PROFILE_FRAMES = var_7_1
	end

	local var_7_3 = false
	local var_7_4, var_7_5 = Imgui.input_text("Filter", arg_7_0._filter)

	if var_7_5 then
		arg_7_0._filter = var_7_4
		arg_7_0._filter_applied = arg_7_0._filter ~= ""
		var_7_3 = true
	end

	arg_7_0._auto_update_filter = Imgui.checkbox("Auto Update Filter (affects performance)", arg_7_0._auto_update_filter)

	if var_7_3 or arg_7_0._auto_update_filter then
		FILTERED_SCOPES_INDEX = 1

		local var_7_6 = arg_7_0._paused_scope or PROFILER_SCOPE_LOOKUP

		if arg_7_0._filter ~= "" then
			arg_7_0:_apply_filter(var_7_6, false)
		end
	end

	arg_7_0._pause_on_frame_spike = Imgui.checkbox("Pause on frame spike", arg_7_0._pause_on_frame_spike)

	if arg_7_0._pause_on_frame_spike then
		arg_7_0._pause_on_frame_time_text = Imgui.input_text("Pause At Frametime (ms)", arg_7_0._pause_on_frame_time_text or "200")

		local var_7_7 = arg_7_0._pause_on_frame_time

		arg_7_0._pause_on_frame_time = tonumber(arg_7_0._pause_on_frame_time_text)

		if arg_7_0._pause_on_frame_time ~= var_7_7 then
			arg_7_0._paused_scope = nil
			arg_7_0._paused_frame_index = nil
		end
	else
		arg_7_0._pause_on_frame_time = nil
		arg_7_0._paused_scope = nil
		arg_7_0._paused_frame_index = nil
	end

	Imgui.begin_child_window("Profiler Tree", 0, 0, true)

	var_0_0 = 1

	if arg_7_0._filter_applied then
		arg_7_0:_draw_filtered_scopes()
	else
		arg_7_0:_draw_lookup_table(arg_7_0._paused_scope or PROFILER_SCOPE_LOOKUP, false)
	end

	Imgui.end_child_window()
	Imgui.end_window()

	return var_7_0
end

function ImguiProfiler._draw_filtered_scopes(arg_8_0)
	if FILTERED_SCOPES_INDEX > 1 then
		local var_8_0 = Imgui.tree_node("root", true)

		for iter_8_0 = 1, FILTERED_SCOPES_INDEX - 1 do
			local var_8_1 = FILTERED_SCOPES[iter_8_0]

			arg_8_0:_draw_lookup_table(var_8_1, false)
		end

		Imgui.tree_pop()
	else
		Imgui.text_colored(string.format("No scope includes the text %q", arg_8_0._filter), 255, 128, 128, 255)
	end
end

function ImguiProfiler._draw_lookup_table(arg_9_0, arg_9_1, arg_9_2)
	local var_9_0 = arg_9_1.name

	if arg_9_1.frame_index and arg_9_1.frame_index < (arg_9_0._paused_frame_index or CURRENT_FRAME_INDEX) then
		return
	end

	local var_9_1 = false
	local var_9_2 = arg_9_1.is_leaf ~= false
	local var_9_3 = arg_9_0._paused_scope and arg_9_1.profiler_scope or arg_9_1.average_profiler_scope
	local var_9_4 = var_9_3 and string.format("%.3f", var_9_3) or ""
	local var_9_5

	if var_9_2 then
		var_9_5 = string.format("%s", arg_9_1.name, var_0_0)

		if arg_9_2 then
			Imgui.text_colored(var_9_5, 0, 255, 0, 255)
		else
			Imgui.text(var_9_5)
		end

		Imgui.same_line()

		if arg_9_2 then
			Imgui.text_colored(var_9_4, 0, 255, 0, 255)
		else
			Imgui.text_colored(var_9_4, 192, 128, 128, 255)
		end

		return
	elseif arg_9_1.name then
		var_9_5 = string.format("%s ##%s", arg_9_1.name, var_0_0)
	else
		var_9_5 = "root"
		var_9_1 = true
	end

	var_0_0 = var_0_0 + 1

	local var_9_6 = Imgui.tree_node(var_9_5, var_9_1)

	Imgui.same_line()

	if arg_9_2 then
		Imgui.text_colored(var_9_4, 0, 255, 0, 255)
	else
		Imgui.text_colored(var_9_4, 192, 128, 128, 255)
	end

	if var_9_6 then
		local var_9_7 = -1
		local var_9_8 = ""
		local var_9_9 = 0
		local var_9_10 = {}

		for iter_9_0, iter_9_1 in pairs(arg_9_1) do
			if type(iter_9_1) == "table" then
				if iter_9_1.parent == var_9_0 and iter_9_1.frame_index == (arg_9_0._paused_frame_index or CURRENT_FRAME_INDEX) then
					var_9_10[#var_9_10 + 1] = iter_9_1

					local var_9_11 = arg_9_0._paused_scope and iter_9_1.profiler_scope or iter_9_1.average_profiler_scope or 0

					if var_9_7 < var_9_11 then
						var_9_7 = var_9_11
						var_9_8 = iter_9_1
					end

					var_9_9 = var_9_9 + iter_9_1.profiler_scope
				end

				local var_9_12 = iter_9_1.stack

				if var_9_12 then
					for iter_9_2 = 1, var_9_12.stack_index do
						local var_9_13 = var_9_12[iter_9_2]

						var_9_10[#var_9_10 + 1] = var_9_13

						local var_9_14 = arg_9_0._paused_scope and var_9_13.profiler_scope or var_9_13.average_profiler_scope or 0

						if var_9_7 < var_9_14 then
							var_9_7 = var_9_14
							var_9_8 = var_9_13
						end
					end
				end
			end
		end

		local function var_9_15(arg_10_0, arg_10_1)
			return arg_10_0.name < arg_10_1.name
		end

		table.sort(var_9_10, var_9_15)

		for iter_9_3, iter_9_4 in ipairs(var_9_10) do
			arg_9_0:_draw_lookup_table(iter_9_4, iter_9_4 == var_9_8)
		end

		if var_9_1 and not arg_9_0._paused_scope and var_9_9 >= (arg_9_0._pause_on_frame_time or math.huge) then
			arg_9_0._paused_scope = table.clone(arg_9_1)
			arg_9_0._paused_frame_index = CURRENT_FRAME_INDEX
		end

		Imgui.tree_pop()
	end
end

function ImguiProfiler._apply_filter(arg_11_0, arg_11_1)
	local var_11_0 = arg_11_1.name

	if arg_11_1.frame_index and arg_11_1.frame_index < (arg_11_0._paused_frame_index or CURRENT_FRAME_INDEX) then
		return
	end

	var_0_0 = var_0_0 + 1

	if var_11_0 and string.find(string.lower(var_11_0), string.lower(arg_11_0._filter)) ~= nil then
		FILTERED_SCOPES[FILTERED_SCOPES_INDEX] = arg_11_1
		FILTERED_SCOPES_INDEX = FILTERED_SCOPES_INDEX + 1

		return
	end

	local var_11_1 = {}

	for iter_11_0, iter_11_1 in pairs(arg_11_1) do
		if type(iter_11_1) == "table" then
			if iter_11_1.parent == var_11_0 and iter_11_1.frame_index == (arg_11_0._paused_frame_index or CURRENT_FRAME_INDEX) then
				var_11_1[#var_11_1 + 1] = iter_11_1
			end

			local var_11_2 = iter_11_1.stack

			if var_11_2 then
				for iter_11_2 = 1, var_11_2.stack_index do
					local var_11_3 = var_11_2[iter_11_2]

					var_11_1[#var_11_1 + 1] = var_11_3
				end
			end
		end
	end

	local function var_11_4(arg_12_0, arg_12_1)
		return arg_12_0.name < arg_12_1.name
	end

	table.sort(var_11_1, var_11_4)

	for iter_11_3, iter_11_4 in ipairs(var_11_1) do
		arg_11_0:_apply_filter(iter_11_4)
	end
end

function ImguiProfiler.post_update(arg_13_0, arg_13_1, arg_13_2)
	return
end
