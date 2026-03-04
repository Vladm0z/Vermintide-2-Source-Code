-- chunkname: @scripts/ui/dlc_upsell/upsell_popup.lua

require("scripts/ui/dlc_upsell/common_popup")

UpsellPopup = class(UpsellPopup, CommonPopup)

UpsellPopup.create_ui_elements = function (arg_1_0)
	UpsellPopup.super.create_ui_elements(arg_1_0)

	local var_1_0 = arg_1_0._common_settings

	arg_1_0._widgets_by_name.window_background.content.texture_id = var_1_0.background_texture
	arg_1_0._widgets_by_name.title_text.content.text = Localize(var_1_0.title_text)
	arg_1_0._widgets_by_name.body_text.content.text = Localize(var_1_0.body_text)
	arg_1_0._widgets_by_name.store_button.content.title_text = Localize(var_1_0.button_text)
	arg_1_0._widgets_by_name.ok_button.content.title_text = Localize(var_1_0.ok_button_text)
end

UpsellPopup.update = function (arg_2_0, arg_2_1)
	UpsellPopup.super.update(arg_2_0, arg_2_1)

	if arg_2_0:should_show() and not arg_2_0._has_widget_been_closed then
		arg_2_0:show()
	end
end

UpsellPopup._handle_input = function (arg_3_0, arg_3_1)
	local var_3_0 = arg_3_0:_get_input_service()

	if var_3_0:get("toggle_menu", true) or var_3_0:get("back", true) then
		arg_3_0._has_widget_been_closed = true

		arg_3_0:hide()

		return
	end

	local var_3_1 = arg_3_0._widgets_by_name

	if UIUtils.is_button_pressed(var_3_1.ok_button) or var_3_0:get("back", true) then
		arg_3_0._has_widget_been_closed = true

		arg_3_0:hide()

		return
	end

	if UIUtils.is_button_pressed(var_3_1.store_button) or var_3_0:get("confirm_press", true) then
		Managers.unlock:open_dlc_page(arg_3_0._name)

		return
	end
end

UpsellPopup._start_transition_animation = function (arg_4_0, arg_4_1)
	return arg_4_0._ui_animator:start_animation(arg_4_1, nil, arg_4_0._common_settings.definitions.scenegraph_definition, {
		wwise_world = arg_4_0._wwise_world,
		render_settings = arg_4_0._render_settings
	})
end

UpsellPopup._update_animations = function (arg_5_0, arg_5_1)
	UpsellPopup.super._update_animations(arg_5_0, arg_5_1)

	local var_5_0 = arg_5_0._widgets_by_name

	UIWidgetUtils.animate_default_button(var_5_0.ok_button, arg_5_1)
	UIWidgetUtils.animate_default_button(var_5_0.store_button, arg_5_1)
end
