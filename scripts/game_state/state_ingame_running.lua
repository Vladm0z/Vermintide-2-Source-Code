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

local testify = script_data.testify

testify = not testify and require("scripts/game_state/state_ingame_running_testify")

local tbl = {
	"rpc_trigger_local_afk_system_message",
	"rpc_follow_to_lobby"
}

StateInGameRunning = class(StateInGameRunning)
StateInGameRunning.NAME = "StateInGameRunning"

StateInGameRunning.on_enter = function (self, arg_1_1)
	-- function 1
	GarbageLeakDetector.register_object(self, "StateInGameRunning")

	self.world = self.parent.world

	local viewport_name = arg_1_1.viewport_name

	self.viewport_name = viewport_name
	self.world_name = arg_1_1.world_name
	self.is_server = arg_1_1.is_server

	local is_host = arg_1_1.lobby.is_host

	is_host = not is_host and arg_1_1.lobby
	self._lobby_host = is_host
	self._lobby_client = not not arg_1_1.lobby.is_host or arg_1_1.lobby
	self._network_options = arg_1_1.network_options
	self.statistics_db = arg_1_1.statistics_db
	self.profile_synchronizer = arg_1_1.profile_synchronizer
	self.network_server = arg_1_1.network_server
	self.network_client = arg_1_1.network_client

	local input_manager = arg_1_1.input_manager

	self.input_manager = input_manager
	self.is_in_inn = arg_1_1.is_in_inn
	self.is_in_tutorial = arg_1_1.is_in_tutorial
	self.network_event_delegate = arg_1_1.network_event_delegate
	self.end_conditions_met = false

	if not self.is_in_tutorial then
		input_manager:create_input_service("Tutorial", "TutorialPlayerControllerKeymaps", "TutorialPlayerControllerFilters")
		input_manager:map_device_to_service("Tutorial", "keyboard")
		input_manager:map_device_to_service("Tutorial", "mouse")
		input_manager:map_device_to_service("Tutorial", "gamepad")
	end

	input_manager:create_input_service("Player", "PlayerControllerKeymaps", "PlayerControllerFilters")
	input_manager:map_device_to_service("Player", "keyboard")
	input_manager:map_device_to_service("Player", "mouse")
	input_manager:map_device_to_service("Player", "gamepad")

	self.player_index = arg_1_1.player

	local get_service = self.input_manager:get_service("Player")
	local player = Managers.player
	local peer_id = Network.peer_id()
	local local_player_id = arg_1_1.local_player_id
	local player_2 = Managers.player:player(peer_id, local_player_id)
	local stats_id = player_2:stats_id()

	player_2.input_source = get_service
	self.local_player_id = local_player_id
	self.player = player_2

	if not Managers.razer_chroma then
		Managers.razer_chroma:lit_keybindings(true)
	end

	if not self.is_server then
		player_2:create_game_object()
	end

	if not (not self.is_server and not Managers.state.room and Managers.state.room:has_room(peer_id)) then
		Managers.state.room:create_room(peer_id, 1)
	end

	local entity = Managers.state.entity
	local system = entity:system("camera_system")
	local system_2 = entity:system("outline_system")
	local system_3 = entity:system("fade_system")
	local system_4 = entity:system("sound_sector_system")
	local system_5 = entity:system("sound_environment_system")

	system:local_player_created(player_2)
	system_2:local_player_created(player_2)
	system_3:local_player_created(player_2)
	system_4:local_player_created(player_2)
	system_5:local_player_created(player_2)

	local event = Managers.state.event

	event:register(self, "game_started", "event_game_started")
	event:register(self, "checkpoint_vote_cancelled", "on_checkpoint_vote_cancelled")
	event:register(self, "conflict_director_setup_done", "event_conflict_director_setup_done")
	event:register(self, "close_ingame_menu", "event_close_ingame_menu")
	event:register(self, "end_screen_ui_complete", "event_end_screen_ui_complete")
	event:register(self, "player_session_scores_synced", "player_session_scores_synced")

	if not IS_PS4 then
		event:register(self, "realtime_multiplay", "event_realtime_multiplay")
	end

	if not IS_XB1 then
		event:register(self, "trigger_xbox_round_end", "event_trigger_xbox_round_end")
	end

	if not self.is_server then
		Managers.state.event:trigger("game_started")
	end

	self.network_event_delegate:register(self, unpack(tbl))

	local level_key = arg_1_1.level_key

	self.free_flight_manager = arg_1_1.free_flight_manager

	self.free_flight_manager:set_teleport_override(function (arg_2_0, arg_2_1)
		-- function 2
		for k, v in pairs(self.player.owned_units) do
			if not ScriptUnit.has_extension(k, "input_system") then
				ScriptUnit.extension(k, "locomotion_system"):teleport_to(arg_2_0, arg_2_1)
			end
		end
	end)

	local world = Managers.world
	local world_2 = world:world("level_world")
	local wwise_world = Managers.world:wwise_world(self.world)
	local tbl_2 = {
		player = player_2,
		peer_id = peer_id,
		local_player_id = local_player_id,
		camera_manager = Managers.state.camera,
		chat_manager = Managers.chat,
		input_manager = input_manager,
		matchmaking_manager = Managers.matchmaking,
		player_manager = Managers.player,
		room_manager = Managers.state.room,
		spawn_manager = Managers.state.spawn,
		time_manager = Managers.time,
		voting_manager = Managers.state.voting,
		world_manager = world,
		is_server = arg_1_1.is_server,
		profile_synchronizer = arg_1_1.profile_synchronizer,
		network_event_delegate = self.network_event_delegate,
		network_server = arg_1_1.network_server,
		network_client = arg_1_1.network_client
	}
	local _lobby_host = self._lobby_host

	_lobby_host = _lobby_host or self._lobby_client
	tbl_2.network_lobby = _lobby_host
	tbl_2.voip = arg_1_1.voip
	tbl_2.statistics_db = self.statistics_db
	tbl_2.stats_id = stats_id
	tbl_2.world = world_2
	tbl_2.wwise_world = wwise_world
	tbl_2.dialogue_system = entity:system("dialogue_system")
	tbl_2.is_in_inn = arg_1_1.is_in_inn
	tbl_2.is_in_tutorial = self.is_in_tutorial
	tbl_2.dice_keeper = arg_1_1.dice_keeper
	DamageUtils.is_in_inn = arg_1_1.is_in_inn

	local loading_context = self.parent.parent.loading_context

	self.ingame_ui_context = tbl_2

	if not script_data["-no-rendering"] then
		Managers.ui:create_ingame_ui(tbl_2, loading_context.subtitle_gui)

		loading_context.subtitle_gui = nil
	end

	loading_context.play_end_of_level_game = nil
	self.game_mode_key = Managers.state.game_mode:game_mode_key()

	local is_quick_game = Managers.venture.quickplay:is_quick_game()

	if not (is_quick_game or self.game_mode_key ~= "weave") then
		local _lobby_host_2

		if not self.is_server then
			_lobby_host_2 = self._lobby_host

			if not _lobby_host_2 then
				-- Nothing
			end
		end

		_lobby_host_2 = self._lobby_client

		::label_1_0::

		is_quick_game = _lobby_host_2:lobby_data("weave_quick_game") == "true"

		if not is_quick_game then
			Managers.venture.quickplay:set_is_weave_quick_game()
		end
	end

	if not (self.game_mode_key == "weave" or self.game_mode_key ~= "versus") then
		self._saved_scoreboard_stats = self.parent.parent.loading_context.saved_scoreboard_stats
		self.parent.parent.loading_context.saved_scoreboard_stats = nil
	end

	self.rewards = Rewards:new(level_key, self.game_mode_key, is_quick_game)
	self.is_quickplay = is_quick_game
	self._level_end_view_wrapper = arg_1_1.level_end_view_wrapper

	if not self._level_end_view_wrapper then
		self._level_end_view_wrapper:game_state_changed()
	end

	arg_1_1.dice_keeper = nil
	self.mood_timers = {}

	if not loading_context.loading_view then
		self.loading_view = loading_context.loading_view
		loading_context.loading_view = nil
		self.show_loading_view = true
	end

	Managers.state.camera:apply_level_particle_effects(LevelSettings[level_key].level_particle_effects, viewport_name)
	Managers.state.camera:apply_level_screen_effects(LevelSettings[level_key].level_screen_effects, viewport_name)
	Managers.razer_chroma:load_packages()

	if not Managers.chat:chat_is_focused() then
		Managers.chat.chat_gui:block_input()
	end

	if not Development.parameter("attract_mode") then
		local temporary_get_ingame_ui_called_from_state_ingame_running = Managers.ui:temporary_get_ingame_ui_called_from_state_ingame_running()

		Managers.benchmark = BenchmarkHandler:new(temporary_get_ingame_ui_called_from_state_ingame_running, self.world)
	end

	if not self.is_in_inn then
		Managers.state.achievement:setup_achievement_data()
		Managers.state.quest:update_quests()
		Managers.mechanism:clear_stored_challenge_progression_status()
	end

	Managers.state.achievement:setup_incompleted_achievements()

	self._waiting_for_peers_message_timer = Managers.time:time("game") + 10
	self._game_started_current_frame = false
	self._transitioned_from_black_screen = false

	Managers.level_transition_handler.transient_package_loader:signal_in_game()
	Managers.mechanism:store_challenge_progression_status(self.is_in_inn)
	Managers.music:on_enter_game()
end

StateInGameRunning._setup_end_of_level_UI = function (self)
	-- function 3
	if not script_data.disable_end_screens then
		Managers.state.network.network_transmit:send_rpc_server("rpc_is_ready_for_transition")
	elseif not Managers.state.game_mode:setting("skip_level_end_view") then
		local flag = not not self.game_lost or not self.game_tied
		local game_mode_key = Managers.state.game_mode:game_mode_key()
		local current_mechanism_name = Managers.mechanism:current_mechanism_name()
		local flag_2 = current_mechanism_name == "versus"
		local var_3_4
		local peer_id = Network.peer_id()
		local get_persistent_profile_index_reservation = self.profile_synchronizer:get_persistent_profile_index_reservation(peer_id)

		if not (not get_persistent_profile_index_reservation and get_persistent_profile_index_reservation == 0) then
			var_3_4 = SPProfiles[get_persistent_profile_index_reservation].display_name
		end

		local tbl = {
			world_manager = Managers.world,
			is_server = self.is_server,
			is_quickplay = self.is_quickplay,
			peer_id = peer_id,
			local_player_hero_name = var_3_4,
			game_won = flag,
			game_mode_key = game_mode_key,
			difficulty = Managers.state.difficulty:get_difficulty(),
			level_key = Managers.state.game_mode:level_key(),
			weave_personal_best_achieved = self._weave_personal_best_achieved,
			completed_weave = self._completed_weave,
			profile_synchronizer = self.profile_synchronizer,
			challenge_progression_status = {
				start_progress = Managers.mechanism:get_stored_challenge_progression_status(),
				end_progress = Managers.mechanism:get_challenge_progression_status()
			}
		}

		if not flag_2 then
			tbl.party_composition = Managers.party:get_party_composition()
		end

		local get_players_session_score = Managers.mechanism:get_players_session_score(self.statistics_db, self.profile_synchronizer, self._saved_scoreboard_stats)

		if not self.is_server then
			Managers.mechanism:sync_players_session_score(get_players_session_score)
		end

		tbl.players_session_score = get_players_session_score
		self._weave_personal_best_achieved = nil
		self._completed_weave = nil

		local flag_3 = current_mechanism_name ~= "versus" or Managers.mechanism:game_mechanism():win_conditions()
		local tbl_2 = {
			team_scores = not flag_3 and flag_3:get_total_scores()
		}

		tbl.rewards = tbl_2

		if not GameSettingsDevelopment.read_only_backend then
			local get_level_start, var_3_12, var_3_13 = self.rewards:get_level_start()
			local get_versus_level_start, var_3_15 = self.rewards:get_versus_level_start()

			tbl_2.level_start = {
				get_level_start,
				var_3_12,
				var_3_13
			}
			tbl_2.versus_level_start = {
				get_versus_level_start,
				var_3_15
			}
			tbl_2.win_track_start_experience = self.rewards:get_win_track_experience_start()

			local get_rewards, var_3_17 = self.rewards:get_rewards()
			local clone

			if not get_rewards then
				clone = table.clone(get_rewards)

				if not clone then
					-- Nothing
				end
			end

			clone = {}

			::label_3_0::

			tbl_2.end_of_level_rewards = clone
			tbl_2.mission_results = table.clone(self.rewards:get_mission_results())

			local clone_2

			if not var_3_17 then
				clone_2 = table.clone(var_3_17)

				if not clone_2 then
					-- Nothing
				end
			end

			clone_2 = {}

			::label_3_1::

			tbl.end_of_level_rewards_arguments = clone_2
		else
			tbl_2.end_of_level_rewards = {}
			tbl_2.mission_results = {}
		end

		tbl.level_end_view = Managers.mechanism:get_level_end_view()
		tbl.level_end_view_packages = Managers.mechanism:get_level_end_view_packages()
		self.parent.parent.loading_context.level_end_view_context = tbl

		if not IS_PS4 then
			Managers.account:set_presence("dice_game")
		end

		if not Managers.chat:chat_is_focused() then
			Managers.chat.chat_gui:block_input()
		end
	end

	self.has_setup_end_of_level = true
end

StateInGameRunning.level_end_view_wrapper = function (self)
	-- function 4
	return self._level_end_view_wrapper
end

StateInGameRunning.handle_end_conditions = function (arg_5_0)
	-- function 5
	local game_mode = Managers.state.game_mode

	if not game_mode and not game_mode:is_game_mode_ended() and not game_mode:is_game_mode_ended() then
		-- Nothing
	end
end

StateInGameRunning.check_invites = function (self)
	-- function 6
	if not self.popup_id then
		return
	end

	if not (not self.network_client and self.network_client:is_ingame()) then
		return
	end

	if not (not self.network_server and self.network_server:are_all_peers_ingame(nil, true)) then
		return
	end

	if self.parent.exit_type ~= nil then
		return
	end

	local PLATFORM = PLATFORM

	if not IS_CONSOLE and Managers.account:offline_mode() and not Managers.account:has_fatal_error() then
		if not Managers.invite:has_invitation() then
			self._offline_invite = true
		end

		return
	end

	local get_invited_lobby_data = Managers.invite:get_invited_lobby_data()

	if not get_invited_lobby_data then
		local id = get_invited_lobby_data.id

		id = id or get_invited_lobby_data.name

		local var_6_3

		if not IS_XB1 then
			var_6_3 = not self._lobby_host and self._lobby_host.lobby._data.session_name and self._lobby_client.lobby._data.session_name
		else
			var_6_3 = not self._lobby_host and self._lobby_host:id() and self._lobby_client:id()
		end

		local voting = Managers.state.voting

		if not voting then
			voting = Managers.state.voting:vote_in_progress()
			voting = not voting and Managers.state.voting:active_vote_template().mission_vote
		end

		local get_current_level_key = Managers.level_transition_handler:get_current_level_key()
		local var_6_6 = LevelSettings[get_current_level_key]

		if (Managers.matchmaking:is_game_matchmaking() or not voting or not self.network_server) and not var_6_6.hub_level then
			mm_printf("Found an invite, but was matchmaking.")

			self.popup_id = Managers.popup:queue_popup(Localize("popup_join_while_matchmaking"), Localize("popup_error_topic"), "ok", Localize("button_ok"))
		elseif id == var_6_3 then
			mm_printf("Found an invite, but was already in lobby.")

			self.popup_id = Managers.popup:queue_popup(Localize("popup_already_in_same_lobby"), Localize("popup_error_topic"), "ok", Localize("button_ok"))
		elseif not Managers.play_go:installed() then
			mm_printf("Found an invite, but game was not fully installed.")

			self.popup_id = Managers.popup:queue_popup(Localize("popup_invite_not_installed"), Localize("popup_invite_not_installed_header"), "not_installed", Localize("menu_ok"))
		elseif not (not self.network_server and self.network_server:are_all_peers_ingame(nil, true)) then
			mm_printf("Found an invite, but someone is trying to join the game.")

			self.popup_id = Managers.popup:queue_popup(Localize("popup_join_blocked_by_joining_player"), Localize("popup_invite_not_installed_header"), "not_installed", Localize("menu_ok"))
		elseif not (not get_invited_lobby_data.mechanism and get_invited_lobby_data.mechanism ~= "versus" and not get_invited_lobby_data.matchmaking and get_invited_lobby_data.matchmaking ~= "searching") then
			mm_printf("Inviting player is currently matchmaking into a quick play game/dedicated server lobby.")

			self.popup_id = Managers.popup:queue_popup(Localize("matchmaking_status_join_game_failed_is_searching_for_dedicated_server"), Localize("popup_invite_not_installed_header"), "not_installed", Localize("menu_ok"))
		elseif not (self._lobby_client or self.is_in_inn) then
			self._invite_lobby_data = get_invited_lobby_data
		elseif not self.popup_id then
			Managers.matchmaking:request_join_lobby(get_invited_lobby_data, {
				friend_join = true
			})
		end
	end
end

StateInGameRunning.wanted_transition = function (self)
	-- function 7
	if not self.popup_id then
		return
	end

	if not (not self.network_client and self.network_client:is_ingame()) then
		return
	end

	if not (not self.network_server and not self.is_in_inn and self.network_server:are_all_peers_ingame(nil, true)) then
		return
	end

	local get_transition, var_7_1 = Managers.ui:get_transition()

	if not get_transition then
		mm_printf("Doing transition %s from UI", get_transition)
	elseif not self._offline_invite then
		get_transition = "offline_invite"
		self._offline_invite = nil
	elseif not self._invite_lobby_data then
		if not self._invite_lobby_data.is_server_invite then
			mm_printf("Found a server invite, joining.")

			get_transition = "join_server"
		else
			mm_printf("Found a lobby invite, joining.")

			get_transition = "join_lobby"
		end

		var_7_1 = self._invite_lobby_data
		self._invite_lobby_data = nil
	end

	if not get_transition then
		get_transition, var_7_1 = Managers.matchmaking:get_transition()

		if not get_transition then
			mm_printf("Matchmaking manager returned a wanted transition %s, doing it.", get_transition)
		end
	end

	if get_transition or not self.afk_kick then
		get_transition = "afk_kick"
	end

	get_transition = get_transition or Managers.state.game_mode:wanted_transition()

	if not (not get_transition and not IS_XB1 and self.is_in_inn and self.is_in_tutorial or Development.parameter("auto-host-level") == nil) then
		-- Nothing
	elseif not self._xbox_event_end_triggered then
		Application.warning("MultiplyerRoundStart was triggered without end conditions met")
		self:_xbone_end_of_round_events(self.statistics_db)
	end

	return get_transition, var_7_1
end

StateInGameRunning.event_end_screen_ui_complete = function (arg_8_0)
	-- function 8
	Managers.state.conflict:destroy_all_units()
	Managers.ui:set_ingame_ui_enabled(false)

	if not Managers.state.network:game() then
		Managers.state.network.network_transmit:send_rpc_server("rpc_is_ready_for_transition")
	end
end

StateInGameRunning.gm_event_end_conditions_met = function (self, arg_9_1, arg_9_2, arg_9_3)
	-- function 9
	if not ((self.is_server or self.game_mode_key ~= "versus" or not Managers.mechanism:is_final_round()) and self._player_session_score_synced) then
		self._player_session_score_synced_cb = callback(self, "gm_event_end_conditions_met", arg_9_1, arg_9_2, arg_9_3)

		return
	end

	if not self._game_has_started then
		Managers.transition:hide_loading_icon()
		Managers.transition:fade_out(GameSettings.transition_fade_in_speed)
	end

	local is_server = self.is_server
	local player = self.player

	self.end_conditions_met = true

	local get_difficulty = Managers.state.difficulty:get_difficulty()
	local level_key = Managers.state.game_mode:level_key()
	local game_mode_key = self.game_mode_key
	local is_quickplay = self.is_quickplay
	local evaluate_end_condition_outcome, var_9_7 = Managers.state.game_mode:evaluate_end_condition_outcome(arg_9_1, player)
	local temporary_get_ingame_ui_called_from_state_ingame_running = Managers.ui:temporary_get_ingame_ui_called_from_state_ingame_running()
	local stats_id = player:stats_id()
	local statistics_db = self.statistics_db

	if not LevelUnlockUtils.completed_level_difficulty_index(statistics_db, stats_id, level_key) then
		local num = 0
	end

	temporary_get_ingame_ui_called_from_state_ingame_running:handle_transition("close_active")

	if not Managers.twitch then
		Managers.twitch:deactivate_twitch_game_mode()
	end

	if not self.is_in_inn then
		DialogueSystem.stateless_global_context.last_level_played = level_key
		DialogueSystem.stateless_global_context.last_level_won = evaluate_end_condition_outcome
	end

	if not temporary_get_ingame_ui_called_from_state_ingame_running.leave_game then
		statistics_db:reset_persistant_stats()
		StatisticsUtil.reset_mission_streak(player, statistics_db, stats_id)

		return
	end

	LoreBookHelper.save_new_pages()

	local system = Managers.state.entity:system("mission_system")

	system:set_percentage_completed(arg_9_3)
	Managers.state.achievement:evaluate_end_of_level_achievements(statistics_db, stats_id, level_key, get_difficulty)

	local get_interface = Managers.backend:get_interface("statistics")
	local flag = true
	local is_final_round = Managers.mechanism:is_final_round()

	Managers.mechanism:load_end_screen_resources()

	if game_mode_key == "survival" then
		if not evaluate_end_condition_outcome then
			print("Game won")
			system:evaluate_level_end_missions()
			StatisticsUtil.register_complete_survival_level(statistics_db)
			get_interface:save()
		end
	elseif not evaluate_end_condition_outcome then
		print("Game won")

		if game_mode_key == "weave" then
			is_final_round = not Managers.weave:calculate_next_objective_index()

			if not is_final_round then
				local weave = Managers.weave
				local get_weave_tier = weave:get_weave_tier()
				local get_score = weave:get_score()
				local get_num_players = weave:get_num_players()
				local count = #WeaveSettings.templates_ordered
				local flag_2 = false

				for i = count, get_weave_tier, -1 do
					local get_weave_score_stat = ScorpionSeasonalSettings.get_weave_score_stat(i, get_num_players)
					local get_persistent_stat = statistics_db:get_persistent_stat(stats_id, ScorpionSeasonalSettings.current_season_name, get_weave_score_stat)
					local flag_3 = not get_persistent_stat and get_persistent_stat > 0

					if get_weave_tier == i then
						if not (not flag_3 and get_persistent_stat < get_score or flag_3) then
							flag_2 = true

							break
						end
					elseif not flag_3 then
						break
					end
				end

				self._weave_personal_best_achieved = flag_2
				self._completed_weave = weave:get_active_weave()

				StatisticsUtil.register_weave_complete(statistics_db, player, is_quickplay, get_difficulty)
			else
				local get_weave_stats = ScoreboardHelper.get_weave_stats(self.statistics_db, self.profile_synchronizer)

				self.parent.parent.loading_context.saved_scoreboard_stats = get_weave_stats
			end
		elseif game_mode_key == "versus" then
			flag = is_final_round
		end

		if not is_final_round then
			self.parent.parent.loading_context.saved_scoreboard_stats = nil
		end

		if not flag then
			if not self._is_in_event_game_mode then
				StatisticsUtil.register_played_weekly_event_level(statistics_db, player, level_key, get_difficulty)
			end

			StatisticsUtil.register_complete_level(statistics_db, game_mode_key)

			if not (game_mode_key ~= "versus" or self.is_in_inn) then
				StatisticsUtil.register_versus_game_won(statistics_db, player, evaluate_end_condition_outcome)
			end
		end

		if not is_final_round and not Managers.mechanism.on_final_round_won then
			Managers.mechanism:on_final_round_won(statistics_db, stats_id)
		end

		get_interface:save()
	elseif not var_9_7 then
		if game_mode_key == "versus" then
			if not is_final_round then
				if not self._is_in_event_game_mode then
					StatisticsUtil.register_played_weekly_event_level(statistics_db, player, level_key, get_difficulty)
				end

				StatisticsUtil.register_complete_level(statistics_db, game_mode_key)

				if not self.is_in_inn then
					StatisticsUtil.register_versus_game_won(statistics_db, player, evaluate_end_condition_outcome)
				end
			end
		else
			is_final_round = true
		end

		Managers.state.game_mode:game_lost(player)
		print("Game lost")

		self.parent.parent.loading_context.saved_scoreboard_stats = nil
		self.checkpoint_available = arg_9_2

		if game_mode_key ~= "versus" then
			statistics_db:reset_persistant_stats()
		end

		StatisticsUtil.reset_mission_streak(player, statistics_db, stats_id)
		get_interface:save()
	end

	if game_mode_key == "versus" then
		if not self.is_server then
			local get_players_session_score = Managers.mechanism:get_players_session_score(self.statistics_db, self.profile_synchronizer, self._saved_scoreboard_stats)

			if not is_final_round then
				Managers.mechanism:sync_players_session_score(get_players_session_score)
			else
				self.parent.parent.loading_context.saved_scoreboard_stats = get_players_session_score
			end
		end

		get_interface:save()
	end

	local get_end_screen_config, var_9_28, var_9_29 = Managers.state.game_mode:get_end_screen_config(evaluate_end_condition_outcome, var_9_7, player, arg_9_1)
	local flag_4 = game_mode_key == "weave"
	local var_9_31
	local var_9_32
	local var_9_33
	local var_9_34

	if not flag_4 then
		var_9_31, var_9_32, var_9_33 = self:_get_weave_scores()

		local current_bar_score = Managers.weave:current_bar_score()

		Managers.weave:store_saved_game_mode_data()
	end

	local function fn(arg_10_0)
		-- function 10
		if not (not flag_4 and (GameSettingsDevelopment.read_only_backend or not evaluate_end_condition_outcome or not is_final_round or not is_server) and self.is_quickplay) then
			self:_submit_weave_scores(var_9_31, var_9_32, var_9_33)
		end

		if arg_10_0 == "commit_error" then
			Managers.backend:commit_error()

			return
		end

		if not temporary_get_ingame_ui_called_from_state_ingame_running.leave_game then
			return
		end

		if not self.parent then
			return
		end

		if not GameModeSettings[game_mode_key].end_mission_rewards then
			if GameSettingsDevelopment.read_only_backend or var_9_7 or not is_final_round then
				self:_award_end_of_level_rewards(statistics_db, stats_id, evaluate_end_condition_outcome, get_difficulty, level_key)
			end

			print("end screen_name:", get_end_screen_config, var_9_28, var_9_29)
			temporary_get_ingame_ui_called_from_state_ingame_running:activate_end_screen_ui(get_end_screen_config, var_9_28, var_9_29)
		end

		if not evaluate_end_condition_outcome and is_final_round and not var_9_7 and not flag_4 then
			Managers.weave:clear_weave_name()
		end
	end

	Managers.backend:commit(true, fn)

	self.game_lost = var_9_7
	self.game_won = evaluate_end_condition_outcome
	self.game_tied = not not evaluate_end_condition_outcome or not var_9_7

	if not IS_PS4 then
		Managers.account:set_realtime_multiplay(false)
	end

	if self.is_in_inn or not self.is_in_tutorial then
		return
	end

	if not IS_XB1 then
		if not self._xbox_event_end_triggered then
			self:_xbone_end_of_round_events(statistics_db)
		end

		if not (self.is_in_inn or self.is_in_tutorial or self.parent.hero_stats_updated) then
			Managers.xbox_stats:update_hero_stats(evaluate_end_condition_outcome)

			self.parent.hero_stats_updated = true
		end
	end
end

StateInGameRunning._award_end_of_level_rewards = function (self, arg_11_1, arg_11_2, arg_11_3, arg_11_4, arg_11_5)
	-- function 11
	local peer_id = Network.peer_id()
	local get_persistent_profile_index_reservation, var_11_2 = self.profile_synchronizer:get_persistent_profile_index_reservation(peer_id)
	local var_11_3 = SPProfiles[get_persistent_profile_index_reservation]
	local display_name = var_11_3.display_name
	local floor = math.floor(Managers.time:time("game"))
	local get_end_of_level_rewards_arguments = Managers.mechanism:get_end_of_level_rewards_arguments(arg_11_3, self.is_quickplay, arg_11_1, arg_11_2, arg_11_5, display_name)
	local get_end_of_level_extra_mission_results = Managers.mechanism:get_end_of_level_extra_mission_results()

	get_end_of_level_rewards_arguments.hero_name = display_name
	get_end_of_level_rewards_arguments.ingame_display_name = var_11_3.ingame_display_name

	self.rewards:award_end_of_level_rewards(arg_11_3, display_name, self._is_in_event_game_mode, floor, get_end_of_level_rewards_arguments, get_end_of_level_extra_mission_results)

	local var_11_8 = LootChestData.chests_by_category[arg_11_4]

	if not var_11_8 then
		local package_name = var_11_8.package_name

		self.chests_package_name = package_name

		Managers.package:load(package_name, "global")
	end
end

StateInGameRunning._get_weave_scores = function (arg_12_0)
	-- function 12
	local weave = Managers.weave
	local get_weave_tier = weave:get_weave_tier()
	local get_score = weave:get_score()
	local get_num_players = weave:get_num_players()

	return get_weave_tier, get_score, get_num_players
end

StateInGameRunning._submit_weave_scores = function (arg_13_0, arg_13_1, arg_13_2, arg_13_3)
	-- function 13
	Managers.backend:get_interface("weaves"):submit_scores(arg_13_1, arg_13_2, arg_13_3)
end

StateInGameRunning.on_checkpoint_vote_cancelled = function (self)
	-- function 14
	self.checkpoint_vote_cancelled = true
end

if not (IS_WINDOWS or BUILD == "dev" or BUILD ~= "debug") then
	function RELOAD_CONTROLS()
		-- function 15
		Managers.input:create_input_service("Player", "PlayerControllerKeymaps", "PlayerControllerFilters")
		Managers.input:map_device_to_service("Player", "keyboard")
		Managers.input:map_device_to_service("Player", "mouse")
		Managers.input:map_device_to_service("Player", "gamepad")

		local get_service = Managers.input:get_service("Player")
		local local_player = Managers.player:local_player()

		local_player.input_source = get_service

		local player_unit = local_player.player_unit

		ScriptUnit.extension(player_unit, "input_system").input_service = get_service
	end
end

StateInGameRunning.update = function (self, arg_16_1, arg_16_2)
	-- function 16
	if self._transitioned_from_black_screen or not self:_check_black_screen_transition_requirements(arg_16_1, arg_16_2) then
		self:_game_actually_starts()

		if not (not IS_WINDOWS and self.is_in_inn or Window.has_focus()) then
			Window.flash_window(nil, "start", 3)
		end

		self._transitioned_from_black_screen = true
	end

	if not (not self._waiting_for_peers_message_timer and not (arg_16_2 > self._waiting_for_peers_message_timer)) then
		if not self.is_server then
			if #self._lobby_host:members():get_members() > 1 then
				Managers.transition:show_waiting_for_peers_message(true)

				self._waiting_for_peers_message_timer = nil
			end
		else
			Managers.transition:show_waiting_for_peers_message(true)

			self._waiting_for_peers_message_timer = nil
		end
	end

	if not self.checkpoint_vote_cancelled then
		self.checkpoint_available = nil
		self.checkpoint_vote_cancelled = nil
	end

	local temporary_get_ingame_ui_called_from_state_ingame_running = Managers.ui:temporary_get_ingame_ui_called_from_state_ingame_running()

	if not temporary_get_ingame_ui_called_from_state_ingame_running then
		local end_screen_active

		if not (temporary_get_ingame_ui_called_from_state_ingame_running.survey_active or self.has_setup_end_of_level) then
			end_screen_active = temporary_get_ingame_ui_called_from_state_ingame_running:end_screen_active()

			if not end_screen_active then
				end_screen_active = temporary_get_ingame_ui_called_from_state_ingame_running:end_screen_fade_in_complete()
			end
		else
			end_screen_active = false
		end

		if false then
			end_screen_active = true
		end

		local read_only_backend = GameSettingsDevelopment.read_only_backend

		if not read_only_backend then
			read_only_backend = self.rewards:rewards_generated()

			if not read_only_backend then
				if not self.rewards:consuming_deed() then
					read_only_backend = self.chests_package_name

					if not read_only_backend then
						read_only_backend = Managers.package:has_loaded(self.chests_package_name, "global")
					end
				else
					read_only_backend = false
				end
			end
		end

		if false then
			read_only_backend = true
		end

		local current_mechanism_name = Managers.mechanism:current_mechanism_name()

		if current_mechanism_name == "versus" then
			read_only_backend = true
		end

		if not (not end_screen_active and current_mechanism_name ~= "versus") then
			if not Managers.mechanism:is_final_round() and not read_only_backend then
				self:_setup_end_of_level_UI()
			end
		elseif not end_screen_active and not read_only_backend then
			self:_setup_end_of_level_UI()
		end
	end

	if not self.popup_id then
		local query_result = Managers.popup:query_result(self.popup_id)

		if not query_result then
			if query_result == "not_installed" then
				Managers.invite:clear_invites()
			end

			self.popup_id = nil
		end
	end

	local time = Managers.time:time("main")

	self:update_player_afk_check(arg_16_1, time)

	if not Managers.benchmark then
		Managers.benchmark:update(arg_16_1, arg_16_2)
	end

	if not self._fps_reporter_testify then
		self._fps_reporter_testify:update(arg_16_1, arg_16_2)
	end

	if not script_data.testify then
		Testify:poll_requests_through_handler(testify, self)
	end
end

StateInGameRunning.check_for_new_quests_or_contracts = function (self, arg_17_1)
	-- function 17
	local num

	if not self._quest_expire_check_cooldown then
		num = self._quest_expire_check_cooldown - arg_17_1

		if not num then
			-- Nothing
		end
	end

	num = 0

	::label_17_0::

	self._quest_expire_check_cooldown = num

	if self._quest_expire_check_cooldown <= 0 then
		local quest = Managers.state.quest

		if quest:has_quests_expired() or not quest:has_contracts_expired() then
			Managers.chat:add_local_system_message(1, Localize("dlc1_3_1_new_quests_and_contracts_available_text"), true)

			self._quest_expire_check_cooldown = QuestSettings.EXPIRE_CHECK_COOLDOWN
		end
	end
end

StateInGameRunning.disable_ui = function (arg_18_0)
	-- function 18
	Managers.ui:set_ingame_ui_enabled(false)
end

StateInGameRunning.event_close_ingame_menu = function (arg_19_0)
	-- function 19
	local temporary_get_ingame_ui_called_from_state_ingame_running = Managers.ui:temporary_get_ingame_ui_called_from_state_ingame_running()

	if not temporary_get_ingame_ui_called_from_state_ingame_running then
		temporary_get_ingame_ui_called_from_state_ingame_running:suspend_active_view()
	end
end

StateInGameRunning.event_realtime_multiplay = function (self, arg_20_1)
	-- function 20
	if not arg_20_1 and self.is_in_tutorial and not self.is_in_inn then
		return
	end

	Managers.account:set_realtime_multiplay(arg_20_1)
end

StateInGameRunning.cb_loading_view_fade_in_done = function (self)
	-- function 21
	Managers.transition:fade_out(GameSettings.transition_fade_out_speed, nil)

	self.show_loading_view = false
end

StateInGameRunning.post_update = function (self, arg_22_1, arg_22_2)
	-- function 22
	local _level_end_view_wrapper = self._level_end_view_wrapper
	local disable_ui = script_data.disable_ui

	if not disable_ui then
		if _level_end_view_wrapper == nil then
			disable_ui = self.waiting_for_transition

			if not disable_ui then
				-- Nothing
			end

			if Managers.state.network:game_session_host() == nil then
				disable_ui = false

				goto label_22_0
			end
		end

		disable_ui = true
	end

	::label_22_0::

	Managers.ui:post_update(arg_22_1, arg_22_2, disable_ui)

	if not _level_end_view_wrapper then
		_level_end_view_wrapper:update(arg_22_1, arg_22_2)

		if not _level_end_view_wrapper:done() then
			_level_end_view_wrapper:destroy()

			self._level_end_view_wrapper = nil
		end
	end

	if not self._game_started_current_frame then
		if not (not IS_PS4 and Managers.state.entity:system("cutscene_system").active_camera) then
			self:event_realtime_multiplay(true)
		end

		self._game_started_current_frame = false
	end
end

StateInGameRunning.trigger_xbox_multiplayer_round_end_events = function (self)
	-- function 23
	if self.is_in_inn or self.is_in_tutorial or Development.parameter("auto-host-level") ~= nil or not self._xbox_event_end_triggered then
		return
	end

	self:_xbone_end_of_round_events(self.statistics_db)
end

StateInGameRunning.on_exit = function (self)
	-- function 24
	Managers.music:on_exit_game()
	Managers.state.network.profile_synchronizer:set_own_actually_ingame(false)
	self.free_flight_manager:set_teleport_override(nil)

	self.parent = nil
	self.free_flight_manager = nil
	self.input_manager = nil

	CLEAR_ALL_PLAYER_LISTS()

	if not Managers.benchmark then
		Managers.benchmark:destroy()

		Managers.benchmark = nil
	end

	if not self._level_end_view_wrapper then
		self._level_end_view_wrapper:destroy()

		self._level_end_view_wrapper = nil
	end

	if not IS_PS4 then
		Managers.account:set_realtime_multiplay(false)
	end

	Managers.ui:destroy_ingame_ui()

	if not self.loading_view then
		self.loading_view:destroy()

		self.loading_view = nil
	end

	if not self.network_event_delegate then
		self.network_event_delegate:unregister(self)

		self.network_event_delegate = nil
	end

	self.level_end_view_context = nil
	self.player = nil

	self:_cancel_afk_warning()
end

StateInGameRunning.event_game_started = function (self)
	-- function 25
	local world = self.parent.world
	local current_level = LevelHelper:current_level(world)

	Level.trigger_event(current_level, "game_started")

	if not self.is_server then
		Managers.state.voting:set_vote_kick_enabled(true)
	end

	self.end_conditions_met = false

	if not Managers.matchmaking:have_game_mode_event_data() then
		self._is_in_event_game_mode = true
	end

	if self.is_in_inn or not self.is_in_tutorial then
		return
	end

	if not IS_XB1 then
		self:_xbone_round_start_events()
	end
end

if not IS_XB1 then
	StateInGameRunning.event_trigger_xbox_round_end = function (self)
		-- function 26
		self:_xbone_end_of_round_events(self.statistics_db)
	end

	StateInGameRunning._xbone_round_start_events = function (self)
		-- function 27
		if not (self.is_in_inn or self.is_in_tutorial or Development.parameter("auto-host-level") ~= nil or Managers.account:is_online()) then
			return
		end

		if not self._xbox_event_init_triggered then
			self._xbox_event_init_triggered = true

			local session_id = Managers.state.network:lobby().lobby:session_id()
			local tbl = {
				Managers.account:xbox_user_id(),
				Managers.account:round_id(),
				0,
				Managers.account:player_session_id(),
				MultiplayerSession.multiplayer_correlation_id(session_id),
				0,
				0,
				0
			}

			Managers.transition:set_multiplayer_values("start", {
				xuid = Managers.account:xbox_user_id(),
				round_id = Managers.account:round_id(),
				player_session_id = Managers.account:player_session_id(),
				correlation_id = MultiplayerSession.multiplayer_correlation_id(session_id)
			}, string.format("[StateInGameRunning] Writing MultiplayerRoundStart. CorrelationID: %s. RoundID: %s", tostring(MultiplayerSession.multiplayer_correlation_id(session_id)), tostring(Managers.account:round_id())))

			local format = string.format("[StateInGameRunning] Writing MultiplayerRoundStart. CorrelationID: %s. RoundID: %s", tostring(MultiplayerSession.multiplayer_correlation_id(session_id)), tostring(Managers.account:round_id()))
			local warning = Application.warning

			Managers.xbox_events:write("MultiplayerRoundStart", tbl, format, warning, true)
		end
	end

	StateInGameRunning._xbone_end_of_round_events = function (self, arg_28_1)
		-- function 28
		if not (self.is_in_inn or self.is_in_tutorial or Development.parameter("auto-host-level") ~= nil or Managers.account:is_online()) then
			return
		end

		if not self._xbox_event_end_triggered then
			self._xbox_event_end_triggered = true

			local session_id = Managers.state.network:lobby().lobby:session_id()
			local tbl = {
				Managers.account:xbox_user_id(),
				Managers.account:round_id(),
				0,
				Managers.account:player_session_id(),
				MultiplayerSession.multiplayer_correlation_id(session_id),
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
				correlation_id = MultiplayerSession.multiplayer_correlation_id(session_id),
				time = Managers.time:time("game")
			}, string.format("[StateInGameRunning] Writing MultiplayerRoundEnd. CorrelationID: %s. RoundID: %s", tostring(MultiplayerSession.multiplayer_correlation_id(session_id)), tostring(Managers.account:round_id())))

			local format = string.format("[StateInGameRunning] Writing MultiplayerRoundEnd. CorrelationID: %s. RoundID: %s", tostring(MultiplayerSession.multiplayer_correlation_id(session_id)), tostring(Managers.account:round_id()))
			local warning = Application.warning

			Managers.xbox_events:write("MultiplayerRoundEnd", tbl, format, warning, true)
			Managers.transition:dump_multiplayer_data()
		end

		if not self._gameprogress_event_triggered then
			self._gameprogress_event_triggered = true

			local tbl_2 = {
				Managers.account:xbox_user_id(),
				Managers.account:player_session_id(),
				StatisticsUtil.get_game_progress(arg_28_1)
			}
			local str = "[StateInGameRunning] Writing GameProgress"
			local warning_2 = Application.warning

			Managers.xbox_events:write("GameProgress", tbl_2, str, warning_2, true)
		end
	end
end

StateInGameRunning._check_black_screen_transition_requirements = function (self)
	-- function 29
	if not self._game_mode_ready_to_start then
		self._game_mode_ready_to_start = Managers.state.game_mode:local_player_ready_to_start(self.player)
	end

	local _conflict_directory_is_ready = self._conflict_directory_is_ready

	_conflict_directory_is_ready = _conflict_directory_is_ready or not self.is_server

	local _game_mode_ready_to_start = self._game_mode_ready_to_start

	if not _conflict_directory_is_ready and not _game_mode_ready_to_start then
		if not self._has_started_framerate_catchup then
			self:_catchup_framerate_before_starting()

			self._has_started_framerate_catchup = true
		end

		self:_update_catchup_framerate_before_starting()

		if self._frame_catchup_counter == nil then
			return true
		end
	end

	return false
end

StateInGameRunning.event_conflict_director_setup_done = function (self)
	-- function 30
	self._conflict_directory_is_ready = true
end

StateInGameRunning._catchup_framerate_before_starting = function (self)
	-- function 31
	Framerate.set_catchup()

	self._frame_catchup_counter = 20
end

StateInGameRunning._update_catchup_framerate_before_starting = function (self)
	-- function 32
	if self._frame_catchup_counter == nil then
		return
	end

	self._frame_catchup_counter = self._frame_catchup_counter - 1

	if self._frame_catchup_counter == 0 then
		self._frame_catchup_counter = nil

		Framerate.set_playing()
	end
end

StateInGameRunning._game_actually_starts = function (self)
	-- function 33
	print("StateInGameRunning:_game_actually_starts()")

	local loading_context = self.parent.parent.loading_context

	Managers.state.game_mode:local_player_game_starts(self.player, loading_context)
	Managers.transition:fade_out(GameSettings.transition_fade_in_speed)

	self._game_started_current_frame = true
	self._game_has_started = true

	Managers.transition:hide_loading_icon()
	Managers.transition:show_waiting_for_peers_message(false)

	self._waiting_for_peers_message_timer = nil

	Managers.load_time:end_timer()

	if not Managers.twitch then
		local get_current_level_keys = Managers.level_transition_handler:get_current_level_keys()
		local var_33_2 = LevelSettings[get_current_level_keys]

		if not (not var_33_2 and var_33_2.disable_twitch_game_mode) then
			Managers.twitch:activate_twitch_game_mode(self.network_event_delegate, Managers.state.game_mode:game_mode_key())
		end
	end

	Managers.state.network.profile_synchronizer:set_own_actually_ingame(true)

	self._game_started_timestamp = os.time(os.date("*t"))

	if not IS_WINDOWS then
		Managers.account:update_presence()
	end
end

local num = 120
local num_2 = 180

StateInGameRunning.update_player_afk_check = function (self, arg_34_1, arg_34_2)
	-- function 34
	do return end

	local active_camera = Managers.state.entity:system("cutscene_system").active_camera
	local afk_kick = self.afk_kick

	if not (afk_kick or active_camera) then
		-- Nothing
	end

	::label_34_0::

	afk_kick = self.is_server

	if not afk_kick then
		afk_kick = self.is_in_inn

		if not afk_kick then
			afk_kick = self.end_conditions_met
			afk_kick = afk_kick or Development.parameter("debug_disable_afk_kick")
		end
	end

	::label_34_1::

	if not afk_kick then
		if not self.afk_popup_id then
			self:_cancel_afk_warning()
		end

		self.last_active_time = nil

		return
	end

	local last_active_time = Managers.input.last_active_time

	if not self.last_active_time then
		self.last_active_time = last_active_time or arg_34_2
	elseif not (not last_active_time and last_active_time == self.last_active_time) then
		self.last_active_time = nil
	elseif not self.last_active_time then
		local player_unit = Managers.player:local_player(1).player_unit

		if not Unit.alive(player_unit) and not ScriptUnit.extension(player_unit, "status_system"):is_disabled() then
			self.last_active_time = self.last_active_time + arg_34_1
		else
			local num_3 = arg_34_2 - self.last_active_time
			local flag = num_3 > num
			local flag_2 = num_3 > num_2

			if not (not flag and self.afk_popup_id) then
				self:_show_afk_warning()
			elseif not flag_2 then
				self:_kick_afk_player()
			end
		end
	end

	self:_handle_afk_warning_result()
end

StateInGameRunning._show_afk_warning = function (self)
	-- function 35
	self.afk_popup_id = Managers.popup:queue_popup(Localize("afk_kick_warning"), Localize("popup_notice_topic"), "ok", Localize("button_ok"))

	if not (_G.Window == nil or Window.flash_window == nil or not Window.has_focus()) then
		Window.flash_window(nil, "start", 5)
	end

	local local_player = Managers.player:local_player(1)
	local str = "rpc_trigger_local_afk_system_message"
	local str_2 = "chat_afk_kick_warning"
	local peer_id = local_player.peer_id

	if not self.is_server then
		Managers.state.network.network_transmit:send_rpc_server(str, str_2, peer_id)
	end

	local var_35_4 = CHANNEL_TO_PEER_ID[peer_id]

	self:rpc_trigger_local_afk_system_message(var_35_4, str_2, peer_id)
end

StateInGameRunning.rpc_trigger_local_afk_system_message = function (self, arg_36_1, arg_36_2, arg_36_3)
	-- function 36
	if not self.is_server then
		Managers.state.network.network_transmit:send_rpc_clients_except(rpc, arg_36_3, arg_36_2, arg_36_3)
	end

	local player = Managers.player:player(arg_36_3, 1)

	if not player then
		local is_player_controlled = player:is_player_controlled()
		local user_name

		if not is_player_controlled then
			if not rawget(_G, "Steam") then
				user_name = Steam.user_name(arg_36_3)

				if not user_name then
					-- Nothing
				end
			end

			user_name = tostring(arg_36_3)

			if not user_name then
				-- Nothing
			end
		end

		user_name = player:name()

		::label_36_0::

		if not (not IS_CONSOLE and Managers.account:offline_mode()) then
			local lobby = Managers.state.network:lobby()

			user_name = not is_player_controlled and lobby:user_name(arg_36_3) and tostring(arg_36_3) and player:name()
		end

		local flag = true
		local format = string.format(Localize(arg_36_2), user_name)

		Managers.chat:add_local_system_message(1, format, flag)
	end
end

StateInGameRunning._cancel_afk_warning = function (self)
	-- function 37
	if not self.afk_popup_id then
		Managers.popup:cancel_popup(self.afk_popup_id)

		self.afk_popup_id = nil
	end
end

StateInGameRunning._handle_afk_warning_result = function (self)
	-- function 38
	if not self.afk_popup_id and not Managers.popup:query_result(self.afk_popup_id) then
		self.afk_popup_id = nil
	end
end

StateInGameRunning._kick_afk_player = function (self)
	-- function 39
	self:_cancel_afk_warning()

	local local_player = Managers.player:local_player(1)
	local str = "rpc_trigger_local_afk_system_message"
	local str_2 = "chat_afk_kick"
	local peer_id = local_player.peer_id

	if not self.is_server then
		Managers.state.network.network_transmit:send_rpc_server(str, str_2, peer_id)
	end

	local var_39_4 = CHANNEL_TO_PEER_ID[peer_id]

	self:rpc_trigger_local_afk_system_message(var_39_4, str_2, peer_id)

	self.afk_kick = true
end

StateInGameRunning.transitioned_from_black_screen = function (self)
	-- function 40
	return self._transitioned_from_black_screen
end

StateInGameRunning.rpc_follow_to_lobby = function (arg_41_0, arg_41_1, arg_41_2, arg_41_3)
	-- function 41
	printf("Got message from lobby host to join %s %s", NetworkLookup.lobby_type[arg_41_2], arg_41_3)

	local var_41_0 = CHANNEL_TO_PEER_ID[arg_41_1]

	if not Managers.party:is_leader(var_41_0) then
		return
	end

	local tbl = {
		join_method = "party"
	}

	if NetworkLookup.lobby_type[arg_41_2] == "server" then
		tbl.is_server_invite = true
		tbl.id = arg_41_3
		tbl.server_info = {
			ip_port = arg_41_3
		}
	else
		tbl.is_server_invite = false
		tbl.id = arg_41_3
	end

	local tbl_2 = {
		friend_join = true
	}

	Managers.matchmaking:request_join_lobby(tbl, tbl_2)
end

StateInGameRunning.player_session_scores_synced = function (self)
	-- function 42
	self._player_session_score_synced = true

	if not self._player_session_score_synced_cb then
		self._player_session_score_synced_cb()

		self._player_session_score_synced_cb = nil
	end
end
