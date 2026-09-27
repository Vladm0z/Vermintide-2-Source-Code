-- chunkname: @scripts/helpers/loadout_utils.lua

local LoadoutUtils = LoadoutUtils

LoadoutUtils = LoadoutUtils or {}
LoadoutUtils = LoadoutUtils

local LOADOUT_SLOTS = LOADOUT_SLOTS

LOADOUT_SLOTS = LOADOUT_SLOTS or {
	slot_necklace = true,
	slot_trinket_1 = true,
	slot_ring = true,
	slot_melee = true,
	slot_ranged = true
}

LoadoutUtils.sync_loadout_slot = function (self, arg_1_1, arg_1_2, arg_1_3)
	-- function 1
	if not LOADOUT_SLOTS[arg_1_1] then
		return
	end

	local network = Managers.state.network
	local is_server = network.is_server
	local network_transmit = network.network_transmit
	local key = arg_1_2.key
	local power_level = arg_1_2.power_level
	local rarity = arg_1_2.rarity

	rarity = rarity or "plentiful"

	local var_1_6 = NetworkLookup.equipment_slots[arg_1_1]
	local var_1_7 = NetworkLookup.item_names[key]
	local var_1_8 = NetworkLookup.rarities[rarity]
	local properties_to_rpc_params, var_1_10, var_1_11 = LoadoutUtils.properties_to_rpc_params(arg_1_2)

	if #properties_to_rpc_params ~= #var_1_10 then
		fassert(false, "[LoadoutUtils.sync_loadout_slot] Length of arrays properties_array(%d) and properties_values_array(%d) not equal!", #properties_to_rpc_params, #var_1_10)
	end

	local network_id = self:network_id()
	local local_player_id = self:local_player_id()

	if not arg_1_3 then
		network_transmit:send_rpc("rpc_sync_loadout_slot", arg_1_3, network_id, local_player_id, var_1_6, var_1_7, var_1_8, power_level, properties_to_rpc_params, var_1_10, var_1_11)
	elseif not is_server then
		network_transmit:send_rpc_all("rpc_sync_loadout_slot", network_id, local_player_id, var_1_6, var_1_7, var_1_8, power_level, properties_to_rpc_params, var_1_10, var_1_11)
	else
		network_transmit:send_rpc_server("rpc_sync_loadout_slot", network_id, local_player_id, var_1_6, var_1_7, var_1_8, power_level, properties_to_rpc_params, var_1_10, var_1_11)
	end
end

local tbl = {}

LoadoutUtils.hot_join_sync = function (arg_2_0)
	-- function 2
	if not Managers.state.network.is_server then
		return
	end

	local player_loadouts = Managers.player:player_loadouts()
	local players = Managers.player:players()

	for k, v in pairs(players) do
		if v:network_id() ~= arg_2_0 then
			local var_2_2 = player_loadouts[k]

			var_2_2 = var_2_2 or tbl

			for k_2, v_2 in pairs(var_2_2) do
				LoadoutUtils.sync_loadout_slot(v, k_2, v_2, arg_2_0)
			end
		else
			print("############### DONT SYNC YOURSELF")
		end
	end
end

LoadoutUtils.create_loadout_item_from_rpc_data = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5, arg_3_6)
	-- function 3
	local var_3_0 = NetworkLookup.equipment_slots[arg_3_0]
	local var_3_1 = NetworkLookup.item_names[arg_3_1]
	local var_3_2 = NetworkLookup.rarities[arg_3_2]
	local var_3_3 = arg_3_3
	local properties_from_rpc_params, var_3_5, var_3_6 = LoadoutUtils.properties_from_rpc_params(arg_3_4, arg_3_5, arg_3_6)
	local var_3_7 = ItemMasterList[var_3_1]
	local tbl = {
		data = var_3_7,
		power_level = var_3_3,
		rarity = var_3_2,
		key = var_3_1,
		ItemId = var_3_1,
		properties = not (properties_from_rpc_params > 0) or not var_3_5 or nil,
		traits = not (#var_3_6 > 0) or not var_3_6 or nil
	}

	return var_3_0, tbl
end

LoadoutUtils.properties_to_rpc_params = function (self)
	-- function 4
	local properties = NetworkLookup.properties
	local traits = NetworkLookup.traits
	local tbl = {}
	local tbl_2 = {}
	local tbl_3 = {}
	local properties_2 = self.properties

	if not properties_2 then
		for k, v in pairs(properties_2) do
			tbl[#tbl + 1] = properties[k]
			tbl_2[#tbl_2 + 1] = v
		end
	end

	local traits_2 = self.traits

	if not traits_2 then
		for k_2 = 1, #traits_2 do
			local var_4_7 = traits_2[k_2]

			tbl_3[#tbl_3 + 1] = traits[var_4_7]
		end
	end

	return tbl, tbl_2, tbl_3
end

LoadoutUtils.properties_from_rpc_params = function (arg_5_0, arg_5_1, arg_5_2)
	-- function 5
	local properties = NetworkLookup.properties
	local traits = NetworkLookup.traits
	local num = 0
	local tbl = {}
	local tbl_2 = {}

	for i = 1, #arg_5_0 do
		tbl[properties[arg_5_0[i]]], num = arg_5_1[i], num + 1
	end

	for j = 1, #arg_5_2 do
		local var_5_5 = arg_5_2[j]

		tbl_2[#tbl_2 + 1] = traits[var_5_5]
	end

	return num, tbl, tbl_2
end

LoadoutUtils.is_item_disabled = function (arg_6_0)
	-- function 6
	local mechanism = Managers.mechanism

	if not mechanism then
		return false
	end

	local mechanism_setting_for_title = mechanism:mechanism_setting_for_title("override_item_availability")

	if not mechanism_setting_for_title then
		return false
	end

	return mechanism_setting_for_title[arg_6_0] == false
end
