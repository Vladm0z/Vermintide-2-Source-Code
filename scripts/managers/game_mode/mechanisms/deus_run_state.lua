-- chunkname: @scripts/managers/game_mode/mechanisms/deus_run_state.lua

require("scripts/helpers/deus_power_up_utils")
require("scripts/network/shared_state")

local var_0_0 = require("scripts/managers/game_mode/mechanisms/deus_run_state_spec")

DeusRunState = class(DeusRunState)

function DeusRunState.init(arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7, arg_1_8, arg_1_9, arg_1_10)
	arg_1_0._run_id = arg_1_1
	arg_1_0._is_server = arg_1_2
	arg_1_0._server_peer_id = arg_1_4
	arg_1_0._own_peer_id = arg_1_5
	arg_1_0._network_handler = arg_1_3
	arg_1_0._event_mutator_packages = {}

	local var_1_0 = "deus_run_state_" .. arg_1_1

	arg_1_0._shared_state = SharedState:new(var_1_0, var_0_0, arg_1_2, arg_1_3, arg_1_4, arg_1_5)
	arg_1_0._own_initial_loadout = arg_1_6
	arg_1_0._own_initial_talents = arg_1_7
	arg_1_0._own_initial_bot_loadout = arg_1_8
	arg_1_0._own_initial_bot_talents = arg_1_9
	arg_1_0._weapon_group_whitelist = arg_1_10
end

function DeusRunState.network_context_created(arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5)
	arg_2_0._is_server = arg_2_4
	arg_2_0._server_peer_id = arg_2_2
	arg_2_0._network_handler = arg_2_5

	arg_2_0._shared_state:network_context_created(arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5)
end

function DeusRunState.register_rpcs(arg_3_0, arg_3_1)
	arg_3_0._shared_state:register_rpcs(arg_3_1)
end

function DeusRunState.unregister_rpcs(arg_4_0)
	arg_4_0._shared_state:unregister_rpcs()
end

function DeusRunState.full_sync(arg_5_0)
	arg_5_0._shared_state:full_sync()
end

function DeusRunState.destroy(arg_6_0)
	arg_6_0:unregister_rpcs()
	arg_6_0._shared_state:destroy()

	for iter_6_0, iter_6_1 in ipairs(arg_6_0._event_mutator_packages) do
		Managers.package:unload(iter_6_1, "deus_run_state_mutator_package")
	end
end

function DeusRunState.get_revision(arg_7_0)
	return arg_7_0._shared_state:get_revision()
end

function DeusRunState.is_server(arg_8_0)
	return arg_8_0._is_server
end

function DeusRunState.get_server_peer_id(arg_9_0)
	return arg_9_0._server_peer_id
end

function DeusRunState.get_own_peer_id(arg_10_0)
	return arg_10_0._own_peer_id
end

function DeusRunState.get_own_initial_loadout(arg_11_0)
	return arg_11_0._own_initial_loadout
end

function DeusRunState.get_own_initial_talents(arg_12_0)
	return arg_12_0._own_initial_talents
end

function DeusRunState.get_own_initial_bot_loadout(arg_13_0)
	return arg_13_0._own_initial_bot_loadout
end

function DeusRunState.get_own_initial_bot_talents(arg_14_0)
	return arg_14_0._own_initial_bot_talents
end

function DeusRunState.get_weapon_group_whitelist(arg_15_0)
	return arg_15_0._weapon_group_whitelist
end

function DeusRunState.set_run_ended(arg_16_0, arg_16_1)
	arg_16_0._shared_state:set_server(arg_16_0._shared_state:get_key("run_ended"), arg_16_1)
end

function DeusRunState.get_run_ended(arg_17_0)
	return arg_17_0._shared_state:get_server(arg_17_0._shared_state:get_key("run_ended"))
end

function DeusRunState.set_run_seed(arg_18_0, arg_18_1)
	arg_18_0._run_seed = arg_18_1
end

function DeusRunState.set_run_difficulty(arg_19_0, arg_19_1)
	arg_19_0._difficulty = arg_19_1
end

function DeusRunState.get_run_difficulty(arg_20_0)
	return arg_20_0._difficulty
end

function DeusRunState.set_journey_name(arg_21_0, arg_21_1)
	arg_21_0._journey_name = arg_21_1
end

function DeusRunState.get_journey_name(arg_22_0)
	return arg_22_0._journey_name
end

function DeusRunState.set_dominant_god(arg_23_0, arg_23_1)
	arg_23_0._dominant_god = arg_23_1
end

function DeusRunState.get_dominant_god(arg_24_0)
	return arg_24_0._dominant_god
end

function DeusRunState.get_run_id(arg_25_0)
	return arg_25_0._run_id
end

function DeusRunState.get_run_seed(arg_26_0)
	return arg_26_0._run_seed
end

function DeusRunState.set_current_node_key(arg_27_0, arg_27_1)
	arg_27_0._shared_state:set_server(arg_27_0._shared_state:get_key("run_node_key"), arg_27_1)
end

function DeusRunState.get_current_node_key(arg_28_0)
	return arg_28_0._shared_state:get_server(arg_28_0._shared_state:get_key("run_node_key"))
end

function DeusRunState.get_completed_level_count(arg_29_0)
	return arg_29_0._shared_state:get_server(arg_29_0._shared_state:get_key("completed_level_count")) or 0
end

function DeusRunState.set_completed_level_count(arg_30_0, arg_30_1)
	arg_30_0._shared_state:set_server(arg_30_0._shared_state:get_key("completed_level_count"), arg_30_1)
end

function DeusRunState.get_traversed_nodes(arg_31_0)
	return arg_31_0._shared_state:get_server(arg_31_0._shared_state:get_key("traversed_nodes"))
end

function DeusRunState.set_traversed_nodes(arg_32_0, arg_32_1)
	arg_32_0._shared_state:set_server(arg_32_0._shared_state:get_key("traversed_nodes"), arg_32_1)
end

function DeusRunState.get_blessings(arg_33_0)
	local var_33_0 = arg_33_0._shared_state:get_server(arg_33_0._shared_state:get_key("blessings_with_buyer"))
	local var_33_1 = {}

	for iter_33_0, iter_33_1 in pairs(var_33_0) do
		var_33_1[#var_33_1 + 1] = iter_33_0
	end

	if script_data.deus_force_load_blessing then
		var_33_1[#var_33_1 + 1] = script_data.deus_force_load_blessing
	end

	return var_33_1
end

function DeusRunState.get_blessings_with_buyer(arg_34_0)
	return arg_34_0._shared_state:get_server(arg_34_0._shared_state:get_key("blessings_with_buyer"))
end

function DeusRunState.set_blessings_with_buyer(arg_35_0, arg_35_1)
	arg_35_0._shared_state:set_server(arg_35_0._shared_state:get_key("blessings_with_buyer"), arg_35_1)
end

function DeusRunState.get_blessing_lifetime(arg_36_0, arg_36_1)
	return arg_36_0._shared_state:get_server(arg_36_0._shared_state:get_key("blessing_lifetimes"))[arg_36_1] or 0
end

function DeusRunState.set_blessing_lifetime(arg_37_0, arg_37_1, arg_37_2)
	local var_37_0 = arg_37_0._shared_state:get_server(arg_37_0._shared_state:get_key("blessing_lifetimes"))
	local var_37_1 = true
	local var_37_2 = table.clone(var_37_0, var_37_1)

	var_37_2[arg_37_1] = arg_37_2

	arg_37_0._shared_state:set_server(arg_37_0._shared_state:get_key("blessing_lifetimes"), var_37_2)
end

function DeusRunState.get_peer_initialized(arg_38_0, arg_38_1)
	local var_38_0 = arg_38_0._shared_state:get_key("peer_initialized", arg_38_1)

	return arg_38_0._shared_state:get_server(var_38_0)
end

function DeusRunState.set_peer_initialized(arg_39_0, arg_39_1, arg_39_2)
	local var_39_0 = arg_39_0._shared_state:get_key("peer_initialized", arg_39_1)

	arg_39_0._shared_state:set_server(var_39_0, arg_39_2)
end

function DeusRunState.get_profile_initialized(arg_40_0, arg_40_1, arg_40_2, arg_40_3, arg_40_4)
	local var_40_0 = arg_40_0._shared_state:get_key("profile_initialized", arg_40_1, arg_40_2, arg_40_3, arg_40_4)

	return arg_40_0._shared_state:get_server(var_40_0)
end

function DeusRunState.set_profile_initialized(arg_41_0, arg_41_1, arg_41_2, arg_41_3, arg_41_4, arg_41_5)
	local var_41_0 = arg_41_0._shared_state:get_key("profile_initialized", arg_41_1, arg_41_2, arg_41_3, arg_41_4)

	arg_41_0._shared_state:set_server(var_41_0, arg_41_5)
end

function DeusRunState.get_cursed_levels_completed(arg_42_0, arg_42_1)
	local var_42_0 = arg_42_0._shared_state:get_key("cursed_levels_completed", arg_42_1)

	return arg_42_0._shared_state:get_server(var_42_0)
end

function DeusRunState.set_cursed_levels_completed(arg_43_0, arg_43_1, arg_43_2)
	local var_43_0 = arg_43_0._shared_state:get_key("cursed_levels_completed", arg_43_1)

	arg_43_0._shared_state:set_server(var_43_0, arg_43_2)
end

function DeusRunState.get_cursed_chests_purified(arg_44_0, arg_44_1)
	local var_44_0 = arg_44_0._shared_state:get_key("cursed_chests_purified", arg_44_1)

	return arg_44_0._shared_state:get_server(var_44_0)
end

function DeusRunState.set_cursed_chests_purified(arg_45_0, arg_45_1, arg_45_2)
	local var_45_0 = arg_45_0._shared_state:get_key("cursed_chests_purified", arg_45_1)

	arg_45_0._shared_state:set_server(var_45_0, arg_45_2)
end

function DeusRunState.get_coin_chests_collected(arg_46_0, arg_46_1)
	local var_46_0 = arg_46_0._shared_state:get_key("coin_chests_collected", arg_46_1)

	return arg_46_0._shared_state:get_server(var_46_0)
end

function DeusRunState.set_coin_chests_collected(arg_47_0, arg_47_1, arg_47_2)
	local var_47_0 = arg_47_0._shared_state:get_key("coin_chests_collected", arg_47_1)

	arg_47_0._shared_state:set_server(var_47_0, arg_47_2)
end

function DeusRunState.get_party_power_ups(arg_48_0)
	local var_48_0 = arg_48_0._shared_state:get_key("party_power_ups")

	return arg_48_0._shared_state:get_server(var_48_0)
end

function DeusRunState.set_party_power_ups(arg_49_0, arg_49_1)
	local var_49_0 = arg_49_0._shared_state:get_key("party_power_ups")

	arg_49_0._shared_state:set_server(var_49_0, arg_49_1)
end

function DeusRunState.get_bought_power_ups(arg_50_0)
	local var_50_0 = arg_50_0._shared_state:get_key("bought_power_ups")

	return arg_50_0._shared_state:get_server(var_50_0)
end

function DeusRunState.set_bought_power_ups(arg_51_0, arg_51_1)
	local var_51_0 = arg_51_0._shared_state:get_key("bought_power_ups")

	arg_51_0._shared_state:set_server(var_51_0, arg_51_1)
end

function DeusRunState.get_bought_blessings(arg_52_0)
	local var_52_0 = arg_52_0._shared_state:get_key("bought_blessings")

	return arg_52_0._shared_state:get_server(var_52_0)
end

function DeusRunState.set_bought_blessings(arg_53_0, arg_53_1)
	local var_53_0 = arg_53_0._shared_state:get_key("bought_blessings")

	arg_53_0._shared_state:set_server(var_53_0, arg_53_1)
end

function DeusRunState.get_ground_coins_picked_up(arg_54_0)
	local var_54_0 = arg_54_0._shared_state:get_key("ground_coins_picked_up")

	return arg_54_0._shared_state:get_server(var_54_0)
end

function DeusRunState.set_ground_coins_picked_up(arg_55_0, arg_55_1)
	local var_55_0 = arg_55_0._shared_state:get_key("ground_coins_picked_up")

	arg_55_0._shared_state:set_server(var_55_0, arg_55_1)
end

function DeusRunState.get_monster_coins_picked_up(arg_56_0)
	local var_56_0 = arg_56_0._shared_state:get_key("monster_coins_picked_up")

	return arg_56_0._shared_state:get_server(var_56_0)
end

function DeusRunState.set_monster_coins_picked_up(arg_57_0, arg_57_1)
	local var_57_0 = arg_57_0._shared_state:get_key("monster_coins_picked_up")

	arg_57_0._shared_state:set_server(var_57_0, arg_57_1)
end

function DeusRunState.get_coins_spent(arg_58_0)
	local var_58_0 = arg_58_0._shared_state:get_key("coins_spent")

	return arg_58_0._shared_state:get_server(var_58_0)
end

function DeusRunState.set_coins_spent(arg_59_0, arg_59_1)
	local var_59_0 = arg_59_0._shared_state:get_key("coins_spent")

	arg_59_0._shared_state:set_server(var_59_0, arg_59_1)
end

function DeusRunState.get_coins_earned(arg_60_0)
	local var_60_0 = arg_60_0._shared_state:get_key("coins_earned")

	return arg_60_0._shared_state:get_server(var_60_0)
end

function DeusRunState.set_coins_earned(arg_61_0, arg_61_1)
	local var_61_0 = arg_61_0._shared_state:get_key("coins_earned")

	arg_61_0._shared_state:set_server(var_61_0, arg_61_1)
end

function DeusRunState.get_melee_swap_chests_used(arg_62_0)
	local var_62_0 = arg_62_0._shared_state:get_key("melee_swap_chests_used")

	return arg_62_0._shared_state:get_server(var_62_0)
end

function DeusRunState.set_melee_swap_chests_used(arg_63_0, arg_63_1)
	local var_63_0 = arg_63_0._shared_state:get_key("melee_swap_chests_used")

	arg_63_0._shared_state:set_server(var_63_0, arg_63_1)
end

function DeusRunState.get_ranged_swap_chests_used(arg_64_0)
	local var_64_0 = arg_64_0._shared_state:get_key("ranged_swap_chests_used")

	return arg_64_0._shared_state:get_server(var_64_0)
end

function DeusRunState.set_ranged_swap_chests_used(arg_65_0, arg_65_1)
	local var_65_0 = arg_65_0._shared_state:get_key("ranged_swap_chests_used")

	arg_65_0._shared_state:set_server(var_65_0, arg_65_1)
end

function DeusRunState.get_upgrade_chests_used(arg_66_0)
	local var_66_0 = arg_66_0._shared_state:get_key("upgrade_chests_used")

	return arg_66_0._shared_state:get_server(var_66_0)
end

function DeusRunState.set_upgrade_chests_used(arg_67_0, arg_67_1)
	local var_67_0 = arg_67_0._shared_state:get_key("upgrade_chests_used")

	arg_67_0._shared_state:set_server(var_67_0, arg_67_1)
end

function DeusRunState.get_power_up_chests_used(arg_68_0)
	local var_68_0 = arg_68_0._shared_state:get_key("power_up_chests_used")

	return arg_68_0._shared_state:get_server(var_68_0)
end

function DeusRunState.set_power_up_chests_used(arg_69_0, arg_69_1)
	local var_69_0 = arg_69_0._shared_state:get_key("power_up_chests_used")

	arg_69_0._shared_state:set_server(var_69_0, arg_69_1)
end

function DeusRunState.get_host_migration_count(arg_70_0)
	local var_70_0 = arg_70_0._shared_state:get_key("host_migration_count")

	return arg_70_0._shared_state:get_server(var_70_0)
end

function DeusRunState.set_host_migration_count(arg_71_0, arg_71_1)
	local var_71_0 = arg_71_0._shared_state:get_key("host_migration_count")

	arg_71_0._shared_state:set_server(var_71_0, arg_71_1)
end

function DeusRunState.get_belakor_enabled(arg_72_0)
	return arg_72_0._belakor_enabled
end

function DeusRunState.set_belakor_enabled(arg_73_0, arg_73_1)
	arg_73_0._belakor_enabled = arg_73_1
end

function DeusRunState.get_arena_belakor_node(arg_74_0)
	local var_74_0 = arg_74_0._shared_state:get_key("arena_belakor_node")
	local var_74_1 = arg_74_0._shared_state:get_server(var_74_0)

	return var_74_1 ~= "" and var_74_1 or nil
end

function DeusRunState.set_arena_belakor_node(arg_75_0, arg_75_1)
	local var_75_0 = arg_75_0._shared_state:get_key("arena_belakor_node")

	arg_75_0._shared_state:set_server(var_75_0, arg_75_1)
end

function DeusRunState.get_seen_arena_belakor_node(arg_76_0, arg_76_1)
	local var_76_0 = arg_76_0._shared_state:get_key("seen_arena_belakor_node", arg_76_1)
	local var_76_1 = arg_76_0._shared_state:get_server(var_76_0)

	return var_76_1 ~= "" and var_76_1 or nil
end

function DeusRunState.set_seen_arena_belakor_node(arg_77_0, arg_77_1, arg_77_2)
	local var_77_0 = arg_77_0._shared_state:get_key("seen_arena_belakor_node", arg_77_1)

	arg_77_0._shared_state:set_server(var_77_0, arg_77_2)
end

function DeusRunState.set_event_mutators(arg_78_0, arg_78_1)
	arg_78_0._event_mutators = arg_78_1

	for iter_78_0, iter_78_1 in ipairs(arg_78_1) do
		local var_78_0 = MutatorTemplates[iter_78_1].packages

		if var_78_0 then
			table.append(arg_78_0._event_mutator_packages, var_78_0)
		end
	end

	for iter_78_2, iter_78_3 in ipairs(arg_78_0._event_mutator_packages) do
		Managers.package:load(iter_78_3, "deus_run_state_mutator_package", nil, true)
	end
end

function DeusRunState.get_event_mutators(arg_79_0, arg_79_1)
	return arg_79_0._event_mutators
end

function DeusRunState.is_weekly_event_packages_loaded(arg_80_0)
	for iter_80_0, iter_80_1 in ipairs(arg_80_0._event_mutator_packages) do
		if not Managers.package:has_loaded(iter_80_1, "deus_run_state_mutator_package") then
			return false
		end
	end

	return true
end

function DeusRunState.set_event_boons(arg_81_0, arg_81_1)
	local var_81_0 = {}

	for iter_81_0 = 1, #arg_81_1 do
		local var_81_1 = arg_81_1[iter_81_0]
		local var_81_2 = DeusPowerUpsLookup[var_81_1].rarity

		var_81_0[#var_81_0 + 1] = DeusPowerUpUtils.generate_specific_power_up(var_81_1, var_81_2)
	end

	arg_81_0._event_boons = var_81_0
end

function DeusRunState.get_event_boons(arg_82_0, arg_82_1)
	return arg_82_0._event_boons
end

function DeusRunState.get_granted_non_party_end_of_level_power_ups(arg_83_0, arg_83_1, arg_83_2, arg_83_3, arg_83_4)
	return arg_83_0._shared_state:get_server(arg_83_0._shared_state:get_key("granted_non_party_end_of_level_power_ups", arg_83_1, arg_83_2, arg_83_3, arg_83_4))
end

function DeusRunState.set_granted_non_party_end_of_level_power_ups(arg_84_0, arg_84_1, arg_84_2, arg_84_3, arg_84_4, arg_84_5)
	arg_84_0._shared_state:set_server(arg_84_0._shared_state:get_key("granted_non_party_end_of_level_power_ups", arg_84_1, arg_84_2, arg_84_3, arg_84_4), arg_84_5)
end

function DeusRunState.get_player_profile(arg_85_0, arg_85_1, arg_85_2)
	local var_85_0, var_85_1 = arg_85_0._network_handler.profile_synchronizer:profile_by_peer(arg_85_1, arg_85_2)

	return var_85_0 or 0, var_85_1 or 0
end

function DeusRunState.get_player_level(arg_86_0, arg_86_1)
	return arg_86_0._shared_state:get_peer(arg_86_1, arg_86_0._shared_state:get_key("player_level"))
end

function DeusRunState.set_own_player_level(arg_87_0, arg_87_1)
	arg_87_0._shared_state:set_own(arg_87_0._shared_state:get_key("player_level"), arg_87_1)
end

function DeusRunState.get_versus_player_level(arg_88_0, arg_88_1)
	return arg_88_0._shared_state:get_peer(arg_88_1, arg_88_0._shared_state:get_key("versus_player_level"))
end

function DeusRunState.set_own_versus_player_level(arg_89_0, arg_89_1)
	arg_89_0._shared_state:set_own(arg_89_0._shared_state:get_key("versus_player_level"), arg_89_1)
end

function DeusRunState.get_player_name(arg_90_0, arg_90_1)
	return arg_90_0._shared_state:get_peer(arg_90_1, arg_90_0._shared_state:get_key("player_name"))
end

function DeusRunState.set_own_player_name(arg_91_0, arg_91_1)
	arg_91_0._shared_state:set_own(arg_91_0._shared_state:get_key("player_name"), arg_91_1)
end

function DeusRunState.get_player_frame(arg_92_0, arg_92_1)
	return arg_92_0._shared_state:get_peer(arg_92_1, arg_92_0._shared_state:get_key("player_frame"))
end

function DeusRunState.set_own_player_frame(arg_93_0, arg_93_1)
	arg_93_0._shared_state:set_own(arg_93_0._shared_state:get_key("player_frame"), arg_93_1)
end

function DeusRunState.get_player_spawned_once(arg_94_0, arg_94_1, arg_94_2, arg_94_3, arg_94_4)
	local var_94_0 = arg_94_0._shared_state:get_key("spawned_once", arg_94_1, arg_94_2, arg_94_3, arg_94_4)

	return arg_94_0._shared_state:get_server(var_94_0) or false
end

function DeusRunState.set_player_spawned_once(arg_95_0, arg_95_1, arg_95_2, arg_95_3, arg_95_4, arg_95_5)
	local var_95_0 = arg_95_0._shared_state:get_key("spawned_once", arg_95_1, arg_95_2, arg_95_3, arg_95_4)

	arg_95_0._shared_state:set_server(var_95_0, arg_95_5)
end

function DeusRunState.get_player_power_ups(arg_96_0, arg_96_1, arg_96_2, arg_96_3, arg_96_4)
	local var_96_0 = arg_96_0._shared_state:get_key("power_ups", arg_96_1, arg_96_2, arg_96_3, arg_96_4)

	return arg_96_0._shared_state:get_server(var_96_0)
end

function DeusRunState.set_player_power_ups(arg_97_0, arg_97_1, arg_97_2, arg_97_3, arg_97_4, arg_97_5)
	local var_97_0 = arg_97_0._shared_state:get_key("power_ups", arg_97_1, arg_97_2, arg_97_3, arg_97_4)

	arg_97_0._shared_state:set_server(var_97_0, arg_97_5)
end

function DeusRunState.get_player_persistent_buffs(arg_98_0, arg_98_1, arg_98_2, arg_98_3, arg_98_4)
	local var_98_0 = arg_98_0._shared_state:get_key("persistent_buffs", arg_98_1, arg_98_2, arg_98_3, arg_98_4)

	return arg_98_0._shared_state:get_server(var_98_0)
end

function DeusRunState.set_player_persistent_buffs(arg_99_0, arg_99_1, arg_99_2, arg_99_3, arg_99_4, arg_99_5)
	local var_99_0 = arg_99_0._shared_state:get_key("persistent_buffs", arg_99_1, arg_99_2, arg_99_3, arg_99_4)

	arg_99_0._shared_state:set_server(var_99_0, arg_99_5)
end

function DeusRunState.get_player_soft_currency(arg_100_0, arg_100_1, arg_100_2)
	local var_100_0 = arg_100_0._shared_state:get_key("soft_currency", arg_100_1, arg_100_2)

	return arg_100_0._shared_state:get_server(var_100_0)
end

function DeusRunState.set_player_soft_currency(arg_101_0, arg_101_1, arg_101_2, arg_101_3)
	local var_101_0 = arg_101_0._shared_state:get_key("soft_currency", arg_101_1, arg_101_2)

	arg_101_0._shared_state:set_server(var_101_0, arg_101_3)
end

function DeusRunState.get_player_health_percentage(arg_102_0, arg_102_1, arg_102_2, arg_102_3, arg_102_4)
	local var_102_0 = arg_102_0._shared_state:get_key("health_percentage", arg_102_1, arg_102_2, arg_102_3, arg_102_4)

	return arg_102_0._shared_state:get_server(var_102_0)
end

function DeusRunState.set_player_health_percentage(arg_103_0, arg_103_1, arg_103_2, arg_103_3, arg_103_4, arg_103_5)
	local var_103_0 = arg_103_0._shared_state:get_key("health_percentage", arg_103_1, arg_103_2, arg_103_3, arg_103_4)

	arg_103_0._shared_state:set_server(var_103_0, arg_103_5)
end

function DeusRunState.get_player_health_state(arg_104_0, arg_104_1, arg_104_2, arg_104_3, arg_104_4)
	local var_104_0 = arg_104_0._shared_state:get_key("health_state", arg_104_1, arg_104_2, arg_104_3, arg_104_4)

	return arg_104_0._shared_state:get_server(var_104_0)
end

function DeusRunState.set_player_health_state(arg_105_0, arg_105_1, arg_105_2, arg_105_3, arg_105_4, arg_105_5)
	local var_105_0 = arg_105_0._shared_state:get_key("health_state", arg_105_1, arg_105_2, arg_105_3, arg_105_4)

	arg_105_0._shared_state:set_server(var_105_0, arg_105_5)
end

function DeusRunState.get_player_melee_ammo(arg_106_0, arg_106_1, arg_106_2, arg_106_3, arg_106_4)
	local var_106_0 = arg_106_0._shared_state:get_key("melee_ammo", arg_106_1, arg_106_2, arg_106_3, arg_106_4)

	return arg_106_0._shared_state:get_server(var_106_0)
end

function DeusRunState.set_player_melee_ammo(arg_107_0, arg_107_1, arg_107_2, arg_107_3, arg_107_4, arg_107_5)
	local var_107_0 = arg_107_0._shared_state:get_key("melee_ammo", arg_107_1, arg_107_2, arg_107_3, arg_107_4)

	arg_107_0._shared_state:set_server(var_107_0, arg_107_5)
end

function DeusRunState.get_player_ranged_ammo(arg_108_0, arg_108_1, arg_108_2, arg_108_3, arg_108_4)
	local var_108_0 = arg_108_0._shared_state:get_key("ranged_ammo", arg_108_1, arg_108_2, arg_108_3, arg_108_4)

	return arg_108_0._shared_state:get_server(var_108_0)
end

function DeusRunState.set_player_ranged_ammo(arg_109_0, arg_109_1, arg_109_2, arg_109_3, arg_109_4, arg_109_5)
	local var_109_0 = arg_109_0._shared_state:get_key("ranged_ammo", arg_109_1, arg_109_2, arg_109_3, arg_109_4)

	arg_109_0._shared_state:set_server(var_109_0, arg_109_5)
end

function DeusRunState.get_player_consumable_healthkit_slot(arg_110_0, arg_110_1, arg_110_2, arg_110_3, arg_110_4)
	local var_110_0 = arg_110_0._shared_state:get_key("healthkit", arg_110_1, arg_110_2, arg_110_3, arg_110_4)
	local var_110_1 = arg_110_0._shared_state:get_server(var_110_0)

	return var_110_1 ~= "" and var_110_1 or nil
end

function DeusRunState.set_player_consumable_healthkit_slot(arg_111_0, arg_111_1, arg_111_2, arg_111_3, arg_111_4, arg_111_5)
	local var_111_0 = arg_111_0._shared_state:get_key("healthkit", arg_111_1, arg_111_2, arg_111_3, arg_111_4)
	local var_111_1 = arg_111_5 or ""

	arg_111_0._shared_state:set_server(var_111_0, var_111_1)
end

function DeusRunState.get_player_consumable_potion_slot(arg_112_0, arg_112_1, arg_112_2, arg_112_3, arg_112_4)
	local var_112_0 = arg_112_0._shared_state:get_key("potion", arg_112_1, arg_112_2, arg_112_3, arg_112_4)
	local var_112_1 = arg_112_0._shared_state:get_server(var_112_0)

	return var_112_1 ~= "" and var_112_1 or nil
end

function DeusRunState.set_player_consumable_potion_slot(arg_113_0, arg_113_1, arg_113_2, arg_113_3, arg_113_4, arg_113_5)
	local var_113_0 = arg_113_0._shared_state:get_key("potion", arg_113_1, arg_113_2, arg_113_3, arg_113_4)
	local var_113_1 = arg_113_5 or ""

	arg_113_0._shared_state:set_server(var_113_0, var_113_1)
end

function DeusRunState.get_player_consumable_grenade_slot(arg_114_0, arg_114_1, arg_114_2, arg_114_3, arg_114_4)
	local var_114_0 = arg_114_0._shared_state:get_key("grenade", arg_114_1, arg_114_2, arg_114_3, arg_114_4)
	local var_114_1 = arg_114_0._shared_state:get_server(var_114_0)

	return var_114_1 ~= "" and var_114_1 or nil
end

function DeusRunState.set_player_consumable_grenade_slot(arg_115_0, arg_115_1, arg_115_2, arg_115_3, arg_115_4, arg_115_5)
	local var_115_0 = arg_115_0._shared_state:get_key("grenade", arg_115_1, arg_115_2, arg_115_3, arg_115_4)
	local var_115_1 = arg_115_5 or ""

	arg_115_0._shared_state:set_server(var_115_0, var_115_1)
end

function DeusRunState.get_player_additional_items(arg_116_0, arg_116_1, arg_116_2, arg_116_3, arg_116_4)
	local var_116_0 = arg_116_0._shared_state:get_key("additional_items", arg_116_1, arg_116_2, arg_116_3, arg_116_4)

	return arg_116_0._shared_state:get_server(var_116_0)
end

function DeusRunState.set_player_additional_items(arg_117_0, arg_117_1, arg_117_2, arg_117_3, arg_117_4, arg_117_5)
	local var_117_0 = arg_117_0._shared_state:get_key("additional_items", arg_117_1, arg_117_2, arg_117_3, arg_117_4)

	arg_117_0._shared_state:set_server(var_117_0, arg_117_5)
end

function DeusRunState.get_player_loadout(arg_118_0, arg_118_1, arg_118_2, arg_118_3, arg_118_4, arg_118_5)
	local var_118_0 = arg_118_0._shared_state:get_key(arg_118_5, arg_118_1, arg_118_2, arg_118_3, arg_118_4)
	local var_118_1 = arg_118_0._shared_state:get_server(var_118_0)

	return var_118_1 ~= "" and var_118_1 or nil
end

function DeusRunState.set_player_loadout(arg_119_0, arg_119_1, arg_119_2, arg_119_3, arg_119_4, arg_119_5, arg_119_6)
	local var_119_0 = arg_119_0._shared_state:get_key(arg_119_5, arg_119_1, arg_119_2, arg_119_3, arg_119_4)

	arg_119_0._shared_state:set_server(var_119_0, arg_119_6 or "")
end

function DeusRunState.set_twitch_level_vote(arg_120_0, arg_120_1)
	arg_120_0._shared_state:set_server(arg_120_0._shared_state:get_key("twitch_vote"), arg_120_1 or "")
end

function DeusRunState.get_twitch_level_vote(arg_121_0)
	local var_121_0 = arg_121_0._shared_state:get_server(arg_121_0._shared_state:get_key("twitch_vote"))

	if var_121_0 == "" then
		return nil
	else
		return var_121_0
	end
end

function DeusRunState.set_scoreboard(arg_122_0, arg_122_1)
	arg_122_0._scoreboard = arg_122_1
end

function DeusRunState.get_scoreboard(arg_123_0, arg_123_1)
	return arg_123_0._scoreboard
end

function DeusRunState.set_persisted_score(arg_124_0, arg_124_1, arg_124_2, arg_124_3)
	local var_124_0 = arg_124_0._shared_state:get_key("persisted_score", arg_124_1, arg_124_2)

	arg_124_0._shared_state:set_server(var_124_0, arg_124_3)
end

function DeusRunState.get_persisted_score(arg_125_0, arg_125_1, arg_125_2, arg_125_3)
	local var_125_0 = arg_125_0._shared_state:get_key("persisted_score", arg_125_1, arg_125_2)

	return arg_125_0._shared_state:get_server(var_125_0)
end

function DeusRunState.set_own_weapon_pool_data(arg_126_0, arg_126_1)
	arg_126_0._weapon_pool_data = arg_126_1
end

function DeusRunState.get_own_weapon_pool_data(arg_127_0)
	return arg_127_0._weapon_pool_data
end

function DeusRunState.set_own_weapon_pool_excludes(arg_128_0, arg_128_1)
	arg_128_0._weapon_pool_excludes = arg_128_1
end

function DeusRunState.get_own_weapon_pool_excludes(arg_129_0)
	return arg_129_0._weapon_pool_excludes or {}
end

function DeusRunState.get_player_telemetry_id(arg_130_0, arg_130_1)
	local var_130_0 = arg_130_0._shared_state:get_key("telemetry_id")

	return arg_130_0._shared_state:get_peer(arg_130_1, var_130_0)
end

function DeusRunState.set_own_player_telemetry_id(arg_131_0, arg_131_1)
	local var_131_0 = arg_131_0._shared_state:get_key("telemetry_id")

	arg_131_0._shared_state:set_own(var_131_0, arg_131_1)
end
