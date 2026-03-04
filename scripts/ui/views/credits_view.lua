-- chunkname: @scripts/ui/views/credits_view.lua

local var_0_0 = local_require("scripts/settings/credits")
local var_0_1 = local_require("scripts/ui/views/credits_view_definitions")
local var_0_2 = {
	header = Colors.color_definitions.credits_header,
	title = Colors.color_definitions.credits_title,
	normal = Colors.color_definitions.credits_normal
}
local var_0_3 = {
	legal = 15,
	normal = 30
}

CreditsView = class(CreditsView)

CreditsView.init = function (arg_1_0, arg_1_1)
	arg_1_0._ui_renderer = arg_1_1.ui_renderer
	arg_1_0._ui_top_renderer = arg_1_1.ui_top_renderer
	arg_1_0._ingame_ui = arg_1_1.ingame_ui
	arg_1_0._in_title_screen = arg_1_1.in_title_screen

	local var_1_0 = arg_1_1.input_manager

	arg_1_0._input_manager = var_1_0

	var_1_0:create_input_service("credits_view", "IngameMenuKeymaps", "IngameMenuFilters")
	var_1_0:map_device_to_service("credits_view", "keyboard")
	var_1_0:map_device_to_service("credits_view", "mouse")
	var_1_0:map_device_to_service("credits_view", "gamepad")
	arg_1_0:_create_ui_elements()
end

CreditsView._create_ui_elements = function (arg_2_0)
	arg_2_0._num_credits = #var_0_0.entries
	arg_2_0._current_offset = 0
	arg_2_0._ui_scenegraph = UISceneGraph.init_scenegraph(var_0_1.scenegraph_definition)
	arg_2_0._credits_widget = UIWidget.init(var_0_1.widget_definitions.credits)
	arg_2_0._back_button_widget = UIWidget.init(var_0_1.widget_definitions.back_button)
end

CreditsView.input_service = function (arg_3_0)
	return arg_3_0._input_manager:get_service("credits_view")
end

CreditsView.on_enter = function (arg_4_0)
	arg_4_0._input_manager:capture_input(ALL_INPUT_METHODS, 1, "credits_view", "CreditsView")

	arg_4_0._current_offset = 0
	arg_4_0._active = true

	UIWidgetUtils.reset_layout_button(arg_4_0._back_button_widget)
end

CreditsView.on_exit = function (arg_5_0)
	arg_5_0._input_manager:release_input(ALL_INPUT_METHODS, 1, "credits_view", "CreditsView")

	arg_5_0.active = nil
	arg_5_0.exiting = nil

	Managers.music:trigger_event(IS_WINDOWS and "Play_console_menu_back" or "Play_console_menu_select")
end

CreditsView.exit = function (arg_6_0, arg_6_1)
	local var_6_0 = arg_6_1 and "exit_menu" or "ingame_menu"

	arg_6_0.ingame_ui:handle_transition(var_6_0)

	arg_6_0.exiting = nil
end

CreditsView.update = function (arg_7_0, arg_7_1)
	local var_7_0 = arg_7_0._input_manager
	local var_7_1 = var_7_0:get_service("credits_view")
	local var_7_2 = var_7_0:is_device_active("gamepad")

	if var_7_1:get("toggle_menu", true) or var_7_2 and var_7_1:get("back", true) then
		arg_7_0:exit()

		return
	end

	local var_7_3 = var_7_2 and var_7_1:get("gamepad_left_axis") or var_7_1:get("scroll_axis")
	local var_7_4 = var_7_3.y

	if not var_7_2 and IS_XB1 then
		var_7_4 = math.sign(var_7_3.x) * 5
	end

	local var_7_5 = math.max(0, arg_7_0._current_offset + arg_7_1 * 50 - var_7_4 * 30)

	arg_7_0._current_offset = var_7_5

	local var_7_6 = arg_7_0._ui_top_renderer
	local var_7_7 = arg_7_0._credits_widget
	local var_7_8 = var_7_7.content
	local var_7_9 = var_7_7.style

	UIRenderer.begin_pass(var_7_6, arg_7_0._ui_scenegraph, var_7_1, arg_7_1)

	local var_7_10 = RESOLUTION_LOOKUP.res_w
	local var_7_11 = RESOLUTION_LOOKUP.res_h
	local var_7_12 = RESOLUTION_LOOKUP.inv_scale

	UIRenderer.draw_texture(var_7_6, "gradient_credits_menu", Vector3(0, 0, UILayer.credits_gradient), Vector2(var_7_10 * var_7_12, var_7_11 * var_7_12))

	local var_7_13 = var_0_0.entries

	for iter_7_0 = 1, arg_7_0._num_credits do
		local var_7_14 = var_7_13[iter_7_0]

		var_7_8.text_field = var_7_14.localized_str or var_7_14.localized and Localize(var_7_14.text) or var_7_14.text
		var_7_14.localized_str = var_7_8.text_field

		if var_7_14.type == "header" then
			var_7_9.text.text_color = var_0_2.header
			var_7_9.text.font_size = var_0_3.normal
			var_7_5 = var_7_5 - 84 - 5
		elseif var_7_14.type == "title" then
			var_7_9.text.text_color = var_0_2.title
			var_7_9.text.font_size = var_0_3.normal
			var_7_5 = var_7_5 - 64 - 5
		elseif var_7_14.type == "legal" then
			var_7_9.text.text_color = var_0_2.normal
			var_7_9.text.font_size = var_0_3.legal
			var_7_5 = var_7_5 - 15 - 5
		else
			var_7_9.text.text_color = var_0_2.normal
			var_7_9.text.font_size = var_0_3.normal
			var_7_5 = var_7_5 - 30 - 5
		end

		if var_7_5 < -84 then
			break
		elseif var_7_5 < var_7_11 then
			var_7_7.offset[2] = var_7_5

			UIRenderer.draw_widget(var_7_6, var_7_7)
		end
	end

	if arg_7_0._in_title_screen then
		arg_7_0:_handle_back_button(var_7_6, arg_7_1)
	end

	if var_7_5 > 1200 then
		arg_7_0._current_offset = 0
	end

	UIRenderer.end_pass(var_7_6)
end

CreditsView._handle_back_button = function (arg_8_0, arg_8_1, arg_8_2)
	if not Managers.input:is_device_active("mouse") then
		return
	end

	local var_8_0 = arg_8_0._back_button_widget

	UIWidgetUtils.animate_layout_button(var_8_0, arg_8_2)
	UIRenderer.draw_widget(arg_8_1, var_8_0)

	if UIUtils.is_button_pressed(var_8_0, "button_hotspot") then
		arg_8_0:exit()
	end
end
