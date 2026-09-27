-- chunkname: @scripts/game_state/components/network_state.lua

require("scripts/network/shared_state")

local scripts_game_state_components_network_state_spec = require("scripts/game_state/components/network_state_spec")

NetworkState = class(NetworkState)

NetworkState.init = function (self, arg_1_1, arg_1_2, arg_1_3, arg_1_4)
	-- function 1
	self._shared_state = SharedState:new("network_state_" .. arg_1_3, scripts_game_state_components_network_state_spec, arg_1_1, arg_1_2, arg_1_3, arg_1_4)
	self._loaded_or_loading_packages = {}
	self._loaded_or_loading_package_peers = {}
	self._is_server = arg_1_1
	self._server_peer_id = arg_1_3
	self._own_peer_id = arg_1_4

	local get_key = self._shared_state:get_key("peers")

	if not arg_1_1 then
		self._shared_state:set_server(get_key, {
			arg_1_3
		})
	else
		self._shared_state:set_server(get_key, {
			arg_1_3,
			arg_1_4
		})
	end
end

NetworkState.register_callback = function (self, arg_2_1, arg_2_2, arg_2_3, ...)
	-- function 2
	self._shared_state:register_callback(arg_2_1, arg_2_2, arg_2_3, ...)
end

NetworkState.unregister_callback = function (self, arg_3_1, arg_3_2)
	-- function 3
	self._shared_state:unregister_callback(arg_3_1, arg_3_2)
end

NetworkState.full_sync = function (self)
	-- function 4
	self._shared_state:full_sync()
end

NetworkState.register_rpcs = function (self, arg_5_1, arg_5_2)
	-- function 5
	self._shared_state:register_rpcs(arg_5_1)
end

NetworkState.unregister_network_events = function (self)
	-- function 6
	self._shared_state:unregister_rpcs()
end

NetworkState.destroy = function (self)
	-- function 7
	self._shared_state:destroy()

	self._shared_state = nil
end

NetworkState.get_revision = function (self)
	-- function 8
	return self._shared_state:get_revision()
end

NetworkState.is_peer_fully_synced = function (self, arg_9_1)
	-- function 9
	return self._shared_state:is_peer_fully_synced(arg_9_1)
end

NetworkState.is_fully_synced = function (self)
	-- function 10
	return self:is_peer_fully_synced(self._own_peer_id)
end

NetworkState.is_server = function (self)
	-- function 11
	return self._is_server
end

NetworkState.get_server_peer_id = function (self)
	-- function 12
	return self._server_peer_id
end

NetworkState.get_own_peer_id = function (self)
	-- function 13
	return self._own_peer_id
end

NetworkState.get_peers = function (self)
	-- function 14
	local get_key = self._shared_state:get_key("peers")

	return self._shared_state:get_server(get_key)
end

NetworkState.add_peer = function (self, arg_15_1)
	-- function 15
	local get_key = self._shared_state:get_key("peers")
	local get_server = self._shared_state:get_server(get_key)

	if not table.contains(get_server, arg_15_1) then
		local flag = true
		local clone = table.clone(get_server, flag)

		clone[#clone + 1] = arg_15_1

		self._shared_state:set_server(get_key, clone)
	end
end

NetworkState.remove_peer = function (self, arg_16_1)
	-- function 16
	local get_key = self._shared_state:get_key("peers")
	local get_server = self._shared_state:get_server(get_key)
	local index_of = table.index_of(get_server, arg_16_1)

	if index_of ~= -1 then
		local flag = true
		local clone = table.clone(get_server, flag)

		table.swap_delete(clone, index_of)
		self._shared_state:set_server(get_key, clone)
	end
end

NetworkState.get_peer_initialized = function (self, arg_17_1)
	-- function 17
	local get_key = self._shared_state:get_key("peer_initialized", arg_17_1)

	return self._shared_state:get_server(get_key)
end

NetworkState.set_peer_initialized = function (self, arg_18_1, arg_18_2)
	-- function 18
	local get_key = self._shared_state:get_key("peer_initialized", arg_18_1)

	return self._shared_state:set_server(get_key, arg_18_2)
end

NetworkState.get_level_key = function (self)
	-- function 19
	local get_key = self._shared_state:get_key("level_key")

	return self._shared_state:get_server(get_key)
end

NetworkState.get_level_seed = function (self)
	-- function 20
	local get_key = self._shared_state:get_key("level_seed")

	return self._shared_state:get_server(get_key)
end

NetworkState.get_conflict_director = function (self)
	-- function 21
	local get_key = self._shared_state:get_key("conflict_director")

	return self._shared_state:get_server(get_key)
end

NetworkState.get_game_mode = function (self)
	-- function 22
	local get_key = self._shared_state:get_key("game_mode")

	return self._shared_state:get_server(get_key)
end

NetworkState.get_environment_variation_id = function (self)
	-- function 23
	local get_key = self._shared_state:get_key("environment_variation_id")

	return self._shared_state:get_server(get_key)
end

NetworkState.get_locked_director_functions = function (self)
	-- function 24
	local get_key = self._shared_state:get_key("locked_director_functions")

	return self._shared_state:get_server(get_key)
end

NetworkState.get_difficulty = function (self)
	-- function 25
	local get_key = self._shared_state:get_key("difficulty")

	return self._shared_state:get_server(get_key)
end

NetworkState.get_difficulty_tweak = function (self)
	-- function 26
	local get_key = self._shared_state:get_key("difficulty_tweak")

	return self._shared_state:get_server(get_key)
end

NetworkState.get_extra_packages = function (self)
	-- function 27
	local get_key = self._shared_state:get_key("extra_packages")

	return self._shared_state:get_server(get_key)
end

NetworkState.get_mechanism = function (self)
	-- function 28
	local get_key = self._shared_state:get_key("mechanism")

	return self._shared_state:get_server(get_key)
end

NetworkState.get_level_session_id = function (self)
	-- function 29
	local get_key = self._shared_state:get_key("level_session_id")

	return self._shared_state:get_server(get_key)
end

NetworkState.get_level_transition_type = function (self)
	-- function 30
	local get_key = self._shared_state:get_key("level_transition_type")

	return self._shared_state:get_server(get_key)
end

NetworkState.set_level_data = function (self, arg_31_1, arg_31_2, arg_31_3, arg_31_4, arg_31_5, arg_31_6, arg_31_7, arg_31_8, arg_31_9, arg_31_10, arg_31_11, arg_31_12)
	-- function 31
	local _shared_state = self._shared_state

	_shared_state:start_atomic_set_server("set_level_data")
	_shared_state:set_server(_shared_state:get_key("level_key"), arg_31_1)
	_shared_state:set_server(_shared_state:get_key("level_seed"), arg_31_3)
	_shared_state:set_server(_shared_state:get_key("conflict_director"), arg_31_6)
	_shared_state:set_server(_shared_state:get_key("locked_director_functions"), arg_31_7)
	_shared_state:set_server(_shared_state:get_key("game_mode"), arg_31_5)
	_shared_state:set_server(_shared_state:get_key("mechanism"), arg_31_4)
	_shared_state:set_server(_shared_state:get_key("environment_variation_id"), arg_31_2)
	_shared_state:set_server(_shared_state:get_key("difficulty"), arg_31_8)
	_shared_state:set_server(_shared_state:get_key("difficulty_tweak"), arg_31_9)
	_shared_state:set_server(_shared_state:get_key("level_session_id"), arg_31_10)
	_shared_state:set_server(_shared_state:get_key("level_transition_type"), arg_31_11)
	_shared_state:set_server(_shared_state:get_key("extra_packages"), arg_31_12)
	_shared_state:end_atomic_set_server("set_level_data")
end

NetworkState.is_peer_ingame = function (self, arg_32_1)
	-- function 32
	local get_key = self._shared_state:get_key("peer_ingame", arg_32_1)

	return self._shared_state:get_server(get_key)
end

NetworkState.set_peer_ingame = function (self, arg_33_1, arg_33_2)
	-- function 33
	local get_key = self._shared_state:get_key("peer_ingame", arg_33_1)

	self._shared_state:set_server(get_key, arg_33_2)
end

NetworkState.is_peer_hot_join_synced = function (self, arg_34_1)
	-- function 34
	local get_key = self._shared_state:get_key("peer_hot_join_synced", arg_34_1)

	return self._shared_state:get_server(get_key)
end

NetworkState.set_peer_hot_join_synced = function (self, arg_35_1, arg_35_2)
	-- function 35
	local get_key = self._shared_state:get_key("peer_hot_join_synced", arg_35_1)

	return self._shared_state:set_server(get_key, arg_35_2)
end

NetworkState.get_loaded_or_loading_packages = function (self)
	-- function 36
	return self._loaded_or_loading_packages
end

NetworkState.set_loaded_or_loading_packages = function (self, arg_37_1)
	-- function 37
	self._loaded_or_loading_packages = arg_37_1
end

NetworkState.loaded_or_loading_package_peers = function (self)
	-- function 38
	return self._loaded_or_loading_package_peers
end

NetworkState.set_loaded_or_loading_package_peers = function (self, arg_39_1)
	-- function 39
	self._loaded_or_loading_package_peers = arg_39_1
end

NetworkState.get_profile_index_reservation = function (self, arg_40_1, arg_40_2)
	-- function 40
	local get_key = self._shared_state:get_key("profile_index_reservation", nil, nil, arg_40_2, nil, arg_40_1)
	local get_server = self._shared_state:get_server(get_key)

	return get_server == "" or not get_server or nil
end

NetworkState.set_profile_index_reservation = function (self, arg_41_1, arg_41_2, arg_41_3, arg_41_4)
	-- function 41
	local get_key = self._shared_state:get_key("profile_index_reservation", nil, nil, arg_41_2, nil, arg_41_1)

	self._shared_state:set_server(get_key, arg_41_4 or "")

	if not (not arg_41_4 and arg_41_4 == "") then
		local get_key_2 = self._shared_state:get_key("persistent_hero_reservation", arg_41_4)
		local get_server = self._shared_state:get_server(get_key_2)
		local profile_index = get_server.profile_index
		local career_index = get_server.career_index
		local party_id = get_server.party_id

		if not (profile_index ~= arg_41_2 or career_index ~= arg_41_3 or party_id == arg_41_1) then
			self._shared_state:set_server(get_key_2, {
				profile_index = arg_41_2,
				career_index = arg_41_3,
				party_id = arg_41_1
			})
		end
	end
end

NetworkState.clear_persistent_profile_index_reservation = function (self, arg_42_1)
	-- function 42
	local get_key = self._shared_state:get_key("persistent_hero_reservation", arg_42_1)

	self._shared_state:set_server(get_key, {
		profile_index = 0,
		career_index = 0,
		party_id = 0
	})
end

NetworkState.set_bot_profile = function (self, arg_43_1, arg_43_2, arg_43_3, arg_43_4)
	-- function 43
	local get_key = self._shared_state:get_key("bot_profile", nil, arg_43_2, nil, nil, arg_43_1)
	local get_server = self._shared_state:get_server(get_key)

	if not (get_server.profile_index ~= arg_43_3 or get_server.career_index == arg_43_4) then
		self._shared_state:set_server(get_key, {
			profile_index = arg_43_3,
			career_index = arg_43_4
		})
	end
end

NetworkState.get_bot_profile = function (self, arg_44_1, arg_44_2)
	-- function 44
	local get_key = self._shared_state:get_key("bot_profile", nil, arg_44_2, nil, nil, arg_44_1)
	local get_server = self._shared_state:get_server(get_key)

	return get_server.profile_index, get_server.career_index
end

NetworkState.get_persistent_profile_index_reservation = function (self, arg_45_1)
	-- function 45
	local get_key = self._shared_state:get_key("persistent_hero_reservation", arg_45_1)
	local get_server = self._shared_state:get_server(get_key)

	return get_server.profile_index, get_server.career_index, get_server.party_id
end

NetworkState.get_peers_with_full_profiles = function (self)
	-- function 46
	local get_key = self._shared_state:get_key("full_profile_peers")

	return self._shared_state:get_server(get_key)
end

NetworkState.get_profile = function (self, arg_47_1, arg_47_2)
	-- function 47
	local get_key = self._shared_state:get_key("full_profile_peers")
	local get_server = self._shared_state:get_server(get_key)

	for i, v in ipairs(get_server) do
		if not (v.peer_id ~= arg_47_1 or v.local_player_id ~= arg_47_2) then
			return v.profile_index, v.career_index, v.is_bot
		end
	end

	return nil, nil
end

NetworkState.set_profile = function (self, arg_48_1, arg_48_2, arg_48_3, arg_48_4, arg_48_5)
	-- function 48
	fassert(arg_48_3 > 0, "use :delete_profile_data instead")

	local get_key = self._shared_state:get_key("full_profile_peers")
	local get_server = self._shared_state:get_server(get_key)
	local flag = true
	local clone = table.clone(get_server, flag)
	local flag_2 = false

	for i, v in ipairs(clone) do
		if not (v.peer_id ~= arg_48_1 or v.local_player_id ~= arg_48_2) then
			v.profile_index = arg_48_3
			v.career_index = arg_48_4
			v.is_bot = arg_48_5
			flag_2 = true
		end
	end

	if not flag_2 then
		clone[#clone + 1] = {
			peer_id = arg_48_1,
			local_player_id = arg_48_2,
			profile_index = arg_48_3,
			career_index = arg_48_4,
			is_bot = arg_48_5
		}
	end

	self._shared_state:set_server(get_key, clone)
end

NetworkState.get_inventory_data = function (self, arg_49_1, arg_49_2)
	-- function 49
	local get_key = self._shared_state:get_key("inventory_list", nil, arg_49_2)

	return self._shared_state:get_peer(arg_49_1, get_key)
end

NetworkState.set_inventory_data = function (self, arg_50_1, arg_50_2, arg_50_3)
	-- function 50
	local get_key = self._shared_state:get_key("inventory_list", nil, arg_50_2)

	self._shared_state:set_peer(arg_50_1, get_key, arg_50_3)
end

NetworkState.get_loaded_inventory_id = function (self, arg_51_1, arg_51_2, arg_51_3)
	-- function 51
	local get_key = self._shared_state:get_key("loaded_inventory_id", arg_51_2, arg_51_3)

	return (self._shared_state:get_peer(arg_51_1, get_key))
end

NetworkState.set_own_loaded_inventory_id = function (self, arg_52_1, arg_52_2, arg_52_3)
	-- function 52
	local get_key = self._shared_state:get_key("loaded_inventory_id", arg_52_1, arg_52_2)

	self._shared_state:set_own(get_key, arg_52_3)
end

NetworkState.delete_profile_data = function (self, arg_53_1, arg_53_2)
	-- function 53
	local get_peers_with_full_profiles = self:get_peers_with_full_profiles()
	local tbl = {}

	for i, v in ipairs(get_peers_with_full_profiles) do
		if not (v.peer_id ~= arg_53_1 or v.local_player_id == arg_53_2) then
			tbl[#tbl + 1] = v
		end
	end

	local get_key = self._shared_state:get_key("full_profile_peers")

	self._shared_state:set_server(get_key, tbl)
end

NetworkState.get_actually_ingame = function (self, arg_54_1)
	-- function 54
	local get_key = self._shared_state:get_key("actually_ingame", arg_54_1)

	return self._shared_state:get_peer(arg_54_1, get_key)
end

NetworkState.set_own_actually_ingame = function (self, arg_55_1)
	-- function 55
	local get_key = self._shared_state:get_key("actually_ingame", self._own_peer_id)

	self._shared_state:set_peer(self._own_peer_id, get_key, arg_55_1)
end

NetworkState.set_side_order_state = function (self, arg_56_1)
	-- function 56
	local get_key = self._shared_state:get_key("side_order_state")

	self._shared_state:set_server(get_key, arg_56_1)
end

NetworkState.get_side_order_state = function (self)
	-- function 57
	local get_key = self._shared_state:get_key("side_order_state")

	return self._shared_state:get_server(get_key)
end

NetworkState.get_game_mode_event_data = function (self)
	-- function 58
	local get_key = self._shared_state:get_key("game_mode_event_data")

	return self._shared_state:get_server(get_key)
end

NetworkState.set_game_mode_event_data = function (self, arg_59_1)
	-- function 59
	local get_key = self._shared_state:get_key("game_mode_event_data")

	self._shared_state:set_server(get_key, arg_59_1)
end

NetworkState.has_peer_state = function (self, arg_60_1, arg_60_2)
	-- function 60
	return self._shared_state:has_peer_state(arg_60_1, arg_60_2)
end

NetworkState.set_initialized_mutator_map = function (self, arg_61_1)
	-- function 61
	local get_key = self._shared_state:get_key("initialized_mutator_map")

	self._shared_state:set_server(get_key, arg_61_1)
end

NetworkState.get_initialized_mutator_map = function (self)
	-- function 62
	local get_key = self._shared_state:get_key("initialized_mutator_map")

	return self._shared_state:get_server(get_key)
end

NetworkState.set_session_breed_map = function (self, arg_63_1)
	-- function 63
	local get_key = self._shared_state:get_key("session_breed_map")

	self._shared_state:set_server(get_key, arg_63_1)
end

NetworkState.get_session_breed_map = function (self)
	-- function 64
	local get_key = self._shared_state:get_key("session_breed_map")

	return self._shared_state:get_server(get_key)
end

NetworkState.get_loaded_session_breed_map = function (self, arg_65_1)
	-- function 65
	local get_key = self._shared_state:get_key("loaded_session_breed_map")

	return self._shared_state:get_peer(arg_65_1, get_key)
end

NetworkState.get_own_loaded_session_breed_map = function (self)
	-- function 66
	local get_key = self._shared_state:get_key("loaded_session_breed_map")

	return self._shared_state:get_own(get_key)
end

NetworkState.set_own_loaded_session_breeds = function (self, arg_67_1)
	-- function 67
	local get_key = self._shared_state:get_key("loaded_session_breed_map")

	return self._shared_state:set_own(get_key, arg_67_1)
end

NetworkState.set_startup_breeds = function (self, arg_68_1)
	-- function 68
	local get_key = self._shared_state:get_key("startup_breed_map")

	return self._shared_state:set_server(get_key, arg_68_1)
end

NetworkState.get_startup_breeds = function (self)
	-- function 69
	local get_key = self._shared_state:get_key("startup_breed_map")

	return self._shared_state:get_server(get_key)
end

NetworkState.get_session_pickup_map = function (self)
	-- function 70
	local get_key = self._shared_state:get_key("session_pickup_map")

	return self._shared_state:get_server(get_key)
end

NetworkState.set_session_pickup_map = function (self, arg_71_1)
	-- function 71
	local get_key = self._shared_state:get_key("session_pickup_map")

	self._shared_state:set_server(get_key, arg_71_1)
end

NetworkState.get_own_loaded_session_pickup_map = function (self)
	-- function 72
	local get_key = self._shared_state:get_key("loaded_session_pickup_map")

	return self._shared_state:get_own(get_key)
end

NetworkState.set_own_loaded_session_pickups = function (self, arg_73_1)
	-- function 73
	local get_key = self._shared_state:get_key("loaded_session_pickup_map")

	return self._shared_state:set_own(get_key, arg_73_1)
end

NetworkState.get_loaded_session_pickup_map = function (self, arg_74_1)
	-- function 74
	local get_key = self._shared_state:get_key("loaded_session_pickup_map")

	return self._shared_state:get_peer(arg_74_1, get_key)
end

NetworkState.get_unlocked_dlcs_set = function (self, arg_75_1)
	-- function 75
	local get_key = self._shared_state:get_key("unlocked_dlcs")

	return self._shared_state:get_peer(arg_75_1, get_key)
end

NetworkState.get_loaded_mutator_map = function (self, arg_76_1)
	-- function 76
	local get_key = self._shared_state:get_key("loaded_mutator_map")

	return self._shared_state:get_peer(arg_76_1, get_key)
end

NetworkState.get_own_loaded_mutator_map = function (self)
	-- function 77
	local get_key = self._shared_state:get_key("loaded_mutator_map")

	return self._shared_state:get_own(get_key)
end

NetworkState.set_own_loaded_mutator_map = function (self, arg_78_1)
	-- function 78
	local get_key = self._shared_state:get_key("loaded_mutator_map")

	self._shared_state:set_own(get_key, arg_78_1)
end
