-- chunkname: @scripts/managers/game_mode/game_modes/game_mode_adventure.lua

require("scripts/managers/game_mode/game_modes/game_mode_base")
require("scripts/managers/game_mode/spawning_components/adventure_spawning")
require("scripts/managers/game_mode/adventure_profile_rules")

local script_data = script_data
local disable_gamemode_end = script_data.disable_gamemode_end

disable_gamemode_end = disable_gamemode_end or Development.parameter("disable_gamemode_end")
script_data.disable_gamemode_end = disable_gamemode_end
GameModeAdventure = class(GameModeAdventure, GameModeBase)

GameModeAdventure.init = function (self, arg_1_1, arg_1_2, ...)
	-- function 1
	GameModeAdventure.super.init(self, arg_1_1, arg_1_2, ...)

	self._lost_condition_timer = nil
	self._adventure_profile_rules = AdventureProfileRules:new(self._profile_synchronizer, self._network_server)

	local get_side_from_name = Managers.state.side:get_side_from_name("heroes")

	self._adventure_spawning = AdventureSpawning:new(self._profile_synchronizer, get_side_from_name, self._is_server, self._network_server)

	self:_register_player_spawner(self._adventure_spawning)

	self._bot_players = {}

	self:_setup_bot_spawn_priority_lookup()

	self._available_profiles = table.clone(PROFILES_BY_AFFILIATION.heroes)

	Managers.state.event:register(self, "level_start_local_player_spawned", "event_local_player_spawned")

	if LAUNCH_MODE == "attract_benchmark" then
		local peer_id = Network.peer_id()
		local num = 1
		local var_1_3 = PROFILES_BY_AFFILIATION.tutorial[1]
		local var_1_4 = FindProfileIndex(var_1_3)
		local num_2 = 1
		local flag = false
		local try_reserve_profile_for_peer_by_mechanism = Managers.mechanism:try_reserve_profile_for_peer_by_mechanism(peer_id, var_1_4, num_2, false)

		fassert(try_reserve_profile_for_peer_by_mechanism, "this should never happen in this particular situation")

		local reserved_party_id_by_peer = Managers.mechanism:reserved_party_id_by_peer(peer_id)

		self._profile_synchronizer:assign_full_profile(peer_id, num, var_1_4, num_2, flag)
		Managers.party:request_join_party(peer_id, num, reserved_party_id_by_peer)
	end

	self._local_player_spawned = false
end

GameModeAdventure.destroy = function (arg_2_0)
	-- function 2
	return
end

GameModeAdventure.cleanup_game_mode_units = function (self)
	-- function 3
	local flag = false

	self:_clear_bots(flag)
end

GameModeAdventure.register_rpcs = function (self, arg_4_1, arg_4_2)
	-- function 4
	GameModeAdventure.super.register_rpcs(self, arg_4_1, arg_4_2)
	self._adventure_spawning:register_rpcs(arg_4_1, arg_4_2)
end

GameModeAdventure.unregister_rpcs = function (self)
	-- function 5
	self._adventure_spawning:unregister_rpcs()
	GameModeAdventure.super.unregister_rpcs(self)
end

GameModeAdventure.event_local_player_spawned = function (self, arg_6_1)
	-- function 6
	self._local_player_spawned = true
	self._is_initial_spawn = arg_6_1
end

GameModeAdventure.update = function (self, arg_7_1, arg_7_2)
	-- function 7
	self._adventure_spawning:update(arg_7_1, arg_7_2)
end

GameModeAdventure.server_update = function (self, arg_8_1, arg_8_2)
	-- function 8
	GameModeAdventure.super.server_update(self, arg_8_1, arg_8_2)
	self:_handle_bots(arg_8_1, arg_8_2)
	self._adventure_spawning:server_update(arg_8_1, arg_8_2)
end

GameModeAdventure.evaluate_end_conditions = function (self, arg_9_1, arg_9_2, arg_9_3, arg_9_4)
	-- function 9
	if not script_data.disable_gamemode_end then
		return false
	end

	local flag = true
	local side_is_dead = GameModeHelper.side_is_dead("heroes", flag)
	local side_is_disabled = GameModeHelper.side_is_disabled("heroes")

	side_is_disabled = not side_is_disabled and not GameModeHelper.side_delaying_loss("heroes")

	local evaluate_lose_conditions, var_9_4 = arg_9_4:evaluate_lose_conditions()
	local _local_player_spawned

	if not self._lose_condition_disabled then
		_local_player_spawned = self._local_player_spawned

		if not (not _local_player_spawned and evaluate_lose_conditions or side_is_dead or side_is_disabled) then
			-- Nothing
		end

		::label_9_2::

		_local_player_spawned = self._level_failed

		if not _local_player_spawned then
			_local_player_spawned = self:_is_time_up()
		end
	else
		_local_player_spawned = false
	end

	if false then
		_local_player_spawned = true
	end

	::label_9_3::

	if not self:is_about_to_end_game_early() then
		if not _local_player_spawned then
			if arg_9_3 > self._lost_condition_timer then
				return true, "lost"
			else
				return false
			end
		else
			self:set_about_to_end_game_early(false)

			self._lost_condition_timer = nil
		end
	end

	if not _local_player_spawned then
		self:set_about_to_end_game_early(true)

		if not evaluate_lose_conditions and not var_9_4 then
			self._lost_condition_timer = arg_9_3 + var_9_4
		elseif not side_is_dead then
			self._lost_condition_timer = arg_9_3 + GameModeSettings.adventure.lose_condition_time_dead
		else
			self._lost_condition_timer = arg_9_3 + GameModeSettings.adventure.lose_condition_time
		end
	elseif not self:update_end_level_areas() then
		return true, "won"
	elseif not self._level_completed then
		if not Managers.deed:has_deed() and not Managers.deed:is_session_faulty() then
			return true, "lost"
		else
			return true, "won"
		end
	else
		return false
	end
end

GameModeAdventure.player_entered_game_session = function (self, arg_10_1, arg_10_2, arg_10_3)
	-- function 10
	GameModeAdventure.super.player_entered_game_session(self, arg_10_1, arg_10_2, arg_10_3)

	if LAUNCH_MODE ~= "attract_benchmark" then
		self._adventure_profile_rules:handle_profile_delegation_for_joining_player(arg_10_1, arg_10_2)
	end

	if Network.peer_id() == arg_10_1 then
		local num = 1

		self:remove_bot(num, arg_10_1, arg_10_2)

		if Managers.party:get_player_status(arg_10_1, arg_10_2).party_id ~= num then
			Managers.party:request_join_party(arg_10_1, arg_10_2, num)
		end
	else
		self._adventure_spawning:add_delayed_client(arg_10_1, arg_10_2)
	end
end

GameModeAdventure.player_left_game_session = function (self, arg_11_1, arg_11_2)
	-- function 11
	GameModeAdventure.super.player_left_game_session(self, arg_11_1, arg_11_2)
	self._adventure_spawning:remove_delayed_client(arg_11_1, arg_11_2)
end

GameModeAdventure.remove_bot = function (self, arg_12_1, arg_12_2, arg_12_3, arg_12_4)
	-- function 12
	if #self._bot_players > 0 then
		local profile_by_peer = self._profile_synchronizer:profile_by_peer(arg_12_2, arg_12_3)
		local _remove_bot_by_profile, var_12_2 = self:_remove_bot_by_profile(profile_by_peer, arg_12_4)

		if not _remove_bot_by_profile then
			arg_12_4 = arg_12_4 or false
			var_12_2 = self._bot_players[#self._bot_players]

			self:_remove_bot(var_12_2, arg_12_4)
		end

		return var_12_2
	end
end

GameModeAdventure.get_end_screen_config = function (self, arg_13_1, arg_13_2, arg_13_3)
	-- function 13
	local var_13_0
	local tbl = {}

	if not arg_13_1 then
		var_13_0 = "victory"

		local stats_id = arg_13_3:stats_id()
		local _statistics_db = self._statistics_db
		local _level_key = self._level_key
		local completed_level_difficulty_index = LevelUnlockUtils.completed_level_difficulty_index(_statistics_db, stats_id, _level_key)

		completed_level_difficulty_index = completed_level_difficulty_index or 0
		tbl = {
			show_act_presentation = true,
			level_key = _level_key,
			previous_completed_difficulty_index = completed_level_difficulty_index
		}
	else
		var_13_0 = "defeat"
	end

	return var_13_0, tbl
end

GameModeAdventure.ended = function (self, arg_14_1)
	-- function 14
	if not self._network_server:are_all_peers_ingame() then
		self._network_server:disconnect_joining_peers()
	end
end

GameModeAdventure.local_player_ready_to_start = function (self, arg_15_1)
	-- function 15
	if not self._local_player_spawned then
		return false
	end

	return true
end

GameModeAdventure.local_player_game_starts = function (self, arg_16_1, arg_16_2)
	-- function 16
	if not self._is_initial_spawn then
		LevelHelper:flow_event(self._world, "local_player_spawned")

		if not Development.parameter("attract_mode") then
			LevelHelper:flow_event(self._world, "start_benchmark")
		else
			LevelHelper:flow_event(self._world, "level_start_local_player_spawned")
		end
	end
end

GameModeAdventure.disable_player_spawning = function (self)
	-- function 17
	self._adventure_spawning:set_spawning_disabled(true)
end

GameModeAdventure.enable_player_spawning = function (self, arg_18_1, arg_18_2)
	-- function 18
	self._adventure_spawning:set_spawning_disabled(false)
	self._adventure_spawning:force_update_spawn_positions(arg_18_1, arg_18_2)
end

GameModeAdventure.teleport_despawned_players = function (self, arg_19_1)
	-- function 19
	self._adventure_spawning:teleport_despawned_players(arg_19_1)
end

GameModeAdventure.flow_callback_add_spawn_point = function (self, arg_20_1)
	-- function 20
	self._adventure_spawning:add_spawn_point(arg_20_1)
end

GameModeAdventure.set_override_respawn_group = function (self, arg_21_1, arg_21_2)
	-- function 21
	self._adventure_spawning:set_override_respawn_group(arg_21_1, arg_21_2)
end

GameModeAdventure.set_respawn_group_enabled = function (self, arg_22_1, arg_22_2)
	-- function 22
	self._adventure_spawning:set_respawn_group_enabled(arg_22_1, arg_22_2)
end

GameModeAdventure.set_respawn_gate_enabled = function (self, arg_23_1, arg_23_2)
	-- function 23
	self._adventure_spawning:set_respawn_gate_enabled(arg_23_1, arg_23_2)
end

GameModeAdventure.respawn_unit_spawned = function (self, arg_24_1)
	-- function 24
	self._adventure_spawning:respawn_unit_spawned(arg_24_1)
end

GameModeAdventure.respawn_gate_unit_spawned = function (self, arg_25_1)
	-- function 25
	self._adventure_spawning:respawn_gate_unit_spawned(arg_25_1)
end

GameModeAdventure.get_respawn_handler = function (self)
	-- function 26
	return self._adventure_spawning:get_respawn_handler()
end

GameModeAdventure.set_respawning_enabled = function (self, arg_27_1)
	-- function 27
	self._adventure_spawning:set_respawning_enabled(arg_27_1)
end

GameModeAdventure.remove_respawn_units_due_to_crossroads = function (self, arg_28_1, arg_28_2)
	-- function 28
	self._adventure_spawning:remove_respawn_units_due_to_crossroads(arg_28_1, arg_28_2)
end

GameModeAdventure.recalc_respawner_dist_due_to_crossroads = function (self)
	-- function 29
	self._adventure_spawning:recalc_respawner_dist_due_to_crossroads()
end

GameModeAdventure.force_respawn = function (self, arg_30_1, arg_30_2)
	-- function 30
	if Managers.party:get_player_status(arg_30_1, arg_30_2).party_id == 0 then
		local num = 1

		Managers.party:assign_peer_to_party(arg_30_1, arg_30_2, num)
	end

	self._adventure_spawning:force_respawn(arg_30_1, arg_30_2)
end

GameModeAdventure.force_respawn_dead_players = function (self)
	-- function 31
	self._adventure_spawning:force_respawn_dead_players()
end

GameModeAdventure._get_first_available_bot_profile = function (self)
	-- function 32
	local _available_profiles = self._available_profiles
	local _profile_synchronizer = self._profile_synchronizer
	local tbl = {}

	for i = 1, #_available_profiles do
		local var_32_3 = _available_profiles[i]
		local var_32_4 = FindProfileIndex(var_32_3)

		if not _profile_synchronizer:is_profile_in_use(var_32_4) then
			tbl[#tbl + 1] = var_32_4
		end
	end

	local _bot_profile_id_to_priority_id = self._bot_profile_id_to_priority_id

	table.sort(tbl, function (arg_33_0, arg_33_1)
		-- function 33
		local var_33_0 = _bot_profile_id_to_priority_id[arg_33_0]

		var_33_0 = var_33_0 or math.huge

		local var_33_1 = _bot_profile_id_to_priority_id[arg_33_1]

		var_33_1 = var_33_1 or math.huge

		return var_33_0 < var_33_1
	end)

	local var_32_6 = tbl[1]
	local var_32_7 = SPProfiles[var_32_6]
	local display_name = var_32_7.display_name
	local get_interface = Managers.backend:get_interface("hero_attributes")
	local get = get_interface:get(display_name, "career")
	local get_2 = get_interface:get(display_name, "bot_career")

	get_2 = get_2 or get or 1

	local var_32_12 = var_32_7.careers[get_2]
	local get_3 = get_interface:get(display_name, "experience")

	get_3 = get_3 or 0

	local get_level = ExperienceSettings.get_level(get_3)

	if not (var_32_12 or var_32_12:is_unlocked_function(display_name, get_level)) then
		local num = 1

		get_2 = 1

		local var_32_16 = var_32_7.careers[num]

		get_interface:set(display_name, "career", num)
		get_interface:set(display_name, "bot_career", get_2)
	end

	return var_32_6, get_2
end

GameModeAdventure._setup_bot_spawn_priority_lookup = function (self)
	-- function 34
	local bot_spawn_priority = PlayerData.bot_spawn_priority
	local count = #bot_spawn_priority

	if LAUNCH_MODE == "game" then
		if count > 0 then
			self._bot_profile_id_to_priority_id = {}

			for i = 1, count do
				local var_34_2 = bot_spawn_priority[i]

				self._bot_profile_id_to_priority_id[var_34_2] = i
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

GameModeAdventure._handle_bots = function (self, arg_35_1, arg_35_2)
	-- function 35
	if not (Managers.state.network == nil or not Managers.state.network.game_session_shutdown) then
		return
	end

	if not script_data.ai_bots_disabled then
		if #self._bot_players > 0 then
			local flag = true

			self:_clear_bots(flag)
		end

		return
	end

	local get_party = Managers.party:get_party(1)
	local num_slots = get_party.num_slots
	local var_35_3 = num_slots

	if not script_data.cap_num_bots then
		var_35_3 = math.min(var_35_3, script_data.cap_num_bots)
	end

	local _bot_players = self._bot_players
	local num = var_35_3 - #_bot_players

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

GameModeAdventure._add_bot = function (self)
	-- function 36
	local _bot_players = self._bot_players
	local num = 1
	local get_party = Managers.party:get_party(num)
	local _get_first_available_bot_profile, var_36_4 = self:_get_first_available_bot_profile(get_party)

	if LAUNCH_MODE == "attract_benchmark" then
		var_36_4 = 1
	end

	local _add_bot_to_party = self:_add_bot_to_party(num, _get_first_available_bot_profile, var_36_4)

	_bot_players[#_bot_players + 1] = _add_bot_to_party
end

GameModeAdventure._remove_bot = function (self, arg_37_1, arg_37_2)
	-- function 37
	local _bot_players = self._bot_players
	local index_of = table.index_of(self._bot_players, arg_37_1)

	if not arg_37_2 then
		self:_remove_bot_update_safe(arg_37_1)
	else
		self:_remove_bot_instant(arg_37_1)
	end

	local count = #_bot_players

	_bot_players[index_of] = _bot_players[count]
	_bot_players[count] = nil
end

GameModeAdventure._remove_bot_by_profile = function (self, arg_38_1, arg_38_2)
	-- function 38
	local _bot_players = self._bot_players
	local var_38_1
	local count = #_bot_players

	for i = 1, count do
		if _bot_players[i]:profile_index() == arg_38_1 then
			var_38_1 = i

			break
		end
	end

	local var_38_3
	local flag = false

	if not var_38_1 then
		var_38_3 = _bot_players[var_38_1]
		arg_38_2 = arg_38_2 or false

		self:_remove_bot(var_38_3, arg_38_2)

		flag = true
	end

	return flag, var_38_3
end

GameModeAdventure._clear_bots = function (self, arg_39_1)
	-- function 39
	local _bot_players = self._bot_players

	for i = #_bot_players, 1, -1 do
		self:_remove_bot(_bot_players[i], arg_39_1)
	end
end

GameModeAdventure.get_active_respawn_units = function (self)
	-- function 40
	return self._adventure_spawning:get_active_respawn_units()
end

GameModeAdventure.get_available_and_active_respawn_units = function (self)
	-- function 41
	return self._adventure_spawning:get_available_and_active_respawn_units()
end

GameModeAdventure.get_player_wounds = function (arg_42_0, arg_42_1)
	-- function 42
	if not Managers.state.game_mode:has_activated_mutator("instant_death") then
		return 1
	end

	return Managers.state.difficulty:get_difficulty_settings().wounds
end
