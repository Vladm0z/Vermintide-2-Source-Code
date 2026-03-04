-- chunkname: @scripts/ui/text_popup/text_popup_ui.lua

local var_0_0 = local_require("scripts/ui/text_popup/text_popup_ui_definitions")
local var_0_1 = var_0_0.scenegraph_definition
local var_0_2 = var_0_0.generic_input_actions
local var_0_3 = var_0_1.text_entry.size[2]

TextPopupUI = class(TextPopupUI)

TextPopupUI.init = function (arg_1_0, arg_1_1)
	arg_1_0._ui_top_renderer = arg_1_1.ui_top_renderer
	arg_1_0._input_manager = arg_1_1.input_manager
	arg_1_0._render_settings = {
		snap_pixel_positions = true
	}

	arg_1_0:_create_ui_elements()
	arg_1_0:_setup_input()

	local var_1_0 = arg_1_0._input_manager:get_service("Text")

	arg_1_0._menu_input_description = MenuInputDescriptionUI:new(arg_1_1, arg_1_0._ui_top_renderer, var_1_0, 3, 900, var_0_2.default)

	arg_1_0._menu_input_description:set_input_description(nil)
end

TextPopupUI._setup_input = function (arg_2_0)
	arg_2_0._input_manager:create_input_service("Text", "IngameMenuKeymaps", "IngameMenuFilters")
	arg_2_0._input_manager:map_device_to_service("Text", "keyboard")
	arg_2_0._input_manager:map_device_to_service("Text", "mouse")
	arg_2_0._input_manager:map_device_to_service("Text", "gamepad")
end

TextPopupUI._create_ui_elements = function (arg_3_0)
	arg_3_0._ui_scenegraph = UISceneGraph.init_scenegraph(var_0_1)

	local var_3_0 = var_0_0.widget_definitions

	arg_3_0._widgets = {}
	arg_3_0._widgets_by_name = {}
	arg_3_0._buttons = {}

	for iter_3_0, iter_3_1 in pairs(var_3_0) do
		local var_3_1 = UIWidget.init(iter_3_1)

		arg_3_0._widgets[#arg_3_0._widgets + 1] = var_3_1

		if string.ends_with(iter_3_0, "_button") then
			arg_3_0._buttons[iter_3_0] = var_3_1
		else
			arg_3_0._widgets_by_name[iter_3_0] = var_3_1
		end
	end
end

TextPopupUI.show = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3)
	if arg_4_0._draw_widgets and arg_4_0.is_visible then
		print("TextPopupUI is already visible")

		return
	end

	if arg_4_3 then
		arg_4_0._on_close_callback = arg_4_3
	end

	arg_4_0._widgets_by_name.title_text.content.text = Localize(arg_4_1)
	arg_4_0._widgets_by_name.overlay_text.content.text = Localize(arg_4_2)

	arg_4_0:_update_scroll_height(0)

	arg_4_0._draw_widgets = true
	arg_4_0.is_visible = true

	ShowCursorStack.show("TextPopupUI")
	arg_4_0._input_manager:capture_input({
		"keyboard",
		"gamepad",
		"mouse"
	}, 1, "Text", "TextPopupUI")
end

TextPopupUI.hide = function (arg_5_0)
	if not arg_5_0._draw_widgets and not arg_5_0.is_visible then
		return
	end

	arg_5_0._draw_widgets = false
	arg_5_0.is_visible = false

	ShowCursorStack.hide("TextPopupUI")
	arg_5_0._input_manager:release_input({
		"keyboard",
		"gamepad",
		"mouse"
	}, 1, "Text", "TextPopupUI")

	if arg_5_0._on_close_callback then
		arg_5_0._on_close_callback()

		arg_5_0._on_close_callback = nil
	end
end

TextPopupUI.update = function (arg_6_0, arg_6_1)
	if not arg_6_0.is_visible or not arg_6_0._draw_widgets then
		return
	end

	if arg_6_0:_button_clicked("ok_button") then
		arg_6_0:hide()

		return
	end

	arg_6_0:_update_mouse_scroll_input()
	arg_6_0:_update_gamepad_scroll_input()
	arg_6_0:_draw(arg_6_1)
end

TextPopupUI.post_update = function (arg_7_0, arg_7_1)
	return
end

TextPopupUI.post_render = function (arg_8_0)
	return
end

TextPopupUI._update_scroll_height = function (arg_9_0, arg_9_1)
	local var_9_0 = UIUtils.get_text_height(arg_9_0._ui_top_renderer, var_0_0.scenegraph_definition.text_entry.size, var_0_0.scroll_text_style, arg_9_0._widgets_by_name.overlay_text.content.text)

	arg_9_0._total_scroll_height = math.max(var_9_0 - var_0_3, 0)

	arg_9_0:_setup_scrollbar(var_9_0, arg_9_1)
end

TextPopupUI._setup_scrollbar = function (arg_10_0, arg_10_1, arg_10_2)
	local var_10_0 = arg_10_0._widgets_by_name.scrollbar
	local var_10_1 = var_10_0.scenegraph_id
	local var_10_2 = arg_10_0._ui_scenegraph[var_10_1].size[2]
	local var_10_3 = math.min(var_10_2 / arg_10_1, 1)

	var_10_0.content.scroll_bar_info.bar_height_percentage = var_10_3

	arg_10_0:_set_scrollbar_value(arg_10_2 or 0)

	local var_10_4 = 2
	local var_10_5 = math.max(var_0_3 / arg_10_0._total_scroll_height, 0) * var_10_4

	arg_10_0._widgets_by_name.scroll_content.content.scroll_amount = var_10_5
end

TextPopupUI._update_mouse_scroll_input = function (arg_11_0)
	local var_11_0 = arg_11_0._widgets_by_name
	local var_11_1 = var_11_0.scrollbar
	local var_11_2 = var_11_0.scroll_content

	if var_11_1.content.scroll_bar_info.on_pressed then
		var_11_2.content.scroll_add = nil
	end

	local var_11_3 = var_11_2.content.scroll_value

	if not var_11_3 then
		return
	end

	local var_11_4 = var_11_1.content.scroll_bar_info.value
	local var_11_5 = arg_11_0._scroll_value or 0

	if var_11_5 ~= var_11_3 then
		arg_11_0:_set_scrollbar_value(var_11_3)
	elseif var_11_5 ~= var_11_4 then
		arg_11_0:_set_scrollbar_value(var_11_4)
	end
end

TextPopupUI._update_gamepad_scroll_input = function (arg_12_0)
	if not Managers.input:is_device_active("gamepad") then
		return
	end

	local var_12_0 = arg_12_0._input_manager:get_service("Text"):get("gamepad_left_axis")

	if math.abs(var_12_0.y) == 0 then
		return
	end

	local var_12_1 = arg_12_0._widgets_by_name.scroll_content.content

	var_12_1.scroll_add = var_12_1.scroll_amount * var_12_0.y * -1 * 0.1
end

TextPopupUI._set_scrollbar_value = function (arg_13_0, arg_13_1)
	if arg_13_1 then
		local var_13_0 = arg_13_0._widgets_by_name

		var_13_0.scrollbar.content.scroll_bar_info.value = arg_13_1
		var_13_0.scroll_content.content.scroll_value = arg_13_1
		arg_13_0._scroll_value = arg_13_1

		local var_13_1 = "text_entry"
		local var_13_2 = arg_13_0._ui_scenegraph
		local var_13_3 = var_0_1[var_13_1].position

		var_13_2[var_13_1].local_position[2] = var_13_3[2] + arg_13_1 * arg_13_0._total_scroll_height
	end
end

TextPopupUI._draw = function (arg_14_0, arg_14_1)
	local var_14_0 = arg_14_0._ui_top_renderer
	local var_14_1 = arg_14_0._ui_scenegraph
	local var_14_2 = arg_14_0._input_manager:get_service("Text")
	local var_14_3 = Managers.input:is_device_active("gamepad")
	local var_14_4 = arg_14_0._render_settings

	for iter_14_0, iter_14_1 in pairs(arg_14_0._buttons) do
		arg_14_0:_animate_button(iter_14_1, arg_14_1)
	end

	UIRenderer.begin_pass(var_14_0, var_14_1, var_14_2, arg_14_1, nil, var_14_4)

	for iter_14_2, iter_14_3 in ipairs(arg_14_0._widgets) do
		UIRenderer.draw_widget(var_14_0, iter_14_3)
	end

	UIRenderer.end_pass(var_14_0)

	if var_14_3 then
		arg_14_0._menu_input_description:draw(var_14_0, arg_14_1)
	end
end

TextPopupUI._button_clicked = function (arg_15_0, arg_15_1)
	local var_15_0 = arg_15_0._buttons[arg_15_1].content.button_hotspot.on_release

	var_15_0 = Managers.input:is_device_active("gamepad") and arg_15_1 == "ok_button" and arg_15_0._input_manager:get_service("Text"):get("confirm") or var_15_0

	if var_15_0 then
		arg_15_0._buttons[arg_15_1].content.button_hotspot.on_release = false
	end

	return var_15_0
end

TextPopupUI._animate_button = function (arg_16_0, arg_16_1, arg_16_2)
	local var_16_0 = arg_16_1.content
	local var_16_1 = arg_16_1.style
	local var_16_2 = var_16_0.button_hotspot
	local var_16_3 = var_16_2.is_hover
	local var_16_4 = var_16_2.is_selected
	local var_16_5 = var_16_2.is_clicked and var_16_2.is_clicked == 0
	local var_16_6 = var_16_2.input_progress or 0
	local var_16_7 = var_16_2.hover_progress or 0
	local var_16_8 = var_16_2.selection_progress or 0
	local var_16_9 = 8
	local var_16_10 = 20

	if var_16_5 then
		var_16_6 = math.min(var_16_6 + arg_16_2 * var_16_10, 1)
	else
		var_16_6 = math.max(var_16_6 - arg_16_2 * var_16_10, 0)
	end

	if var_16_3 then
		var_16_7 = math.min(var_16_7 + arg_16_2 * var_16_9, 1)
	else
		var_16_7 = math.max(var_16_7 - arg_16_2 * var_16_9, 0)
	end

	if var_16_4 then
		var_16_8 = math.min(var_16_8 + arg_16_2 * var_16_9, 1)
	else
		var_16_8 = math.max(var_16_8 - arg_16_2 * var_16_9, 0)
	end

	local var_16_11 = math.max(var_16_7, var_16_8)

	var_16_1.clicked_rect.color[1] = 100 * var_16_6

	local var_16_12 = 255 * var_16_7

	var_16_1.hover_glow.color[1] = var_16_12

	local var_16_13 = var_16_1.title_text_disabled
	local var_16_14 = var_16_13.default_text_color
	local var_16_15 = var_16_13.text_color

	var_16_15[2] = var_16_14[2] * 0.4
	var_16_15[3] = var_16_14[3] * 0.4
	var_16_15[4] = var_16_14[4] * 0.4
	var_16_2.hover_progress = var_16_7
	var_16_2.input_progress = var_16_6
	var_16_2.selection_progress = var_16_8

	local var_16_16 = var_16_1.title_text
	local var_16_17 = var_16_16.text_color
	local var_16_18 = var_16_16.default_text_color
	local var_16_19 = var_16_16.select_text_color

	Colors.lerp_color_tables(var_16_18, var_16_19, var_16_11, var_16_17)
end

TextPopupUI.destroy = function (arg_17_0)
	arg_17_0._draw_widgets = false
	arg_17_0.is_visible = false
	arg_17_0._widgets = nil
	arg_17_0._widgets_by_name = nil
	arg_17_0._buttons = nil
	arg_17_0._on_close_callback = nil
end
