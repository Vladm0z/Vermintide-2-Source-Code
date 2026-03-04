-- chunkname: @scripts/game_state/state_ingame_running.lua

require("scripts/settings/experience_settings")
require("scripts/settings/progression_unlocks")
require("scripts/settings/equipment/loot_chest_data_1")
require("scripts/settings/controller_settings")
require("scripts/settings/profiles/sp_profiles")
local_require("scripts/settings/material_effect_mappings")
require("scripts/settings/player_data")
require("scripts/settings/unit_gib_settings")
require("scripts/settings/unit_variation_settings")
require("scripts/helpers/level_helper")
require("scripts/utils/edit_ai_utility")
require("scripts/utils/keystroke_helper")
require("scripts/game_state/components/dice_keeper")
require("scripts/ui/views/loading_view")
require("scripts/entity_system/systems/mission/rewards")

local var_0_0 = script_data.testify and require("scripts/game_state/state_ingame_running_testify")
local var_0_1 = {
	"rpc_trigger_local_afk_system_message",
	"rpc_follow_to_lobby"
}

StateInGameRunning = class(StateInGameRunning)
StateInGameRunning.NAME = "StateInGameRunning"

StateInGameRunning.on_enter = function (arg_1_0, arg_1_1)
	GarbageLeakDetector.register_object(arg_1_0, "StateInGameRunning")

	arg_1_0.world = arg_1_0.parent.world

	local var_1_0 = arg_1_1.viewport_name

	arg_1_0.viewport_name = var_1_0
	arg_1_0.world_name = arg_1_1.world_name
	arg_1_0.is_server = arg_1_1.is_server
	arg_1_0._lobby_host = arg_1_1.lobby.is_host and arg_1_1.lobby
	arg_1_0._lobby_client = not arg_1_1.lobby.is_host and arg_1_1.lobby
	arg_1_0._network_options = arg_1_1.network_options
	arg_1_0.statistics_db = arg_1_1.statistics_db
	arg_1_0.profile_synchronizer = arg_1_1.profile_synchronizer
	arg_1_0.network_server = arg_1_1.network_server
	arg_1_0.network_client = arg_1_1.network_client

	local var_1_1 = arg_1_1.input_manager

	arg_1_0.input_manager = var_1_1
	arg_1_0.is_in_inn = arg_1_1.is_in_inn
	arg_1_0.is_in_tutorial = arg_1_1.is_in_tutorial
	arg_1_0.network_event_delegate = arg_1_1.network_event_delegate
	arg_1_0.end_conditions_met = false
	arg_1_0._booted_eac_untrusted = script_data["eac-untrusted"]

	if arg_1_0.is_in_tutorial then
		var_1_1:create_input_service("Tutorial", "TutorialPlayerControllerKeymaps", "TutorialPlayerControllerFilters")
		var_1_1:map_device_to_service("Tutorial", "keyboard")
		var_1_1:map_device_to_service("Tutorial", "mouse")
		var_1_1:map_device_to_service("Tutorial", "gamepad")
	end

	var_1_1:create_input_service("Player", "PlayerControllerKeymaps", "PlayerControllerFilters")
	var_1_1:map_device_to_service("Player", "keyboard")
	var_1_1:map_device_to_service("Player", "mouse")
	var_1_1:map_device_to_service("Player", "gamepad")

	arg_1_0.player_index = arg_1_1.player

	local var_1_2 = arg_1_0.input_manager:get_service("Player")
	local var_1_3 = Managers.player
	local var_1_4 = Network.peer_id()
	local var_1_5 = arg_1_1.local_player_id
	local var_1_6 = Managers.player:player(var_1_4, var_1_5)
	local var_1_7 = var_1_6:stats_id()

	var_1_6.input_source = var_1_2
	arg_1_0.local_player_id = var_1_5
	arg_1_0.player = var_1_6

	if Managers.razer_chroma then
		Managers.razer_chroma:lit_keybindings(true)
	end

	if arg_1_0.is_server then
		var_1_6:create_game_object()
	end

	if arg_1_0.is_server and Managers.state.room and not Managers.state.room:has_room(var_1_4) then
		Managers.state.room:create_room(var_1_4, 1)
	end

	local var_1_8 = Managers.state.entity
	local var_1_9 = var_1_8:system("camera_system")
	local var_1_10 = var_1_8:system("outline_system")
	local var_1_11 = var_1_8:system("fade_system")
	local var_1_12 = var_1_8:system("sound_sector_system")
	local var_1_13 = var_1_8:system("sound_environment_system")

	var_1_9:local_player_created(var_1_6)
	var_1_10:local_player_created(var_1_6)
	var_1_11:local_player_created(var_1_6)
	var_1_12:local_player_created(var_1_6)
	var_1_13:local_player_created(var_1_6)

	local var_1_14 = Managers.state.event

	var_1_14:register(arg_1_0, "game_started", "event_game_started")
	var_1_14:register(arg_1_0, "checkpoint_vote_cancelled", "on_checkpoint_vote_cancelled")
	var_1_14:register(arg_1_0, "conflict_director_setup_done", "event_conflict_director_setup_done")
	var_1_14:register(arg_1_0, "close_ingame_menu", "event_close_ingame_menu")
	var_1_14:register(arg_1_0, "end_screen_ui_complete", "event_end_screen_ui_complete")
	var_1_14:register(arg_1_0, "player_session_scores_synced", "player_session_scores_synced")

	if IS_PS4 then
		var_1_14:register(arg_1_0, "realtime_multiplay", "event_realtime_multiplay")
	end

	if IS_XB1 then
		var_1_14:register(arg_1_0, "trigger_xbox_round_end", "event_trigger_xbox_round_end")
	end

	if arg_1_0.is_server then
		Managers.state.event:trigger("game_started")
	end

	arg_1_0.network_event_delegate:register(arg_1_0, unpack(var_0_1))

	local var_1_15 = arg_1_1.level_key

	arg_1_0.free_flight_manager = arg_1_1.free_flight_manager

	arg_1_0.free_flight_manager:set_teleport_override(function (arg_2_0, arg_2_1)
		for iter_2_0, iter_2_1 in pairs(arg_1_0.player.owned_units) do
			if ScriptUnit.has_extension(iter_2_0, "input_system") then
				ScriptUnit.extension(iter_2_0, "locomotion_system"):teleport_to(arg_2_0, arg_2_1)
			end
		end
	end)

	local var_1_16 = Managers.world
	local var_1_17 = var_1_16:world("level_world")
	local var_1_18 = Managers.world:wwise_world(arg_1_0.world)
	local var_1_19 = {
		player = var_1_6,
		peer_id = var_1_4,
		local_player_id = var_1_5,
		camera_manager = Managers.state.camera,
		chat_manager = Managers.chat,
		input_manager = var_1_1,
		matchmaking_manager = Managers.matchmaking,
		player_manager = Managers.player,
		room_manager = Managers.state.room,
		spawn_manager = Managers.state.spawn,
		time_manager = Managers.time,
		voting_manager = Managers.state.voting,
		world_manager = var_1_16,
		is_server = arg_1_1.is_server,
		profile_synchronizer = arg_1_1.profile_synchronizer,
		network_event_delegate = arg_1_0.network_event_delegate,
		network_server = arg_1_1.network_server,
		network_client = arg_1_1.network_client,
		network_lobby = arg_1_0._lobby_host or arg_1_0._lobby_client,
		voip = arg_1_1.voip,
		statistics_db = arg_1_0.statistics_db,
		stats_id = var_1_7,
		world = var_1_17,
		wwise_world = var_1_18,
		dialogue_system = var_1_8:system("dialogue_system"),
		is_in_inn = arg_1_1.is_in_inn,
		is_in_tutorial = arg_1_0.is_in_tutorial,
		dice_keeper = arg_1_1.dice_keeper
	}

	DamageUtils.is_in_inn = arg_1_1.is_in_inn

	local var_1_20 = arg_1_0.parent.parent.loading_context

	arg_1_0.ingame_ui_context = var_1_19

	if not script_data["-no-rendering"] then
		Managers.ui:create_ingame_ui(var_1_19, var_1_20.subtitle_gui)

		var_1_20.subtitle_gui = nil
	end

	var_1_20.play_end_of_level_game = nil
	arg_1_0.game_mode_key = Managers.state.game_mode:game_mode_key()

	local var_1_21 = Managers.venture.quickplay:is_quick_game()

	if not var_1_21 and arg_1_0.game_mode_key == "weave" then
		var_1_21 = (arg_1_0.is_server and arg_1_0._lobby_host or arg_1_0._lobby_client):lobby_data("weave_quick_game") == "true"

		if var_1_21 then
			Managers.venture.quickplay:set_is_weave_quick_game()
		end
	end

	if arg_1_0.game_mode_key == "weave" or arg_1_0.game_mode_key == "versus" then
		arg_1_0._saved_scoreboard_stats = arg_1_0.parent.parent.loading_context.saved_scoreboard_stats
		arg_1_0.parent.parent.loading_context.saved_scoreboard_stats = nil
	end

	arg_1_0.rewards = Rewards:new(var_1_15, arg_1_0.game_mode_key, var_1_21)
	arg_1_0.is_quickplay = var_1_21
	arg_1_0._level_end_view_wrapper = arg_1_1.level_end_view_wrapper

	if arg_1_0._level_end_view_wrapper then
		arg_1_0._level_end_view_wrapper:game_state_changed()
	end

	arg_1_1.dice_keeper = nil
	arg_1_0.mood_timers = {}

	if var_1_20.loading_view then
		arg_1_0.loading_view = var_1_20.loading_view
		var_1_20.loading_view = nil
		arg_1_0.show_loading_view = true
	end

	Managers.state.camera:apply_level_particle_effects(LevelSettings[var_1_15].level_particle_effects, var_1_0)
	Managers.state.camera:apply_level_screen_effects(LevelSettings[var_1_15].level_screen_effects, var_1_0)
	Managers.razer_chroma:load_packages()

	if Managers.chat:chat_is_focused() then
		Managers.chat.chat_gui:block_input()
	end

	if Development.parameter("attract_mode") then
		local var_1_22 = Managers.ui:temporary_get_ingame_ui_called_from_state_ingame_running()

		Managers.benchmark = BenchmarkHandler:new(var_1_22, arg_1_0.world)
	end

	if arg_1_0.is_in_inn then
		Managers.state.achievement:setup_achievement_data()
		Managers.state.quest:update_quests()
		Managers.mechanism:clear_stored_challenge_progression_status()
	end

	Managers.state.achievement:setup_incompleted_achievements()

	arg_1_0._waiting_for_peers_message_timer = Managers.time:time("game") + 10
	arg_1_0._game_started_current_frame = false
	arg_1_0._transitioned_from_black_screen = false

	Managers.level_transition_handler.transient_package_loader:signal_in_game()
	Managers.mechanism:store_challenge_progression_status(arg_1_0.is_in_inn)
	Managers.music:on_enter_game()
end

StateInGameRunning._setup_end_of_level_UI = function (arg_3_0)
	if script_data.disable_end_screens then
		Managers.state.network.network_transmit:send_rpc_server("rpc_is_ready_for_transition")
	elseif not Managers.state.game_mode:setting("skip_level_end_view") then
		local var_3_0 = not arg_3_0.game_lost and not arg_3_0.game_tied
		local var_3_1 = Managers.state.game_mode:game_mode_key()
		local var_3_2 = Managers.mechanism:current_mechanism_name()
		local var_3_3 = var_3_2 == "versus"
		local var_3_4
		local var_3_5 = Network.peer_id()
		local var_3_6 = arg_3_0.profile_synchronizer:get_persistent_profile_index_reservation(var_3_5)

		if var_3_6 and var_3_6 ~= 0 then
			var_3_4 = SPProfiles[var_3_6].display_name
		end

		local var_3_7 = {
			world_manager = Managers.world,
			is_server = arg_3_0.is_server,
			is_quickplay = arg_3_0.is_quickplay,
			peer_id = var_3_5,
			local_player_hero_name = var_3_4,
			game_won = var_3_0,
			game_mode_key = var_3_1,
			difficulty = Managers.state.difficulty:get_difficulty(),
			level_key = Managers.state.game_mode:level_key(),
			weave_personal_best_achieved = arg_3_0._weave_personal_best_achieved,
			completed_weave = arg_3_0._completed_weave,
			profile_synchronizer = arg_3_0.profile_synchronizer,
			challenge_progression_status = {
				start_progress = Managers.mechanism:get_stored_challenge_progression_status(),
				end_progress = Managers.mechanism:get_challenge_progression_status()
			}
		}

		if var_3_3 then
			var_3_7.party_composition = Managers.party:get_party_composition()
		end

		local var_3_8 = Managers.mechanism:get_players_session_score(arg_3_0.statistics_db, arg_3_0.profile_synchronizer, arg_3_0._saved_scoreboard_stats)

		if arg_3_0.is_server then
			Managers.mechanism:sync_players_session_score(var_3_8)
		end

		var_3_7.players_session_score = var_3_8
		arg_3_0._weave_personal_best_achieved = nil
		arg_3_0._completed_weave = nil

		local var_3_9 = var_3_2 == "versus" and Managers.mechanism:game_mechanism():win_conditions()
		local var_3_10 = {
			team_scores = var_3_9 and var_3_9:get_total_scores()
		}

		var_3_7.rewards = var_3_10

		if not arg_3_0._booted_eac_untrusted then
			local var_3_11, var_3_12, var_3_13 = arg_3_0.rewards:get_level_start()
			local var_3_14, var_3_15 = arg_3_0.rewards:get_versus_level_start()

			var_3_10.level_start = {
				var_3_11,
				var_3_12,
				var_3_13
			}
			var_3_10.versus_level_start = {
				var_3_14,
				var_3_15
			}
			var_3_10.win_track_start_experience = arg_3_0.rewards:get_win_track_experience_start()

			local var_3_16, var_3_17 = arg_3_0.rewards:get_rewards()

			var_3_10.end_of_level_rewards = var_3_16 and table.clone(var_3_16) or {}
			var_3_10.mission_results = table.clone(arg_3_0.rewards:get_mission_results())
			var_3_7.end_of_level_rewards_arguments = var_3_17 and table.clone(var_3_17) or {}
		else
			var_3_10.end_of_level_rewards = {}
			var_3_10.mission_results = {}
		end

		var_3_7.level_end_view = Managers.mechanism:get_level_end_view()
		var_3_7.level_end_view_packages = Managers.mechanism:get_level_end_view_packages()
		arg_3_0.parent.parent.loading_context.level_end_view_context = var_3_7

		if IS_PS4 then
			Managers.account:set_presence("dice_game")
		end

		if Managers.chat:chat_is_focused() then
			Managers.chat.chat_gui:block_input()
		end
	end

	arg_3_0.has_setup_end_of_level = true
end

StateInGameRunning.level_end_view_wrapper = function (arg_4_0)
	return arg_4_0._level_end_view_wrapper
end

StateInGameRunning.handle_end_conditions = function (arg_5_0)
	local var_5_0 = Managers.state.game_mode

	if var_5_0 and var_5_0:is_game_mode_ended() and var_5_0:is_game_mode_ended() then
		-- Nothing
	end
end

StateInGameRunning.check_invites = function (arg_6_0)
	if arg_6_0.popup_id then
		return
	end

	if arg_6_0.network_client and not arg_6_0.network_client:is_ingame() then
		return
	end

	if arg_6_0.network_server and not arg_6_0.network_server:are_all_peers_ingame(nil, true) then
		return
	end

	if arg_6_0.parent.exit_type ~= nil then
		return
	end

	local var_6_0 = PLATFORM

	if IS_CONSOLE and (Managers.account:offline_mode() or Managers.account:has_fatal_error()) then
		if Managers.invite:has_invitation() then
			arg_6_0._offline_invite = true
		end

		return
	end

	local var_6_1 = Managers.invite:get_invited_lobby_data()

	if var_6_1 then
		local var_6_2 = var_6_1.id or var_6_1.name
		local var_6_3

		if IS_XB1 then
			var_6_3 = arg_6_0._lobby_host and arg_6_0._lobby_host.lobby._data.session_name or arg_6_0._lobby_client.lobby._data.session_name
		else
			var_6_3 = arg_6_0._lobby_host and arg_6_0._lobby_host:id() or arg_6_0._lobby_client:id()
		end

		local var_6_4 = Managers.state.voting and Managers.state.voting:vote_in_progress() and Managers.state.voting:active_vote_template().mission_vote
		local var_6_5 = Managers.level_transition_handler:get_current_level_key()
		local var_6_6 = LevelSettings[var_6_5]

		if (Managers.matchmaking:is_game_matchmaking() or var_6_4) and arg_6_0.network_server and var_6_6.hub_level then
			mm_printf("Found an invite, but was matchmaking.")

			arg_6_0.popup_id = Managers.popup:queue_popup(Localize("popup_join_while_matchmaking"), Localize("popup_error_topic"), "ok", Localize("button_ok"))
		elseif var_6_2 == var_6_3 then
			mm_printf("Found an invite, but was already in lobby.")

			arg_6_0.popup_id = Managers.popup:queue_popup(Localize("popup_already_in_same_lobby"), Localize("popup_error_topic"), "ok", Localize("button_ok"))
		elseif not Managers.play_go:installed() then
			mm_printf("Found an invite, but game was not fully installed.")

			arg_6_0.popup_id = Managers.popup:queue_popup(Localize("popup_invite_not_installed"), Localize("popup_invite_not_installed_header"), "not_installed", Localize("menu_ok"))
		elseif arg_6_0.network_server and not arg_6_0.network_server:are_all_peers_ingame(nil, true) then
			mm_printf("Found an invite, but someone is trying to join the game.")

			arg_6_0.popup_id = Managers.popup:queue_popup(Localize("popup_join_blocked_by_joining_player"), Localize("popup_invite_not_installed_header"), "not_installed", Localize("menu_ok"))
		elseif var_6_1.mechanism and var_6_1.mechanism == "versus" and var_6_1.matchmaking and var_6_1.matchmaking == "searching" then
			mm_printf("Inviting player is currently matchmaking into a quick play game/dedicated server lobby.")

			arg_6_0.popup_id = Managers.popup:queue_popup(Localize("matchmaking_status_join_game_failed_is_searching_for_dedicated_server"), Localize("popup_invite_not_installed_header"), "not_installed", Localize("menu_ok"))
		elseif arg_6_0._lobby_client or not arg_6_0.is_in_inn then
			arg_6_0._invite_lobby_data = var_6_1
		elseif not arg_6_0.popup_id then
			Managers.matchmaking:request_join_lobby(var_6_1, {
				friend_join = true
			})
		end
	end
end

StateInGameRunning.wanted_transition = function (arg_7_0)
	if arg_7_0.popup_id then
		return
	end

	if arg_7_0.network_client and not arg_7_0.network_client:is_ingame() then
		return
	end

	if arg_7_0.network_server and arg_7_0.is_in_inn and not arg_7_0.network_server:are_all_peers_ingame(nil, true) then
		return
	end

	local var_7_0, var_7_1 = Managers.ui:get_transition()

	if var_7_0 then
		mm_printf("Doing transition %s from UI", var_7_0)
	elseif arg_7_0._offline_invite then
		var_7_0 = "offline_invite"
		arg_7_0._offline_invite = nil
	elseif arg_7_0._invite_lobby_data then
		if arg_7_0._invite_lobby_data.is_server_invite then
			mm_printf("Found a server invite, joining.")

			var_7_0 = "join_server"
		else
			mm_printf("Found a lobby invite, joining.")

			var_7_0 = "join_lobby"
		end

		var_7_1 = arg_7_0._invite_lobby_data
		arg_7_0._invite_lobby_data = nil
	end

	if not var_7_0 then
		var_7_0, var_7_1 = Managers.matchmaking:get_transition()

		if var_7_0 then
			mm_printf("Matchmaking manager returned a wanted transition %s, doing it.", var_7_0)
		end
	end

	if not var_7_0 and arg_7_0.afk_kick then
		var_7_0 = "afk_kick"
	end

	var_7_0 = var_7_0 or Managers.state.game_mode:wanted_transition()

	if not var_7_0 or not IS_XB1 or arg_7_0.is_in_inn or arg_7_0.is_in_tutorial or Development.parameter("auto-host-level") ~= nil then
		-- Nothing
	elseif not arg_7_0._xbox_event_end_triggered then
		Application.warning("MultiplyerRoundStart was triggered without end conditions met")
		arg_7_0:_xbone_end_of_round_events(arg_7_0.statistics_db)
	end

	return var_7_0, var_7_1
end

StateInGameRunning.event_end_screen_ui_complete = function (arg_8_0)
	Managers.state.conflict:destroy_all_units()
	Managers.ui:set_ingame_ui_enabled(false)

	if Managers.state.network:game() then
		Managers.state.network.network_transmit:send_rpc_server("rpc_is_ready_for_transition")
	end
end

StateInGameRunning.gm_event_end_conditions_met = function (arg_9_0, arg_9_1, arg_9_2, arg_9_3)
	if not arg_9_0.is_server and arg_9_0.game_mode_key == "versus" and Managers.mechanism:is_final_round() and not arg_9_0._player_session_score_synced then
		arg_9_0._player_session_score_synced_cb = callback(arg_9_0, "gm_event_end_conditions_met", arg_9_1, arg_9_2, arg_9_3)

		return
	end

	if not arg_9_0._game_has_started then
		Managers.transition:hide_loading_icon()
		Managers.transition:fade_out(GameSettings.transition_fade_in_speed)
	end

	local var_9_0 = arg_9_0.is_server
	local var_9_1 = arg_9_0.player

	arg_9_0.end_conditions_met = true

	local var_9_2 = Managers.state.difficulty:get_difficulty()
	local var_9_3 = Managers.state.game_mode:level_key()
	local var_9_4 = arg_9_0.game_mode_key
	local var_9_5 = arg_9_0.is_quickplay
	local var_9_6, var_9_7 = Managers.state.game_mode:evaluate_end_condition_outcome(arg_9_1, var_9_1)
	local var_9_8 = Managers.ui:temporary_get_ingame_ui_called_from_state_ingame_running()
	local var_9_9 = var_9_1:stats_id()
	local var_9_10 = arg_9_0.statistics_db

	if not LevelUnlockUtils.completed_level_difficulty_index(var_9_10, var_9_9, var_9_3) then
		local var_9_11 = 0
	end

	var_9_8:handle_transition("close_active")

	if Managers.twitch then
		Managers.twitch:deactivate_twitch_game_mode()
	end

	if not arg_9_0.is_in_inn then
		DialogueSystem.stateless_global_context.last_level_played = var_9_3
		DialogueSystem.stateless_global_context.last_level_won = var_9_6
	end

	if var_9_8.leave_game then
		var_9_10:reset_persistant_stats()
		StatisticsUtil.reset_mission_streak(var_9_1, var_9_10, var_9_9)

		return
	end

	LoreBookHelper.save_new_pages()

	local var_9_12 = Managers.state.entity:system("mission_system")

	var_9_12:set_percentage_completed(arg_9_3)
	Managers.state.achievement:evaluate_end_of_level_achievements(var_9_10, var_9_9, var_9_3, var_9_2)

	local var_9_13 = Managers.backend:get_interface("statistics")
	local var_9_14 = true
	local var_9_15 = Managers.mechanism:is_final_round()

	Managers.mechanism:load_end_screen_resources()

	if var_9_4 == "survival" then
		if var_9_6 then
			print("Game won")
			var_9_12:evaluate_level_end_missions()
			StatisticsUtil.register_complete_survival_level(var_9_10)
			var_9_13:save()
		end
	elseif var_9_6 then
		print("Game won")

		if var_9_4 == "weave" then
			var_9_15 = not Managers.weave:calculate_next_objective_index()

			if var_9_15 then
				local var_9_16 = Managers.weave
				local var_9_17 = var_9_16:get_weave_tier()
				local var_9_18 = var_9_16:get_score()
				local var_9_19 = var_9_16:get_num_players()
				local var_9_20 = #WeaveSettings.templates_ordered
				local var_9_21 = false

				for iter_9_0 = var_9_20, var_9_17, -1 do
					local var_9_22 = ScorpionSeasonalSettings.get_weave_score_stat(iter_9_0, var_9_19)
					local var_9_23 = var_9_10:get_persistent_stat(var_9_9, ScorpionSeasonalSettings.current_season_name, var_9_22)
					local var_9_24 = var_9_23 and var_9_23 > 0

					if var_9_17 == iter_9_0 then
						if var_9_24 and var_9_23 < var_9_18 or not var_9_24 then
							var_9_21 = true

							break
						end
					elseif var_9_24 then
						break
					end
				end

				arg_9_0._weave_personal_best_achieved = var_9_21
				arg_9_0._completed_weave = var_9_16:get_active_weave()

				StatisticsUtil.register_weave_complete(var_9_10, var_9_1, var_9_5, var_9_2)
			else
				local var_9_25 = ScoreboardHelper.get_weave_stats(arg_9_0.statistics_db, arg_9_0.profile_synchronizer)

				arg_9_0.parent.parent.loading_context.saved_scoreboard_stats = var_9_25
			end
		elseif var_9_4 == "versus" then
			var_9_14 = var_9_15
		end

		if var_9_15 then
			arg_9_0.parent.parent.loading_context.saved_scoreboard_stats = nil
		end

		if var_9_14 then
			if arg_9_0._is_in_event_game_mode then
				StatisticsUtil.register_played_weekly_event_level(var_9_10, var_9_1, var_9_3, var_9_2)
			end

			StatisticsUtil.register_complete_level(var_9_10, var_9_4)

			if var_9_4 == "versus" and not arg_9_0.is_in_inn then
				StatisticsUtil.register_versus_game_won(var_9_10, var_9_1, var_9_6)
			end
		end

		if var_9_15 and Managers.mechanism.on_final_round_won then
			Managers.mechanism:on_final_round_won(var_9_10, var_9_9)
		end

		var_9_13:save()
	elseif var_9_7 then
		if var_9_4 == "versus" then
			if var_9_15 then
				if arg_9_0._is_in_event_game_mode then
					StatisticsUtil.register_played_weekly_event_level(var_9_10, var_9_1, var_9_3, var_9_2)
				end

				StatisticsUtil.register_complete_level(var_9_10, var_9_4)

				if not arg_9_0.is_in_inn then
					StatisticsUtil.register_versus_game_won(var_9_10, var_9_1, var_9_6)
				end
			end
		else
			var_9_15 = true
		end

		Managers.state.game_mode:game_lost(var_9_1)
		print("Game lost")

		arg_9_0.parent.parent.loading_context.saved_scoreboard_stats = nil
		arg_9_0.checkpoint_available = arg_9_2

		if var_9_4 ~= "versus" then
			var_9_10:reset_persistant_stats()
		end

		StatisticsUtil.reset_mission_streak(var_9_1, var_9_10, var_9_9)
		var_9_13:save()
	end

	if var_9_4 == "versus" then
		if arg_9_0.is_server then
			local var_9_26 = Managers.mechanism:get_players_session_score(arg_9_0.statistics_db, arg_9_0.profile_synchronizer, arg_9_0._saved_scoreboard_stats)

			if var_9_15 then
				Managers.mechanism:sync_players_session_score(var_9_26)
			else
				arg_9_0.parent.parent.loading_context.saved_scoreboard_stats = var_9_26
			end
		end

		var_9_13:save()
	end

	local var_9_27, var_9_28, var_9_29 = Managers.state.game_mode:get_end_screen_config(var_9_6, var_9_7, var_9_1, arg_9_1)
	local var_9_30 = arg_9_0._booted_eac_untrusted
	local var_9_31 = var_9_4 == "weave"
	local var_9_32
	local var_9_33
	local var_9_34
	local var_9_35

	if var_9_31 then
		var_9_32, var_9_33, var_9_34 = arg_9_0:_get_weave_scores()

		local var_9_36 = Managers.weave:current_bar_score()

		Managers.weave:store_saved_game_mode_data()
	end

	local function var_9_37(arg_10_0)
		if var_9_31 and not var_9_30 and var_9_6 and var_9_15 and var_9_0 and not arg_9_0.is_quickplay then
			arg_9_0:_submit_weave_scores(var_9_32, var_9_33, var_9_34)
		end

		if arg_10_0 == "commit_error" then
			Managers.backend:commit_error()

			return
		end

		if var_9_8.leave_game then
			return
		end

		if not arg_9_0.parent then
			return
		end

		if GameModeSettings[var_9_4].end_mission_rewards then
			if not var_9_30 and (var_9_7 or var_9_15) then
				arg_9_0:_award_end_of_level_rewards(var_9_10, var_9_9, var_9_6, var_9_2, var_9_3)
			end

			print("end screen_name:", var_9_27, var_9_28, var_9_29)
			var_9_8:activate_end_screen_ui(var_9_27, var_9_28, var_9_29)
		end

		if (var_9_6 and var_9_15 or var_9_7) and var_9_31 then
			Managers.weave:clear_weave_name()
		end
	end

	Managers.backend:commit(true, var_9_37)

	arg_9_0.game_lost = var_9_7
	arg_9_0.game_won = var_9_6
	arg_9_0.game_tied = not var_9_6 and not var_9_7

	if IS_PS4 then
		Managers.account:set_realtime_multiplay(false)
	end

	if arg_9_0.is_in_inn or arg_9_0.is_in_tutorial then
		return
	end

	if IS_XB1 then
		if not arg_9_0._xbox_event_end_triggered then
			arg_9_0:_xbone_end_of_round_events(var_9_10)
		end

		if not arg_9_0.is_in_inn and not arg_9_0.is_in_tutorial and not arg_9_0.parent.hero_stats_updated then
			Managers.xbox_stats:update_hero_stats(var_9_6)

			arg_9_0.parent.hero_stats_updated = true
		end
	end
end

StateInGameRunning._award_end_of_level_rewards = function (arg_11_0, arg_11_1, arg_11_2, arg_11_3, arg_11_4, arg_11_5)
	local var_11_0 = Network.peer_id()
	local var_11_1, var_11_2 = arg_11_0.profile_synchronizer:get_persistent_profile_index_reservation(var_11_0)
	local var_11_3 = SPProfiles[var_11_1]
	local var_11_4 = var_11_3.display_name
	local var_11_5 = math.floor(Managers.time:time("game"))
	local var_11_6 = Managers.mechanism:get_end_of_level_rewards_arguments(arg_11_3, arg_11_0.is_quickplay, arg_11_1, arg_11_2, arg_11_5, var_11_4)
	local var_11_7 = Managers.mechanism:get_end_of_level_extra_mission_results()

	var_11_6.hero_name = var_11_4
	var_11_6.ingame_display_name = var_11_3.ingame_display_name

	arg_11_0.rewards:award_end_of_level_rewards(arg_11_3, var_11_4, arg_11_0._is_in_event_game_mode, var_11_5, var_11_6, var_11_7)

	local var_11_8 = LootChestData.chests_by_category[arg_11_4]

	if var_11_8 then
		local var_11_9 = var_11_8.package_name

		arg_11_0.chests_package_name = var_11_9

		Managers.package:load(var_11_9, "global")
	end
end

StateInGameRunning._get_weave_scores = function (arg_12_0)
	local var_12_0 = Managers.weave
	local var_12_1 = var_12_0:get_weave_tier()
	local var_12_2 = var_12_0:get_score()
	local var_12_3 = var_12_0:get_num_players()

	return var_12_1, var_12_2, var_12_3
end

StateInGameRunning._submit_weave_scores = function (arg_13_0, arg_13_1, arg_13_2, arg_13_3)
	Managers.backend:get_interface("weaves"):submit_scores(arg_13_1, arg_13_2, arg_13_3)
end

StateInGameRunning.on_checkpoint_vote_cancelled = function (arg_14_0)
	arg_14_0.checkpoint_vote_cancelled = true
end

if not IS_WINDOWS and (BUILD == "dev" or BUILD == "debug") then
	function RELOAD_CONTROLS()
		Managers.input:create_input_service("Player", "PlayerControllerKeymaps", "PlayerControllerFilters")
		Managers.input:map_device_to_service("Player", "keyboard")
		Managers.input:map_device_to_service("Player", "mouse")
		Managers.input:map_device_to_service("Player", "gamepad")

		local var_15_0 = Managers.input:get_service("Player")
		local var_15_1 = Managers.player:local_player()

		var_15_1.input_source = var_15_0

		local var_15_2 = var_15_1.player_unit

		ScriptUnit.extension(var_15_2, "input_system").input_service = var_15_0
	end
end

StateInGameRunning.update = function (arg_16_0, arg_16_1, arg_16_2)
	if not arg_16_0._transitioned_from_black_screen and arg_16_0:_check_black_screen_transition_requirements(arg_16_1, arg_16_2) then
		arg_16_0:_game_actually_starts()

		if IS_WINDOWS and not arg_16_0.is_in_inn and not Window.has_focus() then
			Window.flash_window(nil, "start", 3)
		end

		arg_16_0._transitioned_from_black_screen = true
	end

	if arg_16_0._waiting_for_peers_message_timer and arg_16_2 > arg_16_0._waiting_for_peers_message_timer then
		if arg_16_0.is_server then
			if #arg_16_0._lobby_host:members():get_members() > 1 then
				Managers.transition:show_waiting_for_peers_message(true)

				arg_16_0._waiting_for_peers_message_timer = nil
			end
		else
			Managers.transition:show_waiting_for_peers_message(true)

			arg_16_0._waiting_for_peers_message_timer = nil
		end
	end

	if arg_16_0.checkpoint_vote_cancelled then
		arg_16_0.checkpoint_available = nil
		arg_16_0.checkpoint_vote_cancelled = nil
	end

	local var_16_0 = Managers.ui:temporary_get_ingame_ui_called_from_state_ingame_running()

	if var_16_0 then
		local var_16_1 = not var_16_0.survey_active and not arg_16_0.has_setup_end_of_level and var_16_0:end_screen_active() and var_16_0:end_screen_fade_in_complete()
		local var_16_2 = arg_16_0._booted_eac_untrusted or arg_16_0.rewards:rewards_generated() and not arg_16_0.rewards:consuming_deed() and arg_16_0.chests_package_name and Managers.package:has_loaded(arg_16_0.chests_package_name, "global")
		local var_16_3 = Managers.mechanism:current_mechanism_name()

		if var_16_3 == "versus" then
			var_16_2 = true
		end

		if var_16_1 and var_16_3 == "versus" then
			if Managers.mechanism:is_final_round() and var_16_2 then
				arg_16_0:_setup_end_of_level_UI()
			end
		elseif var_16_1 and var_16_2 then
			arg_16_0:_setup_end_of_level_UI()
		end
	end

	if arg_16_0.popup_id then
		local var_16_4 = Managers.popup:query_result(arg_16_0.popup_id)

		if var_16_4 then
			if var_16_4 == "not_installed" then
				Managers.invite:clear_invites()
			end

			arg_16_0.popup_id = nil
		end
	end

	local var_16_5 = Managers.time:time("main")

	arg_16_0:update_player_afk_check(arg_16_1, var_16_5)

	if Managers.benchmark then
		Managers.benchmark:update(arg_16_1, arg_16_2)
	end

	if arg_16_0._fps_reporter_testify then
		arg_16_0._fps_reporter_testify:update(arg_16_1, arg_16_2)
	end

	if script_data.testify then
		Testify:poll_requests_through_handler(var_0_0, arg_16_0)
	end
end

StateInGameRunning.check_for_new_quests_or_contracts = function (arg_17_0, arg_17_1)
	arg_17_0._quest_expire_check_cooldown = arg_17_0._quest_expire_check_cooldown and arg_17_0._quest_expire_check_cooldown - arg_17_1 or 0

	if arg_17_0._quest_expire_check_cooldown <= 0 then
		local var_17_0 = Managers.state.quest

		if var_17_0:has_quests_expired() or var_17_0:has_contracts_expired() then
			Managers.chat:add_local_system_message(1, Localize("dlc1_3_1_new_quests_and_contracts_available_text"), true)

			arg_17_0._quest_expire_check_cooldown = QuestSettings.EXPIRE_CHECK_COOLDOWN
		end
	end
end

StateInGameRunning.disable_ui = function (arg_18_0)
	Managers.ui:set_ingame_ui_enabled(false)
end

StateInGameRunning.event_close_ingame_menu = function (arg_19_0)
	local var_19_0 = Managers.ui:temporary_get_ingame_ui_called_from_state_ingame_running()

	if var_19_0 then
		var_19_0:suspend_active_view()
	end
end

StateInGameRunning.event_realtime_multiplay = function (arg_20_0, arg_20_1)
	if arg_20_1 and (arg_20_0.is_in_tutorial or arg_20_0.is_in_inn) then
		return
	end

	Managers.account:set_realtime_multiplay(arg_20_1)
end

StateInGameRunning.cb_loading_view_fade_in_done = function (arg_21_0)
	Managers.transition:fade_out(GameSettings.transition_fade_out_speed, nil)

	arg_21_0.show_loading_view = false
end

StateInGameRunning.post_update = function (arg_22_0, arg_22_1, arg_22_2)
	local var_22_0 = arg_22_0._level_end_view_wrapper
	local var_22_1 = script_data.disable_ui or var_22_0 ~= nil or arg_22_0.waiting_for_transition and Managers.state.network:game_session_host() ~= nil

	Managers.ui:post_update(arg_22_1, arg_22_2, var_22_1)

	if var_22_0 then
		var_22_0:update(arg_22_1, arg_22_2)

		if var_22_0:done() then
			var_22_0:destroy()

			arg_22_0._level_end_view_wrapper = nil
		end
	end

	if arg_22_0._game_started_current_frame then
		if IS_PS4 and not Managers.state.entity:system("cutscene_system").active_camera then
			arg_22_0:event_realtime_multiplay(true)
		end

		arg_22_0._game_started_current_frame = false
	end
end

StateInGameRunning.trigger_xbox_multiplayer_round_end_events = function (arg_23_0)
	if arg_23_0.is_in_inn or arg_23_0.is_in_tutorial or Development.parameter("auto-host-level") ~= nil or arg_23_0._xbox_event_end_triggered then
		return
	end

	arg_23_0:_xbone_end_of_round_events(arg_23_0.statistics_db)
end

StateInGameRunning.on_exit = function (arg_24_0)
	Managers.music:on_exit_game()
	Managers.state.network.profile_synchronizer:set_own_actually_ingame(false)
	arg_24_0.free_flight_manager:set_teleport_override(nil)

	arg_24_0.parent = nil
	arg_24_0.free_flight_manager = nil
	arg_24_0.input_manager = nil

	CLEAR_ALL_PLAYER_LISTS()

	if Managers.benchmark then
		Managers.benchmark:destroy()

		Managers.benchmark = nil
	end

	if arg_24_0._level_end_view_wrapper then
		arg_24_0._level_end_view_wrapper:destroy()

		arg_24_0._level_end_view_wrapper = nil
	end

	if IS_PS4 then
		Managers.account:set_realtime_multiplay(false)
	end

	Managers.ui:destroy_ingame_ui()

	if arg_24_0.loading_view then
		arg_24_0.loading_view:destroy()

		arg_24_0.loading_view = nil
	end

	if arg_24_0.network_event_delegate then
		arg_24_0.network_event_delegate:unregister(arg_24_0)

		arg_24_0.network_event_delegate = nil
	end

	arg_24_0.level_end_view_context = nil
	arg_24_0.player = nil

	arg_24_0:_cancel_afk_warning()
end

StateInGameRunning.event_game_started = function (arg_25_0)
	local var_25_0 = arg_25_0.parent.world
	local var_25_1 = LevelHelper:current_level(var_25_0)

	Level.trigger_event(var_25_1, "game_started")

	if arg_25_0.is_server then
		Managers.state.voting:set_vote_kick_enabled(true)
	end

	arg_25_0.end_conditions_met = false

	if Managers.matchmaking:have_game_mode_event_data() then
		arg_25_0._is_in_event_game_mode = true
	end

	if arg_25_0.is_in_inn or arg_25_0.is_in_tutorial then
		return
	end

	if IS_XB1 then
		arg_25_0:_xbone_round_start_events()
	end
end

if IS_XB1 then
	StateInGameRunning.event_trigger_xbox_round_end = function (arg_26_0)
		arg_26_0:_xbone_end_of_round_events(arg_26_0.statistics_db)
	end

	StateInGameRunning._xbone_round_start_events = function (arg_27_0)
		if arg_27_0.is_in_inn or arg_27_0.is_in_tutorial or Development.parameter("auto-host-level") ~= nil or not Managers.account:is_online() then
			return
		end

		if not arg_27_0._xbox_event_init_triggered then
			arg_27_0._xbox_event_init_triggered = true

			local var_27_0 = Managers.state.network:lobby().lobby:session_id()
			local var_27_1 = {
				Managers.account:xbox_user_id(),
				Managers.account:round_id(),
				0,
				Managers.account:player_session_id(),
				MultiplayerSession.multiplayer_correlation_id(var_27_0),
				0,
				0,
				0
			}

			Managers.transition:set_multiplayer_values("start", {
				xuid = Managers.account:xbox_user_id(),
				round_id = Managers.account:round_id(),
				player_session_id = Managers.account:player_session_id(),
				correlation_id = MultiplayerSession.multiplayer_correlation_id(var_27_0)
			}, string.format("[StateInGameRunning] Writing MultiplayerRoundStart. CorrelationID: %s. RoundID: %s", tostring(MultiplayerSession.multiplayer_correlation_id(var_27_0)), tostring(Managers.account:round_id())))

			local var_27_2 = string.format("[StateInGameRunning] Writing MultiplayerRoundStart. CorrelationID: %s. RoundID: %s", tostring(MultiplayerSession.multiplayer_correlation_id(var_27_0)), tostring(Managers.account:round_id()))
			local var_27_3 = Application.warning

			Managers.xbox_events:write("MultiplayerRoundStart", var_27_1, var_27_2, var_27_3, true)
		end
	end

	StateInGameRunning._xbone_end_of_round_events = function (arg_28_0, arg_28_1)
		if arg_28_0.is_in_inn or arg_28_0.is_in_tutorial or Development.parameter("auto-host-level") ~= nil or not Managers.account:is_online() then
			return
		end

		if not arg_28_0._xbox_event_end_triggered then
			arg_28_0._xbox_event_end_triggered = true

			local var_28_0 = Managers.state.network:lobby().lobby:session_id()
			local var_28_1 = {
				Managers.account:xbox_user_id(),
				Managers.account:round_id(),
				0,
				Managers.account:player_session_id(),
				MultiplayerSession.multiplayer_correlation_id(var_28_0),
				0,
				0,
				0,
				math.floor(Managers.time:time("game")),
				0
			}

			Managers.transition:set_multiplayer_values("end", {
				xuid = Managers.account:xbox_user_id(),
				round_id = Managers.account:round_id(),
				player_session_id = Managers.account:player_session_id(),
				correlation_id = MultiplayerSession.multiplayer_correlation_id(var_28_0),
				time = Managers.time:time("game")
			}, string.format("[StateInGameRunning] Writing MultiplayerRoundEnd. CorrelationID: %s. RoundID: %s", tostring(MultiplayerSession.multiplayer_correlation_id(var_28_0)), tostring(Managers.account:round_id())))

			local var_28_2 = string.format("[StateInGameRunning] Writing MultiplayerRoundEnd. CorrelationID: %s. RoundID: %s", tostring(MultiplayerSession.multiplayer_correlation_id(var_28_0)), tostring(Managers.account:round_id()))
			local var_28_3 = Application.warning

			Managers.xbox_events:write("MultiplayerRoundEnd", var_28_1, var_28_2, var_28_3, true)
			Managers.transition:dump_multiplayer_data()
		end

		if not arg_28_0._gameprogress_event_triggered then
			arg_28_0._gameprogress_event_triggered = true

			local var_28_4 = {
				Managers.account:xbox_user_id(),
				Managers.account:player_session_id(),
				StatisticsUtil.get_game_progress(arg_28_1)
			}
			local var_28_5 = "[StateInGameRunning] Writing GameProgress"
			local var_28_6 = Application.warning

			Managers.xbox_events:write("GameProgress", var_28_4, var_28_5, var_28_6, true)
		end
	end
end

StateInGameRunning._check_black_screen_transition_requirements = function (arg_29_0)
	if not arg_29_0._game_mode_ready_to_start then
		arg_29_0._game_mode_ready_to_start = Managers.state.game_mode:local_player_ready_to_start(arg_29_0.player)
	end

	local var_29_0 = arg_29_0._conflict_directory_is_ready or not arg_29_0.is_server
	local var_29_1 = arg_29_0._game_mode_ready_to_start

	if var_29_0 and var_29_1 then
		if not arg_29_0._has_started_framerate_catchup then
			arg_29_0:_catchup_framerate_before_starting()

			arg_29_0._has_started_framerate_catchup = true
		end

		arg_29_0:_update_catchup_framerate_before_starting()

		if arg_29_0._frame_catchup_counter == nil then
			return true
		end
	end

	return false
end

StateInGameRunning.event_conflict_director_setup_done = function (arg_30_0)
	arg_30_0._conflict_directory_is_ready = true
end

StateInGameRunning._catchup_framerate_before_starting = function (arg_31_0)
	Framerate.set_catchup()

	arg_31_0._frame_catchup_counter = 20
end

StateInGameRunning._update_catchup_framerate_before_starting = function (arg_32_0)
	if arg_32_0._frame_catchup_counter == nil then
		return
	end

	arg_32_0._frame_catchup_counter = arg_32_0._frame_catchup_counter - 1

	if arg_32_0._frame_catchup_counter == 0 then
		arg_32_0._frame_catchup_counter = nil

		Framerate.set_playing()
	end
end

StateInGameRunning._game_actually_starts = function (arg_33_0)
	print("StateInGameRunning:_game_actually_starts()")

	local var_33_0 = arg_33_0.parent.parent.loading_context

	Managers.state.game_mode:local_player_game_starts(arg_33_0.player, var_33_0)
	Managers.transition:fade_out(GameSettings.transition_fade_in_speed)

	arg_33_0._game_started_current_frame = true
	arg_33_0._game_has_started = true

	Managers.transition:hide_loading_icon()
	Managers.transition:show_waiting_for_peers_message(false)

	arg_33_0._waiting_for_peers_message_timer = nil

	Managers.load_time:end_timer()

	if Managers.twitch then
		local var_33_1 = Managers.level_transition_handler:get_current_level_keys()
		local var_33_2 = LevelSettings[var_33_1]

		if var_33_2 and not var_33_2.disable_twitch_game_mode then
			Managers.twitch:activate_twitch_game_mode(arg_33_0.network_event_delegate, Managers.state.game_mode:game_mode_key())
		end
	end

	Managers.state.network.profile_synchronizer:set_own_actually_ingame(true)

	arg_33_0._game_started_timestamp = os.time(os.date("*t"))

	if IS_WINDOWS then
		Managers.account:update_presence()
	end
end

local var_0_2 = 120
local var_0_3 = 180

StateInGameRunning.update_player_afk_check = function (arg_34_0, arg_34_1, arg_34_2)
	do return end

	local var_34_0 = Managers.state.entity:system("cutscene_system").active_camera

	if arg_34_0.afk_kick or var_34_0 or arg_34_0.is_server or arg_34_0.is_in_inn or arg_34_0.end_conditions_met or Development.parameter("debug_disable_afk_kick") then
		if arg_34_0.afk_popup_id then
			arg_34_0:_cancel_afk_warning()
		end

		arg_34_0.last_active_time = nil

		return
	end

	local var_34_1 = Managers.input.last_active_time

	if not arg_34_0.last_active_time then
		arg_34_0.last_active_time = var_34_1 or arg_34_2
	elseif var_34_1 and var_34_1 ~= arg_34_0.last_active_time then
		arg_34_0.last_active_time = nil
	elseif arg_34_0.last_active_time then
		local var_34_2 = Managers.player:local_player(1).player_unit

		if not Unit.alive(var_34_2) or ScriptUnit.extension(var_34_2, "status_system"):is_disabled() then
			arg_34_0.last_active_time = arg_34_0.last_active_time + arg_34_1
		else
			local var_34_3 = arg_34_2 - arg_34_0.last_active_time
			local var_34_4 = var_34_3 > var_0_2
			local var_34_5 = var_34_3 > var_0_3

			if var_34_4 and not arg_34_0.afk_popup_id then
				arg_34_0:_show_afk_warning()
			elseif var_34_5 then
				arg_34_0:_kick_afk_player()
			end
		end
	end

	arg_34_0:_handle_afk_warning_result()
end

StateInGameRunning._show_afk_warning = function (arg_35_0)
	arg_35_0.afk_popup_id = Managers.popup:queue_popup(Localize("afk_kick_warning"), Localize("popup_notice_topic"), "ok", Localize("button_ok"))

	if _G.Window ~= nil and Window.flash_window ~= nil and not Window.has_focus() then
		Window.flash_window(nil, "start", 5)
	end

	local var_35_0 = Managers.player:local_player(1)
	local var_35_1 = "rpc_trigger_local_afk_system_message"
	local var_35_2 = "chat_afk_kick_warning"
	local var_35_3 = var_35_0.peer_id

	if not arg_35_0.is_server then
		Managers.state.network.network_transmit:send_rpc_server(var_35_1, var_35_2, var_35_3)
	end

	local var_35_4 = CHANNEL_TO_PEER_ID[var_35_3]

	arg_35_0:rpc_trigger_local_afk_system_message(var_35_4, var_35_2, var_35_3)
end

StateInGameRunning.rpc_trigger_local_afk_system_message = function (arg_36_0, arg_36_1, arg_36_2, arg_36_3)
	if arg_36_0.is_server then
		Managers.state.network.network_transmit:send_rpc_clients_except(rpc, arg_36_3, arg_36_2, arg_36_3)
	end

	local var_36_0 = Managers.player:player(arg_36_3, 1)

	if var_36_0 then
		local var_36_1 = var_36_0:is_player_controlled()
		local var_36_2 = var_36_1 and (rawget(_G, "Steam") and Steam.user_name(arg_36_3) or tostring(arg_36_3)) or var_36_0:name()

		if IS_CONSOLE and not Managers.account:offline_mode() then
			local var_36_3 = Managers.state.network:lobby()

			var_36_2 = var_36_1 and (var_36_3:user_name(arg_36_3) or tostring(arg_36_3)) or var_36_0:name()
		end

		local var_36_4 = true
		local var_36_5 = string.format(Localize(arg_36_2), var_36_2)

		Managers.chat:add_local_system_message(1, var_36_5, var_36_4)
	end
end

StateInGameRunning._cancel_afk_warning = function (arg_37_0)
	if arg_37_0.afk_popup_id then
		Managers.popup:cancel_popup(arg_37_0.afk_popup_id)

		arg_37_0.afk_popup_id = nil
	end
end

StateInGameRunning._handle_afk_warning_result = function (arg_38_0)
	if arg_38_0.afk_popup_id and Managers.popup:query_result(arg_38_0.afk_popup_id) then
		arg_38_0.afk_popup_id = nil
	end
end

StateInGameRunning._kick_afk_player = function (arg_39_0)
	arg_39_0:_cancel_afk_warning()

	local var_39_0 = Managers.player:local_player(1)
	local var_39_1 = "rpc_trigger_local_afk_system_message"
	local var_39_2 = "chat_afk_kick"
	local var_39_3 = var_39_0.peer_id

	if not arg_39_0.is_server then
		Managers.state.network.network_transmit:send_rpc_server(var_39_1, var_39_2, var_39_3)
	end

	local var_39_4 = CHANNEL_TO_PEER_ID[var_39_3]

	arg_39_0:rpc_trigger_local_afk_system_message(var_39_4, var_39_2, var_39_3)

	arg_39_0.afk_kick = true
end

StateInGameRunning.transitioned_from_black_screen = function (arg_40_0)
	return arg_40_0._transitioned_from_black_screen
end

StateInGameRunning.rpc_follow_to_lobby = function (arg_41_0, arg_41_1, arg_41_2, arg_41_3)
	printf("Got message from lobby host to join %s %s", NetworkLookup.lobby_type[arg_41_2], arg_41_3)

	local var_41_0 = CHANNEL_TO_PEER_ID[arg_41_1]

	if not Managers.party:is_leader(var_41_0) then
		return
	end

	local var_41_1 = {
		join_method = "party"
	}

	if NetworkLookup.lobby_type[arg_41_2] == "server" then
		var_41_1.is_server_invite = true
		var_41_1.id = arg_41_3
		var_41_1.server_info = {
			ip_port = arg_41_3
		}
	else
		var_41_1.is_server_invite = false
		var_41_1.id = arg_41_3
	end

	local var_41_2 = {
		friend_join = true
	}

	Managers.matchmaking:request_join_lobby(var_41_1, var_41_2)
end

StateInGameRunning.player_session_scores_synced = function (arg_42_0)
	arg_42_0._player_session_score_synced = true

	if arg_42_0._player_session_score_synced_cb then
		arg_42_0._player_session_score_synced_cb()

		arg_42_0._player_session_score_synced_cb = nil
	end
end
