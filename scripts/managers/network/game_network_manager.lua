-- chunkname: @scripts/managers/network/game_network_manager.lua

local var_0_0 = dofile("scripts/network/game_object_templates")

local function fn(arg_1_0, ...)
	-- function 1
	if not script_data.network_debug then
		printf("[GameNetworkManager] " .. arg_1_0, ...)
	end
end

GameNetworkManager = class(GameNetworkManager)

local num = 10
local num_2 = 1

GameNetworkManager.init = function (self, arg_2_1, arg_2_2, arg_2_3, arg_2_4)
	-- function 2
	print("GameNetworkManager:init... creating game session")

	local create_game_session = Network.create_game_session()

	fassert(create_game_session, "Failed to create game session")

	self.game_session = create_game_session

	if not arg_2_3 then
		printf("Host GameSession.make_game_session_host with session:", create_game_session)
		GameSession.make_game_session_host(create_game_session)

		self._session_id = Application.guid()
	else
		local game_session_host = GameSession.game_session_host(self.game_session)

		self._session_id = "<client-session-id>"

		if not (not game_session_host and game_session_host ~= "0") then
			game_session_host = arg_2_2:lobby_host()
		end

		fassert(not game_session_host and game_session_host ~= "0", "tried to join GameSession without a valid host.")

		local var_2_2 = PEER_ID_TO_CHANNEL[game_session_host]

		GameSession.join(create_game_session, var_2_2)

		self._game_session_host = game_session_host
	end

	self._world = arg_2_1
	self._lobby = arg_2_2
	self._lobby_host = arg_2_2:lobby_host()
	self.is_server = arg_2_3
	self._left_game = false
	self._game_object_types = {}
	self._object_synchronizing_clients = {}
	self._game_object_disconnect_callbacks = {}

	fn("Setting pong timeout to %s", tostring(GameSettingsDevelopment.network_timeout))
	Network.set_pong_timeout(GameSettingsDevelopment.network_timeout)
	dofile("scripts/network_lookup/network_constants")

	self.peer_id = Network.peer_id()

	fn("My own peer_id = %s", tostring(self.peer_id))
	fn("self.is_server = %s", tostring(self.is_server))

	local var_2_3 = self
	local set_small_network_packets = self.set_small_network_packets
	local user_setting = Application.user_setting("small_network_packets")

	user_setting = user_setting or DefaultUserSettings.get("user_settings", "small_network_packets")

	set_small_network_packets(var_2_3, user_setting)

	self._event_delegate = arg_2_4

	arg_2_4:register(self, "rpc_play_particle_effect_no_rotation", "rpc_play_particle_effect", "rpc_play_particle_effect_with_variable", "rpc_play_particle_effect_spline", "rpc_gm_event_end_conditions_met", "rpc_gm_event_round_started", "rpc_gm_event_initial_peers_spawned", "rpc_surface_mtr_fx", "rpc_surface_mtr_fx_lvl_unit", "rpc_skinned_surface_mtr_fx", "rpc_play_melee_hit_effects", "game_object_created", "game_session_disconnect", "game_object_destroyed", "rpc_enemy_is_alerted", "rpc_assist", "rpc_coop_feedback", "rpc_ladder_shake", "rpc_request_spawn_template_unit", "rpc_flow_event")
end

GameNetworkManager.lobby = function (self)
	-- function 3
	return self._lobby
end

GameNetworkManager.session_id = function (self)
	-- function 4
	return self._session_id
end

GameNetworkManager.ping_by_peer = function (self, arg_5_1)
	-- function 5
	fassert(self.is_server, "tried to fetch ping by peer id as a client")

	return self._lobby:ping_by_peer(arg_5_1)
end

GameNetworkManager.set_small_network_packets = function (arg_6_0, arg_6_1)
	-- function 6
	if not arg_6_1 then
		Network.limit_mtu(576)
	else
		Network.limit_mtu(65536)
	end
end

GameNetworkManager.set_entity_system = function (self, arg_7_1)
	-- function 7
	self.entity_system = arg_7_1
end

GameNetworkManager.post_init = function (self, arg_8_1)
	-- function 8
	self.profile_synchronizer = arg_8_1.profile_synchronizer
	self.game_mode = arg_8_1.game_mode
	self.networked_flow_state = arg_8_1.networked_flow_state
	self.room_manager = arg_8_1.room_manager
	self.spawn_manager = arg_8_1.spawn_manager
	self.network_clock = arg_8_1.network_clock
	self.player_manager = arg_8_1.player_manager

	local network_transmit = arg_8_1.network_transmit

	self.network_transmit = network_transmit

	network_transmit:set_game_session(self.game_session)

	for k, v in pairs(self._object_synchronizing_clients) do
		network_transmit:add_peer_ignore(k)
	end

	self.network_server = arg_8_1.network_server
	self.network_client = arg_8_1.network_client
	self.statistics_db = arg_8_1.statistics_db
	self.difficulty_manager = arg_8_1.difficulty_manager
	self.weave_manager = arg_8_1.weave_manager
	self.voting_manager = arg_8_1.voting_manager
	self.matchmaking_manager = arg_8_1.matchmaking_manager
	self.game_server_manager = arg_8_1.game_server_manager
	self._leaving_game = false
end

GameNetworkManager.set_unit_storage = function (self, arg_9_1)
	-- function 9
	self.unit_storage = arg_9_1
end

GameNetworkManager.set_unit_spawner = function (self, arg_10_1)
	-- function 10
	self.unit_spawner = arg_10_1
end

GameNetworkManager.in_game_session = function (self)
	-- function 11
	local game_session = self.game_session

	if not game_session and not GameSession.in_session(game_session) then
		return true
	else
		return false
	end
end

GameNetworkManager.update_receive = function (self, arg_12_1)
	-- function 12
	Network.update_receive(arg_12_1, self._event_delegate.event_table)

	local game_session = self.game_session

	if not game_session then
		return
	end

	self.network_transmit:update_receive()

	if self._game_session_host or not GameSession.in_session(game_session) then
		self._game_session_host = GameSession.game_session_host(game_session)
	end

	if not self._game_session_disconnect then
		fn("Game session disconnected, leaving game...")

		self._game_session_host = nil

		self.network_transmit:set_game_session(nil)

		self.game_session = nil
		self._left_game = true
	end
end

GameNetworkManager.update_transmit = function (arg_13_0, arg_13_1)
	-- function 13
	Network.update_transmit()
end

GameNetworkManager.update = function (self, arg_14_1)
	-- function 14
	if not self.is_server and not self:in_game_session() then
		local _lobby = self._lobby
		local game_session = self.game_session
		local human_players = self.player_manager:human_players()
		local min = NetworkConstants.ping.min
		local max = NetworkConstants.ping.max

		for k, v in pairs(human_players) do
			local peer_id = v.peer_id

			if peer_id ~= self.peer_id then
				local game_object_id = v.game_object_id
				local clamp = math.clamp(math.floor(_lobby:ping_by_peer(peer_id) * 1000), min, max)

				GameSession.set_game_object_field(game_session, game_object_id, "ping", clamp)
			end
		end
	end

	if not self._shutdown_server_timer then
		self._shutdown_server_timer = self._shutdown_server_timer - arg_14_1

		local all_client_peers_disconnected = self.network_server:all_client_peers_disconnected()

		all_client_peers_disconnected = all_client_peers_disconnected or self._shutdown_server_timer < 0

		if not all_client_peers_disconnected then
			self.network_server:force_disconnect_all_client_peers()
			self:_shutdown_server()

			self._shutdown_server_timer = nil
		end
	end

	if not (not self._left_game and self:in_game_session() or self.game_session_shutdown) then
		fn("No longer in game session, shutting it down.")
		Network.shutdown_game_session()

		self.game_session_shutdown = true
	end
end

GameNetworkManager.network_time = function (self)
	-- function 15
	return self.network_clock:time()
end

GameNetworkManager._shutdown_server = function (self)
	-- function 16
	fn("Shutting down game session host.")
	self:game_session_disconnect()
	GameSession.shutdown_game_session_host(self.game_session)

	self._game_session_host = nil

	self.network_transmit:set_game_session(nil)

	self.game_session = nil
	self._left_game = true
end

GameNetworkManager.force_disconnect_from_session = function (self)
	-- function 17
	fn("Forcing disconnect_from_host()")
	GameSession.disconnect_from_host(self.game_session)
end

local num_3 = 2

GameNetworkManager.leave_game = function (self, arg_18_1)
	-- function 18
	fn("Leaving game...")

	self._leaving_game = true
	self.ignore_lobby_rpcs = arg_18_1

	if not self.is_server then
		if not arg_18_1 then
			self._shutdown_server_timer = num_3
		else
			self:_shutdown_server()
		end
	else
		local players_at_peer = Managers.player:players_at_peer(Network.peer_id())

		for k, v in pairs(players_at_peer) do
			if not v:needs_despawn() then
				Managers.state.spawn:delayed_despawn(v)
				printf("despawning player %s", v:name())
			end
		end

		GameSession.leave(self.game_session)
	end
end

GameNetworkManager.has_left_game = function (self)
	-- function 19
	return self._left_game
end

GameNetworkManager.is_leaving_game = function (self)
	-- function 20
	return self._leaving_game
end

GameNetworkManager.destroy = function (self)
	-- function 21
	for k, v in pairs(self._object_synchronizing_clients) do
		self.network_transmit:remove_peer_ignore(k)
	end

	self._event_delegate:unregister(self)

	self._event_delegate = nil
	self.entity_system = nil
	self.game_mode = nil
	self.networked_flow_state = nil
	self.room_manager = nil
	self.spawn_manager = nil
	self.network_clock = nil
	self.profile_synchronizer = nil
	self._lobby = nil
	self._game_object_disconnect_callbacks = nil
	self._world = nil
	self.network_transmit = nil
	self.network_server = nil

	GarbageLeakDetector.register_object(self, "Network Manager")

	if not self.game_session_shutdown then
		fn("Shutting down game session")
		Network.shutdown_game_session()
	end
end

GameNetworkManager.game = function (self)
	-- function 22
	return self.game_session
end

GameNetworkManager.game_object_or_level_unit = function (self, arg_23_1, arg_23_2)
	-- function 23
	if not arg_23_2 then
		local current_level = LevelHelper:current_level(self._world)

		return (Level.unit_by_index(current_level, arg_23_1))
	else
		return (Managers.state.unit_storage:unit(arg_23_1))
	end
end

GameNetworkManager.game_object_or_level_id = function (self, arg_24_1)
	-- function 24
	if not Unit.alive(arg_24_1) then
		return nil, false
	end

	local go_id = Managers.state.unit_storage:go_id(arg_24_1)

	if go_id ~= nil then
		return go_id, false
	end

	local current_level = LevelHelper:current_level(self._world)
	local unit_index = Level.unit_index(current_level, arg_24_1)

	if not unit_index then
		return unit_index, true
	end
end

GameNetworkManager.level_object_id = function (self, arg_25_1)
	-- function 25
	local current_level = LevelHelper:current_level(self._world)

	return Level.unit_index(current_level, arg_25_1)
end

GameNetworkManager.unit_game_object_id = function (self, arg_26_1)
	-- function 26
	local go_id = self.unit_storage:go_id(arg_26_1)

	if not go_id then
		return go_id
	end
end

GameNetworkManager.game_object_template = function (arg_27_0, arg_27_1)
	-- function 27
	return var_0_0[arg_27_1]
end

GameNetworkManager.request_profile = function (self, arg_28_1, arg_28_2, arg_28_3, arg_28_4)
	-- function 28
	if not self.network_server then
		self.network_server:request_profile(arg_28_1, arg_28_2, arg_28_3, arg_28_4)
	end

	if not self.network_client then
		self.network_client:request_profile(arg_28_1, arg_28_2, arg_28_3, arg_28_4)
	end
end

GameNetworkManager.create_game_object = function (self, arg_29_1, arg_29_2, arg_29_3)
	-- function 29
	local create_game_object = GameSession.create_game_object(self.game_session, arg_29_1, arg_29_2)

	self._game_object_types[create_game_object] = arg_29_1
	self._game_object_disconnect_callbacks[create_game_object] = arg_29_3

	fn("Created game object of type '%s' with go_id=%d", arg_29_1, create_game_object)

	return create_game_object
end

GameNetworkManager.create_player_game_object = function (self, arg_30_1, arg_30_2, arg_30_3)
	-- function 30
	fassert(self.is_server, "create_player_game_object: FAIL")

	local create_game_object = GameSession.create_game_object(self.game_session, arg_30_1, arg_30_2)

	self._game_object_types[create_game_object] = "player"
	self._game_object_disconnect_callbacks[create_game_object] = arg_30_3

	fn("Created player game object of type '%s' with go_id=%d", arg_30_1, create_game_object)

	return create_game_object
end

GameNetworkManager.cb_spawn_point_game_object_created = function (arg_31_0, arg_31_1, arg_31_2)
	-- function 31
	Managers.state.event:trigger("event_create_client_spawnpoint", arg_31_1)

	if not script_data.spawn_debug then
		print("spawn created", arg_31_1)
	end
end

GameNetworkManager.game_object_created_player = function (self, arg_32_1, arg_32_2)
	-- function 32
	assert(not self.is_server, "game_object_created_player: FAIL")

	local game_object_field = GameSession.game_object_field(self.game_session, arg_32_1, "network_id")
	local game_object_field_2 = GameSession.game_object_field(self.game_session, arg_32_1, "local_player_id")

	fn("game_object_created_player, go_id=%d, owner_peer_id=%s peer_id=%s", arg_32_1, arg_32_2, game_object_field)

	local player_manager = self.player_manager

	if game_object_field == self.peer_id then
		fn("PLAYER is local player")

		local player = player_manager:player(game_object_field, game_object_field_2)

		player:set_game_object_id(arg_32_1)
		player:create_sync_data()

		local stats_id = player:stats_id()

		self.statistics_db:sync_stats_to_server(stats_id, game_object_field, game_object_field_2, self.network_transmit)
		fn("PLAYER TYPE: %s", player:type())
	else
		fn("PLAYER ADDED go_id = %d, peer_id = %s, self.peer_id = %s", arg_32_1, game_object_field, self.peer_id)

		local game_object_field_3 = GameSession.game_object_field(self.game_session, arg_32_1, "player_controlled")
		local game_object_field_4 = GameSession.game_object_field(self.game_session, arg_32_1, "account_id")

		fn("ADDING REMOTE PLAYER FOR PEER %s", game_object_field)

		local add_remote_player = player_manager:add_remote_player(game_object_field, game_object_field_3, game_object_field_2, nil, game_object_field_4)

		add_remote_player:set_game_object_id(arg_32_1)
		add_remote_player:create_sync_data()
	end
end

GameNetworkManager.game_object_destroyed_player = function (self, arg_33_1, arg_33_2)
	-- function 33
	local game_object_field = GameSession.game_object_field(self.game_session, arg_33_1, "network_id")
	local game_object_field_2 = GameSession.game_object_field(self.game_session, arg_33_1, "local_player_id")

	fn("game_object_destroyed_player, game_object_id=%i owner_peer_id=%s peer_id=%s", arg_33_1, arg_33_2, game_object_field)

	local player_manager = self.player_manager

	if game_object_field ~= self.peer_id then
		player_manager:remove_player(game_object_field, game_object_field_2)
		fn("removing peer_id=%s local_player_id=%d", game_object_field, game_object_field_2)
	else
		fn("not removing peer_id=%s local_player_id=%d", game_object_field, game_object_field_2)
		player_manager:player_from_peer_id(game_object_field, game_object_field_2):game_object_destroyed()
	end
end

GameNetworkManager.game_object_created_player_unit_health = function (self, arg_34_1, arg_34_2)
	-- function 34
	local _health_extension = self:_health_extension(arg_34_1)

	if _health_extension == nil then
		return
	end

	_health_extension:set_health_game_object_id(arg_34_1)
end

GameNetworkManager.game_object_destroyed_player_unit_health = function (self, arg_35_1, arg_35_2)
	-- function 35
	local _health_extension = self:_health_extension(arg_35_1)

	if _health_extension == nil then
		return
	end

	_health_extension:set_health_game_object_id(nil)
end

GameNetworkManager.game_object_created_dark_pact_horde_ability = function (self, arg_36_1, arg_36_2)
	-- function 36
	local game_object_field = GameSession.game_object_field(self.game_session, arg_36_1, "unit_game_object_id")
	local unit = self.unit_storage:unit(game_object_field)

	if unit == nil then
		return nil
	end

	local extension = ScriptUnit.extension(unit, "versus_horde_ability_system")

	if extension == nil then
		return nil
	end

	extension:set_ability_game_object_id(arg_36_1)
end

GameNetworkManager.game_object_destroyed_dark_pact_horde_ability = function (self, arg_37_1, arg_37_2)
	-- function 37
	local game_object_field = GameSession.game_object_field(self.game_session, arg_37_1, "unit_game_object_id")
	local unit = self.unit_storage:unit(game_object_field)

	if unit == nil then
		return nil
	end

	local extension = ScriptUnit.extension(unit, "versus_horde_ability_system")

	if extension == nil then
		return nil
	end

	extension:set_ability_game_object_id(nil)
end

GameNetworkManager.game_object_created_player_sync_data = function (self, arg_38_1, arg_38_2)
	-- function 38
	local game_object_field = GameSession.game_object_field(self.game_session, arg_38_1, "network_id")
	local game_object_field_2 = GameSession.game_object_field(self.game_session, arg_38_1, "local_player_id")

	printf("Adding player sync data to peer=%s local_player_id=%s", game_object_field, game_object_field_2)

	local player = self.player_manager:player(game_object_field, game_object_field_2)

	if not player then
		player:set_sync_data_game_object_id(arg_38_1)
	end
end

GameNetworkManager.game_object_destroyed_player_sync_data = function (self, arg_39_1, arg_39_2)
	-- function 39
	local game_object_field = GameSession.game_object_field(self.game_session, arg_39_1, "network_id")
	local game_object_field_2 = GameSession.game_object_field(self.game_session, arg_39_1, "local_player_id")
	local player = self.player_manager:player(game_object_field, game_object_field_2)

	if not player and not player.remote then
		player:set_sync_data_game_object_id(nil)
	end
end

GameNetworkManager._health_extension = function (self, arg_40_1)
	-- function 40
	local game_object_field = GameSession.game_object_field(self.game_session, arg_40_1, "unit_game_object_id")
	local unit = self.unit_storage:unit(game_object_field)

	if unit == nil then
		return nil
	end

	return (ScriptUnit.extension(unit, "health_system"))
end

GameNetworkManager._career_extension = function (self, arg_41_1)
	-- function 41
	local game_object_field = GameSession.game_object_field(self.game_session, arg_41_1, "unit_game_object_id")
	local unit = self.unit_storage:unit(game_object_field)

	if unit == nil then
		return nil
	end

	return (ScriptUnit.extension(unit, "career_system"))
end

GameNetworkManager.game_object_created = function (self, arg_42_1, arg_42_2)
	-- function 42
	local game_object_field = GameSession.game_object_field(self.game_session, arg_42_1, "go_type")
	local var_42_1 = NetworkLookup.go_types[game_object_field]
	local var_42_2 = var_0_0[var_42_1]
	local game_object_created_func_name = var_42_2.game_object_created_func_name
	local game_session_disconnect_func_name = var_42_2.game_session_disconnect_func_name

	if not game_session_disconnect_func_name then
		local function fn_2(arg_43_0)
			-- function 43
			self[game_session_disconnect_func_name](self, arg_43_0)
		end

		self._game_object_disconnect_callbacks[arg_42_1] = fn_2
	end

	fn("game object created go_id=%d, owner_id=%s go_type=%s go_created_func_name=%s", arg_42_1, arg_42_2, var_42_1, game_object_created_func_name)

	local var_42_6 = self[game_object_created_func_name]

	assert(var_42_6)
	var_42_6(self, arg_42_1, arg_42_2, var_42_2)
end

GameNetworkManager.game_object_created_network_unit = function (self, arg_44_1, arg_44_2, arg_44_3)
	-- function 44
	return self.unit_spawner:spawn_unit_from_game_object(arg_44_1, arg_44_2, arg_44_3)
end

GameNetworkManager.game_object_created_music_states = function (arg_45_0, arg_45_1, arg_45_2, arg_45_3)
	-- function 45
	Managers.music:game_object_created(arg_45_1, arg_45_2, arg_45_3)
end

GameNetworkManager.game_object_created_keep_decoration = function (self, arg_46_1, arg_46_2, arg_46_3)
	-- function 46
	local game_object_field = GameSession.game_object_field(self.game_session, arg_46_1, "level_unit_index")
	local current_level = LevelHelper:current_level(self._world)
	local unit_by_index = Level.unit_by_index(current_level, game_object_field)

	ScriptUnit.extension(unit_by_index, "keep_decoration_system"):on_game_object_created(arg_46_1)
end

GameNetworkManager.game_object_destroyed_keep_decoration = function (self, arg_47_1, arg_47_2, arg_47_3)
	-- function 47
	local game_object_field = GameSession.game_object_field(self.game_session, arg_47_1, "level_unit_index")
	local current_level = LevelHelper:current_level(self._world)
	local unit_by_index = Level.unit_by_index(current_level, game_object_field)

	ScriptUnit.extension(unit_by_index, "keep_decoration_system"):on_game_object_destroyed()
end

GameNetworkManager.game_object_created_progress_timer = function (self, arg_48_1, arg_48_2, arg_48_3)
	-- function 48
	local game_object_field = GameSession.game_object_field(self.game_session, arg_48_1, "level_unit_index")
	local current_level = LevelHelper:current_level(self._world)
	local unit_by_index = Level.unit_by_index(current_level, game_object_field)

	ScriptUnit.extension(unit_by_index, "progress_system"):on_game_object_created(arg_48_1)
end

GameNetworkManager.game_object_destroyed_progress_timer = function (self, arg_49_1, arg_49_2, arg_49_3)
	-- function 49
	local game_object_field = GameSession.game_object_field(self.game_session, arg_49_1, "level_unit_index")
	local current_level = LevelHelper:current_level(self._world)
	local unit_by_index = Level.unit_by_index(current_level, game_object_field)

	ScriptUnit.extension(unit_by_index, "progress_system"):on_game_object_destroyed()
end

GameNetworkManager.game_object_created_game_mode_data = function (self, arg_50_1, arg_50_2, arg_50_3)
	-- function 50
	Managers.state.game_mode:on_game_mode_data_created(self.game_session, arg_50_1)
end

GameNetworkManager.game_object_destroyed_game_mode_data = function (arg_51_0, arg_51_1, arg_51_2, arg_51_3)
	-- function 51
	Managers.state.game_mode:on_game_mode_data_destroyed()
end

GameNetworkManager.game_object_created_weave = function (arg_52_0, arg_52_1, arg_52_2, arg_52_3)
	-- function 52
	Managers.weave:game_object_created(arg_52_1)
end

GameNetworkManager.game_object_destroyed_weave = function (arg_53_0, arg_53_1)
	-- function 53
	Managers.weave:game_object_destroyed(arg_53_1)
end

GameNetworkManager.game_object_created_objective = function (self, arg_54_1, arg_54_2, arg_54_3)
	-- function 54
	Managers.state.entity:system("objective_system"):game_object_created(self.game_session, arg_54_1)
end

GameNetworkManager.game_object_destroyed_objective = function (self, arg_55_1)
	-- function 55
	Managers.state.entity:system("objective_system"):game_object_destroyed(self.game_session, arg_55_1)
end

GameNetworkManager.game_object_created_horde_surge = function (arg_56_0, arg_56_1, arg_56_2, arg_56_3)
	-- function 56
	Managers.state.game_mode:game_mode()._horde_surge_handler._game_object_id = arg_56_1
end

GameNetworkManager.game_object_destroyed_horde_surge = function (arg_57_0, arg_57_1)
	-- function 57
	Managers.state.game_mode:game_mode()._horde_surge_handler._game_object_id = nil
end

GameNetworkManager.destroy_game_object = function (self, arg_58_1)
	-- function 58
	fn("destroying game object with go_id=%d", arg_58_1)

	self._game_object_disconnect_callbacks[arg_58_1] = nil

	GameSession.destroy_game_object(self.game_session, arg_58_1)
end

GameNetworkManager.game_object_destroyed = function (self, arg_59_1, arg_59_2)
	-- function 59
	local game_object_field = GameSession.game_object_field(self.game_session, arg_59_1, "go_type")
	local var_59_1 = NetworkLookup.go_types[game_object_field]
	local var_59_2 = var_0_0[var_59_1]
	local game_object_destroyed_func_name = var_59_2.game_object_destroyed_func_name

	self[game_object_destroyed_func_name](self, arg_59_1, arg_59_2, var_59_2)

	self._game_object_disconnect_callbacks[arg_59_1] = nil

	fn("game object was destroyed id=%d with type=%s, object_destroy_func=%s, owned by peer=%s", arg_59_1, var_59_1, game_object_destroyed_func_name, arg_59_2)
end

GameNetworkManager.game_object_created_player_unit = function (self, arg_60_1, arg_60_2, arg_60_3)
	-- function 60
	if not self.is_server then
		self.network_server:peer_spawned_player(arg_60_2)
	end

	local game_object_created_network_unit = self:game_object_created_network_unit(arg_60_1, arg_60_2, arg_60_3)
	local owner = Managers.player:owner(game_object_created_network_unit)

	Managers.state.event:trigger("new_player_unit", owner, game_object_created_network_unit, owner:unique_id())
end

GameNetworkManager.game_object_destroyed_player_unit = function (self, arg_61_1, arg_61_2, arg_61_3)
	-- function 61
	local unit = self.unit_storage:unit(arg_61_1)

	if not self.is_server then
		self.network_server:peer_despawned_player(arg_61_2)
	end

	self:game_object_destroyed_network_unit(arg_61_1, arg_61_2, arg_61_3)

	if not DEDICATED_SERVER then
		return false
	end

	local last_damage_data = ScriptUnit.has_extension(unit, "health_system").last_damage_data

	if not last_damage_data then
		local local_player = Managers.player:local_player()

		if last_damage_data.attacker_unique_id == local_player:unique_id() then
			local var_61_3 = POSITION_LOOKUP[local_player.player_unit]
			local var_61_4 = POSITION_LOOKUP[unit]

			Managers.telemetry_events:local_player_killed_player(local_player, var_61_3, var_61_4)
		end
	end
end

GameNetworkManager.game_object_destroyed_network_unit = function (self, arg_62_1, arg_62_2, arg_62_3)
	-- function 62
	self.unit_spawner:destroy_game_object_unit(arg_62_1, arg_62_2, arg_62_3)
end

GameNetworkManager.game_object_destroyed_music_states = function (arg_63_0, arg_63_1, arg_63_2, arg_63_3)
	-- function 63
	fn("MUSIC object destroyed")
	Managers.music:game_object_destroyed(arg_63_1, arg_63_2, arg_63_3)
end

GameNetworkManager.game_object_migrated_away = function (arg_64_0, arg_64_1, arg_64_2)
	-- function 64
	assert(false, "Not implemented.")
end

GameNetworkManager.game_object_migrated_to_me = function (arg_65_0, arg_65_1, arg_65_2)
	-- function 65
	assert(false, "Not implemented.")
end

GameNetworkManager.game_session_disconnect = function (self, arg_66_1)
	-- function 66
	fn("Engine called game_session_disconnect callback")

	self._game_session_disconnect = true

	for k, v in pairs(self._game_object_disconnect_callbacks) do
		v(k)
	end

	self.unit_spawner.game_session = nil
end

GameNetworkManager.game_session_disconnect_music_states = function (arg_67_0, arg_67_1)
	-- function 67
	Managers.music:client_game_session_disconnect_music_states(arg_67_1)
end

GameNetworkManager.game_object_destroyed_do_nothing = function (arg_68_0)
	-- function 68
	return
end

GameNetworkManager.game_object_created_sync_unit = function (arg_69_0, arg_69_1, arg_69_2, arg_69_3)
	-- function 69
	Managers.state.entity:system("game_object_system"):game_object_created(arg_69_1, arg_69_2, arg_69_3)
end

GameNetworkManager.game_object_destroyed_sync_unit = function (arg_70_0, arg_70_1, arg_70_2, arg_70_3)
	-- function 70
	return
end

GameNetworkManager.game_object_created_payload = function (self, arg_71_1, arg_71_2, arg_71_3)
	-- function 71
	local game_object_field = GameSession.game_object_field(self.game_session, arg_71_1, "level_unit_index")
	local current_level = LevelHelper:current_level(self._world)
	local unit_by_index = Level.unit_by_index(current_level, game_object_field)

	ScriptUnit.extension(unit_by_index, "payload_system"):set_game_object_id(arg_71_1)
end

GameNetworkManager.game_object_destroyed_payload = function (arg_72_0, arg_72_1)
	-- function 72
	return
end

GameNetworkManager.game_object_created_twitch_vote = function (arg_73_0, arg_73_1, arg_73_2, arg_73_3)
	-- function 73
	Managers.twitch:add_game_object_id(arg_73_1)
end

GameNetworkManager.game_object_destroyed_twitch_vote = function (arg_74_0, arg_74_1)
	-- function 74
	Managers.twitch:remove_game_object_id(arg_74_1)
end

GameNetworkManager.game_object_created_career_data = function (self, arg_75_1, arg_75_2)
	-- function 75
	local _career_extension = self:_career_extension(arg_75_1)

	if _career_extension == nil then
		return
	end

	_career_extension:set_career_game_object_id(arg_75_1)
end

GameNetworkManager.game_object_destroyed_career_data = function (self, arg_76_1, arg_76_2)
	-- function 76
	local _career_extension = self:_career_extension(arg_76_1)

	if _career_extension == nil then
		return
	end

	_career_extension:set_career_game_object_id(nil)
end

GameNetworkManager.remove_peer = function (self, arg_77_1)
	-- function 77
	if not self._object_synchronizing_clients[arg_77_1] then
		self._object_synchronizing_clients[arg_77_1] = nil

		self.network_transmit:remove_peer_ignore(arg_77_1)
	end

	if Managers.game_server ~= nil then
		Managers.game_server:remove_peer(arg_77_1)
	end

	self.player_manager:remove_all_players_from_peer(arg_77_1)

	if not self.room_manager and not self.room_manager:has_room(arg_77_1) then
		self.room_manager:destroy_room(arg_77_1)
	end
end

GameNetworkManager.set_peer_synchronizing = function (self, arg_78_1)
	-- function 78
	self._object_synchronizing_clients[arg_78_1] = true

	self.network_transmit:add_peer_ignore(arg_78_1)
end

GameNetworkManager.hot_join_sync = function (self, arg_79_1)
	-- function 79
	if not Managers.state.debug then
		Managers.state.debug:hot_join_sync(arg_79_1)
	end

	self.difficulty_manager:hot_join_sync(arg_79_1)
	self.weave_manager:hot_join_sync(arg_79_1)
	self.entity_system:hot_join_sync(arg_79_1)
	self.game_mode:hot_join_sync(arg_79_1)
	self.networked_flow_state:hot_join_sync(arg_79_1)
	self.voting_manager:hot_join_sync(arg_79_1)
	self.statistics_db:hot_join_sync(arg_79_1)
	Managers.deed:hot_join_sync(arg_79_1)
	LoadoutUtils.hot_join_sync(arg_79_1)

	if not self.matchmaking_manager then
		self.matchmaking_manager:hot_join_sync(arg_79_1)
	end

	if not self.game_server_manager then
		self.game_server_manager:hot_join_sync(arg_79_1)
	end

	if not self.room_manager then
		self.room_manager:hot_join_sync(arg_79_1)
	end

	if not Managers.venture.challenge then
		Managers.venture.challenge:hot_join_sync(arg_79_1)
	end

	if not Managers.venture.quickplay then
		Managers.venture.quickplay:hot_join_sync(arg_79_1)
	end

	if not Managers.state.conflict then
		Managers.state.conflict:hot_join_sync(arg_79_1)
	end

	local var_79_0 = PEER_ID_TO_CHANNEL[arg_79_1]

	RPC.rpc_to_client_sync_session_id(var_79_0, self._session_id)

	self._object_synchronizing_clients[arg_79_1] = nil

	self.network_transmit:remove_peer_ignore(arg_79_1)
end

GameNetworkManager.rpc_play_particle_effect = function (self, arg_80_1, arg_80_2, arg_80_3, arg_80_4, arg_80_5, arg_80_6, arg_80_7)
	-- function 80
	if not self.is_server then
		self.network_transmit:send_rpc_clients("rpc_play_particle_effect", arg_80_2, arg_80_3, arg_80_4, arg_80_5, arg_80_6, arg_80_7)
	end

	local unit = self.unit_storage:unit(arg_80_3)
	local var_80_1 = NetworkLookup.effects[arg_80_2]

	Managers.state.event:trigger("event_play_particle_effect", var_80_1, unit, arg_80_4, arg_80_5, arg_80_6, arg_80_7)
end

GameNetworkManager.rpc_play_particle_effect_no_rotation = function (self, arg_81_1, arg_81_2, arg_81_3, arg_81_4, arg_81_5, arg_81_6)
	-- function 81
	if not self.is_server then
		self.network_transmit:send_rpc_clients("rpc_play_particle_effect_no_rotation", arg_81_2, arg_81_3, arg_81_4, arg_81_5, arg_81_6)
	end

	local unit = self.unit_storage:unit(arg_81_3)
	local var_81_1 = NetworkLookup.effects[arg_81_2]

	Managers.state.event:trigger("event_play_particle_effect", var_81_1, unit, arg_81_4, arg_81_5, Quaternion.identity(), arg_81_6)
end

GameNetworkManager.rpc_play_particle_effect_with_variable = function (self, arg_82_1, arg_82_2, arg_82_3, arg_82_4, arg_82_5, arg_82_6)
	-- function 82
	if not self.is_server then
		self.network_transmit:send_rpc_clients("rpc_play_particle_effect_with_variable", arg_82_2, arg_82_3, arg_82_4, arg_82_5, arg_82_6)
	end

	local var_82_0 = NetworkLookup.effects[arg_82_2]
	local _world = self._world
	local find_particles_variable = World.find_particles_variable(_world, var_82_0, arg_82_5)
	local create_particles = World.create_particles(_world, var_82_0, arg_82_3, arg_82_4)

	World.set_particles_variable(_world, create_particles, find_particles_variable, arg_82_6)
end

GameNetworkManager.rpc_play_particle_effect_spline = function (self, arg_83_1, arg_83_2, arg_83_3, arg_83_4)
	-- function 83
	if not self.is_server then
		self.network_transmit:send_rpc_clients("rpc_play_particle_effect_spline", arg_83_2, arg_83_3, arg_83_4)
	end

	local var_83_0 = NetworkLookup.effects[arg_83_2]
	local _world = self._world
	local create_particles = World.create_particles(_world, var_83_0, arg_83_4[1])

	for i = 1, #arg_83_4 do
		World.set_particles_variable(_world, create_particles, arg_83_3[i], arg_83_4[i])
	end
end

GameNetworkManager._pack_percentages_completed_arrays = function (arg_84_0, arg_84_1)
	-- function 84
	local tbl = {}
	local tbl_2 = {}
	local tbl_3 = {}
	local num = 1
	local player = Managers.player

	for k, v in pairs(arg_84_1) do
		local player_from_unique_id = player:player_from_unique_id(k)

		if not player_from_unique_id then
			local network_id = player_from_unique_id:network_id()

			tbl_2[num], tbl[num] = player_from_unique_id:local_player_id(), network_id
			tbl_3[num] = v
			num = num + 1
		end
	end

	return tbl, tbl_2, tbl_3
end

GameNetworkManager._unpack_percentages_completed_arrays = function (arg_85_0, arg_85_1, arg_85_2, arg_85_3)
	-- function 85
	local tbl = {}
	local player = Managers.player

	for i = 1, #arg_85_1 do
		local var_85_2 = arg_85_1[i]
		local var_85_3 = arg_85_2[i]
		local var_85_4 = arg_85_3[i]
		local player_2 = player:player(var_85_2, var_85_3)

		if not player_2 then
			tbl[player_2:unique_id()] = math.clamp(var_85_4, 0, 1)
		end
	end

	return tbl
end

GameNetworkManager.gm_event_end_conditions_met = function (self, arg_86_1, arg_86_2, arg_86_3)
	-- function 86
	local _pack_percentages_completed_arrays, var_86_1, var_86_2 = self:_pack_percentages_completed_arrays(arg_86_3)
	local var_86_3 = NetworkLookup.game_end_reasons[arg_86_1]

	self.network_transmit:send_rpc_clients("rpc_gm_event_end_conditions_met", var_86_3, arg_86_2, _pack_percentages_completed_arrays, var_86_1, var_86_2)
end

GameNetworkManager.rpc_gm_event_end_conditions_met = function (self, arg_87_1, arg_87_2, arg_87_3, arg_87_4, arg_87_5, arg_87_6)
	-- function 87
	if not self.is_server then
		local _unpack_percentages_completed_arrays = self:_unpack_percentages_completed_arrays(arg_87_4, arg_87_5, arg_87_6)
		local var_87_1 = NetworkLookup.game_end_reasons[arg_87_2]

		Managers.state.game_mode:set_end_reason(var_87_1)
		Managers.state.game_mode:trigger_event("end_conditions_met", var_87_1, arg_87_3, _unpack_percentages_completed_arrays)
	end
end

GameNetworkManager.gm_event_round_started = function (self)
	-- function 88
	local num = 0

	self.network_transmit:send_rpc_clients("rpc_gm_event_round_started", num)
end

GameNetworkManager.rpc_gm_event_round_started = function (arg_89_0, arg_89_1, arg_89_2)
	-- function 89
	Managers.state.game_mode:trigger_event("round_started", arg_89_2)
end

GameNetworkManager.gm_event_initial_peers_spawned = function (self)
	-- function 90
	self.network_transmit:send_rpc_clients("rpc_gm_event_initial_peers_spawned")
end

GameNetworkManager.rpc_gm_event_initial_peers_spawned = function (arg_91_0, arg_91_1)
	-- function 91
	Managers.state.game_mode:trigger_event("initial_peers_spawned")
end

GameNetworkManager.rpc_play_melee_hit_effects = function (self, arg_92_1, arg_92_2, arg_92_3, arg_92_4, arg_92_5)
	-- function 92
	local unit = self.unit_storage:unit(arg_92_5)

	if not Unit.alive(unit) then
		return
	end

	if not self.is_server then
		local var_92_1 = CHANNEL_TO_PEER_ID[arg_92_1]

		self.network_transmit:send_rpc_clients_except("rpc_play_melee_hit_effects", var_92_1, arg_92_2, arg_92_3, arg_92_4, arg_92_5)
	end

	local var_92_2 = NetworkLookup.sound_events[arg_92_2]
	local var_92_3 = NetworkLookup.melee_impact_sound_types[arg_92_4]

	EffectHelper.play_melee_hit_effects(var_92_2, self._world, arg_92_3, var_92_3, true, unit)
end

GameNetworkManager.rpc_request_spawn_template_unit = function (self, arg_93_1, arg_93_2, arg_93_3, arg_93_4, arg_93_5, arg_93_6, arg_93_7)
	-- function 93
	local unit = self.unit_storage:unit(arg_93_5)
	local var_93_1 = NetworkLookup.spawn_unit_templates[arg_93_2]

	SpawnUnitTemplates[var_93_1].spawn_func(unit, arg_93_3, arg_93_4, arg_93_6)
end

GameNetworkManager.rpc_surface_mtr_fx = function (self, arg_94_1, arg_94_2, arg_94_3, arg_94_4, arg_94_5, arg_94_6, arg_94_7)
	-- function 94
	local unit = self.unit_storage:unit(arg_94_3)

	if not Unit.alive(unit) then
		return
	end

	if not self.is_server then
		local var_94_1 = CHANNEL_TO_PEER_ID[arg_94_1]

		self.network_transmit:send_rpc_clients_except("rpc_surface_mtr_fx", var_94_1, arg_94_2, arg_94_3, arg_94_4, arg_94_5, arg_94_6, arg_94_7)
	end

	local var_94_2

	if arg_94_7 > 0 then
		var_94_2 = Unit.actor(unit, arg_94_7)
	end

	local var_94_3 = NetworkLookup.surface_material_effects[arg_94_2]

	EffectHelper.play_surface_material_effects(var_94_3, self._world, unit, arg_94_4, arg_94_5, arg_94_6, nil, true, nil, var_94_2)
end

GameNetworkManager.rpc_surface_mtr_fx_lvl_unit = function (self, arg_95_1, arg_95_2, arg_95_3, arg_95_4, arg_95_5, arg_95_6, arg_95_7)
	-- function 95
	local current_level = LevelHelper:current_level(self._world)
	local unit_by_index = Level.unit_by_index(current_level, arg_95_3)

	if not Unit.alive(unit_by_index) then
		return
	end

	if not self.is_server then
		local var_95_2 = CHANNEL_TO_PEER_ID[arg_95_1]

		self.network_transmit:send_rpc_clients_except("rpc_surface_mtr_fx_lvl_unit", var_95_2, arg_95_2, arg_95_3, arg_95_4, arg_95_5, arg_95_6, arg_95_7)
	end

	local var_95_3

	if arg_95_7 > 0 then
		var_95_3 = Unit.actor(unit_by_index, arg_95_7)
	end

	local var_95_4 = NetworkLookup.surface_material_effects[arg_95_2]

	EffectHelper.play_surface_material_effects(var_95_4, self._world, unit_by_index, arg_95_4, arg_95_5, arg_95_6, nil, true, nil, var_95_3)
end

GameNetworkManager.rpc_skinned_surface_mtr_fx = function (self, arg_96_1, arg_96_2, arg_96_3, arg_96_4, arg_96_5)
	-- function 96
	if not self.is_server then
		local var_96_0 = CHANNEL_TO_PEER_ID[arg_96_1]

		self.network_transmit:send_rpc_clients_except("rpc_skinned_surface_mtr_fx", var_96_0, arg_96_2, arg_96_3, arg_96_4, arg_96_5)
	end

	local var_96_1 = NetworkLookup.surface_material_effects[arg_96_2]

	EffectHelper.play_skinned_surface_material_effects(var_96_1, self._world, nil, arg_96_3, arg_96_4, arg_96_5, true)
end

GameNetworkManager.game_session_host = function (self)
	-- function 97
	local game_session = self.game_session

	if not game_session then
		game_session = self._game_session_host
		game_session = game_session or GameSession.game_session_host(self.game_session)
	end

	return game_session
end

GameNetworkManager.rpc_enemy_is_alerted = function (self, arg_98_1, arg_98_2, arg_98_3)
	-- function 98
	local unit = self.unit_storage:unit(arg_98_2)
	local str = "detect"

	if not arg_98_3 then
		local node = Unit.node(unit, "c_head")
		local str_2 = "player_1"
		local var_98_4 = Vector3(255, 0, 0)
		local var_98_5 = Vector3(0, 0, 1)
		local num = 0.5
		local str_3 = "!"

		Managers.state.debug_text:output_unit_text(str_3, num, unit, node, var_98_5, nil, str, var_98_4, str_2)
	else
		local str_4 = "detect"

		Managers.state.debug_text:clear_unit_text(unit, str_4)
	end
end

GameNetworkManager.rpc_ladder_shake = function (self, arg_99_1, arg_99_2)
	-- function 99
	local unit_by_index = Level.unit_by_index(LevelHelper:current_level(self._world), arg_99_2)

	ScriptUnit.extension(unit_by_index, "ladder_system"):shake()
end

GameNetworkManager.rpc_assist = function (self, arg_100_1, arg_100_2, arg_100_3, arg_100_4, arg_100_5, arg_100_6, arg_100_7)
	-- function 100
	local player = Managers.player
	local player_2 = player:player(arg_100_2, arg_100_3)
	local player_3 = player:player(arg_100_4, arg_100_5)
	local var_100_3 = NetworkLookup.coop_feedback[arg_100_6]
	local unit = self.unit_storage:unit(arg_100_7)
	local flag = not not player_2.remote or not player_3.bot_player

	Managers.state.event:trigger("add_coop_feedback", player_2:stats_id() .. player_3:stats_id(), flag, var_100_3, player_2, player_3)

	local player_unit = player_2.player_unit
	local player_unit_2 = player_3.player_unit

	if not (not player_unit_2 and player_3.remote) then
		local has_extension = ScriptUnit.has_extension(player_unit_2, "buff_system")

		if not has_extension then
			has_extension:trigger_procs("on_assisted", player_unit, unit)
		end
	end

	if not (not player_unit and player_2.remote) then
		local has_extension_2 = ScriptUnit.has_extension(player_unit, "buff_system")

		if not has_extension_2 then
			has_extension_2:trigger_procs("on_assisted_ally", player_unit_2, unit)
		end
	end

	if var_100_3 == "save" then
		local stats_id = player_2:stats_id()

		Managers.player:statistics_db():increment_stat(stats_id, "saves")
	elseif var_100_3 == "aid" then
		local stats_id_2 = player_2:stats_id()

		Managers.player:statistics_db():increment_stat(stats_id_2, "aidings")
	end
end

GameNetworkManager.rpc_coop_feedback = function (self, arg_101_1, arg_101_2, arg_101_3, arg_101_4, arg_101_5, arg_101_6)
	-- function 101
	if not self.is_server then
		local var_101_0 = CHANNEL_TO_PEER_ID[arg_101_1]

		Managers.state.network.network_transmit:send_rpc_clients_except("rpc_coop_feedback", var_101_0, arg_101_2, arg_101_3, arg_101_4, arg_101_5, arg_101_6)
	end

	local var_101_1 = NetworkLookup.coop_feedback[arg_101_4]
	local player = Managers.player
	local player_2 = player:player(arg_101_2, arg_101_3)
	local player_3 = player:player(arg_101_5, arg_101_6)
	local flag = not not player_2.remote or not player_2.bot_player
	local statistics_db = Managers.player:statistics_db()

	if var_101_1 == "aid" then
		statistics_db:increment_stat(player_2:stats_id(), "aidings")
	elseif var_101_1 == "save" then
		statistics_db:increment_stat(player_2:stats_id(), "saves")
	elseif var_101_1 == "discarded_grimoire" then
		local peer_id = player_2.peer_id
		local is_player_controlled = player_2:is_player_controlled()
		local user_name

		if not is_player_controlled then
			if not rawget(_G, "Steam") then
				user_name = Steam.user_name(peer_id)

				if not user_name then
					-- Nothing
				end
			end

			user_name = tostring(peer_id)

			if not user_name then
				-- Nothing
			end
		end

		user_name = player_2:name()

		::label_101_0::

		if not (not IS_CONSOLE and Managers.account:offline_mode()) then
			local lobby = Managers.state.network:lobby()

			user_name = not is_player_controlled and lobby:user_name(peer_id) and tostring(peer_id) and player_2:name()
		end

		local flag_2 = true
		local format = string.format(Localize("system_chat_player_discarded_grimoire"), user_name)

		Managers.chat:add_local_system_message(1, format, flag_2)
	end

	Managers.state.event:trigger("add_coop_feedback", player_2:stats_id() .. player_3:stats_id(), flag, var_101_1, player_2, player_3)
end

GameNetworkManager.rpc_flow_event = function (self, arg_102_1, arg_102_2, arg_102_3)
	-- function 102
	local unit = self.unit_storage:unit(arg_102_2)

	if not unit then
		printf("unit from game_object_id %d is nil", arg_102_2)

		return
	end

	if not self.is_server then
		local var_102_1 = CHANNEL_TO_PEER_ID[arg_102_1]

		self.network_transmit:send_rpc_clients_except("rpc_flow_event", var_102_1, arg_102_2, arg_102_3)
	end

	local var_102_2 = NetworkLookup.flow_events[arg_102_3]

	Unit.flow_event(unit, var_102_2)
end

GameNetworkManager.anim_event = function (arg_103_0, arg_103_1, arg_103_2)
	-- function 103
	return Managers.state.entity:system("animation_system"):anim_event(arg_103_1, arg_103_2)
end

GameNetworkManager.anim_event_with_variable_float = function (arg_104_0, arg_104_1, arg_104_2, arg_104_3, arg_104_4)
	-- function 104
	Managers.state.entity:system("animation_system"):anim_event_with_variable_float(arg_104_1, arg_104_2, arg_104_3, arg_104_4)
end

GameNetworkManager.anim_set_variable_float = function (self, arg_105_1, arg_105_2, arg_105_3)
	-- function 105
	local go_id = self.unit_storage:go_id(arg_105_1)

	fassert(go_id, "Unit storage does not have a game object id for %q", arg_105_1)

	local var_105_1 = NetworkLookup.anims[arg_105_2]

	if not self.game_session then
		if not self.is_server then
			self.network_transmit:send_rpc_clients("rpc_anim_set_variable_float", go_id, var_105_1, arg_105_3)
		else
			self.network_transmit:send_rpc_server("rpc_anim_set_variable_float", go_id, var_105_1, arg_105_3)
		end
	end

	local animation_find_variable = Unit.animation_find_variable(arg_105_1, arg_105_2)

	Unit.animation_set_variable(arg_105_1, animation_find_variable, arg_105_3)
end
