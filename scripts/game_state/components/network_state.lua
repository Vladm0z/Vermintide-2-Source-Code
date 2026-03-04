-- chunkname: @scripts/game_state/components/network_state.lua

require("scripts/network/shared_state")

local var_0_0 = require("scripts/game_state/components/network_state_spec")

NetworkState = class(NetworkState)

function NetworkState.init(arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4)
	arg_1_0._shared_state = SharedState:new("network_state_" .. arg_1_3, var_0_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4)
	arg_1_0._loaded_or_loading_packages = {}
	arg_1_0._loaded_or_loading_package_peers = {}
	arg_1_0._is_server = arg_1_1
	arg_1_0._server_peer_id = arg_1_3
	arg_1_0._own_peer_id = arg_1_4

	local var_1_0 = arg_1_0._shared_state:get_key("peers")

	if arg_1_1 then
		arg_1_0._shared_state:set_server(var_1_0, {
			arg_1_3
		})
	else
		arg_1_0._shared_state:set_server(var_1_0, {
			arg_1_3,
			arg_1_4
		})
	end
end

function NetworkState.register_callback(arg_2_0, arg_2_1, arg_2_2, arg_2_3, ...)
	arg_2_0._shared_state:register_callback(arg_2_1, arg_2_2, arg_2_3, ...)
end

function NetworkState.unregister_callback(arg_3_0, arg_3_1, arg_3_2)
	arg_3_0._shared_state:unregister_callback(arg_3_1, arg_3_2)
end

function NetworkState.full_sync(arg_4_0)
	arg_4_0._shared_state:full_sync()
end

function NetworkState.register_rpcs(arg_5_0, arg_5_1, arg_5_2)
	arg_5_0._shared_state:register_rpcs(arg_5_1)
end

function NetworkState.unregister_network_events(arg_6_0)
	arg_6_0._shared_state:unregister_rpcs()
end

function NetworkState.destroy(arg_7_0)
	arg_7_0._shared_state:destroy()

	arg_7_0._shared_state = nil
end

function NetworkState.get_revision(arg_8_0)
	return arg_8_0._shared_state:get_revision()
end

function NetworkState.is_peer_fully_synced(arg_9_0, arg_9_1)
	return arg_9_0._shared_state:is_peer_fully_synced(arg_9_1)
end

function NetworkState.is_fully_synced(arg_10_0)
	return arg_10_0:is_peer_fully_synced(arg_10_0._own_peer_id)
end

function NetworkState.is_server(arg_11_0)
	return arg_11_0._is_server
end

function NetworkState.get_server_peer_id(arg_12_0)
	return arg_12_0._server_peer_id
end

function NetworkState.get_own_peer_id(arg_13_0)
	return arg_13_0._own_peer_id
end

function NetworkState.get_peers(arg_14_0)
	local var_14_0 = arg_14_0._shared_state:get_key("peers")

	return arg_14_0._shared_state:get_server(var_14_0)
end

function NetworkState.add_peer(arg_15_0, arg_15_1)
	local var_15_0 = arg_15_0._shared_state:get_key("peers")
	local var_15_1 = arg_15_0._shared_state:get_server(var_15_0)

	if not table.contains(var_15_1, arg_15_1) then
		local var_15_2 = true
		local var_15_3 = table.clone(var_15_1, var_15_2)

		var_15_3[#var_15_3 + 1] = arg_15_1

		arg_15_0._shared_state:set_server(var_15_0, var_15_3)
	end
end

function NetworkState.remove_peer(arg_16_0, arg_16_1)
	local var_16_0 = arg_16_0._shared_state:get_key("peers")
	local var_16_1 = arg_16_0._shared_state:get_server(var_16_0)
	local var_16_2 = table.index_of(var_16_1, arg_16_1)

	if var_16_2 ~= -1 then
		local var_16_3 = true
		local var_16_4 = table.clone(var_16_1, var_16_3)

		table.swap_delete(var_16_4, var_16_2)
		arg_16_0._shared_state:set_server(var_16_0, var_16_4)
	end
end

function NetworkState.get_peer_initialized(arg_17_0, arg_17_1)
	local var_17_0 = arg_17_0._shared_state:get_key("peer_initialized", arg_17_1)

	return arg_17_0._shared_state:get_server(var_17_0)
end

function NetworkState.set_peer_initialized(arg_18_0, arg_18_1, arg_18_2)
	local var_18_0 = arg_18_0._shared_state:get_key("peer_initialized", arg_18_1)

	return arg_18_0._shared_state:set_server(var_18_0, arg_18_2)
end

function NetworkState.get_level_key(arg_19_0)
	local var_19_0 = arg_19_0._shared_state:get_key("level_key")

	return arg_19_0._shared_state:get_server(var_19_0)
end

function NetworkState.get_level_seed(arg_20_0)
	local var_20_0 = arg_20_0._shared_state:get_key("level_seed")

	return arg_20_0._shared_state:get_server(var_20_0)
end

function NetworkState.get_conflict_director(arg_21_0)
	local var_21_0 = arg_21_0._shared_state:get_key("conflict_director")

	return arg_21_0._shared_state:get_server(var_21_0)
end

function NetworkState.get_game_mode(arg_22_0)
	local var_22_0 = arg_22_0._shared_state:get_key("game_mode")

	return arg_22_0._shared_state:get_server(var_22_0)
end

function NetworkState.get_environment_variation_id(arg_23_0)
	local var_23_0 = arg_23_0._shared_state:get_key("environment_variation_id")

	return arg_23_0._shared_state:get_server(var_23_0)
end

function NetworkState.get_locked_director_functions(arg_24_0)
	local var_24_0 = arg_24_0._shared_state:get_key("locked_director_functions")

	return arg_24_0._shared_state:get_server(var_24_0)
end

function NetworkState.get_difficulty(arg_25_0)
	local var_25_0 = arg_25_0._shared_state:get_key("difficulty")

	return arg_25_0._shared_state:get_server(var_25_0)
end

function NetworkState.get_difficulty_tweak(arg_26_0)
	local var_26_0 = arg_26_0._shared_state:get_key("difficulty_tweak")

	return arg_26_0._shared_state:get_server(var_26_0)
end

function NetworkState.get_extra_packages(arg_27_0)
	local var_27_0 = arg_27_0._shared_state:get_key("extra_packages")

	return arg_27_0._shared_state:get_server(var_27_0)
end

function NetworkState.get_mechanism(arg_28_0)
	local var_28_0 = arg_28_0._shared_state:get_key("mechanism")

	return arg_28_0._shared_state:get_server(var_28_0)
end

function NetworkState.get_level_session_id(arg_29_0)
	local var_29_0 = arg_29_0._shared_state:get_key("level_session_id")

	return arg_29_0._shared_state:get_server(var_29_0)
end

function NetworkState.get_level_transition_type(arg_30_0)
	local var_30_0 = arg_30_0._shared_state:get_key("level_transition_type")

	return arg_30_0._shared_state:get_server(var_30_0)
end

function NetworkState.set_level_data(arg_31_0, arg_31_1, arg_31_2, arg_31_3, arg_31_4, arg_31_5, arg_31_6, arg_31_7, arg_31_8, arg_31_9, arg_31_10, arg_31_11, arg_31_12)
	local var_31_0 = arg_31_0._shared_state

	var_31_0:start_atomic_set_server("set_level_data")
	var_31_0:set_server(var_31_0:get_key("level_key"), arg_31_1)
	var_31_0:set_server(var_31_0:get_key("level_seed"), arg_31_3)
	var_31_0:set_server(var_31_0:get_key("conflict_director"), arg_31_6)
	var_31_0:set_server(var_31_0:get_key("locked_director_functions"), arg_31_7)
	var_31_0:set_server(var_31_0:get_key("game_mode"), arg_31_5)
	var_31_0:set_server(var_31_0:get_key("mechanism"), arg_31_4)
	var_31_0:set_server(var_31_0:get_key("environment_variation_id"), arg_31_2)
	var_31_0:set_server(var_31_0:get_key("difficulty"), arg_31_8)
	var_31_0:set_server(var_31_0:get_key("difficulty_tweak"), arg_31_9)
	var_31_0:set_server(var_31_0:get_key("level_session_id"), arg_31_10)
	var_31_0:set_server(var_31_0:get_key("level_transition_type"), arg_31_11)
	var_31_0:set_server(var_31_0:get_key("extra_packages"), arg_31_12)
	var_31_0:end_atomic_set_server("set_level_data")
end

function NetworkState.is_peer_ingame(arg_32_0, arg_32_1)
	local var_32_0 = arg_32_0._shared_state:get_key("peer_ingame", arg_32_1)

	return arg_32_0._shared_state:get_server(var_32_0)
end

function NetworkState.set_peer_ingame(arg_33_0, arg_33_1, arg_33_2)
	local var_33_0 = arg_33_0._shared_state:get_key("peer_ingame", arg_33_1)

	arg_33_0._shared_state:set_server(var_33_0, arg_33_2)
end

function NetworkState.is_peer_hot_join_synced(arg_34_0, arg_34_1)
	local var_34_0 = arg_34_0._shared_state:get_key("peer_hot_join_synced", arg_34_1)

	return arg_34_0._shared_state:get_server(var_34_0)
end

function NetworkState.set_peer_hot_join_synced(arg_35_0, arg_35_1, arg_35_2)
	local var_35_0 = arg_35_0._shared_state:get_key("peer_hot_join_synced", arg_35_1)

	return arg_35_0._shared_state:set_server(var_35_0, arg_35_2)
end

function NetworkState.get_loaded_or_loading_packages(arg_36_0)
	return arg_36_0._loaded_or_loading_packages
end

function NetworkState.set_loaded_or_loading_packages(arg_37_0, arg_37_1)
	arg_37_0._loaded_or_loading_packages = arg_37_1
end

function NetworkState.loaded_or_loading_package_peers(arg_38_0)
	return arg_38_0._loaded_or_loading_package_peers
end

function NetworkState.set_loaded_or_loading_package_peers(arg_39_0, arg_39_1)
	arg_39_0._loaded_or_loading_package_peers = arg_39_1
end

function NetworkState.get_profile_index_reservation(arg_40_0, arg_40_1, arg_40_2)
	local var_40_0 = arg_40_0._shared_state:get_key("profile_index_reservation", nil, nil, arg_40_2, nil, arg_40_1)
	local var_40_1 = arg_40_0._shared_state:get_server(var_40_0)

	return var_40_1 ~= "" and var_40_1 or nil
end

function NetworkState.set_profile_index_reservation(arg_41_0, arg_41_1, arg_41_2, arg_41_3, arg_41_4)
	local var_41_0 = arg_41_0._shared_state:get_key("profile_index_reservation", nil, nil, arg_41_2, nil, arg_41_1)

	arg_41_0._shared_state:set_server(var_41_0, arg_41_4 or "")

	if arg_41_4 and arg_41_4 ~= "" then
		local var_41_1 = arg_41_0._shared_state:get_key("persistent_hero_reservation", arg_41_4)
		local var_41_2 = arg_41_0._shared_state:get_server(var_41_1)
		local var_41_3 = var_41_2.profile_index
		local var_41_4 = var_41_2.career_index
		local var_41_5 = var_41_2.party_id

		if var_41_3 ~= arg_41_2 or var_41_4 ~= arg_41_3 or var_41_5 ~= arg_41_1 then
			arg_41_0._shared_state:set_server(var_41_1, {
				profile_index = arg_41_2,
				career_index = arg_41_3,
				party_id = arg_41_1
			})
		end
	end
end

function NetworkState.clear_persistent_profile_index_reservation(arg_42_0, arg_42_1)
	local var_42_0 = arg_42_0._shared_state:get_key("persistent_hero_reservation", arg_42_1)

	arg_42_0._shared_state:set_server(var_42_0, {
		profile_index = 0,
		career_index = 0,
		party_id = 0
	})
end

function NetworkState.set_bot_profile(arg_43_0, arg_43_1, arg_43_2, arg_43_3, arg_43_4)
	local var_43_0 = arg_43_0._shared_state:get_key("bot_profile", nil, arg_43_2, nil, nil, arg_43_1)
	local var_43_1 = arg_43_0._shared_state:get_server(var_43_0)

	if var_43_1.profile_index ~= arg_43_3 or var_43_1.career_index ~= arg_43_4 then
		arg_43_0._shared_state:set_server(var_43_0, {
			profile_index = arg_43_3,
			career_index = arg_43_4
		})
	end
end

function NetworkState.get_bot_profile(arg_44_0, arg_44_1, arg_44_2)
	local var_44_0 = arg_44_0._shared_state:get_key("bot_profile", nil, arg_44_2, nil, nil, arg_44_1)
	local var_44_1 = arg_44_0._shared_state:get_server(var_44_0)

	return var_44_1.profile_index, var_44_1.career_index
end

function NetworkState.get_persistent_profile_index_reservation(arg_45_0, arg_45_1)
	local var_45_0 = arg_45_0._shared_state:get_key("persistent_hero_reservation", arg_45_1)
	local var_45_1 = arg_45_0._shared_state:get_server(var_45_0)

	return var_45_1.profile_index, var_45_1.career_index, var_45_1.party_id
end

function NetworkState.get_peers_with_full_profiles(arg_46_0)
	local var_46_0 = arg_46_0._shared_state:get_key("full_profile_peers")

	return arg_46_0._shared_state:get_server(var_46_0)
end

function NetworkState.get_profile(arg_47_0, arg_47_1, arg_47_2)
	local var_47_0 = arg_47_0._shared_state:get_key("full_profile_peers")
	local var_47_1 = arg_47_0._shared_state:get_server(var_47_0)

	for iter_47_0, iter_47_1 in ipairs(var_47_1) do
		if iter_47_1.peer_id == arg_47_1 and iter_47_1.local_player_id == arg_47_2 then
			return iter_47_1.profile_index, iter_47_1.career_index, iter_47_1.is_bot
		end
	end

	return nil, nil
end

function NetworkState.set_profile(arg_48_0, arg_48_1, arg_48_2, arg_48_3, arg_48_4, arg_48_5)
	fassert(arg_48_3 > 0, "use :delete_profile_data instead")

	local var_48_0 = arg_48_0._shared_state:get_key("full_profile_peers")
	local var_48_1 = arg_48_0._shared_state:get_server(var_48_0)
	local var_48_2 = true
	local var_48_3 = table.clone(var_48_1, var_48_2)
	local var_48_4 = false

	for iter_48_0, iter_48_1 in ipairs(var_48_3) do
		if iter_48_1.peer_id == arg_48_1 and iter_48_1.local_player_id == arg_48_2 then
			iter_48_1.profile_index = arg_48_3
			iter_48_1.career_index = arg_48_4
			iter_48_1.is_bot = arg_48_5
			var_48_4 = true
		end
	end

	if not var_48_4 then
		var_48_3[#var_48_3 + 1] = {
			peer_id = arg_48_1,
			local_player_id = arg_48_2,
			profile_index = arg_48_3,
			career_index = arg_48_4,
			is_bot = arg_48_5
		}
	end

	arg_48_0._shared_state:set_server(var_48_0, var_48_3)
end

function NetworkState.get_inventory_data(arg_49_0, arg_49_1, arg_49_2)
	local var_49_0 = arg_49_0._shared_state:get_key("inventory_list", nil, arg_49_2)

	return arg_49_0._shared_state:get_peer(arg_49_1, var_49_0)
end

function NetworkState.set_inventory_data(arg_50_0, arg_50_1, arg_50_2, arg_50_3)
	local var_50_0 = arg_50_0._shared_state:get_key("inventory_list", nil, arg_50_2)

	arg_50_0._shared_state:set_peer(arg_50_1, var_50_0, arg_50_3)
end

function NetworkState.get_loaded_inventory_id(arg_51_0, arg_51_1, arg_51_2, arg_51_3)
	local var_51_0 = arg_51_0._shared_state:get_key("loaded_inventory_id", arg_51_2, arg_51_3)

	return (arg_51_0._shared_state:get_peer(arg_51_1, var_51_0))
end

function NetworkState.set_own_loaded_inventory_id(arg_52_0, arg_52_1, arg_52_2, arg_52_3)
	local var_52_0 = arg_52_0._shared_state:get_key("loaded_inventory_id", arg_52_1, arg_52_2)

	arg_52_0._shared_state:set_own(var_52_0, arg_52_3)
end

function NetworkState.delete_profile_data(arg_53_0, arg_53_1, arg_53_2)
	local var_53_0 = arg_53_0:get_peers_with_full_profiles()
	local var_53_1 = {}

	for iter_53_0, iter_53_1 in ipairs(var_53_0) do
		if iter_53_1.peer_id ~= arg_53_1 or iter_53_1.local_player_id ~= arg_53_2 then
			var_53_1[#var_53_1 + 1] = iter_53_1
		end
	end

	local var_53_2 = arg_53_0._shared_state:get_key("full_profile_peers")

	arg_53_0._shared_state:set_server(var_53_2, var_53_1)
end

function NetworkState.get_actually_ingame(arg_54_0, arg_54_1)
	local var_54_0 = arg_54_0._shared_state:get_key("actually_ingame", arg_54_1)

	return arg_54_0._shared_state:get_peer(arg_54_1, var_54_0)
end

function NetworkState.set_own_actually_ingame(arg_55_0, arg_55_1)
	local var_55_0 = arg_55_0._shared_state:get_key("actually_ingame", arg_55_0._own_peer_id)

	arg_55_0._shared_state:set_peer(arg_55_0._own_peer_id, var_55_0, arg_55_1)
end

function NetworkState.set_side_order_state(arg_56_0, arg_56_1)
	local var_56_0 = arg_56_0._shared_state:get_key("side_order_state")

	arg_56_0._shared_state:set_server(var_56_0, arg_56_1)
end

function NetworkState.get_side_order_state(arg_57_0)
	local var_57_0 = arg_57_0._shared_state:get_key("side_order_state")

	return arg_57_0._shared_state:get_server(var_57_0)
end

function NetworkState.get_game_mode_event_data(arg_58_0)
	local var_58_0 = arg_58_0._shared_state:get_key("game_mode_event_data")

	return arg_58_0._shared_state:get_server(var_58_0)
end

function NetworkState.set_game_mode_event_data(arg_59_0, arg_59_1)
	local var_59_0 = arg_59_0._shared_state:get_key("game_mode_event_data")

	arg_59_0._shared_state:set_server(var_59_0, arg_59_1)
end

function NetworkState.has_peer_state(arg_60_0, arg_60_1, arg_60_2)
	return arg_60_0._shared_state:has_peer_state(arg_60_1, arg_60_2)
end

function NetworkState.set_initialized_mutator_map(arg_61_0, arg_61_1)
	local var_61_0 = arg_61_0._shared_state:get_key("initialized_mutator_map")

	arg_61_0._shared_state:set_server(var_61_0, arg_61_1)
end

function NetworkState.get_initialized_mutator_map(arg_62_0)
	local var_62_0 = arg_62_0._shared_state:get_key("initialized_mutator_map")

	return arg_62_0._shared_state:get_server(var_62_0)
end

function NetworkState.set_session_breed_map(arg_63_0, arg_63_1)
	local var_63_0 = arg_63_0._shared_state:get_key("session_breed_map")

	arg_63_0._shared_state:set_server(var_63_0, arg_63_1)
end

function NetworkState.get_session_breed_map(arg_64_0)
	local var_64_0 = arg_64_0._shared_state:get_key("session_breed_map")

	return arg_64_0._shared_state:get_server(var_64_0)
end

function NetworkState.get_loaded_session_breed_map(arg_65_0, arg_65_1)
	local var_65_0 = arg_65_0._shared_state:get_key("loaded_session_breed_map")

	return arg_65_0._shared_state:get_peer(arg_65_1, var_65_0)
end

function NetworkState.get_own_loaded_session_breed_map(arg_66_0)
	local var_66_0 = arg_66_0._shared_state:get_key("loaded_session_breed_map")

	return arg_66_0._shared_state:get_own(var_66_0)
end

function NetworkState.set_own_loaded_session_breeds(arg_67_0, arg_67_1)
	local var_67_0 = arg_67_0._shared_state:get_key("loaded_session_breed_map")

	return arg_67_0._shared_state:set_own(var_67_0, arg_67_1)
end

function NetworkState.set_startup_breeds(arg_68_0, arg_68_1)
	local var_68_0 = arg_68_0._shared_state:get_key("startup_breed_map")

	return arg_68_0._shared_state:set_server(var_68_0, arg_68_1)
end

function NetworkState.get_startup_breeds(arg_69_0)
	local var_69_0 = arg_69_0._shared_state:get_key("startup_breed_map")

	return arg_69_0._shared_state:get_server(var_69_0)
end

function NetworkState.get_session_pickup_map(arg_70_0)
	local var_70_0 = arg_70_0._shared_state:get_key("session_pickup_map")

	return arg_70_0._shared_state:get_server(var_70_0)
end

function NetworkState.set_session_pickup_map(arg_71_0, arg_71_1)
	local var_71_0 = arg_71_0._shared_state:get_key("session_pickup_map")

	arg_71_0._shared_state:set_server(var_71_0, arg_71_1)
end

function NetworkState.get_own_loaded_session_pickup_map(arg_72_0)
	local var_72_0 = arg_72_0._shared_state:get_key("loaded_session_pickup_map")

	return arg_72_0._shared_state:get_own(var_72_0)
end

function NetworkState.set_own_loaded_session_pickups(arg_73_0, arg_73_1)
	local var_73_0 = arg_73_0._shared_state:get_key("loaded_session_pickup_map")

	return arg_73_0._shared_state:set_own(var_73_0, arg_73_1)
end

function NetworkState.get_loaded_session_pickup_map(arg_74_0, arg_74_1)
	local var_74_0 = arg_74_0._shared_state:get_key("loaded_session_pickup_map")

	return arg_74_0._shared_state:get_peer(arg_74_1, var_74_0)
end

function NetworkState.get_unlocked_dlcs_set(arg_75_0, arg_75_1)
	local var_75_0 = arg_75_0._shared_state:get_key("unlocked_dlcs")

	return arg_75_0._shared_state:get_peer(arg_75_1, var_75_0)
end

function NetworkState.get_loaded_mutator_map(arg_76_0, arg_76_1)
	local var_76_0 = arg_76_0._shared_state:get_key("loaded_mutator_map")

	return arg_76_0._shared_state:get_peer(arg_76_1, var_76_0)
end

function NetworkState.get_own_loaded_mutator_map(arg_77_0)
	local var_77_0 = arg_77_0._shared_state:get_key("loaded_mutator_map")

	return arg_77_0._shared_state:get_own(var_77_0)
end

function NetworkState.set_own_loaded_mutator_map(arg_78_0, arg_78_1)
	local var_78_0 = arg_78_0._shared_state:get_key("loaded_mutator_map")

	arg_78_0._shared_state:set_own(var_78_0, arg_78_1)
end
