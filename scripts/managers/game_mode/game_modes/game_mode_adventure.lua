-- chunkname: @scripts/managers/game_mode/game_modes/game_mode_adventure.lua

require("scripts/managers/game_mode/game_modes/game_mode_base")
require("scripts/managers/game_mode/spawning_components/adventure_spawning")
require("scripts/managers/game_mode/adventure_profile_rules")

script_data.disable_gamemode_end = not not script_data.disable_gamemode_end
GameModeAdventure = class(GameModeAdventure, GameModeBase)

GameModeAdventure.init = function (self, settings, world, ...)
	-- function 1
	GameModeAdventure.super.init(self, settings, world, ...)

	self._lost_condition_timer = nil
	self._adventure_profile_rules = AdventureProfileRules:new(self._profile_synchronizer, self._network_server)

	local hero_side = Managers.state.side:get_side_from_name("heroes")

	self._adventure_spawning = AdventureSpawning:new(self._profile_synchronizer, hero_side, self._is_server, self._network_server)

	self:_register_player_spawner(self._adventure_spawning)

	self._bot_players = {}

	self:_setup_bot_spawn_priority_lookup()

	self._available_profiles = table.clone(PROFILES_BY_AFFILIATION.heroes)

	local event_manager = Managers.state.event

	event_manager:register(self, "level_start_local_player_spawned", "event_local_player_spawned")

	if LAUNCH_MODE == "attract_benchmark" then
		local peer_id = Network.peer_id()
		local local_player_id = 1
		local profile_name = PROFILES_BY_AFFILIATION.tutorial[1]
		local profile_index = FindProfileIndex(profile_name)
		local career_index = 1
		local is_bot = false
		local success = Managers.mechanism:try_reserve_profile_for_peer_by_mechanism(peer_id, profile_index, career_index, false)

		fassert(success, "this should never happen in this particular situation")

		local party_id = Managers.mechanism:reserved_party_id_by_peer(peer_id)

		self._profile_synchronizer:assign_full_profile(peer_id, local_player_id, profile_index, career_index, is_bot)
		Managers.party:request_join_party(peer_id, local_player_id, party_id)
	end

	self._local_player_spawned = false
end

GameModeAdventure.destroy = function (self)
	-- function 2
	return
end

GameModeAdventure.cleanup_game_mode_units = function (self)
	-- function 3
	local update_safe = false

	self:_clear_bots(update_safe)
end

GameModeAdventure.register_rpcs = function (self, network_event_delegate, network_transmit)
	-- function 4
	GameModeAdventure.super.register_rpcs(self, network_event_delegate, network_transmit)
	self._adventure_spawning:register_rpcs(network_event_delegate, network_transmit)
end

GameModeAdventure.unregister_rpcs = function (self)
	-- function 5
	self._adventure_spawning:unregister_rpcs()
	GameModeAdventure.super.unregister_rpcs(self)
end

GameModeAdventure.event_local_player_spawned = function (self, is_initial_spawn)
	-- function 6
	self._local_player_spawned = true
	self._is_initial_spawn = is_initial_spawn
end

GameModeAdventure.update = function (self, t, dt)
	-- function 7
	self._adventure_spawning:update(t, dt)
end

GameModeAdventure.server_update = function (self, t, dt)
	-- function 8
	GameModeAdventure.super.server_update(self, t, dt)
	self:_handle_bots(t, dt)
	self._adventure_spawning:server_update(t, dt)
end

GameModeAdventure.evaluate_end_conditions = function (self, round_started, dt, t, mutator_handler)
	-- function 9
	if script_data.disable_gamemode_end then
		return false
	end

	local ignore_bots = true
	local humans_dead = GameModeHelper.side_is_dead("heroes", ignore_bots)
	local players_disabled = not not GameModeHelper.side_is_disabled("heroes")
	local mutator_lost, mutator_lost_delay = mutator_handler:evaluate_lose_conditions()
	local lost = not self._lose_condition_disabled and not not self._local_player_spawned

	if self:is_about_to_end_game_early() then
		if lost then
			if t > self._lost_condition_timer then
				return true, "lost"
			else
				return false
			end
		else
			self:set_about_to_end_game_early(false)

			self._lost_condition_timer = nil
		end
	end

	if lost then
		self:set_about_to_end_game_early(true)

		if mutator_lost and mutator_lost_delay then
			self._lost_condition_timer = t + mutator_lost_delay
		elseif humans_dead then
			self._lost_condition_timer = t + GameModeSettings.adventure.lose_condition_time_dead
		else
			self._lost_condition_timer = t + GameModeSettings.adventure.lose_condition_time
		end
	elseif self:update_end_level_areas() then
		return true, "won"
	elseif self._level_completed then
		if Managers.deed:has_deed() and Managers.deed:is_session_faulty() then
			return true, "lost"
		else
			return true, "won"
		end
	else
		return false
	end
end

GameModeAdventure.player_entered_game_session = function (self, peer_id, local_player_id, requested_party_index)
	-- function 10
	GameModeAdventure.super.player_entered_game_session(self, peer_id, local_player_id, requested_party_index)

	if LAUNCH_MODE ~= "attract_benchmark" then
		self._adventure_profile_rules:handle_profile_delegation_for_joining_player(peer_id, local_player_id)
	end

	if Network.peer_id() == peer_id then
		local party_id = 1

		self:remove_bot(party_id, peer_id, local_player_id)

		local status = Managers.party:get_player_status(peer_id, local_player_id)

		if status.party_id ~= party_id then
			Managers.party:request_join_party(peer_id, local_player_id, party_id)
		end
	else
		self._adventure_spawning:add_delayed_client(peer_id, local_player_id)
	end
end

GameModeAdventure.player_left_game_session = function (self, peer_id, local_player_id)
	-- function 11
	GameModeAdventure.super.player_left_game_session(self, peer_id, local_player_id)
	self._adventure_spawning:remove_delayed_client(peer_id, local_player_id)
end

GameModeAdventure.remove_bot = function (self, party_id, peer_id, local_player_id, update_safe)
	-- function 12
	if #self._bot_players > 0 then
		local profile_index = self._profile_synchronizer:profile_by_peer(peer_id, local_player_id)
		local removed, bot_player = self:_remove_bot_by_profile(profile_index, update_safe)

		if not removed then
			update_safe = not not update_safe or not not false
			bot_player = self._bot_players[#self._bot_players]

			self:_remove_bot(bot_player, update_safe)
		end

		return bot_player
	end
end

GameModeAdventure.get_end_screen_config = function (self, game_won, game_lost, player)
	-- function 13
	local screen_name
	local screen_config = {}

	if game_won then
		screen_name = "victory"

		local stats_id = player:stats_id()
		local statistics_db = self._statistics_db
		local level_key = self._level_key
		local previous_completed_difficulty_index = not not LevelUnlockUtils.completed_level_difficulty_index(statistics_db, stats_id, level_key)

		screen_config = {
			show_act_presentation = true,
			level_key = level_key,
			previous_completed_difficulty_index = previous_completed_difficulty_index
		}
	else
		screen_name = "defeat"
	end

	return screen_name, screen_config
end

GameModeAdventure.ended = function (self, reason)
	-- function 14
	local all_peers_ingame = self._network_server:are_all_peers_ingame()

	if not all_peers_ingame then
		self._network_server:disconnect_joining_peers()
	end
end

GameModeAdventure.local_player_ready_to_start = function (self, player)
	-- function 15
	if not self._local_player_spawned then
		return false
	end

	return true
end

GameModeAdventure.local_player_game_starts = function (self, player, loading_context)
	-- function 16
	if self._is_initial_spawn then
		LevelHelper:flow_event(self._world, "local_player_spawned")

		if Development.parameter("attract_mode") then
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

GameModeAdventure.enable_player_spawning = function (self, safe_position, safe_rotation)
	-- function 18
	self._adventure_spawning:set_spawning_disabled(false)
	self._adventure_spawning:force_update_spawn_positions(safe_position, safe_rotation)
end

GameModeAdventure.teleport_despawned_players = function (self, position)
	-- function 19
	self._adventure_spawning:teleport_despawned_players(position)
end

GameModeAdventure.flow_callback_add_spawn_point = function (self, unit)
	-- function 20
	self._adventure_spawning:add_spawn_point(unit)
end

GameModeAdventure.set_override_respawn_group = function (self, respawn_group_name, active)
	-- function 21
	self._adventure_spawning:set_override_respawn_group(respawn_group_name, active)
end

GameModeAdventure.set_respawn_group_enabled = function (self, respawn_group_name, enabled)
	-- function 22
	self._adventure_spawning:set_respawn_group_enabled(respawn_group_name, enabled)
end

GameModeAdventure.set_respawn_gate_enabled = function (self, respawn_gate_unit, enabled)
	-- function 23
	self._adventure_spawning:set_respawn_gate_enabled(respawn_gate_unit, enabled)
end

GameModeAdventure.respawn_unit_spawned = function (self, unit)
	-- function 24
	self._adventure_spawning:respawn_unit_spawned(unit)
end

GameModeAdventure.respawn_gate_unit_spawned = function (self, unit)
	-- function 25
	self._adventure_spawning:respawn_gate_unit_spawned(unit)
end

GameModeAdventure.get_respawn_handler = function (self)
	-- function 26
	return self._adventure_spawning:get_respawn_handler()
end

GameModeAdventure.set_respawning_enabled = function (self, enabled)
	-- function 27
	self._adventure_spawning:set_respawning_enabled(enabled)
end

GameModeAdventure.remove_respawn_units_due_to_crossroads = function (self, removed_path_distances, total_main_path_length)
	-- function 28
	self._adventure_spawning:remove_respawn_units_due_to_crossroads(removed_path_distances, total_main_path_length)
end

GameModeAdventure.recalc_respawner_dist_due_to_crossroads = function (self)
	-- function 29
	self._adventure_spawning:recalc_respawner_dist_due_to_crossroads()
end

GameModeAdventure.force_respawn = function (self, peer_id, local_player_id)
	-- function 30
	local status = Managers.party:get_player_status(peer_id, local_player_id)

	if status.party_id == 0 then
		local party_id = 1

		Managers.party:assign_peer_to_party(peer_id, local_player_id, party_id)
	end

	self._adventure_spawning:force_respawn(peer_id, local_player_id)
end

GameModeAdventure.force_respawn_dead_players = function (self)
	-- function 31
	self._adventure_spawning:force_respawn_dead_players()
end

GameModeAdventure._get_first_available_bot_profile = function (self)
	-- function 32
	local available_profiles = self._available_profiles
	local profile_synchronizer = self._profile_synchronizer
	local available_profile_by_priority = {}

	for i = 1, #available_profiles do
		local profile_name = available_profiles[i]
		local profile_index = FindProfileIndex(profile_name)

		if not profile_synchronizer:is_profile_in_use(profile_index) then
			available_profile_by_priority[#available_profile_by_priority + 1] = profile_index
		end
	end

	local bot_profile_id_to_priority_id = self._bot_profile_id_to_priority_id

	table.sort(available_profile_by_priority, function (a, b)
		-- function 33
		return not not bot_profile_id_to_priority_id[a] < not not bot_profile_id_to_priority_id[b]
	end)

	local profile_index = available_profile_by_priority[1]
	local profile = SPProfiles[profile_index]
	local display_name = profile.display_name
	local hero_attributes = Managers.backend:get_interface("hero_attributes")
	local career_index = hero_attributes:get(display_name, "career")
	local bot_career_index = not not hero_attributes:get(display_name, "bot_career")
	local career = profile.careers[bot_career_index]
	local hero_experience = not not hero_attributes:get(display_name, "experience")
	local hero_level = ExperienceSettings.get_level(hero_experience)

	if not career and not career:is_unlocked_function(display_name, hero_level) then
		career_index = 1
		bot_career_index = 1
		career = profile.careers[career_index]

		hero_attributes:set(display_name, "career", career_index)
		hero_attributes:set(display_name, "bot_career", bot_career_index)
	end

	return profile_index, bot_career_index
end

GameModeAdventure._setup_bot_spawn_priority_lookup = function (self)
	-- function 34
	local saved_priority = PlayerData.bot_spawn_priority
	local num_saved_priority = #saved_priority

	if LAUNCH_MODE == "game" then
		if num_saved_priority > 0 then
			self._bot_profile_id_to_priority_id = {}

			for i = 1, num_saved_priority do
				local profile_id = saved_priority[i]

				self._bot_profile_id_to_priority_id[profile_id] = i
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

GameModeAdventure._handle_bots = function (self, t, dt)
	-- function 35
	local in_session = Managers.state.network ~= nil and not not not Managers.state.network.game_session_shutdown

	if not in_session then
		return
	end

	if script_data.ai_bots_disabled then
		if #self._bot_players > 0 then
			local update_safe = true

			self:_clear_bots(update_safe)
		end

		return
	end

	local party = Managers.party:get_party(1)
	local num_slots = party.num_slots
	local max_bots = num_slots

	if script_data.cap_num_bots then
		max_bots = math.min(max_bots, script_data.cap_num_bots)
	end

	local bot_players = self._bot_players
	local num_bot_players = #bot_players
	local delta = max_bots - num_bot_players

	if delta > 0 then
		local num_used_slots = party.num_used_slots
		local open_slots = num_slots - num_used_slots
		local num_bots_to_add = math.min(delta, open_slots)

		for i = 1, num_bots_to_add do
			self:_add_bot()
		end
	elseif delta < 0 then
		local num_bots_to_remove = math.abs(delta)

		for i = 1, num_bots_to_remove do
			local update_safe = true

			self:_remove_bot(bot_players[#bot_players], update_safe)
		end
	end
end

GameModeAdventure._add_bot = function (self)
	-- function 36
	local bot_players = self._bot_players
	local party_id = 1
	local party = Managers.party:get_party(party_id)
	local profile_index, career_index = self:_get_first_available_bot_profile(party)

	if LAUNCH_MODE == "attract_benchmark" then
		career_index = 1
	end

	local bot_player = self:_add_bot_to_party(party_id, profile_index, career_index)

	bot_players[#bot_players + 1] = bot_player
end

GameModeAdventure._remove_bot = function (self, bot_player, update_safe)
	-- function 37
	local bot_players = self._bot_players
	local index = table.index_of(self._bot_players, bot_player)

	if update_safe then
		self:_remove_bot_update_safe(bot_player)
	else
		self:_remove_bot_instant(bot_player)
	end

	local last = #bot_players

	bot_players[index] = bot_players[last]
	bot_players[last] = nil
end

GameModeAdventure._remove_bot_by_profile = function (self, profile_index, update_safe)
	-- function 38
	local bot_players = self._bot_players
	local bot_index
	local num_current_bots = #bot_players

	for i = 1, num_current_bots do
		local bot_player = bot_players[i]
		local bot_profile_index = bot_player:profile_index()

		if bot_profile_index == profile_index then
			bot_index = i

			break
		end
	end

	local bot_player
	local removed = false

	if bot_index then
		bot_player = bot_players[bot_index]
		update_safe = not not update_safe or not not false

		self:_remove_bot(bot_player, update_safe)

		removed = true
	end

	return removed, bot_player
end

GameModeAdventure._clear_bots = function (self, update_safe)
	-- function 39
	local bot_players = self._bot_players
	local num_bot_players = #bot_players

	for i = num_bot_players, 1, -1 do
		self:_remove_bot(bot_players[i], update_safe)
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

GameModeAdventure.get_player_wounds = function (self, profile)
	-- function 42
	if Managers.state.game_mode:has_activated_mutator("instant_death") then
		return 1
	end

	local difficulty_manager = Managers.state.difficulty
	local difficulty_settings = difficulty_manager:get_difficulty_settings()

	return difficulty_settings.wounds
end
