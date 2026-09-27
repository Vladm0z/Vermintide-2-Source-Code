-- chunkname: @scripts/managers/game_mode/game_modes/game_mode_tutorial.lua

require("scripts/managers/game_mode/game_modes/game_mode_base")

local script_data = script_data
local disable_gamemode_end = script_data.disable_gamemode_end

disable_gamemode_end = disable_gamemode_end or Development.parameter("disable_gamemode_end")
script_data.disable_gamemode_end = disable_gamemode_end
GameModeTutorial = class(GameModeTutorial, GameModeBase)

local flag = false
local flag_2 = false

GameModeTutorial.init = function (self, arg_1_1, arg_1_2, ...)
	-- function 1
	GameModeTutorial.super.init(self, arg_1_1, arg_1_2, ...)

	local get_side_from_name = Managers.state.side:get_side_from_name("heroes")

	self._adventure_spawning = AdventureSpawning:new(self._profile_synchronizer, get_side_from_name, self._is_server, self._network_server)

	self:_register_player_spawner(self._adventure_spawning)
	self:_switch_profile_to_tutorial()
	Managers.state.event:register(self, "level_start_local_player_spawned", "event_local_player_spawned")

	self._hud_disabled = false
	self._bot_players = {}
end

GameModeTutorial._switch_profile_to_tutorial = function (self)
	-- function 2
	local peer_id = Network.peer_id()
	local num = 1
	local profile_by_peer, var_2_3 = self._profile_synchronizer:profile_by_peer(peer_id, num)

	if not profile_by_peer and not var_2_3 then
		self._previous_profile_index = profile_by_peer
		self._previous_career_index = var_2_3
	end

	local var_2_4 = PROFILES_BY_AFFILIATION.tutorial[1]

	self._tutorial_profile_index = FindProfileIndex(var_2_4)
	self._tutorial_career_index = 1
	self._local_player_spawned = false

	local flag = false

	self._profile_synchronizer:assign_full_profile(peer_id, num, self._tutorial_profile_index, self._tutorial_career_index, flag)
end

GameModeTutorial._switch_back_to_previous_profile = function (self)
	-- function 3
	local peer_id = Network.peer_id()
	local num = 1
	local _previous_profile_index = self._previous_profile_index
	local _previous_career_index = self._previous_career_index

	if not _previous_profile_index and not _previous_career_index then
		local flag = false

		self._profile_synchronizer:assign_full_profile(peer_id, num, _previous_profile_index, _previous_career_index, flag)
	else
		self._profile_synchronizer:unassign_profiles_of_peer(peer_id, num)
	end
end

GameModeTutorial.register_rpcs = function (self, arg_4_1, arg_4_2)
	-- function 4
	GameModeTutorial.super.register_rpcs(self, arg_4_1, arg_4_2)
	self._adventure_spawning:register_rpcs(arg_4_1, arg_4_2)
end

GameModeTutorial.unregister_rpcs = function (self)
	-- function 5
	self._adventure_spawning:unregister_rpcs()
	GameModeTutorial.super.unregister_rpcs(self)
end

GameModeTutorial.player_entered_game_session = function (arg_6_0, arg_6_1, arg_6_2, arg_6_3)
	-- function 6
	GameModeTutorial.super.player_entered_game_session(arg_6_0, arg_6_1, arg_6_2, arg_6_3)

	local get_party_from_player_id, var_6_1 = Managers.party:get_party_from_player_id(arg_6_1, arg_6_2)

	if var_6_1 ~= 1 then
		local num = 1

		Managers.party:request_join_party(arg_6_1, arg_6_2, num)
	end
end

GameModeTutorial.event_local_player_spawned = function (self, arg_7_1)
	-- function 7
	self._local_player_spawned = true
	self._is_initial_spawn = arg_7_1
end

GameModeTutorial.destroy = function (self)
	-- function 8
	self:_switch_back_to_previous_profile()
end

GameModeTutorial.cleanup_game_mode_units = function (self)
	-- function 9
	self:_clear_bots()
end

GameModeTutorial._clear_bots = function (self)
	-- function 10
	local _bot_players = self._bot_players

	for i = #_bot_players, 1, -1 do
		self:_remove_bot(_bot_players[i])
	end
end

GameModeTutorial.add_bot = function (self, arg_11_1, arg_11_2)
	-- function 11
	local _bot_players = self._bot_players
	local num = 1
	local _add_bot_to_party = self:_add_bot_to_party(num, arg_11_1, arg_11_2)

	_bot_players[#_bot_players + 1] = _add_bot_to_party
end

GameModeTutorial._remove_bot = function (self, arg_12_1)
	-- function 12
	local _bot_players = self._bot_players
	local index_of = table.index_of(_bot_players, arg_12_1)

	self:_remove_bot_instant(arg_12_1)

	local count = #_bot_players

	_bot_players[index_of] = _bot_players[count]
	_bot_players[count] = nil
end

GameModeTutorial.update = function (self, arg_13_1, arg_13_2)
	-- function 13
	self._adventure_spawning:update(arg_13_1, arg_13_2)
end

GameModeTutorial.server_update = function (self, arg_14_1, arg_14_2)
	-- function 14
	self._adventure_spawning:server_update(arg_14_1, arg_14_2)
end

GameModeTutorial.evaluate_end_conditions = function (self, arg_15_1, arg_15_2, arg_15_3)
	-- function 15
	if not flag then
		self:complete_level()

		flag = false
	end
end

GameModeTutorial.mutators = function (arg_16_0)
	-- function 16
	return
end

GameModeTutorial.complete_level = function (self)
	-- function 17
	StatisticsUtil.register_complete_tutorial(Managers.state.game_mode.statistics_db)

	local backend = Managers.backend

	backend:get_interface("statistics"):save()
	backend:commit(true)

	self._transition = "finish_tutorial"
end

GameModeTutorial.wanted_transition = function (self)
	-- function 18
	return self._transition
end

GameModeTutorial.COMPLETE_LEVEL = function (arg_19_0)
	-- function 19
	flag = true
end

GameModeTutorial.game_mode_hud_disabled = function (self)
	-- function 20
	return self._hud_disabled
end

GameModeTutorial.disable_hud = function (self, arg_21_1)
	-- function 21
	self._hud_disabled = arg_21_1
end

GameModeTutorial.FAIL_LEVEL = function (arg_22_0)
	-- function 22
	flag_2 = true
end

GameModeTutorial.disable_player_spawning = function (self)
	-- function 23
	self._adventure_spawning:set_spawning_disabled(true)
end

GameModeTutorial.enable_player_spawning = function (self, arg_24_1, arg_24_2)
	-- function 24
	self._adventure_spawning:set_spawning_disabled(false)
	self._adventure_spawning:force_update_spawn_positions(arg_24_1, arg_24_2)
end

GameModeTutorial.teleport_despawned_players = function (self, arg_25_1)
	-- function 25
	self._adventure_spawning:teleport_despawned_players(arg_25_1)
end

GameModeTutorial.flow_callback_add_spawn_point = function (self, arg_26_1)
	-- function 26
	self._adventure_spawning:add_spawn_point(arg_26_1)
end

GameModeTutorial.set_override_respawn_group = function (self, arg_27_1, arg_27_2)
	-- function 27
	self._adventure_spawning:set_override_respawn_group(arg_27_1, arg_27_2)
end

GameModeTutorial.set_respawn_group_enabled = function (self, arg_28_1, arg_28_2)
	-- function 28
	self._adventure_spawning:set_respawn_group_enabled(arg_28_1, arg_28_2)
end

GameModeTutorial.set_respawn_gate_enabled = function (self, arg_29_1, arg_29_2)
	-- function 29
	self._adventure_spawning:set_respawn_gate_enabled(arg_29_1, arg_29_2)
end

GameModeTutorial.respawn_unit_spawned = function (self, arg_30_1)
	-- function 30
	self._adventure_spawning:respawn_unit_spawned(arg_30_1)
end

GameModeTutorial.get_respawn_handler = function (self)
	-- function 31
	return self._adventure_spawning:get_respawn_handler()
end

GameModeTutorial.respawn_gate_unit_spawned = function (self, arg_32_1)
	-- function 32
	self._adventure_spawning:respawn_gate_unit_spawned(arg_32_1)
end

GameModeTutorial.set_respawning_enabled = function (self, arg_33_1)
	-- function 33
	self._adventure_spawning:set_respawning_enabled(arg_33_1)
end

GameModeTutorial.remove_respawn_units_due_to_crossroads = function (self, arg_34_1, arg_34_2)
	-- function 34
	self._adventure_spawning:remove_respawn_units_due_to_crossroads(arg_34_1, arg_34_2)
end

GameModeTutorial.recalc_respawner_dist_due_to_crossroads = function (self)
	-- function 35
	self._adventure_spawning:recalc_respawner_dist_due_to_crossroads()
end

GameModeTutorial.force_respawn_dead_players = function (self)
	-- function 36
	self._adventure_spawning:force_respawn_dead_players()
end

GameModeTutorial.get_active_respawn_units = function (self)
	-- function 37
	return self._adventure_spawning:get_active_respawn_units()
end

GameModeTutorial.get_available_and_active_respawn_units = function (self)
	-- function 38
	return self._adventure_spawning:get_available_and_active_respawn_units()
end

GameModeTutorial.get_end_screen_config = function (self, arg_39_1, arg_39_2, arg_39_3)
	-- function 39
	local var_39_0
	local tbl = {}

	if not arg_39_1 then
		var_39_0 = "victory"

		local stats_id = arg_39_3:stats_id()
		local _statistics_db = self._statistics_db
		local _level_key = self._level_key
		local completed_level_difficulty_index = LevelUnlockUtils.completed_level_difficulty_index(_statistics_db, stats_id, _level_key)

		completed_level_difficulty_index = completed_level_difficulty_index or 0
		tbl = {
			level_key = _level_key,
			previous_completed_difficulty_index = completed_level_difficulty_index
		}
	else
		var_39_0 = "defeat"
	end

	return var_39_0, tbl
end

GameModeTutorial.ended = function (self, arg_40_1)
	-- function 40
	if not self._network_server:are_all_peers_ingame() then
		self._network_server:disconnect_joining_peers()
	end
end

GameModeTutorial.local_player_ready_to_start = function (self, arg_41_1)
	-- function 41
	if not self._local_player_spawned then
		return false
	end

	return true
end

GameModeTutorial.local_player_game_starts = function (self, arg_42_1, arg_42_2)
	-- function 42
	if not self._is_initial_spawn then
		LevelHelper:flow_event(self._world, "local_player_spawned")

		if not Development.parameter("attract_mode") then
			LevelHelper:flow_event(self._world, "start_benchmark")
		else
			LevelHelper:flow_event(self._world, "level_start_local_player_spawned")
		end
	end
end
