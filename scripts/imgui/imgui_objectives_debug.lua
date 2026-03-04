-- chunkname: @scripts/imgui/imgui_objectives_debug.lua

local var_0_0 = true

ImguiObjectivesDebug = class(ImguiObjectivesDebug)

ImguiObjectivesDebug.init = function (arg_1_0)
	arg_1_0._objectives = {}
	arg_1_0._timer = 0
	arg_1_0._objective_system = nil
	arg_1_0._initialized = false
	arg_1_0._is_versus = false
	arg_1_0._is_weave = false
	arg_1_0._objective_lists = nil
end

ImguiObjectivesDebug._initialize = function (arg_2_0)
	arg_2_0._objective_system = Managers.state.entity:system("objective_system")

	if Managers.weave:get_active_weave() then
		arg_2_0._is_weave = true
	elseif Managers.mechanism:current_mechanism_name() == "versus" then
		arg_2_0._is_versus = true
		arg_2_0._timer_paused = false
	end

	arg_2_0._num_main_objectives = arg_2_0._objective_system:num_main_objectives()
	arg_2_0._initialized = true
end

ImguiObjectivesDebug.update = function (arg_3_0)
	if var_0_0 then
		arg_3_0:init()

		var_0_0 = false
	end

	if not arg_3_0._initialized then
		arg_3_0:_initialize()
	end

	arg_3_0._objective_lists = arg_3_0._objective_system:objective_lists()
	arg_3_0._num_completed_main_objectives = arg_3_0._objective_system:num_completed_main_objectives()
	arg_3_0._current_objectives_index = arg_3_0._objective_system:current_objective_index()
	arg_3_0._num_current_sub_objectives = arg_3_0._objective_system:num_current_sub_objectives()
	arg_3_0._num_current_completed_sub_objectives = arg_3_0._objective_system:num_current_completed_sub_objectives()

	if arg_3_0._is_versus then
		arg_3_0:_update_versus()
	elseif arg_3_0._is_weave then
		arg_3_0:_update_weave()
	end
end

ImguiObjectivesDebug._update_versus = function (arg_4_0)
	local var_4_0 = Managers.mechanism:game_mechanism()

	if var_4_0 then
		arg_4_0._timer = var_4_0:win_conditions():round_timer()
	end
end

ImguiObjectivesDebug.is_persistent = function (arg_5_0)
	return true
end

ImguiObjectivesDebug._temp = function (arg_6_0, arg_6_1, arg_6_2, arg_6_3)
	arg_6_3 = arg_6_3 or 1

	for iter_6_0, iter_6_1 in pairs(arg_6_1) do
		if arg_6_3 == 1 or type(iter_6_1) == "table" and iter_6_1.is_objective_root then
			if Imgui.tree_node(iter_6_0, arg_6_2 and not iter_6_1.completed) then
				arg_6_0:_temp(iter_6_1, arg_6_2, arg_6_3 + 1)

				if arg_6_2 and not iter_6_1.completed then
					Imgui.indent()

					if Imgui.button("Complete Objective") then
						arg_6_0._objective_system:complete_objective(iter_6_0)
					end

					Imgui.unindent()
				end

				Imgui.tree_pop()
			end
		else
			Imgui.indent()

			if type(iter_6_1) == "table" then
				if table.size(iter_6_1) > 0 then
					Imgui.text(iter_6_0 .. ":")
					arg_6_0:_temp(iter_6_1, arg_6_2, arg_6_3 + 1)
				else
					Imgui.text(iter_6_0 .. ": {}")
				end
			else
				Imgui.text(iter_6_0 .. ": " .. tostring(iter_6_1))
			end

			Imgui.unindent()
		end
	end
end

ImguiObjectivesDebug._same_line_dummy = function (arg_7_0, arg_7_1, arg_7_2)
	Imgui.same_line()
	Imgui.dummy(arg_7_1, arg_7_2)
	Imgui.same_line()
end

ImguiObjectivesDebug._draw_versus = function (arg_8_0, arg_8_1)
	Imgui.text("Timer")
	Imgui.indent()
	Imgui.text("Pause")
	arg_8_0:_same_line_dummy(0, 0)

	arg_8_0._timer_paused = Imgui.checkbox("  ", arg_8_0._timer_paused)
	script_data.versus_objective_timer_paused = arg_8_0._timer_paused

	Imgui.text("Time")
	arg_8_0:_same_line_dummy(7, 0)

	local var_8_0 = Imgui.slider_float(" ", arg_8_0._timer, 0, 600)

	if math.abs(var_8_0 - arg_8_0._timer) > math.epsilon then
		Managers.mechanism:game_mechanism():win_conditions():set_time(var_8_0)

		arg_8_0._timer = var_8_0
	end

	Imgui.unindent()
	Imgui.dummy(0, 16)

	local var_8_1 = arg_8_0._objective_system

	Imgui.text(string.format("Total Num Main Objectives: %q", var_8_1._total_num_main_objectives))
	Imgui.text(string.format("Num Completed Main Objectives: %q", var_8_1._num_completed_main_objectives))
	Imgui.text(string.format("Num Completed Sub Objectives: %q", var_8_1._num_completed_sub_objectives))
	Imgui.text(string.format("Current Num Completed Main Objectives: %q", var_8_1._current_num_completed_main_objectives))
	Imgui.text(string.format("Current Num Optional Sub Objectives: %q", var_8_1._current_num_optional_sub_objectives))
end

ImguiObjectivesDebug.draw = function (arg_9_0, arg_9_1)
	local var_9_0 = Imgui.begin_window("Objectives Debug")

	Imgui.text(string.format("Completed Objectives: %s/%s", arg_9_0._num_completed_main_objectives, arg_9_0._num_main_objectives))
	Imgui.dummy(0, 16)

	if arg_9_0._is_versus then
		arg_9_0:_draw_versus(arg_9_1)
	end

	Imgui.dummy(0, 16)
	Imgui.text("Objectives")
	Imgui.indent()

	if arg_9_0._objective_lists then
		for iter_9_0, iter_9_1 in ipairs(arg_9_0._objective_lists) do
			if iter_9_0 == arg_9_0._current_objectives_index then
				Imgui.text(tostring(iter_9_0))
			elseif iter_9_0 < arg_9_0._current_objectives_index then
				Imgui.text_colored(tostring(iter_9_0), 0, 255, 0, 255)
			else
				Imgui.text_colored(tostring(iter_9_0), 255, 0, 0, 255)
			end

			arg_9_0:_temp(iter_9_1, iter_9_0 == arg_9_0._current_objectives_index)
		end
	end

	Imgui.unindent()
	Imgui.end_window()

	return var_9_0
end
