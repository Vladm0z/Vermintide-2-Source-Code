-- chunkname: @scripts/imgui/imgui_profiler.lua

ImguiProfiler = class(ImguiProfiler)

ImguiProfiler.init = function (self)
	-- function 1
	self._filter = ""
	self._filter_applied = false
	self._auto_update_filter = false
	self._pause_on_frame_spike = false
end

ImguiProfiler.is_persistent = function (arg_2_0)
	-- function 2
	return true
end

ImguiProfiler.on_show = function (arg_3_0)
	-- function 3
	CALCULATE_AVERAGE = true
end

ImguiProfiler.on_hide = function (arg_4_0)
	-- function 4
	CALCULATE_AVERAGE = false
end

ImguiProfiler.update = function (arg_5_0, arg_5_1, arg_5_2)
	-- function 5
	CALCULATE_AVERAGE = true
end

ImguiProfiler.draw = function (arg_6_0)
	-- function 6
	return
end

local num = 1

FILTERED_SCOPES = {}
FILTERED_SCOPES_INDEX = 1

ImguiProfiler.post_draw = function (self)
	-- function 7
	local begin_window = Imgui.begin_window("Profiler")

	Imgui.set_window_size(700, 512, "once")

	local input_int, var_7_2 = Imgui.input_int("Average over number of frames", PROFILE_FRAMES)

	if not var_7_2 then
		PROFILE_FRAMES = input_int
	end

	local flag = false
	local input_text, var_7_5 = Imgui.input_text("Filter", self._filter)

	if not var_7_5 then
		self._filter = input_text
		self._filter_applied = self._filter ~= ""
		flag = true
	end

	self._auto_update_filter = Imgui.checkbox("Auto Update Filter (affects performance)", self._auto_update_filter)

	if flag or not self._auto_update_filter then
		FILTERED_SCOPES_INDEX = 1

		local _paused_scope = self._paused_scope

		_paused_scope = _paused_scope or PROFILER_SCOPE_LOOKUP

		if self._filter ~= "" then
			self:_apply_filter(_paused_scope, false)
		end
	end

	self._pause_on_frame_spike = Imgui.checkbox("Pause on frame spike", self._pause_on_frame_spike)

	if not self._pause_on_frame_spike then
		local input_text_2 = Imgui.input_text
		local str = "Pause At Frametime (ms)"
		local _pause_on_frame_time_text = self._pause_on_frame_time_text

		_pause_on_frame_time_text = _pause_on_frame_time_text or "200"
		self._pause_on_frame_time_text = input_text_2(str, _pause_on_frame_time_text)

		local _pause_on_frame_time = self._pause_on_frame_time

		self._pause_on_frame_time = tonumber(self._pause_on_frame_time_text)

		if self._pause_on_frame_time ~= _pause_on_frame_time then
			self._paused_scope = nil
			self._paused_frame_index = nil
		end
	else
		self._pause_on_frame_time = nil
		self._paused_scope = nil
		self._paused_frame_index = nil
	end

	Imgui.begin_child_window("Profiler Tree", 0, 0, true)

	num = 1

	if not self._filter_applied then
		self:_draw_filtered_scopes()
	else
		local var_7_11 = self
		local _draw_lookup_table = self._draw_lookup_table
		local _paused_scope_2 = self._paused_scope

		_paused_scope_2 = _paused_scope_2 or PROFILER_SCOPE_LOOKUP

		_draw_lookup_table(var_7_11, _paused_scope_2, false)
	end

	Imgui.end_child_window()
	Imgui.end_window()

	return begin_window
end

ImguiProfiler._draw_filtered_scopes = function (self)
	-- function 8
	if FILTERED_SCOPES_INDEX > 1 then
		local tree_node = Imgui.tree_node("root", true)

		for i = 1, FILTERED_SCOPES_INDEX - 1 do
			local var_8_1 = FILTERED_SCOPES[i]

			self:_draw_lookup_table(var_8_1, false)
		end

		Imgui.tree_pop()
	else
		Imgui.text_colored(string.format("No scope includes the text %q", self._filter), 255, 128, 128, 255)
	end
end

ImguiProfiler._draw_lookup_table = function (self, arg_9_1, arg_9_2)
	-- function 9
	local name = arg_9_1.name

	if not arg_9_1.frame_index then
		local frame_index = arg_9_1.frame_index
		local _paused_frame_index = self._paused_frame_index

		_paused_frame_index = _paused_frame_index or CURRENT_FRAME_INDEX

		if frame_index < _paused_frame_index then
			return
		end
	end

	local flag = false
	local flag_2 = arg_9_1.is_leaf ~= false
	local profiler_scope

	if not self._paused_scope then
		profiler_scope = arg_9_1.profiler_scope

		if not profiler_scope then
			-- Nothing
		end
	end

	profiler_scope = arg_9_1.average_profiler_scope

	do
		local format
	end

	::label_9_0::

	if not profiler_scope then
		format = string.format("%.3f", profiler_scope)

		if not format then
			-- Nothing
		end
	end

	format = ""

	::label_9_1::

	local var_9_7

	if not flag_2 then
		var_9_7 = string.format("%s", arg_9_1.name, num)

		if not arg_9_2 then
			Imgui.text_colored(var_9_7, 0, 255, 0, 255)
		else
			Imgui.text(var_9_7)
		end

		Imgui.same_line()

		if not arg_9_2 then
			Imgui.text_colored(format, 0, 255, 0, 255)
		else
			Imgui.text_colored(format, 192, 128, 128, 255)
		end

		return
	elseif not arg_9_1.name then
		var_9_7 = string.format("%s ##%s", arg_9_1.name, num)
	else
		var_9_7 = "root"
		flag = true
	end

	num = num + 1

	local tree_node = Imgui.tree_node(var_9_7, flag)

	Imgui.same_line()

	if not arg_9_2 then
		Imgui.text_colored(format, 0, 255, 0, 255)
	else
		Imgui.text_colored(format, 192, 128, 128, 255)
	end

	if not tree_node then
		local num_2 = -1
		local str = ""
		local num_3 = 0
		local tbl = {}

		for k, v in pairs(arg_9_1) do
			if type(v) == "table" then
				if v.parent == name then
					local frame_index_2 = v.frame_index
					local _paused_frame_index_2 = self._paused_frame_index

					_paused_frame_index_2 = _paused_frame_index_2 or CURRENT_FRAME_INDEX

					if frame_index_2 == _paused_frame_index_2 then
						tbl[#tbl + 1] = v

						local profiler_scope_2

						if not self._paused_scope then
							profiler_scope_2 = v.profiler_scope

							if not profiler_scope_2 then
								-- Nothing
							end
						end

						profiler_scope_2 = v.average_profiler_scope
						profiler_scope_2 = profiler_scope_2 or 0

						::label_9_2::

						if num_2 < profiler_scope_2 then
							num_2 = profiler_scope_2
							str = v
						end

						num_3 = num_3 + v.profiler_scope
					end
				end

				local stack = v.stack

				if not stack then
					for k_2 = 1, stack.stack_index do
						local var_9_17 = stack[k_2]

						tbl[#tbl + 1] = var_9_17

						local profiler_scope_3

						if not self._paused_scope then
							profiler_scope_3 = var_9_17.profiler_scope

							if not profiler_scope_3 then
								-- Nothing
							end
						end

						profiler_scope_3 = var_9_17.average_profiler_scope
						profiler_scope_3 = profiler_scope_3 or 0

						::label_9_3::

						if num_2 < profiler_scope_3 then
							num_2 = profiler_scope_3
							str = var_9_17
						end
					end
				end
			end
		end

		local function fn(self, arg_10_1)
			-- function 10
			return self.name < arg_10_1.name
		end

		table.sort(tbl, fn)

		for i, v_2 in ipairs(tbl) do
			self:_draw_lookup_table(v_2, v_2 == str)
		end

		if not (not flag and self._paused_scope) then
			local _pause_on_frame_time = self._pause_on_frame_time

			_pause_on_frame_time = _pause_on_frame_time or math.huge

			if _pause_on_frame_time <= num_3 then
				self._paused_scope = table.clone(arg_9_1)
				self._paused_frame_index = CURRENT_FRAME_INDEX
			end
		end

		Imgui.tree_pop()
	end
end

ImguiProfiler._apply_filter = function (self, arg_11_1)
	-- function 11
	local name = arg_11_1.name

	if not arg_11_1.frame_index then
		local frame_index = arg_11_1.frame_index
		local _paused_frame_index = self._paused_frame_index

		_paused_frame_index = _paused_frame_index or CURRENT_FRAME_INDEX

		if frame_index < _paused_frame_index then
			return
		end
	end

	num = num + 1

	if not (not name and string.find(string.lower(name), string.lower(self._filter)) == nil) then
		FILTERED_SCOPES[FILTERED_SCOPES_INDEX] = arg_11_1
		FILTERED_SCOPES_INDEX = FILTERED_SCOPES_INDEX + 1

		return
	end

	local tbl = {}

	for k, v in pairs(arg_11_1) do
		if type(v) == "table" then
			if v.parent == name then
				local frame_index_2 = v.frame_index
				local _paused_frame_index_2 = self._paused_frame_index

				_paused_frame_index_2 = _paused_frame_index_2 or CURRENT_FRAME_INDEX

				if frame_index_2 == _paused_frame_index_2 then
					tbl[#tbl + 1] = v
				end
			end

			local stack = v.stack

			if not stack then
				for k_2 = 1, stack.stack_index do
					local var_11_7 = stack[k_2]

					tbl[#tbl + 1] = var_11_7
				end
			end
		end
	end

	local function fn(self, arg_12_1)
		-- function 12
		return self.name < arg_12_1.name
	end

	table.sort(tbl, fn)

	for i, v_2 in ipairs(tbl) do
		self:_apply_filter(v_2)
	end
end

ImguiProfiler.post_update = function (arg_13_0, arg_13_1, arg_13_2)
	-- function 13
	return
end
