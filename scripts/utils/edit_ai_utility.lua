-- chunkname: @scripts/utils/edit_ai_utility.lua

local scripts_utils_serialize = require("scripts/utils/serialize")
local num = 26
local str = "arial"
local str_2 = "materials/fonts/" .. str
local num_2 = 16
local str_3 = "arial"
local str_4 = "materials/fonts/" .. str_3
local tbl = {}
local resolution, var_0_9 = Application.resolution()
local tbl_2 = {
	x = 300,
	y = 300
}
local num_3 = 30
local num_4 = 30
local num_5 = num_4 * 0.5
local tbl_3 = {}
local tbl_4 = {}
local flag = false
local flag_2 = false
local tbl_5 = {}
local tbl_6 = {
	x = 250,
	y = var_0_9 - tbl_2.y - 200
}
local num_6 = 3
local num_7 = 2
local num_8 = 1

for i = 0, num_7 - 1 do
	for j = 0, num_6 - 1 do
		local num_9 = tbl_6.x + tbl_2.x * j + j * num_3
		local num_10 = tbl_6.y - (tbl_2.y * i + num_3 * i)

		tbl_4[num_8] = {
			x = num_9,
			y = num_10
		}
		tbl_5[num_8] = {
			value = 0,
			index = num_8,
			x = num_9 + tbl_2.x - num_5 / 2,
			y = num_10 - num_4 / 2
		}
		num_8 = num_8 + 1
	end
end

local tbl_7 = {}
local var_0_26 = num_4

for k, v in pairs(UtilityConsiderations) do
	tbl_7[#tbl_7 + 1] = k
	var_0_26 = var_0_26 + num_4
end

local tbl_8 = {
	size_x = 200,
	x = 30,
	y = var_0_9 - var_0_26
}
local considerations = considerations

considerations = considerations or false

local function fn(arg_1_0)
	-- function 1
	if not UtilityConsiderations[arg_1_0] then
		print("No utility action named:", arg_1_0)

		return
	end

	tbl_3 = {}

	for k, v in pairs(UtilityConsiderations[arg_1_0]) do
		if k ~= "name" then
			tbl_3[#tbl_3 + 1] = k
		end
	end

	local count = #tbl_3

	considerations = UtilityConsiderations[arg_1_0]
end

if not considerations then
	local count = #tbl_7

	fn(tbl_7[count])

	tbl.selected_action = count
end

EditAiUtility = class(EditAiUtility)

EditAiUtility.init = function (self, arg_2_1)
	-- function 2
	self.world = arg_2_1
	self.world_gui = World.create_world_gui(arg_2_1, Matrix4x4.identity(), 1, 1, "immediate", "material", "materials/fonts/gw_fonts")
	self.screen_gui = World.create_screen_gui(self.world, "material", "materials/fonts/gw_fonts", "immediate")
end

EditAiUtility.activate = function (arg_3_0)
	-- function 3
	ShowCursorStack.show("EditAiUtility")
end

EditAiUtility.deactivate = function (arg_4_0)
	-- function 4
	ShowCursorStack.hide("EditAiUtility")
end

EditAiUtility.use_breed = function (arg_5_0, arg_5_1)
	-- function 5
	return
end

EditAiUtility.update = function (self, arg_6_1, arg_6_2, arg_6_3, arg_6_4, arg_6_5)
	-- function 6
	local get = arg_6_4:get("cursor")

	tbl.left_pressed = arg_6_4:get("mouse_left_held")

	if not tbl.selected_drag_point then
		tbl.hover_win_name, tbl.win_pos = self:hover_win(arg_6_2, get, tbl_4, tbl_2)

		local hover_win_name = tbl.hover_win_name

		hover_win_name = not hover_win_name and considerations[tbl.hover_win_name].spline

		local var_6_2

		if not (not hover_win_name and hover_win_name ~= tbl.last_hover_spline) then
			local win_pos = tbl.win_pos

			tbl.hover_point = self:hover_spline_point(arg_6_2, hover_win_name, win_pos, tbl_2, get)

			if not (not tbl.hover_point and not tbl.left_pressed and tbl.selected_point) then
				tbl.selected_point = tbl.hover_point
				tbl.last_selected_point = tbl.hover_point
			elseif not (not tbl.selected_point and tbl.left_pressed) then
				tbl.selected_point = nil
			end

			if not tbl.selected_point then
				self:move_spline_point(arg_6_2, hover_win_name, win_pos, tbl_2, tbl.selected_point, get)
				self:draw_mouse_selection(arg_6_2, hover_win_name, win_pos, tbl_2, tbl.selected_point, "selected", considerations[tbl.hover_win_name].max_value)
			elseif not tbl.hover_point then
				self:draw_mouse_selection(arg_6_2, hover_win_name, win_pos, tbl_2, tbl.hover_point, "hover", considerations[tbl.hover_win_name].max_value)
			end

			if not tbl.hover_point and not DebugKeyHandler.key_pressed("d", "remove selected point", "ai editor", "left ctrl") then
				self:remove_spline_point(hover_win_name, tbl.hover_point)

				tbl.last_selected_point = nil
				tbl.hover_point = nil

				return
			end
		else
			tbl.selected_point = nil
			tbl.last_selected_point = nil
		end

		tbl.last_hover_spline = hover_win_name

		if (tbl.hover_point or not tbl.hover_win_name) and not DebugKeyHandler.key_pressed("a", "insert spline point", "ai editor", "left ctrl") then
			self:insert_spline_point(hover_win_name, tbl.win_pos, tbl_2, get)
		end
	end

	tbl.hover_drag_point = self:hover_drag_points(arg_6_2, tbl_5, get)

	if not (not tbl.hover_drag_point and not tbl.left_pressed and tbl.selected_drag_point) then
		tbl.selected_drag_point = tbl.hover_drag_point
	elseif not tbl.selected_drag_point then
		local selected_drag_point = tbl.selected_drag_point
		local num = 16

		self:draw_safe_drag_lane(selected_drag_point, num)

		local var_6_6 = considerations[tbl_3[selected_drag_point.index]]

		if not tbl.left_pressed then
			local max_value = var_6_6.max_value
			local drag_point_distance, var_6_9 = EditAiUtility:drag_point_distance(arg_6_2, selected_drag_point, get)

			if not (not (num > math.abs(var_6_9)) or not (math.abs(drag_point_distance) > 0)) then
				local var_6_10

				if drag_point_distance > 0 then
					var_6_10 = 0.01 * math.pow(drag_point_distance, 1.2) + max_value
				else
					var_6_10 = -0.01 * math.pow(-drag_point_distance, 1.2) + max_value
				end

				local num_2 = math.floor(var_6_10 * 10) / 10

				tbl.selected_drag_point.max_value = not (num_2 >= 0) or not num_2 or 0
			else
				tbl.selected_drag_point.max_value = nil
			end
		else
			local drag_point_distance_2, var_6_13 = EditAiUtility:drag_point_distance(arg_6_2, selected_drag_point, get)

			if not (num > math.abs(var_6_13)) or not selected_drag_point.max_value then
				var_6_6.max_value = selected_drag_point.max_value
			end

			tbl.selected_drag_point = nil
		end
	end

	local num_3 = 1
	local var_6_15 = Vector2(tbl_2.x, tbl_2.y)
	local screen_gui = self.screen_gui
	local num_4 = 0
	local var_6_18 = considerations

	for k, v in pairs(considerations) do
		if not (type(v) ~= "table" or v.is_condition) then
			local var_6_19 = Vector2(tbl_4[num_3].x, tbl_4[num_3].y)
			local var_6_20

			if k == tbl.hover_win_name then
				var_6_20 = Color(192, 28, 128, 44)

				if not var_6_20 then
					-- Nothing
				end
			end

			var_6_20 = Color(92, 28, 128, 44)

			::label_6_0::

			local num_5 = 1

			if not tbl.selected_drag_point then
				local max_value_2 = tbl.selected_drag_point.max_value

				if tbl.selected_drag_point.index == num_3 then
					EditAiUtility.draw_utility_spline(screen_gui, arg_6_2, v, max_value_2, k, var_6_19, var_6_15, var_6_20, 1)
					EditAiUtility.draw_utility_info(screen_gui, v, max_value_2, k, var_6_19, var_6_15, num_5)
				else
					EditAiUtility.draw_utility_spline(screen_gui, arg_6_2, v, nil, k, var_6_19, var_6_15, var_6_20, 0.25)
					EditAiUtility.draw_utility_info(screen_gui, v, max_value_2, k, var_6_19, var_6_15, num_5)
				end
			else
				EditAiUtility.draw_utility_spline(screen_gui, arg_6_2, v, nil, k, var_6_19, var_6_15, var_6_20, 1)
				EditAiUtility.draw_utility_info(screen_gui, v, nil, k, var_6_19, var_6_15, num_5)
			end

			self:draw_utility_ruler(screen_gui, v, var_6_19, var_6_15, 1)

			if not arg_6_5 then
				local selected_action = tbl.selected_action

				selected_action = not selected_action and tbl_7[tbl.selected_action]
				num_4 = num_4 + EditAiUtility.draw_realtime_utility(screen_gui, selected_action, v, var_6_19, var_6_15, arg_6_5)

				local name = arg_6_5.breed.name
				local var_6_25 = BreedActions[name]

				for k_2, v_2 in pairs(var_6_25) do
					repeat
						local considerations_2 = v_2.considerations

						if not considerations_2 then
							break
						end

						if UtilityConsiderationNames[considerations_2] ~= selected_action then
							break
						end

						for k_3, v_3 in pairs(considerations_2) do
							if k_3 == v.name then
								v_3.spline = table.clone(v.spline)
								v_3.max_value = v.max_value
							end
						end
					until true
				end
			end
		end

		num_3 = num_3 + 1
	end

	if not arg_6_5 then
		local var_6_27 = Vector2(tbl_4[1].x, tbl_4[1].y)
	end

	if not DebugKeyHandler.key_pressed("s", "save to disk", "ai editor", "left ctrl") then
		self:save_considerations()
	end

	tbl.hover_action_window, tbl.hover_action = self:hover_action(arg_6_2, tbl_8, tbl_7, get)

	if not tbl.hover_action_window and not tbl.left_pressed and not tbl.hover_action then
		tbl.selected_action = tbl.hover_action

		fn(tbl_7[tbl.selected_action], tbl.selected_action)
	end

	local var_6_28

	if not tbl.hover_action_window then
		var_6_28 = Color(164, 28, 44, 100)

		if not var_6_28 then
			-- Nothing
		end
	end

	var_6_28 = Color(92, 28, 44, 100)

	::label_6_1::

	self:draw_action_list(arg_6_1, arg_6_2, "Actions", tbl_8, tbl_7, var_6_28, tbl.selected_action, arg_6_5)
end

EditAiUtility.insert_spline_point = function (arg_7_0, arg_7_1, arg_7_2, arg_7_3, arg_7_4)
	-- function 7
	local num = (arg_7_4.x - arg_7_2.x) / arg_7_3.x
	local num_2 = (arg_7_4.y - arg_7_2.y) / arg_7_3.y
	local var_7_2

	for i = 1, #arg_7_1, 2 do
		if num < arg_7_1[i] then
			var_7_2 = i

			break
		end
	end

	if not var_7_2 then
		for j = #arg_7_1, var_7_2, -1 do
			arg_7_1[j + 2] = arg_7_1[j]
		end

		arg_7_1[var_7_2] = num
		arg_7_1[var_7_2 + 1] = num_2
	end
end

EditAiUtility.remove_spline_point = function (arg_8_0, arg_8_1, arg_8_2)
	-- function 8
	local num = 1
	local num_2 = #arg_8_1 - 1

	if not (arg_8_2 == num or arg_8_2 ~= num_2) then
		return
	end

	for i = arg_8_2, #arg_8_1 - 2 do
		arg_8_1[i] = arg_8_1[i + 2]
	end

	arg_8_1[#arg_8_1] = nil
	arg_8_1[#arg_8_1] = nil
end

EditAiUtility.hover_win = function (arg_9_0, arg_9_1, arg_9_2, arg_9_3, arg_9_4)
	-- function 9
	local x = arg_9_2.x
	local y = arg_9_2.y
	local num = 1
	local num_2 = 10

	for i = 1, #tbl_3 do
		if not (not (x >= arg_9_3[i].x - num_2) or not (x <= arg_9_3[i].x + arg_9_4.x + num_2) or not (y >= arg_9_3[i].y - num_2) or not (y <= arg_9_3[i].y + arg_9_4.y + num_2)) then
			return tbl_3[i], arg_9_3[i]
		end

		i = i + 1
	end
end

EditAiUtility.move_spline_point = function (arg_10_0, arg_10_1, arg_10_2, arg_10_3, arg_10_4, arg_10_5, arg_10_6)
	-- function 10
	local num = 1
	local num_2 = #arg_10_2 - 1
	local num_3 = (arg_10_6.x - arg_10_3.x) / arg_10_4.x
	local num_4 = (arg_10_6.y - arg_10_3.y) / arg_10_4.y

	if not (not (num < arg_10_5) or not (arg_10_5 < num_2) or not (num_3 > arg_10_2[arg_10_5 - 2]) or not (num_3 < arg_10_2[arg_10_5 + 2])) then
		arg_10_2[arg_10_5] = num_3
	end

	if not (not (num_4 >= 0) or not (num_4 <= 1)) then
		arg_10_2[arg_10_5 + 1] = num_4
	end
end

local num_11 = 20

EditAiUtility.hover_spline_point = function (self, arg_11_1, arg_11_2, arg_11_3, arg_11_4, arg_11_5)
	-- function 11
	local screen_gui = self.screen_gui
	local resolution, var_11_2 = Application.resolution()
	local x = arg_11_4.x
	local y = arg_11_4.y

	for i = 1, #arg_11_2, 2 do
		local num = arg_11_3.x + x * arg_11_2[i]
		local num_2 = arg_11_3.y + y * arg_11_2[i + 1]

		if not (not (math.abs(num - arg_11_5.x) < num_11) or not (math.abs(num_2 - arg_11_5.y) < num_11)) then
			return i, num, num_2
		end
	end
end

EditAiUtility.drag_point_distance = function (arg_12_0, arg_12_1, arg_12_2, arg_12_3)
	-- function 12
	local x = arg_12_3.x
	local y = arg_12_3.y
	local num = 10
	local num_2 = x - arg_12_2.x

	num_2 = not (num > math.abs(num_2)) or not 0 or num_2 - (not (num_2 > 0) or not num or -num)

	local num_3 = y - arg_12_2.y

	num_3 = not (num > math.abs(num_3)) or not 0 or num_3 - (not (num_3 > 0) or not num or -num)

	return num_2, num_3
end

EditAiUtility.hover_drag_points = function (self, arg_13_1, arg_13_2, arg_13_3)
	-- function 13
	local screen_gui = self.screen_gui
	local x = arg_13_3.x
	local y = arg_13_3.y
	local num = 15

	for i = 1, #arg_13_2 do
		local var_13_4 = arg_13_2[i]

		if not (not (x > var_13_4.x - num) or not (x < var_13_4.x + num) or not (y > var_13_4.y - num) or not (y < var_13_4.y + num)) then
			EditAiUtility.draw_square(screen_gui, arg_13_1, Vector2(var_13_4.x, var_13_4.y), num_5, Color(255, 255, 255, 255), 3)

			return var_13_4
		end
	end
end

EditAiUtility.draw_mouse_selection = function (self, arg_14_1, arg_14_2, arg_14_3, arg_14_4, arg_14_5, arg_14_6, arg_14_7)
	-- function 14
	local screen_gui = self.screen_gui
	local resolution, var_14_2 = Application.resolution()
	local x = arg_14_4.x
	local y = arg_14_4.y
	local var_14_5 = Color(128, 45, 45, 196)
	local var_14_6 = arg_14_5
	local num = arg_14_3.x + x * arg_14_2[var_14_6]
	local num_2 = arg_14_3.y + y * arg_14_2[var_14_6 + 1]
	local flag

	flag = arg_14_6 ~= "selected" or not 20 or 30

	local flag_2

	flag_2 = arg_14_6 ~= "last_selected" or not 2 or 5

	local var_14_11 = Vector2(num, num_2)

	EditAiUtility.draw_square(screen_gui, arg_14_1, var_14_11, flag, var_14_5, flag_2)

	local format = string.format("x:%.2f / %.2f y:%.2f ", arg_14_2[var_14_6], arg_14_7 * arg_14_2[var_14_6], arg_14_2[var_14_6 + 1])
	local format_2 = string.format("x:%.2f (%.2f, %.2f) ", arg_14_7 * arg_14_2[var_14_6], arg_14_2[var_14_6], arg_14_2[var_14_6 + 1])
	local var_14_14 = Vector3(num + 20, num_2, 30)

	ScriptGUI.text(screen_gui, format_2, str_2, 32, str, var_14_14, Color(255, 0, 0, 0))
end

EditAiUtility.draw_square = function (arg_15_0, arg_15_1, arg_15_2, arg_15_3, arg_15_4, arg_15_5)
	-- function 15
	arg_15_5 = arg_15_5 or 5
	arg_15_3 = arg_15_3 * 0.5

	local num = arg_15_2.x - arg_15_3
	local num_2 = arg_15_2.y - arg_15_3
	local num_3 = arg_15_2.x + arg_15_3
	local num_4 = arg_15_2.y + arg_15_3

	ScriptGUI.hud_line(arg_15_0, Vector2(num, num_2), Vector2(num_3, num_2), nil, arg_15_5, arg_15_4)
	ScriptGUI.hud_line(arg_15_0, Vector2(num_3, num_2), Vector2(num_3, num_4), nil, arg_15_5, arg_15_4)
	ScriptGUI.hud_line(arg_15_0, Vector2(num_3, num_4), Vector2(num, num_4), nil, arg_15_5, arg_15_4)
	ScriptGUI.hud_line(arg_15_0, Vector2(num, num_4), Vector2(num, num_2), nil, arg_15_5, arg_15_4)
end

EditAiUtility.hover_action = function (arg_16_0, arg_16_1, arg_16_2, arg_16_3, arg_16_4)
	-- function 16
	local num = #arg_16_3 * num_4
	local x = arg_16_4.x
	local y = arg_16_4.y
	local flag = not (x >= arg_16_2.x) or not (x <= arg_16_2.x + arg_16_2.size_x) or not (y >= arg_16_2.y) or y <= arg_16_2.y + num

	for i = 1, #arg_16_3 do
		local var_16_4 = Vector3(arg_16_2.x + 10, arg_16_2.y + (i - 0.7) * num_4, 0)

		if math.abs(var_16_4.y - arg_16_4.y) < num_5 then
			return flag, i, arg_16_3[i]
		end
	end

	return flag
end

EditAiUtility.draw_action_list = function (self, arg_17_1, arg_17_2, arg_17_3, arg_17_4, arg_17_5, arg_17_6, arg_17_7, arg_17_8)
	-- function 17
	local screen_gui = self.screen_gui
	local resolution, var_17_2 = Application.resolution()
	local var_17_3
	local num_2 = 0

	for i = 1, #arg_17_5 do
		local var_17_5 = arg_17_5[i]
		local var_17_6 = Vector3(arg_17_4.x + 30, arg_17_4.y + (i - 0.7) * num_4, 100)
		local flag = not arg_17_8 and arg_17_8.utility_actions[var_17_5]

		if arg_17_7 == i then
			EditAiUtility.draw_square(screen_gui, arg_17_2, var_17_6 + Vector3(-15, 6, 0), num_5, var_17_3, 3)

			var_17_3 = not flag and Color(255, 240, 200, 10) and Color(255, 255, 255, 255)
		else
			var_17_3 = not flag and Color(128, 240, 200, 10) and Color(128, 255, 255, 255)
		end

		ScriptGUI.text(screen_gui, var_17_5, str_2, num, str, var_17_6, var_17_3)

		if not flag then
			local var_17_8 = ScriptUnit.extension(arg_17_1, "ai_system"):brain():bt():action_data()[var_17_5]
			local num_3 = math.floor(Utility.get_action_utility(var_17_8, var_17_5, arg_17_8, arg_17_2) * 10) / 10

			ScriptGUI.text(screen_gui, num_3, str_2, num, str, var_17_6 + Vector3(-40, 0, 0), var_17_3)
		end
	end

	local num_6 = #arg_17_5 * num_4

	Gui.rect(screen_gui, Vector2(arg_17_4.x, arg_17_4.y), Vector2(arg_17_4.size_x, num_6), arg_17_6)
end

EditAiUtility.draw_safe_drag_lane = function (self, arg_18_1, arg_18_2)
	-- function 18
	local num = arg_18_1.x - 400
	local num_2 = arg_18_1.x + 400
	local num_3 = arg_18_1.y - arg_18_2
	local num_4 = arg_18_1.y + arg_18_2

	ScriptGUI.hud_line(self.screen_gui, Vector2(num, num_3), Vector2(num_2, num_3), 40, 3, Color(255, 240, 200, 10))
	ScriptGUI.hud_line(self.screen_gui, Vector2(num, num_4), Vector2(num_2, num_4), 40, 3, Color(255, 240, 200, 10))
end

EditAiUtility.draw_realtime_utility = function (arg_19_0, arg_19_1, arg_19_2, arg_19_3, arg_19_4, arg_19_5)
	-- function 19
	local var_19_0 = arg_19_5.utility_actions[arg_19_1]

	if not var_19_0 then
		local blackboard_input = arg_19_2.blackboard_input
		local var_19_2 = var_19_0[blackboard_input]

		var_19_2 = var_19_2 or arg_19_5[blackboard_input]

		local clamp = math.clamp(var_19_2 / arg_19_2.max_value, 0, 1)
		local num = arg_19_3.x + arg_19_4.x * clamp
		local y = arg_19_3.y
		local num_3 = arg_19_3.y + arg_19_4.y
		local var_19_7 = Color(255, 240, 200, 10)

		ScriptGUI.hud_line(arg_19_0, Vector2(num, y), Vector2(num, num_3), arg_19_3.z, 1, var_19_7)

		local num_4 = Utility.GetUtilityValueFromSpline(arg_19_2.spline, clamp) * arg_19_4.y + y

		EditAiUtility.draw_square(arg_19_0, 0, Vector3(num, num_4, arg_19_3.z + 1), 14, var_19_7, 4)

		local num_5 = math.floor(clamp * arg_19_2.max_value * 10) / 10

		ScriptGUI.text(arg_19_0, num_5, str_4, num_2, str_3, Vector3(num + 10, num_4, arg_19_3.z + 1), var_19_7)

		return num_4
	end

	return 0
end

EditAiUtility.draw_utility_sum = function (arg_20_0, arg_20_1, arg_20_2, arg_20_3)
	-- function 20
	return
end

EditAiUtility.draw_utility_ruler = function (arg_21_0, arg_21_1, arg_21_2, arg_21_3, arg_21_4)
	-- function 21
	local num = 12
	local num_3 = 10
	local num_4 = arg_21_3 + Vector3(0, 0, 3)
	local num_5 = 1 / num_3 * arg_21_4.x
	local x = num_4.x
	local y = num_4.y
	local max_value = arg_21_2.max_value
	local text_extents, var_21_8, var_21_9 = Gui.text_extents(arg_21_1, arg_21_2.max_value, str_2, num_2)
	local var_21_10 = Vector2(var_21_8.x - text_extents.x, var_21_8.y - text_extents.y)
	local num_6 = -var_21_10.x / 2
	local num_7 = var_21_10.y / 2 + 10

	for i = 0, num_3 do
		ScriptGUI.hud_line(arg_21_1, Vector2(x, y), Vector2(x, y + 10), nil, 1)

		local num_8 = arg_21_2.max_value * (i / num_3)

		ScriptGUI.text(arg_21_1, num_8, str_4, num_2, str_3, Vector3(x + num_6, y + num_7, 10), Color(255, 255, 255, 255))

		x = x + num_5
	end
end

EditAiUtility.draw_utility_info = function (arg_22_0, arg_22_1, arg_22_2, arg_22_3, arg_22_4, arg_22_5, arg_22_6, arg_22_7)
	-- function 22
	local var_22_0 = num
	local var_22_1 = str
	local var_22_2 = str_2

	if not arg_22_7 then
		var_22_0 = num_2
		var_22_1 = str_3
		var_22_2 = str_4
	end

	if not arg_22_2 then
		-- Nothing
	end

	::label_22_0::

	local max_value = arg_22_1.max_value

	max_value = max_value or ""

	::label_22_1::

	local text_extents, var_22_5, var_22_6 = Gui.text_extents(arg_22_0, max_value, var_22_2, var_22_0)
	local var_22_7 = Vector2(var_22_5.x - text_extents.x, var_22_5.y - text_extents.y)
	local num_3 = -var_22_0
	local text_extents_2, var_22_10, var_22_11 = Gui.text_extents(arg_22_0, arg_22_3, var_22_2, var_22_0)
	local min = math.min(0, arg_22_5.x - (var_22_10.x + var_22_7.x))
	local var_22_13

	if not arg_22_7 then
		var_22_13 = Vector3(arg_22_5.x - var_22_5.x, num_3, 10)

		if not var_22_13 then
			-- Nothing
		end
	end

	var_22_13 = Vector3(arg_22_5.x - var_22_5.x - num_5 * 1.5, num_3, 10)

	::label_22_2::

	local num_4 = arg_22_4 + var_22_13

	if not arg_22_2 then
		local num_6 = num_4 + Vector3(2, -1, -1)

		ScriptGUI.text(arg_22_0, max_value, var_22_2, var_22_0, var_22_1, num_6, not arg_22_2 and Color(255, 0, 0, 0))
	end

	local text = ScriptGUI.text
	local var_22_17 = arg_22_0
	local var_22_18 = max_value
	local var_22_19 = var_22_2
	local var_22_20 = var_22_0
	local var_22_21 = var_22_1
	local var_22_22 = num_4
	local var_22_23

	if not arg_22_2 then
		var_22_23 = Color(255 * arg_22_6, 240, 200, 10)

		if not var_22_23 then
			-- Nothing
		end
	end

	var_22_23 = Color(255 * arg_22_6, 255, 255, 255)

	::label_22_3::

	text(var_22_17, var_22_18, var_22_19, var_22_20, var_22_21, var_22_22, var_22_23)
	ScriptGUI.text(arg_22_0, arg_22_3, var_22_2, var_22_0, var_22_1, arg_22_4 + Vector3(min, num_3, 10), Color(255 * arg_22_6, 255, 255, 255))
end

EditAiUtility.draw_utility_spline = function (arg_23_0, arg_23_1, arg_23_2, arg_23_3, arg_23_4, arg_23_5, arg_23_6, arg_23_7, arg_23_8, arg_23_9)
	-- function 23
	local spline = arg_23_2.spline
	local resolution, var_23_2 = Application.resolution()
	local x = arg_23_6.x
	local y = arg_23_6.y
	local var_23_5 = Color(255 * arg_23_8, 255, 255, 255)

	arg_23_9 = arg_23_9 or 5

	for i = 1, #spline - 2, 2 do
		local num = arg_23_5.x + x * spline[i]
		local num_2 = arg_23_5.y + y * spline[i + 1]
		local num_3 = arg_23_5.x + x * spline[i + 2]
		local num_4 = arg_23_5.y + y * spline[i + 3]

		ScriptGUI.hud_line(arg_23_0, Vector2(num, num_2), Vector2(num_3, num_4), nil, arg_23_9, var_23_5)
	end

	Gui.rect(arg_23_0, arg_23_5, arg_23_6, arg_23_7)
end

EditAiUtility.draw_utility_condition = function (arg_24_0, arg_24_1, arg_24_2, arg_24_3, arg_24_4, arg_24_5, arg_24_6)
	-- function 24
	local var_24_0 = arg_24_5.utility_actions[arg_24_1]

	if not var_24_0 then
		local var_24_1 = var_24_0[arg_24_2.blackboard_input]

		var_24_1 = var_24_1 or arg_24_5[arg_24_2.blackboard_input]

		if not arg_24_2.invert then
			var_24_1 = not var_24_1
		end

		local flag

		flag = not var_24_1 and "true" and "false"

		local num_2 = arg_24_3.x + arg_24_4.x / 2 - 24
		local num_3 = arg_24_3.y + arg_24_4.y / 2 - 6
		local var_24_5

		if not var_24_1 then
			var_24_5 = Color(255, 240, 200, 10)

			if not var_24_5 then
				-- Nothing
			end
		end

		var_24_5 = Colors.get("white")

		::label_24_0::

		local var_24_6 = flag

		ScriptGUI.text(arg_24_0, var_24_6, str_2, num, str, Vector3(num_2, num_3, arg_24_3.z + 1), var_24_5)
	end

	Gui.rect(arg_24_0, arg_24_3, arg_24_4, arg_24_6)
end

EditAiUtility.save_considerations = function (arg_25_0)
	-- function 25
	if not GameSettingsDevelopment.trunk_path then
		print("Cannot save! No run parameter \"-trunk-path <path to my bulldozer trunk>\" has been added")

		return
	end

	print("SAVING CONSIDERATIONS!")

	local clone = table.clone(UtilityConsiderations)

	for k, v in pairs(clone) do
		for k_2, v_2 in pairs(v) do
			if type(v_2) == "table" then
				v_2.name = nil
			end
		end
	end

	local str = "UtilityConsiderations = " .. scripts_utils_serialize.save_simple(clone)

	print(str)

	local str_2 = GameSettingsDevelopment.trunk_path .. "/scripts/entity_system/systems/behaviour/utility/utility_considerations.lua"
	local open = io.open(str_2, "w+")

	assert(open)
	open:write(str)
	io.close(open)
end
