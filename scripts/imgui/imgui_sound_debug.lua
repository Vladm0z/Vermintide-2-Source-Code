-- chunkname: @scripts/imgui/imgui_sound_debug.lua

ImguiSoundDebug = class(ImguiSoundDebug)

local var_0_0 = false
local var_0_1 = 820
local var_0_2 = 500

local function var_0_3(arg_1_0)
	local var_1_0 = arg_1_0 % 60
	local var_1_1 = math.floor(arg_1_0)

	return os.date("%H:%M", var_1_1) .. string.format(":%06.3f", var_1_0)
end

function ImguiSoundDebug.init(arg_2_0)
	arg_2_0._event_name = "pwe_activate_ability_handmaiden_03"
	arg_2_0._music_players = {}
	arg_2_0._music_flags = {}
	arg_2_0._is_persistent = false
	arg_2_0._indent_counter = 0
	arg_2_0._history = {}
	arg_2_0._history_running = false
	arg_2_0._sort_history_by = "timestamp"
	arg_2_0._sort_direction = "asc"
	arg_2_0._first_run = true

	arg_2_0:register_events()

	var_0_0 = false
end

function ImguiSoundDebug.destroy(arg_3_0)
	arg_3_0:unregister_events()
end

function ImguiSoundDebug.register_events(arg_4_0)
	local var_4_0 = Managers.state.event

	if var_4_0 then
		var_4_0:register(arg_4_0, "music_flag_change", "on_music_flag_change")
		var_4_0:register(arg_4_0, "music_player_state_change", "on_music_player_state_change")
	end
end

function ImguiSoundDebug.unregister_events(arg_5_0)
	local var_5_0 = Managers.state.event

	if var_5_0 then
		var_5_0:unregister("music_flag_change", arg_5_0)
		var_5_0:unregister("music_player_state_change", arg_5_0)
	end
end

function ImguiSoundDebug.is_persistent(arg_6_0)
	return arg_6_0._is_persistent
end

function ImguiSoundDebug.update(arg_7_0)
	if var_0_0 then
		arg_7_0:unregister_events()
		arg_7_0:init()
	end

	arg_7_0:_update_music_flags()
	arg_7_0:_update_music_players()
end

function ImguiSoundDebug._update_music_flags(arg_8_0)
	local var_8_0 = Managers.music
	local var_8_1 = var_8_0._flags
	local var_8_2 = var_8_0.flags_update_disabled

	for iter_8_0, iter_8_1 in pairs(var_8_1) do
		arg_8_0._music_flags[iter_8_0] = {
			value = iter_8_1,
			update_disabled = var_8_2[iter_8_0] or false
		}
	end
end

function ImguiSoundDebug._update_music_players(arg_9_0)
	local var_9_0 = Managers.music._music_players

	for iter_9_0, iter_9_1 in pairs(var_9_0) do
		local var_9_1 = iter_9_1._playing
		local var_9_2 = var_9_1 and var_9_1._group_states or {}
		local var_9_3 = {}

		for iter_9_2, iter_9_3 in pairs(var_9_2) do
			var_9_3[iter_9_2] = {
				value = iter_9_3,
				update_disabled = var_9_1 and var_9_1.states_update_disabled[iter_9_2]
			}
		end

		arg_9_0._music_players[iter_9_0] = {
			is_playing = iter_9_1:is_playing(),
			states = var_9_3
		}
	end
end

function ImguiSoundDebug.draw(arg_10_0)
	if arg_10_0._first_run then
		Imgui.set_next_window_size(var_0_1, var_0_2)

		arg_10_0._first_run = false
	end

	local var_10_0 = Imgui.begin_window("Sound Debug")

	arg_10_0._is_persistent = Imgui.checkbox("Keep Window Open", arg_10_0._is_persistent)

	Imgui.separator()
	arg_10_0:_draw_music_player()
	Imgui.separator()
	arg_10_0:_draw_music_flags()
	Imgui.separator()
	arg_10_0:_draw_music_players()
	Imgui.separator()
	arg_10_0:_draw_history()
	Imgui.separator()
	arg_10_0:_verify_indent()
	Imgui.end_window()

	return var_10_0
end

function ImguiSoundDebug._draw_music_player(arg_11_0)
	arg_11_0._event_name = Imgui.input_text("Event", arg_11_0._event_name)

	Imgui.same_line()

	if Imgui.small_button("Play") then
		local var_11_0 = Managers.world:world("level_world")
		local var_11_1 = Managers.world:wwise_world(var_11_0)

		WwiseWorld.trigger_event(var_11_1, arg_11_0._event_name)
	end
end

function ImguiSoundDebug._draw_music_flags(arg_12_0)
	Imgui.text("Music Flags")
	Imgui.dummy(0, 2)
	arg_12_0:_set_columns(3, true, 300)

	local var_12_0 = arg_12_0._music_flags

	for iter_12_0, iter_12_1 in pairs(var_12_0) do
		Imgui.tree_push(iter_12_0)
		Imgui.text(iter_12_0)
		Imgui.next_column()

		local var_12_1, var_12_2 = Imgui.input_text("", tostring(iter_12_1.value))

		if var_12_2 and var_12_1 ~= tostring(iter_12_1.value) then
			local var_12_3 = string.lower(var_12_1)

			if var_12_3 == "true" then
				var_12_1 = true
			elseif var_12_3 == "false" then
				var_12_1 = false
			end

			local var_12_4 = Managers.music.flags_update_disabled

			var_12_4[iter_12_0] = nil

			Managers.music:set_flag(iter_12_0, var_12_1)

			var_12_4[iter_12_0] = true
		end

		if type(iter_12_1.value) == "boolean" then
			Imgui.same_line()
			Imgui.text("(Boolean)")
		end

		Imgui.next_column()

		local var_12_5 = Imgui.checkbox("Update Disabled", iter_12_1.update_disabled)

		if var_12_5 ~= iter_12_1.update_disabled then
			Managers.music.flags_update_disabled[iter_12_0] = var_12_5
		end

		Imgui.next_column()
		Imgui.tree_pop()
	end

	arg_12_0:_reset_columns()
end

function ImguiSoundDebug._draw_music_players(arg_13_0)
	Imgui.text("Music Players")
	Imgui.dummy(0, 2)

	if not arg_13_0._music_players then
		return
	end

	arg_13_0:_indent()

	for iter_13_0, iter_13_1 in pairs(arg_13_0._music_players) do
		Imgui.text(string.format("Player: %s", iter_13_0))
		arg_13_0:_indent()
		Imgui.text(string.format("Is Playing: %s", iter_13_1.is_playing))
		Imgui.text("States: ")
		arg_13_0:_set_columns(3, true, 300)

		for iter_13_2, iter_13_3 in pairs(iter_13_1.states) do
			Imgui.tree_push(iter_13_2)
			Imgui.text(iter_13_2)
			Imgui.next_column()

			local var_13_0, var_13_1 = Imgui.input_text("", tostring(iter_13_3.value))

			if var_13_1 and var_13_0 ~= tostring(iter_13_3.value) then
				local var_13_2 = Managers.music._music_players[iter_13_0]._playing.states_update_disabled

				var_13_2[iter_13_2] = nil

				Managers.music._music_players[iter_13_0]:set_group_state(iter_13_2, var_13_0)

				var_13_2[iter_13_2] = true
			end

			Imgui.next_column()

			local var_13_3 = Imgui.checkbox("Update Disabled", iter_13_3.update_disabled or false)

			if var_13_3 ~= iter_13_3.update_disabled then
				Managers.music._music_players[iter_13_0]._playing.states_update_disabled[iter_13_2] = var_13_3
			end

			Imgui.next_column()
			Imgui.tree_pop()
		end

		arg_13_0:_unindent()
	end

	arg_13_0:_unindent()
	arg_13_0:_reset_columns()
end

local var_0_4 = {
	"timestamp",
	"name",
	"key",
	"old_value",
	"new_value"
}

function ImguiSoundDebug._draw_history(arg_14_0)
	local var_14_0 = arg_14_0._history_running and "Stop" or "Start"

	if Imgui.button(var_14_0) then
		if arg_14_0._history_running then
			arg_14_0:unregister_events()
		else
			arg_14_0:register_events()
		end

		arg_14_0._history_running = not arg_14_0._history_running
	end

	Imgui.same_line()

	if Imgui.button("Clear History") then
		arg_14_0._history = {}
	end

	arg_14_0:_set_columns(5)

	for iter_14_0, iter_14_1 in pairs(var_0_4) do
		if arg_14_0:_draw_sort_button(iter_14_1) then
			arg_14_0._history_sorted = false

			break
		end

		Imgui.next_column()
	end

	arg_14_0:_reset_columns()

	if not arg_14_0._history_sorted then
		for iter_14_2, iter_14_3 in pairs(arg_14_0._history) do
			table.sort(arg_14_0._history, function(arg_15_0, arg_15_1)
				if arg_14_0._sort_direction == "asc" then
					return arg_15_0[arg_14_0._sort_history_by]:lower() < arg_15_1[arg_14_0._sort_history_by]:lower()
				else
					return arg_15_0[arg_14_0._sort_history_by]:lower() > arg_15_1[arg_14_0._sort_history_by]:lower()
				end
			end)
		end

		arg_14_0._history_sorted = true
	end

	local var_14_1, var_14_2 = Imgui.get_window_size()

	Imgui.begin_child_window("Log:", var_14_1, var_14_2 * 0.4, false)
	arg_14_0:_set_columns(5)

	for iter_14_4, iter_14_5 in pairs(arg_14_0._history) do
		for iter_14_6, iter_14_7 in pairs(var_0_4) do
			Imgui.text(tostring(iter_14_5[iter_14_7]))
			Imgui.next_column()
		end
	end

	arg_14_0:_reset_columns()
	Imgui.end_child_window()
end

function ImguiSoundDebug._draw_sort_button(arg_16_0, arg_16_1)
	local var_16_0

	if arg_16_0._sort_history_by == arg_16_1 then
		var_16_0 = string.format("%s %s", arg_16_1, arg_16_0._sort_direction == "asc" and "/\\" or "\\/")
	else
		var_16_0 = arg_16_1
	end

	if Imgui.button(var_16_0) then
		arg_16_0._sort_history_by = arg_16_1
		arg_16_0._sort_direction = arg_16_0._sort_direction == "asc" and "desc" or "asc"

		return true
	end
end

function ImguiSoundDebug.on_music_flag_change(arg_17_0, arg_17_1, arg_17_2, arg_17_3)
	local var_17_0 = {
		name = "flag",
		timestamp = var_0_3(os.time()),
		key = arg_17_1,
		old_value = arg_17_2 or "",
		new_value = arg_17_3 or ""
	}

	arg_17_0._history[#arg_17_0._history + 1] = var_17_0
	arg_17_0._history_sorted = false
end

function ImguiSoundDebug.on_music_player_state_change(arg_18_0, arg_18_1, arg_18_2, arg_18_3, arg_18_4)
	local var_18_0 = {
		timestamp = var_0_3(os.time()),
		name = arg_18_1,
		key = arg_18_2,
		old_value = arg_18_3 or "",
		new_value = arg_18_4 or ""
	}

	arg_18_0._history[#arg_18_0._history + 1] = var_18_0
	arg_18_0._history_sorted = false
end

function ImguiSoundDebug._set_columns(arg_19_0, arg_19_1, arg_19_2, arg_19_3)
	arg_19_2 = arg_19_2 or false

	Imgui.columns(arg_19_1, arg_19_2)

	if not arg_19_3 then
		return
	end

	if type(arg_19_3) == "table" then
		for iter_19_0, iter_19_1 in ipairs(arg_19_3) do
			Imgui.set_column_width(iter_19_1, iter_19_0 - 1)
		end
	else
		for iter_19_2 = 0, arg_19_1 - 1 do
			Imgui.set_column_width(arg_19_3, iter_19_2)
		end
	end
end

function ImguiSoundDebug._reset_columns(arg_20_0)
	arg_20_0:_set_columns(1)
end

local var_0_5 = 8

function ImguiSoundDebug._indent(arg_21_0)
	arg_21_0._indent_counter = arg_21_0._indent_counter + 1

	Imgui.indent(var_0_5)
end

function ImguiSoundDebug._unindent(arg_22_0)
	arg_22_0._indent_counter = arg_22_0._indent_counter - 1

	Imgui.unindent(var_0_5)
end

function ImguiSoundDebug._verify_indent(arg_23_0)
	fassert(arg_23_0._indent_counter == 0, tostring(arg_23_0._indent_counter))
end
