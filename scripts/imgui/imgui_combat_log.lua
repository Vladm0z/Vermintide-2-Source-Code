-- chunkname: @scripts/imgui/imgui_combat_log.lua

ImguiCombatLog = class(ImguiCombatLog)

local SHOULD_RELOAD = false
local DEFAULT_WINDOW_X = 800
local DEFAULT_WINDOW_Y = 500

local function format_timestamp(time)
	-- function 1
	local miliseconds = time % 60
	local seconds = math.floor(time)

	return os.date("%H:%M", seconds) .. string.format(":%06.3f", miliseconds)
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

ImguiCombatLog.register_events = function (self)
	-- function 3
	local event_manager = Managers.state.event

	if event_manager then
		event_manager:register(self, "combat_log_damage", "log_damage")
		event_manager:register(self, "combat_log_heal", "log_heal")
		event_manager:register(self, "combat_log_action", "log_action")
		event_manager:register(self, "combat_log_proc", "log_proc")
		event_manager:register(self, "combat_log_buff", "log_buff")
	end
end

ImguiCombatLog.unregister_events = function (self)
	-- function 4
	local event_manager = Managers.state.event

	if event_manager then
		event_manager:unregister("combat_log_damage", self)
		event_manager:unregister("combat_log_heal", self)
		event_manager:unregister("combat_log_action", self)
		event_manager:unregister("combat_log_proc", self)
		event_manager:unregister("combat_log_buff", self)
	end
end

ImguiCombatLog.on_round_start = function (self)
	-- function 5
	if self._settings.auto_start_recording then
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
	if SHOULD_RELOAD then
		self:unregister_events()
		self:init()

		SHOULD_RELOAD = false
	end
end

ImguiCombatLog.is_persistent = function (self)
	-- function 9
	return true
end

ImguiCombatLog.draw = function (self, is_open)
	-- function 10
	if self._first_run then
		Imgui.set_next_window_size(DEFAULT_WINDOW_X, DEFAULT_WINDOW_Y)

		self._first_run = false
	end

	local do_close = Imgui.begin_window("Combat Log")

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

		local category = categories[i]

		category.enabled = Imgui.checkbox(category.name, category.enabled)
	end

	if Imgui.button("Start", 100, 20) then
		self:register_events()
	end

	Imgui.same_line()

	if Imgui.button("Stop", 100, 20) then
		self:unregister_events()
	end

	Imgui.same_line()

	if Imgui.button("Copy Visible", 100, 20) then
		self:copy_to_clipboard(false)
	end

	Imgui.same_line()

	if Imgui.button("Copy All", 100, 20) then
		self:copy_to_clipboard(true)
	end

	Imgui.same_line()

	if Imgui.button("Clear", 40, 20) then
		self:clear()
	end

	local show_timestamp = self._settings.show_timestamp
	local show_type = self._settings.show_type
	local window_size_x, window_size_y = Imgui.get_window_size()

	Imgui.begin_child_window("Log:", window_size_x - 15, window_size_y - 105, false, "no_title_bar", "always_auto_resize", "horizontal_scrollbar")

	for line_id = 1, #self._log do
		local line = self._log[line_id]

		if categories[line.type_id].enabled then
			local line_contents = line.content

			if show_timestamp then
				Imgui.text(line.timestamp)
				Imgui.same_line()
			end

			if show_type then
				Imgui.text(line.type_name)
				Imgui.same_line()
			end

			local line_content_num = #line_contents

			for i = 1, line_content_num do
				local data = line_contents[i]
				local text = data[1]
				local color = data[2]

				Imgui.text_colored(text, color[2], color[3], color[4], color[1])

				if i ~= line_content_num then
					Imgui.same_line()
				end
			end
		end
	end

	Imgui.end_child_window()
	Imgui.end_window("Combat Log")

	return do_close
end

ImguiCombatLog.log_damage = function (self, attacker_unit, victim_unit, networkified_damage_amount, hit_zone_name, damage_type, damage_source, is_critical_strike, backstab_multiplier, added_dot, target_index, first_hit, total_hits, power_level)
	-- function 11
	local alive = Unit.alive(attacker_unit)

	if alive then
		-- Nothing
	end

	alive = Unit.get_data(attacker_unit, "breed")

	local attacker_unit_breed = alive

	::label_11_0::

	local alive_2 = Unit.alive(victim_unit)

	if alive_2 then
		-- Nothing
	end

	alive_2 = Unit.get_data(victim_unit, "breed")

	local victim_unit_breed = alive_2

	::label_11_1::

	local network_manager = Managers.state.network
	local unit_id = not not network_manager and not not network_manager:unit_game_object_id(victim_unit)
	local line = self:_add_line("damage")
	local var_11_2 = self
	local _add_colored_segment = self._add_colored_segment
	local var_11_4 = line
	local format = string.format
	local str = "%s -> %s (%d) (%.2f %s), Power(%.2f), hit (%s) using (%s) Crit: %s, Backstab Mult: %.2f, Target Index: %d"
	local tostring = tostring
	local name

	if attacker_unit_breed then
		name = attacker_unit_breed.name

		if not name then
			-- Nothing
		end
	end

	name = attacker_unit

	::label_11_2::

	local var_11_9 = tostring(name)
	local tostring_2 = tostring
	local name_2

	if victim_unit_breed then
		name_2 = victim_unit_breed.name

		if not name_2 then
			-- Nothing
		end
	end

	name_2 = victim_unit

	::label_11_3::

	_add_colored_segment(var_11_2, var_11_4, format(str, var_11_9, tostring_2(name_2), not not unit_id or not not 0, not not networkified_damage_amount or not not 0, tostring(damage_type), not not power_level or not not 0, tostring(hit_zone_name), tostring(damage_source), tostring(is_critical_strike), not not backstab_multiplier or not not 1, not not target_index or not not 0), Colors.get_table("orange"))
end

ImguiCombatLog.log_heal = function (self, healer_unit, unit, buffed_heal_amount, heal_type)
	-- function 12
	local alive = Unit.alive(healer_unit)

	if alive then
		-- Nothing
	end

	alive = Unit.get_data(healer_unit, "breed")

	local healer_unit_breed = alive

	::label_12_0::

	local alive_2 = Unit.alive(unit)

	if alive_2 then
		-- Nothing
	end

	alive_2 = Unit.get_data(unit, "breed")

	local unit_breed = alive_2

	::label_12_1::

	local line = self:_add_line("heal")
	local var_12_2 = self
	local _add_colored_segment = self._add_colored_segment
	local var_12_4 = line
	local format = string.format
	local str = "%s -> %s (%.2f %s)"
	local tostring = tostring
	local name

	if healer_unit_breed then
		name = healer_unit_breed.name

		if not name then
			-- Nothing
		end
	end

	name = healer_unit

	::label_12_2::

	local var_12_9 = tostring(name)
	local tostring_2 = tostring
	local name_2

	if unit_breed then
		name_2 = unit_breed.name

		if not name_2 then
			-- Nothing
		end
	end

	name_2 = unit

	::label_12_3::

	_add_colored_segment(var_12_2, var_12_4, format(str, var_12_9, tostring_2(name_2), not not buffed_heal_amount or not not 0, tostring(heal_type)), Colors.get_table("lime"))
end

ImguiCombatLog.log_action = function (self, unit, item_name, kind, action_name, sub_action_name, power_level, started, reason)
	-- function 13
	local alive = Unit.alive(unit)

	if alive then
		-- Nothing
	end

	alive = Unit.get_data(unit, "breed")

	local unit_breed = alive

	::label_13_0::

	local line = self:_add_line("action")

	if started then
		local var_13_1 = self
		local _add_colored_segment = self._add_colored_segment
		local var_13_3 = line
		local format = string.format
		local str = "[Start] %s (%s - power %.2f) - %s/%s/%s"
		local tostring = tostring
		local name

		if unit_breed then
			name = unit_breed.name

			if not name then
				-- Nothing
			end
		end

		name = unit

		::label_13_1::

		_add_colored_segment(var_13_1, var_13_3, format(str, tostring(name), tostring(kind), not not power_level or not not 0, tostring(item_name), tostring(action_name), tostring(sub_action_name)), Colors.get_table("white"))
	else
		local var_13_8 = self
		local _add_colored_segment_2 = self._add_colored_segment
		local var_13_10 = line
		local format_2 = string.format
		local str_2 = "[End] %s (%s - power %.2f), Reason: %s - %s/%s/%s "
		local tostring_2 = tostring
		local name_2

		if unit_breed then
			name_2 = unit_breed.name

			if not name_2 then
				-- Nothing
			end
		end

		name_2 = unit

		::label_13_2::

		_add_colored_segment_2(var_13_8, var_13_10, format_2(str_2, tostring_2(name_2), tostring(kind), not not power_level or not not 0, tostring(reason), tostring(item_name), tostring(action_name), tostring(sub_action_name)), Colors.get_table("white"))
	end
end

ImguiCombatLog.log_proc = function (self, player, event, buff, params, success)
	-- function 14
	local unit = not not player and not not player.player_unit
	local alive = Unit.alive(unit)

	if alive then
		-- Nothing
	end

	alive = Unit.get_data(unit, "breed")

	local unit_breed = alive

	::label_14_0::

	local line = self:_add_line("buff_proc")
	local var_14_1 = self
	local _add_colored_segment = self._add_colored_segment
	local var_14_3 = line
	local format = string.format
	local str = "%s (%s) -> %s"
	local tostring = tostring
	local name

	if unit_breed then
		name = unit_breed.name

		if not name then
			-- Nothing
		end
	end

	name = unit

	::label_14_1::

	_add_colored_segment(var_14_1, var_14_3, format(str, tostring(name), not not event or not not "-", tostring(buff.buff_type)), Colors.get_table("silver"))
end

ImguiCombatLog.log_buff = function (self, unit, buff, added, stack_count, max_stacks)
	-- function 15
	local alive = Unit.alive(unit)

	if alive then
		-- Nothing
	end

	alive = Unit.get_data(unit, "breed")

	local owner_breed = alive

	::label_15_0::

	local attacker_unit = not not buff and not not buff.attacker_unit
	local alive_2 = Unit.alive(attacker_unit)

	if alive_2 then
		-- Nothing
	end

	alive_2 = Unit.get_data(attacker_unit, "breed")

	local attacker_breed = alive_2

	::label_15_1::

	local line = self:_add_line("buff")

	if added then
		local var_15_2 = self
		local _add_colored_segment = self._add_colored_segment
		local var_15_4 = line
		local format = string.format
		local str = "[Added] %s -> %s (mult: %.2f)"
		local tostring = tostring
		local name

		if owner_breed then
			name = owner_breed.name

			if not name then
				-- Nothing
			end
		end

		name = unit

		::label_15_2::

		local var_15_9 = tostring(name)
		local var_15_10 = tostring(buff.buff_type)
		local multiplier

		if type(buff.multiplier) == "function" then
			multiplier = buff.multiplier(unit, ScriptUnit.extension(unit, "buff_system"))

			if not multiplier then
				-- Nothing
			end
		end

		multiplier = buff.multiplier
		multiplier = not not multiplier or not not 1

		::label_15_3::

		_add_colored_segment(var_15_2, var_15_4, format(str, var_15_9, var_15_10, multiplier), Colors.get_table("lime"))

		if stack_count and max_stacks then
			self:_add_colored_segment(line, string.format("(stacks: %d/%d)", stack_count, max_stacks), Colors.get_table("lime"))
		end

		if attacker_unit then
			local var_15_12 = self
			local _add_colored_segment_2 = self._add_colored_segment
			local var_15_14 = line
			local format_2 = string.format
			local str_2 = "(%s)"
			local tostring_2 = tostring
			local name_2

			if attacker_breed then
				name_2 = attacker_breed.name

				if not name_2 then
					-- Nothing
				end
			end

			name_2 = attacker_unit

			::label_15_4::

			_add_colored_segment_2(var_15_12, var_15_14, format_2(str_2, tostring_2(name_2)), Colors.get_table("lime"))
		end
	else
		local var_15_19 = self
		local _add_colored_segment_3 = self._add_colored_segment
		local var_15_21 = line
		local format_3 = string.format
		local str_3 = "[Removed] %s -> %s"
		local tostring_3 = tostring
		local name_3

		if owner_breed then
			name_3 = owner_breed.name

			if not name_3 then
				-- Nothing
			end
		end

		name_3 = unit

		::label_15_5::

		_add_colored_segment_3(var_15_19, var_15_21, format_3(str_3, tostring_3(name_3), tostring(buff.buff_type)), Colors.get_table("yellow"))

		if attacker_unit then
			local var_15_26 = self
			local _add_colored_segment_4 = self._add_colored_segment
			local var_15_28 = line
			local format_4 = string.format
			local str_4 = "(%s)"
			local tostring_4 = tostring
			local name_4

			if attacker_breed then
				name_4 = attacker_breed.name

				if not name_4 then
					-- Nothing
				end
			end

			name_4 = attacker_unit

			::label_15_6::

			_add_colored_segment_4(var_15_26, var_15_28, format_4(str_4, tostring_4(name_4)), Colors.get_table("yellow"))
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

ImguiCombatLog._get_type_name = function (self, type)
	-- function 17
	if type then
		local id = self._type_ids[type]
		local category = self.categories[id]
		local name

		if category then
			name = category.name

			if not name then
				-- Nothing
			end
		end

		name = tostring(type)

		local type_name = name

		::label_17_0::

		return type_name
	end

	return tostring("Unknown")
end

ImguiCombatLog._add_line = function (self, type)
	-- function 18
	local new_line = {}

	new_line.timestamp = "[" .. format_timestamp(self._start_time + os.clock()) .. "]"
	new_line.content = {}

	local var_18_0 = self._type_ids[type]

	var_18_0 = not not var_18_0 or not not 0
	new_line.type_id = var_18_0
	new_line.type_name = "[" .. self:_get_type_name(type) .. "]"

	table.insert(self._log, 1, new_line)

	local num_lines = #self._log

	if num_lines > self._max_lines then
		table.remove(self._log, num_lines)
	end

	return new_line
end

ImguiCombatLog._add_colored_segment = function (self, line, text, color)
	-- function 19
	local text_to_add = not not text or not not ""
	local color_to_add = not not color or not not Colors.get_table("white")

	table.insert(line.content, {
		text_to_add,
		color_to_add
	})
end

ImguiCombatLog.clear = function (self)
	-- function 20
	self._log = {}
end

ImguiCombatLog.copy_to_clipboard = function (self, copy_all)
	-- function 21
	local output = ""
	local categories = self.categories
	local show_type = self._settings.show_type

	for line_id = 1, #self._log do
		local line = self._log[line_id]

		if copy_all or categories[line.type_id].enabled then
			local line_contents = line.content

			if copy_all or self._show_timestamp then
				output = output .. line.timestamp
			end

			if copy_all or show_type then
				output = output .. " " .. line.type_name
			end

			for i = 1, #line_contents do
				local data = line_contents[i]
				local text = data[1]

				output = output .. " " .. text
			end

			output = output .. "\n"
		end
	end

	Clipboard.put(output)
end

ImguiCombatLog._save_settings = function (self)
	-- function 22
	local categories = self.categories
	local saved_settings = {
		categories = {},
		settings = self._settings
	}

	for i = 1, #categories do
		local type = categories[i].type

		saved_settings.categories[type] = categories[i].enabled
	end

	Development.set_setting("ImguiCombatLog_settings", saved_settings)
	Application.save_user_settings()
end

ImguiCombatLog._load_settings = function (self)
	-- function 23
	local saved_settings = Development.setting("ImguiCombatLog_settings")

	if saved_settings then
		local category_settings = saved_settings.categories

		if category_settings then
			local categories = self.categories

			for i = 1, #categories do
				local type = categories[i].type
				local new_val = category_settings[type]

				if new_val ~= nil then
					categories[i].enabled = new_val
				end
			end
		end

		local general_settings = saved_settings.settings

		if general_settings then
			table.merge(self._settings, general_settings)
		end
	end
end
