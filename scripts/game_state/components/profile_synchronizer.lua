-- chunkname: @scripts/game_state/components/profile_synchronizer.lua

require("scripts/settings/profiles/sp_profiles")

local var_0_0 = #PROFILES_BY_AFFILIATION.heroes
local var_0_1 = "ProfileSynchronizer"
local var_0_2 = table.set({
	"dark_pact"
})
local var_0_3 = printf

local function var_0_4(...)
	if script_data.profile_synchronizer_debug_logging then
		local var_1_0 = sprintf(...)

		var_0_3("[ProfileSynchronizer] %s", var_1_0)
	end
end

local function var_0_5(...)
	local var_2_0 = sprintf(...)

	var_0_3("[ProfileSynchronizer] %s", var_2_0)
end

local function var_0_6(arg_3_0, arg_3_1)
	return string.format("%s:%d", arg_3_0, arg_3_1)
end

local function var_0_7(arg_4_0)
	local var_4_0 = string.find(arg_4_0, ":")
	local var_4_1 = arg_4_0:sub(1, var_4_0 - 1)
	local var_4_2 = tonumber(arg_4_0:sub(var_4_0 + 1))

	return var_4_1, var_4_2
end

local function var_0_8(arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4, arg_5_5)
	local var_5_0 = BackendUtils.get_item_template(arg_5_2, arg_5_3)
	local var_5_1 = BackendUtils.get_item_units(arg_5_2, arg_5_3, nil, arg_5_4)
	local var_5_2 = arg_5_1.category

	if var_5_2 == "weapon" or var_5_2 == "career_skill_weapon" then
		local var_5_3 = WeaponUtils.get_weapon_packages(var_5_0, var_5_1, arg_5_5, arg_5_4)

		for iter_5_0 = 1, #var_5_3 do
			arg_5_0[var_5_3[iter_5_0]] = false
		end
	elseif var_5_2 == "attachment" then
		if var_5_1.unit then
			arg_5_0[var_5_1.unit] = false
		end

		local var_5_4 = var_5_0.character_material_changes

		if var_5_4 then
			arg_5_0[var_5_4.package_name] = false
		end
	elseif var_5_2 == "cosmetic" then
		-- Nothing
	else
		error("ProfileSynchronizer unknown slot_category: " .. var_5_2)
	end
end

local var_0_9 = {}
local var_0_10 = {}

local function var_0_11(arg_6_0, arg_6_1, arg_6_2, arg_6_3)
	local var_6_0 = SPProfiles[arg_6_0]
	local var_6_1 = var_6_0.careers[arg_6_1]
	local var_6_2 = var_6_1.name
	local var_6_3 = #InventorySettings.slots
	local var_6_4 = {}

	for iter_6_0 = 1, var_6_3 do
		local var_6_5 = InventorySettings.slots[iter_6_0]
		local var_6_6 = var_6_5.name
		local var_6_7 = BackendUtils.get_loadout_item(var_6_2, var_6_6, arg_6_3)

		if var_6_7 then
			local var_6_8 = var_6_7.data
			local var_6_9 = var_6_7.backend_id

			var_0_8(var_6_4, var_6_5, var_6_8, var_6_9, var_6_2, arg_6_2)
		end
	end

	local var_6_10 = var_6_1.base_skin
	local var_6_11 = BackendUtils.get_loadout_item(var_6_2, "slot_skin", arg_6_3)
	local var_6_12 = var_6_11 and var_6_11.data.name or var_6_10
	local var_6_13 = CosmeticsUtils.retrieve_skin_packages(var_6_12, arg_6_2)

	for iter_6_1 = 1, #var_6_13 do
		var_6_4[var_6_13[iter_6_1]] = false
	end

	if var_6_1.package_name then
		var_6_4[var_6_1.package_name] = false
	end

	local var_6_14 = Managers.state.game_mode
	local var_6_15 = var_6_14 and var_6_14:has_activated_mutator("whiterun")
	local var_6_16

	if var_6_15 then
		table.clear(var_0_10)

		var_6_16 = var_0_10
	else
		var_6_16 = Managers.backend:get_talents_interface():get_talent_ids(var_6_2, nil, arg_6_3)
	end

	local var_6_17 = var_6_1.requires_packages

	if var_6_17 then
		table.merge(var_0_9, var_6_17)
	end

	for iter_6_2 = 1, #var_6_16 do
		local var_6_18 = TalentUtils.get_talent_by_id(var_6_0.display_name, var_6_16[iter_6_2])

		if var_6_18 and var_6_18.requires_packages then
			table.merge(var_0_9, var_6_18.requires_packages)
		end
	end

	for iter_6_3, iter_6_4 in pairs(var_0_9) do
		for iter_6_5, iter_6_6 in pairs(iter_6_4) do
			var_6_4[iter_6_6] = false
		end
	end

	table.clear(var_0_9)

	if var_6_1.talent_packages then
		var_6_1.talent_packages(var_6_16, var_6_4, arg_6_2, arg_6_3)
	end

	if var_6_1.additional_inventory then
		for iter_6_7, iter_6_8 in pairs(var_6_1.additional_inventory) do
			for iter_6_9 = 1, #iter_6_8 do
				local var_6_19 = ItemMasterList[iter_6_8[iter_6_9]]
				local var_6_20 = InventorySettings.slots_by_name[iter_6_7]

				var_0_8(var_6_4, var_6_20, var_6_19, nil, var_6_2, arg_6_2)
			end
		end
	end

	return var_6_4
end

local function var_0_12(arg_7_0, arg_7_1, arg_7_2)
	if not arg_7_0 or arg_7_0 == 0 then
		return {}, {}
	end

	local var_7_0 = SPProfiles[arg_7_0]

	if var_0_2[var_7_0.affiliation] then
		return {}, {}
	end

	local var_7_1 = var_0_11(arg_7_0, arg_7_1, false, arg_7_2)
	local var_7_2 = var_0_11(arg_7_0, arg_7_1, true, arg_7_2)

	return var_7_1, var_7_2
end

local var_0_13 = {}

local function var_0_14(arg_8_0, arg_8_1)
	local var_8_0
	local var_8_1
	local var_8_2, var_8_3 = table.keys(arg_8_0, var_0_13)
	local var_8_4, var_8_5 = table.keys(arg_8_1, var_0_13, var_8_3)

	return Application.make_hash(unpack(var_0_13, 1, var_8_5))
end

local function var_0_15(arg_9_0, arg_9_1, arg_9_2, arg_9_3, arg_9_4, arg_9_5, arg_9_6, arg_9_7)
	local var_9_0, var_9_1 = var_0_12(arg_9_3, arg_9_4, arg_9_5)
	local var_9_2 = arg_9_0:get_inventory_data(arg_9_1, arg_9_2)
	local var_9_3 = math.wrap_index_between(var_9_2.inventory_id + 1, 1, 2147483647)
	local var_9_4 = arg_9_7 or var_0_14(var_9_0, var_9_1)

	if not arg_9_6 and var_9_2.inventory_id ~= 0 and var_9_4 == var_9_2.inventory_hash then
		return
	end

	arg_9_0:set_inventory_data(arg_9_1, arg_9_2, {
		inventory_id = var_9_3,
		inventory_hash = var_9_4,
		first_person = var_9_1,
		third_person = var_9_0
	})

	return var_9_3
end

local function var_0_16(arg_10_0, arg_10_1, arg_10_2, arg_10_3, arg_10_4)
	assert(arg_10_1 ~= Network.peer_id(), "This function is meant to be called remotely, together with a request for the peer to update their inventory data.")

	local var_10_0 = table.shallow_copy(arg_10_0:get_inventory_data(arg_10_1, arg_10_2), true)

	var_10_0.inventory_id = 0

	arg_10_0:set_inventory_data(arg_10_1, arg_10_2, var_10_0)
	arg_10_0:set_own_loaded_inventory_id(arg_10_1, arg_10_2, 0)
end

local function var_0_17(arg_11_0, arg_11_1, arg_11_2, arg_11_3)
	local var_11_0 = arg_11_0:get_inventory_data(arg_11_1, arg_11_2).inventory_id

	if var_11_0 == 0 then
		return false
	end

	local var_11_1 = arg_11_0:get_peers_with_full_profiles()

	for iter_11_0, iter_11_1 in ipairs(var_11_1) do
		local var_11_2 = iter_11_1.peer_id

		if (not arg_11_3 or arg_11_0:is_peer_hot_join_synced(var_11_2)) and var_11_0 ~= arg_11_0:get_loaded_inventory_id(var_11_2, arg_11_1, arg_11_2) then
			return false
		end
	end

	if DEDICATED_SERVER then
		local var_11_3 = arg_11_0._server_peer_id

		if not var_11_1[var_11_3] and var_11_0 ~= arg_11_0:get_loaded_inventory_id(var_11_3, arg_11_1, arg_11_2) then
			return false
		end
	end

	return true
end

local function var_0_18(arg_12_0, arg_12_1)
	local var_12_0 = arg_12_0:get_peers_with_full_profiles()

	for iter_12_0, iter_12_1 in ipairs(var_12_0) do
		local var_12_1 = iter_12_1.peer_id
		local var_12_2 = iter_12_1.local_player_id

		if not var_0_17(arg_12_0, var_12_1, var_12_2, arg_12_1) then
			return false
		end
	end

	return true
end

local var_0_19 = {}
local var_0_20 = {}
local var_0_21 = {}
local var_0_22 = {}

local function var_0_23(arg_13_0)
	local var_13_0 = Managers.package
	local var_13_1 = arg_13_0:get_own_peer_id()
	local var_13_2 = arg_13_0:get_loaded_or_loading_packages()
	local var_13_3 = arg_13_0:loaded_or_loading_package_peers()

	table.clear(var_0_19)
	table.clear(var_0_20)
	table.clear(var_0_21)
	table.clear(var_0_22)

	local var_13_4 = arg_13_0:get_peers_with_full_profiles()

	for iter_13_0, iter_13_1 in ipairs(var_13_4) do
		local var_13_5 = iter_13_1.peer_id
		local var_13_6 = iter_13_1.local_player_id
		local var_13_7 = arg_13_0:get_inventory_data(var_13_5, var_13_6)
		local var_13_8 = PlayerUtils.unique_player_id(var_13_5, var_13_6)

		var_13_3[var_13_8] = true
		var_0_22[var_13_8] = true

		if var_13_7 then
			local var_13_9 = var_13_5 == var_13_1 and var_13_7.first_person or var_13_7.third_person

			for iter_13_2, iter_13_3 in pairs(var_13_9) do
				var_0_20[iter_13_2] = true
			end

			if arg_13_0:get_loaded_inventory_id(var_13_1, var_13_5, var_13_6) ~= var_13_7.inventory_id then
				local var_13_10 = true

				for iter_13_4, iter_13_5 in pairs(var_13_9) do
					if not var_13_0:has_loaded(iter_13_4, var_0_1) then
						var_0_19[iter_13_4] = true
						var_13_10 = false
					end
				end

				if var_13_10 then
					arg_13_0:set_own_loaded_inventory_id(var_13_5, var_13_6, var_13_7.inventory_id)
				end
			end
		end
	end

	for iter_13_6, iter_13_7 in pairs(var_0_19) do
		if not var_13_0:is_loading(iter_13_6) then
			local var_13_11 = true

			var_13_2[iter_13_6] = true

			var_13_0:load(iter_13_6, var_0_1, nil, var_13_11)
		end
	end

	for iter_13_8, iter_13_9 in pairs(var_13_2) do
		var_0_21[iter_13_8] = true
	end

	for iter_13_10, iter_13_11 in pairs(var_0_20) do
		var_0_21[iter_13_10] = nil
	end

	for iter_13_12, iter_13_13 in pairs(var_0_21) do
		if var_13_0:can_unload(iter_13_12) then
			var_13_0:unload(iter_13_12, var_0_1)

			var_13_2[iter_13_12] = nil
		end
	end

	for iter_13_14 in pairs(var_13_3) do
		if not var_0_22[iter_13_14] then
			var_13_3[iter_13_14] = nil

			local var_13_12, var_13_13 = PlayerUtils.split_unique_player_id(iter_13_14)

			if arg_13_0:get_loaded_inventory_id(var_13_1, var_13_12, var_13_13) ~= 0 then
				arg_13_0:set_own_loaded_inventory_id(var_13_12, var_13_13, 0)
			end
		end
	end

	arg_13_0:set_loaded_or_loading_package_peers(var_13_3)
	arg_13_0:set_loaded_or_loading_packages(var_13_2)
end

local function var_0_24(arg_14_0)
	local var_14_0 = arg_14_0:get_loaded_or_loading_packages()
	local var_14_1 = Managers.package

	for iter_14_0, iter_14_1 in pairs(var_14_0) do
		var_14_1:unload(iter_14_0, var_0_1)
	end
end

ProfileSynchronizer = class(ProfileSynchronizer)

ProfileSynchronizer.init = function (arg_15_0, arg_15_1, arg_15_2, arg_15_3)
	arg_15_0._state = arg_15_3
	arg_15_0._lobby = arg_15_2
	arg_15_0._cached_all_synced_for_peer = {
		ingame = {},
		any = {}
	}
end

local var_0_25 = {
	"rpc_assign_peer_to_profile"
}

ProfileSynchronizer.register_rpcs = function (arg_16_0, arg_16_1, arg_16_2)
	arg_16_0._network_event_delegate = arg_16_1

	arg_16_0._network_event_delegate:register(arg_16_0, unpack(var_0_25))
end

ProfileSynchronizer.unregister_network_events = function (arg_17_0)
	arg_17_0._network_event_delegate:unregister(arg_17_0)
end

ProfileSynchronizer.destroy = function (arg_18_0)
	var_0_24(arg_18_0._state)
end

ProfileSynchronizer.update = function (arg_19_0)
	var_0_23(arg_19_0._state)
end

ProfileSynchronizer.hot_join_sync = function (arg_20_0, arg_20_1)
	fassert(arg_20_0._state:is_server(), "only for the server")
	var_0_5("Peer %s entered session", arg_20_1)
	var_0_5("Running hot_join_sync for peer %s", arg_20_1)

	local var_20_0 = PEER_ID_TO_CHANNEL[arg_20_1]
	local var_20_1 = arg_20_0._state:get_peers_with_full_profiles()

	for iter_20_0, iter_20_1 in ipairs(var_20_1) do
		local var_20_2 = iter_20_1.peer_id
		local var_20_3 = iter_20_1.local_player_id
		local var_20_4 = iter_20_1.profile_index
		local var_20_5 = iter_20_1.career_index
		local var_20_6 = iter_20_1.is_bot

		RPC.rpc_assign_peer_to_profile(var_20_0, var_20_2, var_20_3, var_20_4, var_20_5, var_20_6)
	end
end

ProfileSynchronizer.clear_peer_data = function (arg_21_0, arg_21_1)
	fassert(arg_21_0._state:is_server(), "only for the server")
	var_0_5("Peer %s left session", arg_21_1)
	arg_21_0:_unassign_profiles_of_peer(arg_21_1)
	arg_21_0:_clear_profile_index_reservation(arg_21_1)
	arg_21_0:_request_lobby_data_sync()
end

ProfileSynchronizer.get_profile_index_reservation = function (arg_22_0, arg_22_1, arg_22_2)
	local var_22_0 = arg_22_0._state:get_profile_index_reservation(arg_22_1, arg_22_2)
	local var_22_1
	local var_22_2

	if var_22_0 then
		local var_22_3

		var_22_3, var_22_2 = arg_22_0:get_persistent_profile_index_reservation(var_22_0)
	end

	return var_22_0, var_22_2
end

ProfileSynchronizer.get_persistent_profile_index_reservation = function (arg_23_0, arg_23_1)
	local var_23_0, var_23_1 = arg_23_0._state:get_persistent_profile_index_reservation(arg_23_1)

	return var_23_0, var_23_1
end

ProfileSynchronizer.try_reserve_profile_for_peer = function (arg_24_0, arg_24_1, arg_24_2, arg_24_3, arg_24_4)
	fassert(arg_24_0._state:is_server(), "Should only be called on server.")

	local var_24_0, var_24_1 = arg_24_0._state:get_profile_index_reservation(arg_24_1, arg_24_3)

	if var_24_0 == nil or var_24_0 == arg_24_2 and arg_24_4 ~= var_24_1 then
		var_0_5("Reserving profile index %d career index %s to peer %s in party %s", arg_24_3, arg_24_4, arg_24_2, arg_24_1)
		arg_24_0:_clear_profile_index_reservation(arg_24_2)
		arg_24_0._state:set_profile_index_reservation(arg_24_1, arg_24_3, arg_24_4, arg_24_2)

		if var_24_0 == nil then
			arg_24_0:_request_lobby_data_sync()
		end

		return true
	end

	if var_24_0 == arg_24_2 then
		return true
	end

	return false
end

ProfileSynchronizer.clear_profile_index_reservation = function (arg_25_0, arg_25_1, arg_25_2)
	arg_25_0:_clear_profile_index_reservation(arg_25_1, arg_25_2)
	arg_25_0:_request_lobby_data_sync()
end

ProfileSynchronizer.profile_by_peer = function (arg_26_0, arg_26_1, arg_26_2)
	local var_26_0 = arg_26_0._state:get_peers_with_full_profiles()

	for iter_26_0, iter_26_1 in ipairs(var_26_0) do
		local var_26_1 = iter_26_1.peer_id
		local var_26_2 = iter_26_1.local_player_id

		if var_26_1 == arg_26_1 and var_26_2 == arg_26_2 then
			local var_26_3 = iter_26_1.profile_index
			local var_26_4 = iter_26_1.career_index

			return var_26_3, var_26_4
		end
	end

	return nil, nil
end

ProfileSynchronizer.get_peers_with_full_profiles = function (arg_27_0)
	return arg_27_0._state:get_peers_with_full_profiles()
end

ProfileSynchronizer.assign_full_profile = function (arg_28_0, arg_28_1, arg_28_2, arg_28_3, arg_28_4, arg_28_5)
	local var_28_0 = arg_28_0._state

	fassert(var_28_0:is_server(), "Should only be called on server.")
	var_0_5("Assigning peer(%s:%s) to profile(%s) career(%s) is_bot(%s)", arg_28_1, arg_28_2, arg_28_3, arg_28_4, arg_28_5)

	local var_28_1, var_28_2, var_28_3 = var_28_0:get_profile(arg_28_1, arg_28_2)

	if var_28_1 == arg_28_3 and var_28_2 == arg_28_4 and var_28_3 == arg_28_5 then
		print("Was already assigned...")

		return
	end

	arg_28_0:_unassign_profiles_of_peer(arg_28_1, arg_28_2)
	arg_28_0._state:set_profile(arg_28_1, arg_28_2, arg_28_3, arg_28_4, arg_28_5)

	if arg_28_5 then
		local var_28_4 = Managers.party:get_player_status(arg_28_1, arg_28_2)
		local var_28_5 = var_28_4.party_id
		local var_28_6 = var_28_4.slot_id

		arg_28_0._state:set_bot_profile(var_28_5, var_28_6, arg_28_3, arg_28_4)
	end

	arg_28_0:_assign_peer_to_profile(arg_28_1, arg_28_2, arg_28_3, arg_28_4, arg_28_5)

	local var_28_7 = var_28_0:get_own_peer_id()
	local var_28_8 = var_28_0:get_peers()

	for iter_28_0, iter_28_1 in ipairs(var_28_8) do
		if iter_28_1 ~= var_28_7 then
			local var_28_9 = PEER_ID_TO_CHANNEL[iter_28_1]

			RPC.rpc_assign_peer_to_profile(var_28_9, arg_28_1, arg_28_2, arg_28_3, arg_28_4, arg_28_5)
		end
	end
end

ProfileSynchronizer.unassign_profiles_of_peer = function (arg_29_0, arg_29_1, arg_29_2)
	arg_29_0:_unassign_profiles_of_peer(arg_29_1, arg_29_2)
end

ProfileSynchronizer.get_first_free_profile = function (arg_30_0, arg_30_1)
	local var_30_0 = 1

	for iter_30_0 = 1, var_0_0 do
		if not arg_30_0._state:get_profile_index_reservation(arg_30_1, iter_30_0) then
			if not (Managers.mechanism:current_mechanism_name() == "versus") then
				return iter_30_0, var_30_0
			end

			var_30_0 = PlayerUtils.get_enabled_career_index_by_profile(iter_30_0)

			if var_30_0 then
				return iter_30_0, var_30_0
			end
		end
	end

	fassert(false, "Trying to get free profile when there are no free profiles.")
end

ProfileSynchronizer.is_profile_in_use = function (arg_31_0, arg_31_1)
	local var_31_0 = arg_31_0._state:get_peers_with_full_profiles()

	for iter_31_0, iter_31_1 in ipairs(var_31_0) do
		if iter_31_1.profile_index == arg_31_1 then
			return true
		end
	end

	return false
end

ProfileSynchronizer.all_synced = function (arg_32_0)
	local var_32_0 = arg_32_0._state:get_revision()

	if arg_32_0._cached_all_synced_revision ~= var_32_0 then
		local var_32_1 = false

		arg_32_0._cached_all_synced = var_0_18(arg_32_0._state, var_32_1)
		arg_32_0._cached_all_synced_revision = var_32_0
	end

	return arg_32_0._cached_all_synced
end

ProfileSynchronizer.all_ingame_synced = function (arg_33_0)
	local var_33_0 = arg_33_0._state:get_revision()

	if arg_33_0._cached_all_ingame_synced_revision ~= var_33_0 then
		local var_33_1 = true

		arg_33_0._cached_all_ingame_synced = var_0_18(arg_33_0._state, var_33_1)
		arg_33_0._cached_all_ingame_synced_revision = var_33_0
	end

	return arg_33_0._cached_all_ingame_synced
end

ProfileSynchronizer.all_synced_for_peer = function (arg_34_0, arg_34_1, arg_34_2)
	local var_34_0 = false

	return arg_34_0:_all_synced_for_peer(arg_34_1, arg_34_2, var_34_0)
end

ProfileSynchronizer.all_ingame_synced_for_peer = function (arg_35_0, arg_35_1, arg_35_2)
	local var_35_0 = true

	return arg_35_0:_all_synced_for_peer(arg_35_1, arg_35_2, var_35_0)
end

ProfileSynchronizer._all_synced_for_peer = function (arg_36_0, arg_36_1, arg_36_2, arg_36_3)
	local var_36_0 = arg_36_0._state:get_revision()
	local var_36_1 = arg_36_3 and "ingame" or "any"
	local var_36_2 = arg_36_0._cached_all_synced_for_peer[var_36_1][arg_36_1]
	local var_36_3 = var_36_2 and var_36_2[arg_36_2]
	local var_36_4 = 1
	local var_36_5 = 2

	if not var_36_3 or var_36_3[var_36_4] ~= var_36_0 then
		local var_36_6 = var_0_17(arg_36_0._state, arg_36_1, arg_36_2, arg_36_3)

		var_36_3 = {
			var_36_0,
			var_36_6
		}
		var_36_2 = var_36_2 or {}
		var_36_2[arg_36_2] = var_36_3
		arg_36_0._cached_all_synced_for_peer[var_36_1][arg_36_1] = var_36_2
	end

	return var_36_3[var_36_5]
end

ProfileSynchronizer.is_peer_all_synced = function (arg_37_0, arg_37_1)
	local var_37_0 = arg_37_0._state:get_peers_with_full_profiles()

	for iter_37_0, iter_37_1 in ipairs(var_37_0) do
		local var_37_1 = iter_37_1.peer_id
		local var_37_2 = iter_37_1.local_player_id
		local var_37_3 = arg_37_0._state:get_inventory_data(var_37_1, var_37_2)
		local var_37_4 = arg_37_0._state:get_loaded_inventory_id(arg_37_1, var_37_1, var_37_2)

		if var_37_3.inventory_id ~= var_37_4 then
			return false
		end
	end

	return true
end

ProfileSynchronizer.resync_loadout = function (arg_38_0, arg_38_1, arg_38_2, arg_38_3, arg_38_4, arg_38_5)
	var_0_5("Resyncing loadout of peer(%s:%s)", arg_38_1, arg_38_2)

	local var_38_0, var_38_1 = arg_38_0:profile_by_peer(arg_38_1, arg_38_2)

	var_0_15(arg_38_0._state, arg_38_1, arg_38_2, var_38_0, var_38_1, arg_38_3, arg_38_4, arg_38_5)
end

ProfileSynchronizer.rpc_assign_peer_to_profile = function (arg_39_0, arg_39_1, arg_39_2, arg_39_3, arg_39_4, arg_39_5, arg_39_6)
	var_0_5("rpc_assign_peer_to_profile peer_id:%s local_player_id:%d profile_index:%d career_index:%d is_bot:%s", arg_39_2, arg_39_3, arg_39_4, arg_39_5, arg_39_6 and "true" or "false")

	if not Managers.party:get_player_status(arg_39_2, arg_39_3) then
		var_0_5("rpc_assign_peer_to_profile called without status available in party manager. Ignoring it")

		return
	end

	arg_39_0:_assign_peer_to_profile(arg_39_2, arg_39_3, arg_39_4, arg_39_5, arg_39_6)
end

ProfileSynchronizer._clear_profile_index_reservation = function (arg_40_0, arg_40_1, arg_40_2)
	local var_40_0 = Managers.party:get_num_parties()

	for iter_40_0 = 1, var_0_0 do
		for iter_40_1 = 1, var_40_0 do
			if arg_40_0._state:get_profile_index_reservation(iter_40_1, iter_40_0) == arg_40_1 then
				arg_40_0._state:set_profile_index_reservation(iter_40_1, iter_40_0, nil, "")
			end
		end
	end

	if arg_40_2 then
		arg_40_0._state:clear_persistent_profile_index_reservation(arg_40_1)
	end
end

ProfileSynchronizer._unassign_profiles_of_peer = function (arg_41_0, arg_41_1, arg_41_2)
	local var_41_0 = arg_41_0._state:get_peers_with_full_profiles()

	for iter_41_0, iter_41_1 in ipairs(var_41_0) do
		local var_41_1 = iter_41_1.peer_id
		local var_41_2 = iter_41_1.local_player_id

		if var_41_1 == arg_41_1 and (not arg_41_2 or arg_41_2 == var_41_2) then
			arg_41_0._state:delete_profile_data(arg_41_1, arg_41_2 or 1)
		end
	end
end

ProfileSynchronizer._assign_peer_to_profile = function (arg_42_0, arg_42_1, arg_42_2, arg_42_3, arg_42_4, arg_42_5, arg_42_6)
	local var_42_0 = Managers.party:get_player_status(arg_42_1, arg_42_2)

	var_42_0.profile_index = arg_42_3
	var_42_0.career_index = arg_42_4
	var_42_0.selected_profile_index = arg_42_3
	var_42_0.selected_career_index = arg_42_4
	var_42_0.profile_id = SPProfiles[arg_42_3].display_name

	Managers.mechanism:profile_changed(arg_42_1, arg_42_2, arg_42_3, arg_42_4, arg_42_5)

	if Managers.state.game_mode then
		Managers.state.game_mode:profile_changed(arg_42_1, arg_42_2, arg_42_3, arg_42_4, arg_42_5)
	end

	if Managers.venture.challenge then
		Managers.venture.challenge:profile_changed(arg_42_1, arg_42_2, arg_42_3, arg_42_4, arg_42_5)
	end

	if arg_42_1 == arg_42_0._state:get_own_peer_id() then
		local var_42_1 = arg_42_3 ~= FindProfileIndex("spectator")

		var_42_1 = var_42_1 and arg_42_3 ~= FindProfileIndex("vs_undecided")

		if var_42_1 then
			local var_42_2 = SPProfiles[arg_42_3]
			local var_42_3 = Managers.backend:get_interface("hero_attributes")
			local var_42_4 = var_42_2.display_name

			var_42_3:set(var_42_4, "career", arg_42_4)
		end

		var_0_15(arg_42_0._state, arg_42_1, arg_42_2, arg_42_3, arg_42_4, arg_42_5, true)
	elseif arg_42_1 ~= arg_42_0._state:get_server_peer_id() and arg_42_0._state:is_peer_hot_join_synced(Network.peer_id()) then
		var_0_16(arg_42_0._state, arg_42_1, arg_42_2, arg_42_3, arg_42_4)
	end

	Managers.state.event:trigger("player_profile_assigned", arg_42_1, arg_42_2, arg_42_3, arg_42_4)
end

local var_0_26 = "0"
local var_0_27 = "0:0"

ProfileSynchronizer.set_own_actually_ingame = function (arg_43_0, arg_43_1)
	arg_43_0._state:set_own_actually_ingame(arg_43_1)
end

ProfileSynchronizer.get_own_actually_ingame = function (arg_44_0)
	return arg_44_0._state:get_actually_ingame(arg_44_0._state:get_own_peer_id())
end

ProfileSynchronizer.others_actually_ingame = function (arg_45_0)
	local var_45_0 = arg_45_0._state
	local var_45_1 = var_45_0:get_own_peer_id()
	local var_45_2 = arg_45_0:get_peers_with_full_profiles()

	for iter_45_0, iter_45_1 in ipairs(var_45_2) do
		local var_45_3 = iter_45_1.peer_id

		if var_45_1 ~= var_45_3 and not var_45_0:get_actually_ingame(var_45_3) then
			return false
		end
	end

	return true
end

ProfileSynchronizer._request_lobby_data_sync = function (arg_46_0)
	arg_46_0._lobby_data_sync_requested = true
end

ProfileSynchronizer.poll_sync_lobby_data_required = function (arg_47_0)
	if arg_47_0._lobby_data_sync_requested then
		arg_47_0._lobby_data_sync_requested = false

		return true
	end

	return false
end

ProfileSynchronizer.hash_inventory = function (arg_48_0, arg_48_1, arg_48_2, arg_48_3)
	local var_48_0, var_48_1 = var_0_12(arg_48_1, arg_48_2, arg_48_3)

	return var_0_14(var_48_0, var_48_1)
end

ProfileSynchronizer.cached_inventory_hash = function (arg_49_0, arg_49_1, arg_49_2)
	return arg_49_0._state:get_inventory_data(arg_49_1, arg_49_2).inventory_hash
end

ProfileSynchronizer.own_loaded_inventory_id = function (arg_50_0)
	local var_50_0 = arg_50_0._state:get_own_peer_id()

	return arg_50_0._state:get_loaded_inventory_id(var_50_0, var_50_0, 1)
end

ProfileSynchronizer.net_pack_lobby_profile_slots = function (arg_51_0)
	local var_51_0 = {}
	local var_51_1 = {}
	local var_51_2 = LobbyAux.deserialize_lobby_reservation_data(arg_51_0)

	for iter_51_0, iter_51_1 in ipairs(var_51_2) do
		local var_51_3 = {}
		local var_51_4 = {}

		var_51_0[iter_51_0] = var_51_3
		var_51_1[iter_51_0] = var_51_4

		for iter_51_2 = 1, #iter_51_1 do
			local var_51_5 = iter_51_1[iter_51_2]
			local var_51_6 = var_51_5.peer_id

			var_51_4[iter_51_2], var_51_3[iter_51_2] = var_51_5.profile_index, var_51_6
		end
	end

	return var_51_0, var_51_1
end

ProfileSynchronizer.owner_in_lobby = function (arg_52_0, arg_52_1, arg_52_2)
	local var_52_0 = LobbyAux.deserialize_lobby_reservation_data(arg_52_1)[arg_52_2 or 1]

	if var_52_0 then
		for iter_52_0 = 1, #var_52_0 do
			local var_52_1 = var_52_0[iter_52_0]

			if var_52_1.profile_index == arg_52_0 then
				local var_52_2 = var_52_1.peer_id
				local var_52_3 = 1

				return var_52_2, var_52_3
			end
		end
	end
end

ProfileSynchronizer.is_free_in_lobby = function (arg_53_0, arg_53_1, arg_53_2)
	local var_53_0 = LobbyAux.deserialize_lobby_reservation_data(arg_53_1)[arg_53_2 or 1]

	if var_53_0 then
		for iter_53_0 = 1, #var_53_0 do
			if var_53_0[iter_53_0].profile_index == arg_53_0 then
				return false
			end
		end
	end

	return true
end

ProfileSynchronizer.join_reservation_data_arrays = function (arg_54_0, arg_54_1)
	assert(#arg_54_0 == #arg_54_1, "Mismatch in received reservation data")

	local var_54_0 = {}

	for iter_54_0 = 1, #arg_54_0 do
		local var_54_1 = {}

		var_54_0[iter_54_0] = var_54_1

		local var_54_2 = arg_54_0[iter_54_0]
		local var_54_3 = arg_54_1[iter_54_0]

		for iter_54_1 = 1, #var_54_2 do
			local var_54_4 = var_54_2[iter_54_1]
			local var_54_5 = var_54_3[iter_54_1]

			var_54_1[iter_54_1] = {
				peer_id = var_54_4,
				profile_index = var_54_5
			}
		end
	end

	return var_54_0
end

ProfileSynchronizer.get_bot_profile = function (arg_55_0, arg_55_1, arg_55_2)
	return arg_55_0._state:get_bot_profile(arg_55_1, arg_55_2)
end

ProfileSynchronizer.set_bot_profile = function (arg_56_0, arg_56_1, arg_56_2, arg_56_3, arg_56_4)
	return arg_56_0._state:set_bot_profile(arg_56_1, arg_56_2, arg_56_3, arg_56_4)
end
