-- chunkname: @scripts/imgui/imgui_deus_map_gen.lua

ImguiDeusMapGen = class(ImguiDeusMapGen)

local AvailableJourneyOrder = AvailableJourneyOrder
local DEUS_GOD_INDEX = DEUS_GOD_INDEX
local tbl = {
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

local flag = true

ImguiDeusMapGen.init = function (self)
	-- function 3
	local var_3_0 = tonumber(script_data.debug_draw_base_map_seed)

	var_3_0 = var_3_0 or 0
	self._seed = var_3_0
	self._journey_index = 1
	self._dominant_god_index = 1

	self:_init_configs()

	flag = false
end

ImguiDeusMapGen.update = function (self)
	-- function 4
	if not flag then
		self:_init_configs()

		flag = false
	end
end

ImguiDeusMapGen.is_persistent = function (arg_5_0)
	-- function 5
	return false
end

ImguiDeusMapGen._init_configs = function (self)
	-- function 6
	self._original_populate_configs = DEUS_MAP_POPULATE_SETTINGS
	self._populate_configs = table.clone(DEUS_MAP_POPULATE_SETTINGS)

	self:_reset_configs_for_journey()
end

ImguiDeusMapGen._reset_configs_for_journey = function (self)
	-- function 7
	local var_7_0 = AvailableJourneyOrder[self._journey_index]
	local var_7_1 = DEUS_MAP_POPULATE_SETTINGS[var_7_0]

	var_7_1 = var_7_1 or DEUS_MAP_POPULATE_SETTINGS.default
	self._original_populate_config = var_7_1

	local var_7_2 = self._populate_configs[var_7_0]

	var_7_2 = var_7_2 or self._populate_configs.default
	self._populate_config = var_7_2
end

ImguiDeusMapGen.draw = function (self, arg_8_1)
	-- function 8
	local begin_window = Imgui.begin_window("DeusMapGen", "always_auto_resize")
	local _journey_index = self._journey_index

	self._journey_index = Imgui.combo("Journey to change", self._journey_index, AvailableJourneyOrder)

	if _journey_index ~= self._journey_index then
		self:_reset_configs_for_journey()
	end

	self._dominant_god_index = Imgui.combo("Dominant God", self._dominant_god_index, DEUS_GOD_INDEX)

	local _with_belakor = self._with_belakor

	_with_belakor = _with_belakor or false
	self._with_belakor = Imgui.checkbox("With Be'lakor", _with_belakor)

	if not Imgui.tree_node("PopulateSettings") then
		fn_2(tbl, self._populate_config, self._original_populate_config)
		Imgui.tree_pop()
	end

	Imgui.spacing()

	local script_data = script_data
	local checkbox = Imgui.checkbox
	local str = "print populate debug info"
	local deus_populate_graph_debug = script_data.deus_populate_graph_debug

	deus_populate_graph_debug = deus_populate_graph_debug or false
	script_data.deus_populate_graph_debug = checkbox(str, deus_populate_graph_debug)

	Imgui.spacing()

	self._seed = Imgui.input_int("seed", self._seed)

	Imgui.spacing()

	if not Imgui.button("Generate and show") then
		self:_trigger_graph_render()
	end

	if not Imgui.button("Set new seed, Generate and show") then
		self._seed = self._seed + 1

		self:_trigger_graph_render()
	end

	if not Imgui.button("Hide") then
		script_data.deus_debug_draw_map = false
		DeusDebugDrawMapSettings.base_graph = nil
		DeusDebugDrawMapSettings.final_graph = nil
	end

	if not Imgui.button("Force this seed and journey on the next game (can't have changes)") then
		script_data.deus_seed = self._seed
		script_data.deus_journey = AvailableJourneyOrder[self._journey_index]
		script_data.deus_dominant_god = DEUS_GOD_INDEX[self._dominant_god_index]
	end

	Imgui.spacing()
	Imgui.spacing()
	Imgui.end_window()

	return begin_window
end

ImguiDeusMapGen._trigger_graph_render = function (self)
	-- function 9
	script_data.deus_debug_draw_map = true

	local var_9_0 = deus_generate_graph(self._seed, AvailableJourneyOrder[self._journey_index], DEUS_GOD_INDEX[self._dominant_god_index], self._populate_config, self._with_belakor)

	DeusDebugDrawMapSettings.base_graph = nil
	DeusDebugDrawMapSettings.final_graph = var_9_0
end
