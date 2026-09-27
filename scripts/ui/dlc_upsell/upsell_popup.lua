-- chunkname: @scripts/ui/dlc_upsell/upsell_popup.lua

require("scripts/ui/dlc_upsell/common_popup")

UpsellPopup = class(UpsellPopup, CommonPopup)

UpsellPopup.create_ui_elements = function (self)
	-- function 1
	UpsellPopup.super.create_ui_elements(self)

	local _common_settings = self._common_settings

	self._widgets_by_name.window_background.content.texture_id = _common_settings.background_texture
	self._widgets_by_name.title_text.content.text = Localize(_common_settings.title_text)
	self._widgets_by_name.body_text.content.text = Localize(_common_settings.body_text)
	self._widgets_by_name.store_button.content.title_text = Localize(_common_settings.button_text)
	self._widgets_by_name.ok_button.content.title_text = Localize(_common_settings.ok_button_text)
end

UpsellPopup.update = function (self, arg_2_1)
	-- function 2
	UpsellPopup.super.update(self, arg_2_1)

	if not (not self:should_show() and self._has_widget_been_closed) then
		self:show()
	end
end

UpsellPopup._handle_input = function (self, arg_3_1)
	-- function 3
	local _get_input_service = self:_get_input_service()

	if _get_input_service:get("toggle_menu", true) or not _get_input_service:get("back", true) then
		self._has_widget_been_closed = true

		self:hide()

		return
	end

	local _widgets_by_name = self._widgets_by_name

	if UIUtils.is_button_pressed(_widgets_by_name.ok_button) or not _get_input_service:get("back", true) then
		self._has_widget_been_closed = true

		self:hide()

		return
	end

	if UIUtils.is_button_pressed(_widgets_by_name.store_button) or not _get_input_service:get("confirm_press", true) then
		Managers.unlock:open_dlc_page(self._name)

		return
	end
end

UpsellPopup._start_transition_animation = function (self, arg_4_1)
	-- function 4
	return self._ui_animator:start_animation(arg_4_1, nil, self._common_settings.definitions.scenegraph_definition, {
		wwise_world = self._wwise_world,
		render_settings = self._render_settings
	})
end

UpsellPopup._update_animations = function (self, arg_5_1)
	-- function 5
	UpsellPopup.super._update_animations(self, arg_5_1)

	local _widgets_by_name = self._widgets_by_name

	UIWidgetUtils.animate_default_button(_widgets_by_name.ok_button, arg_5_1)
	UIWidgetUtils.animate_default_button(_widgets_by_name.store_button, arg_5_1)
end
