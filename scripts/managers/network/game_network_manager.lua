-- chunkname: @scripts/managers/network/game_network_manager.lua

local var_0_0 = dofile("scripts/network/game_object_templates")

local function var_0_1(arg_1_0, ...)
	if script_data.network_debug then
		printf("[GameNetworkManager] " .. arg_1_0, ...)
	end
end

GameNetworkManager = class(GameNetworkManager)

local var_0_2 = 10
local var_0_3 = 1

function GameNetworkManager.init(arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4)
	print("GameNetworkManager:init... creating game session")

	local var_2_0 = Network.create_game_session()

	fassert(var_2_0, "Failed to create game session")

	arg_2_0.game_session = var_2_0

	if arg_2_3 then
		printf("Host GameSession.make_game_session_host with session:", var_2_0)
		GameSession.make_game_session_host(var_2_0)

		arg_2_0._session_id = Application.guid()
	else
		local var_2_1 = GameSession.game_session_host(arg_2_0.game_session)

		arg_2_0._session_id = "<client-session-id>"

		if not var_2_1 or var_2_1 == "0" then
			var_2_1 = arg_2_2:lobby_host()
		end

		fassert(var_2_1 and var_2_1 ~= "0", "tried to join GameSession without a valid host.")

		local var_2_2 = PEER_ID_TO_CHANNEL[var_2_1]

		GameSession.join(var_2_0, var_2_2)

		arg_2_0._game_session_host = var_2_1
	end

	arg_2_0._world = arg_2_1
	arg_2_0._lobby = arg_2_2
	arg_2_0._lobby_host = arg_2_2:lobby_host()
	arg_2_0.is_server = arg_2_3
	arg_2_0._left_game = false
	arg_2_0._game_object_types = {}
	arg_2_0._object_synchronizing_clients = {}
	arg_2_0._game_object_disconnect_callbacks = {}

	var_0_1("Setting pong timeout to %s", tostring(GameSettingsDevelopment.network_timeout))
	Network.set_pong_timeout(GameSettingsDevelopment.network_timeout)
	dofile("scripts/network_lookup/network_constants")

	arg_2_0.peer_id = Network.peer_id()

	var_0_1("My own peer_id = %s", tostring(arg_2_0.peer_id))
	var_0_1("self.is_server = %s", tostring(arg_2_0.is_server))
	arg_2_0:set_small_network_packets(Application.user_setting("small_network_packets") or DefaultUserSettings.get("user_settings", "small_network_packets"))

	arg_2_0._event_delegate = arg_2_4

	arg_2_4:register(arg_2_0, "rpc_play_particle_effect_no_rotation", "rpc_play_particle_effect", "rpc_play_particle_effect_with_variable", "rpc_play_particle_effect_spline", "rpc_gm_event_end_conditions_met", "rpc_gm_event_round_started", "rpc_gm_event_initial_peers_spawned", "rpc_surface_mtr_fx", "rpc_surface_mtr_fx_lvl_unit", "rpc_skinned_surface_mtr_fx", "rpc_play_melee_hit_effects", "game_object_created", "game_session_disconnect", "game_object_destroyed", "rpc_enemy_is_alerted", "rpc_assist", "rpc_coop_feedback", "rpc_ladder_shake", "rpc_request_spawn_template_unit", "rpc_flow_event")
end

function GameNetworkManager.lobby(arg_3_0)
	return arg_3_0._lobby
end

function GameNetworkManager.session_id(arg_4_0)
	return arg_4_0._session_id
end

function GameNetworkManager.ping_by_peer(arg_5_0, arg_5_1)
	fassert(arg_5_0.is_server, "tried to fetch ping by peer id as a client")

	return arg_5_0._lobby:ping_by_peer(arg_5_1)
end

function GameNetworkManager.set_small_network_packets(arg_6_0, arg_6_1)
	if arg_6_1 then
		Network.limit_mtu(576)
	else
		Network.limit_mtu(65536)
	end
end

function GameNetworkManager.set_entity_system(arg_7_0, arg_7_1)
	arg_7_0.entity_system = arg_7_1
end

function GameNetworkManager.post_init(arg_8_0, arg_8_1)
	arg_8_0.profile_synchronizer = arg_8_1.profile_synchronizer
	arg_8_0.game_mode = arg_8_1.game_mode
	arg_8_0.networked_flow_state = arg_8_1.networked_flow_state
	arg_8_0.room_manager = arg_8_1.room_manager
	arg_8_0.spawn_manager = arg_8_1.spawn_manager
	arg_8_0.network_clock = arg_8_1.network_clock
	arg_8_0.player_manager = arg_8_1.player_manager

	local var_8_0 = arg_8_1.network_transmit

	arg_8_0.network_transmit = var_8_0

	var_8_0:set_game_session(arg_8_0.game_session)

	for iter_8_0, iter_8_1 in pairs(arg_8_0._object_synchronizing_clients) do
		var_8_0:add_peer_ignore(iter_8_0)
	end

	arg_8_0.network_server = arg_8_1.network_server
	arg_8_0.network_client = arg_8_1.network_client
	arg_8_0.statistics_db = arg_8_1.statistics_db
	arg_8_0.difficulty_manager = arg_8_1.difficulty_manager
	arg_8_0.weave_manager = arg_8_1.weave_manager
	arg_8_0.voting_manager = arg_8_1.voting_manager
	arg_8_0.matchmaking_manager = arg_8_1.matchmaking_manager
	arg_8_0.game_server_manager = arg_8_1.game_server_manager
	arg_8_0._leaving_game = false
end

function GameNetworkManager.set_unit_storage(arg_9_0, arg_9_1)
	arg_9_0.unit_storage = arg_9_1
end

function GameNetworkManager.set_unit_spawner(arg_10_0, arg_10_1)
	arg_10_0.unit_spawner = arg_10_1
end

function GameNetworkManager.in_game_session(arg_11_0)
	local var_11_0 = arg_11_0.game_session

	if var_11_0 and GameSession.in_session(var_11_0) then
		return true
	else
		return false
	end
end

function GameNetworkManager.update_receive(arg_12_0, arg_12_1)
	Network.update_receive(arg_12_1, arg_12_0._event_delegate.event_table)

	local var_12_0 = arg_12_0.game_session

	if not var_12_0 then
		return
	end

	arg_12_0.network_transmit:update_receive()

	if not arg_12_0._game_session_host and GameSession.in_session(var_12_0) then
		arg_12_0._game_session_host = GameSession.game_session_host(var_12_0)
	end

	if arg_12_0._game_session_disconnect then
		var_0_1("Game session disconnected, leaving game...")

		arg_12_0._game_session_host = nil

		arg_12_0.network_transmit:set_game_session(nil)

		arg_12_0.game_session = nil
		arg_12_0._left_game = true
	end
end

function GameNetworkManager.update_transmit(arg_13_0, arg_13_1)
	Network.update_transmit()
end

function GameNetworkManager.update(arg_14_0, arg_14_1)
	if arg_14_0.is_server and arg_14_0:in_game_session() then
		local var_14_0 = arg_14_0._lobby
		local var_14_1 = arg_14_0.game_session
		local var_14_2 = arg_14_0.player_manager:human_players()
		local var_14_3 = NetworkConstants.ping.min
		local var_14_4 = NetworkConstants.ping.max

		for iter_14_0, iter_14_1 in pairs(var_14_2) do
			local var_14_5 = iter_14_1.peer_id

			if var_14_5 ~= arg_14_0.peer_id then
				local var_14_6 = iter_14_1.game_object_id
				local var_14_7 = math.clamp(math.floor(var_14_0:ping_by_peer(var_14_5) * 1000), var_14_3, var_14_4)

				GameSession.set_game_object_field(var_14_1, var_14_6, "ping", var_14_7)
			end
		end
	end

	if arg_14_0._shutdown_server_timer then
		arg_14_0._shutdown_server_timer = arg_14_0._shutdown_server_timer - arg_14_1

		if arg_14_0.network_server:all_client_peers_disconnected() or arg_14_0._shutdown_server_timer < 0 then
			arg_14_0.network_server:force_disconnect_all_client_peers()
			arg_14_0:_shutdown_server()

			arg_14_0._shutdown_server_timer = nil
		end
	end

	if arg_14_0._left_game and not arg_14_0:in_game_session() and not arg_14_0.game_session_shutdown then
		var_0_1("No longer in game session, shutting it down.")
		Network.shutdown_game_session()

		arg_14_0.game_session_shutdown = true
	end
end

function GameNetworkManager.network_time(arg_15_0)
	return arg_15_0.network_clock:time()
end

function GameNetworkManager._shutdown_server(arg_16_0)
	var_0_1("Shutting down game session host.")
	arg_16_0:game_session_disconnect()
	GameSession.shutdown_game_session_host(arg_16_0.game_session)

	arg_16_0._game_session_host = nil

	arg_16_0.network_transmit:set_game_session(nil)

	arg_16_0.game_session = nil
	arg_16_0._left_game = true
end

function GameNetworkManager.force_disconnect_from_session(arg_17_0)
	var_0_1("Forcing disconnect_from_host()")
	GameSession.disconnect_from_host(arg_17_0.game_session)
end

local var_0_4 = 2

function GameNetworkManager.leave_game(arg_18_0, arg_18_1)
	var_0_1("Leaving game...")

	arg_18_0._leaving_game = true
	arg_18_0.ignore_lobby_rpcs = arg_18_1

	if arg_18_0.is_server then
		if arg_18_1 then
			arg_18_0._shutdown_server_timer = var_0_4
		else
			arg_18_0:_shutdown_server()
		end
	else
		local var_18_0 = Managers.player:players_at_peer(Network.peer_id())

		for iter_18_0, iter_18_1 in pairs(var_18_0) do
			if iter_18_1:needs_despawn() then
				Managers.state.spawn:delayed_despawn(iter_18_1)
				printf("despawning player %s", iter_18_1:name())
			end
		end

		GameSession.leave(arg_18_0.game_session)
	end
end

function GameNetworkManager.has_left_game(arg_19_0)
	return arg_19_0._left_game
end

function GameNetworkManager.is_leaving_game(arg_20_0)
	return arg_20_0._leaving_game
end

function GameNetworkManager.destroy(arg_21_0)
	for iter_21_0, iter_21_1 in pairs(arg_21_0._object_synchronizing_clients) do
		arg_21_0.network_transmit:remove_peer_ignore(iter_21_0)
	end

	arg_21_0._event_delegate:unregister(arg_21_0)

	arg_21_0._event_delegate = nil
	arg_21_0.entity_system = nil
	arg_21_0.game_mode = nil
	arg_21_0.networked_flow_state = nil
	arg_21_0.room_manager = nil
	arg_21_0.spawn_manager = nil
	arg_21_0.network_clock = nil
	arg_21_0.profile_synchronizer = nil
	arg_21_0._lobby = nil
	arg_21_0._game_object_disconnect_callbacks = nil
	arg_21_0._world = nil
	arg_21_0.network_transmit = nil
	arg_21_0.network_server = nil

	GarbageLeakDetector.register_object(arg_21_0, "Network Manager")

	if not arg_21_0.game_session_shutdown then
		var_0_1("Shutting down game session")
		Network.shutdown_game_session()
	end
end

function GameNetworkManager.game(arg_22_0)
	return arg_22_0.game_session
end

function GameNetworkManager.game_object_or_level_unit(arg_23_0, arg_23_1, arg_23_2)
	if arg_23_2 then
		local var_23_0 = LevelHelper:current_level(arg_23_0._world)

		return (Level.unit_by_index(var_23_0, arg_23_1))
	else
		return (Managers.state.unit_storage:unit(arg_23_1))
	end
end

function GameNetworkManager.game_object_or_level_id(arg_24_0, arg_24_1)
	if not Unit.alive(arg_24_1) then
		return nil, false
	end

	local var_24_0 = Managers.state.unit_storage:go_id(arg_24_1)

	if var_24_0 ~= nil then
		return var_24_0, false
	end

	local var_24_1 = LevelHelper:current_level(arg_24_0._world)
	local var_24_2 = Level.unit_index(var_24_1, arg_24_1)

	if var_24_2 then
		return var_24_2, true
	end
end

function GameNetworkManager.level_object_id(arg_25_0, arg_25_1)
	local var_25_0 = LevelHelper:current_level(arg_25_0._world)

	return Level.unit_index(var_25_0, arg_25_1)
end

function GameNetworkManager.unit_game_object_id(arg_26_0, arg_26_1)
	local var_26_0 = arg_26_0.unit_storage:go_id(arg_26_1)

	if var_26_0 then
		return var_26_0
	end
end

function GameNetworkManager.game_object_template(arg_27_0, arg_27_1)
	return var_0_0[arg_27_1]
end

function GameNetworkManager.request_profile(arg_28_0, arg_28_1, arg_28_2, arg_28_3, arg_28_4)
	if arg_28_0.network_server then
		arg_28_0.network_server:request_profile(arg_28_1, arg_28_2, arg_28_3, arg_28_4)
	end

	if arg_28_0.network_client then
		arg_28_0.network_client:request_profile(arg_28_1, arg_28_2, arg_28_3, arg_28_4)
	end
end

function GameNetworkManager.create_game_object(arg_29_0, arg_29_1, arg_29_2, arg_29_3)
	local var_29_0 = GameSession.create_game_object(arg_29_0.game_session, arg_29_1, arg_29_2)

	arg_29_0._game_object_types[var_29_0] = arg_29_1
	arg_29_0._game_object_disconnect_callbacks[var_29_0] = arg_29_3

	var_0_1("Created game object of type '%s' with go_id=%d", arg_29_1, var_29_0)

	return var_29_0
end

function GameNetworkManager.create_player_game_object(arg_30_0, arg_30_1, arg_30_2, arg_30_3)
	fassert(arg_30_0.is_server, "create_player_game_object: FAIL")

	local var_30_0 = GameSession.create_game_object(arg_30_0.game_session, arg_30_1, arg_30_2)

	arg_30_0._game_object_types[var_30_0] = "player"
	arg_30_0._game_object_disconnect_callbacks[var_30_0] = arg_30_3

	var_0_1("Created player game object of type '%s' with go_id=%d", arg_30_1, var_30_0)

	return var_30_0
end

function GameNetworkManager.cb_spawn_point_game_object_created(arg_31_0, arg_31_1, arg_31_2)
	Managers.state.event:trigger("event_create_client_spawnpoint", arg_31_1)

	if script_data.spawn_debug then
		print("spawn created", arg_31_1)
	end
end

function GameNetworkManager.game_object_created_player(arg_32_0, arg_32_1, arg_32_2)
	assert(not arg_32_0.is_server, "game_object_created_player: FAIL")

	local var_32_0 = GameSession.game_object_field(arg_32_0.game_session, arg_32_1, "network_id")
	local var_32_1 = GameSession.game_object_field(arg_32_0.game_session, arg_32_1, "local_player_id")

	var_0_1("game_object_created_player, go_id=%d, owner_peer_id=%s peer_id=%s", arg_32_1, arg_32_2, var_32_0)

	local var_32_2 = arg_32_0.player_manager

	if var_32_0 == arg_32_0.peer_id then
		var_0_1("PLAYER is local player")

		local var_32_3 = var_32_2:player(var_32_0, var_32_1)

		var_32_3:set_game_object_id(arg_32_1)
		var_32_3:create_sync_data()

		local var_32_4 = var_32_3:stats_id()

		arg_32_0.statistics_db:sync_stats_to_server(var_32_4, var_32_0, var_32_1, arg_32_0.network_transmit)
		var_0_1("PLAYER TYPE: %s", var_32_3:type())
	else
		var_0_1("PLAYER ADDED go_id = %d, peer_id = %s, self.peer_id = %s", arg_32_1, var_32_0, arg_32_0.peer_id)

		local var_32_5 = GameSession.game_object_field(arg_32_0.game_session, arg_32_1, "player_controlled")
		local var_32_6 = GameSession.game_object_field(arg_32_0.game_session, arg_32_1, "account_id")

		var_0_1("ADDING REMOTE PLAYER FOR PEER %s", var_32_0)

		local var_32_7 = var_32_2:add_remote_player(var_32_0, var_32_5, var_32_1, nil, var_32_6)

		var_32_7:set_game_object_id(arg_32_1)
		var_32_7:create_sync_data()
	end
end

function GameNetworkManager.game_object_destroyed_player(arg_33_0, arg_33_1, arg_33_2)
	local var_33_0 = GameSession.game_object_field(arg_33_0.game_session, arg_33_1, "network_id")
	local var_33_1 = GameSession.game_object_field(arg_33_0.game_session, arg_33_1, "local_player_id")

	var_0_1("game_object_destroyed_player, game_object_id=%i owner_peer_id=%s peer_id=%s", arg_33_1, arg_33_2, var_33_0)

	local var_33_2 = arg_33_0.player_manager

	if var_33_0 ~= arg_33_0.peer_id then
		var_33_2:remove_player(var_33_0, var_33_1)
		var_0_1("removing peer_id=%s local_player_id=%d", var_33_0, var_33_1)
	else
		var_0_1("not removing peer_id=%s local_player_id=%d", var_33_0, var_33_1)
		var_33_2:player_from_peer_id(var_33_0, var_33_1):game_object_destroyed()
	end
end

function GameNetworkManager.game_object_created_player_unit_health(arg_34_0, arg_34_1, arg_34_2)
	local var_34_0 = arg_34_0:_health_extension(arg_34_1)

	if var_34_0 == nil then
		return
	end

	var_34_0:set_health_game_object_id(arg_34_1)
end

function GameNetworkManager.game_object_destroyed_player_unit_health(arg_35_0, arg_35_1, arg_35_2)
	local var_35_0 = arg_35_0:_health_extension(arg_35_1)

	if var_35_0 == nil then
		return
	end

	var_35_0:set_health_game_object_id(nil)
end

function GameNetworkManager.game_object_created_dark_pact_horde_ability(arg_36_0, arg_36_1, arg_36_2)
	local var_36_0 = GameSession.game_object_field(arg_36_0.game_session, arg_36_1, "unit_game_object_id")
	local var_36_1 = arg_36_0.unit_storage:unit(var_36_0)

	if var_36_1 == nil then
		return nil
	end

	local var_36_2 = ScriptUnit.extension(var_36_1, "versus_horde_ability_system")

	if var_36_2 == nil then
		return nil
	end

	var_36_2:set_ability_game_object_id(arg_36_1)
end

function GameNetworkManager.game_object_destroyed_dark_pact_horde_ability(arg_37_0, arg_37_1, arg_37_2)
	local var_37_0 = GameSession.game_object_field(arg_37_0.game_session, arg_37_1, "unit_game_object_id")
	local var_37_1 = arg_37_0.unit_storage:unit(var_37_0)

	if var_37_1 == nil then
		return nil
	end

	local var_37_2 = ScriptUnit.extension(var_37_1, "versus_horde_ability_system")

	if var_37_2 == nil then
		return nil
	end

	var_37_2:set_ability_game_object_id(nil)
end

function GameNetworkManager.game_object_created_player_sync_data(arg_38_0, arg_38_1, arg_38_2)
	local var_38_0 = GameSession.game_object_field(arg_38_0.game_session, arg_38_1, "network_id")
	local var_38_1 = GameSession.game_object_field(arg_38_0.game_session, arg_38_1, "local_player_id")

	printf("Adding player sync data to peer=%s local_player_id=%s", var_38_0, var_38_1)

	local var_38_2 = arg_38_0.player_manager:player(var_38_0, var_38_1)

	if var_38_2 then
		var_38_2:set_sync_data_game_object_id(arg_38_1)
	end
end

function GameNetworkManager.game_object_destroyed_player_sync_data(arg_39_0, arg_39_1, arg_39_2)
	local var_39_0 = GameSession.game_object_field(arg_39_0.game_session, arg_39_1, "network_id")
	local var_39_1 = GameSession.game_object_field(arg_39_0.game_session, arg_39_1, "local_player_id")
	local var_39_2 = arg_39_0.player_manager:player(var_39_0, var_39_1)

	if var_39_2 and var_39_2.remote then
		var_39_2:set_sync_data_game_object_id(nil)
	end
end

function GameNetworkManager._health_extension(arg_40_0, arg_40_1)
	local var_40_0 = GameSession.game_object_field(arg_40_0.game_session, arg_40_1, "unit_game_object_id")
	local var_40_1 = arg_40_0.unit_storage:unit(var_40_0)

	if var_40_1 == nil then
		return nil
	end

	return (ScriptUnit.extension(var_40_1, "health_system"))
end

function GameNetworkManager._career_extension(arg_41_0, arg_41_1)
	local var_41_0 = GameSession.game_object_field(arg_41_0.game_session, arg_41_1, "unit_game_object_id")
	local var_41_1 = arg_41_0.unit_storage:unit(var_41_0)

	if var_41_1 == nil then
		return nil
	end

	return (ScriptUnit.extension(var_41_1, "career_system"))
end

function GameNetworkManager.game_object_created(arg_42_0, arg_42_1, arg_42_2)
	local var_42_0 = GameSession.game_object_field(arg_42_0.game_session, arg_42_1, "go_type")
	local var_42_1 = NetworkLookup.go_types[var_42_0]
	local var_42_2 = var_0_0[var_42_1]
	local var_42_3 = var_42_2.game_object_created_func_name
	local var_42_4 = var_42_2.game_session_disconnect_func_name

	if var_42_4 then
		local function var_42_5(arg_43_0)
			arg_42_0[var_42_4](arg_42_0, arg_43_0)
		end

		arg_42_0._game_object_disconnect_callbacks[arg_42_1] = var_42_5
	end

	var_0_1("game object created go_id=%d, owner_id=%s go_type=%s go_created_func_name=%s", arg_42_1, arg_42_2, var_42_1, var_42_3)

	local var_42_6 = arg_42_0[var_42_3]

	assert(var_42_6)
	var_42_6(arg_42_0, arg_42_1, arg_42_2, var_42_2)
end

function GameNetworkManager.game_object_created_network_unit(arg_44_0, arg_44_1, arg_44_2, arg_44_3)
	return arg_44_0.unit_spawner:spawn_unit_from_game_object(arg_44_1, arg_44_2, arg_44_3)
end

function GameNetworkManager.game_object_created_music_states(arg_45_0, arg_45_1, arg_45_2, arg_45_3)
	Managers.music:game_object_created(arg_45_1, arg_45_2, arg_45_3)
end

function GameNetworkManager.game_object_created_keep_decoration(arg_46_0, arg_46_1, arg_46_2, arg_46_3)
	local var_46_0 = GameSession.game_object_field(arg_46_0.game_session, arg_46_1, "level_unit_index")
	local var_46_1 = LevelHelper:current_level(arg_46_0._world)
	local var_46_2 = Level.unit_by_index(var_46_1, var_46_0)

	ScriptUnit.extension(var_46_2, "keep_decoration_system"):on_game_object_created(arg_46_1)
end

function GameNetworkManager.game_object_destroyed_keep_decoration(arg_47_0, arg_47_1, arg_47_2, arg_47_3)
	local var_47_0 = GameSession.game_object_field(arg_47_0.game_session, arg_47_1, "level_unit_index")
	local var_47_1 = LevelHelper:current_level(arg_47_0._world)
	local var_47_2 = Level.unit_by_index(var_47_1, var_47_0)

	ScriptUnit.extension(var_47_2, "keep_decoration_system"):on_game_object_destroyed()
end

function GameNetworkManager.game_object_created_progress_timer(arg_48_0, arg_48_1, arg_48_2, arg_48_3)
	local var_48_0 = GameSession.game_object_field(arg_48_0.game_session, arg_48_1, "level_unit_index")
	local var_48_1 = LevelHelper:current_level(arg_48_0._world)
	local var_48_2 = Level.unit_by_index(var_48_1, var_48_0)

	ScriptUnit.extension(var_48_2, "progress_system"):on_game_object_created(arg_48_1)
end

function GameNetworkManager.game_object_destroyed_progress_timer(arg_49_0, arg_49_1, arg_49_2, arg_49_3)
	local var_49_0 = GameSession.game_object_field(arg_49_0.game_session, arg_49_1, "level_unit_index")
	local var_49_1 = LevelHelper:current_level(arg_49_0._world)
	local var_49_2 = Level.unit_by_index(var_49_1, var_49_0)

	ScriptUnit.extension(var_49_2, "progress_system"):on_game_object_destroyed()
end

function GameNetworkManager.game_object_created_game_mode_data(arg_50_0, arg_50_1, arg_50_2, arg_50_3)
	Managers.state.game_mode:on_game_mode_data_created(arg_50_0.game_session, arg_50_1)
end

function GameNetworkManager.game_object_destroyed_game_mode_data(arg_51_0, arg_51_1, arg_51_2, arg_51_3)
	Managers.state.game_mode:on_game_mode_data_destroyed()
end

function GameNetworkManager.game_object_created_weave(arg_52_0, arg_52_1, arg_52_2, arg_52_3)
	Managers.weave:game_object_created(arg_52_1)
end

function GameNetworkManager.game_object_destroyed_weave(arg_53_0, arg_53_1)
	Managers.weave:game_object_destroyed(arg_53_1)
end

function GameNetworkManager.game_object_created_objective(arg_54_0, arg_54_1, arg_54_2, arg_54_3)
	Managers.state.entity:system("objective_system"):game_object_created(arg_54_0.game_session, arg_54_1)
end

function GameNetworkManager.game_object_destroyed_objective(arg_55_0, arg_55_1)
	Managers.state.entity:system("objective_system"):game_object_destroyed(arg_55_0.game_session, arg_55_1)
end

function GameNetworkManager.game_object_created_horde_surge(arg_56_0, arg_56_1, arg_56_2, arg_56_3)
	Managers.state.game_mode:game_mode()._horde_surge_handler._game_object_id = arg_56_1
end

function GameNetworkManager.game_object_destroyed_horde_surge(arg_57_0, arg_57_1)
	Managers.state.game_mode:game_mode()._horde_surge_handler._game_object_id = nil
end

function GameNetworkManager.destroy_game_object(arg_58_0, arg_58_1)
	var_0_1("destroying game object with go_id=%d", arg_58_1)

	arg_58_0._game_object_disconnect_callbacks[arg_58_1] = nil

	GameSession.destroy_game_object(arg_58_0.game_session, arg_58_1)
end

function GameNetworkManager.game_object_destroyed(arg_59_0, arg_59_1, arg_59_2)
	local var_59_0 = GameSession.game_object_field(arg_59_0.game_session, arg_59_1, "go_type")
	local var_59_1 = NetworkLookup.go_types[var_59_0]
	local var_59_2 = var_0_0[var_59_1]
	local var_59_3 = var_59_2.game_object_destroyed_func_name

	arg_59_0[var_59_3](arg_59_0, arg_59_1, arg_59_2, var_59_2)

	arg_59_0._game_object_disconnect_callbacks[arg_59_1] = nil

	var_0_1("game object was destroyed id=%d with type=%s, object_destroy_func=%s, owned by peer=%s", arg_59_1, var_59_1, var_59_3, arg_59_2)
end

function GameNetworkManager.game_object_created_player_unit(arg_60_0, arg_60_1, arg_60_2, arg_60_3)
	if arg_60_0.is_server then
		arg_60_0.network_server:peer_spawned_player(arg_60_2)
	end

	local var_60_0 = arg_60_0:game_object_created_network_unit(arg_60_1, arg_60_2, arg_60_3)
	local var_60_1 = Managers.player:owner(var_60_0)

	Managers.state.event:trigger("new_player_unit", var_60_1, var_60_0, var_60_1:unique_id())
end

function GameNetworkManager.game_object_destroyed_player_unit(arg_61_0, arg_61_1, arg_61_2, arg_61_3)
	local var_61_0 = arg_61_0.unit_storage:unit(arg_61_1)

	if arg_61_0.is_server then
		arg_61_0.network_server:peer_despawned_player(arg_61_2)
	end

	arg_61_0:game_object_destroyed_network_unit(arg_61_1, arg_61_2, arg_61_3)

	if DEDICATED_SERVER then
		return false
	end

	local var_61_1 = ScriptUnit.has_extension(var_61_0, "health_system").last_damage_data

	if var_61_1 then
		local var_61_2 = Managers.player:local_player()

		if var_61_1.attacker_unique_id == var_61_2:unique_id() then
			local var_61_3 = POSITION_LOOKUP[var_61_2.player_unit]
			local var_61_4 = POSITION_LOOKUP[var_61_0]

			Managers.telemetry_events:local_player_killed_player(var_61_2, var_61_3, var_61_4)
		end
	end
end

function GameNetworkManager.game_object_destroyed_network_unit(arg_62_0, arg_62_1, arg_62_2, arg_62_3)
	arg_62_0.unit_spawner:destroy_game_object_unit(arg_62_1, arg_62_2, arg_62_3)
end

function GameNetworkManager.game_object_destroyed_music_states(arg_63_0, arg_63_1, arg_63_2, arg_63_3)
	var_0_1("MUSIC object destroyed")
	Managers.music:game_object_destroyed(arg_63_1, arg_63_2, arg_63_3)
end

function GameNetworkManager.game_object_migrated_away(arg_64_0, arg_64_1, arg_64_2)
	assert(false, "Not implemented.")
end

function GameNetworkManager.game_object_migrated_to_me(arg_65_0, arg_65_1, arg_65_2)
	assert(false, "Not implemented.")
end

function GameNetworkManager.game_session_disconnect(arg_66_0, arg_66_1)
	var_0_1("Engine called game_session_disconnect callback")

	arg_66_0._game_session_disconnect = true

	for iter_66_0, iter_66_1 in pairs(arg_66_0._game_object_disconnect_callbacks) do
		iter_66_1(iter_66_0)
	end

	arg_66_0.unit_spawner.game_session = nil
end

function GameNetworkManager.game_session_disconnect_music_states(arg_67_0, arg_67_1)
	Managers.music:client_game_session_disconnect_music_states(arg_67_1)
end

function GameNetworkManager.game_object_destroyed_do_nothing(arg_68_0)
	return
end

function GameNetworkManager.game_object_created_sync_unit(arg_69_0, arg_69_1, arg_69_2, arg_69_3)
	Managers.state.entity:system("game_object_system"):game_object_created(arg_69_1, arg_69_2, arg_69_3)
end

function GameNetworkManager.game_object_destroyed_sync_unit(arg_70_0, arg_70_1, arg_70_2, arg_70_3)
	return
end

function GameNetworkManager.game_object_created_payload(arg_71_0, arg_71_1, arg_71_2, arg_71_3)
	local var_71_0 = GameSession.game_object_field(arg_71_0.game_session, arg_71_1, "level_unit_index")
	local var_71_1 = LevelHelper:current_level(arg_71_0._world)
	local var_71_2 = Level.unit_by_index(var_71_1, var_71_0)

	ScriptUnit.extension(var_71_2, "payload_system"):set_game_object_id(arg_71_1)
end

function GameNetworkManager.game_object_destroyed_payload(arg_72_0, arg_72_1)
	return
end

function GameNetworkManager.game_object_created_twitch_vote(arg_73_0, arg_73_1, arg_73_2, arg_73_3)
	Managers.twitch:add_game_object_id(arg_73_1)
end

function GameNetworkManager.game_object_destroyed_twitch_vote(arg_74_0, arg_74_1)
	Managers.twitch:remove_game_object_id(arg_74_1)
end

function GameNetworkManager.game_object_created_career_data(arg_75_0, arg_75_1, arg_75_2)
	local var_75_0 = arg_75_0:_career_extension(arg_75_1)

	if var_75_0 == nil then
		return
	end

	var_75_0:set_career_game_object_id(arg_75_1)
end

function GameNetworkManager.game_object_destroyed_career_data(arg_76_0, arg_76_1, arg_76_2)
	local var_76_0 = arg_76_0:_career_extension(arg_76_1)

	if var_76_0 == nil then
		return
	end

	var_76_0:set_career_game_object_id(nil)
end

function GameNetworkManager.remove_peer(arg_77_0, arg_77_1)
	if arg_77_0._object_synchronizing_clients[arg_77_1] then
		arg_77_0._object_synchronizing_clients[arg_77_1] = nil

		arg_77_0.network_transmit:remove_peer_ignore(arg_77_1)
	end

	if Managers.game_server ~= nil then
		Managers.game_server:remove_peer(arg_77_1)
	end

	arg_77_0.player_manager:remove_all_players_from_peer(arg_77_1)

	if arg_77_0.room_manager and arg_77_0.room_manager:has_room(arg_77_1) then
		arg_77_0.room_manager:destroy_room(arg_77_1)
	end
end

function GameNetworkManager.set_peer_synchronizing(arg_78_0, arg_78_1)
	arg_78_0._object_synchronizing_clients[arg_78_1] = true

	arg_78_0.network_transmit:add_peer_ignore(arg_78_1)
end

function GameNetworkManager.hot_join_sync(arg_79_0, arg_79_1)
	if Managers.state.debug then
		Managers.state.debug:hot_join_sync(arg_79_1)
	end

	arg_79_0.difficulty_manager:hot_join_sync(arg_79_1)
	arg_79_0.weave_manager:hot_join_sync(arg_79_1)
	arg_79_0.entity_system:hot_join_sync(arg_79_1)
	arg_79_0.game_mode:hot_join_sync(arg_79_1)
	arg_79_0.networked_flow_state:hot_join_sync(arg_79_1)
	arg_79_0.voting_manager:hot_join_sync(arg_79_1)
	arg_79_0.statistics_db:hot_join_sync(arg_79_1)
	Managers.deed:hot_join_sync(arg_79_1)
	LoadoutUtils.hot_join_sync(arg_79_1)

	if arg_79_0.matchmaking_manager then
		arg_79_0.matchmaking_manager:hot_join_sync(arg_79_1)
	end

	if arg_79_0.game_server_manager then
		arg_79_0.game_server_manager:hot_join_sync(arg_79_1)
	end

	if arg_79_0.room_manager then
		arg_79_0.room_manager:hot_join_sync(arg_79_1)
	end

	if Managers.venture.challenge then
		Managers.venture.challenge:hot_join_sync(arg_79_1)
	end

	if Managers.venture.quickplay then
		Managers.venture.quickplay:hot_join_sync(arg_79_1)
	end

	if Managers.state.conflict then
		Managers.state.conflict:hot_join_sync(arg_79_1)
	end

	local var_79_0 = PEER_ID_TO_CHANNEL[arg_79_1]

	RPC.rpc_to_client_sync_session_id(var_79_0, arg_79_0._session_id)

	arg_79_0._object_synchronizing_clients[arg_79_1] = nil

	arg_79_0.network_transmit:remove_peer_ignore(arg_79_1)
end

function GameNetworkManager.rpc_play_particle_effect(arg_80_0, arg_80_1, arg_80_2, arg_80_3, arg_80_4, arg_80_5, arg_80_6, arg_80_7)
	if arg_80_0.is_server then
		arg_80_0.network_transmit:send_rpc_clients("rpc_play_particle_effect", arg_80_2, arg_80_3, arg_80_4, arg_80_5, arg_80_6, arg_80_7)
	end

	local var_80_0 = arg_80_0.unit_storage:unit(arg_80_3)
	local var_80_1 = NetworkLookup.effects[arg_80_2]

	Managers.state.event:trigger("event_play_particle_effect", var_80_1, var_80_0, arg_80_4, arg_80_5, arg_80_6, arg_80_7)
end

function GameNetworkManager.rpc_play_particle_effect_no_rotation(arg_81_0, arg_81_1, arg_81_2, arg_81_3, arg_81_4, arg_81_5, arg_81_6)
	if arg_81_0.is_server then
		arg_81_0.network_transmit:send_rpc_clients("rpc_play_particle_effect_no_rotation", arg_81_2, arg_81_3, arg_81_4, arg_81_5, arg_81_6)
	end

	local var_81_0 = arg_81_0.unit_storage:unit(arg_81_3)
	local var_81_1 = NetworkLookup.effects[arg_81_2]

	Managers.state.event:trigger("event_play_particle_effect", var_81_1, var_81_0, arg_81_4, arg_81_5, Quaternion.identity(), arg_81_6)
end

function GameNetworkManager.rpc_play_particle_effect_with_variable(arg_82_0, arg_82_1, arg_82_2, arg_82_3, arg_82_4, arg_82_5, arg_82_6)
	if arg_82_0.is_server then
		arg_82_0.network_transmit:send_rpc_clients("rpc_play_particle_effect_with_variable", arg_82_2, arg_82_3, arg_82_4, arg_82_5, arg_82_6)
	end

	local var_82_0 = NetworkLookup.effects[arg_82_2]
	local var_82_1 = arg_82_0._world
	local var_82_2 = World.find_particles_variable(var_82_1, var_82_0, arg_82_5)
	local var_82_3 = World.create_particles(var_82_1, var_82_0, arg_82_3, arg_82_4)

	World.set_particles_variable(var_82_1, var_82_3, var_82_2, arg_82_6)
end

function GameNetworkManager.rpc_play_particle_effect_spline(arg_83_0, arg_83_1, arg_83_2, arg_83_3, arg_83_4)
	if arg_83_0.is_server then
		arg_83_0.network_transmit:send_rpc_clients("rpc_play_particle_effect_spline", arg_83_2, arg_83_3, arg_83_4)
	end

	local var_83_0 = NetworkLookup.effects[arg_83_2]
	local var_83_1 = arg_83_0._world
	local var_83_2 = World.create_particles(var_83_1, var_83_0, arg_83_4[1])

	for iter_83_0 = 1, #arg_83_4 do
		World.set_particles_variable(var_83_1, var_83_2, arg_83_3[iter_83_0], arg_83_4[iter_83_0])
	end
end

function GameNetworkManager._pack_percentages_completed_arrays(arg_84_0, arg_84_1)
	local var_84_0 = {}
	local var_84_1 = {}
	local var_84_2 = {}
	local var_84_3 = 1
	local var_84_4 = Managers.player

	for iter_84_0, iter_84_1 in pairs(arg_84_1) do
		local var_84_5 = var_84_4:player_from_unique_id(iter_84_0)

		if var_84_5 then
			local var_84_6 = var_84_5:network_id()

			var_84_1[var_84_3], var_84_0[var_84_3] = var_84_5:local_player_id(), var_84_6
			var_84_2[var_84_3] = iter_84_1
			var_84_3 = var_84_3 + 1
		end
	end

	return var_84_0, var_84_1, var_84_2
end

function GameNetworkManager._unpack_percentages_completed_arrays(arg_85_0, arg_85_1, arg_85_2, arg_85_3)
	local var_85_0 = {}
	local var_85_1 = Managers.player

	for iter_85_0 = 1, #arg_85_1 do
		local var_85_2 = arg_85_1[iter_85_0]
		local var_85_3 = arg_85_2[iter_85_0]
		local var_85_4 = arg_85_3[iter_85_0]
		local var_85_5 = var_85_1:player(var_85_2, var_85_3)

		if var_85_5 then
			var_85_0[var_85_5:unique_id()] = math.clamp(var_85_4, 0, 1)
		end
	end

	return var_85_0
end

function GameNetworkManager.gm_event_end_conditions_met(arg_86_0, arg_86_1, arg_86_2, arg_86_3)
	local var_86_0, var_86_1, var_86_2 = arg_86_0:_pack_percentages_completed_arrays(arg_86_3)
	local var_86_3 = NetworkLookup.game_end_reasons[arg_86_1]

	arg_86_0.network_transmit:send_rpc_clients("rpc_gm_event_end_conditions_met", var_86_3, arg_86_2, var_86_0, var_86_1, var_86_2)
end

function GameNetworkManager.rpc_gm_event_end_conditions_met(arg_87_0, arg_87_1, arg_87_2, arg_87_3, arg_87_4, arg_87_5, arg_87_6)
	if not arg_87_0.is_server then
		local var_87_0 = arg_87_0:_unpack_percentages_completed_arrays(arg_87_4, arg_87_5, arg_87_6)
		local var_87_1 = NetworkLookup.game_end_reasons[arg_87_2]

		Managers.state.game_mode:set_end_reason(var_87_1)
		Managers.state.game_mode:trigger_event("end_conditions_met", var_87_1, arg_87_3, var_87_0)
	end
end

function GameNetworkManager.gm_event_round_started(arg_88_0)
	local var_88_0 = 0

	arg_88_0.network_transmit:send_rpc_clients("rpc_gm_event_round_started", var_88_0)
end

function GameNetworkManager.rpc_gm_event_round_started(arg_89_0, arg_89_1, arg_89_2)
	Managers.state.game_mode:trigger_event("round_started", arg_89_2)
end

function GameNetworkManager.gm_event_initial_peers_spawned(arg_90_0)
	arg_90_0.network_transmit:send_rpc_clients("rpc_gm_event_initial_peers_spawned")
end

function GameNetworkManager.rpc_gm_event_initial_peers_spawned(arg_91_0, arg_91_1)
	Managers.state.game_mode:trigger_event("initial_peers_spawned")
end

function GameNetworkManager.rpc_play_melee_hit_effects(arg_92_0, arg_92_1, arg_92_2, arg_92_3, arg_92_4, arg_92_5)
	local var_92_0 = arg_92_0.unit_storage:unit(arg_92_5)

	if not Unit.alive(var_92_0) then
		return
	end

	if arg_92_0.is_server then
		local var_92_1 = CHANNEL_TO_PEER_ID[arg_92_1]

		arg_92_0.network_transmit:send_rpc_clients_except("rpc_play_melee_hit_effects", var_92_1, arg_92_2, arg_92_3, arg_92_4, arg_92_5)
	end

	local var_92_2 = NetworkLookup.sound_events[arg_92_2]
	local var_92_3 = NetworkLookup.melee_impact_sound_types[arg_92_4]

	EffectHelper.play_melee_hit_effects(var_92_2, arg_92_0._world, arg_92_3, var_92_3, true, var_92_0)
end

function GameNetworkManager.rpc_request_spawn_template_unit(arg_93_0, arg_93_1, arg_93_2, arg_93_3, arg_93_4, arg_93_5, arg_93_6, arg_93_7)
	local var_93_0 = arg_93_0.unit_storage:unit(arg_93_5)
	local var_93_1 = NetworkLookup.spawn_unit_templates[arg_93_2]

	SpawnUnitTemplates[var_93_1].spawn_func(var_93_0, arg_93_3, arg_93_4, arg_93_6)
end

function GameNetworkManager.rpc_surface_mtr_fx(arg_94_0, arg_94_1, arg_94_2, arg_94_3, arg_94_4, arg_94_5, arg_94_6, arg_94_7)
	local var_94_0 = arg_94_0.unit_storage:unit(arg_94_3)

	if not Unit.alive(var_94_0) then
		return
	end

	if arg_94_0.is_server then
		local var_94_1 = CHANNEL_TO_PEER_ID[arg_94_1]

		arg_94_0.network_transmit:send_rpc_clients_except("rpc_surface_mtr_fx", var_94_1, arg_94_2, arg_94_3, arg_94_4, arg_94_5, arg_94_6, arg_94_7)
	end

	local var_94_2

	if arg_94_7 > 0 then
		var_94_2 = Unit.actor(var_94_0, arg_94_7)
	end

	local var_94_3 = NetworkLookup.surface_material_effects[arg_94_2]

	EffectHelper.play_surface_material_effects(var_94_3, arg_94_0._world, var_94_0, arg_94_4, arg_94_5, arg_94_6, nil, true, nil, var_94_2)
end

function GameNetworkManager.rpc_surface_mtr_fx_lvl_unit(arg_95_0, arg_95_1, arg_95_2, arg_95_3, arg_95_4, arg_95_5, arg_95_6, arg_95_7)
	local var_95_0 = LevelHelper:current_level(arg_95_0._world)
	local var_95_1 = Level.unit_by_index(var_95_0, arg_95_3)

	if not Unit.alive(var_95_1) then
		return
	end

	if arg_95_0.is_server then
		local var_95_2 = CHANNEL_TO_PEER_ID[arg_95_1]

		arg_95_0.network_transmit:send_rpc_clients_except("rpc_surface_mtr_fx_lvl_unit", var_95_2, arg_95_2, arg_95_3, arg_95_4, arg_95_5, arg_95_6, arg_95_7)
	end

	local var_95_3

	if arg_95_7 > 0 then
		var_95_3 = Unit.actor(var_95_1, arg_95_7)
	end

	local var_95_4 = NetworkLookup.surface_material_effects[arg_95_2]

	EffectHelper.play_surface_material_effects(var_95_4, arg_95_0._world, var_95_1, arg_95_4, arg_95_5, arg_95_6, nil, true, nil, var_95_3)
end

function GameNetworkManager.rpc_skinned_surface_mtr_fx(arg_96_0, arg_96_1, arg_96_2, arg_96_3, arg_96_4, arg_96_5)
	if arg_96_0.is_server then
		local var_96_0 = CHANNEL_TO_PEER_ID[arg_96_1]

		arg_96_0.network_transmit:send_rpc_clients_except("rpc_skinned_surface_mtr_fx", var_96_0, arg_96_2, arg_96_3, arg_96_4, arg_96_5)
	end

	local var_96_1 = NetworkLookup.surface_material_effects[arg_96_2]

	EffectHelper.play_skinned_surface_material_effects(var_96_1, arg_96_0._world, nil, arg_96_3, arg_96_4, arg_96_5, true)
end

function GameNetworkManager.game_session_host(arg_97_0)
	return arg_97_0.game_session and (arg_97_0._game_session_host or GameSession.game_session_host(arg_97_0.game_session))
end

function GameNetworkManager.rpc_enemy_is_alerted(arg_98_0, arg_98_1, arg_98_2, arg_98_3)
	local var_98_0 = arg_98_0.unit_storage:unit(arg_98_2)
	local var_98_1 = "detect"

	if arg_98_3 then
		local var_98_2 = Unit.node(var_98_0, "c_head")
		local var_98_3 = "player_1"
		local var_98_4 = Vector3(255, 0, 0)
		local var_98_5 = Vector3(0, 0, 1)
		local var_98_6 = 0.5
		local var_98_7 = "!"

		Managers.state.debug_text:output_unit_text(var_98_7, var_98_6, var_98_0, var_98_2, var_98_5, nil, var_98_1, var_98_4, var_98_3)
	else
		local var_98_8 = "detect"

		Managers.state.debug_text:clear_unit_text(var_98_0, var_98_8)
	end
end

function GameNetworkManager.rpc_ladder_shake(arg_99_0, arg_99_1, arg_99_2)
	local var_99_0 = Level.unit_by_index(LevelHelper:current_level(arg_99_0._world), arg_99_2)

	ScriptUnit.extension(var_99_0, "ladder_system"):shake()
end

function GameNetworkManager.rpc_assist(arg_100_0, arg_100_1, arg_100_2, arg_100_3, arg_100_4, arg_100_5, arg_100_6, arg_100_7)
	local var_100_0 = Managers.player
	local var_100_1 = var_100_0:player(arg_100_2, arg_100_3)
	local var_100_2 = var_100_0:player(arg_100_4, arg_100_5)
	local var_100_3 = NetworkLookup.coop_feedback[arg_100_6]
	local var_100_4 = arg_100_0.unit_storage:unit(arg_100_7)
	local var_100_5 = not var_100_1.remote and not var_100_2.bot_player

	Managers.state.event:trigger("add_coop_feedback", var_100_1:stats_id() .. var_100_2:stats_id(), var_100_5, var_100_3, var_100_1, var_100_2)

	local var_100_6 = var_100_1.player_unit
	local var_100_7 = var_100_2.player_unit

	if var_100_7 and not var_100_2.remote then
		local var_100_8 = ScriptUnit.has_extension(var_100_7, "buff_system")

		if var_100_8 then
			var_100_8:trigger_procs("on_assisted", var_100_6, var_100_4)
		end
	end

	if var_100_6 and not var_100_1.remote then
		local var_100_9 = ScriptUnit.has_extension(var_100_6, "buff_system")

		if var_100_9 then
			var_100_9:trigger_procs("on_assisted_ally", var_100_7, var_100_4)
		end
	end

	if var_100_3 == "save" then
		local var_100_10 = var_100_1:stats_id()

		Managers.player:statistics_db():increment_stat(var_100_10, "saves")
	elseif var_100_3 == "aid" then
		local var_100_11 = var_100_1:stats_id()

		Managers.player:statistics_db():increment_stat(var_100_11, "aidings")
	end
end

function GameNetworkManager.rpc_coop_feedback(arg_101_0, arg_101_1, arg_101_2, arg_101_3, arg_101_4, arg_101_5, arg_101_6)
	if arg_101_0.is_server then
		local var_101_0 = CHANNEL_TO_PEER_ID[arg_101_1]

		Managers.state.network.network_transmit:send_rpc_clients_except("rpc_coop_feedback", var_101_0, arg_101_2, arg_101_3, arg_101_4, arg_101_5, arg_101_6)
	end

	local var_101_1 = NetworkLookup.coop_feedback[arg_101_4]
	local var_101_2 = Managers.player
	local var_101_3 = var_101_2:player(arg_101_2, arg_101_3)
	local var_101_4 = var_101_2:player(arg_101_5, arg_101_6)
	local var_101_5 = not var_101_3.remote and not var_101_3.bot_player
	local var_101_6 = Managers.player:statistics_db()

	if var_101_1 == "aid" then
		var_101_6:increment_stat(var_101_3:stats_id(), "aidings")
	elseif var_101_1 == "save" then
		var_101_6:increment_stat(var_101_3:stats_id(), "saves")
	elseif var_101_1 == "discarded_grimoire" then
		local var_101_7 = var_101_3.peer_id
		local var_101_8 = var_101_3:is_player_controlled()
		local var_101_9 = var_101_8 and (rawget(_G, "Steam") and Steam.user_name(var_101_7) or tostring(var_101_7)) or var_101_3:name()

		if IS_CONSOLE and not Managers.account:offline_mode() then
			local var_101_10 = Managers.state.network:lobby()

			var_101_9 = var_101_8 and (var_101_10:user_name(var_101_7) or tostring(var_101_7)) or var_101_3:name()
		end

		local var_101_11 = true
		local var_101_12 = string.format(Localize("system_chat_player_discarded_grimoire"), var_101_9)

		Managers.chat:add_local_system_message(1, var_101_12, var_101_11)
	end

	Managers.state.event:trigger("add_coop_feedback", var_101_3:stats_id() .. var_101_4:stats_id(), var_101_5, var_101_1, var_101_3, var_101_4)
end

function GameNetworkManager.rpc_flow_event(arg_102_0, arg_102_1, arg_102_2, arg_102_3)
	local var_102_0 = arg_102_0.unit_storage:unit(arg_102_2)

	if not var_102_0 then
		printf("unit from game_object_id %d is nil", arg_102_2)

		return
	end

	if arg_102_0.is_server then
		local var_102_1 = CHANNEL_TO_PEER_ID[arg_102_1]

		arg_102_0.network_transmit:send_rpc_clients_except("rpc_flow_event", var_102_1, arg_102_2, arg_102_3)
	end

	local var_102_2 = NetworkLookup.flow_events[arg_102_3]

	Unit.flow_event(var_102_0, var_102_2)
end

function GameNetworkManager.anim_event(arg_103_0, arg_103_1, arg_103_2)
	return Managers.state.entity:system("animation_system"):anim_event(arg_103_1, arg_103_2)
end

function GameNetworkManager.anim_event_with_variable_float(arg_104_0, arg_104_1, arg_104_2, arg_104_3, arg_104_4)
	Managers.state.entity:system("animation_system"):anim_event_with_variable_float(arg_104_1, arg_104_2, arg_104_3, arg_104_4)
end

function GameNetworkManager.anim_set_variable_float(arg_105_0, arg_105_1, arg_105_2, arg_105_3)
	local var_105_0 = arg_105_0.unit_storage:go_id(arg_105_1)

	fassert(var_105_0, "Unit storage does not have a game object id for %q", arg_105_1)

	local var_105_1 = NetworkLookup.anims[arg_105_2]

	if arg_105_0.game_session then
		if arg_105_0.is_server then
			arg_105_0.network_transmit:send_rpc_clients("rpc_anim_set_variable_float", var_105_0, var_105_1, arg_105_3)
		else
			arg_105_0.network_transmit:send_rpc_server("rpc_anim_set_variable_float", var_105_0, var_105_1, arg_105_3)
		end
	end

	local var_105_2 = Unit.animation_find_variable(arg_105_1, arg_105_2)

	Unit.animation_set_variable(arg_105_1, var_105_2, arg_105_3)
end
