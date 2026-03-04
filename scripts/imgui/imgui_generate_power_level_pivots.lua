-- chunkname: @scripts/imgui/imgui_generate_power_level_pivots.lua

local var_0_0 = require("scripts/utils/serialize")

ImguiGeneratePowerLevelPivots = class(ImguiGeneratePowerLevelPivots)

local var_0_1 = 80
local var_0_2 = 30
local var_0_3 = 30
local var_0_4 = {
	{
		key = "min",
		precision = 0.25,
		type = "float",
		label = "Min:",
		column_width = 85
	},
	{
		key = "max",
		precision = 0.25,
		type = "float",
		label = "Max:",
		column_width = 85
	},
	{
		min = 0.01,
		key = "pivot_power",
		precision = 0.25,
		type = "slider_float",
		label = "Pivot Power:",
		column_width = 210,
		max = function(arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5)
			return arg_1_2.max * 2
		end
	},
	{
		min = 1,
		key = "pivot_level",
		type = "slider_int",
		label = "Level:",
		column_width = 140,
		max = 45
	},
	{
		min = 0.01,
		key = "easing_power",
		precision = 0.1,
		type = "slider_float",
		label = "Easing Power:",
		column_width = 200,
		max = 2
	},
	{
		type = "text",
		label = "Color:",
		column_width = 205,
		data = function(arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5)
			return arg_2_0._colors
		end,
		key = function(arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5)
			return arg_3_1 .. "." .. arg_3_5
		end
	}
}
local var_0_5 = 0

for iter_0_0 = 1, #var_0_4 do
	var_0_5 = var_0_5 + var_0_4[iter_0_0].column_width
end

function ImguiGeneratePowerLevelPivots.init(arg_4_0)
	return
end

function ImguiGeneratePowerLevelPivots._lazy_init(arg_5_0)
	local var_5_0 = arg_5_0:_power_level_settings()

	arg_5_0._default_settings = arg_5_0._default_settings or table.clone(var_5_0)
	arg_5_0._tabs = {
		"Graph",
		"Code"
	}
	arg_5_0._selected_tab = arg_5_0._selected_tab or "Graph"

	local var_5_1 = 0
	local var_5_2 = math.huge

	for iter_5_0, iter_5_1 in pairs(arg_5_0._default_settings.pivots) do
		if var_5_1 < iter_5_1.hi.max then
			var_5_1 = iter_5_1.hi.max
		end

		if var_5_2 > iter_5_1.hi.min then
			var_5_2 = iter_5_1.hi.min
		end

		if var_5_1 < iter_5_1.low.max then
			var_5_1 = iter_5_1.low.max
		end

		if var_5_2 > iter_5_1.low.min then
			var_5_2 = iter_5_1.low.min
		end
	end

	arg_5_0._max_power_level = var_5_1
	arg_5_0._min_power_level = var_5_2
	arg_5_0._colors = {
		normal = {
			hi = "common",
			low = "common"
		},
		hard = {
			hi = "rare",
			low = "rare"
		},
		harder = {
			hi = "exotic",
			low = "exotic"
		},
		hardest = {
			hi = "unique",
			low = "unique"
		}
	}
	arg_5_0._fallback_color = "pale_golden_rod"
	arg_5_0._display_order = {
		harder = 3,
		hard = 2,
		hardest = 4,
		normal = 1
	}
	arg_5_0._easing_functions = {
		{
			inverse = "easeOutCubicInv",
			ease = "easeOutCubic"
		},
		{
			inverse = "linear_inv",
			ease = "linear"
		},
		{
			inverse = "ease_out_quart_inv",
			ease = "ease_out_quart"
		}
	}
	arg_5_0._easing_as_array = table.select_array(arg_5_0._easing_functions, function(arg_6_0, arg_6_1)
		return arg_6_1.ease
	end)
	arg_5_0._easing_func_index = arg_5_0._easing_func_index or 1
	arg_5_0._history = arg_5_0._history or {
		table.clone(arg_5_0._default_settings)
	}
	arg_5_0._history_index = 1
	arg_5_0._filter = ""
end

function ImguiGeneratePowerLevelPivots.is_persistent(arg_7_0)
	return false
end

function ImguiGeneratePowerLevelPivots._power_level_settings(arg_8_0)
	return (Managers.backend:get_interface("loot"):get_power_level_settings())
end

local var_0_6 = true

function ImguiGeneratePowerLevelPivots.update(arg_9_0, arg_9_1, arg_9_2)
	if var_0_6 then
		arg_9_0:_lazy_init()

		var_0_6 = false
	end

	if Keyboard.button(Keyboard.button_index("left ctrl")) > 0 then
		if Keyboard.pressed(Keyboard.button_index("z")) then
			if arg_9_0._history_index > 1 then
				arg_9_0._history_index = arg_9_0._history_index - 1

				Managers.backend:get_interface("loot"):debug_override_power_level_settings(table.clone(arg_9_0._history[arg_9_0._history_index]))
			end
		elseif Keyboard.pressed(Keyboard.button_index("y")) and arg_9_0._history_index + 1 <= #arg_9_0._history then
			arg_9_0._history_index = arg_9_0._history_index + 1

			Managers.backend:get_interface("loot"):debug_override_power_level_settings(table.clone(arg_9_0._history[arg_9_0._history_index]))
		end
	end
end

function ImguiGeneratePowerLevelPivots.on_show(arg_10_0)
	arg_10_0:_lazy_init()
end

function ImguiGeneratePowerLevelPivots.draw(arg_11_0)
	local var_11_0, var_11_1 = Imgui.begin_window("Generate Power Level Pivots", "always_auto_resize", "menu_bar")

	if not var_11_1 then
		return var_11_0
	end

	arg_11_0:_reset_control_id()

	arg_11_0._menu_bar_height = 0

	if Imgui.begin_menu_bar() then
		for iter_11_0, iter_11_1 in ipairs(arg_11_0._tabs) do
			local var_11_2 = arg_11_0._selected_tab ~= iter_11_1 and " " .. iter_11_1 .. " " or "[" .. iter_11_1 .. "]"

			if Imgui.menu_item(var_11_2) then
				arg_11_0._selected_tab = iter_11_1
			end
		end

		Imgui.end_menu_bar()

		arg_11_0.asdf, arg_11_0._menu_bar_height = Imgui.get_item_rect_size()
	end

	local var_11_3 = {
		var_0_5 + 170,
		500
	}
	local var_11_4 = var_11_3[2] + 290

	Imgui.begin_child_window("GraphEditor", var_11_3[1], var_11_4, true, "always_auto_resize")

	local var_11_5 = arg_11_0._selected_tab

	if var_11_5 == "Graph" then
		arg_11_0:_draw_graph(var_11_3)
	elseif var_11_5 == "Code" then
		arg_11_0:_draw_code(var_11_3)
	end

	Imgui.end_child_window()
	Imgui.same_line()

	local var_11_6 = 800

	Imgui.begin_child_window("Summary", var_11_6, var_11_4, true, "always_auto_resize")
	arg_11_0:_draw_summary(var_11_6)
	Imgui.end_child_window()
	Imgui.end_window()

	return var_11_0
end

function ImguiGeneratePowerLevelPivots._reset_control_id(arg_12_0)
	arg_12_0._next_control_id_internal = 0
end

function ImguiGeneratePowerLevelPivots._next_control_id(arg_13_0)
	arg_13_0._next_control_id_internal = arg_13_0._next_control_id_internal + 1

	return tostring(arg_13_0._next_control_id_internal)
end

function ImguiGeneratePowerLevelPivots._nan_backup(arg_14_0, arg_14_1, arg_14_2, arg_14_3)
	if arg_14_1 ~= arg_14_1 then
		return 0, true, arg_14_3
	end

	return arg_14_1, arg_14_2, arg_14_3
end

function ImguiGeneratePowerLevelPivots._draw_graph(arg_15_0, arg_15_1)
	local var_15_0 = Color(180, 100, 100, 100)
	local var_15_1 = Color(255, 255, 255, 255)
	local var_15_2 = Color(255, 255, 255, 255)
	local var_15_3 = Color(255, 255, 255, 255)
	local var_15_4 = Color(255, 255, 0, 0)
	local var_15_5 = 0
	local var_15_6 = 0
	local var_15_7 = arg_15_1[1]
	local var_15_8 = arg_15_1[2]
	local var_15_9 = 20
	local var_15_10 = 20
	local var_15_11 = 0
	local var_15_12 = 0
	local var_15_13 = 1
	local var_15_14 = 2
	local var_15_15 = 10

	Imgui.channel_split(2)
	Imgui.channel_set_current(0)

	local var_15_16, var_15_17 = Imgui.get_cursor_screen_pos()

	Imgui.add_rect_filled(var_15_16 + var_15_5, var_15_17 + var_15_6, var_15_16 + var_15_7 - var_15_5, var_15_17 + var_15_8 - var_15_6, var_15_0, 3)
	Imgui.add_rect(var_15_16 + var_15_5, var_15_17 + var_15_6, var_15_16 + var_15_7 - var_15_5, var_15_17 + var_15_8 - var_15_6, var_15_1, 3, 1)

	local var_15_18 = var_15_16 + var_15_5 + var_15_9 + var_15_11
	local var_15_19 = var_15_17 + var_15_6 + var_15_10 + var_15_12
	local var_15_20 = var_15_16 - var_15_5 - var_15_9 + var_15_7 + var_15_11
	local var_15_21 = var_15_17 - var_15_6 - var_15_10 + var_15_8 + var_15_12
	local var_15_22 = var_15_20 - var_15_18
	local var_15_23 = var_15_21 - var_15_19

	Imgui.add_line(var_15_18 - var_15_15, var_15_21, var_15_20 + var_15_15, var_15_21, var_15_2, var_15_14)
	Imgui.add_line(var_15_18, var_15_19 - var_15_15, var_15_18, var_15_21 + var_15_15, var_15_2, var_15_14)

	local var_15_24 = Color(100, 255, 255, 255)

	Imgui.add_line(var_15_18, var_15_19, var_15_18 + var_15_22, var_15_19, var_15_24)
	Imgui.add_text("300", var_15_18, var_15_19 - 15, Colors.get("white"))
	Imgui.add_line(var_15_18, var_15_19 + var_15_23 * 0.3333333333333333, var_15_18 + var_15_22, var_15_19 + var_15_23 * 0.3333333333333333, var_15_24)
	Imgui.add_text("200", var_15_18, var_15_19 + var_15_23 * 0.3333333333333333 - 15, Colors.get("white"))
	Imgui.add_line(var_15_18, var_15_19 + var_15_23 * 0.6666666666666666, var_15_18 + var_15_22, var_15_19 + var_15_23 * 0.6666666666666666, var_15_24)
	Imgui.add_text("100", var_15_18, var_15_19 + var_15_23 * 0.6666666666666666 - 15, Colors.get("white"))
	Imgui.channel_set_current(1)

	local var_15_25 = var_15_18 + 1 / var_0_2 * var_15_22
	local var_15_26 = var_15_18 + var_15_22
	local var_15_27 = var_15_19
	local var_15_28 = var_15_19 + var_15_23 - var_15_23 * arg_15_0._min_power_level / arg_15_0._max_power_level
	local var_15_29 = 0
	local var_15_30
	local var_15_31 = arg_15_0:_power_level_settings()
	local var_15_32 = var_15_31.pivots
	local var_15_33 = table.clone(var_15_32)

	for iter_15_0, iter_15_1 in pairs(var_15_32) do
		repeat
			if not string.find(iter_15_0, arg_15_0._filter) then
				break
			end

			local var_15_34 = arg_15_0:_graph_colors(iter_15_0)
			local var_15_35 = Colors.color_definitions[var_15_34.hi] and Colors.get(var_15_34.hi) or Colors.get(arg_15_0._fallback_color)
			local var_15_36 = Colors.color_definitions[var_15_34.low] and Colors.get(var_15_34.low) or Colors.get(arg_15_0._fallback_color)
			local var_15_37 = iter_15_1.low.min
			local var_15_38 = iter_15_1.low.max
			local var_15_39 = iter_15_1.hi.min
			local var_15_40 = iter_15_1.hi.max
			local var_15_41 = 1 / var_0_2
			local var_15_42, var_15_43 = LootChestData.calculate_power_level(1, iter_15_1)
			local var_15_44 = var_15_42 / arg_15_0._max_power_level
			local var_15_45 = var_15_43 / arg_15_0._max_power_level
			local var_15_46
			local var_15_47
			local var_15_48, var_15_49 = arg_15_0:_nan_backup(var_15_44, var_15_46)
			local var_15_50, var_15_51 = arg_15_0:_nan_backup(var_15_45, var_15_47)

			for iter_15_2 = 1, var_0_1 do
				local var_15_52 = iter_15_2 / var_0_1

				if var_15_52 * var_0_2 > 1 then
					local var_15_53, var_15_54 = LootChestData.calculate_power_level(var_15_52 * var_0_2, iter_15_1)
					local var_15_55 = var_15_53 / arg_15_0._max_power_level
					local var_15_56 = var_15_54 / arg_15_0._max_power_level
					local var_15_57

					var_15_57, var_15_49 = arg_15_0:_nan_backup(var_15_55, var_15_49)

					local var_15_58

					var_15_58, var_15_51 = arg_15_0:_nan_backup(var_15_56, var_15_51)

					Imgui.add_line(var_15_18 + var_15_22 * var_15_41, var_15_19 + var_15_23 - var_15_23 * var_15_50, var_15_18 + var_15_22 * var_15_52, var_15_19 + var_15_23 - var_15_23 * var_15_58, var_15_35, 1.5)
					Imgui.add_line(var_15_18 + var_15_22 * var_15_41, var_15_19 + var_15_23 - var_15_23 * var_15_48, var_15_18 + var_15_22 * var_15_52, var_15_19 + var_15_23 - var_15_23 * var_15_57, var_15_36, 1.5)

					var_15_41 = var_15_52
					var_15_50 = var_15_58
					var_15_48 = var_15_57
				end
			end

			if var_15_49 then
				var_15_29 = var_15_29 + 1

				local var_15_59, var_15_60 = Imgui.get_cursor_screen_pos()

				Imgui.set_cursor_screen_pos(var_15_18 + 10, var_15_19 + var_15_23 - 20 * var_15_29)
				Imgui.push_style_color(Imgui.COLOR_TEXT, 255, 0, 0, 255)
				Imgui.text("Error: nan value detected in: " .. iter_15_0 .. "; low")
				Imgui.pop_style_color(1)
				Imgui.set_cursor_screen_pos(var_15_59, var_15_60)
			end

			if var_15_51 then
				var_15_29 = var_15_29 + 1

				local var_15_61, var_15_62 = Imgui.get_cursor_screen_pos()

				Imgui.set_cursor_screen_pos(var_15_18 + 10, var_15_19 + var_15_23 - 20 * var_15_29)
				Imgui.push_style_color(Imgui.COLOR_TEXT, 255, 0, 0, 255)
				Imgui.text("Error: nan value detected in: " .. iter_15_0 .. "; high")
				Imgui.pop_style_color(1)
				Imgui.set_cursor_screen_pos(var_15_61, var_15_62)
			end
		until true
	end

	Imgui.channels_merge()
	Imgui.dummy(var_15_7, var_15_8)

	local var_15_63, var_15_64 = Imgui.get_item_rect_min()

	if Imgui.is_item_hovered() then
		local var_15_65 = Mouse.axis(Mouse.axis_id("cursor"))
		local var_15_66, var_15_67 = Imgui.get_window_pos()
		local var_15_68, var_15_69 = Application.resolution()
		local var_15_70 = var_15_65.x
		local var_15_71 = math.clamp(var_15_65.x, var_15_25, var_15_26) - var_15_25
		local var_15_72 = math.round_to_closest_multiple(var_15_71, 1 / var_0_2 * var_15_22)
		local var_15_73 = var_15_25 + var_15_72
		local var_15_74 = math.clamp(var_15_73, var_15_25, var_15_26)
		local var_15_75 = math.clamp(var_15_69 - var_15_65.y + var_0_3, var_15_27, var_15_28)

		Imgui.add_line(var_15_74, var_15_19, var_15_74, var_15_19 + var_15_23, Colors.get("white"))

		local var_15_76 = (1 - (var_15_75 - var_15_19) / var_15_23) * arg_15_0._max_power_level
		local var_15_77 = math.huge
		local var_15_78 = 0
		local var_15_79
		local var_15_80 = math.round(var_15_72 / var_15_22 * var_0_2)

		for iter_15_3, iter_15_4 in pairs(var_15_32) do
			repeat
				if not string.find(iter_15_3, arg_15_0._filter) then
					break
				end

				local var_15_81 = arg_15_0:_graph_colors(iter_15_3)
				local var_15_82 = Colors.color_definitions[var_15_81.hi] and Colors.get(var_15_81.hi) or Colors.get(arg_15_0._fallback_color)
				local var_15_83 = Colors.color_definitions[var_15_81.low] and Colors.get(var_15_81.low) or Colors.get(arg_15_0._fallback_color)
				local var_15_84 = 1 / var_0_2
				local var_15_85, var_15_86 = LootChestData.calculate_power_level(var_15_80, iter_15_4)
				local var_15_87, var_15_88 = math.round(var_15_85), math.round(var_15_86)

				if var_15_77 > math.abs(var_15_87 - var_15_76) then
					var_15_78 = var_15_87
					var_15_77 = math.abs(var_15_87 - var_15_76)
					var_15_79 = var_15_83
				end

				if var_15_77 > math.abs(var_15_88 - var_15_76) then
					var_15_78 = var_15_88
					var_15_77 = math.abs(var_15_88 - var_15_76)
					var_15_79 = var_15_82
				end
			until true
		end

		if var_15_78 ~= 0 then
			local var_15_89 = var_15_19 + var_15_23 - var_15_78 / arg_15_0._max_power_level * var_15_23

			Imgui.add_text(tostring(var_15_78), var_15_74 + 5, var_15_89 - 15, var_15_79)
			Imgui.add_text(tostring(var_15_80), var_15_74, var_15_19 + var_15_23, Colors.get("white"))
		end
	end

	Imgui.dummy(var_15_7, 5)
	Imgui.separator()
	Imgui.dummy(var_15_7, 5)
	Imgui.tree_push(arg_15_0:_next_control_id())
	Imgui.unindent()
	Imgui.text("Easing Function")
	Imgui.same_line()

	arg_15_0._easing_func_index = Imgui.combo("", arg_15_0._easing_func_index, arg_15_0._easing_as_array)

	Imgui.indent()
	Imgui.tree_pop()

	var_15_31.easing_function = arg_15_0._easing_functions[arg_15_0._easing_func_index].ease
	var_15_31.inverse_easing_function = arg_15_0._easing_functions[arg_15_0._easing_func_index].inverse

	Imgui.same_line()
	Imgui.indent(350)
	Imgui.tree_push(arg_15_0:_next_control_id())
	Imgui.unindent()
	Imgui.text("Filter")
	Imgui.same_line()

	arg_15_0._filter = Imgui.input_text("", arg_15_0._filter)

	Imgui.indent()
	Imgui.tree_pop()
	Imgui.unindent(350)
	Imgui.dummy(var_15_7, 5)
	Imgui.separator()
	Imgui.dummy(var_15_7, 5)
	Imgui.columns(8)

	local var_15_90 = arg_15_0:_sorted_pivot_keys(var_15_32)
	local var_15_91

	for iter_15_5 = 1, #var_15_90 do
		repeat
			local var_15_92 = var_15_90[iter_15_5]

			if not string.find(var_15_92, arg_15_0._filter) then
				break
			end

			local var_15_93 = var_15_32[var_15_92]

			Imgui.set_column_width(123)
			Imgui.tree_push(arg_15_0:_next_control_id())
			Imgui.unindent()

			if Imgui.button("x") then
				var_15_32[var_15_92] = nil

				Imgui.indent()
				Imgui.tree_pop()

				break
			end

			Imgui.same_line()
			Imgui.push_item_width(85)

			local var_15_94 = Imgui.input_text("", arg_15_0._pivot_key_original == var_15_92 and arg_15_0._pivot_key_edit or var_15_92)
			local var_15_95 = Imgui.is_item_active()

			Imgui.indent()
			Imgui.tree_pop()
			Imgui.pop_item_width()

			if (var_15_95 or var_15_92 == arg_15_0._pivot_key_original) and var_15_94 ~= var_15_92 then
				if var_15_95 then
					arg_15_0._pivot_key_edit = var_15_94
					arg_15_0._pivot_key_original = var_15_92
				else
					var_15_32[var_15_92] = nil
					var_15_32[var_15_94] = var_15_93
					arg_15_0._pivot_key_edit = nil
					arg_15_0._pivot_key_original = nil

					break
				end
			end

			arg_15_0:_draw_pivot_edit_row(var_15_92, var_15_93.low, "low", 0, "low")
			arg_15_0:_draw_pivot_edit_row(var_15_92, var_15_93.hi, "high", 1, "hi")
			Imgui.next_column()

			var_15_91 = var_15_93
		until true
	end

	Imgui.columns(1)

	if Imgui.button("Add") then
		local var_15_96 = ""

		while var_15_32[var_15_96] do
			var_15_96 = var_15_96 .. " "
		end

		var_15_32[var_15_96] = table.clone(var_15_91) or {
			pivot_level = 30,
			min = 10,
			pivot_power = 300,
			max = 300
		}
	end

	Imgui.same_line()

	if Imgui.button("Reset") then
		Managers.backend:get_interface("loot"):debug_override_power_level_settings(arg_15_0._default_settings)
	end

	if not table.deep_equal(var_15_33, var_15_32) then
		arg_15_0._history_index = arg_15_0._history_index + 1
		arg_15_0._history[arg_15_0._history_index] = table.clone(var_15_31)

		for iter_15_6 = arg_15_0._history_index + 1, #arg_15_0._history do
			arg_15_0._history[iter_15_6] = nil
		end
	end
end

function ImguiGeneratePowerLevelPivots._draw_pivot_edit_row(arg_16_0, arg_16_1, arg_16_2, arg_16_3, arg_16_4, arg_16_5)
	for iter_16_0 = 1, arg_16_4 do
		Imgui.next_column()
	end

	Imgui.next_column()
	Imgui.set_column_width(50)
	Imgui.text(arg_16_3)

	for iter_16_1 = 1, #var_0_4 do
		Imgui.next_column()

		local var_16_0 = var_0_4[iter_16_1]
		local var_16_1 = var_16_0.data and var_16_0.data(arg_16_0, arg_16_1, arg_16_2, arg_16_3, arg_16_4, arg_16_5) or arg_16_2
		local var_16_2 = var_16_0.column_width
		local var_16_3 = var_16_0.label or var_16_0.key
		local var_16_4 = type(var_16_0.key) == "function" and var_16_0.key(arg_16_0, arg_16_1, arg_16_2, var_16_3, arg_16_4, arg_16_5) or var_16_0.key
		local var_16_5 = string.split(var_16_4, ".")
		local var_16_6 = type(var_16_0.max) == "function" and var_16_0.max(arg_16_0, arg_16_1, arg_16_2, var_16_3, arg_16_4, arg_16_5) or var_16_0.max
		local var_16_7 = var_16_0.type

		Imgui.set_column_width(var_16_2)

		local var_16_8 = 0

		if var_16_3 then
			var_16_8 = Imgui.calculate_text_size(var_16_3)

			Imgui.text(var_16_3)
			Imgui.same_line()
		end

		if var_16_5 then
			Imgui.tree_push(arg_16_0:_next_control_id())
			Imgui.unindent()

			for iter_16_2 = 1, #var_16_5 - 1 do
				var_16_1 = var_16_1[var_16_5[iter_16_2]]
			end

			local var_16_9 = var_16_5[#var_16_5]

			Imgui.dummy(var_16_8, 0)
			Imgui.same_line()
			Imgui.push_item_width(var_16_2 - var_16_8)

			if var_16_7 == "float" then
				var_16_1[var_16_9] = Imgui.input_text("", tostring(var_16_1[var_16_9] or 0))
				var_16_1[var_16_9] = tonumber(var_16_1[var_16_9]) or 0
			elseif var_16_7 == "slider_float" then
				var_16_1[var_16_9] = Imgui.slider_float("", var_16_1[var_16_9], var_16_0.min or 0, var_16_6 or 1) or 0
			elseif var_16_7 == "slider_int" then
				var_16_1[var_16_9] = Imgui.slider_int("", var_16_1[var_16_9], var_16_0.min or 0, var_16_6 or 1) or 0
			elseif var_16_7 == "text" then
				var_16_1[var_16_9] = Imgui.input_text("", var_16_1[var_16_9]) or ""
			end

			Imgui.pop_item_width()

			if var_16_0.precision then
				var_16_1[var_16_9] = math.round_to_closest_multiple(var_16_1[var_16_9], var_16_0.precision)
			end

			Imgui.indent()
			Imgui.tree_pop()
		end
	end
end

function ImguiGeneratePowerLevelPivots._draw_code(arg_17_0, arg_17_1)
	Imgui.push_item_width(arg_17_1[1])

	local var_17_0 = arg_17_0:_power_level_settings()
	local var_17_1 = var_0_0.save_simple(var_17_0)
	local var_17_2 = Imgui.input_text_multiline("", var_17_1, arg_17_1[2])
	local var_17_3, var_17_4 = pcall(function()
		return cjson.decode(var_17_2)
	end)

	if var_17_3 then
		Managers.backend:get_interface("loot"):debug_override_power_level_settings(var_17_4)
	else
		local var_17_5 = "Error: " .. var_17_4

		Imgui.text(var_17_5)
	end

	Imgui.text("Code doesn't support clipboard. Need to implement serializer.")
	Imgui.pop_item_width()
end

function ImguiGeneratePowerLevelPivots._draw_summary(arg_19_0, arg_19_1)
	local var_19_0 = arg_19_0:_power_level_settings().pivots
	local var_19_1 = arg_19_0:_sorted_pivot_keys(var_19_0)
	local var_19_2 = 47
	local var_19_3 = (arg_19_1 - 47) / #var_19_1 * 0.5

	Imgui.columns(1 + #var_19_1 * 2)
	Imgui.set_column_width(var_19_2)
	Imgui.text("Level")

	for iter_19_0 = 1, #var_19_1 do
		local var_19_4 = var_19_1[iter_19_0]
		local var_19_5 = var_19_0[var_19_4]
		local var_19_6 = DifficultySettings[var_19_4]
		local var_19_7 = var_19_6 and var_19_6.display_name and Localize(var_19_6.display_name) or var_19_4

		Imgui.next_column()
		Imgui.set_column_width(var_19_3)
		Imgui.text(var_19_7 .. " min")
		Imgui.next_column()
		Imgui.set_column_width(var_19_3)
		Imgui.text(var_19_7 .. " max")
	end

	Imgui.separator()

	for iter_19_1 = 1, var_0_2 do
		Imgui.next_column()
		Imgui.set_column_width(var_19_2)
		Imgui.text(iter_19_1)

		for iter_19_2 = 1, #var_19_1 do
			local var_19_8 = var_19_1[iter_19_2]
			local var_19_9 = var_19_0[var_19_8]
			local var_19_10 = arg_19_0:_graph_colors(var_19_8)
			local var_19_11 = var_19_10.hi
			local var_19_12 = var_19_10.low
			local var_19_13, var_19_14 = LootChestData.calculate_power_level(iter_19_1, var_19_9)

			Imgui.push_style_color(Imgui.COLOR_TEXT, unpack(Colors.get_table_rgba(var_19_11)))
			Imgui.next_column()
			Imgui.set_column_width(var_19_3)
			Imgui.text(math.round(var_19_13))
			Imgui.push_style_color(Imgui.COLOR_TEXT, unpack(Colors.get_table_rgba(var_19_12)))
			Imgui.next_column()
			Imgui.set_column_width(var_19_3)
			Imgui.text(math.round(var_19_14))
			Imgui.pop_style_color(2)
		end

		Imgui.separator()

		if iter_19_1 % 5 == 0 and iter_19_1 ~= var_0_2 then
			Imgui.separator()
		end
	end
end

function ImguiGeneratePowerLevelPivots._sorted_pivot_keys(arg_20_0, arg_20_1)
	local var_20_0 = table.keys(arg_20_1)

	table.sort(var_20_0, function(arg_21_0, arg_21_1)
		if arg_20_0._display_order[arg_21_0] then
			return arg_20_0._display_order[arg_21_0] < (arg_20_0._display_order[arg_21_1] or math.huge)
		elseif arg_20_0._display_order[arg_21_1] then
			return false
		end

		return arg_21_0 < arg_21_1
	end)

	return var_20_0
end

function ImguiGeneratePowerLevelPivots._graph_colors(arg_22_0, arg_22_1)
	arg_22_0._colors[arg_22_1] = arg_22_0._colors[arg_22_1] or {
		hi = arg_22_0._fallback_color,
		low = arg_22_0._fallback_color
	}

	return {
		hi = Colors.color_definitions[arg_22_0._colors[arg_22_1].hi] and arg_22_0._colors[arg_22_1].hi or arg_22_0._fallback_color,
		low = Colors.color_definitions[arg_22_0._colors[arg_22_1].low] and arg_22_0._colors[arg_22_1].low or arg_22_0._fallback_color
	}
end
