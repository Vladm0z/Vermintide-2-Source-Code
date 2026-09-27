-- chunkname: @scripts/managers/game_mode/mechanisms/deus_mechanism.lua

require("scripts/managers/game_mode/mechanisms/deus_run_controller")
require("scripts/settings/dlcs/morris/deus_default_graph_settings")
require("scripts/settings/dlcs/morris/deus_node_settings")
require("scripts/settings/dlcs/morris/deus_theme_settings")

DeusMechanism = class(DeusMechanism)
DeusMechanism.name = "Deus"

local tbl = {
	"rpc_deus_setup_run"
}
local tbl_2 = {}
local tbl_3 = {}

for i, v in ipairs(SPProfiles) do
	if v.affiliation == "heroes" then
		local careers = v.careers

		for i_2, v_2 in ipairs(careers) do
			tbl_2[#tbl_2 + 1] = v_2.name
		end
	end
end

local num = 1
local str = "morris_hub"
local str_2 = "inn_deus"
local str_3 = "inn_deus"
local str_4 = "dlc_morris_map"
local str_5 = "map_deus"
local str_6 = "map_deus"
local str_7 = "deus"
local str_8 = "ingame_deus"

local function fn(arg_1_0)
	-- function 1
	return DeusNodeSettings[arg_1_0].mechanism_state
end

local function fn_2(arg_2_0)
	-- function 2
	return DeusNodeSettings[arg_2_0].game_mode_key
end

local function fn_3(arg_3_0)
	-- function 3
	if arg_3_0 == str_4 then
		return "map"
	end

	if arg_3_0 == str then
		return "inn"
	end

	return "ingame"
end

local function fn_4(self)
	-- function 4
	local mission_id = self.mission_id
	local difficulty = self.difficulty
	local quick_game = self.quick_game
	local private_game = self.private_game
	local always_host = self.always_host
	local strict_matchmaking = self.strict_matchmaking
	local matchmaking_type = self.matchmaking_type
	local twitch_enabled = self.twitch_enabled

	print("............................................................................................................")
	print("............................................................................................................")

	local printf = printf
	local str = "GAME START SETTINGS -> Level: %s | Difficulty: %s | Private: %s | Always Host: %s | Strict Matchmaking: %s | Quick Game: %s | Matchmaking Type: %s | Twitch: %s"
	local flag = not mission_id and mission_id and "Not specified"
	local var_4_11 = difficulty
	local flag_2

	flag_2 = not private_game and "yes" and "no"

	local flag_3

	flag_3 = not always_host and "yes" and "no"

	local flag_4

	flag_4 = not strict_matchmaking and "yes" and "no"

	local flag_5

	flag_5 = not quick_game and "yes" and "no"

	local flag_6 = matchmaking_type or "Not specified"
	local flag_7

	flag_7 = not twitch_enabled and "Yes" and "No"

	printf(str, flag, var_4_11, flag_2, flag_3, flag_4, flag_5, flag_6, flag_7)
	print("............................................................................................................")
	print("............................................................................................................")
end

local tbl_4 = {
	deus_quickplay = function (arg_5_0, arg_5_1)
		-- function 5
		local tbl = {
			mechanism = "deus",
			difficulty = arg_5_1.difficulty,
			quick_game = arg_5_1.quick_game,
			private_game = arg_5_1.private_game,
			always_host = arg_5_1.always_host,
			strict_matchmaking = arg_5_1.strict_matchmaking,
			matchmaking_type = arg_5_1.matchmaking_type,
			vote_type = arg_5_1.request_type
		}

		Managers.state.voting:request_vote("deus_settings_vote", tbl, Network.peer_id())
	end,
	deus_custom = function (arg_6_0, arg_6_1)
		-- function 6
		local tbl = {
			mechanism = "deus",
			mission_id = arg_6_1.mission_id,
			difficulty = arg_6_1.difficulty,
			quick_game = arg_6_1.quick_game,
			private_game = arg_6_1.private_game,
			always_host = arg_6_1.always_host,
			strict_matchmaking = arg_6_1.strict_matchmaking,
			dominant_god = arg_6_1.dominant_god,
			matchmaking_type = arg_6_1.matchmaking_type,
			vote_type = arg_6_1.request_type
		}

		Managers.state.voting:request_vote("deus_settings_vote", tbl, Network.peer_id())
	end,
	deus_twitch = function (arg_7_0, arg_7_1)
		-- function 7
		local tbl = {
			mechanism = "deus",
			mission_id = arg_7_1.mission_id,
			difficulty = arg_7_1.difficulty,
			quick_game = arg_7_1.quick_game,
			private_game = arg_7_1.private_game,
			always_host = arg_7_1.always_host,
			strict_matchmaking = arg_7_1.strict_matchmaking,
			dominant_god = arg_7_1.dominant_god,
			matchmaking_type = arg_7_1.matchmaking_type,
			vote_type = arg_7_1.request_type
		}

		Managers.state.voting:request_vote("deus_settings_vote", tbl, Network.peer_id())
	end,
	deus_weekly = function (arg_8_0, arg_8_1)
		-- function 8
		local tbl = {
			mechanism = "deus",
			mission_id = arg_8_1.mission_id,
			event_data = arg_8_1.event_data,
			difficulty = arg_8_1.difficulty,
			quick_game = arg_8_1.quick_game,
			private_game = arg_8_1.private_game,
			always_host = arg_8_1.always_host,
			strict_matchmaking = arg_8_1.strict_matchmaking,
			dominant_god = arg_8_1.dominant_god,
			matchmaking_type = arg_8_1.matchmaking_type,
			vote_type = arg_8_1.request_type
		}

		Managers.state.voting:request_vote("deus_settings_vote", tbl, Network.peer_id())
	end
}

local function fn_5(arg_9_0)
	-- function 9
	return math.round(math.lerp(-DifficultyTweak.range, DifficultyTweak.range, arg_9_0))
end

local function fn_6(self, arg_10_1)
	-- function 10
	local var_10_0
	local var_10_1
	local var_10_2
	local str_2 = "deus"
	local var_10_4
	local var_10_5
	local var_10_6
	local var_10_7
	local var_10_8
	local tbl = {}

	if not self and not self:get_run_ended() then
		var_10_0 = str
	elseif not arg_10_1 then
		var_10_0 = str_4
	else
		local get_current_node = self:get_current_node()
		local node_type = get_current_node.node_type

		var_10_0 = get_current_node.level
		var_10_2 = get_current_node.level_seed
		var_10_1 = LevelHelper:get_random_variation_id(var_10_0)
		var_10_4 = fn_2(node_type)
		var_10_7 = self:get_run_difficulty()

		local run_progress = get_current_node.run_progress

		var_10_8 = fn_5(run_progress)
		var_10_5 = get_current_node.conflict_settings
		var_10_6 = nil

		local curse = get_current_node.curse

		if not curse then
			local packages = MutatorTemplates[curse].packages

			if not packages then
				table.append(tbl, packages)
			end
		end
	end

	return var_10_0, var_10_1, var_10_2, str_2, var_10_4, var_10_5, var_10_6, var_10_7, var_10_8, tbl
end

DeusMechanism.init = function (self, arg_11_1)
	-- function 11
	self._is_server = true
	self._hero_profiles = table.clone(PROFILES_BY_AFFILIATION.heroes)
	self._state = str_3
end

DeusMechanism._reset = function (self, arg_12_1)
	-- function 12
	if not self._deus_run_controller then
		self._deus_run_controller:destroy()

		self._deus_run_controller = nil
	end

	self._run_id = nil
	self._run_seed = nil
	self._final_round = false

	if not self._is_server then
		self:_update_current_state(true)
	end
end

DeusMechanism.network_context_created = function (self, arg_13_1, arg_13_2, arg_13_3, arg_13_4, arg_13_5)
	-- function 13
	self._is_server = arg_13_4

	if not self._deus_run_controller then
		Managers.mechanism:manual_end_venture()

		local get_current_level_key = Managers.level_transition_handler:get_current_level_key()
		local var_13_1 = LevelSettings[get_current_level_key]

		if not (not arg_13_4 and self._deus_run_controller:get_run_ended() or var_13_1.hub_level) then
			self._deus_run_controller:network_context_created(arg_13_1, arg_13_2, arg_13_3, arg_13_4, arg_13_5)
		else
			self._deus_run_controller:destroy()

			self._deus_run_controller = nil
		end
	end

	if not arg_13_4 then
		self:_update_current_state()
	end
end

DeusMechanism.network_context_destroyed = function (arg_14_0)
	-- function 14
	return
end

DeusMechanism.handle_ingame_enter = function (self, arg_15_1)
	-- function 15
	if not self._deus_run_controller then
		self._deus_run_controller:full_sync()
		self:_update_own_avatar_info()
		self._deus_run_controller:handle_level_start()

		if arg_15_1 ~= str_7 or not self._deus_run_controller:is_server() then
			self:_send_level_started_tracking_data()
		end
	end

	if not (not Development.parameter("deus-auto-host") and arg_15_1 ~= str_2) then
		Managers.state.game_mode:complete_level()
	end
end

DeusMechanism.handle_ingame_exit = function (self, arg_16_1)
	-- function 16
	if not (arg_16_1 == "join_lobby_failed" or arg_16_1 == "left_game" or arg_16_1 == "lobby_state_failed" or arg_16_1 == "kicked_by_server" or arg_16_1 == "afk_kick" or arg_16_1 == "quit_game" or arg_16_1 == "return_to_pc_menu" or arg_16_1 ~= "backend_disconnected") then
		self:_reset()
	end
end

DeusMechanism.create_host_migration_info = function (self, arg_17_1, arg_17_2)
	-- function 17
	local network_handler = Managers.mechanism:network_handler()
	local _deus_run_controller = self._deus_run_controller
	local host_to_migrate_to = network_handler.host_to_migrate_to

	if not _deus_run_controller and not host_to_migrate_to then
		local peer_id = host_to_migrate_to.peer_id

		if (_deus_run_controller:get_player_profile(peer_id, num) == 0 or _deus_run_controller:get_player_health_state(peer_id, num)) ~= "alive" then
			_deus_run_controller = nil
		end
	end

	if not _deus_run_controller and not _deus_run_controller:get_run_ended() then
		_deus_run_controller = nil
	end

	if not (not _deus_run_controller and host_to_migrate_to) then
		_deus_run_controller = nil
	end

	local flag = self._state == str_6
	local get_game_mode_event_data = network_handler:get_network_state():get_game_mode_event_data()
	local tbl = {
		host_to_migrate_to = host_to_migrate_to,
		game_mode_event_data = table.is_empty(get_game_mode_event_data) or not get_game_mode_event_data or nil
	}
	local var_17_7, var_17_8, var_17_9, var_17_10, var_17_11, var_17_12, var_17_13, var_17_14, var_17_15, var_17_16 = fn_6(_deus_run_controller, flag)

	tbl.level_data = {
		level_key = var_17_7,
		environment_variation_id = var_17_8,
		level_seed = var_17_9,
		mechanism = var_17_10,
		game_mode_key = var_17_11,
		conflict_settings = var_17_12,
		locked_director_functions = var_17_13,
		difficulty = var_17_14,
		difficulty_tweak = var_17_15,
		extra_packages = var_17_16
	}

	local lobby_data = network_handler.lobby_client:lobby_data("is_private")
	local var_17_18

	if not IS_PS4 then
		var_17_18 = "n/a"
	elseif not _deus_run_controller then
		var_17_18 = NetworkLookup.matchmaking_types["n/a"]
	else
		var_17_18 = network_handler.lobby_client:lobby_data("matchmaking_type") or NetworkLookup.matchmaking_types["n/a"]
	end

	tbl.lobby_data = {
		is_private = lobby_data,
		difficulty = var_17_14,
		difficulty_tweak = var_17_15,
		selected_mission_id = var_17_7,
		mission_id = var_17_7,
		matchmaking_type = var_17_18,
		mechanism = var_17_10
	}

	return tbl
end

DeusMechanism.register_rpcs = function (self, arg_18_1)
	-- function 18
	self:unregister_rpcs()

	self._network_event_delegate = arg_18_1

	arg_18_1:register(self, unpack(tbl))

	if not self._deus_run_controller then
		self._deus_run_controller:register_rpcs(self._network_event_delegate)
	end
end

DeusMechanism.unregister_rpcs = function (self)
	-- function 19
	if not self._network_event_delegate then
		self._network_event_delegate:unregister(self)

		self._network_event_delegate = nil
	end

	if not self._deus_run_controller then
		self._deus_run_controller:unregister_rpcs()
	end
end

DeusMechanism.can_resync_loadout = function (self)
	-- function 20
	if Managers.level_transition_handler:get_current_game_mode() == "deus" then
		return self._deus_run_controller ~= nil
	else
		return true
	end
end

DeusMechanism.update_loadout = function (self)
	-- function 21
	local _deus_run_controller = self._deus_run_controller

	if not (not _deus_run_controller and _deus_run_controller:get_run_ended()) then
		local get_own_peer_id = _deus_run_controller:get_own_peer_id()
		local get_player_profile, var_21_3 = _deus_run_controller:get_player_profile(get_own_peer_id, num)

		if get_player_profile ~= 0 then
			local name = SPProfiles[get_player_profile].careers[var_21_3].name

			self:_update_career_loadout(num, name)
		end
	end
end

DeusMechanism._update_career_loadout = function (self, arg_22_1, arg_22_2, arg_22_3)
	-- function 22
	local _deus_run_controller = self._deus_run_controller

	if not _deus_run_controller and not _deus_run_controller:get_run_ended() then
		return
	end

	local get_own_peer_id = _deus_run_controller:get_own_peer_id()
	local get_interface = Managers.backend:get_interface("deus")
	local var_22_3 = CareerSettings[arg_22_2]
	local profile_name = var_22_3.profile_name
	local var_22_5 = FindProfileIndex(var_22_3.profile_name)
	local careers = SPProfiles[var_22_5].careers
	local index_of = table.index_of(careers, var_22_3)
	local talent_tree_index = var_22_3.talent_tree_index
	local get_loadout, var_22_10 = _deus_run_controller:get_loadout(get_own_peer_id, arg_22_1, var_22_5, index_of)

	if not get_loadout then
		get_interface:grant_deus_weapon(get_loadout)
		get_interface:set_loadout_item(get_loadout.backend_id, arg_22_2, "slot_melee")
	end

	if not var_22_10 then
		get_interface:grant_deus_weapon(var_22_10)
		get_interface:set_loadout_item(var_22_10.backend_id, arg_22_2, "slot_ranged")
	end

	local get_power_ups = _deus_run_controller:get_power_ups(get_own_peer_id, arg_22_1, var_22_5, index_of, arg_22_3)
	local tbl = {}

	for i, v in ipairs(get_power_ups) do
		local var_22_13 = DeusPowerUps[v.rarity][v.name]

		if not var_22_13.talent then
			local talent_index = var_22_13.talent_index
			local talent_tier = var_22_13.talent_tier
			local var_22_16 = TalentTrees[profile_name][talent_tree_index][talent_tier][talent_index]
			local talent_id = TalentIDLookup[var_22_16].talent_id

			tbl[#tbl + 1] = talent_id
		end
	end

	get_interface:set_deus_talent_ids(arg_22_2, tbl, arg_22_3)
	get_interface:refresh_deus_weapons_in_items_backend()
end

DeusMechanism.choose_next_state = function (self, arg_23_1)
	-- function 23
	self._next_state = arg_23_1
end

DeusMechanism.reset_choose_next_state = function (self)
	-- function 24
	self._next_state = nil
end

DeusMechanism.progress_state = function (self)
	-- function 25
	self._prior_state = self._state

	if not self._next_state then
		self._state = self._next_state
		self._next_state = nil
	else
		self._state = str_3
	end

	return self._state
end

DeusMechanism.get_prior_state = function (self)
	-- function 26
	local _prior_state = self._prior_state

	if not (_prior_state == str_6 or _prior_state ~= str_8) then
		return "deus"
	end

	return _prior_state
end

DeusMechanism.set_current_state = function (self, arg_27_1)
	-- function 27
	self._prior_state = self._state
	self._state = arg_27_1
end

DeusMechanism.get_hub_level_key = function (arg_28_0)
	-- function 28
	return str
end

DeusMechanism.get_end_of_level_rewards_arguments = function (self, arg_29_1, arg_29_2, arg_29_3, arg_29_4, arg_29_5, arg_29_6)
	-- function 29
	local get_end_of_level_rewards_arguments = self._deus_run_controller:get_end_of_level_rewards_arguments(arg_29_1, arg_29_2)
	local flag = false
	local current_weave = LevelUnlockUtils.current_weave(arg_29_3, arg_29_4, flag)
	local var_29_3 = WeaveSettings.templates[current_weave]
	local templates_ordered = WeaveSettings.templates_ordered

	get_end_of_level_rewards_arguments.current_weave_index = table.find(templates_ordered, var_29_3)
	get_end_of_level_rewards_arguments.kill_count = arg_29_3:get_stat(arg_29_4, "kills_total")

	return get_end_of_level_rewards_arguments
end

DeusMechanism.get_end_of_level_extra_mission_results = function (self)
	-- function 30
	return self._deus_run_controller:get_mission_results()
end

DeusMechanism.get_players_session_score = function (self, arg_31_1, arg_31_2, arg_31_3)
	-- function 31
	local _deus_run_controller = self._deus_run_controller

	_deus_run_controller = not _deus_run_controller and self._deus_run_controller:get_scoreboard()

	return _deus_run_controller
end

DeusMechanism.on_final_round_won = function (self, arg_32_1, arg_32_2)
	-- function 32
	local local_player = Managers.player:local_player()
	local get_journey_name = self._deus_run_controller:get_journey_name()
	local get_run_difficulty = self._deus_run_controller:get_run_difficulty()
	local get_dominant_god = self._deus_run_controller:get_dominant_god()

	StatisticsUtil.register_journey_complete(arg_32_1, local_player, get_journey_name, get_dominant_god, get_run_difficulty)
end

DeusMechanism.request_vote = function (arg_33_0, arg_33_1)
	-- function 33
	fn_4(arg_33_1)

	local tbl = {
		mission_id = arg_33_1.mission_id,
		event_data = arg_33_1.event_data,
		difficulty = arg_33_1.difficulty,
		quick_game = arg_33_1.quick_game,
		private_game = arg_33_1.private_game,
		always_host = arg_33_1.always_host,
		strict_matchmaking = arg_33_1.strict_matchmaking,
		dominant_god = arg_33_1.dominant_god,
		matchmaking_type = arg_33_1.matchmaking_type,
		mechanism = arg_33_1.mechanism,
		vote_type = arg_33_1.request_type
	}

	Managers.state.voting:request_vote("deus_settings_vote", tbl, Network.peer_id())
end

DeusMechanism.get_deus_run_controller = function (self)
	-- function 34
	return self._deus_run_controller
end

DeusMechanism.is_final_round = function (self)
	-- function 35
	return self._final_round
end

DeusMechanism.is_venture_over = function (self)
	-- function 36
	local _game_round_ended_reason = self._game_round_ended_reason

	return not (_game_round_ended_reason == "won" or _game_round_ended_reason == "lost") and _game_round_ended_reason == "lost" or self._final_round
end

DeusMechanism.game_round_ended = function (self, arg_37_1, arg_37_2, arg_37_3, arg_37_4)
	-- function 37
	fassert(arg_37_3 == "reload" or arg_37_3 == "won" or arg_37_3 == "lost" or arg_37_3 == "start_game", "unsupported reason for game end")

	self._game_round_ended_reason = arg_37_3

	local var_37_0

	if arg_37_3 == "reload" then
		Managers.level_transition_handler:reload_level()
		Managers.level_transition_handler:promote_next_level_data()

		self._next_state = self._state
	elseif arg_37_3 == "start_game" then
		local var_37_1
		local var_37_2
		local var_37_3
		local var_37_4 = tbl_3
		local var_37_5 = tbl_3

		if not self._vote_data then
			var_37_1 = self._vote_data.difficulty
			var_37_2 = self._vote_data.mission_id
			var_37_3 = self._vote_data.dominant_god

			local event_data = self._vote_data.event_data

			event_data = event_data or tbl_3
			var_37_4 = event_data.mutators or tbl_3
			var_37_5 = event_data.boons or tbl_3
		else
			var_37_1 = "normal"
			var_37_2 = AvailableJourneyOrder[1]
			var_37_3 = DeusJourneyCycleGods[1]
		end

		local sub = string.sub(tostring(math.random_seed()), 0, 8)
		local var_37_8

		if not script_data.deus_seed then
			var_37_8 = script_data.deus_seed
		elseif not DEUS_MAP_SEED_WHITELIST.use_full_gen_whitelist then
			local var_37_9 = DEUS_MAP_SEED_WHITELIST.full_gen_whitelist[var_37_2]

			var_37_9 = var_37_9 or DEUS_MAP_SEED_WHITELIST.full_gen_whitelist.default

			local next_random, var_37_11 = Math.next_random(math.random_seed(), 1, #var_37_9)

			var_37_8 = var_37_9[var_37_11]
		else
			var_37_8 = tostring(math.random_seed())
		end

		var_37_2 = script_data.deus_journey or var_37_2
		var_37_3 = script_data.deus_dominant_god or var_37_3

		local flag = false
		local get_interface = Managers.backend:get_interface("deus")

		if not get_interface then
			get_interface:get_belakor_cycle()

			flag = get_interface:deus_journey_with_belakor(var_37_2)
		end

		self:_setup_run(sub, var_37_8, true, Network.peer_id(), var_37_1, var_37_2, var_37_3, flag, var_37_4, var_37_5)

		local var_37_14 = NetworkLookup.difficulties[var_37_1]
		local var_37_15 = NetworkLookup.deus_journeys[var_37_2]
		local var_37_16 = NetworkLookup.deus_themes[var_37_3]
		local tbl = {}

		for i = 1, #var_37_4 do
			local var_37_18 = var_37_4[i]
			local var_37_19 = NetworkLookup.mutator_templates[var_37_18]

			tbl[#tbl + 1] = var_37_19
		end

		local tbl_2 = {}

		for j = 1, #var_37_5 do
			local var_37_21 = var_37_5[j]
			local var_37_22 = DeusPowerUpsLookup[var_37_21]

			tbl_2[#tbl_2 + 1] = var_37_22.lookup_id
		end

		Managers.mechanism:send_rpc_clients("rpc_deus_setup_run", sub, var_37_8, var_37_14, var_37_15, var_37_16, flag, tbl, tbl_2)

		var_37_0 = self:_transition_next_node("start")
	else
		local _state = self._state

		if not (_state == str_8 or _state ~= str_6) then
			local flag_2 = arg_37_3 == "won"

			if _state == str_8 then
				self:_send_level_ended_tracking_data(flag_2)
			end

			if arg_37_3 == "lost" then
				self:_send_run_tracking_data(flag_2)
				self._deus_run_controller:handle_run_ended()

				var_37_0 = self:_transition_to_inn()
			elseif not flag_2 then
				if _state == str_8 then
					self._deus_run_controller:handle_level_won()
				end

				if #self._deus_run_controller:get_current_node().next > 0 then
					if _state == str_6 then
						local var_37_25 = arg_37_4

						if var_37_25 == nil then
							var_37_25 = self._deus_run_controller:get_current_node().next[1]
						end

						var_37_0 = self:_transition_next_node(var_37_25)
					else
						var_37_0 = self:_transition_map()
					end
				else
					self:_send_run_tracking_data(flag_2)
					self._deus_run_controller:handle_run_ended()

					var_37_0 = self:_transition_to_inn()
				end
			end
		end
	end

	if not var_37_0 then
		self._next_state = var_37_0
	end
end

DeusMechanism._transition_next_node = function (self, arg_38_1)
	-- function 38
	local _deus_run_controller = self._deus_run_controller
	local level_transition_handler = Managers.level_transition_handler

	_deus_run_controller:set_current_node_key(arg_38_1)

	local node_type = _deus_run_controller:get_current_node().node_type
	local flag = false
	local var_38_4, var_38_5, var_38_6, var_38_7, var_38_8, var_38_9, var_38_10, var_38_11, var_38_12, var_38_13 = fn_6(_deus_run_controller, flag)

	level_transition_handler:set_next_level(var_38_4, var_38_5, var_38_6, var_38_7, var_38_8, var_38_9, var_38_10, var_38_11, var_38_12, var_38_13)
	level_transition_handler:promote_next_level_data()

	return (fn(node_type))
end

DeusMechanism._transition_map = function (self)
	-- function 39
	local _deus_run_controller = self._deus_run_controller
	local level_transition_handler = Managers.level_transition_handler
	local flag = true
	local var_39_3, var_39_4, var_39_5, var_39_6, var_39_7, var_39_8, var_39_9, var_39_10, var_39_11, var_39_12 = fn_6(_deus_run_controller, flag)

	level_transition_handler:set_next_level(var_39_3, var_39_4, var_39_5, var_39_6, var_39_7, var_39_8, var_39_9, var_39_10, var_39_11, var_39_12)

	return str_6
end

DeusMechanism._transition_to_inn = function (self)
	-- function 40
	local level_transition_handler = Managers.level_transition_handler
	local flag = false
	local var_40_2
	local var_40_3, var_40_4, var_40_5, var_40_6, var_40_7, var_40_8, var_40_9, var_40_10, var_40_11, var_40_12 = fn_6(var_40_2, flag)

	level_transition_handler:set_next_level(var_40_3, var_40_4, var_40_5, var_40_6, var_40_7, var_40_8, var_40_9, var_40_10, var_40_11, var_40_12)

	self._post_match = true

	return str_3
end

DeusMechanism.should_run_tutorial = function (arg_41_0)
	-- function 41
	return true, "tutorial"
end

DeusMechanism.get_level_end_view = function (arg_42_0)
	-- function 42
	return "LevelEndViewDeus"
end

DeusMechanism.get_level_end_view_packages = function (arg_43_0)
	-- function 43
	return {
		"resource_packages/levels/ui_end_screen"
	}
end

DeusMechanism._get_next_game_mode_key = function (self)
	-- function 44
	local var_44_0
	local _state = self._state

	if _state == str_3 then
		var_44_0 = str_2
	elseif _state == str_8 then
		local get_current_node = self._deus_run_controller:get_current_node()

		var_44_0 = fn_2(get_current_node.node_type)
	elseif _state == str_6 then
		var_44_0 = str_5
	end

	return var_44_0
end

DeusMechanism.start_next_round = function (self)
	-- function 45
	local _deus_run_controller = self._deus_run_controller

	self._game_round_ended_reason = nil
	self._final_round = false

	local _state = self._state
	local _build_side_compositions = self:_build_side_compositions(_state)
	local _get_next_game_mode_key = self:_get_next_game_mode_key()
	local debug_activated_blessings = script_data.debug_activated_blessings

	if not debug_activated_blessings then
		if not _deus_run_controller then
			debug_activated_blessings = _deus_run_controller:get_blessings()

			if not debug_activated_blessings then
				-- Nothing
			end
		end

		debug_activated_blessings = {}
	end

	::label_45_0::

	local tbl = {}

	for i, v in ipairs(debug_activated_blessings) do
		local var_45_6 = DeusBlessingSettings[v]

		if not var_45_6.mutators then
			for i_2, v_2 in ipairs(var_45_6.mutators) do
				tbl[#tbl + 1] = v_2
			end
		end
	end

	if _state == str_3 then
		if not _deus_run_controller then
			_deus_run_controller:destroy()

			self._deus_run_controller = nil
		end
	elseif _state == str_8 then
		local get_current_node = _deus_run_controller:get_current_node()
		local next = get_current_node.next

		next = not next and #get_current_node.next > 0
		self._final_round = not next

		local curse = get_current_node.curse

		if not curse then
			tbl[#tbl + 1] = curse
		end

		local minor_modifier_group = get_current_node.minor_modifier_group

		if not minor_modifier_group then
			for i_3, v_3 in ipairs(minor_modifier_group) do
				tbl[#tbl + 1] = v_3
			end
		end

		local theme = get_current_node.theme
		local mutators = DeusThemeSettings[theme].mutators

		if not mutators then
			for i_4, v_4 in ipairs(mutators) do
				tbl[#tbl + 1] = v_4
			end
		end

		if not get_current_node.mutators then
			for i_5, v_5 in ipairs(get_current_node.mutators) do
				tbl[#tbl + 1] = v_5
			end
		end

		_deus_run_controller:handle_start_next_round()
	end

	local tbl_2 = {
		mutators = tbl,
		deus_run_controller = _deus_run_controller
	}

	return _get_next_game_mode_key, _build_side_compositions, tbl_2
end

DeusMechanism._build_side_compositions = function (self, arg_46_1)
	-- function 46
	local _hero_profiles = self._hero_profiles
	local party = Managers.party

	return {
		{
			name = "heroes",
			relations = {
				enemy = {
					"dark_pact"
				}
			},
			party = party:get_party(1),
			add_these_settings = {
				using_grims_and_tomes = true,
				show_damage_feedback = false,
				using_enemy_recycler = true,
				available_profiles = _hero_profiles
			}
		},
		{
			name = "dark_pact",
			relations = {
				enemy = {
					"heroes"
				}
			}
		},
		{
			name = "neutral",
			relations = {
				enemy = {}
			}
		}
	}
end

DeusMechanism.get_state = function (self)
	-- function 47
	return self._state
end

DeusMechanism.generate_level_seed = function (self)
	-- function 48
	local _deus_run_controller = self._deus_run_controller
	local flag = not _deus_run_controller and _deus_run_controller:get_current_node()
	local level_seed

	if not flag then
		level_seed = flag.level_seed

		if not level_seed then
			-- Nothing
		end
	end

	level_seed = 0

	::label_48_0::

	return level_seed
end

DeusMechanism.get_current_node_curse = function (self)
	-- function 49
	local _deus_run_controller = self._deus_run_controller
	local flag = not _deus_run_controller and _deus_run_controller:get_current_node()
	local curse

	if not flag then
		curse = flag.curse

		if not curse then
			-- Nothing
		end
	end

	curse = nil

	::label_49_0::

	return curse
end

DeusMechanism.get_current_node_theme = function (self)
	-- function 50
	local _deus_run_controller = self._deus_run_controller
	local flag = not _deus_run_controller and _deus_run_controller:get_current_node()
	local theme

	if not flag then
		theme = flag.theme

		if not theme then
			-- Nothing
		end
	end

	theme = nil

	::label_50_0::

	return theme
end

DeusMechanism.get_level_seed = function (self, arg_51_1, arg_51_2)
	-- function 51
	local _deus_run_controller = self._deus_run_controller
	local flag = not _deus_run_controller and _deus_run_controller:get_current_node()

	if not arg_51_2 then
		local var_51_2

		if not flag then
			var_51_2 = flag.system_seeds[arg_51_2]

			if not var_51_2 then
				-- Nothing
			end
		end

		var_51_2 = 0

		::label_51_0::

		return var_51_2
	end

	local level_seed

	if not flag then
		level_seed = flag.level_seed

		if not level_seed then
			-- Nothing
		end
	end

	level_seed = 0

	::label_51_1::

	return level_seed
end

DeusMechanism.can_spawn_pickup = function (arg_52_0, arg_52_1, arg_52_2)
	-- function 52
	local var_52_0

	if not Pickups.deus_potions[arg_52_2] then
		var_52_0 = Unit.get_data(arg_52_1, "deus_potion")
	end

	if arg_52_2 == "deus_02" then
		var_52_0 = Unit.get_data(arg_52_1, "deus_cursed_chest") or Unit.get_data(arg_52_1, "deus_02")
	end

	return var_52_0
end

DeusMechanism.uses_random_directors = function (arg_53_0)
	-- function 53
	return false
end

DeusMechanism.profile_changed = function (self, arg_54_1, arg_54_2, arg_54_3, arg_54_4, arg_54_5)
	-- function 54
	if not (not self._deus_run_controller and self._deus_run_controller:get_run_ended()) then
		self._deus_run_controller:profile_changed(arg_54_1, arg_54_2, arg_54_3, arg_54_4, arg_54_5)

		if not (arg_54_1 ~= self._deus_run_controller:get_own_peer_id() or arg_54_2 ~= num) then
			self:_update_own_avatar_info()
		end

		local name = SPProfiles[arg_54_3].careers[arg_54_4].name

		self:_update_career_loadout(arg_54_2, name, arg_54_5)
	end
end

DeusMechanism.sync_mechanism_data = function (self, arg_55_1, arg_55_2)
	-- function 55
	if not arg_55_2 then
		return
	end

	local _deus_run_controller = self._deus_run_controller

	if not (not _deus_run_controller and _deus_run_controller:get_run_ended()) then
		local var_55_1 = NetworkLookup.difficulties[_deus_run_controller:get_run_difficulty()]
		local var_55_2 = NetworkLookup.deus_journeys[_deus_run_controller:get_journey_name()]
		local var_55_3 = NetworkLookup.deus_themes[_deus_run_controller:get_dominant_god()]
		local get_belakor_enabled = _deus_run_controller:get_belakor_enabled()
		local get_event_mutators = _deus_run_controller:get_event_mutators()
		local get_event_boons = _deus_run_controller:get_event_boons()
		local tbl = {}

		for i = 1, #get_event_mutators do
			local var_55_8 = get_event_mutators[i]
			local var_55_9 = NetworkLookup.mutator_templates[var_55_8]

			tbl[#tbl + 1] = var_55_9
		end

		local tbl_2 = {}

		for j = 1, #get_event_boons do
			local name = get_event_boons[j].name
			local var_55_12 = DeusPowerUpsLookup[name]

			tbl_2[#tbl_2 + 1] = var_55_12.lookup_id
		end

		local var_55_13 = PEER_ID_TO_CHANNEL[arg_55_1]

		RPC.rpc_deus_setup_run(var_55_13, self._run_id, self._run_seed, var_55_1, var_55_2, var_55_3, not not get_belakor_enabled, tbl, tbl_2)
	end
end

DeusMechanism._send_level_started_tracking_data = function (self)
	-- function 56
	local statistics_db = Managers.player:statistics_db()
	local count = #Managers.player:bots()
	local get_level_started_tracking_data = self._deus_run_controller:get_level_started_tracking_data(statistics_db, count)

	Managers.telemetry_events:deus_level_started(get_level_started_tracking_data)
end

DeusMechanism._send_level_ended_tracking_data = function (self, arg_57_1)
	-- function 57
	local statistics_db = Managers.player:statistics_db()
	local count = #Managers.player:bots()
	local get_level_ended_tracking_data = self._deus_run_controller:get_level_ended_tracking_data(statistics_db, arg_57_1, count)

	Managers.telemetry_events:deus_level_ended(get_level_ended_tracking_data)
end

DeusMechanism._send_run_tracking_data = function (self, arg_58_1)
	-- function 58
	local get_run_tracking_data = self._deus_run_controller:get_run_tracking_data(arg_58_1)

	Managers.telemetry_events:deus_run_ended(get_run_tracking_data)
end

DeusMechanism.debug_load_shrine_node = function (self)
	-- function 59
	local str = "DEBUG_SHRINE_NODE"
	local var_59_1 = self
	local _debug_load_seed = self._debug_load_seed
	local var_59_3 = str
	local current_difficulty_setting = script_data.current_difficulty_setting

	current_difficulty_setting = current_difficulty_setting or "normal"

	_debug_load_seed(var_59_1, var_59_3, current_difficulty_setting)
end

DeusMechanism.debug_load_map = function (self)
	-- function 60
	local var_60_0 = self
	local _debug_load_seed = self._debug_load_seed
	local deus_seed = script_data.deus_seed

	deus_seed = deus_seed or tostring(math.random_seed())

	local current_difficulty_setting = script_data.current_difficulty_setting

	current_difficulty_setting = current_difficulty_setting or "normal"

	_debug_load_seed(var_60_0, deus_seed, current_difficulty_setting)
end

DeusMechanism.debug_load_level = function (self, arg_61_1)
	-- function 61
	local var_61_0 = LevelSettings[arg_61_1]

	if not var_61_0 and not var_61_0.hub_level then
		local level_transition_handler = Managers.level_transition_handler

		level_transition_handler:set_next_level(arg_61_1)
		level_transition_handler:promote_next_level_data()
	else
		local str = "DEBUG_SPECIFIC_NODE"
		local deus_force_load_run_progress = script_data.deus_force_load_run_progress

		deus_force_load_run_progress = deus_force_load_run_progress or 0

		local str_2 = str .. deus_force_load_run_progress .. "_" .. arg_61_1 .. "SEED" .. 0 .. "SEED_END"
		local var_61_5 = self
		local _debug_load_seed = self._debug_load_seed
		local var_61_7 = str_2
		local current_difficulty_setting = script_data.current_difficulty_setting

		current_difficulty_setting = current_difficulty_setting or "normal"

		_debug_load_seed(var_61_5, var_61_7, current_difficulty_setting)
	end
end

DeusMechanism.debug_load_deus_level = function (self, arg_62_1, arg_62_2, arg_62_3, arg_62_4, arg_62_5)
	-- function 62
	local str = "DEBUG_SPECIFIC_NODE" .. math.floor(arg_62_3 * 1000) .. "_" .. arg_62_1 .. "SEED" .. arg_62_4 .. "SEED_END"

	self:_debug_load_seed(str, arg_62_2, arg_62_5)
end

DeusMechanism._debug_load_seed = function (self, arg_63_1, arg_63_2, arg_63_3)
	-- function 63
	local sub = string.sub(tostring(math.random_seed()), 0, 8)
	local deus_journey = script_data.deus_journey

	deus_journey = deus_journey or AvailableJourneyOrder[1]

	local deus_dominant_god = script_data.deus_dominant_god

	deus_dominant_god = deus_dominant_god or DeusJourneyCycleGods[1]

	local tbl = {}
	local tbl_2 = {}

	self:_setup_run(sub, arg_63_1, true, Network.peer_id(), arg_63_2, deus_journey, deus_dominant_god, not not arg_63_3, tbl, tbl_2)

	local var_63_5 = NetworkLookup.difficulties[arg_63_2]
	local var_63_6 = NetworkLookup.deus_journeys[deus_journey]
	local var_63_7 = NetworkLookup.deus_themes[deus_dominant_god]
	local tbl_3 = {}
	local tbl_4 = {}

	Managers.mechanism:send_rpc_clients("rpc_deus_setup_run", sub, arg_63_1, var_63_5, var_63_6, var_63_7, not not arg_63_3, tbl_3, tbl_4)

	if not string.starts_with(arg_63_1, "DEBUG_SHRINE_NODE") then
		self._deus_run_controller:debug_shrine_setup()
	end

	local flag = false
	local _deus_run_controller = self._deus_run_controller
	local var_63_12, var_63_13, var_63_14, var_63_15, var_63_16, var_63_17, var_63_18, var_63_19, var_63_20, var_63_21 = fn_6(_deus_run_controller, flag)
	local level_transition_handler = Managers.level_transition_handler

	level_transition_handler:set_next_level(var_63_12, var_63_13, var_63_14, var_63_15, var_63_16, var_63_17, var_63_18, var_63_19, var_63_20, var_63_21)
	self:_update_current_state()
	level_transition_handler:promote_next_level_data()
end

DeusMechanism._setup_run = function (self, arg_64_1, arg_64_2, arg_64_3, arg_64_4, arg_64_5, arg_64_6, arg_64_7, arg_64_8, arg_64_9, arg_64_10)
	-- function 64
	local get_interface = Managers.backend:get_interface("deus")
	local peer_id = Network.peer_id()

	self._run_id = arg_64_1
	self._run_seed = arg_64_2

	if not self._deus_run_controller then
		self._deus_run_controller:destroy()
	end

	arg_64_9 = arg_64_9 or tbl_3
	arg_64_10 = arg_64_10 or tbl_3

	local get_interface_2 = Managers.backend:get_interface("items")
	local get_interface_3 = Managers.backend:get_interface("talents")
	local get_bot_loadout = get_interface_2:get_bot_loadout()
	local tbl = {}
	local tbl_4 = {}

	for i, v in ipairs(tbl_2) do
		tbl_4[v] = get_interface_3:get_bot_talents(v)

		local var_64_7 = get_bot_loadout[v]
		local tbl_5 = {}

		tbl[v] = tbl_5

		for k, v_2 in pairs(var_64_7) do
			if not (k == "slot_melee" or k ~= "slot_ranged") then
				local get_item_from_id = get_interface_2:get_item_from_id(v_2)
				local flag = not get_item_from_id and get_item_from_id.key
				local var_64_11 = DeusStartingWeaponTypeMapping[flag]

				if not var_64_11 then
					fassert(DeusDefaultLoadout[v], "career %s is not properly configured for Morris.", v)

					var_64_11 = DeusDefaultLoadout[v][k]

					Application.warning("Unknown weapon " .. (flag or "unknown") .. " in slot " .. k .. ", can't convert to deus weapon. Using " .. var_64_11)
				end

				local generate_item_from_item_key = DeusWeaponGeneration.generate_item_from_item_key(var_64_11, arg_64_5, 0, "plentiful", 0)
				local var_64_13 = DeusStarterWeaponPowerLevels[arg_64_5]

				var_64_13 = var_64_13 or DeusStarterWeaponPowerLevels.default
				generate_item_from_item_key.power_level = var_64_13
				tbl_5[k] = generate_item_from_item_key
			end
		end
	end

	local get_loadout = get_interface_2:get_loadout()
	local tbl_6 = {}
	local tbl_7 = {}

	for i_2, v_3 in ipairs(tbl_2) do
		tbl_7[v_3] = get_interface_3:get_talents(v_3)

		local var_64_17 = get_loadout[v_3]
		local tbl_8 = {}

		tbl_6[v_3] = tbl_8

		for k_2, v_4 in pairs(var_64_17) do
			if not (k_2 == "slot_melee" or k_2 ~= "slot_ranged") then
				local get_item_from_id_2 = get_interface_2:get_item_from_id(v_4)
				local flag_2 = not get_item_from_id_2 and get_item_from_id_2.key
				local var_64_21 = DeusStartingWeaponTypeMapping[flag_2]

				if not var_64_21 then
					fassert(DeusDefaultLoadout[v_3], "career %s is not properly configured for Morris.", v_3)

					var_64_21 = DeusDefaultLoadout[v_3][k_2]

					Application.warning("Unknown weapon " .. (flag_2 or "unknown") .. " in slot " .. k_2 .. ", can't convert to deus weapon. Using " .. var_64_21)
				end

				local generate_item_from_item_key_2 = DeusWeaponGeneration.generate_item_from_item_key(var_64_21, arg_64_5, 0, "plentiful", 0)
				local var_64_23 = DeusStarterWeaponPowerLevels[arg_64_5]

				var_64_23 = var_64_23 or DeusStarterWeaponPowerLevels.default
				generate_item_from_item_key_2.power_level = var_64_23
				tbl_8[k_2] = generate_item_from_item_key_2

				local var_64_24 = tbl[v_3]
				local var_64_25 = tbl[v_3][k_2]

				var_64_25 = var_64_25 or generate_item_from_item_key_2
				var_64_24[k_2] = var_64_25
			end
		end
	end

	get_interface:reset_deus_inventory()

	local tbl_9 = {}

	for k_3, v_5 in pairs(tbl_6) do
		local tbl_10 = {}

		tbl_9[k_3] = tbl_10

		for k_4, v_6 in pairs(v_5) do
			tbl_10[k_4] = get_interface:grant_deus_weapon(v_6)
		end
	end

	local tbl_11 = {}

	for k_5, v_7 in pairs(tbl) do
		local tbl_12 = {}

		tbl_11[k_5] = tbl_12

		for k_6, v_8 in pairs(v_7) do
			tbl_12[k_6] = get_interface:grant_deus_weapon(v_8)
		end
	end

	get_interface:refresh_deus_weapons_in_items_backend()
	get_interface:set_deus_loadout(tbl_9)
	get_interface:set_deus_bot_loadout(tbl_11)

	local network_handler = Managers.mechanism:network_handler()

	Managers.backend:set_loadout_interface_override(nil)

	local tbl_13 = {}

	for k_7, v_9 in pairs(DeusWeaponGroups) do
		if not get_interface_2:has_item(k_7) then
			tbl_13[k_7] = true
		end
	end

	self._deus_run_controller = DeusRunController:new(arg_64_1, arg_64_3, network_handler, arg_64_4, peer_id, tbl_6, tbl_7, tbl, tbl_4, tbl_13)

	self._deus_run_controller:register_rpcs(self._network_event_delegate)

	local get_rolled_over_soft_currency = get_interface:get_rolled_over_soft_currency()
	local player_id = Managers.backend:player_id()

	player_id = player_id or ""

	self._deus_run_controller:setup_run(arg_64_2, arg_64_5, arg_64_6, arg_64_7, get_rolled_over_soft_currency, player_id, arg_64_8, arg_64_9, arg_64_10)
	self._deus_run_controller:full_sync()
	self:_update_own_avatar_info()

	local get_player_profile, var_64_35 = self._deus_run_controller:get_player_profile(peer_id, num)

	if get_player_profile ~= 0 then
		local name = SPProfiles[get_player_profile].careers[var_64_35].name

		self:_update_career_loadout(num, name)
	end

	get_interface:deus_run_started()
end

DeusMechanism._update_own_avatar_info = function (self)
	-- function 65
	local get_own_peer_id = self._deus_run_controller:get_own_peer_id()
	local get_player_profile, var_65_2 = self._deus_run_controller:get_player_profile(get_own_peer_id, num)
	local local_player = Managers.player:local_player()

	if not (get_player_profile == 0 or local_player) then
		return
	end

	local var_65_4 = SPProfiles[get_player_profile]
	local var_65_5 = var_65_4.careers[var_65_2]
	local display_name = var_65_4.display_name
	local name = var_65_5.name
	local get_experience = ExperienceSettings.get_experience(display_name)
	local get_level = ExperienceSettings.get_level(get_experience)
	local get_versus_level

	if not Application.user_setting("toggle_versus_level_in_all_game_modes") then
		get_versus_level = ExperienceSettings.get_versus_level()

		if not get_versus_level then
			-- Nothing
		end
	end

	get_versus_level = 0

	::label_65_0::

	local get_loadout_item = BackendUtils.get_loadout_item(name, "slot_frame")
	local name_2

	if not get_loadout_item then
		name_2 = get_loadout_item.data.name

		if not name_2 then
			-- Nothing
		end
	end

	name_2 = "default"

	::label_65_1::

	local name_3 = local_player:name()

	name_3 = name_3 or ""

	self._deus_run_controller:set_own_player_avatar_info(get_level, name_3, name_2, get_versus_level)
end

DeusMechanism.rpc_deus_setup_run = function (self, arg_66_1, arg_66_2, arg_66_3, arg_66_4, arg_66_5, arg_66_6, arg_66_7, arg_66_8, arg_66_9)
	-- function 66
	local var_66_0 = NetworkLookup.difficulties[arg_66_4]
	local var_66_1 = NetworkLookup.deus_journeys[arg_66_5]
	local var_66_2 = NetworkLookup.deus_themes[arg_66_6]
	local var_66_3 = CHANNEL_TO_PEER_ID[arg_66_1]
	local tbl = {}

	for i = 1, #arg_66_8 do
		local var_66_5 = arg_66_8[i]

		tbl[#tbl + 1] = NetworkLookup.mutator_templates[var_66_5]
	end

	local tbl_2 = {}

	for j = 1, #arg_66_9 do
		local var_66_7 = arg_66_9[j]
		local var_66_8 = DeusPowerUpsLookup[var_66_7]

		tbl_2[#tbl_2 + 1] = var_66_8.name
	end

	self:_setup_run(arg_66_2, arg_66_3, false, var_66_3, var_66_0, var_66_1, var_66_2, arg_66_7, tbl, tbl_2)
end

DeusMechanism.should_play_level_introduction = function (arg_67_0)
	-- function 67
	return false
end

DeusMechanism.set_vote_data = function (self, arg_68_1)
	-- function 68
	self._vote_data = arg_68_1
end

DeusMechanism._get_vote_data = function (self)
	-- function 69
	return self._vote_data
end

DeusMechanism.get_loading_tip = function (self)
	-- function 70
	local loading_tips_file = DLCSettings.morris.loading_tips_file
	local var_70_1 = local_require(loading_tips_file)
	local var_70_2 = var_70_1[self:get_current_node_theme()]

	var_70_2 = var_70_2 or var_70_1.general

	if self._state == str_6 then
		var_70_2 = var_70_1.general
	end

	return var_70_2[math.random(1, #var_70_2)]
end

DeusMechanism.post_match = function (self)
	-- function 71
	return self._post_match
end

DeusMechanism.get_level_dialogue_context = function (self)
	-- function 72
	local num = 0
	local num_2 = 0
	local num_3 = 0
	local var_72_3
	local flag = false
	local _deus_run_controller = self._deus_run_controller

	if not _deus_run_controller then
		num = #_deus_run_controller:get_traversed_nodes() + 1

		local get_visited_nodes = _deus_run_controller:get_visited_nodes()

		for i, v in ipairs(get_visited_nodes) do
			local get_node = _deus_run_controller:get_node(v)

			if get_node.node_type == "shop" then
				num_3 = num_3 + 1
			end

			for i_2, v_2 in ipairs(get_node.next) do
				if _deus_run_controller:get_node(v_2).node_type == "shop" then
					num_2 = num_2 + 1

					break
				end
			end
		end

		local level = _deus_run_controller:get_current_node().level

		var_72_3 = LevelSettings[level].theme

		local get_journey_name = _deus_run_controller:get_journey_name()

		flag = Managers.backend:get_interface("deus"):deus_journey_with_belakor(get_journey_name)
	end

	return {
		times_map_visited = num,
		times_shrine_was_in_range = num_2,
		current_theme = var_72_3,
		times_shrine_visited = num_3,
		deus_current_curse = self:get_current_node_curse(),
		is_final_round = self:is_final_round(),
		map_has_belakor = flag
	}
end

DeusMechanism.is_packages_loaded = function (self)
	-- function 73
	if not self._deus_run_controller then
		return true
	end

	return self._deus_run_controller:is_weekly_event_packages_loaded()
end

DeusMechanism._update_current_state = function (self, arg_74_1)
	-- function 74
	local var_74_0

	if not self._deus_run_controller and not self._deus_run_controller:get_run_ended() then
		var_74_0 = str_3
	elseif not self._deus_run_controller:has_completed_current_node() then
		var_74_0 = str_6
	elseif self._deus_run_controller:get_current_node().level_type == "SHOP" then
		var_74_0 = str_6
	else
		var_74_0 = str_8
	end

	Managers.mechanism:choose_next_state(var_74_0)
	Managers.mechanism:progress_state(arg_74_1)
end

DeusMechanism.get_player_level_fallback = function (self, arg_75_1)
	-- function 75
	if not self._deus_run_controller and not arg_75_1 then
		local peer_id = arg_75_1.peer_id

		return self._deus_run_controller:get_player_level(peer_id)
	end
end

DeusMechanism.get_starting_level = function ()
	-- function 76
	return str
end

DeusMechanism.reserved_party_id_by_peer = function (arg_77_0, arg_77_1)
	-- function 77
	return 1
end

DeusMechanism.try_reserve_profile_for_peer_by_mechanism = function (self, arg_78_1, arg_78_2, arg_78_3, arg_78_4, arg_78_5)
	-- function 78
	local reserved_party_id_by_peer = self:reserved_party_id_by_peer(arg_78_2)

	return arg_78_1:try_reserve_profile_for_peer(reserved_party_id_by_peer, arg_78_2, arg_78_3, arg_78_4)
end

DeusMechanism.entered_mechanism_due_to_switch = function (arg_79_0)
	-- function 79
	Managers.chat:set_chat_enabled(true)
end
