-- chunkname: @scripts/managers/backend_playfab/backend_interface_crafting_playfab.lua

require("scripts/managers/backend_playfab/backend_interface_crafting_base")

local var_0_0 = require("PlayFab.PlayFabClientApi")

BackendInterfaceCraftingPlayfab = class(BackendInterfaceCraftingPlayfab, BackendInterfaceCraftingBase)

function BackendInterfaceCraftingPlayfab.init(arg_1_0, arg_1_1)
	BackendInterfaceCraftingPlayfab.super.init(arg_1_0)

	arg_1_0.is_local = false
	arg_1_0._backend_mirror = arg_1_1
	arg_1_0._last_id = 0
	arg_1_0._craft_requests = {}
end

function BackendInterfaceCraftingPlayfab.ready(arg_2_0)
	return true
end

function BackendInterfaceCraftingPlayfab.update(arg_3_0, arg_3_1)
	return
end

function BackendInterfaceCraftingPlayfab._new_id(arg_4_0)
	arg_4_0._last_id = arg_4_0._last_id + 1

	return arg_4_0._last_id
end

function BackendInterfaceCraftingPlayfab.craft(arg_5_0, arg_5_1, arg_5_2, arg_5_3)
	local var_5_0, var_5_1 = arg_5_0:_get_valid_recipe(arg_5_2, arg_5_3)
	local var_5_2 = CareerSettings[arg_5_1].profile_name

	if var_5_0 and var_5_0.result_function_playfab then
		local var_5_3 = arg_5_0:_new_id()
		local var_5_4 = {
			FunctionName = var_5_0.result_function_playfab,
			FunctionParameter = {
				item_backend_ids_and_amounts = var_5_1,
				hero_name = var_5_2
			}
		}
		local var_5_5 = callback(arg_5_0, "craft_request_cb", var_5_3)

		arg_5_0._backend_mirror:request_queue():enqueue(var_5_4, var_5_5, true)

		return var_5_3, var_5_0
	end

	return nil
end

function BackendInterfaceCraftingPlayfab.craft_request_cb(arg_6_0, arg_6_1, arg_6_2)
	local var_6_0 = Managers.backend
	local var_6_1 = var_6_0:get_interface("items")
	local var_6_2 = arg_6_0._backend_mirror
	local var_6_3 = arg_6_2.FunctionResult
	local var_6_4 = var_6_3.items
	local var_6_5 = var_6_3.consumed_items
	local var_6_6 = var_6_3.modified_items
	local var_6_7 = var_6_3.unlocked_weapon_skins
	local var_6_8 = {}

	if var_6_4 then
		for iter_6_0 = 1, #var_6_4 do
			local var_6_9 = var_6_4[iter_6_0]
			local var_6_10 = var_6_9.ItemInstanceId
			local var_6_11 = var_6_9.UsesIncrementedBy or 1

			var_6_2:add_item(var_6_10, var_6_9)

			var_6_8[iter_6_0] = {
				var_6_10,
				[3] = var_6_11
			}
		end
	end

	if var_6_5 then
		for iter_6_1 = 1, #var_6_5 do
			local var_6_12 = var_6_5[iter_6_1]
			local var_6_13 = var_6_12.ItemInstanceId
			local var_6_14 = var_6_12.RemainingUses

			if var_6_14 > 0 then
				var_6_2:update_item_field(var_6_13, "RemainingUses", var_6_14)
			else
				var_6_2:remove_item(var_6_13)
			end
		end
	end

	if var_6_6 then
		for iter_6_2 = 1, #var_6_6 do
			local var_6_15 = var_6_6[iter_6_2]
			local var_6_16 = var_6_15.ItemInstanceId
			local var_6_17 = var_6_15.UsesIncrementedBy or 1

			var_6_2:update_item(var_6_16, var_6_15)

			var_6_8[iter_6_2] = {
				var_6_16,
				[3] = var_6_17
			}
		end
	end

	if var_6_7 then
		for iter_6_3 = 1, #var_6_7 do
			local var_6_18 = var_6_7[iter_6_3]

			var_6_2:add_unlocked_weapon_skin(var_6_18)
		end
	end

	var_6_0:dirtify_interfaces()

	arg_6_0._craft_requests[arg_6_1] = var_6_8
end

function BackendInterfaceCraftingPlayfab.is_craft_complete(arg_7_0, arg_7_1)
	if arg_7_0._craft_requests[arg_7_1] then
		return true
	end

	return false
end

function BackendInterfaceCraftingPlayfab.get_craft_result(arg_8_0, arg_8_1)
	return arg_8_0._craft_requests[arg_8_1]
end

function BackendInterfaceCraftingPlayfab.get_unlocked_weapon_skins(arg_9_0)
	return arg_9_0._backend_mirror:get_unlocked_weapon_skins()
end

function BackendInterfaceCraftingPlayfab.get_unlocked_cosmetics(arg_10_0)
	return arg_10_0._backend_mirror:get_unlocked_cosmetics()
end
