-- chunkname: @scripts/ui/dlc_upsell/common_popup_handler.lua

require("scripts/ui/dlc_upsell/common_popup_settings")
require("scripts/ui/dlc_upsell/unlock_reminder_popup")
require("scripts/ui/dlc_upsell/upsell_popup")
require("scripts/ui/dlc_upsell/handbook_popup")
require("scripts/ui/active_event/active_event_popup")

CommonPopupHandler = class(CommonPopupHandler)

CommonPopupHandler.init = function (self, arg_1_1)
	-- function 1
	self._context = arg_1_1
	self._popups = {}
	self._n_popups = 0
	self._popup_ids = 0

	local menu_active = arg_1_1.ingame_ui.menu_active

	if not menu_active then
		menu_active = arg_1_1.ingame_ui.current_view
		menu_active = menu_active or arg_1_1.ingame_ui._transition_fade_data
	end

	self._menu_active = menu_active

	Managers.state.event:register(self, "ui_show_popup", "ui_show_popup")
end

CommonPopupHandler.destroy = function (self)
	-- function 2
	Managers.state.event:unregister("ui_show_popup", self)

	for i = 1, self._n_popups do
		local var_2_0 = self._popups[i]

		if not var_2_0 then
			var_2_0:delete()

			self._popups[i] = nil
		end
	end
end

CommonPopupHandler.update = function (self, arg_3_1, arg_3_2)
	-- function 3
	local var_3_0 = self._popups[self._n_popups]

	if not var_3_0 then
		return
	end

	local state = Managers.state

	if not state and not state.voting:vote_in_progress() and not Managers.popup:has_popup() then
		var_3_0:hide()

		return
	end

	var_3_0:update(arg_3_1)

	if not var_3_0:exit_done() then
		var_3_0:delete()

		self._popups[self._n_popups] = nil
		self._n_popups = self._n_popups - 1
	end
end

CommonPopupHandler.queue_popup = function (self, arg_4_1)
	-- function 4
	local _n_popups = self._n_popups
	local _popups = self._popups
	local num = _n_popups + 1

	self._n_popups = num
	self._popup_ids = self._popup_ids + 1

	local var_4_3 = tostring(self._popup_ids)

	arg_4_1.popup_id = var_4_3

	if not (num > 1) or not _popups[num - 1]:is_popup_showing() then
		table.insert(_popups, 1, arg_4_1)

		self._popups = _popups

		return var_4_3
	end

	_popups[num] = arg_4_1
	self._popups = _popups

	return var_4_3
end

CommonPopupHandler.ui_show_popup = function (self, arg_5_1, arg_5_2)
	-- function 5
	local var_5_0 = CommonPopupSettings[arg_5_1]

	if not var_5_0 then
		printf("No popup settings for DLC %q", arg_5_1)

		return
	end

	if var_5_0.popup_type == arg_5_2 then
		self:new_popup(arg_5_1, var_5_0)

		return
	end
end

CommonPopupHandler.new_popup = function (self, arg_6_1, arg_6_2)
	-- function 6
	local var_6_0 = rawget(_G, arg_6_2.class_name):new(self._context, arg_6_1, arg_6_2)

	self:queue_popup(var_6_0)
end

CommonPopupHandler._is_menu_active = function (self)
	-- function 7
	local menu_active = self._context.ingame_ui.menu_active

	if not menu_active then
		menu_active = self._context.ingame_ui.current_view
		menu_active = menu_active or self._context.ingame_ui._transition_fade_data
	end

	return menu_active
end
