-- chunkname: @scripts/utils/debug_screen.lua

local var_0_0 = "arial"
local var_0_1 = "materials/fonts/" .. var_0_0
local var_0_2 = 10
local var_0_3 = UILayer.debug_screen

local function var_0_4(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
	arg_1_0 = arg_1_0 / arg_1_3

	return -arg_1_2 * arg_1_0 * (arg_1_0 - 2) + arg_1_1
end

local var_0_5 = 0

local function var_0_6(arg_2_0, arg_2_1, arg_2_2, arg_2_3)
	if arg_2_0.propagate_to_server and not DebugScreen._is_server and not arg_2_3 then
		DebugScreen._propagate_option(arg_2_0.setting_id, arg_2_1, not not arg_2_2)
	end

	local var_2_0 = arg_2_0.options[arg_2_1]

	arg_2_0.selected_id = arg_2_1

	if var_2_0 == "[clear value]" then
		var_2_0 = nil
		arg_2_0.selected_id = nil
	end

	if arg_2_0.copy then
		arg_2_0.copy.selected_id = arg_2_0.selected_id
	end

	if arg_2_0.commands then
		local var_2_1 = arg_2_0.commands[arg_2_0.hot_id]

		if var_2_1 then
			for iter_2_0 = 1, #var_2_1 do
				local var_2_2 = var_2_1[iter_2_0]

				Application.console_command(unpack(var_2_2))
			end
		end
	end

	Development.set_setting(arg_2_0.title, var_2_0)

	script_data[arg_2_0.title] = var_2_0

	Development.clear_param_cache(arg_2_0.title)

	if arg_2_0.callback then
		arg_2_0.callback(var_2_0)
	end

	if not arg_2_2 and not arg_2_0.never_save then
		printf("DebugScreen: script_data.%-35s = %s", arg_2_0.title, tostring(arg_2_0.options[arg_2_1]))
		Application.save_user_settings()
	end

	Profiler.event("%s = %s", arg_2_0.title, tostring(arg_2_0.options[arg_2_1]))
end

local function var_0_7(arg_3_0)
	if arg_3_0.propagate_to_server and not DebugScreen._is_server then
		DebugScreen._propagate_option(arg_3_0.setting_id, 0, true)
	end

	arg_3_0.func(arg_3_0.options, arg_3_0.hot_id)

	if arg_3_0.clear_setting then
		arg_3_0.selected_id = nil

		Development.set_setting(arg_3_0.title, nil)

		script_data[arg_3_0.title] = nil

		Development.clear_param_cache(arg_3_0.title)
	end
end

local function var_0_8(arg_4_0)
	for iter_4_0, iter_4_1 in pairs(arg_4_0.preset) do
		for iter_4_2 = 1, #DebugScreen.console_settings do
			local var_4_0 = DebugScreen.console_settings[iter_4_2]

			if var_4_0.title == iter_4_0 and var_4_0.is_boolean then
				var_0_6(var_4_0, iter_4_1 and 1 or 2)
			end
		end
	end

	arg_4_0.selected_id = nil

	Development.set_setting(arg_4_0.title, nil)

	script_data[arg_4_0.title] = nil

	Development.clear_param_cache(arg_4_0.title)
end

DebugScreen = DebugScreen or {}

local var_0_9 = DebugScreen

var_0_9.console_width = var_0_9.console_width or 800 * (RESOLUTION_LOOKUP.scale or 1)
var_0_9.font_size = var_0_9.font_size or 20 * (RESOLUTION_LOOKUP.scale or 1)
var_0_9.numpad_presses = {}
var_0_9.shortcut_any = "_any_"
var_0_9.shortcut_version = 1

local function var_0_10(arg_5_0, arg_5_1)
	if arg_5_1 == 0 then
		for iter_5_0 = 1, #arg_5_0 / 2 do
			table.insert(arg_5_0, iter_5_0 * 3, var_0_9.shortcut_any)
		end
	end

	return arg_5_0
end

function var_0_9.setup(arg_6_0, arg_6_1, arg_6_2, arg_6_3)
	local var_6_0 = var_0_9

	var_6_0.world = arg_6_0
	var_6_0.gui = World.create_screen_gui(arg_6_0, "material", "materials/fonts/gw_fonts", "material", "materials/menu/debug_screen", "immediate")
	var_6_0.active = false
	var_6_0._is_server = arg_6_3

	local var_6_1 = script_data

	var_6_0.console_settings = {}

	for iter_6_0 = 1, #arg_6_1 do
		local var_6_2 = {
			hot_id = 1,
			options = {}
		}
		local var_6_3 = arg_6_1[iter_6_0]

		if var_6_3.item_source then
			local var_6_4 = var_6_3.item_source

			if var_6_3.custom_item_source_order then
				var_6_3.custom_item_source_order(var_6_4, var_6_2.options)
			else
				for iter_6_1, iter_6_2 in pairs(var_6_4) do
					local var_6_5 = iter_6_1

					var_6_2.options[#var_6_2.options + 1] = var_6_5
				end
			end

			if var_6_3.func then
				var_6_2.func = var_6_3.func
				var_6_2.clear_setting = false
			end

			var_6_2.load_items_source_func = var_6_3.load_items_source_func
		elseif var_6_3.is_boolean then
			var_6_2.is_boolean = true
			var_6_2.options[#var_6_2.options + 1] = true
			var_6_2.options[#var_6_2.options + 1] = false

			if var_6_3.func then
				var_6_2.func = var_6_3.func
			end
		elseif var_6_3.command_list then
			var_6_2.commands = {}

			for iter_6_3 = 1, #var_6_3.command_list do
				local var_6_6 = var_6_3.command_list[iter_6_3]

				var_6_2.options[#var_6_2.options + 1] = var_6_6.description
				var_6_2.commands[#var_6_2.commands + 1] = var_6_6.commands
			end
		elseif var_6_3.func then
			var_6_2.options[1] = "Activate function"
			var_6_2.func = var_6_3.func
		elseif var_6_3.preset then
			var_6_2.options[1] = "Activate preset"
			var_6_2.preset = var_6_3.preset
		end

		var_6_2.propagate_to_server = var_6_3.propagate_to_server
		var_6_2.never_save = var_6_3.never_save
		var_6_2.item_display_func = var_6_3.item_display_func

		if var_6_3.bitmap then
			var_6_2.bitmap = var_6_3.bitmap
			var_6_2.bitmap_size = var_6_3.bitmap_size
		end

		if var_6_3.callback then
			var_6_2.callback = arg_6_2[var_6_3.callback]
		end

		var_6_2.title = var_6_3.setting_name
		var_6_2.description = var_6_3.description
		var_6_2.category = var_6_3.category
		var_6_2.close_when_selected = var_6_3.close_when_selected
		var_6_2.clear_when_selected = var_6_3.clear_when_selected
		var_6_2.setting_id = iter_6_0

		for iter_6_4 = 1, #var_6_2.options do
			local var_6_7 = var_6_2.options[iter_6_4]

			if Development.parameter(var_6_2.title) == var_6_7 then
				var_6_2.selected_id = iter_6_4
				var_6_2.hot_id = iter_6_4

				var_0_6(var_6_2, iter_6_4, true, true)
			end
		end

		if #var_6_2.options > 0 and not var_6_3.no_nil and not var_6_3.func and not var_6_3.preset then
			var_6_2.options[#var_6_2.options + 1] = "[clear value]"
		end

		var_6_0.console_settings[#var_6_0.console_settings + 1] = var_6_2
	end

	var_6_0.settings_hash = HashUtils.fnv32_hash(table.concat(table.select_array(arg_6_1, function(arg_7_0, arg_7_1)
		return arg_7_1.setting_name or arg_7_0
	end), ","))

	for iter_6_5 = 1, #var_6_0.console_settings do
		local var_6_8 = var_6_0.console_settings[iter_6_5]

		if var_6_8.preset and Development.parameter(var_6_8.title) then
			var_0_8(var_6_8)
		end
	end

	var_6_0.shortcut_list = {}
	var_6_0.shortcuts = Development.setting("debug_shortcuts") or {
		"numpad 0",
		"debug_weapons"
	}

	local var_6_9 = tonumber(var_6_0.shortcuts[1]) or 0

	var_0_10(var_6_0.shortcuts, var_6_9)

	for iter_6_6 = 1, #var_6_0.shortcuts, 3 do
		local var_6_10 = var_6_0.shortcuts[iter_6_6]
		local var_6_11 = var_6_0.shortcuts[iter_6_6 + 1]
		local var_6_12 = var_6_0.shortcuts[iter_6_6 + 2]

		for iter_6_7 = 1, #var_6_0.console_settings do
			local var_6_13 = var_6_0.console_settings[iter_6_7]

			if var_6_13.title == var_6_11 then
				var_6_0.shortcut_list[var_6_10] = {
					cs = var_6_13,
					option = var_6_12
				}

				break
			end
		end
	end

	var_6_0.favorites = Development.setting("debug_favorites") or {}

	for iter_6_8 = 1, #var_6_0.favorites do
		local var_6_14 = var_6_0.favorites[iter_6_8]

		for iter_6_9 = 1, #var_6_0.console_settings do
			local var_6_15 = var_6_0.console_settings[iter_6_9]

			if var_6_15.title == var_6_14 then
				local var_6_16 = table.clone(var_6_15)

				var_6_16.category = "Favorites"
				var_6_15.copy = var_6_16
				var_6_16.copy = var_6_15

				table.insert(var_6_0.console_settings, 1, var_6_16)

				break
			end
		end
	end

	if not var_6_1.debug_enabled then
		var_6_1.disable_debug_draw = true
	end

	var_6_0.active_id = nil
	var_6_0.hot_id = 1
	var_6_0.fade_timer = 0
	var_6_0.closing = false
	var_6_0.target_y_offset = 0
	var_6_0.text_effects = {}
	var_6_0.hold_to_move_timer = 0
	var_6_0.is_holding = false
	var_6_0.active_shortcut_data = {
		time = 0
	}
	var_6_0.unblocked_services = {}
	var_6_0.unblocked_services_n = 0
	var_6_0.search_active = false
	var_6_0.search_string = ""
	var_6_0.filtered_console_settings = var_6_0.console_settings
	var_6_0.allow_to_open = true
end

function var_0_9.destroy()
	World.destroy_gui(var_0_9.world, var_0_9.gui)

	var_0_9.world = nil
	var_0_9.gui = nil
end

function var_0_9.set_blocked(arg_9_0)
	var_0_9.is_blocked = arg_9_0
end

function var_0_9.reset_setting_size(arg_10_0, arg_10_1, arg_10_2)
	arg_10_0.setting_height = 0
	arg_10_0.setting_pos = math.abs(arg_10_1 - arg_10_2)
	arg_10_0.option_pos = nil
end

function var_0_9.push_setting_size(arg_11_0, arg_11_1, arg_11_2)
	arg_11_1 = arg_11_1 - arg_11_2
	arg_11_0.setting_height = arg_11_0.setting_height + arg_11_2

	return arg_11_1
end

var_0_9.accelerate_factor = var_0_9.accelerate_factor or 1

function var_0_9.update(arg_12_0, arg_12_1, arg_12_2, arg_12_3)
	local var_12_0 = var_0_9

	if var_12_0.is_blocked or not script_data.debug_enabled or not arg_12_2 or IS_LINUX then
		return
	end

	local var_12_1 = var_12_0.gui

	arg_12_0 = arg_12_0 / GLOBAL_TIME_SCALE

	local var_12_2 = false
	local var_12_3 = var_12_0.font_size
	local var_12_4 = var_12_0.console_width
	local var_12_5 = arg_12_2:get("console_mod_key")

	if arg_12_2:get("console_open_key") or var_12_0.active and arg_12_2:is_blocked() then
		var_12_0.active = not var_12_0.active

		if var_12_0.active then
			arg_12_3:device_block_service("keyboard", 1, "Debug")
		else
			arg_12_3:device_unblock_service("keyboard", 1, "Debug")
		end
	end

	if arg_12_2:get("right_key") and not var_12_0.active then
		var_12_0.active = not var_12_0.active

		arg_12_3:device_block_service("keyboard", 1, "Debug", "debug_screen")

		var_12_2 = true
	end

	if not var_12_0.active and var_12_0.fade_timer == 0 then
		for iter_12_0, iter_12_1 in pairs(var_12_0.shortcut_list) do
			if Keyboard.pressed(Keyboard.button_index(iter_12_0)) then
				local var_12_6 = iter_12_1.cs
				local var_12_7 = iter_12_1.option

				if var_12_7 == var_12_0.shortcut_any then
					if var_12_6.hot_id == #var_12_6.options then
						var_12_6.hot_id = 1
					else
						var_12_6.hot_id = var_12_6.hot_id + 1
					end
				else
					local var_12_8 = table.find(var_12_6.options, var_12_7)

					var_12_6.hot_id = math.clamp(var_12_8 or -1, 1, #var_12_6.options)
				end

				if var_12_6.func then
					var_0_7(var_12_6)
				else
					var_0_6(var_12_6, var_12_6.hot_id)
				end

				var_12_0.active_shortcut_data.time = arg_12_1 + 1
				var_12_0.active_shortcut_data.cs = var_12_6
			end
		end

		if arg_12_1 < var_12_0.active_shortcut_data.time then
			local var_12_9 = var_12_0.active_shortcut_data.cs

			Debug.text("Debug Screen: %s = %s", var_12_9.title, tostring(var_12_9.options[var_12_9.hot_id]))
		end

		return
	end

	var_12_0.update_search(arg_12_3, arg_12_2, var_12_1, arg_12_1, arg_12_0, var_12_2)

	if var_12_0.active then
		var_12_0.fade_timer = math.min(1, var_12_0.fade_timer + arg_12_0 * var_0_2)
	else
		var_12_0.fade_timer = math.max(0, var_12_0.fade_timer - arg_12_0 * var_0_2)
	end

	local var_12_10 = var_12_0.console_settings
	local var_12_11 = var_12_0.filtered_console_settings[var_12_0.hot_id]
	local var_12_12, var_12_13 = var_12_0.search_string:match("([^.]*).?(.*)")

	if var_12_0.search_active then
		if var_12_12 == "*" then
			var_12_10 = {}

			for iter_12_2 = 1, #var_12_0.console_settings do
				local var_12_14 = var_12_0.console_settings[iter_12_2]

				if var_12_14.selected_id ~= nil then
					var_12_10[#var_12_10 + 1] = var_12_14
				end
			end
		elseif var_12_12 ~= "" then
			var_12_10 = {}

			local var_12_15 = string.gsub(var_12_12, "[_ ]", "")

			for iter_12_3 = 1, #var_12_0.console_settings do
				local var_12_16 = var_12_0.console_settings[iter_12_3]
				local var_12_17 = var_12_16.title:lower()

				if string.gsub(var_12_17, "[_ ]", ""):find(var_12_15, 1, true) ~= nil then
					var_12_10[#var_12_10 + 1] = var_12_16
				end
			end
		end
	end

	if var_12_11 ~= var_12_10[var_12_0.hot_id] then
		var_12_0.hot_id = var_12_0.hot_id or 1
		var_12_0.active_id = nil

		for iter_12_4 = 0, #var_12_10 * 0.5 do
			if var_12_10[var_12_0.hot_id + iter_12_4] then
				var_12_0.hot_id = var_12_0.hot_id + iter_12_4

				break
			elseif var_12_10[var_12_0.hot_id - iter_12_4] then
				var_12_0.hot_id = var_12_0.hot_id - iter_12_4

				break
			end
		end
	end

	var_12_0.filtered_console_settings = var_12_10

	local var_12_18 = {}

	if var_12_0.active_id ~= nil then
		if var_12_0.search_active and var_12_13 ~= "" then
			local var_12_19 = var_12_10[var_12_0.hot_id]
			local var_12_20 = string.gsub(var_12_13, "[_ ]", "")

			for iter_12_5 = 1, #var_12_19.options do
				local var_12_21 = var_12_19.options[iter_12_5]
				local var_12_22 = tostring(var_12_21):lower()

				if string.gsub(var_12_22, "[_ ]", ""):find(var_12_20, 1, true) ~= nil then
					var_12_18[#var_12_18 + 1] = iter_12_5
				end
			end

			if not table.contains(var_12_18, var_12_19.hot_id) and #var_12_18 > 0 then
				var_12_19.hot_id = var_12_18[1]
			end
		else
			local var_12_23 = var_12_10[var_12_0.hot_id]

			for iter_12_6 = 1, #var_12_23.options do
				var_12_18[iter_12_6] = iter_12_6
			end
		end
	end

	if arg_12_2:get("up_key") and arg_12_1 > var_12_0.hold_to_move_timer then
		if var_12_0.is_holding then
			local var_12_24 = var_12_0.accelerate_factor

			var_12_0.hold_to_move_timer = arg_12_1 + 0.1 * GLOBAL_TIME_SCALE * var_12_24
			var_12_0.accelerate_factor = var_12_24 * 0.95
		else
			var_12_0.hold_to_move_timer = arg_12_1 + 0.1 * GLOBAL_TIME_SCALE
			var_12_0.is_holding = true
			var_12_0.accelerate_factor = 1
		end

		if var_12_0.active_id == nil then
			if var_12_0.hot_id == 1 then
				var_12_0.hot_id = #var_12_10
			elseif var_12_5 then
				local var_12_25 = var_12_0.hot_id
				local var_12_26 = var_12_10[var_12_25]
				local var_12_27 = not var_12_26.is_boolean and var_12_26.selected_id ~= nil or var_12_26.options[var_12_26.selected_id]

				while var_12_25 > 1 do
					var_12_25 = var_12_25 - 1

					local var_12_28 = var_12_10[var_12_25]
					local var_12_29 = not var_12_28.is_boolean and var_12_28.selected_id ~= nil or var_12_28.options[var_12_28.selected_id]

					if var_12_29 and not var_12_27 then
						break
					elseif not var_12_29 then
						var_12_27 = false
					end

					if var_12_28.category ~= var_12_10[math.max(1, var_12_25 - 1)].category then
						break
					end
				end

				var_12_0.hot_id = var_12_25
			else
				var_12_0.hot_id = var_12_0.hot_id - 1
			end
		else
			local var_12_30 = var_12_10[var_12_0.active_id]
			local var_12_31 = #var_12_18
			local var_12_32 = table.find(var_12_18, var_12_30.hot_id)

			if var_12_32 then
				var_12_30.hot_id = var_12_18[(var_12_32 + var_12_31 - 2) % var_12_31 + 1]
			end
		end
	end

	if arg_12_2:get("down_key") and arg_12_1 > var_12_0.hold_to_move_timer then
		if var_12_0.is_holding then
			local var_12_33 = var_12_0.accelerate_factor

			var_12_0.hold_to_move_timer = arg_12_1 + 0.1 * GLOBAL_TIME_SCALE * var_12_33
			var_12_0.accelerate_factor = var_12_33 * 0.95
		else
			var_12_0.hold_to_move_timer = arg_12_1 + 0.1 * GLOBAL_TIME_SCALE
			var_12_0.is_holding = true
			var_12_0.accelerate_factor = 1
		end

		if var_12_0.active_id == nil then
			if var_12_0.hot_id == #var_12_10 then
				var_12_0.hot_id = 1
			elseif var_12_5 then
				local var_12_34 = var_12_0.hot_id
				local var_12_35 = var_12_10[var_12_34]
				local var_12_36 = not var_12_35.is_boolean and var_12_35.selected_id ~= nil or var_12_35.options[var_12_35.selected_id]

				while var_12_34 < #var_12_10 do
					var_12_34 = var_12_34 + 1

					local var_12_37 = var_12_10[var_12_34]
					local var_12_38 = not var_12_37.is_boolean and var_12_37.selected_id ~= nil or var_12_37.options[var_12_37.selected_id]

					if var_12_38 and not var_12_36 then
						break
					elseif not var_12_38 then
						var_12_36 = false
					end

					if var_12_37.category ~= var_12_10[math.max(1, var_12_34 - 1)].category then
						break
					end
				end

				var_12_0.hot_id = var_12_34
			else
				var_12_0.hot_id = var_12_0.hot_id + 1
			end
		else
			local var_12_39 = var_12_10[var_12_0.active_id]
			local var_12_40 = #var_12_18
			local var_12_41 = table.find(var_12_18, var_12_39.hot_id)

			if var_12_41 then
				var_12_39.hot_id = var_12_18[var_12_41 % var_12_40 + 1]
			end
		end
	end

	if arg_12_2:get("page up") then
		if var_12_0.active_id then
			var_12_10[var_12_0.active_id].hot_id = 1
		else
			var_12_0.hot_id = 1
		end
	elseif arg_12_2:get("page down") then
		if var_12_0.active_id then
			var_12_10[var_12_0.active_id].hot_id = #var_12_18
		else
			var_12_0.hot_id = #var_12_10
		end
	end

	if not arg_12_2:get("down_key") and not arg_12_2:get("up_key") then
		var_12_0.is_holding = false
	end

	var_12_0.hot_id = math.clamp(var_12_0.hot_id, math.min(1, #var_12_10), #var_12_10)

	local var_12_42 = var_0_4(var_12_0.fade_timer, 0, 1, 1)
	local var_12_43 = var_12_42 * var_12_4
	local var_12_44 = RESOLUTION_LOOKUP.res_w
	local var_12_45 = RESOLUTION_LOOKUP.res_h
	local var_12_46 = var_12_45 - 100

	if var_12_0.active_id ~= nil and not var_12_10[var_12_0.active_id] then
		var_12_0.active_id = nil
	end

	local var_12_47 = 200
	local var_12_48 = 0
	local var_12_49 = 0

	if not table.is_empty(var_12_10) then
		local var_12_50 = var_12_10[#var_12_10]

		var_12_48 = (var_12_50.setting_pos or 0) + (var_12_50.setting_height or 0)

		local var_12_51 = var_12_45 * 0.25
		local var_12_52 = var_12_48 - var_12_45 * 0.25
		local var_12_53 = var_12_10[var_12_0.hot_id]

		if var_12_53 then
			local var_12_54 = var_12_53.option_pos or var_12_53.setting_pos or 0

			if var_12_51 ~= var_12_52 then
				var_12_49 = math.remap_clamped(var_12_51, var_12_52, 0, 1, var_12_54)
			end
		end
	end

	local var_12_55 = var_12_48 + var_12_47
	local var_12_56 = math.max(0, var_12_55 - var_12_45) * var_12_49

	var_12_0.target_y_offset = math.lerp(var_12_0.target_y_offset, var_12_56, 0.1)

	local var_12_57 = var_12_46 + var_12_0.target_y_offset
	local var_12_58 = var_12_57

	var_0_5 = var_0_5 + arg_12_0 * 10

	if var_0_5 > 10 then
		var_0_5 = 0
	end

	local var_12_59 = var_0_5

	if var_12_59 > 5 then
		var_12_59 = 10 - var_12_59
	end

	local var_12_60 = (var_12_55 == var_12_47 or var_12_55 < var_12_45) and 0 or var_12_45 * var_12_45 / (var_12_55 - var_12_47)
	local var_12_61 = var_12_45 * math.remap(0, 1, 0, 1 - var_12_60 / var_12_45, var_12_49)
	local var_12_62 = var_0_3 + 1

	Gui.rect(var_12_1, Vector3(0, 0, var_0_3), Vector2(var_12_43, var_12_45), Color(var_12_42 * 220, 25, 50, 25))
	Gui.rect(var_12_1, Vector3(0, var_12_45 - var_12_61 - var_12_60, var_12_62), Vector2(3, var_12_60), Color(var_12_42 * 150, 200, 200, 25))

	local var_12_63 = (math.sin(arg_12_1 / GLOBAL_TIME_SCALE * 10) + 1) * 0.5
	local var_12_64 = Color(var_12_42 * 250, 255, 255, 255)
	local var_12_65 = Color(var_12_42 * 250, 120, 120, 0)
	local var_12_66 = Color(var_12_42 * 255, 200, 200, 0)
	local var_12_67 = Color(var_12_42 * 255, 230 + 25 * var_12_63, 230 + 25 * var_12_63, 200 * var_12_63)
	local var_12_68 = Color(var_12_42 * 255, 100, 255, 100)
	local var_12_69 = Color(var_12_42 * 255, 50, 150, 50)
	local var_12_70 = Color(var_12_42 * 255, 100, 255, 100)
	local var_12_71 = Color(var_12_42 * 255, 200, 255, 200)
	local var_12_72 = Color(var_12_42 * 255, 150, 150, 150)
	local var_12_73 = Color(var_12_42 * 150, 100, 100, 50)
	local var_12_74 = 30
	local var_12_75 = 50
	local var_12_76
	local var_12_77 = var_0_3 + 2
	local var_12_78 = var_0_3 + 2
	local var_12_79 = var_0_3 + 1
	local var_12_80 = var_0_3 + 1

	for iter_12_7 = 1, #var_12_10 do
		local var_12_81 = iter_12_7 == var_12_0.active_id
		local var_12_82 = iter_12_7 == var_12_0.hot_id
		local var_12_83 = var_12_10[iter_12_7]

		var_12_0.reset_setting_size(var_12_83, var_12_57, var_12_58)

		local var_12_84 = var_12_83.title

		if var_12_83.category ~= var_12_76 then
			var_12_57 = var_12_57 - var_12_3 * 0.4
			var_12_76 = var_12_83.category

			Gui.text(var_12_1, var_12_83.category, var_0_1, var_12_3, var_0_0, Vector3(10, var_12_57, var_12_77), var_12_64)

			var_12_57 = var_12_57 - var_12_3
		end

		local var_12_85 = Vector3(var_12_43 - 400, var_12_57, var_12_78)
		local var_12_86

		if var_12_83.selected_id ~= nil then
			local var_12_87 = var_12_83.options
			local var_12_88 = var_12_83.selected_id
			local var_12_89 = var_12_87[var_12_88]

			if var_12_83.item_display_func then
				var_12_86 = string.format("< %s >", var_12_83.item_display_func(var_12_89, var_12_88, var_12_87))
			else
				var_12_86 = string.format("< %s >", tostring(var_12_89))
			end

			if var_12_82 then
				Gui.text(var_12_1, var_12_86, var_0_1, var_12_3, var_0_0, var_12_85, var_12_71)
			elseif not var_12_83.is_boolean or var_12_83.options[var_12_83.selected_id] then
				Gui.text(var_12_1, var_12_86, var_0_1, var_12_3, var_0_0, var_12_85, var_12_70)
			else
				Gui.text(var_12_1, var_12_86, var_0_1, var_12_3, var_0_0, var_12_85, var_12_69)
			end
		end

		if var_12_81 then
			Gui.text(var_12_1, ">", var_0_1, var_12_3, var_0_0, Vector3(10, var_12_57, var_12_78), var_12_68)
			Gui.text(var_12_1, var_12_84, var_0_1, var_12_3, var_0_0, Vector3(var_12_74, var_12_57, var_12_78), var_12_68)

			local var_12_90

			for iter_12_8, iter_12_9 in pairs(var_12_0.shortcut_list) do
				local var_12_91 = iter_12_9.cs

				if var_12_83 == var_12_91 or var_12_83 == var_12_91.copy then
					var_12_90 = (var_12_90 and var_12_90 .. ", " or "") .. iter_12_8
				end
			end

			if var_12_90 then
				Gui.text(var_12_1, "[" .. var_12_90 .. "]", var_0_1, var_12_3, var_0_0, Vector3(var_12_43 - 100, var_12_57, var_12_78), var_12_64)
			end

			var_12_57 = var_12_0.push_setting_size(var_12_83, var_12_57, var_12_3 + 2)

			local var_12_92 = true
			local var_12_93 = Gui.word_wrap(var_12_1, var_12_83.description, var_0_1, var_12_3, 500, " ", "", "\n", var_12_92)

			for iter_12_10 = 1, #var_12_93 do
				local var_12_94 = var_12_93[iter_12_10]

				Gui.text(var_12_1, var_12_94, var_0_1, var_12_3, var_0_0, Vector3(var_12_74, var_12_57, var_12_78), var_12_72)

				var_12_57 = var_12_0.push_setting_size(var_12_83, var_12_57, var_12_3 + 2)
			end

			for iter_12_11 = 1, #var_12_18 do
				local var_12_95 = var_12_18[iter_12_11]
				local var_12_96 = var_12_83.options[var_12_95]
				local var_12_97 = var_12_95 == var_12_83.hot_id
				local var_12_98 = var_12_95 == var_12_83.selected_id

				for iter_12_12, iter_12_13 in pairs(var_12_0.shortcut_list) do
					local var_12_99 = iter_12_13.cs
					local var_12_100 = iter_12_13.option

					if (var_12_83 == var_12_99 or var_12_83 == var_12_99.copy) and var_12_96 == var_12_100 then
						Gui.text(var_12_1, "[" .. iter_12_12 .. "]", var_0_1, var_12_3, var_0_0, Vector3(var_12_43 - 100, var_12_57, var_12_78), var_12_64)
					end
				end

				local var_12_101

				if var_12_83.item_display_func then
					var_12_101 = tostring(var_12_83.item_display_func(var_12_96, var_12_95, var_12_83.options))
				else
					var_12_101 = tostring(var_12_96)
				end

				if var_12_98 then
					if var_12_97 then
						var_12_83.option_pos = math.abs(var_12_57 - var_12_58)

						Gui.rect(var_12_1, Vector3(0, var_12_57 - 5, var_12_79), Vector2(var_12_43, 25), var_12_73)
						Gui.text(var_12_1, ">", var_0_1, var_12_3, var_0_0, Vector3(var_12_74 + var_12_59, var_12_57, var_12_78), var_12_67)
					end

					Gui.text(var_12_1, var_12_101, var_0_1, var_12_3, var_0_0, Vector3(var_12_75, var_12_57, var_12_78), var_12_68)
				elseif var_12_97 then
					var_12_83.option_pos = math.abs(var_12_57 - var_12_58)

					if (arg_12_2:get("right_key") or arg_12_2:has("exclusive_right_key") and arg_12_2:get("exclusive_right_key")) and not var_12_2 then
						var_0_6(var_12_83, var_12_95)

						if var_12_85 then
							var_12_0.text_effects[#var_12_0.text_effects + 1] = {
								time = 0,
								start_position = {
									var_12_75,
									var_12_57,
									var_12_78
								},
								end_position = {
									var_12_85.x,
									var_12_85.y,
									var_12_85.z
								},
								text = tostring(var_12_96)
							}

							if var_12_83.close_when_selected then
								var_12_0.active = false
								var_12_2 = true

								arg_12_3:device_unblock_service("keyboard", 1, "Debug")
							end

							if var_12_83.clear_when_selected then
								var_12_83.selected_id = nil
							end
						end
					end

					Gui.rect(var_12_1, Vector3(0, var_12_57 - 5, var_12_79), Vector2(var_12_43, 25), var_12_73)
					Gui.text(var_12_1, ">", var_0_1, var_12_3, var_0_0, Vector3(var_12_74 + var_12_59, var_12_57, var_12_78), var_12_67)
					Gui.text(var_12_1, var_12_101, var_0_1, var_12_3, var_0_0, Vector3(var_12_75, var_12_57, var_12_78), var_12_67)
				else
					Gui.text(var_12_1, var_12_101, var_0_1, var_12_3, var_0_0, Vector3(var_12_75, var_12_57, var_12_78), var_12_65)
				end

				var_12_57 = var_12_0.push_setting_size(var_12_83, var_12_57, var_12_3 + 2)
			end

			if var_12_83.func and (arg_12_2:get("right_key") or arg_12_2:has("exclusive_right_key") and arg_12_2:get("exclusive_right_key")) and not var_12_2 then
				var_0_7(var_12_83)

				if var_12_83.close_when_selected then
					var_12_0.active = false
					var_12_2 = true

					arg_12_3:device_unblock_service("keyboard", 1, "Debug")
				end

				Application.save_user_settings()
			end

			if var_12_83.preset and (arg_12_2:get("right_key") or arg_12_2:has("exclusive_right_key") and arg_12_2:get("exclusive_right_key")) and not var_12_2 then
				var_0_8(var_12_83)
				Application.save_user_settings()
			end

			if arg_12_2:get("left_key") then
				var_12_0.active_id = nil
			end

			if var_12_83.bitmap then
				local var_12_102 = Vector2(1, 1) * var_12_83.bitmap_size

				Gui.bitmap(var_12_1, var_12_83.bitmap, Vector3(var_12_43 / 2 - var_12_83.bitmap_size / 2, var_12_57 - var_12_83.bitmap_size, var_12_80), var_12_102, Color(var_12_42 * 250, 255, 255, 255))

				var_12_57 = var_12_0.push_setting_size(var_12_83, var_12_57, var_12_83.bitmap_size)
			end
		elseif var_12_82 then
			local var_12_103

			for iter_12_14, iter_12_15 in pairs(var_12_0.shortcut_list) do
				local var_12_104 = iter_12_15.cs

				if var_12_83 == var_12_104 or var_12_83 == var_12_104.copy then
					var_12_103 = (var_12_103 and var_12_103 .. ", " or "") .. iter_12_14
				end
			end

			if var_12_103 then
				Gui.text(var_12_1, "[" .. var_12_103 .. "]", var_0_1, var_12_3, var_0_0, Vector3(var_12_43 - 100, var_12_57, var_12_78), var_12_64)
			end

			Gui.rect(var_12_1, Vector3(0, var_12_57 - 5, var_12_79), Vector2(var_12_43, 25), var_12_73)
			Gui.text(var_12_1, ">", var_0_1, var_12_3, var_0_0, Vector3(10 + var_12_59, var_12_57, var_12_78), var_12_67)
			Gui.text(var_12_1, var_12_84, var_0_1, var_12_3, var_0_0, Vector3(var_12_74, var_12_57, var_12_78), var_12_67)

			if arg_12_2:get("left_key") and var_12_0.active_id == nil then
				if var_12_5 and #var_12_83.options > 0 then
					if var_12_83.is_boolean then
						var_12_83.hot_id = 3
					elseif var_12_83.hot_id == 1 then
						var_12_83.hot_id = #var_12_83.options
					else
						var_12_83.hot_id = var_12_83.hot_id - 1
					end

					var_0_6(var_12_83, var_12_83.hot_id)
				else
					var_12_0.active = false

					arg_12_3:device_unblock_service("keyboard", 1, "Debug")
				end
			end

			if (arg_12_2:get("right_key") or arg_12_2:has("exclusive_right_key") and arg_12_2:get("exclusive_right_key")) and not var_12_2 then
				if var_12_83.load_items_source_func then
					var_12_83.load_items_source_func(var_12_83.options)
				end

				if var_12_5 and #var_12_83.options > 0 then
					if var_12_83.is_boolean then
						var_12_83.hot_id = var_12_83.selected_id == 1 and 2 or 1
					elseif var_12_83.hot_id == #var_12_83.options then
						var_12_83.hot_id = 1
					else
						var_12_83.hot_id = var_12_83.hot_id + 1
					end

					var_0_6(var_12_83, var_12_83.hot_id)
				else
					var_12_0.active_id = iter_12_7
				end
			end

			if not var_12_0.search_active and arg_12_2:get("console_favorite_key") then
				if var_12_83.category == "Favorites" then
					var_12_83.copy.copy = nil

					local var_12_105 = table.find(var_12_0.console_settings, var_12_83)

					table.remove(var_12_0.console_settings, var_12_105)

					local var_12_106 = table.find(var_12_0.favorites, var_12_83.title)

					if var_12_106 then
						table.remove(var_12_0.favorites, var_12_106)
						Development.set_setting("debug_favorites", var_12_0.favorites)
						Application.save_user_settings()
					end

					break
				elseif not var_12_83.copy then
					local var_12_107 = table.clone(var_12_83)

					var_12_107.category = "Favorites"
					var_12_83.copy = var_12_107
					var_12_107.copy = var_12_83

					table.insert(var_12_0.console_settings, 1, var_12_107)

					var_12_0.hot_id = var_12_0.hot_id + 1
					var_12_0.target_y_offset = var_12_0.target_y_offset + var_12_3
					var_12_0.favorites[#var_12_0.favorites + 1] = var_12_83.title

					Development.set_setting("debug_favorites", var_12_0.favorites)
					Application.save_user_settings()

					break
				end
			end
		else
			if not var_12_83.is_boolean and var_12_83.selected_id ~= nil or var_12_83.options[var_12_83.selected_id] then
				Gui.text(var_12_1, var_12_84, var_0_1, var_12_3, var_0_0, Vector3(var_12_74, var_12_57, var_12_78), var_12_66)
			else
				Gui.text(var_12_1, var_12_84, var_0_1, var_12_3, var_0_0, Vector3(var_12_74, var_12_57, var_12_78), var_12_65)
			end

			local var_12_108

			for iter_12_16, iter_12_17 in pairs(var_12_0.shortcut_list) do
				local var_12_109 = iter_12_17.cs

				if var_12_83 == var_12_109 or var_12_83 == var_12_109.copy then
					var_12_108 = (var_12_108 and var_12_108 .. ", " or "") .. iter_12_16
				end
			end

			if var_12_108 then
				Gui.text(var_12_1, "[" .. var_12_108 .. "]", var_0_1, var_12_3, var_0_0, Vector3(var_12_43 - 100, var_12_57, var_12_78), var_12_64)
			end
		end

		if var_12_81 or var_12_82 then
			for iter_12_18 = 0, 9 do
				local var_12_110 = "numpad " .. iter_12_18

				if Keyboard.pressed(Keyboard.button_index(var_12_110)) or var_12_0.numpad_presses[iter_12_18] then
					local var_12_111 = false

					for iter_12_19, iter_12_20 in pairs(var_12_0.shortcut_list) do
						local var_12_112 = iter_12_20.cs
						local var_12_113 = iter_12_20.option
						local var_12_114 = var_12_81 and var_12_83.options[var_12_83.hot_id] or var_12_0.shortcut_any

						if (var_12_83 == var_12_112 or var_12_83 == var_12_112.copy) and var_12_113 == var_12_114 then
							var_12_0.shortcut_list[iter_12_19] = nil

							if iter_12_19 == var_12_110 then
								var_12_111 = true
							end
						end
					end

					if var_12_111 then
						break
					end

					local var_12_115 = var_12_83.category == "Favorites" and var_12_83.copy or var_12_83
					local var_12_116 = var_12_0.shortcut_any

					var_12_116 = var_12_81 and var_12_115.options[var_12_115.hot_id] or var_12_116
					var_12_0.shortcut_list[var_12_110] = {
						cs = var_12_115,
						option = var_12_116
					}

					local var_12_117 = {}

					for iter_12_21, iter_12_22 in pairs(var_12_0.shortcut_list) do
						var_12_117[#var_12_117 + 1] = iter_12_21
						var_12_117[#var_12_117 + 1] = iter_12_22.cs.title
						var_12_117[#var_12_117 + 1] = iter_12_22.option
					end

					Development.set_setting("debug_shortcuts", var_12_117)
					Application.save_user_settings()
				end
			end
		end

		var_12_57 = var_12_0.push_setting_size(var_12_83, var_12_57, var_12_3 + 2)
	end

	if var_12_0.hot_id == 0 and arg_12_2:get("left_key") then
		var_12_0.active = false

		arg_12_3:device_unblock_service("keyboard", 1, "Debug")
	end

	local var_12_118 = 1
	local var_12_119 = var_12_0.text_effects
	local var_12_120 = #var_12_119

	while var_12_118 <= var_12_120 do
		local var_12_121 = var_12_119[var_12_118]

		var_12_121.time = var_12_121.time + arg_12_0

		if var_12_121.time > 0.5 then
			var_12_119[var_12_118] = var_12_119[var_12_120]
			var_12_119[var_12_120] = nil
			var_12_120 = var_12_120 - 1
		else
			local var_12_122 = Vector3(var_12_121.start_position[1], var_12_121.start_position[2], var_12_121.start_position[3])
			local var_12_123 = Vector3(var_12_121.end_position[1], var_12_121.end_position[2], var_12_121.end_position[3])
			local var_12_124 = var_0_4(var_12_121.time, 0, 1, 0.5)
			local var_12_125 = math.lerp(var_12_122, var_12_123, var_12_124)

			Gui.text(var_12_1, var_12_121.text, var_0_1, var_12_3, var_0_0, var_12_125, var_12_71)

			var_12_118 = var_12_118 + 1
		end
	end
end

function var_0_9.reset_settings()
	local var_13_0 = true

	for iter_13_0 = 1, #var_0_9.console_settings do
		local var_13_1 = var_0_9.console_settings[iter_13_0]

		if var_13_1.is_boolean and var_13_1.selected_id == 1 then
			var_13_0 = false

			var_0_6(var_13_1, 2, true, true)
		end
	end

	if var_13_0 then
		for iter_13_1 = 1, #var_0_9.console_settings do
			local var_13_2 = var_0_9.console_settings[iter_13_1]

			if var_13_2.is_boolean and var_13_2.selected_id == 2 then
				var_0_6(var_13_2, 3, true, true)
			end
		end
	end

	Application.save_user_settings()
end

function var_0_9.set_texture_quality(arg_14_0)
	Application.set_user_setting("texture_settings", "texture_categories/character_df", arg_14_0)
	Application.set_user_setting("texture_settings", "texture_categories/character_gsm", arg_14_0)
	Application.set_user_setting("texture_settings", "texture_categories/character_ma", arg_14_0)
	Application.set_user_setting("texture_settings", "texture_categories/character_nm", arg_14_0)
	Application.set_user_setting("texture_settings", "texture_categories/coat_of_arms", arg_14_0)
	Application.set_user_setting("texture_settings", "texture_categories/color_grading", arg_14_0)
	Application.set_user_setting("texture_settings", "texture_categories/decals", arg_14_0)
	Application.set_user_setting("texture_settings", "texture_categories/detail_textures", arg_14_0)
	Application.set_user_setting("texture_settings", "texture_categories/environment_df", arg_14_0)
	Application.set_user_setting("texture_settings", "texture_categories/environment_dfa", arg_14_0)
	Application.set_user_setting("texture_settings", "texture_categories/environment_gsm", arg_14_0)
	Application.set_user_setting("texture_settings", "texture_categories/environment_hm", arg_14_0)
	Application.set_user_setting("texture_settings", "texture_categories/environment_ma", arg_14_0)
	Application.set_user_setting("texture_settings", "texture_categories/environment_nm", arg_14_0)
	Application.set_user_setting("texture_settings", "texture_categories/fx", arg_14_0)
	Application.set_user_setting("texture_settings", "texture_categories/gui", arg_14_0)
	Application.set_user_setting("texture_settings", "texture_categories/skydome", arg_14_0)
	Application.set_user_setting("texture_settings", "texture_categories/weapon_ao", arg_14_0)
	Application.set_user_setting("texture_settings", "texture_categories/weapon_df", arg_14_0)
	Application.set_user_setting("texture_settings", "texture_categories/weapon_dfo", arg_14_0)
	Application.set_user_setting("texture_settings", "texture_categories/weapon_gsm", arg_14_0)
	Application.set_user_setting("texture_settings", "texture_categories/weapon_nm", arg_14_0)
	Application.set_user_setting("texture_settings", "texture_categories/weapon_scr", arg_14_0)
	Application.save_user_settings()
end

function var_0_9.update_search(arg_15_0, arg_15_1, arg_15_2, arg_15_3, arg_15_4, arg_15_5)
	local var_15_0 = arg_15_5 and var_0_9.search_string ~= ""
	local var_15_1 = arg_15_1:get("console_search_key") and (var_0_9.search_string == "" or not var_0_9.search_active)
	local var_15_2 = not var_0_9.active and var_0_9.search_active
	local var_15_3 = var_0_9.search_active and var_0_9.hot_id == 0 and arg_15_1:get("left_key")

	if var_15_0 or var_15_1 or var_15_2 or var_15_3 then
		if not var_0_9.search_active then
			var_0_9.unblocked_services_n = arg_15_0:get_unblocked_services(nil, nil, var_0_9.unblocked_services)

			arg_15_0:device_block_services("keyboard", 1, var_0_9.unblocked_services, var_0_9.unblocked_services_n, "debug_screen")
			arg_15_0:device_unblock_service("keyboard", 1, "DebugMenu")

			var_0_9.search_active = true
		else
			arg_15_0:device_block_service("keyboard", 1, "DebugMenu")
			arg_15_0:device_unblock_services("keyboard", 1, var_0_9.unblocked_services, var_0_9.unblocked_services_n)

			var_0_9.search_active = false
		end
	end

	local var_15_4 = var_0_3 + 3
	local var_15_5 = var_0_3 + 4
	local var_15_6 = (math.sin(arg_15_3 / GLOBAL_TIME_SCALE * 10) + 1) * 0.5
	local var_15_7 = RESOLUTION_LOOKUP.res_w
	local var_15_8 = RESOLUTION_LOOKUP.res_h
	local var_15_9 = Vector3(50, var_15_8 - 60, var_15_4)
	local var_15_10 = Vector3(250, var_15_8 - 60, var_15_4)
	local var_15_11 = Vector3(60, var_15_8 - 50, var_15_5)
	local var_15_12 = Vector3(260, var_15_8 - 50, var_15_5)
	local var_15_13 = var_0_9.font_size

	var_0_9.search_text_box_width = var_0_9.search_text_box_width or 0

	if not var_0_9.search_active then
		var_0_9.search_text_box_width = math.max(0, var_0_9.search_text_box_width - 2000 * arg_15_4)

		if var_0_9.hot_id <= 5 then
			Gui.rect(arg_15_2, var_15_10, Vector2(var_0_9.search_text_box_width, 35), Colors.get_color_with_alpha("dark_olive_green", 100 + math.cos(var_15_6) * 25))
			Gui.rect(arg_15_2, var_15_9, Vector2(200, 35), Colors.get_color_with_alpha("orange", 15 + math.cos(var_15_6) * 5))
			Gui.text(arg_15_2, "Search (backspace) ", var_0_1, var_15_13, var_0_0, var_15_11, Colors.get_color_with_alpha("white", 100 + math.cos(var_15_6) * 100))

			local var_15_14 = 300
			local var_15_15 = Vector3(var_0_9.console_width - var_15_14, var_15_8 - var_15_13, var_15_5)

			Gui.text(arg_15_2, "Select First (Page up)", var_0_1, var_15_13 * 0.5, var_0_0, var_15_15, Colors.get_color_with_alpha("white", 100 + math.cos(var_15_6) * 100))

			local var_15_16 = Vector3(var_0_9.console_width - var_15_14, var_15_8 - var_15_13 * 2, var_15_5)

			Gui.text(arg_15_2, "Select Last (Page down)", var_0_1, var_15_13 * 0.5, var_0_0, var_15_16, Colors.get_color_with_alpha("white", 100 + math.cos(var_15_6) * 100))

			local var_15_17 = Vector3(var_0_9.console_width - var_15_14, var_15_8 - var_15_13 * 3, var_15_5)

			Gui.text(arg_15_2, "Use dot symbol [.] in search box to search submenus.", var_0_1, var_15_13 * 0.5, var_0_0, var_15_17, Colors.get_color_with_alpha("white", 100 + math.cos(var_15_6) * 100))

			local var_15_18 = Vector3(var_0_9.console_width - var_15_14, var_15_8 - var_15_13 * 4, var_15_5)

			Gui.text(arg_15_2, "Use star symbol [*] in search box to filter modified.", var_0_1, var_15_13 * 0.5, var_0_0, var_15_18, Colors.get_color_with_alpha("white", 100 + math.cos(var_15_6) * 100))
		end

		return
	end

	var_0_9.search_text_box_width = math.min(400, var_0_9.search_text_box_width + 2000 * arg_15_4)

	local var_15_19 = false

	for iter_15_0 = 0, 9 do
		local var_15_20 = "numpad " .. tostring(iter_15_0)

		var_15_19 = var_15_19 or var_0_9.numpad_presses[iter_15_0]
		var_0_9.numpad_presses[iter_15_0] = Keyboard.pressed(Keyboard.button_index(var_15_20)) or nil
		var_15_19 = var_15_19 or var_0_9.numpad_presses[iter_15_0]
	end

	if not var_15_19 then
		local var_15_21 = Keyboard.keystrokes()

		for iter_15_1 = 1, #var_15_21 do
			local var_15_22 = var_15_21[iter_15_1]

			if var_15_22 == "\x7F" then
				var_0_9.search_string = ""
				var_0_9.active_id = nil
			elseif type(var_15_22) == "string" then
				if var_15_22:find(".", 1, true) == nil and var_0_9.search_string:find(".", 1, true) == nil then
					var_0_9.active_id = nil
				end

				var_0_9.search_string = var_0_9.search_string .. string.lower(var_15_22)
			elseif var_15_22 == Keyboard.BACKSPACE and #var_0_9.search_string > 0 then
				local var_15_23 = string.len(var_0_9.search_string)
				local var_15_24 = Utf8.location(var_0_9.search_string, var_15_23)

				var_0_9.search_string = var_0_9.search_string:sub(1, var_15_24 - 1)

				if var_0_9.search_string:find(".", 1, true) == nil then
					var_0_9.active_id = nil
				end
			end
		end
	end

	Gui.rect(arg_15_2, var_15_10, Vector2(var_0_9.search_text_box_width, 35), Colors.get_color_with_alpha("dark_olive_green", 225 + math.cos(var_15_6) * 25))
	Gui.rect(arg_15_2, var_15_9, Vector2(200, 35), Colors.get_color_with_alpha("olive", 225))
	Gui.text(arg_15_2, "Search: ", var_0_1, var_15_13, var_0_0, var_15_11, Colors.get("white"))
	Gui.text(arg_15_2, var_0_9.search_string, var_0_1, var_15_13, var_0_0, var_15_12, Colors.get("yellow"))

	local var_15_25, var_15_26 = Gui.text_extents(arg_15_2, var_0_9.search_string, var_0_1, var_15_13)
	local var_15_27 = var_15_26.x - var_15_25.x

	Gui.rect(arg_15_2, var_15_12 + Vector3(var_15_27 + 1, -2, 0), Vector2(10, 20), Colors.get_color_with_alpha("white", -50 + math.cos(var_15_6) * 250))
end

function var_0_9.hash_options()
	return var_0_9.settings_hash or 0
end

function var_0_9._propagate_option(arg_17_0, arg_17_1, arg_17_2)
	Managers.state.network.network_transmit:send_rpc_server("rpc_propagate_debug_option", var_0_9.hash_options(), arg_17_0, arg_17_1, arg_17_2)
end

function var_0_9.handle_propagated_option(arg_18_0, arg_18_1, arg_18_2, arg_18_3)
	local var_18_0 = var_0_9.hash_options()

	if var_18_0 ~= arg_18_0 then
		return string.format("Debug option mismatch (%s ~= %s)", var_18_0, arg_18_0)
	end

	local var_18_1, var_18_2 = table.find_func(var_0_9.console_settings, function(arg_19_0, arg_19_1)
		return arg_19_1.setting_id == arg_18_1
	end)

	if not var_18_2 then
		return "Missing debug option at index " .. tostring(arg_18_1)
	end

	Debug.sticky_text("[DebugManager] Received propagated debug option '%s' from client", arg_18_2 == 0 and var_18_2.title or string.format("%s = %s", var_18_2.title, var_18_2.options[arg_18_2]), "delay", 5)

	if var_18_2.func then
		var_0_7(var_18_2)
	else
		var_0_6(var_18_2, arg_18_2, arg_18_3)
	end
end
