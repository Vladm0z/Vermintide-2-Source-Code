-- chunkname: @scripts/imgui/imgui_terror_event_debug.lua

ImguiTerrorEventDebug = class(ImguiTerrorEventDebug)

local var_0_0 = {
	"normal",
	"hard",
	"harder",
	"hardest",
	"cataclysm"
}
local var_0_1 = {}

for iter_0_0 = -DifficultyTweak.range, DifficultyTweak.range do
	var_0_1[#var_0_1 + 1] = iter_0_0
end

local function var_0_2()
	if not Managers.state.game_mode then
		return
	end

	return (Managers.level_transition_handler:get_current_level_keys())
end

function ImguiTerrorEventDebug.init(arg_2_0)
	arg_2_0._level_specific_index = 1
	arg_2_0._generic_index = 1
	arg_2_0._difficulty_tweak_index = 1
	arg_2_0._difficulty_index = 1
	arg_2_0._generic_terror_events = {}

	for iter_2_0, iter_2_1 in pairs(GenericTerrorEvents) do
		arg_2_0._generic_terror_events[#arg_2_0._generic_terror_events + 1] = iter_2_0
	end

	table.sort(arg_2_0._generic_terror_events)
end

function ImguiTerrorEventDebug.update(arg_3_0)
	return
end

function ImguiTerrorEventDebug.is_persistent(arg_4_0)
	return true
end

function ImguiTerrorEventDebug.draw(arg_5_0, arg_5_1)
	local var_5_0 = Imgui.begin_window("TerrorEventDebug", "always_auto_resize")
	local var_5_1 = var_0_2()

	if var_5_1 ~= arg_5_0._current_level then
		arg_5_0._level_specific_terror_events = {}

		local var_5_2 = TerrorEventBlueprints[var_5_1]

		if var_5_2 then
			for iter_5_0, iter_5_1 in pairs(var_5_2) do
				arg_5_0._level_specific_terror_events[#arg_5_0._level_specific_terror_events + 1] = iter_5_0
			end
		end

		table.sort(arg_5_0._level_specific_terror_events)

		arg_5_0._level_specific_index = 1
		arg_5_0._current_level = var_5_1
		arg_5_0._seed = Managers.mechanism:get_level_seed() or 0
	end

	arg_5_0._seed = Imgui.input_int("seed", arg_5_0._seed)

	Imgui.spacing()
	Imgui.spacing()
	Imgui.spacing()
	Imgui.spacing()

	arg_5_0._difficulty_index = Imgui.combo("Difficulty", arg_5_0._difficulty_index, var_0_0)
	arg_5_0._difficulty_tweak_index = Imgui.combo("Difficulty Tweak", arg_5_0._difficulty_tweak_index, var_0_1)

	Imgui.spacing()
	Imgui.spacing()
	Imgui.spacing()
	Imgui.spacing()

	arg_5_0._level_specific_index = Imgui.combo("Level Specific Terror Event", arg_5_0._level_specific_index, arg_5_0._level_specific_terror_events)

	if Imgui.button("Start Level Specific Terror Event") and Managers.state.conflict then
		script_data.terror_event_difficulty = var_0_0[arg_5_0._difficulty_index]
		script_data.terror_event_difficulty_tweak = var_0_1[arg_5_0._difficulty_tweak_index]

		Managers.state.conflict:start_terror_event(arg_5_0._level_specific_terror_events[arg_5_0._level_specific_index], arg_5_0._seed)
	end

	Imgui.spacing()
	Imgui.spacing()
	Imgui.spacing()
	Imgui.spacing()

	arg_5_0._generic_index = Imgui.combo("Generic Terror Event", arg_5_0._generic_index, arg_5_0._generic_terror_events)

	if Imgui.button("Start Generic Terror Event") and Managers.state.conflict then
		script_data.terror_event_difficulty = var_0_0[arg_5_0._difficulty_index]
		script_data.terror_event_difficulty_tweak = var_0_1[arg_5_0._difficulty_tweak_index]

		Managers.state.conflict:start_terror_event(arg_5_0._generic_terror_events[arg_5_0._generic_index], arg_5_0._seed)
	end

	Imgui.spacing()
	Imgui.spacing()
	Imgui.spacing()
	Imgui.spacing()

	script_data.debug_terror = Imgui.checkbox("Terror Event Debugging On", script_data.debug_terror or false)

	local var_5_3 = Managers.state.conflict

	if var_5_3 then
		if var_5_3.pacing:get_state() ~= "pacing_frozen" then
			if Imgui.button("Disable Normal Spawning") then
				var_5_3.pacing:disable()
			end
		elseif Imgui.button("Enable Normal Spawning") then
			var_5_3.pacing:enable()
		end

		if Imgui.button("Kill All Enemies") then
			var_5_3:destroy_all_units(true)
		end
	end

	if Imgui.button("Stop active terror events") and (Managers.player.is_server or LEVEL_EDITOR_TEST) then
		local var_5_4 = TerrorEventMixer.active_events

		for iter_5_2, iter_5_3 in ipairs(var_5_4) do
			TerrorEventMixer.stop_event(iter_5_3.name)
		end
	end

	Imgui.end_window()

	return var_5_0
end
