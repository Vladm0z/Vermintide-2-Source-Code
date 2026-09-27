-- chunkname: @scripts/managers/game_mode/game_mechanism_manager.lua

require("scripts/managers/game_mode/mechanisms/adventure_mechanism")

local testify = script_data.testify

testify = not testify and require("scripts/managers/game_mode/game_mechanism_manager_testify")
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
		extra_requirements_function = function (self, arg_1_1)
			-- function 1
			if not script_data.unlock_all_levels then
				return true
			end

			local get_stats = Managers.backend:get_stats()

			for k, v in pairs(MainGameLevels) do
				if LevelSettings[v].game_mode == "adventure" then
					if not self then
						local get_persistent_stat = self:get_persistent_stat(arg_1_1, "completed_levels", v)

						if not (not get_persistent_stat and get_persistent_stat ~= 0) then
							return false
						end
					else
						local var_1_2 = tonumber(get_stats["completed_levels_" .. v])

						var_1_2 = var_1_2 or 0

						if var_1_2 < 1 then
							return false
						end
					end
				end
			end

			local act_scorpion = GameActs.act_scorpion

			for k_2, v_2 in pairs(act_scorpion) do
				if LevelSettings[v_2].game_mode == "adventure" then
					if not self then
						local get_persistent_stat_2 = self:get_persistent_stat(arg_1_1, "completed_levels", v_2)

						if not (not get_persistent_stat_2 and get_persistent_stat_2 ~= 0) then
							return false
						end
					else
						local var_1_5 = tonumber(get_stats["completed_levels_" .. v_2])

						var_1_5 = var_1_5 or 0

						if var_1_5 < 1 then
							return false
						end
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

for k, v in pairs(DLCSettings) do
	local mechanism_settings = v.mechanism_settings

	if not mechanism_settings then
		for k_2, v_2 in pairs(mechanism_settings) do
			if not v_2.file then
				require(v_2.file)
			end

			MechanismSettings[k_2] = v_2
		end
	end
end

GameMechanismManager = class(GameMechanismManager)

local tbl = {
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

local function fn(arg_2_0)
	-- function 2
	if arg_2_0 == "false" then
		return false
	else
		return arg_2_0
	end
end

GameMechanismManager.init = function (self, arg_3_1)
	-- function 3
	self._mechanism_key = arg_3_1
	self._game_mechanism = nil
	self._level_seed = nil
	self._locked_director_functions = nil
	self._locked_director_function_ids = nil
	self._venture_started = false

	self:_init_mechanism()
end

GameMechanismManager.handle_level_load = function (self, arg_4_1)
	-- function 4
	local level_transition_handler = Managers.level_transition_handler
	local get_current_mechanism = level_transition_handler:get_current_mechanism()
	local _mechanism_key = self._mechanism_key

	if not arg_4_1 then
		self._last_mechanism_switch = _mechanism_key
	end

	if not (not self._game_mechanism and _mechanism_key == get_current_mechanism) then
		self:_init_mechanism()
	end

	if not self._network_client then
		local var_4_3 = PEER_ID_TO_CHANNEL[self._server_peer_id]
		local get_current_level_session_id = level_transition_handler:get_current_level_session_id()

		RPC.rpc_level_load_started(var_4_3, get_current_level_session_id)
	end

	if not Managers.party:cleared() then
		self:reset_party_data(self._is_server)
	end
end

GameMechanismManager.create_level_seed = function (arg_5_0)
	-- function 5
	return LevelTransitionHandler.create_level_seed()
end

GameMechanismManager.generate_level_seed = function (self)
	-- function 6
	local generate_level_seed = self._game_mechanism.generate_level_seed

	generate_level_seed = not generate_level_seed and self._game_mechanism:generate_level_seed()

	if not generate_level_seed then
		self._level_seed = generate_level_seed
	else
		print("[LevelTransitionHandler] Generated new level_seed:", generate_level_seed)

		self._level_seed = self:create_level_seed()
	end

	return self._level_seed
end

GameMechanismManager.get_level_seed = function (self, arg_7_1)
	-- function 7
	local get_current_level_seed = Managers.level_transition_handler:get_current_level_seed()

	if not self._game_mechanism.get_level_seed then
		return self._game_mechanism:get_level_seed(get_current_level_seed, arg_7_1)
	else
		return get_current_level_seed
	end
end

GameMechanismManager.get_end_of_level_rewards_arguments = function (self, arg_8_1, arg_8_2, arg_8_3, arg_8_4, arg_8_5, arg_8_6)
	-- function 8
	if not self._game_mechanism.get_end_of_level_rewards_arguments then
		return self._game_mechanism:get_end_of_level_rewards_arguments(arg_8_1, arg_8_2, arg_8_3, arg_8_4, arg_8_5, arg_8_6)
	else
		return {}
	end
end

GameMechanismManager.get_end_of_level_extra_mission_results = function (self)
	-- function 9
	if not self._game_mechanism.get_end_of_level_extra_mission_results then
		return self._game_mechanism:get_end_of_level_extra_mission_results()
	else
		return {}
	end
end

GameMechanismManager.sync_players_session_score = function (self, arg_10_1)
	-- function 10
	local tbl = {}
	local tbl_2 = {}
	local tbl_3 = {}

	if not self._game_mechanism.sync_players_session_score then
		self._game_mechanism:sync_players_session_score(arg_10_1, tbl, tbl_2, tbl_3)
	else
		for k, v in pairs(arg_10_1) do
			tbl[#tbl + 1] = v.peer_id
			tbl_2[#tbl_2 + 1] = v.local_player_id

			local offense = v.group_scores.offense

			for k_2 = 1, #offense do
				tbl_3[#tbl_3 + 1] = offense[k_2].score
			end
		end
	end

	self:send_rpc_clients("rpc_sync_players_session_score", tbl, tbl_2, tbl_3)
	Managers.state.event:trigger("player_session_scores_synced")
end

GameMechanismManager.network_server = function (self)
	-- function 11
	return self._network_server
end

GameMechanismManager.network_client = function (self)
	-- function 12
	return self._network_client
end

GameMechanismManager.network_handler = function (self)
	-- function 13
	local _network_server = self._network_server

	_network_server = _network_server or self._network_client

	return _network_server
end

GameMechanismManager.set_level_seed = function (self, arg_14_1)
	-- function 14
	print("GameMechanismManager setting level seed:", arg_14_1)

	self._level_seed = arg_14_1
end

GameMechanismManager.generate_locked_director_functions = function (arg_15_0, arg_15_1)
	-- function 15
	return (ConflictUtils.generate_conflict_director_locked_functions(arg_15_1))
end

GameMechanismManager.can_spawn_pickup = function (self, arg_16_1, arg_16_2)
	-- function 16
	local _game_mechanism = self._game_mechanism

	if not _game_mechanism and not _game_mechanism.can_spawn_pickup then
		return _game_mechanism:can_spawn_pickup(arg_16_1, arg_16_2)
	end

	return false
end

GameMechanismManager.uses_random_directors = function (self)
	-- function 17
	local _game_mechanism = self._game_mechanism

	if not _game_mechanism and not _game_mechanism.uses_random_directors then
		return _game_mechanism:uses_random_directors()
	end

	return true
end

GameMechanismManager.destroy = function (self)
	-- function 18
	self:_unregister_mechanism_rpcs()

	if not self._game_mechanism.destroy then
		self._game_mechanism:destroy()

		self._game_mechanism = nil
	end

	if not self._network_event_delegate then
		self._network_event_delegate:unregister(self)

		self._network_event_delegate = nil
	end
end

GameMechanismManager.set_profile_synchronizer = function (self, arg_19_1)
	-- function 19
	self._profile_synchronizer = arg_19_1
end

GameMechanismManager.get_level_end_view = function (self)
	-- function 20
	local _game_mechanism = self._game_mechanism

	if not _game_mechanism then
		_game_mechanism = self._game_mechanism.get_level_end_view
		_game_mechanism = not _game_mechanism and self._game_mechanism:get_level_end_view()
	end

	return _game_mechanism
end

GameMechanismManager.get_level_end_view_packages = function (self)
	-- function 21
	local _game_mechanism = self._game_mechanism

	if not _game_mechanism then
		_game_mechanism = self._game_mechanism.get_level_end_view_packages
		_game_mechanism = not _game_mechanism and self._game_mechanism:get_level_end_view_packages()
	end

	return _game_mechanism
end

GameMechanismManager.handle_ingame_enter = function (self, arg_22_1)
	-- function 22
	local _game_mechanism = self._game_mechanism

	if not _game_mechanism and not _game_mechanism.handle_ingame_enter then
		_game_mechanism:handle_ingame_enter(arg_22_1)
	end
end

GameMechanismManager.handle_ingame_exit = function (self, arg_23_1)
	-- function 23
	local _game_mechanism = self._game_mechanism

	if not _game_mechanism and not _game_mechanism.handle_ingame_exit then
		_game_mechanism:handle_ingame_exit(arg_23_1)
	end
end

GameMechanismManager.can_resync_loadout = function (self)
	-- function 24
	local _game_mechanism = self._game_mechanism

	if not _game_mechanism and not _game_mechanism.can_resync_loadout then
		return _game_mechanism:can_resync_loadout()
	else
		return true
	end
end

GameMechanismManager.update_loadout = function (self)
	-- function 25
	local _game_mechanism = self._game_mechanism

	if not _game_mechanism and not _game_mechanism.update_loadout then
		_game_mechanism:update_loadout()
	end
end

GameMechanismManager.network_context_created = function (self, arg_26_1, arg_26_2, arg_26_3, arg_26_4, arg_26_5)
	-- function 26
	printf("[GameMechanismManager] network_context_created (server_peer_id=%s, own_peer_id=%s)", arg_26_2, arg_26_3)

	self._lobby = arg_26_1
	self._server_peer_id = arg_26_2
	self._peer_id = arg_26_3
	self._is_server = arg_26_4

	local _game_mechanism = self._game_mechanism

	if not _game_mechanism and not _game_mechanism.network_context_created then
		_game_mechanism:network_context_created(arg_26_1, arg_26_2, arg_26_3, arg_26_4, arg_26_5)
	end
end

GameMechanismManager.set_network_server = function (self, arg_27_1)
	-- function 27
	self._network_server = arg_27_1

	if not arg_27_1 then
		self._network_client = nil
	end

	if not self._game_mechanism.network_handler_set then
		self._game_mechanism:network_handler_set(arg_27_1)
	end
end

GameMechanismManager.set_network_client = function (self, arg_28_1)
	-- function 28
	self._network_client = arg_28_1

	if not arg_28_1 then
		self._network_server = nil
	end

	if not self._game_mechanism.network_handler_set then
		self._game_mechanism:network_handler_set(arg_28_1)
	end
end

GameMechanismManager.server_peer_id = function (self)
	-- function 29
	return self._server_peer_id
end

GameMechanismManager.is_server = function (self)
	-- function 30
	return self._is_server
end

GameMechanismManager.network_context_destroyed = function (self, arg_31_1)
	-- function 31
	print("[GameMechanismManager] network_context_destroyed")

	self._lobby = nil
	self._server_peer_id = nil
	self._peer_id = nil
	self._is_server = nil

	if not self._game_mechanism and not self._game_mechanism.network_context_destroyed then
		self._game_mechanism:network_context_destroyed()
	end
end

GameMechanismManager.register_rpcs = function (self, arg_32_1)
	-- function 32
	self._network_event_delegate = arg_32_1

	arg_32_1:register(self, unpack(tbl))
	self:_register_mechanism_rpcs()
end

GameMechanismManager._register_mechanism_rpcs = function (self)
	-- function 33
	if not self._network_event_delegate and not self._game_mechanism and not self._game_mechanism.register_rpcs then
		self._game_mechanism:register_rpcs(self._network_event_delegate)
	end
end

GameMechanismManager.unregister_rpcs = function (self)
	-- function 34
	self:_unregister_mechanism_rpcs()

	if not self._network_event_delegate then
		self._network_event_delegate:unregister(self)

		self._network_event_delegate = nil
	end
end

GameMechanismManager._unregister_mechanism_rpcs = function (self)
	-- function 35
	if not self._game_mechanism and not self._game_mechanism.unregister_rpcs then
		self._game_mechanism:unregister_rpcs()
	end
end

GameMechanismManager._setup_mechanism_specific_career_settings = function (self)
	-- function 36
	for k, v in pairs(CareerSettingsOriginal) do
		local mechanism_overrides = v.mechanism_overrides

		if not mechanism_overrides then
			local var_36_1 = mechanism_overrides[self._mechanism_key]

			if not var_36_1 then
				local shallow_copy = table.shallow_copy(v)

				table.merge_recursive(shallow_copy, var_36_1)
				table.merge(CareerSettings[k], shallow_copy)
			end
		end
	end
end

GameMechanismManager._init_mechanism = function (self)
	-- function 37
	local get_current_mechanism = Managers.level_transition_handler:get_current_mechanism()

	print("initializing mechanism to:", get_current_mechanism)
	fassert(MechanismSettings[get_current_mechanism], "[GameMechanismManager] Tried to set unknown mechanism %q", tostring(get_current_mechanism))

	local var_37_1 = MechanismSettings[get_current_mechanism]
	local _mechanism_key = self._mechanism_key

	_mechanism_key = not _mechanism_key and self._mechanism_key ~= get_current_mechanism
	self._mechanism_key = get_current_mechanism

	self:_unregister_mechanism_rpcs()

	if not self._game_mechanism and not _mechanism_key then
		if not self._game_mechanism then
			if not self._game_mechanism.left_mechanism_due_to_switch then
				self._game_mechanism:left_mechanism_due_to_switch()
			end

			if not self._game_mechanism.destroy then
				self._game_mechanism:destroy()

				self._game_mechanism = nil
			end
		end

		self:_setup_mechanism_specific_career_settings()

		self._game_mechanism = rawget(_G, var_37_1.class_name):new(var_37_1)

		if not _mechanism_key and not self._game_mechanism.entered_mechanism_due_to_switch then
			self._game_mechanism:entered_mechanism_due_to_switch()
		end

		local network_handler = self:network_handler()

		if not network_handler and not self._game_mechanism.network_handler_set then
			self._game_mechanism:network_handler_set(network_handler)
		end

		if not _mechanism_key then
			MechanismOverrides.mechanism_switched()
			Managers.backend:commit(true, function ()
				-- function 38
				Managers.backend:switch_mechanism(get_current_mechanism)
				Managers.backend:load_mechanism_loadout(get_current_mechanism)
			end)
		elseif not Managers.backend:get_backend_mirror() then
			Managers.backend:switch_mechanism(get_current_mechanism)
			Managers.backend:load_mechanism_loadout(get_current_mechanism)
		end
	end

	self:_register_mechanism_rpcs()
	self:reset_party_data(false)
	self:clear_stored_challenge_progression_status()
end

GameMechanismManager.mechanism_try_call = function (self, arg_39_1, ...)
	-- function 39
	local _game_mechanism = self._game_mechanism

	if not _game_mechanism then
		local var_39_1 = _game_mechanism[arg_39_1]

		if not var_39_1 then
			return true, var_39_1(_game_mechanism, ...)
		end
	end

	return false
end

GameMechanismManager.rpc_level_load_started = function (self, arg_40_1, arg_40_2)
	-- function 40
	if Managers.level_transition_handler:get_current_level_session_id() ~= arg_40_2 then
		Crashify.print_exception("GameMechanismManager", "rpc_level_load_started received with the wrong current state, ignoring it.")

		return
	end

	local var_40_0 = CHANNEL_TO_PEER_ID[arg_40_1]

	if not (not var_40_0 and var_40_0 ~= "0") then
		Crashify.print_exception("GameMechanismManager", "rpc_level_load_started received with unknown channel_id, ignoring it.")

		return
	end

	local _network_server = self._network_server

	if not _network_server then
		Crashify.print_exception("GameMechanismManager", "rpc_level_load_started as not the server, ignoring it.")

		return
	end

	local flag = _network_server:get_peer_initialized_mechanism(var_40_0) ~= self._mechanism_key

	if not flag then
		print("Mechanism says: a client has initialized the mechanism!", var_40_0)
		_network_server:set_peer_initialized_mechanism(var_40_0, self._mechanism_key)

		local get_state = self._game_mechanism:get_state()
		local states = MechanismSettings[self._mechanism_key].states
		local find = table.find(states, get_state)

		RPC.rpc_set_current_mechanism_state(arg_40_1, find)
	end

	if not self._game_mechanism.sync_mechanism_data then
		self._game_mechanism:sync_mechanism_data(var_40_0, flag)
	end
end

GameMechanismManager.create_host_migration_info = function (self, arg_41_1, arg_41_2)
	-- function 41
	if not self._game_mechanism.create_host_migration_info then
		return self._game_mechanism:create_host_migration_info(arg_41_1, arg_41_2)
	end

	local tbl = {
		host_to_migrate_to = self._network_client.host_to_migrate_to
	}
	local get_difficulty = Managers.state.difficulty:get_difficulty()
	local default_level_key = Managers.mechanism:default_level_key()

	tbl.level_to_load = default_level_key

	local lobby_data = self._network_client.lobby_client:lobby_data("is_private")
	local var_41_4
	local flag

	flag = not IS_PS4 and "n/a" and NetworkLookup.matchmaking_types["n/a"]
	tbl.lobby_data = {
		matchmaking_type = flag,
		is_private = lobby_data,
		difficulty = get_difficulty,
		selected_mission_id = default_level_key,
		mission_id = default_level_key
	}

	return tbl
end

GameMechanismManager.is_final_round = function (self)
	-- function 42
	return self._game_mechanism:is_final_round()
end

GameMechanismManager.on_final_round_won = function (self, arg_43_1, arg_43_2)
	-- function 43
	if not self._game_mechanism.on_final_round_won then
		self._game_mechanism:on_final_round_won(arg_43_1, arg_43_2)
	end
end

GameMechanismManager.request_vote = function (self, arg_44_1, arg_44_2)
	-- function 44
	if not self._game_mechanism.request_vote then
		self._game_mechanism:request_vote(arg_44_1, arg_44_2)
	end
end

GameMechanismManager.game_round_ended = function (self, arg_45_1, arg_45_2, arg_45_3, arg_45_4)
	-- function 45
	self._game_mechanism:game_round_ended(arg_45_1, arg_45_2, arg_45_3, arg_45_4)
end

GameMechanismManager.start_next_round = function (self)
	-- function 46
	local start_next_round, var_46_1, var_46_2 = self._game_mechanism:start_next_round()

	return start_next_round, var_46_1, var_46_2
end

GameMechanismManager.get_current_level_key = function (arg_47_0)
	-- function 47
	return Managers.level_transition_handler:get_current_level_key()
end

GameMechanismManager.get_current_level_keys = function (arg_48_0)
	-- function 48
	return Managers.level_transition_handler:get_current_level_key()
end

GameMechanismManager.game_mechanism = function (self)
	-- function 49
	return self._game_mechanism
end

GameMechanismManager.current_mechanism_name = function (self)
	-- function 50
	return self._mechanism_key
end

GameMechanismManager.get_last_mechanism_switch = function (self)
	-- function 51
	return self._last_mechanism_switch
end

GameMechanismManager.mechanism_setting = function (self, arg_52_1)
	-- function 52
	fassert(self._mechanism_key, "No mechanism set yet.")

	return MechanismSettings[self._mechanism_key][arg_52_1]
end

GameMechanismManager.mechanism_setting_for_title = function (self, arg_53_1)
	-- function 53
	if not self._title_settings then
		self:refresh_mechanism_setting_for_title()
	end

	fassert(self._mechanism_key, "No mechanism set yet.")

	local var_53_0 = self._title_settings[self._mechanism_key]
	local flag = not var_53_0 and var_53_0[arg_53_1]

	if not flag then
		return flag
	end

	return self:mechanism_setting(arg_53_1)
end

GameMechanismManager.refresh_mechanism_setting_for_title = function (self)
	-- function 54
	fassert(Managers.backend:get_backend_mirror(), "Backend not created yet")

	self._title_settings = Managers.backend:get_title_settings()
end

GameMechanismManager.max_party_members = function (self)
	-- function 55
	local party_data = MechanismSettings[self._mechanism_key].party_data

	return Managers.party:max_party_members(party_data)
end

GameMechanismManager.max_instance_members = function (self)
	-- function 56
	fassert(self._mechanism_key, "No mechanism set yet.")

	if not self._game_mechanism.max_instance_members then
		local max_instance_members = self._game_mechanism:max_instance_members(self._lobby)

		assert(max_instance_members > 0, "[GameMechanismManager] At least one must be provided to lobbies.")

		return max_instance_members
	end

	local max_party_members = self:max_party_members()

	assert(max_party_members > 0, "[GameMechanismManager] At least one must be provided to lobbies. Parties is not set up yet.")

	return max_party_members
end

GameMechanismManager.server_universe = function (self)
	-- function 57
	fassert(self._mechanism_key, "No mechanism set yet.")

	return MechanismSettings[self._mechanism_key].server_universe
end

GameMechanismManager.is_packages_loaded = function (self)
	-- function 58
	if not self._game_mechanism.is_packages_loaded then
		return self._game_mechanism:is_packages_loaded()
	end

	return true
end

GameMechanismManager.load_packages = function (self)
	-- function 59
	if not self._game_mechanism.load_packages then
		self._game_mechanism:load_packages()
	end
end

GameMechanismManager.preferred_slot_id = function (self, arg_60_1, arg_60_2, arg_60_3)
	-- function 60
	if not self._game_mechanism and not self._game_mechanism.preferred_slot_id then
		return self._game_mechanism:preferred_slot_id(arg_60_1, arg_60_2, arg_60_3)
	end

	return nil
end

GameMechanismManager.profile_available_for_peer = function (self, arg_61_1, arg_61_2, arg_61_3)
	-- function 61
	local get_profile_index_reservation = self._profile_synchronizer:get_profile_index_reservation(arg_61_1, arg_61_3)

	return not get_profile_index_reservation and get_profile_index_reservation == arg_61_2
end

GameMechanismManager.profile_changed = function (self, arg_62_1, arg_62_2, arg_62_3, arg_62_4, arg_62_5)
	-- function 62
	if not self._game_mechanism and not self._game_mechanism.profile_changed then
		return self._game_mechanism:profile_changed(arg_62_1, arg_62_2, arg_62_3, arg_62_4, arg_62_5)
	end

	return false
end

GameMechanismManager.profile_synchronizer = function (self)
	-- function 63
	return self._profile_synchronizer
end

GameMechanismManager.get_players_session_score = function (self, arg_64_1, arg_64_2, arg_64_3)
	-- function 64
	local var_64_0

	if not self._is_server then
		var_64_0 = self.synced_players_session_score
	end

	if not var_64_0 then
		if not self._game_mechanism.get_players_session_score then
			var_64_0 = self._game_mechanism:get_players_session_score(arg_64_1, arg_64_2, arg_64_3)
		end

		var_64_0 = var_64_0 or ScoreboardHelper.get_grouped_topic_statistics(arg_64_1, arg_64_2, arg_64_3)
	end

	return var_64_0
end

GameMechanismManager.get_prior_state = function (self)
	-- function 65
	return self._game_mechanism:get_prior_state()
end

GameMechanismManager.choose_next_state = function (self, arg_66_1)
	-- function 66
	self._game_mechanism:choose_next_state(arg_66_1)
end

GameMechanismManager.reset_choose_next_state = function (self)
	-- function 67
	self._game_mechanism:reset_choose_next_state()
end

GameMechanismManager.setting = function (self, arg_68_1)
	-- function 68
	return MechanismSettings[self._mechanism_key][arg_68_1]
end

GameMechanismManager.progress_state = function (self, arg_69_1)
	-- function 69
	local progress_state = self._game_mechanism:progress_state()
	local states = MechanismSettings[self._mechanism_key].states
	local find = table.find(states, progress_state)

	fassert(find, "State not found in mechanism settings")

	if not arg_69_1 then
		self:send_rpc_clients("rpc_set_current_mechanism_state", find)
	end
end

GameMechanismManager.get_starting_level = function (self)
	-- function 70
	local get_starting_level

	if not self._game_mechanism.get_starting_level then
		get_starting_level = self._game_mechanism:get_starting_level()

		if not get_starting_level then
			-- Nothing
		end
	end

	get_starting_level = LevelSettings.default_start_level

	::label_70_0::

	return get_starting_level
end

GameMechanismManager.default_level_key = function (self)
	-- function 71
	local loading_context = Boot.loading_context

	loading_context = not loading_context and Boot.loading_context.level_key

	if not loading_context then
		return loading_context
	end

	local var_71_1 = fn(Development.parameter("attract_mode"))

	var_71_1 = not var_71_1 and BenchmarkSettings.auto_host_level

	local var_71_2 = fn(Development.parameter("auto_host_level"))

	var_71_2 = var_71_2 or not Development.parameter("vs_auto_search") and "carousel_hub" and var_71_1 or self:get_starting_level()

	return var_71_2
end

GameMechanismManager.get_loading_tip = function (self)
	-- function 72
	local _game_mechanism = self._game_mechanism

	if not _game_mechanism.get_loading_tip then
		return _game_mechanism:get_loading_tip()
	end

	return nil
end

GameMechanismManager.backend_profiles_loaded = function (self)
	-- function 73
	if not self._game_mechanism.backend_profiles_loaded then
		self._game_mechanism:backend_profiles_loaded()
	end
end

GameMechanismManager.try_reserve_game_server_slots = function (self, arg_74_1, arg_74_2, arg_74_3)
	-- function 74
	local game_mode = Managers.state.game_mode

	if not (not game_mode and game_mode:is_reservable()) then
		print("Rejected game server reservation because game mode denies joining")

		return false
	end

	if not self._game_mechanism.try_reserve_game_server_slots then
		return self._game_mechanism:try_reserve_game_server_slots(arg_74_1, arg_74_2, arg_74_3)
	end

	printf("[GameMechanismManager] Approving slot reservation by default.")

	return true
end

GameMechanismManager.game_server_slot_reservation_expired = function (self, arg_75_1)
	-- function 75
	if not self._game_mechanism.game_server_slot_reservation_expired then
		self._game_mechanism:game_server_slot_reservation_expired(arg_75_1)
	end
end

GameMechanismManager.debug_load_level = function (self, arg_76_1, arg_76_2)
	-- function 76
	if not self._is_server then
		return
	end

	if not self._game_mechanism and not self._game_mechanism.debug_load_level then
		self._game_mechanism:debug_load_level(arg_76_1, arg_76_2)
	else
		local level_transition_handler = Managers.level_transition_handler

		level_transition_handler:set_next_level(arg_76_1, arg_76_2)
		level_transition_handler:promote_next_level_data()
	end
end

GameMechanismManager._on_venture_start = function (self, arg_77_1)
	-- function 77
	self._venture_started = true

	local _is_server = self._is_server
	local var_77_1 = StatisticsDatabase:new()

	Managers.venture.statistics = var_77_1
	Managers.venture.challenge = ChallengeManager:new(var_77_1, _is_server)
	Managers.venture.quickplay = QuickplayManager:new(arg_77_1, _is_server)

	Managers:on_venture_start()

	if not self._game_mechanism.on_venture_start then
		self._game_mechanism:on_venture_start()
	end
end

GameMechanismManager._on_venture_end = function (self)
	-- function 78
	Managers:on_venture_end()

	if not self._game_mechanism.on_venture_end then
		self._game_mechanism:on_venture_end()
	end

	Managers.venture:destroy()

	self._venture_started = false
end

GameMechanismManager.check_venture_start = function (self, arg_79_1)
	-- function 79
	if not self._venture_started then
		self:_on_venture_start(arg_79_1)
	end
end

GameMechanismManager.check_venture_end = function (self, arg_80_1)
	-- function 80
	local get_state = self._game_mechanism:get_state()
	local get_prior_state = self._game_mechanism:get_prior_state()
	local mechanism_setting = self:mechanism_setting("venture_end_states_in")
	local mechanism_setting_2 = self:mechanism_setting("venture_end_states_out")

	if arg_80_1 or self._venture_ended_manually or not self._venture_started and table.contains(mechanism_setting, get_state) and not table.contains(mechanism_setting_2, get_prior_state) then
		self:_on_venture_end()
	end

	self._venture_ended_manually = nil
end

GameMechanismManager.manual_end_venture = function (self)
	-- function 81
	self._venture_ended_manually = true
end

GameMechanismManager.is_venture_over = function (self)
	-- function 82
	if not self._game_mechanism.is_venture_over then
		return self._game_mechanism:is_venture_over()
	end

	local game_mode = Managers.state.game_mode

	return not game_mode and game_mode:is_game_mode_ended()
end

GameMechanismManager.rpc_set_current_mechanism_state = function (self, arg_83_1, arg_83_2)
	-- function 83
	fassert(not self._is_server, "Server handles the state internally, this should only end up on clients.")

	local var_83_0 = MechanismSettings[self._mechanism_key].states[arg_83_2]

	fassert(var_83_0, "No corresponding state_name for state_id (mechanism:%s)", self._mechanism_key)
	print("Received new state from server", var_83_0)
	self._game_mechanism:set_current_state(var_83_0)
end

GameMechanismManager.rpc_carousel_set_local_match = function (self, arg_84_1, arg_84_2)
	-- function 84
	if CHANNEL_TO_PEER_ID[arg_84_1] ~= self._server_peer_id then
		return
	end

	self:mechanism_try_call("set_local_match", arg_84_2)
end

GameMechanismManager.rpc_carousel_set_private_lobby = function (self, arg_85_1, arg_85_2)
	-- function 85
	if CHANNEL_TO_PEER_ID[arg_85_1] ~= self._server_peer_id then
		return
	end

	self:mechanism_try_call("set_private_lobby", arg_85_2)
end

GameMechanismManager.rpc_dedicated_or_player_hosted_search = function (self, arg_86_1, arg_86_2, arg_86_3, arg_86_4)
	-- function 86
	if CHANNEL_TO_PEER_ID[arg_86_1] ~= self._server_peer_id then
		return
	end

	self:mechanism_try_call("set_dedicated_or_player_hosted_search", arg_86_2, arg_86_3, arg_86_4)
end

GameMechanismManager.rpc_reserved_slots_count = function (self, arg_87_1, arg_87_2, arg_87_3)
	-- function 87
	if not self._game_mechanism.num_dedicated_reserved_slots_changed then
		return
	end

	self._game_mechanism:num_dedicated_reserved_slots_changed(arg_87_2, arg_87_3)

	if not self._is_server then
		self._dedicated_server_peer_id = CHANNEL_TO_PEER_ID[arg_87_1]

		self:send_rpc_clients("rpc_reserved_slots_count", arg_87_2, arg_87_3)
	end
end

GameMechanismManager.rpc_party_slots_status = function (self, arg_88_1, arg_88_2, arg_88_3, arg_88_4, arg_88_5)
	-- function 88
	if not self._game_mechanism.dedicated_party_slot_status_changed then
		return
	end

	self._game_mechanism:dedicated_party_slot_status_changed(arg_88_2, arg_88_3, arg_88_4, arg_88_5)

	if not self._is_server then
		self._dedicated_server_peer_id = CHANNEL_TO_PEER_ID[arg_88_1]

		self:send_rpc_clients("rpc_party_slots_status", arg_88_2, arg_88_3, arg_88_4, arg_88_5)
	end
end

GameMechanismManager.rpc_force_start_dedicated_server = function (self, arg_89_1)
	-- function 89
	print("got GameMechanismManager:rpc_force_start_dedicated_server from", arg_89_1)

	if not self._game_mechanism.force_start_dedicated_server then
		self._game_mechanism:force_start_dedicated_server()
	end
end

GameMechanismManager.rpc_switch_level_dedicated_server = function (self, arg_90_1, arg_90_2)
	-- function 90
	print("got GameMechanismManager:rpc_force_start_dedicated_server from", arg_90_2)

	if not self._game_mechanism.switch_level_dedicated_server then
		local flag = Managers.mechanism:dedicated_server_peer_id() == CHANNEL_TO_PEER_ID[arg_90_1]
		local var_90_1

		if arg_90_2 > 0 then
			var_90_1 = NetworkLookup.level_keys[arg_90_2]
		end

		self._game_mechanism:switch_level_dedicated_server(var_90_1, flag)
	end
end

GameMechanismManager.rpc_sync_players_session_score = function (self, arg_91_1, arg_91_2, arg_91_3, arg_91_4)
	-- function 91
	local count = #arg_91_2
	local num = #arg_91_4 / count
	local statistics_db = Managers.player:statistics_db()
	local var_91_3
	local num_stats_per_player = ScoreboardHelper.num_stats_per_player

	if not self._game_mechanism.get_players_session_score then
		var_91_3, num_stats_per_player = self._game_mechanism:get_players_session_score(statistics_db, self._profile_synchronizer)
		num_stats_per_player = num_stats_per_player or ScoreboardHelper.num_stats_per_player
	end

	var_91_3 = var_91_3 or ScoreboardHelper.get_grouped_topic_statistics(statistics_db, self._profile_synchronizer)

	if num_stats_per_player ~= num then
		Crashify.print_exception("GameMechanismManager", "rpc_sync_players_session_score received with mismatching stats_per_player count, probably the host was modded. Ignoring the host score and using client's.")

		self.synced_players_session_score = var_91_3

		return
	end

	if not self._game_mechanism.extract_players_session_score then
		self._game_mechanism:extract_players_session_score(count, num, arg_91_2, arg_91_3, var_91_3, arg_91_4)
	else
		for k, v in pairs(var_91_3) do
			local peer_id = v.peer_id
			local local_player_id = v.local_player_id

			for k_2 = 1, count do
				if not (peer_id ~= arg_91_2[k_2] or local_player_id ~= arg_91_3[k_2]) then
					local offense = v.group_scores.offense
					local num_2 = (k_2 - 1) * num + 1
					local num_3 = 1

					for l = num_2, num_2 + num - 1 do
						offense[num_3].score = arg_91_4[l]
						num_3 = num_3 + 1
					end

					break
				end
			end
		end
	end

	self.synced_players_session_score = var_91_3

	Managers.state.event:trigger("player_session_scores_synced")
end

GameMechanismManager.dedicated_server_peer_id = function (self)
	-- function 92
	return self._dedicated_server_peer_id
end

GameMechanismManager.reset_dedicated_server_peer_id = function (self)
	-- function 93
	self._dedicated_server_peer_id = nil
end

GameMechanismManager.send_rpc_clients = function (self, arg_94_1, ...)
	-- function 94
	local _network_server = self._network_server

	_network_server = not _network_server and self._network_server:get_peers()

	if not _network_server then
		return
	end

	local var_94_1 = RPC[arg_94_1]

	for i, v in ipairs(_network_server) do
		local var_94_2 = PEER_ID_TO_CHANNEL[v]

		if v == self._peer_id or not var_94_2 then
			var_94_1(var_94_2, ...)
		end
	end
end

GameMechanismManager.should_run_tutorial = function (self)
	-- function 95
	return self._game_mechanism:should_run_tutorial()
end

GameMechanismManager.get_custom_lobby_sort = function (self)
	-- function 96
	local get_custom_lobby_sort = self._game_mechanism.get_custom_lobby_sort

	get_custom_lobby_sort = not get_custom_lobby_sort and self._game_mechanism:get_custom_lobby_sort()

	return get_custom_lobby_sort
end

GameMechanismManager.get_state = function (self)
	-- function 97
	return self._game_mechanism:get_state()
end

GameMechanismManager.set_vote_data = function (self, arg_98_1)
	-- function 98
	if not self._game_mechanism.set_vote_data then
		self._game_mechanism:set_vote_data(arg_98_1)
	end
end

GameMechanismManager.reset_party_data = function (self, arg_99_1)
	-- function 99
	local var_99_0

	if not arg_99_1 then
		var_99_0 = Managers.party:gather_party_members()
	end

	Managers.party:clear_parties(arg_99_1)
	self:setup_mechanism_parties()

	if not arg_99_1 then
		for k, v in pairs(var_99_0) do
			local peer_id = v.peer_id
			local local_player_id = v.local_player_id

			Managers.party:assign_peer_to_party(peer_id, local_player_id)
		end
	end
end

GameMechanismManager.setup_mechanism_parties = function (self)
	-- function 100
	local party_data = MechanismSettings[self._mechanism_key].party_data

	Managers.party:register_parties(party_data)

	if not self._game_mechanism.setup_mechanism_parties then
		self._game_mechanism:setup_mechanism_parties(self)
	end
end

GameMechanismManager.get_level_dialogue_context = function (self)
	-- function 101
	if not self._game_mechanism.get_level_dialogue_context then
		return self._game_mechanism:get_level_dialogue_context()
	end

	return {}
end

GameMechanismManager.override_hub_level = function (self, arg_102_1)
	-- function 102
	if not self._game_mechanism and not self._game_mechanism.override_hub_level then
		self._game_mechanism:override_hub_level(arg_102_1)
	end
end

GameMechanismManager.get_player_level_fallback = function (self, arg_103_1)
	-- function 103
	if not self._game_mechanism and not self._game_mechanism.get_player_level_fallback then
		return self._game_mechanism:get_player_level_fallback(arg_103_1)
	end
end

GameMechanismManager.get_slot_reservation_handler = function (self, arg_104_1, arg_104_2)
	-- function 104
	if not self._game_mechanism.get_slot_reservation_handler then
		return self._game_mechanism:get_slot_reservation_handler(arg_104_1, arg_104_2)
	end
end

GameMechanismManager.get_all_reservation_handlers_by_owner = function (self, arg_105_1)
	-- function 105
	if not self._game_mechanism.get_all_reservation_handlers_by_owner then
		return self._game_mechanism:get_all_reservation_handlers_by_owner(arg_105_1)
	end
end

GameMechanismManager.rpc_set_peer_backend_id = function (self, arg_106_1, arg_106_2)
	-- function 106
	if not self._is_server then
		Application.warning("[GameMechanismManager:rpc_set_peer_backend_id] sent rpc to non-server peer")

		return
	end

	if not self._game_mechanism.set_peer_backend_id then
		local var_106_0 = CHANNEL_TO_PEER_ID[arg_106_1]

		self._game_mechanism:set_peer_backend_id(var_106_0, arg_106_2)
	end
end

GameMechanismManager.get_social_wheel_class = function (self)
	-- function 107
	local social_wheel = MechanismSettings[self._mechanism_key].social_wheel

	return not social_wheel and social_wheel and "SocialWheelUI"
end

GameMechanismManager.load_end_screen_resources = function (self)
	-- function 108
	if not self._game_mechanism.load_end_screen_resources then
		self._game_mechanism:load_end_screen_resources()
	end
end

GameMechanismManager.unload_end_screen_resources = function (self)
	-- function 109
	if not self._game_mechanism.unload_end_screen_resources then
		self._game_mechanism:unload_end_screen_resources()
	end
end

GameMechanismManager.is_peer_fully_synced = function (self, arg_110_1)
	-- function 110
	if not self._game_mechanism.is_peer_fully_synced then
		return self._game_mechanism:is_peer_fully_synced(arg_110_1)
	end

	return true
end

GameMechanismManager.update_testify = function (self, arg_111_1, arg_111_2)
	-- function 111
	Testify:poll_requests_through_handler(testify, self)

	if not self._game_mechanism.update_testify then
		self._game_mechanism:update_testify(arg_111_1, arg_111_2)
	end
end

GameMechanismManager.player_joined_party = function (self, arg_112_1, arg_112_2, arg_112_3, arg_112_4, arg_112_5)
	-- function 112
	if not self._game_mechanism.player_joined_party then
		self._game_mechanism:player_joined_party(arg_112_1, arg_112_2, arg_112_3, arg_112_4, arg_112_5)
	end
end

GameMechanismManager.reserved_party_id_by_peer = function (self, arg_113_1)
	-- function 113
	return self._game_mechanism:reserved_party_id_by_peer(arg_113_1)
end

GameMechanismManager.try_reserve_profile_for_peer_by_mechanism = function (self, arg_114_1, arg_114_2, arg_114_3, arg_114_4)
	-- function 114
	return self._game_mechanism:try_reserve_profile_for_peer_by_mechanism(self._profile_synchronizer, arg_114_1, arg_114_2, arg_114_3, arg_114_4)
end

GameMechanismManager.get_persistent_profile_index_reservation = function (self, arg_115_1)
	-- function 115
	if not self._profile_synchronizer then
		local get_persistent_profile_index_reservation, var_115_1 = self._profile_synchronizer:get_persistent_profile_index_reservation(arg_115_1)

		return get_persistent_profile_index_reservation, var_115_1
	end
end

GameMechanismManager.remote_client_connecting = function (self, arg_116_1)
	-- function 116
	if not self._game_mechanism.remote_client_connecting then
		self._game_mechanism:remote_client_connecting(arg_116_1)
	end
end

GameMechanismManager.remote_client_disconnected = function (self, arg_117_1)
	-- function 117
	if not self._game_mechanism.remote_client_disconnected then
		self._game_mechanism:remote_client_disconnected(arg_117_1)
	end
end

local tbl_2 = {}

GameMechanismManager.get_challenge_progression_status = function (arg_118_0, arg_118_1)
	-- function 118
	local get_challenge_progression

	if not Managers.state.achievement then
		get_challenge_progression = Managers.state.achievement:get_challenge_progression(arg_118_1)

		if not get_challenge_progression then
			-- Nothing
		end
	end

	get_challenge_progression = tbl_2

	::label_118_0::

	return get_challenge_progression
end

GameMechanismManager.store_challenge_progression_status = function (self, arg_119_1, arg_119_2)
	-- function 119
	if not self._game_mechanism.store_challenge_progression_status then
		self._game_mechanism:store_challenge_progression_status(arg_119_1, arg_119_2)
	end
end

GameMechanismManager.get_stored_challenge_progression_status = function (self, arg_120_1)
	-- function 120
	if not self._game_mechanism.get_stored_challenge_progression_status then
		return self._game_mechanism:get_stored_challenge_progression_status(arg_120_1)
	end

	return tbl_2
end

GameMechanismManager.clear_stored_challenge_progression_status = function (self, arg_121_1)
	-- function 121
	if not self._game_mechanism.clear_stored_challenge_progression_status then
		return self._game_mechanism:clear_stored_challenge_progression_status(arg_121_1)
	end
end

GameMechanismManager.state_context_set_up = function (self)
	-- function 122
	if not self._game_mechanism.state_context_set_up then
		return self._game_mechanism:state_context_set_up()
	end
end
