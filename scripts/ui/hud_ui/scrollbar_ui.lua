-- chunkname: @scripts/ui/hud_ui/scrollbar_ui.lua

local var_0_0 = local_require("scripts/ui/hud_ui/scrollbar_ui_definitions")

ScrollbarUI = class(ScrollbarUI)
ScrollbarUI.NAME = "ScrollbarUI"

local var_0_1 = 2
local var_0_2 = 0.25
local var_0_3 = 5
local var_0_4 = 150
local var_0_5 = 300

function ScrollbarUI.init(arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7, arg_1_8)
	arg_1_0._scroll_area_scenegraph_id = arg_1_2
	arg_1_0._scroll_area_anchor_scenegraph_id = arg_1_3
	arg_1_0._scroll_area_hotspot_widget = arg_1_6
	arg_1_0._excess_area = arg_1_4
	arg_1_0._ui_scenegraph = arg_1_1
	arg_1_0._auto_scroll_enabled = arg_1_5
	arg_1_0._auto_scroll_enabled_at_start = arg_1_5
	arg_1_0._horizontal_scrollbar = arg_1_7
	arg_1_0._left_aligned = arg_1_8

	arg_1_0:_create_ui_elements()
end

function ScrollbarUI._create_ui_elements(arg_2_0)
	arg_2_0._scrollbar_wait_timer = 0
	arg_2_0._scrollbar_timer = 0
	arg_2_0._auto_scroll_enabled = arg_2_0._auto_scroll_enabled_at_start
	arg_2_0._progress = 0
	arg_2_0._ui_animations = {}
	arg_2_0._widgets, arg_2_0._widgets_by_name = var_0_0.setup_func(arg_2_0._ui_scenegraph, arg_2_0._scroll_area_anchor_scenegraph_id, arg_2_0._excess_area, arg_2_0._horizontal_scrollbar, arg_2_0._left_aligned)

	if not arg_2_0._scroll_area_hotspot_widget then
		local var_2_0 = UIWidgets.create_simple_hotspot(arg_2_0._scroll_area_anchor_scenegraph_id)
		local var_2_1 = UIWidget.init(var_2_0)

		arg_2_0._scroll_area_hotspot_widget = var_2_1
		arg_2_0._internal_hotspot_widget = var_2_1
	end
end

function ScrollbarUI.update(arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5)
	arg_3_0:_auto_scroll(arg_3_1, arg_3_2)
	arg_3_0:_update_input(arg_3_1, arg_3_2, arg_3_4, arg_3_3)
	arg_3_0:_update_scroller_progress()
	arg_3_0:_update_scrollbar_hover_animations()
	arg_3_0:_update_animations(arg_3_1, arg_3_2)
	arg_3_0:_draw(arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5)
end

function ScrollbarUI.force_update_progress(arg_4_0, arg_4_1)
	local var_4_0 = arg_4_1 or 1
	local var_4_1 = arg_4_0._ui_scenegraph[arg_4_0._scroll_area_scenegraph_id].local_position[var_4_0]

	arg_4_0._progress = math.inv_lerp(0, arg_4_0._excess_area, math.abs(var_4_1))

	table.clear(arg_4_0._ui_animations)
end

function ScrollbarUI._auto_scroll(arg_5_0, arg_5_1, arg_5_2)
	if not arg_5_0._auto_scroll_enabled then
		return
	end

	if UIUtils.is_button_hover(arg_5_0._scroll_area_hotspot_widget) then
		arg_5_0._scrollbar_wait_timer = 0
	elseif arg_5_0._scrollbar_wait_timer > var_0_1 then
		local var_5_0 = var_0_2 * arg_5_1

		arg_5_0._progress = math.clamp(arg_5_0._progress + var_5_0 * var_0_4 / arg_5_0._excess_area, 0, 1)
		arg_5_0._scrollbar_timer = arg_5_0._progress == 1 and arg_5_0._scrollbar_timer + arg_5_1 or 0

		if arg_5_0._scrollbar_timer >= var_0_3 then
			arg_5_0._scrollbar_timer = 0
			arg_5_0._scrollbar_wait_timer = 0
			arg_5_0._progress = 0
		end
	else
		arg_5_0._scrollbar_wait_timer = arg_5_0._scrollbar_wait_timer + arg_5_1
	end
end

function ScrollbarUI.disable_input(arg_6_0, arg_6_1)
	arg_6_0._input_disabled = arg_6_1
	arg_6_0._widgets_by_name.scrollbar.content.gamepad_input_disabled = arg_6_1
end

function ScrollbarUI.disable_gamepad_input(arg_7_0, arg_7_1)
	arg_7_0._gamepad_input_disabled = arg_7_1
	arg_7_0._widgets_by_name.scrollbar.content.gamepad_input_disabled = arg_7_1
end

function ScrollbarUI._update_input(arg_8_0, arg_8_1, arg_8_2, arg_8_3, arg_8_4)
	if arg_8_0._input_disabled then
		return
	end

	local var_8_0 = arg_8_0._widgets_by_name.scrollbar
	local var_8_1 = Managers.input:is_device_active("gamepad")
	local var_8_2 = arg_8_0._ui_scenegraph

	if arg_8_3:get("left_press") then
		if UIUtils.is_button_hover(var_8_0, "scroller_hotspot") then
			arg_8_0:_calculate_input_offset(arg_8_3, var_8_2)
		elseif UIUtils.is_button_hover(var_8_0, "scrollbar_hotspot") then
			arg_8_0:_update_scroller_position(arg_8_3, var_8_2)
		end
	elseif arg_8_3:get("left_hold") and arg_8_0._progress_diff then
		arg_8_0:_update_scroller_position(arg_8_3, var_8_2)
	else
		arg_8_0._progress_diff = nil
	end

	local var_8_3 = 0

	if arg_8_0._horizontal_scrollbar then
		if var_8_1 and not arg_8_0._gamepad_input_disabled then
			local var_8_4 = arg_8_3:get("gamepad_right_axis")

			var_8_3 = var_8_4 and -var_8_4[1] or 0
		elseif UIUtils.is_button_hover(arg_8_0._scroll_area_hotspot_widget) then
			local var_8_5 = arg_8_3:get("scroll_axis")

			var_8_3 = var_8_5 and var_8_5[2] or 0
		end
	elseif var_8_1 and not arg_8_0._gamepad_input_disabled then
		local var_8_6 = arg_8_3:get("gamepad_right_axis")

		var_8_3 = var_8_6 and var_8_6[2] or 0
	elseif UIUtils.is_button_hover(arg_8_0._scroll_area_hotspot_widget) then
		local var_8_7 = arg_8_3:get("scroll_axis")

		var_8_3 = var_8_7 and var_8_7[2] or 0
	end

	if math.abs(var_8_3) == 0 then
		return
	end

	local var_8_8 = arg_8_0._horizontal_scrollbar and var_0_5 or var_0_4
	local var_8_9 = arg_8_0._progress - var_8_3 * var_8_8 / arg_8_0._excess_area

	arg_8_0._ui_animations.scroll = UIAnimation.init(UIAnimation.function_by_time, arg_8_0, "_progress", arg_8_0._progress, math.clamp(var_8_9, 0, 1), 0.5, math.easeOutCubic)
	arg_8_0._auto_scroll_enabled = false
end

function ScrollbarUI._calculate_input_offset(arg_9_0, arg_9_1, arg_9_2)
	local var_9_0 = arg_9_0._widgets_by_name.scrollbar.style
	local var_9_1 = arg_9_1:get("cursor")
	local var_9_2 = arg_9_2[arg_9_0._scroll_area_anchor_scenegraph_id]
	local var_9_3 = var_9_2.world_position
	local var_9_4 = var_9_2.size

	if arg_9_0._horizontal_scrollbar then
		local var_9_5 = var_9_3[1]
		local var_9_6 = var_9_3[1] + var_9_4[1]
		local var_9_7 = var_9_0.scroller.rect_size[1]
		local var_9_8 = UIInverseScaleVectorToResolution(var_9_1)[1]
		local var_9_9 = 1 - math.clamp(1 - math.inv_lerp(var_9_5 + var_9_7 * 0.5, var_9_6 - var_9_7 * 0.5, var_9_8), 0, 1)

		arg_9_0._progress_diff = arg_9_0._progress - var_9_9
	else
		local var_9_10 = var_9_3[2]
		local var_9_11 = var_9_3[2] + var_9_4[2]
		local var_9_12 = var_9_0.scroller.rect_size[2]
		local var_9_13 = UIInverseScaleVectorToResolution(var_9_1)[2]
		local var_9_14 = 1 - math.inv_lerp(var_9_10 + var_9_12 * 0.5, var_9_11 - var_9_12 * 0.5, var_9_13)

		arg_9_0._progress_diff = arg_9_0._progress - var_9_14
	end
end

function ScrollbarUI._update_scroller_position(arg_10_0, arg_10_1, arg_10_2)
	local var_10_0 = arg_10_0._widgets_by_name.scrollbar.style
	local var_10_1 = arg_10_1:get("cursor")
	local var_10_2 = arg_10_2[arg_10_0._scroll_area_anchor_scenegraph_id]
	local var_10_3 = var_10_2.world_position
	local var_10_4 = var_10_2.size

	if arg_10_0._horizontal_scrollbar then
		local var_10_5 = var_10_3[1]
		local var_10_6 = var_10_3[1] + var_10_4[1]
		local var_10_7 = var_10_0.scroller.rect_size[1]
		local var_10_8 = UIInverseScaleVectorToResolution(var_10_1)[1]

		arg_10_0._progress = 1 - (1 - math.inv_lerp(var_10_5 + var_10_7 * 0.5, var_10_6 - var_10_7 * 0.5, var_10_8))

		local var_10_9 = arg_10_0._progress_diff or 0

		arg_10_0._progress = math.clamp(arg_10_0._progress + var_10_9, 0, 1)
	else
		local var_10_10 = var_10_3[2]
		local var_10_11 = var_10_3[2] + var_10_4[2]
		local var_10_12 = var_10_0.scroller.rect_size[2]
		local var_10_13 = UIInverseScaleVectorToResolution(var_10_1)[2]

		arg_10_0._progress = 1 - math.inv_lerp(var_10_10 + var_10_12 * 0.5, var_10_11 - var_10_12 * 0.5, var_10_13)

		local var_10_14 = arg_10_0._progress_diff or 0

		arg_10_0._progress = math.clamp(arg_10_0._progress + var_10_14, 0, 1)
	end
end

function ScrollbarUI._update_scroller_progress(arg_11_0)
	arg_11_0._widgets_by_name.scrollbar.content.progress = arg_11_0._progress

	if arg_11_0._horizontal_scrollbar then
		arg_11_0._ui_scenegraph[arg_11_0._scroll_area_scenegraph_id].local_position[1] = -arg_11_0._excess_area * arg_11_0._progress
	else
		arg_11_0._ui_scenegraph[arg_11_0._scroll_area_scenegraph_id].local_position[2] = arg_11_0._excess_area * arg_11_0._progress
	end
end

function ScrollbarUI._update_scrollbar_hover_animations(arg_12_0)
	local var_12_0 = arg_12_0._widgets_by_name.scrollbar
	local var_12_1 = var_12_0.content
	local var_12_2 = var_12_0.style

	if UIUtils.is_button_hover(var_12_0, "scroller_hotspot") then
		arg_12_0._ui_animations.scroller_hotspot_anim = UIAnimation.init(UIAnimation.function_by_time, var_12_2.scroller.color, 1, var_12_2.scroller.color[1], 255, 0.25, math.easeOutCubic)
	else
		arg_12_0._ui_animations.scroller_hotspot_anim = UIAnimation.init(UIAnimation.function_by_time, var_12_2.scroller.color, 1, var_12_2.scroller.color[1], 128, 0.25, math.easeOutCubic)
	end

	if UIUtils.is_button_hover(var_12_0, "scrollbar_hotspot") then
		arg_12_0._ui_animations.scrollbar_hotspot_anim = UIAnimation.init(UIAnimation.function_by_time, var_12_2.scrollbar_bg_bg.color, 1, var_12_2.scrollbar_bg_bg.color[1], 255, 0.25, math.easeOutCubic)
	else
		arg_12_0._ui_animations.scrollbar_hotspot_anim = UIAnimation.init(UIAnimation.function_by_time, var_12_2.scrollbar_bg_bg.color, 1, var_12_2.scrollbar_bg_bg.color[1], 128, 0.25, math.easeOutCubic)
	end
end

function ScrollbarUI._update_animations(arg_13_0, arg_13_1, arg_13_2)
	local var_13_0 = arg_13_0._ui_animations

	for iter_13_0, iter_13_1 in pairs(var_13_0) do
		UIAnimation.update(iter_13_1, arg_13_1)

		if UIAnimation.completed(iter_13_1) then
			iter_13_1[iter_13_0] = nil
		end
	end
end

function ScrollbarUI._draw(arg_14_0, arg_14_1, arg_14_2, arg_14_3, arg_14_4, arg_14_5)
	local var_14_0 = arg_14_0._ui_scenegraph

	UIRenderer.begin_pass(arg_14_3, var_14_0, arg_14_4, arg_14_1, nil, arg_14_5)

	for iter_14_0, iter_14_1 in ipairs(arg_14_0._widgets) do
		UIRenderer.draw_widget(arg_14_3, iter_14_1)
	end

	if arg_14_0._internal_hotspot_widget then
		UIRenderer.draw_widget(arg_14_3, arg_14_0._internal_hotspot_widget)
	end

	UIRenderer.end_pass(arg_14_3)
end

function ScrollbarUI.destroy(arg_15_0, arg_15_1)
	arg_15_1[arg_15_0._scroll_area_scenegraph_id].local_position[2] = 0
	arg_15_0._scroll_area_scenegraph_id = nil
	arg_15_0._scroll_area_anchor_scenegraph_id = nil
	arg_15_0._excess_area = nil
	arg_15_0._scrollbar_wait_timer = nil
	arg_15_0._scrollbar_timer = nil
end
