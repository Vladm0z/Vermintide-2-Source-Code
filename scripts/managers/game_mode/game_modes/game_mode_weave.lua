-- chunkname: @scripts/managers/game_mode/game_modes/game_mode_weave.lua

require("scripts/managers/game_mode/game_modes/game_mode_base")
require("scripts/managers/game_mode/spawning_components/weave_spawning")

local script_data = script_data
local disable_gamemode_end = script_data.disable_gamemode_end

disable_gamemode_end = disable_gamemode_end or Development.parameter("disable_gamemode_end")
script_data.disable_gamemode_end = disable_gamemode_end
GameModeWeave = class(GameModeWeave, GameModeBase)

local flag = false
local flag_2 = false

GameModeWeave.init = function (self, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7, arg_1_8)
	-- function 1
	GameModeWeave.super.init(self, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7, arg_1_8)

	self._lost_condition_timer = nil
	self.about_to_win = false
	self.win_condition_timer = nil
	self._adventure_profile_rules = AdventureProfileRules:new(self._profile_synchronizer, self._network_server)

	local get_side_from_name = Managers.state.side:get_side_from_name("heroes")

	self._weave_spawning = WeaveSpawning:new(self._profile_synchronizer, get_side_from_name, self._is_server, self._network_server, not arg_1_8 and arg_1_8.game_mode_data)

	self:_register_player_spawner(self._weave_spawning)

	self._available_profiles = table.clone(PROFILES_BY_AFFILIATION.heroes)
	self._bot_players = {}

	self:_setup_bot_spawn_priority_lookup()

	self._local_player_spawned = false
	self._has_locked_party_size = Managers.matchmaking:is_game_private()

	local event = Managers.state.event

	event:register(self, "level_start_local_player_spawned", "event_local_player_spawned")
	event:register(self, "on_ai_unit_destroyed", "on_ai_unit_destroyed")
end

GameModeWeave.register_rpcs = function (self, arg_2_1, arg_2_2)
	-- function 2
	GameModeWeave.super.register_rpcs(self, arg_2_1, arg_2_2)
	self._weave_spawning:register_rpcs(arg_2_1, arg_2_2)
end

GameModeWeave.unregister_rpcs = function (self)
	-- function 3
	self._weave_spawning:unregister_rpcs()
	GameModeWeave.super.unregister_rpcs(self)
end

GameModeWeave.event_local_player_spawned = function (self, arg_4_1)
	-- function 4
	self._local_player_spawned = true
	self._is_initial_spawn = arg_4_1
end

GameModeWeave.update = function (self, arg_5_1, arg_5_2)
	-- function 5
	self._weave_spawning:update(arg_5_1, arg_5_2)
end

GameModeWeave.server_update = function (self, arg_6_1, arg_6_2)
	-- function 6
	GameModeWeave.super.server_update(self, arg_6_1, arg_6_2)
	self:_handle_bots(arg_6_1, arg_6_2)
	self._weave_spawning:server_update(arg_6_1, arg_6_2)
end

GameModeWeave.evaluate_end_conditions = function (self, arg_7_1, arg_7_2, arg_7_3, arg_7_4)
	-- function 7
	if not script_data.disable_gamemode_end then
		return false
	end

	local flag = true
	local side_is_dead = GameModeHelper.side_is_dead("heroes", flag)
	local side_is_disabled = GameModeHelper.side_is_disabled("heroes")

	side_is_disabled = not side_is_disabled and not GameModeHelper.side_delaying_loss("heroes")

	local evaluate_lose_conditions = arg_7_4:evaluate_lose_conditions()
	local _is_time_up = self:_is_time_up(arg_7_3)
	local flag_2 = not not self._lose_condition_disabled or evaluate_lose_conditions or side_is_dead or side_is_disabled or self._level_failed

	if not self._about_to_win then
		if arg_7_3 > self.win_condition_timer then
			return true, "won"
		elseif not _is_time_up then
			return true, "lost"
		else
			return false
		end
	end

	if not self:is_about_to_end_game_early() then
		if not flag_2 then
			if arg_7_3 > self._lost_condition_timer then
				return true, "lost"
			else
				return false
			end
		else
			self:set_about_to_end_game_early(false)

			self._lost_condition_timer = nil
		end
	end

	if not flag_2 then
		self:set_about_to_end_game_early(true)

		if not side_is_dead then
			self._lost_condition_timer = arg_7_3 + GameModeSettings.weave.lose_condition_time_dead
		else
			self._lost_condition_timer = arg_7_3 + GameModeSettings.weave.lose_condition_time
		end
	elseif not (not self._level_completed and self._about_to_win) then
		if not Managers.weave:calculate_next_objective_index() then
			if not _is_time_up then
				return true, "won"
			else
				return true, "won"
			end
		else
			self._about_to_win = true
			self.win_condition_timer = arg_7_3 + 6
		end
	else
		return false
	end
end

GameModeWeave.get_saved_game_mode_data = function (self)
	-- function 8
	local get_saved_game_mode_data = self._weave_spawning:get_saved_game_mode_data()

	return table.clone(get_saved_game_mode_data)
end

GameModeWeave.mutators = function (arg_9_0)
	-- function 9
	return (Managers.weave:mutators())
end

GameModeWeave.ai_killed = function (arg_10_0, arg_10_1, arg_10_2, arg_10_3, arg_10_4)
	-- function 10
	Managers.weave:ai_killed(arg_10_1, arg_10_2, arg_10_3, arg_10_4)
end

GameModeWeave.on_ai_unit_destroyed = function (arg_11_0, arg_11_1, arg_11_2, arg_11_3)
	-- function 11
	if arg_11_3 ~= "far_away" or not arg_11_2 then
		local get_data = Unit.get_data(arg_11_1, "spawn_type")

		get_data = get_data or "unknown"

		local enemy_recycler = Managers.state.conflict.enemy_recycler
		local breed = arg_11_2.breed
		local tbl = {
			despawned = true,
			breed = breed
		}
		local var_11_4 = Vector3Box(POSITION_LOOKUP[arg_11_1])
		local var_11_5 = QuaternionBox(Unit.local_rotation(arg_11_1, 0))
		local tbl_2 = {
			spawn_type = get_data
		}

		enemy_recycler:add_breed(breed.name, var_11_4, var_11_5, tbl_2)
		Managers.state.entity:system("objective_system"):on_ai_killed(arg_11_1, nil, tbl)
	end
end

GameModeWeave._is_time_up = function (arg_12_0)
	-- function 12
	if not LEVEL_EDITOR_TEST then
		return false
	end

	local get_time_left = Managers.weave:get_time_left()

	if not get_time_left then
		return get_time_left <= 0
	end

	return Managers.state.network:network_time() / NetworkConstants.clock_time.max > 0.9
end

GameModeWeave.player_entered_game_session = function (self, arg_13_1, arg_13_2)
	-- function 13
	GameModeWeave.super.player_entered_game_session(self, arg_13_1, arg_13_2)

	if LAUNCH_MODE ~= "attract_benchmark" then
		self._adventure_profile_rules:handle_profile_delegation_for_joining_player(arg_13_1, arg_13_2)
	end

	if Managers.party:get_player_status(arg_13_1, arg_13_2).party_id ~= 1 then
		local num = 1

		if #self._bot_players > 0 then
			local profile_by_peer = self._profile_synchronizer:profile_by_peer(arg_13_1, arg_13_2)

			if not self:_remove_bot_by_profile(profile_by_peer) then
				local flag = false

				self:_remove_bot(self._bot_players[#self._bot_players], flag)
			end
		end

		Managers.party:request_join_party(arg_13_1, arg_13_2, num)
	end
end

GameModeWeave.players_left_safe_zone = function (arg_14_0)
	-- function 14
	Managers.weave:weave_spawner():players_left_safe_zone()
end

GameModeWeave.disable_player_spawning = function (self)
	-- function 15
	self._weave_spawning:set_spawning_disabled(true)
end

GameModeWeave.enable_player_spawning = function (self, arg_16_1, arg_16_2)
	-- function 16
	self._weave_spawning:set_spawning_disabled(false)
	self._weave_spawning:force_update_spawn_positions(arg_16_1, arg_16_2)
end

GameModeWeave.teleport_despawned_players = function (self, arg_17_1)
	-- function 17
	self._weave_spawning:teleport_despawned_players(arg_17_1)
end

GameModeWeave.flow_callback_add_spawn_point = function (self, arg_18_1)
	-- function 18
	self._weave_spawning:add_spawn_point(arg_18_1)
end

GameModeWeave.set_override_respawn_group = function (self, arg_19_1, arg_19_2)
	-- function 19
	self._weave_spawning:set_override_respawn_group(arg_19_1, arg_19_2)
end

GameModeWeave.set_respawn_group_enabled = function (self, arg_20_1, arg_20_2)
	-- function 20
	self._weave_spawning:set_respawn_group_enabled(arg_20_1, arg_20_2)
end

GameModeWeave.set_respawn_gate_enabled = function (self, arg_21_1, arg_21_2)
	-- function 21
	self._weave_spawning:set_respawn_gate_enabled(arg_21_1, arg_21_2)
end

GameModeWeave.respawn_unit_spawned = function (self, arg_22_1)
	-- function 22
	self._weave_spawning:respawn_unit_spawned(arg_22_1)
end

GameModeWeave.get_respawn_handler = function (self)
	-- function 23
	return self._weave_spawning:get_respawn_handler()
end

GameModeWeave.respawn_gate_unit_spawned = function (self, arg_24_1)
	-- function 24
	self._weave_spawning:respawn_gate_unit_spawned(arg_24_1)
end

GameModeWeave.set_respawning_enabled = function (self, arg_25_1)
	-- function 25
	self._weave_spawning:set_respawning_enabled(arg_25_1)
end

GameModeWeave.remove_respawn_units_due_to_crossroads = function (self, arg_26_1, arg_26_2)
	-- function 26
	self._weave_spawning:remove_respawn_units_due_to_crossroads(arg_26_1, arg_26_2)
end

GameModeWeave.recalc_respawner_dist_due_to_crossroads = function (self)
	-- function 27
	self._weave_spawning:recalc_respawner_dist_due_to_crossroads()
end

GameModeWeave.force_respawn = function (self, arg_28_1, arg_28_2)
	-- function 28
	if Managers.party:get_player_status(arg_28_1, arg_28_2).party_id == 0 then
		local num = 1

		Managers.party:assign_peer_to_party(arg_28_1, arg_28_2, num)
	end

	self._weave_spawning:force_respawn(arg_28_1, arg_28_2)
end

GameModeWeave.force_respawn_dead_players = function (self)
	-- function 29
	self._weave_spawning:force_respawn_dead_players()
end

GameModeWeave.get_active_respawn_units = function (self)
	-- function 30
	return self._weave_spawning:get_active_respawn_units()
end

GameModeWeave.get_available_and_active_respawn_units = function (self)
	-- function 31
	return self._weave_spawning:get_available_and_active_respawn_units()
end

GameModeWeave.get_player_wounds = function (arg_32_0, arg_32_1)
	-- function 32
	if not Managers.state.game_mode:has_activated_mutator("instant_death") then
		return 1
	end

	return Managers.state.difficulty:get_difficulty_settings().wounds
end

GameModeWeave.get_boss_loot_pickup = function (arg_33_0)
	-- function 33
	return nil
end

GameModeWeave.ended = function (self, arg_34_1)
	-- function 34
	if not self._network_server:are_all_peers_ingame() then
		self._network_server:disconnect_joining_peers()
	end

	local weave = Managers.weave
	local calculate_next_objective_index = weave:calculate_next_objective_index()
	local get_active_weave_phase = weave:get_active_weave_phase()

	weave:set_active_weave_phase(get_active_weave_phase + 1)

	if not (arg_34_1 ~= "won" or calculate_next_objective_index) then
		weave:sync_end_of_weave_data()
	end
end

GameModeWeave.get_end_screen_config = function (arg_35_0, arg_35_1, arg_35_2, arg_35_3)
	-- function 35
	local str = "none"
	local tbl = {}

	if not arg_35_1 then
		if not Managers.weave:calculate_next_objective_index() then
			str = "victory"
			tbl = {
				show_act_presentation = false
			}
		end
	elseif not Managers.weave:calculate_next_objective_index() then
		str = "defeat"
	end

	return str, tbl
end

GameModeWeave.local_player_ready_to_start = function (self, arg_36_1)
	-- function 36
	if not self._local_player_spawned then
		return false
	end

	return true
end

GameModeWeave.local_player_game_starts = function (self, arg_37_1, arg_37_2)
	-- function 37
	if not self._is_initial_spawn then
		LevelHelper:flow_event(self._world, "local_player_spawned")

		if not Development.parameter("attract_mode") then
			LevelHelper:flow_event(self._world, "start_benchmark")
		else
			LevelHelper:flow_event(self._world, "level_start_local_player_spawned")
		end
	end

	local weave = Managers.weave

	if not self._is_server then
		weave:store_player_ids()
		weave:start_objective()
		weave:reset_statistics_for_challenges()
		weave:start_timer()
	end
end

GameModeWeave._get_first_available_bot_profile = function (self)
	-- function 38
	local _available_profiles = self._available_profiles
	local _profile_synchronizer = self._profile_synchronizer
	local tbl = {}

	for i = 1, #_available_profiles do
		local var_38_3 = _available_profiles[i]
		local var_38_4 = FindProfileIndex(var_38_3)

		if not _profile_synchronizer:is_profile_in_use(var_38_4) then
			tbl[#tbl + 1] = var_38_4
		end
	end

	local _bot_profile_id_to_priority_id = self._bot_profile_id_to_priority_id

	table.sort(tbl, function (arg_39_0, arg_39_1)
		-- function 39
		local var_39_0 = _bot_profile_id_to_priority_id[arg_39_0]

		var_39_0 = var_39_0 or math.huge

		local var_39_1 = _bot_profile_id_to_priority_id[arg_39_1]

		var_39_1 = var_39_1 or math.huge

		return var_39_0 < var_39_1
	end)

	local var_38_6 = tbl[1]

	if not script_data.wanted_bot_profile then
		local var_38_7 = FindProfileIndex(script_data.wanted_bot_profile)

		if not (script_data.allow_same_bots or _profile_synchronizer:is_profile_in_use(var_38_7)) then
			var_38_6 = var_38_7
		end
	end

	local display_name = SPProfiles[var_38_6].display_name
	local get_interface = Managers.backend:get_interface("hero_attributes")
	local get = get_interface:get(display_name, "career")
	local get_2 = get_interface:get(display_name, "bot_career")

	get_2 = get_2 or get or 1

	if not script_data.wanted_bot_career_index then
		get_2 = script_data.wanted_bot_career_index
	end

	return var_38_6, get_2
end

GameModeWeave._setup_bot_spawn_priority_lookup = function (self)
	-- function 40
	local bot_spawn_priority = PlayerData.bot_spawn_priority
	local count = #bot_spawn_priority

	if LAUNCH_MODE == "game" then
		if count > 0 then
			self._bot_profile_id_to_priority_id = {}

			for i = 1, count do
				local var_40_2 = bot_spawn_priority[i]

				self._bot_profile_id_to_priority_id[var_40_2] = i
			end
		else
			self._bot_profile_id_to_priority_id = ProfileIndexToPriorityIndex
		end
	elseif LAUNCH_MODE == "attract_benchmark" then
		self._bot_profile_id_to_priority_id = ProfileIndexToPriorityIndex
	else
		self._bot_profile_id_to_priority_id = ProfileIndexToPriorityIndex
	end
end

GameModeWeave._handle_bots = function (self, arg_41_1, arg_41_2)
	-- function 41
	if not (Managers.state.network == nil or not Managers.state.network.game_session_shutdown) then
		return
	end

	local parameter = Development.parameter("enable_bots_in_weaves")

	parameter = parameter or not self._has_locked_party_size

	if not (script_data.ai_bots_disabled or parameter) then
		if #self._bot_players > 0 then
			local flag = true

			self:_clear_bots(flag)
		end

		return
	end

	local get_party = Managers.party:get_party(1)
	local num_slots = get_party.num_slots
	local var_41_4 = num_slots

	if not script_data.cap_num_bots then
		var_41_4 = math.min(var_41_4, script_data.cap_num_bots)
	end

	local _bot_players = self._bot_players
	local num = var_41_4 - #_bot_players

	if num > 0 then
		local num_2 = num_slots - get_party.num_used_slots
		local min = math.min(num, num_2)

		for i = 1, min do
			self:_add_bot()
		end
	elseif num < 0 then
		local abs = math.abs(num)

		for j = 1, abs do
			local flag_2 = true

			self:_remove_bot(_bot_players[#_bot_players], flag_2)
		end
	end
end

GameModeWeave._add_bot = function (self)
	-- function 42
	local _bot_players = self._bot_players
	local num = 1
	local get_party = Managers.party:get_party(num)
	local _get_first_available_bot_profile, var_42_4 = self:_get_first_available_bot_profile(get_party)

	if LAUNCH_MODE == "attract_benchmark" then
		var_42_4 = 1
	end

	local _add_bot_to_party = self:_add_bot_to_party(num, _get_first_available_bot_profile, var_42_4)

	_bot_players[#_bot_players + 1] = _add_bot_to_party
end

GameModeWeave._remove_bot = function (self, arg_43_1, arg_43_2)
	-- function 43
	local _bot_players = self._bot_players
	local index_of = table.index_of(_bot_players, arg_43_1)

	if not arg_43_2 then
		self:_remove_bot_update_safe(arg_43_1)
	else
		self:_remove_bot_instant(arg_43_1)
	end

	local count = #_bot_players

	_bot_players[index_of] = _bot_players[count]
	_bot_players[count] = nil
end

GameModeWeave._remove_bot_by_profile = function (self, arg_44_1)
	-- function 44
	local _bot_players = self._bot_players
	local var_44_1
	local count = #_bot_players

	for i = 1, count do
		if _bot_players[i]:profile_index() == arg_44_1 then
			var_44_1 = i

			break
		end
	end

	local flag = false

	if not var_44_1 then
		local flag_2 = false

		self:_remove_bot(_bot_players[var_44_1], flag_2)

		flag = true
	end

	return flag
end

GameModeWeave._clear_bots = function (self, arg_45_1)
	-- function 45
	local _bot_players = self._bot_players

	for i = #_bot_players, 1, -1 do
		self:_remove_bot(_bot_players[i], arg_45_1)
	end
end

GameModeWeave.cleanup_game_mode_units = function (self)
	-- function 46
	local flag = false

	self:_clear_bots(flag)
end
