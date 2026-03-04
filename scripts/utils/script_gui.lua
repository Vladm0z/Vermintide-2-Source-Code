-- chunkname: @scripts/utils/script_gui.lua

ScriptGUI = ScriptGUI or {}

ScriptGUI.text = function (arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7, arg_1_8)
	if arg_1_7 then
		Gui.text(arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5 + arg_1_8, arg_1_7)
	end

	Gui.text(arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6)
end

ScriptGUI.irect = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5, arg_2_6, arg_2_7, arg_2_8)
	local var_2_0 = Vector3(arg_2_3 * arg_2_1, (1 - arg_2_6) * arg_2_2, arg_2_7)
	local var_2_1 = Vector3((arg_2_5 - arg_2_3) * arg_2_1, (arg_2_6 - arg_2_4) * arg_2_2, arg_2_7)

	Gui.rect(arg_2_0, var_2_0, var_2_1, arg_2_8)
end

ScriptGUI.itext = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5, arg_3_6, arg_3_7, arg_3_8, arg_3_9, arg_3_10)
	Gui.text(arg_3_0, arg_3_3, arg_3_4, arg_3_5, arg_3_6, Vector3(arg_3_7 * arg_3_1, (1 - arg_3_8) * arg_3_2, arg_3_9), arg_3_10)
end

ScriptGUI.itext_next_xy = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4, arg_4_5, arg_4_6, arg_4_7, arg_4_8, arg_4_9, arg_4_10)
	Gui.text(arg_4_0, arg_4_3, arg_4_4, arg_4_5, arg_4_6, Vector3(arg_4_7 * arg_4_1, (1 - arg_4_8) * arg_4_2, arg_4_9), arg_4_10)

	local var_4_0, var_4_1 = Gui.text_extents(arg_4_0, arg_4_3, arg_4_4, arg_4_5)
	local var_4_2 = (var_4_1.x - var_4_0.x) / arg_4_1 + arg_4_7
	local var_4_3 = (var_4_1.y - var_4_0.y) / arg_4_2 + arg_4_8

	return var_4_2, var_4_3
end

ScriptGUI.icrect = function (arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4, arg_5_5, arg_5_6, arg_5_7, arg_5_8)
	local var_5_0 = Vector3(arg_5_3, arg_5_2 - arg_5_6, arg_5_7)
	local var_5_1 = Vector3(arg_5_5 - arg_5_3, arg_5_6 - arg_5_4, arg_5_7)

	Gui.rect(arg_5_0, var_5_0, var_5_1, arg_5_8)
end

ScriptGUI.ictext = function (arg_6_0, arg_6_1, arg_6_2, arg_6_3, arg_6_4, arg_6_5, arg_6_6, arg_6_7, arg_6_8, arg_6_9, arg_6_10)
	Gui.text(arg_6_0, arg_6_3, arg_6_4, arg_6_5, arg_6_6, Vector3(arg_6_7, arg_6_2 - arg_6_8, arg_6_9), arg_6_10)
end

ScriptGUI.hud_line = function (arg_7_0, arg_7_1, arg_7_2, arg_7_3, arg_7_4, arg_7_5)
	arg_7_4 = arg_7_4 or 3
	arg_7_3 = arg_7_3 or 1

	local var_7_0 = arg_7_2.x - arg_7_1.x
	local var_7_1 = arg_7_2.y - arg_7_1.y
	local var_7_2 = -math.atan2(var_7_1, var_7_0)
	local var_7_3 = Vector2(math.sqrt(var_7_0 * var_7_0 + var_7_1 * var_7_1), arg_7_4)
	local var_7_4 = Rotation2D(arg_7_1, var_7_2)

	Gui.rect_3d(arg_7_0, var_7_4, Vector2(0, 0), arg_7_3, var_7_3, arg_7_5)
end

ScriptGUI.hud_iline = function (arg_8_0, arg_8_1, arg_8_2, arg_8_3, arg_8_4, arg_8_5, arg_8_6, arg_8_7)
	local var_8_0 = Vector2(arg_8_3.x * arg_8_1, (1 - arg_8_3.y) * arg_8_2)
	local var_8_1 = Vector2(arg_8_4.x * arg_8_1, (1 - arg_8_4.y) * arg_8_2)

	ScriptGUI.hud_line(arg_8_0, var_8_0, var_8_1, arg_8_5, arg_8_6, arg_8_7)
end
