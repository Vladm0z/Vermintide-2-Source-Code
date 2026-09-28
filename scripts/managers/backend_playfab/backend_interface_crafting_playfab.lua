-- chunkname: @scripts/managers/backend_playfab/backend_interface_crafting_playfab.lua

require("scripts/managers/backend_playfab/backend_interface_crafting_base")

local PlayFabClientApi = require("PlayFab.PlayFabClientApi")

BackendInterfaceCraftingPlayfab = class(BackendInterfaceCraftingPlayfab, BackendInterfaceCraftingBase)

BackendInterfaceCraftingPlayfab.init = function (self, backend_mirror)
	-- function 1
	BackendInterfaceCraftingPlayfab.super.init(self)

	self.is_local = false
	self._backend_mirror = backend_mirror
	self._last_id = 0
	self._craft_requests = {}
end

BackendInterfaceCraftingPlayfab.ready = function (self)
	-- function 2
	return true
end

BackendInterfaceCraftingPlayfab.update = function (self, dt)
	-- function 3
	return
end

BackendInterfaceCraftingPlayfab._new_id = function (self)
	-- function 4
	self._last_id = self._last_id + 1

	return self._last_id
end

BackendInterfaceCraftingPlayfab.craft = function (self, career_name, item_backend_ids, recipe_override)
	-- function 5
	local recipe, item_backend_ids_and_amounts = self:_get_valid_recipe(item_backend_ids, recipe_override)
	local hero_name = CareerSettings[career_name].profile_name

	if recipe and recipe.result_function_playfab then
		local id = self:_new_id()
		local craft_request = {
			FunctionName = recipe.result_function_playfab,
			FunctionParameter = {
				item_backend_ids_and_amounts = item_backend_ids_and_amounts,
				hero_name = hero_name
			}
		}
		local success_callback = callback(self, "craft_request_cb", id)
		local request_queue = self._backend_mirror:request_queue()

		request_queue:enqueue(craft_request, success_callback, true)

		return id, recipe
	end

	return nil
end

BackendInterfaceCraftingPlayfab.craft_request_cb = function (self, id, result)
	-- function 6
	local backend_manager = Managers.backend
	local item_interface = backend_manager:get_interface("items")
	local backend_mirror = self._backend_mirror
	local function_result = result.FunctionResult
	local items = function_result.items
	local consumed_items = function_result.consumed_items
	local modified_items = function_result.modified_items
	local unlocked_weapon_skins = function_result.unlocked_weapon_skins
	local result = {}

	if items then
		for i = 1, #items do
			local item = items[i]
			local backend_id = item.ItemInstanceId
			local UsesIncrementedBy = item.UsesIncrementedBy

			if not UsesIncrementedBy then
				-- Nothing
			end

			UsesIncrementedBy = 1

			local amount = UsesIncrementedBy

			::label_6_0::

			backend_mirror:add_item(backend_id, item)

			result[i] = {
				backend_id,
				[3] = amount
			}
		end
	end

	if consumed_items then
		for i = 1, #consumed_items do
			local item = consumed_items[i]
			local backend_id = item.ItemInstanceId
			local remaining_uses = item.RemainingUses

			if remaining_uses > 0 then
				backend_mirror:update_item_field(backend_id, "RemainingUses", remaining_uses)
			else
				backend_mirror:remove_item(backend_id)
			end
		end
	end

	if modified_items then
		for i = 1, #modified_items do
			local item = modified_items[i]
			local backend_id = item.ItemInstanceId
			local UsesIncrementedBy_2 = item.UsesIncrementedBy

			if not UsesIncrementedBy_2 then
				-- Nothing
			end

			UsesIncrementedBy_2 = 1

			local amount = UsesIncrementedBy_2

			::label_6_1::

			backend_mirror:update_item(backend_id, item)

			result[i] = {
				backend_id,
				[3] = amount
			}
		end
	end

	if unlocked_weapon_skins then
		for i = 1, #unlocked_weapon_skins do
			local weapon_skin = unlocked_weapon_skins[i]

			backend_mirror:add_unlocked_weapon_skin(weapon_skin)
		end
	end

	backend_manager:dirtify_interfaces()

	self._craft_requests[id] = result
end

BackendInterfaceCraftingPlayfab.is_craft_complete = function (self, id)
	-- function 7
	local craft_request = self._craft_requests[id]

	if craft_request then
		return true
	end

	return false
end

BackendInterfaceCraftingPlayfab.get_craft_result = function (self, id)
	-- function 8
	return self._craft_requests[id]
end

BackendInterfaceCraftingPlayfab.get_unlocked_weapon_skins = function (self)
	-- function 9
	local mirror = self._backend_mirror

	return mirror:get_unlocked_weapon_skins()
end

BackendInterfaceCraftingPlayfab.get_unlocked_cosmetics = function (self)
	-- function 10
	local mirror = self._backend_mirror

	return mirror:get_unlocked_cosmetics()
end
