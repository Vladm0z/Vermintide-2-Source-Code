-- chunkname: @scripts/imgui/imgui_buffs_debug.lua

ImguiBuffsDebug = class(ImguiBuffsDebug)

local SHOULD_RELOAD = true

ImguiBuffsDebug.init = function (self)
	-- function 1
	self._buff_system = nil
	self._unit_names = {}
	self._units = {}

	local _selected_unit_idx = self._selected_unit_idx

	_selected_unit_idx = not not _selected_unit_idx or not not -1
	self._selected_unit_idx = _selected_unit_idx
	self._selected_unit = nil
	self._selected_debug_unit = nil
	self._debug_unit_alive = false
	self._stat_base_value = 1

	local _filter_text = self._filter_text

	_filter_text = not not _filter_text or not not ""
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

	for name, template in pairs(BuffTemplates) do
		template = BuffUtils.get_buff_template(name)

		table.insert(self._buff_list, name)
	end

	table.sort(self._buff_list)

	self._selected_buff_id = 0
end

ImguiBuffsDebug._apply_buff_filter = function (self, filter_text, buff_list)
	-- function 3
	if filter_text == "" then
		return buff_list
	end

	local filtered_list = {}
	local search_string = string.gsub(filter_text, "[_ ]", "")

	for i = 1, #buff_list do
		local buff = buff_list[i]
		local search_buff_name = string.gsub(buff, "[_ ]", "")

		if search_buff_name:find(search_string, 1, true) then
			table.insert(filtered_list, buff)
		end
	end

	return filtered_list
end

ImguiBuffsDebug.update = function (self)
	-- function 4
	if SHOULD_RELOAD then
		self:init()

		SHOULD_RELOAD = false
	end

	if (not self._current_unit or not ALIVE[self._current_unit] or not self._selected_unit or ALIVE[self._selected_unit]) and self._selected_debug_unit ~= script_data.debug_unit or self._debug_unit_alive ~= ALIVE[self._selected_debug_unit] then
		self:_refresh_unit_list()
	end
end

ImguiBuffsDebug.on_round_start = function (self)
	-- function 5
	self._current_unit = nil

	self:_refresh_unit_list()
end

ImguiBuffsDebug.is_persistent = function (self)
	-- function 6
	return true
end

ImguiBuffsDebug.draw = function (self, is_open)
	-- function 7
	local do_close = Imgui.begin_window("Buff Debug")

	self:_update_controls()

	local _buff_extension = self._buff_extension

	if _buff_extension then
		-- Nothing
	end

	_buff_extension = self._buff_extension._buffs

	local buffs = _buff_extension

	::label_7_0::

	local _buff_extension_2 = self._buff_extension

	if _buff_extension_2 then
		-- Nothing
	end

	_buff_extension_2 = self._buff_extension._stat_buffs

	local stat_buffs = _buff_extension_2

	::label_7_1::

	local _buff_extension_3 = self._buff_extension

	if _buff_extension_3 then
		-- Nothing
	end

	_buff_extension_3 = self._buff_extension._event_buffs

	local event_buffs = _buff_extension_3

	::label_7_2::

	local _buff_extension_4 = self._buff_extension

	if _buff_extension_4 then
		-- Nothing
	end

	_buff_extension_4 = self._buff_extension._perks

	local perks = _buff_extension_4

	::label_7_3::

	self:_display_buffs(buffs)
	self:_display_perks(perks)
	self:_display_stat_buffs(stat_buffs)
	self:_display_event_buffs(event_buffs)
	self:_display_movement_settings(self._current_unit)
	Imgui.end_window()

	return do_close
end

ImguiBuffsDebug._update_controls = function (self)
	-- function 8
	local selected_unit_idx = Imgui.combo("Unit", self._selected_unit_idx, self._unit_names)

	if selected_unit_idx ~= self._selected_unit_idx then
		self._selected_unit_idx = selected_unit_idx
		self._selected_unit = self._units[selected_unit_idx]

		if self._selected_unit then
			self._fallback_to_ai = self._selected_unit == script_data.debug_unit
		end

		self:_initialize_unit(self._selected_unit)
	end

	Imgui.same_line()

	if Imgui.button("Refresh") then
		self:_refresh_unit_list()

		self._fallback_to_ai = self._selected_unit == script_data.debug_unit
	end

	self._selected_buff_id, self._filtered_buff_list, self._filter_text = ImguiX.combo_search(self._selected_buff_id, self._filtered_buff_list, self._filter_text, self._buff_list)
	self._buff_advanced_params_enabled = Imgui.checkbox("Advanced Params", self._buff_advanced_params_enabled)

	if self._buff_advanced_params_enabled then
		Imgui.tree_push("bonus_input")

		self._buff_bonus_enabled = Imgui.checkbox("Bonus", self._buff_bonus_enabled)

		if self._buff_bonus_enabled then
			Imgui.same_line()

			self._buff_bonus = Imgui.input_float("", self._buff_bonus)
		end

		Imgui.tree_pop()
		Imgui.tree_push("mult_input")

		self._buff_multiplier_enabled = Imgui.checkbox("Multiplier", self._buff_multiplier_enabled)

		if self._buff_multiplier_enabled then
			Imgui.same_line()

			self._buff_multiplier = Imgui.input_float("", self._buff_multiplier)
		end

		Imgui.tree_pop()
		Imgui.tree_push("val_input")

		self._buff_value_enabled = Imgui.checkbox("Value", self._buff_value_enabled)

		if self._buff_value_enabled then
			Imgui.same_line()

			self._buff_value = Imgui.input_float("", self._buff_value)
		end

		Imgui.tree_pop()
		Imgui.tree_push("proc_input")

		self._buff_proc_chance_enabled = Imgui.checkbox("Proc Chance", self._buff_proc_chance_enabled)

		if self._buff_proc_chance_enabled then
			Imgui.same_line()

			self._buff_proc_chance = Imgui.input_float("", self._buff_proc_chance)
		end

		Imgui.tree_pop()
		Imgui.tree_push("duration_input")

		self._buff_duration_enabled = Imgui.checkbox("Duration", self._buff_duration_enabled)

		if self._buff_duration_enabled then
			Imgui.same_line()

			self._buff_duration = Imgui.input_float("", self._buff_duration)
		end

		Imgui.tree_pop()
		Imgui.tree_push("range_input")

		self._buff_range_enabled = Imgui.checkbox("Range", self._buff_range_enabled)

		if self._buff_range_enabled then
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

	if Imgui.button("Add", 100, 20) then
		local buff_to_add = self._filtered_buff_list[self._selected_buff_id]
		local _buff_advanced_params_enabled = self._buff_advanced_params_enabled

		if _buff_advanced_params_enabled then
			-- Nothing
		end

		_buff_advanced_params_enabled = {}

		do
			local _buff_bonus_enabled = self._buff_bonus_enabled

			_buff_bonus_enabled = not not _buff_bonus_enabled and not not self._buff_bonus
			_buff_advanced_params_enabled.external_optional_bonus = _buff_bonus_enabled

			local _buff_multiplier_enabled = self._buff_multiplier_enabled

			_buff_multiplier_enabled = not not _buff_multiplier_enabled and not not self._buff_multiplier
			_buff_advanced_params_enabled.external_optional_multiplier = _buff_multiplier_enabled

			local _buff_value_enabled = self._buff_value_enabled

			_buff_value_enabled = not not _buff_value_enabled and not not self._buff_value
			_buff_advanced_params_enabled.external_optional_value = _buff_value_enabled

			local _buff_proc_chance_enabled = self._buff_proc_chance_enabled

			_buff_proc_chance_enabled = not not _buff_proc_chance_enabled and not not self._buff_proc_chance
			_buff_advanced_params_enabled.external_optional_proc_chance = _buff_proc_chance_enabled

			local _buff_duration_enabled = self._buff_duration_enabled

			_buff_duration_enabled = not not _buff_duration_enabled and not not self._buff_duration
			_buff_advanced_params_enabled.external_optional_duration = _buff_duration_enabled

			local _buff_range_enabled = self._buff_range_enabled

			_buff_range_enabled = not not _buff_range_enabled and not not self._buff_range
			_buff_advanced_params_enabled.external_optional_range = _buff_range_enabled
			_buff_advanced_params_enabled.power_level = self._buff_power_level

			local params = _buff_advanced_params_enabled
		end

		::label_8_0::

		self:_add_buff(self._buff_extension, buff_to_add, params)
	end

	if Imgui.button("Add with buff system", 200, 20) then
		local buff_to_add = self._filtered_buff_list[self._selected_buff_id]

		if buff_to_add then
			self:_add_buff_with_buff_system(buff_to_add)
		end
	end

	Imgui.separator()
	Imgui.push_item_width(200)

	self._selected_buff_sync_type_id = Imgui.combo("Sync Type", self._selected_buff_sync_type_id, BuffSyncType)

	Imgui.pop_item_width()

	local sync_type = BuffSyncType[self._selected_buff_sync_type_id]

	if sync_type == BuffSyncType.Client or sync_type == BuffSyncType.ClientAndServer then
		local found_peer_ids = FrameTable.alloc_table()
		local actual_peer_ids = FrameTable.alloc_table()
		local peer_ids = table.select_array(table.keys(Managers.player:human_players()), function (_, unique_id)
			-- function 9
			local peer_id = string.sub(unique_id, 1, string.find(unique_id, ":") - 1)

			if not found_peer_ids[peer_id] then
				found_peer_ids[peer_id] = true

				local player_name = Managers.player:player_from_unique_id(unique_id):name()
				local display_name = string.format("%s (%s)", player_name, peer_id)

				actual_peer_ids[#actual_peer_ids + 1] = peer_id

				return display_name
			end

			return nil
		end)
		local combo = Imgui.combo
		local str = "Peer ID"
		local min = math.min
		local _target_peer_id_idx = self._target_peer_id_idx

		_target_peer_id_idx = not not _target_peer_id_idx or not not 1
		self._target_peer_id_idx = combo(str, min(_target_peer_id_idx, #peer_ids), peer_ids)
		self._target_peer_id = actual_peer_ids[self._target_peer_id_idx]
	end

	if Imgui.button("Add Buff Sync", 200, 20) then
		local buff_to_add = self._filtered_buff_list[self._selected_buff_id]
		local sync_type = BuffSyncType[self._selected_buff_sync_type_id]

		if buff_to_add and sync_type then
			self:_add_buff_with_buff_synced(buff_to_add, sync_type)
		end
	end

	Imgui.separator()
	Imgui.dummy(10, 10)
end

ImguiBuffsDebug._display_buffs = function (self, buffs)
	-- function 10
	if Imgui.tree_node("Buffs") then
		if buffs then
			local buffs_to_remove

			for i = 1, #buffs do
				local buff = buffs[i]

				if not buff.removed and Imgui.tree_node(buff.buff_type .. "(" .. buff.id .. ")") then
					for name, data in pairs(buff) do
						if name == "template" and Imgui.tree_node(name) then
							for template_name, template_data in pairs(data) do
								Imgui.text(template_name)
								Imgui.same_line()
								Imgui.text(tostring(template_data))
							end

							Imgui.tree_pop()
						end

						if type(data) ~= "function" and type(data) ~= "table" and name ~= "buff_type" and name ~= "id" then
							Imgui.text(name)
							Imgui.same_line()
							Imgui.text(tostring(data))
						end
					end

					if Imgui.button("Remove") then
						buffs_to_remove = not not buffs_to_remove or not not {}

						table.insert(buffs_to_remove, buff.id)
					end

					Imgui.tree_pop()
				end

				Imgui.separator()
			end

			if buffs_to_remove then
				for i = 1, #buffs_to_remove do
					self:_remove_buff(self._buff_extension, buffs_to_remove[i])
				end
			end
		end

		Imgui.dummy(10, 10)
		Imgui.tree_pop()
	end
end

ImguiBuffsDebug._display_perks = function (self, perks)
	-- function 11
	if Imgui.tree_node("Perks") then
		if perks then
			for perk_name, num in pairs(perks) do
				if num > 0 then
					Imgui.text(string.format("%s %d", perk_name .. " ", num))
				end
			end
		end

		Imgui.dummy(10, 10)
		Imgui.tree_pop()
	end
end

ImguiBuffsDebug._display_stat_buffs = function (self, stat_buffs)
	-- function 12
	if Imgui.tree_node("Stat Buffs") then
		self._stat_base_value = Imgui.input_float("Base Stat Value", self._stat_base_value)

		if stat_buffs then
			Imgui.separator()
			Imgui.text(string.format("%-36s%8s%12s%13s%14s%15s", "Name", "Bonus", "Multiplier", "Value", "Proc Chance", "Final Value"))
			Imgui.separator()

			for name, data in pairs(stat_buffs) do
				if not table.is_empty(data) then
					local final_value = self._stat_base_value

					for index, buff in pairs(data) do
						local bonus_2 = buff.bonus

						if not bonus_2 then
							-- Nothing
						end

						bonus_2 = 0

						local bonus = bonus_2

						do
							local multiplier_2
						end

						::label_12_0::

						if type(buff.multiplier) == "function" then
							multiplier_2 = buff.multiplier(self._current_unit, self._buff_extension)

							if not multiplier_2 then
								-- Nothing
							end
						end

						multiplier_2 = buff.multiplier

						if not multiplier_2 then
							-- Nothing
						end

						multiplier_2 = 0

						local multiplier = multiplier_2

						::label_12_1::

						local proc_chance_2 = buff.proc_chance

						if not proc_chance_2 then
							-- Nothing
						end

						proc_chance_2 = 0

						local proc_chance = proc_chance_2

						::label_12_2::

						local value = buff.value
						local display_value = not not value or not not 0

						final_value = not not value or not not (final_value * (1 + multiplier) + bonus)

						Imgui.text(string.format("%-36s%8.2f%12.2f%13.2f%14.2f%15.2f", name, bonus, multiplier, display_value, proc_chance, final_value))
					end

					Imgui.separator()
				end
			end
		end

		Imgui.dummy(10, 10)
		Imgui.tree_pop()
	end
end

ImguiBuffsDebug._display_event_buffs = function (self, event_buffs)
	-- function 13
	if Imgui.tree_node("Event Buffs") then
		if event_buffs then
			Imgui.separator()
			Imgui.text(string.format("%-53s%8s%12s%13s%14s", "Name", "Bonus", "Multiplier", "Value", "Proc Chance"))
			Imgui.separator()

			for name, data in pairs(event_buffs) do
				if not table.is_empty(data) then
					if Imgui.tree_node(name) then
						for index, buff in pairs(data) do
							local buff_type = buff.buff_type

							if not buff_type then
								-- Nothing
							end

							buff_type = ""

							local buff_name = buff_type

							::label_13_0::

							local bonus_2 = buff.bonus

							if not bonus_2 then
								-- Nothing
							end

							bonus_2 = 0

							local bonus = bonus_2

							::label_13_1::

							local value_2 = buff.value

							if not value_2 then
								-- Nothing
							end

							value_2 = 0

							local value = value_2

							::label_13_2::

							local multiplier_2 = buff.multiplier

							if not multiplier_2 then
								-- Nothing
							end

							multiplier_2 = 0

							local multiplier = multiplier_2

							::label_13_3::

							local proc_chance_2 = buff.proc_chance

							if not proc_chance_2 then
								-- Nothing
							end

							proc_chance_2 = 1

							local proc_chance = proc_chance_2

							::label_13_4::

							Imgui.text(string.format("%-50s%8.2f%12.2f%13.2f%14.2f", buff_name, bonus, multiplier, value, proc_chance))
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

ImguiBuffsDebug._display_movement_settings = function (self, unit)
	-- function 14
	if not Unit.alive(unit) then
		return
	end

	local movement_settings = PlayerUnitMovementSettings.get_movement_settings_table(unit)

	if not movement_settings then
		return
	end

	if Imgui.tree_node("Movement Settings") then
		Imgui.text(string.format("%-36s", "Move speed"))
		Imgui.text(string.format("    %-36s%.1f", "forwards", movement_settings.move_speed))
		Imgui.text(string.format("    %-36s%.1f", "backwards", movement_settings.backward_move_scale * movement_settings.move_speed))
		Imgui.text(string.format("    %-36s%.1f", "walk", movement_settings.walk_move_speed))
		Imgui.text(string.format("    %-36s%.1f", "crouch", movement_settings.crouch_move_speed))
		Imgui.text(string.format("    %-36s%.1f", "pounce", movement_settings.pounce_speed))
		Imgui.text(string.format("%-36s", "Dodge"))
		Imgui.text(string.format("    %-36s%.1f m", "distance", movement_settings.dodging.distance))
		Imgui.text(string.format("    %-36sx%.1f", "distance modifier", movement_settings.dodging.distance_modifier))
		Imgui.text(string.format("    %-36s%.1f s", "cooldown", movement_settings.dodging.dodge_cd))
		Imgui.text(string.format("    %-36sx%.1f", "speed modifier", movement_settings.dodging.speed_modifier))
		Imgui.dummy(10, 10)
		Imgui.tree_pop()
	end
end

ImguiBuffsDebug._refresh_unit_list = function (self)
	-- function 15
	self._unit_names = {}
	self._units = {}

	local local_player_index

	table.insert(self._unit_names, "none")
	table.insert(self._units, false)

	local player_manager = Managers.player

	if player_manager then
		local players = player_manager:human_and_bot_players()

		for id, player in pairs(players) do
			if player then
				local profile_display_name = player:profile_display_name()

				table.insert(self._unit_names, profile_display_name)
				table.insert(self._units, player.player_unit)

				if player.local_player then
					local_player_index = #self._unit_names
				end
			end
		end
	end

	if ALIVE[script_data.debug_unit] then
		local ai_unit = script_data.debug_unit

		table.insert(self._unit_names, "Selected AI: " .. Unit.debug_name(ai_unit))
		table.insert(self._units, ai_unit)

		if self._fallback_to_ai then
			self._selected_unit_idx = #self._units
		end
	end

	if not self._units[self._selected_unit_idx] then
		self._selected_unit_idx = not not local_player_index or not not 1
	end

	self._current_unit = self._units[self._selected_unit_idx]
	self._selected_unit = self._current_unit
	self._selected_debug_unit = script_data.debug_unit
	self._debug_unit_alive = ALIVE[self._selected_debug_unit]

	self:_initialize_unit(self._current_unit)
end

ImguiBuffsDebug._initialize_unit = function (self, unit)
	-- function 16
	self._current_unit = unit

	if unit and Unit.alive(unit) then
		self._buff_extension = ScriptUnit.extension(unit, "buff_system")
	end
end

ImguiBuffsDebug._add_buff = function (self, buff_extension, buff_name, params)
	-- function 17
	if self._buff_extension and buff_name then
		self._buff_extension:add_buff(buff_name, params)
	end
end

ImguiBuffsDebug._add_buff_with_buff_system = function (self, buff_name)
	-- function 18
	if self._current_unit then
		local buff_system = Managers.state.entity:system("buff_system")

		if buff_system then
			buff_system:add_buff(self._current_unit, buff_name, self._current_unit)
		end
	end
end

ImguiBuffsDebug._add_buff_with_buff_synced = function (self, buff_name, sync_type)
	-- function 19
	if self._current_unit then
		local buff_system = Managers.state.entity:system("buff_system")

		if buff_system then
			buff_system:add_buff_synced(self._current_unit, buff_name, sync_type, nil, self._target_peer_id)
		end
	end
end

ImguiBuffsDebug._remove_buff = function (self, buff_extension, buff_id)
	-- function 20
	if self._buff_extension and buff_id then
		self._buff_extension:remove_buff(buff_id)
	end
end
