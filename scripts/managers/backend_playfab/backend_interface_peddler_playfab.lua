-- chunkname: @scripts/managers/backend_playfab/backend_interface_peddler_playfab.lua

require("scripts/utils/steam_item_service")

BackendInterfacePeddlerPlayFab = class(BackendInterfacePeddlerPlayFab)

local var_0_0 = "Store"
local var_0_1 = {
	[1052] = true,
	[1053] = true,
	[1047] = true,
	[1059] = true
}

function BackendInterfacePeddlerPlayFab.init(arg_1_0, arg_1_1)
	arg_1_0._backend_mirror = arg_1_1
	arg_1_0._peddler_stock = {}
	arg_1_0._chips = {}
	arg_1_0._app_prices = {}
	arg_1_0._psn_requests = {}
	arg_1_0._stock_ready = false
	arg_1_0._chips_ready = false
	arg_1_0._steam_stock_ready = not HAS_STEAM
	arg_1_0._app_prices_ready = false
	arg_1_0._steam_item_prices = {}
	arg_1_0._login_rewards_cooldown = 0
	arg_1_0._is_done_claiming = true

	arg_1_0:refresh_stock()
	arg_1_0:refresh_chips()
	arg_1_0:refresh_layout_override(true)
	arg_1_0:refresh_app_prices()
	arg_1_0:refresh_platform_item_prices()
	arg_1_0:refresh_login_rewards()
end

function BackendInterfacePeddlerPlayFab.ready(arg_2_0)
	return arg_2_0._login_rewards and arg_2_0._stock_ready and arg_2_0._steam_stock_ready and arg_2_0._chips_ready and arg_2_0._app_prices_ready
end

function BackendInterfacePeddlerPlayFab.destroy(arg_3_0)
	arg_3_0._peddler_stock = nil
	arg_3_0._chips = nil
	arg_3_0._app_prices = nil
end

function BackendInterfacePeddlerPlayFab.get_peddler_stock(arg_4_0)
	return arg_4_0._peddler_stock
end

local var_0_2 = {}

function BackendInterfacePeddlerPlayFab.get_filtered_items(arg_5_0, arg_5_1, arg_5_2)
	local var_5_0 = arg_5_0._peddler_stock

	return (Managers.backend:get_interface("common"):filter_items(var_5_0, arg_5_1, arg_5_2 or var_0_2))
end

function BackendInterfacePeddlerPlayFab.get_chips(arg_6_0, arg_6_1)
	return arg_6_0._chips[arg_6_1]
end

function BackendInterfacePeddlerPlayFab.get_app_price(arg_7_0, arg_7_1)
	return arg_7_0._app_prices[arg_7_1]
end

function BackendInterfacePeddlerPlayFab.get_steam_item_price(arg_8_0, arg_8_1)
	return arg_8_0._steam_item_prices[arg_8_1], arg_8_0._steam_item_currency
end

function BackendInterfacePeddlerPlayFab.is_purchaseable(arg_9_0, arg_9_1)
	return arg_9_0._steam_item_prices[arg_9_1] ~= nil
end

function BackendInterfacePeddlerPlayFab.get_unseen_currency_rewards(arg_10_0)
	local var_10_0 = arg_10_0._backend_mirror:get_user_data("unseen_rewards")

	if not var_10_0 then
		return nil
	end

	local var_10_1 = DLCSettings.store.currency_ui_settings
	local var_10_2 = cjson.decode(var_10_0)
	local var_10_3
	local var_10_4 = 1

	while var_10_4 <= #var_10_2 do
		local var_10_5 = var_10_2[var_10_4]
		local var_10_6 = var_10_5.reward_type
		local var_10_7 = var_10_5.currency_type

		if var_10_6 == "currency" and var_10_1[var_10_7] ~= nil then
			var_10_3 = var_10_3 or {}
			var_10_3[#var_10_3 + 1] = var_10_5

			table.remove(var_10_2, var_10_4)
		else
			var_10_4 = var_10_4 + 1
		end
	end

	if var_10_3 then
		arg_10_0._backend_mirror:set_user_data("unseen_rewards", cjson.encode(var_10_2))
	end

	return var_10_3
end

function BackendInterfacePeddlerPlayFab.refresh_stock(arg_11_0, arg_11_1)
	arg_11_0._peddler_stock = {}

	local var_11_0 = {
		StoreId = var_0_0
	}
	local var_11_1 = callback(arg_11_0, "_refresh_stock_cb", arg_11_1)

	arg_11_0._backend_mirror:request_queue():enqueue_api_request("GetStoreItems", var_11_0, var_11_1)
end

local function var_0_3(arg_12_0)
	local var_12_0

	if IS_CONSOLE then
		return true
	else
		local var_12_1 = arg_12_0.steam_itemdefid

		var_12_0 = var_12_1 ~= nil

		if var_12_0 then
			local var_12_2 = false

			if var_12_1 and HAS_STEAM then
				var_12_2 = true
			end

			if not var_12_2 then
				return false
			end
		end
	end

	return true, var_12_0
end

function BackendInterfacePeddlerPlayFab._refresh_stock_cb(arg_13_0, arg_13_1, arg_13_2)
	local var_13_0 = arg_13_2.Store
	local var_13_1 = arg_13_0._peddler_stock
	local var_13_2 = arg_13_0._backend_mirror:get_all_inventory_items()
	local var_13_3 = HAS_STEAM
	local var_13_4 = #var_13_1 + 1
	local var_13_5 = PlayerData.seen_shop_items
	local var_13_6 = false

	for iter_13_0 = 1, #var_13_0 do
		local var_13_7 = var_13_0[iter_13_0]
		local var_13_8 = var_13_7.ItemId

		if var_13_7.ItemId and not rawget(ItemMasterList, var_13_7.ItemId) then
			printf("BackendInterfacePeddlerPlayFab - ItemMasterList has no item %q", tostring(var_13_7.ItemId))
		else
			local var_13_9 = ItemMasterList[var_13_8]
			local var_13_10 = false

			for iter_13_1, iter_13_2 in pairs(var_13_2) do
				if var_13_8 == iter_13_2.key then
					var_13_10 = true

					break
				end
			end

			local var_13_11, var_13_12 = var_0_3(var_13_9)

			if var_13_11 and not var_13_12 then
				local var_13_13 = var_13_7.CustomData.regular_prices
				local var_13_14 = var_13_7.VirtualCurrencyPrices

				var_13_1[var_13_4] = {
					type = "item",
					data = table.clone(var_13_9),
					key = var_13_8,
					id = var_13_8,
					regular_prices = var_13_13,
					current_prices = var_13_14,
					end_time = var_13_7.CustomData.end_time,
					owned = var_13_10,
					dlc_name = var_13_9.dlc_name,
					steam_itemdefid = var_13_3 and var_13_9.steam_itemdefid
				}
				var_13_4 = var_13_4 + 1

				if not var_13_5[var_13_8] then
					var_13_6 = true
				end
			end
		end
	end

	print(string.format("[BackendInterfacePeddlerPlayFab] _refresh_stock_cb -> Added %s item(s) to the peddler stock", #var_13_1))

	arg_13_0._peddler_stock = var_13_1
	arg_13_0._stock_ready = true

	if arg_13_1 then
		arg_13_1()
	end

	if BUILD == "dev" and (IS_XB1 or IS_PS4) then
		var_13_6 = false
	end

	if var_13_6 then
		local var_13_15 = arg_13_2.MarketingData.Metadata

		if type(var_13_15) == "string" then
			var_13_15 = cjson.decode(var_13_15)
		end

		local var_13_16 = var_13_15.uploaded
		local var_13_17 = PlayerData.store_update_timestamp

		if not var_13_17 or var_13_17 < var_13_16 then
			PlayerData.store_new_items = true
			PlayerData.store_update_timestamp = var_13_16

			Managers.save:auto_save(SaveFileName, SaveData, nil)
		end
	else
		PlayerData.store_new_items = false
	end
end

function BackendInterfacePeddlerPlayFab.set_chips(arg_14_0, arg_14_1, arg_14_2)
	arg_14_0._chips[arg_14_1] = arg_14_2
end

function BackendInterfacePeddlerPlayFab.refresh_chips(arg_15_0, arg_15_1)
	local var_15_0 = {
		FunctionName = "getUserChips",
		FunctionParameter = {}
	}

	arg_15_0._backend_mirror:request_queue():enqueue(var_15_0, callback(arg_15_0, "_refresh_chips_cb", arg_15_1), false)
end

function BackendInterfacePeddlerPlayFab._refresh_chips_cb(arg_16_0, arg_16_1, arg_16_2)
	local var_16_0 = arg_16_2.FunctionResult.chips

	for iter_16_0, iter_16_1 in pairs(var_16_0) do
		arg_16_0:set_chips(iter_16_0, iter_16_1)
	end

	arg_16_0._chips_ready = true

	if arg_16_1 then
		arg_16_1()
	end
end

function BackendInterfacePeddlerPlayFab.refresh_layout_override(arg_17_0, arg_17_1, arg_17_2)
	local var_17_0 = arg_17_0._backend_mirror

	if arg_17_1 then
		local var_17_1 = var_17_0:get_title_data().store_layout_override

		if var_17_1 then
			local var_17_2 = cjson.decode(var_17_1)
			local var_17_3 = StoreLayoutConfig

			if var_17_2.menu_options then
				var_17_3.menu_options = var_17_2.menu_options
			end

			if var_17_2.structure then
				for iter_17_0, iter_17_1 in pairs(var_17_2.structure) do
					var_17_3.structure[iter_17_0] = iter_17_1
				end
			end

			if var_17_2.pages then
				for iter_17_2, iter_17_3 in pairs(var_17_2.pages) do
					var_17_3.pages[iter_17_2] = iter_17_3
				end
			end
		end

		if arg_17_2 then
			arg_17_2()
		end
	else
		local var_17_4 = {
			Keys = {
				"store_layout_override"
			}
		}
		local var_17_5 = callback(arg_17_0, "_refresh_layout_override_cb", arg_17_2)

		arg_17_0._backend_mirror:request_queue():enqueue_api_request("GetTitleData", var_17_4, var_17_5)
	end
end

function BackendInterfacePeddlerPlayFab._refresh_layout_override_cb(arg_18_0, arg_18_1, arg_18_2)
	local var_18_0 = arg_18_2.Data and arg_18_2.Data.store_layout_override

	arg_18_0._backend_mirror:set_title_data("store_layout_override", var_18_0)
	arg_18_0:refresh_layout_override(true, arg_18_1)
end

function BackendInterfacePeddlerPlayFab.store_display_items(arg_19_0)
	local var_19_0 = arg_19_0._backend_mirror:get_title_data().store_display_items

	return var_19_0 and cjson.decode(var_19_0)
end

function BackendInterfacePeddlerPlayFab.refresh_platform_item_prices(arg_20_0, arg_20_1)
	if HAS_STEAM then
		print("[BackendInterfacePeddlerPlayFab] refresh steam item prices")
		Managers.steam:request_item_prices(callback(arg_20_0, "_refresh_steam_item_prices_cb", arg_20_1))
	end
end

function BackendInterfacePeddlerPlayFab._read_bundle_from_steam(arg_21_0, arg_21_1)
	local var_21_0 = SteamInventory.get_item_definition_property(arg_21_1, "bundle")

	if var_21_0 then
		local var_21_1 = string.split_deprecated(var_21_0, ";")

		for iter_21_0, iter_21_1 in ipairs(var_21_1) do
			var_21_1[iter_21_0] = tonumber(iter_21_1)
		end

		local var_21_2 = SteamInventory.get_item_definition_property(arg_21_1, "purchase_bundle_discount")

		return var_21_1, tonumber(var_21_2)
	end
end

function BackendInterfacePeddlerPlayFab._refresh_steam_item_prices_cb(arg_22_0, arg_22_1, arg_22_2, arg_22_3)
	print("_refresh_steam_item_prices_cb")

	local var_22_0 = arg_22_0._backend_mirror:get_all_inventory_items()
	local var_22_1 = arg_22_0._peddler_stock
	local var_22_2 = #var_22_1 + 1
	local var_22_3 = {}

	for iter_22_0 = 1, #arg_22_2, 2 do
		local var_22_4 = arg_22_2[iter_22_0]
		local var_22_5 = arg_22_2[iter_22_0 + 1]
		local var_22_6 = SteamitemdefidToMasterList[var_22_4]

		if var_22_6 then
			arg_22_0._steam_item_prices[var_22_4] = var_22_5

			local var_22_7 = ItemMasterList[var_22_6]

			if not var_22_7.steam_store_hidden and var_0_3(var_22_7) then
				local var_22_8 = false

				for iter_22_1, iter_22_2 in pairs(var_22_0) do
					if var_22_6 == iter_22_2.key then
						var_22_8 = true

						break
					end
				end

				local var_22_9 = table.clone(var_22_7)

				if var_22_7.item_type == "bundle" or var_22_7.item_type == "cosmetic_bundle" then
					local var_22_10, var_22_11 = arg_22_0:_read_bundle_from_steam(var_22_4)

					if var_22_10 then
						var_22_9.bundle_contains = var_22_10
						var_22_9.discount = var_22_11
					else
						Crashify.print_exception("[BackendInterfacePeddlerPlayFab]", "_refresh_steam_item_prices_cb, bundle_contains table is empty. steam_itemdef_id: %s", tostring(var_22_4))
						print(table.dump(var_22_9, "MISSING BUNDLE CONTAINS", 2))
					end

					var_22_3[#var_22_3 + 1] = var_22_9
				end

				var_22_1[var_22_2] = {
					type = "item",
					data = var_22_9,
					key = var_22_6,
					id = var_22_6,
					owned = var_22_8,
					steam_itemdefid = var_22_4,
					steam_price = var_22_5,
					steam_data = SteamItemService.get_item_data(var_22_4)
				}
				var_22_2 = var_22_2 + 1
			end
		else
			print("Missing item masterlist item for steam_itemdefid:", var_22_4)
		end
	end

	for iter_22_3 = 1, #var_22_3 do
		local var_22_12 = var_22_3[iter_22_3]
		local var_22_13 = 0
		local var_22_14 = var_22_12.bundle_contains

		if type(var_22_14) == "table" then
			for iter_22_4 = 1, #var_22_14 do
				local var_22_15 = var_22_14[iter_22_4]

				var_22_13 = var_22_13 + (arg_22_0._steam_item_prices[var_22_15] or 0)
			end
		end

		var_22_12.bundle_price = var_22_13
	end

	arg_22_0._steam_item_currency = arg_22_3
	arg_22_0._steam_stock_ready = true

	if arg_22_1 then
		arg_22_1()
	end
end

function BackendInterfacePeddlerPlayFab.refresh_app_prices(arg_23_0, arg_23_1)
	local var_23_0 = PLATFORM

	if IS_WINDOWS or IS_LINUX then
		arg_23_0:_refresh_app_prices_steam(arg_23_1)
	elseif IS_PS4 then
		arg_23_0:_refresh_app_prices_psn(arg_23_1)
	elseif IS_XB1 then
		arg_23_0:_refresh_app_prices_xboxlive(arg_23_1)
	end
end

function BackendInterfacePeddlerPlayFab._refresh_app_prices_steam(arg_24_0, arg_24_1)
	local var_24_0 = {
		FunctionName = "getSteamAppPriceInfo",
		FunctionParameter = {}
	}

	arg_24_0._backend_mirror:request_queue():enqueue(var_24_0, callback(arg_24_0, "_refresh_app_prices_steam_cb", arg_24_1), false)
end

function BackendInterfacePeddlerPlayFab._refresh_app_prices_steam_cb(arg_25_0, arg_25_1, arg_25_2)
	local var_25_0 = arg_25_2.FunctionResult
	local var_25_1 = true

	if var_25_0.error then
		print("[BackendInterfacePeddlerPlayFab] _refresh_app_prices_steam_cb ERROR", var_25_0.error)

		var_25_1 = false
	else
		local var_25_2 = var_25_0.price_info

		if var_25_2 then
			for iter_25_0, iter_25_1 in pairs(var_25_2) do
				local var_25_3 = iter_25_1.currency
				local var_25_4 = iter_25_1.initial_price
				local var_25_5 = iter_25_1.final_price

				arg_25_0._app_prices[iter_25_0] = {
					currency = var_25_3,
					regular_price = var_25_4,
					current_price = var_25_5
				}
			end
		end
	end

	arg_25_0._app_prices_ready = true

	if arg_25_1 then
		arg_25_1(var_25_1)
	end
end

function BackendInterfacePeddlerPlayFab._refresh_app_prices_psn(arg_26_0, arg_26_1)
	table.clear(arg_26_0._psn_requests)

	local var_26_0 = {}
	local var_26_1 = ""
	local var_26_2 = PS4.title_id()

	table.clear(arg_26_0._app_prices)

	for iter_26_0, iter_26_1 in pairs(DLCSettings) do
		local var_26_3 = iter_26_1.unlock_settings_ps4

		if var_26_3 then
			local var_26_4 = var_26_3[var_26_2] or {}

			for iter_26_2, iter_26_3 in pairs(var_26_4) do
				local var_26_5 = iter_26_3.product_label

				if var_26_5 then
					var_26_1 = var_26_1 .. iter_26_3.product_label .. ":"
					var_26_0[var_26_5] = iter_26_2

					if table.size(var_26_0) > 20 then
						arg_26_0._psn_requests[#arg_26_0._psn_requests + 1] = {
							product_labels_string = var_26_1,
							product_label_lookup = table.clone(var_26_0)
						}

						table.clear(var_26_0)

						var_26_1 = ""
					end
				end
			end
		end
	end

	if table.size(var_26_0) > 0 then
		arg_26_0._psn_requests[#arg_26_0._psn_requests + 1] = {
			product_labels_string = var_26_1,
			product_label_lookup = table.clone(var_26_0)
		}

		table.clear(var_26_0)

		local var_26_6 = ""
	end

	local var_26_7 = arg_26_0._psn_requests[1]

	Managers.account:get_product_details(var_26_7.product_labels_string, 0, callback(arg_26_0, "_refresh_app_prices_psn_cb", arg_26_1, var_26_7.product_label_lookup))
end

function BackendInterfacePeddlerPlayFab._refresh_app_prices_psn_cb(arg_27_0, arg_27_1, arg_27_2, arg_27_3)
	print("")
	print("############ WEBAPI JSON COMMERCE RESULT ############")
	print(arg_27_3)
	print("#####################################################")
	print("")

	if arg_27_3 then
		local var_27_0 = {}
		local var_27_1 = cjson.decode(arg_27_3)

		for iter_27_0, iter_27_1 in pairs(var_27_1) do
			local var_27_2 = iter_27_1.label
			local var_27_3 = iter_27_1.skus
			local var_27_4 = var_27_3 and var_27_3[1] or var_27_0
			local var_27_5 = arg_27_2[var_27_2]

			arg_27_0._app_prices[var_27_5] = {
				name = iter_27_1.name,
				is_plus_price = var_27_4.is_plus_price,
				plus_upsell_price = var_27_4.plus_upsell_price,
				original_price = var_27_4.original_price,
				price = var_27_4.price,
				display_original_price = var_27_4.display_original_price,
				display_plus_upsell_price = var_27_4.display_plus_upsell_price,
				display_price = var_27_4.display_price,
				product_id = var_27_4.product_id,
				product_label = var_27_2
			}
		end
	elseif arg_27_1 then
		local var_27_6 = false

		arg_27_1(var_27_6)
	end

	table.remove(arg_27_0._psn_requests, 1)

	if table.size(arg_27_0._psn_requests) > 0 then
		local var_27_7 = arg_27_0._psn_requests[1]

		Managers.account:get_product_details(var_27_7.product_labels_string, 0, callback(arg_27_0, "_refresh_app_prices_psn_cb", arg_27_1, var_27_7.product_label_lookup))
	else
		arg_27_0._app_prices_ready = true

		if arg_27_1 then
			local var_27_8 = false

			arg_27_1(var_27_8)
		end
	end
end

function BackendInterfacePeddlerPlayFab._refresh_app_prices_xboxlive(arg_28_0, arg_28_1)
	local var_28_0 = {}
	local var_28_1 = {}

	table.clear(arg_28_0._app_prices)

	for iter_28_0, iter_28_1 in pairs(DLCSettings) do
		local var_28_2 = iter_28_1.unlock_settings_xb1 or {}

		for iter_28_2, iter_28_3 in pairs(var_28_2) do
			local var_28_3 = iter_28_3.id

			if var_28_3 then
				var_28_1[#var_28_1 + 1] = var_28_3
				var_28_0[var_28_3] = iter_28_2
			end
		end
	end

	if #var_28_1 < 0 then
		local var_28_4 = true

		if arg_28_1 then
			arg_28_1(var_28_4)
		end

		return
	end

	print("####### GET PRICING INFORMATION")
	table.dump(var_28_1, "PRODUCT_IDS", 5)
	table.dump(var_28_0, "PRODUCT_ID_LOOKUP", 5)
	Managers.account:get_product_details(var_28_1, callback(arg_28_0, "_refresh_app_prices_xboxlive_cb", arg_28_1, var_28_0))
end

function BackendInterfacePeddlerPlayFab._refresh_app_prices_xboxlive_cb(arg_29_0, arg_29_1, arg_29_2, arg_29_3)
	if arg_29_3.error then
		Application.warning(arg_29_3.error)
	end

	if arg_29_3.product_details then
		for iter_29_0, iter_29_1 in pairs(arg_29_3.product_details) do
			local var_29_0 = arg_29_2[string.upper(iter_29_0)]

			arg_29_0._app_prices[var_29_0] = iter_29_1
		end
	end

	if arg_29_1 then
		local var_29_1 = arg_29_3.error == nil

		arg_29_1(var_29_1)
	end

	arg_29_0._app_prices_ready = true
end

function BackendInterfacePeddlerPlayFab.exchange_chips(arg_30_0, arg_30_1, arg_30_2, arg_30_3, arg_30_4)
	local var_30_0 = {
		StoreId = var_0_0,
		ItemId = arg_30_1,
		VirtualCurrency = arg_30_2,
		Price = arg_30_3
	}
	local var_30_1 = callback(arg_30_0, "_exchange_chips_success_cb", arg_30_4)
	local var_30_2 = callback(arg_30_0, "_exchange_chips_error_cb", arg_30_4)

	arg_30_0._backend_mirror:request_queue():enqueue_api_request("PurchaseItem", var_30_0, var_30_1, var_30_2)
end

function BackendInterfacePeddlerPlayFab._exchange_chips_success_cb(arg_31_0, arg_31_1, arg_31_2)
	local var_31_0 = arg_31_2.Items
	local var_31_1 = arg_31_0._chips
	local var_31_2 = arg_31_0._backend_mirror

	for iter_31_0 = 1, #var_31_0 do
		local var_31_3 = var_31_0[iter_31_0]
		local var_31_4 = var_31_3.ItemInstanceId

		var_31_2:add_item(var_31_4, var_31_3)

		if not var_31_3.BundleParent then
			local var_31_5 = var_31_3.UnitCurrency
			local var_31_6 = var_31_3.UnitPrice

			var_31_1[var_31_5] = var_31_1[var_31_5] - var_31_6

			print(string.format("[BackendInterfacePeddlerPlayFab] Exchanged %s %s for %s", var_31_6, var_31_5, var_31_3.ItemId))
		end
	end

	local var_31_7 = {
		FunctionName = "storePurchaseMade",
		FunctionParameter = {
			items = var_31_0
		}
	}
	local var_31_8 = callback(arg_31_0, "_store_purchase_made_cb", var_31_0)

	arg_31_0._backend_mirror:request_queue():enqueue(var_31_7, var_31_8, true)
	arg_31_1(true, var_31_0)
end

function BackendInterfacePeddlerPlayFab._exchange_chips_error_cb(arg_32_0, arg_32_1, arg_32_2, arg_32_3)
	local var_32_0 = arg_32_2.errorCode

	if var_0_1[var_32_0] then
		arg_32_3()
		arg_32_0:_refresh_on_error(arg_32_1)
	else
		Managers.backend:playfab_error(BACKEND_PLAYFAB_ERRORS.ERR_PLAYFAB_ERROR, var_32_0)
		arg_32_1(false)
	end
end

function BackendInterfacePeddlerPlayFab._store_purchase_made_cb(arg_33_0, arg_33_1, arg_33_2)
	local var_33_0 = arg_33_2.FunctionResult
	local var_33_1 = var_33_0.updated_statistics

	if var_33_1 then
		local var_33_2 = Managers.player and Managers.player:local_player()
		local var_33_3 = Managers.player:statistics_db()

		if not var_33_2 or not var_33_3 then
			print("[BackendInterfacePeddlerPlayFab] Could not get statistics_db, skipping updating statistics...")
		else
			local var_33_4 = var_33_2:stats_id()

			for iter_33_0, iter_33_1 in pairs(var_33_1) do
				if not var_33_3.statistics[var_33_4][iter_33_0] then
					Application.warning("[BackendInterfacePeddlerPlayFab] updated_statistics " .. iter_33_0 .. " doesn't exist.")
				else
					var_33_3:set_stat(var_33_4, iter_33_0, iter_33_1)
				end
			end
		end
	end

	if var_33_0.new_cosmetics then
		for iter_33_2 = 1, #var_33_0.new_cosmetics do
			local var_33_5 = var_33_0.new_cosmetics[iter_33_2]
			local var_33_6, var_33_7 = table.find_by_key(arg_33_1, "ItemId", var_33_5)

			arg_33_0._backend_mirror:add_item(var_33_7 and var_33_7.ItemInstanceId, {
				ItemId = var_33_0.new_cosmetics[iter_33_2]
			})
		end
	end

	if var_33_0.new_weapon_skins then
		for iter_33_3 = 1, #var_33_0.new_weapon_skins do
			arg_33_0._backend_mirror:add_item(nil, {
				ItemId = var_33_0.new_weapon_skins[iter_33_3]
			})
		end
	end
end

function BackendInterfacePeddlerPlayFab._refresh_on_error(arg_34_0, arg_34_1)
	arg_34_0:refresh_stock(callback(arg_34_0, "_refresh_stock_on_error_cb", arg_34_1))
end

function BackendInterfacePeddlerPlayFab._refresh_stock_on_error_cb(arg_35_0, arg_35_1)
	arg_35_0:refresh_chips(callback(arg_35_0, "_refresh_chips_on_error_cb", arg_35_1))
end

function BackendInterfacePeddlerPlayFab._refresh_chips_on_error_cb(arg_36_0, arg_36_1)
	arg_36_0:refresh_layout_override(false, callback(arg_36_0, "_refresh_layout_override_on_error_cb", arg_36_1))
end

function BackendInterfacePeddlerPlayFab._refresh_layout_override_on_error_cb(arg_37_0, arg_37_1)
	Managers.backend:playfab_error(BACKEND_PLAYFAB_ERRORS.ERR_PLAYFAB_NON_FATAL_STORE_ERROR, nil)
	arg_37_1(false)
end

function BackendInterfacePeddlerPlayFab.refresh_login_rewards(arg_38_0, arg_38_1)
	local var_38_0 = {
		FunctionName = "getStoreRewards"
	}
	local var_38_1 = callback(arg_38_0, "_refresh_login_rewards_cb", arg_38_1)

	arg_38_0._backend_mirror:request_queue():enqueue(var_38_0, var_38_1, false)
end

function BackendInterfacePeddlerPlayFab._refresh_login_rewards_cb(arg_39_0, arg_39_1, arg_39_2)
	local var_39_0 = arg_39_2.FunctionResult

	arg_39_0._login_rewards = var_39_0

	if arg_39_1 then
		arg_39_1(var_39_0)
	end
end

function BackendInterfacePeddlerPlayFab.get_login_rewards(arg_40_0)
	return arg_40_0._login_rewards
end

function BackendInterfacePeddlerPlayFab.done_claiming_login_rewards(arg_41_0)
	return arg_41_0._is_done_claiming
end

function BackendInterfacePeddlerPlayFab.claim_login_rewards(arg_42_0, arg_42_1, arg_42_2)
	if not arg_42_0._is_done_claiming then
		return
	end

	local var_42_0 = {
		FunctionName = "claimStoreRewards",
		FunctionParameter = {
			offset = arg_42_2
		}
	}
	local var_42_1 = callback(arg_42_0, "_claim_store_rewards_cb", arg_42_1, arg_42_2)

	arg_42_0._backend_mirror:request_queue():enqueue(var_42_0, var_42_1, true)

	arg_42_0._is_done_claiming = false
end

function BackendInterfacePeddlerPlayFab._claim_store_rewards_cb(arg_43_0, arg_43_1, arg_43_2, arg_43_3)
	arg_43_0:_refresh_login_rewards_cb(nil, arg_43_3)

	local var_43_0 = arg_43_3.FunctionResult.items
	local var_43_1 = arg_43_0._backend_mirror
	local var_43_2 = false

	if var_43_0 then
		for iter_43_0 = 1, #var_43_0 do
			local var_43_3 = var_43_0[iter_43_0]
			local var_43_4 = var_43_3.ItemInstanceId

			if not var_43_3.UsesIncrementedBy then
				local var_43_5 = 1
			end

			var_43_1:add_item(var_43_4, var_43_3)

			var_43_2 = true
		end
	end

	local var_43_6 = arg_43_3.FunctionResult.new_cosmetics

	if var_43_6 then
		local var_43_7 = arg_43_0._backend_mirror

		for iter_43_1 = 1, #var_43_6 do
			local var_43_8 = var_43_6[iter_43_1]

			if var_43_7:add_item(nil, {
				ItemId = var_43_8
			}) then
				var_43_2 = true
			end
		end
	end

	local var_43_9 = arg_43_3.FunctionResult.new_steam_items

	if var_43_9 then
		local var_43_10 = arg_43_0._backend_mirror

		for iter_43_2 = 1, #var_43_9 do
			local var_43_11 = var_43_9[iter_43_2]
			local var_43_12 = tonumber(var_43_11[1])
			local var_43_13 = var_43_11[2]
			local var_43_14 = var_43_11[3]
			local var_43_15 = var_43_11[4]
			local var_43_16 = SteamitemdefidToMasterList[var_43_12]

			if var_43_16 then
				local var_43_17 = {
					ItemId = var_43_16,
					ItemInstanceId = var_43_13
				}

				if var_43_10:add_item(var_43_13, var_43_17, true) then
					var_43_2 = true
				end
			end
		end
	end

	local var_43_18 = arg_43_3.FunctionResult.currency_added

	if var_43_18 then
		for iter_43_3 = 1, #var_43_18 do
			local var_43_19 = var_43_18[iter_43_3]

			arg_43_0:set_chips(var_43_19.code, (arg_43_0._chips[var_43_19.code] or 0) + var_43_19.amount)
		end

		var_43_2 = true
	end

	local var_43_20 = arg_43_3.FunctionResult.chest_inventory

	if var_43_20 then
		var_43_1:set_read_only_data("chest_inventory", var_43_20, true)
	end

	if var_43_2 then
		Managers.telemetry_events:store_rewards_claimed(arg_43_3.FunctionResult, arg_43_2)
		Managers.save:auto_save(SaveFileName, SaveData, nil)
	end

	arg_43_0._is_done_claiming = true

	if arg_43_1 then
		arg_43_1(arg_43_3.FunctionResult)
	end
end
