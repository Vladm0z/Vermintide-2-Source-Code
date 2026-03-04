-- chunkname: @scripts/utils/edit_ai_utility.lua

local var_0_0 = require("scripts/utils/serialize")
local var_0_1 = 26
local var_0_2 = "arial"
local var_0_3 = "materials/fonts/" .. var_0_2
local var_0_4 = 16
local var_0_5 = "arial"
local var_0_6 = "materials/fonts/" .. var_0_5
local var_0_7 = {}
local var_0_8, var_0_9 = Application.resolution()
local var_0_10 = {
	x = 300,
	y = 300
}
local var_0_11 = 30
local var_0_12 = 30
local var_0_13 = var_0_12 * 0.5
local var_0_14 = {}
local var_0_15 = {}
local var_0_16 = false
local var_0_17 = false
local var_0_18 = {}
local var_0_19 = {
	x = 250,
	y = var_0_9 - var_0_10.y - 200
}
local var_0_20 = 3
local var_0_21 = 2
local var_0_22 = 1

for iter_0_0 = 0, var_0_21 - 1 do
	for iter_0_1 = 0, var_0_20 - 1 do
		local var_0_23 = var_0_19.x + var_0_10.x * iter_0_1 + iter_0_1 * var_0_11
		local var_0_24 = var_0_19.y - (var_0_10.y * iter_0_0 + var_0_11 * iter_0_0)

		var_0_15[var_0_22] = {
			x = var_0_23,
			y = var_0_24
		}
		var_0_18[var_0_22] = {
			value = 0,
			index = var_0_22,
			x = var_0_23 + var_0_10.x - var_0_13 / 2,
			y = var_0_24 - var_0_12 / 2
		}
		var_0_22 = var_0_22 + 1
	end
end

local var_0_25 = {}
local var_0_26 = var_0_12

for iter_0_2, iter_0_3 in pairs(UtilityConsiderations) do
	var_0_25[#var_0_25 + 1] = iter_0_2
	var_0_26 = var_0_26 + var_0_12
end

local var_0_27 = {
	size_x = 200,
	x = 30,
	y = var_0_9 - var_0_26
}
local var_0_28 = considerations or false

local function var_0_29(arg_1_0)
	if not UtilityConsiderations[arg_1_0] then
		print("No utility action named:", arg_1_0)

		return
	end

	var_0_14 = {}

	for iter_1_0, iter_1_1 in pairs(UtilityConsiderations[arg_1_0]) do
		if iter_1_0 ~= "name" then
			var_0_14[#var_0_14 + 1] = iter_1_0
		end
	end

	local var_1_0 = #var_0_14

	var_0_28 = UtilityConsiderations[arg_1_0]
end

if not var_0_28 then
	local var_0_30 = #var_0_25

	var_0_29(var_0_25[var_0_30])

	var_0_7.selected_action = var_0_30
end

EditAiUtility = class(EditAiUtility)

EditAiUtility.init = function (arg_2_0, arg_2_1)
	arg_2_0.world = arg_2_1
	arg_2_0.world_gui = World.create_world_gui(arg_2_1, Matrix4x4.identity(), 1, 1, "immediate", "material", "materials/fonts/gw_fonts")
	arg_2_0.screen_gui = World.create_screen_gui(arg_2_0.world, "material", "materials/fonts/gw_fonts", "immediate")
end

EditAiUtility.activate = function (arg_3_0)
	ShowCursorStack.show("EditAiUtility")
end

EditAiUtility.deactivate = function (arg_4_0)
	ShowCursorStack.hide("EditAiUtility")
end

EditAiUtility.use_breed = function (arg_5_0, arg_5_1)
	return
end

EditAiUtility.update = function (arg_6_0, arg_6_1, arg_6_2, arg_6_3, arg_6_4, arg_6_5)
	local var_6_0 = arg_6_4:get("cursor")

	var_0_7.left_pressed = arg_6_4:get("mouse_left_held")

	if not var_0_7.selected_drag_point then
		var_0_7.hover_win_name, var_0_7.win_pos = arg_6_0:hover_win(arg_6_2, var_6_0, var_0_15, var_0_10)

		local var_6_1 = var_0_7.hover_win_name and var_0_28[var_0_7.hover_win_name].spline
		local var_6_2

		if var_6_1 and var_6_1 == var_0_7.last_hover_spline then
			local var_6_3 = var_0_7.win_pos

			var_0_7.hover_point = arg_6_0:hover_spline_point(arg_6_2, var_6_1, var_6_3, var_0_10, var_6_0)

			if var_0_7.hover_point and var_0_7.left_pressed and not var_0_7.selected_point then
				var_0_7.selected_point = var_0_7.hover_point
				var_0_7.last_selected_point = var_0_7.hover_point
			elseif var_0_7.selected_point and not var_0_7.left_pressed then
				var_0_7.selected_point = nil
			end

			if var_0_7.selected_point then
				arg_6_0:move_spline_point(arg_6_2, var_6_1, var_6_3, var_0_10, var_0_7.selected_point, var_6_0)
				arg_6_0:draw_mouse_selection(arg_6_2, var_6_1, var_6_3, var_0_10, var_0_7.selected_point, "selected", var_0_28[var_0_7.hover_win_name].max_value)
			elseif var_0_7.hover_point then
				arg_6_0:draw_mouse_selection(arg_6_2, var_6_1, var_6_3, var_0_10, var_0_7.hover_point, "hover", var_0_28[var_0_7.hover_win_name].max_value)
			end

			if var_0_7.hover_point and DebugKeyHandler.key_pressed("d", "remove selected point", "ai editor", "left ctrl") then
				arg_6_0:remove_spline_point(var_6_1, var_0_7.hover_point)

				var_0_7.last_selected_point = nil
				var_0_7.hover_point = nil

				return
			end
		else
			var_0_7.selected_point = nil
			var_0_7.last_selected_point = nil
		end

		var_0_7.last_hover_spline = var_6_1

		if not var_0_7.hover_point and var_0_7.hover_win_name and DebugKeyHandler.key_pressed("a", "insert spline point", "ai editor", "left ctrl") then
			arg_6_0:insert_spline_point(var_6_1, var_0_7.win_pos, var_0_10, var_6_0)
		end
	end

	var_0_7.hover_drag_point = arg_6_0:hover_drag_points(arg_6_2, var_0_18, var_6_0)

	if var_0_7.hover_drag_point and var_0_7.left_pressed and not var_0_7.selected_drag_point then
		var_0_7.selected_drag_point = var_0_7.hover_drag_point
	elseif var_0_7.selected_drag_point then
		local var_6_4 = var_0_7.selected_drag_point
		local var_6_5 = 16

		arg_6_0:draw_safe_drag_lane(var_6_4, var_6_5)

		local var_6_6 = var_0_28[var_0_14[var_6_4.index]]

		if var_0_7.left_pressed then
			local var_6_7 = var_6_6.max_value
			local var_6_8, var_6_9 = EditAiUtility:drag_point_distance(arg_6_2, var_6_4, var_6_0)

			if var_6_5 > math.abs(var_6_9) and math.abs(var_6_8) > 0 then
				local var_6_10

				if var_6_8 > 0 then
					var_6_10 = 0.01 * math.pow(var_6_8, 1.2) + var_6_7
				else
					var_6_10 = -0.01 * math.pow(-var_6_8, 1.2) + var_6_7
				end

				local var_6_11 = math.floor(var_6_10 * 10) / 10

				var_0_7.selected_drag_point.max_value = var_6_11 >= 0 and var_6_11 or 0
			else
				var_0_7.selected_drag_point.max_value = nil
			end
		else
			local var_6_12, var_6_13 = EditAiUtility:drag_point_distance(arg_6_2, var_6_4, var_6_0)

			if var_6_5 > math.abs(var_6_13) and var_6_4.max_value then
				var_6_6.max_value = var_6_4.max_value
			end

			var_0_7.selected_drag_point = nil
		end
	end

	local var_6_14 = 1
	local var_6_15 = Vector2(var_0_10.x, var_0_10.y)
	local var_6_16 = arg_6_0.screen_gui
	local var_6_17 = 0
	local var_6_18 = var_0_28

	for iter_6_0, iter_6_1 in pairs(var_0_28) do
		if type(iter_6_1) == "table" and not iter_6_1.is_condition then
			local var_6_19 = Vector2(var_0_15[var_6_14].x, var_0_15[var_6_14].y)
			local var_6_20 = iter_6_0 == var_0_7.hover_win_name and Color(192, 28, 128, 44) or Color(92, 28, 128, 44)
			local var_6_21 = 1

			if var_0_7.selected_drag_point then
				local var_6_22 = var_0_7.selected_drag_point.max_value

				if var_0_7.selected_drag_point.index == var_6_14 then
					EditAiUtility.draw_utility_spline(var_6_16, arg_6_2, iter_6_1, var_6_22, iter_6_0, var_6_19, var_6_15, var_6_20, 1)
					EditAiUtility.draw_utility_info(var_6_16, iter_6_1, var_6_22, iter_6_0, var_6_19, var_6_15, var_6_21)
				else
					EditAiUtility.draw_utility_spline(var_6_16, arg_6_2, iter_6_1, nil, iter_6_0, var_6_19, var_6_15, var_6_20, 0.25)
					EditAiUtility.draw_utility_info(var_6_16, iter_6_1, var_6_22, iter_6_0, var_6_19, var_6_15, var_6_21)
				end
			else
				EditAiUtility.draw_utility_spline(var_6_16, arg_6_2, iter_6_1, nil, iter_6_0, var_6_19, var_6_15, var_6_20, 1)
				EditAiUtility.draw_utility_info(var_6_16, iter_6_1, nil, iter_6_0, var_6_19, var_6_15, var_6_21)
			end

			arg_6_0:draw_utility_ruler(var_6_16, iter_6_1, var_6_19, var_6_15, 1)

			if arg_6_5 then
				local var_6_23 = var_0_7.selected_action and var_0_25[var_0_7.selected_action]

				var_6_17 = var_6_17 + EditAiUtility.draw_realtime_utility(var_6_16, var_6_23, iter_6_1, var_6_19, var_6_15, arg_6_5)

				local var_6_24 = arg_6_5.breed.name
				local var_6_25 = BreedActions[var_6_24]

				for iter_6_2, iter_6_3 in pairs(var_6_25) do
					repeat
						local var_6_26 = iter_6_3.considerations

						if not var_6_26 then
							break
						end

						if UtilityConsiderationNames[var_6_26] ~= var_6_23 then
							break
						end

						for iter_6_4, iter_6_5 in pairs(var_6_26) do
							if iter_6_4 == iter_6_1.name then
								iter_6_5.spline = table.clone(iter_6_1.spline)
								iter_6_5.max_value = iter_6_1.max_value
							end
						end
					until true
				end
			end
		end

		var_6_14 = var_6_14 + 1
	end

	if arg_6_5 then
		local var_6_27 = Vector2(var_0_15[1].x, var_0_15[1].y)
	end

	if DebugKeyHandler.key_pressed("s", "save to disk", "ai editor", "left ctrl") then
		arg_6_0:save_considerations()
	end

	var_0_7.hover_action_window, var_0_7.hover_action = arg_6_0:hover_action(arg_6_2, var_0_27, var_0_25, var_6_0)

	if var_0_7.hover_action_window and var_0_7.left_pressed and var_0_7.hover_action then
		var_0_7.selected_action = var_0_7.hover_action

		var_0_29(var_0_25[var_0_7.selected_action], var_0_7.selected_action)
	end

	local var_6_28 = var_0_7.hover_action_window and Color(164, 28, 44, 100) or Color(92, 28, 44, 100)

	arg_6_0:draw_action_list(arg_6_1, arg_6_2, "Actions", var_0_27, var_0_25, var_6_28, var_0_7.selected_action, arg_6_5)
end

EditAiUtility.insert_spline_point = function (arg_7_0, arg_7_1, arg_7_2, arg_7_3, arg_7_4)
	local var_7_0 = (arg_7_4.x - arg_7_2.x) / arg_7_3.x
	local var_7_1 = (arg_7_4.y - arg_7_2.y) / arg_7_3.y
	local var_7_2

	for iter_7_0 = 1, #arg_7_1, 2 do
		if var_7_0 < arg_7_1[iter_7_0] then
			var_7_2 = iter_7_0

			break
		end
	end

	if var_7_2 then
		for iter_7_1 = #arg_7_1, var_7_2, -1 do
			arg_7_1[iter_7_1 + 2] = arg_7_1[iter_7_1]
		end

		arg_7_1[var_7_2] = var_7_0
		arg_7_1[var_7_2 + 1] = var_7_1
	end
end

EditAiUtility.remove_spline_point = function (arg_8_0, arg_8_1, arg_8_2)
	local var_8_0 = 1
	local var_8_1 = #arg_8_1 - 1

	if arg_8_2 == var_8_0 or arg_8_2 == var_8_1 then
		return
	end

	for iter_8_0 = arg_8_2, #arg_8_1 - 2 do
		arg_8_1[iter_8_0] = arg_8_1[iter_8_0 + 2]
	end

	arg_8_1[#arg_8_1] = nil
	arg_8_1[#arg_8_1] = nil
end

EditAiUtility.hover_win = function (arg_9_0, arg_9_1, arg_9_2, arg_9_3, arg_9_4)
	local var_9_0 = arg_9_2.x
	local var_9_1 = arg_9_2.y
	local var_9_2 = 1
	local var_9_3 = 10

	for iter_9_0 = 1, #var_0_14 do
		if var_9_0 >= arg_9_3[iter_9_0].x - var_9_3 and var_9_0 <= arg_9_3[iter_9_0].x + arg_9_4.x + var_9_3 and var_9_1 >= arg_9_3[iter_9_0].y - var_9_3 and var_9_1 <= arg_9_3[iter_9_0].y + arg_9_4.y + var_9_3 then
			return var_0_14[iter_9_0], arg_9_3[iter_9_0]
		end

		iter_9_0 = iter_9_0 + 1
	end
end

EditAiUtility.move_spline_point = function (arg_10_0, arg_10_1, arg_10_2, arg_10_3, arg_10_4, arg_10_5, arg_10_6)
	local var_10_0 = 1
	local var_10_1 = #arg_10_2 - 1
	local var_10_2 = (arg_10_6.x - arg_10_3.x) / arg_10_4.x
	local var_10_3 = (arg_10_6.y - arg_10_3.y) / arg_10_4.y

	if var_10_0 < arg_10_5 and arg_10_5 < var_10_1 and var_10_2 > arg_10_2[arg_10_5 - 2] and var_10_2 < arg_10_2[arg_10_5 + 2] then
		arg_10_2[arg_10_5] = var_10_2
	end

	if var_10_3 >= 0 and var_10_3 <= 1 then
		arg_10_2[arg_10_5 + 1] = var_10_3
	end
end

local var_0_31 = 20

EditAiUtility.hover_spline_point = function (arg_11_0, arg_11_1, arg_11_2, arg_11_3, arg_11_4, arg_11_5)
	local var_11_0 = arg_11_0.screen_gui
	local var_11_1, var_11_2 = Application.resolution()
	local var_11_3 = arg_11_4.x
	local var_11_4 = arg_11_4.y

	for iter_11_0 = 1, #arg_11_2, 2 do
		local var_11_5 = arg_11_3.x + var_11_3 * arg_11_2[iter_11_0]
		local var_11_6 = arg_11_3.y + var_11_4 * arg_11_2[iter_11_0 + 1]

		if math.abs(var_11_5 - arg_11_5.x) < var_0_31 and math.abs(var_11_6 - arg_11_5.y) < var_0_31 then
			return iter_11_0, var_11_5, var_11_6
		end
	end
end

EditAiUtility.drag_point_distance = function (arg_12_0, arg_12_1, arg_12_2, arg_12_3)
	local var_12_0 = arg_12_3.x
	local var_12_1 = arg_12_3.y
	local var_12_2 = 10
	local var_12_3 = var_12_0 - arg_12_2.x

	var_12_3 = var_12_2 > math.abs(var_12_3) and 0 or var_12_3 - (var_12_3 > 0 and var_12_2 or -var_12_2)

	local var_12_4 = var_12_1 - arg_12_2.y

	var_12_4 = var_12_2 > math.abs(var_12_4) and 0 or var_12_4 - (var_12_4 > 0 and var_12_2 or -var_12_2)

	return var_12_3, var_12_4
end

EditAiUtility.hover_drag_points = function (arg_13_0, arg_13_1, arg_13_2, arg_13_3)
	local var_13_0 = arg_13_0.screen_gui
	local var_13_1 = arg_13_3.x
	local var_13_2 = arg_13_3.y
	local var_13_3 = 15

	for iter_13_0 = 1, #arg_13_2 do
		local var_13_4 = arg_13_2[iter_13_0]

		if var_13_1 > var_13_4.x - var_13_3 and var_13_1 < var_13_4.x + var_13_3 and var_13_2 > var_13_4.y - var_13_3 and var_13_2 < var_13_4.y + var_13_3 then
			EditAiUtility.draw_square(var_13_0, arg_13_1, Vector2(var_13_4.x, var_13_4.y), var_0_13, Color(255, 255, 255, 255), 3)

			return var_13_4
		end
	end
end

EditAiUtility.draw_mouse_selection = function (arg_14_0, arg_14_1, arg_14_2, arg_14_3, arg_14_4, arg_14_5, arg_14_6, arg_14_7)
	local var_14_0 = arg_14_0.screen_gui
	local var_14_1, var_14_2 = Application.resolution()
	local var_14_3 = arg_14_4.x
	local var_14_4 = arg_14_4.y
	local var_14_5 = Color(128, 45, 45, 196)
	local var_14_6 = arg_14_5
	local var_14_7 = arg_14_3.x + var_14_3 * arg_14_2[var_14_6]
	local var_14_8 = arg_14_3.y + var_14_4 * arg_14_2[var_14_6 + 1]
	local var_14_9 = arg_14_6 == "selected" and 20 or 30
	local var_14_10 = arg_14_6 == "last_selected" and 2 or 5
	local var_14_11 = Vector2(var_14_7, var_14_8)

	EditAiUtility.draw_square(var_14_0, arg_14_1, var_14_11, var_14_9, var_14_5, var_14_10)

	local var_14_12 = string.format("x:%.2f / %.2f y:%.2f ", arg_14_2[var_14_6], arg_14_7 * arg_14_2[var_14_6], arg_14_2[var_14_6 + 1])
	local var_14_13 = string.format("x:%.2f (%.2f, %.2f) ", arg_14_7 * arg_14_2[var_14_6], arg_14_2[var_14_6], arg_14_2[var_14_6 + 1])
	local var_14_14 = Vector3(var_14_7 + 20, var_14_8, 30)

	ScriptGUI.text(var_14_0, var_14_13, var_0_3, 32, var_0_2, var_14_14, Color(255, 0, 0, 0))
end

EditAiUtility.draw_square = function (arg_15_0, arg_15_1, arg_15_2, arg_15_3, arg_15_4, arg_15_5)
	arg_15_5 = arg_15_5 or 5
	arg_15_3 = arg_15_3 * 0.5

	local var_15_0 = arg_15_2.x - arg_15_3
	local var_15_1 = arg_15_2.y - arg_15_3
	local var_15_2 = arg_15_2.x + arg_15_3
	local var_15_3 = arg_15_2.y + arg_15_3

	ScriptGUI.hud_line(arg_15_0, Vector2(var_15_0, var_15_1), Vector2(var_15_2, var_15_1), nil, arg_15_5, arg_15_4)
	ScriptGUI.hud_line(arg_15_0, Vector2(var_15_2, var_15_1), Vector2(var_15_2, var_15_3), nil, arg_15_5, arg_15_4)
	ScriptGUI.hud_line(arg_15_0, Vector2(var_15_2, var_15_3), Vector2(var_15_0, var_15_3), nil, arg_15_5, arg_15_4)
	ScriptGUI.hud_line(arg_15_0, Vector2(var_15_0, var_15_3), Vector2(var_15_0, var_15_1), nil, arg_15_5, arg_15_4)
end

EditAiUtility.hover_action = function (arg_16_0, arg_16_1, arg_16_2, arg_16_3, arg_16_4)
	local var_16_0 = #arg_16_3 * var_0_12
	local var_16_1 = arg_16_4.x
	local var_16_2 = arg_16_4.y
	local var_16_3 = var_16_1 >= arg_16_2.x and var_16_1 <= arg_16_2.x + arg_16_2.size_x and var_16_2 >= arg_16_2.y and var_16_2 <= arg_16_2.y + var_16_0

	for iter_16_0 = 1, #arg_16_3 do
		local var_16_4 = Vector3(arg_16_2.x + 10, arg_16_2.y + (iter_16_0 - 0.7) * var_0_12, 0)

		if math.abs(var_16_4.y - arg_16_4.y) < var_0_13 then
			return var_16_3, iter_16_0, arg_16_3[iter_16_0]
		end
	end

	return var_16_3
end

EditAiUtility.draw_action_list = function (arg_17_0, arg_17_1, arg_17_2, arg_17_3, arg_17_4, arg_17_5, arg_17_6, arg_17_7, arg_17_8)
	local var_17_0 = arg_17_0.screen_gui
	local var_17_1, var_17_2 = Application.resolution()
	local var_17_3
	local var_17_4 = 0

	for iter_17_0 = 1, #arg_17_5 do
		local var_17_5 = arg_17_5[iter_17_0]
		local var_17_6 = Vector3(arg_17_4.x + 30, arg_17_4.y + (iter_17_0 - 0.7) * var_0_12, 100)
		local var_17_7 = arg_17_8 and arg_17_8.utility_actions[var_17_5]

		if arg_17_7 == iter_17_0 then
			EditAiUtility.draw_square(var_17_0, arg_17_2, var_17_6 + Vector3(-15, 6, 0), var_0_13, var_17_3, 3)

			var_17_3 = var_17_7 and Color(255, 240, 200, 10) or Color(255, 255, 255, 255)
		else
			var_17_3 = var_17_7 and Color(128, 240, 200, 10) or Color(128, 255, 255, 255)
		end

		ScriptGUI.text(var_17_0, var_17_5, var_0_3, var_0_1, var_0_2, var_17_6, var_17_3)

		if var_17_7 then
			local var_17_8 = ScriptUnit.extension(arg_17_1, "ai_system"):brain():bt():action_data()[var_17_5]
			local var_17_9 = math.floor(Utility.get_action_utility(var_17_8, var_17_5, arg_17_8, arg_17_2) * 10) / 10

			ScriptGUI.text(var_17_0, var_17_9, var_0_3, var_0_1, var_0_2, var_17_6 + Vector3(-40, 0, 0), var_17_3)
		end
	end

	local var_17_10 = #arg_17_5 * var_0_12

	Gui.rect(var_17_0, Vector2(arg_17_4.x, arg_17_4.y), Vector2(arg_17_4.size_x, var_17_10), arg_17_6)
end

EditAiUtility.draw_safe_drag_lane = function (arg_18_0, arg_18_1, arg_18_2)
	local var_18_0 = arg_18_1.x - 400
	local var_18_1 = arg_18_1.x + 400
	local var_18_2 = arg_18_1.y - arg_18_2
	local var_18_3 = arg_18_1.y + arg_18_2

	ScriptGUI.hud_line(arg_18_0.screen_gui, Vector2(var_18_0, var_18_2), Vector2(var_18_1, var_18_2), 40, 3, Color(255, 240, 200, 10))
	ScriptGUI.hud_line(arg_18_0.screen_gui, Vector2(var_18_0, var_18_3), Vector2(var_18_1, var_18_3), 40, 3, Color(255, 240, 200, 10))
end

EditAiUtility.draw_realtime_utility = function (arg_19_0, arg_19_1, arg_19_2, arg_19_3, arg_19_4, arg_19_5)
	local var_19_0 = arg_19_5.utility_actions[arg_19_1]

	if var_19_0 then
		local var_19_1 = arg_19_2.blackboard_input
		local var_19_2 = var_19_0[var_19_1] or arg_19_5[var_19_1]
		local var_19_3 = math.clamp(var_19_2 / arg_19_2.max_value, 0, 1)
		local var_19_4 = arg_19_3.x + arg_19_4.x * var_19_3
		local var_19_5 = arg_19_3.y
		local var_19_6 = arg_19_3.y + arg_19_4.y
		local var_19_7 = Color(255, 240, 200, 10)

		ScriptGUI.hud_line(arg_19_0, Vector2(var_19_4, var_19_5), Vector2(var_19_4, var_19_6), arg_19_3.z, 1, var_19_7)

		local var_19_8 = Utility.GetUtilityValueFromSpline(arg_19_2.spline, var_19_3) * arg_19_4.y + var_19_5

		EditAiUtility.draw_square(arg_19_0, 0, Vector3(var_19_4, var_19_8, arg_19_3.z + 1), 14, var_19_7, 4)

		local var_19_9 = math.floor(var_19_3 * arg_19_2.max_value * 10) / 10

		ScriptGUI.text(arg_19_0, var_19_9, var_0_6, var_0_4, var_0_5, Vector3(var_19_4 + 10, var_19_8, arg_19_3.z + 1), var_19_7)

		return var_19_8
	end

	return 0
end

EditAiUtility.draw_utility_sum = function (arg_20_0, arg_20_1, arg_20_2, arg_20_3)
	return
end

EditAiUtility.draw_utility_ruler = function (arg_21_0, arg_21_1, arg_21_2, arg_21_3, arg_21_4)
	local var_21_0 = 12
	local var_21_1 = 10
	local var_21_2 = arg_21_3 + Vector3(0, 0, 3)
	local var_21_3 = 1 / var_21_1 * arg_21_4.x
	local var_21_4 = var_21_2.x
	local var_21_5 = var_21_2.y
	local var_21_6 = arg_21_2.max_value
	local var_21_7, var_21_8, var_21_9 = Gui.text_extents(arg_21_1, arg_21_2.max_value, var_0_3, var_0_4)
	local var_21_10 = Vector2(var_21_8.x - var_21_7.x, var_21_8.y - var_21_7.y)
	local var_21_11 = -var_21_10.x / 2
	local var_21_12 = var_21_10.y / 2 + 10

	for iter_21_0 = 0, var_21_1 do
		ScriptGUI.hud_line(arg_21_1, Vector2(var_21_4, var_21_5), Vector2(var_21_4, var_21_5 + 10), nil, 1)

		local var_21_13 = arg_21_2.max_value * (iter_21_0 / var_21_1)

		ScriptGUI.text(arg_21_1, var_21_13, var_0_6, var_0_4, var_0_5, Vector3(var_21_4 + var_21_11, var_21_5 + var_21_12, 10), Color(255, 255, 255, 255))

		var_21_4 = var_21_4 + var_21_3
	end
end

EditAiUtility.draw_utility_info = function (arg_22_0, arg_22_1, arg_22_2, arg_22_3, arg_22_4, arg_22_5, arg_22_6, arg_22_7)
	local var_22_0 = var_0_1
	local var_22_1 = var_0_2
	local var_22_2 = var_0_3

	if arg_22_7 then
		var_22_0 = var_0_4
		var_22_1 = var_0_5
		var_22_2 = var_0_6
	end

	local var_22_3 = arg_22_2 or arg_22_1.max_value or ""
	local var_22_4, var_22_5, var_22_6 = Gui.text_extents(arg_22_0, var_22_3, var_22_2, var_22_0)
	local var_22_7 = Vector2(var_22_5.x - var_22_4.x, var_22_5.y - var_22_4.y)
	local var_22_8 = -var_22_0
	local var_22_9, var_22_10, var_22_11 = Gui.text_extents(arg_22_0, arg_22_3, var_22_2, var_22_0)
	local var_22_12 = math.min(0, arg_22_5.x - (var_22_10.x + var_22_7.x))
	local var_22_13 = arg_22_4 + (arg_22_7 and Vector3(arg_22_5.x - var_22_5.x, var_22_8, 10) or Vector3(arg_22_5.x - var_22_5.x - var_0_13 * 1.5, var_22_8, 10))

	if arg_22_2 then
		local var_22_14 = var_22_13 + Vector3(2, -1, -1)

		ScriptGUI.text(arg_22_0, var_22_3, var_22_2, var_22_0, var_22_1, var_22_14, arg_22_2 and Color(255, 0, 0, 0))
	end

	ScriptGUI.text(arg_22_0, var_22_3, var_22_2, var_22_0, var_22_1, var_22_13, arg_22_2 and Color(255 * arg_22_6, 240, 200, 10) or Color(255 * arg_22_6, 255, 255, 255))
	ScriptGUI.text(arg_22_0, arg_22_3, var_22_2, var_22_0, var_22_1, arg_22_4 + Vector3(var_22_12, var_22_8, 10), Color(255 * arg_22_6, 255, 255, 255))
end

EditAiUtility.draw_utility_spline = function (arg_23_0, arg_23_1, arg_23_2, arg_23_3, arg_23_4, arg_23_5, arg_23_6, arg_23_7, arg_23_8, arg_23_9)
	local var_23_0 = arg_23_2.spline
	local var_23_1, var_23_2 = Application.resolution()
	local var_23_3 = arg_23_6.x
	local var_23_4 = arg_23_6.y
	local var_23_5 = Color(255 * arg_23_8, 255, 255, 255)

	arg_23_9 = arg_23_9 or 5

	for iter_23_0 = 1, #var_23_0 - 2, 2 do
		local var_23_6 = arg_23_5.x + var_23_3 * var_23_0[iter_23_0]
		local var_23_7 = arg_23_5.y + var_23_4 * var_23_0[iter_23_0 + 1]
		local var_23_8 = arg_23_5.x + var_23_3 * var_23_0[iter_23_0 + 2]
		local var_23_9 = arg_23_5.y + var_23_4 * var_23_0[iter_23_0 + 3]

		ScriptGUI.hud_line(arg_23_0, Vector2(var_23_6, var_23_7), Vector2(var_23_8, var_23_9), nil, arg_23_9, var_23_5)
	end

	Gui.rect(arg_23_0, arg_23_5, arg_23_6, arg_23_7)
end

EditAiUtility.draw_utility_condition = function (arg_24_0, arg_24_1, arg_24_2, arg_24_3, arg_24_4, arg_24_5, arg_24_6)
	local var_24_0 = arg_24_5.utility_actions[arg_24_1]

	if var_24_0 then
		local var_24_1 = var_24_0[arg_24_2.blackboard_input] or arg_24_5[arg_24_2.blackboard_input]

		if arg_24_2.invert then
			var_24_1 = not var_24_1
		end

		local var_24_2 = var_24_1 and "true" or "false"
		local var_24_3 = arg_24_3.x + arg_24_4.x / 2 - 24
		local var_24_4 = arg_24_3.y + arg_24_4.y / 2 - 6
		local var_24_5 = var_24_1 and Color(255, 240, 200, 10) or Colors.get("white")
		local var_24_6 = var_24_2

		ScriptGUI.text(arg_24_0, var_24_6, var_0_3, var_0_1, var_0_2, Vector3(var_24_3, var_24_4, arg_24_3.z + 1), var_24_5)
	end

	Gui.rect(arg_24_0, arg_24_3, arg_24_4, arg_24_6)
end

EditAiUtility.save_considerations = function (arg_25_0)
	if not GameSettingsDevelopment.trunk_path then
		print("Cannot save! No run parameter \"-trunk-path <path to my bulldozer trunk>\" has been added")

		return
	end

	print("SAVING CONSIDERATIONS!")

	local var_25_0 = table.clone(UtilityConsiderations)

	for iter_25_0, iter_25_1 in pairs(var_25_0) do
		for iter_25_2, iter_25_3 in pairs(iter_25_1) do
			if type(iter_25_3) == "table" then
				iter_25_3.name = nil
			end
		end
	end

	local var_25_1 = "UtilityConsiderations = " .. var_0_0.save_simple(var_25_0)

	print(var_25_1)

	local var_25_2 = GameSettingsDevelopment.trunk_path .. "/scripts/entity_system/systems/behaviour/utility/utility_considerations.lua"
	local var_25_3 = io.open(var_25_2, "w+")

	assert(var_25_3)
	var_25_3:write(var_25_1)
	io.close(var_25_3)
end
