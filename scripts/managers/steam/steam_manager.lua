-- chunkname: @scripts/managers/steam/steam_manager.lua

SteamManager = class(SteamManager)

SteamManager.init = function (arg_1_0)
	arg_1_0._overlay_active = false
end

SteamManager.destroy = function (arg_2_0)
	return
end

SteamManager.update = function (arg_3_0, arg_3_1, arg_3_2)
	if HAS_STEAM then
		Steam.run_callbacks(arg_3_0)
	end
end

SteamManager.on_overlay_activated = function (arg_4_0, arg_4_1)
	arg_4_0._overlay_active = arg_4_1
end

SteamManager.is_overlay_active = function (arg_5_0)
	return arg_5_0._overlay_active
end

SteamManager.on_inventory_result = function (arg_6_0, arg_6_1, arg_6_2)
	print("[SteamManager] on_inventory_result, result=", arg_6_2, "handle=", arg_6_1)

	if arg_6_2 == 1 then
		if arg_6_1 == arg_6_0._request_user_inventory_handle then
			print("ISI-> GET_ALL_ITEMS!")

			local var_6_0 = SteamInventory.get_result_items(arg_6_1)

			arg_6_0._request_user_inventory_callback(arg_6_2, var_6_0)

			arg_6_0._request_user_inventory_callback = nil

			table.dump(var_6_0, "ITEM-LIST", 3)
		elseif arg_6_0._purchase_item_callback then
			local var_6_1 = SteamInventory.get_result_items(arg_6_1)

			arg_6_0._purchase_item_callback(arg_6_2, var_6_1)

			arg_6_0._purchase_item_callback = nil

			print("[SteamManager] -> PURCHASE success!")
			table.dump(var_6_1, "ITEM-LIST", 3)
		end
	else
		print("[SteamManager] on_inventory_result FAILED, error-code:", arg_6_2)

		if arg_6_0._request_user_inventory_callback then
			print("[SteamManager] failed empty on_inventory_result callback")
			arg_6_0._request_user_inventory_callback(arg_6_2)

			arg_6_0._request_user_inventory_callback = nil
		elseif arg_6_0._purchase_item_callback then
			arg_6_0._purchase_item_callback(arg_6_2)

			arg_6_0._purchase_item_callback = nil
		end
	end

	if arg_6_1 == arg_6_0._request_user_inventory_handle then
		arg_6_0._request_user_inventory_handle = nil
	end

	SteamInventory.destroy_result(arg_6_1)
end

SteamManager.on_price_result = function (arg_7_0, arg_7_1, arg_7_2)
	print("[SteamManager] on_price_result", arg_7_1, arg_7_2)

	if arg_7_0._refresh_item_prices_callback then
		local var_7_0

		if arg_7_1 == 1 then
			var_7_0 = SteamInventory.get_items_with_prices()
		else
			print("[SteamManager] -> on_price_result ERROR:", arg_7_1)
		end

		arg_7_0._refresh_item_prices_callback(var_7_0 or {}, arg_7_2)

		arg_7_0._refresh_item_prices_callback = nil
	end
end

SteamManager.on_start_purchase = function (arg_8_0, arg_8_1, arg_8_2, arg_8_3)
	print("[SteamManager] on_start_purchase result=", arg_8_1, "order_id=", arg_8_2, ", transaction_id=", arg_8_3)

	if arg_8_1 ~= 1 then
		local var_8_0 = Localize("start_game_window_twitch_error_connection")
		local var_8_1 = string.format(var_8_0, Localize("backend_err_auth_steam"), ">=k_EResultFail", arg_8_1 or 0)

		Managers.simple_popup:queue_popup(var_8_1, Localize("popup_error_topic"), "ok", Localize("popup_choice_ok"))
	end
end

SteamManager.request_user_inventory = function (arg_9_0, arg_9_1)
	arg_9_0._request_user_inventory_callback = arg_9_1
	arg_9_0._request_user_inventory_handle = SteamInventory.get_all_items()
end

SteamManager.request_item_prices = function (arg_10_0, arg_10_1)
	print("[SteamManager] request_item_prices")
	SteamInventory.request_prices()

	arg_10_0._refresh_item_prices_callback = arg_10_1
	arg_10_0._last_result = nil
end

SteamManager.request_purchase_item = function (arg_11_0, arg_11_1, arg_11_2, arg_11_3)
	local var_11_0 = SteamitemdefidToMasterList[arg_11_1]

	printf("[SteamManager] request_purchase_item(steam_itemdefid=%s %q, amount=%s)", arg_11_1, var_11_0 or "n/a", arg_11_2)
	SteamInventory.start_purchase(arg_11_1, arg_11_2)

	arg_11_0._purchase_item_callback = arg_11_3
end
