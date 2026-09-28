-- chunkname: @scripts/unit_extensions/human/ai_player_unit/debug_breeds/debug_gutter_runner.lua

local DebugGutterRunner = DebugGutterRunner

DebugGutterRunner = not not DebugGutterRunner or not not {}
DebugGutterRunner = DebugGutterRunner

DebugGutterRunner.update = function (unit, blackboard, t)
	-- function 1
	local breed = blackboard.breed
	local get_data

	if blackboard.target_unit then
		get_data = Unit.get_data(blackboard.target_unit, "unit_name")

		if not get_data then
			-- Nothing
		end
	end

	get_data = "nil"

	local target_unit = get_data

	do
		local target_unit_2
	end

	::label_1_0::

	if blackboard.jump_data then
		target_unit_2 = blackboard.jump_data.target_unit

		if not target_unit_2 then
			-- Nothing
		end
	end

	target_unit_2 = "-"

	local jump_target = target_unit_2

	::label_1_1::

	local format = string.format
	local str = "%.1f / %.1f, close range: 8.0 "
	local target_dist = blackboard.target_dist

	target_dist = not not target_dist or not not 0

	local jump_range = format(str, target_dist, tostring(breed.jump_range))
	local action = blackboard.action

	if action then
		-- Nothing
	end

	action = blackboard.action.name

	local ai_node = action

	::label_1_2::

	local skulk
	local target_skulk_time = blackboard.target_skulk_time

	if target_skulk_time then
		-- Nothing
	end

	target_skulk_time = t - blackboard.target_skulk_time

	local skulk_time = target_skulk_time

	::label_1_3::

	skulk = (skulk_time or not "not skulking") and (not (skulk_time > 0) or not "engage") and not not string.format("%.1f", skulk_time)

	local growing_aggro

	if blackboard.skulk_jump_tries then
		growing_aggro = string.format("%.1f%% tries: %d", blackboard.skulk_jump_tries / 10 * 100, blackboard.skulk_jump_tries)
	else
		growing_aggro = "n/a"
	end

	local str_2

	if target_unit and blackboard.group_blackboard.special_targets[target_unit] == unit then
		str_2 = "YES"

		goto label_1_4
	end

	str_2 = "NO"

	local special_targets_text = str_2

	do
		local str_3
	end

	::label_1_4::

	if blackboard.next_smart_object_data.next_smart_object_id ~= nil then
		str_3 = "YES"

		goto label_1_5
	end

	str_3 = "NO"

	local next_smart_object_data = str_3

	do
		local str_4
	end

	::label_1_5::

	if blackboard.is_in_smartobject_range then
		str_4 = "YES"

		goto label_1_6
	end

	str_4 = "NO"

	local in_smartobj_range = str_4

	::label_1_6::

	DebugGlobadier.debug_hud_print("Gutter runner:", nil, 1)
	DebugGlobadier.debug_hud_print("behavior:", ai_node, 2)
	DebugGlobadier.debug_hud_print("target_unit:", tostring(target_unit), 5)
	DebugGlobadier.debug_hud_print("jump_data target:", tostring(jump_target), 6)
	DebugGlobadier.debug_hud_print("jump_range:", jump_range, 7)
	DebugGlobadier.debug_hud_print("urgency to engage:", blackboard.urgency_to_engage, 8)
	DebugGlobadier.debug_hud_print("skulk time:", skulk, 9)
	DebugGlobadier.debug_hud_print("growing_aggro:", growing_aggro, 10)
	DebugGlobadier.debug_hud_print("special_targets:", special_targets_text, 11)
	DebugGlobadier.debug_hud_print("nxt smartobj:", next_smart_object_data, 12)
	DebugGlobadier.debug_hud_print("in smartobj range:", in_smartobj_range, 13)
	DebugGlobadier.debug_hud_background(11)
end

local font_size = 16
local font = "arial"
local font_mtrl = "materials/fonts/" .. font
local row_height = 17

DebugGutterRunner.debug_hud_print = function (caption, value, index, valid)
	-- function 2
	local gui = Debug.gui
	local y = 220 - index * row_height
	local caption_pos = Vector3(20, y, 100)
	local caption_color = Colors.get("steel_blue")

	Gui.text(gui, caption, font_mtrl, font_size, font, caption_pos, caption_color)

	if not value then
		return
	end

	local text_color = Colors.get("light_green")

	if valid == false then
		text_color = Colors.get("crimson")
	elseif valid == nil then
		text_color = Colors.get("steel_blue")
	end

	local caption_x = 100
	local pos = Vector3(160, y, 100)

	Gui.text(gui, value, font_mtrl, font_size, font, pos, text_color)
end

DebugGutterRunner.debug_hud_background = function (max_index)
	-- function 3
	local gui = Debug.gui
	local width = 300
	local height = max_index * row_height + 30
	local y = 200 - max_index * row_height
	local pos = Vector3(10, y, 90)
	local size = Vector3(width, height, 0)
	local color = Colors.get_color_with_alpha("black", 150)

	Gui.rect(gui, pos, size, color)
end
