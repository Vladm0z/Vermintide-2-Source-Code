-- chunkname: @scripts/managers/popup/popup_manager.lua

require("scripts/ui/views/popup_handler")

PopupManager = class(PopupManager)

function PopupManager.init(arg_1_0)
	local var_1_0 = Managers.world:world("top_ingame_view")

	arg_1_0._ui_top_renderer = UIRenderer.create(var_1_0, "material", "materials/ui/ui_1080p_popup", "material", "materials/fonts/gw_fonts")

	local var_1_1 = {
		ui_renderer = arg_1_0._ui_top_renderer,
		world = var_1_0
	}

	arg_1_0:create_own_handler(var_1_1)

	arg_1_0._poll_data = {
		num_updates = 0
	}
end

function PopupManager.create_own_handler(arg_2_0, arg_2_1)
	arg_2_0._handler = PopupHandler:new(arg_2_1, true)
end

function PopupManager.update(arg_3_0, arg_3_1)
	if arg_3_0._handler then
		arg_3_0._handler:update(arg_3_1, true)

		local var_3_0, var_3_1 = arg_3_0._handler:active_popup()

		if not var_3_0 then
			return
		end

		local var_3_2 = arg_3_0._poll_data

		if var_3_2.current_popup_id == var_3_0 then
			var_3_2.num_updates = var_3_2.num_updates + 1

			fassert(var_3_2.num_updates <= 1, "Not polling current popup %q: %q", var_3_1.topic or "nil", var_3_1.text or "nil")
		else
			var_3_2.current_popup_id = var_3_0
			var_3_2.num_updates = 1
		end
	end
end

function PopupManager.destroy(arg_4_0)
	local var_4_0 = Managers.world:world("top_ingame_view")
	local var_4_1 = arg_4_0._ui_top_renderer

	UIRenderer.destroy(var_4_1, var_4_0)

	arg_4_0._ui_top_renderer = nil
end

function PopupManager.set_button_enabled(arg_5_0, arg_5_1, arg_5_2, arg_5_3)
	return arg_5_0._handler:set_button_enabled(arg_5_1, arg_5_2, arg_5_3)
end

function PopupManager.queue_popup(arg_6_0, arg_6_1, arg_6_2, ...)
	print("PopupManager:queue_default_popup: ", arg_6_1, arg_6_2, ...)

	local var_6_0 = "default"

	return arg_6_0._handler:queue_popup(var_6_0, arg_6_1, arg_6_2, ...)
end

function PopupManager.queue_password_popup(arg_7_0, arg_7_1, arg_7_2, ...)
	print("PopupManager:queue_password_popup: ", arg_7_1, arg_7_2, ...)

	local var_7_0 = "password"

	return arg_7_0._handler:queue_popup(var_7_0, arg_7_1, arg_7_2, ...)
end

function PopupManager.activate_timer(arg_8_0, arg_8_1, arg_8_2, arg_8_3, arg_8_4, arg_8_5, arg_8_6, arg_8_7)
	return arg_8_0._handler:activate_timer(arg_8_1, arg_8_2, arg_8_3, arg_8_4, arg_8_5, arg_8_6, arg_8_7)
end

function PopupManager.has_popup(arg_9_0)
	return arg_9_0._handler:has_popup()
end

function PopupManager.has_popup_with_id(arg_10_0, arg_10_1)
	return arg_10_0._handler:has_popup_with_id(arg_10_1)
end

function PopupManager.cancel_popup(arg_11_0, arg_11_1)
	return arg_11_0._handler:cancel_popup(arg_11_1)
end

function PopupManager.cancel_all_popups(arg_12_0)
	Managers.account:cancel_all_popups()

	return arg_12_0._handler:cancel_all_popups()
end

function PopupManager.query_result(arg_13_0, arg_13_1)
	local var_13_0 = arg_13_0._poll_data

	if var_13_0.current_popup_id == arg_13_1 then
		var_13_0.num_updates = 0
	end

	local var_13_1, var_13_2 = arg_13_0._handler:query_result(arg_13_1)

	if var_13_1 then
		print("PopupManager:query_result returned result:", var_13_1)
	end

	return var_13_1, var_13_2
end

function PopupManager.set_input_manager(arg_14_0, arg_14_1)
	arg_14_0._handler:set_input_manager(arg_14_1)
end

function PopupManager.remove_input_manager(arg_15_0, arg_15_1)
	arg_15_0._handler:remove_input_manager(arg_15_1)
end

function PopupManager.fit_text_width_to_popup(arg_16_0, arg_16_1)
	return arg_16_0._handler:fit_text_width_to_popup(arg_16_1)
end

function PopupManager.set_popup_verifying_password(arg_17_0, arg_17_1, arg_17_2, arg_17_3, arg_17_4)
	return arg_17_0._handler:set_popup_verifying_password(arg_17_1, arg_17_2, arg_17_3, arg_17_4)
end
