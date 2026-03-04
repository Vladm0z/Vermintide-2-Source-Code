-- chunkname: @scripts/ui/dlc_upsell/common_popup_handler.lua

require("scripts/ui/dlc_upsell/common_popup_settings")
require("scripts/ui/dlc_upsell/unlock_reminder_popup")
require("scripts/ui/dlc_upsell/upsell_popup")
require("scripts/ui/dlc_upsell/handbook_popup")
require("scripts/ui/active_event/active_event_popup")

CommonPopupHandler = class(CommonPopupHandler)

CommonPopupHandler.init = function (arg_1_0, arg_1_1)
	arg_1_0._context = arg_1_1
	arg_1_0._popups = {}
	arg_1_0._n_popups = 0
	arg_1_0._popup_ids = 0
	arg_1_0._menu_active = arg_1_1.ingame_ui.menu_active or arg_1_1.ingame_ui.current_view or arg_1_1.ingame_ui._transition_fade_data

	Managers.state.event:register(arg_1_0, "ui_show_popup", "ui_show_popup")
end

CommonPopupHandler.destroy = function (arg_2_0)
	Managers.state.event:unregister("ui_show_popup", arg_2_0)

	for iter_2_0 = 1, arg_2_0._n_popups do
		local var_2_0 = arg_2_0._popups[iter_2_0]

		if var_2_0 then
			var_2_0:delete()

			arg_2_0._popups[iter_2_0] = nil
		end
	end
end

CommonPopupHandler.update = function (arg_3_0, arg_3_1, arg_3_2)
	local var_3_0 = arg_3_0._popups[arg_3_0._n_popups]

	if not var_3_0 then
		return
	end

	local var_3_1 = Managers.state

	if var_3_1 and var_3_1.voting:vote_in_progress() and Managers.popup:has_popup() then
		var_3_0:hide()

		return
	end

	var_3_0:update(arg_3_1)

	if var_3_0:exit_done() then
		var_3_0:delete()

		arg_3_0._popups[arg_3_0._n_popups] = nil
		arg_3_0._n_popups = arg_3_0._n_popups - 1
	end
end

CommonPopupHandler.queue_popup = function (arg_4_0, arg_4_1)
	local var_4_0 = arg_4_0._n_popups
	local var_4_1 = arg_4_0._popups
	local var_4_2 = var_4_0 + 1

	arg_4_0._n_popups = var_4_2
	arg_4_0._popup_ids = arg_4_0._popup_ids + 1

	local var_4_3 = tostring(arg_4_0._popup_ids)

	arg_4_1.popup_id = var_4_3

	if var_4_2 > 1 and var_4_1[var_4_2 - 1]:is_popup_showing() then
		table.insert(var_4_1, 1, arg_4_1)

		arg_4_0._popups = var_4_1

		return var_4_3
	end

	var_4_1[var_4_2] = arg_4_1
	arg_4_0._popups = var_4_1

	return var_4_3
end

CommonPopupHandler.ui_show_popup = function (arg_5_0, arg_5_1, arg_5_2)
	local var_5_0 = CommonPopupSettings[arg_5_1]

	if not var_5_0 then
		printf("No popup settings for DLC %q", arg_5_1)

		return
	end

	if var_5_0.popup_type == arg_5_2 then
		arg_5_0:new_popup(arg_5_1, var_5_0)

		return
	end
end

CommonPopupHandler.new_popup = function (arg_6_0, arg_6_1, arg_6_2)
	local var_6_0 = rawget(_G, arg_6_2.class_name):new(arg_6_0._context, arg_6_1, arg_6_2)

	arg_6_0:queue_popup(var_6_0)
end

CommonPopupHandler._is_menu_active = function (arg_7_0)
	return arg_7_0._context.ingame_ui.menu_active or arg_7_0._context.ingame_ui.current_view or arg_7_0._context.ingame_ui._transition_fade_data
end
