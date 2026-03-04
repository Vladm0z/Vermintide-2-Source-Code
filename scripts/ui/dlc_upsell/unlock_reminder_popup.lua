-- chunkname: @scripts/ui/dlc_upsell/unlock_reminder_popup.lua

require("scripts/ui/dlc_upsell/common_popup")

UnlockReminderPopup = class(UnlockReminderPopup, CommonPopup)

function UnlockReminderPopup.create_ui_elements(arg_1_0)
	UnlockReminderPopup.super.create_ui_elements(arg_1_0)

	local var_1_0 = arg_1_0._common_settings

	arg_1_0._widgets_by_name.window_background.content.texture_id = var_1_0.background_texture
	arg_1_0._widgets_by_name.body_text.content.text = var_1_0.body_text and Localize(var_1_0.body_text) or ""
	arg_1_0._widgets_by_name.ok_button.content.title_text = Localize(var_1_0.button_text)

	if var_1_0.top_detail_texture then
		arg_1_0._widgets_by_name.window_top_detail.content.texture_id = var_1_0.top_detail_texture.texture
		arg_1_0._widgets_by_name.window_top_detail.style.texture_id.size = var_1_0.top_detail_texture.size
		arg_1_0._widgets_by_name.window_top_detail.style.texture_id.offset = var_1_0.top_detail_texture.offset
	end
end

function UnlockReminderPopup.update(arg_2_0, arg_2_1)
	UnlockReminderPopup.super.update(arg_2_0, arg_2_1)

	if arg_2_0:should_show() and not arg_2_0._has_widget_been_closed then
		arg_2_0:show()
	end
end

function UnlockReminderPopup._handle_input(arg_3_0, arg_3_1)
	local var_3_0 = arg_3_0:_get_input_service()
	local var_3_1 = arg_3_0._widgets_by_name

	if not arg_3_0._has_widget_been_closed and (UIUtils.is_button_pressed(var_3_1.ok_button) or var_3_0:get("back", true) or var_3_0:get("confirm_press", true)) then
		arg_3_0._has_widget_been_closed = true
		SaveData.new_dlcs_unlocks[arg_3_0._dlc_name] = false

		Managers.save:auto_save(SaveFileName, SaveData)
		arg_3_0:release_input()
		arg_3_0:hide()

		return
	end
end

function UnlockReminderPopup.show(arg_4_0)
	UnlockReminderPopup.super.show(arg_4_0)
	arg_4_0:_start_transition_animation("on_enter")
end

function UnlockReminderPopup.hide(arg_5_0)
	arg_5_0._exit_anim_id = arg_5_0:_start_transition_animation("on_exit")
end

function UnlockReminderPopup._start_transition_animation(arg_6_0, arg_6_1)
	return arg_6_0._ui_animator:start_animation(arg_6_1, nil, arg_6_0._common_settings.definitions.scenegraph_definition, {
		wwise_world = arg_6_0._wwise_world,
		render_settings = arg_6_0._render_settings
	})
end

function UnlockReminderPopup._update_animations(arg_7_0, arg_7_1)
	UnlockReminderPopup.super._update_animations(arg_7_0, arg_7_1)

	if arg_7_0._exit_anim_id and arg_7_0._ui_animator:is_animation_completed(arg_7_0._exit_anim_id) then
		arg_7_0._is_visible = false
	end

	local var_7_0 = arg_7_0._widgets_by_name

	UIWidgetUtils.animate_default_button(var_7_0.ok_button, arg_7_1)
end

function UnlockReminderPopup.should_show(arg_8_0)
	return arg_8_0._ui_context.is_in_inn and Managers.popup:has_popup() == false and arg_8_0._ui_context.ingame_ui.current_view == nil and arg_8_0._ui_context.ingame_ui.has_left_menu and not arg_8_0._is_visible
end
