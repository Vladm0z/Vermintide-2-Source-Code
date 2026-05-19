-- chunkname: @scripts/helpers/loadout_utils.lua

LoadoutUtils = LoadoutUtils or {}

local var_0_0 = LOADOUT_SLOTS or {
	slot_necklace = true,
	slot_trinket_1 = true,
	slot_ring = true,
	slot_melee = true,
	slot_ranged = true
}

function LoadoutUtils.sync_loadout_slot(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
	if not var_0_0[arg_1_1] then
		return
	end

	local var_1_0 = Managers.state.network
	local var_1_1 = var_1_0.is_server
	local var_1_2 = var_1_0.network_transmit
	local var_1_3 = arg_1_2.key
	local var_1_4 = arg_1_2.power_level
	local var_1_5 = arg_1_2.rarity or "plentiful"
	local var_1_6 = NetworkLookup.equipment_slots[arg_1_1]
	local var_1_7 = NetworkLookup.item_names[var_1_3]
	local var_1_8 = NetworkLookup.rarities[var_1_5]
	local var_1_9, var_1_10, var_1_11 = LoadoutUtils.properties_to_rpc_params(arg_1_2)

	if #var_1_9 ~= #var_1_10 then
		fassert(false, "[LoadoutUtils.sync_loadout_slot] Length of arrays properties_array(%d) and properties_values_array(%d) not equal!", #var_1_9, #var_1_10)
	end

	local var_1_12 = arg_1_0:network_id()
	local var_1_13 = arg_1_0:local_player_id()

	if arg_1_3 then
		var_1_2:send_rpc("rpc_sync_loadout_slot", arg_1_3, var_1_12, var_1_13, var_1_6, var_1_7, var_1_8, var_1_4, var_1_9, var_1_10, var_1_11)
	elseif var_1_1 then
		var_1_2:send_rpc_all("rpc_sync_loadout_slot", var_1_12, var_1_13, var_1_6, var_1_7, var_1_8, var_1_4, var_1_9, var_1_10, var_1_11)
	else
		var_1_2:send_rpc_server("rpc_sync_loadout_slot", var_1_12, var_1_13, var_1_6, var_1_7, var_1_8, var_1_4, var_1_9, var_1_10, var_1_11)
	end
end

local var_0_1 = {}

function LoadoutUtils.hot_join_sync(arg_2_0)
	if not Managers.state.network.is_server then
		return
	end

	local var_2_0 = Managers.player:player_loadouts()
	local var_2_1 = Managers.player:players()

	for iter_2_0, iter_2_1 in pairs(var_2_1) do
		if iter_2_1:network_id() ~= arg_2_0 then
			local var_2_2 = var_2_0[iter_2_0] or var_0_1

			for iter_2_2, iter_2_3 in pairs(var_2_2) do
				LoadoutUtils.sync_loadout_slot(iter_2_1, iter_2_2, iter_2_3, arg_2_0)
			end
		else
			print("############### DONT SYNC YOURSELF")
		end
	end
end

function LoadoutUtils.create_loadout_item_from_rpc_data(arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5, arg_3_6)
	local var_3_0 = NetworkLookup.equipment_slots[arg_3_0]
	local var_3_1 = NetworkLookup.item_names[arg_3_1]
	local var_3_2 = NetworkLookup.rarities[arg_3_2]
	local var_3_3 = arg_3_3
	local var_3_4, var_3_5, var_3_6 = LoadoutUtils.properties_from_rpc_params(arg_3_4, arg_3_5, arg_3_6)
	local var_3_7 = ItemMasterList[var_3_1]
	local var_3_8 = {
		data = var_3_7,
		power_level = var_3_3,
		rarity = var_3_2,
		key = var_3_1,
		ItemId = var_3_1,
		properties = var_3_4 > 0 and var_3_5 or nil,
		traits = #var_3_6 > 0 and var_3_6 or nil
	}

	return var_3_0, var_3_8
end

function LoadoutUtils.properties_to_rpc_params(arg_4_0)
	local var_4_0 = NetworkLookup.properties
	local var_4_1 = NetworkLookup.traits
	local var_4_2 = {}
	local var_4_3 = {}
	local var_4_4 = {}
	local var_4_5 = arg_4_0.properties

	if var_4_5 then
		for iter_4_0, iter_4_1 in pairs(var_4_5) do
			var_4_2[#var_4_2 + 1] = var_4_0[iter_4_0]
			var_4_3[#var_4_3 + 1] = iter_4_1
		end
	end

	local var_4_6 = arg_4_0.traits

	if var_4_6 then
		for iter_4_2 = 1, #var_4_6 do
			local var_4_7 = var_4_6[iter_4_2]

			var_4_4[#var_4_4 + 1] = var_4_1[var_4_7]
		end
	end

	return var_4_2, var_4_3, var_4_4
end

function LoadoutUtils.properties_from_rpc_params(arg_5_0, arg_5_1, arg_5_2)
	local var_5_0 = NetworkLookup.properties
	local var_5_1 = NetworkLookup.traits
	local var_5_2 = 0
	local var_5_3 = {}
	local var_5_4 = {}

	for iter_5_0 = 1, #arg_5_0 do
		var_5_3[var_5_0[arg_5_0[iter_5_0]]], var_5_2 = arg_5_1[iter_5_0], var_5_2 + 1
	end

	for iter_5_1 = 1, #arg_5_2 do
		local var_5_5 = arg_5_2[iter_5_1]

		var_5_4[#var_5_4 + 1] = var_5_1[var_5_5]
	end

	return var_5_2, var_5_3, var_5_4
end

function LoadoutUtils.is_item_disabled(arg_6_0)
	local var_6_0 = Managers.mechanism

	if not var_6_0 then
		return false
	end

	local var_6_1 = var_6_0:mechanism_setting_for_title("override_item_availability")

	if not var_6_1 then
		return false
	end

	return var_6_1[arg_6_0] == false
end
