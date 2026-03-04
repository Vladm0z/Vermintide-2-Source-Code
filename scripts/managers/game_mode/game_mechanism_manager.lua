-- chunkname: @scripts/managers/game_mode/game_mechanism_manager.lua

require("scripts/managers/game_mode/mechanisms/adventure_mechanism")

local var_0_0 = script_data.testify and require("scripts/managers/game_mode/game_mechanism_manager_testify")

MechanismSettings = {
	adventure = {
		default_inventory = true,
		display_name = "game_mode_adventure",
		check_matchmaking_hero_availability = true,
		server_universe = "carousel",
		tobii_available = true,
		vote_switch_mechanism_background = "vote_switch_mechanism_adventure_background",
		vote_switch_mechanism_text = "vote_switch_mechanism_adventure_description",
		server_port = 27015,
		default_difficulty = "hard",
		class_name = "AdventureMechanism",
		states = {
			"inn",
			"ingame",
			"tutorial",
			"weave"
		},
		venture_end_states_in = {
			"inn"
		},
		venture_end_states_out = {
			"inn"
		},
		party_data = {
			heroes = {
				party_id = 1,
				name = "heroes",
				num_slots = 4
			}
		},
		gamemode_lookup = {
			default = "adventure",
			keep = "inn"
		}
	},
	weave = {
		vote_switch_mechanism_text = "vote_switch_mechanism_adventure_description",
		disable_difficulty_check = true,
		display_name = "game_mode_adventure",
		server_port = 27015,
		default_inventory = true,
		tobii_available = true,
		class_name = "AdventureMechanism",
		server_universe = "carousel",
		vote_switch_mechanism_background = "vote_switch_mechanism_adventure_background",
		check_matchmaking_hero_availability = true,
		required_dlc = "scorpion",
		states = {
			"inn",
			"ingame",
			"tutorial",
			"weave"
		},
		venture_end_states_in = {
			"inn"
		},
		venture_end_states_out = {
			"inn"
		},
		party_data = {
			heroes = {
				party_id = 1,
				name = "heroes",
				num_slots = 4
			}
		},
		extra_requirements_function = function (arg_1_0, arg_1_1)
			if script_data.unlock_all_levels then
				return true
			end

			local var_1_0 = Managers.backend:get_stats()

			for iter_1_0, iter_1_1 in pairs(MainGameLevels) do
				if LevelSettings[iter_1_1].game_mode == "adventure" then
					if arg_1_0 then
						local var_1_1 = arg_1_0:get_persistent_stat(arg_1_1, "completed_levels", iter_1_1)

						if not (var_1_1 and var_1_1 ~= 0) then
							return false
						end
					elseif (tonumber(var_1_0["completed_levels_" .. iter_1_1]) or 0) < 1 then
						return false
					end
				end
			end

			local var_1_2 = GameActs.act_scorpion

			for iter_1_2, iter_1_3 in pairs(var_1_2) do
				if LevelSettings[iter_1_3].game_mode == "adventure" then
					if arg_1_0 then
						local var_1_3 = arg_1_0:get_persistent_stat(arg_1_1, "completed_levels", iter_1_3)

						if not (var_1_3 and var_1_3 ~= 0) then
							return false
						end
					elseif (tonumber(var_1_0["completed_levels_" .. iter_1_3]) or 0) < 1 then
						return false
					end
				end
			end

			return true
		end,
		gamemode_lookup = {
			default = "weave",
			keep = "inn"
		}
	}
}

for iter_0_0, iter_0_1 in pairs(DLCSettings) do
	local var_0_1 = iter_0_1.mechanism_settings

	if var_0_1 then
		for iter_0_2, iter_0_3 in pairs(var_0_1) do
			if iter_0_3.file then
				require(iter_0_3.file)
			end

			MechanismSettings[iter_0_2] = iter_0_3
		end
	end
end

GameMechanismManager = class(GameMechanismManager)

local var_0_2 = {
	"rpc_set_current_mechanism_state",
	"rpc_level_load_started",
	"rpc_carousel_set_local_match",
	"rpc_carousel_set_private_lobby",
	"rpc_set_peer_backend_id",
	"rpc_dedicated_or_player_hosted_search",
	"rpc_reserved_slots_count",
	"rpc_party_slots_status",
	"rpc_force_start_dedicated_server",
	"rpc_switch_level_dedicated_server",
	"rpc_sync_players_session_score"
}

local function var_0_3(arg_2_0)
	if arg_2_0 == "false" then
		return false
	else
		return arg_2_0
	end
end

GameMechanismManager.init = function (arg_3_0, arg_3_1)
	arg_3_0._mechanism_key = arg_3_1
	arg_3_0._game_mechanism = nil
	arg_3_0._level_seed = nil
	arg_3_0._locked_director_functions = nil
	arg_3_0._locked_director_function_ids = nil
	arg_3_0._venture_started = false

	arg_3_0:_init_mechanism()
end

GameMechanismManager.handle_level_load = function (arg_4_0, arg_4_1)
	local var_4_0 = Managers.level_transition_handler
	local var_4_1 = var_4_0:get_current_mechanism()
	local var_4_2 = arg_4_0._mechanism_key

	if not arg_4_1 then
		arg_4_0._last_mechanism_switch = var_4_2
	end

	if not arg_4_0._game_mechanism or var_4_2 ~= var_4_1 then
		arg_4_0:_init_mechanism()
	end

	if arg_4_0._network_client then
		local var_4_3 = PEER_ID_TO_CHANNEL[arg_4_0._server_peer_id]
		local var_4_4 = var_4_0:get_current_level_session_id()

		RPC.rpc_level_load_started(var_4_3, var_4_4)
	end

	if Managers.party:cleared() then
		arg_4_0:reset_party_data(arg_4_0._is_server)
	end
end

GameMechanismManager.create_level_seed = function (arg_5_0)
	return LevelTransitionHandler.create_level_seed()
end

GameMechanismManager.generate_level_seed = function (arg_6_0)
	local var_6_0 = arg_6_0._game_mechanism.generate_level_seed and arg_6_0._game_mechanism:generate_level_seed()

	if var_6_0 then
		arg_6_0._level_seed = var_6_0
	else
		print("[LevelTransitionHandler] Generated new level_seed:", var_6_0)

		arg_6_0._level_seed = arg_6_0:create_level_seed()
	end

	return arg_6_0._level_seed
end

GameMechanismManager.get_level_seed = function (arg_7_0, arg_7_1)
	local var_7_0 = Managers.level_transition_handler:get_current_level_seed()

	if arg_7_0._game_mechanism.get_level_seed then
		return arg_7_0._game_mechanism:get_level_seed(var_7_0, arg_7_1)
	else
		return var_7_0
	end
end

GameMechanismManager.get_end_of_level_rewards_arguments = function (arg_8_0, arg_8_1, arg_8_2, arg_8_3, arg_8_4, arg_8_5, arg_8_6)
	if arg_8_0._game_mechanism.get_end_of_level_rewards_arguments then
		return arg_8_0._game_mechanism:get_end_of_level_rewards_arguments(arg_8_1, arg_8_2, arg_8_3, arg_8_4, arg_8_5, arg_8_6)
	else
		return {}
	end
end

GameMechanismManager.get_end_of_level_extra_mission_results = function (arg_9_0)
	if arg_9_0._game_mechanism.get_end_of_level_extra_mission_results then
		return arg_9_0._game_mechanism:get_end_of_level_extra_mission_results()
	else
		return {}
	end
end

GameMechanismManager.sync_players_session_score = function (arg_10_0, arg_10_1)
	local var_10_0 = {}
	local var_10_1 = {}
	local var_10_2 = {}

	if arg_10_0._game_mechanism.sync_players_session_score then
		arg_10_0._game_mechanism:sync_players_session_score(arg_10_1, var_10_0, var_10_1, var_10_2)
	else
		for iter_10_0, iter_10_1 in pairs(arg_10_1) do
			var_10_0[#var_10_0 + 1] = iter_10_1.peer_id
			var_10_1[#var_10_1 + 1] = iter_10_1.local_player_id

			local var_10_3 = iter_10_1.group_scores.offense

			for iter_10_2 = 1, #var_10_3 do
				var_10_2[#var_10_2 + 1] = var_10_3[iter_10_2].score
			end
		end
	end

	arg_10_0:send_rpc_clients("rpc_sync_players_session_score", var_10_0, var_10_1, var_10_2)
	Managers.state.event:trigger("player_session_scores_synced")
end

GameMechanismManager.network_server = function (arg_11_0)
	return arg_11_0._network_server
end

GameMechanismManager.network_client = function (arg_12_0)
	return arg_12_0._network_client
end

GameMechanismManager.network_handler = function (arg_13_0)
	return arg_13_0._network_server or arg_13_0._network_client
end

GameMechanismManager.set_level_seed = function (arg_14_0, arg_14_1)
	print("GameMechanismManager setting level seed:", arg_14_1)

	arg_14_0._level_seed = arg_14_1
end

GameMechanismManager.generate_locked_director_functions = function (arg_15_0, arg_15_1)
	return (ConflictUtils.generate_conflict_director_locked_functions(arg_15_1))
end

GameMechanismManager.can_spawn_pickup = function (arg_16_0, arg_16_1, arg_16_2)
	local var_16_0 = arg_16_0._game_mechanism

	if var_16_0 and var_16_0.can_spawn_pickup then
		return var_16_0:can_spawn_pickup(arg_16_1, arg_16_2)
	end

	return false
end

GameMechanismManager.uses_random_directors = function (arg_17_0)
	local var_17_0 = arg_17_0._game_mechanism

	if var_17_0 and var_17_0.uses_random_directors then
		return var_17_0:uses_random_directors()
	end

	return true
end

GameMechanismManager.destroy = function (arg_18_0)
	arg_18_0:_unregister_mechanism_rpcs()

	if arg_18_0._game_mechanism.destroy then
		arg_18_0._game_mechanism:destroy()

		arg_18_0._game_mechanism = nil
	end

	if arg_18_0._network_event_delegate then
		arg_18_0._network_event_delegate:unregister(arg_18_0)

		arg_18_0._network_event_delegate = nil
	end
end

GameMechanismManager.set_profile_synchronizer = function (arg_19_0, arg_19_1)
	arg_19_0._profile_synchronizer = arg_19_1
end

GameMechanismManager.get_level_end_view = function (arg_20_0)
	return arg_20_0._game_mechanism and arg_20_0._game_mechanism.get_level_end_view and arg_20_0._game_mechanism:get_level_end_view()
end

GameMechanismManager.get_level_end_view_packages = function (arg_21_0)
	return arg_21_0._game_mechanism and arg_21_0._game_mechanism.get_level_end_view_packages and arg_21_0._game_mechanism:get_level_end_view_packages()
end

GameMechanismManager.handle_ingame_enter = function (arg_22_0, arg_22_1)
	local var_22_0 = arg_22_0._game_mechanism

	if var_22_0 and var_22_0.handle_ingame_enter then
		var_22_0:handle_ingame_enter(arg_22_1)
	end
end

GameMechanismManager.handle_ingame_exit = function (arg_23_0, arg_23_1)
	local var_23_0 = arg_23_0._game_mechanism

	if var_23_0 and var_23_0.handle_ingame_exit then
		var_23_0:handle_ingame_exit(arg_23_1)
	end
end

GameMechanismManager.can_resync_loadout = function (arg_24_0)
	local var_24_0 = arg_24_0._game_mechanism

	if var_24_0 and var_24_0.can_resync_loadout then
		return var_24_0:can_resync_loadout()
	else
		return true
	end
end

GameMechanismManager.update_loadout = function (arg_25_0)
	local var_25_0 = arg_25_0._game_mechanism

	if var_25_0 and var_25_0.update_loadout then
		var_25_0:update_loadout()
	end
end

GameMechanismManager.network_context_created = function (arg_26_0, arg_26_1, arg_26_2, arg_26_3, arg_26_4, arg_26_5)
	printf("[GameMechanismManager] network_context_created (server_peer_id=%s, own_peer_id=%s)", arg_26_2, arg_26_3)

	arg_26_0._lobby = arg_26_1
	arg_26_0._server_peer_id = arg_26_2
	arg_26_0._peer_id = arg_26_3
	arg_26_0._is_server = arg_26_4

	local var_26_0 = arg_26_0._game_mechanism

	if var_26_0 and var_26_0.network_context_created then
		var_26_0:network_context_created(arg_26_1, arg_26_2, arg_26_3, arg_26_4, arg_26_5)
	end
end

GameMechanismManager.set_network_server = function (arg_27_0, arg_27_1)
	arg_27_0._network_server = arg_27_1

	if arg_27_1 then
		arg_27_0._network_client = nil
	end

	if arg_27_0._game_mechanism.network_handler_set then
		arg_27_0._game_mechanism:network_handler_set(arg_27_1)
	end
end

GameMechanismManager.set_network_client = function (arg_28_0, arg_28_1)
	arg_28_0._network_client = arg_28_1

	if arg_28_1 then
		arg_28_0._network_server = nil
	end

	if arg_28_0._game_mechanism.network_handler_set then
		arg_28_0._game_mechanism:network_handler_set(arg_28_1)
	end
end

GameMechanismManager.server_peer_id = function (arg_29_0)
	return arg_29_0._server_peer_id
end

GameMechanismManager.is_server = function (arg_30_0)
	return arg_30_0._is_server
end

GameMechanismManager.network_context_destroyed = function (arg_31_0, arg_31_1)
	print("[GameMechanismManager] network_context_destroyed")

	arg_31_0._lobby = nil
	arg_31_0._server_peer_id = nil
	arg_31_0._peer_id = nil
	arg_31_0._is_server = nil

	if arg_31_0._game_mechanism and arg_31_0._game_mechanism.network_context_destroyed then
		arg_31_0._game_mechanism:network_context_destroyed()
	end
end

GameMechanismManager.register_rpcs = function (arg_32_0, arg_32_1)
	arg_32_0._network_event_delegate = arg_32_1

	arg_32_1:register(arg_32_0, unpack(var_0_2))
	arg_32_0:_register_mechanism_rpcs()
end

GameMechanismManager._register_mechanism_rpcs = function (arg_33_0)
	if arg_33_0._network_event_delegate and arg_33_0._game_mechanism and arg_33_0._game_mechanism.register_rpcs then
		arg_33_0._game_mechanism:register_rpcs(arg_33_0._network_event_delegate)
	end
end

GameMechanismManager.unregister_rpcs = function (arg_34_0)
	arg_34_0:_unregister_mechanism_rpcs()

	if arg_34_0._network_event_delegate then
		arg_34_0._network_event_delegate:unregister(arg_34_0)

		arg_34_0._network_event_delegate = nil
	end
end

GameMechanismManager._unregister_mechanism_rpcs = function (arg_35_0)
	if arg_35_0._game_mechanism and arg_35_0._game_mechanism.unregister_rpcs then
		arg_35_0._game_mechanism:unregister_rpcs()
	end
end

GameMechanismManager._setup_mechanism_specific_career_settings = function (arg_36_0)
	for iter_36_0, iter_36_1 in pairs(CareerSettingsOriginal) do
		local var_36_0 = iter_36_1.mechanism_overrides

		if var_36_0 then
			local var_36_1 = var_36_0[arg_36_0._mechanism_key]

			if var_36_1 then
				local var_36_2 = table.shallow_copy(iter_36_1)

				table.merge_recursive(var_36_2, var_36_1)
				table.merge(CareerSettings[iter_36_0], var_36_2)
			end
		end
	end
end

GameMechanismManager._init_mechanism = function (arg_37_0)
	local var_37_0 = Managers.level_transition_handler:get_current_mechanism()

	print("initializing mechanism to:", var_37_0)
	fassert(MechanismSettings[var_37_0], "[GameMechanismManager] Tried to set unknown mechanism %q", tostring(var_37_0))

	local var_37_1 = MechanismSettings[var_37_0]
	local var_37_2 = arg_37_0._mechanism_key and arg_37_0._mechanism_key ~= var_37_0

	arg_37_0._mechanism_key = var_37_0

	arg_37_0:_unregister_mechanism_rpcs()

	if not arg_37_0._game_mechanism or var_37_2 then
		if arg_37_0._game_mechanism then
			if arg_37_0._game_mechanism.left_mechanism_due_to_switch then
				arg_37_0._game_mechanism:left_mechanism_due_to_switch()
			end

			if arg_37_0._game_mechanism.destroy then
				arg_37_0._game_mechanism:destroy()

				arg_37_0._game_mechanism = nil
			end
		end

		arg_37_0:_setup_mechanism_specific_career_settings()

		arg_37_0._game_mechanism = rawget(_G, var_37_1.class_name):new(var_37_1)

		if var_37_2 and arg_37_0._game_mechanism.entered_mechanism_due_to_switch then
			arg_37_0._game_mechanism:entered_mechanism_due_to_switch()
		end

		local var_37_3 = arg_37_0:network_handler()

		if var_37_3 and arg_37_0._game_mechanism.network_handler_set then
			arg_37_0._game_mechanism:network_handler_set(var_37_3)
		end

		if var_37_2 then
			MechanismOverrides.mechanism_switched()
			Managers.backend:commit(true, function ()
				Managers.backend:switch_mechanism(var_37_0)
				Managers.backend:load_mechanism_loadout(var_37_0)
			end)
		elseif Managers.backend:get_backend_mirror() then
			Managers.backend:switch_mechanism(var_37_0)
			Managers.backend:load_mechanism_loadout(var_37_0)
		end
	end

	arg_37_0:_register_mechanism_rpcs()
	arg_37_0:reset_party_data(false)
	arg_37_0:clear_stored_challenge_progression_status()
end

GameMechanismManager.mechanism_try_call = function (arg_39_0, arg_39_1, ...)
	local var_39_0 = arg_39_0._game_mechanism

	if var_39_0 then
		local var_39_1 = var_39_0[arg_39_1]

		if var_39_1 then
			return true, var_39_1(var_39_0, ...)
		end
	end

	return false
end

GameMechanismManager.rpc_level_load_started = function (arg_40_0, arg_40_1, arg_40_2)
	if Managers.level_transition_handler:get_current_level_session_id() ~= arg_40_2 then
		Crashify.print_exception("GameMechanismManager", "rpc_level_load_started received with the wrong current state, ignoring it.")

		return
	end

	local var_40_0 = CHANNEL_TO_PEER_ID[arg_40_1]

	if not var_40_0 or var_40_0 == "0" then
		Crashify.print_exception("GameMechanismManager", "rpc_level_load_started received with unknown channel_id, ignoring it.")

		return
	end

	local var_40_1 = arg_40_0._network_server

	if not var_40_1 then
		Crashify.print_exception("GameMechanismManager", "rpc_level_load_started as not the server, ignoring it.")

		return
	end

	local var_40_2 = var_40_1:get_peer_initialized_mechanism(var_40_0) ~= arg_40_0._mechanism_key

	if var_40_2 then
		print("Mechanism says: a client has initialized the mechanism!", var_40_0)
		var_40_1:set_peer_initialized_mechanism(var_40_0, arg_40_0._mechanism_key)

		local var_40_3 = arg_40_0._game_mechanism:get_state()
		local var_40_4 = MechanismSettings[arg_40_0._mechanism_key].states
		local var_40_5 = table.find(var_40_4, var_40_3)

		RPC.rpc_set_current_mechanism_state(arg_40_1, var_40_5)
	end

	if arg_40_0._game_mechanism.sync_mechanism_data then
		arg_40_0._game_mechanism:sync_mechanism_data(var_40_0, var_40_2)
	end
end

GameMechanismManager.create_host_migration_info = function (arg_41_0, arg_41_1, arg_41_2)
	if arg_41_0._game_mechanism.create_host_migration_info then
		return arg_41_0._game_mechanism:create_host_migration_info(arg_41_1, arg_41_2)
	end

	local var_41_0 = {
		host_to_migrate_to = arg_41_0._network_client.host_to_migrate_to
	}
	local var_41_1 = Managers.state.difficulty:get_difficulty()
	local var_41_2 = Managers.mechanism:default_level_key()

	var_41_0.level_to_load = var_41_2

	local var_41_3 = arg_41_0._network_client.lobby_client:lobby_data("is_private")
	local var_41_4
	local var_41_5 = IS_PS4 and "n/a" or NetworkLookup.matchmaking_types["n/a"]

	var_41_0.lobby_data = {
		matchmaking_type = var_41_5,
		is_private = var_41_3,
		difficulty = var_41_1,
		selected_mission_id = var_41_2,
		mission_id = var_41_2
	}

	return var_41_0
end

GameMechanismManager.is_final_round = function (arg_42_0)
	return arg_42_0._game_mechanism:is_final_round()
end

GameMechanismManager.on_final_round_won = function (arg_43_0, arg_43_1, arg_43_2)
	if arg_43_0._game_mechanism.on_final_round_won then
		arg_43_0._game_mechanism:on_final_round_won(arg_43_1, arg_43_2)
	end
end

GameMechanismManager.request_vote = function (arg_44_0, arg_44_1, arg_44_2)
	if arg_44_0._game_mechanism.request_vote then
		arg_44_0._game_mechanism:request_vote(arg_44_1, arg_44_2)
	end
end

GameMechanismManager.game_round_ended = function (arg_45_0, arg_45_1, arg_45_2, arg_45_3, arg_45_4)
	arg_45_0._game_mechanism:game_round_ended(arg_45_1, arg_45_2, arg_45_3, arg_45_4)
end

GameMechanismManager.start_next_round = function (arg_46_0)
	local var_46_0, var_46_1, var_46_2 = arg_46_0._game_mechanism:start_next_round()

	return var_46_0, var_46_1, var_46_2
end

GameMechanismManager.get_current_level_key = function (arg_47_0)
	return Managers.level_transition_handler:get_current_level_key()
end

GameMechanismManager.get_current_level_keys = function (arg_48_0)
	return Managers.level_transition_handler:get_current_level_key()
end

GameMechanismManager.game_mechanism = function (arg_49_0)
	return arg_49_0._game_mechanism
end

GameMechanismManager.current_mechanism_name = function (arg_50_0)
	return arg_50_0._mechanism_key
end

GameMechanismManager.get_last_mechanism_switch = function (arg_51_0)
	return arg_51_0._last_mechanism_switch
end

GameMechanismManager.mechanism_setting = function (arg_52_0, arg_52_1)
	fassert(arg_52_0._mechanism_key, "No mechanism set yet.")

	return MechanismSettings[arg_52_0._mechanism_key][arg_52_1]
end

GameMechanismManager.mechanism_setting_for_title = function (arg_53_0, arg_53_1)
	if not arg_53_0._title_settings then
		arg_53_0:refresh_mechanism_setting_for_title()
	end

	fassert(arg_53_0._mechanism_key, "No mechanism set yet.")

	local var_53_0 = arg_53_0._title_settings[arg_53_0._mechanism_key]
	local var_53_1 = var_53_0 and var_53_0[arg_53_1]

	if var_53_1 then
		return var_53_1
	end

	return arg_53_0:mechanism_setting(arg_53_1)
end

GameMechanismManager.refresh_mechanism_setting_for_title = function (arg_54_0)
	fassert(Managers.backend:get_backend_mirror(), "Backend not created yet")

	arg_54_0._title_settings = Managers.backend:get_title_settings()
end

GameMechanismManager.max_party_members = function (arg_55_0)
	local var_55_0 = MechanismSettings[arg_55_0._mechanism_key].party_data

	return Managers.party:max_party_members(var_55_0)
end

GameMechanismManager.max_instance_members = function (arg_56_0)
	fassert(arg_56_0._mechanism_key, "No mechanism set yet.")

	if arg_56_0._game_mechanism.max_instance_members then
		local var_56_0 = arg_56_0._game_mechanism:max_instance_members(arg_56_0._lobby)

		assert(var_56_0 > 0, "[GameMechanismManager] At least one must be provided to lobbies.")

		return var_56_0
	end

	local var_56_1 = arg_56_0:max_party_members()

	assert(var_56_1 > 0, "[GameMechanismManager] At least one must be provided to lobbies. Parties is not set up yet.")

	return var_56_1
end

GameMechanismManager.server_universe = function (arg_57_0)
	fassert(arg_57_0._mechanism_key, "No mechanism set yet.")

	return MechanismSettings[arg_57_0._mechanism_key].server_universe
end

GameMechanismManager.is_packages_loaded = function (arg_58_0)
	if arg_58_0._game_mechanism.is_packages_loaded then
		return arg_58_0._game_mechanism:is_packages_loaded()
	end

	return true
end

GameMechanismManager.load_packages = function (arg_59_0)
	if arg_59_0._game_mechanism.load_packages then
		arg_59_0._game_mechanism:load_packages()
	end
end

GameMechanismManager.preferred_slot_id = function (arg_60_0, arg_60_1, arg_60_2, arg_60_3)
	if arg_60_0._game_mechanism and arg_60_0._game_mechanism.preferred_slot_id then
		return arg_60_0._game_mechanism:preferred_slot_id(arg_60_1, arg_60_2, arg_60_3)
	end

	return nil
end

GameMechanismManager.profile_available_for_peer = function (arg_61_0, arg_61_1, arg_61_2, arg_61_3)
	local var_61_0 = arg_61_0._profile_synchronizer:get_profile_index_reservation(arg_61_1, arg_61_3)

	return not var_61_0 or var_61_0 == arg_61_2
end

GameMechanismManager.profile_changed = function (arg_62_0, arg_62_1, arg_62_2, arg_62_3, arg_62_4, arg_62_5)
	if arg_62_0._game_mechanism and arg_62_0._game_mechanism.profile_changed then
		return arg_62_0._game_mechanism:profile_changed(arg_62_1, arg_62_2, arg_62_3, arg_62_4, arg_62_5)
	end

	return false
end

GameMechanismManager.profile_synchronizer = function (arg_63_0)
	return arg_63_0._profile_synchronizer
end

GameMechanismManager.get_players_session_score = function (arg_64_0, arg_64_1, arg_64_2, arg_64_3)
	local var_64_0

	if not arg_64_0._is_server then
		var_64_0 = arg_64_0.synced_players_session_score
	end

	if not var_64_0 then
		if arg_64_0._game_mechanism.get_players_session_score then
			var_64_0 = arg_64_0._game_mechanism:get_players_session_score(arg_64_1, arg_64_2, arg_64_3)
		end

		var_64_0 = var_64_0 or ScoreboardHelper.get_grouped_topic_statistics(arg_64_1, arg_64_2, arg_64_3)
	end

	return var_64_0
end

GameMechanismManager.get_prior_state = function (arg_65_0)
	return arg_65_0._game_mechanism:get_prior_state()
end

GameMechanismManager.choose_next_state = function (arg_66_0, arg_66_1)
	arg_66_0._game_mechanism:choose_next_state(arg_66_1)
end

GameMechanismManager.reset_choose_next_state = function (arg_67_0)
	arg_67_0._game_mechanism:reset_choose_next_state()
end

GameMechanismManager.setting = function (arg_68_0, arg_68_1)
	return MechanismSettings[arg_68_0._mechanism_key][arg_68_1]
end

GameMechanismManager.progress_state = function (arg_69_0, arg_69_1)
	local var_69_0 = arg_69_0._game_mechanism:progress_state()
	local var_69_1 = MechanismSettings[arg_69_0._mechanism_key].states
	local var_69_2 = table.find(var_69_1, var_69_0)

	fassert(var_69_2, "State not found in mechanism settings")

	if not arg_69_1 then
		arg_69_0:send_rpc_clients("rpc_set_current_mechanism_state", var_69_2)
	end
end

GameMechanismManager.get_starting_level = function (arg_70_0)
	return arg_70_0._game_mechanism.get_starting_level and arg_70_0._game_mechanism:get_starting_level() or LevelSettings.default_start_level
end

GameMechanismManager.default_level_key = function (arg_71_0)
	local var_71_0 = Boot.loading_context and Boot.loading_context.level_key

	if var_71_0 then
		return var_71_0
	end

	local var_71_1 = var_0_3(Development.parameter("attract_mode")) and BenchmarkSettings.auto_host_level

	return var_0_3(Development.parameter("auto_host_level")) or Development.parameter("vs_auto_search") and "carousel_hub" or var_71_1 or arg_71_0:get_starting_level()
end

GameMechanismManager.get_loading_tip = function (arg_72_0)
	local var_72_0 = arg_72_0._game_mechanism

	if var_72_0.get_loading_tip then
		return var_72_0:get_loading_tip()
	end

	return nil
end

GameMechanismManager.backend_profiles_loaded = function (arg_73_0)
	if arg_73_0._game_mechanism.backend_profiles_loaded then
		arg_73_0._game_mechanism:backend_profiles_loaded()
	end
end

GameMechanismManager.try_reserve_game_server_slots = function (arg_74_0, arg_74_1, arg_74_2, arg_74_3)
	local var_74_0 = Managers.state.game_mode

	if var_74_0 and not var_74_0:is_reservable() then
		print("Rejected game server reservation because game mode denies joining")

		return false
	end

	if arg_74_0._game_mechanism.try_reserve_game_server_slots then
		return arg_74_0._game_mechanism:try_reserve_game_server_slots(arg_74_1, arg_74_2, arg_74_3)
	end

	printf("[GameMechanismManager] Approving slot reservation by default.")

	return true
end

GameMechanismManager.game_server_slot_reservation_expired = function (arg_75_0, arg_75_1)
	if arg_75_0._game_mechanism.game_server_slot_reservation_expired then
		arg_75_0._game_mechanism:game_server_slot_reservation_expired(arg_75_1)
	end
end

GameMechanismManager.debug_load_level = function (arg_76_0, arg_76_1, arg_76_2)
	if not arg_76_0._is_server then
		return
	end

	if arg_76_0._game_mechanism and arg_76_0._game_mechanism.debug_load_level then
		arg_76_0._game_mechanism:debug_load_level(arg_76_1, arg_76_2)
	else
		local var_76_0 = Managers.level_transition_handler

		var_76_0:set_next_level(arg_76_1, arg_76_2)
		var_76_0:promote_next_level_data()
	end
end

GameMechanismManager._on_venture_start = function (arg_77_0, arg_77_1)
	arg_77_0._venture_started = true

	local var_77_0 = arg_77_0._is_server
	local var_77_1 = StatisticsDatabase:new()

	Managers.venture.statistics = var_77_1
	Managers.venture.challenge = ChallengeManager:new(var_77_1, var_77_0)
	Managers.venture.quickplay = QuickplayManager:new(arg_77_1, var_77_0)

	Managers:on_venture_start()

	if arg_77_0._game_mechanism.on_venture_start then
		arg_77_0._game_mechanism:on_venture_start()
	end
end

GameMechanismManager._on_venture_end = function (arg_78_0)
	Managers:on_venture_end()

	if arg_78_0._game_mechanism.on_venture_end then
		arg_78_0._game_mechanism:on_venture_end()
	end

	Managers.venture:destroy()

	arg_78_0._venture_started = false
end

GameMechanismManager.check_venture_start = function (arg_79_0, arg_79_1)
	if not arg_79_0._venture_started then
		arg_79_0:_on_venture_start(arg_79_1)
	end
end

GameMechanismManager.check_venture_end = function (arg_80_0, arg_80_1)
	local var_80_0 = arg_80_0._game_mechanism:get_state()
	local var_80_1 = arg_80_0._game_mechanism:get_prior_state()
	local var_80_2 = arg_80_0:mechanism_setting("venture_end_states_in")
	local var_80_3 = arg_80_0:mechanism_setting("venture_end_states_out")

	if arg_80_1 or arg_80_0._venture_ended_manually or arg_80_0._venture_started and (table.contains(var_80_2, var_80_0) or table.contains(var_80_3, var_80_1)) then
		arg_80_0:_on_venture_end()
	end

	arg_80_0._venture_ended_manually = nil
end

GameMechanismManager.manual_end_venture = function (arg_81_0)
	arg_81_0._venture_ended_manually = true
end

GameMechanismManager.is_venture_over = function (arg_82_0)
	if arg_82_0._game_mechanism.is_venture_over then
		return arg_82_0._game_mechanism:is_venture_over()
	end

	local var_82_0 = Managers.state.game_mode

	return var_82_0 and var_82_0:is_game_mode_ended()
end

GameMechanismManager.rpc_set_current_mechanism_state = function (arg_83_0, arg_83_1, arg_83_2)
	fassert(not arg_83_0._is_server, "Server handles the state internally, this should only end up on clients.")

	local var_83_0 = MechanismSettings[arg_83_0._mechanism_key].states[arg_83_2]

	fassert(var_83_0, "No corresponding state_name for state_id (mechanism:%s)", arg_83_0._mechanism_key)
	print("Received new state from server", var_83_0)
	arg_83_0._game_mechanism:set_current_state(var_83_0)
end

GameMechanismManager.rpc_carousel_set_local_match = function (arg_84_0, arg_84_1, arg_84_2)
	if CHANNEL_TO_PEER_ID[arg_84_1] ~= arg_84_0._server_peer_id then
		return
	end

	arg_84_0:mechanism_try_call("set_local_match", arg_84_2)
end

GameMechanismManager.rpc_carousel_set_private_lobby = function (arg_85_0, arg_85_1, arg_85_2)
	if CHANNEL_TO_PEER_ID[arg_85_1] ~= arg_85_0._server_peer_id then
		return
	end

	arg_85_0:mechanism_try_call("set_private_lobby", arg_85_2)
end

GameMechanismManager.rpc_dedicated_or_player_hosted_search = function (arg_86_0, arg_86_1, arg_86_2, arg_86_3, arg_86_4)
	if CHANNEL_TO_PEER_ID[arg_86_1] ~= arg_86_0._server_peer_id then
		return
	end

	arg_86_0:mechanism_try_call("set_dedicated_or_player_hosted_search", arg_86_2, arg_86_3, arg_86_4)
end

GameMechanismManager.rpc_reserved_slots_count = function (arg_87_0, arg_87_1, arg_87_2, arg_87_3)
	if not arg_87_0._game_mechanism.num_dedicated_reserved_slots_changed then
		return
	end

	arg_87_0._game_mechanism:num_dedicated_reserved_slots_changed(arg_87_2, arg_87_3)

	if arg_87_0._is_server then
		arg_87_0._dedicated_server_peer_id = CHANNEL_TO_PEER_ID[arg_87_1]

		arg_87_0:send_rpc_clients("rpc_reserved_slots_count", arg_87_2, arg_87_3)
	end
end

GameMechanismManager.rpc_party_slots_status = function (arg_88_0, arg_88_1, arg_88_2, arg_88_3, arg_88_4, arg_88_5)
	if not arg_88_0._game_mechanism.dedicated_party_slot_status_changed then
		return
	end

	arg_88_0._game_mechanism:dedicated_party_slot_status_changed(arg_88_2, arg_88_3, arg_88_4, arg_88_5)

	if arg_88_0._is_server then
		arg_88_0._dedicated_server_peer_id = CHANNEL_TO_PEER_ID[arg_88_1]

		arg_88_0:send_rpc_clients("rpc_party_slots_status", arg_88_2, arg_88_3, arg_88_4, arg_88_5)
	end
end

GameMechanismManager.rpc_force_start_dedicated_server = function (arg_89_0, arg_89_1)
	print("got GameMechanismManager:rpc_force_start_dedicated_server from", arg_89_1)

	if arg_89_0._game_mechanism.force_start_dedicated_server then
		arg_89_0._game_mechanism:force_start_dedicated_server()
	end
end

GameMechanismManager.rpc_switch_level_dedicated_server = function (arg_90_0, arg_90_1, arg_90_2)
	print("got GameMechanismManager:rpc_force_start_dedicated_server from", arg_90_2)

	if arg_90_0._game_mechanism.switch_level_dedicated_server then
		local var_90_0 = Managers.mechanism:dedicated_server_peer_id() == CHANNEL_TO_PEER_ID[arg_90_1]
		local var_90_1

		if arg_90_2 > 0 then
			var_90_1 = NetworkLookup.level_keys[arg_90_2]
		end

		arg_90_0._game_mechanism:switch_level_dedicated_server(var_90_1, var_90_0)
	end
end

GameMechanismManager.rpc_sync_players_session_score = function (arg_91_0, arg_91_1, arg_91_2, arg_91_3, arg_91_4)
	local var_91_0 = #arg_91_2
	local var_91_1 = #arg_91_4 / var_91_0
	local var_91_2 = Managers.player:statistics_db()
	local var_91_3
	local var_91_4 = ScoreboardHelper.num_stats_per_player

	if arg_91_0._game_mechanism.get_players_session_score then
		var_91_3, var_91_4 = arg_91_0._game_mechanism:get_players_session_score(var_91_2, arg_91_0._profile_synchronizer)
		var_91_4 = var_91_4 or ScoreboardHelper.num_stats_per_player
	end

	var_91_3 = var_91_3 or ScoreboardHelper.get_grouped_topic_statistics(var_91_2, arg_91_0._profile_synchronizer)

	if var_91_4 ~= var_91_1 then
		Crashify.print_exception("GameMechanismManager", "rpc_sync_players_session_score received with mismatching stats_per_player count, probably the host was modded. Ignoring the host score and using client's.")

		arg_91_0.synced_players_session_score = var_91_3

		return
	end

	if arg_91_0._game_mechanism.extract_players_session_score then
		arg_91_0._game_mechanism:extract_players_session_score(var_91_0, var_91_1, arg_91_2, arg_91_3, var_91_3, arg_91_4)
	else
		for iter_91_0, iter_91_1 in pairs(var_91_3) do
			local var_91_5 = iter_91_1.peer_id
			local var_91_6 = iter_91_1.local_player_id

			for iter_91_2 = 1, var_91_0 do
				if var_91_5 == arg_91_2[iter_91_2] and var_91_6 == arg_91_3[iter_91_2] then
					local var_91_7 = iter_91_1.group_scores.offense
					local var_91_8 = (iter_91_2 - 1) * var_91_1 + 1
					local var_91_9 = 1

					for iter_91_3 = var_91_8, var_91_8 + var_91_1 - 1 do
						var_91_7[var_91_9].score = arg_91_4[iter_91_3]
						var_91_9 = var_91_9 + 1
					end

					break
				end
			end
		end
	end

	arg_91_0.synced_players_session_score = var_91_3

	Managers.state.event:trigger("player_session_scores_synced")
end

GameMechanismManager.dedicated_server_peer_id = function (arg_92_0)
	return arg_92_0._dedicated_server_peer_id
end

GameMechanismManager.reset_dedicated_server_peer_id = function (arg_93_0)
	arg_93_0._dedicated_server_peer_id = nil
end

GameMechanismManager.send_rpc_clients = function (arg_94_0, arg_94_1, ...)
	local var_94_0 = arg_94_0._network_server and arg_94_0._network_server:get_peers()

	if not var_94_0 then
		return
	end

	local var_94_1 = RPC[arg_94_1]

	for iter_94_0, iter_94_1 in ipairs(var_94_0) do
		local var_94_2 = PEER_ID_TO_CHANNEL[iter_94_1]

		if iter_94_1 ~= arg_94_0._peer_id and var_94_2 then
			var_94_1(var_94_2, ...)
		end
	end
end

GameMechanismManager.should_run_tutorial = function (arg_95_0)
	return arg_95_0._game_mechanism:should_run_tutorial()
end

GameMechanismManager.get_custom_lobby_sort = function (arg_96_0)
	return arg_96_0._game_mechanism.get_custom_lobby_sort and arg_96_0._game_mechanism:get_custom_lobby_sort()
end

GameMechanismManager.get_state = function (arg_97_0)
	return arg_97_0._game_mechanism:get_state()
end

GameMechanismManager.set_vote_data = function (arg_98_0, arg_98_1)
	if arg_98_0._game_mechanism.set_vote_data then
		arg_98_0._game_mechanism:set_vote_data(arg_98_1)
	end
end

GameMechanismManager.reset_party_data = function (arg_99_0, arg_99_1)
	local var_99_0

	if arg_99_1 then
		var_99_0 = Managers.party:gather_party_members()
	end

	Managers.party:clear_parties(arg_99_1)
	arg_99_0:setup_mechanism_parties()

	if arg_99_1 then
		for iter_99_0, iter_99_1 in pairs(var_99_0) do
			local var_99_1 = iter_99_1.peer_id
			local var_99_2 = iter_99_1.local_player_id

			Managers.party:assign_peer_to_party(var_99_1, var_99_2)
		end
	end
end

GameMechanismManager.setup_mechanism_parties = function (arg_100_0)
	local var_100_0 = MechanismSettings[arg_100_0._mechanism_key].party_data

	Managers.party:register_parties(var_100_0)

	if arg_100_0._game_mechanism.setup_mechanism_parties then
		arg_100_0._game_mechanism:setup_mechanism_parties(arg_100_0)
	end
end

GameMechanismManager.get_level_dialogue_context = function (arg_101_0)
	if arg_101_0._game_mechanism.get_level_dialogue_context then
		return arg_101_0._game_mechanism:get_level_dialogue_context()
	end

	return {}
end

GameMechanismManager.override_hub_level = function (arg_102_0, arg_102_1)
	if arg_102_0._game_mechanism and arg_102_0._game_mechanism.override_hub_level then
		arg_102_0._game_mechanism:override_hub_level(arg_102_1)
	end
end

GameMechanismManager.get_player_level_fallback = function (arg_103_0, arg_103_1)
	if arg_103_0._game_mechanism and arg_103_0._game_mechanism.get_player_level_fallback then
		return arg_103_0._game_mechanism:get_player_level_fallback(arg_103_1)
	end
end

GameMechanismManager.get_slot_reservation_handler = function (arg_104_0, arg_104_1, arg_104_2)
	if arg_104_0._game_mechanism.get_slot_reservation_handler then
		return arg_104_0._game_mechanism:get_slot_reservation_handler(arg_104_1, arg_104_2)
	end
end

GameMechanismManager.get_all_reservation_handlers_by_owner = function (arg_105_0, arg_105_1)
	if arg_105_0._game_mechanism.get_all_reservation_handlers_by_owner then
		return arg_105_0._game_mechanism:get_all_reservation_handlers_by_owner(arg_105_1)
	end
end

GameMechanismManager.rpc_set_peer_backend_id = function (arg_106_0, arg_106_1, arg_106_2)
	if not arg_106_0._is_server then
		Application.warning("[GameMechanismManager:rpc_set_peer_backend_id] sent rpc to non-server peer")

		return
	end

	if arg_106_0._game_mechanism.set_peer_backend_id then
		local var_106_0 = CHANNEL_TO_PEER_ID[arg_106_1]

		arg_106_0._game_mechanism:set_peer_backend_id(var_106_0, arg_106_2)
	end
end

GameMechanismManager.get_social_wheel_class = function (arg_107_0)
	local var_107_0 = MechanismSettings[arg_107_0._mechanism_key].social_wheel

	return var_107_0 and var_107_0 or "SocialWheelUI"
end

GameMechanismManager.load_end_screen_resources = function (arg_108_0)
	if arg_108_0._game_mechanism.load_end_screen_resources then
		arg_108_0._game_mechanism:load_end_screen_resources()
	end
end

GameMechanismManager.unload_end_screen_resources = function (arg_109_0)
	if arg_109_0._game_mechanism.unload_end_screen_resources then
		arg_109_0._game_mechanism:unload_end_screen_resources()
	end
end

GameMechanismManager.is_peer_fully_synced = function (arg_110_0, arg_110_1)
	if arg_110_0._game_mechanism.is_peer_fully_synced then
		return arg_110_0._game_mechanism:is_peer_fully_synced(arg_110_1)
	end

	return true
end

GameMechanismManager.update_testify = function (arg_111_0, arg_111_1, arg_111_2)
	Testify:poll_requests_through_handler(var_0_0, arg_111_0)

	if arg_111_0._game_mechanism.update_testify then
		arg_111_0._game_mechanism:update_testify(arg_111_1, arg_111_2)
	end
end

GameMechanismManager.player_joined_party = function (arg_112_0, arg_112_1, arg_112_2, arg_112_3, arg_112_4, arg_112_5)
	if arg_112_0._game_mechanism.player_joined_party then
		arg_112_0._game_mechanism:player_joined_party(arg_112_1, arg_112_2, arg_112_3, arg_112_4, arg_112_5)
	end
end

GameMechanismManager.reserved_party_id_by_peer = function (arg_113_0, arg_113_1)
	return arg_113_0._game_mechanism:reserved_party_id_by_peer(arg_113_1)
end

GameMechanismManager.try_reserve_profile_for_peer_by_mechanism = function (arg_114_0, arg_114_1, arg_114_2, arg_114_3, arg_114_4)
	return arg_114_0._game_mechanism:try_reserve_profile_for_peer_by_mechanism(arg_114_0._profile_synchronizer, arg_114_1, arg_114_2, arg_114_3, arg_114_4)
end

GameMechanismManager.get_persistent_profile_index_reservation = function (arg_115_0, arg_115_1)
	if arg_115_0._profile_synchronizer then
		local var_115_0, var_115_1 = arg_115_0._profile_synchronizer:get_persistent_profile_index_reservation(arg_115_1)

		return var_115_0, var_115_1
	end
end

GameMechanismManager.remote_client_connecting = function (arg_116_0, arg_116_1)
	if arg_116_0._game_mechanism.remote_client_connecting then
		arg_116_0._game_mechanism:remote_client_connecting(arg_116_1)
	end
end

GameMechanismManager.remote_client_disconnected = function (arg_117_0, arg_117_1)
	if arg_117_0._game_mechanism.remote_client_disconnected then
		arg_117_0._game_mechanism:remote_client_disconnected(arg_117_1)
	end
end

local var_0_4 = {}

GameMechanismManager.get_challenge_progression_status = function (arg_118_0, arg_118_1)
	return Managers.state.achievement and Managers.state.achievement:get_challenge_progression(arg_118_1) or var_0_4
end

GameMechanismManager.store_challenge_progression_status = function (arg_119_0, arg_119_1, arg_119_2)
	if arg_119_0._game_mechanism.store_challenge_progression_status then
		arg_119_0._game_mechanism:store_challenge_progression_status(arg_119_1, arg_119_2)
	end
end

GameMechanismManager.get_stored_challenge_progression_status = function (arg_120_0, arg_120_1)
	if arg_120_0._game_mechanism.get_stored_challenge_progression_status then
		return arg_120_0._game_mechanism:get_stored_challenge_progression_status(arg_120_1)
	end

	return var_0_4
end

GameMechanismManager.clear_stored_challenge_progression_status = function (arg_121_0, arg_121_1)
	if arg_121_0._game_mechanism.clear_stored_challenge_progression_status then
		return arg_121_0._game_mechanism:clear_stored_challenge_progression_status(arg_121_1)
	end
end

GameMechanismManager.state_context_set_up = function (arg_122_0)
	if arg_122_0._game_mechanism.state_context_set_up then
		return arg_122_0._game_mechanism:state_context_set_up()
	end
end
