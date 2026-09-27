-- chunkname: @scripts/managers/popup/popup_manager.lua

require("scripts/ui/views/popup_handler")

PopupManager = class(PopupManager)

PopupManager.init = function (self)
	-- function 1
	local world = Managers.world:world("top_ingame_view")

	self._ui_top_renderer = UIRenderer.create(world, "material", "materials/ui/ui_1080p_popup", "material", "materials/fonts/gw_fonts")

	local tbl = {
		ui_renderer = self._ui_top_renderer,
		world = world
	}

	self:create_own_handler(tbl)

	self._poll_data = {
		num_updates = 0
	}
end

PopupManager.create_own_handler = function (self, arg_2_1)
	-- function 2
	self._handler = PopupHandler:new(arg_2_1, true)
end

PopupManager.update = function (self, arg_3_1)
	-- function 3
	if not self._handler then
		self._handler:update(arg_3_1, true)

		local active_popup, var_3_1 = self._handler:active_popup()

		if not active_popup then
			return
		end

		local _poll_data = self._poll_data

		if _poll_data.current_popup_id == active_popup then
			_poll_data.num_updates = _poll_data.num_updates + 1

			local fassert = fassert
			local flag = _poll_data.num_updates <= 1
			local str = "Not polling current popup %q: %q"
			local topic = var_3_1.topic

			topic = topic or "nil"

			local text = var_3_1.text

			text = text or "nil"

			fassert(flag, str, topic, text)
		else
			_poll_data.current_popup_id = active_popup
			_poll_data.num_updates = 1
		end
	end
end

PopupManager.destroy = function (self)
	-- function 4
	local world = Managers.world:world("top_ingame_view")
	local _ui_top_renderer = self._ui_top_renderer

	UIRenderer.destroy(_ui_top_renderer, world)

	self._ui_top_renderer = nil
end

PopupManager.set_button_enabled = function (self, arg_5_1, arg_5_2, arg_5_3)
	-- function 5
	return self._handler:set_button_enabled(arg_5_1, arg_5_2, arg_5_3)
end

PopupManager.queue_popup = function (self, arg_6_1, arg_6_2, ...)
	-- function 6
	print("PopupManager:queue_default_popup: ", arg_6_1, arg_6_2, ...)

	local str = "default"

	return self._handler:queue_popup(str, arg_6_1, arg_6_2, ...)
end

PopupManager.queue_password_popup = function (self, arg_7_1, arg_7_2, ...)
	-- function 7
	print("PopupManager:queue_password_popup: ", arg_7_1, arg_7_2, ...)

	local str = "password"

	return self._handler:queue_popup(str, arg_7_1, arg_7_2, ...)
end

PopupManager.activate_timer = function (self, arg_8_1, arg_8_2, arg_8_3, arg_8_4, arg_8_5, arg_8_6, arg_8_7)
	-- function 8
	return self._handler:activate_timer(arg_8_1, arg_8_2, arg_8_3, arg_8_4, arg_8_5, arg_8_6, arg_8_7)
end

PopupManager.has_popup = function (self)
	-- function 9
	return self._handler:has_popup()
end

PopupManager.has_popup_with_id = function (self, arg_10_1)
	-- function 10
	return self._handler:has_popup_with_id(arg_10_1)
end

PopupManager.cancel_popup = function (self, arg_11_1)
	-- function 11
	return self._handler:cancel_popup(arg_11_1)
end

PopupManager.cancel_all_popups = function (self)
	-- function 12
	Managers.account:cancel_all_popups()

	return self._handler:cancel_all_popups()
end

PopupManager.query_result = function (self, arg_13_1)
	-- function 13
	local _poll_data = self._poll_data

	if _poll_data.current_popup_id == arg_13_1 then
		_poll_data.num_updates = 0
	end

	local query_result, var_13_2 = self._handler:query_result(arg_13_1)

	if not query_result then
		print("PopupManager:query_result returned result:", query_result)
	end

	return query_result, var_13_2
end

PopupManager.set_input_manager = function (self, arg_14_1)
	-- function 14
	self._handler:set_input_manager(arg_14_1)
end

PopupManager.remove_input_manager = function (self, arg_15_1)
	-- function 15
	self._handler:remove_input_manager(arg_15_1)
end

PopupManager.fit_text_width_to_popup = function (self, arg_16_1)
	-- function 16
	return self._handler:fit_text_width_to_popup(arg_16_1)
end

PopupManager.set_popup_verifying_password = function (self, arg_17_1, arg_17_2, arg_17_3, arg_17_4)
	-- function 17
	return self._handler:set_popup_verifying_password(arg_17_1, arg_17_2, arg_17_3, arg_17_4)
end
