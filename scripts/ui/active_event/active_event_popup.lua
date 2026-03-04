-- chunkname: @scripts/ui/active_event/active_event_popup.lua

require("scripts/ui/dlc_upsell/common_popup")

ActiveEventPopup = class(ActiveEventPopup, CommonPopup)

ActiveEventPopup.create_ui_elements = function (arg_1_0)
	ActiveEventPopup.super.create_ui_elements(arg_1_0)

	local var_1_0 = arg_1_0._common_settings

	arg_1_0._widgets_by_name.window_background.content.texture_id = var_1_0.background_texture
	arg_1_0._widgets_by_name.window_background.offset[1] = 100

	local var_1_1 = var_1_0.body_text and Localize(var_1_0.body_text) or ""

	if var_1_1 ~= "" and var_1_0.event_name then
		var_1_1 = string.format(var_1_1, var_1_0.event_name)
	end

	if var_1_0.logo_data then
		local var_1_2 = var_1_0.logo_data

		arg_1_0._widgets_by_name.logo.content.texture_id = var_1_2.logo_texture and var_1_2.logo_texture or "hero_view_home_logo"
		arg_1_0._widgets_by_name.logo.style.texture_id.texture_size = var_1_2.size and var_1_2.size or {
			468,
			236.39999999999998
		}
		arg_1_0._widgets_by_name.logo.offset = var_1_2.offset and var_1_2.offset or {
			-234,
			-118.19999999999999,
			1
		}
	end

	arg_1_0._widgets_by_name.body_text.content.text = var_1_1
	arg_1_0._widgets_by_name.close_button.content.title_text = Localize(var_1_0.button_text)

	if var_1_0.top_detail_texture then
		arg_1_0._widgets_by_name.window_top_detail.content.texture_id = var_1_0.top_detail_texture.texture
		arg_1_0._widgets_by_name.window_top_detail.style.texture_id.size = var_1_0.top_detail_texture.size
		arg_1_0._widgets_by_name.window_top_detail.style.texture_id.offset = var_1_0.top_detail_texture.offset
	end

	if var_1_0.action_buttons then
		arg_1_0._action_button_widgets = {}

		local var_1_3 = var_1_0.action_buttons

		for iter_1_0 = 1, #var_1_3 do
			local var_1_4 = var_1_3[iter_1_0]
			local var_1_5 = var_1_4.button_text
			local var_1_6 = {
				360,
				60
			}
			local var_1_7 = arg_1_0._definitions.create_simple_action_button("action_buttons_anchor", var_1_6, var_1_5, "button_frame_02_gold")
			local var_1_8 = UIWidget.init(var_1_7)

			var_1_8.offset[1] = -(var_1_6[1] * 0.5)
			var_1_8.offset[2] = 80 * (#var_1_3 - iter_1_0)
			var_1_8.content.on_pressed = callback(var_1_4.on_pressed)
			arg_1_0._action_button_widgets[#arg_1_0._action_button_widgets + 1] = var_1_8
		end
	end

	arg_1_0._selected_button_idx = #arg_1_0._action_button_widgets
	arg_1_0._buttons_amount = #arg_1_0._action_button_widgets
	arg_1_0._action_button_widgets[#arg_1_0._action_button_widgets].content.button_hotspot.is_selected = true
end

ActiveEventPopup.update = function (arg_2_0, arg_2_1)
	if arg_2_0:should_show() and not arg_2_0._has_widget_been_closed then
		arg_2_0:show()
	end

	ActiveEventPopup.super.update(arg_2_0, arg_2_1)
end

ActiveEventPopup.draw = function (arg_3_0, arg_3_1)
	ActiveEventPopup.super.draw(arg_3_0, arg_3_1)

	local var_3_0 = arg_3_0._ui_top_renderer
	local var_3_1 = arg_3_0._ui_scenegraph
	local var_3_2 = arg_3_0:_get_input_service()
	local var_3_3 = arg_3_0._render_settings
	local var_3_4 = Managers.input:is_device_active("gamepad")

	UIRenderer.begin_pass(var_3_0, var_3_1, var_3_2, arg_3_1, nil, var_3_3)

	if arg_3_0._action_button_widgets then
		UIRenderer.draw_all_widgets(var_3_0, arg_3_0._action_button_widgets)
	end

	UIRenderer.end_pass(var_3_0)
	arg_3_0:_update_scrolling_background(arg_3_1)
end

ActiveEventPopup._handle_input = function (arg_4_0, arg_4_1)
	local var_4_0 = arg_4_0:_get_input_service()
	local var_4_1 = arg_4_0._widgets_by_name
	local var_4_2 = Managers.input:is_device_active("gamepad")

	if var_4_2 then
		arg_4_0:_handle_gamepad_selection(arg_4_1, var_4_0)
	else
		arg_4_0:_handle_mouse_selection(arg_4_1, var_4_0)
	end

	for iter_4_0, iter_4_1 in ipairs(arg_4_0._action_button_widgets) do
		iter_4_1.content.button_hotspot.is_selected = var_4_2 and iter_4_0 == arg_4_0._selected_button_idx
	end

	if var_4_2 and var_4_0:get("confirm_press", true) then
		arg_4_0:play_sound("Play_gui_event_ui_select")

		local var_4_3 = arg_4_0._action_button_widgets[arg_4_0._selected_button_idx].content

		if var_4_3.on_pressed then
			local var_4_4 = {
				on_exit_func = var_4_3.on_pressed
			}

			arg_4_0:_on_close(var_4_4)
		end
	end

	if not arg_4_0._has_widget_been_closed and (UIUtils.is_button_pressed(var_4_1.close_button) or var_4_0:get("back", true) or var_4_0:get("toggle_menu", true)) then
		arg_4_0:_on_close()

		return
	end
end

ActiveEventPopup._handle_gamepad_selection = function (arg_5_0, arg_5_1, arg_5_2)
	if arg_5_0._action_button_widgets then
		local var_5_0 = arg_5_0._action_button_widgets
		local var_5_1 = arg_5_0._selected_button_idx

		if arg_5_2:get("move_up") then
			var_5_1 = var_5_1 + 1 <= arg_5_0._buttons_amount and var_5_1 + 1 or 1

			arg_5_0:play_sound("play_gui_start_menu_button_hover")
		elseif arg_5_2:get("move_down") then
			var_5_1 = var_5_1 - 1 >= 1 and var_5_1 - 1 or arg_5_0._buttons_amount

			arg_5_0:play_sound("play_gui_start_menu_button_hover")
		end

		if var_5_1 ~= arg_5_0._selected_button_idx then
			arg_5_0._selected_button_idx = var_5_1
		end
	end
end

ActiveEventPopup._handle_mouse_selection = function (arg_6_0, arg_6_1, arg_6_2)
	if arg_6_0._action_button_widgets then
		local var_6_0 = arg_6_0._action_button_widgets

		for iter_6_0 = 1, #var_6_0 do
			local var_6_1 = var_6_0[iter_6_0]

			if UIUtils.is_button_hover_enter(var_6_1) then
				arg_6_0:play_sound("play_gui_start_menu_button_hover")
			end

			if UIUtils.is_button_pressed(var_6_1) then
				arg_6_0:play_sound("Play_gui_event_ui_select")

				local var_6_2 = var_6_1.content

				if var_6_2.on_pressed then
					local var_6_3 = {
						on_exit_func = var_6_2.on_pressed
					}

					arg_6_0:_on_close(var_6_3)

					return
				end
			end
		end
	end
end

ActiveEventPopup._on_close = function (arg_7_0, arg_7_1)
	arg_7_0._has_widget_been_closed = true

	arg_7_0:release_input()
	arg_7_0:hide(arg_7_1)
end

ActiveEventPopup.show = function (arg_8_0)
	ActiveEventPopup.super.show(arg_8_0)
	arg_8_0:_start_transition_animation("on_enter")
	arg_8_0:play_sound("Play_gui_event_ui_open")

	local var_8_0 = Managers.world:world("level_world")

	World.set_data(var_8_0, "fullscreen_blur", 0.5)
end

ActiveEventPopup.hide = function (arg_9_0, arg_9_1)
	arg_9_0._exit_anim_id = arg_9_0:_start_transition_animation("on_exit", arg_9_1)

	local var_9_0 = Managers.world:world("level_world")

	World.set_data(var_9_0, "fullscreen_blur", nil)
end

ActiveEventPopup._start_transition_animation = function (arg_10_0, arg_10_1, arg_10_2)
	local var_10_0 = {
		wwise_world = arg_10_0._wwise_world,
		render_settings = arg_10_0._render_settings
	}

	if arg_10_2 then
		for iter_10_0, iter_10_1 in pairs(arg_10_2) do
			var_10_0[iter_10_0] = iter_10_1
		end
	end

	return arg_10_0._ui_animator:start_animation(arg_10_1, nil, arg_10_0._definitions.scenegraph_definition, var_10_0)
end

ActiveEventPopup._update_animations = function (arg_11_0, arg_11_1)
	ActiveEventPopup.super._update_animations(arg_11_0, arg_11_1)

	if arg_11_0._exit_anim_id and arg_11_0._ui_animator:is_animation_completed(arg_11_0._exit_anim_id) then
		arg_11_0._is_visible = false
	end

	local var_11_0 = arg_11_0._widgets_by_name

	UIWidgetUtils.animate_default_button(var_11_0.close_button, arg_11_1)
end

ActiveEventPopup.should_show = function (arg_12_0)
	return arg_12_0._ui_context.is_in_inn and Managers.popup:has_popup() == false and arg_12_0._ui_context.ingame_ui.current_view == nil and arg_12_0._ui_context.ingame_ui.has_left_menu and not arg_12_0._is_visible
end

ActiveEventPopup._update_scrolling_background = function (arg_13_0, arg_13_1)
	local var_13_0 = arg_13_0._widgets_by_name.window_background
	local var_13_1 = 100 + 150 * math.sin(Managers.time:time("ui") * 0.1)

	var_13_0.offset[1] = var_13_1
end
