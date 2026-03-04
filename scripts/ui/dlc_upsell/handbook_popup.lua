-- chunkname: @scripts/ui/dlc_upsell/handbook_popup.lua

require("scripts/ui/helpers/handbook_logic")

local var_0_0 = local_require("scripts/ui/views/hero_view/states/definitions/hero_view_state_handbook_definitions").content_blueprints
local var_0_1 = local_require("scripts/ui/dlc_upsell/handbook_popup_definitions")
local var_0_2 = var_0_1.generic_input_actions
local var_0_3 = var_0_1.achievement_window_size[2]

HandbookPopup = class(HandbookPopup, CommonPopup)

HandbookPopup.init = function (arg_1_0, arg_1_1, arg_1_2, arg_1_3)
	HandbookPopup.super.init(arg_1_0, arg_1_1, arg_1_2, arg_1_3)

	arg_1_0._input_manager = arg_1_1.input_manager
	arg_1_0._render_settings = {
		alpha_multiplier = 1,
		snap_pixel_positions = false
	}
	arg_1_0._active_pages = arg_1_3.pages
	arg_1_0._current_page = 1
	arg_1_0._total_pages = #arg_1_0._active_pages

	local var_1_0 = arg_1_3.pages[1]

	SaveData.seen_handbook_pages = SaveData.seen_handbook_pages or {}
	SaveData.seen_handbook_pages[var_1_0] = true
	arg_1_0._has_widget_been_closed = false
end

HandbookPopup.destroy = function (arg_2_0)
	HandbookPopup.super.destroy(arg_2_0)
	arg_2_0._handbook_logic:delete()
end

HandbookPopup.create_ui_elements = function (arg_3_0)
	HandbookPopup.super.create_ui_elements(arg_3_0)

	local var_3_0 = {
		scenegraph_id = "achievement_root",
		ui_renderer = arg_3_0._ui_top_renderer,
		world = arg_3_0._ui_context.world
	}

	arg_3_0._handbook_logic = HandbookLogic:new(var_3_0, var_0_0)
end

HandbookPopup.show = function (arg_4_0)
	HandbookPopup.super.show(arg_4_0)
	arg_4_0:_start_transition_animation("on_enter")
	arg_4_0:play_sound("Play_gui_handbook_popup")
	arg_4_0:set_fullscreen_effect_enable_state(true)
end

HandbookPopup.hide = function (arg_5_0)
	arg_5_0:set_fullscreen_effect_enable_state(false)

	arg_5_0._exit_anim_id = arg_5_0:_start_transition_animation("on_exit")
end

HandbookPopup._start_transition_animation = function (arg_6_0, arg_6_1)
	return arg_6_0._ui_animator:start_animation(arg_6_1, nil, var_0_1.scenegraph_definition, {
		wwise_world = arg_6_0._wwise_world,
		render_settings = arg_6_0._render_settings
	})
end

HandbookPopup._update_animations = function (arg_7_0, arg_7_1)
	HandbookPopup.super._update_animations(arg_7_0, arg_7_1)

	if arg_7_0._exit_anim_id and arg_7_0._ui_animator:is_animation_completed(arg_7_0._exit_anim_id) then
		arg_7_0._is_visible = false
	end

	local var_7_0 = arg_7_0._widgets_by_name.exit_button

	UIWidgetUtils.animate_default_button(var_7_0, arg_7_1)
end

HandbookPopup._handle_input = function (arg_8_0, arg_8_1)
	if arg_8_0._has_widget_been_closed then
		return
	end

	HandbookPopup.super._handle_input(arg_8_0, arg_8_1)

	local var_8_0 = arg_8_0._widgets_by_name
	local var_8_1 = arg_8_0:_get_input_service()
	local var_8_2 = Managers.input:is_device_active("gamepad")

	arg_8_0:_set_gamepad_input_buttons_visibility(var_8_2)

	local var_8_3 = var_8_0.page_button_next
	local var_8_4 = var_8_0.page_button_previous

	UIWidgetUtils.animate_arrow_button(var_8_3, arg_8_1)
	UIWidgetUtils.animate_arrow_button(var_8_4, arg_8_1)

	if UIUtils.is_button_hover_enter(var_8_3) or UIUtils.is_button_hover_enter(var_8_4) then
		arg_8_0:play_sound("play_gui_inventory_next_hover")
	end

	if UIUtils.is_button_pressed(var_8_3) or var_8_1:get("cycle_next") then
		local var_8_5 = arg_8_0._current_page + 1

		if var_8_5 <= arg_8_0._total_pages then
			arg_8_0:_go_to_page(var_8_5)
			arg_8_0:play_sound("play_gui_cosmetics_inventory_next_click")
		end
	elseif UIUtils.is_button_pressed(var_8_4) or var_8_1:get("cycle_previous") then
		local var_8_6 = arg_8_0._current_page - 1

		if var_8_6 >= 1 then
			arg_8_0:_go_to_page(var_8_6)
			arg_8_0:play_sound("play_gui_cosmetics_inventory_next_click")
		end
	end

	if arg_8_0._content_widgets then
		arg_8_0:_update_mouse_scroll_input()
	end

	if UIUtils.is_button_pressed(var_8_0.exit_button) or var_8_1:get("back", true) or var_8_1:get("toggle_menu", true) then
		arg_8_0:hide()
		arg_8_0:release_input()

		arg_8_0._has_widget_been_closed = true

		arg_8_0:play_sound("Play_hud_button_close")

		return
	end
end

HandbookPopup._go_to_page = function (arg_9_0, arg_9_1)
	local var_9_0 = arg_9_0._active_pages[arg_9_1]
	local var_9_1 = HandbookSettings.pages[var_9_0]

	if not var_9_1 then
		return
	end

	local var_9_2, var_9_3 = arg_9_0._handbook_logic:create_entry_widgets(var_9_1)
	local var_9_4 = var_9_3 + 150

	arg_9_0._content_widgets = var_9_2
	arg_9_0._total_scroll_height = math.max(var_9_4 - var_0_3, 0)
	arg_9_0._scroll_value = nil

	arg_9_0:_setup_scrollbar(var_9_4)

	arg_9_0._current_page = arg_9_1

	arg_9_0:_update_page_info()
end

HandbookPopup._update_page_info = function (arg_10_0)
	local var_10_0 = arg_10_0._widgets_by_name
	local var_10_1 = arg_10_0._current_page
	local var_10_2 = arg_10_0._total_pages

	var_10_0.page_text_left.content.text = tostring(var_10_1)
	var_10_0.page_text_right.content.text = tostring(var_10_2)
	var_10_0.page_button_next.content.hotspot.disable_button = var_10_1 == var_10_2
	var_10_0.page_button_previous.content.hotspot.disable_button = var_10_1 == 1

	local var_10_3 = var_10_2 > 1

	var_10_0.page_button_next.content.visible = var_10_3
	var_10_0.page_button_previous.content.visible = var_10_3
	var_10_0.input_icon_next.content.visible = var_10_3
	var_10_0.input_icon_previous.content.visible = var_10_3
	var_10_0.input_arrow_next.content.visible = var_10_3
	var_10_0.input_arrow_previous.content.visible = var_10_3
	var_10_0.page_text_center.content.visible = var_10_3
	var_10_0.page_text_left.content.visible = var_10_3
	var_10_0.page_text_right.content.visible = var_10_3
	var_10_0.page_text_area.content.visible = var_10_3

	arg_10_0._menu_input_description:set_input_description(var_10_3 and var_0_2.has_pages or nil)
end

HandbookPopup.should_show = function (arg_11_0)
	return arg_11_0._ui_context.is_in_inn and not Managers.popup:has_popup() and not arg_11_0._is_visible and not Managers.unlock:is_waiting_for_gift_popup_ui()
end

HandbookPopup.update = function (arg_12_0, arg_12_1)
	HandbookPopup.super.update(arg_12_0, arg_12_1)

	if arg_12_0:should_show() and not arg_12_0._has_widget_been_closed then
		arg_12_0:show()
		arg_12_0:_go_to_page(1)
	end
end

HandbookPopup._setup_scrollbar = function (arg_13_0, arg_13_1, arg_13_2)
	local var_13_0 = arg_13_0._widgets_by_name.achievement_scrollbar
	local var_13_1 = var_13_0.scenegraph_id
	local var_13_2 = arg_13_0._ui_scenegraph[var_13_1].size[2]
	local var_13_3 = math.min(var_13_2 / arg_13_1, 1)

	var_13_0.content.scroll_bar_info.bar_height_percentage = var_13_3

	arg_13_0:_set_scrollbar_value(arg_13_2 or 0)

	local var_13_4 = 2
	local var_13_5 = math.max(110 / arg_13_0._total_scroll_height, 0) * var_13_4

	arg_13_0._widgets_by_name.achievement_window.content.scroll_amount = var_13_5
end

HandbookPopup._set_scrollbar_value = function (arg_14_0, arg_14_1)
	if arg_14_1 then
		local var_14_0 = arg_14_0._widgets_by_name

		var_14_0.achievement_scrollbar.content.scroll_bar_info.value = arg_14_1
		var_14_0.achievement_window.content.scroll_value = arg_14_1

		local var_14_1 = arg_14_0._total_scroll_height * arg_14_1

		arg_14_0._ui_scenegraph.achievement_root.position[2] = math.floor(var_14_1)
		arg_14_0._scroll_value = arg_14_1
	end
end

HandbookPopup._update_mouse_scroll_input = function (arg_15_0)
	local var_15_0 = true

	if var_15_0 then
		local var_15_1 = arg_15_0._widgets_by_name
		local var_15_2 = var_15_1.achievement_scrollbar
		local var_15_3 = var_15_1.achievement_window

		if var_15_2.content.scroll_bar_info.on_pressed then
			var_15_3.content.scroll_add = nil
		end

		local var_15_4 = var_15_3.content.scroll_value

		if not var_15_4 then
			return
		end

		local var_15_5 = var_15_2.content.scroll_bar_info.value
		local var_15_6 = arg_15_0._scroll_value

		if var_15_6 ~= var_15_4 then
			arg_15_0:_set_scrollbar_value(var_15_4)
		elseif var_15_6 ~= var_15_5 then
			arg_15_0:_set_scrollbar_value(var_15_5)
		end
	end
end

HandbookPopup._set_gamepad_input_buttons_visibility = function (arg_16_0, arg_16_1)
	local var_16_0 = arg_16_0._widgets_by_name
	local var_16_1 = arg_16_0._total_pages > 1

	arg_16_1 = arg_16_1 and var_16_1

	local var_16_2 = var_16_0.input_icon_next
	local var_16_3 = var_16_0.input_icon_previous
	local var_16_4 = var_16_0.input_arrow_next
	local var_16_5 = var_16_0.input_arrow_previous

	var_16_2.content.visible = arg_16_1
	var_16_3.content.visible = arg_16_1
	var_16_4.content.visible = arg_16_1
	var_16_5.content.visible = arg_16_1
end
