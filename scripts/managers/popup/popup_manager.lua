-- chunkname: @scripts/managers/popup/popup_manager.lua

require("scripts/ui/views/popup_handler")

PopupManager = class(PopupManager)

PopupManager.init = function (self)
	-- function 1
	local top_world = Managers.world:world("top_ingame_view")

	self._ui_top_renderer = UIRenderer.create(top_world, "material", "materials/ui/ui_1080p_popup", "material", "materials/fonts/gw_fonts")

	local popup_context = {
		ui_renderer = self._ui_top_renderer,
		world = top_world
	}

	self:create_own_handler(popup_context)

	local poll_data = {
		num_updates = 0
	}

	self._poll_data = poll_data
end

PopupManager.create_own_handler = function (self, popup_context)
	-- function 2
	self._handler = PopupHandler:new(popup_context, true)
end

PopupManager.update = function (self, dt)
	-- function 3
	if self._handler then
		self._handler:update(dt, true)

		local popup_id, popup = self._handler:active_popup()

		if not popup_id then
			return
		end

		local poll_data = self._poll_data

		if poll_data.current_popup_id == popup_id then
			poll_data.num_updates = poll_data.num_updates + 1

			local fassert = fassert
			local flag = poll_data.num_updates <= 1
			local str = "Not polling current popup %q: %q"
			local topic = popup.topic

			topic = not not topic or not not "nil"

			local text = popup.text

			text = not not text or not not "nil"

			fassert(flag, str, topic, text)
		else
			poll_data.current_popup_id = popup_id
			poll_data.num_updates = 1
		end
	end
end

PopupManager.destroy = function (self)
	-- function 4
	local top_world = Managers.world:world("top_ingame_view")
	local ui_top_renderer = self._ui_top_renderer

	UIRenderer.destroy(ui_top_renderer, top_world)

	self._ui_top_renderer = nil
end

PopupManager.set_button_enabled = function (self, popup_id, button_index, enabled)
	-- function 5
	return self._handler:set_button_enabled(popup_id, button_index, enabled)
end

PopupManager.queue_popup = function (self, text, topic, ...)
	-- function 6
	print("PopupManager:queue_default_popup: ", text, topic, ...)

	local popup_type = "default"

	return self._handler:queue_popup(popup_type, text, topic, ...)
end

PopupManager.queue_password_popup = function (self, text, topic, ...)
	-- function 7
	print("PopupManager:queue_password_popup: ", text, topic, ...)

	local popup_type = "password"

	return self._handler:queue_popup(popup_type, text, topic, ...)
end

PopupManager.activate_timer = function (self, popup_id, time, default_result, timer_alignment, blink, optional_timer_format_func, optional_font_size)
	-- function 8
	return self._handler:activate_timer(popup_id, time, default_result, timer_alignment, blink, optional_timer_format_func, optional_font_size)
end

PopupManager.has_popup = function (self)
	-- function 9
	return self._handler:has_popup()
end

PopupManager.has_popup_with_id = function (self, popup_id)
	-- function 10
	return self._handler:has_popup_with_id(popup_id)
end

PopupManager.cancel_popup = function (self, popup_id)
	-- function 11
	return self._handler:cancel_popup(popup_id)
end

PopupManager.cancel_all_popups = function (self)
	-- function 12
	Managers.account:cancel_all_popups()

	return self._handler:cancel_all_popups()
end

PopupManager.query_result = function (self, popup_id)
	-- function 13
	local poll_data = self._poll_data

	if poll_data.current_popup_id == popup_id then
		poll_data.num_updates = 0
	end

	local result, params = self._handler:query_result(popup_id)

	if result then
		print("PopupManager:query_result returned result:", result)
	end

	return result, params
end

PopupManager.set_input_manager = function (self, input_manager)
	-- function 14
	self._handler:set_input_manager(input_manager)
end

PopupManager.remove_input_manager = function (self, application_shutdown)
	-- function 15
	self._handler:remove_input_manager(application_shutdown)
end

PopupManager.fit_text_width_to_popup = function (self, text)
	-- function 16
	return self._handler:fit_text_width_to_popup(text)
end

PopupManager.set_popup_verifying_password = function (self, popup_id, is_verifying, status_message, error_message)
	-- function 17
	return self._handler:set_popup_verifying_password(popup_id, is_verifying, status_message, error_message)
end
