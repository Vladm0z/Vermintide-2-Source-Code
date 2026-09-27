-- chunkname: @scripts/imgui/imgui_objectives_debug.lua

local flag = true

ImguiObjectivesDebug = class(ImguiObjectivesDebug)

ImguiObjectivesDebug.init = function (self)
	-- function 1
	self._objectives = {}
	self._timer = 0
	self._objective_system = nil
	self._initialized = false
	self._is_versus = false
	self._is_weave = false
	self._objective_lists = nil
end

ImguiObjectivesDebug._initialize = function (self)
	-- function 2
	self._objective_system = Managers.state.entity:system("objective_system")

	if not Managers.weave:get_active_weave() then
		self._is_weave = true
	elseif Managers.mechanism:current_mechanism_name() == "versus" then
		self._is_versus = true
		self._timer_paused = false
	end

	self._num_main_objectives = self._objective_system:num_main_objectives()
	self._initialized = true
end

ImguiObjectivesDebug.update = function (self)
	-- function 3
	if not flag then
		self:init()

		flag = false
	end

	if not self._initialized then
		self:_initialize()
	end

	self._objective_lists = self._objective_system:objective_lists()
	self._num_completed_main_objectives = self._objective_system:num_completed_main_objectives()
	self._current_objectives_index = self._objective_system:current_objective_index()
	self._num_current_sub_objectives = self._objective_system:num_current_sub_objectives()
	self._num_current_completed_sub_objectives = self._objective_system:num_current_completed_sub_objectives()

	if not self._is_versus then
		self:_update_versus()
	elseif not self._is_weave then
		self:_update_weave()
	end
end

ImguiObjectivesDebug._update_versus = function (self)
	-- function 4
	local game_mechanism = Managers.mechanism:game_mechanism()

	if not game_mechanism then
		self._timer = game_mechanism:win_conditions():round_timer()
	end
end

ImguiObjectivesDebug.is_persistent = function (arg_5_0)
	-- function 5
	return true
end

ImguiObjectivesDebug._temp = function (self, arg_6_1, arg_6_2, arg_6_3)
	-- function 6
	arg_6_3 = arg_6_3 or 1

	for k, v in pairs(arg_6_1) do
		if arg_6_3 == 1 or type(v) ~= "table" or not v.is_objective_root then
			if not Imgui.tree_node(k, not arg_6_2 and not v.completed) then
				self:_temp(v, arg_6_2, arg_6_3 + 1)

				if not (not arg_6_2 and v.completed) then
					Imgui.indent()

					if not Imgui.button("Complete Objective") then
						self._objective_system:complete_objective(k)
					end

					Imgui.unindent()
				end

				Imgui.tree_pop()
			end
		else
			Imgui.indent()

			if type(v) == "table" then
				if table.size(v) > 0 then
					Imgui.text(k .. ":")
					self:_temp(v, arg_6_2, arg_6_3 + 1)
				else
					Imgui.text(k .. ": {}")
				end
			else
				Imgui.text(k .. ": " .. tostring(v))
			end

			Imgui.unindent()
		end
	end
end

ImguiObjectivesDebug._same_line_dummy = function (arg_7_0, arg_7_1, arg_7_2)
	-- function 7
	Imgui.same_line()
	Imgui.dummy(arg_7_1, arg_7_2)
	Imgui.same_line()
end

ImguiObjectivesDebug._draw_versus = function (self, arg_8_1)
	-- function 8
	Imgui.text("Timer")
	Imgui.indent()
	Imgui.text("Pause")
	self:_same_line_dummy(0, 0)

	self._timer_paused = Imgui.checkbox("  ", self._timer_paused)
	script_data.versus_objective_timer_paused = self._timer_paused

	Imgui.text("Time")
	self:_same_line_dummy(7, 0)

	local slider_float = Imgui.slider_float(" ", self._timer, 0, 600)

	if math.abs(slider_float - self._timer) > math.epsilon then
		Managers.mechanism:game_mechanism():win_conditions():set_time(slider_float)

		self._timer = slider_float
	end

	Imgui.unindent()
	Imgui.dummy(0, 16)

	local _objective_system = self._objective_system

	Imgui.text(string.format("Total Num Main Objectives: %q", _objective_system._total_num_main_objectives))
	Imgui.text(string.format("Num Completed Main Objectives: %q", _objective_system._num_completed_main_objectives))
	Imgui.text(string.format("Num Completed Sub Objectives: %q", _objective_system._num_completed_sub_objectives))
	Imgui.text(string.format("Current Num Completed Main Objectives: %q", _objective_system._current_num_completed_main_objectives))
	Imgui.text(string.format("Current Num Optional Sub Objectives: %q", _objective_system._current_num_optional_sub_objectives))
end

ImguiObjectivesDebug.draw = function (self, arg_9_1)
	-- function 9
	local begin_window = Imgui.begin_window("Objectives Debug")

	Imgui.text(string.format("Completed Objectives: %s/%s", self._num_completed_main_objectives, self._num_main_objectives))
	Imgui.dummy(0, 16)

	if not self._is_versus then
		self:_draw_versus(arg_9_1)
	end

	Imgui.dummy(0, 16)
	Imgui.text("Objectives")
	Imgui.indent()

	if not self._objective_lists then
		for i, v in ipairs(self._objective_lists) do
			if i == self._current_objectives_index then
				Imgui.text(tostring(i))
			elseif i < self._current_objectives_index then
				Imgui.text_colored(tostring(i), 0, 255, 0, 255)
			else
				Imgui.text_colored(tostring(i), 255, 0, 0, 255)
			end

			self:_temp(v, i == self._current_objectives_index)
		end
	end

	Imgui.unindent()
	Imgui.end_window()

	return begin_window
end
