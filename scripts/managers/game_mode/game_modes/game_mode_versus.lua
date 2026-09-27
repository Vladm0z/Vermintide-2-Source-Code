-- chunkname: @scripts/managers/game_mode/game_modes/game_mode_versus.lua

require("scripts/managers/game_mode/game_modes/game_mode_base")
require("scripts/managers/game_mode/spawning_components/adventure_spawning")
require("scripts/managers/game_mode/spawning_components/versus_spawning")
require("scripts/managers/game_mode/versus_win_conditions")
require("scripts/managers/game_mode/versus_dark_pact_career_delegator")
require("scripts/managers/admin/dedicated_server_commands")
require("scripts/ui/views/pactsworn_video_transition_view")
require("scripts/managers/game_mode/versus_party_selection_logic")

local scripts_managers_game_mode_mechanisms_reservation_handler_types = require("scripts/managers/game_mode/mechanisms/reservation_handler_types")
local script_data = script_data
local disable_gamemode_end = script_data.disable_gamemode_end

disable_gamemode_end = disable_gamemode_end or Development.parameter("disable_gamemode_end")
script_data.disable_gamemode_end = disable_gamemode_end

local testify = script_data.testify

testify = not testify and require("scripts/managers/game_mode/game_modes/game_mode_versus_testify")
GameModeVersus = class(GameModeVersus, GameModeBase)
GameModeVersus.WAIT_FOR_CLIENTS_TO_LEAVE_TIMEOUT = 30

local tbl = {
	"rpc_rejoin_parties",
	"rpc_sync_next_horde_time",
	"rpc_selectable_careers_request",
	"rpc_selectable_careers_response",
	"rpc_set_playable_boss_can_be_picked"
}

GameModeVersus.init = function (self, arg_1_1, arg_1_2, ...)
	-- function 1
	GameModeVersus.super.init(self, arg_1_1, arg_1_2, ...)

	self._game_end_condition_timer = nil
	self._round_id = nil
	self._objectives_completed = nil
	self._total_main_objectives = nil
	self._training_mode = LevelSettings[self._level_key].training_mode

	local get_side_from_name = Managers.state.side:get_side_from_name("heroes")
	local get_side_from_name_2 = Managers.state.side:get_side_from_name("dark_pact")

	self._mechanism = Managers.mechanism:game_mechanism()
	self._current_mechanism_state = self._mechanism:get_state()
	self._adventure_spawning = AdventureSpawning:new(self._profile_synchronizer, get_side_from_name, self._is_server, self._network_server)
	self._versus_spawning = VersusSpawning:new("dark_pact", self._profile_synchronizer, get_side_from_name_2.available_profiles, self._is_server, arg_1_1, self._dark_pact_career_delegator)
	self.pactsworn_video_transition_view = PactswornVideoTransitionView:new(self._world)

	self:_register_player_spawner(self._adventure_spawning)

	self._active_transporters = {}

	local party = get_side_from_name.party
	local party_2 = get_side_from_name_2.party

	self._bot_players = {
		[party.party_id] = {},
		[party_2.party_id] = {}
	}
	self._horde_timer = math.huge
	self._time_until_next_horde = math.huge
	self._hero_side = get_side_from_name
	self._dark_pact_side = get_side_from_name_2
	self._available_profiles_by_party = {
		[party.party_id] = table.clone(PROFILES_BY_AFFILIATION.heroes),
		[party_2.party_id] = table.clone(PROFILES_BY_AFFILIATION.dark_pact)
	}

	Managers.state.event:register(self, "level_start_local_player_spawned", "event_local_player_spawned", "gm_event_initial_peers_spawned", "gm_event_initial_peers_spawned", "end_screen_ui_complete", "event_end_screen_ui_complete", "event_set_loadout_items", "event_set_loadout_items")

	self._win_conditions = Managers.mechanism:game_mechanism():win_conditions()

	local get_objective_settings = self._mechanism:get_objective_settings()

	self._win_conditions:setup_round(self._is_server, get_objective_settings)

	if not self._is_server then
		self._dark_pact_career_delegator = VersusDarkPactCareerDelegator:new()

		self:_create_game_mode_data_game_object()

		self._lobby_host = self._network_server.lobby_host
		self._profile_requester = self._network_server:profile_requester()

		if not DEDICATED_SERVER then
			self._start_game_timeout_timer = 0
		end
	end

	if not arg_1_1.surge_events and not arg_1_1.enable_horde_surge then
		local get_level_seed = Managers.mechanism:get_level_seed()
		local var_1_6 = arg_1_1.surge_events.events[self._level_key]

		self._horde_surge_handler = HordeSurgeHandler:new(self._is_server, arg_1_2, var_1_6, get_level_seed)
	end

	self._boss_has_been_played = false
	self._initial_peers_spawned = false
	self._local_player_spawned = false
	self.pre_round_start_timer = math.huge
	self._transition_state = "idle"
	self._transition_state_time = 0
	self._hero_bots_enabled = true

	if not self._mechanism:custom_settings_enabled() then
		self._hero_bots_enabled = self._mechanism:get_custom_game_setting("hero_bots_enabled")

		local get_custom_game_setting = self._mechanism:get_custom_game_setting("hero_rescues_enabled")

		get_custom_game_setting = get_custom_game_setting or false
		self._hero_rescues_enabled = get_custom_game_setting
	end
end

GameModeVersus.level_start_objectives = function (self)
	-- function 2
	return self:_get_objective_list_name_current_set()
end

GameModeVersus._create_game_mode_data_game_object = function (self)
	-- function 3
	local network = Managers.state.network
	local get_objective_settings = self._mechanism:get_objective_settings()
	local tbl = {
		go_type = NetworkLookup.go_types.game_mode_data
	}
	local round_timer = get_objective_settings.round_timer

	round_timer = round_timer or 36000
	tbl.round_timer = round_timer

	local create_game_object = network:create_game_object("game_mode_data_carousel", tbl)
	local game = network:game()
	local var_3_6 = callback(self, "game_session_disconnect")

	self._win_conditions:on_game_mode_data_created(game, create_game_object, var_3_6)

	self._go_id = create_game_object
end

GameModeVersus.on_game_mode_data_created = function (self, arg_4_1, arg_4_2)
	-- function 4
	self._win_conditions:on_game_mode_data_created(arg_4_1, arg_4_2)
end

GameModeVersus.on_game_mode_data_destroyed = function (self)
	-- function 5
	self._win_conditions:on_game_mode_data_destroyed()

	self._go_id = nil
end

GameModeVersus.game_session_disconnect = function (self)
	-- function 6
	self._win_conditions:on_game_mode_data_destroyed()

	self._go_id = nil
end

GameModeVersus.cleanup_game_mode_units = function (self)
	-- function 7
	self:_clear_bots(true)
end

GameModeVersus.register_rpcs = function (self, arg_8_1, arg_8_2)
	-- function 8
	GameModeVersus.super.register_rpcs(self, arg_8_1, arg_8_2)
	arg_8_1:register(self, unpack(tbl))
	self._adventure_spawning:register_rpcs(arg_8_1, arg_8_2)
	self._versus_spawning:register_rpcs(arg_8_1, arg_8_2)

	if not self._horde_surge_handler then
		self._horde_surge_handler:register_rpcs(arg_8_1, arg_8_2)
	end

	if not self._win_conditions then
		self._win_conditions:register_rpcs(arg_8_1, arg_8_2)
	end
end

GameModeVersus.unregister_rpcs = function (self)
	-- function 9
	self._adventure_spawning:unregister_rpcs()
	self._versus_spawning:unregister_rpcs()
	self._network_event_delegate:unregister(self)

	if not self._horde_surge_handler then
		self._horde_surge_handler:unregister_rpcs()
	end

	if not self._win_conditions then
		self._win_conditions:unregister_rpcs()
	end

	GameModeVersus.super.unregister_rpcs(self)
end

GameModeVersus.event_local_player_spawned = function (self, arg_10_1)
	-- function 10
	local current_level = LevelHelper:current_level(self._world)
	local str = "versus_activator"

	if not Level.has_volume(current_level, str) then
		Managers.state.entity:system("round_started_system"):set_start_area(str)
	end

	self._is_initial_spawn = arg_10_1

	local _win_conditions = self._win_conditions
	local local_player = Managers.player:local_player()
	local get_side_from_player_unique_id = Managers.state.side:get_side_from_player_unique_id(local_player:unique_id())
	local flag = not get_side_from_player_unique_id and get_side_from_player_unique_id:name() == "heroes"

	if not (not flag and self._local_player_spawned) then
		Managers.transition:force_fade_in()

		self._delayed_fade_out_timer = Managers.time:time("game") + 0.5
	end

	if not (not flag and _win_conditions:is_round_timer_started()) then
		local player_unit = local_player.player_unit

		ScriptUnit.has_extension(player_unit, "career_system"):set_activated_ability_cooldown_paused()
	end

	if not arg_10_1 then
		LevelHelper:flow_event(self._world, "local_player_spawned")

		local format = string.format("versus_%s", get_side_from_player_unique_id:name())

		Managers.state.game_mode:set_object_set_enabled(format, true)
	end

	self._local_player_spawned = true
end

GameModeVersus.party_selection_logic = function (self)
	-- function 11
	return self._versus_party_selection_logic
end

GameModeVersus.hot_join_sync = function (self, arg_12_1)
	-- function 12
	if not self._initial_peers_spawned then
		self._network_transmit:send_rpc("rpc_gm_event_initial_peers_spawned", arg_12_1)
	end

	if not self._versus_party_selection_logic then
		self._versus_party_selection_logic:hot_join_sync(arg_12_1)
	end

	self._win_conditions:hot_join_sync(arg_12_1)

	if not self._horde_surge_handler then
		self._horde_surge_handler:hot_join_sync(arg_12_1)
	end

	if self._game_mode_state == "match_running_state" then
		local str = "round_started_set_" .. self._mechanism:get_current_set()

		self._network_transmit:send_rpc_clients("rpc_trigger_level_event", str)
		self._network_transmit:send_rpc("rpc_trigger_level_event", arg_12_1, "remove_safe_zone_wall")
	end
end

GameModeVersus.destroy = function (self)
	-- function 13
	if not self._is_server then
		self._dark_pact_career_delegator:destroy()
	end

	if not self._versus_party_selection_logic then
		self._versus_party_selection_logic:destroy()

		self._versus_party_selection_logic = nil
	end

	local event = Managers.state.event

	if not event then
		event:unregister("level_start_local_player_spawned", self)
		event:unregister("gm_event_initial_peers_spawned", self)
		event:unregister("end_screen_ui_complete", self)
		event:unregister("event_set_loadout_items", self)
	end
end

GameModeVersus.evaluate_end_conditions = function (self, arg_14_1, arg_14_2, arg_14_3)
	-- function 14
	repeat
		if not (not script_data.auto_complete_rounds and self._game_mode_state == "match_running_state" or self._game_mode_state ~= "pre_start_round_state") then
			break
		end

		if self._training_mode or not script_data.disable_gamemode_end then
			return false
		end

		if not (arg_14_1 or self._level_completed or self._level_failed) then
			return false
		end
	until true

	local flag = true
	local flag_2 = false
	local is_round_timer_over = self._win_conditions:is_round_timer_over()
	local all_objectives_completed = Managers.state.entity:system("objective_system"):all_objectives_completed()
	local party_won_early = self._win_conditions.party_won_early
	local side_is_dead = GameModeHelper.side_is_dead("heroes", flag)
	local side_is_disabled = GameModeHelper.side_is_disabled("heroes")
	local flag_3 = side_is_dead or side_is_disabled
	local flag_4 = Managers.state.side:get_party_from_side_name("dark_pact").num_used_slots == 0

	if not script_data.disable_gamemode_end_hero_check then
		flag_3 = false
		flag_4 = false
	end

	local _level_failed

	if not self._lose_condition_disabled then
		if not (flag_3 or flag_4) then
			-- Nothing
		end

		::label_14_1::

		_level_failed = self._level_failed

		if not _level_failed then
			-- Nothing
		end
	end

	if not (is_round_timer_over or all_objectives_completed or party_won_early) then
		-- Nothing
	end

	::label_14_4::

	_level_failed = script_data.auto_complete_rounds
	_level_failed = _level_failed or false

	::label_14_5::

	if not self._level_completed then
		local _level_complete_timer = self._level_complete_timer

		_level_complete_timer = _level_complete_timer or arg_14_3 + 0.4
		self._level_complete_timer = _level_complete_timer
		flag_2 = arg_14_3 >= self._level_complete_timer

		if not self._last_hero_down_riser_played then
			Managers.state.entity:system("audio_system"):play_2d_audio_event("Play_versus_hud_last_hero_down_riser")

			self._last_hero_down_riser_played = true
		end
	elseif not self:is_about_to_end_game_early() then
		if not _level_failed and not self._game_end_condition_timer then
			if arg_14_3 > self._game_end_condition_timer then
				flag_2 = true
			end
		else
			if not self._last_hero_down_riser_played then
				Managers.state.entity:system("audio_system"):play_2d_audio_event("Stop_versus_hud_last_hero_down_riser_interrupted")

				self._last_hero_down_riser_played = false
			end

			self:set_about_to_end_game_early(nil)

			self._game_end_condition_timer = nil
		end
	elseif not _level_failed then
		self:set_about_to_end_game_early(true)
		Managers.state.entity:system("audio_system"):play_2d_audio_event("Play_versus_hud_last_hero_down_riser")

		self._last_hero_down_riser_played = true

		if not script_data.auto_complete_rounds then
			self._game_end_condition_timer = arg_14_3
		elseif not side_is_dead then
			self._game_end_condition_timer = arg_14_3 + GameModeSettings.versus.lose_condition_time_dead
		else
			self._game_end_condition_timer = arg_14_3 + GameModeSettings.versus.lose_condition_time
		end
	end

	if not flag_2 then
		local _get_end_reason, var_14_12 = self:_get_end_reason(party_won_early)
		local _handle_round_end = self:_handle_round_end(_get_end_reason, var_14_12, all_objectives_completed)

		self._mechanism:server_decide_side_order()

		if DEDICATED_SERVER or not self._mechanism:is_hosting_versus_custom_game() then
			Managers.party:server_update_all_client_friend_parties()
		end

		self._level_complete_timer = nil
		self._game_end_condition_timer = nil
		self._round_timer = nil

		self:change_game_mode_state("post_round_state")

		return true, _handle_round_end, var_14_12
	else
		return false
	end
end

GameModeVersus._handle_round_end = function (self, arg_15_1, arg_15_2, arg_15_3)
	-- function 15
	local parameter = Development.parameter("versus_quick_match_end")

	parameter = parameter or self._current_mechanism_state ~= "round_2" or self._mechanism:is_last_set()

	local party_id = Managers.state.side:get_side_from_name("heroes").party.party_id
	local flag = not arg_15_2 and arg_15_2.party_id == party_id or false
	local flag_2 = arg_15_3 or flag

	if not (arg_15_1 == "party_one_won_early" or arg_15_1 ~= "party_two_won_early") then
		self:_trigger_early_win_vo(arg_15_2.party_id)
	elseif not parameter then
		arg_15_1 = self._win_conditions:get_match_results()

		if arg_15_1 == "draw" then
			self:_trigger_draw_vo()
		end
	elseif not flag_2 then
		Managers.state.entity:system("dialogue_system"):trigger_mission_giver_event("vs_mg_heroes_team_wipe")
	end

	self:_server_on_round_over(flag_2)
	self:_round_end_telemetry()

	if arg_15_1 ~= "round_end" then
		self:_match_end_telemetry(arg_15_1)
	end

	return arg_15_1
end

GameModeVersus._get_end_reason = function (self, arg_16_1)
	-- function 16
	local str = "round_end"
	local var_16_1

	if not arg_16_1 then
		local var_16_2
		local update_early_win_conditions

		update_early_win_conditions, arg_16_1 = self._win_conditions:update_early_win_conditions()
	end

	if not arg_16_1 then
		str = arg_16_1.party_id ~= 1 or not "party_one_won_early" or "party_two_won_early"
		var_16_1 = arg_16_1
	end

	return str, var_16_1
end

GameModeVersus.ready_to_transition = function (self)
	-- function 17
	local flag = self._current_mechanism_state ~= "round_2" or not self._mechanism:should_start_next_set()

	if flag or not self._win_conditions.party_won_early then
		self._network_transmit:send_rpc_clients("rpc_rejoin_parties")

		if not DEDICATED_SERVER then
			self._transition_state = "versus_migration"
		else
			self._transition_state = "wait_until_empty"
			self._transition_state_time = 0
		end
	else
		self._transition_state = "next_level"

		Managers.level_transition_handler:promote_next_level_data()
	end

	printf("[GameModeVersus] Ready to transition. _transition_state: %s, _is_server: %s, all_rounds_played: %s, party_won-early: %s", self._transition_state, self._is_server, flag, self._win_conditions.party_won_early)
end

GameModeVersus.wanted_transition = function (self)
	-- function 18
	local _transition_state = self._transition_state

	if _transition_state == "next_level" then
		return "complete_level"
	elseif _transition_state == "restart_game_server" then
		return "restart_game_server"
	elseif _transition_state == "quit_game" then
		return "quit_game"
	elseif _transition_state == "versus_migration" then
		return "versus_migration"
	end
end

GameModeVersus.server_character_selection_completed = function (self)
	-- function 19
	if not self._settings.display_parading_view then
		self:change_game_mode_state("player_team_parading_state")
	else
		self:change_game_mode_state("pre_start_round_state")
	end
end

GameModeVersus.pre_update = function (self, arg_20_1, arg_20_2)
	-- function 20
	local _game_mode_state = self._game_mode_state

	if not self._is_server and not self:is_in_round_state() then
		self:_handle_bots(arg_20_1, arg_20_2)
	end

	if not self._versus_party_selection_logic then
		self._versus_party_selection_logic:pre_update(arg_20_1, arg_20_2)
	end
end

GameModeVersus.player_ready = function (self)
	-- function 21
	local _local_player_spawned = self._local_player_spawned

	_local_player_spawned = not _local_player_spawned and not self._delayed_fade_out_timer

	return _local_player_spawned
end

GameModeVersus.update = function (self, arg_22_1, arg_22_2)
	-- function 22
	if not self._is_server then
		self._dark_pact_career_delegator:update()
		self:_update_hero_rushing(arg_22_1)
	else
		self:_client_update(arg_22_1, arg_22_2)
	end

	if not (not self._delayed_fade_out_timer and not (arg_22_1 > self._delayed_fade_out_timer)) then
		Managers.transition:fade_out(GameSettings.transition_fade_out_speed)

		self._delayed_fade_out_timer = nil
	end

	if not self._initial_peers_ready then
		local _game_mode_state = self._game_mode_state

		if not self:is_in_round_state() then
			self._adventure_spawning:update(arg_22_1, arg_22_2)

			if _game_mode_state == "match_running_state" then
				-- Nothing
			end
		end

		if not self.pactsworn_video_transition_view then
			self.pactsworn_video_transition_view:update(arg_22_2)
		end
	end

	if not script_data.testify then
		Testify:poll_requests_through_handler(testify, self)
	end
end

local tbl_2 = {}

GameModeVersus._clear_profile_reservations = function (self, arg_23_1)
	-- function 23
	local var_23_0 = tbl_2

	if not arg_23_1 then
		var_23_0[1] = arg_23_1
	else
		var_23_0 = Managers.party:game_participating_parties()
	end

	for i = 1, #var_23_0 do
		local var_23_1 = var_23_0[i]
		local _profile_synchronizer = self._profile_synchronizer
		local occupied_slots = var_23_1.occupied_slots

		for j = 1, #occupied_slots do
			local var_23_4 = occupied_slots[j]
			local peer_id = var_23_4.peer_id
			local local_player_id = var_23_4.local_player_id

			if not _profile_synchronizer:profile_by_peer(peer_id, local_player_id) then
				_profile_synchronizer:unassign_profiles_of_peer(peer_id, local_player_id)
			end

			_profile_synchronizer:clear_profile_index_reservation(peer_id, true)
		end
	end
end

GameModeVersus._game_mode_state_changed = function (self, arg_24_1, arg_24_2)
	-- function 24
	if self._current_mechanism_state == "round_1" then
		self._round_id = 1
	else
		self._round_id = 2
	end

	if not self._is_server then
		self._start_game_timeout_timer = 0
	end

	if arg_24_1 == "waiting_for_players_to_join" then
		self._mechanism:increment_total_rounds_started()
	elseif arg_24_1 == "character_selection_state" then
		if not self._is_server then
			self:_clear_profile_reservations()
		end

		self._versus_party_selection_logic = VersusPartySelectionLogic:new(self._is_server, self._settings, self._network_server, self._profile_synchronizer, self._network_event_delegate, self._network_transmit)

		self._mechanism:make_profiles_reservable()
		Managers.ui:handle_transition("versus_party_char_selection_view", {
			menu_state_name = "character"
		})

		if not DEDICATED_SERVER then
			self:_disable_side_object_sets()
		end

		self:_stop_advertise_playing()

		if not self._mechanism:custom_settings_enabled() then
			self:_custom_settings_telemetry()
		end
	elseif arg_24_1 == "player_team_parading_state" then
		if not (arg_24_2 ~= "character_selection_state") then
			self._versus_party_selection_logic = VersusPartySelectionLogic:new(self._is_server, self._settings, self._network_server, self._profile_synchronizer, self._network_event_delegate, self._network_transmit)
		end

		local _get_parading_screen_duration = self:_get_parading_screen_duration()

		Managers.ui:handle_transition("versus_team_parading_view", {
			menu_state_name = "parading",
			duration = _get_parading_screen_duration
		})

		self._parading_timer = Managers.time:time("game") + _get_parading_screen_duration

		self:_stop_advertise_playing()
	elseif arg_24_1 == "pre_start_round_state" then
		if not self._versus_party_selection_logic then
			self._versus_party_selection_logic:destroy()

			self._versus_party_selection_logic = nil
		end

		self:_advertise_playing()
		self:_update_profiles()
		self:_spawn_pact_sworn("dark_pact")
		self:_init_pact_sworn_camera_state()
		self:_start_objective()
		Managers.state.event:trigger("versus_pre_start_initialized")
		Managers.ui:handle_transition("exit_menu", {
			use_fade = true,
			fade_in_speed = GameSettings.transition_fade_in_speed
		})

		if not self._is_server then
			Managers.state.entity:system("ghost_mode_system"):set_active(true)
		end
	elseif arg_24_1 == "match_running_state" then
		if not DEDICATED_SERVER then
			self:_round_start_telemetry()
		end

		if not (arg_24_2 ~= "pre_start_round_state") then
			self:_init_pact_sworn_camera_state()
			self:_advertise_playing()
		end

		if not self._is_server then
			Managers.state.entity:system("ghost_mode_system"):set_active(true)
		end
	elseif arg_24_1 == "post_round_state" then
		self:play_sound("Stop_versus_hud_last_hero_down_riser")
		self:_register_disabled_as_eliminiations()
		self._win_conditions:round_ended()
		self:_stop_advertise_playing()
	end
end

GameModeVersus._advertise_playing = function (arg_25_0)
	-- function 25
	return
end

GameModeVersus._stop_advertise_playing = function (arg_26_0)
	-- function 26
	if not DEDICATED_SERVER then
		local network_handler = Managers.mechanism:network_handler()

		if not network_handler.lobby_client and not network_handler.lobby_client.stop_advertise_playing then
			network_handler.lobby_client:stop_advertise_playing()
		end
	end
end

GameModeVersus._update_profiles = function (self)
	-- function 27
	if not self._is_server then
		return
	end

	local parties = Managers.party:parties()

	for i = 1, #parties do
		local var_27_1 = parties[i]

		if not var_27_1.game_participating then
			local occupied_slots = var_27_1.occupied_slots

			for j = 1, #occupied_slots do
				local var_27_3 = occupied_slots[j]

				self:_update_profile_in_party(var_27_3.peer_id, var_27_3.local_player_id, var_27_1.party_id)
			end
		end
	end
end

GameModeVersus._init_pact_sworn_camera_state = function (arg_28_0)
	-- function 28
	local get_local_player_party = Managers.party:get_local_player_party()
	local var_28_1 = Managers.state.side.side_by_party[get_local_player_party]

	if not (not var_28_1 and var_28_1:name() ~= "dark_pact") then
		local local_player = Managers.player:local_player()

		CharacterStateHelper.change_camera_state(local_player, "observer", {
			input_service_name = "dark_pact_selection"
		})
	end
end

GameModeVersus._spawn_pact_sworn = function (self)
	-- function 29
	local system = Managers.state.entity:system("versus_horde_ability_system")
	local get_party_from_name = Managers.party:get_party_from_name("dark_pact")
	local num = 0
	local occupied_slots = get_party_from_name.occupied_slots

	for i = 1, #occupied_slots do
		local var_29_4 = occupied_slots[i]
		local peer_id = var_29_4.peer_id
		local local_player_id = var_29_4.local_player_id

		self._versus_spawning:setup_data(peer_id, local_player_id)

		if not self._is_server then
			self._versus_spawning:set_spawn_state(peer_id, local_player_id, "w8_for_profile", 0, num, true)
			system:server_register_peer(peer_id)
		end
	end
end

GameModeVersus.assign_temporary_dark_pact_profile = function (self, arg_30_1)
	-- function 30
	local vs_undecided = PROFILES_BY_NAME.vs_undecided

	self:set_profile(arg_30_1, vs_undecided.index, 1, false)
end

GameModeVersus.round_started = function (self)
	-- function 31
	if not self._is_server then
		Managers.state.entity:system("dialogue_system"):queue_mission_giver_event("vs_mg_heroes_left_safe_room")
	end

	Managers.state.entity:system("versus_horde_ability_system"):on_round_started()
end

GameModeVersus.server_update = function (self, arg_32_1, arg_32_2)
	-- function 32
	GameModeVersus.super.server_update(self, arg_32_1, arg_32_2)

	local get_slot_reservation_handler = self._mechanism:get_slot_reservation_handler(Network.peer_id(), scripts_managers_game_mode_mechanisms_reservation_handler_types.session)

	if not DEDICATED_SERVER then
		self:_handle_dedicated_input(arg_32_1, arg_32_2)
	end

	if not get_slot_reservation_handler and not get_slot_reservation_handler.handle_dangling_peers then
		get_slot_reservation_handler:handle_dangling_peers()
	end

	if not self._initial_peers_ready then
		if not self._initial_peers_spawned then
			self:_update_initial_peers_spawned()
		end

		self._win_conditions:server_update(arg_32_1, arg_32_2)
	end

	local _game_mode_state = self._game_mode_state

	if _game_mode_state == "initial_state" then
		if not DEDICATED_SERVER then
			if not get_slot_reservation_handler:is_empty() then
				self:change_game_mode_state("dedicated_server_abort_game")
			else
				self._mechanism:signal_reservers_to_join(arg_32_1, self._network_server)
				self:change_game_mode_state("waiting_for_players_to_join")
			end
		else
			self:change_game_mode_state("waiting_for_players_to_join")
		end
	elseif _game_mode_state == "waiting_for_players_to_join" then
		self._start_game_timeout_timer = self._start_game_timeout_timer + arg_32_2

		local members_map = self._network_server.lobby_host:members():members_map()
		local DEDICATED_SERVER = DEDICATED_SERVER

		if not DEDICATED_SERVER then
			DEDICATED_SERVER = get_slot_reservation_handler:is_all_reserved_peers_joined(members_map)
			DEDICATED_SERVER = not DEDICATED_SERVER and self._initial_peers_ready
		end

		local flag = not not DEDICATED_SERVER or self._initial_peers_ready

		if DEDICATED_SERVER or not flag then
			if not (self._current_mechanism_state ~= "round_1" or self._mechanism:get_current_set() ~= 1) then
				if not self._settings.display_character_picking_view then
					self:change_game_mode_state("character_selection_state")
				end
			elseif not self._profile_synchronizer:all_synced() then
				self:change_game_mode_state("pre_start_round_state")
			end
		elseif not self:_start_game_timeout() then
			self._start_game_timeout_timer = 0

			for k, v in pairs(members_map) do
				if not self._network_server:is_peer_ready(k) then
					printf("[game_mode_versus] kicking timed out peer %s in state %s", k, self._game_mode_state)
					self._network_server:kick_peer(k)
				end
			end
		end
	elseif _game_mode_state == "dedicated_server_abort_game" then
		self._network_server:all_client_peers_disconnected()

		if not self._network_server:all_client_peers_disconnected() then
			if not script_data.testify then
				self._transition_state = "restart_game_server"
			elseif not self:_delay_abort_game(arg_32_1) then
				-- Nothing
			else
				self._transition_state = "quit_game"
			end
		end
	elseif _game_mode_state == "character_selection_state" then
		-- Nothing
	elseif _game_mode_state == "player_team_parading_state" then
		if arg_32_1 > self._parading_timer then
			self:change_game_mode_state("pre_start_round_state")
		end
	elseif _game_mode_state == "pre_start_round_state" then
		self._adventure_spawning:server_update(arg_32_1, arg_32_2)
		self._versus_spawning:update(arg_32_1, arg_32_2)

		local ceil = math.ceil(self.pre_round_start_timer - arg_32_1)

		if not self._initial_peers_spawned then
			if not self._time_left then
				self._time_left = ceil
			end

			if not (not self._is_server and self._pre_round_start_vo) then
				local system = Managers.state.entity:system("dialogue_system")

				if not system:has_local_player_moved_from_start_position() then
					self._pre_round_start_vo = true

					system:queue_mission_giver_event("vs_mg_round_start")
				end
			end

			if ceil < self._time_left then
				self._time_left = ceil

				if not (not self._is_server and DEDICATED_SERVER) then
					Managers.state.event:trigger("ui_update_start_round_counter", ceil)
					Managers.state.event:trigger("ui_tab_update_start_round_counter", ceil)
				end

				Managers.state.network.network_transmit:send_rpc_clients("rpc_update_start_round_countdown_timer", ceil)
			end
		end

		if not (arg_32_1 > self.pre_round_start_timer) or not self._initial_peers_spawned then
			local current_level = LevelHelper:current_level(self._world)
			local str = "round_started_set_" .. self._mechanism:get_current_set()

			Level.trigger_event(current_level, str)
			Managers.state.network.network_transmit:send_rpc_clients("rpc_trigger_level_event", str)
			Level.trigger_event(current_level, "remove_safe_zone_wall")
			Managers.state.network.network_transmit:send_rpc_clients("rpc_trigger_level_event", "remove_safe_zone_wall")
			self:change_game_mode_state("match_running_state")

			if not (not self._is_server and DEDICATED_SERVER) then
				Managers.state.event:trigger("ui_round_started")
			end

			Managers.state.network.network_transmit:send_rpc_clients("rpc_ui_round_started")

			self._time_left = nil
		end
	elseif _game_mode_state == "match_running_state" then
		self._adventure_spawning:server_update(arg_32_1, arg_32_2)
		self._versus_spawning:update(arg_32_1, arg_32_2)

		if not self._horde_surge_handler then
			self._horde_surge_handler:server_update(arg_32_1, arg_32_2)
		end
	elseif _game_mode_state == "post_round_state" then
		-- Nothing
	else
		fassert(false, "Unknown state", _game_mode_state)
	end

	if not DEDICATED_SERVER and not self._settings.allow_hotjoining_ongoing_game and not self._settings.allowed_hotjoin_states[_game_mode_state] then
		self._mechanism:signal_reservers_to_join(arg_32_1, self._network_server)
	end

	if self._transition_state == "wait_until_empty" then
		self._transition_state_time = self._transition_state_time + arg_32_2

		if (self._transition_state_time > GameModeVersus.WAIT_FOR_CLIENTS_TO_LEAVE_TIMEOUT or not self._network_server:all_client_peers_disconnected()) and not self:_delay_abort_game(arg_32_1) then
			-- Nothing
		else
			self._transition_state = "quit_game"
		end
	end
end

local num = 30

GameModeVersus._delay_abort_game = function (self, arg_33_1)
	-- function 33
	local batch_in_flight = Managers.telemetry:batch_in_flight()
	local has_events_to_post = Managers.telemetry:has_events_to_post()

	if not (batch_in_flight or has_events_to_post) then
		local _delay_abort_game_timer = self._delay_abort_game_timer

		_delay_abort_game_timer = _delay_abort_game_timer or arg_33_1 + num
		self._delay_abort_game_timer = _delay_abort_game_timer
	end

	if not (not has_events_to_post and batch_in_flight) then
		Managers.telemetry:post_batch()
	end

	local _delay_abort_game_timer_2 = self._delay_abort_game_timer

	_delay_abort_game_timer_2 = not _delay_abort_game_timer_2 and arg_33_1 < self._delay_abort_game_timer

	return _delay_abort_game_timer_2
end

GameModeVersus._client_update = function (self, arg_34_1, arg_34_2)
	-- function 34
	self._win_conditions:client_update(arg_34_1, arg_34_2)

	if self._game_mode_state == "match_running_state" then
		-- Nothing
	end

	if not self._horde_surge_handler then
		self._horde_surge_handler:client_update(arg_34_1, arg_34_2)
	end

	if not self.pactsworn_video_transition_view then
		self.pactsworn_video_transition_view:update(arg_34_2)
	end
end

GameModeVersus._start_game_timeout = function (self)
	-- function 35
	local num = 10

	if self._game_mode_state == "waiting_for_players_to_join" then
		num = 120
	end

	return num < self._start_game_timeout_timer
end

GameModeVersus._update_initial_peers_spawned = function (arg_36_0)
	-- function 36
	local flag = true
	local player = Managers.player
	local occupied_slots = Managers.party:get_party_from_name("heroes").occupied_slots

	for i = 1, #occupied_slots do
		local var_36_3 = occupied_slots[i]
		local peer_id = var_36_3.peer_id
		local local_player_id = var_36_3.local_player_id
		local player_2 = player:player(peer_id, local_player_id)

		if not Unit.alive(player_2.player_unit) then
			flag = false
		end
	end

	if not flag then
		Managers.state.game_mode:trigger_event("initial_peers_spawned")
	end
end

GameModeVersus._handle_dedicated_input = function (arg_37_0, arg_37_1, arg_37_2)
	-- function 37
	CommandWindow.update()

	local read_line = CommandWindow.read_line()

	if not read_line then
		Managers.admin:execute_command(read_line)
	end
end

GameModeVersus.all_peers_ready = function (arg_38_0)
	-- function 38
	GameModeVersus.super.all_peers_ready(arg_38_0)
end

GameModeVersus.complete_level = function (self, arg_39_1)
	-- function 39
	self._level_completed = true
end

GameModeVersus.FAIL_LEVEL = function (self)
	-- function 40
	self._level_failed = true
end

GameModeVersus.evaluate_end_condition_outcome = function (arg_41_0, arg_41_1, arg_41_2)
	-- function 41
	if not (DEDICATED_SERVER or arg_41_1 ~= nil) then
		return false, false
	end

	local flag = false
	local flag_2 = false
	local network_id = arg_41_2:network_id()
	local local_player_id = arg_41_2:local_player_id()
	local get_party_from_player_id = Managers.party:get_party_from_player_id(network_id, local_player_id)

	if not (arg_41_1 == "party_one_won" or arg_41_1 ~= "party_one_won_early") then
		if get_party_from_player_id.party_id == 1 then
			flag = true
		elseif get_party_from_player_id.party_id == 2 then
			flag_2 = true
		end
	elseif not (arg_41_1 == "party_two_won" or arg_41_1 ~= "party_two_won_early") then
		if get_party_from_player_id.party_id == 1 then
			flag_2 = true
		elseif get_party_from_player_id.party_id == 2 then
			flag = true
		end
	end

	return flag, flag_2, arg_41_1
end

GameModeVersus.gm_event_end_conditions_met = function (self, arg_42_1, arg_42_2, arg_42_3)
	-- function 42
	local system = Managers.state.entity:system("objective_system")

	self._objectives_completed = system:num_completed_main_objectives()
	self._total_main_objectives = system:num_main_objectives()
	self._end_reason = arg_42_1
end

GameModeVersus.gm_event_initial_peers_spawned = function (self)
	-- function 43
	local var_43_0

	if not (Managers.mechanism:game_mechanism():get_current_set() == 1) then
		var_43_0 = Managers.state.game_mode:setting("initial_set_pre_start_duration")
	else
		var_43_0 = Managers.state.game_mode:setting("pre_start_round_duration")
	end

	self._pre_start_round_countdown = var_43_0
	self.pre_round_start_timer = Managers.time:time("game") + var_43_0
	self._initial_peers_spawned = true
end

GameModeVersus.initial_peers_spawned = function (self)
	-- function 44
	return self._initial_peers_spawned
end

GameModeVersus.get_extra_observer_units = function (self, arg_45_1)
	-- function 45
	local var_45_0

	if not Managers.state.game_mode:is_round_started() then
		local get_current_spawn_group = Managers.mechanism:game_mechanism():get_current_spawn_group()
		local get_spawn_point, var_45_3, var_45_4 = self._versus_spawning:get_spawn_point(get_current_spawn_group, arg_45_1)

		if not var_45_4 then
			var_45_0 = {
				var_45_4
			}
		end
	end

	return var_45_0
end

GameModeVersus._player_entered_party = function (self, arg_46_1, arg_46_2, arg_46_3)
	-- function 46
	local name = arg_46_2:name()

	if not (not arg_46_3 and not arg_46_3.local_player and name ~= "heroes") then
		local peer_id = arg_46_3.peer_id
		local local_player_id = arg_46_3:local_player_id()
		local get_player_status = Managers.party:get_player_status(peer_id, local_player_id)

		if not get_player_status.preferred_profile_index then
			local profile_by_peer, var_46_5 = self._profile_synchronizer:profile_by_peer(peer_id, local_player_id)

			get_player_status.preferred_profile_index = profile_by_peer
			get_player_status.preferred_career_index = var_46_5
		end
	end
end

GameModeVersus.player_entered_game_session = function (self, arg_47_1, arg_47_2, arg_47_3)
	-- function 47
	GameModeVersus.super.player_entered_game_session(self, arg_47_1, arg_47_2, arg_47_3)

	local party = Managers.party
	local handle_party_assignment_for_joining_peer = self._mechanism:handle_party_assignment_for_joining_peer(arg_47_1, arg_47_2)

	printf("[GameModeVersus] player_entered_game_session: %s:%s, party_id: %s", arg_47_1, arg_47_2, handle_party_assignment_for_joining_peer)

	local update_wanted_hero_character, var_47_3 = self._mechanism:update_wanted_hero_character(arg_47_1, arg_47_2, handle_party_assignment_for_joining_peer)
	local var_47_4 = self._bot_players[handle_party_assignment_for_joining_peer]

	if not (not var_47_4 and not (#var_47_4 > 0)) then
		if not self._settings.duplicate_hero_profiles_allowed then
			self:_remove_last_added_bot(handle_party_assignment_for_joining_peer)
		else
			local flag = true

			self:_remove_bot_by_profile(handle_party_assignment_for_joining_peer, update_wanted_hero_character, flag)
		end
	end

	local get_party_from_player_id, var_47_7 = Managers.party:get_party_from_player_id(arg_47_1, arg_47_2)

	if handle_party_assignment_for_joining_peer ~= var_47_7 then
		party:request_join_party(arg_47_1, arg_47_2, handle_party_assignment_for_joining_peer)
	elseif not self._mechanism:profiles_reservable() then
		self:_update_profile_in_party(arg_47_1, arg_47_2, handle_party_assignment_for_joining_peer)
	end
end

GameModeVersus.player_left_game_session = function (self, arg_48_1, arg_48_2)
	-- function 48
	if table.size(self._network_server.peer_state_machines) - 1 <= 0 then
		self:change_game_mode_state("dedicated_server_abort_game")
	end
end

GameModeVersus._assign_peer_to_wanted_hero_profile = function (self, arg_49_1, arg_49_2, arg_49_3)
	-- function 49
	local get_player_status = Managers.party:get_player_status(arg_49_1, arg_49_2)

	assert(not get_player_status.is_bot, "this should not be called on a bot, due to profile reservations ")

	local get_persistent_profile_index_reservation, var_49_2 = Managers.mechanism:get_persistent_profile_index_reservation(arg_49_1)
	local update_wanted_hero_character, var_49_4, var_49_5 = self._mechanism:update_wanted_hero_character(arg_49_1, arg_49_2, arg_49_3)

	printf("[GameModeVersus] assigned profile for %s: profile_index: %s, career_index: %s, reason: %s (previous: %s, %s)", arg_49_1, update_wanted_hero_character, var_49_4, var_49_5, get_persistent_profile_index_reservation, var_49_2)
	self:set_profile(get_player_status, update_wanted_hero_character, var_49_4, nil)

	return update_wanted_hero_character, var_49_4
end

GameModeVersus.set_profile = function (self, arg_50_1, arg_50_2, arg_50_3, arg_50_4)
	-- function 50
	local var_50_0

	if arg_50_4 ~= nil then
		var_50_0 = arg_50_4
	else
		var_50_0 = self:is_in_round_state()
	end

	local var_50_1 = SPProfiles[arg_50_2]

	if not self._is_server then
		self._profile_requester:request_profile(arg_50_1.peer_id, arg_50_1.local_player_id, var_50_1.display_name, var_50_1.careers[arg_50_3].display_name, var_50_0)
	else
		Managers.state.network:request_profile(arg_50_1.local_player_id, var_50_1.display_name, var_50_1.careers[arg_50_3].display_name, var_50_0)
	end
end

GameModeVersus._update_profile_in_party = function (self, arg_51_1, arg_51_2, arg_51_3)
	-- function 51
	local get_player_status = Managers.party:get_player_status(arg_51_1, arg_51_2)

	if not get_player_status.is_bot then
		return
	end

	self._profile_synchronizer:unassign_profiles_of_peer(arg_51_1, arg_51_2)

	local get_party = Managers.party:get_party(arg_51_3)

	if get_party.name == "heroes" then
		local _assign_peer_to_wanted_hero_profile, var_51_3 = self:_assign_peer_to_wanted_hero_profile(arg_51_1, arg_51_2, arg_51_3)
	elseif get_party.name == "dark_pact" then
		self:assign_temporary_dark_pact_profile(get_player_status)
	end
end

GameModeVersus.player_joined_party = function (self, arg_52_1, arg_52_2, arg_52_3, arg_52_4, arg_52_5)
	-- function 52
	GameModeVersus.super.player_joined_party(self, arg_52_1, arg_52_2, arg_52_3, arg_52_4, arg_52_5)

	local get_party = Managers.party:get_party(arg_52_3)
	local var_52_1 = get_party.slots[arg_52_4]

	if not var_52_1.is_bot then
		return
	end

	printf("[GAMEMODEVERSUS] player_joined_party: %s, %s, %s, is_bot: %s, game_mode_state: %s, has_party_selection_logic: %s", arg_52_1, arg_52_2, arg_52_3, var_52_1.is_bot, self._game_mode_state, self._versus_party_selection_logic)

	if arg_52_3 == 0 then
		return
	end

	if not self._versus_party_selection_logic then
		self._versus_party_selection_logic:player_joined_party(arg_52_1, arg_52_2, arg_52_3, arg_52_4)
	elseif not self._is_server and not self._mechanism:profiles_reservable() then
		self:_update_profile_in_party(arg_52_1, arg_52_2, arg_52_3)
	end

	local name = Managers.state.side.side_by_party[get_party]:name()

	if not self._is_server and name ~= "dark_pact" or not self:is_in_round_state() then
		local get_spawn_time = self._versus_spawning:get_spawn_time(get_party)

		self._versus_spawning:setup_data(arg_52_1, arg_52_2)
		self._versus_spawning:set_spawn_state(arg_52_1, arg_52_2, "w8_for_profile", 0, get_spawn_time, true)
		Managers.state.entity:system("versus_horde_ability_system"):server_register_peer(arg_52_1)
	end

	local player = var_52_1.player

	if not player and not player.local_player then
		if name == "spectators" then
			local system = Managers.state.entity:system("camera_system")
			local spectator = PROFILES_BY_NAME.spectator

			system:initialize_camera_states(player, spectator.index, 1)
			CharacterStateHelper.change_camera_state(player, "observer")
		elseif name ~= "dark_pact" or not self:is_in_round_state() then
			CharacterStateHelper.change_camera_state(player, "observer", {
				input_service_name = "dark_pact_selection"
			})
		end

		if Managers.mechanism:get_persistent_profile_index_reservation(arg_52_1) ~= 0 then
			self:update_local_hero_cosmetics()
		end
	end
end

GameModeVersus.profile_changed = function (self, arg_53_1, arg_53_2, arg_53_3, arg_53_4, arg_53_5)
	-- function 53
	if not (arg_53_5 or arg_53_1 ~= Network.peer_id()) then
		self:update_local_hero_cosmetics()
	end
end

GameModeVersus.server_validate_horde_timer = function (self, arg_54_1)
	-- function 54
	local conflict = Managers.state.conflict

	if not conflict then
		return
	end

	local get_horde_timer, var_54_2 = conflict:get_horde_timer()

	self._horde_delayed = var_54_2

	if self._horde_timer ~= get_horde_timer or not var_54_2 then
		self._horde_timer = get_horde_timer

		if not self._horde_timer then
			return
		end

		self._time_until_next_horde = self._horde_timer - arg_54_1

		if self._time_until_next_horde > 0 then
			Managers.state.network.network_transmit:send_rpc_clients("rpc_sync_next_horde_time", self._time_until_next_horde, var_54_2)
		end
	end
end

GameModeVersus.rpc_sync_next_horde_time = function (self, arg_55_1, arg_55_2, arg_55_3)
	-- function 55
	self._time_until_next_horde = arg_55_2 + Managers.time:time("game")
	self._horde_delayed = arg_55_3
end

GameModeVersus.display_debug_horde_timer_pactsworn = function (self, arg_56_1, arg_56_2)
	-- function 56
	if not self._settings.show_horde_timer_pactsworn then
		return
	end

	local local_player = Managers.player:local_player()

	if Managers.state.side:get_side_from_player_unique_id(local_player:unique_id())._name == "dark_pact" then
		local _time_until_next_horde = self._time_until_next_horde
		local num = RESOLUTION_LOOKUP.res_w * 0.6
		local var_56_3 = Color(100, 255, 0)
		local var_56_4 = Vector3(num, 0, 10)
		local num_2 = 40

		if not (not _time_until_next_horde and not (_time_until_next_horde >= 0) or not (_time_until_next_horde <= 1000)) then
			if not self._horde_delayed then
				_time_until_next_horde = string.format("Next horde(DELAYED): %2d", _time_until_next_horde - arg_56_1)
			else
				_time_until_next_horde = string.format("Next horde: %2d", _time_until_next_horde - arg_56_1)
			end

			Debug.draw_text(_time_until_next_horde, var_56_4, num_2, var_56_3)
		else
			local str = "Next horde: NIL"

			Debug.draw_text(str, var_56_4, num_2, var_56_3)
		end
	end
end

GameModeVersus.players_left_safe_zone = function (self)
	-- function 57
	if not self._horde_surge_handler then
		self._horde_surge_handler:activate()
	end
end

GameModeVersus.player_left_party = function (self, arg_58_1, arg_58_2, arg_58_3, arg_58_4, arg_58_5)
	-- function 58
	if not self._versus_party_selection_logic then
		self._versus_party_selection_logic:player_left_party(arg_58_1, arg_58_2, arg_58_3, arg_58_4, arg_58_5)
	end
end

GameModeVersus.local_player_ready_to_start = function (self, arg_59_1)
	-- function 59
	local _game_mode_state = self._game_mode_state

	if not (self._is_server or self:is_in_round_state() or _game_mode_state == "character_selection_state") then
		return false
	end

	if not (not self._is_server and self._initial_peers_ready) then
		return false
	end

	return true
end

GameModeVersus.local_player_game_starts = function (self, arg_60_1, arg_60_2)
	-- function 60
	local network_id = arg_60_1:network_id()
	local local_player_id = arg_60_1:local_player_id()
	local get_party_from_player_id = Managers.party:get_party_from_player_id(network_id, local_player_id)
	local var_60_3 = Managers.state.side.side_by_party[get_party_from_player_id]

	self:_player_entered_party(get_party_from_player_id, var_60_3, arg_60_1)
end

GameModeVersus.level_key = function (self)
	-- function 61
	return self._level_key
end

GameModeVersus._start_objective = function (self)
	-- function 62
	if not self._is_server then
		return
	end

	if not self:_get_objectives_current_set() then
		Managers.state.entity:system("objective_system"):server_activate_first_objective()
	end
end

GameModeVersus._get_objective_list_name_current_set = function (self)
	-- function 63
	local objective_lists = self._mechanism:get_objective_settings().objective_lists

	if not objective_lists then
		return objective_lists[Managers.mechanism:game_mechanism():get_current_set()]
	end
end

GameModeVersus._get_objectives_current_set = function (self)
	-- function 64
	return ObjectiveLists[self:_get_objective_list_name_current_set()]
end

GameModeVersus.get_current_objective_data = function (self)
	-- function 65
	local system = Managers.state.entity:system("objective_system")

	return self:_get_objectives_current_set()[system:current_objective_index()]
end

GameModeVersus.get_next_objective_data = function (self)
	-- function 66
	local system = Managers.state.entity:system("objective_system")

	return self:_get_objectives_current_set()[system:current_objective_index() + 1]
end

GameModeVersus.disable_player_spawning = function (self)
	-- function 67
	self._adventure_spawning:set_spawning_disabled(true)
end

GameModeVersus.enable_player_spawning = function (self, arg_68_1, arg_68_2)
	-- function 68
	self._adventure_spawning:set_spawning_disabled(false)
	self._adventure_spawning:force_update_spawn_positions(arg_68_1, arg_68_2)
end

GameModeVersus.teleport_despawned_players = function (self, arg_69_1)
	-- function 69
	self._adventure_spawning:teleport_despawned_players(arg_69_1)
end

GameModeVersus.flow_callback_add_spawn_point = function (self, arg_70_1)
	-- function 70
	self._adventure_spawning:add_spawn_point(arg_70_1)
end

GameModeVersus.flow_callback_add_game_mode_specific_spawn_point = function (self, arg_71_1, arg_71_2)
	-- function 71
	for i, v in ipairs(arg_71_2) do
		if v == "heroes" then
			self._adventure_spawning:add_spawn_point_to_spawn_group(arg_71_1)
		elseif v == "dark_pact" then
			self._versus_spawning:add_spawn_point(arg_71_1)
		end
	end
end

GameModeVersus.respawn_unit_spawned = function (self, arg_72_1)
	-- function 72
	if not (not self._hero_rescues_enabled and Unit.get_data(arg_72_1, "vs_set_id") ~= self._mechanism:get_current_set()) then
		self._adventure_spawning:respawn_unit_spawned(arg_72_1)
	end
end

GameModeVersus.get_respawn_handler = function (self)
	-- function 73
	return self._adventure_spawning:get_respawn_handler()
end

GameModeVersus.respawn_gate_unit_spawned = function (self, arg_74_1)
	-- function 74
	self._adventure_spawning:respawn_gate_unit_spawned(arg_74_1)
end

GameModeVersus.set_respawning_enabled = function (self, arg_75_1)
	-- function 75
	self._adventure_spawning:set_respawning_enabled(arg_75_1)
end

GameModeVersus.force_respawn = function (self, arg_76_1, arg_76_2)
	-- function 76
	local get_party_from_player_id = Managers.party:get_party_from_player_id(arg_76_1, arg_76_2)
	local name = Managers.state.side.side_by_party[get_party_from_player_id]:name()

	if not self:is_in_round_state() then
		if name == "heroes" then
			self._adventure_spawning:force_respawn(arg_76_1, arg_76_2)
		elseif name == "dark_pact" then
			self._versus_spawning:force_respawn(arg_76_1, arg_76_2)
		end
	end
end

GameModeVersus._handle_bots = function (self, arg_77_1, arg_77_2)
	-- function 77
	if not self._hero_bots_enabled then
		return
	end

	if not (Managers.state.network == nil or not Managers.state.network.game_session_shutdown) then
		return
	end

	for k, v in pairs(self._bot_players) do
		local get_party = Managers.party:get_party(k)

		if not self._settings.party_settings[get_party.name].using_bots then
			self:_remove_partyless_bots(v)

			local num_slots = get_party.num_slots
			local num = num_slots - #v

			if num > 0 then
				local num_2 = num_slots - get_party.num_used_slots

				if math.min(num, num_2) > 0 then
					self:_add_bot(k)

					return
				end
			elseif num < 0 then
				for k_2 = 1, math.abs(num) do
					self:_remove_last_added_bot(k)
				end
			end
		end
	end
end

GameModeVersus.event_set_loadout_items = function (self)
	-- function 78
	self:update_local_hero_cosmetics()
end

GameModeVersus.update_local_hero_cosmetics = function (self)
	-- function 79
	if not DEDICATED_SERVER then
		return
	end

	local local_player = Managers.player:local_player()
	local network_id = local_player:network_id()
	local local_player_id = local_player:local_player_id()
	local get_persistent_profile_index_reservation, var_79_4 = Managers.mechanism:get_persistent_profile_index_reservation(network_id)
	local var_79_5 = SPProfiles[get_persistent_profile_index_reservation].careers[var_79_4]
	local name = var_79_5.name
	local preview_wield_slot = var_79_5.preview_wield_slot
	local var_79_8 = InventorySettings.slot_names_by_type[preview_wield_slot][1]
	local get_loadout_item = BackendUtils.get_loadout_item(name, var_79_8)
	local get_loadout_item_2 = BackendUtils.get_loadout_item(name, "slot_pose")
	local flag = not get_loadout_item_2 and CosmeticUtils.get_weapon_pose_skin(get_loadout_item_2.key)
	local get_loadout_item_3 = BackendUtils.get_loadout_item(name, "slot_skin")
	local get_loadout_item_4 = BackendUtils.get_loadout_item(name, "slot_hat")
	local get_loadout_item_5 = BackendUtils.get_loadout_item(name, "slot_frame")
	local flag_2

	flag_2 = not get_loadout_item and get_loadout_item.data.name and CosmeticUtils.get_default_cosmetic_slot(var_79_5, var_79_8).item_name

	local flag_3

	flag_3 = not get_loadout_item_2 and get_loadout_item_2.data.name and CosmeticUtils.get_default_cosmetic_slot(var_79_5, "slot_pose").item_name

	local flag_4

	flag_4 = not flag and flag.skin and "n/a"

	local flag_5

	flag_5 = not get_loadout_item_3 and get_loadout_item_3.data.name and CosmeticUtils.get_default_cosmetic_slot(var_79_5, "slot_skin").item_name

	local flag_6

	flag_6 = not get_loadout_item_4 and get_loadout_item_4.data.name and CosmeticUtils.get_default_cosmetic_slot(var_79_5, "slot_hat").item_name

	local flag_7

	flag_7 = not get_loadout_item_5 and get_loadout_item_5.data.name and CosmeticUtils.get_default_cosmetic_slot(var_79_5, "slot_frame").item_name

	local _pack_pactsworn_cosmetics = self:_pack_pactsworn_cosmetics()
	local get_hero_cosmetics, var_79_23, var_79_24, var_79_25, var_79_26, var_79_27, var_79_28 = self._mechanism:get_hero_cosmetics(network_id, local_player_id)

	if flag_2 ~= get_hero_cosmetics or flag_3 ~= var_79_23 or var_79_24 ~= flag_4 or flag_5 ~= var_79_25 or flag_6 ~= var_79_26 or flag_7 ~= var_79_27 or not table.recursive_compare(var_79_28, _pack_pactsworn_cosmetics) then
		self._mechanism:set_hero_cosmetics(network_id, local_player_id, var_79_8, flag_2, flag_3, flag_4, flag_5, flag_6, flag_7, _pack_pactsworn_cosmetics)
	end
end

GameModeVersus._pack_pactsworn_cosmetics = function (arg_80_0)
	-- function 80
	local tbl = {}

	for i = 1, #SPProfiles do
		local var_80_1 = SPProfiles[i]

		if var_80_1.affiliation == "dark_pact" then
			local var_80_2 = var_80_1.careers[1]
			local name = var_80_2.name

			if name ~= "vs_undecided" then
				local preview_wield_slot = var_80_2.preview_wield_slot
				local var_80_5 = InventorySettings.slot_names_by_type[preview_wield_slot][1]
				local get_loadout_item = BackendUtils.get_loadout_item(name, var_80_5)
				local get_loadout_item_2 = BackendUtils.get_loadout_item(name, "slot_skin")
				local flag

				flag = not get_loadout_item_2 and get_loadout_item_2.data.name and CosmeticUtils.get_default_cosmetic_slot(var_80_2, "slot_skin").item_name

				local flag_2

				flag_2 = not get_loadout_item and get_loadout_item.data.name and var_80_2.base_weapon
				tbl[name] = {
					weapon_slot = var_80_5,
					skin = flag,
					weapon = flag_2
				}
			end
		end
	end

	return tbl
end

GameModeVersus._get_first_available_bot_profile = function (self, arg_81_1)
	-- function 81
	local var_81_0 = self._available_profiles_by_party[arg_81_1]
	local _profile_synchronizer = self._profile_synchronizer
	local tbl = {}

	for i = 1, #var_81_0 do
		local var_81_3 = var_81_0[i]
		local var_81_4 = FindProfileIndex(var_81_3)

		if not _profile_synchronizer:is_profile_in_use(var_81_4) then
			tbl[#tbl + 1] = var_81_4
		end
	end

	table.shuffle(tbl)

	for j = 1, #tbl do
		local var_81_5 = tbl[j]
		local var_81_6 = SPProfiles[var_81_5]
		local display_name = var_81_6.display_name
		local tbl_2 = {}

		for k = 1, #var_81_6.careers do
			tbl_2[k] = k
		end

		table.shuffle(tbl_2)

		for l = 1, #tbl_2 do
			local var_81_9 = tbl_2[l]
			local var_81_10 = var_81_6.careers[var_81_9]

			if not var_81_10 and not var_81_10:is_unlocked_function(display_name, math.huge) then
				return var_81_5, var_81_9
			end
		end
	end

	fassert(false, "Failed to find available bot profile profile for party " .. tostring(arg_81_1))
end

GameModeVersus._add_bot = function (self, arg_82_1)
	-- function 82
	local get_party = Managers.party:get_party(arg_82_1)
	local find_first_empty_slot_id = Managers.party:find_first_empty_slot_id(get_party)
	local get_bot_profile, var_82_3 = self._profile_synchronizer:get_bot_profile(arg_82_1, find_first_empty_slot_id)
	local parse_hero_profile_availability = self._mechanism:parse_hero_profile_availability(get_bot_profile, arg_82_1, nil, nil)
	local var_82_5 = self._bot_players[arg_82_1]

	if not parse_hero_profile_availability then
		for i = 1, #var_82_5 do
			if parse_hero_profile_availability == var_82_5[i]:profile_index() then
				parse_hero_profile_availability = nil

				break
			end
		end
	end

	if not parse_hero_profile_availability then
		parse_hero_profile_availability, var_82_3 = self:_get_first_available_bot_profile(arg_82_1)
	end

	local _add_bot_to_party = self:_add_bot_to_party(arg_82_1, parse_hero_profile_availability, var_82_3, find_first_empty_slot_id)

	var_82_5[#var_82_5 + 1] = _add_bot_to_party
end

GameModeVersus._remove_bot = function (self, arg_83_1, arg_83_2)
	-- function 83
	printf("_remove_bot: %s", tostring(arg_83_2))

	for k, v in pairs(self._bot_players) do
		local index_of = table.index_of(v, arg_83_1)

		if index_of >= 1 then
			if not arg_83_2 then
				self:_remove_bot_instant(arg_83_1)
			else
				self:_remove_bot_update_safe(arg_83_1)
			end

			local count = #v

			v[index_of] = v[count]
			v[count] = nil

			break
		end
	end
end

GameModeVersus._clear_bots = function (self, arg_84_1)
	-- function 84
	for k, v in pairs(self._bot_players) do
		for k_2 = #v, 1, -1 do
			self:_remove_bot(v[k_2], arg_84_1)
		end
	end
end

GameModeVersus._remove_partyless_bots = function (self, arg_85_1)
	-- function 85
	local party = Managers.party

	for i = #arg_85_1, 1, -1 do
		local var_85_1 = arg_85_1[i]
		local network_id = var_85_1:network_id()
		local local_player_id = var_85_1:local_player_id()

		if not party:get_party_from_player_id(network_id, local_player_id) then
			self:_remove_bot(arg_85_1[i])
		end
	end
end

GameModeVersus._remove_last_added_bot = function (self, arg_86_1, arg_86_2)
	-- function 86
	printf("_remove_last_added_bot")

	local var_86_0 = self._bot_players[arg_86_1]
	local count = #var_86_0

	self:_remove_bot(var_86_0[count], arg_86_2)
end

GameModeVersus._remove_bot_by_profile = function (self, arg_87_1, arg_87_2, arg_87_3)
	-- function 87
	printf("_remove_bot_by_profile: %s, from party: %s", arg_87_2, arg_87_1)

	local var_87_0 = self._bot_players[arg_87_1]

	for i, v in ipairs(var_87_0) do
		if v:profile_index() == arg_87_2 then
			printf("found bot by profile to remove: %s", arg_87_2)

			return self:_remove_bot(var_87_0[i], arg_87_3)
		end
	end

	return self:_remove_last_added_bot(arg_87_1, arg_87_3)
end

GameModeVersus.get_active_respawn_units = function (self)
	-- function 88
	return self._adventure_spawning:get_active_respawn_units()
end

GameModeVersus.get_available_and_active_respawn_units = function (self)
	-- function 89
	return self._adventure_spawning:get_available_and_active_respawn_units()
end

GameModeVersus.adventure_spawning = function (self)
	-- function 90
	return self._adventure_spawning
end

GameModeVersus.horde_surge_handler = function (self)
	-- function 91
	return self._horde_surge_handler
end

GameModeVersus.in_training_mode = function (self)
	-- function 92
	return self._training_mode
end

GameModeVersus.get_num_occupied_profile_enemy_role = function (arg_93_0, arg_93_1, arg_93_2, arg_93_3)
	-- function 93
	local num = 0
	local occupied_slots = arg_93_2.occupied_slots

	for i = 1, #occupied_slots do
		local var_93_2 = occupied_slots[i]
		local peer_id = var_93_2.peer_id
		local local_player_id = var_93_2.local_player_id
		local profile_by_peer = arg_93_1:profile_by_peer(peer_id, local_player_id)

		if not (not profile_by_peer and SPProfiles[profile_by_peer].enemy_role ~= arg_93_3) then
			num = num + 1
		end
	end

	return num
end

GameModeVersus.get_end_screen_config = function (self, arg_94_1, arg_94_2, arg_94_3, arg_94_4)
	-- function 94
	local var_94_0
	local var_94_1
	local var_94_2

	if arg_94_4 == "party_one_won_early" or arg_94_4 == "party_two_won_early" or Development.parameter("versus_quick_match_end") or not self._mechanism:should_start_next_set() then
		var_94_0 = "carousel_round_end"
		var_94_1 = {
			objectives_completed = self._objectives_completed,
			total_main_objectives = self._total_main_objectives,
			display_screen_delay = self._settings.end_of_match_view_display_screen_delay
		}
	else
		var_94_0 = not arg_94_1 and "victory" and not arg_94_2 or "defeat" and "draw"
		var_94_1 = {
			show_act_presentation = false,
			display_screen_delay = self._settings.end_of_match_view_display_screen_delay
		}
		var_94_2 = {
			reason = arg_94_4
		}
	end

	return var_94_0 or "none", var_94_1 or {}, var_94_2
end

GameModeVersus.get_end_of_round_screen_settings = function (arg_95_0)
	-- function 95
	return "carousel_round_end", {}, {}
end

GameModeVersus.ended = function (self, arg_96_1)
	-- function 96
	if not ((self._current_mechanism_state ~= "round_2" or not self._mechanism:is_last_set()) and self._network_server:are_all_peers_ingame()) then
		self._network_server:disconnect_joining_peers()
	end
end

GameModeVersus.get_player_wounds = function (self, arg_97_1)
	-- function 97
	local affiliation = arg_97_1.affiliation
	local var_97_1 = self._settings.player_wounds[affiliation]

	if not (not self._mechanism:custom_settings_enabled() and affiliation ~= "heroes") then
		var_97_1 = self._mechanism:get_custom_game_setting("wounds_amount") + 1
	end

	fassert(var_97_1, "Couldn't find player wounds for affiliation (%s)", affiliation)

	return var_97_1
end

GameModeVersus.get_initial_inventory = function (arg_98_0, arg_98_1, arg_98_2, arg_98_3, arg_98_4, arg_98_5)
	-- function 98
	local var_98_0

	if arg_98_5.affiliation == "heroes" then
		var_98_0 = {
			slot_packmaster_claw = "packmaster_claw_combo",
			slot_healthkit = arg_98_1,
			slot_potion = arg_98_2,
			slot_grenade = arg_98_3,
			additional_items = arg_98_4
		}
	else
		var_98_0 = {}
	end

	return var_98_0
end

GameModeVersus.round_id = function (self)
	-- function 99
	return self._round_id
end

GameModeVersus.allowed_interactions = function (arg_100_0, arg_100_1, arg_100_2)
	-- function 100
	local name = Managers.state.side.side_by_unit[arg_100_1]:name()
	local allowed_interactions = GameModeSettings.versus.side_settings[name].allowed_interactions

	if not allowed_interactions then
		return true
	end

	if name == "dark_pact" then
		local has_extension = ScriptUnit.has_extension(arg_100_1, "ghost_mode_system")

		if not has_extension and not has_extension:is_in_ghost_mode() then
			return allowed_interactions.ghost_mode[arg_100_2] ~= nil
		end

		return allowed_interactions.normal[arg_100_2] ~= nil
	else
		return allowed_interactions[arg_100_2] ~= nil
	end
end

GameModeVersus._disable_side_object_sets = function (arg_101_0)
	-- function 101
	local sides = Managers.state.side:sides()

	for i = 1, #sides do
		local var_101_1 = sides[i]
		local format = string.format("versus_%s", var_101_1:name())

		Managers.state.game_mode:set_object_set_enabled(format, false)
	end
end

GameModeVersus.rpc_rejoin_parties = function (self, arg_102_1)
	-- function 102
	if not self._is_server then
		return
	end

	print("[GameModeVersus] Told to rejoin parties")

	self._transition_state = "versus_migration"
end

GameModeVersus.event_end_screen_ui_complete = function (arg_103_0)
	-- function 103
	return
end

GameModeVersus.play_sound = function (self, arg_104_1)
	-- function 104
	local wwise_world = Managers.world:wwise_world(self._world)

	WwiseWorld.trigger_event(wwise_world, arg_104_1)
end

GameModeVersus._server_on_round_over = function (arg_105_0, arg_105_1)
	-- function 105
	local system = Managers.state.entity:system("audio_system")
	local flag

	flag = not arg_105_1 and "Play_versus_hud_round_end_heroes_win" and "Play_versus_hud_round_end_heroes_fail"

	system:play_2d_audio_event(flag)
end

GameModeVersus.pick_pactsworn_spawn_category = function (self, arg_106_1, arg_106_2)
	-- function 106
	local dark_pact_profile_rules = self._settings.dark_pact_profile_rules
	local tbl = {}

	for k, v in pairs(dark_pact_profile_rules) do
		if v > self:get_num_occupied_profile_enemy_role(arg_106_1, arg_106_2, k) then
			tbl[#tbl + 1] = k
		end
	end

	assert(#tbl ~= 0, "unable to pick pactsworn spawn category, no categories available")

	return tbl[Math.random(1, #tbl)]
end

GameModeVersus._round_start_telemetry = function (arg_107_0)
	-- function 107
	local game_mechanism = Managers.mechanism:game_mechanism()
	local local_player = Managers.player:local_player()
	local player_unit = local_player.player_unit
	local total_rounds_started = game_mechanism:total_rounds_started()
	local match_id = game_mechanism:match_id()
	local telemetry_id = local_player:telemetry_id()
	local var_107_6
	local var_107_7
	local var_107_8

	if not (not Unit.alive(player_unit) and Managers.state.side:versus_is_dark_pact(player_unit)) then
		local var_107_9 = Managers.player:player_loadouts()[local_player:unique_id()]

		if not var_107_9 then
			return
		end

		var_107_6 = not var_107_9.slot_melee and var_107_9.slot_melee.key
		var_107_7 = not var_107_9.slot_ranged and var_107_9.slot_ranged.key

		if not ScriptUnit.has_extension(player_unit, "talent_system") then
			var_107_8 = ScriptUnit.extension(player_unit, "talent_system"):get_talent_names()
		end
	end

	Managers.telemetry_events:versus_round_started(telemetry_id, total_rounds_started, match_id, var_107_6, var_107_7, var_107_8)
end

GameModeVersus._custom_settings_telemetry = function (self)
	-- function 108
	local get_telemetry_data, var_108_1, var_108_2 = self._mechanism:get_custom_game_settings_handler():get_telemetry_data()
	local telemetry_id = Managers.player:local_player():telemetry_id()
	local match_id = self._mechanism:match_id()

	Managers.telemetry_events:versus_custom_game_settings(telemetry_id, match_id, get_telemetry_data, var_108_1, var_108_2)
end

GameModeVersus._round_end_telemetry = function (self)
	-- function 109
	local game_mechanism = Managers.mechanism:game_mechanism()
	local party_id = Managers.state.side:get_side_from_name("heroes").party.party_id
	local total_rounds_started = game_mechanism:total_rounds_started()
	local match_id = game_mechanism:match_id()
	local get_current_score = self._win_conditions:get_current_score(party_id)

	Managers.telemetry_events:versus_round_ended(get_current_score, total_rounds_started, match_id)
end

GameModeVersus._match_end_telemetry = function (self, arg_110_1)
	-- function 110
	local var_110_0
	local var_110_1
	local match_id = self._mechanism:match_id()
	local flag

	flag = (arg_110_1 == "party_one_won" or arg_110_1 == "party_one_won_early" or 1 or arg_110_1 == "party_two_won" or arg_110_1 == "party_two_won_early") and 2

	local tbl = {}

	if not flag then
		local occupied_slots = Managers.party:get_party(flag).occupied_slots

		for i = 1, #occupied_slots do
			local peer_id = occupied_slots[i].peer_id

			tbl[i] = not peer_id and self._mechanism:get_peer_backend_id(peer_id)
		end
	else
		var_110_0 = true
	end

	Managers.telemetry_events:versus_match_ended(match_id, var_110_0, tbl)
end

GameModeVersus.activated_ability_telemetry = function (arg_111_0, arg_111_1, arg_111_2)
	-- function 111
	local game_mechanism = Managers.mechanism:game_mechanism()
	local total_rounds_started = game_mechanism:total_rounds_started()
	local match_id = game_mechanism:match_id()
	local telemetry_id = arg_111_2:telemetry_id()

	Managers.telemetry_events:versus_activated_ability(match_id, total_rounds_started, telemetry_id, arg_111_1)
end

GameModeVersus.menu_access_allowed_in_state = function (self)
	-- function 112
	if not self:is_in_round_state() then
		return true
	end

	return false
end

GameModeVersus.request_selectable_dark_pact_careers = function (self)
	-- function 113
	self._network_transmit:send_rpc_server("rpc_selectable_careers_request")
end

local tbl_3 = {
	waiting_for_players_to_join = true,
	character_selection_state = true,
	initial_state = true
}

GameModeVersus.is_in_pre_match_state = function (self)
	-- function 114
	return tbl_3[self._game_mode_state]
end

local tbl_4 = {
	pre_start_round_state = true,
	match_running_state = true
}

GameModeVersus.is_in_round_state = function (self)
	-- function 115
	return tbl_4[self._game_mode_state]
end

GameModeVersus.match_is_running = function (self)
	-- function 116
	return self._game_mode_state == "match_running_state"
end

GameModeVersus.match_in_round_over_state = function (self)
	-- function 117
	return self._game_mode_state == "post_round_state"
end

GameModeVersus.game_mode_state = function (self)
	-- function 118
	return self._game_mode_state
end

GameModeVersus.rpc_selectable_careers_request = function (self, arg_119_1)
	-- function 119
	assert(self._is_server, "[GameModeVersus] 'rpc_selectable_careers_request' may only be received by the server")

	local var_119_0 = CHANNEL_TO_PEER_ID[arg_119_1]

	if not var_119_0 then
		return
	end

	local request_careers, var_119_2 = self._dark_pact_career_delegator:request_careers(var_119_0)
	local var_119_3 = NetworkLookup.versus_dark_pact_profile_rules[var_119_2]

	for i = 1, #request_careers do
		request_careers[i] = PROFILES_BY_NAME[request_careers[i]].index
	end

	self._network_transmit:send_rpc("rpc_selectable_careers_response", var_119_0, var_119_3, request_careers)
end

GameModeVersus.rpc_selectable_careers_response = function (arg_120_0, arg_120_1, arg_120_2, arg_120_3)
	-- function 120
	local var_120_0 = NetworkLookup.versus_dark_pact_profile_rules[arg_120_2]

	for i = 1, #arg_120_3 do
		arg_120_3[i] = SPProfiles[arg_120_3[i]].display_name
	end

	Managers.state.event:trigger("versus_received_selectable_careers_response", var_120_0, arg_120_3)
end

GameModeVersus.increment_num_picks_for_career = function (self)
	-- function 121
	self._dark_pact_career_delegator:increment_num_picks_for_career()
end

GameModeVersus.decrement_num_picks_for_career = function (self)
	-- function 122
	self._dark_pact_career_delegator:decrement_num_picks_for_career()
end

GameModeVersus.set_playable_boss_can_be_picked = function (self, arg_123_1)
	-- function 123
	if not self._boss_has_been_played then
		return
	end

	if not self._is_server then
		printf("[VS BOSS] trigger playable boss")

		self._boss_has_been_played = true

		self._dark_pact_career_delegator:set_playable_boss_can_be_picked(arg_123_1)
	else
		printf("[VS BOSS] trigger playable boss")
		self._network_transmit:send_rpc_server("rpc_set_playable_boss_can_be_picked", arg_123_1)
	end
end

GameModeVersus.rpc_set_playable_boss_can_be_picked = function (self, arg_124_1)
	-- function 124
	assert(self._is_server, "[Trying to set the boss to be pickable by client, it should only happen on server]")

	self._boss_has_been_played = true

	self._dark_pact_career_delegator:set_playable_boss_can_be_picked(arg_124_1)
end

GameModeVersus._get_parading_screen_duration = function (arg_125_0)
	-- function 125
	local num = 0
	local setting = Managers.state.game_mode:setting("parading_times")

	for k, v in pairs(setting) do
		num = num + v
	end

	return num
end

GameModeVersus.projectile_hit_character = function (arg_126_0, arg_126_1, arg_126_2, arg_126_3, arg_126_4, arg_126_5, arg_126_6, arg_126_7, arg_126_8)
	-- function 126
	arg_126_3 = arg_126_2 or arg_126_3

	if not DamageUtils.is_player_unit(arg_126_3) then
		if not Managers.state.side:is_enemy(arg_126_3, arg_126_4) then
			return
		end

		arg_126_1 = arg_126_1 or Managers.player:owner(arg_126_3)
		arg_126_6 = arg_126_6 or AiUtils.unit_breed(arg_126_4)

		if not arg_126_6.is_player then
			local flag = not arg_126_1.local_player

			DamageUtils.add_hit_reaction(arg_126_4, arg_126_6, flag, arg_126_7, false)
		end

		if not Managers.state.side:versus_is_dark_pact(arg_126_3) then
			local system = Managers.state.entity:system("audio_system")
			local local_player = arg_126_1.local_player

			arg_126_8 = arg_126_8 or 0

			system:vs_play_pactsworn_hit_enemy(arg_126_5, local_player, arg_126_1, arg_126_8, Managers.time:time("game"))
		end
	end
end

GameModeVersus._trigger_early_win_vo = function (arg_127_0, arg_127_1)
	-- function 127
	local get_party = Managers.party:get_party(arg_127_1)
	local var_127_1 = Managers.state.side.side_by_party[get_party]
	local flag

	flag = arg_127_1 ~= 1 or not 2 or 1

	local get_party_2 = Managers.party:get_party(flag)
	local var_127_4 = Managers.state.side.side_by_party[get_party_2]
	local system = Managers.state.entity:system("dialogue_system")

	system:trigger_mission_giver_event("vs_mg_early_win", nil, var_127_1:name())
	system:trigger_mission_giver_event("vs_mg_early_loss", nil, var_127_4:name())
end

GameModeVersus._trigger_draw_vo = function (arg_128_0)
	-- function 128
	Managers.state.entity:system("dialogue_system"):queue_mission_giver_event("vs_mg_match_draw")
end

local num_2 = 70
local num_3 = 5
local tbl_5 = {}
local tbl_6 = {}

GameModeVersus._update_hero_rushing = function (self, arg_129_1)
	-- function 129
	if not self._is_server then
		return
	end

	local _last_played_hero_rushed_t = self._last_played_hero_rushed_t

	_last_played_hero_rushed_t = _last_played_hero_rushed_t or 0

	if arg_129_1 - _last_played_hero_rushed_t < 60 then
		return
	end

	table.clear(tbl_5)
	table.clear(tbl_6)

	local num = 0
	local conflict = Managers.state.conflict
	local PLAYER_UNITS = Managers.state.side:get_side_from_name("heroes").PLAYER_UNITS

	for i = 1, #PLAYER_UNITS do
		local var_129_4 = PLAYER_UNITS[i]
		local get_main_path_player_data = conflict:get_main_path_player_data(var_129_4)

		if not get_main_path_player_data and not get_main_path_player_data.travel_dist and not ScriptUnit.has_extension(var_129_4, "career_system") then
			num = num + 1
			tbl_5[num] = var_129_4
			tbl_6[var_129_4] = get_main_path_player_data.travel_dist
		end
	end

	if num > 1 then
		table.sort(tbl_5, function (arg_130_0, arg_130_1)
			-- function 130
			return tbl_6[arg_130_0] < tbl_6[arg_130_1]
		end)

		local var_129_6 = tbl_5[num]
		local var_129_7 = tbl_5[num - 1]

		if tbl_6[var_129_6] - tbl_6[var_129_7] > num_2 then
			local _hero_rush_grace_delay = self._hero_rush_grace_delay

			_hero_rush_grace_delay = _hero_rush_grace_delay or arg_129_1 + num_3
			self._hero_rush_grace_delay = _hero_rush_grace_delay

			if _hero_rush_grace_delay < arg_129_1 then
				local profile_index = ScriptUnit.extension(var_129_6, "career_system"):profile_index()
				local display_name = SPProfiles[profile_index].display_name

				Managers.state.entity:system("dialogue_system"):queue_mission_giver_event("vs_mg_hero_rushing", {
					target_name = display_name
				})

				self._last_played_hero_rushed_t = arg_129_1
				self._hero_rush_grace_delay = nil
			end
		else
			self._hero_rush_grace_delay = nil
		end
	end
end

GameModeVersus._register_disabled_as_eliminiations = function (arg_131_0)
	-- function 131
	local players = Managers.player:players()
	local statistics_db = Managers.player:statistics_db()

	for k, v in pairs(players) do
		repeat
			local var_131_2
			local var_131_3
			local has_extension = ScriptUnit.has_extension(v.player_unit, "status_system")

			if not has_extension then
				if has_extension:is_grabbed_by_pack_master() or not has_extension:is_hanging_from_hook() then
					var_131_2 = has_extension:query_pack_master_player()
					var_131_3 = "vs_packmaster"
				elseif not has_extension:is_pounced_down() then
					var_131_2 = Managers.player:owner(has_extension:get_pouncer_unit())
					var_131_3 = "vs_gutter_runner"
				elseif not has_extension:is_disabled_by_pact_sworn() then
					-- Nothing
				end
			end

			if not var_131_2 then
				local stats_id = var_131_2:stats_id()

				if not statistics_db:is_registered(stats_id) then
					if not has_extension:is_knocked_down() then
						statistics_db:increment_stat(stats_id, "kills_per_breed", var_131_3)

						break
					end

					local name = Unit.get_data(v.player_unit, "breed").name

					statistics_db:increment_stat(stats_id, "vs_knockdowns_per_breed", name)
					statistics_db:increment_stat(stats_id, "eliminations_as_breed", var_131_3)
				end
			end
		until true
	end
end
