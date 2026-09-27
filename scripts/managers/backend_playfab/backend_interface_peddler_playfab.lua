-- chunkname: @scripts/managers/backend_playfab/backend_interface_peddler_playfab.lua

require("scripts/utils/steam_item_service")

BackendInterfacePeddlerPlayFab = class(BackendInterfacePeddlerPlayFab)

local str = "Store"
local tbl = {
	[1052] = true,
	[1053] = true,
	[1047] = true,
	[1059] = true
}

BackendInterfacePeddlerPlayFab.init = function (self, arg_1_1)
	-- function 1
	self._backend_mirror = arg_1_1
	self._peddler_stock = {}
	self._chips = {}
	self._app_prices = {}
	self._psn_requests = {}
	self._stock_ready = false
	self._chips_ready = false
	self._steam_stock_ready = not HAS_STEAM
	self._app_prices_ready = false
	self._steam_item_prices = {}
	self._login_rewards_cooldown = 0
	self._is_done_claiming = true

	self:refresh_stock()
	self:refresh_chips()
	self:refresh_layout_override(true)
	self:refresh_app_prices()
	self:refresh_platform_item_prices()
	self:refresh_login_rewards()
end

BackendInterfacePeddlerPlayFab.ready = function (self)
	-- function 2
	local _login_rewards = self._login_rewards

	if not _login_rewards then
		_login_rewards = self._stock_ready

		if not _login_rewards then
			_login_rewards = self._steam_stock_ready

			if not _login_rewards then
				_login_rewards = self._chips_ready
				_login_rewards = not _login_rewards and self._app_prices_ready
			end
		end
	end

	return _login_rewards
end

BackendInterfacePeddlerPlayFab.destroy = function (self)
	-- function 3
	self._peddler_stock = nil
	self._chips = nil
	self._app_prices = nil
end

BackendInterfacePeddlerPlayFab.get_peddler_stock = function (self)
	-- function 4
	return self._peddler_stock
end

local tbl_2 = {}

BackendInterfacePeddlerPlayFab.get_filtered_items = function (self, arg_5_1, arg_5_2)
	-- function 5
	local _peddler_stock = self._peddler_stock

	return (Managers.backend:get_interface("common"):filter_items(_peddler_stock, arg_5_1, arg_5_2 or tbl_2))
end

BackendInterfacePeddlerPlayFab.get_chips = function (self, arg_6_1)
	-- function 6
	return self._chips[arg_6_1]
end

BackendInterfacePeddlerPlayFab.get_app_price = function (self, arg_7_1)
	-- function 7
	return self._app_prices[arg_7_1]
end

BackendInterfacePeddlerPlayFab.get_steam_item_price = function (self, arg_8_1)
	-- function 8
	return self._steam_item_prices[arg_8_1], self._steam_item_currency
end

BackendInterfacePeddlerPlayFab.is_purchaseable = function (self, arg_9_1)
	-- function 9
	return self._steam_item_prices[arg_9_1] ~= nil
end

BackendInterfacePeddlerPlayFab.get_unseen_currency_rewards = function (self)
	-- function 10
	local get_user_data = self._backend_mirror:get_user_data("unseen_rewards")

	if not get_user_data then
		return nil
	end

	local currency_ui_settings = DLCSettings.store.currency_ui_settings
	local decode = cjson.decode(get_user_data)
	local var_10_3
	local num = 1

	while num <= #decode do
		local var_10_5 = decode[num]
		local reward_type = var_10_5.reward_type
		local currency_type = var_10_5.currency_type

		if not (reward_type ~= "currency" or currency_ui_settings[currency_type] == nil) then
			var_10_3 = var_10_3 or {}
			var_10_3[#var_10_3 + 1] = var_10_5

			table.remove(decode, num)
		else
			num = num + 1
		end
	end

	if not var_10_3 then
		self._backend_mirror:set_user_data("unseen_rewards", cjson.encode(decode))
	end

	return var_10_3
end

BackendInterfacePeddlerPlayFab.refresh_stock = function (self, arg_11_1)
	-- function 11
	self._peddler_stock = {}

	local tbl = {
		StoreId = str
	}
	local var_11_1 = callback(self, "_refresh_stock_cb", arg_11_1)

	self._backend_mirror:request_queue():enqueue_api_request("GetStoreItems", tbl, var_11_1)
end

local function fn(self)
	-- function 12
	local var_12_0

	if not IS_CONSOLE then
		return true
	else
		local steam_itemdefid = self.steam_itemdefid

		var_12_0 = steam_itemdefid ~= nil

		if not var_12_0 then
			local flag = false

			if not steam_itemdefid and not HAS_STEAM then
				flag = true
			end

			if not flag then
				return false
			end
		end
	end

	return true, var_12_0
end

BackendInterfacePeddlerPlayFab._refresh_stock_cb = function (self, arg_13_1, arg_13_2)
	-- function 13
	local Store = arg_13_2.Store
	local _peddler_stock = self._peddler_stock
	local get_all_inventory_items = self._backend_mirror:get_all_inventory_items()
	local HAS_STEAM = HAS_STEAM
	local num = #_peddler_stock + 1
	local seen_shop_items = PlayerData.seen_shop_items
	local flag = false

	for i = 1, #Store do
		local var_13_7 = Store[i]
		local ItemId = var_13_7.ItemId

		if not (not var_13_7.ItemId and rawget(ItemMasterList, var_13_7.ItemId)) then
			printf("BackendInterfacePeddlerPlayFab - ItemMasterList has no item %q", tostring(var_13_7.ItemId))
		else
			local var_13_9 = ItemMasterList[ItemId]
			local flag_2 = false

			for k, v in pairs(get_all_inventory_items) do
				if ItemId == v.key then
					flag_2 = true

					break
				end
			end

			local var_13_11, var_13_12 = fn(var_13_9)

			if not (not var_13_11 and var_13_12) then
				local regular_prices = var_13_7.CustomData.regular_prices
				local VirtualCurrencyPrices = var_13_7.VirtualCurrencyPrices

				_peddler_stock[num] = {
					type = "item",
					data = table.clone(var_13_9),
					key = ItemId,
					id = ItemId,
					regular_prices = regular_prices,
					current_prices = VirtualCurrencyPrices,
					end_time = var_13_7.CustomData.end_time,
					owned = flag_2,
					dlc_name = var_13_9.dlc_name,
					steam_itemdefid = not HAS_STEAM and var_13_9.steam_itemdefid
				}
				num = num + 1

				if not seen_shop_items[ItemId] then
					flag = true
				end
			end
		end
	end

	print(string.format("[BackendInterfacePeddlerPlayFab] _refresh_stock_cb -> Added %s item(s) to the peddler stock", #_peddler_stock))

	self._peddler_stock = _peddler_stock
	self._stock_ready = true

	if not arg_13_1 then
		arg_13_1()
	end

	if BUILD ~= "dev" or IS_XB1 or not IS_PS4 then
		flag = false
	end

	if not flag then
		local Metadata = arg_13_2.MarketingData.Metadata

		if type(Metadata) == "string" then
			Metadata = cjson.decode(Metadata)
		end

		local uploaded = Metadata.uploaded
		local store_update_timestamp = PlayerData.store_update_timestamp

		if not (not store_update_timestamp and not (store_update_timestamp < uploaded)) then
			PlayerData.store_new_items = true
			PlayerData.store_update_timestamp = uploaded

			Managers.save:auto_save(SaveFileName, SaveData, nil)
		end
	else
		PlayerData.store_new_items = false
	end
end

BackendInterfacePeddlerPlayFab.set_chips = function (arg_14_0, arg_14_1, arg_14_2)
	-- function 14
	arg_14_0._chips[arg_14_1] = arg_14_2
end

BackendInterfacePeddlerPlayFab.refresh_chips = function (self, arg_15_1)
	-- function 15
	local tbl = {
		FunctionName = "getUserChips",
		FunctionParameter = {}
	}

	self._backend_mirror:request_queue():enqueue(tbl, callback(self, "_refresh_chips_cb", arg_15_1), false)
end

BackendInterfacePeddlerPlayFab._refresh_chips_cb = function (self, arg_16_1, arg_16_2)
	-- function 16
	local chips = arg_16_2.FunctionResult.chips

	for k, v in pairs(chips) do
		self:set_chips(k, v)
	end

	self._chips_ready = true

	if not arg_16_1 then
		arg_16_1()
	end
end

BackendInterfacePeddlerPlayFab.refresh_layout_override = function (self, arg_17_1, arg_17_2)
	-- function 17
	local _backend_mirror = self._backend_mirror

	if not arg_17_1 then
		local store_layout_override = _backend_mirror:get_title_data().store_layout_override

		if not store_layout_override then
			local decode = cjson.decode(store_layout_override)
			local StoreLayoutConfig = StoreLayoutConfig

			if not decode.menu_options then
				StoreLayoutConfig.menu_options = decode.menu_options
			end

			if not decode.structure then
				for k, v in pairs(decode.structure) do
					StoreLayoutConfig.structure[k] = v
				end
			end

			if not decode.pages then
				for k_2, v_2 in pairs(decode.pages) do
					StoreLayoutConfig.pages[k_2] = v_2
				end
			end
		end

		if not arg_17_2 then
			arg_17_2()
		end
	else
		local tbl = {
			Keys = {
				"store_layout_override"
			}
		}
		local var_17_5 = callback(self, "_refresh_layout_override_cb", arg_17_2)

		self._backend_mirror:request_queue():enqueue_api_request("GetTitleData", tbl, var_17_5)
	end
end

BackendInterfacePeddlerPlayFab._refresh_layout_override_cb = function (self, arg_18_1, arg_18_2)
	-- function 18
	local Data = arg_18_2.Data

	Data = not Data and arg_18_2.Data.store_layout_override

	self._backend_mirror:set_title_data("store_layout_override", Data)
	self:refresh_layout_override(true, arg_18_1)
end

BackendInterfacePeddlerPlayFab.store_display_items = function (self)
	-- function 19
	local store_display_items = self._backend_mirror:get_title_data().store_display_items

	return not store_display_items and cjson.decode(store_display_items)
end

BackendInterfacePeddlerPlayFab.refresh_platform_item_prices = function (arg_20_0, arg_20_1)
	-- function 20
	if not HAS_STEAM then
		print("[BackendInterfacePeddlerPlayFab] refresh steam item prices")
		Managers.steam:request_item_prices(callback(arg_20_0, "_refresh_steam_item_prices_cb", arg_20_1))
	end
end

BackendInterfacePeddlerPlayFab._read_bundle_from_steam = function (arg_21_0, arg_21_1)
	-- function 21
	local get_item_definition_property = SteamInventory.get_item_definition_property(arg_21_1, "bundle")

	if not get_item_definition_property then
		local split_deprecated = string.split_deprecated(get_item_definition_property, ";")

		for i, v in ipairs(split_deprecated) do
			split_deprecated[i] = tonumber(v)
		end

		local get_item_definition_property_2 = SteamInventory.get_item_definition_property(arg_21_1, "purchase_bundle_discount")

		return split_deprecated, tonumber(get_item_definition_property_2)
	end
end

BackendInterfacePeddlerPlayFab._refresh_steam_item_prices_cb = function (self, arg_22_1, arg_22_2, arg_22_3)
	-- function 22
	print("_refresh_steam_item_prices_cb")

	local get_all_inventory_items = self._backend_mirror:get_all_inventory_items()
	local _peddler_stock = self._peddler_stock
	local num = #_peddler_stock + 1
	local tbl = {}

	for i = 1, #arg_22_2, 2 do
		local var_22_4 = arg_22_2[i]
		local var_22_5 = arg_22_2[i + 1]
		local var_22_6 = SteamitemdefidToMasterList[var_22_4]

		if not var_22_6 then
			self._steam_item_prices[var_22_4] = var_22_5

			local var_22_7 = ItemMasterList[var_22_6]

			if var_22_7.steam_store_hidden or not fn(var_22_7) then
				local flag = false

				for k, v in pairs(get_all_inventory_items) do
					if var_22_6 == v.key then
						flag = true

						break
					end
				end

				local clone = table.clone(var_22_7)

				if not (var_22_7.item_type == "bundle" or var_22_7.item_type ~= "cosmetic_bundle") then
					local _read_bundle_from_steam, var_22_11 = self:_read_bundle_from_steam(var_22_4)

					if not _read_bundle_from_steam then
						clone.bundle_contains = _read_bundle_from_steam
						clone.discount = var_22_11
					else
						Crashify.print_exception("[BackendInterfacePeddlerPlayFab]", "_refresh_steam_item_prices_cb, bundle_contains table is empty. steam_itemdef_id: %s", tostring(var_22_4))
						print(table.dump(clone, "MISSING BUNDLE CONTAINS", 2))
					end

					tbl[#tbl + 1] = clone
				end

				_peddler_stock[num] = {
					type = "item",
					data = clone,
					key = var_22_6,
					id = var_22_6,
					owned = flag,
					steam_itemdefid = var_22_4,
					steam_price = var_22_5,
					steam_data = SteamItemService.get_item_data(var_22_4)
				}
				num = num + 1
			end
		else
			print("Missing item masterlist item for steam_itemdefid:", var_22_4)
		end
	end

	for l = 1, #tbl do
		local var_22_12 = tbl[l]
		local num_2 = 0
		local bundle_contains = var_22_12.bundle_contains

		if type(bundle_contains) == "table" then
			for i4 = 1, #bundle_contains do
				local var_22_15 = bundle_contains[i4]
				local var_22_16 = self._steam_item_prices[var_22_15]

				var_22_16 = var_22_16 or 0
				num_2 = num_2 + var_22_16
			end
		end

		var_22_12.bundle_price = num_2
	end

	self._steam_item_currency = arg_22_3
	self._steam_stock_ready = true

	if not arg_22_1 then
		arg_22_1()
	end
end

BackendInterfacePeddlerPlayFab.refresh_app_prices = function (self, arg_23_1)
	-- function 23
	local PLATFORM = PLATFORM

	if IS_WINDOWS or not IS_LINUX then
		self:_refresh_app_prices_steam(arg_23_1)
	elseif not IS_PS4 then
		self:_refresh_app_prices_psn(arg_23_1)
	elseif not IS_XB1 then
		self:_refresh_app_prices_xboxlive(arg_23_1)
	end
end

BackendInterfacePeddlerPlayFab._refresh_app_prices_steam = function (self, arg_24_1)
	-- function 24
	local tbl = {
		FunctionName = "getSteamAppPriceInfo",
		FunctionParameter = {}
	}

	self._backend_mirror:request_queue():enqueue(tbl, callback(self, "_refresh_app_prices_steam_cb", arg_24_1), false)
end

BackendInterfacePeddlerPlayFab._refresh_app_prices_steam_cb = function (self, arg_25_1, arg_25_2)
	-- function 25
	local FunctionResult = arg_25_2.FunctionResult
	local flag = true

	if not FunctionResult.error then
		print("[BackendInterfacePeddlerPlayFab] _refresh_app_prices_steam_cb ERROR", FunctionResult.error)

		flag = false
	else
		local price_info = FunctionResult.price_info

		if not price_info then
			for k, v in pairs(price_info) do
				local currency = v.currency
				local initial_price = v.initial_price
				local final_price = v.final_price

				self._app_prices[k] = {
					currency = currency,
					regular_price = initial_price,
					current_price = final_price
				}
			end
		end
	end

	self._app_prices_ready = true

	if not arg_25_1 then
		arg_25_1(flag)
	end
end

BackendInterfacePeddlerPlayFab._refresh_app_prices_psn = function (self, arg_26_1)
	-- function 26
	table.clear(self._psn_requests)

	local tbl = {}
	local str = ""
	local title_id = PS4.title_id()

	table.clear(self._app_prices)

	for k, v in pairs(DLCSettings) do
		local unlock_settings_ps4 = v.unlock_settings_ps4

		if not unlock_settings_ps4 then
			local var_26_4 = unlock_settings_ps4[title_id]

			var_26_4 = var_26_4 or {}

			for k_2, v_2 in pairs(var_26_4) do
				local product_label = v_2.product_label

				if not product_label then
					str = str .. v_2.product_label .. ":"
					tbl[product_label] = k_2

					if table.size(tbl) > 20 then
						self._psn_requests[#self._psn_requests + 1] = {
							product_labels_string = str,
							product_label_lookup = table.clone(tbl)
						}

						table.clear(tbl)

						str = ""
					end
				end
			end
		end
	end

	if table.size(tbl) > 0 then
		self._psn_requests[#self._psn_requests + 1] = {
			product_labels_string = str,
			product_label_lookup = table.clone(tbl)
		}

		table.clear(tbl)

		local str_2 = ""
	end

	local var_26_7 = self._psn_requests[1]

	Managers.account:get_product_details(var_26_7.product_labels_string, 0, callback(self, "_refresh_app_prices_psn_cb", arg_26_1, var_26_7.product_label_lookup))
end

BackendInterfacePeddlerPlayFab._refresh_app_prices_psn_cb = function (self, arg_27_1, arg_27_2, arg_27_3)
	-- function 27
	print("")
	print("############ WEBAPI JSON COMMERCE RESULT ############")
	print(arg_27_3)
	print("#####################################################")
	print("")

	if not arg_27_3 then
		local tbl = {}
		local decode = cjson.decode(arg_27_3)

		for k, v in pairs(decode) do
			local label = v.label
			local skus = v.skus
			local var_27_4

			if not skus then
				var_27_4 = skus[1]

				if not var_27_4 then
					-- Nothing
				end
			end

			var_27_4 = tbl

			::label_27_0::

			local var_27_5 = arg_27_2[label]

			self._app_prices[var_27_5] = {
				name = v.name,
				is_plus_price = var_27_4.is_plus_price,
				plus_upsell_price = var_27_4.plus_upsell_price,
				original_price = var_27_4.original_price,
				price = var_27_4.price,
				display_original_price = var_27_4.display_original_price,
				display_plus_upsell_price = var_27_4.display_plus_upsell_price,
				display_price = var_27_4.display_price,
				product_id = var_27_4.product_id,
				product_label = label
			}
		end
	elseif not arg_27_1 then
		local flag = false

		arg_27_1(flag)
	end

	table.remove(self._psn_requests, 1)

	if table.size(self._psn_requests) > 0 then
		local var_27_7 = self._psn_requests[1]

		Managers.account:get_product_details(var_27_7.product_labels_string, 0, callback(self, "_refresh_app_prices_psn_cb", arg_27_1, var_27_7.product_label_lookup))
	else
		self._app_prices_ready = true

		if not arg_27_1 then
			local flag_2 = false

			arg_27_1(flag_2)
		end
	end
end

BackendInterfacePeddlerPlayFab._refresh_app_prices_xboxlive = function (self, arg_28_1)
	-- function 28
	local tbl = {}
	local tbl_2 = {}

	table.clear(self._app_prices)

	for k, v in pairs(DLCSettings) do
		local unlock_settings_xb1 = v.unlock_settings_xb1

		unlock_settings_xb1 = unlock_settings_xb1 or {}

		for k_2, v_2 in pairs(unlock_settings_xb1) do
			local id = v_2.id

			if not id then
				tbl_2[#tbl_2 + 1] = id
				tbl[id] = k_2
			end
		end
	end

	if #tbl_2 < 0 then
		local flag = true

		if not arg_28_1 then
			arg_28_1(flag)
		end

		return
	end

	print("####### GET PRICING INFORMATION")
	table.dump(tbl_2, "PRODUCT_IDS", 5)
	table.dump(tbl, "PRODUCT_ID_LOOKUP", 5)
	Managers.account:get_product_details(tbl_2, callback(self, "_refresh_app_prices_xboxlive_cb", arg_28_1, tbl))
end

BackendInterfacePeddlerPlayFab._refresh_app_prices_xboxlive_cb = function (self, arg_29_1, arg_29_2, arg_29_3)
	-- function 29
	if not arg_29_3.error then
		Application.warning(arg_29_3.error)
	end

	if not arg_29_3.product_details then
		for k, v in pairs(arg_29_3.product_details) do
			local var_29_0 = arg_29_2[string.upper(k)]

			self._app_prices[var_29_0] = v
		end
	end

	if not arg_29_1 then
		local flag = arg_29_3.error == nil

		arg_29_1(flag)
	end

	self._app_prices_ready = true
end

BackendInterfacePeddlerPlayFab.exchange_chips = function (self, arg_30_1, arg_30_2, arg_30_3, arg_30_4)
	-- function 30
	local tbl = {
		StoreId = str,
		ItemId = arg_30_1,
		VirtualCurrency = arg_30_2,
		Price = arg_30_3
	}
	local var_30_1 = callback(self, "_exchange_chips_success_cb", arg_30_4)
	local var_30_2 = callback(self, "_exchange_chips_error_cb", arg_30_4)

	self._backend_mirror:request_queue():enqueue_api_request("PurchaseItem", tbl, var_30_1, var_30_2)
end

BackendInterfacePeddlerPlayFab._exchange_chips_success_cb = function (self, arg_31_1, arg_31_2)
	-- function 31
	local Items = arg_31_2.Items
	local _chips = self._chips
	local _backend_mirror = self._backend_mirror

	for i = 1, #Items do
		local var_31_3 = Items[i]
		local ItemInstanceId = var_31_3.ItemInstanceId

		_backend_mirror:add_item(ItemInstanceId, var_31_3)

		if not var_31_3.BundleParent then
			local UnitCurrency = var_31_3.UnitCurrency
			local UnitPrice = var_31_3.UnitPrice

			_chips[UnitCurrency] = _chips[UnitCurrency] - UnitPrice

			print(string.format("[BackendInterfacePeddlerPlayFab] Exchanged %s %s for %s", UnitPrice, UnitCurrency, var_31_3.ItemId))
		end
	end

	local tbl = {
		FunctionName = "storePurchaseMade",
		FunctionParameter = {
			items = Items
		}
	}
	local var_31_8 = callback(self, "_store_purchase_made_cb", Items)

	self._backend_mirror:request_queue():enqueue(tbl, var_31_8, true)
	arg_31_1(true, Items)
end

BackendInterfacePeddlerPlayFab._exchange_chips_error_cb = function (self, arg_32_1, arg_32_2, arg_32_3)
	-- function 32
	local errorCode = arg_32_2.errorCode

	if not tbl[errorCode] then
		arg_32_3()
		self:_refresh_on_error(arg_32_1)
	else
		Managers.backend:playfab_error(BACKEND_PLAYFAB_ERRORS.ERR_PLAYFAB_ERROR, errorCode)
		arg_32_1(false)
	end
end

BackendInterfacePeddlerPlayFab._store_purchase_made_cb = function (self, arg_33_1, arg_33_2)
	-- function 33
	local FunctionResult = arg_33_2.FunctionResult
	local updated_statistics = FunctionResult.updated_statistics

	if not updated_statistics then
		local player = Managers.player

		player = not player and Managers.player:local_player()

		local statistics_db = Managers.player:statistics_db()

		if not (not player and statistics_db) then
			print("[BackendInterfacePeddlerPlayFab] Could not get statistics_db, skipping updating statistics...")
		else
			local stats_id = player:stats_id()

			for k, v in pairs(updated_statistics) do
				if not statistics_db.statistics[stats_id][k] then
					Application.warning("[BackendInterfacePeddlerPlayFab] updated_statistics " .. k .. " doesn't exist.")
				else
					statistics_db:set_stat(stats_id, k, v)
				end
			end
		end
	end

	if not FunctionResult.new_cosmetics then
		for k_2 = 1, #FunctionResult.new_cosmetics do
			local var_33_5 = FunctionResult.new_cosmetics[k_2]
			local find_by_key, var_33_7 = table.find_by_key(arg_33_1, "ItemId", var_33_5)

			self._backend_mirror:add_item(not var_33_7 and var_33_7.ItemInstanceId, {
				ItemId = FunctionResult.new_cosmetics[k_2]
			})
		end
	end

	if not FunctionResult.new_weapon_skins then
		for l = 1, #FunctionResult.new_weapon_skins do
			self._backend_mirror:add_item(nil, {
				ItemId = FunctionResult.new_weapon_skins[l]
			})
		end
	end
end

BackendInterfacePeddlerPlayFab._refresh_on_error = function (self, arg_34_1)
	-- function 34
	self:refresh_stock(callback(self, "_refresh_stock_on_error_cb", arg_34_1))
end

BackendInterfacePeddlerPlayFab._refresh_stock_on_error_cb = function (self, arg_35_1)
	-- function 35
	self:refresh_chips(callback(self, "_refresh_chips_on_error_cb", arg_35_1))
end

BackendInterfacePeddlerPlayFab._refresh_chips_on_error_cb = function (self, arg_36_1)
	-- function 36
	self:refresh_layout_override(false, callback(self, "_refresh_layout_override_on_error_cb", arg_36_1))
end

BackendInterfacePeddlerPlayFab._refresh_layout_override_on_error_cb = function (arg_37_0, arg_37_1)
	-- function 37
	Managers.backend:playfab_error(BACKEND_PLAYFAB_ERRORS.ERR_PLAYFAB_NON_FATAL_STORE_ERROR, nil)
	arg_37_1(false)
end

BackendInterfacePeddlerPlayFab.refresh_login_rewards = function (self, arg_38_1)
	-- function 38
	local tbl = {
		FunctionName = "getStoreRewards"
	}
	local var_38_1 = callback(self, "_refresh_login_rewards_cb", arg_38_1)

	self._backend_mirror:request_queue():enqueue(tbl, var_38_1, false)
end

BackendInterfacePeddlerPlayFab._refresh_login_rewards_cb = function (self, arg_39_1, arg_39_2)
	-- function 39
	local FunctionResult = arg_39_2.FunctionResult

	self._login_rewards = FunctionResult

	if not arg_39_1 then
		arg_39_1(FunctionResult)
	end
end

BackendInterfacePeddlerPlayFab.get_login_rewards = function (self)
	-- function 40
	return self._login_rewards
end

BackendInterfacePeddlerPlayFab.done_claiming_login_rewards = function (self)
	-- function 41
	return self._is_done_claiming
end

BackendInterfacePeddlerPlayFab.claim_login_rewards = function (self, arg_42_1, arg_42_2)
	-- function 42
	if not self._is_done_claiming then
		return
	end

	local tbl = {
		FunctionName = "claimStoreRewards",
		FunctionParameter = {
			offset = arg_42_2
		}
	}
	local var_42_1 = callback(self, "_claim_store_rewards_cb", arg_42_1, arg_42_2)

	self._backend_mirror:request_queue():enqueue(tbl, var_42_1, true)

	self._is_done_claiming = false
end

BackendInterfacePeddlerPlayFab._claim_store_rewards_cb = function (self, arg_43_1, arg_43_2, arg_43_3)
	-- function 43
	self:_refresh_login_rewards_cb(nil, arg_43_3)

	local items = arg_43_3.FunctionResult.items
	local _backend_mirror = self._backend_mirror
	local flag = false

	if not items then
		for i = 1, #items do
			local var_43_3 = items[i]
			local ItemInstanceId = var_43_3.ItemInstanceId

			if not var_43_3.UsesIncrementedBy then
				local num = 1
			end

			_backend_mirror:add_item(ItemInstanceId, var_43_3)

			flag = true
		end
	end

	local new_cosmetics = arg_43_3.FunctionResult.new_cosmetics

	if not new_cosmetics then
		local _backend_mirror_2 = self._backend_mirror

		for j = 1, #new_cosmetics do
			local var_43_8 = new_cosmetics[j]

			if not _backend_mirror_2:add_item(nil, {
				ItemId = var_43_8
			}) then
				flag = true
			end
		end
	end

	local new_steam_items = arg_43_3.FunctionResult.new_steam_items

	if not new_steam_items then
		local _backend_mirror_3 = self._backend_mirror

		for k = 1, #new_steam_items do
			local var_43_11 = new_steam_items[k]
			local var_43_12 = tonumber(var_43_11[1])
			local var_43_13 = var_43_11[2]
			local var_43_14 = var_43_11[3]
			local var_43_15 = var_43_11[4]
			local var_43_16 = SteamitemdefidToMasterList[var_43_12]

			if not var_43_16 then
				local tbl = {
					ItemId = var_43_16,
					ItemInstanceId = var_43_13
				}

				if not _backend_mirror_3:add_item(var_43_13, tbl, true) then
					flag = true
				end
			end
		end
	end

	local currency_added = arg_43_3.FunctionResult.currency_added

	if not currency_added then
		for l = 1, #currency_added do
			local var_43_19 = currency_added[l]
			local var_43_20 = self
			local set_chips = self.set_chips
			local code = var_43_19.code
			local var_43_23 = self._chips[var_43_19.code]

			var_43_23 = var_43_23 or 0

			set_chips(var_43_20, code, var_43_23 + var_43_19.amount)
		end

		flag = true
	end

	local chest_inventory = arg_43_3.FunctionResult.chest_inventory

	if not chest_inventory then
		_backend_mirror:set_read_only_data("chest_inventory", chest_inventory, true)
	end

	if not flag then
		Managers.telemetry_events:store_rewards_claimed(arg_43_3.FunctionResult, arg_43_2)
		Managers.save:auto_save(SaveFileName, SaveData, nil)
	end

	self._is_done_claiming = true

	if not arg_43_1 then
		arg_43_1(arg_43_3.FunctionResult)
	end
end
