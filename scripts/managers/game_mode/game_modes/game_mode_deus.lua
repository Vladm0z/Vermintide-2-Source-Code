-- chunkname: @scripts/managers/game_mode/game_modes/game_mode_deus.lua

require("scripts/managers/game_mode/game_modes/game_mode_base")
require("scripts/managers/game_mode/spawning_components/deus_spawning")
require("scripts/settings/dlcs/morris/deus_soft_currency_settings")
require("scripts/utils/hash_utils")

local num = 1
local str = "ferry_lady"
local str_2 = "volume_intro_vo"

local function fn(arg_1_0, arg_1_1)
	-- function 1
	local extension_input = ScriptUnit.extension_input(arg_1_0, "dialogue_system")
	local alloc_table = FrameTable.alloc_table()

	if not arg_1_1 then
		extension_input:trigger_dialogue_event("curse_intro", alloc_table)
	else
		extension_input:trigger_dialogue_event("no_curse_intro", alloc_table)
	end
end

GameModeDeus = class(GameModeDeus, GameModeBase)

GameModeDeus.init = function (self, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5, arg_2_6, arg_2_7, arg_2_8)
	-- function 2
	GameModeDeus.super.init(self, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5, arg_2_6, arg_2_7)
	fassert(arg_2_8, "game mode settings can not be nil")
	fassert(arg_2_8.deus_run_controller, "game mode settings must provide a deus run controller")

	self._lost_condition_timer = nil
	self._adventure_profile_rules = AdventureProfileRules:new(self._profile_synchronizer, self._network_server)

	local get_side_from_name = Managers.state.side:get_side_from_name("heroes")

	self._mutators = arg_2_8.mutators
	self._deus_run_controller = arg_2_8.deus_run_controller
	self._deus_spawning = DeusSpawning:new(self._profile_synchronizer, get_side_from_name, self._is_server, self._network_server, self._deus_run_controller)

	self:_register_player_spawner(self._deus_spawning)

	self._bot_players = {}

	self:_setup_bot_spawn_priority_lookup()

	self._available_profiles = table.clone(PROFILES_BY_AFFILIATION.heroes)

	local event = Managers.state.event

	event:register(self, "level_start_local_player_spawned", "event_local_player_spawned")
	event:register(self, "statistics_database_unregister_player", "event_statistics_database_unregister_player")

	self._local_player_spawned = false
end

GameModeDeus.on_round_end = function (self)
	-- function 3
	local system = Managers.state.entity:system("volume_system")
	local current_level = LevelHelper:current_level(self._world)
	local has_volume = Level.has_volume(current_level, str_2)

	if not system and not has_volume then
		system:unregister_volume(str_2)
	end
end

GameModeDeus.destroy = function (arg_4_0)
	-- function 4
	local event = Managers.state.event

	if not event then
		event:unregister("level_start_local_player_spawned", arg_4_0)
		event:unregister("statistics_database_unregister_player", arg_4_0)
	end
end

GameModeDeus.cleanup_game_mode_units = function (self)
	-- function 5
	local flag = false

	self:_clear_bots(flag)
end

GameModeDeus.register_rpcs = function (self, arg_6_1, arg_6_2)
	-- function 6
	GameModeDeus.super.register_rpcs(self, arg_6_1, arg_6_2)
	self._deus_spawning:register_rpcs(arg_6_1, arg_6_2)
end

GameModeDeus.unregister_rpcs = function (self)
	-- function 7
	self._deus_spawning:unregister_rpcs()
	GameModeDeus.super.unregister_rpcs(self)
end

GameModeDeus.event_local_player_spawned = function (self, arg_8_1)
	-- function 8
	self._local_player_spawned = true
	self._is_initial_spawn = arg_8_1
end

GameModeDeus.update = function (self, arg_9_1, arg_9_2)
	-- function 9
	self._deus_spawning:update(arg_9_1, arg_9_2)
end

GameModeDeus.server_update = function (self, arg_10_1, arg_10_2)
	-- function 10
	GameModeDeus.super.server_update(self, arg_10_1, arg_10_2)
	self:_handle_bots(arg_10_1, arg_10_2)
	self._deus_spawning:server_update(arg_10_1, arg_10_2)
	self:_update_morris_music_intensity()
end

GameModeDeus.evaluate_end_conditions = function (self, arg_11_1, arg_11_2, arg_11_3, arg_11_4)
	-- function 11
	if not script_data.disable_gamemode_end then
		return false
	end

	if not self._won then
		return true, "won"
	end

	local get_party_from_side_name = Managers.state.side:get_party_from_side_name("heroes")
	local flag = false
	local occupied_slots = get_party_from_side_name.occupied_slots

	for i = 1, #occupied_slots do
		flag = flag or not occupied_slots[i].is_bot
	end

	if not flag then
		return false
	end

	local flag_2 = true
	local side_is_dead = GameModeHelper.side_is_dead("heroes", flag_2)
	local side_is_disabled = GameModeHelper.side_is_disabled("heroes")

	side_is_disabled = not side_is_disabled and not GameModeHelper.side_delaying_loss("heroes")

	local evaluate_lose_conditions, var_11_7 = arg_11_4:evaluate_lose_conditions()
	local _level_failed

	if not self._lose_condition_disabled then
		if not (evaluate_lose_conditions or side_is_dead or side_is_disabled) then
			-- Nothing
		end

		::label_11_2::

		_level_failed = self._level_failed

		if not _level_failed then
			_level_failed = self:_is_time_up()
		end
	else
		_level_failed = false
	end

	if false then
		_level_failed = true
	end

	::label_11_3::

	if not self:is_about_to_end_game_early() then
		if not _level_failed then
			if arg_11_3 > self._lost_condition_timer then
				return true, "lost"
			else
				return false
			end
		else
			self:set_about_to_end_game_early(false)

			self._lost_condition_timer = nil
		end
	end

	local flag_3 = false

	if not _level_failed then
		self:set_about_to_end_game_early(true)

		if not evaluate_lose_conditions and not var_11_7 then
			self._lost_condition_timer = arg_11_3 + var_11_7
		elseif not side_is_dead then
			self._lost_condition_timer = arg_11_3 + GameModeSettings.adventure.lose_condition_time_dead
		else
			self._lost_condition_timer = arg_11_3 + GameModeSettings.adventure.lose_condition_time
		end

		return false
	elseif not self:update_end_level_areas() then
		flag_3 = true
	elseif not self._level_completed then
		if not Managers.deed:has_deed() and not Managers.deed:is_session_faulty() then
			return true, "lost"
		else
			flag_3 = true
		end
	end

	if not flag_3 then
		return true, "won"
	end

	return false
end

GameModeDeus.gm_event_end_conditions_met = function (self, arg_12_1, arg_12_2, arg_12_3)
	-- function 12
	local _deus_run_controller = self._deus_run_controller
	local player = Managers.player

	for k, v in pairs(player:players()) do
		local _statistics_db = self._statistics_db
		local network_id = v:network_id()
		local local_player_id = v:local_player_id()

		_deus_run_controller:save_persisted_score(_statistics_db, PlayerUtils.unique_player_id(network_id, local_player_id))
	end

	local get_grouped_topic_statistics = ScoreboardHelper.get_grouped_topic_statistics(self._statistics_db, self._profile_synchronizer, {})

	_deus_run_controller:save_scoreboard(get_grouped_topic_statistics)

	if _deus_run_controller:get_current_node().level_type ~= "ARENA" then
		local wwise_world = Managers.world:wwise_world(self._world)

		WwiseWorld.trigger_event(wwise_world, "Play_morris_run_level_complete")
	end
end

GameModeDeus.player_entered_game_session = function (self, arg_13_1, arg_13_2, arg_13_3)
	-- function 13
	GameModeDeus.super.player_entered_game_session(self, arg_13_1, arg_13_2, arg_13_3)
	self._adventure_profile_rules:handle_profile_delegation_for_joining_player(arg_13_1, arg_13_2)
	self._deus_spawning:add_delayed_client(arg_13_1, arg_13_2)
	self._deus_run_controller:restore_persisted_score(self._statistics_db, arg_13_1, arg_13_2)
end

GameModeDeus.player_left_game_session = function (self, arg_14_1, arg_14_2)
	-- function 14
	GameModeDeus.super.player_left_game_session(self, arg_14_1, arg_14_2)
	self._deus_spawning:remove_delayed_client(arg_14_1, arg_14_2)
end

GameModeDeus.event_statistics_database_unregister_player = function (self, arg_15_1)
	-- function 15
	if not self._is_server then
		self._deus_run_controller:save_persisted_score(self._statistics_db, arg_15_1)
	end
end

GameModeDeus.remove_bot = function (self, arg_16_1, arg_16_2, arg_16_3, arg_16_4)
	-- function 16
	arg_16_4 = arg_16_4 or false

	if #self._bot_players > 0 then
		local profile_by_peer = self._profile_synchronizer:profile_by_peer(arg_16_2, arg_16_3)
		local _remove_bot_by_profile, var_16_2 = self:_remove_bot_by_profile(profile_by_peer, arg_16_4)

		if not _remove_bot_by_profile then
			var_16_2 = self._bot_players[#self._bot_players]

			self:_remove_bot(var_16_2, arg_16_4)
		end

		return var_16_2
	end
end

GameModeDeus.get_end_screen_config = function (self, arg_17_1, arg_17_2, arg_17_3)
	-- function 17
	if Managers.mechanism:is_final_round() or not arg_17_2 then
		local _statistics_db = self._statistics_db
		local get_journey_name = self._deus_run_controller:get_journey_name()
		local get_own_peer_id = self._deus_run_controller:get_own_peer_id()
		local get_player_profile, var_17_4 = self._deus_run_controller:get_player_profile(get_own_peer_id, num)
		local stats_id = Managers.player:local_player():stats_id()
		local completed_journey_difficulty_index = LevelUnlockUtils.completed_journey_difficulty_index(_statistics_db, stats_id, get_journey_name)
		local flag

		flag = not arg_17_1 and "deus_victory" and "defeat"

		return flag, {
			journey_name = get_journey_name,
			profile_index = get_player_profile,
			previous_completed_difficulty_index = completed_journey_difficulty_index
		}
	else
		local tbl = {}
		local try_grant_end_of_level_deus_power_ups = self._deus_run_controller:try_grant_end_of_level_deus_power_ups()

		if not try_grant_end_of_level_deus_power_ups then
			for i = 1, #try_grant_end_of_level_deus_power_ups do
				local var_17_10 = try_grant_end_of_level_deus_power_ups[i]
				local tbl_2 = {
					type = "deus_power_up_end_of_level",
					sounds = {
						"hud_morris_weapon_chest_unlock",
						"morris_reliquarys_get_boon"
					},
					power_up = var_17_10
				}

				tbl[#tbl + 1] = tbl_2
			end
		end

		return "none", {}, {
			rewards = tbl
		}
	end
end

GameModeDeus.ended = function (self, arg_18_1)
	-- function 18
	if not self._network_server:are_all_peers_ingame() then
		self._network_server:disconnect_joining_peers()
	end
end

GameModeDeus.local_player_ready_to_start = function (self, arg_19_1)
	-- function 19
	local peer_id = arg_19_1.peer_id
	local local_player_id = arg_19_1:local_player_id()
	local get_player_profile, var_19_3 = self._deus_run_controller:get_player_profile(peer_id, num)

	if not (get_player_profile == 0 or var_19_3 ~= 0) then
		return false
	end

	local get_player_health_state = self._deus_run_controller:get_player_health_state(peer_id, local_player_id)

	if not (self._local_player_spawned or get_player_health_state == "dead" or get_player_health_state ~= "respawn") then
		return true
	end

	return false
end

GameModeDeus.local_player_game_starts = function (self, arg_20_1, arg_20_2)
	-- function 20
	local _deus_run_controller = self._deus_run_controller
	local _world = self._world
	local current_level = LevelHelper:current_level(_world)
	local get_current_node = _deus_run_controller:get_current_node()
	local theme = get_current_node.theme

	if not self._is_initial_spawn then
		LevelHelper:flow_event(_world, "local_player_spawned")
		LevelHelper:flow_event(_world, "level_start_local_player_spawned")
	end

	local has_volume = Level.has_volume(current_level, str_2)

	if not (not self._is_server and not has_volume and theme ~= DEUS_THEME_TYPES.BELAKOR) then
		Managers.state.entity:system("volume_system"):register_volume(str_2, "trigger_volume", {
			sub_type = "players_inside",
			on_triggered = function ()
				-- function 21
				if not self._enter_vo_has_triggered then
					return
				end

				local find_dialogue_unit = LevelHelper:find_dialogue_unit(self._world, str)

				if not (not find_dialogue_unit and ScriptUnit.has_extension(find_dialogue_unit, "dialogue_system")) then
					self._enter_vo_has_triggered = true

					fn(find_dialogue_unit, get_current_node.curse)
				else
					print("GameModeDeus:local_player_game_starts - No unit for curse intro vo")
				end
			end
		})
	end

	if not arg_20_1.player_unit then
		Managers.state.entity:system("camera_system"):external_state_change(arg_20_1, "observer", {})
	end

	if get_current_node.level_type == "ARENA" then
		Managers.state.entity:system("dialogue_system"):freeze_story_trigger()
	end

	local light_probe_tint = DeusThemeSettings[theme].light_probe_tint
	local var_20_7 = Vector3(light_probe_tint[1], light_probe_tint[2], light_probe_tint[3])
	local units = Level.units(current_level)
	local count = #units

	for i = 1, count do
		local var_20_10 = units[i]

		if not Unit.is_a(var_20_10, "core/stingray_renderer/helper_units/reflection_probe/reflection_probe") then
			local num_lights = Unit.num_lights(var_20_10)

			if not num_lights then
				for j = 1, num_lights do
					local light = Unit.light(var_20_10, j - 1)

					Light.set_color(light, var_20_7)
				end
			end
		end
	end

	Managers.state.event:trigger("local_player_game_starts")
end

GameModeDeus.disable_player_spawning = function (self)
	-- function 22
	self._deus_spawning:set_spawning_disabled(true)
end

GameModeDeus.enable_player_spawning = function (self, arg_23_1, arg_23_2)
	-- function 23
	self._deus_spawning:set_spawning_disabled(false)
	self._deus_spawning:force_update_spawn_positions(arg_23_1, arg_23_2)
end

GameModeDeus.teleport_despawned_players = function (self, arg_24_1)
	-- function 24
	self._deus_spawning:teleport_despawned_players(arg_24_1)
end

GameModeDeus.flow_callback_add_spawn_point = function (self, arg_25_1)
	-- function 25
	self._deus_spawning:add_spawn_point(arg_25_1)
end

GameModeDeus.set_override_respawn_group = function (self, arg_26_1, arg_26_2)
	-- function 26
	self._deus_spawning:set_override_respawn_group(arg_26_1, arg_26_2)
end

GameModeDeus.set_respawn_group_enabled = function (self, arg_27_1, arg_27_2)
	-- function 27
	self._deus_spawning:set_respawn_group_enabled(arg_27_1, arg_27_2)
end

GameModeDeus.set_respawn_gate_enabled = function (self, arg_28_1, arg_28_2)
	-- function 28
	self._deus_spawning:set_respawn_gate_enabled(arg_28_1, arg_28_2)
end

GameModeDeus.respawn_unit_spawned = function (self, arg_29_1)
	-- function 29
	self._deus_spawning:respawn_unit_spawned(arg_29_1)
end

GameModeDeus.get_respawn_handler = function (self)
	-- function 30
	return self._deus_spawning:get_respawn_handler()
end

GameModeDeus.respawn_gate_unit_spawned = function (self, arg_31_1)
	-- function 31
	self._deus_spawning:respawn_gate_unit_spawned(arg_31_1)
end

GameModeDeus.set_respawning_enabled = function (self, arg_32_1)
	-- function 32
	self._deus_spawning:set_respawning_enabled(arg_32_1)
end

GameModeDeus.remove_respawn_units_due_to_crossroads = function (self, arg_33_1, arg_33_2)
	-- function 33
	self._deus_spawning:remove_respawn_units_due_to_crossroads(arg_33_1, arg_33_2)
end

GameModeDeus.recalc_respawner_dist_due_to_crossroads = function (self)
	-- function 34
	self._deus_spawning:recalc_respawner_dist_due_to_crossroads()
end

GameModeDeus.profile_changed = function (self, arg_35_1, arg_35_2, arg_35_3, arg_35_4)
	-- function 35
	self._deus_spawning:profile_changed(arg_35_1, arg_35_2, arg_35_3, arg_35_4)
end

GameModeDeus.force_respawn = function (self, arg_36_1, arg_36_2)
	-- function 36
	if Managers.party:get_player_status(arg_36_1, arg_36_2).party_id == 0 then
		local num = 1

		Managers.party:assign_peer_to_party(arg_36_1, arg_36_2, num)
	end

	self._deus_spawning:force_respawn(arg_36_1, arg_36_2)
end

GameModeDeus.force_respawn_dead_players = function (self)
	-- function 37
	self._deus_spawning:force_respawn_dead_players()
end

GameModeDeus._get_first_available_bot_profile = function (self)
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
	local var_38_7 = SPProfiles[var_38_6]
	local display_name = var_38_7.display_name
	local get_interface = Managers.backend:get_interface("hero_attributes")
	local get = get_interface:get(display_name, "career")
	local get_2 = get_interface:get(display_name, "bot_career")

	get_2 = get_2 or get or 1

	local var_38_12 = var_38_7.careers[get_2]
	local get_3 = get_interface:get(display_name, "experience")

	get_3 = get_3 or 0

	local get_level = ExperienceSettings.get_level(get_3)

	if not (not var_38_12 and var_38_12:is_unlocked_function(display_name, get_level)) then
		local num = 1

		get_2 = 1

		get_interface:set(display_name, "career", num)
		get_interface:set(display_name, "bot_career", get_2)
	end

	return var_38_6, get_2
end

GameModeDeus._setup_bot_spawn_priority_lookup = function (self)
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

GameModeDeus._handle_bots = function (self, arg_41_1, arg_41_2)
	-- function 41
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
	local var_41_3 = num_slots

	if not script_data.cap_num_bots then
		var_41_3 = math.min(var_41_3, script_data.cap_num_bots)
	end

	local _bot_players = self._bot_players
	local num = var_41_3 - #_bot_players

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

GameModeDeus._add_bot = function (self)
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

	local network_id = _add_bot_to_party:network_id()
	local local_player_id = _add_bot_to_party:local_player_id()

	self._deus_run_controller:restore_persisted_score(self._statistics_db, network_id, local_player_id)
end

GameModeDeus._remove_bot = function (self, arg_43_1, arg_43_2)
	-- function 43
	local network_id = arg_43_1:network_id()
	local local_player_id = arg_43_1:local_player_id()

	self._deus_run_controller:save_persisted_score(self._statistics_db, PlayerUtils.unique_player_id(network_id, local_player_id))

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

GameModeDeus._remove_bot_by_profile = function (self, arg_44_1, arg_44_2)
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

	local var_44_3
	local flag = false

	if not var_44_1 then
		var_44_3 = _bot_players[var_44_1]

		self:_remove_bot(var_44_3, arg_44_2 or false)

		flag = true
	end

	return flag, var_44_3
end

GameModeDeus._clear_bots = function (self, arg_45_1)
	-- function 45
	local _bot_players = self._bot_players

	for i = #_bot_players, 1, -1 do
		self:_remove_bot(_bot_players[i], arg_45_1)
	end
end

GameModeDeus.get_active_respawn_units = function (self)
	-- function 46
	return self._deus_spawning:get_active_respawn_units()
end

GameModeDeus.get_available_and_active_respawn_units = function (self)
	-- function 47
	return self._deus_spawning:get_available_and_active_respawn_units()
end

GameModeDeus.get_player_wounds = function (arg_48_0, arg_48_1)
	-- function 48
	if not Managers.state.game_mode:has_activated_mutator("instant_death") then
		return 1
	end

	return Managers.state.difficulty:get_difficulty_settings().wounds
end

GameModeDeus.mutators = function (self)
	-- function 49
	local shallow_copy = table.shallow_copy(self._mutators)

	self:append_live_event_mutators(shallow_copy)

	local get_event_mutators = self._deus_run_controller:get_event_mutators()

	if not get_event_mutators then
		local set = table.set(shallow_copy)

		for i = 1, #get_event_mutators do
			local var_49_3 = get_event_mutators[i]

			if not set[var_49_3] then
				shallow_copy[#shallow_copy + 1] = var_49_3
			end
		end
	end

	return shallow_copy
end

GameModeDeus.on_picked_up_soft_currency = function (self, arg_50_1, arg_50_2, arg_50_3, arg_50_4)
	-- function 50
	local _deus_run_controller = self._deus_run_controller
	local var_50_1
	local var_50_2

	if not arg_50_3 then
		var_50_1, var_50_2 = arg_50_3, arg_50_4 or DeusSoftCurrencySettings.types.GROUND
	else
		var_50_1, var_50_2 = self:_get_coins_amount_and_type(arg_50_1)
	end

	local unit_owner = Managers.player:unit_owner(arg_50_2)

	if unit_owner.bot_player or not unit_owner.remote then
		Managers.state.entity:system("audio_system"):play_2d_audio_event("hud_morris_currency_added")
	else
		local wwise_world = Managers.world:wwise_world(self._world)

		WwiseWorld.trigger_event(wwise_world, "hud_morris_pickup_chest")
	end

	local local_player = Managers.player:local_player()
	local flag = not local_player and local_player.player_unit
	local flag_2 = not flag and ScriptUnit.has_extension(flag, "buff_system")

	if not flag_2 then
		var_50_1 = flag_2:apply_buffs_to_value(var_50_1, "deus_coins_greed")
		var_50_1 = math.floor(var_50_1)
	end

	_deus_run_controller:on_soft_currency_picked_up(var_50_1, var_50_2)

	if not UISettings.deus.show_coin_pickup_in_chat then
		local var_50_8

		if not unit_owner:is_player_controlled() then
			var_50_8 = _deus_run_controller:get_player_name(unit_owner.peer_id)
		else
			var_50_8 = unit_owner:name()
		end

		local flag_3 = true
		local var_50_10

		if not (unit_owner.bot_player or unit_owner.remote) then
			var_50_10 = string.format(Localize("system_chat_local_player_picked_up_deus_currency"), var_50_1)
		else
			var_50_10 = string.format(Localize("system_chat_other_player_picked_up_deus_currency"), var_50_8, var_50_1)
		end

		Managers.chat:add_local_system_message(1, var_50_10, flag_3)
	end
end

GameModeDeus.get_boss_loot_pickup = function (arg_51_0)
	-- function 51
	return "deus_soft_currency"
end

GameModeDeus._get_coins_amount_and_type = function (self, arg_52_1)
	-- function 52
	local has_extension = ScriptUnit.has_extension(arg_52_1, "pickup_system")

	if not has_extension then
		return 0
	end

	local _deus_run_controller = self._deus_run_controller
	local pickups = _deus_run_controller:get_current_node().system_seeds.pickups

	pickups = pickups or 0

	local fnv32_hash = HashUtils.fnv32_hash(Managers.state.unit_storage:go_id(arg_52_1) .. "_" .. pickups)
	local next_random, var_52_5 = Math.next_random(fnv32_hash)
	local count = #_deus_run_controller:get_peers()
	local get_dropped_by_breed = has_extension:get_dropped_by_breed()
	local var_52_8 = DeusSoftCurrencySettings.loot_amount[get_dropped_by_breed]
	local var_52_9 = var_52_8[count]

	var_52_9 = var_52_9 or var_52_8[#var_52_8]

	local min = var_52_9.min
	local max = var_52_9.max
	local lerp = math.lerp(min, max, var_52_5)
	local var_52_13

	if not (not get_dropped_by_breed and get_dropped_by_breed ~= "n/a") then
		var_52_13 = DeusSoftCurrencySettings.types.GROUND
	else
		var_52_13 = DeusSoftCurrencySettings.types.MONSTER
	end

	return math.round(lerp), var_52_13
end

GameModeDeus.players_left_safe_zone = function (self)
	-- function 53
	local game_mechanism = Managers.mechanism:game_mechanism()

	if (not game_mechanism and game_mechanism:get_current_node_theme()) == DEUS_THEME_TYPES.BELAKOR then
		return
	end

	local find_dialogue_unit = LevelHelper:find_dialogue_unit(self._world, str)

	if not (not find_dialogue_unit and ScriptUnit.has_extension(find_dialogue_unit, "dialogue_system")) then
		local curse = self._deus_run_controller:get_current_node().curse

		fn(find_dialogue_unit, curse)
	else
		print("GameModeDeus:players_left_safe_zone - no unit for curse intro vo")
	end
end

GameModeDeus._update_morris_music_intensity = function (self)
	-- function 54
	local total_intensity = Managers.state.conflict.pacing.total_intensity
	local system = Managers.state.entity:system("audio_system")
	local morris_music_intensity = NetworkLookup.global_parameter_names.morris_music_intensity
	local round = math.round(math.clamp(total_intensity, 0, 100))

	if not (not self._sent_intensity and self._sent_intensity ~= round) then
		return
	end

	system:set_global_parameter_with_lerp("morris_music_intensity", round)

	if not self._network_transmit then
		self._network_transmit:send_rpc_clients("rpc_client_audio_set_global_parameter_with_lerp", morris_music_intensity, round / 100)
	end

	self._sent_intensity = round
end
