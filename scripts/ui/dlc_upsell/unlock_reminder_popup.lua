-- chunkname: @scripts/ui/dlc_upsell/unlock_reminder_popup.lua

require("scripts/ui/dlc_upsell/common_popup")

UnlockReminderPopup = class(UnlockReminderPopup, CommonPopup)

UnlockReminderPopup.create_ui_elements = function (self)
	-- function 1
	UnlockReminderPopup.super.create_ui_elements(self)

	local reminder_settings = self._common_settings

	self._widgets_by_name.window_background.content.texture_id = reminder_settings.background_texture

	local content = self._widgets_by_name.body_text.content
	local var_1_1

	if reminder_settings.body_text then
		var_1_1 = Localize(reminder_settings.body_text)

		if not var_1_1 then
			-- Nothing
		end
	end

	var_1_1 = ""

	::label_1_0::

	content.text = var_1_1
	self._widgets_by_name.ok_button.content.title_text = Localize(reminder_settings.button_text)

	if reminder_settings.top_detail_texture then
		self._widgets_by_name.window_top_detail.content.texture_id = reminder_settings.top_detail_texture.texture
		self._widgets_by_name.window_top_detail.style.texture_id.size = reminder_settings.top_detail_texture.size
		self._widgets_by_name.window_top_detail.style.texture_id.offset = reminder_settings.top_detail_texture.offset
	end
end

UnlockReminderPopup.update = function (self, dt)
	-- function 2
	UnlockReminderPopup.super.update(self, dt)

	if self:should_show() and not self._has_widget_been_closed then
		self:show()
	end
end

UnlockReminderPopup._handle_input = function (self, dt)
	-- function 3
	local input_service = self:_get_input_service()
	local widgets_by_name = self._widgets_by_name

	if not self._has_widget_been_closed and (UIUtils.is_button_pressed(widgets_by_name.ok_button) or input_service:get("back", true) or input_service:get("confirm_press", true)) then
		self._has_widget_been_closed = true
		SaveData.new_dlcs_unlocks[self._dlc_name] = false

		Managers.save:auto_save(SaveFileName, SaveData)
		self:release_input()
		self:hide()

		return
	end
end

UnlockReminderPopup.show = function (self)
	-- function 4
	UnlockReminderPopup.super.show(self)
	self:_start_transition_animation("on_enter")
end

UnlockReminderPopup.hide = function (self)
	-- function 5
	self._exit_anim_id = self:_start_transition_animation("on_exit")
end

UnlockReminderPopup._start_transition_animation = function (self, animation_name)
	-- function 6
	return self._ui_animator:start_animation(animation_name, nil, self._common_settings.definitions.scenegraph_definition, {
		wwise_world = self._wwise_world,
		render_settings = self._render_settings
	})
end

UnlockReminderPopup._update_animations = function (self, dt)
	-- function 7
	UnlockReminderPopup.super._update_animations(self, dt)

	if self._exit_anim_id and self._ui_animator:is_animation_completed(self._exit_anim_id) then
		self._is_visible = false
	end

	local widgets_by_name = self._widgets_by_name

	UIWidgetUtils.animate_default_button(widgets_by_name.ok_button, dt)
end

UnlockReminderPopup.should_show = function (self)
	-- function 8
	local is_in_inn = self._ui_context.is_in_inn

	if is_in_inn then
		if Managers.popup:has_popup() == false and self._ui_context.ingame_ui.current_view == nil then
			is_in_inn = self._ui_context.ingame_ui.has_left_menu

			if is_in_inn then
				is_in_inn = not self._is_visible
			end
		else
			is_in_inn = false
		end
	end

	if false then
		is_in_inn = true
	end

	return is_in_inn
end
