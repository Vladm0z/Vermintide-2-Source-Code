-- chunkname: @scripts/imgui/imgui_terror_event_debug.lua

ImguiTerrorEventDebug = class(ImguiTerrorEventDebug)

local tbl = {
	"normal",
	"hard",
	"harder",
	"hardest",
	"cataclysm"
}
local tbl_2 = {}

for i = -DifficultyTweak.range, DifficultyTweak.range do
	tbl_2[#tbl_2 + 1] = i
end

local function fn()
	-- function 1
	if not Managers.state.game_mode then
		return
	end

	return (Managers.level_transition_handler:get_current_level_keys())
end

ImguiTerrorEventDebug.init = function (self)
	-- function 2
	self._level_specific_index = 1
	self._generic_index = 1
	self._difficulty_tweak_index = 1
	self._difficulty_index = 1
	self._generic_terror_events = {}

	for k, v in pairs(GenericTerrorEvents) do
		self._generic_terror_events[#self._generic_terror_events + 1] = k
	end

	table.sort(self._generic_terror_events)
end

ImguiTerrorEventDebug.update = function (arg_3_0)
	-- function 3
	return
end

ImguiTerrorEventDebug.is_persistent = function (arg_4_0)
	-- function 4
	return true
end

ImguiTerrorEventDebug.draw = function (self, arg_5_1)
	-- function 5
	local begin_window = Imgui.begin_window("TerrorEventDebug", "always_auto_resize")
	local var_5_1 = fn()

	if var_5_1 ~= self._current_level then
		self._level_specific_terror_events = {}

		local var_5_2 = TerrorEventBlueprints[var_5_1]

		if not var_5_2 then
			for k, v in pairs(var_5_2) do
				self._level_specific_terror_events[#self._level_specific_terror_events + 1] = k
			end
		end

		table.sort(self._level_specific_terror_events)

		self._level_specific_index = 1
		self._current_level = var_5_1

		local get_level_seed = Managers.mechanism:get_level_seed()

		get_level_seed = get_level_seed or 0
		self._seed = get_level_seed
	end

	self._seed = Imgui.input_int("seed", self._seed)

	Imgui.spacing()
	Imgui.spacing()
	Imgui.spacing()
	Imgui.spacing()

	self._difficulty_index = Imgui.combo("Difficulty", self._difficulty_index, tbl)
	self._difficulty_tweak_index = Imgui.combo("Difficulty Tweak", self._difficulty_tweak_index, tbl_2)

	Imgui.spacing()
	Imgui.spacing()
	Imgui.spacing()
	Imgui.spacing()

	self._level_specific_index = Imgui.combo("Level Specific Terror Event", self._level_specific_index, self._level_specific_terror_events)

	if not Imgui.button("Start Level Specific Terror Event") and not Managers.state.conflict then
		script_data.terror_event_difficulty = tbl[self._difficulty_index]
		script_data.terror_event_difficulty_tweak = tbl_2[self._difficulty_tweak_index]

		Managers.state.conflict:start_terror_event(self._level_specific_terror_events[self._level_specific_index], self._seed)
	end

	Imgui.spacing()
	Imgui.spacing()
	Imgui.spacing()
	Imgui.spacing()

	self._generic_index = Imgui.combo("Generic Terror Event", self._generic_index, self._generic_terror_events)

	if not Imgui.button("Start Generic Terror Event") and not Managers.state.conflict then
		script_data.terror_event_difficulty = tbl[self._difficulty_index]
		script_data.terror_event_difficulty_tweak = tbl_2[self._difficulty_tweak_index]

		Managers.state.conflict:start_terror_event(self._generic_terror_events[self._generic_index], self._seed)
	end

	Imgui.spacing()
	Imgui.spacing()
	Imgui.spacing()
	Imgui.spacing()

	local script_data = script_data
	local checkbox = Imgui.checkbox
	local str = "Terror Event Debugging On"
	local debug_terror = script_data.debug_terror

	debug_terror = debug_terror or false
	script_data.debug_terror = checkbox(str, debug_terror)

	local conflict = Managers.state.conflict

	if not conflict then
		if conflict.pacing:get_state() ~= "pacing_frozen" then
			if not Imgui.button("Disable Normal Spawning") then
				conflict.pacing:disable()
			end
		elseif not Imgui.button("Enable Normal Spawning") then
			conflict.pacing:enable()
		end

		if not Imgui.button("Kill All Enemies") then
			conflict:destroy_all_units(true)
		end
	end

	if not Imgui.button("Stop active terror events") and Managers.player.is_server and not LEVEL_EDITOR_TEST then
		local active_events = TerrorEventMixer.active_events

		for i, v_2 in ipairs(active_events) do
			TerrorEventMixer.stop_event(v_2.name)
		end
	end

	Imgui.end_window()

	return begin_window
end
