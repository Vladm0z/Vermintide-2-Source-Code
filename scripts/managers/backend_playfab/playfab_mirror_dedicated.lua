-- chunkname: @scripts/managers/backend_playfab/playfab_mirror_dedicated.lua

require("scripts/managers/backend_playfab/playfab_mirror_adventure")

local var_0_0 = require("PlayFab.PlayFabClientApi")

PlayFabMirrorDedicated = class(PlayFabMirrorDedicated, PlayFabMirrorAdventure)

PlayFabMirrorDedicated.init = function (arg_1_0, arg_1_1)
	arg_1_0._data_is_ready = false

	PlayFabMirrorAdventure.init(arg_1_0, arg_1_1)

	arg_1_0._unlocked_weapon_skins = {}
	arg_1_0._unlocked_cosmetics = {}
	arg_1_0._owned_dlcs = {}

	for iter_1_0, iter_1_1 in pairs(Managers.unlock:get_dlcs()) do
		arg_1_0._owned_dlcs[#arg_1_0._owned_dlcs + 1] = iter_1_0

		if iter_1_1 and iter_1_1.set_owned then
			iter_1_1:set_owned(true)
		end
	end
end

PlayFabMirrorDedicated.is_update_items_done = function (arg_2_0)
	return arg_2_0._data_is_ready
end

PlayFabMirrorDedicated.set_character_data = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3)
	assert(false)
end

PlayFabMirrorDedicated._request_server_inventory = function (arg_4_0)
	local var_4_0 = {
		FunctionName = "getServerInventory",
		FunctionParameter = {}
	}
	local var_4_1 = callback(arg_4_0, "inventory_request_cb")

	arg_4_0._request_queue:enqueue(var_4_0, var_4_1)

	arg_4_0._num_items_to_load = arg_4_0._num_items_to_load + 1
end

PlayFabMirrorDedicated.inventory_request_cb = function (arg_5_0, arg_5_1)
	arg_5_0._data_is_ready = true
	arg_5_0._unlocked_weapon_skins = arg_5_0:_parse_unlocked_weapon_skins(arg_5_1.FunctionResult)
	arg_5_0._unlocked_cosmetics = arg_5_0:_parse_unlocked_cosmetics(arg_5_1.FunctionResult.unlocked_cosmetics)

	arg_5_0.super.inventory_request_cb(arg_5_0, arg_5_1.FunctionResult)
end

PlayFabMirrorDedicated.request_characters = function (arg_6_0)
	if arg_6_0._refresh_characters or arg_6_0:get_read_only_data("vs_characters_data") == nil then
		arg_6_0._refresh_characters = false
		arg_6_0._num_items_to_load = arg_6_0._num_items_to_load + 1

		local var_6_0 = {
			FunctionName = "getServerCharactersData",
			FunctionParameter = {}
		}
		local var_6_1 = callback(arg_6_0, "get_versus_characters_data")

		arg_6_0._request_queue:enqueue(var_6_0, var_6_1)
	else
		arg_6_0:_setup_careers()
	end
end

PlayFabMirrorDedicated.get_versus_characters_data = function (arg_7_0, arg_7_1)
	local var_7_0 = arg_7_1.FunctionResult.vs_characters_data

	arg_7_0._num_items_to_load = arg_7_0._num_items_to_load - 1

	arg_7_0:set_read_only_data("vs_characters_data", var_7_0, true)
	arg_7_0:_setup_careers()
end

PlayFabMirrorDedicated._fix_career_data = function (arg_8_0, arg_8_1)
	local var_8_0 = cjson.decode(arg_8_0._read_only_data.vs_characters_data)

	arg_8_0._characters_data = var_8_0
	arg_8_0._characters_data_mirror = table.clone(var_8_0)
end
