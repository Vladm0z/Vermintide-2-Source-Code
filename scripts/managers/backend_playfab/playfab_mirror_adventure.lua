-- chunkname: @scripts/managers/backend_playfab/playfab_mirror_adventure.lua

require("scripts/managers/backend_playfab/playfab_mirror_base")

local var_0_0 = require("PlayFab.PlayFabClientApi")

PlayFabMirrorAdventure = class(PlayFabMirrorAdventure, PlayFabMirrorBase)

PlayFabMirrorAdventure.init = function (arg_1_0, arg_1_1)
	local var_1_0 = Managers.mechanism:current_mechanism_name()

	arg_1_0:set_mechanism(var_1_0)
	PlayFabMirrorBase.init(arg_1_0, arg_1_1)
end

PlayFabMirrorAdventure.set_mechanism = function (arg_2_0, arg_2_1)
	printf("[PlayFabMirrorAdventure] Setting mechanism %s", arg_2_1)
	rawset(_G, "debug_characters_data_unsafe_write", arg_2_0._mechanism_key and arg_2_0._mechanism_key ~= arg_2_1 or nil)

	arg_2_0._mechanism_key = arg_2_1

	local var_2_0 = table.clone(InventorySettings.slots_per_affiliation)

	table.insert(var_2_0.heroes, "talents")

	if arg_2_1 == "versus" then
		arg_2_0._characters_data_key = "vs_characters_data"
	else
		arg_2_0._characters_data_key = "characters_data"
		var_2_0 = {
			heroes = var_2_0.heroes
		}
	end

	arg_2_0._verify_slot_keys_per_affiliation = var_2_0
end

PlayFabMirrorAdventure.request_characters = function (arg_3_0, arg_3_1)
	arg_3_1 = arg_3_1 or arg_3_0._mechanism_key

	if arg_3_1 == "versus" then
		local var_3_0 = false
		local var_3_1 = arg_3_0:get_read_only_data("vs_characters_data")

		if not var_3_1 or arg_3_0:get_read_only_data("vs_profile_data") == nil then
			var_3_0 = true
		elseif var_3_1 then
			local var_3_2 = cjson.decode(var_3_1)

			for iter_3_0, iter_3_1 in pairs(var_3_2) do
				if table.is_empty(iter_3_1.careers) then
					var_3_0 = true

					break
				end
			end

			if not var_3_0 then
				local var_3_3 = PROFILES_BY_AFFILIATION.dark_pact

				for iter_3_2 = 1, #var_3_3 do
					local var_3_4 = var_3_3[iter_3_2]

					if var_3_4 ~= "vs_undecided" and not var_3_2[var_3_4] then
						var_3_0 = true

						break
					end
				end
			end
		end

		if var_3_0 then
			arg_3_0._num_items_to_load = arg_3_0._num_items_to_load + 1

			local var_3_5 = {
				FunctionName = "versusPlayerSetup",
				FunctionParameter = {}
			}
			local var_3_6 = callback(arg_3_0, "versus_player_setup_cb")

			arg_3_0._request_queue:enqueue(var_3_5, var_3_6)
		else
			arg_3_0:_verify_career_loadouts()
		end
	else
		arg_3_0:_verify_career_loadouts()
	end
end

PlayFabMirrorAdventure._verify_career_loadouts = function (arg_4_0)
	arg_4_0._num_items_to_load = arg_4_0._num_items_to_load + 1

	local var_4_0 = {
		FunctionName = "verifyCareerLoadouts",
		FunctionParameter = {}
	}
	local var_4_1 = callback(arg_4_0, "verify_career_loadouts_cb")

	arg_4_0._request_queue:enqueue(var_4_0, var_4_1)
end

PlayFabMirrorAdventure.verify_career_loadouts_cb = function (arg_5_0, arg_5_1)
	local var_5_0 = arg_5_1.FunctionResult
	local var_5_1 = var_5_0.characters_data
	local var_5_2 = var_5_0.vs_characters_data

	if var_5_1 then
		arg_5_0:set_read_only_data("characters_data", var_5_1, true)
	end

	if var_5_2 then
		arg_5_0:set_read_only_data("vs_characters_data", var_5_2, true)
	end

	arg_5_0._num_items_to_load = arg_5_0._num_items_to_load - 1

	arg_5_0:_verify_dlc_careers()
end

PlayFabMirrorAdventure.versus_player_setup_cb = function (arg_6_0, arg_6_1)
	local var_6_0 = arg_6_1.FunctionResult
	local var_6_1 = var_6_0.vs_characters_data
	local var_6_2 = var_6_0.vs_profile_data
	local var_6_3 = var_6_0.num_items_granted

	arg_6_0:set_read_only_data("vs_characters_data", var_6_1, true)
	arg_6_0:set_read_only_data("vs_profile_data", var_6_2, true)

	arg_6_0._num_items_to_load = arg_6_0._num_items_to_load - 1

	local var_6_4 = var_6_0.unlocked_cosmetics

	if var_6_4 then
		arg_6_0:set_read_only_data("unlocked_cosmetics", var_6_4, true)

		arg_6_0._unlocked_cosmetics = arg_6_0:_parse_unlocked_cosmetics()
	end

	if var_6_3 > 0 then
		arg_6_0:_request_user_inventory()
	else
		arg_6_0:_verify_career_loadouts()
	end
end

PlayFabMirrorAdventure._set_inital_career_data_weaves = function (arg_7_0, arg_7_1, arg_7_2, arg_7_3)
	local var_7_0 = {}

	for iter_7_0 = 1, #arg_7_3 do
		local var_7_1 = arg_7_3[iter_7_0]
		local var_7_2 = arg_7_2[var_7_1]
		local var_7_3 = type(var_7_2) == "table" and var_7_2.Value or var_7_2

		if not var_7_3 then
			var_7_0[var_7_1] = true
		elseif not arg_7_0._inventory_items[var_7_3] then
			var_7_0[var_7_1] = true
		end
	end

	if table.size(var_7_0) > 0 then
		return var_7_0
	end
end

PlayFabMirrorAdventure._check_weaves_loadout = function (arg_8_0)
	local var_8_0 = arg_8_0:get_read_only_data(arg_8_0._characters_data_key)
	local var_8_1 = cjson.decode(var_8_0)
	local var_8_2 = {}

	for iter_8_0, iter_8_1 in pairs(var_8_1) do
		for iter_8_2, iter_8_3 in pairs(iter_8_1.careers) do
			local var_8_3 = "weaves_loadout_" .. iter_8_2
			local var_8_4 = arg_8_0:get_read_only_data(var_8_3)
			local var_8_5 = cjson.decode(var_8_4)
			local var_8_6 = arg_8_0:_set_inital_career_data_weaves(iter_8_2, var_8_5, {
				"slot_melee",
				"slot_ranged"
			})

			if var_8_6 then
				var_8_2[iter_8_2] = var_8_6

				print("Broken item slots for career", var_8_3)
				table.dump(var_8_6)
			end
		end
	end

	if not table.is_empty(var_8_2) then
		arg_8_0:_fix_career_data(var_8_2, "weaves", "fix_weaves_career_data_request_cb")
	else
		arg_8_0:unequip_disabled_items()
	end
end

PlayFabMirrorAdventure.fix_weaves_career_data_request_cb = function (arg_9_0, arg_9_1)
	arg_9_0.broken_slots_data = nil
	arg_9_0._num_items_to_load = arg_9_0._num_items_to_load - 1

	local var_9_0 = arg_9_1.FunctionResult

	if var_9_0.num_items_granted > 0 then
		arg_9_0:_request_user_inventory()

		return
	end

	local var_9_1 = var_9_0.character_starting_gear

	arg_9_0:merge_read_only_data(var_9_1, true)
	arg_9_0:unequip_disabled_items()
end
