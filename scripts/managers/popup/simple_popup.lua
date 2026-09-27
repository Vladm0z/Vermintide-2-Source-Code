-- chunkname: @scripts/managers/popup/simple_popup.lua

SimplePopup = class(SimplePopup)

SimplePopup.init = function (self)
	-- function 1
	self._tracked_popups = {}
end

SimplePopup.queue_popup = function (arg_2_0, arg_2_1, arg_2_2, ...)
	-- function 2
	local queue_popup = Managers.popup:queue_popup(arg_2_1, arg_2_2, ...)

	arg_2_0._tracked_popups[#arg_2_0._tracked_popups + 1] = queue_popup
end

SimplePopup.update = function (self, arg_3_1)
	-- function 3
	local popup = Managers.popup
	local var_3_1 = self._tracked_popups[1]

	if not (not var_3_1 and popup:has_popup_with_id(var_3_1)) then
		table.remove(self._tracked_popups, 1)
	end

	for i, v in ipairs(self._tracked_popups) do
		if popup:query_result(v) ~= nil then
			table.remove(self._tracked_popups, i)
		end
	end
end

SimplePopup.destroy = function (arg_4_0)
	-- function 4
	return
end
