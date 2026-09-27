-- chunkname: @scripts/unit_extensions/human/ai_player_unit/debug_breeds/debug_gutter_runner.lua

local DebugGutterRunner = DebugGutterRunner

DebugGutterRunner = DebugGutterRunner or {}
DebugGutterRunner = DebugGutterRunner

DebugGutterRunner.update = function (arg_1_0, arg_1_1, arg_1_2)
	-- function 1
	local breed = arg_1_1.breed
	local get_data

	if not arg_1_1.target_unit then
		get_data = Unit.get_data(arg_1_1.target_unit, "unit_name")

		if not get_data then
			-- Nothing
		end
	end

	get_data = "nil"

	do
		local target_unit
	end

	::label_1_0::

	if not arg_1_1.jump_data then
		target_unit = arg_1_1.jump_data.target_unit

		if not target_unit then
			-- Nothing
		end
	end

	target_unit = "-"

	::label_1_1::

	local format = string.format
	local str = "%.1f / %.1f, close range: 8.0 "
	local target_dist = arg_1_1.target_dist

	target_dist = target_dist or 0

	local var_1_6 = format(str, target_dist, tostring(breed.jump_range))
	local action = arg_1_1.action

	action = not action and arg_1_1.action.name

	local var_1_8
	local target_skulk_time = arg_1_1.target_skulk_time

	target_skulk_time = not target_skulk_time and arg_1_2 - arg_1_1.target_skulk_time

	local flag

	flag = (target_skulk_time or not "not skulking" or not (target_skulk_time > 0)) and (not "engage" or string.format("%.1f", target_skulk_time))

	local var_1_11

	if not arg_1_1.skulk_jump_tries then
		var_1_11 = string.format("%.1f%% tries: %d", arg_1_1.skulk_jump_tries / 10 * 100, arg_1_1.skulk_jump_tries)
	else
		var_1_11 = "n/a"
	end

	local flag_2

	flag_2 = not get_data and arg_1_1.group_blackboard.special_targets[get_data] == arg_1_0 and "YES" and "NO"

	local flag_3

	flag_3 = arg_1_1.next_smart_object_data.next_smart_object_id == nil or not "YES" or "NO"

	local flag_4

	flag_4 = not arg_1_1.is_in_smartobject_range and "YES" and "NO"

	DebugGlobadier.debug_hud_print("Gutter runner:", nil, 1)
	DebugGlobadier.debug_hud_print("behavior:", action, 2)
	DebugGlobadier.debug_hud_print("target_unit:", tostring(get_data), 5)
	DebugGlobadier.debug_hud_print("jump_data target:", tostring(target_unit), 6)
	DebugGlobadier.debug_hud_print("jump_range:", var_1_6, 7)
	DebugGlobadier.debug_hud_print("urgency to engage:", arg_1_1.urgency_to_engage, 8)
	DebugGlobadier.debug_hud_print("skulk time:", flag, 9)
	DebugGlobadier.debug_hud_print("growing_aggro:", var_1_11, 10)
	DebugGlobadier.debug_hud_print("special_targets:", flag_2, 11)
	DebugGlobadier.debug_hud_print("nxt smartobj:", flag_3, 12)
	DebugGlobadier.debug_hud_print("in smartobj range:", flag_4, 13)
	DebugGlobadier.debug_hud_background(11)
end

local num = 16
local str = "arial"
local str_2 = "materials/fonts/" .. str
local num_2 = 17

DebugGutterRunner.debug_hud_print = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3)
	-- function 2
	local gui = Debug.gui
	local num_3 = 220 - arg_2_2 * num_2
	local var_2_2 = Vector3(20, num_3, 100)
	local get = Colors.get("steel_blue")

	Gui.text(gui, arg_2_0, str_2, num, str, var_2_2, get)

	if not arg_2_1 then
		return
	end

	local get_2 = Colors.get("light_green")

	if arg_2_3 == false then
		get_2 = Colors.get("crimson")
	elseif arg_2_3 == nil then
		get_2 = Colors.get("steel_blue")
	end

	local num_4 = 100
	local var_2_6 = Vector3(160, num_3, 100)

	Gui.text(gui, arg_2_1, str_2, num, str, var_2_6, get_2)
end

DebugGutterRunner.debug_hud_background = function (arg_3_0)
	-- function 3
	local gui = Debug.gui
	local num = 300
	local num_3 = arg_3_0 * num_2 + 30
	local num_4 = 200 - arg_3_0 * num_2
	local var_3_4 = Vector3(10, num_4, 90)
	local var_3_5 = Vector3(num, num_3, 0)
	local get_color_with_alpha = Colors.get_color_with_alpha("black", 150)

	Gui.rect(gui, var_3_4, var_3_5, get_color_with_alpha)
end
