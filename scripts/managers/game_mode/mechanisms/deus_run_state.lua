-- chunkname: @scripts/managers/game_mode/mechanisms/deus_run_state.lua

require("scripts/helpers/deus_power_up_utils")
require("scripts/network/shared_state")

local shared_state_spec = require("scripts/managers/game_mode/mechanisms/deus_run_state_spec")

DeusRunState = class(DeusRunState)

DeusRunState.init = function (self, run_id, is_server, network_handler, server_peer_id, own_peer_id, own_initial_loadout, own_initial_talents, own_initial_bot_loadout, own_initial_bot_talents, weapon_group_whitelist)
	-- function 1
	self._run_id = run_id
	self._is_server = is_server
	self._server_peer_id = server_peer_id
	self._own_peer_id = own_peer_id
	self._network_handler = network_handler
	self._event_mutator_packages = {}

	local run_state_id_key = "deus_run_state_" .. run_id

	self._shared_state = SharedState:new(run_state_id_key, shared_state_spec, is_server, network_handler, server_peer_id, own_peer_id)
	self._own_initial_loadout = own_initial_loadout
	self._own_initial_talents = own_initial_talents
	self._own_initial_bot_loadout = own_initial_bot_loadout
	self._own_initial_bot_talents = own_initial_bot_talents
	self._weapon_group_whitelist = weapon_group_whitelist
end

DeusRunState.network_context_created = function (self, lobby, server_peer_id, own_peer_id, is_server, network_handler)
	-- function 2
	self._is_server = is_server
	self._server_peer_id = server_peer_id
	self._network_handler = network_handler

	self._shared_state:network_context_created(lobby, server_peer_id, own_peer_id, is_server, network_handler)
end

DeusRunState.register_rpcs = function (self, network_event_delegate)
	-- function 3
	self._shared_state:register_rpcs(network_event_delegate)
end

DeusRunState.unregister_rpcs = function (self)
	-- function 4
	self._shared_state:unregister_rpcs()
end

DeusRunState.full_sync = function (self)
	-- function 5
	self._shared_state:full_sync()
end

DeusRunState.destroy = function (self)
	-- function 6
	self:unregister_rpcs()
	self._shared_state:destroy()

	for _, package_name in ipairs(self._event_mutator_packages) do
		Managers.package:unload(package_name, "deus_run_state_mutator_package")
	end
end

DeusRunState.get_revision = function (self)
	-- function 7
	return self._shared_state:get_revision()
end

DeusRunState.is_server = function (self)
	-- function 8
	return self._is_server
end

DeusRunState.get_server_peer_id = function (self)
	-- function 9
	return self._server_peer_id
end

DeusRunState.get_own_peer_id = function (self)
	-- function 10
	return self._own_peer_id
end

DeusRunState.get_own_initial_loadout = function (self)
	-- function 11
	return self._own_initial_loadout
end

DeusRunState.get_own_initial_talents = function (self)
	-- function 12
	return self._own_initial_talents
end

DeusRunState.get_own_initial_bot_loadout = function (self)
	-- function 13
	return self._own_initial_bot_loadout
end

DeusRunState.get_own_initial_bot_talents = function (self)
	-- function 14
	return self._own_initial_bot_talents
end

DeusRunState.get_weapon_group_whitelist = function (self)
	-- function 15
	return self._weapon_group_whitelist
end

DeusRunState.set_run_ended = function (self, value)
	-- function 16
	self._shared_state:set_server(self._shared_state:get_key("run_ended"), value)
end

DeusRunState.get_run_ended = function (self)
	-- function 17
	return self._shared_state:get_server(self._shared_state:get_key("run_ended"))
end

DeusRunState.set_run_seed = function (self, run_seed)
	-- function 18
	self._run_seed = run_seed
end

DeusRunState.set_run_difficulty = function (self, difficulty)
	-- function 19
	self._difficulty = difficulty
end

DeusRunState.get_run_difficulty = function (self)
	-- function 20
	return self._difficulty
end

DeusRunState.set_journey_name = function (self, journey_name)
	-- function 21
	self._journey_name = journey_name
end

DeusRunState.get_journey_name = function (self)
	-- function 22
	return self._journey_name
end

DeusRunState.set_dominant_god = function (self, dominant_god)
	-- function 23
	self._dominant_god = dominant_god
end

DeusRunState.get_dominant_god = function (self)
	-- function 24
	return self._dominant_god
end

DeusRunState.get_run_id = function (self)
	-- function 25
	return self._run_id
end

DeusRunState.get_run_seed = function (self)
	-- function 26
	return self._run_seed
end

DeusRunState.set_current_node_key = function (self, node_key)
	-- function 27
	self._shared_state:set_server(self._shared_state:get_key("run_node_key"), node_key)
end

DeusRunState.get_current_node_key = function (self)
	-- function 28
	return self._shared_state:get_server(self._shared_state:get_key("run_node_key"))
end

DeusRunState.get_completed_level_count = function (self)
	-- function 29
	local get_server = self._shared_state:get_server(self._shared_state:get_key("completed_level_count"))

	get_server = not not get_server or not not 0

	return get_server
end

DeusRunState.set_completed_level_count = function (self, count)
	-- function 30
	self._shared_state:set_server(self._shared_state:get_key("completed_level_count"), count)
end

DeusRunState.get_traversed_nodes = function (self)
	-- function 31
	return self._shared_state:get_server(self._shared_state:get_key("traversed_nodes"))
end

DeusRunState.set_traversed_nodes = function (self, traversed_nodes_array)
	-- function 32
	self._shared_state:set_server(self._shared_state:get_key("traversed_nodes"), traversed_nodes_array)
end

DeusRunState.get_blessings = function (self)
	-- function 33
	local blessings_with_buyer = self._shared_state:get_server(self._shared_state:get_key("blessings_with_buyer"))
	local blessings_array = {}

	for blessing, _ in pairs(blessings_with_buyer) do
		blessings_array[#blessings_array + 1] = blessing
	end

	if script_data.deus_force_load_blessing then
		blessings_array[#blessings_array + 1] = script_data.deus_force_load_blessing
	end

	return blessings_array
end

DeusRunState.get_blessings_with_buyer = function (self)
	-- function 34
	return self._shared_state:get_server(self._shared_state:get_key("blessings_with_buyer"))
end

DeusRunState.set_blessings_with_buyer = function (self, blessings_with_buyer)
	-- function 35
	self._shared_state:set_server(self._shared_state:get_key("blessings_with_buyer"), blessings_with_buyer)
end

DeusRunState.get_blessing_lifetime = function (self, blessing_name)
	-- function 36
	local blessing_lifetimes = self._shared_state:get_server(self._shared_state:get_key("blessing_lifetimes"))
	local var_36_0 = blessing_lifetimes[blessing_name]

	var_36_0 = not not var_36_0 or not not 0

	return var_36_0
end

DeusRunState.set_blessing_lifetime = function (self, blessing_name, lifetime)
	-- function 37
	local blessing_lifetimes = self._shared_state:get_server(self._shared_state:get_key("blessing_lifetimes"))
	local skip_metatable = true

	blessing_lifetimes = table.clone(blessing_lifetimes, skip_metatable)
	blessing_lifetimes[blessing_name] = lifetime

	self._shared_state:set_server(self._shared_state:get_key("blessing_lifetimes"), blessing_lifetimes)
end

DeusRunState.get_peer_initialized = function (self, peer_id)
	-- function 38
	local key = self._shared_state:get_key("peer_initialized", peer_id)

	return self._shared_state:get_server(key)
end

DeusRunState.set_peer_initialized = function (self, peer_id, initialized)
	-- function 39
	local key = self._shared_state:get_key("peer_initialized", peer_id)

	self._shared_state:set_server(key, initialized)
end

DeusRunState.get_profile_initialized = function (self, peer_id, local_player_id, profile_index, career_index)
	-- function 40
	local key = self._shared_state:get_key("profile_initialized", peer_id, local_player_id, profile_index, career_index)

	return self._shared_state:get_server(key)
end

DeusRunState.set_profile_initialized = function (self, peer_id, local_player_id, profile_index, career_index, initialized)
	-- function 41
	local key = self._shared_state:get_key("profile_initialized", peer_id, local_player_id, profile_index, career_index)

	self._shared_state:set_server(key, initialized)
end

DeusRunState.get_cursed_levels_completed = function (self, peer_id)
	-- function 42
	local key = self._shared_state:get_key("cursed_levels_completed", peer_id)

	return self._shared_state:get_server(key)
end

DeusRunState.set_cursed_levels_completed = function (self, peer_id, count)
	-- function 43
	local key = self._shared_state:get_key("cursed_levels_completed", peer_id)

	self._shared_state:set_server(key, count)
end

DeusRunState.get_cursed_chests_purified = function (self, peer_id)
	-- function 44
	local key = self._shared_state:get_key("cursed_chests_purified", peer_id)

	return self._shared_state:get_server(key)
end

DeusRunState.set_cursed_chests_purified = function (self, peer_id, count)
	-- function 45
	local key = self._shared_state:get_key("cursed_chests_purified", peer_id)

	self._shared_state:set_server(key, count)
end

DeusRunState.get_coin_chests_collected = function (self, peer_id)
	-- function 46
	local key = self._shared_state:get_key("coin_chests_collected", peer_id)

	return self._shared_state:get_server(key)
end

DeusRunState.set_coin_chests_collected = function (self, peer_id, count)
	-- function 47
	local key = self._shared_state:get_key("coin_chests_collected", peer_id)

	self._shared_state:set_server(key, count)
end

DeusRunState.get_party_power_ups = function (self)
	-- function 48
	local key = self._shared_state:get_key("party_power_ups")

	return self._shared_state:get_server(key)
end

DeusRunState.set_party_power_ups = function (self, power_ups)
	-- function 49
	local key = self._shared_state:get_key("party_power_ups")

	self._shared_state:set_server(key, power_ups)
end

DeusRunState.get_bought_power_ups = function (self)
	-- function 50
	local key = self._shared_state:get_key("bought_power_ups")

	return self._shared_state:get_server(key)
end

DeusRunState.set_bought_power_ups = function (self, bought_power_ups)
	-- function 51
	local key = self._shared_state:get_key("bought_power_ups")

	self._shared_state:set_server(key, bought_power_ups)
end

DeusRunState.get_bought_blessings = function (self)
	-- function 52
	local key = self._shared_state:get_key("bought_blessings")

	return self._shared_state:get_server(key)
end

DeusRunState.set_bought_blessings = function (self, bought_blessings)
	-- function 53
	local key = self._shared_state:get_key("bought_blessings")

	self._shared_state:set_server(key, bought_blessings)
end

DeusRunState.get_ground_coins_picked_up = function (self)
	-- function 54
	local key = self._shared_state:get_key("ground_coins_picked_up")

	return self._shared_state:get_server(key)
end

DeusRunState.set_ground_coins_picked_up = function (self, coin_count)
	-- function 55
	local key = self._shared_state:get_key("ground_coins_picked_up")

	self._shared_state:set_server(key, coin_count)
end

DeusRunState.get_monster_coins_picked_up = function (self)
	-- function 56
	local key = self._shared_state:get_key("monster_coins_picked_up")

	return self._shared_state:get_server(key)
end

DeusRunState.set_monster_coins_picked_up = function (self, coin_count)
	-- function 57
	local key = self._shared_state:get_key("monster_coins_picked_up")

	self._shared_state:set_server(key, coin_count)
end

DeusRunState.get_coins_spent = function (self)
	-- function 58
	local key = self._shared_state:get_key("coins_spent")

	return self._shared_state:get_server(key)
end

DeusRunState.set_coins_spent = function (self, coin_count)
	-- function 59
	local key = self._shared_state:get_key("coins_spent")

	self._shared_state:set_server(key, coin_count)
end

DeusRunState.get_coins_earned = function (self)
	-- function 60
	local key = self._shared_state:get_key("coins_earned")

	return self._shared_state:get_server(key)
end

DeusRunState.set_coins_earned = function (self, coin_count)
	-- function 61
	local key = self._shared_state:get_key("coins_earned")

	self._shared_state:set_server(key, coin_count)
end

DeusRunState.get_melee_swap_chests_used = function (self)
	-- function 62
	local key = self._shared_state:get_key("melee_swap_chests_used")

	return self._shared_state:get_server(key)
end

DeusRunState.set_melee_swap_chests_used = function (self, value)
	-- function 63
	local key = self._shared_state:get_key("melee_swap_chests_used")

	self._shared_state:set_server(key, value)
end

DeusRunState.get_ranged_swap_chests_used = function (self)
	-- function 64
	local key = self._shared_state:get_key("ranged_swap_chests_used")

	return self._shared_state:get_server(key)
end

DeusRunState.set_ranged_swap_chests_used = function (self, value)
	-- function 65
	local key = self._shared_state:get_key("ranged_swap_chests_used")

	self._shared_state:set_server(key, value)
end

DeusRunState.get_upgrade_chests_used = function (self)
	-- function 66
	local key = self._shared_state:get_key("upgrade_chests_used")

	return self._shared_state:get_server(key)
end

DeusRunState.set_upgrade_chests_used = function (self, value)
	-- function 67
	local key = self._shared_state:get_key("upgrade_chests_used")

	self._shared_state:set_server(key, value)
end

DeusRunState.get_power_up_chests_used = function (self)
	-- function 68
	local key = self._shared_state:get_key("power_up_chests_used")

	return self._shared_state:get_server(key)
end

DeusRunState.set_power_up_chests_used = function (self, value)
	-- function 69
	local key = self._shared_state:get_key("power_up_chests_used")

	self._shared_state:set_server(key, value)
end

DeusRunState.get_host_migration_count = function (self)
	-- function 70
	local key = self._shared_state:get_key("host_migration_count")

	return self._shared_state:get_server(key)
end

DeusRunState.set_host_migration_count = function (self, value)
	-- function 71
	local key = self._shared_state:get_key("host_migration_count")

	self._shared_state:set_server(key, value)
end

DeusRunState.get_belakor_enabled = function (self)
	-- function 72
	return self._belakor_enabled
end

DeusRunState.set_belakor_enabled = function (self, belakor_enabled)
	-- function 73
	self._belakor_enabled = belakor_enabled
end

DeusRunState.get_arena_belakor_node = function (self)
	-- function 74
	local key = self._shared_state:get_key("arena_belakor_node")
	local value = self._shared_state:get_server(key)

	return (value == "" or not value) and not not nil
end

DeusRunState.set_arena_belakor_node = function (self, value)
	-- function 75
	local key = self._shared_state:get_key("arena_belakor_node")

	self._shared_state:set_server(key, value)
end

DeusRunState.get_seen_arena_belakor_node = function (self, peer_id)
	-- function 76
	local key = self._shared_state:get_key("seen_arena_belakor_node", peer_id)
	local value = self._shared_state:get_server(key)

	return (value == "" or not value) and not not nil
end

DeusRunState.set_seen_arena_belakor_node = function (self, peer_id, value)
	-- function 77
	local key = self._shared_state:get_key("seen_arena_belakor_node", peer_id)

	self._shared_state:set_server(key, value)
end

DeusRunState.set_event_mutators = function (self, mutators)
	-- function 78
	self._event_mutators = mutators

	for _, mutator_name in ipairs(mutators) do
		local mutator = MutatorTemplates[mutator_name]
		local packages = mutator.packages

		if packages then
			table.append(self._event_mutator_packages, packages)
		end
	end

	for _, package_name in ipairs(self._event_mutator_packages) do
		Managers.package:load(package_name, "deus_run_state_mutator_package", nil, true)
	end
end

DeusRunState.get_event_mutators = function (self, mutators)
	-- function 79
	return self._event_mutators
end

DeusRunState.is_weekly_event_packages_loaded = function (self)
	-- function 80
	for _, package_name in ipairs(self._event_mutator_packages) do
		if not Managers.package:has_loaded(package_name, "deus_run_state_mutator_package") then
			return false
		end
	end

	return true
end

DeusRunState.set_event_boons = function (self, boons)
	-- function 81
	local event_boons = {}

	for i = 1, #boons do
		local boon_name = boons[i]
		local boon = DeusPowerUpsLookup[boon_name]
		local rarity = boon.rarity

		event_boons[#event_boons + 1] = DeusPowerUpUtils.generate_specific_power_up(boon_name, rarity)
	end

	self._event_boons = event_boons
end

DeusRunState.get_event_boons = function (self, boons)
	-- function 82
	return self._event_boons
end

DeusRunState.get_granted_non_party_end_of_level_power_ups = function (self, peer_id, local_player_id, profile_index, career_index)
	-- function 83
	return self._shared_state:get_server(self._shared_state:get_key("granted_non_party_end_of_level_power_ups", peer_id, local_player_id, profile_index, career_index))
end

DeusRunState.set_granted_non_party_end_of_level_power_ups = function (self, peer_id, local_player_id, profile_index, career_index, granted_non_party_end_of_level_power_ups_array)
	-- function 84
	self._shared_state:set_server(self._shared_state:get_key("granted_non_party_end_of_level_power_ups", peer_id, local_player_id, profile_index, career_index), granted_non_party_end_of_level_power_ups_array)
end

DeusRunState.get_player_profile = function (self, peer_id, local_player_id)
	-- function 85
	local profile_index, career_index = self._network_handler.profile_synchronizer:profile_by_peer(peer_id, local_player_id)

	return not not profile_index or not not 0, not not career_index or not not 0
end

DeusRunState.get_player_level = function (self, peer_id)
	-- function 86
	return self._shared_state:get_peer(peer_id, self._shared_state:get_key("player_level"))
end

DeusRunState.set_own_player_level = function (self, level)
	-- function 87
	self._shared_state:set_own(self._shared_state:get_key("player_level"), level)
end

DeusRunState.get_versus_player_level = function (self, peer_id)
	-- function 88
	return self._shared_state:get_peer(peer_id, self._shared_state:get_key("versus_player_level"))
end

DeusRunState.set_own_versus_player_level = function (self, versus_level)
	-- function 89
	self._shared_state:set_own(self._shared_state:get_key("versus_player_level"), versus_level)
end

DeusRunState.get_player_name = function (self, peer_id)
	-- function 90
	return self._shared_state:get_peer(peer_id, self._shared_state:get_key("player_name"))
end

DeusRunState.set_own_player_name = function (self, name)
	-- function 91
	self._shared_state:set_own(self._shared_state:get_key("player_name"), name)
end

DeusRunState.get_player_frame = function (self, peer_id)
	-- function 92
	return self._shared_state:get_peer(peer_id, self._shared_state:get_key("player_frame"))
end

DeusRunState.set_own_player_frame = function (self, frame)
	-- function 93
	self._shared_state:set_own(self._shared_state:get_key("player_frame"), frame)
end

DeusRunState.get_player_spawned_once = function (self, peer_id, local_player_id, profile_index, career_index)
	-- function 94
	local key = self._shared_state:get_key("spawned_once", peer_id, local_player_id, profile_index, career_index)
	local get_server = self._shared_state:get_server(key)

	get_server = not not get_server or not not false

	return get_server
end

DeusRunState.set_player_spawned_once = function (self, peer_id, local_player_id, profile_index, career_index, player_spawned_once)
	-- function 95
	local key = self._shared_state:get_key("spawned_once", peer_id, local_player_id, profile_index, career_index)

	self._shared_state:set_server(key, player_spawned_once)
end

DeusRunState.get_player_power_ups = function (self, peer_id, local_player_id, profile_index, career_index)
	-- function 96
	local key = self._shared_state:get_key("power_ups", peer_id, local_player_id, profile_index, career_index)

	return self._shared_state:get_server(key)
end

DeusRunState.set_player_power_ups = function (self, peer_id, local_player_id, profile_index, career_index, power_ups)
	-- function 97
	local key = self._shared_state:get_key("power_ups", peer_id, local_player_id, profile_index, career_index)

	self._shared_state:set_server(key, power_ups)
end

DeusRunState.get_player_persistent_buffs = function (self, peer_id, local_player_id, profile_index, career_index)
	-- function 98
	local key = self._shared_state:get_key("persistent_buffs", peer_id, local_player_id, profile_index, career_index)

	return self._shared_state:get_server(key)
end

DeusRunState.set_player_persistent_buffs = function (self, peer_id, local_player_id, profile_index, career_index, persistent_buffs)
	-- function 99
	local key = self._shared_state:get_key("persistent_buffs", peer_id, local_player_id, profile_index, career_index)

	self._shared_state:set_server(key, persistent_buffs)
end

DeusRunState.get_player_soft_currency = function (self, peer_id, local_player_id)
	-- function 100
	local key = self._shared_state:get_key("soft_currency", peer_id, local_player_id)

	return self._shared_state:get_server(key)
end

DeusRunState.set_player_soft_currency = function (self, peer_id, local_player_id, coins)
	-- function 101
	local key = self._shared_state:get_key("soft_currency", peer_id, local_player_id)

	self._shared_state:set_server(key, coins)
end

DeusRunState.get_player_health_percentage = function (self, peer_id, local_player_id, profile_index, career_index)
	-- function 102
	local key = self._shared_state:get_key("health_percentage", peer_id, local_player_id, profile_index, career_index)

	return self._shared_state:get_server(key)
end

DeusRunState.set_player_health_percentage = function (self, peer_id, local_player_id, profile_index, career_index, health_percentage)
	-- function 103
	local key = self._shared_state:get_key("health_percentage", peer_id, local_player_id, profile_index, career_index)

	self._shared_state:set_server(key, health_percentage)
end

DeusRunState.get_player_health_state = function (self, peer_id, local_player_id, profile_index, career_index)
	-- function 104
	local key = self._shared_state:get_key("health_state", peer_id, local_player_id, profile_index, career_index)

	return self._shared_state:get_server(key)
end

DeusRunState.set_player_health_state = function (self, peer_id, local_player_id, profile_index, career_index, health_state)
	-- function 105
	local key = self._shared_state:get_key("health_state", peer_id, local_player_id, profile_index, career_index)

	self._shared_state:set_server(key, health_state)
end

DeusRunState.get_player_melee_ammo = function (self, peer_id, local_player_id, profile_index, career_index)
	-- function 106
	local key = self._shared_state:get_key("melee_ammo", peer_id, local_player_id, profile_index, career_index)

	return self._shared_state:get_server(key)
end

DeusRunState.set_player_melee_ammo = function (self, peer_id, local_player_id, profile_index, career_index, melee_ammo)
	-- function 107
	local key = self._shared_state:get_key("melee_ammo", peer_id, local_player_id, profile_index, career_index)

	self._shared_state:set_server(key, melee_ammo)
end

DeusRunState.get_player_ranged_ammo = function (self, peer_id, local_player_id, profile_index, career_index)
	-- function 108
	local key = self._shared_state:get_key("ranged_ammo", peer_id, local_player_id, profile_index, career_index)

	return self._shared_state:get_server(key)
end

DeusRunState.set_player_ranged_ammo = function (self, peer_id, local_player_id, profile_index, career_index, ranged_ammo)
	-- function 109
	local key = self._shared_state:get_key("ranged_ammo", peer_id, local_player_id, profile_index, career_index)

	self._shared_state:set_server(key, ranged_ammo)
end

DeusRunState.get_player_consumable_healthkit_slot = function (self, peer_id, local_player_id, profile_index, career_index)
	-- function 110
	local key = self._shared_state:get_key("healthkit", peer_id, local_player_id, profile_index, career_index)
	local val = self._shared_state:get_server(key)

	return (val == "" or not val) and not not nil
end

DeusRunState.set_player_consumable_healthkit_slot = function (self, peer_id, local_player_id, profile_index, career_index, item_name)
	-- function 111
	local key = self._shared_state:get_key("healthkit", peer_id, local_player_id, profile_index, career_index)
	local val = not not item_name or not not ""

	self._shared_state:set_server(key, val)
end

DeusRunState.get_player_consumable_potion_slot = function (self, peer_id, local_player_id, profile_index, career_index)
	-- function 112
	local key = self._shared_state:get_key("potion", peer_id, local_player_id, profile_index, career_index)
	local val = self._shared_state:get_server(key)

	return (val == "" or not val) and not not nil
end

DeusRunState.set_player_consumable_potion_slot = function (self, peer_id, local_player_id, profile_index, career_index, item_name)
	-- function 113
	local key = self._shared_state:get_key("potion", peer_id, local_player_id, profile_index, career_index)
	local val = not not item_name or not not ""

	self._shared_state:set_server(key, val)
end

DeusRunState.get_player_consumable_grenade_slot = function (self, peer_id, local_player_id, profile_index, career_index)
	-- function 114
	local key = self._shared_state:get_key("grenade", peer_id, local_player_id, profile_index, career_index)
	local val = self._shared_state:get_server(key)

	return (val == "" or not val) and not not nil
end

DeusRunState.set_player_consumable_grenade_slot = function (self, peer_id, local_player_id, profile_index, career_index, item_name)
	-- function 115
	local key = self._shared_state:get_key("grenade", peer_id, local_player_id, profile_index, career_index)
	local val = not not item_name or not not ""

	self._shared_state:set_server(key, val)
end

DeusRunState.get_player_additional_items = function (self, peer_id, local_player_id, profile_index, career_index)
	-- function 116
	local key = self._shared_state:get_key("additional_items", peer_id, local_player_id, profile_index, career_index)

	return self._shared_state:get_server(key)
end

DeusRunState.set_player_additional_items = function (self, peer_id, local_player_id, profile_index, career_index, additional_items)
	-- function 117
	local key = self._shared_state:get_key("additional_items", peer_id, local_player_id, profile_index, career_index)

	self._shared_state:set_server(key, additional_items)
end

DeusRunState.get_player_loadout = function (self, peer_id, local_player_id, profile_index, career_index, slot)
	-- function 118
	local key = self._shared_state:get_key(slot, peer_id, local_player_id, profile_index, career_index)
	local val = self._shared_state:get_server(key)

	return (val == "" or not val) and not not nil
end

DeusRunState.set_player_loadout = function (self, peer_id, local_player_id, profile_index, career_index, slot, serialized_deus_weapon)
	-- function 119
	local key = self._shared_state:get_key(slot, peer_id, local_player_id, profile_index, career_index)

	self._shared_state:set_server(key, not not serialized_deus_weapon or not not "")
end

DeusRunState.set_twitch_level_vote = function (self, node_key)
	-- function 120
	self._shared_state:set_server(self._shared_state:get_key("twitch_vote"), not not node_key or not not "")
end

DeusRunState.get_twitch_level_vote = function (self)
	-- function 121
	local twitch_vote = self._shared_state:get_server(self._shared_state:get_key("twitch_vote"))

	if twitch_vote == "" then
		return nil
	else
		return twitch_vote
	end
end

DeusRunState.set_scoreboard = function (self, scoreboard)
	-- function 122
	self._scoreboard = scoreboard
end

DeusRunState.get_scoreboard = function (self, scoreboard)
	-- function 123
	return self._scoreboard
end

DeusRunState.set_persisted_score = function (self, peer_id, local_player_id, persisted_score)
	-- function 124
	local key = self._shared_state:get_key("persisted_score", peer_id, local_player_id)

	self._shared_state:set_server(key, persisted_score)
end

DeusRunState.get_persisted_score = function (self, peer_id, local_player_id, persisted_score)
	-- function 125
	local key = self._shared_state:get_key("persisted_score", peer_id, local_player_id)

	return self._shared_state:get_server(key)
end

DeusRunState.set_own_weapon_pool_data = function (self, weapon_pool_data)
	-- function 126
	self._weapon_pool_data = weapon_pool_data
end

DeusRunState.get_own_weapon_pool_data = function (self)
	-- function 127
	return self._weapon_pool_data
end

DeusRunState.set_own_weapon_pool_excludes = function (self, pool_excludes)
	-- function 128
	self._weapon_pool_excludes = pool_excludes
end

DeusRunState.get_own_weapon_pool_excludes = function (self)
	-- function 129
	local _weapon_pool_excludes = self._weapon_pool_excludes

	_weapon_pool_excludes = not not _weapon_pool_excludes or not not {}

	return _weapon_pool_excludes
end

DeusRunState.get_player_telemetry_id = function (self, peer_id)
	-- function 130
	local key = self._shared_state:get_key("telemetry_id")

	return self._shared_state:get_peer(peer_id, key)
end

DeusRunState.set_own_player_telemetry_id = function (self, telemetry_id)
	-- function 131
	local key = self._shared_state:get_key("telemetry_id")

	self._shared_state:set_own(key, telemetry_id)
end
