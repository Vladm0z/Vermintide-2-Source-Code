-- chunkname: @scripts/managers/game_mode/mechanisms/deus_run_state.lua

require("scripts/helpers/deus_power_up_utils")
require("scripts/network/shared_state")

local scripts_managers_game_mode_mechanisms_deus_run_state_spec = require("scripts/managers/game_mode/mechanisms/deus_run_state_spec")

DeusRunState = class(DeusRunState)

DeusRunState.init = function (self, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7, arg_1_8, arg_1_9, arg_1_10)
	-- function 1
	self._run_id = arg_1_1
	self._is_server = arg_1_2
	self._server_peer_id = arg_1_4
	self._own_peer_id = arg_1_5
	self._network_handler = arg_1_3
	self._event_mutator_packages = {}

	local str = "deus_run_state_" .. arg_1_1

	self._shared_state = SharedState:new(str, scripts_managers_game_mode_mechanisms_deus_run_state_spec, arg_1_2, arg_1_3, arg_1_4, arg_1_5)
	self._own_initial_loadout = arg_1_6
	self._own_initial_talents = arg_1_7
	self._own_initial_bot_loadout = arg_1_8
	self._own_initial_bot_talents = arg_1_9
	self._weapon_group_whitelist = arg_1_10
end

DeusRunState.network_context_created = function (self, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5)
	-- function 2
	self._is_server = arg_2_4
	self._server_peer_id = arg_2_2
	self._network_handler = arg_2_5

	self._shared_state:network_context_created(arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5)
end

DeusRunState.register_rpcs = function (self, arg_3_1)
	-- function 3
	self._shared_state:register_rpcs(arg_3_1)
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

	for i, v in ipairs(self._event_mutator_packages) do
		Managers.package:unload(v, "deus_run_state_mutator_package")
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

DeusRunState.set_run_ended = function (self, arg_16_1)
	-- function 16
	self._shared_state:set_server(self._shared_state:get_key("run_ended"), arg_16_1)
end

DeusRunState.get_run_ended = function (self)
	-- function 17
	return self._shared_state:get_server(self._shared_state:get_key("run_ended"))
end

DeusRunState.set_run_seed = function (self, arg_18_1)
	-- function 18
	self._run_seed = arg_18_1
end

DeusRunState.set_run_difficulty = function (self, arg_19_1)
	-- function 19
	self._difficulty = arg_19_1
end

DeusRunState.get_run_difficulty = function (self)
	-- function 20
	return self._difficulty
end

DeusRunState.set_journey_name = function (self, arg_21_1)
	-- function 21
	self._journey_name = arg_21_1
end

DeusRunState.get_journey_name = function (self)
	-- function 22
	return self._journey_name
end

DeusRunState.set_dominant_god = function (self, arg_23_1)
	-- function 23
	self._dominant_god = arg_23_1
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

DeusRunState.set_current_node_key = function (self, arg_27_1)
	-- function 27
	self._shared_state:set_server(self._shared_state:get_key("run_node_key"), arg_27_1)
end

DeusRunState.get_current_node_key = function (self)
	-- function 28
	return self._shared_state:get_server(self._shared_state:get_key("run_node_key"))
end

DeusRunState.get_completed_level_count = function (self)
	-- function 29
	local get_server = self._shared_state:get_server(self._shared_state:get_key("completed_level_count"))

	get_server = get_server or 0

	return get_server
end

DeusRunState.set_completed_level_count = function (self, arg_30_1)
	-- function 30
	self._shared_state:set_server(self._shared_state:get_key("completed_level_count"), arg_30_1)
end

DeusRunState.get_traversed_nodes = function (self)
	-- function 31
	return self._shared_state:get_server(self._shared_state:get_key("traversed_nodes"))
end

DeusRunState.set_traversed_nodes = function (self, arg_32_1)
	-- function 32
	self._shared_state:set_server(self._shared_state:get_key("traversed_nodes"), arg_32_1)
end

DeusRunState.get_blessings = function (self)
	-- function 33
	local get_server = self._shared_state:get_server(self._shared_state:get_key("blessings_with_buyer"))
	local tbl = {}

	for k, v in pairs(get_server) do
		tbl[#tbl + 1] = k
	end

	if not script_data.deus_force_load_blessing then
		tbl[#tbl + 1] = script_data.deus_force_load_blessing
	end

	return tbl
end

DeusRunState.get_blessings_with_buyer = function (self)
	-- function 34
	return self._shared_state:get_server(self._shared_state:get_key("blessings_with_buyer"))
end

DeusRunState.set_blessings_with_buyer = function (self, arg_35_1)
	-- function 35
	self._shared_state:set_server(self._shared_state:get_key("blessings_with_buyer"), arg_35_1)
end

DeusRunState.get_blessing_lifetime = function (self, arg_36_1)
	-- function 36
	local var_36_0 = self._shared_state:get_server(self._shared_state:get_key("blessing_lifetimes"))[arg_36_1]

	var_36_0 = var_36_0 or 0

	return var_36_0
end

DeusRunState.set_blessing_lifetime = function (self, arg_37_1, arg_37_2)
	-- function 37
	local get_server = self._shared_state:get_server(self._shared_state:get_key("blessing_lifetimes"))
	local flag = true
	local clone = table.clone(get_server, flag)

	clone[arg_37_1] = arg_37_2

	self._shared_state:set_server(self._shared_state:get_key("blessing_lifetimes"), clone)
end

DeusRunState.get_peer_initialized = function (self, arg_38_1)
	-- function 38
	local get_key = self._shared_state:get_key("peer_initialized", arg_38_1)

	return self._shared_state:get_server(get_key)
end

DeusRunState.set_peer_initialized = function (self, arg_39_1, arg_39_2)
	-- function 39
	local get_key = self._shared_state:get_key("peer_initialized", arg_39_1)

	self._shared_state:set_server(get_key, arg_39_2)
end

DeusRunState.get_profile_initialized = function (self, arg_40_1, arg_40_2, arg_40_3, arg_40_4)
	-- function 40
	local get_key = self._shared_state:get_key("profile_initialized", arg_40_1, arg_40_2, arg_40_3, arg_40_4)

	return self._shared_state:get_server(get_key)
end

DeusRunState.set_profile_initialized = function (self, arg_41_1, arg_41_2, arg_41_3, arg_41_4, arg_41_5)
	-- function 41
	local get_key = self._shared_state:get_key("profile_initialized", arg_41_1, arg_41_2, arg_41_3, arg_41_4)

	self._shared_state:set_server(get_key, arg_41_5)
end

DeusRunState.get_cursed_levels_completed = function (self, arg_42_1)
	-- function 42
	local get_key = self._shared_state:get_key("cursed_levels_completed", arg_42_1)

	return self._shared_state:get_server(get_key)
end

DeusRunState.set_cursed_levels_completed = function (self, arg_43_1, arg_43_2)
	-- function 43
	local get_key = self._shared_state:get_key("cursed_levels_completed", arg_43_1)

	self._shared_state:set_server(get_key, arg_43_2)
end

DeusRunState.get_cursed_chests_purified = function (self, arg_44_1)
	-- function 44
	local get_key = self._shared_state:get_key("cursed_chests_purified", arg_44_1)

	return self._shared_state:get_server(get_key)
end

DeusRunState.set_cursed_chests_purified = function (self, arg_45_1, arg_45_2)
	-- function 45
	local get_key = self._shared_state:get_key("cursed_chests_purified", arg_45_1)

	self._shared_state:set_server(get_key, arg_45_2)
end

DeusRunState.get_coin_chests_collected = function (self, arg_46_1)
	-- function 46
	local get_key = self._shared_state:get_key("coin_chests_collected", arg_46_1)

	return self._shared_state:get_server(get_key)
end

DeusRunState.set_coin_chests_collected = function (self, arg_47_1, arg_47_2)
	-- function 47
	local get_key = self._shared_state:get_key("coin_chests_collected", arg_47_1)

	self._shared_state:set_server(get_key, arg_47_2)
end

DeusRunState.get_party_power_ups = function (self)
	-- function 48
	local get_key = self._shared_state:get_key("party_power_ups")

	return self._shared_state:get_server(get_key)
end

DeusRunState.set_party_power_ups = function (self, arg_49_1)
	-- function 49
	local get_key = self._shared_state:get_key("party_power_ups")

	self._shared_state:set_server(get_key, arg_49_1)
end

DeusRunState.get_bought_power_ups = function (self)
	-- function 50
	local get_key = self._shared_state:get_key("bought_power_ups")

	return self._shared_state:get_server(get_key)
end

DeusRunState.set_bought_power_ups = function (self, arg_51_1)
	-- function 51
	local get_key = self._shared_state:get_key("bought_power_ups")

	self._shared_state:set_server(get_key, arg_51_1)
end

DeusRunState.get_bought_blessings = function (self)
	-- function 52
	local get_key = self._shared_state:get_key("bought_blessings")

	return self._shared_state:get_server(get_key)
end

DeusRunState.set_bought_blessings = function (self, arg_53_1)
	-- function 53
	local get_key = self._shared_state:get_key("bought_blessings")

	self._shared_state:set_server(get_key, arg_53_1)
end

DeusRunState.get_ground_coins_picked_up = function (self)
	-- function 54
	local get_key = self._shared_state:get_key("ground_coins_picked_up")

	return self._shared_state:get_server(get_key)
end

DeusRunState.set_ground_coins_picked_up = function (self, arg_55_1)
	-- function 55
	local get_key = self._shared_state:get_key("ground_coins_picked_up")

	self._shared_state:set_server(get_key, arg_55_1)
end

DeusRunState.get_monster_coins_picked_up = function (self)
	-- function 56
	local get_key = self._shared_state:get_key("monster_coins_picked_up")

	return self._shared_state:get_server(get_key)
end

DeusRunState.set_monster_coins_picked_up = function (self, arg_57_1)
	-- function 57
	local get_key = self._shared_state:get_key("monster_coins_picked_up")

	self._shared_state:set_server(get_key, arg_57_1)
end

DeusRunState.get_coins_spent = function (self)
	-- function 58
	local get_key = self._shared_state:get_key("coins_spent")

	return self._shared_state:get_server(get_key)
end

DeusRunState.set_coins_spent = function (self, arg_59_1)
	-- function 59
	local get_key = self._shared_state:get_key("coins_spent")

	self._shared_state:set_server(get_key, arg_59_1)
end

DeusRunState.get_coins_earned = function (self)
	-- function 60
	local get_key = self._shared_state:get_key("coins_earned")

	return self._shared_state:get_server(get_key)
end

DeusRunState.set_coins_earned = function (self, arg_61_1)
	-- function 61
	local get_key = self._shared_state:get_key("coins_earned")

	self._shared_state:set_server(get_key, arg_61_1)
end

DeusRunState.get_melee_swap_chests_used = function (self)
	-- function 62
	local get_key = self._shared_state:get_key("melee_swap_chests_used")

	return self._shared_state:get_server(get_key)
end

DeusRunState.set_melee_swap_chests_used = function (self, arg_63_1)
	-- function 63
	local get_key = self._shared_state:get_key("melee_swap_chests_used")

	self._shared_state:set_server(get_key, arg_63_1)
end

DeusRunState.get_ranged_swap_chests_used = function (self)
	-- function 64
	local get_key = self._shared_state:get_key("ranged_swap_chests_used")

	return self._shared_state:get_server(get_key)
end

DeusRunState.set_ranged_swap_chests_used = function (self, arg_65_1)
	-- function 65
	local get_key = self._shared_state:get_key("ranged_swap_chests_used")

	self._shared_state:set_server(get_key, arg_65_1)
end

DeusRunState.get_upgrade_chests_used = function (self)
	-- function 66
	local get_key = self._shared_state:get_key("upgrade_chests_used")

	return self._shared_state:get_server(get_key)
end

DeusRunState.set_upgrade_chests_used = function (self, arg_67_1)
	-- function 67
	local get_key = self._shared_state:get_key("upgrade_chests_used")

	self._shared_state:set_server(get_key, arg_67_1)
end

DeusRunState.get_power_up_chests_used = function (self)
	-- function 68
	local get_key = self._shared_state:get_key("power_up_chests_used")

	return self._shared_state:get_server(get_key)
end

DeusRunState.set_power_up_chests_used = function (self, arg_69_1)
	-- function 69
	local get_key = self._shared_state:get_key("power_up_chests_used")

	self._shared_state:set_server(get_key, arg_69_1)
end

DeusRunState.get_host_migration_count = function (self)
	-- function 70
	local get_key = self._shared_state:get_key("host_migration_count")

	return self._shared_state:get_server(get_key)
end

DeusRunState.set_host_migration_count = function (self, arg_71_1)
	-- function 71
	local get_key = self._shared_state:get_key("host_migration_count")

	self._shared_state:set_server(get_key, arg_71_1)
end

DeusRunState.get_belakor_enabled = function (self)
	-- function 72
	return self._belakor_enabled
end

DeusRunState.set_belakor_enabled = function (self, arg_73_1)
	-- function 73
	self._belakor_enabled = arg_73_1
end

DeusRunState.get_arena_belakor_node = function (self)
	-- function 74
	local get_key = self._shared_state:get_key("arena_belakor_node")
	local get_server = self._shared_state:get_server(get_key)

	return get_server == "" or not get_server or nil
end

DeusRunState.set_arena_belakor_node = function (self, arg_75_1)
	-- function 75
	local get_key = self._shared_state:get_key("arena_belakor_node")

	self._shared_state:set_server(get_key, arg_75_1)
end

DeusRunState.get_seen_arena_belakor_node = function (self, arg_76_1)
	-- function 76
	local get_key = self._shared_state:get_key("seen_arena_belakor_node", arg_76_1)
	local get_server = self._shared_state:get_server(get_key)

	return get_server == "" or not get_server or nil
end

DeusRunState.set_seen_arena_belakor_node = function (self, arg_77_1, arg_77_2)
	-- function 77
	local get_key = self._shared_state:get_key("seen_arena_belakor_node", arg_77_1)

	self._shared_state:set_server(get_key, arg_77_2)
end

DeusRunState.set_event_mutators = function (self, arg_78_1)
	-- function 78
	self._event_mutators = arg_78_1

	for i, v in ipairs(arg_78_1) do
		local packages = MutatorTemplates[v].packages

		if not packages then
			table.append(self._event_mutator_packages, packages)
		end
	end

	for i_2, v_2 in ipairs(self._event_mutator_packages) do
		Managers.package:load(v_2, "deus_run_state_mutator_package", nil, true)
	end
end

DeusRunState.get_event_mutators = function (self, arg_79_1)
	-- function 79
	return self._event_mutators
end

DeusRunState.is_weekly_event_packages_loaded = function (self)
	-- function 80
	for i, v in ipairs(self._event_mutator_packages) do
		if not Managers.package:has_loaded(v, "deus_run_state_mutator_package") then
			return false
		end
	end

	return true
end

DeusRunState.set_event_boons = function (self, arg_81_1)
	-- function 81
	local tbl = {}

	for i = 1, #arg_81_1 do
		local var_81_1 = arg_81_1[i]
		local rarity = DeusPowerUpsLookup[var_81_1].rarity

		tbl[#tbl + 1] = DeusPowerUpUtils.generate_specific_power_up(var_81_1, rarity)
	end

	self._event_boons = tbl
end

DeusRunState.get_event_boons = function (self, arg_82_1)
	-- function 82
	return self._event_boons
end

DeusRunState.get_granted_non_party_end_of_level_power_ups = function (self, arg_83_1, arg_83_2, arg_83_3, arg_83_4)
	-- function 83
	return self._shared_state:get_server(self._shared_state:get_key("granted_non_party_end_of_level_power_ups", arg_83_1, arg_83_2, arg_83_3, arg_83_4))
end

DeusRunState.set_granted_non_party_end_of_level_power_ups = function (self, arg_84_1, arg_84_2, arg_84_3, arg_84_4, arg_84_5)
	-- function 84
	self._shared_state:set_server(self._shared_state:get_key("granted_non_party_end_of_level_power_ups", arg_84_1, arg_84_2, arg_84_3, arg_84_4), arg_84_5)
end

DeusRunState.get_player_profile = function (self, arg_85_1, arg_85_2)
	-- function 85
	local profile_by_peer, var_85_1 = self._network_handler.profile_synchronizer:profile_by_peer(arg_85_1, arg_85_2)

	return profile_by_peer or 0, var_85_1 or 0
end

DeusRunState.get_player_level = function (self, arg_86_1)
	-- function 86
	return self._shared_state:get_peer(arg_86_1, self._shared_state:get_key("player_level"))
end

DeusRunState.set_own_player_level = function (self, arg_87_1)
	-- function 87
	self._shared_state:set_own(self._shared_state:get_key("player_level"), arg_87_1)
end

DeusRunState.get_versus_player_level = function (self, arg_88_1)
	-- function 88
	return self._shared_state:get_peer(arg_88_1, self._shared_state:get_key("versus_player_level"))
end

DeusRunState.set_own_versus_player_level = function (self, arg_89_1)
	-- function 89
	self._shared_state:set_own(self._shared_state:get_key("versus_player_level"), arg_89_1)
end

DeusRunState.get_player_name = function (self, arg_90_1)
	-- function 90
	return self._shared_state:get_peer(arg_90_1, self._shared_state:get_key("player_name"))
end

DeusRunState.set_own_player_name = function (self, arg_91_1)
	-- function 91
	self._shared_state:set_own(self._shared_state:get_key("player_name"), arg_91_1)
end

DeusRunState.get_player_frame = function (self, arg_92_1)
	-- function 92
	return self._shared_state:get_peer(arg_92_1, self._shared_state:get_key("player_frame"))
end

DeusRunState.set_own_player_frame = function (self, arg_93_1)
	-- function 93
	self._shared_state:set_own(self._shared_state:get_key("player_frame"), arg_93_1)
end

DeusRunState.get_player_spawned_once = function (self, arg_94_1, arg_94_2, arg_94_3, arg_94_4)
	-- function 94
	local get_key = self._shared_state:get_key("spawned_once", arg_94_1, arg_94_2, arg_94_3, arg_94_4)
	local get_server = self._shared_state:get_server(get_key)

	get_server = get_server or false

	return get_server
end

DeusRunState.set_player_spawned_once = function (self, arg_95_1, arg_95_2, arg_95_3, arg_95_4, arg_95_5)
	-- function 95
	local get_key = self._shared_state:get_key("spawned_once", arg_95_1, arg_95_2, arg_95_3, arg_95_4)

	self._shared_state:set_server(get_key, arg_95_5)
end

DeusRunState.get_player_power_ups = function (self, arg_96_1, arg_96_2, arg_96_3, arg_96_4)
	-- function 96
	local get_key = self._shared_state:get_key("power_ups", arg_96_1, arg_96_2, arg_96_3, arg_96_4)

	return self._shared_state:get_server(get_key)
end

DeusRunState.set_player_power_ups = function (self, arg_97_1, arg_97_2, arg_97_3, arg_97_4, arg_97_5)
	-- function 97
	local get_key = self._shared_state:get_key("power_ups", arg_97_1, arg_97_2, arg_97_3, arg_97_4)

	self._shared_state:set_server(get_key, arg_97_5)
end

DeusRunState.get_player_persistent_buffs = function (self, arg_98_1, arg_98_2, arg_98_3, arg_98_4)
	-- function 98
	local get_key = self._shared_state:get_key("persistent_buffs", arg_98_1, arg_98_2, arg_98_3, arg_98_4)

	return self._shared_state:get_server(get_key)
end

DeusRunState.set_player_persistent_buffs = function (self, arg_99_1, arg_99_2, arg_99_3, arg_99_4, arg_99_5)
	-- function 99
	local get_key = self._shared_state:get_key("persistent_buffs", arg_99_1, arg_99_2, arg_99_3, arg_99_4)

	self._shared_state:set_server(get_key, arg_99_5)
end

DeusRunState.get_player_soft_currency = function (self, arg_100_1, arg_100_2)
	-- function 100
	local get_key = self._shared_state:get_key("soft_currency", arg_100_1, arg_100_2)

	return self._shared_state:get_server(get_key)
end

DeusRunState.set_player_soft_currency = function (self, arg_101_1, arg_101_2, arg_101_3)
	-- function 101
	local get_key = self._shared_state:get_key("soft_currency", arg_101_1, arg_101_2)

	self._shared_state:set_server(get_key, arg_101_3)
end

DeusRunState.get_player_health_percentage = function (self, arg_102_1, arg_102_2, arg_102_3, arg_102_4)
	-- function 102
	local get_key = self._shared_state:get_key("health_percentage", arg_102_1, arg_102_2, arg_102_3, arg_102_4)

	return self._shared_state:get_server(get_key)
end

DeusRunState.set_player_health_percentage = function (self, arg_103_1, arg_103_2, arg_103_3, arg_103_4, arg_103_5)
	-- function 103
	local get_key = self._shared_state:get_key("health_percentage", arg_103_1, arg_103_2, arg_103_3, arg_103_4)

	self._shared_state:set_server(get_key, arg_103_5)
end

DeusRunState.get_player_health_state = function (self, arg_104_1, arg_104_2, arg_104_3, arg_104_4)
	-- function 104
	local get_key = self._shared_state:get_key("health_state", arg_104_1, arg_104_2, arg_104_3, arg_104_4)

	return self._shared_state:get_server(get_key)
end

DeusRunState.set_player_health_state = function (self, arg_105_1, arg_105_2, arg_105_3, arg_105_4, arg_105_5)
	-- function 105
	local get_key = self._shared_state:get_key("health_state", arg_105_1, arg_105_2, arg_105_3, arg_105_4)

	self._shared_state:set_server(get_key, arg_105_5)
end

DeusRunState.get_player_melee_ammo = function (self, arg_106_1, arg_106_2, arg_106_3, arg_106_4)
	-- function 106
	local get_key = self._shared_state:get_key("melee_ammo", arg_106_1, arg_106_2, arg_106_3, arg_106_4)

	return self._shared_state:get_server(get_key)
end

DeusRunState.set_player_melee_ammo = function (self, arg_107_1, arg_107_2, arg_107_3, arg_107_4, arg_107_5)
	-- function 107
	local get_key = self._shared_state:get_key("melee_ammo", arg_107_1, arg_107_2, arg_107_3, arg_107_4)

	self._shared_state:set_server(get_key, arg_107_5)
end

DeusRunState.get_player_ranged_ammo = function (self, arg_108_1, arg_108_2, arg_108_3, arg_108_4)
	-- function 108
	local get_key = self._shared_state:get_key("ranged_ammo", arg_108_1, arg_108_2, arg_108_3, arg_108_4)

	return self._shared_state:get_server(get_key)
end

DeusRunState.set_player_ranged_ammo = function (self, arg_109_1, arg_109_2, arg_109_3, arg_109_4, arg_109_5)
	-- function 109
	local get_key = self._shared_state:get_key("ranged_ammo", arg_109_1, arg_109_2, arg_109_3, arg_109_4)

	self._shared_state:set_server(get_key, arg_109_5)
end

DeusRunState.get_player_consumable_healthkit_slot = function (self, arg_110_1, arg_110_2, arg_110_3, arg_110_4)
	-- function 110
	local get_key = self._shared_state:get_key("healthkit", arg_110_1, arg_110_2, arg_110_3, arg_110_4)
	local get_server = self._shared_state:get_server(get_key)

	return get_server == "" or not get_server or nil
end

DeusRunState.set_player_consumable_healthkit_slot = function (self, arg_111_1, arg_111_2, arg_111_3, arg_111_4, arg_111_5)
	-- function 111
	local get_key = self._shared_state:get_key("healthkit", arg_111_1, arg_111_2, arg_111_3, arg_111_4)
	local flag = arg_111_5 or ""

	self._shared_state:set_server(get_key, flag)
end

DeusRunState.get_player_consumable_potion_slot = function (self, arg_112_1, arg_112_2, arg_112_3, arg_112_4)
	-- function 112
	local get_key = self._shared_state:get_key("potion", arg_112_1, arg_112_2, arg_112_3, arg_112_4)
	local get_server = self._shared_state:get_server(get_key)

	return get_server == "" or not get_server or nil
end

DeusRunState.set_player_consumable_potion_slot = function (self, arg_113_1, arg_113_2, arg_113_3, arg_113_4, arg_113_5)
	-- function 113
	local get_key = self._shared_state:get_key("potion", arg_113_1, arg_113_2, arg_113_3, arg_113_4)
	local flag = arg_113_5 or ""

	self._shared_state:set_server(get_key, flag)
end

DeusRunState.get_player_consumable_grenade_slot = function (self, arg_114_1, arg_114_2, arg_114_3, arg_114_4)
	-- function 114
	local get_key = self._shared_state:get_key("grenade", arg_114_1, arg_114_2, arg_114_3, arg_114_4)
	local get_server = self._shared_state:get_server(get_key)

	return get_server == "" or not get_server or nil
end

DeusRunState.set_player_consumable_grenade_slot = function (self, arg_115_1, arg_115_2, arg_115_3, arg_115_4, arg_115_5)
	-- function 115
	local get_key = self._shared_state:get_key("grenade", arg_115_1, arg_115_2, arg_115_3, arg_115_4)
	local flag = arg_115_5 or ""

	self._shared_state:set_server(get_key, flag)
end

DeusRunState.get_player_additional_items = function (self, arg_116_1, arg_116_2, arg_116_3, arg_116_4)
	-- function 116
	local get_key = self._shared_state:get_key("additional_items", arg_116_1, arg_116_2, arg_116_3, arg_116_4)

	return self._shared_state:get_server(get_key)
end

DeusRunState.set_player_additional_items = function (self, arg_117_1, arg_117_2, arg_117_3, arg_117_4, arg_117_5)
	-- function 117
	local get_key = self._shared_state:get_key("additional_items", arg_117_1, arg_117_2, arg_117_3, arg_117_4)

	self._shared_state:set_server(get_key, arg_117_5)
end

DeusRunState.get_player_loadout = function (self, arg_118_1, arg_118_2, arg_118_3, arg_118_4, arg_118_5)
	-- function 118
	local get_key = self._shared_state:get_key(arg_118_5, arg_118_1, arg_118_2, arg_118_3, arg_118_4)
	local get_server = self._shared_state:get_server(get_key)

	return get_server == "" or not get_server or nil
end

DeusRunState.set_player_loadout = function (self, arg_119_1, arg_119_2, arg_119_3, arg_119_4, arg_119_5, arg_119_6)
	-- function 119
	local get_key = self._shared_state:get_key(arg_119_5, arg_119_1, arg_119_2, arg_119_3, arg_119_4)

	self._shared_state:set_server(get_key, arg_119_6 or "")
end

DeusRunState.set_twitch_level_vote = function (self, arg_120_1)
	-- function 120
	self._shared_state:set_server(self._shared_state:get_key("twitch_vote"), arg_120_1 or "")
end

DeusRunState.get_twitch_level_vote = function (self)
	-- function 121
	local get_server = self._shared_state:get_server(self._shared_state:get_key("twitch_vote"))

	if get_server == "" then
		return nil
	else
		return get_server
	end
end

DeusRunState.set_scoreboard = function (self, arg_122_1)
	-- function 122
	self._scoreboard = arg_122_1
end

DeusRunState.get_scoreboard = function (self, arg_123_1)
	-- function 123
	return self._scoreboard
end

DeusRunState.set_persisted_score = function (self, arg_124_1, arg_124_2, arg_124_3)
	-- function 124
	local get_key = self._shared_state:get_key("persisted_score", arg_124_1, arg_124_2)

	self._shared_state:set_server(get_key, arg_124_3)
end

DeusRunState.get_persisted_score = function (self, arg_125_1, arg_125_2, arg_125_3)
	-- function 125
	local get_key = self._shared_state:get_key("persisted_score", arg_125_1, arg_125_2)

	return self._shared_state:get_server(get_key)
end

DeusRunState.set_own_weapon_pool_data = function (self, arg_126_1)
	-- function 126
	self._weapon_pool_data = arg_126_1
end

DeusRunState.get_own_weapon_pool_data = function (self)
	-- function 127
	return self._weapon_pool_data
end

DeusRunState.set_own_weapon_pool_excludes = function (self, arg_128_1)
	-- function 128
	self._weapon_pool_excludes = arg_128_1
end

DeusRunState.get_own_weapon_pool_excludes = function (self)
	-- function 129
	local _weapon_pool_excludes = self._weapon_pool_excludes

	_weapon_pool_excludes = _weapon_pool_excludes or {}

	return _weapon_pool_excludes
end

DeusRunState.get_player_telemetry_id = function (self, arg_130_1)
	-- function 130
	local get_key = self._shared_state:get_key("telemetry_id")

	return self._shared_state:get_peer(arg_130_1, get_key)
end

DeusRunState.set_own_player_telemetry_id = function (self, arg_131_1)
	-- function 131
	local get_key = self._shared_state:get_key("telemetry_id")

	self._shared_state:set_own(get_key, arg_131_1)
end
