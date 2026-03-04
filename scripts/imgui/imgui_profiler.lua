-- chunkname: @scripts/imgui/imgui_profiler.lua

ImguiProfiler = class(ImguiProfiler)

function ImguiProfiler.init(arg_1_0)
	arg_1_0._filter = ""
	arg_1_0._filter_applied = false
	arg_1_0._auto_update_filter = false
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
	return
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

		local var_7_6 = PROFILER_SCOPE_LOOKUP

		if arg_7_0._filter ~= "" then
			arg_7_0:_apply_filter(var_7_6, false)
		end
	end

	Imgui.begin_child_window("Profiler Tree", 0, 0, true)

	var_0_0 = 1

	if arg_7_0._filter_applied then
		arg_7_0:_draw_filtered_scopes()
	else
		arg_7_0:_draw_lookup_table(PROFILER_SCOPE_LOOKUP, false)
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

	if arg_9_1.frame_index and arg_9_1.frame_index < CURRENT_FRAME_INDEX then
		return
	end

	local var_9_1 = false
	local var_9_2 = arg_9_1.is_leaf ~= false
	local var_9_3 = arg_9_1.average_profiler_scope and string.format("%.3f", arg_9_1.average_profiler_scope) or ""
	local var_9_4

	if var_9_2 then
		var_9_4 = string.format("%s", arg_9_1.name, var_0_0)

		if arg_9_2 then
			Imgui.text_colored(var_9_4, 0, 255, 0, 255)
		else
			Imgui.text(var_9_4)
		end

		Imgui.same_line()

		if arg_9_2 then
			Imgui.text_colored(var_9_3, 0, 255, 0, 255)
		else
			Imgui.text_colored(var_9_3, 192, 128, 128, 255)
		end

		return
	elseif arg_9_1.name then
		var_9_4 = string.format("%s ##%s", arg_9_1.name, var_0_0)
	else
		var_9_4 = "root"
		var_9_1 = true
	end

	var_0_0 = var_0_0 + 1

	local var_9_5 = Imgui.tree_node(var_9_4, var_9_1)

	Imgui.same_line()

	if arg_9_2 then
		Imgui.text_colored(var_9_3, 0, 255, 0, 255)
	else
		Imgui.text_colored(var_9_3, 192, 128, 128, 255)
	end

	if var_9_5 then
		local var_9_6 = -1
		local var_9_7 = ""
		local var_9_8 = {}

		for iter_9_0, iter_9_1 in pairs(arg_9_1) do
			if type(iter_9_1) == "table" then
				if iter_9_1.parent == var_9_0 and iter_9_1.frame_index == CURRENT_FRAME_INDEX then
					var_9_8[#var_9_8 + 1] = iter_9_1

					local var_9_9 = iter_9_1.average_profiler_scope or 0

					if var_9_6 < var_9_9 then
						var_9_6 = var_9_9
						var_9_7 = iter_9_1
					end
				end

				local var_9_10 = iter_9_1.stack

				if var_9_10 then
					for iter_9_2 = 1, var_9_10.stack_index do
						local var_9_11 = var_9_10[iter_9_2]

						var_9_8[#var_9_8 + 1] = var_9_11

						local var_9_12 = var_9_11.average_profiler_scope or 0

						if var_9_6 < var_9_12 then
							var_9_6 = var_9_12
							var_9_7 = var_9_11
						end
					end
				end
			end
		end

		local function var_9_13(arg_10_0, arg_10_1)
			return arg_10_0.name < arg_10_1.name
		end

		table.sort(var_9_8, var_9_13)

		for iter_9_3, iter_9_4 in ipairs(var_9_8) do
			arg_9_0:_draw_lookup_table(iter_9_4, iter_9_4 == var_9_7)
		end

		Imgui.tree_pop()
	end
end

function ImguiProfiler._apply_filter(arg_11_0, arg_11_1)
	local var_11_0 = arg_11_1.name

	if arg_11_1.frame_index and arg_11_1.frame_index < CURRENT_FRAME_INDEX then
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
			if iter_11_1.parent == var_11_0 and iter_11_1.frame_index == CURRENT_FRAME_INDEX then
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
