-- chunkname: @scripts/imgui/imgui_deus_map_gen.lua

ImguiDeusMapGen = class(ImguiDeusMapGen)

local var_0_0 = AvailableJourneyOrder
local var_0_1 = DEUS_GOD_INDEX
local var_0_2 = {
	{
		type = "INT",
		key = "CURSES_HOT_SPOTS_MIN_COUNT"
	},
	{
		type = "INT",
		key = "CURSES_HOT_SPOTS_MAX_COUNT"
	},
	{
		type = "FLOAT",
		key = "CURSES_HOT_SPOT_MIN_RANGE"
	},
	{
		type = "FLOAT",
		key = "CURSES_HOT_SPOT_MAX_RANGE"
	},
	{
		type = "FLOAT",
		key = "CURSES_MIN_PROGRESS"
	},
	{
		type = "FLOAT",
		key = "MINOR_MODIFIABLE_NODE_CHANCE"
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

local var_0_5 = true

ImguiDeusMapGen.init = function (arg_3_0)
	arg_3_0._seed = tonumber(script_data.debug_draw_base_map_seed) or 0
	arg_3_0._journey_index = 1
	arg_3_0._dominant_god_index = 1

	arg_3_0:_init_configs()

	var_0_5 = false
end

ImguiDeusMapGen.update = function (arg_4_0)
	if var_0_5 then
		arg_4_0:_init_configs()

		var_0_5 = false
	end
end

ImguiDeusMapGen.is_persistent = function (arg_5_0)
	return false
end

ImguiDeusMapGen._init_configs = function (arg_6_0)
	arg_6_0._original_populate_configs = DEUS_MAP_POPULATE_SETTINGS
	arg_6_0._populate_configs = table.clone(DEUS_MAP_POPULATE_SETTINGS)

	arg_6_0:_reset_configs_for_journey()
end

ImguiDeusMapGen._reset_configs_for_journey = function (arg_7_0)
	local var_7_0 = var_0_0[arg_7_0._journey_index]

	arg_7_0._original_populate_config = DEUS_MAP_POPULATE_SETTINGS[var_7_0] or DEUS_MAP_POPULATE_SETTINGS.default
	arg_7_0._populate_config = arg_7_0._populate_configs[var_7_0] or arg_7_0._populate_configs.default
end

ImguiDeusMapGen.draw = function (arg_8_0, arg_8_1)
	local var_8_0 = Imgui.begin_window("DeusMapGen", "always_auto_resize")
	local var_8_1 = arg_8_0._journey_index

	arg_8_0._journey_index = Imgui.combo("Journey to change", arg_8_0._journey_index, var_0_0)

	if var_8_1 ~= arg_8_0._journey_index then
		arg_8_0:_reset_configs_for_journey()
	end

	arg_8_0._dominant_god_index = Imgui.combo("Dominant God", arg_8_0._dominant_god_index, var_0_1)

	local var_8_2 = arg_8_0._with_belakor or false

	arg_8_0._with_belakor = Imgui.checkbox("With Be'lakor", var_8_2)

	if Imgui.tree_node("PopulateSettings") then
		var_0_4(var_0_2, arg_8_0._populate_config, arg_8_0._original_populate_config)
		Imgui.tree_pop()
	end

	Imgui.spacing()

	script_data.deus_populate_graph_debug = Imgui.checkbox("print populate debug info", script_data.deus_populate_graph_debug or false)

	Imgui.spacing()

	arg_8_0._seed = Imgui.input_int("seed", arg_8_0._seed)

	Imgui.spacing()

	if Imgui.button("Generate and show") then
		arg_8_0:_trigger_graph_render()
	end

	if Imgui.button("Set new seed, Generate and show") then
		arg_8_0._seed = arg_8_0._seed + 1

		arg_8_0:_trigger_graph_render()
	end

	if Imgui.button("Hide") then
		script_data.deus_debug_draw_map = false
		DeusDebugDrawMapSettings.base_graph = nil
		DeusDebugDrawMapSettings.final_graph = nil
	end

	if Imgui.button("Force this seed and journey on the next game (can't have changes)") then
		script_data.deus_seed = arg_8_0._seed
		script_data.deus_journey = var_0_0[arg_8_0._journey_index]
		script_data.deus_dominant_god = var_0_1[arg_8_0._dominant_god_index]
	end

	Imgui.spacing()
	Imgui.spacing()
	Imgui.end_window()

	return var_8_0
end

ImguiDeusMapGen._trigger_graph_render = function (arg_9_0)
	script_data.deus_debug_draw_map = true

	local var_9_0 = deus_generate_graph(arg_9_0._seed, var_0_0[arg_9_0._journey_index], var_0_1[arg_9_0._dominant_god_index], arg_9_0._populate_config, arg_9_0._with_belakor)

	DeusDebugDrawMapSettings.base_graph = nil
	DeusDebugDrawMapSettings.final_graph = var_9_0
end
