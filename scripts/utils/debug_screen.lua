-- chunkname: @scripts/utils/debug_screen.lua

local str = "arial"
local str_2 = "materials/fonts/" .. str
local num = 10
local debug_screen = UILayer.debug_screen

local function fn(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
	-- function 1
	arg_1_0 = arg_1_0 / arg_1_3

	return -arg_1_2 * arg_1_0 * (arg_1_0 - 2) + arg_1_1
end

local num_2 = 0

local function fn_2(self, arg_2_1, arg_2_2, arg_2_3)
	-- function 2
	if not (not self.propagate_to_server and DebugScreen._is_server or arg_2_3) then
		DebugScreen._propagate_option(self.setting_id, arg_2_1, not not arg_2_2)
	end

	local var_2_0 = self.options[arg_2_1]

	self.selected_id = arg_2_1

	if var_2_0 == "[clear value]" then
		var_2_0 = nil
		self.selected_id = nil
	end

	if not self.copy then
		self.copy.selected_id = self.selected_id
	end

	if not self.commands then
		local var_2_1 = self.commands[self.hot_id]

		if not var_2_1 then
			for i = 1, #var_2_1 do
				local var_2_2 = var_2_1[i]

				Application.console_command(unpack(var_2_2))
			end
		end
	end

	Development.set_setting(self.title, var_2_0)

	script_data[self.title] = var_2_0

	Development.clear_param_cache(self.title)

	if not self.callback then
		self.callback(var_2_0)
	end

	if not (arg_2_2 or self.never_save) then
		printf("DebugScreen: script_data.%-35s = %s", self.title, tostring(self.options[arg_2_1]))
		Application.save_user_settings()
	end

	Profiler.event("%s = %s", self.title, tostring(self.options[arg_2_1]))
end

local function fn_3(self)
	-- function 3
	if not (not self.propagate_to_server and DebugScreen._is_server) then
		DebugScreen._propagate_option(self.setting_id, 0, true)
	end

	self.func(self.options, self.hot_id)

	if not self.clear_setting then
		self.selected_id = nil

		Development.set_setting(self.title, nil)

		script_data[self.title] = nil

		Development.clear_param_cache(self.title)
	end
end

local function fn_4(self)
	-- function 4
	for k, v in pairs(self.preset) do
		for k_2 = 1, #DebugScreen.console_settings do
			local var_4_0 = DebugScreen.console_settings[k_2]

			if var_4_0.title ~= k or not var_4_0.is_boolean then
				local var_4_1 = fn_2
				local var_4_2 = var_4_0
				local flag

				flag = not v and 1 and 2

				var_4_1(var_4_2, flag)
			end
		end
	end

	self.selected_id = nil

	Development.set_setting(self.title, nil)

	script_data[self.title] = nil

	Development.clear_param_cache(self.title)
end

local DebugScreen = DebugScreen

DebugScreen = DebugScreen or {}
DebugScreen = DebugScreen

local DebugScreen_2 = DebugScreen
local console_width = DebugScreen_2.console_width

if not console_width then
	local scale = RESOLUTION_LOOKUP.scale

	scale = scale or 1
	console_width = 800 * scale
end

DebugScreen_2.console_width = console_width

local font_size = DebugScreen_2.font_size

if not font_size then
	local scale_2 = RESOLUTION_LOOKUP.scale

	scale_2 = scale_2 or 1
	font_size = 20 * scale_2
end

DebugScreen_2.font_size = font_size
DebugScreen_2.numpad_presses = {}
DebugScreen_2.shortcut_any = "_any_"
DebugScreen_2.shortcut_version = 1

local function fn_5(arg_5_0, arg_5_1)
	-- function 5
	if arg_5_1 == 0 then
		for i = 1, #arg_5_0 / 2 do
			table.insert(arg_5_0, i * 3, DebugScreen_2.shortcut_any)
		end
	end

	return arg_5_0
end

DebugScreen_2.setup = function (arg_6_0, arg_6_1, arg_6_2, arg_6_3)
	-- function 6
	local var_6_0 = DebugScreen_2

	var_6_0.world = arg_6_0
	var_6_0.gui = World.create_screen_gui(arg_6_0, "material", "materials/fonts/gw_fonts", "material", "materials/menu/debug_screen", "immediate")
	var_6_0.active = false
	var_6_0._is_server = arg_6_3

	local script_data = script_data

	var_6_0.console_settings = {}

	for i = 1, #arg_6_1 do
		local tbl = {
			hot_id = 1,
			options = {}
		}
		local var_6_3 = arg_6_1[i]

		if not var_6_3.item_source then
			local item_source = var_6_3.item_source

			if not var_6_3.custom_item_source_order then
				var_6_3.custom_item_source_order(item_source, tbl.options)
			else
				for k, v in pairs(item_source) do
					local var_6_5 = k

					tbl.options[#tbl.options + 1] = var_6_5
				end
			end

			if not var_6_3.func then
				tbl.func = var_6_3.func
				tbl.clear_setting = false
			end

			tbl.load_items_source_func = var_6_3.load_items_source_func
		elseif not var_6_3.is_boolean then
			tbl.is_boolean = true
			tbl.options[#tbl.options + 1] = true
			tbl.options[#tbl.options + 1] = false

			if not var_6_3.func then
				tbl.func = var_6_3.func
			end
		elseif not var_6_3.command_list then
			tbl.commands = {}

			for l = 1, #var_6_3.command_list do
				local var_6_6 = var_6_3.command_list[l]

				tbl.options[#tbl.options + 1] = var_6_6.description
				tbl.commands[#tbl.commands + 1] = var_6_6.commands
			end
		elseif not var_6_3.func then
			tbl.options[1] = "Activate function"
			tbl.func = var_6_3.func
		elseif not var_6_3.preset then
			tbl.options[1] = "Activate preset"
			tbl.preset = var_6_3.preset
		end

		tbl.propagate_to_server = var_6_3.propagate_to_server
		tbl.never_save = var_6_3.never_save
		tbl.item_display_func = var_6_3.item_display_func

		if not var_6_3.bitmap then
			tbl.bitmap = var_6_3.bitmap
			tbl.bitmap_size = var_6_3.bitmap_size
		end

		if not var_6_3.callback then
			tbl.callback = arg_6_2[var_6_3.callback]
		end

		tbl.title = var_6_3.setting_name
		tbl.description = var_6_3.description
		tbl.category = var_6_3.category
		tbl.close_when_selected = var_6_3.close_when_selected
		tbl.clear_when_selected = var_6_3.clear_when_selected
		tbl.setting_id = i

		for i4 = 1, #tbl.options do
			local var_6_7 = tbl.options[i4]

			if Development.parameter(tbl.title) == var_6_7 then
				tbl.selected_id = i4
				tbl.hot_id = i4

				fn_2(tbl, i4, true, true)
			end
		end

		if not (not (#tbl.options > 0) or var_6_3.no_nil or var_6_3.func or var_6_3.preset) then
			tbl.options[#tbl.options + 1] = "[clear value]"
		end

		var_6_0.console_settings[#var_6_0.console_settings + 1] = tbl
	end

	var_6_0.settings_hash = HashUtils.fnv32_hash(table.concat(table.select_array(arg_6_1, function (arg_7_0, arg_7_1)
		-- function 7
		local setting_name = arg_7_1.setting_name

		setting_name = setting_name or arg_7_0

		return setting_name
	end), ","))

	for i5 = 1, #var_6_0.console_settings do
		local var_6_8 = var_6_0.console_settings[i5]

		if not var_6_8.preset and not Development.parameter(var_6_8.title) then
			fn_4(var_6_8)
		end
	end

	var_6_0.shortcut_list = {}

	local setting = Development.setting("debug_shortcuts")

	setting = setting or {
		"numpad 0",
		"debug_weapons"
	}
	var_6_0.shortcuts = setting

	local var_6_10 = tonumber(var_6_0.shortcuts[1])

	var_6_10 = var_6_10 or 0

	fn_5(var_6_0.shortcuts, var_6_10)

	for i6 = 1, #var_6_0.shortcuts, 3 do
		local var_6_11 = var_6_0.shortcuts[i6]
		local var_6_12 = var_6_0.shortcuts[i6 + 1]
		local var_6_13 = var_6_0.shortcuts[i6 + 2]

		for i7 = 1, #var_6_0.console_settings do
			local var_6_14 = var_6_0.console_settings[i7]

			if var_6_14.title == var_6_12 then
				var_6_0.shortcut_list[var_6_11] = {
					cs = var_6_14,
					option = var_6_13
				}

				break
			end
		end
	end

	local setting_2 = Development.setting("debug_favorites")

	setting_2 = setting_2 or {}
	var_6_0.favorites = setting_2

	for i8 = 1, #var_6_0.favorites do
		local var_6_16 = var_6_0.favorites[i8]

		for i9 = 1, #var_6_0.console_settings do
			local var_6_17 = var_6_0.console_settings[i9]

			if var_6_17.title == var_6_16 then
				local clone = table.clone(var_6_17)

				clone.category = "Favorites"
				var_6_17.copy = clone
				clone.copy = var_6_17

				table.insert(var_6_0.console_settings, 1, clone)

				break
			end
		end
	end

	if not script_data.debug_enabled then
		script_data.disable_debug_draw = true
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

DebugScreen_2.destroy = function ()
	-- function 8
	World.destroy_gui(DebugScreen_2.world, DebugScreen_2.gui)

	DebugScreen_2.world = nil
	DebugScreen_2.gui = nil
end

DebugScreen_2.set_blocked = function (arg_9_0)
	-- function 9
	DebugScreen_2.is_blocked = arg_9_0
end

DebugScreen_2.reset_setting_size = function (self, arg_10_1, arg_10_2)
	-- function 10
	self.setting_height = 0
	self.setting_pos = math.abs(arg_10_1 - arg_10_2)
	self.option_pos = nil
end

DebugScreen_2.push_setting_size = function (self, arg_11_1, arg_11_2)
	-- function 11
	arg_11_1 = arg_11_1 - arg_11_2
	self.setting_height = self.setting_height + arg_11_2

	return arg_11_1
end

local accelerate_factor = DebugScreen_2.accelerate_factor

accelerate_factor = accelerate_factor or 1
DebugScreen_2.accelerate_factor = accelerate_factor

DebugScreen_2.update = function (arg_12_0, arg_12_1, arg_12_2, arg_12_3)
	-- function 12
	local var_12_0 = DebugScreen_2

	if (var_12_0.is_blocked or not script_data.debug_enabled or not arg_12_2) and not IS_LINUX then
		return
	end

	local gui = var_12_0.gui

	arg_12_0 = arg_12_0 / GLOBAL_TIME_SCALE

	local flag = false
	local font_size = var_12_0.font_size
	local console_width = var_12_0.console_width
	local get = arg_12_2:get("console_mod_key")

	if arg_12_2:get("console_open_key") or not var_12_0.active or not arg_12_2:is_blocked() then
		var_12_0.active = not var_12_0.active

		if not var_12_0.active then
			arg_12_3:device_block_service("keyboard", 1, "Debug")
		else
			arg_12_3:device_unblock_service("keyboard", 1, "Debug")
		end
	end

	if not (not arg_12_2:get("right_key") and var_12_0.active) then
		var_12_0.active = not var_12_0.active

		arg_12_3:device_block_service("keyboard", 1, "Debug", "debug_screen")

		flag = true
	end

	if not (var_12_0.active or var_12_0.fade_timer ~= 0) then
		for k, v in pairs(var_12_0.shortcut_list) do
			if not Keyboard.pressed(Keyboard.button_index(k)) then
				local cs = v.cs
				local option = v.option

				if option == var_12_0.shortcut_any then
					if cs.hot_id == #cs.options then
						cs.hot_id = 1
					else
						cs.hot_id = cs.hot_id + 1
					end
				else
					local find = table.find(cs.options, option)

					cs.hot_id = math.clamp(find or -1, 1, #cs.options)
				end

				if not cs.func then
					fn_3(cs)
				else
					fn_2(cs, cs.hot_id)
				end

				var_12_0.active_shortcut_data.time = arg_12_1 + 1
				var_12_0.active_shortcut_data.cs = cs
			end
		end

		if arg_12_1 < var_12_0.active_shortcut_data.time then
			local cs_2 = var_12_0.active_shortcut_data.cs

			Debug.text("Debug Screen: %s = %s", cs_2.title, tostring(cs_2.options[cs_2.hot_id]))
		end

		return
	end

	var_12_0.update_search(arg_12_3, arg_12_2, gui, arg_12_1, arg_12_0, flag)

	if not var_12_0.active then
		var_12_0.fade_timer = math.min(1, var_12_0.fade_timer + arg_12_0 * num)
	else
		var_12_0.fade_timer = math.max(0, var_12_0.fade_timer - arg_12_0 * num)
	end

	local console_settings = var_12_0.console_settings
	local var_12_11 = var_12_0.filtered_console_settings[var_12_0.hot_id]
	local match, var_12_13 = var_12_0.search_string:match("([^.]*).?(.*)")

	if not var_12_0.search_active then
		if match == "*" then
			console_settings = {}

			for k_2 = 1, #var_12_0.console_settings do
				local var_12_14 = var_12_0.console_settings[k_2]

				if var_12_14.selected_id ~= nil then
					console_settings[#console_settings + 1] = var_12_14
				end
			end
		elseif match ~= "" then
			console_settings = {}

			local gsub = string.gsub(match, "[_ ]", "")

			for l = 1, #var_12_0.console_settings do
				local var_12_16 = var_12_0.console_settings[l]
				local lower = var_12_16.title:lower()

				if string.gsub(lower, "[_ ]", ""):find(gsub, 1, true) ~= nil then
					console_settings[#console_settings + 1] = var_12_16
				end
			end
		end
	end

	if var_12_11 ~= console_settings[var_12_0.hot_id] then
		local hot_id = var_12_0.hot_id

		hot_id = hot_id or 1
		var_12_0.hot_id = hot_id
		var_12_0.active_id = nil

		for i4 = 0, #console_settings * 0.5 do
			if not console_settings[var_12_0.hot_id + i4] then
				var_12_0.hot_id = var_12_0.hot_id + i4

				break
			elseif not console_settings[var_12_0.hot_id - i4] then
				var_12_0.hot_id = var_12_0.hot_id - i4

				break
			end
		end
	end

	var_12_0.filtered_console_settings = console_settings

	local tbl = {}

	if var_12_0.active_id ~= nil then
		if not (not var_12_0.search_active and var_12_13 == "") then
			local var_12_20 = console_settings[var_12_0.hot_id]
			local gsub_2 = string.gsub(var_12_13, "[_ ]", "")

			for i5 = 1, #var_12_20.options do
				local var_12_22 = var_12_20.options[i5]
				local lower_2 = tostring(var_12_22):lower()

				if string.gsub(lower_2, "[_ ]", ""):find(gsub_2, 1, true) ~= nil then
					tbl[#tbl + 1] = i5
				end
			end

			if not (table.contains(tbl, var_12_20.hot_id) or not (#tbl > 0)) then
				var_12_20.hot_id = tbl[1]
			end
		else
			local var_12_24 = console_settings[var_12_0.hot_id]

			for i6 = 1, #var_12_24.options do
				tbl[i6] = i6
			end
		end
	end

	if not (not arg_12_2:get("up_key") and not (arg_12_1 > var_12_0.hold_to_move_timer)) then
		if not var_12_0.is_holding then
			local accelerate_factor = var_12_0.accelerate_factor

			var_12_0.hold_to_move_timer = arg_12_1 + 0.1 * GLOBAL_TIME_SCALE * accelerate_factor
			var_12_0.accelerate_factor = accelerate_factor * 0.95
		else
			var_12_0.hold_to_move_timer = arg_12_1 + 0.1 * GLOBAL_TIME_SCALE
			var_12_0.is_holding = true
			var_12_0.accelerate_factor = 1
		end

		if var_12_0.active_id == nil then
			if var_12_0.hot_id == 1 then
				var_12_0.hot_id = #console_settings
			elseif not get then
				local hot_id_2 = var_12_0.hot_id
				local var_12_27 = console_settings[hot_id_2]
				local flag_2 = (var_12_27.is_boolean or var_12_27.selected_id == nil) and var_12_27.options[var_12_27.selected_id]

				while hot_id_2 > 1 do
					hot_id_2 = hot_id_2 - 1

					local var_12_29 = console_settings[hot_id_2]
					local flag_3 = (var_12_29.is_boolean or var_12_29.selected_id == nil) and var_12_29.options[var_12_29.selected_id]

					if not (not flag_3 and flag_2) then
						break
					elseif not flag_3 then
						flag_2 = false
					end

					if var_12_29.category ~= console_settings[math.max(1, hot_id_2 - 1)].category then
						break
					end
				end

				var_12_0.hot_id = hot_id_2
			else
				var_12_0.hot_id = var_12_0.hot_id - 1
			end
		else
			local var_12_31 = console_settings[var_12_0.active_id]
			local count = #tbl
			local find_2 = table.find(tbl, var_12_31.hot_id)

			if not find_2 then
				var_12_31.hot_id = tbl[(find_2 + count - 2) % count + 1]
			end
		end
	end

	if not (not arg_12_2:get("down_key") and not (arg_12_1 > var_12_0.hold_to_move_timer)) then
		if not var_12_0.is_holding then
			local accelerate_factor_2 = var_12_0.accelerate_factor

			var_12_0.hold_to_move_timer = arg_12_1 + 0.1 * GLOBAL_TIME_SCALE * accelerate_factor_2
			var_12_0.accelerate_factor = accelerate_factor_2 * 0.95
		else
			var_12_0.hold_to_move_timer = arg_12_1 + 0.1 * GLOBAL_TIME_SCALE
			var_12_0.is_holding = true
			var_12_0.accelerate_factor = 1
		end

		if var_12_0.active_id == nil then
			if var_12_0.hot_id == #console_settings then
				var_12_0.hot_id = 1
			elseif not get then
				local hot_id_3 = var_12_0.hot_id
				local var_12_36 = console_settings[hot_id_3]
				local flag_4 = (var_12_36.is_boolean or var_12_36.selected_id == nil) and var_12_36.options[var_12_36.selected_id]

				while hot_id_3 < #console_settings do
					hot_id_3 = hot_id_3 + 1

					local var_12_38 = console_settings[hot_id_3]
					local flag_5 = (var_12_38.is_boolean or var_12_38.selected_id == nil) and var_12_38.options[var_12_38.selected_id]

					if not (not flag_5 and flag_4) then
						break
					elseif not flag_5 then
						flag_4 = false
					end

					if var_12_38.category ~= console_settings[math.max(1, hot_id_3 - 1)].category then
						break
					end
				end

				var_12_0.hot_id = hot_id_3
			else
				var_12_0.hot_id = var_12_0.hot_id + 1
			end
		else
			local var_12_40 = console_settings[var_12_0.active_id]
			local count_2 = #tbl
			local find_3 = table.find(tbl, var_12_40.hot_id)

			if not find_3 then
				var_12_40.hot_id = tbl[find_3 % count_2 + 1]
			end
		end
	end

	if not arg_12_2:get("page up") then
		if not var_12_0.active_id then
			console_settings[var_12_0.active_id].hot_id = 1
		else
			var_12_0.hot_id = 1
		end
	elseif not arg_12_2:get("page down") then
		if not var_12_0.active_id then
			console_settings[var_12_0.active_id].hot_id = #tbl
		else
			var_12_0.hot_id = #console_settings
		end
	end

	if not (arg_12_2:get("down_key") or arg_12_2:get("up_key")) then
		var_12_0.is_holding = false
	end

	var_12_0.hot_id = math.clamp(var_12_0.hot_id, math.min(1, #console_settings), #console_settings)

	local var_12_43 = fn(var_12_0.fade_timer, 0, 1, 1)
	local num_3 = var_12_43 * console_width
	local res_w = RESOLUTION_LOOKUP.res_w
	local res_h = RESOLUTION_LOOKUP.res_h
	local num_4 = res_h - 100

	if not (var_12_0.active_id == nil or console_settings[var_12_0.active_id]) then
		var_12_0.active_id = nil
	end

	local num_5 = 200
	local num_6 = 0
	local num_7 = 0

	if not table.is_empty(console_settings) then
		local var_12_51 = console_settings[#console_settings]
		local setting_pos = var_12_51.setting_pos

		setting_pos = setting_pos or 0

		local setting_height = var_12_51.setting_height

		setting_height = setting_height or 0
		num_6 = setting_pos + setting_height

		local num_8 = res_h * 0.25
		local num_9 = num_6 - res_h * 0.25
		local var_12_56 = console_settings[var_12_0.hot_id]

		if not var_12_56 then
			local option_pos = var_12_56.option_pos

			if not option_pos then
				option_pos = var_12_56.setting_pos
				option_pos = option_pos or 0
			end

			if num_8 ~= num_9 then
				num_7 = math.remap_clamped(num_8, num_9, 0, 1, option_pos)
			end
		end
	end

	local num_10 = num_6 + num_5
	local num_11 = math.max(0, num_10 - res_h) * num_7

	var_12_0.target_y_offset = math.lerp(var_12_0.target_y_offset, num_11, 0.1)

	local num_12 = num_4 + var_12_0.target_y_offset
	local var_12_61 = num_12

	num_2 = num_2 + arg_12_0 * 10

	if num_2 > 10 then
		num_2 = 0
	end

	local var_12_62 = num_2

	if var_12_62 > 5 then
		var_12_62 = 10 - var_12_62
	end

	local flag_6

	flag_6 = num_10 == num_5 or num_10 < res_h or 0 or res_h * res_h / (num_10 - num_5)

	local num_13 = res_h * math.remap(0, 1, 0, 1 - flag_6 / res_h, num_7)
	local num_14 = debug_screen + 1

	Gui.rect(gui, Vector3(0, 0, debug_screen), Vector2(num_3, res_h), Color(var_12_43 * 220, 25, 50, 25))
	Gui.rect(gui, Vector3(0, res_h - num_13 - flag_6, num_14), Vector2(3, flag_6), Color(var_12_43 * 150, 200, 200, 25))

	local num_15 = (math.sin(arg_12_1 / GLOBAL_TIME_SCALE * 10) + 1) * 0.5
	local var_12_67 = Color(var_12_43 * 250, 255, 255, 255)
	local var_12_68 = Color(var_12_43 * 250, 120, 120, 0)
	local var_12_69 = Color(var_12_43 * 255, 200, 200, 0)
	local var_12_70 = Color(var_12_43 * 255, 230 + 25 * num_15, 230 + 25 * num_15, 200 * num_15)
	local var_12_71 = Color(var_12_43 * 255, 100, 255, 100)
	local var_12_72 = Color(var_12_43 * 255, 50, 150, 50)
	local var_12_73 = Color(var_12_43 * 255, 100, 255, 100)
	local var_12_74 = Color(var_12_43 * 255, 200, 255, 200)
	local var_12_75 = Color(var_12_43 * 255, 150, 150, 150)
	local var_12_76 = Color(var_12_43 * 150, 100, 100, 50)
	local num_16 = 30
	local num_17 = 50
	local var_12_79
	local num_18 = debug_screen + 2
	local num_19 = debug_screen + 2
	local num_20 = debug_screen + 1
	local num_21 = debug_screen + 1

	for i7 = 1, #console_settings do
		local flag_7 = i7 == var_12_0.active_id
		local flag_8 = i7 == var_12_0.hot_id
		local var_12_86 = console_settings[i7]

		var_12_0.reset_setting_size(var_12_86, num_12, var_12_61)

		local title = var_12_86.title

		if var_12_86.category ~= var_12_79 then
			num_12 = num_12 - font_size * 0.4
			var_12_79 = var_12_86.category

			Gui.text(gui, var_12_86.category, str_2, font_size, str, Vector3(10, num_12, num_18), var_12_67)

			num_12 = num_12 - font_size
		end

		local var_12_88 = Vector3(num_3 - 400, num_12, num_19)
		local var_12_89

		if var_12_86.selected_id ~= nil then
			local options = var_12_86.options
			local selected_id = var_12_86.selected_id
			local var_12_92 = options[selected_id]

			if not var_12_86.item_display_func then
				var_12_89 = string.format("< %s >", var_12_86.item_display_func(var_12_92, selected_id, options))
			else
				var_12_89 = string.format("< %s >", tostring(var_12_92))
			end

			if not flag_8 then
				Gui.text(gui, var_12_89, str_2, font_size, str, var_12_88, var_12_74)
			elseif not var_12_86.is_boolean and not var_12_86.options[var_12_86.selected_id] then
				Gui.text(gui, var_12_89, str_2, font_size, str, var_12_88, var_12_73)
			else
				Gui.text(gui, var_12_89, str_2, font_size, str, var_12_88, var_12_72)
			end
		end

		if not flag_7 then
			Gui.text(gui, ">", str_2, font_size, str, Vector3(10, num_12, num_19), var_12_71)
			Gui.text(gui, title, str_2, font_size, str, Vector3(num_16, num_12, num_19), var_12_71)

			local var_12_93

			for k_3, v_2 in pairs(var_12_0.shortcut_list) do
				local cs_3 = v_2.cs

				if not (var_12_86 == cs_3 or var_12_86 ~= cs_3.copy) then
					local str_3

					if not var_12_93 then
						str_3 = var_12_93 .. ", "

						if not str_3 then
							-- Nothing
						end
					end

					str_3 = ""

					::label_12_0::

					var_12_93 = str_3 .. k_3
				end
			end

			if not var_12_93 then
				Gui.text(gui, "[" .. var_12_93 .. "]", str_2, font_size, str, Vector3(num_3 - 100, num_12, num_19), var_12_67)
			end

			num_12 = var_12_0.push_setting_size(var_12_86, num_12, font_size + 2)

			local flag_9 = true
			local word_wrap = Gui.word_wrap(gui, var_12_86.description, str_2, font_size, 500, " ", "", "\n", flag_9)

			for i10 = 1, #word_wrap do
				local var_12_98 = word_wrap[i10]

				Gui.text(gui, var_12_98, str_2, font_size, str, Vector3(num_16, num_12, num_19), var_12_75)

				num_12 = var_12_0.push_setting_size(var_12_86, num_12, font_size + 2)
			end

			for i11 = 1, #tbl do
				local var_12_99 = tbl[i11]
				local var_12_100 = var_12_86.options[var_12_99]
				local flag_10 = var_12_99 == var_12_86.hot_id
				local flag_11 = var_12_99 == var_12_86.selected_id

				for k_4, v_3 in pairs(var_12_0.shortcut_list) do
					local cs_4 = v_3.cs
					local option_2 = v_3.option

					if not ((var_12_86 == cs_4 or var_12_86 == cs_4.copy) and var_12_100 ~= option_2) then
						Gui.text(gui, "[" .. k_4 .. "]", str_2, font_size, str, Vector3(num_3 - 100, num_12, num_19), var_12_67)
					end
				end

				local var_12_105

				if not var_12_86.item_display_func then
					var_12_105 = tostring(var_12_86.item_display_func(var_12_100, var_12_99, var_12_86.options))
				else
					var_12_105 = tostring(var_12_100)
				end

				if not flag_11 then
					if not flag_10 then
						var_12_86.option_pos = math.abs(num_12 - var_12_61)

						Gui.rect(gui, Vector3(0, num_12 - 5, num_20), Vector2(num_3, 25), var_12_76)
						Gui.text(gui, ">", str_2, font_size, str, Vector3(num_16 + var_12_62, num_12, num_19), var_12_70)
					end

					Gui.text(gui, var_12_105, str_2, font_size, str, Vector3(num_17, num_12, num_19), var_12_71)
				elseif not flag_10 then
					var_12_86.option_pos = math.abs(num_12 - var_12_61)

					if not ((arg_12_2:get("right_key") or not arg_12_2:has("exclusive_right_key") or not arg_12_2:get("exclusive_right_key")) and flag) then
						fn_2(var_12_86, var_12_99)

						if not var_12_88 then
							var_12_0.text_effects[#var_12_0.text_effects + 1] = {
								time = 0,
								start_position = {
									num_17,
									num_12,
									num_19
								},
								end_position = {
									var_12_88.x,
									var_12_88.y,
									var_12_88.z
								},
								text = tostring(var_12_100)
							}

							if not var_12_86.close_when_selected then
								var_12_0.active = false
								flag = true

								arg_12_3:device_unblock_service("keyboard", 1, "Debug")
							end

							if not var_12_86.clear_when_selected then
								var_12_86.selected_id = nil
							end
						end
					end

					Gui.rect(gui, Vector3(0, num_12 - 5, num_20), Vector2(num_3, 25), var_12_76)
					Gui.text(gui, ">", str_2, font_size, str, Vector3(num_16 + var_12_62, num_12, num_19), var_12_70)
					Gui.text(gui, var_12_105, str_2, font_size, str, Vector3(num_17, num_12, num_19), var_12_70)
				else
					Gui.text(gui, var_12_105, str_2, font_size, str, Vector3(num_17, num_12, num_19), var_12_68)
				end

				num_12 = var_12_0.push_setting_size(var_12_86, num_12, font_size + 2)
			end

			if not (not var_12_86.func and arg_12_2:get("right_key") and not arg_12_2:has("exclusive_right_key") and not arg_12_2:get("exclusive_right_key") and flag) then
				fn_3(var_12_86)

				if not var_12_86.close_when_selected then
					var_12_0.active = false
					flag = true

					arg_12_3:device_unblock_service("keyboard", 1, "Debug")
				end

				Application.save_user_settings()
			end

			if not (not var_12_86.preset and arg_12_2:get("right_key") and not arg_12_2:has("exclusive_right_key") and not arg_12_2:get("exclusive_right_key") and flag) then
				fn_4(var_12_86)
				Application.save_user_settings()
			end

			if not arg_12_2:get("left_key") then
				var_12_0.active_id = nil
			end

			if not var_12_86.bitmap then
				local num_22 = Vector2(1, 1) * var_12_86.bitmap_size

				Gui.bitmap(gui, var_12_86.bitmap, Vector3(num_3 / 2 - var_12_86.bitmap_size / 2, num_12 - var_12_86.bitmap_size, num_21), num_22, Color(var_12_43 * 250, 255, 255, 255))

				num_12 = var_12_0.push_setting_size(var_12_86, num_12, var_12_86.bitmap_size)
			end
		elseif not flag_8 then
			local var_12_107

			for k_5, v_4 in pairs(var_12_0.shortcut_list) do
				local cs_5 = v_4.cs

				if not (var_12_86 == cs_5 or var_12_86 ~= cs_5.copy) then
					local str_4

					if not var_12_107 then
						str_4 = var_12_107 .. ", "

						if not str_4 then
							-- Nothing
						end
					end

					str_4 = ""

					::label_12_1::

					var_12_107 = str_4 .. k_5
				end
			end

			if not var_12_107 then
				Gui.text(gui, "[" .. var_12_107 .. "]", str_2, font_size, str, Vector3(num_3 - 100, num_12, num_19), var_12_67)
			end

			Gui.rect(gui, Vector3(0, num_12 - 5, num_20), Vector2(num_3, 25), var_12_76)
			Gui.text(gui, ">", str_2, font_size, str, Vector3(10 + var_12_62, num_12, num_19), var_12_70)
			Gui.text(gui, title, str_2, font_size, str, Vector3(num_16, num_12, num_19), var_12_70)

			if not (not arg_12_2:get("left_key") and var_12_0.active_id ~= nil) then
				if not (not get and not (#var_12_86.options > 0)) then
					if not var_12_86.is_boolean then
						var_12_86.hot_id = 3
					elseif var_12_86.hot_id == 1 then
						var_12_86.hot_id = #var_12_86.options
					else
						var_12_86.hot_id = var_12_86.hot_id - 1
					end

					fn_2(var_12_86, var_12_86.hot_id)
				else
					var_12_0.active = false

					arg_12_3:device_unblock_service("keyboard", 1, "Debug")
				end
			end

			if not ((arg_12_2:get("right_key") or not arg_12_2:has("exclusive_right_key") or not arg_12_2:get("exclusive_right_key")) and flag) then
				if not var_12_86.load_items_source_func then
					var_12_86.load_items_source_func(var_12_86.options)
				end

				if not (not get and not (#var_12_86.options > 0)) then
					if not var_12_86.is_boolean then
						local flag_12

						flag_12 = var_12_86.selected_id ~= 1 or not 2 or 1
						var_12_86.hot_id = flag_12
					elseif var_12_86.hot_id == #var_12_86.options then
						var_12_86.hot_id = 1
					else
						var_12_86.hot_id = var_12_86.hot_id + 1
					end

					fn_2(var_12_86, var_12_86.hot_id)
				else
					var_12_0.active_id = i7
				end
			end

			if var_12_0.search_active or not arg_12_2:get("console_favorite_key") then
				if var_12_86.category == "Favorites" then
					var_12_86.copy.copy = nil

					local find_4 = table.find(var_12_0.console_settings, var_12_86)

					table.remove(var_12_0.console_settings, find_4)

					local find_5 = table.find(var_12_0.favorites, var_12_86.title)

					if not find_5 then
						table.remove(var_12_0.favorites, find_5)
						Development.set_setting("debug_favorites", var_12_0.favorites)
						Application.save_user_settings()
					end

					break
				elseif not var_12_86.copy then
					local clone = table.clone(var_12_86)

					clone.category = "Favorites"
					var_12_86.copy = clone
					clone.copy = var_12_86

					table.insert(var_12_0.console_settings, 1, clone)

					var_12_0.hot_id = var_12_0.hot_id + 1
					var_12_0.target_y_offset = var_12_0.target_y_offset + font_size
					var_12_0.favorites[#var_12_0.favorites + 1] = var_12_86.title

					Development.set_setting("debug_favorites", var_12_0.favorites)
					Application.save_user_settings()

					break
				end
			end
		else
			if (var_12_86.is_boolean or var_12_86.selected_id == nil) and not var_12_86.options[var_12_86.selected_id] then
				Gui.text(gui, title, str_2, font_size, str, Vector3(num_16, num_12, num_19), var_12_69)
			else
				Gui.text(gui, title, str_2, font_size, str, Vector3(num_16, num_12, num_19), var_12_68)
			end

			local var_12_114

			for k_6, v_5 in pairs(var_12_0.shortcut_list) do
				local cs_6 = v_5.cs

				if not (var_12_86 == cs_6 or var_12_86 ~= cs_6.copy) then
					local str_5

					if not var_12_114 then
						str_5 = var_12_114 .. ", "

						if not str_5 then
							-- Nothing
						end
					end

					str_5 = ""

					::label_12_2::

					var_12_114 = str_5 .. k_6
				end
			end

			if not var_12_114 then
				Gui.text(gui, "[" .. var_12_114 .. "]", str_2, font_size, str, Vector3(num_3 - 100, num_12, num_19), var_12_67)
			end
		end

		if flag_7 or not flag_8 then
			for i18 = 0, 9 do
				local str_6 = "numpad " .. i18
				local pressed = Keyboard.pressed(Keyboard.button_index(str_6))

				pressed = pressed or var_12_0.numpad_presses[i18]

				if not pressed then
					local flag_13 = false

					for k_7, v_6 in pairs(var_12_0.shortcut_list) do
						local cs_7 = v_6.cs
						local option_3 = v_6.option
						local var_12_122

						if not flag_7 then
							var_12_122 = var_12_86.options[var_12_86.hot_id]

							if not var_12_122 then
								-- Nothing
							end
						end

						var_12_122 = var_12_0.shortcut_any

						::label_12_3::

						if not ((var_12_86 == cs_7 or var_12_86 == cs_7.copy) and option_3 ~= var_12_122) then
							var_12_0.shortcut_list[k_7] = nil

							if k_7 == str_6 then
								flag_13 = true
							end
						end
					end

					if not flag_13 then
						break
					end

					local copy

					if var_12_86.category == "Favorites" then
						copy = var_12_86.copy

						if not copy then
							-- Nothing
						end
					end

					copy = var_12_86

					::label_12_4::

					local shortcut_any = var_12_0.shortcut_any

					shortcut_any = not flag_7 and copy.options[copy.hot_id] and shortcut_any
					var_12_0.shortcut_list[str_6] = {
						cs = copy,
						option = shortcut_any
					}

					local tbl_2 = {}

					for k_8, v_7 in pairs(var_12_0.shortcut_list) do
						tbl_2[#tbl_2 + 1] = k_8
						tbl_2[#tbl_2 + 1] = v_7.cs.title
						tbl_2[#tbl_2 + 1] = v_7.option
					end

					Development.set_setting("debug_shortcuts", tbl_2)
					Application.save_user_settings()
				end
			end
		end

		num_12 = var_12_0.push_setting_size(var_12_86, num_12, font_size + 2)
	end

	if var_12_0.hot_id ~= 0 or not arg_12_2:get("left_key") then
		var_12_0.active = false

		arg_12_3:device_unblock_service("keyboard", 1, "Debug")
	end

	local num_23 = 1
	local text_effects = var_12_0.text_effects
	local count_3 = #text_effects

	while num_23 <= count_3 do
		local var_12_129 = text_effects[num_23]

		var_12_129.time = var_12_129.time + arg_12_0

		if var_12_129.time > 0.5 then
			text_effects[num_23] = text_effects[count_3]
			text_effects[count_3] = nil
			count_3 = count_3 - 1
		else
			local var_12_130 = Vector3(var_12_129.start_position[1], var_12_129.start_position[2], var_12_129.start_position[3])
			local var_12_131 = Vector3(var_12_129.end_position[1], var_12_129.end_position[2], var_12_129.end_position[3])
			local var_12_132 = fn(var_12_129.time, 0, 1, 0.5)
			local lerp = math.lerp(var_12_130, var_12_131, var_12_132)

			Gui.text(gui, var_12_129.text, str_2, font_size, str, lerp, var_12_74)

			num_23 = num_23 + 1
		end
	end
end

DebugScreen_2.reset_settings = function ()
	-- function 13
	local flag = true

	for i = 1, #DebugScreen_2.console_settings do
		local var_13_1 = DebugScreen_2.console_settings[i]

		if not (not var_13_1.is_boolean and var_13_1.selected_id ~= 1) then
			flag = false

			fn_2(var_13_1, 2, true, true)
		end
	end

	if not flag then
		for j = 1, #DebugScreen_2.console_settings do
			local var_13_2 = DebugScreen_2.console_settings[j]

			if not (not var_13_2.is_boolean and var_13_2.selected_id ~= 2) then
				fn_2(var_13_2, 3, true, true)
			end
		end
	end

	Application.save_user_settings()
end

DebugScreen_2.set_texture_quality = function (arg_14_0)
	-- function 14
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

DebugScreen_2.update_search = function (self, arg_15_1, arg_15_2, arg_15_3, arg_15_4, arg_15_5)
	-- function 15
	local flag = not arg_15_5 and DebugScreen_2.search_string ~= ""
	local get = arg_15_1:get("console_search_key")

	get = not get and DebugScreen_2.search_string == "" or not DebugScreen_2.search_active

	local flag_2 = not not DebugScreen_2.active or DebugScreen_2.search_active
	local search_active = DebugScreen_2.search_active

	search_active = not search_active and DebugScreen_2.hot_id ~= 0 or arg_15_1:get("left_key")

	if flag or get or flag_2 or not search_active then
		if not DebugScreen_2.search_active then
			DebugScreen_2.unblocked_services_n = self:get_unblocked_services(nil, nil, DebugScreen_2.unblocked_services)

			self:device_block_services("keyboard", 1, DebugScreen_2.unblocked_services, DebugScreen_2.unblocked_services_n, "debug_screen")
			self:device_unblock_service("keyboard", 1, "DebugMenu")

			DebugScreen_2.search_active = true
		else
			self:device_block_service("keyboard", 1, "DebugMenu")
			self:device_unblock_services("keyboard", 1, DebugScreen_2.unblocked_services, DebugScreen_2.unblocked_services_n)

			DebugScreen_2.search_active = false
		end
	end

	local num = debug_screen + 3
	local num_2 = debug_screen + 4
	local num_3 = (math.sin(arg_15_3 / GLOBAL_TIME_SCALE * 10) + 1) * 0.5
	local res_w = RESOLUTION_LOOKUP.res_w
	local res_h = RESOLUTION_LOOKUP.res_h
	local var_15_9 = Vector3(50, res_h - 60, num)
	local var_15_10 = Vector3(250, res_h - 60, num)
	local var_15_11 = Vector3(60, res_h - 50, num_2)
	local var_15_12 = Vector3(260, res_h - 50, num_2)
	local font_size = DebugScreen_2.font_size
	local var_15_14 = DebugScreen_2
	local search_text_box_width = DebugScreen_2.search_text_box_width

	search_text_box_width = search_text_box_width or 0
	var_15_14.search_text_box_width = search_text_box_width

	if not DebugScreen_2.search_active then
		DebugScreen_2.search_text_box_width = math.max(0, DebugScreen_2.search_text_box_width - 2000 * arg_15_4)

		if DebugScreen_2.hot_id <= 5 then
			Gui.rect(arg_15_2, var_15_10, Vector2(DebugScreen_2.search_text_box_width, 35), Colors.get_color_with_alpha("dark_olive_green", 100 + math.cos(num_3) * 25))
			Gui.rect(arg_15_2, var_15_9, Vector2(200, 35), Colors.get_color_with_alpha("orange", 15 + math.cos(num_3) * 5))
			Gui.text(arg_15_2, "Search (backspace) ", str_2, font_size, str, var_15_11, Colors.get_color_with_alpha("white", 100 + math.cos(num_3) * 100))

			local num_4 = 300
			local var_15_17 = Vector3(DebugScreen_2.console_width - num_4, res_h - font_size, num_2)

			Gui.text(arg_15_2, "Select First (Page up)", str_2, font_size * 0.5, str, var_15_17, Colors.get_color_with_alpha("white", 100 + math.cos(num_3) * 100))

			local var_15_18 = Vector3(DebugScreen_2.console_width - num_4, res_h - font_size * 2, num_2)

			Gui.text(arg_15_2, "Select Last (Page down)", str_2, font_size * 0.5, str, var_15_18, Colors.get_color_with_alpha("white", 100 + math.cos(num_3) * 100))

			local var_15_19 = Vector3(DebugScreen_2.console_width - num_4, res_h - font_size * 3, num_2)

			Gui.text(arg_15_2, "Use dot symbol [.] in search box to search submenus.", str_2, font_size * 0.5, str, var_15_19, Colors.get_color_with_alpha("white", 100 + math.cos(num_3) * 100))

			local var_15_20 = Vector3(DebugScreen_2.console_width - num_4, res_h - font_size * 4, num_2)

			Gui.text(arg_15_2, "Use star symbol [*] in search box to filter modified.", str_2, font_size * 0.5, str, var_15_20, Colors.get_color_with_alpha("white", 100 + math.cos(num_3) * 100))
		end

		return
	end

	DebugScreen_2.search_text_box_width = math.min(400, DebugScreen_2.search_text_box_width + 2000 * arg_15_4)

	local flag_3 = false

	for i = 0, 9 do
		local str_3 = "numpad " .. tostring(i)

		flag_3 = flag_3 or DebugScreen_2.numpad_presses[i]

		local numpad_presses = DebugScreen_2.numpad_presses
		local pressed = Keyboard.pressed(Keyboard.button_index(str_3))

		pressed = pressed or nil
		numpad_presses[i] = pressed
		flag_3 = flag_3 or DebugScreen_2.numpad_presses[i]
	end

	if not flag_3 then
		local keystrokes = Keyboard.keystrokes()

		for j = 1, #keystrokes do
			local var_15_26 = keystrokes[j]

			if var_15_26 == "\x7F" then
				DebugScreen_2.search_string = ""
				DebugScreen_2.active_id = nil
			elseif type(var_15_26) == "string" then
				if not (var_15_26:find(".", 1, true) ~= nil or DebugScreen_2.search_string:find(".", 1, true) ~= nil) then
					DebugScreen_2.active_id = nil
				end

				DebugScreen_2.search_string = DebugScreen_2.search_string .. string.lower(var_15_26)
			elseif not (var_15_26 ~= Keyboard.BACKSPACE or not (#DebugScreen_2.search_string > 0)) then
				local len = string.len(DebugScreen_2.search_string)
				local location = Utf8.location(DebugScreen_2.search_string, len)

				DebugScreen_2.search_string = DebugScreen_2.search_string:sub(1, location - 1)

				if DebugScreen_2.search_string:find(".", 1, true) == nil then
					DebugScreen_2.active_id = nil
				end
			end
		end
	end

	Gui.rect(arg_15_2, var_15_10, Vector2(DebugScreen_2.search_text_box_width, 35), Colors.get_color_with_alpha("dark_olive_green", 225 + math.cos(num_3) * 25))
	Gui.rect(arg_15_2, var_15_9, Vector2(200, 35), Colors.get_color_with_alpha("olive", 225))
	Gui.text(arg_15_2, "Search: ", str_2, font_size, str, var_15_11, Colors.get("white"))
	Gui.text(arg_15_2, DebugScreen_2.search_string, str_2, font_size, str, var_15_12, Colors.get("yellow"))

	local text_extents, var_15_30 = Gui.text_extents(arg_15_2, DebugScreen_2.search_string, str_2, font_size)
	local num_5 = var_15_30.x - text_extents.x

	Gui.rect(arg_15_2, var_15_12 + Vector3(num_5 + 1, -2, 0), Vector2(10, 20), Colors.get_color_with_alpha("white", -50 + math.cos(num_3) * 250))
end

DebugScreen_2.hash_options = function ()
	-- function 16
	local settings_hash = DebugScreen_2.settings_hash

	settings_hash = settings_hash or 0

	return settings_hash
end

DebugScreen_2._propagate_option = function (arg_17_0, arg_17_1, arg_17_2)
	-- function 17
	Managers.state.network.network_transmit:send_rpc_server("rpc_propagate_debug_option", DebugScreen_2.hash_options(), arg_17_0, arg_17_1, arg_17_2)
end

DebugScreen_2.handle_propagated_option = function (arg_18_0, arg_18_1, arg_18_2, arg_18_3)
	-- function 18
	local hash_options = DebugScreen_2.hash_options()

	if hash_options ~= arg_18_0 then
		return string.format("Debug option mismatch (%s ~= %s)", hash_options, arg_18_0)
	end

	local find_func, var_18_2 = table.find_func(DebugScreen_2.console_settings, function (arg_19_0, arg_19_1)
		-- function 19
		return arg_19_1.setting_id == arg_18_1
	end)

	if not var_18_2 then
		return "Missing debug option at index " .. tostring(arg_18_1)
	end

	local sticky_text = Debug.sticky_text
	local str = "[DebugManager] Received propagated debug option '%s' from client"
	local title

	if arg_18_2 == 0 then
		title = var_18_2.title

		if not title then
			-- Nothing
		end
	end

	title = string.format("%s = %s", var_18_2.title, var_18_2.options[arg_18_2])

	::label_18_0::

	sticky_text(str, title, "delay", 5)

	if not var_18_2.func then
		fn_3(var_18_2)
	else
		fn_2(var_18_2, arg_18_2, arg_18_3)
	end
end
