-- chunkname: @scripts/managers/popup/simple_popup.lua

SimplePopup = class(SimplePopup)

SimplePopup.init = function (arg_1_0)
	arg_1_0._tracked_popups = {}
end

SimplePopup.queue_popup = function (arg_2_0, arg_2_1, arg_2_2, ...)
	local var_2_0 = Managers.popup:queue_popup(arg_2_1, arg_2_2, ...)

	arg_2_0._tracked_popups[#arg_2_0._tracked_popups + 1] = var_2_0
end

SimplePopup.update = function (arg_3_0, arg_3_1)
	local var_3_0 = Managers.popup
	local var_3_1 = arg_3_0._tracked_popups[1]

	if var_3_1 and not var_3_0:has_popup_with_id(var_3_1) then
		table.remove(arg_3_0._tracked_popups, 1)
	end

	for iter_3_0, iter_3_1 in ipairs(arg_3_0._tracked_popups) do
		if var_3_0:query_result(iter_3_1) ~= nil then
			table.remove(arg_3_0._tracked_popups, iter_3_0)
		end
	end
end

SimplePopup.destroy = function (arg_4_0)
	return
end
