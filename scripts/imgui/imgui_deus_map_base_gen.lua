-- chunkname: @scripts/imgui/imgui_deus_map_base_gen.lua

ImguiDeusMapBaseGen = class(ImguiDeusMapBaseGen)

local var_0_0 = AvailableJourneyOrder
local var_0_1 = {
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
local var_0_2 = {
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

local function var_0_3(arg_1_0, arg_1_1)
	return math.round(arg_1_0 * 10000) ~= math.round(arg_1_1 * 10000)
end

local function var_0_4(arg_2_0, arg_2_1, arg_2_2)
	for iter_2_0, iter_2_1 in ipairs(arg_2_0) do
		if iter_2_1.type == "FLOAT" then
			arg_2_1[iter_2_1.key] = Imgui.input_float(iter_2_1.key, arg_2_1[iter_2_1.key])
		elseif iter_2_1.type == "INT" then
			arg_2_1[iter_2_1.key] = Imgui.input_int(iter_2_1.key, arg_2_1[iter_2_1.key])
		end

		if var_0_3(arg_2_1[iter_2_1.key], arg_2_2[iter_2_1.key]) then
			Imgui.same_line()
			Imgui.text("<changed>")
		end
	end
end

local function var_0_5(arg_3_0, arg_3_1, arg_3_2)
	for iter_3_0, iter_3_1 in ipairs(arg_3_0) do
		if var_0_3(arg_3_1[iter_3_1.key], arg_3_2[iter_3_1.key]) then
			return true
		end
	end
end

local function var_0_6(arg_4_0, arg_4_1)
	for iter_4_0 = 1, arg_4_1 do
		arg_4_0[#arg_4_0 + 1] = "\t"
	end
end

local function var_0_7(arg_5_0, arg_5_1, arg_5_2)
	for iter_5_0, iter_5_1 in pairs(arg_5_2) do
		var_0_6(arg_5_0, arg_5_1)

		if type(iter_5_0) == "string" then
			arg_5_0[#arg_5_0 + 1] = iter_5_0
		else
			arg_5_0[#arg_5_0 + 1] = "["
			arg_5_0[#arg_5_0 + 1] = tostring(iter_5_0)
			arg_5_0[#arg_5_0 + 1] = "]"
		end

		arg_5_0[#arg_5_0 + 1] = " = "

		local var_5_0 = type(iter_5_1)

		if var_5_0 == "string" then
			arg_5_0[#arg_5_0 + 1] = "\""
			arg_5_0[#arg_5_0 + 1] = iter_5_1
			arg_5_0[#arg_5_0 + 1] = "\""
		elseif var_5_0 == "table" then
			arg_5_0[#arg_5_0 + 1] = "{\n"
			arg_5_1 = arg_5_1 + 1

			var_0_7(arg_5_0, arg_5_1, iter_5_1)

			arg_5_1 = arg_5_1 - 1

			var_0_6(arg_5_0, arg_5_1)

			arg_5_0[#arg_5_0 + 1] = "}"
		else
			arg_5_0[#arg_5_0 + 1] = tostring(iter_5_1)
		end

		arg_5_0[#arg_5_0 + 1] = ",\n"
	end
end

local function var_0_8(arg_6_0)
	local var_6_0 = {}

	var_6_0[#var_6_0 + 1] = "return {\n"

	var_0_7(var_6_0, 1, arg_6_0)

	var_6_0[#var_6_0 + 1] = "}\n"

	return table.concat(var_6_0)
end

local var_0_9 = true

ImguiDeusMapBaseGen.init = function (arg_7_0)
	arg_7_0._seed = tonumber(script_data.debug_draw_base_map_seed) or 0
	arg_7_0._journey_index = 1
	arg_7_0._draw_realtime = false
	arg_7_0._start_paused = false

	arg_7_0:_init_configs()

	var_0_9 = false
end

local var_0_10 = {
	LAYOUT = 2,
	BASE_GEN = 1
}

ImguiDeusMapBaseGen.update = function (arg_8_0, arg_8_1, arg_8_2)
	if var_0_9 then
		arg_8_0:_init_configs()

		var_0_9 = false
	end

	if arg_8_0._seed_to_render then
		arg_8_0._generator_seed = arg_8_0._seed_to_render
		arg_8_0._seed_to_render = nil
		arg_8_0._generation_state = var_0_10.BASE_GEN
		arg_8_0._base_graph_generator = nil
		arg_8_0._layout_updater = nil
		arg_8_0._nodes_being_generated = nil
		arg_8_0._paused = false
		arg_8_0._next_step = false
		DeusDebugDrawMapSettings.error_message = nil
		DeusDebugDrawMapSettings.base_graph = nil
		DeusDebugDrawMapSettings.final_graph = nil
	end

	if arg_8_0._generation_state == var_0_10.BASE_GEN then
		if not arg_8_0._base_graph_generator then
			arg_8_0._base_graph_generator = deus_base_graph_generator(arg_8_0._generator_seed, arg_8_0._base_config)

			if arg_8_0._draw_realtime and arg_8_0._start_paused then
				arg_8_0._paused = true
			end
		end

		local var_8_0
		local var_8_1
		local var_8_2

		if not arg_8_0._paused or arg_8_0._next_step then
			if arg_8_0._draw_realtime then
				var_8_0, var_8_1, var_8_2 = arg_8_0._base_graph_generator()
				DeusDebugDrawMapSettings.base_graph = deus_layout_normalize(var_8_2)
				DeusDebugDrawMapSettings.final_graph = nil
			else
				local var_8_3 = os.clock()

				while not var_8_0 and not (os.clock() - var_8_3 > 0.01) do
					var_8_0, var_8_1, var_8_2 = arg_8_0._base_graph_generator()
				end

				DeusDebugDrawMapSettings.base_graph = deus_layout_normalize(var_8_2)
				DeusDebugDrawMapSettings.final_graph = nil
			end
		end

		arg_8_0._nodes_being_generated = var_8_2

		if var_8_0 then
			if var_8_1 then
				arg_8_0._generation_state = nil
				DeusDebugDrawMapSettings.error_message = var_8_1
			else
				arg_8_0._generation_state = var_0_10.LAYOUT
			end
		end
	elseif arg_8_0._generation_state == var_0_10.LAYOUT then
		local var_8_4

		if not arg_8_0._paused or arg_8_0._next_step then
			if arg_8_0._draw_realtime then
				if not arg_8_0._layout_updater then
					arg_8_0._layout_updater = debug_deus_create_realtime_layout_updater(arg_8_0._nodes_being_generated, arg_8_0._layout_config)

					if arg_8_0._draw_realtime and arg_8_0._start_paused then
						arg_8_0._paused = true
					end
				end

				local var_8_5
				local var_8_6

				var_8_6, var_8_4 = arg_8_0._layout_updater()
				arg_8_0._nodes_being_generated = var_8_4

				if var_8_6 then
					arg_8_0._generation_state = nil
					arg_8_0._graph_to_save = arg_8_0._nodes_being_generated
					arg_8_0._nodes_being_generated = nil
				end
			else
				var_8_4 = deus_layout_base_graph(arg_8_0._nodes_being_generated, arg_8_0._layout_config)
				arg_8_0._generation_state = nil
				arg_8_0._graph_to_save = var_8_4
				arg_8_0._nodes_being_generated = nil
			end

			DeusDebugDrawMapSettings.base_graph = var_8_4
			DeusDebugDrawMapSettings.final_graph = nil
		end
	end

	arg_8_0._next_step = false
end

ImguiDeusMapBaseGen.is_persistent = function (arg_9_0)
	return false
end

ImguiDeusMapBaseGen._init_configs = function (arg_10_0)
	arg_10_0._original_layout_configs = DEUS_MAP_LAYOUT_SETTINGS
	arg_10_0._layout_configs = table.clone(DEUS_MAP_LAYOUT_SETTINGS)
	arg_10_0._original_base_configs = DEUS_BASE_MAP_GEN_SETTINGS
	arg_10_0._base_configs = table.clone(DEUS_BASE_MAP_GEN_SETTINGS)

	arg_10_0:_reset_configs_for_journey()

	arg_10_0._configs_changed = false
end

ImguiDeusMapBaseGen._reset_configs_for_journey = function (arg_11_0)
	local var_11_0 = var_0_0[arg_11_0._journey_index]

	arg_11_0._original_layout_config = DEUS_MAP_LAYOUT_SETTINGS[var_11_0] or DEUS_MAP_LAYOUT_SETTINGS.default
	arg_11_0._layout_config = arg_11_0._layout_configs[var_11_0] or arg_11_0._layout_configs.default
	arg_11_0._original_base_config = DEUS_BASE_MAP_GEN_SETTINGS[var_11_0] or DEUS_BASE_MAP_GEN_SETTINGS.default
	arg_11_0._base_config = arg_11_0._base_configs[var_11_0] or arg_11_0._base_configs.default
end

ImguiDeusMapBaseGen.draw = function (arg_12_0, arg_12_1)
	local var_12_0 = Imgui.begin_window("DeusMapBaseGen", "always_auto_resize")

	if arg_12_0._saved_graphs then
		Imgui.text("Saving for " .. var_0_0[arg_12_0._journey_index])
	else
		local var_12_1 = arg_12_0._journey_index

		arg_12_0._journey_index = Imgui.combo("Journey to change", arg_12_0._journey_index, var_0_0)

		if var_12_1 ~= arg_12_0._journey_index then
			arg_12_0:_reset_configs_for_journey()

			arg_12_0._configs_changed = false
		end

		if Imgui.tree_node("BaseGenSettings") then
			var_0_4(var_0_2, arg_12_0._base_config, arg_12_0._original_base_config)
			Imgui.tree_pop()
		end

		if Imgui.tree_node("LayoutSettings") then
			var_0_4(var_0_1, arg_12_0._layout_config, arg_12_0._original_layout_config)
			Imgui.tree_pop()
		end

		arg_12_0._configs_changed = var_0_5(var_0_2, arg_12_0._base_config, arg_12_0._original_base_config) or var_0_5(var_0_1, arg_12_0._layout_config, arg_12_0._original_layout_config)

		Imgui.spacing()
	end

	arg_12_0._draw_realtime = Imgui.checkbox("see realtime layouting", arg_12_0._draw_realtime)

	if arg_12_0._draw_realtime then
		script_data.deus_base_graph_generator_debug = Imgui.checkbox("print gen debug info", script_data.deus_base_graph_generator_debug or false)
	else
		script_data.deus_base_graph_generator_debug = false
	end

	if not arg_12_0._generation_state then
		if arg_12_0._draw_realtime then
			arg_12_0._start_paused = Imgui.checkbox("start paused", arg_12_0._start_paused)
		end

		Imgui.spacing()

		arg_12_0._seed = Imgui.input_int("seed", arg_12_0._seed)

		Imgui.spacing()

		if Imgui.button("Generate and show") then
			arg_12_0._seed_to_render = arg_12_0._seed
			script_data.deus_debug_draw_map = true
		end

		if Imgui.button("Set new seed, Generate and show") then
			arg_12_0._seed = arg_12_0._seed + 1
			arg_12_0._seed_to_render = arg_12_0._seed
			script_data.deus_debug_draw_map = true
		end

		if arg_12_0._graph_to_save then
			if not arg_12_0._configs_changed then
				if Imgui.button("Save seed") then
					if not arg_12_0._saved_graphs then
						arg_12_0._saved_graphs = {
							[arg_12_0._seed] = arg_12_0._graph_to_save
						}
					else
						arg_12_0._saved_graphs[arg_12_0._seed] = arg_12_0._graph_to_save
					end

					arg_12_0._graph_to_save = nil
				end
			else
				Imgui.text("You can't save seeds with changed configs.")
				Imgui.text("Save your changes first to the lua config files and then save seeds.")
			end
		end
	else
		if arg_12_0._paused then
			if Imgui.button("Next Step") then
				arg_12_0._next_step = true
			end

			if Imgui.button("Continue") then
				arg_12_0._paused = false
			end
		elseif Imgui.button("Pause") then
			arg_12_0._paused = true
		end

		if Imgui.button("Stop") then
			arg_12_0._generation_state = nil
			arg_12_0._next_step = false
			arg_12_0._paused = false
		end
	end

	if Imgui.button("Hide") then
		script_data.deus_debug_draw_map = false
	end

	Imgui.spacing()
	Imgui.spacing()

	if arg_12_0._saved_graphs and not arg_12_0._configs_changed then
		local var_12_2 = 0

		for iter_12_0, iter_12_1 in pairs(arg_12_0._saved_graphs) do
			var_12_2 = var_12_2 + 1
		end

		Imgui.text("Saved graphs " .. var_12_2)

		if Imgui.button("Copy Saved Graphs to Clipboard") then
			Clipboard.put(var_0_8(arg_12_0._saved_graphs))
		end

		if Imgui.button("Clear Saved Graphs") then
			arg_12_0._saved_graphs = nil
		end
	end

	Imgui.end_window()

	return var_12_0
end
