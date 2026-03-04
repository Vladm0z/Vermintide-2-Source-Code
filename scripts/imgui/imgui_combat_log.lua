-- chunkname: @scripts/imgui/imgui_combat_log.lua

ImguiCombatLog = class(ImguiCombatLog)

local var_0_0 = false
local var_0_1 = 800
local var_0_2 = 500

local function var_0_3(arg_1_0)
	local var_1_0 = arg_1_0 % 60
	local var_1_1 = math.floor(arg_1_0)

	return os.date("%H:%M", var_1_1) .. string.format(":%06.3f", var_1_0)
end

ImguiCombatLog.init = function (arg_2_0)
	arg_2_0._log = {}
	arg_2_0._max_lines = 1000
	arg_2_0._start_time = os.time() - os.clock()
	arg_2_0.categories = {
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
	arg_2_0._type_ids = {}
	arg_2_0._settings = {
		auto_start_recording = true,
		show_timestamp = true,
		show_type = true
	}
	arg_2_0._first_run = true

	arg_2_0:_make_log_type_lookup()
	arg_2_0:register_events()
	arg_2_0:_load_settings()
end

ImguiCombatLog.register_events = function (arg_3_0)
	local var_3_0 = Managers.state.event

	if var_3_0 then
		var_3_0:register(arg_3_0, "combat_log_damage", "log_damage")
		var_3_0:register(arg_3_0, "combat_log_heal", "log_heal")
		var_3_0:register(arg_3_0, "combat_log_action", "log_action")
		var_3_0:register(arg_3_0, "combat_log_proc", "log_proc")
		var_3_0:register(arg_3_0, "combat_log_buff", "log_buff")
	end
end

ImguiCombatLog.unregister_events = function (arg_4_0)
	local var_4_0 = Managers.state.event

	if var_4_0 then
		var_4_0:unregister("combat_log_damage", arg_4_0)
		var_4_0:unregister("combat_log_heal", arg_4_0)
		var_4_0:unregister("combat_log_action", arg_4_0)
		var_4_0:unregister("combat_log_proc", arg_4_0)
		var_4_0:unregister("combat_log_buff", arg_4_0)
	end
end

ImguiCombatLog.on_round_start = function (arg_5_0)
	if arg_5_0._settings.auto_start_recording then
		arg_5_0:register_events()
	end

	arg_5_0:_save_settings()
end

ImguiCombatLog.on_round_end = function (arg_6_0)
	arg_6_0:unregister_events()
	arg_6_0:_save_settings()
end

ImguiCombatLog.destroy = function (arg_7_0)
	arg_7_0:unregister_events()
	arg_7_0:_save_settings()
end

ImguiCombatLog.update = function (arg_8_0)
	if var_0_0 then
		arg_8_0:unregister_events()
		arg_8_0:init()

		var_0_0 = false
	end
end

ImguiCombatLog.is_persistent = function (arg_9_0)
	return true
end

ImguiCombatLog.draw = function (arg_10_0, arg_10_1)
	if arg_10_0._first_run then
		Imgui.set_next_window_size(var_0_1, var_0_2)

		arg_10_0._first_run = false
	end

	local var_10_0 = Imgui.begin_window("Combat Log")

	arg_10_0._settings.show_timestamp = Imgui.checkbox("Timestamp", arg_10_0._settings.show_timestamp)

	Imgui.same_line()

	arg_10_0._settings.show_type = Imgui.checkbox("Type", arg_10_0._settings.show_type)

	Imgui.same_line()

	arg_10_0._settings.auto_start_recording = Imgui.checkbox("Auto Start Recording", arg_10_0._settings.auto_start_recording)

	local var_10_1 = arg_10_0.categories

	for iter_10_0 = 1, #var_10_1 do
		if iter_10_0 > 1 then
			Imgui.same_line()
		end

		local var_10_2 = var_10_1[iter_10_0]

		var_10_2.enabled = Imgui.checkbox(var_10_2.name, var_10_2.enabled)
	end

	if Imgui.button("Start", 100, 20) then
		arg_10_0:register_events()
	end

	Imgui.same_line()

	if Imgui.button("Stop", 100, 20) then
		arg_10_0:unregister_events()
	end

	Imgui.same_line()

	if Imgui.button("Copy Visible", 100, 20) then
		arg_10_0:copy_to_clipboard(false)
	end

	Imgui.same_line()

	if Imgui.button("Copy All", 100, 20) then
		arg_10_0:copy_to_clipboard(true)
	end

	Imgui.same_line()

	if Imgui.button("Clear", 40, 20) then
		arg_10_0:clear()
	end

	local var_10_3 = arg_10_0._settings.show_timestamp
	local var_10_4 = arg_10_0._settings.show_type
	local var_10_5, var_10_6 = Imgui.get_window_size()

	Imgui.begin_child_window("Log:", var_10_5 - 15, var_10_6 - 105, false, "no_title_bar", "always_auto_resize", "horizontal_scrollbar")

	for iter_10_1 = 1, #arg_10_0._log do
		local var_10_7 = arg_10_0._log[iter_10_1]

		if var_10_1[var_10_7.type_id].enabled then
			local var_10_8 = var_10_7.content

			if var_10_3 then
				Imgui.text(var_10_7.timestamp)
				Imgui.same_line()
			end

			if var_10_4 then
				Imgui.text(var_10_7.type_name)
				Imgui.same_line()
			end

			local var_10_9 = #var_10_8

			for iter_10_2 = 1, var_10_9 do
				local var_10_10 = var_10_8[iter_10_2]
				local var_10_11 = var_10_10[1]
				local var_10_12 = var_10_10[2]

				Imgui.text_colored(var_10_11, var_10_12[2], var_10_12[3], var_10_12[4], var_10_12[1])

				if iter_10_2 ~= var_10_9 then
					Imgui.same_line()
				end
			end
		end
	end

	Imgui.end_child_window()
	Imgui.end_window("Combat Log")

	return var_10_0
end

ImguiCombatLog.log_damage = function (arg_11_0, arg_11_1, arg_11_2, arg_11_3, arg_11_4, arg_11_5, arg_11_6, arg_11_7, arg_11_8, arg_11_9, arg_11_10, arg_11_11, arg_11_12, arg_11_13)
	local var_11_0 = Unit.alive(arg_11_1) and Unit.get_data(arg_11_1, "breed")
	local var_11_1 = Unit.alive(arg_11_2) and Unit.get_data(arg_11_2, "breed")
	local var_11_2 = Managers.state.network
	local var_11_3 = var_11_2 and var_11_2:unit_game_object_id(arg_11_2)
	local var_11_4 = arg_11_0:_add_line("damage")

	arg_11_0:_add_colored_segment(var_11_4, string.format("%s -> %s (%d) (%.2f %s), Power(%.2f), hit (%s) using (%s) Crit: %s, Backstab Mult: %.2f, Target Index: %d", tostring(var_11_0 and var_11_0.name or arg_11_1), tostring(var_11_1 and var_11_1.name or arg_11_2), var_11_3 or 0, arg_11_3 or 0, tostring(arg_11_5), arg_11_13 or 0, tostring(arg_11_4), tostring(arg_11_6), tostring(arg_11_7), arg_11_8 or 1, arg_11_10 or 0), Colors.get_table("orange"))
end

ImguiCombatLog.log_heal = function (arg_12_0, arg_12_1, arg_12_2, arg_12_3, arg_12_4)
	local var_12_0 = Unit.alive(arg_12_1) and Unit.get_data(arg_12_1, "breed")
	local var_12_1 = Unit.alive(arg_12_2) and Unit.get_data(arg_12_2, "breed")
	local var_12_2 = arg_12_0:_add_line("heal")

	arg_12_0:_add_colored_segment(var_12_2, string.format("%s -> %s (%.2f %s)", tostring(var_12_0 and var_12_0.name or arg_12_1), tostring(var_12_1 and var_12_1.name or arg_12_2), arg_12_3 or 0, tostring(arg_12_4)), Colors.get_table("lime"))
end

ImguiCombatLog.log_action = function (arg_13_0, arg_13_1, arg_13_2, arg_13_3, arg_13_4, arg_13_5, arg_13_6, arg_13_7, arg_13_8)
	local var_13_0 = Unit.alive(arg_13_1) and Unit.get_data(arg_13_1, "breed")
	local var_13_1 = arg_13_0:_add_line("action")

	if arg_13_7 then
		arg_13_0:_add_colored_segment(var_13_1, string.format("[Start] %s (%s - power %.2f) - %s/%s/%s", tostring(var_13_0 and var_13_0.name or arg_13_1), tostring(arg_13_3), arg_13_6 or 0, tostring(arg_13_2), tostring(arg_13_4), tostring(arg_13_5)), Colors.get_table("white"))
	else
		arg_13_0:_add_colored_segment(var_13_1, string.format("[End] %s (%s - power %.2f), Reason: %s - %s/%s/%s ", tostring(var_13_0 and var_13_0.name or arg_13_1), tostring(arg_13_3), arg_13_6 or 0, tostring(arg_13_8), tostring(arg_13_2), tostring(arg_13_4), tostring(arg_13_5)), Colors.get_table("white"))
	end
end

ImguiCombatLog.log_proc = function (arg_14_0, arg_14_1, arg_14_2, arg_14_3, arg_14_4, arg_14_5)
	local var_14_0 = arg_14_1 and arg_14_1.player_unit
	local var_14_1 = Unit.alive(var_14_0) and Unit.get_data(var_14_0, "breed")
	local var_14_2 = arg_14_0:_add_line("buff_proc")

	arg_14_0:_add_colored_segment(var_14_2, string.format("%s (%s) -> %s", tostring(var_14_1 and var_14_1.name or var_14_0), arg_14_2 or "-", tostring(arg_14_3.buff_type)), Colors.get_table("silver"))
end

ImguiCombatLog.log_buff = function (arg_15_0, arg_15_1, arg_15_2, arg_15_3, arg_15_4, arg_15_5)
	local var_15_0 = Unit.alive(arg_15_1) and Unit.get_data(arg_15_1, "breed")
	local var_15_1 = arg_15_2 and arg_15_2.attacker_unit
	local var_15_2 = Unit.alive(var_15_1) and Unit.get_data(var_15_1, "breed")
	local var_15_3 = arg_15_0:_add_line("buff")

	if arg_15_3 then
		arg_15_0:_add_colored_segment(var_15_3, string.format("[Added] %s -> %s (mult: %.2f)", tostring(var_15_0 and var_15_0.name or arg_15_1), tostring(arg_15_2.buff_type), type(arg_15_2.multiplier) == "function" and arg_15_2.multiplier(arg_15_1, ScriptUnit.extension(arg_15_1, "buff_system")) or arg_15_2.multiplier or 1), Colors.get_table("lime"))

		if arg_15_4 and arg_15_5 then
			arg_15_0:_add_colored_segment(var_15_3, string.format("(stacks: %d/%d)", arg_15_4, arg_15_5), Colors.get_table("lime"))
		end

		if var_15_1 then
			arg_15_0:_add_colored_segment(var_15_3, string.format("(%s)", tostring(var_15_2 and var_15_2.name or var_15_1)), Colors.get_table("lime"))
		end
	else
		arg_15_0:_add_colored_segment(var_15_3, string.format("[Removed] %s -> %s", tostring(var_15_0 and var_15_0.name or arg_15_1), tostring(arg_15_2.buff_type)), Colors.get_table("yellow"))

		if var_15_1 then
			arg_15_0:_add_colored_segment(var_15_3, string.format("(%s)", tostring(var_15_2 and var_15_2.name or var_15_1)), Colors.get_table("yellow"))
		end
	end
end

ImguiCombatLog._make_log_type_lookup = function (arg_16_0)
	local var_16_0 = arg_16_0.categories

	for iter_16_0 = 1, #var_16_0 do
		arg_16_0._type_ids[var_16_0[iter_16_0].type] = iter_16_0
	end
end

ImguiCombatLog._get_type_name = function (arg_17_0, arg_17_1)
	if arg_17_1 then
		local var_17_0 = arg_17_0._type_ids[arg_17_1]
		local var_17_1 = arg_17_0.categories[var_17_0]

		return var_17_1 and var_17_1.name or tostring(arg_17_1)
	end

	return tostring("Unknown")
end

ImguiCombatLog._add_line = function (arg_18_0, arg_18_1)
	local var_18_0 = {
		timestamp = "[" .. var_0_3(arg_18_0._start_time + os.clock()) .. "]",
		content = {},
		type_id = arg_18_0._type_ids[arg_18_1] or 0,
		type_name = "[" .. arg_18_0:_get_type_name(arg_18_1) .. "]"
	}

	table.insert(arg_18_0._log, 1, var_18_0)

	local var_18_1 = #arg_18_0._log

	if var_18_1 > arg_18_0._max_lines then
		table.remove(arg_18_0._log, var_18_1)
	end

	return var_18_0
end

ImguiCombatLog._add_colored_segment = function (arg_19_0, arg_19_1, arg_19_2, arg_19_3)
	local var_19_0 = arg_19_2 or ""
	local var_19_1 = arg_19_3 or Colors.get_table("white")

	table.insert(arg_19_1.content, {
		var_19_0,
		var_19_1
	})
end

ImguiCombatLog.clear = function (arg_20_0)
	arg_20_0._log = {}
end

ImguiCombatLog.copy_to_clipboard = function (arg_21_0, arg_21_1)
	local var_21_0 = ""
	local var_21_1 = arg_21_0.categories
	local var_21_2 = arg_21_0._settings.show_type

	for iter_21_0 = 1, #arg_21_0._log do
		local var_21_3 = arg_21_0._log[iter_21_0]

		if arg_21_1 or var_21_1[var_21_3.type_id].enabled then
			local var_21_4 = var_21_3.content

			if arg_21_1 or arg_21_0._show_timestamp then
				var_21_0 = var_21_0 .. var_21_3.timestamp
			end

			if arg_21_1 or var_21_2 then
				var_21_0 = var_21_0 .. " " .. var_21_3.type_name
			end

			for iter_21_1 = 1, #var_21_4 do
				local var_21_5 = var_21_4[iter_21_1][1]

				var_21_0 = var_21_0 .. " " .. var_21_5
			end

			var_21_0 = var_21_0 .. "\n"
		end
	end

	Clipboard.put(var_21_0)
end

ImguiCombatLog._save_settings = function (arg_22_0)
	local var_22_0 = arg_22_0.categories
	local var_22_1 = {
		categories = {},
		settings = arg_22_0._settings
	}

	for iter_22_0 = 1, #var_22_0 do
		local var_22_2 = var_22_0[iter_22_0].type

		var_22_1.categories[var_22_2] = var_22_0[iter_22_0].enabled
	end

	Development.set_setting("ImguiCombatLog_settings", var_22_1)
	Application.save_user_settings()
end

ImguiCombatLog._load_settings = function (arg_23_0)
	local var_23_0 = Development.setting("ImguiCombatLog_settings")

	if var_23_0 then
		local var_23_1 = var_23_0.categories

		if var_23_1 then
			local var_23_2 = arg_23_0.categories

			for iter_23_0 = 1, #var_23_2 do
				local var_23_3 = var_23_1[var_23_2[iter_23_0].type]

				if var_23_3 ~= nil then
					var_23_2[iter_23_0].enabled = var_23_3
				end
			end
		end

		local var_23_4 = var_23_0.settings

		if var_23_4 then
			table.merge(arg_23_0._settings, var_23_4)
		end
	end
end
