-- chunkname: @scripts/managers/backend_playfab/backend_interface_crafting_playfab.lua

require("scripts/managers/backend_playfab/backend_interface_crafting_base")

local PlayFabClientApi = require("PlayFab.PlayFabClientApi")

BackendInterfaceCraftingPlayfab = class(BackendInterfaceCraftingPlayfab, BackendInterfaceCraftingBase)

BackendInterfaceCraftingPlayfab.init = function (self, arg_1_1)
	-- function 1
	BackendInterfaceCraftingPlayfab.super.init(self)

	self.is_local = false
	self._backend_mirror = arg_1_1
	self._last_id = 0
	self._craft_requests = {}
end

BackendInterfaceCraftingPlayfab.ready = function (arg_2_0)
	-- function 2
	return true
end

BackendInterfaceCraftingPlayfab.update = function (arg_3_0, arg_3_1)
	-- function 3
	return
end

BackendInterfaceCraftingPlayfab._new_id = function (self)
	-- function 4
	self._last_id = self._last_id + 1

	return self._last_id
end

BackendInterfaceCraftingPlayfab.craft = function (self, arg_5_1, arg_5_2, arg_5_3)
	-- function 5
	local _get_valid_recipe, var_5_1 = self:_get_valid_recipe(arg_5_2, arg_5_3)
	local profile_name = CareerSettings[arg_5_1].profile_name

	if not _get_valid_recipe and not _get_valid_recipe.result_function_playfab then
		local _new_id = self:_new_id()
		local tbl = {
			FunctionName = _get_valid_recipe.result_function_playfab,
			FunctionParameter = {
				item_backend_ids_and_amounts = var_5_1,
				hero_name = profile_name
			}
		}
		local var_5_5 = callback(self, "craft_request_cb", _new_id)

		self._backend_mirror:request_queue():enqueue(tbl, var_5_5, true)

		return _new_id, _get_valid_recipe
	end

	return nil
end

BackendInterfaceCraftingPlayfab.craft_request_cb = function (self, arg_6_1, arg_6_2)
	-- function 6
	local backend = Managers.backend
	local get_interface = backend:get_interface("items")
	local _backend_mirror = self._backend_mirror
	local FunctionResult = arg_6_2.FunctionResult
	local items = FunctionResult.items
	local consumed_items = FunctionResult.consumed_items
	local modified_items = FunctionResult.modified_items
	local unlocked_weapon_skins = FunctionResult.unlocked_weapon_skins
	local tbl = {}

	if not items then
		for i = 1, #items do
			local var_6_9 = items[i]
			local ItemInstanceId = var_6_9.ItemInstanceId
			local UsesIncrementedBy = var_6_9.UsesIncrementedBy

			UsesIncrementedBy = UsesIncrementedBy or 1

			_backend_mirror:add_item(ItemInstanceId, var_6_9)

			tbl[i] = {
				ItemInstanceId,
				[3] = UsesIncrementedBy
			}
		end
	end

	if not consumed_items then
		for j = 1, #consumed_items do
			local var_6_12 = consumed_items[j]
			local ItemInstanceId_2 = var_6_12.ItemInstanceId
			local RemainingUses = var_6_12.RemainingUses

			if RemainingUses > 0 then
				_backend_mirror:update_item_field(ItemInstanceId_2, "RemainingUses", RemainingUses)
			else
				_backend_mirror:remove_item(ItemInstanceId_2)
			end
		end
	end

	if not modified_items then
		for k = 1, #modified_items do
			local var_6_15 = modified_items[k]
			local ItemInstanceId_3 = var_6_15.ItemInstanceId
			local UsesIncrementedBy_2 = var_6_15.UsesIncrementedBy

			UsesIncrementedBy_2 = UsesIncrementedBy_2 or 1

			_backend_mirror:update_item(ItemInstanceId_3, var_6_15)

			tbl[k] = {
				ItemInstanceId_3,
				[3] = UsesIncrementedBy_2
			}
		end
	end

	if not unlocked_weapon_skins then
		for l = 1, #unlocked_weapon_skins do
			local var_6_18 = unlocked_weapon_skins[l]

			_backend_mirror:add_unlocked_weapon_skin(var_6_18)
		end
	end

	backend:dirtify_interfaces()

	self._craft_requests[arg_6_1] = tbl
end

BackendInterfaceCraftingPlayfab.is_craft_complete = function (self, arg_7_1)
	-- function 7
	if not self._craft_requests[arg_7_1] then
		return true
	end

	return false
end

BackendInterfaceCraftingPlayfab.get_craft_result = function (self, arg_8_1)
	-- function 8
	return self._craft_requests[arg_8_1]
end

BackendInterfaceCraftingPlayfab.get_unlocked_weapon_skins = function (self)
	-- function 9
	return self._backend_mirror:get_unlocked_weapon_skins()
end

BackendInterfaceCraftingPlayfab.get_unlocked_cosmetics = function (self)
	-- function 10
	return self._backend_mirror:get_unlocked_cosmetics()
end
