-- chunkname: @scripts/managers/backend_playfab/backend_interface_dlcs_playfab.lua

local PlayFabClientApi = require("PlayFab.PlayFabClientApi")

BackendInterfaceDLCsPlayfab = class(BackendInterfaceDLCsPlayfab)

BackendInterfaceDLCsPlayfab.init = function (self, arg_1_1)
	-- function 1
	self.is_local = false
	self._backend_mirror = arg_1_1
	self._last_id = 0
	self._updating_dlc_ownership = false
	self._owned_dlcs = arg_1_1:get_owned_dlcs()
	self._platform_dlcs = arg_1_1:get_platform_dlcs()
end

BackendInterfaceDLCsPlayfab.ready = function (arg_2_0)
	-- function 2
	return true
end

BackendInterfaceDLCsPlayfab.update = function (arg_3_0, arg_3_1)
	-- function 3
	return
end

BackendInterfaceDLCsPlayfab._new_id = function (self)
	-- function 4
	self._last_id = self._last_id + 1

	return self._last_id
end

BackendInterfaceDLCsPlayfab.update_dlc_ownership = function (self)
	-- function 5
	local get_installed_dlcs = Managers.unlock:get_installed_dlcs()
	local encode = cjson.encode(get_installed_dlcs)
	local tbl = {
		FunctionName = "updateDLCOwnership",
		FunctionParameter = {
			installed_dlcs = encode
		}
	}
	local var_5_3 = callback(self, "_update_owned_dlcs_cb")

	self._backend_mirror:request_queue():enqueue(tbl, var_5_3, false)

	self._updating_dlc_ownership = true
end

BackendInterfaceDLCsPlayfab._update_owned_dlcs_cb = function (self, arg_6_1)
	-- function 6
	local FunctionResult = arg_6_1.FunctionResult
	local new_dlcs = FunctionResult.new_dlcs
	local revoked_dlcs = FunctionResult.revoked_dlcs
	local flag = (not not GameSettingsDevelopment.read_only_backend or not new_dlcs) and not revoked_dlcs and #new_dlcs > 0 or #revoked_dlcs > 0

	self._owner_dlcs_cb_data = table.shallow_copy(FunctionResult)

	local _owner_dlcs_cb_data = self._owner_dlcs_cb_data
	local HAS_STEAM = HAS_STEAM

	HAS_STEAM = not HAS_STEAM and flag
	_owner_dlcs_cb_data.dlcs_dirty = HAS_STEAM

	if not flag then
		self:_execute_dlc_specific_logic()
	else
		self:_handle_owned_dlcs_data()

		self._updating_dlc_ownership = false
	end
end

BackendInterfaceDLCsPlayfab._handle_owned_dlcs_data = function (self)
	-- function 7
	local _owner_dlcs_cb_data = self._owner_dlcs_cb_data
	local owned_dlcs = _owner_dlcs_cb_data.owned_dlcs
	local platform_dlcs = _owner_dlcs_cb_data.platform_dlcs
	local excluded_dlcs = _owner_dlcs_cb_data.excluded_dlcs
	local new_dlcs = _owner_dlcs_cb_data.new_dlcs
	local revoked_dlcs = _owner_dlcs_cb_data.revoked_dlcs

	self._owned_dlcs = owned_dlcs or {}
	self._platform_dlcs = platform_dlcs

	Managers.unlock:set_excluded_dlcs(excluded_dlcs)
	self._backend_mirror:set_owned_dlcs(owned_dlcs)
	self._backend_mirror:set_platform_dlcs(platform_dlcs)
	print("Finished Updating Owned DLCS")
	table.dump(self._owned_dlcs, nil, 2)
	self._backend_mirror:update_owned_dlcs(true)

	if not (not revoked_dlcs and not (#revoked_dlcs > 0)) then
		local unlocked_keep_decorations = _owner_dlcs_cb_data.unlocked_keep_decorations

		if not unlocked_keep_decorations then
			self._backend_mirror:set_read_only_data("unlocked_keep_decorations", unlocked_keep_decorations, true)
		end

		local unlocked_cosmetics = _owner_dlcs_cb_data.unlocked_cosmetics

		if not unlocked_cosmetics then
			self._backend_mirror:set_read_only_data("unlocked_cosmetics", unlocked_cosmetics, true)
		end

		local unlocked_weapon_skins = _owner_dlcs_cb_data.unlocked_weapon_skins

		if not unlocked_weapon_skins then
			self._backend_mirror:set_read_only_data("unlocked_weapon_skins", unlocked_weapon_skins, true)
		end
	end

	self._backend_mirror:update_filtered_dlc_data()

	if not _owner_dlcs_cb_data.dlcs_dirty then
		self._backend_mirror:handle_new_dlcs(new_dlcs)
	end
end

BackendInterfaceDLCsPlayfab._execute_dlc_specific_logic = function (self)
	-- function 8
	local tbl = {
		FunctionName = "executeDLCLogic",
		FunctionParameter = {}
	}
	local var_8_1 = callback(self, "_execute_dlc_logic_cb")

	self._backend_mirror:request_queue():enqueue(tbl, var_8_1, true)
end

BackendInterfaceDLCsPlayfab._execute_dlc_logic_cb = function (self, arg_9_1)
	-- function 9
	local item_grant_results = arg_9_1.FunctionResult.item_grant_results

	self:_handle_owned_dlcs_data()

	local get_user_data = self._backend_mirror:get_user_data("unseen_rewards")
	local flag

	flag = not get_user_data and cjson.decode(get_user_data) and {}

	for i = 1, #item_grant_results do
		local var_9_3 = item_grant_results[i]
		local ItemId = var_9_3.ItemId
		local ItemType = var_9_3.ItemType

		if ItemType == "keep_decoration_painting" then
			local tbl = {
				reward_type = "keep_decoration_painting",
				rewarded_from = var_9_3.Data.rewarded_from,
				keep_decoration_name = ItemId
			}

			flag[#flag + 1] = tbl

			self._backend_mirror:add_keep_decoration(ItemId)
		elseif not CosmeticUtils.is_cosmetic_item(ItemType) then
			local add_item = self._backend_mirror:add_item(nil, {
				ItemId = ItemId
			})

			if not add_item then
				local tbl_2 = {
					reward_type = ItemType,
					backend_id = add_item,
					rewarded_from = var_9_3.Data.rewarded_from,
					item_type = ItemType,
					item_id = ItemId
				}

				flag[#flag + 1] = tbl_2
			end
		else
			local var_9_9 = ItemMasterList[ItemId]
			local rewarded_from = var_9_3.CustomData.rewarded_from

			if not var_9_9.bundle then
				local BundledVirtualCurrencies = var_9_9.bundle.BundledVirtualCurrencies

				for k, v in pairs(BundledVirtualCurrencies) do
					if not rewarded_from then
						local tbl_3 = {
							reward_type = "currency",
							currency_type = k,
							currency_amount = v,
							rewarded_from = rewarded_from
						}

						flag[#flag + 1] = tbl_3
					end

					if k == "SM" then
						local get_interface = Managers.backend:get_interface("peddler")
						local get_chips = get_interface:get_chips("SM")

						get_interface:set_chips(k, get_chips + v)
					end
				end
			else
				local ItemInstanceId = var_9_3.ItemInstanceId

				if not rewarded_from then
					local item_type = ItemMasterList[var_9_3.ItemId].item_type
					local tbl_4 = {
						reward_type = "item",
						backend_id = ItemInstanceId,
						rewarded_from = rewarded_from,
						item_type = item_type,
						item_id = ItemId
					}

					flag[#flag + 1] = tbl_4
				end

				self._backend_mirror:add_item(ItemInstanceId, var_9_3)
			end
		end
	end

	self._backend_mirror:set_user_data("unseen_rewards", cjson.encode(flag))
	print("Finished Getting New DLC Rewards")
	print("New Rewards:")
	table.dump(flag, "unseen_rewards", 5)

	self._updating_dlc_ownership = false
end

BackendInterfaceDLCsPlayfab.get_owned_dlcs = function (self)
	-- function 10
	return self._owned_dlcs
end

BackendInterfaceDLCsPlayfab.get_platform_dlcs = function (self)
	-- function 11
	return self._platform_dlcs
end

BackendInterfaceDLCsPlayfab.updating_dlc_ownership = function (self)
	-- function 12
	return self._updating_dlc_ownership
end

BackendInterfaceDLCsPlayfab.is_unreleased_career = function (self, arg_13_1)
	-- function 13
	local unreleased_careers = self._backend_mirror:get_title_data().unreleased_careers

	if not unreleased_careers and not string.find(unreleased_careers, arg_13_1) then
		return true
	end

	return false
end
