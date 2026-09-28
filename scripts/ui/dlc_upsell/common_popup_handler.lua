-- chunkname: @scripts/ui/dlc_upsell/common_popup_handler.lua

require("scripts/ui/dlc_upsell/common_popup_settings")
require("scripts/ui/dlc_upsell/unlock_reminder_popup")
require("scripts/ui/dlc_upsell/upsell_popup")
require("scripts/ui/dlc_upsell/handbook_popup")
require("scripts/ui/active_event/active_event_popup")

CommonPopupHandler = class(CommonPopupHandler)

CommonPopupHandler.init = function (self, context)
	-- function 1
	self._context = context
	self._popups = {}
	self._n_popups = 0
	self._popup_ids = 0

	local menu_active_2 = context.ingame_ui.menu_active

	if not menu_active_2 then
		-- Nothing
	end

	menu_active_2 = context.ingame_ui.current_view

	if not menu_active_2 then
		-- Nothing
	end

	menu_active_2 = context.ingame_ui._transition_fade_data

	local menu_active = menu_active_2

	::label_1_0::

	self._menu_active = menu_active

	Managers.state.event:register(self, "ui_show_popup", "ui_show_popup")
end

CommonPopupHandler.destroy = function (self)
	-- function 2
	Managers.state.event:unregister("ui_show_popup", self)

	for i = 1, self._n_popups do
		local popup = self._popups[i]

		if popup then
			popup:delete()

			self._popups[i] = nil
		end
	end
end

CommonPopupHandler.update = function (self, dt, t)
	-- function 3
	local popup = self._popups[self._n_popups]

	if not popup then
		return
	end

	local managers_state = Managers.state

	if managers_state and managers_state.voting:vote_in_progress() and Managers.popup:has_popup() then
		popup:hide()

		return
	end

	popup:update(dt)

	if popup:exit_done() then
		popup:delete()

		self._popups[self._n_popups] = nil
		self._n_popups = self._n_popups - 1
	end
end

CommonPopupHandler.queue_popup = function (self, ui_popup)
	-- function 4
	local n_popups, popups = self._n_popups, self._popups

	n_popups = n_popups + 1
	self._n_popups = n_popups
	self._popup_ids = self._popup_ids + 1

	local popup_id = tostring(self._popup_ids)

	ui_popup.popup_id = popup_id

	if n_popups > 1 then
		local previous_popup_showing = popups[n_popups - 1]:is_popup_showing()

		if previous_popup_showing then
			table.insert(popups, 1, ui_popup)

			self._popups = popups

			return popup_id
		end
	end

	popups[n_popups] = ui_popup
	self._popups = popups

	return popup_id
end

CommonPopupHandler.ui_show_popup = function (self, popup_name, type)
	-- function 5
	local popup_settings = CommonPopupSettings[popup_name]

	if not popup_settings then
		printf("No popup settings for DLC %q", popup_name)

		return
	end

	if popup_settings.popup_type == type then
		self:new_popup(popup_name, popup_settings)

		return
	end
end

CommonPopupHandler.new_popup = function (self, popup_name, popup_settings)
	-- function 6
	local popup_class = rawget(_G, popup_settings.class_name)
	local popup = popup_class:new(self._context, popup_name, popup_settings)

	self:queue_popup(popup)
end

CommonPopupHandler._is_menu_active = function (self)
	-- function 7
	local menu_active = self._context.ingame_ui.menu_active

	if not menu_active then
		menu_active = self._context.ingame_ui.current_view
		menu_active = not not menu_active or not not self._context.ingame_ui._transition_fade_data
	end

	return menu_active
end
