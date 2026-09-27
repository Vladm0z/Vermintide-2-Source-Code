-- chunkname: @scripts/imgui/imgui_sound_debug.lua

ImguiSoundDebug = class(ImguiSoundDebug)

local flag = false
local num = 820
local num_2 = 500

local function fn(arg_1_0)
	-- function 1
	local num = arg_1_0 % 60
	local floor = math.floor(arg_1_0)

	return os.date("%H:%M", floor) .. string.format(":%06.3f", num)
end

ImguiSoundDebug.init = function (self)
	-- function 2
	self._event_name = "pwe_activate_ability_handmaiden_03"
	self._music_players = {}
	self._music_flags = {}
	self._is_persistent = false
	self._indent_counter = 0
	self._history = {}
	self._history_running = false
	self._sort_history_by = "timestamp"
	self._sort_direction = "asc"
	self._first_run = true

	self:register_events()

	flag = false
end

ImguiSoundDebug.destroy = function (self)
	-- function 3
	self:unregister_events()
end

ImguiSoundDebug.register_events = function (arg_4_0)
	-- function 4
	local event = Managers.state.event

	if not event then
		event:register(arg_4_0, "music_flag_change", "on_music_flag_change")
		event:register(arg_4_0, "music_player_state_change", "on_music_player_state_change")
	end
end

ImguiSoundDebug.unregister_events = function (arg_5_0)
	-- function 5
	local event = Managers.state.event

	if not event then
		event:unregister("music_flag_change", arg_5_0)
		event:unregister("music_player_state_change", arg_5_0)
	end
end

ImguiSoundDebug.is_persistent = function (self)
	-- function 6
	return self._is_persistent
end

ImguiSoundDebug.update = function (self)
	-- function 7
	if not flag then
		self:unregister_events()
		self:init()
	end

	self:_update_music_flags()
	self:_update_music_players()
end

ImguiSoundDebug._update_music_flags = function (self)
	-- function 8
	local music = Managers.music
	local _flags = music._flags
	local flags_update_disabled = music.flags_update_disabled

	for k, v in pairs(_flags) do
		local _music_flags = self._music_flags
		local tbl = {
			value = v
		}
		local var_8_5 = flags_update_disabled[k]

		var_8_5 = var_8_5 or false
		tbl.update_disabled = var_8_5
		_music_flags[k] = tbl
	end
end

ImguiSoundDebug._update_music_players = function (arg_9_0)
	-- function 9
	local _music_players = Managers.music._music_players

	for k, v in pairs(_music_players) do
		local _playing = v._playing
		local _group_states

		if not _playing then
			_group_states = _playing._group_states

			if not _group_states then
				-- Nothing
			end
		end

		_group_states = {}

		::label_9_0::

		local tbl = {}

		for k_2, v_2 in pairs(_group_states) do
			tbl[k_2] = {
				value = v_2,
				update_disabled = not _playing and _playing.states_update_disabled[k_2]
			}
		end

		arg_9_0._music_players[k] = {
			is_playing = v:is_playing(),
			states = tbl
		}
	end
end

ImguiSoundDebug.draw = function (self)
	-- function 10
	if not self._first_run then
		Imgui.set_next_window_size(num, num_2)

		self._first_run = false
	end

	local begin_window = Imgui.begin_window("Sound Debug")

	self._is_persistent = Imgui.checkbox("Keep Window Open", self._is_persistent)

	Imgui.separator()
	self:_draw_music_player()
	Imgui.separator()
	self:_draw_music_flags()
	Imgui.separator()
	self:_draw_music_players()
	Imgui.separator()
	self:_draw_history()
	Imgui.separator()
	self:_verify_indent()
	Imgui.end_window()

	return begin_window
end

ImguiSoundDebug._draw_music_player = function (self)
	-- function 11
	self._event_name = Imgui.input_text("Event", self._event_name)

	Imgui.same_line()

	if not Imgui.small_button("Play") then
		local world = Managers.world:world("level_world")
		local wwise_world = Managers.world:wwise_world(world)

		WwiseWorld.trigger_event(wwise_world, self._event_name)
	end
end

ImguiSoundDebug._draw_music_flags = function (self)
	-- function 12
	Imgui.text("Music Flags")
	Imgui.dummy(0, 2)
	self:_set_columns(3, true, 300)

	local _music_flags = self._music_flags

	for k, v in pairs(_music_flags) do
		Imgui.tree_push(k)
		Imgui.text(k)
		Imgui.next_column()

		local input_text, var_12_2 = Imgui.input_text("", tostring(v.value))

		if not (not var_12_2 and input_text == tostring(v.value)) then
			local lower = string.lower(input_text)

			if lower == "true" then
				input_text = true
			elseif lower == "false" then
				input_text = false
			end

			local flags_update_disabled = Managers.music.flags_update_disabled

			flags_update_disabled[k] = nil

			Managers.music:set_flag(k, input_text)

			flags_update_disabled[k] = true
		end

		if type(v.value) == "boolean" then
			Imgui.same_line()
			Imgui.text("(Boolean)")
		end

		Imgui.next_column()

		local checkbox = Imgui.checkbox("Update Disabled", v.update_disabled)

		if checkbox ~= v.update_disabled then
			Managers.music.flags_update_disabled[k] = checkbox
		end

		Imgui.next_column()
		Imgui.tree_pop()
	end

	self:_reset_columns()
end

ImguiSoundDebug._draw_music_players = function (self)
	-- function 13
	Imgui.text("Music Players")
	Imgui.dummy(0, 2)

	if not self._music_players then
		return
	end

	self:_indent()

	for k, v in pairs(self._music_players) do
		Imgui.text(string.format("Player: %s", k))
		self:_indent()
		Imgui.text(string.format("Is Playing: %s", v.is_playing))
		Imgui.text("States: ")
		self:_set_columns(3, true, 300)

		for k_2, v_2 in pairs(v.states) do
			Imgui.tree_push(k_2)
			Imgui.text(k_2)
			Imgui.next_column()

			local input_text, var_13_1 = Imgui.input_text("", tostring(v_2.value))

			if not (not var_13_1 and input_text == tostring(v_2.value)) then
				local states_update_disabled = Managers.music._music_players[k]._playing.states_update_disabled

				states_update_disabled[k_2] = nil

				Managers.music._music_players[k]:set_group_state(k_2, input_text)

				states_update_disabled[k_2] = true
			end

			Imgui.next_column()

			local checkbox = Imgui.checkbox
			local str = "Update Disabled"
			local update_disabled = v_2.update_disabled

			update_disabled = update_disabled or false

			local var_13_6 = checkbox(str, update_disabled)

			if var_13_6 ~= v_2.update_disabled then
				Managers.music._music_players[k]._playing.states_update_disabled[k_2] = var_13_6
			end

			Imgui.next_column()
			Imgui.tree_pop()
		end

		self:_unindent()
	end

	self:_unindent()
	self:_reset_columns()
end

local tbl = {
	"timestamp",
	"name",
	"key",
	"old_value",
	"new_value"
}

ImguiSoundDebug._draw_history = function (self)
	-- function 14
	local flag

	flag = not self._history_running and "Stop" and "Start"

	if not Imgui.button(flag) then
		if not self._history_running then
			self:unregister_events()
		else
			self:register_events()
		end

		self._history_running = not self._history_running
	end

	Imgui.same_line()

	if not Imgui.button("Clear History") then
		self._history = {}
	end

	self:_set_columns(5)

	for k, v in pairs(tbl) do
		if not self:_draw_sort_button(v) then
			self._history_sorted = false

			break
		end

		Imgui.next_column()
	end

	self:_reset_columns()

	if not self._history_sorted then
		for k_2, v_2 in pairs(self._history) do
			table.sort(self._history, function (self, arg_15_1)
				-- function 15
				if self._sort_direction == "asc" then
					return self[self._sort_history_by]:lower() < arg_15_1[self._sort_history_by]:lower()
				else
					return self[self._sort_history_by]:lower() > arg_15_1[self._sort_history_by]:lower()
				end
			end)
		end

		self._history_sorted = true
	end

	local get_window_size, var_14_2 = Imgui.get_window_size()

	Imgui.begin_child_window("Log:", get_window_size, var_14_2 * 0.4, false)
	self:_set_columns(5)

	for k_3, v_3 in pairs(self._history) do
		for k_4, v_4 in pairs(tbl) do
			Imgui.text(tostring(v_3[v_4]))
			Imgui.next_column()
		end
	end

	self:_reset_columns()
	Imgui.end_child_window()
end

ImguiSoundDebug._draw_sort_button = function (self, arg_16_1)
	-- function 16
	local var_16_0

	if self._sort_history_by == arg_16_1 then
		local format = string.format
		local str = "%s %s"
		local var_16_3 = arg_16_1
		local flag

		flag = self._sort_direction ~= "asc" or not "/\\" or "\\/"
		var_16_0 = format(str, var_16_3, flag)
	else
		var_16_0 = arg_16_1
	end

	if not Imgui.button(var_16_0) then
		self._sort_history_by = arg_16_1

		local flag_2

		flag_2 = self._sort_direction ~= "asc" or not "desc" or "asc"
		self._sort_direction = flag_2

		return true
	end
end

ImguiSoundDebug.on_music_flag_change = function (self, arg_17_1, arg_17_2, arg_17_3)
	-- function 17
	local tbl = {
		name = "flag",
		timestamp = fn(os.time()),
		key = arg_17_1,
		old_value = arg_17_2 or "",
		new_value = arg_17_3 or ""
	}

	self._history[#self._history + 1] = tbl
	self._history_sorted = false
end

ImguiSoundDebug.on_music_player_state_change = function (self, arg_18_1, arg_18_2, arg_18_3, arg_18_4)
	-- function 18
	local tbl = {
		timestamp = fn(os.time()),
		name = arg_18_1,
		key = arg_18_2,
		old_value = arg_18_3 or "",
		new_value = arg_18_4 or ""
	}

	self._history[#self._history + 1] = tbl
	self._history_sorted = false
end

ImguiSoundDebug._set_columns = function (arg_19_0, arg_19_1, arg_19_2, arg_19_3)
	-- function 19
	arg_19_2 = arg_19_2 or false

	Imgui.columns(arg_19_1, arg_19_2)

	if not arg_19_3 then
		return
	end

	if type(arg_19_3) == "table" then
		for i, v in ipairs(arg_19_3) do
			Imgui.set_column_width(v, i - 1)
		end
	else
		for k = 0, arg_19_1 - 1 do
			Imgui.set_column_width(arg_19_3, k)
		end
	end
end

ImguiSoundDebug._reset_columns = function (self)
	-- function 20
	self:_set_columns(1)
end

local num_3 = 8

ImguiSoundDebug._indent = function (self)
	-- function 21
	self._indent_counter = self._indent_counter + 1

	Imgui.indent(num_3)
end

ImguiSoundDebug._unindent = function (self)
	-- function 22
	self._indent_counter = self._indent_counter - 1

	Imgui.unindent(num_3)
end

ImguiSoundDebug._verify_indent = function (self)
	-- function 23
	fassert(self._indent_counter == 0, tostring(self._indent_counter))
end
