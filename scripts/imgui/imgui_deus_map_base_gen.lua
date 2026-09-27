-- chunkname: @scripts/imgui/imgui_deus_map_base_gen.lua

ImguiDeusMapBaseGen = class(ImguiDeusMapBaseGen)

local AvailableJourneyOrder = AvailableJourneyOrder
local tbl = {
	{
		type = "FLOAT",
		key = "SPRING_CONSTANT"
	},
	{
		type = "FLOAT",
		key = "FORCE_MAX"
	},
	{
		type = "FLOAT",
		key = "REPEL_CONSTANT"
	},
	{
		type = "FLOAT",
		key = "DEFAULT_MASS"
	},
	{
		type = "FLOAT",
		key = "START_MASS"
	},
	{
		type = "FLOAT",
		key = "END_MASS"
	},
	{
		type = "FLOAT",
		key = "NODE_SPEED"
	},
	{
		type = "FLOAT",
		key = "DAMPING_FACTOR"
	},
	{
		type = "INT",
		key = "WIDTH"
	},
	{
		type = "INT",
		key = "HEIGHT"
	},
	{
		type = "INT",
		key = "LAYOUT_TICKS"
	}
}
local tbl_2 = {
	{
		type = "INT",
		key = "MAX_STRAIGHT_LINE"
	},
	{
		type = "INT",
		key = "MAX_IDEAL_NODES"
	},
	{
		type = "INT",
		key = "MIN_NODES"
	},
	{
		type = "INT",
		key = "MAX_CONNECTIONS_PER_NODE"
	},
	{
		type = "INT",
		key = "MAX_INCOMING_CONNECTIONS_PER_NODE"
	},
	{
		type = "INT",
		key = "MAX_PATHS"
	}
}

local function fn(arg_1_0, arg_1_1)
	-- function 1
	return math.round(arg_1_0 * 10000) ~= math.round(arg_1_1 * 10000)
end

local function fn_2(arg_2_0, arg_2_1, arg_2_2)
	-- function 2
	for i, v in ipairs(arg_2_0) do
		if v.type == "FLOAT" then
			arg_2_1[v.key] = Imgui.input_float(v.key, arg_2_1[v.key])
		elseif v.type == "INT" then
			arg_2_1[v.key] = Imgui.input_int(v.key, arg_2_1[v.key])
		end

		if not fn(arg_2_1[v.key], arg_2_2[v.key]) then
			Imgui.same_line()
			Imgui.text("<changed>")
		end
	end
end

local function fn_3(arg_3_0, arg_3_1, arg_3_2)
	-- function 3
	for i, v in ipairs(arg_3_0) do
		if not fn(arg_3_1[v.key], arg_3_2[v.key]) then
			return true
		end
	end
end

local function fn_4(self, arg_4_1)
	-- function 4
	for i = 1, arg_4_1 do
		self[#self + 1] = "\t"
	end
end

local function fn_5(self, arg_5_1, arg_5_2)
	-- function 5
	for k, v in pairs(arg_5_2) do
		fn_4(self, arg_5_1)

		if type(k) == "string" then
			self[#self + 1] = k
		else
			self[#self + 1] = "["
			self[#self + 1] = tostring(k)
			self[#self + 1] = "]"
		end

		self[#self + 1] = " = "

		local var_5_0 = type(v)

		if var_5_0 == "string" then
			self[#self + 1] = "\""
			self[#self + 1] = v
			self[#self + 1] = "\""
		elseif var_5_0 == "table" then
			self[#self + 1] = "{\n"
			arg_5_1 = arg_5_1 + 1

			fn_5(self, arg_5_1, v)

			arg_5_1 = arg_5_1 - 1

			fn_4(self, arg_5_1)

			self[#self + 1] = "}"
		else
			self[#self + 1] = tostring(v)
		end

		self[#self + 1] = ",\n"
	end
end

local function fn_6(arg_6_0)
	-- function 6
	local tbl = {}

	tbl[#tbl + 1] = "return {\n"

	fn_5(tbl, 1, arg_6_0)

	tbl[#tbl + 1] = "}\n"

	return table.concat(tbl)
end

local flag = true

ImguiDeusMapBaseGen.init = function (self)
	-- function 7
	local var_7_0 = tonumber(script_data.debug_draw_base_map_seed)

	var_7_0 = var_7_0 or 0
	self._seed = var_7_0
	self._journey_index = 1
	self._draw_realtime = false
	self._start_paused = false

	self:_init_configs()

	flag = false
end

local tbl_3 = {
	LAYOUT = 2,
	BASE_GEN = 1
}

ImguiDeusMapBaseGen.update = function (self, arg_8_1, arg_8_2)
	-- function 8
	if not flag then
		self:_init_configs()

		flag = false
	end

	if not self._seed_to_render then
		self._generator_seed = self._seed_to_render
		self._seed_to_render = nil
		self._generation_state = tbl_3.BASE_GEN
		self._base_graph_generator = nil
		self._layout_updater = nil
		self._nodes_being_generated = nil
		self._paused = false
		self._next_step = false
		DeusDebugDrawMapSettings.error_message = nil
		DeusDebugDrawMapSettings.base_graph = nil
		DeusDebugDrawMapSettings.final_graph = nil
	end

	if self._generation_state == tbl_3.BASE_GEN then
		if not self._base_graph_generator then
			self._base_graph_generator = deus_base_graph_generator(self._generator_seed, self._base_config)

			if not self._draw_realtime and not self._start_paused then
				self._paused = true
			end
		end

		local var_8_0
		local var_8_1
		local var_8_2

		if not self._paused and not self._next_step then
			if not self._draw_realtime then
				var_8_0, var_8_1, var_8_2 = self._base_graph_generator()
				DeusDebugDrawMapSettings.base_graph = deus_layout_normalize(var_8_2)
				DeusDebugDrawMapSettings.final_graph = nil
			else
				local clock = os.clock()

				while not (var_8_0 or os.clock() - clock > 0.01) do
					var_8_0, var_8_1, var_8_2 = self._base_graph_generator()
				end

				DeusDebugDrawMapSettings.base_graph = deus_layout_normalize(var_8_2)
				DeusDebugDrawMapSettings.final_graph = nil
			end
		end

		self._nodes_being_generated = var_8_2

		if not var_8_0 then
			if not var_8_1 then
				self._generation_state = nil
				DeusDebugDrawMapSettings.error_message = var_8_1
			else
				self._generation_state = tbl_3.LAYOUT
			end
		end
	elseif self._generation_state == tbl_3.LAYOUT then
		local var_8_4

		if not self._paused and not self._next_step then
			if not self._draw_realtime then
				if not self._layout_updater then
					self._layout_updater = debug_deus_create_realtime_layout_updater(self._nodes_being_generated, self._layout_config)

					if not self._draw_realtime and not self._start_paused then
						self._paused = true
					end
				end

				local var_8_5
				local _layout_updater

				_layout_updater, var_8_4 = self._layout_updater()
				self._nodes_being_generated = var_8_4

				if not _layout_updater then
					self._generation_state = nil
					self._graph_to_save = self._nodes_being_generated
					self._nodes_being_generated = nil
				end
			else
				var_8_4 = deus_layout_base_graph(self._nodes_being_generated, self._layout_config)
				self._generation_state = nil
				self._graph_to_save = var_8_4
				self._nodes_being_generated = nil
			end

			DeusDebugDrawMapSettings.base_graph = var_8_4
			DeusDebugDrawMapSettings.final_graph = nil
		end
	end

	self._next_step = false
end

ImguiDeusMapBaseGen.is_persistent = function (arg_9_0)
	-- function 9
	return false
end

ImguiDeusMapBaseGen._init_configs = function (self)
	-- function 10
	self._original_layout_configs = DEUS_MAP_LAYOUT_SETTINGS
	self._layout_configs = table.clone(DEUS_MAP_LAYOUT_SETTINGS)
	self._original_base_configs = DEUS_BASE_MAP_GEN_SETTINGS
	self._base_configs = table.clone(DEUS_BASE_MAP_GEN_SETTINGS)

	self:_reset_configs_for_journey()

	self._configs_changed = false
end

ImguiDeusMapBaseGen._reset_configs_for_journey = function (self)
	-- function 11
	local var_11_0 = AvailableJourneyOrder[self._journey_index]
	local var_11_1 = DEUS_MAP_LAYOUT_SETTINGS[var_11_0]

	var_11_1 = var_11_1 or DEUS_MAP_LAYOUT_SETTINGS.default
	self._original_layout_config = var_11_1

	local var_11_2 = self._layout_configs[var_11_0]

	var_11_2 = var_11_2 or self._layout_configs.default
	self._layout_config = var_11_2

	local var_11_3 = DEUS_BASE_MAP_GEN_SETTINGS[var_11_0]

	var_11_3 = var_11_3 or DEUS_BASE_MAP_GEN_SETTINGS.default
	self._original_base_config = var_11_3

	local var_11_4 = self._base_configs[var_11_0]

	var_11_4 = var_11_4 or self._base_configs.default
	self._base_config = var_11_4
end

ImguiDeusMapBaseGen.draw = function (self, arg_12_1)
	-- function 12
	local begin_window = Imgui.begin_window("DeusMapBaseGen", "always_auto_resize")

	if not self._saved_graphs then
		Imgui.text("Saving for " .. AvailableJourneyOrder[self._journey_index])
	else
		local _journey_index = self._journey_index

		self._journey_index = Imgui.combo("Journey to change", self._journey_index, AvailableJourneyOrder)

		if _journey_index ~= self._journey_index then
			self:_reset_configs_for_journey()

			self._configs_changed = false
		end

		if not Imgui.tree_node("BaseGenSettings") then
			fn_2(tbl_2, self._base_config, self._original_base_config)
			Imgui.tree_pop()
		end

		if not Imgui.tree_node("LayoutSettings") then
			fn_2(tbl, self._layout_config, self._original_layout_config)
			Imgui.tree_pop()
		end

		local var_12_2 = fn_3(tbl_2, self._base_config, self._original_base_config)

		var_12_2 = var_12_2 or fn_3(tbl, self._layout_config, self._original_layout_config)
		self._configs_changed = var_12_2

		Imgui.spacing()
	end

	self._draw_realtime = Imgui.checkbox("see realtime layouting", self._draw_realtime)

	if not self._draw_realtime then
		local script_data = script_data
		local checkbox = Imgui.checkbox
		local str = "print gen debug info"
		local deus_base_graph_generator_debug = script_data.deus_base_graph_generator_debug

		deus_base_graph_generator_debug = deus_base_graph_generator_debug or false
		script_data.deus_base_graph_generator_debug = checkbox(str, deus_base_graph_generator_debug)
	else
		script_data.deus_base_graph_generator_debug = false
	end

	if not self._generation_state then
		if not self._draw_realtime then
			self._start_paused = Imgui.checkbox("start paused", self._start_paused)
		end

		Imgui.spacing()

		self._seed = Imgui.input_int("seed", self._seed)

		Imgui.spacing()

		if not Imgui.button("Generate and show") then
			self._seed_to_render = self._seed
			script_data.deus_debug_draw_map = true
		end

		if not Imgui.button("Set new seed, Generate and show") then
			self._seed = self._seed + 1
			self._seed_to_render = self._seed
			script_data.deus_debug_draw_map = true
		end

		if not self._graph_to_save then
			if not self._configs_changed then
				if not Imgui.button("Save seed") then
					if not self._saved_graphs then
						self._saved_graphs = {
							[self._seed] = self._graph_to_save
						}
					else
						self._saved_graphs[self._seed] = self._graph_to_save
					end

					self._graph_to_save = nil
				end
			else
				Imgui.text("You can't save seeds with changed configs.")
				Imgui.text("Save your changes first to the lua config files and then save seeds.")
			end
		end
	else
		if not self._paused then
			if not Imgui.button("Next Step") then
				self._next_step = true
			end

			if not Imgui.button("Continue") then
				self._paused = false
			end
		elseif not Imgui.button("Pause") then
			self._paused = true
		end

		if not Imgui.button("Stop") then
			self._generation_state = nil
			self._next_step = false
			self._paused = false
		end
	end

	if not Imgui.button("Hide") then
		script_data.deus_debug_draw_map = false
	end

	Imgui.spacing()
	Imgui.spacing()

	if not (not self._saved_graphs and self._configs_changed) then
		local num = 0

		for k, v in pairs(self._saved_graphs) do
			num = num + 1
		end

		Imgui.text("Saved graphs " .. num)

		if not Imgui.button("Copy Saved Graphs to Clipboard") then
			Clipboard.put(fn_6(self._saved_graphs))
		end

		if not Imgui.button("Clear Saved Graphs") then
			self._saved_graphs = nil
		end
	end

	Imgui.end_window()

	return begin_window
end
