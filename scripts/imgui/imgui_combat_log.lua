-- chunkname: @scripts/imgui/imgui_combat_log.lua

ImguiCombatLog = class(ImguiCombatLog)

local flag = false
local num = 800
local num_2 = 500

local function fn(arg_1_0)
	-- function 1
	local num = arg_1_0 % 60
	local floor = math.floor(arg_1_0)

	return os.date("%H:%M", floor) .. string.format(":%06.3f", num)
end

ImguiCombatLog.init = function (self)
	-- function 2
	self._log = {}
	self._max_lines = 1000
	self._start_time = os.time() - os.clock()
	self.categories = {
		{
			name = "Damage",
			enabled = true,
			type = "damage"
		},
		{
			name = "Heal",
			enabled = true,
			type = "heal"
		},
		{
			name = "Buff",
			enabled = true,
			type = "buff"
		},
		{
			name = "Buff Proc",
			enabled = true,
			type = "buff_proc"
		},
		{
			name = "Action",
			enabled = true,
			type = "action"
		}
	}
	self._type_ids = {}
	self._settings = {
		auto_start_recording = true,
		show_timestamp = true,
		show_type = true
	}
	self._first_run = true

	self:_make_log_type_lookup()
	self:register_events()
	self:_load_settings()
end

ImguiCombatLog.register_events = function (arg_3_0)
	-- function 3
	local event = Managers.state.event

	if not event then
		event:register(arg_3_0, "combat_log_damage", "log_damage")
		event:register(arg_3_0, "combat_log_heal", "log_heal")
		event:register(arg_3_0, "combat_log_action", "log_action")
		event:register(arg_3_0, "combat_log_proc", "log_proc")
		event:register(arg_3_0, "combat_log_buff", "log_buff")
	end
end

ImguiCombatLog.unregister_events = function (arg_4_0)
	-- function 4
	local event = Managers.state.event

	if not event then
		event:unregister("combat_log_damage", arg_4_0)
		event:unregister("combat_log_heal", arg_4_0)
		event:unregister("combat_log_action", arg_4_0)
		event:unregister("combat_log_proc", arg_4_0)
		event:unregister("combat_log_buff", arg_4_0)
	end
end

ImguiCombatLog.on_round_start = function (self)
	-- function 5
	if not self._settings.auto_start_recording then
		self:register_events()
	end

	self:_save_settings()
end

ImguiCombatLog.on_round_end = function (self)
	-- function 6
	self:unregister_events()
	self:_save_settings()
end

ImguiCombatLog.destroy = function (self)
	-- function 7
	self:unregister_events()
	self:_save_settings()
end

ImguiCombatLog.update = function (self)
	-- function 8
	if not flag then
		self:unregister_events()
		self:init()

		flag = false
	end
end

ImguiCombatLog.is_persistent = function (arg_9_0)
	-- function 9
	return true
end

ImguiCombatLog.draw = function (self, arg_10_1)
	-- function 10
	if not self._first_run then
		Imgui.set_next_window_size(num, num_2)

		self._first_run = false
	end

	local begin_window = Imgui.begin_window("Combat Log")

	self._settings.show_timestamp = Imgui.checkbox("Timestamp", self._settings.show_timestamp)

	Imgui.same_line()

	self._settings.show_type = Imgui.checkbox("Type", self._settings.show_type)

	Imgui.same_line()

	self._settings.auto_start_recording = Imgui.checkbox("Auto Start Recording", self._settings.auto_start_recording)

	local categories = self.categories

	for i = 1, #categories do
		if i > 1 then
			Imgui.same_line()
		end

		local var_10_2 = categories[i]

		var_10_2.enabled = Imgui.checkbox(var_10_2.name, var_10_2.enabled)
	end

	if not Imgui.button("Start", 100, 20) then
		self:register_events()
	end

	Imgui.same_line()

	if not Imgui.button("Stop", 100, 20) then
		self:unregister_events()
	end

	Imgui.same_line()

	if not Imgui.button("Copy Visible", 100, 20) then
		self:copy_to_clipboard(false)
	end

	Imgui.same_line()

	if not Imgui.button("Copy All", 100, 20) then
		self:copy_to_clipboard(true)
	end

	Imgui.same_line()

	if not Imgui.button("Clear", 40, 20) then
		self:clear()
	end

	local show_timestamp = self._settings.show_timestamp
	local show_type = self._settings.show_type
	local get_window_size, var_10_6 = Imgui.get_window_size()

	Imgui.begin_child_window("Log:", get_window_size - 15, var_10_6 - 105, false, "no_title_bar", "always_auto_resize", "horizontal_scrollbar")

	for j = 1, #self._log do
		local var_10_7 = self._log[j]

		if not categories[var_10_7.type_id].enabled then
			local content = var_10_7.content

			if not show_timestamp then
				Imgui.text(var_10_7.timestamp)
				Imgui.same_line()
			end

			if not show_type then
				Imgui.text(var_10_7.type_name)
				Imgui.same_line()
			end

			local count = #content

			for k = 1, count do
				local var_10_10 = content[k]
				local var_10_11 = var_10_10[1]
				local var_10_12 = var_10_10[2]

				Imgui.text_colored(var_10_11, var_10_12[2], var_10_12[3], var_10_12[4], var_10_12[1])

				if k ~= count then
					Imgui.same_line()
				end
			end
		end
	end

	Imgui.end_child_window()
	Imgui.end_window("Combat Log")

	return begin_window
end

ImguiCombatLog.log_damage = function (self, arg_11_1, arg_11_2, arg_11_3, arg_11_4, arg_11_5, arg_11_6, arg_11_7, arg_11_8, arg_11_9, arg_11_10, arg_11_11, arg_11_12, arg_11_13)
	-- function 11
	local alive = Unit.alive(arg_11_1)

	alive = not alive and Unit.get_data(arg_11_1, "breed")

	local alive_2 = Unit.alive(arg_11_2)

	alive_2 = not alive_2 and Unit.get_data(arg_11_2, "breed")

	local network = Managers.state.network
	local flag = not network and network:unit_game_object_id(arg_11_2)
	local _add_line = self:_add_line("damage")
	local var_11_5 = self
	local _add_colored_segment = self._add_colored_segment
	local var_11_7 = _add_line
	local format = string.format
	local str = "%s -> %s (%d) (%.2f %s), Power(%.2f), hit (%s) using (%s) Crit: %s, Backstab Mult: %.2f, Target Index: %d"
	local tostring = tostring
	local name

	if not alive then
		name = alive.name

		if not name then
			-- Nothing
		end
	end

	name = arg_11_1

	::label_11_0::

	local var_11_12 = tostring(name)
	local tostring_2 = tostring
	local name_2

	if not alive_2 then
		name_2 = alive_2.name

		if not name_2 then
			-- Nothing
		end
	end

	name_2 = arg_11_2

	::label_11_1::

	_add_colored_segment(var_11_5, var_11_7, format(str, var_11_12, tostring_2(name_2), flag or 0, arg_11_3 or 0, tostring(arg_11_5), arg_11_13 or 0, tostring(arg_11_4), tostring(arg_11_6), tostring(arg_11_7), arg_11_8 or 1, arg_11_10 or 0), Colors.get_table("orange"))
end

ImguiCombatLog.log_heal = function (self, arg_12_1, arg_12_2, arg_12_3, arg_12_4)
	-- function 12
	local alive = Unit.alive(arg_12_1)

	alive = not alive and Unit.get_data(arg_12_1, "breed")

	local alive_2 = Unit.alive(arg_12_2)

	alive_2 = not alive_2 and Unit.get_data(arg_12_2, "breed")

	local _add_line = self:_add_line("heal")
	local var_12_3 = self
	local _add_colored_segment = self._add_colored_segment
	local var_12_5 = _add_line
	local format = string.format
	local str = "%s -> %s (%.2f %s)"
	local tostring = tostring
	local name

	if not alive then
		name = alive.name

		if not name then
			-- Nothing
		end
	end

	name = arg_12_1

	::label_12_0::

	local var_12_10 = tostring(name)
	local tostring_2 = tostring
	local name_2

	if not alive_2 then
		name_2 = alive_2.name

		if not name_2 then
			-- Nothing
		end
	end

	name_2 = arg_12_2

	::label_12_1::

	_add_colored_segment(var_12_3, var_12_5, format(str, var_12_10, tostring_2(name_2), arg_12_3 or 0, tostring(arg_12_4)), Colors.get_table("lime"))
end

ImguiCombatLog.log_action = function (self, arg_13_1, arg_13_2, arg_13_3, arg_13_4, arg_13_5, arg_13_6, arg_13_7, arg_13_8)
	-- function 13
	local alive = Unit.alive(arg_13_1)

	alive = not alive and Unit.get_data(arg_13_1, "breed")

	local _add_line = self:_add_line("action")

	if not arg_13_7 then
		local var_13_2 = self
		local _add_colored_segment = self._add_colored_segment
		local var_13_4 = _add_line
		local format = string.format
		local str = "[Start] %s (%s - power %.2f) - %s/%s/%s"
		local tostring = tostring
		local name

		if not alive then
			name = alive.name

			if not name then
				-- Nothing
			end
		end

		name = arg_13_1

		::label_13_0::

		_add_colored_segment(var_13_2, var_13_4, format(str, tostring(name), tostring(arg_13_3), arg_13_6 or 0, tostring(arg_13_2), tostring(arg_13_4), tostring(arg_13_5)), Colors.get_table("white"))
	else
		local var_13_9 = self
		local _add_colored_segment_2 = self._add_colored_segment
		local var_13_11 = _add_line
		local format_2 = string.format
		local str_2 = "[End] %s (%s - power %.2f), Reason: %s - %s/%s/%s "
		local tostring_2 = tostring
		local name_2

		if not alive then
			name_2 = alive.name

			if not name_2 then
				-- Nothing
			end
		end

		name_2 = arg_13_1

		::label_13_1::

		_add_colored_segment_2(var_13_9, var_13_11, format_2(str_2, tostring_2(name_2), tostring(arg_13_3), arg_13_6 or 0, tostring(arg_13_8), tostring(arg_13_2), tostring(arg_13_4), tostring(arg_13_5)), Colors.get_table("white"))
	end
end

ImguiCombatLog.log_proc = function (self, arg_14_1, arg_14_2, arg_14_3, arg_14_4, arg_14_5)
	-- function 14
	local flag = not arg_14_1 and arg_14_1.player_unit
	local alive = Unit.alive(flag)

	alive = not alive and Unit.get_data(flag, "breed")

	local _add_line = self:_add_line("buff_proc")
	local var_14_3 = self
	local _add_colored_segment = self._add_colored_segment
	local var_14_5 = _add_line
	local format = string.format
	local str = "%s (%s) -> %s"
	local tostring = tostring
	local name

	if not alive then
		name = alive.name

		if not name then
			-- Nothing
		end
	end

	name = flag

	::label_14_0::

	_add_colored_segment(var_14_3, var_14_5, format(str, tostring(name), arg_14_2 or "-", tostring(arg_14_3.buff_type)), Colors.get_table("silver"))
end

ImguiCombatLog.log_buff = function (self, arg_15_1, arg_15_2, arg_15_3, arg_15_4, arg_15_5)
	-- function 15
	local alive = Unit.alive(arg_15_1)

	alive = not alive and Unit.get_data(arg_15_1, "breed")

	local flag = not arg_15_2 and arg_15_2.attacker_unit
	local alive_2 = Unit.alive(flag)

	alive_2 = not alive_2 and Unit.get_data(flag, "breed")

	local _add_line = self:_add_line("buff")

	if not arg_15_3 then
		local var_15_4 = self
		local _add_colored_segment = self._add_colored_segment
		local var_15_6 = _add_line
		local format = string.format
		local str = "[Added] %s -> %s (mult: %.2f)"
		local tostring = tostring
		local name

		if not alive then
			name = alive.name

			if not name then
				-- Nothing
			end
		end

		name = arg_15_1

		::label_15_0::

		local var_15_11 = tostring(name)
		local var_15_12 = tostring(arg_15_2.buff_type)
		local multiplier

		if type(arg_15_2.multiplier) == "function" then
			multiplier = arg_15_2.multiplier(arg_15_1, ScriptUnit.extension(arg_15_1, "buff_system"))

			if not multiplier then
				-- Nothing
			end
		end

		multiplier = arg_15_2.multiplier
		multiplier = multiplier or 1

		::label_15_1::

		_add_colored_segment(var_15_4, var_15_6, format(str, var_15_11, var_15_12, multiplier), Colors.get_table("lime"))

		if not arg_15_4 and not arg_15_5 then
			self:_add_colored_segment(_add_line, string.format("(stacks: %d/%d)", arg_15_4, arg_15_5), Colors.get_table("lime"))
		end

		if not flag then
			local var_15_14 = self
			local _add_colored_segment_2 = self._add_colored_segment
			local var_15_16 = _add_line
			local format_2 = string.format
			local str_2 = "(%s)"
			local tostring_2 = tostring
			local name_2

			if not alive_2 then
				name_2 = alive_2.name

				if not name_2 then
					-- Nothing
				end
			end

			name_2 = flag

			::label_15_2::

			_add_colored_segment_2(var_15_14, var_15_16, format_2(str_2, tostring_2(name_2)), Colors.get_table("lime"))
		end
	else
		local var_15_21 = self
		local _add_colored_segment_3 = self._add_colored_segment
		local var_15_23 = _add_line
		local format_3 = string.format
		local str_3 = "[Removed] %s -> %s"
		local tostring_3 = tostring
		local name_3

		if not alive then
			name_3 = alive.name

			if not name_3 then
				-- Nothing
			end
		end

		name_3 = arg_15_1

		::label_15_3::

		_add_colored_segment_3(var_15_21, var_15_23, format_3(str_3, tostring_3(name_3), tostring(arg_15_2.buff_type)), Colors.get_table("yellow"))

		if not flag then
			local var_15_28 = self
			local _add_colored_segment_4 = self._add_colored_segment
			local var_15_30 = _add_line
			local format_4 = string.format
			local str_4 = "(%s)"
			local tostring_4 = tostring
			local name_4

			if not alive_2 then
				name_4 = alive_2.name

				if not name_4 then
					-- Nothing
				end
			end

			name_4 = flag

			::label_15_4::

			_add_colored_segment_4(var_15_28, var_15_30, format_4(str_4, tostring_4(name_4)), Colors.get_table("yellow"))
		end
	end
end

ImguiCombatLog._make_log_type_lookup = function (self)
	-- function 16
	local categories = self.categories

	for i = 1, #categories do
		self._type_ids[categories[i].type] = i
	end
end

ImguiCombatLog._get_type_name = function (self, arg_17_1)
	-- function 17
	if not arg_17_1 then
		local var_17_0 = self._type_ids[arg_17_1]
		local var_17_1 = self.categories[var_17_0]
		local name

		if not var_17_1 then
			name = var_17_1.name

			if not name then
				-- Nothing
			end
		end

		name = tostring(arg_17_1)

		::label_17_0::

		return name
	end

	return tostring("Unknown")
end

ImguiCombatLog._add_line = function (self, arg_18_1)
	-- function 18
	local tbl = {
		timestamp = "[" .. fn(self._start_time + os.clock()) .. "]",
		content = {}
	}
	local var_18_1 = self._type_ids[arg_18_1]

	var_18_1 = var_18_1 or 0
	tbl.type_id = var_18_1
	tbl.type_name = "[" .. self:_get_type_name(arg_18_1) .. "]"

	table.insert(self._log, 1, tbl)

	local count = #self._log

	if count > self._max_lines then
		table.remove(self._log, count)
	end

	return tbl
end

ImguiCombatLog._add_colored_segment = function (arg_19_0, arg_19_1, arg_19_2, arg_19_3)
	-- function 19
	local flag = arg_19_2 or ""
	local flag_2 = arg_19_3 or Colors.get_table("white")

	table.insert(arg_19_1.content, {
		flag,
		flag_2
	})
end

ImguiCombatLog.clear = function (self)
	-- function 20
	self._log = {}
end

ImguiCombatLog.copy_to_clipboard = function (self, arg_21_1)
	-- function 21
	local str = ""
	local categories = self.categories
	local show_type = self._settings.show_type

	for i = 1, #self._log do
		local var_21_3 = self._log[i]

		if arg_21_1 or not categories[var_21_3.type_id].enabled then
			local content = var_21_3.content

			if arg_21_1 or not self._show_timestamp then
				str = str .. var_21_3.timestamp
			end

			if arg_21_1 or not show_type then
				str = str .. " " .. var_21_3.type_name
			end

			for j = 1, #content do
				local var_21_5 = content[j][1]

				str = str .. " " .. var_21_5
			end

			str = str .. "\n"
		end
	end

	Clipboard.put(str)
end

ImguiCombatLog._save_settings = function (self)
	-- function 22
	local categories = self.categories
	local tbl = {
		categories = {},
		settings = self._settings
	}

	for i = 1, #categories do
		local type = categories[i].type

		tbl.categories[type] = categories[i].enabled
	end

	Development.set_setting("ImguiCombatLog_settings", tbl)
	Application.save_user_settings()
end

ImguiCombatLog._load_settings = function (self)
	-- function 23
	local setting = Development.setting("ImguiCombatLog_settings")

	if not setting then
		local categories = setting.categories

		if not categories then
			local categories_2 = self.categories

			for i = 1, #categories_2 do
				local var_23_3 = categories[categories_2[i].type]

				if var_23_3 ~= nil then
					categories_2[i].enabled = var_23_3
				end
			end
		end

		local settings = setting.settings

		if not settings then
			table.merge(self._settings, settings)
		end
	end
end
