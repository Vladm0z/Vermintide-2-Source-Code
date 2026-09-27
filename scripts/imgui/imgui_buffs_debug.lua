-- chunkname: @scripts/imgui/imgui_buffs_debug.lua

ImguiBuffsDebug = class(ImguiBuffsDebug)

local flag = true

ImguiBuffsDebug.init = function (self)
	-- function 1
	self._buff_system = nil
	self._unit_names = {}
	self._units = {}

	local _selected_unit_idx = self._selected_unit_idx

	_selected_unit_idx = _selected_unit_idx or -1
	self._selected_unit_idx = _selected_unit_idx
	self._selected_unit = nil
	self._selected_debug_unit = nil
	self._debug_unit_alive = false
	self._stat_base_value = 1

	local _filter_text = self._filter_text

	_filter_text = _filter_text or ""
	self._filter_text = _filter_text
	self._buff_list = {}
	self._filtered_buff_list = {}
	self._selected_buff_id = 0
	self._selected_buff_sync_type_id = 1
	self._buff_advanced_params_enabled = false
	self._buff_bonus_enabled = false
	self._buff_multiplier_enabled = false
	self._buff_value_enabled = false
	self._buff_proc_chance_enabled = false
	self._buff_duration_enabled = false
	self._buff_range_enabled = false
	self._buff_bonus = 0
	self._buff_multiplier = 0
	self._buff_value = 0
	self._buff_proc_chance = 0
	self._buff_duration = 0
	self._buff_range = 0
	self._buff_power_level = 0
	self._current_unit = nil
	self._buff_extension = nil

	self:_get_buff_templates()

	self._filtered_buff_list = self:_apply_buff_filter(self._filter_text, self._buff_list)
	self._target_peer_id = ""
end

ImguiBuffsDebug._get_buff_templates = function (self)
	-- function 2
	table.clear(self._buff_list)

	for k, v in pairs(BuffTemplates) do
		v = BuffUtils.get_buff_template(k)

		table.insert(self._buff_list, k)
	end

	table.sort(self._buff_list)

	self._selected_buff_id = 0
end

ImguiBuffsDebug._apply_buff_filter = function (arg_3_0, arg_3_1, arg_3_2)
	-- function 3
	if arg_3_1 == "" then
		return arg_3_2
	end

	local tbl = {}
	local gsub = string.gsub(arg_3_1, "[_ ]", "")

	for i = 1, #arg_3_2 do
		local var_3_2 = arg_3_2[i]

		if not string.gsub(var_3_2, "[_ ]", ""):find(gsub, 1, true) then
			table.insert(tbl, var_3_2)
		end
	end

	return tbl
end

ImguiBuffsDebug.update = function (self)
	-- function 4
	if not flag then
		self:init()

		flag = false
	end

	if not (not self._current_unit and not ALIVE[self._current_unit] and not self._selected_unit and ALIVE[self._selected_unit] and self._selected_debug_unit ~= script_data.debug_unit or self._debug_unit_alive == ALIVE[self._selected_debug_unit]) then
		self:_refresh_unit_list()
	end
end

ImguiBuffsDebug.on_round_start = function (self)
	-- function 5
	self._current_unit = nil

	self:_refresh_unit_list()
end

ImguiBuffsDebug.is_persistent = function (arg_6_0)
	-- function 6
	return true
end

ImguiBuffsDebug.draw = function (self, arg_7_1)
	-- function 7
	local begin_window = Imgui.begin_window("Buff Debug")

	self:_update_controls()

	local _buff_extension = self._buff_extension

	_buff_extension = not _buff_extension and self._buff_extension._buffs

	local _buff_extension_2 = self._buff_extension

	_buff_extension_2 = not _buff_extension_2 and self._buff_extension._stat_buffs

	local _buff_extension_3 = self._buff_extension

	_buff_extension_3 = not _buff_extension_3 and self._buff_extension._event_buffs

	local _buff_extension_4 = self._buff_extension

	_buff_extension_4 = not _buff_extension_4 and self._buff_extension._perks

	self:_display_buffs(_buff_extension)
	self:_display_perks(_buff_extension_4)
	self:_display_stat_buffs(_buff_extension_2)
	self:_display_event_buffs(_buff_extension_3)
	self:_display_movement_settings(self._current_unit)
	Imgui.end_window()

	return begin_window
end

ImguiBuffsDebug._update_controls = function (self)
	-- function 8
	local combo = Imgui.combo("Unit", self._selected_unit_idx, self._unit_names)

	if combo ~= self._selected_unit_idx then
		self._selected_unit_idx = combo
		self._selected_unit = self._units[combo]

		if not self._selected_unit then
			self._fallback_to_ai = self._selected_unit == script_data.debug_unit
		end

		self:_initialize_unit(self._selected_unit)
	end

	Imgui.same_line()

	if not Imgui.button("Refresh") then
		self:_refresh_unit_list()

		self._fallback_to_ai = self._selected_unit == script_data.debug_unit
	end

	self._selected_buff_id, self._filtered_buff_list, self._filter_text = ImguiX.combo_search(self._selected_buff_id, self._filtered_buff_list, self._filter_text, self._buff_list)
	self._buff_advanced_params_enabled = Imgui.checkbox("Advanced Params", self._buff_advanced_params_enabled)

	if not self._buff_advanced_params_enabled then
		Imgui.tree_push("bonus_input")

		self._buff_bonus_enabled = Imgui.checkbox("Bonus", self._buff_bonus_enabled)

		if not self._buff_bonus_enabled then
			Imgui.same_line()

			self._buff_bonus = Imgui.input_float("", self._buff_bonus)
		end

		Imgui.tree_pop()
		Imgui.tree_push("mult_input")

		self._buff_multiplier_enabled = Imgui.checkbox("Multiplier", self._buff_multiplier_enabled)

		if not self._buff_multiplier_enabled then
			Imgui.same_line()

			self._buff_multiplier = Imgui.input_float("", self._buff_multiplier)
		end

		Imgui.tree_pop()
		Imgui.tree_push("val_input")

		self._buff_value_enabled = Imgui.checkbox("Value", self._buff_value_enabled)

		if not self._buff_value_enabled then
			Imgui.same_line()

			self._buff_value = Imgui.input_float("", self._buff_value)
		end

		Imgui.tree_pop()
		Imgui.tree_push("proc_input")

		self._buff_proc_chance_enabled = Imgui.checkbox("Proc Chance", self._buff_proc_chance_enabled)

		if not self._buff_proc_chance_enabled then
			Imgui.same_line()

			self._buff_proc_chance = Imgui.input_float("", self._buff_proc_chance)
		end

		Imgui.tree_pop()
		Imgui.tree_push("duration_input")

		self._buff_duration_enabled = Imgui.checkbox("Duration", self._buff_duration_enabled)

		if not self._buff_duration_enabled then
			Imgui.same_line()

			self._buff_duration = Imgui.input_float("", self._buff_duration)
		end

		Imgui.tree_pop()
		Imgui.tree_push("range_input")

		self._buff_range_enabled = Imgui.checkbox("Range", self._buff_range_enabled)

		if not self._buff_range_enabled then
			Imgui.same_line()

			self._buff_range = Imgui.input_float("", self._buff_range)
		end

		Imgui.tree_pop()
		Imgui.tree_push("power_input")
		Imgui.dummy(15, 15)
		Imgui.same_line()
		Imgui.text("Power Level")
		Imgui.same_line()

		self._buff_power_level = Imgui.input_float("", self._buff_power_level)

		Imgui.tree_pop()
	end

	if not Imgui.button("Add", 100, 20) then
		local var_8_1 = self._filtered_buff_list[self._selected_buff_id]
		local _buff_advanced_params_enabled = self._buff_advanced_params_enabled

		if not _buff_advanced_params_enabled then
			_buff_advanced_params_enabled = {}

			local _buff_bonus_enabled = self._buff_bonus_enabled

			_buff_bonus_enabled = not _buff_bonus_enabled and self._buff_bonus
			_buff_advanced_params_enabled.external_optional_bonus = _buff_bonus_enabled

			local _buff_multiplier_enabled = self._buff_multiplier_enabled

			_buff_multiplier_enabled = not _buff_multiplier_enabled and self._buff_multiplier
			_buff_advanced_params_enabled.external_optional_multiplier = _buff_multiplier_enabled

			local _buff_value_enabled = self._buff_value_enabled

			_buff_value_enabled = not _buff_value_enabled and self._buff_value
			_buff_advanced_params_enabled.external_optional_value = _buff_value_enabled

			local _buff_proc_chance_enabled = self._buff_proc_chance_enabled

			_buff_proc_chance_enabled = not _buff_proc_chance_enabled and self._buff_proc_chance
			_buff_advanced_params_enabled.external_optional_proc_chance = _buff_proc_chance_enabled

			local _buff_duration_enabled = self._buff_duration_enabled

			_buff_duration_enabled = not _buff_duration_enabled and self._buff_duration
			_buff_advanced_params_enabled.external_optional_duration = _buff_duration_enabled

			local _buff_range_enabled = self._buff_range_enabled

			_buff_range_enabled = not _buff_range_enabled and self._buff_range
			_buff_advanced_params_enabled.external_optional_range = _buff_range_enabled
			_buff_advanced_params_enabled.power_level = self._buff_power_level
		end

		self:_add_buff(self._buff_extension, var_8_1, _buff_advanced_params_enabled)
	end

	if not Imgui.button("Add with buff system", 200, 20) then
		local var_8_9 = self._filtered_buff_list[self._selected_buff_id]

		if not var_8_9 then
			self:_add_buff_with_buff_system(var_8_9)
		end
	end

	Imgui.separator()
	Imgui.push_item_width(200)

	self._selected_buff_sync_type_id = Imgui.combo("Sync Type", self._selected_buff_sync_type_id, BuffSyncType)

	Imgui.pop_item_width()

	local var_8_10 = BuffSyncType[self._selected_buff_sync_type_id]

	if not (var_8_10 == BuffSyncType.Client or var_8_10 ~= BuffSyncType.ClientAndServer) then
		local alloc_table = FrameTable.alloc_table()
		local alloc_table_2 = FrameTable.alloc_table()
		local select_array = table.select_array(table.keys(Managers.player:human_players()), function (arg_9_0, arg_9_1)
			-- function 9
			local sub = string.sub(arg_9_1, 1, string.find(arg_9_1, ":") - 1)

			if not alloc_table[sub] then
				alloc_table[sub] = true

				local name = Managers.player:player_from_unique_id(arg_9_1):name()
				local format = string.format("%s (%s)", name, sub)

				alloc_table_2[#alloc_table_2 + 1] = sub

				return format
			end

			return nil
		end)
		local combo_2 = Imgui.combo
		local str = "Peer ID"
		local min = math.min
		local _target_peer_id_idx = self._target_peer_id_idx

		_target_peer_id_idx = _target_peer_id_idx or 1
		self._target_peer_id_idx = combo_2(str, min(_target_peer_id_idx, #select_array), select_array)
		self._target_peer_id = alloc_table_2[self._target_peer_id_idx]
	end

	if not Imgui.button("Add Buff Sync", 200, 20) then
		local var_8_18 = self._filtered_buff_list[self._selected_buff_id]
		local var_8_19 = BuffSyncType[self._selected_buff_sync_type_id]

		if not var_8_18 and not var_8_19 then
			self:_add_buff_with_buff_synced(var_8_18, var_8_19)
		end
	end

	Imgui.separator()
	Imgui.dummy(10, 10)
end

ImguiBuffsDebug._display_buffs = function (self, arg_10_1)
	-- function 10
	if not Imgui.tree_node("Buffs") then
		if not arg_10_1 then
			local var_10_0

			for i = 1, #arg_10_1 do
				local var_10_1 = arg_10_1[i]

				if var_10_1.removed or not Imgui.tree_node(var_10_1.buff_type .. "(" .. var_10_1.id .. ")") then
					for k, v in pairs(var_10_1) do
						if k ~= "template" or not Imgui.tree_node(k) then
							for k_2, v_2 in pairs(v) do
								Imgui.text(k_2)
								Imgui.same_line()
								Imgui.text(tostring(v_2))
							end

							Imgui.tree_pop()
						end

						if not (type(v) == "function" or type(v) == "table" or k == "buff_type" or k == "id") then
							Imgui.text(k)
							Imgui.same_line()
							Imgui.text(tostring(v))
						end
					end

					if not Imgui.button("Remove") then
						var_10_0 = var_10_0 or {}

						table.insert(var_10_0, var_10_1.id)
					end

					Imgui.tree_pop()
				end

				Imgui.separator()
			end

			if not var_10_0 then
				for i5 = 1, #var_10_0 do
					self:_remove_buff(self._buff_extension, var_10_0[i5])
				end
			end
		end

		Imgui.dummy(10, 10)
		Imgui.tree_pop()
	end
end

ImguiBuffsDebug._display_perks = function (arg_11_0, arg_11_1)
	-- function 11
	if not Imgui.tree_node("Perks") then
		if not arg_11_1 then
			for k, v in pairs(arg_11_1) do
				if v > 0 then
					Imgui.text(string.format("%s %d", k .. " ", v))
				end
			end
		end

		Imgui.dummy(10, 10)
		Imgui.tree_pop()
	end
end

ImguiBuffsDebug._display_stat_buffs = function (self, arg_12_1)
	-- function 12
	if not Imgui.tree_node("Stat Buffs") then
		self._stat_base_value = Imgui.input_float("Base Stat Value", self._stat_base_value)

		if not arg_12_1 then
			Imgui.separator()
			Imgui.text(string.format("%-36s%8s%12s%13s%14s%15s", "Name", "Bonus", "Multiplier", "Value", "Proc Chance", "Final Value"))
			Imgui.separator()

			for k, v in pairs(arg_12_1) do
				if not table.is_empty(v) then
					local _stat_base_value = self._stat_base_value

					for k_2, v_2 in pairs(v) do
						local bonus = v_2.bonus

						bonus = bonus or 0

						local multiplier

						if type(v_2.multiplier) == "function" then
							multiplier = v_2.multiplier(self._current_unit, self._buff_extension)

							if not multiplier then
								-- Nothing
							end
						end

						multiplier = v_2.multiplier
						multiplier = multiplier or 0

						::label_12_0::

						local proc_chance = v_2.proc_chance

						proc_chance = proc_chance or 0

						local value = v_2.value
						local flag = value or 0

						_stat_base_value = value or _stat_base_value * (1 + multiplier) + bonus

						Imgui.text(string.format("%-36s%8.2f%12.2f%13.2f%14.2f%15.2f", k, bonus, multiplier, flag, proc_chance, _stat_base_value))
					end

					Imgui.separator()
				end
			end
		end

		Imgui.dummy(10, 10)
		Imgui.tree_pop()
	end
end

ImguiBuffsDebug._display_event_buffs = function (arg_13_0, arg_13_1)
	-- function 13
	if not Imgui.tree_node("Event Buffs") then
		if not arg_13_1 then
			Imgui.separator()
			Imgui.text(string.format("%-53s%8s%12s%13s%14s", "Name", "Bonus", "Multiplier", "Value", "Proc Chance"))
			Imgui.separator()

			for k, v in pairs(arg_13_1) do
				if not table.is_empty(v) then
					if not Imgui.tree_node(k) then
						for k_2, v_2 in pairs(v) do
							local buff_type = v_2.buff_type

							buff_type = buff_type or ""

							local bonus = v_2.bonus

							bonus = bonus or 0

							local value = v_2.value

							value = value or 0

							local multiplier = v_2.multiplier

							multiplier = multiplier or 0

							local proc_chance = v_2.proc_chance

							proc_chance = proc_chance or 1

							Imgui.text(string.format("%-50s%8.2f%12.2f%13.2f%14.2f", buff_type, bonus, multiplier, value, proc_chance))
						end

						Imgui.tree_pop()
					end

					Imgui.separator()
				end
			end
		end

		Imgui.dummy(10, 10)
		Imgui.tree_pop()
	end
end

ImguiBuffsDebug._display_movement_settings = function (arg_14_0, arg_14_1)
	-- function 14
	if not Unit.alive(arg_14_1) then
		return
	end

	local get_movement_settings_table = PlayerUnitMovementSettings.get_movement_settings_table(arg_14_1)

	if not get_movement_settings_table then
		return
	end

	if not Imgui.tree_node("Movement Settings") then
		Imgui.text(string.format("%-36s", "Move speed"))
		Imgui.text(string.format("    %-36s%.1f", "forwards", get_movement_settings_table.move_speed))
		Imgui.text(string.format("    %-36s%.1f", "backwards", get_movement_settings_table.backward_move_scale * get_movement_settings_table.move_speed))
		Imgui.text(string.format("    %-36s%.1f", "walk", get_movement_settings_table.walk_move_speed))
		Imgui.text(string.format("    %-36s%.1f", "crouch", get_movement_settings_table.crouch_move_speed))
		Imgui.text(string.format("    %-36s%.1f", "pounce", get_movement_settings_table.pounce_speed))
		Imgui.text(string.format("%-36s", "Dodge"))
		Imgui.text(string.format("    %-36s%.1f m", "distance", get_movement_settings_table.dodging.distance))
		Imgui.text(string.format("    %-36sx%.1f", "distance modifier", get_movement_settings_table.dodging.distance_modifier))
		Imgui.text(string.format("    %-36s%.1f s", "cooldown", get_movement_settings_table.dodging.dodge_cd))
		Imgui.text(string.format("    %-36sx%.1f", "speed modifier", get_movement_settings_table.dodging.speed_modifier))
		Imgui.dummy(10, 10)
		Imgui.tree_pop()
	end
end

ImguiBuffsDebug._refresh_unit_list = function (self)
	-- function 15
	self._unit_names = {}
	self._units = {}

	local var_15_0

	table.insert(self._unit_names, "none")
	table.insert(self._units, false)

	local player = Managers.player

	if not player then
		local human_and_bot_players = player:human_and_bot_players()

		for k, v in pairs(human_and_bot_players) do
			if not v then
				local profile_display_name = v:profile_display_name()

				table.insert(self._unit_names, profile_display_name)
				table.insert(self._units, v.player_unit)

				if not v.local_player then
					var_15_0 = #self._unit_names
				end
			end
		end
	end

	if not ALIVE[script_data.debug_unit] then
		local debug_unit = script_data.debug_unit

		table.insert(self._unit_names, "Selected AI: " .. Unit.debug_name(debug_unit))
		table.insert(self._units, debug_unit)

		if not self._fallback_to_ai then
			self._selected_unit_idx = #self._units
		end
	end

	if not self._units[self._selected_unit_idx] then
		self._selected_unit_idx = var_15_0 or 1
	end

	self._current_unit = self._units[self._selected_unit_idx]
	self._selected_unit = self._current_unit
	self._selected_debug_unit = script_data.debug_unit
	self._debug_unit_alive = ALIVE[self._selected_debug_unit]

	self:_initialize_unit(self._current_unit)
end

ImguiBuffsDebug._initialize_unit = function (self, arg_16_1)
	-- function 16
	self._current_unit = arg_16_1

	if not arg_16_1 and not Unit.alive(arg_16_1) then
		self._buff_extension = ScriptUnit.extension(arg_16_1, "buff_system")
	end
end

ImguiBuffsDebug._add_buff = function (self, arg_17_1, arg_17_2, arg_17_3)
	-- function 17
	if not self._buff_extension and not arg_17_2 then
		self._buff_extension:add_buff(arg_17_2, arg_17_3)
	end
end

ImguiBuffsDebug._add_buff_with_buff_system = function (self, arg_18_1)
	-- function 18
	if not self._current_unit then
		local system = Managers.state.entity:system("buff_system")

		if not system then
			system:add_buff(self._current_unit, arg_18_1, self._current_unit)
		end
	end
end

ImguiBuffsDebug._add_buff_with_buff_synced = function (self, arg_19_1, arg_19_2)
	-- function 19
	if not self._current_unit then
		local system = Managers.state.entity:system("buff_system")

		if not system then
			system:add_buff_synced(self._current_unit, arg_19_1, arg_19_2, nil, self._target_peer_id)
		end
	end
end

ImguiBuffsDebug._remove_buff = function (self, arg_20_1, arg_20_2)
	-- function 20
	if not self._buff_extension and not arg_20_2 then
		self._buff_extension:remove_buff(arg_20_2)
	end
end
