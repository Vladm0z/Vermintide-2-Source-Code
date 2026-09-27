-- chunkname: @scripts/game_state/components/profile_synchronizer.lua

require("scripts/settings/profiles/sp_profiles")

local count = #PROFILES_BY_AFFILIATION.heroes
local str = "ProfileSynchronizer"
local set = table.set({
	"dark_pact"
})
local printf = printf

local function fn(...)
	-- function 1
	if not script_data.profile_synchronizer_debug_logging then
		local var_1_0 = sprintf(...)

		printf("[ProfileSynchronizer] %s", var_1_0)
	end
end

local function fn_2(...)
	-- function 2
	local var_2_0 = sprintf(...)

	printf("[ProfileSynchronizer] %s", var_2_0)
end

local function fn_3(arg_3_0, arg_3_1)
	-- function 3
	return string.format("%s:%d", arg_3_0, arg_3_1)
end

local function fn_4(self)
	-- function 4
	local find = string.find(self, ":")
	local sub = self:sub(1, find - 1)
	local var_4_2 = tonumber(self:sub(find + 1))

	return sub, var_4_2
end

local function fn_5(self, arg_5_1, arg_5_2, arg_5_3, arg_5_4, arg_5_5)
	-- function 5
	local get_item_template = BackendUtils.get_item_template(arg_5_2, arg_5_3)
	local get_item_units = BackendUtils.get_item_units(arg_5_2, arg_5_3, nil, arg_5_4)
	local category = arg_5_1.category

	if not (category == "weapon" or category ~= "career_skill_weapon") then
		local get_weapon_packages = WeaponUtils.get_weapon_packages(get_item_template, get_item_units, arg_5_5, arg_5_4)

		for i = 1, #get_weapon_packages do
			self[get_weapon_packages[i]] = false
		end
	elseif category == "attachment" then
		if not get_item_units.unit then
			self[get_item_units.unit] = false
		end

		local character_material_changes = get_item_template.character_material_changes

		if not character_material_changes then
			self[character_material_changes.package_name] = false
		end
	elseif category == "cosmetic" then
		-- Nothing
	else
		error("ProfileSynchronizer unknown slot_category: " .. category)
	end
end

local tbl = {}
local tbl_2 = {}

local function fn_6(arg_6_0, arg_6_1, arg_6_2, arg_6_3)
	-- function 6
	local var_6_0 = SPProfiles[arg_6_0]
	local var_6_1 = var_6_0.careers[arg_6_1]
	local name = var_6_1.name
	local count = #InventorySettings.slots
	local tbl_3 = {}

	for i = 1, count do
		local var_6_5 = InventorySettings.slots[i]
		local name_2 = var_6_5.name
		local get_loadout_item = BackendUtils.get_loadout_item(name, name_2, arg_6_3)

		if not get_loadout_item then
			local data = get_loadout_item.data
			local backend_id = get_loadout_item.backend_id

			fn_5(tbl_3, var_6_5, data, backend_id, name, arg_6_2)
		end
	end

	local base_skin = var_6_1.base_skin
	local get_loadout_item_2 = BackendUtils.get_loadout_item(name, "slot_skin", arg_6_3)
	local name_3

	if not get_loadout_item_2 then
		name_3 = get_loadout_item_2.data.name

		if not name_3 then
			-- Nothing
		end
	end

	name_3 = base_skin

	::label_6_0::

	local retrieve_skin_packages = CosmeticsUtils.retrieve_skin_packages(name_3, arg_6_2)

	for j = 1, #retrieve_skin_packages do
		tbl_3[retrieve_skin_packages[j]] = false
	end

	if not var_6_1.package_name then
		tbl_3[var_6_1.package_name] = false
	end

	local game_mode = Managers.state.game_mode
	local flag = not game_mode and game_mode:has_activated_mutator("whiterun")
	local var_6_16

	if not flag then
		table.clear(tbl_2)

		var_6_16 = tbl_2
	else
		var_6_16 = Managers.backend:get_talents_interface():get_talent_ids(name, nil, arg_6_3)
	end

	local requires_packages = var_6_1.requires_packages

	if not requires_packages then
		table.merge(tbl, requires_packages)
	end

	for k = 1, #var_6_16 do
		local get_talent_by_id = TalentUtils.get_talent_by_id(var_6_0.display_name, var_6_16[k])

		if not get_talent_by_id and not get_talent_by_id.requires_packages then
			table.merge(tbl, get_talent_by_id.requires_packages)
		end
	end

	for k_2, v in pairs(tbl) do
		for k_3, v_2 in pairs(v) do
			tbl_3[v_2] = false
		end
	end

	table.clear(tbl)

	if not var_6_1.talent_packages then
		var_6_1.talent_packages(var_6_16, tbl_3, arg_6_2, arg_6_3)
	end

	if not var_6_1.additional_inventory then
		for k_4, v_3 in pairs(var_6_1.additional_inventory) do
			for i9 = 1, #v_3 do
				local var_6_19 = ItemMasterList[v_3[i9]]
				local var_6_20 = InventorySettings.slots_by_name[k_4]

				fn_5(tbl_3, var_6_20, var_6_19, nil, name, arg_6_2)
			end
		end
	end

	return tbl_3
end

local function fn_7(arg_7_0, arg_7_1, arg_7_2)
	-- function 7
	if not (not arg_7_0 and arg_7_0 ~= 0) then
		return {}, {}
	end

	local var_7_0 = SPProfiles[arg_7_0]

	if not set[var_7_0.affiliation] then
		return {}, {}
	end

	local var_7_1 = fn_6(arg_7_0, arg_7_1, false, arg_7_2)
	local var_7_2 = fn_6(arg_7_0, arg_7_1, true, arg_7_2)

	return var_7_1, var_7_2
end

local tbl_3 = {}

local function fn_8(arg_8_0, arg_8_1)
	-- function 8
	local var_8_0
	local var_8_1
	local keys, var_8_3 = table.keys(arg_8_0, tbl_3)
	local keys_2, var_8_5 = table.keys(arg_8_1, tbl_3, var_8_3)

	return Application.make_hash(unpack(tbl_3, 1, var_8_5))
end

local function fn_9(self, arg_9_1, arg_9_2, arg_9_3, arg_9_4, arg_9_5, arg_9_6, arg_9_7)
	-- function 9
	local var_9_0, var_9_1 = fn_7(arg_9_3, arg_9_4, arg_9_5)
	local get_inventory_data = self:get_inventory_data(arg_9_1, arg_9_2)
	local wrap_index_between = math.wrap_index_between(get_inventory_data.inventory_id + 1, 1, 2147483647)
	local flag = arg_9_7 or fn_8(var_9_0, var_9_1)

	if not (arg_9_6 or get_inventory_data.inventory_id == 0 or flag ~= get_inventory_data.inventory_hash) then
		return
	end

	self:set_inventory_data(arg_9_1, arg_9_2, {
		inventory_id = wrap_index_between,
		inventory_hash = flag,
		first_person = var_9_1,
		third_person = var_9_0
	})

	return wrap_index_between
end

local function fn_10(self, arg_10_1, arg_10_2, arg_10_3, arg_10_4)
	-- function 10
	assert(arg_10_1 ~= Network.peer_id(), "This function is meant to be called remotely, together with a request for the peer to update their inventory data.")

	local shallow_copy = table.shallow_copy(self:get_inventory_data(arg_10_1, arg_10_2), true)

	shallow_copy.inventory_id = 0

	self:set_inventory_data(arg_10_1, arg_10_2, shallow_copy)
	self:set_own_loaded_inventory_id(arg_10_1, arg_10_2, 0)
end

local function fn_11(self, arg_11_1, arg_11_2, arg_11_3)
	-- function 11
	local inventory_id = self:get_inventory_data(arg_11_1, arg_11_2).inventory_id

	if inventory_id == 0 then
		return false
	end

	local get_peers_with_full_profiles = self:get_peers_with_full_profiles()

	for i, v in ipairs(get_peers_with_full_profiles) do
		local peer_id = v.peer_id

		if not (not arg_11_3 and self:is_peer_hot_join_synced(peer_id) and inventory_id == self:get_loaded_inventory_id(peer_id, arg_11_1, arg_11_2)) then
			return false
		end
	end

	if not DEDICATED_SERVER then
		local _server_peer_id = self._server_peer_id

		if not (get_peers_with_full_profiles[_server_peer_id] or inventory_id == self:get_loaded_inventory_id(_server_peer_id, arg_11_1, arg_11_2)) then
			return false
		end
	end

	return true
end

local function fn_12(self, arg_12_1)
	-- function 12
	local get_peers_with_full_profiles = self:get_peers_with_full_profiles()

	for i, v in ipairs(get_peers_with_full_profiles) do
		local peer_id = v.peer_id
		local local_player_id = v.local_player_id

		if not fn_11(self, peer_id, local_player_id, arg_12_1) then
			return false
		end
	end

	return true
end

local tbl_4 = {}
local tbl_5 = {}
local tbl_6 = {}
local tbl_7 = {}

local function fn_13(self)
	-- function 13
	local package = Managers.package
	local get_own_peer_id = self:get_own_peer_id()
	local get_loaded_or_loading_packages = self:get_loaded_or_loading_packages()
	local loaded_or_loading_package_peers = self:loaded_or_loading_package_peers()

	table.clear(tbl_4)
	table.clear(tbl_5)
	table.clear(tbl_6)
	table.clear(tbl_7)

	local get_peers_with_full_profiles = self:get_peers_with_full_profiles()

	for i, v in ipairs(get_peers_with_full_profiles) do
		local peer_id = v.peer_id
		local local_player_id = v.local_player_id
		local get_inventory_data = self:get_inventory_data(peer_id, local_player_id)
		local unique_player_id = PlayerUtils.unique_player_id(peer_id, local_player_id)

		loaded_or_loading_package_peers[unique_player_id] = true
		tbl_7[unique_player_id] = true

		if not get_inventory_data then
			local first_person

			if not (peer_id == get_own_peer_id) then
				first_person = get_inventory_data.first_person

				if not first_person then
					-- Nothing
				end
			end

			first_person = get_inventory_data.third_person

			::label_13_0::

			for k, v_2 in pairs(first_person) do
				tbl_5[k] = true
			end

			if self:get_loaded_inventory_id(get_own_peer_id, peer_id, local_player_id) ~= get_inventory_data.inventory_id then
				local flag = true

				for k_2, v_3 in pairs(first_person) do
					if not package:has_loaded(k_2, str) then
						tbl_4[k_2] = true
						flag = false
					end
				end

				if not flag then
					self:set_own_loaded_inventory_id(peer_id, local_player_id, get_inventory_data.inventory_id)
				end
			end
		end
	end

	for k_3, v_4 in pairs(tbl_4) do
		if not package:is_loading(k_3) then
			local flag_2 = true

			get_loaded_or_loading_packages[k_3] = true

			package:load(k_3, str, nil, flag_2)
		end
	end

	for k_4, v_5 in pairs(get_loaded_or_loading_packages) do
		tbl_6[k_4] = true
	end

	for k_5, v_6 in pairs(tbl_5) do
		tbl_6[k_5] = nil
	end

	for k_6, v_7 in pairs(tbl_6) do
		if not package:can_unload(k_6) then
			package:unload(k_6, str)

			get_loaded_or_loading_packages[k_6] = nil
		end
	end

	for k_7 in pairs(loaded_or_loading_package_peers) do
		if not tbl_7[k_7] then
			loaded_or_loading_package_peers[k_7] = nil

			local split_unique_player_id, var_13_13 = PlayerUtils.split_unique_player_id(k_7)

			if self:get_loaded_inventory_id(get_own_peer_id, split_unique_player_id, var_13_13) ~= 0 then
				self:set_own_loaded_inventory_id(split_unique_player_id, var_13_13, 0)
			end
		end
	end

	self:set_loaded_or_loading_package_peers(loaded_or_loading_package_peers)
	self:set_loaded_or_loading_packages(get_loaded_or_loading_packages)
end

local function fn_14(self)
	-- function 14
	local get_loaded_or_loading_packages = self:get_loaded_or_loading_packages()
	local package = Managers.package

	for k, v in pairs(get_loaded_or_loading_packages) do
		package:unload(k, str)
	end
end

ProfileSynchronizer = class(ProfileSynchronizer)

ProfileSynchronizer.init = function (self, arg_15_1, arg_15_2, arg_15_3)
	-- function 15
	self._state = arg_15_3
	self._lobby = arg_15_2
	self._cached_all_synced_for_peer = {
		ingame = {},
		any = {}
	}
end

local tbl_8 = {
	"rpc_assign_peer_to_profile"
}

ProfileSynchronizer.register_rpcs = function (self, arg_16_1, arg_16_2)
	-- function 16
	self._network_event_delegate = arg_16_1

	self._network_event_delegate:register(self, unpack(tbl_8))
end

ProfileSynchronizer.unregister_network_events = function (self)
	-- function 17
	self._network_event_delegate:unregister(self)
end

ProfileSynchronizer.destroy = function (self)
	-- function 18
	fn_14(self._state)
end

ProfileSynchronizer.update = function (self)
	-- function 19
	fn_13(self._state)
end

ProfileSynchronizer.hot_join_sync = function (self, arg_20_1)
	-- function 20
	fassert(self._state:is_server(), "only for the server")
	fn_2("Peer %s entered session", arg_20_1)
	fn_2("Running hot_join_sync for peer %s", arg_20_1)

	local var_20_0 = PEER_ID_TO_CHANNEL[arg_20_1]
	local get_peers_with_full_profiles = self._state:get_peers_with_full_profiles()

	for i, v in ipairs(get_peers_with_full_profiles) do
		local peer_id = v.peer_id
		local local_player_id = v.local_player_id
		local profile_index = v.profile_index
		local career_index = v.career_index
		local is_bot = v.is_bot

		RPC.rpc_assign_peer_to_profile(var_20_0, peer_id, local_player_id, profile_index, career_index, is_bot)
	end
end

ProfileSynchronizer.clear_peer_data = function (self, arg_21_1)
	-- function 21
	fassert(self._state:is_server(), "only for the server")
	fn_2("Peer %s left session", arg_21_1)
	self:_unassign_profiles_of_peer(arg_21_1)
	self:_clear_profile_index_reservation(arg_21_1)
	self:_request_lobby_data_sync()
end

ProfileSynchronizer.get_profile_index_reservation = function (self, arg_22_1, arg_22_2)
	-- function 22
	local get_profile_index_reservation = self._state:get_profile_index_reservation(arg_22_1, arg_22_2)
	local var_22_1
	local var_22_2

	if not get_profile_index_reservation then
		local get_persistent_profile_index_reservation

		get_persistent_profile_index_reservation, var_22_2 = self:get_persistent_profile_index_reservation(get_profile_index_reservation)
	end

	return get_profile_index_reservation, var_22_2
end

ProfileSynchronizer.get_persistent_profile_index_reservation = function (self, arg_23_1)
	-- function 23
	local get_persistent_profile_index_reservation, var_23_1 = self._state:get_persistent_profile_index_reservation(arg_23_1)

	return get_persistent_profile_index_reservation, var_23_1
end

ProfileSynchronizer.try_reserve_profile_for_peer = function (self, arg_24_1, arg_24_2, arg_24_3, arg_24_4)
	-- function 24
	fassert(self._state:is_server(), "Should only be called on server.")

	local get_profile_index_reservation, var_24_1 = self._state:get_profile_index_reservation(arg_24_1, arg_24_3)

	if not (get_profile_index_reservation == nil or get_profile_index_reservation ~= arg_24_2 or arg_24_4 == var_24_1) then
		fn_2("Reserving profile index %d career index %s to peer %s in party %s", arg_24_3, arg_24_4, arg_24_2, arg_24_1)
		self:_clear_profile_index_reservation(arg_24_2)
		self._state:set_profile_index_reservation(arg_24_1, arg_24_3, arg_24_4, arg_24_2)

		if get_profile_index_reservation == nil then
			self:_request_lobby_data_sync()
		end

		return true
	end

	if get_profile_index_reservation == arg_24_2 then
		return true
	end

	return false
end

ProfileSynchronizer.clear_profile_index_reservation = function (self, arg_25_1, arg_25_2)
	-- function 25
	self:_clear_profile_index_reservation(arg_25_1, arg_25_2)
	self:_request_lobby_data_sync()
end

ProfileSynchronizer.profile_by_peer = function (self, arg_26_1, arg_26_2)
	-- function 26
	local get_peers_with_full_profiles = self._state:get_peers_with_full_profiles()

	for i, v in ipairs(get_peers_with_full_profiles) do
		local peer_id = v.peer_id
		local local_player_id = v.local_player_id

		if not (peer_id ~= arg_26_1 or local_player_id ~= arg_26_2) then
			local profile_index = v.profile_index
			local career_index = v.career_index

			return profile_index, career_index
		end
	end

	return nil, nil
end

ProfileSynchronizer.get_peers_with_full_profiles = function (self)
	-- function 27
	return self._state:get_peers_with_full_profiles()
end

ProfileSynchronizer.assign_full_profile = function (self, arg_28_1, arg_28_2, arg_28_3, arg_28_4, arg_28_5)
	-- function 28
	local _state = self._state

	fassert(_state:is_server(), "Should only be called on server.")
	fn_2("Assigning peer(%s:%s) to profile(%s) career(%s) is_bot(%s)", arg_28_1, arg_28_2, arg_28_3, arg_28_4, arg_28_5)

	local get_profile, var_28_2, var_28_3 = _state:get_profile(arg_28_1, arg_28_2)

	if not (get_profile ~= arg_28_3 or var_28_2 ~= arg_28_4 or var_28_3 ~= arg_28_5) then
		print("Was already assigned...")

		return
	end

	self:_unassign_profiles_of_peer(arg_28_1, arg_28_2)
	self._state:set_profile(arg_28_1, arg_28_2, arg_28_3, arg_28_4, arg_28_5)

	if not arg_28_5 then
		local get_player_status = Managers.party:get_player_status(arg_28_1, arg_28_2)
		local party_id = get_player_status.party_id
		local slot_id = get_player_status.slot_id

		self._state:set_bot_profile(party_id, slot_id, arg_28_3, arg_28_4)
	end

	self:_assign_peer_to_profile(arg_28_1, arg_28_2, arg_28_3, arg_28_4, arg_28_5)

	local get_own_peer_id = _state:get_own_peer_id()
	local get_peers = _state:get_peers()

	for i, v in ipairs(get_peers) do
		if v ~= get_own_peer_id then
			local var_28_9 = PEER_ID_TO_CHANNEL[v]

			RPC.rpc_assign_peer_to_profile(var_28_9, arg_28_1, arg_28_2, arg_28_3, arg_28_4, arg_28_5)
		end
	end
end

ProfileSynchronizer.unassign_profiles_of_peer = function (self, arg_29_1, arg_29_2)
	-- function 29
	self:_unassign_profiles_of_peer(arg_29_1, arg_29_2)
end

ProfileSynchronizer.get_first_free_profile = function (self, arg_30_1)
	-- function 30
	local num = 1

	for i = 1, count do
		if not self._state:get_profile_index_reservation(arg_30_1, i) then
			if not (Managers.mechanism:current_mechanism_name() == "versus") then
				return i, num
			end

			num = PlayerUtils.get_enabled_career_index_by_profile(i)

			if not num then
				return i, num
			end
		end
	end

	fassert(false, "Trying to get free profile when there are no free profiles.")
end

ProfileSynchronizer.is_profile_in_use = function (self, arg_31_1)
	-- function 31
	local get_peers_with_full_profiles = self._state:get_peers_with_full_profiles()

	for i, v in ipairs(get_peers_with_full_profiles) do
		if v.profile_index == arg_31_1 then
			return true
		end
	end

	return false
end

ProfileSynchronizer.all_synced = function (self)
	-- function 32
	local get_revision = self._state:get_revision()

	if self._cached_all_synced_revision ~= get_revision then
		local flag = false

		self._cached_all_synced = fn_12(self._state, flag)
		self._cached_all_synced_revision = get_revision
	end

	return self._cached_all_synced
end

ProfileSynchronizer.all_ingame_synced = function (self)
	-- function 33
	local get_revision = self._state:get_revision()

	if self._cached_all_ingame_synced_revision ~= get_revision then
		local flag = true

		self._cached_all_ingame_synced = fn_12(self._state, flag)
		self._cached_all_ingame_synced_revision = get_revision
	end

	return self._cached_all_ingame_synced
end

ProfileSynchronizer.all_synced_for_peer = function (self, arg_34_1, arg_34_2)
	-- function 34
	local flag = false

	return self:_all_synced_for_peer(arg_34_1, arg_34_2, flag)
end

ProfileSynchronizer.all_ingame_synced_for_peer = function (self, arg_35_1, arg_35_2)
	-- function 35
	local flag = true

	return self:_all_synced_for_peer(arg_35_1, arg_35_2, flag)
end

ProfileSynchronizer._all_synced_for_peer = function (self, arg_36_1, arg_36_2, arg_36_3)
	-- function 36
	local get_revision = self._state:get_revision()
	local flag

	flag = not arg_36_3 and "ingame" and "any"

	local var_36_2 = self._cached_all_synced_for_peer[flag][arg_36_1]
	local flag_2 = not var_36_2 and var_36_2[arg_36_2]
	local num = 1
	local num_2 = 2

	if not (not flag_2 and flag_2[num] == get_revision) then
		local var_36_6 = fn_11(self._state, arg_36_1, arg_36_2, arg_36_3)

		flag_2 = {
			get_revision,
			var_36_6
		}
		var_36_2 = var_36_2 or {}
		var_36_2[arg_36_2] = flag_2
		self._cached_all_synced_for_peer[flag][arg_36_1] = var_36_2
	end

	return flag_2[num_2]
end

ProfileSynchronizer.is_peer_all_synced = function (self, arg_37_1)
	-- function 37
	local get_peers_with_full_profiles = self._state:get_peers_with_full_profiles()

	for i, v in ipairs(get_peers_with_full_profiles) do
		local peer_id = v.peer_id
		local local_player_id = v.local_player_id
		local get_inventory_data = self._state:get_inventory_data(peer_id, local_player_id)
		local get_loaded_inventory_id = self._state:get_loaded_inventory_id(arg_37_1, peer_id, local_player_id)

		if get_inventory_data.inventory_id ~= get_loaded_inventory_id then
			return false
		end
	end

	return true
end

ProfileSynchronizer.resync_loadout = function (self, arg_38_1, arg_38_2, arg_38_3, arg_38_4, arg_38_5)
	-- function 38
	fn_2("Resyncing loadout of peer(%s:%s)", arg_38_1, arg_38_2)

	local profile_by_peer, var_38_1 = self:profile_by_peer(arg_38_1, arg_38_2)

	fn_9(self._state, arg_38_1, arg_38_2, profile_by_peer, var_38_1, arg_38_3, arg_38_4, arg_38_5)
end

ProfileSynchronizer.rpc_assign_peer_to_profile = function (self, arg_39_1, arg_39_2, arg_39_3, arg_39_4, arg_39_5, arg_39_6)
	-- function 39
	local var_39_0 = fn_2
	local str = "rpc_assign_peer_to_profile peer_id:%s local_player_id:%d profile_index:%d career_index:%d is_bot:%s"
	local var_39_2 = arg_39_2
	local var_39_3 = arg_39_3
	local var_39_4 = arg_39_4
	local var_39_5 = arg_39_5
	local flag

	flag = not arg_39_6 and "true" and "false"

	var_39_0(str, var_39_2, var_39_3, var_39_4, var_39_5, flag)

	if not Managers.party:get_player_status(arg_39_2, arg_39_3) then
		fn_2("rpc_assign_peer_to_profile called without status available in party manager. Ignoring it")

		return
	end

	self:_assign_peer_to_profile(arg_39_2, arg_39_3, arg_39_4, arg_39_5, arg_39_6)
end

ProfileSynchronizer._clear_profile_index_reservation = function (self, arg_40_1, arg_40_2)
	-- function 40
	local get_num_parties = Managers.party:get_num_parties()

	for i = 1, count do
		for j = 1, get_num_parties do
			if self._state:get_profile_index_reservation(j, i) == arg_40_1 then
				self._state:set_profile_index_reservation(j, i, nil, "")
			end
		end
	end

	if not arg_40_2 then
		self._state:clear_persistent_profile_index_reservation(arg_40_1)
	end
end

ProfileSynchronizer._unassign_profiles_of_peer = function (self, arg_41_1, arg_41_2)
	-- function 41
	local get_peers_with_full_profiles = self._state:get_peers_with_full_profiles()

	for i, v in ipairs(get_peers_with_full_profiles) do
		local peer_id = v.peer_id
		local local_player_id = v.local_player_id

		if not (peer_id ~= arg_41_1 or not arg_41_2 or arg_41_2 ~= local_player_id) then
			self._state:delete_profile_data(arg_41_1, arg_41_2 or 1)
		end
	end
end

ProfileSynchronizer._assign_peer_to_profile = function (self, arg_42_1, arg_42_2, arg_42_3, arg_42_4, arg_42_5, arg_42_6)
	-- function 42
	local get_player_status = Managers.party:get_player_status(arg_42_1, arg_42_2)

	get_player_status.profile_index = arg_42_3
	get_player_status.career_index = arg_42_4
	get_player_status.selected_profile_index = arg_42_3
	get_player_status.selected_career_index = arg_42_4
	get_player_status.profile_id = SPProfiles[arg_42_3].display_name

	Managers.mechanism:profile_changed(arg_42_1, arg_42_2, arg_42_3, arg_42_4, arg_42_5)

	if not Managers.state.game_mode then
		Managers.state.game_mode:profile_changed(arg_42_1, arg_42_2, arg_42_3, arg_42_4, arg_42_5)
	end

	if not Managers.venture.challenge then
		Managers.venture.challenge:profile_changed(arg_42_1, arg_42_2, arg_42_3, arg_42_4, arg_42_5)
	end

	if arg_42_1 == self._state:get_own_peer_id() then
		local flag = arg_42_3 ~= FindProfileIndex("spectator")

		flag = not flag and arg_42_3 ~= FindProfileIndex("vs_undecided")

		if not flag then
			local var_42_2 = SPProfiles[arg_42_3]
			local get_interface = Managers.backend:get_interface("hero_attributes")
			local display_name = var_42_2.display_name

			get_interface:set(display_name, "career", arg_42_4)
		end

		fn_9(self._state, arg_42_1, arg_42_2, arg_42_3, arg_42_4, arg_42_5, true)
	elseif arg_42_1 == self._state:get_server_peer_id() or not self._state:is_peer_hot_join_synced(Network.peer_id()) then
		fn_10(self._state, arg_42_1, arg_42_2, arg_42_3, arg_42_4)
	end

	Managers.state.event:trigger("player_profile_assigned", arg_42_1, arg_42_2, arg_42_3, arg_42_4)
end

local str_2 = "0"
local str_3 = "0:0"

ProfileSynchronizer.set_own_actually_ingame = function (self, arg_43_1)
	-- function 43
	self._state:set_own_actually_ingame(arg_43_1)
end

ProfileSynchronizer.get_own_actually_ingame = function (self)
	-- function 44
	return self._state:get_actually_ingame(self._state:get_own_peer_id())
end

ProfileSynchronizer.others_actually_ingame = function (self)
	-- function 45
	local _state = self._state
	local get_own_peer_id = _state:get_own_peer_id()
	local get_peers_with_full_profiles = self:get_peers_with_full_profiles()

	for i, v in ipairs(get_peers_with_full_profiles) do
		local peer_id = v.peer_id

		if not (get_own_peer_id == peer_id or _state:get_actually_ingame(peer_id)) then
			return false
		end
	end

	return true
end

ProfileSynchronizer._request_lobby_data_sync = function (self)
	-- function 46
	self._lobby_data_sync_requested = true
end

ProfileSynchronizer.poll_sync_lobby_data_required = function (self)
	-- function 47
	if not self._lobby_data_sync_requested then
		self._lobby_data_sync_requested = false

		return true
	end

	return false
end

ProfileSynchronizer.hash_inventory = function (arg_48_0, arg_48_1, arg_48_2, arg_48_3)
	-- function 48
	local var_48_0, var_48_1 = fn_7(arg_48_1, arg_48_2, arg_48_3)

	return fn_8(var_48_0, var_48_1)
end

ProfileSynchronizer.cached_inventory_hash = function (self, arg_49_1, arg_49_2)
	-- function 49
	return self._state:get_inventory_data(arg_49_1, arg_49_2).inventory_hash
end

ProfileSynchronizer.own_loaded_inventory_id = function (self)
	-- function 50
	local get_own_peer_id = self._state:get_own_peer_id()

	return self._state:get_loaded_inventory_id(get_own_peer_id, get_own_peer_id, 1)
end

ProfileSynchronizer.net_pack_lobby_profile_slots = function (arg_51_0)
	-- function 51
	local tbl = {}
	local tbl_2 = {}
	local deserialize_lobby_reservation_data = LobbyAux.deserialize_lobby_reservation_data(arg_51_0)

	for i, v in ipairs(deserialize_lobby_reservation_data) do
		local tbl_3 = {}
		local tbl_4 = {}

		tbl[i] = tbl_3
		tbl_2[i] = tbl_4

		for k = 1, #v do
			local var_51_5 = v[k]
			local peer_id = var_51_5.peer_id

			tbl_4[k], tbl_3[k] = var_51_5.profile_index, peer_id
		end
	end

	return tbl, tbl_2
end

ProfileSynchronizer.owner_in_lobby = function (arg_52_0, arg_52_1, arg_52_2)
	-- function 52
	local var_52_0 = LobbyAux.deserialize_lobby_reservation_data(arg_52_1)[arg_52_2 or 1]

	if not var_52_0 then
		for i = 1, #var_52_0 do
			local var_52_1 = var_52_0[i]

			if var_52_1.profile_index == arg_52_0 then
				local peer_id = var_52_1.peer_id
				local num = 1

				return peer_id, num
			end
		end
	end
end

ProfileSynchronizer.is_free_in_lobby = function (arg_53_0, arg_53_1, arg_53_2)
	-- function 53
	local var_53_0 = LobbyAux.deserialize_lobby_reservation_data(arg_53_1)[arg_53_2 or 1]

	if not var_53_0 then
		for i = 1, #var_53_0 do
			if var_53_0[i].profile_index == arg_53_0 then
				return false
			end
		end
	end

	return true
end

ProfileSynchronizer.join_reservation_data_arrays = function (self, arg_54_1)
	-- function 54
	assert(#self == #arg_54_1, "Mismatch in received reservation data")

	local tbl = {}

	for i = 1, #self do
		local tbl_2 = {}

		tbl[i] = tbl_2

		local var_54_2 = self[i]
		local var_54_3 = arg_54_1[i]

		for j = 1, #var_54_2 do
			local var_54_4 = var_54_2[j]
			local var_54_5 = var_54_3[j]

			tbl_2[j] = {
				peer_id = var_54_4,
				profile_index = var_54_5
			}
		end
	end

	return tbl
end

ProfileSynchronizer.get_bot_profile = function (self, arg_55_1, arg_55_2)
	-- function 55
	return self._state:get_bot_profile(arg_55_1, arg_55_2)
end

ProfileSynchronizer.set_bot_profile = function (self, arg_56_1, arg_56_2, arg_56_3, arg_56_4)
	-- function 56
	return self._state:set_bot_profile(arg_56_1, arg_56_2, arg_56_3, arg_56_4)
end
