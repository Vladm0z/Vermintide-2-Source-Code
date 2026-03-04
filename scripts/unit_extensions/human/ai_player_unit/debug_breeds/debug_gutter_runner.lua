-- chunkname: @scripts/unit_extensions/human/ai_player_unit/debug_breeds/debug_gutter_runner.lua

DebugGutterRunner = DebugGutterRunner or {}

DebugGutterRunner.update = function (arg_1_0, arg_1_1, arg_1_2)
	local var_1_0 = arg_1_1.breed
	local var_1_1 = arg_1_1.target_unit and Unit.get_data(arg_1_1.target_unit, "unit_name") or "nil"
	local var_1_2 = arg_1_1.jump_data and arg_1_1.jump_data.target_unit or "-"
	local var_1_3 = string.format("%.1f / %.1f, close range: 8.0 ", arg_1_1.target_dist or 0, tostring(var_1_0.jump_range))
	local var_1_4 = arg_1_1.action and arg_1_1.action.name
	local var_1_5
	local var_1_6 = arg_1_1.target_skulk_time and arg_1_2 - arg_1_1.target_skulk_time
	local var_1_7 = not var_1_6 and "not skulking" or var_1_6 > 0 and "engage" or string.format("%.1f", var_1_6)
	local var_1_8

	if arg_1_1.skulk_jump_tries then
		var_1_8 = string.format("%.1f%% tries: %d", arg_1_1.skulk_jump_tries / 10 * 100, arg_1_1.skulk_jump_tries)
	else
		var_1_8 = "n/a"
	end

	local var_1_9 = var_1_1 and arg_1_1.group_blackboard.special_targets[var_1_1] == arg_1_0 and "YES" or "NO"
	local var_1_10 = arg_1_1.next_smart_object_data.next_smart_object_id ~= nil and "YES" or "NO"
	local var_1_11 = arg_1_1.is_in_smartobject_range and "YES" or "NO"

	DebugGlobadier.debug_hud_print("Gutter runner:", nil, 1)
	DebugGlobadier.debug_hud_print("behavior:", var_1_4, 2)
	DebugGlobadier.debug_hud_print("target_unit:", tostring(var_1_1), 5)
	DebugGlobadier.debug_hud_print("jump_data target:", tostring(var_1_2), 6)
	DebugGlobadier.debug_hud_print("jump_range:", var_1_3, 7)
	DebugGlobadier.debug_hud_print("urgency to engage:", arg_1_1.urgency_to_engage, 8)
	DebugGlobadier.debug_hud_print("skulk time:", var_1_7, 9)
	DebugGlobadier.debug_hud_print("growing_aggro:", var_1_8, 10)
	DebugGlobadier.debug_hud_print("special_targets:", var_1_9, 11)
	DebugGlobadier.debug_hud_print("nxt smartobj:", var_1_10, 12)
	DebugGlobadier.debug_hud_print("in smartobj range:", var_1_11, 13)
	DebugGlobadier.debug_hud_background(11)
end

local var_0_0 = 16
local var_0_1 = "arial"
local var_0_2 = "materials/fonts/" .. var_0_1
local var_0_3 = 17

DebugGutterRunner.debug_hud_print = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3)
	local var_2_0 = Debug.gui
	local var_2_1 = 220 - arg_2_2 * var_0_3
	local var_2_2 = Vector3(20, var_2_1, 100)
	local var_2_3 = Colors.get("steel_blue")

	Gui.text(var_2_0, arg_2_0, var_0_2, var_0_0, var_0_1, var_2_2, var_2_3)

	if not arg_2_1 then
		return
	end

	local var_2_4 = Colors.get("light_green")

	if arg_2_3 == false then
		var_2_4 = Colors.get("crimson")
	elseif arg_2_3 == nil then
		var_2_4 = Colors.get("steel_blue")
	end

	local var_2_5 = 100
	local var_2_6 = Vector3(160, var_2_1, 100)

	Gui.text(var_2_0, arg_2_1, var_0_2, var_0_0, var_0_1, var_2_6, var_2_4)
end

DebugGutterRunner.debug_hud_background = function (arg_3_0)
	local var_3_0 = Debug.gui
	local var_3_1 = 300
	local var_3_2 = arg_3_0 * var_0_3 + 30
	local var_3_3 = 200 - arg_3_0 * var_0_3
	local var_3_4 = Vector3(10, var_3_3, 90)
	local var_3_5 = Vector3(var_3_1, var_3_2, 0)
	local var_3_6 = Colors.get_color_with_alpha("black", 150)

	Gui.rect(var_3_0, var_3_4, var_3_5, var_3_6)
end
