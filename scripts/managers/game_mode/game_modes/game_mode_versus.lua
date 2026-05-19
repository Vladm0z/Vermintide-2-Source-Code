-- chunkname: @scripts/managers/game_mode/game_modes/game_mode_versus.lua

require("scripts/managers/game_mode/game_modes/game_mode_base")
require("scripts/managers/game_mode/spawning_components/adventure_spawning")
require("scripts/managers/game_mode/spawning_components/versus_spawning")
require("scripts/managers/game_mode/versus_win_conditions")
require("scripts/managers/game_mode/versus_dark_pact_career_delegator")
require("scripts/managers/admin/dedicated_server_commands")
require("scripts/ui/views/pactsworn_video_transition_view")
require("scripts/managers/game_mode/versus_party_selection_logic")

local var_0_0 = require("scripts/managers/game_mode/mechanisms/reservation_handler_types")

script_data.disable_gamemode_end = script_data.disable_gamemode_end or Development.parameter("disable_gamemode_end")

local var_0_1 = script_data.testify and require("scripts/managers/game_mode/game_modes/game_mode_versus_testify")

GameModeVersus = class(GameModeVersus, GameModeBase)
GameModeVersus.WAIT_FOR_CLIENTS_TO_LEAVE_TIMEOUT = 30

local var_0_2 = {
	"rpc_rejoin_parties",
	"rpc_sync_next_horde_time",
	"rpc_selectable_careers_request",
	"rpc_selectable_careers_response",
	"rpc_set_playable_boss_can_be_picked"
}

function GameModeVersus.init(arg_1_0, arg_1_1, arg_1_2, ...)
	GameModeVersus.super.init(arg_1_0, arg_1_1, arg_1_2, ...)

	arg_1_0._game_end_condition_timer = nil
	arg_1_0._round_id = nil
	arg_1_0._objectives_completed = nil
	arg_1_0._total_main_objectives = nil
	arg_1_0._training_mode = LevelSettings[arg_1_0._level_key].training_mode

	local var_1_0 = Managers.state.side:get_side_from_name("heroes")
	local var_1_1 = Managers.state.side:get_side_from_name("dark_pact")

	arg_1_0._mechanism = Managers.mechanism:game_mechanism()
	arg_1_0._current_mechanism_state = arg_1_0._mechanism:get_state()
	arg_1_0._adventure_spawning = AdventureSpawning:new(arg_1_0._profile_synchronizer, var_1_0, arg_1_0._is_server, arg_1_0._network_server)
	arg_1_0._versus_spawning = VersusSpawning:new("dark_pact", arg_1_0._profile_synchronizer, var_1_1.available_profiles, arg_1_0._is_server, arg_1_1, arg_1_0._dark_pact_career_delegator)
	arg_1_0.pactsworn_video_transition_view = PactswornVideoTransitionView:new(arg_1_0._world)

	arg_1_0:_register_player_spawner(arg_1_0._adventure_spawning)

	arg_1_0._active_transporters = {}

	local var_1_2 = var_1_0.party
	local var_1_3 = var_1_1.party

	arg_1_0._bot_players = {
		[var_1_2.party_id] = {},
		[var_1_3.party_id] = {}
	}
	arg_1_0._horde_timer = math.huge
	arg_1_0._time_until_next_horde = math.huge
	arg_1_0._hero_side = var_1_0
	arg_1_0._dark_pact_side = var_1_1
	arg_1_0._available_profiles_by_party = {
		[var_1_2.party_id] = table.clone(PROFILES_BY_AFFILIATION.heroes),
		[var_1_3.party_id] = table.clone(PROFILES_BY_AFFILIATION.dark_pact)
	}

	Managers.state.event:register(arg_1_0, "level_start_local_player_spawned", "event_local_player_spawned", "gm_event_initial_peers_spawned", "gm_event_initial_peers_spawned", "end_screen_ui_complete", "event_end_screen_ui_complete", "event_set_loadout_items", "event_set_loadout_items")

	arg_1_0._win_conditions = Managers.mechanism:game_mechanism():win_conditions()

	local var_1_4 = arg_1_0._mechanism:get_objective_settings()

	arg_1_0._win_conditions:setup_round(arg_1_0._is_server, var_1_4)

	if arg_1_0._is_server then
		arg_1_0._dark_pact_career_delegator = VersusDarkPactCareerDelegator:new()

		arg_1_0:_create_game_mode_data_game_object()

		arg_1_0._lobby_host = arg_1_0._network_server.lobby_host
		arg_1_0._profile_requester = arg_1_0._network_server:profile_requester()

		if DEDICATED_SERVER then
			arg_1_0._start_game_timeout_timer = 0
		end
	end

	if arg_1_1.surge_events and arg_1_1.enable_horde_surge then
		local var_1_5 = Managers.mechanism:get_level_seed()
		local var_1_6 = arg_1_1.surge_events.events[arg_1_0._level_key]

		arg_1_0._horde_surge_handler = HordeSurgeHandler:new(arg_1_0._is_server, arg_1_2, var_1_6, var_1_5)
	end

	arg_1_0._boss_has_been_played = false
	arg_1_0._initial_peers_spawned = false
	arg_1_0._local_player_spawned = false
	arg_1_0.pre_round_start_timer = math.huge
	arg_1_0._transition_state = "idle"
	arg_1_0._transition_state_time = 0
	arg_1_0._hero_bots_enabled = true

	if arg_1_0._mechanism:custom_settings_enabled() then
		arg_1_0._hero_bots_enabled = arg_1_0._mechanism:get_custom_game_setting("hero_bots_enabled")
		arg_1_0._hero_rescues_enabled = arg_1_0._mechanism:get_custom_game_setting("hero_rescues_enabled") or false
	end
end

function GameModeVersus.level_start_objectives(arg_2_0)
	return arg_2_0:_get_objective_list_name_current_set()
end

function GameModeVersus._create_game_mode_data_game_object(arg_3_0)
	local var_3_0 = Managers.state.network
	local var_3_1 = arg_3_0._mechanism:get_objective_settings()
	local var_3_2 = {
		go_type = NetworkLookup.go_types.game_mode_data,
		round_timer = var_3_1.round_timer or 36000
	}
	local var_3_3 = var_3_0:create_game_object("game_mode_data_carousel", var_3_2)
	local var_3_4 = var_3_0:game()
	local var_3_5 = callback(arg_3_0, "game_session_disconnect")

	arg_3_0._win_conditions:on_game_mode_data_created(var_3_4, var_3_3, var_3_5)

	arg_3_0._go_id = var_3_3
end

function GameModeVersus.on_game_mode_data_created(arg_4_0, arg_4_1, arg_4_2)
	arg_4_0._win_conditions:on_game_mode_data_created(arg_4_1, arg_4_2)
end

function GameModeVersus.on_game_mode_data_destroyed(arg_5_0)
	arg_5_0._win_conditions:on_game_mode_data_destroyed()

	arg_5_0._go_id = nil
end

function GameModeVersus.game_session_disconnect(arg_6_0)
	arg_6_0._win_conditions:on_game_mode_data_destroyed()

	arg_6_0._go_id = nil
end

function GameModeVersus.cleanup_game_mode_units(arg_7_0)
	arg_7_0:_clear_bots(true)
end

function GameModeVersus.register_rpcs(arg_8_0, arg_8_1, arg_8_2)
	GameModeVersus.super.register_rpcs(arg_8_0, arg_8_1, arg_8_2)
	arg_8_1:register(arg_8_0, unpack(var_0_2))
	arg_8_0._adventure_spawning:register_rpcs(arg_8_1, arg_8_2)
	arg_8_0._versus_spawning:register_rpcs(arg_8_1, arg_8_2)

	if arg_8_0._horde_surge_handler then
		arg_8_0._horde_surge_handler:register_rpcs(arg_8_1, arg_8_2)
	end

	if arg_8_0._win_conditions then
		arg_8_0._win_conditions:register_rpcs(arg_8_1, arg_8_2)
	end
end

function GameModeVersus.unregister_rpcs(arg_9_0)
	arg_9_0._adventure_spawning:unregister_rpcs()
	arg_9_0._versus_spawning:unregister_rpcs()
	arg_9_0._network_event_delegate:unregister(arg_9_0)

	if arg_9_0._horde_surge_handler then
		arg_9_0._horde_surge_handler:unregister_rpcs()
	end

	if arg_9_0._win_conditions then
		arg_9_0._win_conditions:unregister_rpcs()
	end

	GameModeVersus.super.unregister_rpcs(arg_9_0)
end

function GameModeVersus.event_local_player_spawned(arg_10_0, arg_10_1)
	local var_10_0 = LevelHelper:current_level(arg_10_0._world)
	local var_10_1 = "versus_activator"

	if Level.has_volume(var_10_0, var_10_1) then
		Managers.state.entity:system("round_started_system"):set_start_area(var_10_1)
	end

	arg_10_0._is_initial_spawn = arg_10_1

	local var_10_2 = arg_10_0._win_conditions
	local var_10_3 = Managers.player:local_player()
	local var_10_4 = Managers.state.side:get_side_from_player_unique_id(var_10_3:unique_id())
	local var_10_5 = var_10_4 and var_10_4:name() == "heroes"

	if var_10_5 and not arg_10_0._local_player_spawned then
		Managers.transition:force_fade_in()

		arg_10_0._delayed_fade_out_timer = Managers.time:time("game") + 0.5
	end

	if var_10_5 and not var_10_2:is_round_timer_started() then
		local var_10_6 = var_10_3.player_unit

		ScriptUnit.has_extension(var_10_6, "career_system"):set_activated_ability_cooldown_paused()
	end

	if arg_10_1 then
		LevelHelper:flow_event(arg_10_0._world, "local_player_spawned")

		local var_10_7 = string.format("versus_%s", var_10_4:name())

		Managers.state.game_mode:set_object_set_enabled(var_10_7, true)
	end

	arg_10_0._local_player_spawned = true
end

function GameModeVersus.party_selection_logic(arg_11_0)
	return arg_11_0._versus_party_selection_logic
end

function GameModeVersus.hot_join_sync(arg_12_0, arg_12_1)
	if arg_12_0._initial_peers_spawned then
		arg_12_0._network_transmit:send_rpc("rpc_gm_event_initial_peers_spawned", arg_12_1)
	end

	if arg_12_0._versus_party_selection_logic then
		arg_12_0._versus_party_selection_logic:hot_join_sync(arg_12_1)
	end

	arg_12_0._win_conditions:hot_join_sync(arg_12_1)

	if arg_12_0._horde_surge_handler then
		arg_12_0._horde_surge_handler:hot_join_sync(arg_12_1)
	end

	if arg_12_0._game_mode_state == "match_running_state" then
		local var_12_0 = "round_started_set_" .. arg_12_0._mechanism:get_current_set()

		arg_12_0._network_transmit:send_rpc_clients("rpc_trigger_level_event", var_12_0)
		arg_12_0._network_transmit:send_rpc("rpc_trigger_level_event", arg_12_1, "remove_safe_zone_wall")
	end
end

function GameModeVersus.destroy(arg_13_0)
	if arg_13_0._is_server then
		arg_13_0._dark_pact_career_delegator:destroy()
	end

	if arg_13_0._versus_party_selection_logic then
		arg_13_0._versus_party_selection_logic:destroy()

		arg_13_0._versus_party_selection_logic = nil
	end

	local var_13_0 = Managers.state.event

	if var_13_0 then
		var_13_0:unregister("level_start_local_player_spawned", arg_13_0)
		var_13_0:unregister("gm_event_initial_peers_spawned", arg_13_0)
		var_13_0:unregister("end_screen_ui_complete", arg_13_0)
		var_13_0:unregister("event_set_loadout_items", arg_13_0)
	end
end

function GameModeVersus.evaluate_end_conditions(arg_14_0, arg_14_1, arg_14_2, arg_14_3)
	repeat
		if script_data.auto_complete_rounds and (arg_14_0._game_mode_state == "match_running_state" or arg_14_0._game_mode_state == "pre_start_round_state") then
			break
		end

		if arg_14_0._training_mode or script_data.disable_gamemode_end then
			return false
		end

		if not arg_14_1 and not arg_14_0._level_completed and not arg_14_0._level_failed then
			return false
		end
	until true

	local var_14_0 = true
	local var_14_1 = false
	local var_14_2 = arg_14_0._win_conditions:is_round_timer_over()
	local var_14_3 = Managers.state.entity:system("objective_system"):all_objectives_completed()
	local var_14_4 = arg_14_0._win_conditions.party_won_early
	local var_14_5 = GameModeHelper.side_is_dead("heroes", var_14_0)
	local var_14_6 = GameModeHelper.side_is_disabled("heroes")
	local var_14_7 = var_14_5 or var_14_6
	local var_14_8 = Managers.state.side:get_party_from_side_name("dark_pact").num_used_slots == 0

	if script_data.disable_gamemode_end_hero_check then
		var_14_7 = false
		var_14_8 = false
	end

	local var_14_9 = not arg_14_0._lose_condition_disabled and (var_14_7 or var_14_8 or arg_14_0._level_failed) or var_14_2 or var_14_3 or var_14_4 or script_data.auto_complete_rounds or false

	if arg_14_0._level_completed then
		arg_14_0._level_complete_timer = arg_14_0._level_complete_timer or arg_14_3 + 0.4
		var_14_1 = arg_14_3 >= arg_14_0._level_complete_timer

		if not arg_14_0._last_hero_down_riser_played then
			Managers.state.entity:system("audio_system"):play_2d_audio_event("Play_versus_hud_last_hero_down_riser")

			arg_14_0._last_hero_down_riser_played = true
		end
	elseif arg_14_0:is_about_to_end_game_early() then
		if var_14_9 and arg_14_0._game_end_condition_timer then
			if arg_14_3 > arg_14_0._game_end_condition_timer then
				var_14_1 = true
			end
		else
			if arg_14_0._last_hero_down_riser_played then
				Managers.state.entity:system("audio_system"):play_2d_audio_event("Stop_versus_hud_last_hero_down_riser_interrupted")

				arg_14_0._last_hero_down_riser_played = false
			end

			arg_14_0:set_about_to_end_game_early(nil)

			arg_14_0._game_end_condition_timer = nil
		end
	elseif var_14_9 then
		arg_14_0:set_about_to_end_game_early(true)
		Managers.state.entity:system("audio_system"):play_2d_audio_event("Play_versus_hud_last_hero_down_riser")

		arg_14_0._last_hero_down_riser_played = true

		if script_data.auto_complete_rounds then
			arg_14_0._game_end_condition_timer = arg_14_3
		elseif var_14_5 then
			arg_14_0._game_end_condition_timer = arg_14_3 + GameModeSettings.versus.lose_condition_time_dead
		else
			arg_14_0._game_end_condition_timer = arg_14_3 + GameModeSettings.versus.lose_condition_time
		end
	end

	if var_14_1 then
		local var_14_10, var_14_11 = arg_14_0:_get_end_reason(var_14_4)
		local var_14_12 = arg_14_0:_handle_round_end(var_14_10, var_14_11, var_14_3)

		arg_14_0._mechanism:server_decide_side_order()

		if DEDICATED_SERVER or arg_14_0._mechanism:is_hosting_versus_custom_game() then
			Managers.party:server_update_all_client_friend_parties()
		end

		arg_14_0._level_complete_timer = nil
		arg_14_0._game_end_condition_timer = nil
		arg_14_0._round_timer = nil

		arg_14_0:change_game_mode_state("post_round_state")

		return true, var_14_12, var_14_11
	else
		return false
	end
end

function GameModeVersus._handle_round_end(arg_15_0, arg_15_1, arg_15_2, arg_15_3)
	local var_15_0 = Development.parameter("versus_quick_match_end") or arg_15_0._current_mechanism_state == "round_2" and arg_15_0._mechanism:is_last_set()
	local var_15_1 = Managers.state.side:get_side_from_name("heroes").party.party_id
	local var_15_2 = arg_15_2 and arg_15_2.party_id == var_15_1 or false
	local var_15_3 = arg_15_3 or var_15_2

	if arg_15_1 == "party_one_won_early" or arg_15_1 == "party_two_won_early" then
		arg_15_0:_trigger_early_win_vo(arg_15_2.party_id)
	elseif var_15_0 then
		arg_15_1 = arg_15_0._win_conditions:get_match_results()

		if arg_15_1 == "draw" then
			arg_15_0:_trigger_draw_vo()
		end
	elseif not var_15_3 then
		Managers.state.entity:system("dialogue_system"):trigger_mission_giver_event("vs_mg_heroes_team_wipe")
	end

	arg_15_0:_server_on_round_over(var_15_3)
	arg_15_0:_round_end_telemetry()

	if arg_15_1 ~= "round_end" then
		arg_15_0:_match_end_telemetry(arg_15_1)
	end

	return arg_15_1
end

function GameModeVersus._get_end_reason(arg_16_0, arg_16_1)
	local var_16_0 = "round_end"
	local var_16_1

	if not arg_16_1 then
		local var_16_2
		local var_16_3

		var_16_3, arg_16_1 = arg_16_0._win_conditions:update_early_win_conditions()
	end

	if arg_16_1 then
		var_16_0 = arg_16_1.party_id == 1 and "party_one_won_early" or "party_two_won_early"
		var_16_1 = arg_16_1
	end

	return var_16_0, var_16_1
end

function GameModeVersus.ready_to_transition(arg_17_0)
	local var_17_0 = arg_17_0._current_mechanism_state == "round_2" and not arg_17_0._mechanism:should_start_next_set()

	if var_17_0 or arg_17_0._win_conditions.party_won_early then
		arg_17_0._network_transmit:send_rpc_clients("rpc_rejoin_parties")

		if not DEDICATED_SERVER then
			arg_17_0._transition_state = "versus_migration"
		else
			arg_17_0._transition_state = "wait_until_empty"
			arg_17_0._transition_state_time = 0
		end
	else
		arg_17_0._transition_state = "next_level"

		Managers.level_transition_handler:promote_next_level_data()
	end

	printf("[GameModeVersus] Ready to transition. _transition_state: %s, _is_server: %s, all_rounds_played: %s, party_won-early: %s", arg_17_0._transition_state, arg_17_0._is_server, var_17_0, arg_17_0._win_conditions.party_won_early)
end

function GameModeVersus.wanted_transition(arg_18_0)
	local var_18_0 = arg_18_0._transition_state

	if var_18_0 == "next_level" then
		return "complete_level"
	elseif var_18_0 == "restart_game_server" then
		return "restart_game_server"
	elseif var_18_0 == "quit_game" then
		return "quit_game"
	elseif var_18_0 == "versus_migration" then
		return "versus_migration"
	end
end

function GameModeVersus.server_character_selection_completed(arg_19_0)
	if arg_19_0._settings.display_parading_view then
		arg_19_0:change_game_mode_state("player_team_parading_state")
	else
		arg_19_0:change_game_mode_state("pre_start_round_state")
	end
end

function GameModeVersus.pre_update(arg_20_0, arg_20_1, arg_20_2)
	local var_20_0 = arg_20_0._game_mode_state

	if arg_20_0._is_server and arg_20_0:is_in_round_state() then
		arg_20_0:_handle_bots(arg_20_1, arg_20_2)
	end

	if arg_20_0._versus_party_selection_logic then
		arg_20_0._versus_party_selection_logic:pre_update(arg_20_1, arg_20_2)
	end
end

function GameModeVersus.player_ready(arg_21_0)
	return arg_21_0._local_player_spawned and not arg_21_0._delayed_fade_out_timer
end

function GameModeVersus.update(arg_22_0, arg_22_1, arg_22_2)
	if arg_22_0._is_server then
		arg_22_0._dark_pact_career_delegator:update()
		arg_22_0:_update_hero_rushing(arg_22_1)
	else
		arg_22_0:_client_update(arg_22_1, arg_22_2)
	end

	if arg_22_0._delayed_fade_out_timer and arg_22_1 > arg_22_0._delayed_fade_out_timer then
		Managers.transition:fade_out(GameSettings.transition_fade_out_speed)

		arg_22_0._delayed_fade_out_timer = nil
	end

	if arg_22_0._initial_peers_ready then
		local var_22_0 = arg_22_0._game_mode_state

		if arg_22_0:is_in_round_state() then
			arg_22_0._adventure_spawning:update(arg_22_1, arg_22_2)

			if var_22_0 == "match_running_state" then
				-- block empty
			end
		end

		if arg_22_0.pactsworn_video_transition_view then
			arg_22_0.pactsworn_video_transition_view:update(arg_22_2)
		end
	end

	if script_data.testify then
		Testify:poll_requests_through_handler(var_0_1, arg_22_0)
	end
end

local var_0_3 = {}

function GameModeVersus._clear_profile_reservations(arg_23_0, arg_23_1)
	local var_23_0 = var_0_3

	if arg_23_1 then
		var_23_0[1] = arg_23_1
	else
		var_23_0 = Managers.party:game_participating_parties()
	end

	for iter_23_0 = 1, #var_23_0 do
		local var_23_1 = var_23_0[iter_23_0]
		local var_23_2 = arg_23_0._profile_synchronizer
		local var_23_3 = var_23_1.occupied_slots

		for iter_23_1 = 1, #var_23_3 do
			local var_23_4 = var_23_3[iter_23_1]
			local var_23_5 = var_23_4.peer_id
			local var_23_6 = var_23_4.local_player_id

			if var_23_2:profile_by_peer(var_23_5, var_23_6) then
				var_23_2:unassign_profiles_of_peer(var_23_5, var_23_6)
			end

			var_23_2:clear_profile_index_reservation(var_23_5, true)
		end
	end
end

function GameModeVersus._game_mode_state_changed(arg_24_0, arg_24_1, arg_24_2)
	if arg_24_0._current_mechanism_state == "round_1" then
		arg_24_0._round_id = 1
	else
		arg_24_0._round_id = 2
	end

	if arg_24_0._is_server then
		arg_24_0._start_game_timeout_timer = 0
	end

	if arg_24_1 == "waiting_for_players_to_join" then
		arg_24_0._mechanism:increment_total_rounds_started()
	elseif arg_24_1 == "character_selection_state" then
		if arg_24_0._is_server then
			arg_24_0:_clear_profile_reservations()
		end

		arg_24_0._versus_party_selection_logic = VersusPartySelectionLogic:new(arg_24_0._is_server, arg_24_0._settings, arg_24_0._network_server, arg_24_0._profile_synchronizer, arg_24_0._network_event_delegate, arg_24_0._network_transmit)

		arg_24_0._mechanism:make_profiles_reservable()
		Managers.ui:handle_transition("versus_party_char_selection_view", {
			menu_state_name = "character"
		})

		if not DEDICATED_SERVER then
			arg_24_0:_disable_side_object_sets()
		end

		arg_24_0:_stop_advertise_playing()

		if arg_24_0._mechanism:custom_settings_enabled() then
			arg_24_0:_custom_settings_telemetry()
		end
	elseif arg_24_1 == "player_team_parading_state" then
		if arg_24_2 ~= "character_selection_state" then
			arg_24_0._versus_party_selection_logic = VersusPartySelectionLogic:new(arg_24_0._is_server, arg_24_0._settings, arg_24_0._network_server, arg_24_0._profile_synchronizer, arg_24_0._network_event_delegate, arg_24_0._network_transmit)
		end

		local var_24_0 = arg_24_0:_get_parading_screen_duration()

		Managers.ui:handle_transition("versus_team_parading_view", {
			menu_state_name = "parading",
			duration = var_24_0
		})

		arg_24_0._parading_timer = Managers.time:time("game") + var_24_0

		arg_24_0:_stop_advertise_playing()
	elseif arg_24_1 == "pre_start_round_state" then
		if arg_24_0._versus_party_selection_logic then
			arg_24_0._versus_party_selection_logic:destroy()

			arg_24_0._versus_party_selection_logic = nil
		end

		arg_24_0:_advertise_playing()
		arg_24_0:_update_profiles()
		arg_24_0:_spawn_pact_sworn("dark_pact")
		arg_24_0:_init_pact_sworn_camera_state()
		arg_24_0:_start_objective()
		Managers.state.event:trigger("versus_pre_start_initialized")
		Managers.ui:handle_transition("exit_menu", {
			use_fade = true,
			fade_in_speed = GameSettings.transition_fade_in_speed
		})

		if arg_24_0._is_server then
			Managers.state.entity:system("ghost_mode_system"):set_active(true)
		end
	elseif arg_24_1 == "match_running_state" then
		if not DEDICATED_SERVER then
			arg_24_0:_round_start_telemetry()
		end

		if arg_24_2 ~= "pre_start_round_state" then
			arg_24_0:_init_pact_sworn_camera_state()
			arg_24_0:_advertise_playing()
		end

		if arg_24_0._is_server then
			Managers.state.entity:system("ghost_mode_system"):set_active(true)
		end
	elseif arg_24_1 == "post_round_state" then
		arg_24_0:play_sound("Stop_versus_hud_last_hero_down_riser")
		arg_24_0:_register_disabled_as_eliminiations()
		arg_24_0._win_conditions:round_ended()
		arg_24_0:_stop_advertise_playing()
	end
end

function GameModeVersus._advertise_playing(arg_25_0)
	return
end

function GameModeVersus._stop_advertise_playing(arg_26_0)
	if not DEDICATED_SERVER then
		local var_26_0 = Managers.mechanism:network_handler()

		if var_26_0.lobby_client and var_26_0.lobby_client.stop_advertise_playing then
			var_26_0.lobby_client:stop_advertise_playing()
		end
	end
end

function GameModeVersus._update_profiles(arg_27_0)
	if not arg_27_0._is_server then
		return
	end

	local var_27_0 = Managers.party:parties()

	for iter_27_0 = 1, #var_27_0 do
		local var_27_1 = var_27_0[iter_27_0]

		if var_27_1.game_participating then
			local var_27_2 = var_27_1.occupied_slots

			for iter_27_1 = 1, #var_27_2 do
				local var_27_3 = var_27_2[iter_27_1]

				arg_27_0:_update_profile_in_party(var_27_3.peer_id, var_27_3.local_player_id, var_27_1.party_id)
			end
		end
	end
end

function GameModeVersus._init_pact_sworn_camera_state(arg_28_0)
	local var_28_0 = Managers.party:get_local_player_party()
	local var_28_1 = Managers.state.side.side_by_party[var_28_0]

	if var_28_1 and var_28_1:name() == "dark_pact" then
		local var_28_2 = Managers.player:local_player()

		CharacterStateHelper.change_camera_state(var_28_2, "observer", {
			input_service_name = "dark_pact_selection"
		})
	end
end

function GameModeVersus._spawn_pact_sworn(arg_29_0)
	local var_29_0 = Managers.state.entity:system("versus_horde_ability_system")
	local var_29_1 = Managers.party:get_party_from_name("dark_pact")
	local var_29_2 = 0
	local var_29_3 = var_29_1.occupied_slots

	for iter_29_0 = 1, #var_29_3 do
		local var_29_4 = var_29_3[iter_29_0]
		local var_29_5 = var_29_4.peer_id
		local var_29_6 = var_29_4.local_player_id

		arg_29_0._versus_spawning:setup_data(var_29_5, var_29_6)

		if arg_29_0._is_server then
			arg_29_0._versus_spawning:set_spawn_state(var_29_5, var_29_6, "w8_for_profile", 0, var_29_2, true)
			var_29_0:server_register_peer(var_29_5)
		end
	end
end

function GameModeVersus.assign_temporary_dark_pact_profile(arg_30_0, arg_30_1)
	local var_30_0 = PROFILES_BY_NAME.vs_undecided

	arg_30_0:set_profile(arg_30_1, var_30_0.index, 1, false)
end

function GameModeVersus.round_started(arg_31_0)
	if arg_31_0._is_server then
		Managers.state.entity:system("dialogue_system"):queue_mission_giver_event("vs_mg_heroes_left_safe_room")
	end

	Managers.state.entity:system("versus_horde_ability_system"):on_round_started()
end

function GameModeVersus.server_update(arg_32_0, arg_32_1, arg_32_2)
	GameModeVersus.super.server_update(arg_32_0, arg_32_1, arg_32_2)

	local var_32_0 = arg_32_0._mechanism:get_slot_reservation_handler(Network.peer_id(), var_0_0.session)

	if DEDICATED_SERVER then
		arg_32_0:_handle_dedicated_input(arg_32_1, arg_32_2)
	end

	if var_32_0 and var_32_0.handle_dangling_peers then
		var_32_0:handle_dangling_peers()
	end

	if arg_32_0._initial_peers_ready then
		if not arg_32_0._initial_peers_spawned then
			arg_32_0:_update_initial_peers_spawned()
		end

		arg_32_0._win_conditions:server_update(arg_32_1, arg_32_2)
	end

	local var_32_1 = arg_32_0._game_mode_state

	if var_32_1 == "initial_state" then
		if DEDICATED_SERVER then
			if var_32_0:is_empty() then
				arg_32_0:change_game_mode_state("dedicated_server_abort_game")
			else
				arg_32_0._mechanism:signal_reservers_to_join(arg_32_1, arg_32_0._network_server)
				arg_32_0:change_game_mode_state("waiting_for_players_to_join")
			end
		else
			arg_32_0:change_game_mode_state("waiting_for_players_to_join")
		end
	elseif var_32_1 == "waiting_for_players_to_join" then
		arg_32_0._start_game_timeout_timer = arg_32_0._start_game_timeout_timer + arg_32_2

		local var_32_2 = arg_32_0._network_server.lobby_host:members():members_map()
		local var_32_3 = DEDICATED_SERVER and var_32_0:is_all_reserved_peers_joined(var_32_2) and arg_32_0._initial_peers_ready
		local var_32_4 = not DEDICATED_SERVER and arg_32_0._initial_peers_ready

		if var_32_3 or var_32_4 then
			if arg_32_0._current_mechanism_state == "round_1" and arg_32_0._mechanism:get_current_set() == 1 then
				if arg_32_0._settings.display_character_picking_view then
					arg_32_0:change_game_mode_state("character_selection_state")
				end
			elseif arg_32_0._profile_synchronizer:all_synced() then
				arg_32_0:change_game_mode_state("pre_start_round_state")
			end
		elseif arg_32_0:_start_game_timeout() then
			arg_32_0._start_game_timeout_timer = 0

			for iter_32_0, iter_32_1 in pairs(var_32_2) do
				if not arg_32_0._network_server:is_peer_ready(iter_32_0) then
					printf("[game_mode_versus] kicking timed out peer %s in state %s", iter_32_0, arg_32_0._game_mode_state)
					arg_32_0._network_server:kick_peer(iter_32_0)
				end
			end
		end
	elseif var_32_1 == "dedicated_server_abort_game" then
		arg_32_0._network_server:all_client_peers_disconnected()

		if arg_32_0._network_server:all_client_peers_disconnected() then
			if script_data.testify then
				arg_32_0._transition_state = "restart_game_server"
			elseif arg_32_0:_delay_abort_game(arg_32_1) then
				-- block empty
			else
				arg_32_0._transition_state = "quit_game"
			end
		end
	elseif var_32_1 == "character_selection_state" then
		-- block empty
	elseif var_32_1 == "player_team_parading_state" then
		if arg_32_1 > arg_32_0._parading_timer then
			arg_32_0:change_game_mode_state("pre_start_round_state")
		end
	elseif var_32_1 == "pre_start_round_state" then
		arg_32_0._adventure_spawning:server_update(arg_32_1, arg_32_2)
		arg_32_0._versus_spawning:update(arg_32_1, arg_32_2)

		local var_32_5 = math.ceil(arg_32_0.pre_round_start_timer - arg_32_1)

		if arg_32_0._initial_peers_spawned then
			if not arg_32_0._time_left then
				arg_32_0._time_left = var_32_5
			end

			if arg_32_0._is_server and not arg_32_0._pre_round_start_vo then
				local var_32_6 = Managers.state.entity:system("dialogue_system")

				if var_32_6:has_local_player_moved_from_start_position() then
					arg_32_0._pre_round_start_vo = true

					var_32_6:queue_mission_giver_event("vs_mg_round_start")
				end
			end

			if var_32_5 < arg_32_0._time_left then
				arg_32_0._time_left = var_32_5

				if arg_32_0._is_server and not DEDICATED_SERVER then
					Managers.state.event:trigger("ui_update_start_round_counter", var_32_5)
					Managers.state.event:trigger("ui_tab_update_start_round_counter", var_32_5)
				end

				Managers.state.network.network_transmit:send_rpc_clients("rpc_update_start_round_countdown_timer", var_32_5)
			end
		end

		if arg_32_1 > arg_32_0.pre_round_start_timer and arg_32_0._initial_peers_spawned then
			local var_32_7 = LevelHelper:current_level(arg_32_0._world)
			local var_32_8 = "round_started_set_" .. arg_32_0._mechanism:get_current_set()

			Level.trigger_event(var_32_7, var_32_8)
			Managers.state.network.network_transmit:send_rpc_clients("rpc_trigger_level_event", var_32_8)
			Level.trigger_event(var_32_7, "remove_safe_zone_wall")
			Managers.state.network.network_transmit:send_rpc_clients("rpc_trigger_level_event", "remove_safe_zone_wall")
			arg_32_0:change_game_mode_state("match_running_state")

			if arg_32_0._is_server and not DEDICATED_SERVER then
				Managers.state.event:trigger("ui_round_started")
			end

			Managers.state.network.network_transmit:send_rpc_clients("rpc_ui_round_started")

			arg_32_0._time_left = nil
		end
	elseif var_32_1 == "match_running_state" then
		arg_32_0._adventure_spawning:server_update(arg_32_1, arg_32_2)
		arg_32_0._versus_spawning:update(arg_32_1, arg_32_2)

		if arg_32_0._horde_surge_handler then
			arg_32_0._horde_surge_handler:server_update(arg_32_1, arg_32_2)
		end
	elseif var_32_1 == "post_round_state" then
		-- block empty
	else
		fassert(false, "Unknown state", var_32_1)
	end

	if DEDICATED_SERVER and arg_32_0._settings.allow_hotjoining_ongoing_game and arg_32_0._settings.allowed_hotjoin_states[var_32_1] then
		arg_32_0._mechanism:signal_reservers_to_join(arg_32_1, arg_32_0._network_server)
	end

	if arg_32_0._transition_state == "wait_until_empty" then
		arg_32_0._transition_state_time = arg_32_0._transition_state_time + arg_32_2

		if not (arg_32_0._transition_state_time > GameModeVersus.WAIT_FOR_CLIENTS_TO_LEAVE_TIMEOUT) and not arg_32_0._network_server:all_client_peers_disconnected() or arg_32_0:_delay_abort_game(arg_32_1) then
			-- block empty
		else
			arg_32_0._transition_state = "quit_game"
		end
	end
end

local var_0_4 = 30

function GameModeVersus._delay_abort_game(arg_33_0, arg_33_1)
	local var_33_0 = Managers.telemetry:batch_in_flight()
	local var_33_1 = Managers.telemetry:has_events_to_post()

	if var_33_0 or var_33_1 then
		arg_33_0._delay_abort_game_timer = arg_33_0._delay_abort_game_timer or arg_33_1 + var_0_4
	end

	if var_33_1 and not var_33_0 then
		Managers.telemetry:post_batch()
	end

	return arg_33_0._delay_abort_game_timer and arg_33_1 < arg_33_0._delay_abort_game_timer
end

function GameModeVersus._client_update(arg_34_0, arg_34_1, arg_34_2)
	arg_34_0._win_conditions:client_update(arg_34_1, arg_34_2)

	if arg_34_0._game_mode_state == "match_running_state" then
		-- block empty
	end

	if arg_34_0._horde_surge_handler then
		arg_34_0._horde_surge_handler:client_update(arg_34_1, arg_34_2)
	end

	if arg_34_0.pactsworn_video_transition_view then
		arg_34_0.pactsworn_video_transition_view:update(arg_34_2)
	end
end

function GameModeVersus._start_game_timeout(arg_35_0)
	local var_35_0 = 10

	if arg_35_0._game_mode_state == "waiting_for_players_to_join" then
		var_35_0 = 120
	end

	return var_35_0 < arg_35_0._start_game_timeout_timer
end

function GameModeVersus._update_initial_peers_spawned(arg_36_0)
	local var_36_0 = true
	local var_36_1 = Managers.player
	local var_36_2 = Managers.party:get_party_from_name("heroes").occupied_slots

	for iter_36_0 = 1, #var_36_2 do
		local var_36_3 = var_36_2[iter_36_0]
		local var_36_4 = var_36_3.peer_id
		local var_36_5 = var_36_3.local_player_id
		local var_36_6 = var_36_1:player(var_36_4, var_36_5)

		if not Unit.alive(var_36_6.player_unit) then
			var_36_0 = false
		end
	end

	if var_36_0 then
		Managers.state.game_mode:trigger_event("initial_peers_spawned")
	end
end

function GameModeVersus._handle_dedicated_input(arg_37_0, arg_37_1, arg_37_2)
	CommandWindow.update()

	local var_37_0 = CommandWindow.read_line()

	if var_37_0 then
		Managers.admin:execute_command(var_37_0)
	end
end

function GameModeVersus.all_peers_ready(arg_38_0)
	GameModeVersus.super.all_peers_ready(arg_38_0)
end

function GameModeVersus.complete_level(arg_39_0, arg_39_1)
	arg_39_0._level_completed = true
end

function GameModeVersus.FAIL_LEVEL(arg_40_0)
	arg_40_0._level_failed = true
end

function GameModeVersus.evaluate_end_condition_outcome(arg_41_0, arg_41_1, arg_41_2)
	if DEDICATED_SERVER or arg_41_1 == nil then
		return false, false
	end

	local var_41_0 = false
	local var_41_1 = false
	local var_41_2 = arg_41_2:network_id()
	local var_41_3 = arg_41_2:local_player_id()
	local var_41_4 = Managers.party:get_party_from_player_id(var_41_2, var_41_3)

	if arg_41_1 == "party_one_won" or arg_41_1 == "party_one_won_early" then
		if var_41_4.party_id == 1 then
			var_41_0 = true
		elseif var_41_4.party_id == 2 then
			var_41_1 = true
		end
	elseif arg_41_1 == "party_two_won" or arg_41_1 == "party_two_won_early" then
		if var_41_4.party_id == 1 then
			var_41_1 = true
		elseif var_41_4.party_id == 2 then
			var_41_0 = true
		end
	end

	return var_41_0, var_41_1, arg_41_1
end

function GameModeVersus.gm_event_end_conditions_met(arg_42_0, arg_42_1, arg_42_2, arg_42_3)
	local var_42_0 = Managers.state.entity:system("objective_system")

	arg_42_0._objectives_completed = var_42_0:num_completed_main_objectives()
	arg_42_0._total_main_objectives = var_42_0:num_main_objectives()
	arg_42_0._end_reason = arg_42_1
end

function GameModeVersus.gm_event_initial_peers_spawned(arg_43_0)
	local var_43_0

	if Managers.mechanism:game_mechanism():get_current_set() == 1 then
		var_43_0 = Managers.state.game_mode:setting("initial_set_pre_start_duration")
	else
		var_43_0 = Managers.state.game_mode:setting("pre_start_round_duration")
	end

	arg_43_0._pre_start_round_countdown = var_43_0
	arg_43_0.pre_round_start_timer = Managers.time:time("game") + var_43_0
	arg_43_0._initial_peers_spawned = true
end

function GameModeVersus.initial_peers_spawned(arg_44_0)
	return arg_44_0._initial_peers_spawned
end

function GameModeVersus.get_extra_observer_units(arg_45_0, arg_45_1)
	local var_45_0

	if not Managers.state.game_mode:is_round_started() then
		local var_45_1 = Managers.mechanism:game_mechanism():get_current_spawn_group()
		local var_45_2, var_45_3, var_45_4 = arg_45_0._versus_spawning:get_spawn_point(var_45_1, arg_45_1)

		if var_45_4 then
			var_45_0 = {
				var_45_4
			}
		end
	end

	return var_45_0
end

function GameModeVersus._player_entered_party(arg_46_0, arg_46_1, arg_46_2, arg_46_3)
	local var_46_0 = arg_46_2:name()

	if arg_46_3 and arg_46_3.local_player and var_46_0 == "heroes" then
		local var_46_1 = arg_46_3.peer_id
		local var_46_2 = arg_46_3:local_player_id()
		local var_46_3 = Managers.party:get_player_status(var_46_1, var_46_2)

		if not var_46_3.preferred_profile_index then
			local var_46_4, var_46_5 = arg_46_0._profile_synchronizer:profile_by_peer(var_46_1, var_46_2)

			var_46_3.preferred_profile_index = var_46_4
			var_46_3.preferred_career_index = var_46_5
		end
	end
end

function GameModeVersus.player_entered_game_session(arg_47_0, arg_47_1, arg_47_2, arg_47_3)
	GameModeVersus.super.player_entered_game_session(arg_47_0, arg_47_1, arg_47_2, arg_47_3)

	local var_47_0 = Managers.party
	local var_47_1 = arg_47_0._mechanism:handle_party_assignment_for_joining_peer(arg_47_1, arg_47_2)

	printf("[GameModeVersus] player_entered_game_session: %s:%s, party_id: %s", arg_47_1, arg_47_2, var_47_1)

	local var_47_2, var_47_3 = arg_47_0._mechanism:update_wanted_hero_character(arg_47_1, arg_47_2, var_47_1)
	local var_47_4 = arg_47_0._bot_players[var_47_1]

	if var_47_4 and #var_47_4 > 0 then
		if arg_47_0._settings.duplicate_hero_profiles_allowed then
			arg_47_0:_remove_last_added_bot(var_47_1)
		else
			local var_47_5 = true

			arg_47_0:_remove_bot_by_profile(var_47_1, var_47_2, var_47_5)
		end
	end

	local var_47_6, var_47_7 = Managers.party:get_party_from_player_id(arg_47_1, arg_47_2)

	if var_47_1 ~= var_47_7 then
		var_47_0:request_join_party(arg_47_1, arg_47_2, var_47_1)
	elseif arg_47_0._mechanism:profiles_reservable() then
		arg_47_0:_update_profile_in_party(arg_47_1, arg_47_2, var_47_1)
	end
end

function GameModeVersus.player_left_game_session(arg_48_0, arg_48_1, arg_48_2)
	if table.size(arg_48_0._network_server.peer_state_machines) - 1 <= 0 then
		arg_48_0:change_game_mode_state("dedicated_server_abort_game")
	end
end

function GameModeVersus._assign_peer_to_wanted_hero_profile(arg_49_0, arg_49_1, arg_49_2, arg_49_3)
	local var_49_0 = Managers.party:get_player_status(arg_49_1, arg_49_2)

	assert(not var_49_0.is_bot, "this should not be called on a bot, due to profile reservations ")

	local var_49_1, var_49_2 = Managers.mechanism:get_persistent_profile_index_reservation(arg_49_1)
	local var_49_3, var_49_4, var_49_5 = arg_49_0._mechanism:update_wanted_hero_character(arg_49_1, arg_49_2, arg_49_3)

	printf("[GameModeVersus] assigned profile for %s: profile_index: %s, career_index: %s, reason: %s (previous: %s, %s)", arg_49_1, var_49_3, var_49_4, var_49_5, var_49_1, var_49_2)
	arg_49_0:set_profile(var_49_0, var_49_3, var_49_4, nil)

	return var_49_3, var_49_4
end

function GameModeVersus.set_profile(arg_50_0, arg_50_1, arg_50_2, arg_50_3, arg_50_4)
	local var_50_0

	if arg_50_4 ~= nil then
		var_50_0 = arg_50_4
	else
		var_50_0 = arg_50_0:is_in_round_state()
	end

	local var_50_1 = SPProfiles[arg_50_2]

	if arg_50_0._is_server then
		arg_50_0._profile_requester:request_profile(arg_50_1.peer_id, arg_50_1.local_player_id, var_50_1.display_name, var_50_1.careers[arg_50_3].display_name, var_50_0)
	else
		Managers.state.network:request_profile(arg_50_1.local_player_id, var_50_1.display_name, var_50_1.careers[arg_50_3].display_name, var_50_0)
	end
end

function GameModeVersus._update_profile_in_party(arg_51_0, arg_51_1, arg_51_2, arg_51_3)
	local var_51_0 = Managers.party:get_player_status(arg_51_1, arg_51_2)

	if var_51_0.is_bot then
		return
	end

	arg_51_0._profile_synchronizer:unassign_profiles_of_peer(arg_51_1, arg_51_2)

	local var_51_1 = Managers.party:get_party(arg_51_3)

	if var_51_1.name == "heroes" then
		local var_51_2, var_51_3 = arg_51_0:_assign_peer_to_wanted_hero_profile(arg_51_1, arg_51_2, arg_51_3)
	elseif var_51_1.name == "dark_pact" then
		arg_51_0:assign_temporary_dark_pact_profile(var_51_0)
	end
end

function GameModeVersus.player_joined_party(arg_52_0, arg_52_1, arg_52_2, arg_52_3, arg_52_4, arg_52_5)
	GameModeVersus.super.player_joined_party(arg_52_0, arg_52_1, arg_52_2, arg_52_3, arg_52_4, arg_52_5)

	local var_52_0 = Managers.party:get_party(arg_52_3)
	local var_52_1 = var_52_0.slots[arg_52_4]

	if var_52_1.is_bot then
		return
	end

	printf("[GAMEMODEVERSUS] player_joined_party: %s, %s, %s, is_bot: %s, game_mode_state: %s, has_party_selection_logic: %s", arg_52_1, arg_52_2, arg_52_3, var_52_1.is_bot, arg_52_0._game_mode_state, arg_52_0._versus_party_selection_logic)

	if arg_52_3 == 0 then
		return
	end

	if arg_52_0._versus_party_selection_logic then
		arg_52_0._versus_party_selection_logic:player_joined_party(arg_52_1, arg_52_2, arg_52_3, arg_52_4)
	elseif arg_52_0._is_server and arg_52_0._mechanism:profiles_reservable() then
		arg_52_0:_update_profile_in_party(arg_52_1, arg_52_2, arg_52_3)
	end

	local var_52_2 = Managers.state.side.side_by_party[var_52_0]:name()

	if arg_52_0._is_server and var_52_2 == "dark_pact" and arg_52_0:is_in_round_state() then
		local var_52_3 = arg_52_0._versus_spawning:get_spawn_time(var_52_0)

		arg_52_0._versus_spawning:setup_data(arg_52_1, arg_52_2)
		arg_52_0._versus_spawning:set_spawn_state(arg_52_1, arg_52_2, "w8_for_profile", 0, var_52_3, true)
		Managers.state.entity:system("versus_horde_ability_system"):server_register_peer(arg_52_1)
	end

	local var_52_4 = var_52_1.player

	if var_52_4 and var_52_4.local_player then
		if var_52_2 == "spectators" then
			local var_52_5 = Managers.state.entity:system("camera_system")
			local var_52_6 = PROFILES_BY_NAME.spectator

			var_52_5:initialize_camera_states(var_52_4, var_52_6.index, 1)
			CharacterStateHelper.change_camera_state(var_52_4, "observer")
		elseif var_52_2 == "dark_pact" and arg_52_0:is_in_round_state() then
			CharacterStateHelper.change_camera_state(var_52_4, "observer", {
				input_service_name = "dark_pact_selection"
			})
		end

		if Managers.mechanism:get_persistent_profile_index_reservation(arg_52_1) ~= 0 then
			arg_52_0:update_local_hero_cosmetics()
		end
	end
end

function GameModeVersus.profile_changed(arg_53_0, arg_53_1, arg_53_2, arg_53_3, arg_53_4, arg_53_5)
	if not arg_53_5 and arg_53_1 == Network.peer_id() then
		arg_53_0:update_local_hero_cosmetics()
	end
end

function GameModeVersus.server_validate_horde_timer(arg_54_0, arg_54_1)
	local var_54_0 = Managers.state.conflict

	if not var_54_0 then
		return
	end

	local var_54_1, var_54_2 = var_54_0:get_horde_timer()

	arg_54_0._horde_delayed = var_54_2

	if arg_54_0._horde_timer ~= var_54_1 or var_54_2 then
		arg_54_0._horde_timer = var_54_1

		if not arg_54_0._horde_timer then
			return
		end

		arg_54_0._time_until_next_horde = arg_54_0._horde_timer - arg_54_1

		if arg_54_0._time_until_next_horde > 0 then
			Managers.state.network.network_transmit:send_rpc_clients("rpc_sync_next_horde_time", arg_54_0._time_until_next_horde, var_54_2)
		end
	end
end

function GameModeVersus.rpc_sync_next_horde_time(arg_55_0, arg_55_1, arg_55_2, arg_55_3)
	arg_55_0._time_until_next_horde = arg_55_2 + Managers.time:time("game")
	arg_55_0._horde_delayed = arg_55_3
end

function GameModeVersus.display_debug_horde_timer_pactsworn(arg_56_0, arg_56_1, arg_56_2)
	if not arg_56_0._settings.show_horde_timer_pactsworn then
		return
	end

	local var_56_0 = Managers.player:local_player()

	if Managers.state.side:get_side_from_player_unique_id(var_56_0:unique_id())._name == "dark_pact" then
		local var_56_1 = arg_56_0._time_until_next_horde
		local var_56_2 = RESOLUTION_LOOKUP.res_w * 0.6
		local var_56_3 = Color(100, 255, 0)
		local var_56_4 = Vector3(var_56_2, 0, 10)
		local var_56_5 = 40

		if var_56_1 and var_56_1 >= 0 and var_56_1 <= 1000 then
			if arg_56_0._horde_delayed then
				var_56_1 = string.format("Next horde(DELAYED): %2d", var_56_1 - arg_56_1)
			else
				var_56_1 = string.format("Next horde: %2d", var_56_1 - arg_56_1)
			end

			Debug.draw_text(var_56_1, var_56_4, var_56_5, var_56_3)
		else
			local var_56_6 = "Next horde: NIL"

			Debug.draw_text(var_56_6, var_56_4, var_56_5, var_56_3)
		end
	end
end

function GameModeVersus.players_left_safe_zone(arg_57_0)
	if arg_57_0._horde_surge_handler then
		arg_57_0._horde_surge_handler:activate()
	end
end

function GameModeVersus.player_left_party(arg_58_0, arg_58_1, arg_58_2, arg_58_3, arg_58_4, arg_58_5)
	if arg_58_0._versus_party_selection_logic then
		arg_58_0._versus_party_selection_logic:player_left_party(arg_58_1, arg_58_2, arg_58_3, arg_58_4, arg_58_5)
	end
end

function GameModeVersus.local_player_ready_to_start(arg_59_0, arg_59_1)
	local var_59_0 = arg_59_0._game_mode_state

	if not arg_59_0._is_server and not arg_59_0:is_in_round_state() and var_59_0 ~= "character_selection_state" then
		return false
	end

	if arg_59_0._is_server and not arg_59_0._initial_peers_ready then
		return false
	end

	return true
end

function GameModeVersus.local_player_game_starts(arg_60_0, arg_60_1, arg_60_2)
	local var_60_0 = arg_60_1:network_id()
	local var_60_1 = arg_60_1:local_player_id()
	local var_60_2 = Managers.party:get_party_from_player_id(var_60_0, var_60_1)
	local var_60_3 = Managers.state.side.side_by_party[var_60_2]

	arg_60_0:_player_entered_party(var_60_2, var_60_3, arg_60_1)
end

function GameModeVersus.level_key(arg_61_0)
	return arg_61_0._level_key
end

function GameModeVersus._start_objective(arg_62_0)
	if not arg_62_0._is_server then
		return
	end

	if arg_62_0:_get_objectives_current_set() then
		Managers.state.entity:system("objective_system"):server_activate_first_objective()
	end
end

function GameModeVersus._get_objective_list_name_current_set(arg_63_0)
	local var_63_0 = arg_63_0._mechanism:get_objective_settings().objective_lists

	if var_63_0 then
		return var_63_0[Managers.mechanism:game_mechanism():get_current_set()]
	end
end

function GameModeVersus._get_objectives_current_set(arg_64_0)
	return ObjectiveLists[arg_64_0:_get_objective_list_name_current_set()]
end

function GameModeVersus.get_current_objective_data(arg_65_0)
	local var_65_0 = Managers.state.entity:system("objective_system")

	return arg_65_0:_get_objectives_current_set()[var_65_0:current_objective_index()]
end

function GameModeVersus.get_next_objective_data(arg_66_0)
	local var_66_0 = Managers.state.entity:system("objective_system")

	return arg_66_0:_get_objectives_current_set()[var_66_0:current_objective_index() + 1]
end

function GameModeVersus.disable_player_spawning(arg_67_0)
	arg_67_0._adventure_spawning:set_spawning_disabled(true)
end

function GameModeVersus.enable_player_spawning(arg_68_0, arg_68_1, arg_68_2)
	arg_68_0._adventure_spawning:set_spawning_disabled(false)
	arg_68_0._adventure_spawning:force_update_spawn_positions(arg_68_1, arg_68_2)
end

function GameModeVersus.teleport_despawned_players(arg_69_0, arg_69_1)
	arg_69_0._adventure_spawning:teleport_despawned_players(arg_69_1)
end

function GameModeVersus.flow_callback_add_spawn_point(arg_70_0, arg_70_1)
	arg_70_0._adventure_spawning:add_spawn_point(arg_70_1)
end

function GameModeVersus.flow_callback_add_game_mode_specific_spawn_point(arg_71_0, arg_71_1, arg_71_2)
	for iter_71_0, iter_71_1 in ipairs(arg_71_2) do
		if iter_71_1 == "heroes" then
			arg_71_0._adventure_spawning:add_spawn_point_to_spawn_group(arg_71_1)
		elseif iter_71_1 == "dark_pact" then
			arg_71_0._versus_spawning:add_spawn_point(arg_71_1)
		end
	end
end

function GameModeVersus.respawn_unit_spawned(arg_72_0, arg_72_1)
	if arg_72_0._hero_rescues_enabled and Unit.get_data(arg_72_1, "vs_set_id") == arg_72_0._mechanism:get_current_set() then
		arg_72_0._adventure_spawning:respawn_unit_spawned(arg_72_1)
	end
end

function GameModeVersus.get_respawn_handler(arg_73_0)
	return arg_73_0._adventure_spawning:get_respawn_handler()
end

function GameModeVersus.respawn_gate_unit_spawned(arg_74_0, arg_74_1)
	arg_74_0._adventure_spawning:respawn_gate_unit_spawned(arg_74_1)
end

function GameModeVersus.set_respawning_enabled(arg_75_0, arg_75_1)
	arg_75_0._adventure_spawning:set_respawning_enabled(arg_75_1)
end

function GameModeVersus.force_respawn(arg_76_0, arg_76_1, arg_76_2)
	local var_76_0 = Managers.party:get_party_from_player_id(arg_76_1, arg_76_2)
	local var_76_1 = Managers.state.side.side_by_party[var_76_0]:name()

	if arg_76_0:is_in_round_state() then
		if var_76_1 == "heroes" then
			arg_76_0._adventure_spawning:force_respawn(arg_76_1, arg_76_2)
		elseif var_76_1 == "dark_pact" then
			arg_76_0._versus_spawning:force_respawn(arg_76_1, arg_76_2)
		end
	end
end

function GameModeVersus._handle_bots(arg_77_0, arg_77_1, arg_77_2)
	if not arg_77_0._hero_bots_enabled then
		return
	end

	if not (Managers.state.network ~= nil and not Managers.state.network.game_session_shutdown) then
		return
	end

	for iter_77_0, iter_77_1 in pairs(arg_77_0._bot_players) do
		local var_77_0 = Managers.party:get_party(iter_77_0)

		if arg_77_0._settings.party_settings[var_77_0.name].using_bots then
			arg_77_0:_remove_partyless_bots(iter_77_1)

			local var_77_1 = var_77_0.num_slots
			local var_77_2 = var_77_1 - #iter_77_1

			if var_77_2 > 0 then
				local var_77_3 = var_77_1 - var_77_0.num_used_slots

				if math.min(var_77_2, var_77_3) > 0 then
					arg_77_0:_add_bot(iter_77_0)

					return
				end
			elseif var_77_2 < 0 then
				for iter_77_2 = 1, math.abs(var_77_2) do
					arg_77_0:_remove_last_added_bot(iter_77_0)
				end
			end
		end
	end
end

function GameModeVersus.event_set_loadout_items(arg_78_0)
	arg_78_0:update_local_hero_cosmetics()
end

function GameModeVersus.update_local_hero_cosmetics(arg_79_0)
	if DEDICATED_SERVER then
		return
	end

	local var_79_0 = Managers.player:local_player()
	local var_79_1 = var_79_0:network_id()
	local var_79_2 = var_79_0:local_player_id()
	local var_79_3, var_79_4 = Managers.mechanism:get_persistent_profile_index_reservation(var_79_1)
	local var_79_5 = SPProfiles[var_79_3].careers[var_79_4]
	local var_79_6 = var_79_5.name
	local var_79_7 = var_79_5.preview_wield_slot
	local var_79_8 = InventorySettings.slot_names_by_type[var_79_7][1]
	local var_79_9 = BackendUtils.get_loadout_item(var_79_6, var_79_8)
	local var_79_10 = BackendUtils.get_loadout_item(var_79_6, "slot_pose")
	local var_79_11 = var_79_10 and CosmeticUtils.get_weapon_pose_skin(var_79_10.key)
	local var_79_12 = BackendUtils.get_loadout_item(var_79_6, "slot_skin")
	local var_79_13 = BackendUtils.get_loadout_item(var_79_6, "slot_hat")
	local var_79_14 = BackendUtils.get_loadout_item(var_79_6, "slot_frame")
	local var_79_15

	var_79_15 = var_79_9 and var_79_9.data.name or CosmeticUtils.get_default_cosmetic_slot(var_79_5, var_79_8).item_name

	local var_79_16

	var_79_16 = var_79_10 and var_79_10.data.name or CosmeticUtils.get_default_cosmetic_slot(var_79_5, "slot_pose").item_name

	local var_79_17

	var_79_17 = var_79_11 and var_79_11.skin or "n/a"

	local var_79_18

	var_79_18 = var_79_12 and var_79_12.data.name or CosmeticUtils.get_default_cosmetic_slot(var_79_5, "slot_skin").item_name

	local var_79_19

	var_79_19 = var_79_13 and var_79_13.data.name or CosmeticUtils.get_default_cosmetic_slot(var_79_5, "slot_hat").item_name

	local var_79_20

	var_79_20 = var_79_14 and var_79_14.data.name or CosmeticUtils.get_default_cosmetic_slot(var_79_5, "slot_frame").item_name

	local var_79_21 = arg_79_0:_pack_pactsworn_cosmetics()
	local var_79_22, var_79_23, var_79_24, var_79_25, var_79_26, var_79_27, var_79_28 = arg_79_0._mechanism:get_hero_cosmetics(var_79_1, var_79_2)

	if var_79_15 ~= var_79_22 or var_79_16 ~= var_79_23 or var_79_24 ~= var_79_17 or var_79_18 ~= var_79_25 or var_79_19 ~= var_79_26 or var_79_20 ~= var_79_27 or table.recursive_compare(var_79_28, var_79_21) then
		arg_79_0._mechanism:set_hero_cosmetics(var_79_1, var_79_2, var_79_8, var_79_15, var_79_16, var_79_17, var_79_18, var_79_19, var_79_20, var_79_21)
	end
end

function GameModeVersus._pack_pactsworn_cosmetics(arg_80_0)
	local var_80_0 = {}

	for iter_80_0 = 1, #SPProfiles do
		local var_80_1 = SPProfiles[iter_80_0]

		if var_80_1.affiliation == "dark_pact" then
			local var_80_2 = var_80_1.careers[1]
			local var_80_3 = var_80_2.name

			if var_80_3 ~= "vs_undecided" then
				local var_80_4 = var_80_2.preview_wield_slot
				local var_80_5 = InventorySettings.slot_names_by_type[var_80_4][1]
				local var_80_6 = BackendUtils.get_loadout_item(var_80_3, var_80_5)
				local var_80_7 = BackendUtils.get_loadout_item(var_80_3, "slot_skin")
				local var_80_8

				var_80_8 = var_80_7 and var_80_7.data.name or CosmeticUtils.get_default_cosmetic_slot(var_80_2, "slot_skin").item_name

				local var_80_9

				var_80_9 = var_80_6 and var_80_6.data.name or var_80_2.base_weapon
				var_80_0[var_80_3] = {
					weapon_slot = var_80_5,
					skin = var_80_8,
					weapon = var_80_9
				}
			end
		end
	end

	return var_80_0
end

function GameModeVersus._get_first_available_bot_profile(arg_81_0, arg_81_1)
	local var_81_0 = arg_81_0._available_profiles_by_party[arg_81_1]
	local var_81_1 = arg_81_0._profile_synchronizer
	local var_81_2 = {}

	for iter_81_0 = 1, #var_81_0 do
		local var_81_3 = var_81_0[iter_81_0]
		local var_81_4 = FindProfileIndex(var_81_3)

		if not var_81_1:is_profile_in_use(var_81_4) then
			var_81_2[#var_81_2 + 1] = var_81_4
		end
	end

	table.shuffle(var_81_2)

	for iter_81_1 = 1, #var_81_2 do
		local var_81_5 = var_81_2[iter_81_1]
		local var_81_6 = SPProfiles[var_81_5]
		local var_81_7 = var_81_6.display_name
		local var_81_8 = {}

		for iter_81_2 = 1, #var_81_6.careers do
			var_81_8[iter_81_2] = iter_81_2
		end

		table.shuffle(var_81_8)

		for iter_81_3 = 1, #var_81_8 do
			local var_81_9 = var_81_8[iter_81_3]
			local var_81_10 = var_81_6.careers[var_81_9]

			if var_81_10 and var_81_10:is_unlocked_function(var_81_7, math.huge) then
				return var_81_5, var_81_9
			end
		end
	end

	fassert(false, "Failed to find available bot profile profile for party " .. tostring(arg_81_1))
end

function GameModeVersus._add_bot(arg_82_0, arg_82_1)
	local var_82_0 = Managers.party:get_party(arg_82_1)
	local var_82_1 = Managers.party:find_first_empty_slot_id(var_82_0)
	local var_82_2, var_82_3 = arg_82_0._profile_synchronizer:get_bot_profile(arg_82_1, var_82_1)
	local var_82_4 = arg_82_0._mechanism:parse_hero_profile_availability(var_82_2, arg_82_1, nil, nil)
	local var_82_5 = arg_82_0._bot_players[arg_82_1]

	if var_82_4 then
		for iter_82_0 = 1, #var_82_5 do
			if var_82_4 == var_82_5[iter_82_0]:profile_index() then
				var_82_4 = nil

				break
			end
		end
	end

	if not var_82_4 then
		var_82_4, var_82_3 = arg_82_0:_get_first_available_bot_profile(arg_82_1)
	end

	local var_82_6 = arg_82_0:_add_bot_to_party(arg_82_1, var_82_4, var_82_3, var_82_1)

	var_82_5[#var_82_5 + 1] = var_82_6
end

function GameModeVersus._remove_bot(arg_83_0, arg_83_1, arg_83_2)
	printf("_remove_bot: %s", tostring(arg_83_2))

	for iter_83_0, iter_83_1 in pairs(arg_83_0._bot_players) do
		local var_83_0 = table.index_of(iter_83_1, arg_83_1)

		if var_83_0 >= 1 then
			if arg_83_2 then
				arg_83_0:_remove_bot_instant(arg_83_1)
			else
				arg_83_0:_remove_bot_update_safe(arg_83_1)
			end

			local var_83_1 = #iter_83_1

			iter_83_1[var_83_0] = iter_83_1[var_83_1]
			iter_83_1[var_83_1] = nil

			break
		end
	end
end

function GameModeVersus._clear_bots(arg_84_0, arg_84_1)
	for iter_84_0, iter_84_1 in pairs(arg_84_0._bot_players) do
		for iter_84_2 = #iter_84_1, 1, -1 do
			arg_84_0:_remove_bot(iter_84_1[iter_84_2], arg_84_1)
		end
	end
end

function GameModeVersus._remove_partyless_bots(arg_85_0, arg_85_1)
	local var_85_0 = Managers.party

	for iter_85_0 = #arg_85_1, 1, -1 do
		local var_85_1 = arg_85_1[iter_85_0]
		local var_85_2 = var_85_1:network_id()
		local var_85_3 = var_85_1:local_player_id()

		if not var_85_0:get_party_from_player_id(var_85_2, var_85_3) then
			arg_85_0:_remove_bot(arg_85_1[iter_85_0])
		end
	end
end

function GameModeVersus._remove_last_added_bot(arg_86_0, arg_86_1, arg_86_2)
	printf("_remove_last_added_bot")

	local var_86_0 = arg_86_0._bot_players[arg_86_1]
	local var_86_1 = #var_86_0

	arg_86_0:_remove_bot(var_86_0[var_86_1], arg_86_2)
end

function GameModeVersus._remove_bot_by_profile(arg_87_0, arg_87_1, arg_87_2, arg_87_3)
	printf("_remove_bot_by_profile: %s, from party: %s", arg_87_2, arg_87_1)

	local var_87_0 = arg_87_0._bot_players[arg_87_1]

	for iter_87_0, iter_87_1 in ipairs(var_87_0) do
		if iter_87_1:profile_index() == arg_87_2 then
			printf("found bot by profile to remove: %s", arg_87_2)

			return arg_87_0:_remove_bot(var_87_0[iter_87_0], arg_87_3)
		end
	end

	return arg_87_0:_remove_last_added_bot(arg_87_1, arg_87_3)
end

function GameModeVersus.get_active_respawn_units(arg_88_0)
	return arg_88_0._adventure_spawning:get_active_respawn_units()
end

function GameModeVersus.get_available_and_active_respawn_units(arg_89_0)
	return arg_89_0._adventure_spawning:get_available_and_active_respawn_units()
end

function GameModeVersus.adventure_spawning(arg_90_0)
	return arg_90_0._adventure_spawning
end

function GameModeVersus.horde_surge_handler(arg_91_0)
	return arg_91_0._horde_surge_handler
end

function GameModeVersus.in_training_mode(arg_92_0)
	return arg_92_0._training_mode
end

function GameModeVersus.get_num_occupied_profile_enemy_role(arg_93_0, arg_93_1, arg_93_2, arg_93_3)
	local var_93_0 = 0
	local var_93_1 = arg_93_2.occupied_slots

	for iter_93_0 = 1, #var_93_1 do
		local var_93_2 = var_93_1[iter_93_0]
		local var_93_3 = var_93_2.peer_id
		local var_93_4 = var_93_2.local_player_id
		local var_93_5 = arg_93_1:profile_by_peer(var_93_3, var_93_4)

		if var_93_5 and SPProfiles[var_93_5].enemy_role == arg_93_3 then
			var_93_0 = var_93_0 + 1
		end
	end

	return var_93_0
end

function GameModeVersus.get_end_screen_config(arg_94_0, arg_94_1, arg_94_2, arg_94_3, arg_94_4)
	local var_94_0
	local var_94_1
	local var_94_2

	if not (arg_94_4 == "party_one_won_early" or arg_94_4 == "party_two_won_early" or Development.parameter("versus_quick_match_end")) and arg_94_0._mechanism:should_start_next_set() then
		var_94_0 = "carousel_round_end"
		var_94_1 = {
			objectives_completed = arg_94_0._objectives_completed,
			total_main_objectives = arg_94_0._total_main_objectives,
			display_screen_delay = arg_94_0._settings.end_of_match_view_display_screen_delay
		}
	else
		var_94_0 = arg_94_1 and "victory" or arg_94_2 and "defeat" or "draw"
		var_94_1 = {
			show_act_presentation = false,
			display_screen_delay = arg_94_0._settings.end_of_match_view_display_screen_delay
		}
		var_94_2 = {
			reason = arg_94_4
		}
	end

	return var_94_0 or "none", var_94_1 or {}, var_94_2
end

function GameModeVersus.get_end_of_round_screen_settings(arg_95_0)
	return "carousel_round_end", {}, {}
end

function GameModeVersus.ended(arg_96_0, arg_96_1)
	if arg_96_0._current_mechanism_state == "round_2" and arg_96_0._mechanism:is_last_set() and not arg_96_0._network_server:are_all_peers_ingame() then
		arg_96_0._network_server:disconnect_joining_peers()
	end
end

function GameModeVersus.get_player_wounds(arg_97_0, arg_97_1)
	local var_97_0 = arg_97_1.affiliation
	local var_97_1 = arg_97_0._settings.player_wounds[var_97_0]

	if arg_97_0._mechanism:custom_settings_enabled() and var_97_0 == "heroes" then
		var_97_1 = arg_97_0._mechanism:get_custom_game_setting("wounds_amount") + 1
	end

	fassert(var_97_1, "Couldn't find player wounds for affiliation (%s)", var_97_0)

	return var_97_1
end

function GameModeVersus.get_initial_inventory(arg_98_0, arg_98_1, arg_98_2, arg_98_3, arg_98_4, arg_98_5)
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

function GameModeVersus.round_id(arg_99_0)
	return arg_99_0._round_id
end

function GameModeVersus.allowed_interactions(arg_100_0, arg_100_1, arg_100_2)
	local var_100_0 = Managers.state.side.side_by_unit[arg_100_1]:name()
	local var_100_1 = GameModeSettings.versus.side_settings[var_100_0].allowed_interactions

	if not var_100_1 then
		return true
	end

	if var_100_0 == "dark_pact" then
		local var_100_2 = ScriptUnit.has_extension(arg_100_1, "ghost_mode_system")

		if var_100_2 and var_100_2:is_in_ghost_mode() then
			return var_100_1.ghost_mode[arg_100_2] ~= nil
		end

		return var_100_1.normal[arg_100_2] ~= nil
	else
		return var_100_1[arg_100_2] ~= nil
	end
end

function GameModeVersus._disable_side_object_sets(arg_101_0)
	local var_101_0 = Managers.state.side:sides()

	for iter_101_0 = 1, #var_101_0 do
		local var_101_1 = var_101_0[iter_101_0]
		local var_101_2 = string.format("versus_%s", var_101_1:name())

		Managers.state.game_mode:set_object_set_enabled(var_101_2, false)
	end
end

function GameModeVersus.rpc_rejoin_parties(arg_102_0, arg_102_1)
	if arg_102_0._is_server then
		return
	end

	print("[GameModeVersus] Told to rejoin parties")

	arg_102_0._transition_state = "versus_migration"
end

function GameModeVersus.event_end_screen_ui_complete(arg_103_0)
	return
end

function GameModeVersus.play_sound(arg_104_0, arg_104_1)
	local var_104_0 = Managers.world:wwise_world(arg_104_0._world)

	WwiseWorld.trigger_event(var_104_0, arg_104_1)
end

function GameModeVersus._server_on_round_over(arg_105_0, arg_105_1)
	local var_105_0 = Managers.state.entity:system("audio_system")
	local var_105_1 = arg_105_1 and "Play_versus_hud_round_end_heroes_win" or "Play_versus_hud_round_end_heroes_fail"

	var_105_0:play_2d_audio_event(var_105_1)
end

function GameModeVersus.pick_pactsworn_spawn_category(arg_106_0, arg_106_1, arg_106_2)
	local var_106_0 = arg_106_0._settings.dark_pact_profile_rules
	local var_106_1 = {}

	for iter_106_0, iter_106_1 in pairs(var_106_0) do
		if iter_106_1 > arg_106_0:get_num_occupied_profile_enemy_role(arg_106_1, arg_106_2, iter_106_0) then
			var_106_1[#var_106_1 + 1] = iter_106_0
		end
	end

	assert(#var_106_1 ~= 0, "unable to pick pactsworn spawn category, no categories available")

	return var_106_1[Math.random(1, #var_106_1)]
end

function GameModeVersus._round_start_telemetry(arg_107_0)
	local var_107_0 = Managers.mechanism:game_mechanism()
	local var_107_1 = Managers.player:local_player()
	local var_107_2 = var_107_1.player_unit
	local var_107_3 = var_107_0:total_rounds_started()
	local var_107_4 = var_107_0:match_id()
	local var_107_5 = var_107_1:telemetry_id()
	local var_107_6
	local var_107_7
	local var_107_8

	if Unit.alive(var_107_2) and not Managers.state.side:versus_is_dark_pact(var_107_2) then
		local var_107_9 = Managers.player:player_loadouts()[var_107_1:unique_id()]

		if not var_107_9 then
			return
		end

		var_107_6 = var_107_9.slot_melee and var_107_9.slot_melee.key
		var_107_7 = var_107_9.slot_ranged and var_107_9.slot_ranged.key

		if ScriptUnit.has_extension(var_107_2, "talent_system") then
			var_107_8 = ScriptUnit.extension(var_107_2, "talent_system"):get_talent_names()
		end
	end

	Managers.telemetry_events:versus_round_started(var_107_5, var_107_3, var_107_4, var_107_6, var_107_7, var_107_8)
end

function GameModeVersus._custom_settings_telemetry(arg_108_0)
	local var_108_0, var_108_1, var_108_2 = arg_108_0._mechanism:get_custom_game_settings_handler():get_telemetry_data()
	local var_108_3 = Managers.player:local_player():telemetry_id()
	local var_108_4 = arg_108_0._mechanism:match_id()

	Managers.telemetry_events:versus_custom_game_settings(var_108_3, var_108_4, var_108_0, var_108_1, var_108_2)
end

function GameModeVersus._round_end_telemetry(arg_109_0)
	local var_109_0 = Managers.mechanism:game_mechanism()
	local var_109_1 = Managers.state.side:get_side_from_name("heroes").party.party_id
	local var_109_2 = var_109_0:total_rounds_started()
	local var_109_3 = var_109_0:match_id()
	local var_109_4 = arg_109_0._win_conditions:get_current_score(var_109_1)

	Managers.telemetry_events:versus_round_ended(var_109_4, var_109_2, var_109_3)
end

function GameModeVersus._match_end_telemetry(arg_110_0, arg_110_1)
	local var_110_0
	local var_110_1
	local var_110_2 = arg_110_0._mechanism:match_id()
	local var_110_3 = (arg_110_1 == "party_one_won" or arg_110_1 == "party_one_won_early") and 1 or (arg_110_1 == "party_two_won" or arg_110_1 == "party_two_won_early") and 2
	local var_110_4 = {}

	if var_110_3 then
		local var_110_5 = Managers.party:get_party(var_110_3).occupied_slots

		for iter_110_0 = 1, #var_110_5 do
			local var_110_6 = var_110_5[iter_110_0].peer_id

			var_110_4[iter_110_0] = var_110_6 and arg_110_0._mechanism:get_peer_backend_id(var_110_6)
		end
	else
		var_110_0 = true
	end

	Managers.telemetry_events:versus_match_ended(var_110_2, var_110_0, var_110_4)
end

function GameModeVersus.activated_ability_telemetry(arg_111_0, arg_111_1, arg_111_2)
	local var_111_0 = Managers.mechanism:game_mechanism()
	local var_111_1 = var_111_0:total_rounds_started()
	local var_111_2 = var_111_0:match_id()
	local var_111_3 = arg_111_2:telemetry_id()

	Managers.telemetry_events:versus_activated_ability(var_111_2, var_111_1, var_111_3, arg_111_1)
end

function GameModeVersus.menu_access_allowed_in_state(arg_112_0)
	if arg_112_0:is_in_round_state() then
		return true
	end

	return false
end

function GameModeVersus.request_selectable_dark_pact_careers(arg_113_0)
	arg_113_0._network_transmit:send_rpc_server("rpc_selectable_careers_request")
end

local var_0_5 = {
	waiting_for_players_to_join = true,
	character_selection_state = true,
	initial_state = true
}

function GameModeVersus.is_in_pre_match_state(arg_114_0)
	return var_0_5[arg_114_0._game_mode_state]
end

local var_0_6 = {
	pre_start_round_state = true,
	match_running_state = true
}

function GameModeVersus.is_in_round_state(arg_115_0)
	return var_0_6[arg_115_0._game_mode_state]
end

function GameModeVersus.match_is_running(arg_116_0)
	return arg_116_0._game_mode_state == "match_running_state"
end

function GameModeVersus.match_in_round_over_state(arg_117_0)
	return arg_117_0._game_mode_state == "post_round_state"
end

function GameModeVersus.game_mode_state(arg_118_0)
	return arg_118_0._game_mode_state
end

function GameModeVersus.rpc_selectable_careers_request(arg_119_0, arg_119_1)
	assert(arg_119_0._is_server, "[GameModeVersus] 'rpc_selectable_careers_request' may only be received by the server")

	local var_119_0 = CHANNEL_TO_PEER_ID[arg_119_1]

	if not var_119_0 then
		return
	end

	local var_119_1, var_119_2 = arg_119_0._dark_pact_career_delegator:request_careers(var_119_0)
	local var_119_3 = NetworkLookup.versus_dark_pact_profile_rules[var_119_2]

	for iter_119_0 = 1, #var_119_1 do
		var_119_1[iter_119_0] = PROFILES_BY_NAME[var_119_1[iter_119_0]].index
	end

	arg_119_0._network_transmit:send_rpc("rpc_selectable_careers_response", var_119_0, var_119_3, var_119_1)
end

function GameModeVersus.rpc_selectable_careers_response(arg_120_0, arg_120_1, arg_120_2, arg_120_3)
	local var_120_0 = NetworkLookup.versus_dark_pact_profile_rules[arg_120_2]

	for iter_120_0 = 1, #arg_120_3 do
		arg_120_3[iter_120_0] = SPProfiles[arg_120_3[iter_120_0]].display_name
	end

	Managers.state.event:trigger("versus_received_selectable_careers_response", var_120_0, arg_120_3)
end

function GameModeVersus.increment_num_picks_for_career(arg_121_0)
	arg_121_0._dark_pact_career_delegator:increment_num_picks_for_career()
end

function GameModeVersus.decrement_num_picks_for_career(arg_122_0)
	arg_122_0._dark_pact_career_delegator:decrement_num_picks_for_career()
end

function GameModeVersus.set_playable_boss_can_be_picked(arg_123_0, arg_123_1)
	if arg_123_0._boss_has_been_played then
		return
	end

	if arg_123_0._is_server then
		printf("[VS BOSS] trigger playable boss")

		arg_123_0._boss_has_been_played = true

		arg_123_0._dark_pact_career_delegator:set_playable_boss_can_be_picked(arg_123_1)
	else
		printf("[VS BOSS] trigger playable boss")
		arg_123_0._network_transmit:send_rpc_server("rpc_set_playable_boss_can_be_picked", arg_123_1)
	end
end

function GameModeVersus.rpc_set_playable_boss_can_be_picked(arg_124_0, arg_124_1)
	assert(arg_124_0._is_server, "[Trying to set the boss to be pickable by client, it should only happen on server]")

	arg_124_0._boss_has_been_played = true

	arg_124_0._dark_pact_career_delegator:set_playable_boss_can_be_picked(arg_124_1)
end

function GameModeVersus._get_parading_screen_duration(arg_125_0)
	local var_125_0 = 0
	local var_125_1 = Managers.state.game_mode:setting("parading_times")

	for iter_125_0, iter_125_1 in pairs(var_125_1) do
		var_125_0 = var_125_0 + iter_125_1
	end

	return var_125_0
end

function GameModeVersus.projectile_hit_character(arg_126_0, arg_126_1, arg_126_2, arg_126_3, arg_126_4, arg_126_5, arg_126_6, arg_126_7, arg_126_8)
	arg_126_3 = arg_126_2 or arg_126_3

	if DamageUtils.is_player_unit(arg_126_3) then
		if not Managers.state.side:is_enemy(arg_126_3, arg_126_4) then
			return
		end

		arg_126_1 = arg_126_1 or Managers.player:owner(arg_126_3)
		arg_126_6 = arg_126_6 or AiUtils.unit_breed(arg_126_4)

		if arg_126_6.is_player then
			local var_126_0 = not arg_126_1.local_player

			DamageUtils.add_hit_reaction(arg_126_4, arg_126_6, var_126_0, arg_126_7, false)
		end

		if Managers.state.side:versus_is_dark_pact(arg_126_3) then
			local var_126_1 = Managers.state.entity:system("audio_system")
			local var_126_2 = arg_126_1.local_player

			arg_126_8 = arg_126_8 or 0

			var_126_1:vs_play_pactsworn_hit_enemy(arg_126_5, var_126_2, arg_126_1, arg_126_8, Managers.time:time("game"))
		end
	end
end

function GameModeVersus._trigger_early_win_vo(arg_127_0, arg_127_1)
	local var_127_0 = Managers.party:get_party(arg_127_1)
	local var_127_1 = Managers.state.side.side_by_party[var_127_0]
	local var_127_2 = arg_127_1 == 1 and 2 or 1
	local var_127_3 = Managers.party:get_party(var_127_2)
	local var_127_4 = Managers.state.side.side_by_party[var_127_3]
	local var_127_5 = Managers.state.entity:system("dialogue_system")

	var_127_5:trigger_mission_giver_event("vs_mg_early_win", nil, var_127_1:name())
	var_127_5:trigger_mission_giver_event("vs_mg_early_loss", nil, var_127_4:name())
end

function GameModeVersus._trigger_draw_vo(arg_128_0)
	Managers.state.entity:system("dialogue_system"):queue_mission_giver_event("vs_mg_match_draw")
end

local var_0_7 = 70
local var_0_8 = 5
local var_0_9 = {}
local var_0_10 = {}

function GameModeVersus._update_hero_rushing(arg_129_0, arg_129_1)
	if not arg_129_0._is_server then
		return
	end

	if arg_129_1 - (arg_129_0._last_played_hero_rushed_t or 0) < 60 then
		return
	end

	table.clear(var_0_9)
	table.clear(var_0_10)

	local var_129_0 = 0
	local var_129_1 = Managers.state.conflict
	local var_129_2 = Managers.state.side:get_side_from_name("heroes").PLAYER_UNITS

	for iter_129_0 = 1, #var_129_2 do
		local var_129_3 = var_129_2[iter_129_0]
		local var_129_4 = var_129_1:get_main_path_player_data(var_129_3)

		if var_129_4 and var_129_4.travel_dist and ScriptUnit.has_extension(var_129_3, "career_system") then
			var_129_0 = var_129_0 + 1
			var_0_9[var_129_0] = var_129_3
			var_0_10[var_129_3] = var_129_4.travel_dist
		end
	end

	if var_129_0 > 1 then
		table.sort(var_0_9, function(arg_130_0, arg_130_1)
			return var_0_10[arg_130_0] < var_0_10[arg_130_1]
		end)

		local var_129_5 = var_0_9[var_129_0]
		local var_129_6 = var_0_9[var_129_0 - 1]

		if var_0_10[var_129_5] - var_0_10[var_129_6] > var_0_7 then
			local var_129_7 = arg_129_0._hero_rush_grace_delay or arg_129_1 + var_0_8

			arg_129_0._hero_rush_grace_delay = var_129_7

			if var_129_7 < arg_129_1 then
				local var_129_8 = ScriptUnit.extension(var_129_5, "career_system"):profile_index()
				local var_129_9 = SPProfiles[var_129_8].display_name

				Managers.state.entity:system("dialogue_system"):queue_mission_giver_event("vs_mg_hero_rushing", {
					target_name = var_129_9
				})

				arg_129_0._last_played_hero_rushed_t = arg_129_1
				arg_129_0._hero_rush_grace_delay = nil
			end
		else
			arg_129_0._hero_rush_grace_delay = nil
		end
	end
end

function GameModeVersus._register_disabled_as_eliminiations(arg_131_0)
	local var_131_0 = Managers.player:players()
	local var_131_1 = Managers.player:statistics_db()

	for iter_131_0, iter_131_1 in pairs(var_131_0) do
		repeat
			local var_131_2
			local var_131_3
			local var_131_4 = ScriptUnit.has_extension(iter_131_1.player_unit, "status_system")

			if var_131_4 then
				if var_131_4:is_grabbed_by_pack_master() or var_131_4:is_hanging_from_hook() then
					var_131_2 = var_131_4:query_pack_master_player()
					var_131_3 = "vs_packmaster"
				elseif var_131_4:is_pounced_down() then
					var_131_2 = Managers.player:owner(var_131_4:get_pouncer_unit())
					var_131_3 = "vs_gutter_runner"
				elseif var_131_4:is_disabled_by_pact_sworn() then
					-- block empty
				end
			end

			if var_131_2 then
				local var_131_5 = var_131_2:stats_id()

				if var_131_1:is_registered(var_131_5) then
					if var_131_4:is_knocked_down() then
						var_131_1:increment_stat(var_131_5, "kills_per_breed", var_131_3)

						break
					end

					local var_131_6 = Unit.get_data(iter_131_1.player_unit, "breed").name

					var_131_1:increment_stat(var_131_5, "vs_knockdowns_per_breed", var_131_6)
					var_131_1:increment_stat(var_131_5, "eliminations_as_breed", var_131_3)
				end
			end
		until true
	end
end
