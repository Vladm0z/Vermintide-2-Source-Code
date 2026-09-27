-- chunkname: @scripts/managers/game_mode/mechanisms/adventure_mechanism.lua

AdventureMechanism = class(AdventureMechanism)
AdventureMechanism.name = "Adventure"

local scripts_settings_live_events_packages = require("scripts/settings/live_events_packages")
local str = "inn_level"
local str_2 = "inn"
local str_3 = "inn"
local str_4 = "adventure"
local str_5 = "ingame"
local str_6 = "tutorial"
local str_7 = "tutorial"
local str_8 = "weave"
local str_9 = "weave"

local function fn(self)
	-- function 1
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
	local var_1_11 = difficulty
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

	printf(str, flag, var_1_11, flag_2, flag_3, flag_4, flag_5, flag_6, flag_7)
	print("............................................................................................................")
	print("............................................................................................................")
end

local tbl = {
	default = function (self)
		-- function 2
		fn(self)

		local tbl = {
			mission_id = self.mission_id,
			difficulty = self.difficulty,
			quick_game = self.quick_game,
			private_game = self.private_game,
			always_host = self.always_host,
			strict_matchmaking = self.strict_matchmaking,
			excluded_level_keys = self.excluded_level_keys,
			matchmaking_type = self.matchmaking_type,
			mechanism = self.mechanism,
			vote_type = self.request_type
		}
		local str = "game_settings_vote"

		Managers.state.voting:request_vote(str, tbl, Network.peer_id())
	end,
	deed = function (self)
		-- function 3
		fn(self)

		local get_item_from_id = Managers.backend:get_interface("items"):get_item_from_id(self.deed_backend_id)
		local data = get_item_from_id.data
		local difficulty = get_item_from_id.difficulty
		local level_key = get_item_from_id.level_key
		local tbl = {
			item_name = data.name,
			mission_id = level_key,
			difficulty = difficulty,
			excluded_level_keys = self.excluded_level_keys,
			matchmaking_type = self.matchmaking_type,
			mechanism = self.mechanism,
			vote_type = self.request_type
		}

		Managers.state.voting:request_vote("game_settings_deed_vote", tbl, Network.peer_id())
	end,
	event = function (self)
		-- function 4
		fn(self)

		local tbl = {
			mission_id = self.mission_id,
			difficulty = self.difficulty,
			quick_game = self.quick_game,
			private_game = self.private_game,
			always_host = self.always_host,
			strict_matchmaking = self.strict_matchmaking,
			event_data = self.event_data,
			excluded_level_keys = self.excluded_level_keys,
			matchmaking_type = self.matchmaking_type,
			mechanism = self.mechanism,
			vote_type = self.request_type
		}

		Managers.state.voting:request_vote("game_settings_event_vote", tbl, Network.peer_id())
	end,
	weave_quick_play = function (self)
		-- function 5
		fn(self)

		local tbl = {
			quick_game = true,
			difficulty = self.difficulty,
			private_game = self.private_game,
			always_host = self.always_host,
			matchmaking_type = self.matchmaking_type,
			mechanism = self.mechanism,
			vote_type = self.request_type
		}

		Managers.state.voting:request_vote("game_settings_weave_quick_play_vote", tbl, Network.peer_id())
	end,
	weave = function (self)
		-- function 6
		fn(self)

		local tbl = {
			quick_game = false,
			mission_id = self.mission_id,
			difficulty = self.difficulty,
			objective_index = self.objective_index,
			private_game = self.private_game,
			always_host = self.always_host,
			matchmaking_type = self.matchmaking_type,
			mechanism = self.mechanism,
			vote_type = self.request_type
		}

		Managers.state.voting:request_vote("game_settings_weave_vote", tbl, Network.peer_id())
	end
}
local tbl_2 = {
	"rpc_sync_adventure_data_to_peer"
}

AdventureMechanism.init = function (self, arg_7_1)
	-- function 7
	self:_reset(arg_7_1)
end

AdventureMechanism.register_rpcs = function (self, arg_8_1)
	-- function 8
	self:unregister_rpcs()

	self._network_event_delegate = arg_8_1

	arg_8_1:register(self, unpack(tbl_2))
end

AdventureMechanism.unregister_rpcs = function (self)
	-- function 9
	if not self._network_event_delegate then
		self._network_event_delegate:unregister(self)

		self._network_event_delegate = nil
	end
end

AdventureMechanism.on_venture_start = function (arg_10_0)
	-- function 10
	return
end

AdventureMechanism.on_venture_end = function (self)
	-- function 11
	if self._state ~= str_9 then
		Managers.weave:clear_weave_name()
		Managers.backend:set_talents_interface_override()
	end
end

AdventureMechanism.is_venture_over = function (self)
	-- function 12
	local _game_round_ended_reason = self._game_round_ended_reason
	local flag = _game_round_ended_reason == "won" or _game_round_ended_reason == "lost"

	if self._state == str_9 then
		local flag_2 = not Managers.weave:calculate_next_objective_index()

		return not flag and _game_round_ended_reason == "lost" or flag_2
	else
		return flag
	end
end

AdventureMechanism.handle_ingame_exit = function (self, arg_13_1)
	-- function 13
	if not (arg_13_1 == "join_lobby_failed" or arg_13_1 == "left_game" or arg_13_1 == "lobby_state_failed" or arg_13_1 == "kicked_by_server" or arg_13_1 == "afk_kick" or arg_13_1 == "quit_game" or arg_13_1 ~= "return_to_pc_menu") then
		self:_reset()
	end
end

AdventureMechanism._reset = function (self, arg_14_1, arg_14_2)
	-- function 14
	local get_hub_level_key = self:get_hub_level_key()
	local var_14_1 = LevelSettings[get_hub_level_key]

	self._prior_state = arg_14_2 or self._state

	if not var_14_1.hub_level then
		self._state = str_3
	else
		self._state = str_5
	end

	self._next_state = nil
	self._saved_game_mode_data = nil
	self._hero_profiles = table.clone(PROFILES_BY_AFFILIATION.heroes)
	self._tutorial_profiles = table.clone(PROFILES_BY_AFFILIATION.tutorial)
end

AdventureMechanism.network_context_destroyed = function (self)
	-- function 15
	self:_reset()
end

AdventureMechanism.choose_next_state = function (self, arg_16_1)
	-- function 16
	local _state = self._state

	if not (_state == str_3 or _state ~= str_7) then
		local tbl = {
			weave = true,
			ingame = true,
			tutorial = true
		}

		fassert(tbl[arg_16_1], "State (%s) is not an acceptable transition from current state (%s)", arg_16_1, _state)
	elseif not (not Development.parameter("weave_name") and _state ~= "ingame") then
		-- Nothing
	else
		ferror("Not allowed to choose next state in current state (%s)", _state)
	end

	self._next_state = arg_16_1
end

AdventureMechanism.reset_choose_next_state = function (self)
	-- function 17
	self._next_state = nil
end

AdventureMechanism.progress_state = function (self)
	-- function 18
	if not self._next_state then
		self._prior_state = self._state
		self._state = self._next_state
		self._next_state = nil
	else
		local _state = self._state

		self._prior_state = _state

		if _state == str_3 then
			self._state = str_5
		elseif not (_state == str_5 or _state ~= str_7) then
			self._state = str_3
		elseif _state == str_9 then
			if not Managers.weave:calculate_next_objective_index() then
				self._state = str_3
			end
		else
			ferror("AdventureMechanism: unknown state %s", _state)
		end
	end

	return self._state
end

AdventureMechanism.get_prior_state = function (self)
	-- function 19
	return self._prior_state
end

AdventureMechanism.set_current_state = function (self, arg_20_1)
	-- function 20
	self._prior_state = self._state
	self._state = arg_20_1
end

AdventureMechanism.get_hub_level_key = function (self)
	-- function 21
	local _debug_hub_level_key = self._debug_hub_level_key

	_debug_hub_level_key = _debug_hub_level_key or AdventureMechanism.get_starting_level()

	return _debug_hub_level_key
end

AdventureMechanism.get_level_seed = function (arg_22_0, arg_22_1, arg_22_2)
	-- function 22
	local weave = Managers.weave

	if not weave and not weave:get_active_weave() then
		local get_active_objective_template = weave:get_active_objective_template()

		arg_22_1 = not arg_22_2 and not get_active_objective_template.system_seeds and get_active_objective_template.system_seeds[arg_22_2] and get_active_objective_template.level_seed or arg_22_1
	end

	return arg_22_1
end

AdventureMechanism.get_end_of_level_rewards_arguments = function (self, arg_23_1, arg_23_2, arg_23_3, arg_23_4, arg_23_5, arg_23_6)
	-- function 23
	local flag = self._current_game_mode == str_8
	local get_stat = arg_23_3:get_stat(arg_23_4, "kills_total")
	local var_23_2
	local var_23_3
	local flag_2 = false

	if not flag then
		local weave = Managers.weave

		var_23_2 = weave:get_weave_tier()
		var_23_3 = weave:current_bar_score()
	elseif not arg_23_1 then
		flag_2 = arg_23_3:get_persistent_stat(arg_23_4, "completed_levels_" .. arg_23_6, arg_23_5) == 1
	end

	local flag_3 = false
	local current_weave = LevelUnlockUtils.current_weave(arg_23_3, arg_23_4, flag_3)
	local var_23_8 = WeaveSettings.templates[current_weave]
	local templates_ordered = WeaveSettings.templates_ordered
	local find = table.find(templates_ordered, var_23_8)
	local system = Managers.state.entity:system("mission_system")
	local get_level_end_mission_data = system:get_level_end_mission_data("tome_bonus_mission")
	local get_level_end_mission_data_2 = system:get_level_end_mission_data("grimoire_hidden_mission")
	local get_level_end_mission_data_3 = system:get_level_end_mission_data("bonus_dice_hidden_mission")
	local get_level_end_mission_data_4 = system:get_level_end_mission_data("painting_scrap_hidden_mission")
	local tbl = {}
	local current_amount

	if not get_level_end_mission_data then
		current_amount = get_level_end_mission_data.current_amount

		if not current_amount then
			-- Nothing
		end
	end

	current_amount = 0

	::label_23_0::

	tbl.tome = current_amount

	local current_amount_2

	if not get_level_end_mission_data_2 then
		current_amount_2 = get_level_end_mission_data_2.current_amount

		if not current_amount_2 then
			-- Nothing
		end
	end

	current_amount_2 = 0

	::label_23_1::

	tbl.grimoire = current_amount_2

	local current_amount_3

	if not get_level_end_mission_data_3 then
		current_amount_3 = get_level_end_mission_data_3.current_amount

		if not current_amount_3 then
			-- Nothing
		end
	end

	current_amount_3 = 0

	::label_23_2::

	tbl.loot_dice = current_amount_3

	local current_amount_4

	if not get_level_end_mission_data_4 then
		current_amount_4 = get_level_end_mission_data_4.current_amount

		if not current_amount_4 then
			-- Nothing
		end
	end

	current_amount_4 = 0

	::label_23_3::

	tbl.painting_scraps = current_amount_4
	tbl.quickplay = arg_23_2
	tbl.game_won = arg_23_1

	return {
		current_weave_index = find,
		weave_tier = var_23_2,
		weave_progress = var_23_3,
		kill_count = get_stat,
		chest_upgrade_data = tbl,
		first_time_completion = flag_2
	}
end

AdventureMechanism.get_end_of_level_extra_mission_results = function (arg_24_0)
	-- function 24
	Managers.state.entity:system("mission_system"):start_mission("players_alive_mission")

	return {}
end

AdventureMechanism.is_final_round = function (self)
	-- function 25
	if self._current_game_mode == str_8 then
		return not Managers.weave:calculate_next_objective_index()
	end

	return true
end

AdventureMechanism.get_level_end_view = function (self)
	-- function 26
	local flag = Managers.state.network:lobby():lobby_data("weave_quick_game") == "true"

	if not (self._current_game_mode ~= str_8 or flag) then
		return "LevelEndViewWeave"
	end

	return "LevelEndView"
end

AdventureMechanism.get_level_end_view_packages = function (self)
	-- function 27
	local flag = Managers.state.network:lobby():lobby_data("weave_quick_game") == "true"

	if not (self._current_game_mode ~= str_8 or flag) then
		return {
			"resource_packages/levels/ui_end_screen_victory"
		}
	end

	return {
		"resource_packages/levels/ui_end_screen"
	}
end

AdventureMechanism.game_round_ended = function (self, arg_28_1, arg_28_2, arg_28_3)
	-- function 28
	self._game_round_ended_reason = arg_28_3

	local var_28_0
	local _state = self._state
	local var_28_2
	local var_28_3
	local var_28_4
	local var_28_5
	local var_28_6
	local var_28_7

	if _state == str_3 then
		var_28_2 = Managers.level_transition_handler:get_next_level_key()
	elseif _state == str_7 then
		var_28_2 = self._debug_hub_level_key or AdventureMechanism.get_starting_level()
	elseif _state == str_9 then
		local weave = Managers.weave
		local calculate_next_objective_index = weave:calculate_next_objective_index()

		if not (not calculate_next_objective_index and arg_28_3 ~= "won") then
			local get_active_weave = weave:get_active_weave()
			local var_28_11 = WeaveSettings.templates[get_active_weave].objectives[calculate_next_objective_index]

			weave:set_next_weave(get_active_weave)
			weave:set_next_objective(calculate_next_objective_index)

			var_28_0 = Managers.state.game_mode:get_saved_game_mode_data()

			if not var_28_0 then
				for k, v in pairs(var_28_0) do
					v.spawn_state = nil
					v.position = nil
					v.rotation = nil
				end
			end

			var_28_2 = var_28_11.level_id
			var_28_3 = var_28_11.conflict_settings
			var_28_4 = Managers.mechanism:generate_level_seed()

			local level_transition_handler = Managers.level_transition_handler

			var_28_6 = level_transition_handler:get_current_difficulty()
			var_28_7 = level_transition_handler:get_current_difficulty_tweak()
			var_28_5 = level_transition_handler:get_current_locked_director_functions()
		else
			var_28_2 = AdventureMechanism.debug_hub_level_key or AdventureMechanism.get_starting_level()
			self._next_state = str_3
		end
	else
		var_28_2 = AdventureMechanism.debug_hub_level_key or AdventureMechanism.get_starting_level()
	end

	if arg_28_3 == "start_game" then
		Managers.level_transition_handler:promote_next_level_data()
	elseif not (arg_28_3 == "won" or arg_28_3 ~= "lost") then
		self._saved_game_mode_data = var_28_0

		local get_environment_variation_id = LevelHelper:get_environment_variation_id(var_28_2)

		Managers.level_transition_handler:set_next_level(var_28_2, get_environment_variation_id, var_28_4, nil, nil, var_28_3, var_28_5, var_28_6, var_28_7)
	elseif arg_28_3 == "reload" then
		local generate_level_seed = Managers.mechanism:generate_level_seed()

		Managers.level_transition_handler:reload_level(nil, generate_level_seed)
		Managers.level_transition_handler:promote_next_level_data()
	else
		fassert(false, "Invalid end reason %q.", tostring(arg_28_3))
	end
end

AdventureMechanism.should_run_tutorial = function (arg_29_0)
	-- function 29
	return true, str_7
end

AdventureMechanism._get_next_game_mode_key = function (self)
	-- function 30
	local var_30_0
	local _state = self._state

	if _state == str_3 then
		local get_current_level_keys = Managers.level_transition_handler:get_current_level_keys()

		if not LevelSettings[get_current_level_keys].hub_level then
			var_30_0 = str_2
		else
			var_30_0 = str_4
		end
	elseif _state == str_7 then
		var_30_0 = str_6
	elseif _state == str_9 then
		var_30_0 = str_8
	else
		var_30_0 = str_4
	end

	return var_30_0
end

AdventureMechanism.start_next_round = function (self)
	-- function 31
	self._game_round_ended_reason = nil

	local _state = self._state

	if _state == str_3 then
		local var_31_1
		local _prior_state = self._prior_state

		self:_reset(var_31_1, _prior_state)
	end

	local _build_side_compositions = self:_build_side_compositions(_state)
	local _get_next_game_mode_key = self:_get_next_game_mode_key()

	self._current_game_mode = _get_next_game_mode_key

	local var_31_5

	if not self._saved_game_mode_data then
		var_31_5 = table.clone(self._saved_game_mode_data)
	end

	local tbl = {
		game_mode_data = var_31_5
	}

	return _get_next_game_mode_key, _build_side_compositions, tbl
end

AdventureMechanism._build_side_compositions = function (self, arg_32_1)
	-- function 32
	local _hero_profiles = self._hero_profiles

	if arg_32_1 == str_7 then
		_hero_profiles = self._tutorial_profiles
	end

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

AdventureMechanism.get_state = function (self)
	-- function 33
	return self._state
end

AdventureMechanism.sync_mechanism_data = function (arg_34_0, arg_34_1, arg_34_2)
	-- function 34
	local weave = Managers.weave

	if not weave then
		local get_next_weave = weave:get_next_weave()
		local get_next_objective = weave:get_next_objective()
		local get_active_weave = weave:get_active_weave()
		local get_active_objective = weave:get_active_objective()
		local flag = get_next_weave or get_active_weave or "n/a"
		local flag_2 = get_next_objective or get_active_objective or 1
		local var_34_7 = NetworkLookup.weave_names[flag]
		local var_34_8 = PEER_ID_TO_CHANNEL[arg_34_1]

		RPC.rpc_sync_adventure_data_to_peer(var_34_8, var_34_7, flag_2)
	end
end

AdventureMechanism.rpc_sync_adventure_data_to_peer = function (arg_35_0, arg_35_1, arg_35_2, arg_35_3)
	-- function 35
	local var_35_0 = NetworkLookup.weave_names[arg_35_2]
	local weave = Managers.weave

	if var_35_0 ~= "n/a" then
		weave:set_next_weave(var_35_0)
		weave:set_next_objective(arg_35_3)
	end
end

AdventureMechanism.should_play_level_introduction = function (arg_36_0)
	-- function 36
	return true
end

AdventureMechanism.uses_random_directors = function (arg_37_0)
	-- function 37
	local get_next_weave = Managers.weave:get_next_weave()

	get_next_weave = get_next_weave or Development.parameter("weave_name")

	return not WeaveSettings.templates[get_next_weave]
end

AdventureMechanism.debug_load_level = function (self, arg_38_1, arg_38_2)
	-- function 38
	local var_38_0 = LevelSettings[arg_38_1]
	local level_transition_handler = Managers.level_transition_handler

	level_transition_handler:set_next_level(arg_38_1, arg_38_2)
	level_transition_handler:promote_next_level_data()

	if not var_38_0 and not var_38_0.hub_level then
		self._next_state = str_3
	else
		self._next_state = str_5
	end

	Managers.mechanism:progress_state()
end

AdventureMechanism.request_vote = function (arg_39_0, arg_39_1)
	-- function 39
	local deed_backend_id = arg_39_1.deed_backend_id

	if not deed_backend_id then
		Managers.deed:select_deed(deed_backend_id, Network.peer_id())
	end

	local var_39_1 = tbl[arg_39_1.request_type]

	var_39_1 = var_39_1 or tbl.default

	if not var_39_1 then
		var_39_1(arg_39_1)
	end
end

AdventureMechanism.override_hub_level = function (self, arg_40_1)
	-- function 40
	self._debug_hub_level_key = arg_40_1
end

AdventureMechanism.get_starting_level = function ()
	-- function 41
	local parameter = Development.parameter("weave_name")

	if not (not parameter and parameter == "false") then
		return WeaveSettings.templates[parameter].objectives[1].level_id
	end

	local hub_level = Managers.backend:get_level_variation_data().hub_level

	hub_level = hub_level or str

	return hub_level
end

AdventureMechanism.reserved_party_id_by_peer = function (arg_42_0, arg_42_1)
	-- function 42
	return 1
end

AdventureMechanism.try_reserve_profile_for_peer_by_mechanism = function (self, arg_43_1, arg_43_2, arg_43_3, arg_43_4, arg_43_5)
	-- function 43
	local reserved_party_id_by_peer = self:reserved_party_id_by_peer(arg_43_2)

	return arg_43_1:try_reserve_profile_for_peer(reserved_party_id_by_peer, arg_43_2, arg_43_3, arg_43_4)
end

AdventureMechanism.entered_mechanism_due_to_switch = function (arg_44_0)
	-- function 44
	Managers.chat:set_chat_enabled(true)
end
