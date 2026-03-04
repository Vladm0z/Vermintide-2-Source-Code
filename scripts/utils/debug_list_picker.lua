-- chunkname: @scripts/utils/debug_list_picker.lua

DebugListPicker = class(DebugListPicker)

local var_0_0 = 22
local var_0_1 = "arial"
local var_0_2 = "materials/fonts/" .. var_0_1
local var_0_3 = 22
local var_0_4 = 10
local var_0_5 = 20

DebugListPicker.init = function (arg_1_0, arg_1_1, arg_1_2, arg_1_3)
	arg_1_0.pick_list = arg_1_1
	arg_1_0.save_data_name = arg_1_2
	arg_1_0._item_validation_func = arg_1_3 or function ()
		return true
	end
	arg_1_0.column_index, arg_1_0.row_index = 1, 1
	arg_1_0.move_cursor_timer = 0
	arg_1_0.gui = Debug.gui
	arg_1_0.font_mtrl = var_0_2
	arg_1_0.font = var_0_1
	arg_1_0.font_size = var_0_0

	arg_1_0:setup(arg_1_2)

	arg_1_0.column = arg_1_0.pick_list[arg_1_0.column_index]
	arg_1_0.item = arg_1_0.column[arg_1_0.row_index] or "?"
	arg_1_0.max_cols_seen = 3
end

DebugListPicker.destroy = function (arg_3_0)
	return
end

DebugListPicker.setup = function (arg_4_0)
	local var_4_0 = SaveData[arg_4_0.save_data_name]

	var_4_0 = type(var_4_0) == "table" and var_4_0 or {
		last_column_index = 1,
		columns = {}
	}
	arg_4_0.save_data = var_4_0

	local var_4_1 = var_4_0.columns

	arg_4_0.column_index = var_4_1[var_4_0.last_column_index] and var_4_0.last_column_index or 1
	arg_4_0.row_index = var_4_1[arg_4_0.column_index] and var_4_1[arg_4_0.column_index].row_index or 1

	local var_4_2
	local var_4_3 = 0
	local var_4_4 = 0
	local var_4_5 = arg_4_0.pick_list
	local var_4_6 = 0

	arg_4_0.column_index = var_4_5[arg_4_0.column_index] and arg_4_0.column_index or 1
	arg_4_0.column = var_4_5[arg_4_0.column_index]
	arg_4_0.row_index = arg_4_0.column[arg_4_0.row_index] and arg_4_0.row_index or 1
	arg_4_0.item = arg_4_0.column[arg_4_0.row_index]

	for iter_4_0 = 1, #var_4_5 do
		local var_4_7 = var_4_5[iter_4_0]

		var_4_7.last_row_index = var_4_1[iter_4_0] and var_4_1[iter_4_0].row_index or 1

		local var_4_8 = #var_4_7

		if var_4_6 < var_4_8 then
			var_4_6 = var_4_8
		end

		for iter_4_1 = 1, var_4_8 do
			local var_4_9 = var_4_7[iter_4_1][1] .. "(Load)"
			local var_4_10, var_4_11 = Gui.text_extents(arg_4_0.gui, var_4_9:upper(), arg_4_0.font_mtrl, arg_4_0.font_size)
			local var_4_12 = var_4_11.x - var_4_10.x
			local var_4_13 = var_4_11.y - var_4_10.y

			if var_4_3 < var_4_12 then
				var_4_3 = var_4_12
			end

			if var_4_4 < var_4_13 then
				var_4_4 = var_4_13
			end
		end
	end

	arg_4_0.max_height = var_4_4
	arg_4_0.max_width = var_4_3 + 40
	arg_4_0.max_rows = var_4_6 + 1
end

DebugListPicker.activate = function (arg_5_0)
	arg_5_0.active = not arg_5_0.active

	DebugScreen.set_blocked(arg_5_0.active)

	if not arg_5_0.active and arg_5_0.save_data_name then
		local var_5_0 = arg_5_0.pick_list
		local var_5_1 = arg_5_0.save_data
		local var_5_2 = var_5_1.columns or {}

		var_5_1.columns = var_5_2
		var_5_1.last_column_index = arg_5_0.column_index

		for iter_5_0 = 1, #var_5_0 do
			local var_5_3 = var_5_0[iter_5_0]

			var_5_2[iter_5_0] = var_5_2[iter_5_0] or {}
			var_5_2[iter_5_0].row_index = var_5_3.last_row_index
		end

		SaveData[arg_5_0.save_data_name] = var_5_1

		Managers.save:auto_save(SaveFileName, SaveData)
	end
end

DebugListPicker.current_item = function (arg_6_0)
	return arg_6_0.item
end

DebugListPicker.current_item_name = function (arg_7_0)
	return arg_7_0.item[1]
end

DebugListPicker._sort_column = function (arg_8_0, arg_8_1)
	local var_8_0 = arg_8_0._item_validation_func

	table.sort(arg_8_1, function (arg_9_0, arg_9_1)
		local var_9_0 = not not var_8_0(arg_9_0[1])

		if var_9_0 == not not var_8_0(arg_9_1[1]) then
			return arg_9_0[1] < arg_9_1[1]
		elseif var_9_0 then
			return true
		end

		return false
	end)
end

DebugListPicker.update = function (arg_10_0, arg_10_1, arg_10_2)
	if not arg_10_0.active then
		return
	end

	local var_10_0 = Application.time_since_launch()
	local var_10_1 = arg_10_0.pick_list
	local var_10_2 = arg_10_0.column
	local var_10_3 = arg_10_0.item
	local var_10_4 = arg_10_0.row_index

	if DebugKeyHandler.key_pressed("right_key", "switch spawn category", "ai") then
		arg_10_0.column_index = arg_10_0.column_index + 1
		arg_10_0.column_index = (arg_10_0.column_index - 1) % #var_10_1 + 1
		arg_10_0.column = arg_10_0.pick_list[arg_10_0.column_index]
		arg_10_0.row_index = math.clamp(arg_10_0.column.last_row_index or arg_10_0.row_index, 1, #arg_10_0.column)
	end

	if DebugKeyHandler.key_pressed("left_key", "switch spawn category", "ai") then
		arg_10_0.column_index = arg_10_0.column_index - 1
		arg_10_0.column_index = (arg_10_0.column_index - 1) % #var_10_1 + 1
		arg_10_0.column = arg_10_0.pick_list[arg_10_0.column_index]
		arg_10_0.row_index = math.clamp(arg_10_0.column.last_row_index or arg_10_0.row_index, 1, #arg_10_0.column)
	end

	if DebugKeyHandler.key_pressed("up_key", "switch spawn category", "ai") and var_10_0 > arg_10_0.move_cursor_timer then
		arg_10_0.row_index = arg_10_0.row_index - 1
		arg_10_0.row_index = (arg_10_0.row_index - 1) % #var_10_2 + 1
		arg_10_0.move_cursor_timer = var_10_0 + 0.1
		var_10_2.last_row_index = arg_10_0.row_index
	end

	if DebugKeyHandler.key_pressed("down_key", "switch spawn category", "ai") and var_10_0 > arg_10_0.move_cursor_timer then
		arg_10_0.row_index = arg_10_0.row_index + 1
		arg_10_0.row_index = (arg_10_0.row_index - 1) % #var_10_2 + 1
		arg_10_0.move_cursor_timer = var_10_0 + 0.1
		var_10_2.last_row_index = arg_10_0.row_index
	end

	local var_10_5 = var_10_4 == arg_10_0.row_index

	arg_10_0.item = arg_10_0.column[arg_10_0.row_index]

	if not script_data.disable_debug_draw then
		local var_10_6 = arg_10_0.item
		local var_10_7 = arg_10_0.column
		local var_10_8 = arg_10_0.column_index
		local var_10_9 = #arg_10_0.pick_list
		local var_10_10 = var_10_8 - 1
		local var_10_11 = var_10_8 + 1

		if var_10_8 == 1 then
			var_10_10 = 1
			var_10_11 = var_10_10 + (arg_10_0.max_cols_seen - 1)
		elseif var_10_8 == var_10_9 then
			var_10_10 = var_10_9 - (arg_10_0.max_cols_seen - 1)
			var_10_11 = var_10_9
		end

		local var_10_12 = RESOLUTION_LOOKUP.res_w
		local var_10_13 = RESOLUTION_LOOKUP.res_h
		local var_10_14 = 0.85
		local var_10_15 = arg_10_0.font_size * (var_0_5 + 1) + var_0_4
		local var_10_16 = ""
		local var_10_17
		local var_10_18 = Color(200, 100, 0)
		local var_10_19 = Color(255, 155, 0)
		local var_10_20 = Vector3(5, var_10_13 - 80 - var_0_3, 900)
		local var_10_21 = Vector3.copy(var_10_20)
		local var_10_22

		for iter_10_0 = var_10_10, var_10_11 do
			local var_10_23 = var_10_1[iter_10_0]

			if var_10_7 == var_10_23 then
				var_10_22 = var_10_7
				var_10_16 = string.upper(var_10_23.name)
				var_10_17 = var_10_19
			else
				var_10_16 = var_10_23.name
				var_10_17 = var_10_18
			end

			Gui.text(arg_10_0.gui, var_10_16, arg_10_0.font_mtrl, arg_10_0.font_size, arg_10_0.font, var_10_21, var_10_17)

			local var_10_24, var_10_25 = Gui.text_extents(arg_10_0.gui, var_10_16, arg_10_0.font_mtrl, arg_10_0.font_size)
			local var_10_26 = var_10_25.x - var_10_24.x + var_0_4

			var_10_21.x = var_10_21.x + var_10_26
		end

		if var_10_22.column_run_func then
			var_10_22.column_run_func(arg_10_0, var_10_6, var_10_21)
		end

		arg_10_0:_sort_column(var_10_7)

		if var_10_5 and arg_10_0.item and arg_10_0._last_selected_item and arg_10_0.item ~= arg_10_0._last_selected_item then
			local var_10_27 = table.find_func(var_10_7, function (arg_11_0, arg_11_1)
				return type(arg_11_1) == "table" and arg_11_1[1] == arg_10_0._last_selected_item[1]
			end)

			if var_10_27 then
				arg_10_0.row_index = var_10_27
			end
		else
			arg_10_0._last_selected_item = arg_10_0.item
		end

		local var_10_28 = math.clamp(arg_10_0.row_index - var_0_5 + 1, 1, #var_10_7)
		local var_10_29 = math.min(#var_10_7, var_0_5) + (var_10_28 - 1)

		for iter_10_1 = var_10_28, var_10_29 do
			local var_10_30 = var_10_20 - Vector3(0, (iter_10_1 - var_10_28 + 1) * var_0_3, 0)
			local var_10_31 = var_10_7[iter_10_1][1]

			if var_10_22.row_func then
				var_10_31 = var_10_31 .. var_10_22.row_func(arg_10_0, var_10_7[iter_10_1])
			end

			local var_10_32 = arg_10_0._item_validation_func(var_10_31)

			if not var_10_32 then
				var_10_31 = var_10_31 .. " (Load)"
			end

			if iter_10_1 == arg_10_0.row_index then
				Gui.text(arg_10_0.gui, " > " .. var_10_31:upper(), arg_10_0.font_mtrl, arg_10_0.font_size, arg_10_0.font, var_10_30, var_10_32 and Color(200, 200, 200) or Color(100, 50, 200, 0))
			else
				Gui.text(arg_10_0.gui, "     " .. var_10_31, arg_10_0.font_mtrl, arg_10_0.font_size, arg_10_0.font, var_10_30, var_10_32 and Color(50, 200, 0) or Color(100, 50, 200, 0))
			end
		end

		Gui.rect(arg_10_0.gui, Vector3(5, var_10_13 - var_10_15 - 80, 899), Vector3(arg_10_0.max_width, var_10_15, 899), Color(230 * var_10_14, 10, 10, 10))
	end
end
