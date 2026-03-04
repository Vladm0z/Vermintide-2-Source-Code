-- chunkname: @scripts/imgui/imgui_buffs_debug.lua

ImguiBuffsDebug = class(ImguiBuffsDebug)

local var_0_0 = true

function ImguiBuffsDebug.init(arg_1_0)
	arg_1_0._buff_system = nil
	arg_1_0._unit_names = {}
	arg_1_0._units = {}
	arg_1_0._selected_unit_idx = arg_1_0._selected_unit_idx or -1
	arg_1_0._selected_unit = nil
	arg_1_0._selected_debug_unit = nil
	arg_1_0._debug_unit_alive = false
	arg_1_0._stat_base_value = 1
	arg_1_0._filter_text = arg_1_0._filter_text or ""
	arg_1_0._buff_list = {}
	arg_1_0._filtered_buff_list = {}
	arg_1_0._selected_buff_id = 0
	arg_1_0._selected_buff_sync_type_id = 1
	arg_1_0._buff_advanced_params_enabled = false
	arg_1_0._buff_bonus_enabled = false
	arg_1_0._buff_multiplier_enabled = false
	arg_1_0._buff_value_enabled = false
	arg_1_0._buff_proc_chance_enabled = false
	arg_1_0._buff_duration_enabled = false
	arg_1_0._buff_range_enabled = false
	arg_1_0._buff_bonus = 0
	arg_1_0._buff_multiplier = 0
	arg_1_0._buff_value = 0
	arg_1_0._buff_proc_chance = 0
	arg_1_0._buff_duration = 0
	arg_1_0._buff_range = 0
	arg_1_0._buff_power_level = 0
	arg_1_0._current_unit = nil
	arg_1_0._buff_extension = nil

	arg_1_0:_get_buff_templates()

	arg_1_0._filtered_buff_list = arg_1_0:_apply_buff_filter(arg_1_0._filter_text, arg_1_0._buff_list)
	arg_1_0._target_peer_id = ""
end

function ImguiBuffsDebug._get_buff_templates(arg_2_0)
	table.clear(arg_2_0._buff_list)

	for iter_2_0, iter_2_1 in pairs(BuffTemplates) do
		iter_2_1 = BuffUtils.get_buff_template(iter_2_0)

		table.insert(arg_2_0._buff_list, iter_2_0)
	end

	table.sort(arg_2_0._buff_list)

	arg_2_0._selected_buff_id = 0
end

function ImguiBuffsDebug._apply_buff_filter(arg_3_0, arg_3_1, arg_3_2)
	if arg_3_1 == "" then
		return arg_3_2
	end

	local var_3_0 = {}
	local var_3_1 = string.gsub(arg_3_1, "[_ ]", "")

	for iter_3_0 = 1, #arg_3_2 do
		local var_3_2 = arg_3_2[iter_3_0]

		if string.gsub(var_3_2, "[_ ]", ""):find(var_3_1, 1, true) then
			table.insert(var_3_0, var_3_2)
		end
	end

	return var_3_0
end

function ImguiBuffsDebug.update(arg_4_0)
	if var_0_0 then
		arg_4_0:init()

		var_0_0 = false
	end

	if not arg_4_0._current_unit or not ALIVE[arg_4_0._current_unit] or arg_4_0._selected_unit and not ALIVE[arg_4_0._selected_unit] or arg_4_0._selected_debug_unit ~= script_data.debug_unit or arg_4_0._debug_unit_alive ~= ALIVE[arg_4_0._selected_debug_unit] then
		arg_4_0:_refresh_unit_list()
	end
end

function ImguiBuffsDebug.on_round_start(arg_5_0)
	arg_5_0._current_unit = nil

	arg_5_0:_refresh_unit_list()
end

function ImguiBuffsDebug.is_persistent(arg_6_0)
	return true
end

function ImguiBuffsDebug.draw(arg_7_0, arg_7_1)
	local var_7_0 = Imgui.begin_window("Buff Debug")

	arg_7_0:_update_controls()

	local var_7_1 = arg_7_0._buff_extension and arg_7_0._buff_extension._buffs
	local var_7_2 = arg_7_0._buff_extension and arg_7_0._buff_extension._stat_buffs
	local var_7_3 = arg_7_0._buff_extension and arg_7_0._buff_extension._event_buffs
	local var_7_4 = arg_7_0._buff_extension and arg_7_0._buff_extension._perks

	arg_7_0:_display_buffs(var_7_1)
	arg_7_0:_display_perks(var_7_4)
	arg_7_0:_display_stat_buffs(var_7_2)
	arg_7_0:_display_event_buffs(var_7_3)
	Imgui.end_window()

	return var_7_0
end

function ImguiBuffsDebug._update_controls(arg_8_0)
	local var_8_0 = Imgui.combo("Unit", arg_8_0._selected_unit_idx, arg_8_0._unit_names)

	if var_8_0 ~= arg_8_0._selected_unit_idx then
		arg_8_0._selected_unit_idx = var_8_0
		arg_8_0._selected_unit = arg_8_0._units[var_8_0]

		if arg_8_0._selected_unit then
			arg_8_0._fallback_to_ai = arg_8_0._selected_unit == script_data.debug_unit
		end

		arg_8_0:_initialize_unit(arg_8_0._selected_unit)
	end

	Imgui.same_line()

	if Imgui.button("Refresh") then
		arg_8_0:_refresh_unit_list()

		arg_8_0._fallback_to_ai = arg_8_0._selected_unit == script_data.debug_unit
	end

	arg_8_0._selected_buff_id, arg_8_0._filtered_buff_list, arg_8_0._filter_text = ImguiX.combo_search(arg_8_0._selected_buff_id, arg_8_0._filtered_buff_list, arg_8_0._filter_text, arg_8_0._buff_list)
	arg_8_0._buff_advanced_params_enabled = Imgui.checkbox("Advanced Params", arg_8_0._buff_advanced_params_enabled)

	if arg_8_0._buff_advanced_params_enabled then
		Imgui.tree_push("bonus_input")

		arg_8_0._buff_bonus_enabled = Imgui.checkbox("Bonus", arg_8_0._buff_bonus_enabled)

		if arg_8_0._buff_bonus_enabled then
			Imgui.same_line()

			arg_8_0._buff_bonus = Imgui.input_float("", arg_8_0._buff_bonus)
		end

		Imgui.tree_pop()
		Imgui.tree_push("mult_input")

		arg_8_0._buff_multiplier_enabled = Imgui.checkbox("Multiplier", arg_8_0._buff_multiplier_enabled)

		if arg_8_0._buff_multiplier_enabled then
			Imgui.same_line()

			arg_8_0._buff_multiplier = Imgui.input_float("", arg_8_0._buff_multiplier)
		end

		Imgui.tree_pop()
		Imgui.tree_push("val_input")

		arg_8_0._buff_value_enabled = Imgui.checkbox("Value", arg_8_0._buff_value_enabled)

		if arg_8_0._buff_value_enabled then
			Imgui.same_line()

			arg_8_0._buff_value = Imgui.input_float("", arg_8_0._buff_value)
		end

		Imgui.tree_pop()
		Imgui.tree_push("proc_input")

		arg_8_0._buff_proc_chance_enabled = Imgui.checkbox("Proc Chance", arg_8_0._buff_proc_chance_enabled)

		if arg_8_0._buff_proc_chance_enabled then
			Imgui.same_line()

			arg_8_0._buff_proc_chance = Imgui.input_float("", arg_8_0._buff_proc_chance)
		end

		Imgui.tree_pop()
		Imgui.tree_push("duration_input")

		arg_8_0._buff_duration_enabled = Imgui.checkbox("Duration", arg_8_0._buff_duration_enabled)

		if arg_8_0._buff_duration_enabled then
			Imgui.same_line()

			arg_8_0._buff_duration = Imgui.input_float("", arg_8_0._buff_duration)
		end

		Imgui.tree_pop()
		Imgui.tree_push("range_input")

		arg_8_0._buff_range_enabled = Imgui.checkbox("Range", arg_8_0._buff_range_enabled)

		if arg_8_0._buff_range_enabled then
			Imgui.same_line()

			arg_8_0._buff_range = Imgui.input_float("", arg_8_0._buff_range)
		end

		Imgui.tree_pop()
		Imgui.tree_push("power_input")
		Imgui.dummy(15, 15)
		Imgui.same_line()
		Imgui.text("Power Level")
		Imgui.same_line()

		arg_8_0._buff_power_level = Imgui.input_float("", arg_8_0._buff_power_level)

		Imgui.tree_pop()
	end

	if Imgui.button("Add", 100, 20) then
		local var_8_1 = arg_8_0._filtered_buff_list[arg_8_0._selected_buff_id]
		local var_8_2 = arg_8_0._buff_advanced_params_enabled and {
			external_optional_bonus = arg_8_0._buff_bonus_enabled and arg_8_0._buff_bonus,
			external_optional_multiplier = arg_8_0._buff_multiplier_enabled and arg_8_0._buff_multiplier,
			external_optional_value = arg_8_0._buff_value_enabled and arg_8_0._buff_value,
			external_optional_proc_chance = arg_8_0._buff_proc_chance_enabled and arg_8_0._buff_proc_chance,
			external_optional_duration = arg_8_0._buff_duration_enabled and arg_8_0._buff_duration,
			external_optional_range = arg_8_0._buff_range_enabled and arg_8_0._buff_range,
			power_level = arg_8_0._buff_power_level
		}

		arg_8_0:_add_buff(arg_8_0._buff_extension, var_8_1, var_8_2)
	end

	if Imgui.button("Add with buff system", 200, 20) then
		local var_8_3 = arg_8_0._filtered_buff_list[arg_8_0._selected_buff_id]

		if var_8_3 then
			arg_8_0:_add_buff_with_buff_system(var_8_3)
		end
	end

	Imgui.separator()
	Imgui.push_item_width(200)

	arg_8_0._selected_buff_sync_type_id = Imgui.combo("Sync Type", arg_8_0._selected_buff_sync_type_id, BuffSyncType)

	Imgui.pop_item_width()

	local var_8_4 = BuffSyncType[arg_8_0._selected_buff_sync_type_id]

	if var_8_4 == BuffSyncType.Client or var_8_4 == BuffSyncType.ClientAndServer then
		local var_8_5 = FrameTable.alloc_table()
		local var_8_6 = FrameTable.alloc_table()
		local var_8_7 = table.select_array(table.keys(Managers.player:human_players()), function(arg_9_0, arg_9_1)
			local var_9_0 = string.sub(arg_9_1, 1, string.find(arg_9_1, ":") - 1)

			if not var_8_5[var_9_0] then
				var_8_5[var_9_0] = true

				local var_9_1 = Managers.player:player_from_unique_id(arg_9_1):name()
				local var_9_2 = string.format("%s (%s)", var_9_1, var_9_0)

				var_8_6[#var_8_6 + 1] = var_9_0

				return var_9_2
			end

			return nil
		end)

		arg_8_0._target_peer_id_idx = Imgui.combo("Peer ID", math.min(arg_8_0._target_peer_id_idx or 1, #var_8_7), var_8_7)
		arg_8_0._target_peer_id = var_8_6[arg_8_0._target_peer_id_idx]
	end

	if Imgui.button("Add Buff Sync", 200, 20) then
		local var_8_8 = arg_8_0._filtered_buff_list[arg_8_0._selected_buff_id]
		local var_8_9 = BuffSyncType[arg_8_0._selected_buff_sync_type_id]

		if var_8_8 and var_8_9 then
			arg_8_0:_add_buff_with_buff_synced(var_8_8, var_8_9)
		end
	end

	Imgui.separator()
	Imgui.dummy(10, 10)
end

function ImguiBuffsDebug._display_buffs(arg_10_0, arg_10_1)
	if Imgui.tree_node("Buffs") then
		if arg_10_1 then
			local var_10_0

			for iter_10_0 = 1, #arg_10_1 do
				local var_10_1 = arg_10_1[iter_10_0]

				if not var_10_1.removed and Imgui.tree_node(var_10_1.buff_type .. "(" .. var_10_1.id .. ")") then
					for iter_10_1, iter_10_2 in pairs(var_10_1) do
						if iter_10_1 == "template" and Imgui.tree_node(iter_10_1) then
							for iter_10_3, iter_10_4 in pairs(iter_10_2) do
								Imgui.text(iter_10_3)
								Imgui.same_line()
								Imgui.text(tostring(iter_10_4))
							end

							Imgui.tree_pop()
						end

						if type(iter_10_2) ~= "function" and type(iter_10_2) ~= "table" and iter_10_1 ~= "buff_type" and iter_10_1 ~= "id" then
							Imgui.text(iter_10_1)
							Imgui.same_line()
							Imgui.text(tostring(iter_10_2))
						end
					end

					if Imgui.button("Remove") then
						var_10_0 = var_10_0 or {}

						table.insert(var_10_0, var_10_1.id)
					end

					Imgui.tree_pop()
				end

				Imgui.separator()
			end

			if var_10_0 then
				for iter_10_5 = 1, #var_10_0 do
					arg_10_0:_remove_buff(arg_10_0._buff_extension, var_10_0[iter_10_5])
				end
			end
		end

		Imgui.dummy(10, 10)
		Imgui.tree_pop()
	end
end

function ImguiBuffsDebug._display_perks(arg_11_0, arg_11_1)
	if Imgui.tree_node("Perks") then
		if arg_11_1 then
			for iter_11_0, iter_11_1 in pairs(arg_11_1) do
				if iter_11_1 > 0 then
					Imgui.text(string.format("%s %d", iter_11_0 .. " ", iter_11_1))
				end
			end
		end

		Imgui.dummy(10, 10)
		Imgui.tree_pop()
	end
end

function ImguiBuffsDebug._display_stat_buffs(arg_12_0, arg_12_1)
	if Imgui.tree_node("Stat Buffs") then
		arg_12_0._stat_base_value = Imgui.input_float("Base Stat Value", arg_12_0._stat_base_value)

		if arg_12_1 then
			Imgui.separator()
			Imgui.text(string.format("%-36s%8s%12s%13s%14s%15s", "Name", "Bonus", "Multiplier", "Value", "Proc Chance", "Final Value"))
			Imgui.separator()

			for iter_12_0, iter_12_1 in pairs(arg_12_1) do
				if not table.is_empty(iter_12_1) then
					local var_12_0 = arg_12_0._stat_base_value

					for iter_12_2, iter_12_3 in pairs(iter_12_1) do
						local var_12_1 = iter_12_3.bonus or 0
						local var_12_2 = type(iter_12_3.multiplier) == "function" and iter_12_3.multiplier(arg_12_0._current_unit, arg_12_0._buff_extension) or iter_12_3.multiplier or 0
						local var_12_3 = iter_12_3.proc_chance or 0
						local var_12_4 = iter_12_3.value
						local var_12_5 = var_12_4 or 0

						var_12_0 = var_12_4 or var_12_0 * (1 + var_12_2) + var_12_1

						Imgui.text(string.format("%-36s%8.2f%12.2f%13.2f%14.2f%15.2f", iter_12_0, var_12_1, var_12_2, var_12_5, var_12_3, var_12_0))
					end

					Imgui.separator()
				end
			end
		end

		Imgui.dummy(10, 10)
		Imgui.tree_pop()
	end
end

function ImguiBuffsDebug._display_event_buffs(arg_13_0, arg_13_1)
	if Imgui.tree_node("Event Buffs") then
		if arg_13_1 then
			Imgui.separator()
			Imgui.text(string.format("%-53s%8s%12s%13s%14s", "Name", "Bonus", "Multiplier", "Value", "Proc Chance"))
			Imgui.separator()

			for iter_13_0, iter_13_1 in pairs(arg_13_1) do
				if not table.is_empty(iter_13_1) then
					if Imgui.tree_node(iter_13_0) then
						for iter_13_2, iter_13_3 in pairs(iter_13_1) do
							local var_13_0 = iter_13_3.buff_type or ""
							local var_13_1 = iter_13_3.bonus or 0
							local var_13_2 = iter_13_3.value or 0
							local var_13_3 = iter_13_3.multiplier or 0
							local var_13_4 = iter_13_3.proc_chance or 1

							Imgui.text(string.format("%-50s%8.2f%12.2f%13.2f%14.2f", var_13_0, var_13_1, var_13_3, var_13_2, var_13_4))
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

function ImguiBuffsDebug._refresh_unit_list(arg_14_0)
	arg_14_0._unit_names = {}
	arg_14_0._units = {}

	local var_14_0

	table.insert(arg_14_0._unit_names, "none")
	table.insert(arg_14_0._units, false)

	local var_14_1 = Managers.player

	if var_14_1 then
		local var_14_2 = var_14_1:human_and_bot_players()

		for iter_14_0, iter_14_1 in pairs(var_14_2) do
			if iter_14_1 then
				local var_14_3 = iter_14_1:profile_display_name()

				table.insert(arg_14_0._unit_names, var_14_3)
				table.insert(arg_14_0._units, iter_14_1.player_unit)

				if iter_14_1.local_player then
					var_14_0 = #arg_14_0._unit_names
				end
			end
		end
	end

	if ALIVE[script_data.debug_unit] then
		local var_14_4 = script_data.debug_unit

		table.insert(arg_14_0._unit_names, "Selected AI: " .. Unit.debug_name(var_14_4))
		table.insert(arg_14_0._units, var_14_4)

		if arg_14_0._fallback_to_ai then
			arg_14_0._selected_unit_idx = #arg_14_0._units
		end
	end

	if not arg_14_0._units[arg_14_0._selected_unit_idx] then
		arg_14_0._selected_unit_idx = var_14_0 or 1
	end

	arg_14_0._current_unit = arg_14_0._units[arg_14_0._selected_unit_idx]
	arg_14_0._selected_unit = arg_14_0._current_unit
	arg_14_0._selected_debug_unit = script_data.debug_unit
	arg_14_0._debug_unit_alive = ALIVE[arg_14_0._selected_debug_unit]

	arg_14_0:_initialize_unit(arg_14_0._current_unit)
end

function ImguiBuffsDebug._initialize_unit(arg_15_0, arg_15_1)
	arg_15_0._current_unit = arg_15_1

	if arg_15_1 and Unit.alive(arg_15_1) then
		arg_15_0._buff_extension = ScriptUnit.extension(arg_15_1, "buff_system")
	end
end

function ImguiBuffsDebug._add_buff(arg_16_0, arg_16_1, arg_16_2, arg_16_3)
	if arg_16_0._buff_extension and arg_16_2 then
		arg_16_0._buff_extension:add_buff(arg_16_2, arg_16_3)
	end
end

function ImguiBuffsDebug._add_buff_with_buff_system(arg_17_0, arg_17_1)
	if arg_17_0._current_unit then
		local var_17_0 = Managers.state.entity:system("buff_system")

		if var_17_0 then
			var_17_0:add_buff(arg_17_0._current_unit, arg_17_1, arg_17_0._current_unit)
		end
	end
end

function ImguiBuffsDebug._add_buff_with_buff_synced(arg_18_0, arg_18_1, arg_18_2)
	if arg_18_0._current_unit then
		local var_18_0 = Managers.state.entity:system("buff_system")

		if var_18_0 then
			var_18_0:add_buff_synced(arg_18_0._current_unit, arg_18_1, arg_18_2, nil, arg_18_0._target_peer_id)
		end
	end
end

function ImguiBuffsDebug._remove_buff(arg_19_0, arg_19_1, arg_19_2)
	if arg_19_0._buff_extension and arg_19_2 then
		arg_19_0._buff_extension:remove_buff(arg_19_2)
	end
end
