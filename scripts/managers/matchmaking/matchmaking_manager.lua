-- chunkname: @scripts/managers/matchmaking/matchmaking_manager.lua

require("scripts/managers/matchmaking/matchmaking_state_search_game")
require("scripts/managers/matchmaking/matchmaking_state_request_join_game")
require("scripts/managers/matchmaking/matchmaking_state_request_profiles")
require("scripts/managers/matchmaking/matchmaking_state_start_game")
require("scripts/managers/matchmaking/matchmaking_state_host_game")
require("scripts/managers/matchmaking/matchmaking_state_join_game")
require("scripts/managers/matchmaking/matchmaking_state_idle")
require("scripts/managers/matchmaking/matchmaking_state_ingame")
require("scripts/managers/matchmaking/matchmaking_state_friend_client")
require("scripts/managers/matchmaking/matchmaking_state_wait_for_countdown")

local var_0_0 = require("scripts/managers/game_mode/mechanisms/reservation_handler_types")

DLCUtils.require_list("matchmaking_state_files")

MatchmakingManager = class(MatchmakingManager)
script_data.matchmaking_debug = script_data.matchmaking_debug or Development.parameter("matchmaking_debug")

local var_0_1 = script_data.testify and require("scripts/managers/matchmaking/matchmaking_manager_testify")

function mm_printf(arg_1_0, ...)
	if script_data.matchmaking_debug then
		arg_1_0 = "[Matchmaking] " .. arg_1_0

		printf(arg_1_0, ...)
	end
end

function mm_printf_force(arg_2_0, ...)
	arg_2_0 = "[Matchmaking] " .. arg_2_0

	printf(arg_2_0, ...)
end

local var_0_2 = Development.parameter("network_timeout_really_long") and 10000 or 0
local var_0_3 = DEDICATED_SERVER and true or false

MatchmakingSettings = {
	TIME_BETWEEN_EACH_SEARCH = 3.4,
	MAX_NUM_LOBBIES = 100,
	START_GAME_TIME = 5,
	MIN_STATUS_MESSAGE_TIME = 2,
	TOTAL_GAME_SEARCH_TIME = 5,
	afk_force_stop_mm_timer = 180,
	afk_warn_timer = 150,
	MAX_NUMBER_OF_PLAYERS = 4,
	host_games = "auto",
	restart_search_after_host_cancel = true,
	auto_ready = false,
	LOBBY_FINDER_UPDATE_INTERVAL = 1,
	JOIN_LOBBY_TIME_UNTIL_AUTO_CANCEL = 20 + var_0_2,
	REQUEST_JOIN_LOBBY_REPLY_TIME = 30 + var_0_2,
	REQUEST_PROFILES_REPLY_TIME = 10 + var_0_2,
	max_distance_filter = GameSettingsDevelopment.network_mode == "lan" and "close" or Application.user_setting("max_quick_play_search_range") ~= "medium" and Application.user_setting("max_quick_play_search_range") or "close" or DefaultUserSettings.get("user_settings", "max_quick_play_search_range"),
	allowed_profiles = {
		true,
		true,
		true,
		true,
		true
	},
	hero_search_filter = {
		true,
		true,
		true,
		true,
		true
	},
	quickplay_level_select_settings = {
		loss_multiplier = 1,
		win_multiplier = 1,
		base_level_weight = 1,
		amount_of_relevant_games = 20,
		progression_multiplier = 10
	}
}
MatchmakingSettingsOverrides = {
	versus = {
		TIME_BETWEEN_EACH_SEARCH = 3.4,
		MAX_NUM_LOBBIES = 100,
		START_GAME_TIME = 5,
		REQUEST_JOIN_LOBBY_REPLY_TIME = 300,
		MIN_STATUS_MESSAGE_TIME = 2,
		TOTAL_GAME_SEARCH_TIME = 5,
		afk_force_stop_mm_timer = 180,
		afk_warn_timer = 150,
		MAX_NUMBER_OF_PLAYERS = 8,
		host_games = "auto",
		restart_search_after_host_cancel = true,
		auto_ready = false,
		REQUEST_PROFILES_REPLY_TIME = 300,
		JOIN_LOBBY_TIME_UNTIL_AUTO_CANCEL = 300,
		LOBBY_FINDER_UPDATE_INTERVAL = 1,
		max_distance_filter = GameSettingsDevelopment.network_mode == "lan" and "close" or Application.user_setting("max_quick_play_search_range") ~= "medium" and Application.user_setting("max_quick_play_search_range") or "close" or DefaultUserSettings.get("user_settings", "max_quick_play_search_range"),
		allowed_profiles = {
			true,
			true,
			true,
			true,
			true
		},
		hero_search_filter = {
			true,
			true,
			true,
			true,
			true
		},
		quickplay_level_select_settings = {
			loss_multiplier = 1,
			win_multiplier = 1,
			base_level_weight = 1,
			amount_of_relevant_games = 20,
			progression_multiplier = 10
		}
	}
}

local var_0_4 = {
	"rpc_matchmaking_request_profiles_data",
	"rpc_matchmaking_request_join_lobby",
	"rpc_matchmaking_request_profile",
	"rpc_set_matchmaking",
	"rpc_cancel_matchmaking",
	"rpc_matchmaking_request_join_lobby_reply",
	"rpc_notify_connected",
	"rpc_matchmaking_join_game",
	"rpc_matchmaking_request_profile_reply",
	"rpc_matchmaking_request_profiles_data_reply",
	"rpc_matchmaking_request_selected_level",
	"rpc_matchmaking_request_selected_level_reply",
	"rpc_matchmaking_request_selected_difficulty",
	"rpc_matchmaking_request_selected_difficulty_reply",
	"rpc_matchmaking_request_status_message",
	"rpc_matchmaking_status_message",
	"rpc_set_client_game_privacy",
	"rpc_game_server_set_group_leader",
	"rpc_matchmaking_broadcast_game_server_ip_address",
	"rpc_start_game_countdown_finished",
	"rpc_matchmaking_sync_quickplay_data",
	"rpc_matchmaking_request_quickplay_data",
	"rpc_matchmaking_verify_dlc",
	"rpc_matchmaking_verify_dlc_reply",
	"rpc_join_reserved_game_server",
	"rpc_matchmaking_client_join_player_hosted",
	"rpc_matchmaking_client_joined_player_hosted",
	"rpc_matchmaking_request_reserve_slots",
	"rpc_matchmaking_request_reserve_slots_reply",
	"rpc_matchmaking_reservation_success",
	"rpc_matchmaking_ticket_request",
	"rpc_matchmaking_ticket_response",
	"rpc_matchmaking_queue_session_data",
	"rpc_flexmatch_game_session_id_request"
}
local var_0_5 = {
	MatchmakingStatePartyJoins = "versus",
	MatchmakingStateWaitJoinPlayerHosted = "versus",
	MatchmakingStateReserveSlotsPlayerHosted = "versus",
	MatchmakingStateHostGame = "adventure",
	MatchmakingStateWaitForCountdown = "adventure",
	MatchmakingStatePlayerHostedGame = "versus",
	MatchmakingStateReserveLobby = "versus",
	MatchmakingStateIngame = "adventure",
	MatchmakingStateSearchPlayerHostedLobby = "versus",
	MatchmakingStateHostFindWeaveGroup = "adventure",
	MatchmakingStateFlexmatchHost = "versus"
}

MatchmakingManager._broken_lobbies = MatchmakingManager._broken_lobbies or {}
MatchmakingManager._broken_servers = MatchmakingManager._broken_servers or {}

MatchmakingManager.init = function (arg_3_0, arg_3_1)
	arg_3_0.params = arg_3_1
	arg_3_0.network_transmit = arg_3_1.network_transmit
	arg_3_0.lobby = arg_3_1.lobby
	arg_3_0.peer_id = arg_3_1.peer_id
	arg_3_0.is_server = arg_3_1.is_server
	arg_3_0.profile_synchronizer = arg_3_1.profile_synchronizer
	arg_3_0.statistics_db = arg_3_1.statistics_db
	arg_3_0.network_server = arg_3_1.network_server
	arg_3_0._network_hash = arg_3_0.lobby.network_hash
	arg_3_0._power_level_timer = 0
	arg_3_0.party_owned_dlcs = {}
	arg_3_0._level_weights = {}
	arg_3_0.peers_to_sync = {}

	local var_3_0 = LobbySetup.network_options()

	if not DEDICATED_SERVER then
		local var_3_1 = LobbyFinder:new(var_3_0, MatchmakingSettings.MAX_NUM_LOBBIES, true)

		arg_3_0.lobby_finder = var_3_1
		arg_3_1.lobby_finder = var_3_1
	end

	arg_3_1.network_options = var_3_0
	arg_3_1.matchmaking_manager = arg_3_0
	arg_3_1.network_hash = arg_3_0.lobby.network_hash
	arg_3_0.state_context = {}
	arg_3_0.debug = {
		text = "",
		progression = "",
		lobby_timer = 0,
		state = "",
		hero = "",
		difficulty = "",
		level = ""
	}

	if not arg_3_0.is_server then
		arg_3_0._joining_this_host_peer_id = arg_3_0.lobby:lobby_host()

		arg_3_0:_change_state(MatchmakingStateIdle, arg_3_0.params, {})

		local var_3_2 = Managers.mechanism:network_handler():get_network_state()

		var_3_2:register_callback("server_data_updated", arg_3_0, "on_client_game_mode_event_data_updated", "game_mode_event_data")

		local var_3_3 = var_3_2:get_game_mode_event_data()

		if not table.is_empty(var_3_3) then
			arg_3_0:set_game_mode_event_data(var_3_3)
		else
			arg_3_0:clear_game_mode_event_data()
		end
	else
		arg_3_0:_change_state(MatchmakingStateIdle, arg_3_0.params, {})
	end

	arg_3_0:reset_lobby_filters()
	mm_printf("initializing")
	mm_printf("my_peer_id: %s, I am %s", Network.peer_id(), arg_3_0.is_server and "server" or "client")

	arg_3_0.lobby_finder_timer = 0
	arg_3_0.profile_update_time = 0
	arg_3_0._leader_peer_id = nil
	arg_3_0.countdown_has_finished = false

	if arg_3_1.game_mode_event_data then
		arg_3_0:set_game_mode_event_data(arg_3_1.game_mode_event_data)
	end
end

MatchmakingManager.reset_lobby_filters = function (arg_4_0)
	if DEDICATED_SERVER then
		return
	end

	if IS_WINDOWS then
		local var_4_0 = arg_4_0.lobby_finder:get_lobby_browser()

		LobbyInternal.clear_filter_requirements(var_4_0)
	else
		LobbyInternal.clear_filter_requirements()
	end
end

MatchmakingManager.game_mode_event_data = function (arg_5_0)
	return arg_5_0._game_mode_event_data
end

MatchmakingManager.have_game_mode_event_data = function (arg_6_0)
	return arg_6_0._game_mode_event_data and not table.is_empty(arg_6_0._game_mode_event_data)
end

MatchmakingManager.set_game_mode_event_data = function (arg_7_0, arg_7_1)
	arg_7_0._game_mode_event_data = arg_7_1

	if arg_7_0.is_server then
		local var_7_0 = arg_7_1.mutators

		fassert(#var_7_0 <= NetworkConstants.mutator_array.max_size, "Too many mutators defined for event! (%d|%d)", #var_7_0, NetworkConstants.mutator_array.max_size)
		arg_7_0.network_server:get_network_state():set_game_mode_event_data(arg_7_1)
	end
end

MatchmakingManager.clear_game_mode_event_data = function (arg_8_0)
	arg_8_0._game_mode_event_data = nil

	if arg_8_0.is_server then
		arg_8_0.network_server:get_network_state():set_game_mode_event_data({})
	end
end

MatchmakingManager.on_client_game_mode_event_data_updated = function (arg_9_0, arg_9_1, arg_9_2, arg_9_3, arg_9_4, arg_9_5, arg_9_6, arg_9_7)
	if not table.is_empty(arg_9_7) then
		arg_9_0:set_game_mode_event_data(arg_9_7)
	else
		arg_9_0:clear_game_mode_event_data()
	end
end

MatchmakingManager.set_statistics_db = function (arg_10_0, arg_10_1)
	arg_10_0.statistics_db = arg_10_1
	arg_10_0.params.statistics_db = arg_10_1
end

MatchmakingManager.set_active_lobby_browser = function (arg_11_0, arg_11_1)
	arg_11_0._lobby_browser = arg_11_1
end

MatchmakingManager.setup_post_init_data = function (arg_12_0, arg_12_1)
	arg_12_0.is_in_inn = arg_12_1.is_in_inn
	arg_12_0.difficulty_manager = arg_12_1.difficulty
	arg_12_0.params.hero_spawner_handler = arg_12_1.hero_spawner_handler
	arg_12_0.params.difficulty = arg_12_1.difficulty
	arg_12_0.params.wwise_world = arg_12_1.wwise_world

	local var_12_0 = arg_12_0.is_server

	if arg_12_1.reset_matchmaking and var_12_0 then
		arg_12_0:cancel_matchmaking()
	end

	if var_12_0 then
		if arg_12_0.lobby:lobby_data("matchmaking") == "true" then
			arg_12_0:_change_state(MatchmakingStateIngame, arg_12_0.params, {})
		else
			arg_12_0:_change_state(MatchmakingStateIdle, arg_12_0.params, {})
		end
	end

	local var_12_1 = SaveData.map_save_data

	if var_12_1 then
		MatchmakingSettings.host_games = var_12_1.host_option
		MatchmakingSettings.auto_ready = var_12_1.selected_ready_option
	end

	arg_12_0.profile_update_time = 0
	arg_12_0._power_level_timer = 0

	arg_12_0:_update_power_level(0)
end

MatchmakingManager.waystone_is_active = function (arg_13_0)
	return arg_13_0._waystone_is_active or false, arg_13_0._waystone_type or 0
end

MatchmakingManager.activate_waystone_portal = function (arg_14_0, arg_14_1)
	arg_14_0._waystone_is_active = arg_14_1 ~= nil
	arg_14_0._waystone_type = arg_14_1

	local var_14_0 = Managers.state.event

	if var_14_0 then
		var_14_0:trigger("activate_waystone_portal", arg_14_1)
	end
end

MatchmakingManager.destroy = function (arg_15_0)
	mm_printf("destroying")
	arg_15_0:_terminate_dangling_matchmaking_lobbies()

	if arg_15_0._state and arg_15_0._state.on_exit then
		arg_15_0._state:on_exit()
	end

	if arg_15_0.lobby_finder then
		arg_15_0.lobby_finder:destroy()
	end

	if arg_15_0.afk_popup_id then
		Managers.popup:cancel_popup(arg_15_0.afk_popup_id)

		arg_15_0.afk_popup_id = nil
	end
end

MatchmakingManager.register_rpcs = function (arg_16_0, arg_16_1)
	mm_printf("register rpcs")
	fassert(arg_16_0.network_event_delegate == nil, "trying to register rpcs without a network_event_delegate..")

	arg_16_0.network_event_delegate = arg_16_1
	arg_16_0.params.network_event_delegate = arg_16_1

	arg_16_1:register(arg_16_0, unpack(var_0_4))
end

MatchmakingManager.unregister_rpcs = function (arg_17_0)
	mm_printf("unregister rpcs")
	fassert(arg_17_0.network_event_delegate ~= nil, "trying to unregister rpcs without a network_event_delegate..")
	arg_17_0.network_event_delegate:unregister(arg_17_0)

	arg_17_0.params.network_event_delegate = nil
	arg_17_0.network_event_delegate = nil
end

MatchmakingManager._change_state = function (arg_18_0, arg_18_1, arg_18_2, arg_18_3, arg_18_4)
	if arg_18_0._state and arg_18_0._state.NAME == arg_18_1.NAME then
		mm_printf("Ignoring state transision %s because we are already there", arg_18_1.NAME)

		return
	end

	if arg_18_0._state then
		if arg_18_0._state.on_exit then
			mm_printf("Exiting state %s with on_exit()", arg_18_0._state.NAME)
			arg_18_0._state:on_exit(arg_18_0._state.NAME)
		else
			mm_printf("Exiting %s", arg_18_0._state.NAME)
		end
	end

	arg_18_0._state = arg_18_1:new(arg_18_2, arg_18_4)
	arg_18_0._state.parent = arg_18_0._parent
	arg_18_0.state_context = arg_18_3

	if arg_18_0._state.on_enter then
		mm_printf("Entering %s on_enter() ", arg_18_1.NAME)
		arg_18_0._state:on_enter(arg_18_3)
	else
		mm_printf("Entering %s", arg_18_1.NAME)
	end
end

MatchmakingManager._remove_old_broken_lobbies = function (arg_19_0, arg_19_1)
	local var_19_0 = MatchmakingManager._broken_lobbies

	for iter_19_0, iter_19_1 in pairs(var_19_0) do
		if iter_19_1 < arg_19_1 then
			mm_printf("Removing broken lobby %s, perhaps it will now work again?!", tostring(iter_19_0))

			var_19_0[iter_19_0] = nil
		end
	end

	local var_19_1 = MatchmakingManager._broken_servers

	for iter_19_2, iter_19_3 in pairs(var_19_1) do
		if iter_19_3 < arg_19_1 then
			mm_printf("Removing broken server %s, perhaps it will now work again?!", iter_19_2)

			var_19_1[iter_19_2] = nil
		end
	end
end

MatchmakingManager.update = function (arg_20_0, arg_20_1, arg_20_2)
	if arg_20_0._state then
		local var_20_0 = arg_20_0._state.NAME
		local var_20_1, var_20_2, var_20_3 = arg_20_0._state:update(arg_20_1, arg_20_2)

		if var_20_1 then
			arg_20_0:_change_state(var_20_1, arg_20_0.params, var_20_2, var_20_3)
		end
	end

	arg_20_0:_update_power_level(arg_20_2)
	arg_20_0:_update_afk_logic(arg_20_1, arg_20_2)
	arg_20_0:_remove_old_broken_lobbies(arg_20_2)

	if arg_20_0.is_server and next(arg_20_0.peers_to_sync) then
		local var_20_4, var_20_5 = arg_20_0:is_game_matchmaking()
		local var_20_6 = arg_20_0:search_info()
		local var_20_7 = var_20_6.mission_id
		local var_20_8 = var_20_6.difficulty
		local var_20_9 = var_20_6.quick_game or false
		local var_20_10 = var_20_6.mechanism
		local var_20_11 = var_20_7 and NetworkLookup.mission_ids[var_20_7] or NetworkLookup.mission_ids["n/a"]
		local var_20_12 = var_20_8 and NetworkLookup.difficulties[var_20_8] or NetworkLookup.difficulties.normal
		local var_20_13 = var_20_10 and NetworkLookup.mechanisms[var_20_10] or NetworkLookup.mechanisms.adventure

		for iter_20_0, iter_20_1 in pairs(arg_20_0.peers_to_sync) do
			arg_20_0.peers_to_sync[iter_20_0] = nil

			local var_20_14 = PEER_ID_TO_CHANNEL[iter_20_0]

			RPC.rpc_set_matchmaking(var_20_14, var_20_4, var_20_5, var_20_11, var_20_12, var_20_9, var_20_13)
		end
	end

	if not DEDICATED_SERVER and arg_20_0._joining_this_host_peer_id and PEER_ID_TO_CHANNEL[arg_20_0._joining_this_host_peer_id] == nil then
		print("No connection to host, cancelling matchmaking")
		arg_20_0:cancel_matchmaking()
	end

	if script_data.testify then
		Testify:poll_requests_through_handler(var_0_1, arg_20_0)
	end

	arg_20_0.t = arg_20_2
end

MatchmakingManager._update_afk_logic = function (arg_21_0, arg_21_1, arg_21_2)
	local var_21_0 = arg_21_0.lobby

	if arg_21_0.is_server and var_21_0:is_joined() then
		local var_21_1 = arg_21_0._state and arg_21_0._state.NAME

		if (var_21_1 == "MatchmakingStateHostGame" or var_21_1 == "MatchmakingStateSearchGame") and arg_21_0.is_in_inn then
			local var_21_2 = arg_21_2 - Managers.input.last_active_time
			local var_21_3 = var_21_2 > MatchmakingSettings.afk_warn_timer
			local var_21_4 = var_21_2 > MatchmakingSettings.afk_force_stop_mm_timer
			local var_21_5 = _G.Window ~= nil and Window.flash_window ~= nil and not Window.has_focus()

			if var_21_3 and arg_21_0.afk_popup_id == nil then
				arg_21_0.afk_popup_id = Managers.popup:queue_popup(Localize("popup_afk_warning"), Localize("popup_error_topic"), "ok", Localize("button_ok"))

				if var_21_5 then
					Window.flash_window(nil, "start", 5)
				end

				arg_21_0:send_system_chat_message("popup_afk_warning")
			elseif var_21_4 then
				if arg_21_0.afk_popup_id then
					Managers.popup:cancel_popup(arg_21_0.afk_popup_id)
				end

				arg_21_0.afk_popup_id = Managers.popup:queue_popup(Localize("popup_afk_mm_cancelled"), Localize("popup_error_topic"), "ok", Localize("button_ok"))

				if var_21_5 then
					Window.flash_window(nil, "start", 1)
				end

				arg_21_0:send_system_chat_message("popup_afk_mm_cancelled")
				arg_21_0:cancel_matchmaking()
			end
		end

		if arg_21_0.afk_popup_id and Managers.popup:query_result(arg_21_0.afk_popup_id) then
			arg_21_0.afk_popup_id = nil
		end
	end
end

local var_0_6 = {}

MatchmakingManager._update_power_level = function (arg_22_0, arg_22_1)
	if arg_22_1 < arg_22_0._power_level_timer then
		return
	end

	arg_22_0._power_level_timer = arg_22_1 + 5

	local var_22_0 = Network.peer_id()
	local var_22_1 = arg_22_0.is_server
	local var_22_2 = Managers.player:local_player()

	if var_22_2 then
		local var_22_3 = var_22_2:sync_data_active()
		local var_22_4 = var_22_2:profile_display_name()
		local var_22_5 = var_22_2:career_name()
		local var_22_6 = arg_22_0.lobby:lobby_data("matchmaking_type")
		local var_22_7 = var_22_6 and (IS_PS4 and var_22_6 or NetworkLookup.matchmaking_types[tonumber(var_22_6)])

		if var_22_3 and var_22_4 and var_22_5 then
			local var_22_8 = BackendUtils.get_total_power_level(var_22_4, var_22_5, var_22_7)

			if var_22_8 ~= var_22_2:get_data("power_level") then
				var_22_2:set_data("power_level", var_22_8)
			end

			local var_22_9 = var_22_2:best_aquired_power_level()

			if var_22_9 ~= var_22_2:get_data("best_aquired_power_level") then
				var_22_2:set_data("best_aquired_power_level", var_22_9)
				var_22_2:reevaluate_highest_difficulty()
			end
		end
	end

	if var_22_1 then
		arg_22_0:_set_power_level()
	end
end

MatchmakingManager.get_average_power_level = function (arg_23_0)
	local var_23_0 = 0
	local var_23_1 = 0
	local var_23_2 = Managers.player:human_players()

	for iter_23_0, iter_23_1 in pairs(var_23_2) do
		if iter_23_1:sync_data_active() then
			local var_23_3 = iter_23_1:get_data("power_level")

			if var_23_3 then
				var_23_0 = var_23_0 + var_23_3
				var_23_1 = var_23_1 + 1
			end
		end
	end

	if var_23_1 == 0 then
		return 0
	end

	return math.floor(var_23_0 / var_23_1)
end

MatchmakingManager.get_average_weave_progression = function (arg_24_0)
	return 1
end

MatchmakingManager.has_required_power_level = function (arg_25_0, arg_25_1, arg_25_2, arg_25_3)
	local var_25_0 = arg_25_1.difficulty

	if not var_25_0 then
		return false
	end

	local var_25_1 = DifficultySettings[var_25_0]

	if not var_25_1 then
		return false
	end

	if BackendUtils.get_total_power_level(arg_25_2, arg_25_3) < var_25_1.required_power_level then
		return false
	end

	return true
end

MatchmakingManager._set_power_level = function (arg_26_0)
	fassert(arg_26_0.is_server, "You need to be the server.")

	local var_26_0 = arg_26_0:get_average_power_level()
	local var_26_1 = arg_26_0.lobby:get_stored_lobby_data()

	if var_26_0 ~= var_26_1.power_level then
		var_26_1.power_level = var_26_0

		arg_26_0.lobby:set_lobby_data(var_26_1)
	end
end

MatchmakingManager.state = function (arg_27_0)
	return arg_27_0._state
end

MatchmakingManager.gather_party_unlocked_journeys = function (arg_28_0)
	local var_28_0 = {}
	local var_28_1 = Managers.player:players()

	for iter_28_0, iter_28_1 in pairs(var_28_1) do
		var_28_0[iter_28_0] = {}
		var_28_0[iter_28_0] = LevelUnlockUtils.unlocked_journeys(arg_28_0.statistics_db, iter_28_0)
	end

	local var_28_2 = {}

	for iter_28_2, iter_28_3 in ipairs(AvailableJourneyOrder) do
		local var_28_3 = true

		for iter_28_4, iter_28_5 in pairs(var_28_0) do
			if not table.find(iter_28_5, iter_28_3) then
				var_28_3 = false
			end
		end

		if var_28_3 then
			var_28_2[#var_28_2 + 1] = iter_28_3
		end
	end

	return var_28_2
end

MatchmakingManager.party_has_level_unlocked = function (arg_29_0, arg_29_1, arg_29_2, arg_29_3, arg_29_4)
	local var_29_0 = LevelSettings[arg_29_1]
	local var_29_1 = Managers.player:human_players()
	local var_29_2 = arg_29_0.statistics_db
	local var_29_3 = arg_29_0._level_weights
	local var_29_4 = false

	for iter_29_0, iter_29_1 in pairs(var_29_1) do
		local var_29_5 = iter_29_1:stats_id()

		if arg_29_3 and var_29_0.dlc_name then
			return false
		end

		if not var_29_0.dlc_name then
			if not LevelUnlockUtils.level_unlocked(var_29_2, var_29_5, arg_29_1, true) and not arg_29_4 or var_29_0.not_quickplayable then
				return false
			end
		elseif not LevelUnlockUtils.level_unlocked(var_29_2, var_29_5, arg_29_1, true) or var_29_0.not_quickplayable then
			return false
		end

		if not arg_29_2 then
			if var_29_0.dlc_name then
				local var_29_6 = iter_29_1.peer_id

				if var_29_3[var_29_6] and var_29_3[var_29_6][arg_29_1] then
					var_29_4 = true
				end
			else
				var_29_4 = true
			end
		end
	end

	if not arg_29_2 then
		return var_29_4
	end

	return true
end

MatchmakingManager._get_unlocked_levels_by_party = function (arg_30_0, arg_30_1, arg_30_2, arg_30_3, arg_30_4)
	local var_30_0 = {}

	arg_30_4 = arg_30_4 or {}

	local var_30_1 = UnlockableLevelsByGameMode.adventure

	for iter_30_0, iter_30_1 in ipairs(var_30_1) do
		if arg_30_0:party_has_level_unlocked(iter_30_1, arg_30_1, arg_30_2, arg_30_3) and not table.contains(arg_30_4, iter_30_1) then
			var_30_0[#var_30_0 + 1] = iter_30_1
		end
	end

	return var_30_0
end

MatchmakingManager._get_unlocked_levels = function (arg_31_0, arg_31_1)
	local var_31_0 = {}
	local var_31_1 = arg_31_0.statistics_db
	local var_31_2 = Managers.player:local_player()
	local var_31_3 = UnlockableLevelsByGameMode.adventure

	for iter_31_0, iter_31_1 in ipairs(var_31_3) do
		local var_31_4 = var_31_2:stats_id()

		if LevelUnlockUtils.level_unlocked(var_31_1, var_31_4, iter_31_1) then
			var_31_0[#var_31_0 + 1] = iter_31_1
		end
	end

	return var_31_0
end

MatchmakingManager._get_level_key_from_level_weights = function (arg_32_0, arg_32_1, arg_32_2)
	fassert(#arg_32_1 > 0, "Empty level_keys list")

	local var_32_0 = arg_32_0._level_weights
	local var_32_1 = {}
	local var_32_2 = 0

	for iter_32_0, iter_32_1 in pairs(var_32_0) do
		var_32_2 = var_32_2 + 1
	end

	for iter_32_2 = 1, #arg_32_1 do
		var_32_1[iter_32_2] = 0

		local var_32_3 = arg_32_1[iter_32_2]

		for iter_32_3, iter_32_4 in pairs(var_32_0) do
			if iter_32_4[var_32_3] then
				var_32_1[iter_32_2] = var_32_1[iter_32_2] + iter_32_4[var_32_3]
			end
		end

		var_32_1[iter_32_2] = var_32_1[iter_32_2] / var_32_2
	end

	local var_32_4, var_32_5 = LoadedDice.create(var_32_1, false)
	local var_32_6 = LoadedDice.roll(var_32_4, var_32_5)
	local var_32_7 = {}

	for iter_32_5 = 1, #var_32_1 do
		local var_32_8 = 1

		for iter_32_6 = 1, #var_32_1 do
			if var_32_1[iter_32_6] > var_32_1[var_32_8] then
				var_32_8 = iter_32_6
			end
		end

		local var_32_9 = arg_32_1[var_32_8]

		if var_32_9 and var_32_1[var_32_8] >= 0 or arg_32_2 then
			var_32_7[#var_32_7 + 1] = var_32_9
		end

		var_32_1[var_32_8] = -1
	end

	local var_32_10 = Managers.mechanism:game_mechanism():get_hub_level_key()

	var_32_7[#var_32_7 + 1] = var_32_10

	return arg_32_1[var_32_6], var_32_7
end

MatchmakingManager._calculate_level_weights = function (arg_33_0, arg_33_1, arg_33_2)
	fassert(#arg_33_1 > 0, "Empty level_keys list")

	local var_33_0 = MatchmakingSettings.quickplay_level_select_settings
	local var_33_1 = Managers.player:local_player()
	local var_33_2 = arg_33_0.statistics_db
	local var_33_3 = NetworkLookup.unlockable_level_keys
	local var_33_4 = var_33_1:stats_id()
	local var_33_5 = arg_33_2 or {}
	local var_33_6 = {}

	for iter_33_0 = 1, #NetworkLookup.unlockable_level_keys do
		var_33_6[iter_33_0] = -1
	end

	for iter_33_1 = 1, #arg_33_1 do
		local var_33_7 = arg_33_1[iter_33_1]
		local var_33_8 = var_33_3[var_33_7]
		local var_33_9

		var_33_6[var_33_8], var_33_9 = var_33_0.base_level_weight, var_33_0.progression_multiplier

		local var_33_10 = LevelUnlockUtils.completed_level_difficulty_index(var_33_2, var_33_4, var_33_7)

		if not var_33_10 or var_33_10 == 0 then
			var_33_6[var_33_8] = var_33_6[var_33_8] * var_33_9
		end
	end

	local function var_33_11(arg_34_0, arg_34_1)
		return arg_34_0.timestamp > arg_34_1.timestamp
	end

	table.sort(var_33_5, var_33_11)

	local var_33_12 = var_33_0.amount_of_relevant_games

	while var_33_12 < #var_33_5 do
		var_33_5[#var_33_5] = nil
	end

	local var_33_13 = var_33_0.win_multiplier
	local var_33_14 = var_33_0.loss_multiplier

	for iter_33_2 = 1, #var_33_5 do
		local var_33_15 = var_33_5[iter_33_2].level_name

		if var_33_15 and table.contains(var_33_3, var_33_15) then
			local var_33_16 = var_33_3[var_33_15]

			if var_33_16 then
				local var_33_17 = var_33_5[iter_33_2].game_won and var_33_13 or var_33_14

				var_33_6[var_33_16] = var_33_6[var_33_16] - var_33_17 * (#var_33_5 - iter_33_2 + 1) / #var_33_5

				if var_33_6[var_33_16] < 0 then
					var_33_6[var_33_16] = 0
				end
			end
		end
	end

	return var_33_6
end

MatchmakingManager._add_level_weight = function (arg_35_0, arg_35_1, arg_35_2)
	local var_35_0 = arg_35_0._level_weights
	local var_35_1 = {}
	local var_35_2 = NetworkLookup.unlockable_level_keys

	for iter_35_0, iter_35_1 in pairs(arg_35_2) do
		if iter_35_1 ~= -1 then
			var_35_1[var_35_2[iter_35_0]] = iter_35_1
		end
	end

	var_35_0[arg_35_1] = var_35_1
end

MatchmakingManager._remove_irrelevant_level_weights = function (arg_36_0)
	local var_36_0 = arg_36_0._level_weights
	local var_36_1 = Managers.player:human_players()

	for iter_36_0, iter_36_1 in pairs(var_36_0) do
		local var_36_2 = false

		for iter_36_2, iter_36_3 in pairs(var_36_1) do
			if iter_36_0 == iter_36_3.peer_id then
				var_36_2 = true

				break
			end
		end

		if not var_36_2 then
			var_36_0[iter_36_0] = nil
		end
	end

	arg_36_0._level_weights = var_36_0
end

MatchmakingManager.get_weighed_random_unlocked_level = function (arg_37_0, arg_37_1, arg_37_2, arg_37_3)
	local var_37_0 = Managers.backend:get_read_only_data("recent_quickplay_games")
	local var_37_1 = var_37_0 and cjson.decode(var_37_0) or {}
	local var_37_2 = arg_37_0.state_context.search_config.game_mode == "event"

	if not DEDICATED_SERVER then
		local var_37_3 = arg_37_0:_get_unlocked_levels()
		local var_37_4 = arg_37_0:_calculate_level_weights(var_37_3, var_37_1)
		local var_37_5 = Managers.player:local_player().peer_id

		arg_37_0:_add_level_weight(var_37_5, var_37_4)
	end

	arg_37_0:_remove_irrelevant_level_weights()

	local var_37_6 = true

	if not script_data.settings.use_beta_mode then
		var_37_6 = not arg_37_0:_party_has_completed_act("act_4")

		if arg_37_2 then
			var_37_6 = false
		end
	end

	local var_37_7 = arg_37_0:_get_unlocked_levels_by_party(arg_37_1, var_37_6, var_37_2, arg_37_3)
	local var_37_8, var_37_9 = arg_37_0:_get_level_key_from_level_weights(var_37_7, var_37_2)

	return var_37_8, var_37_9
end

MatchmakingManager._party_has_completed_act = function (arg_38_0, arg_38_1)
	local var_38_0 = Managers.player:human_players()
	local var_38_1 = arg_38_0.statistics_db

	for iter_38_0, iter_38_1 in pairs(var_38_0) do
		local var_38_2 = iter_38_1:stats_id()

		if not LevelUnlockUtils.act_completed(var_38_1, var_38_2, arg_38_1) then
			return false
		end
	end

	return true
end

MatchmakingManager.set_matchmaking_data = function (arg_39_0, arg_39_1, arg_39_2, arg_39_3, arg_39_4, arg_39_5, arg_39_6, arg_39_7, arg_39_8, arg_39_9)
	local var_39_0 = Managers.level_transition_handler:get_current_level_keys()
	local var_39_1 = #arg_39_0.lobby:members():get_members()
	local var_39_2 = not arg_39_5
	local var_39_3 = arg_39_0.lobby:get_stored_lobby_data()

	var_39_3.mission_id = var_39_0
	var_39_3.matchmaking_type = not IS_PS4 and NetworkLookup.matchmaking_types[arg_39_4] or arg_39_4
	var_39_3.act_key = arg_39_3
	var_39_3.matchmaking = var_39_2 and "true" or "false"
	var_39_3.selected_mission_id = arg_39_1 or LevelHelper:current_level_settings().level_id
	var_39_3.unique_server_name = LobbyAux.get_unique_server_name()
	var_39_3.custom_server_name = "n/a"
	var_39_3.host = Network.peer_id()
	var_39_3.num_players = var_39_1
	var_39_3.difficulty = arg_39_2
	var_39_3.weave_quick_game = arg_39_9 == "weave" and arg_39_6 and "true" or "false"
	var_39_3.country_code = Managers.account:region()
	var_39_3.twitch_enabled = GameSettingsDevelopment.twitch_enabled and Managers.twitch:is_connected() and Managers.twitch:game_mode_supported(arg_39_4, arg_39_2) and "true" or "false"
	var_39_3.eac_authorized = arg_39_7 and "true" or "false"
	var_39_3.mechanism = arg_39_9
	var_39_3.match_started = "true"

	print("[MATCHMAKING] - Hosting game on mission:", var_39_0, arg_39_1, arg_39_8)
	arg_39_0.lobby:set_lobby_data(var_39_3)
end

MatchmakingManager.on_dedicated_server = function (arg_40_0)
	return arg_40_0.lobby:is_dedicated_server()
end

MatchmakingManager.weave_vote_result = function (arg_41_0, arg_41_1)
	if arg_41_0._state.NAME == "MatchmakingStateSearchForWeaveGroup" then
		arg_41_0._state:weave_vote_result(arg_41_1)
	elseif IS_XB1 and arg_41_0._state.NAME == "MatchmakingStateRequestJoinGame" then
		arg_41_0._state:weave_vote_result(arg_41_1)
	else
		arg_41_0:cancel_matchmaking()
	end
end

MatchmakingManager.find_game = function (arg_42_0, arg_42_1)
	if arg_42_0.is_server then
		local var_42_0 = arg_42_1.dedicated_server

		fassert(var_42_0 ~= nil, "Dedicated server game wasn't set!")

		arg_42_0.state_context = {}
		arg_42_0.state_context.search_config = table.clone(arg_42_1)
		arg_42_0.state_context.started_matchmaking_t = Managers.time:time("main")

		local var_42_1 = arg_42_1.private_game

		fassert(var_42_1 ~= nil, "Private game wasn't set!")

		local var_42_2 = arg_42_1.quick_game

		fassert(var_42_2 ~= nil, "Quick game wasn't set!")

		local var_42_3 = arg_42_1.join_method

		if var_42_3 == "party" then
			fassert(arg_42_1.party_lobby_host ~= nil, "Missing party lobby for party join")
		end

		local var_42_4

		if var_42_0 then
			if var_42_3 == "party" then
				fassert(arg_42_1.wait_for_join_message ~= nil, "Missing wait_for_join_message for dedicated server party join.")

				if arg_42_1.aws then
					var_42_4 = MatchmakingStateFlexmatchHost
				else
					var_42_4 = MatchmakingStateReserveLobby
				end
			else
				fassert(false, "Join method %s not implemented", var_42_3)
			end
		else
			local var_42_5 = arg_42_0.network_server:num_active_peers() > 1
			local var_42_6 = arg_42_1.always_host

			if var_42_1 or var_42_5 or var_42_6 or var_0_3 then
				if var_42_2 and IS_XB1 then
					local var_42_7 = false

					if Managers.account:offline_mode() then
						var_42_7 = false
					end

					local var_42_8 = arg_42_1.excluded_level_keys

					arg_42_0.state_context.search_config.mission_id = arg_42_0:get_weighed_random_unlocked_level(var_42_7, false, var_42_8)
				end

				if arg_42_1.matchmaking_start_state then
					var_42_4 = rawget(_G, arg_42_1.matchmaking_start_state)
				else
					var_42_4 = MatchmakingStateHostGame
				end
			elseif arg_42_1.matchmaking_start_state then
				var_42_4 = rawget(_G, arg_42_1.matchmaking_start_state)
			else
				var_42_4 = MatchmakingStateSearchGame
			end
		end

		local var_42_9 = arg_42_0:search_info()
		local var_42_10 = var_42_9.mission_id
		local var_42_11 = var_42_9.difficulty
		local var_42_12 = var_42_9.quick_game
		local var_42_13 = var_42_9.mechanism
		local var_42_14 = var_42_10 and NetworkLookup.mission_ids[var_42_10] or NetworkLookup.mission_ids["n/a"]
		local var_42_15 = var_42_11 and NetworkLookup.difficulties[var_42_11] or NetworkLookup.difficulties.normal
		local var_42_16 = var_42_13 and NetworkLookup.mechanisms[var_42_13] or NetworkLookup.mechanisms.adventure

		arg_42_0.network_transmit:send_rpc_clients("rpc_set_matchmaking", true, var_42_1, var_42_14, var_42_15, var_42_12, var_42_16)
		arg_42_0:_change_state(var_42_4, arg_42_0.params, arg_42_0.state_context)

		arg_42_0.start_matchmaking_time = 1000000

		Managers.venture.quickplay:set_has_pending_quick_game(var_42_12)
	end
end

MatchmakingManager._terminate_dangling_matchmaking_lobbies = function (arg_43_0)
	if Managers.lobby:query_lobby("matchmaking_join_lobby") then
		Managers.lobby:destroy_lobby("matchmaking_join_lobby")
	end
end

MatchmakingManager.cancel_matchmaking = function (arg_44_0)
	mm_printf("Cancelling matchmaking")

	if not arg_44_0:is_game_matchmaking() then
		if not arg_44_0.is_server and not arg_44_0.lobby:is_dedicated_server() then
			arg_44_0._joining_this_host_peer_id = nil
		end

		mm_printf("Wasn't really matchmaking to begin with...")

		return
	end

	local var_44_0 = Managers.party

	if not arg_44_0.is_server and arg_44_0.lobby:is_dedicated_server() then
		if var_44_0:is_leader(arg_44_0.peer_id) then
			arg_44_0.network_transmit:send_rpc_server("rpc_cancel_matchmaking")
		end

		return
	end

	if IS_WINDOWS or IS_LINUX then
		local var_44_1 = Managers.player:local_player(1)
		local var_44_2 = "cancelled"
		local var_44_3 = arg_44_0.state_context.started_matchmaking_t

		if var_44_3 ~= nil then
			local var_44_4 = (Managers.time:time("main") or var_44_3) - var_44_3
			local var_44_5 = arg_44_0.state_context.search_config.strict_matchmaking

			Managers.telemetry_events:matchmaking_cancelled(var_44_1, var_44_4, arg_44_0.state_context.search_config)
		end
	end

	arg_44_0.state_context = {}

	if arg_44_0._state then
		if arg_44_0._state.terminate then
			arg_44_0._state:terminate()
		end

		arg_44_0:_terminate_dangling_matchmaking_lobbies()

		if arg_44_0._state.lobby_client then
			arg_44_0._state.lobby_client:destroy()

			arg_44_0._state.lobby_client = nil
		end

		if arg_44_0._state._lobby_unclaimed then
			arg_44_0._state._lobby_unclaimed:destroy()

			arg_44_0._state._lobby_unclaimed = nil
		end

		local var_44_6 = Managers.ui

		if var_44_6:get_active_popup("profile_picker") then
			var_44_6:close_popup("profile_picker")
		end

		local var_44_7 = Managers.mechanism:game_mechanism()

		if var_44_7.is_hosting_versus_custom_game and var_44_7:is_hosting_versus_custom_game() then
			var_44_7:set_is_hosting_versus_custom_game(false)
		end

		arg_44_0:_change_state(MatchmakingStateIdle, arg_44_0.params, arg_44_0.state_context, "cancel_matchmaking")
	end

	if arg_44_0.is_server then
		local var_44_8 = arg_44_0.lobby:get_stored_lobby_data()

		var_44_8.matchmaking = "false"
		var_44_8.difficulty = "normal"
		var_44_8.selected_mission_id = LevelHelper:current_level_settings().level_id
		var_44_8.custom_game_settings = "n/a"
		var_44_8.custom_server_name = "n/a"
		var_44_8.matchmaking_type = not IS_PS4 and NetworkLookup.matchmaking_types["n/a"] or "n/a"

		arg_44_0.lobby:set_lobby_data(var_44_8)

		local var_44_9 = NetworkLookup.mission_ids["n/a"]
		local var_44_10 = NetworkLookup.difficulties.normal
		local var_44_11 = NetworkLookup.mechanisms.adventure
		local var_44_12 = false

		Managers.state.difficulty:set_difficulty("normal", 0)

		if IS_XB1 then
			arg_44_0.lobby:enable_matchmaking(false)
		end

		arg_44_0.network_transmit:send_rpc_clients("rpc_set_matchmaking", false, false, var_44_9, var_44_10, var_44_12, var_44_11)
		arg_44_0:reset_lobby_filters()

		if not DEDICATED_SERVER then
			var_44_0:set_leader(arg_44_0.network_server.lobby_host:lobby_host())
		end

		Managers.level_transition_handler:clear_next_level()

		local var_44_13 = Managers.mechanism:network_handler()
		local var_44_14 = var_44_13 and var_44_13:get_match_handler()

		if var_44_14 then
			var_44_14:send_rpc_down("rpc_cancel_matchmaking")
		end

		if Managers.venture.quickplay then
			Managers.venture.quickplay:set_has_pending_quick_game(false)
		end
	else
		var_44_0:set_leader(nil)
	end

	arg_44_0._joining_this_host_peer_id = nil
end

MatchmakingManager.force_start_game = function (arg_45_0)
	arg_45_0:_try_call_state_method("force_start_game")
end

MatchmakingManager.set_selected_level = function (arg_46_0, arg_46_1)
	assert(arg_46_0.is_server)

	local var_46_0 = arg_46_0.lobby:get_stored_lobby_data()

	var_46_0.selected_mission_id = arg_46_1

	arg_46_0.lobby:set_lobby_data(var_46_0)

	local var_46_1 = arg_46_0.state_context.search_config

	if var_46_1 then
		var_46_1.mission_id = arg_46_1
	end
end

MatchmakingManager.get_selected_level = function (arg_47_0)
	return arg_47_0.lobby:get_stored_lobby_data().selected_mission_id
end

MatchmakingManager.is_player_hosting = function (arg_48_0)
	local var_48_0 = arg_48_0.state_context
	local var_48_1 = var_48_0 and var_48_0.search_config

	return var_48_1 and var_48_1.is_player_hosted
end

MatchmakingManager.is_matchmaking_versus = function (arg_49_0)
	local var_49_0 = arg_49_0.lobby and arg_49_0.lobby:lobby_data("mechanism")
	local var_49_1 = arg_49_0._state.lobby_client or Managers.lobby:query_lobby("matchmaking_session_lobby") or Managers.lobby:query_lobby("matchmaking_join_lobby")
	local var_49_2 = var_49_1 and var_49_1:lobby_data("mechanism")
	local var_49_3 = arg_49_0._state.NAME ~= "MatchmakingStateIdle"
	local var_49_4 = arg_49_0.lobby and arg_49_0.lobby:lobby_data("matchmaking") == "true"
	local var_49_5 = var_49_1 and var_49_1:lobby_data("matchmaking") == "true"

	return (var_49_3 or var_49_4 or var_49_5) and (var_49_0 == "versus" or var_49_2 == "versus")
end

MatchmakingManager.is_matchmaking_in_inn = function (arg_50_0)
	local var_50_0 = arg_50_0._state.NAME
	local var_50_1 = var_50_0 ~= "MatchmakingStateIdle"

	return arg_50_0.is_in_inn and var_50_1, var_50_0
end

MatchmakingManager.is_game_matchmaking = function (arg_51_0)
	local var_51_0 = arg_51_0._state.NAME ~= "MatchmakingStateIdle"
	local var_51_1 = arg_51_0.state_context and arg_51_0.state_context.search_config
	local var_51_2 = var_51_1 and var_51_1.private_game or false
	local var_51_3 = arg_51_0._state.reason

	return var_51_0, var_51_2, var_51_3
end

MatchmakingManager.active_game_mode = function (arg_52_0)
	local var_52_0 = arg_52_0._state.NAME ~= "MatchmakingStateIdle" and arg_52_0.lobby:lobby_data("matchmaking_type")

	if not IS_PS4 then
		var_52_0 = var_52_0 and NetworkLookup.matchmaking_types[tonumber(var_52_0)]
	end

	return var_52_0
end

MatchmakingManager._try_call_state_method = function (arg_53_0, arg_53_1, ...)
	local var_53_0 = arg_53_0._state
	local var_53_1 = var_53_0 and var_53_0[arg_53_1]

	if var_53_1 then
		var_53_1(var_53_0, ...)
	else
		local var_53_2 = var_53_0 and var_53_0.NAME or "none"

		Crashify.print_exception("MatchmakingManager", "Method %q not supported by state %q!", arg_53_1, var_53_2)
	end
end

MatchmakingManager.rpc_set_matchmaking = function (arg_54_0, arg_54_1, arg_54_2, arg_54_3, arg_54_4, arg_54_5, arg_54_6, arg_54_7)
	if not arg_54_0.is_server then
		mm_printf_force("Set matchmaking=%s, private_game=%s", tostring(arg_54_2), tostring(arg_54_3))

		if arg_54_2 then
			local var_54_0 = NetworkLookup.mechanisms[arg_54_7]
			local var_54_1 = {
				private_game = arg_54_3,
				mechanism = var_54_0
			}

			arg_54_0:_change_state(MatchmakingStateFriendClient, arg_54_0.params, var_54_1)
		else
			if Managers.lobby:query_lobby("matchmaking_join_lobby") then
				Managers.lobby:destroy_lobby("matchmaking_join_lobby")
			end

			local var_54_2 = arg_54_0._state

			if var_54_2.lobby_client then
				var_54_2.lobby_client:destroy()

				var_54_2.lobby_client = nil
			end

			arg_54_0:_change_state(MatchmakingStateIdle, arg_54_0.params, {})
		end
	end
end

MatchmakingManager.rpc_cancel_matchmaking = function (arg_55_0, arg_55_1)
	if not arg_55_0.is_server then
		return
	end

	local var_55_0 = CHANNEL_TO_PEER_ID[arg_55_1]

	if not Managers.party:is_leader(var_55_0) then
		return
	end

	arg_55_0:cancel_matchmaking()
end

MatchmakingManager.rpc_matchmaking_request_profiles_data = function (arg_56_0, arg_56_1)
	local var_56_0 = CHANNEL_TO_PEER_ID[arg_56_1]
	local var_56_1 = arg_56_0.lobby:get_stored_lobby_data()
	local var_56_2, var_56_3 = ProfileSynchronizer.net_pack_lobby_profile_slots(var_56_1)
	local var_56_4 = Managers.mechanism:reserved_party_id_by_peer(var_56_0)

	arg_56_0.network_transmit:send_rpc("rpc_matchmaking_request_profiles_data_reply", var_56_0, var_56_2, var_56_3, var_56_4)
end

MatchmakingManager._extract_dlcs = function (arg_57_0, arg_57_1)
	local var_57_0 = {}

	for iter_57_0, iter_57_1 in ipairs(arg_57_1) do
		var_57_0[NetworkLookup.dlcs[iter_57_1]] = true
	end

	return var_57_0
end

MatchmakingManager._missing_required_dlc = function (arg_58_0, arg_58_1, arg_58_2, arg_58_3)
	local var_58_0 = arg_58_1 and MechanismSettings[arg_58_1]

	if var_58_0 and var_58_0.required_dlc and not arg_58_3[var_58_0.required_dlc] then
		return var_58_0.required_dlc
	end

	local var_58_1 = arg_58_2 and DifficultySettings[arg_58_2]

	if var_58_1 and var_58_1.dlc_requirement and not arg_58_3[var_58_1.dlc_requirement] then
		return var_58_1.dlc_requirement
	end

	return nil
end

MatchmakingManager.rpc_matchmaking_request_join_lobby = function (arg_59_0, arg_59_1, arg_59_2, arg_59_3, arg_59_4)
	local var_59_0 = arg_59_0.lobby:id()
	local var_59_1 = tostring(var_59_0)

	arg_59_2 = tostring(arg_59_2)

	local var_59_2 = "lobby_ok"
	local var_59_3 = 1
	local var_59_4

	if DEDICATED_SERVER then
		var_59_4 = var_59_1 == arg_59_2
	else
		var_59_4 = LobbyInternal.lobby_id_match and LobbyInternal.lobby_id_match(var_59_1, arg_59_2) or var_59_1 == arg_59_2
	end

	local var_59_5 = CHANNEL_TO_PEER_ID[arg_59_1]
	local var_59_6 = arg_59_0:_extract_dlcs(arg_59_4)
	local var_59_7 = Managers.state.game_mode
	local var_59_8 = Managers.state.difficulty
	local var_59_9 = Managers.mechanism
	local var_59_10 = var_59_9:game_mechanism()
	local var_59_11 = var_59_7 and var_59_7:game_mode_key()
	local var_59_12 = var_59_8 and var_59_8:get_difficulty()
	local var_59_13 = var_59_9:is_venture_over()
	local var_59_14, var_59_15 = var_59_9:mechanism_try_call("is_hosting_versus_custom_game")
	local var_59_16
	local var_59_17

	if not DEDICATED_SERVER then
		local var_59_18 = var_0_5[arg_59_0._state.NAME]

		if var_59_18 == "adventure" then
			var_59_17 = true
		elseif var_59_18 == "versus" then
			var_59_16 = true
		end
	end

	local var_59_19 = arg_59_0.lobby:lobby_data("matchmaking")
	local var_59_20 = arg_59_0.lobby:lobby_data("mechanism")
	local var_59_21 = false

	if not DEDICATED_SERVER then
		var_59_21 = IS_CONSOLE and true or LobbyInternal.is_friend(var_59_5)
	end

	local var_59_22

	if not DEDICATED_SERVER and IS_WINDOWS then
		local var_59_23 = Friends.relationship(var_59_5)

		var_59_22 = var_59_23 == 5 or var_59_23 == 6
	end

	local var_59_24 = not var_59_21 and arg_59_0:_missing_required_dlc(var_59_20, var_59_12, var_59_6)
	local var_59_25 = Application.user_setting("friend_join_mode")

	if not var_59_4 then
		var_59_2 = "lobby_id_mismatch"
	elseif var_59_22 then
		var_59_2 = "user_blocked"
	elseif var_59_13 then
		var_59_2 = "game_mode_ended"
	elseif not DEDICATED_SERVER and arg_59_3 and var_59_25 == "host_friends_only" and not var_59_21 then
		var_59_2 = "friend_joining_friends_only"
	elseif not DEDICATED_SERVER and arg_59_3 and var_59_25 == "disabled" then
		var_59_2 = "friend_joining_disabled"
	elseif var_59_15 and (arg_59_3 or var_59_21) then
		var_59_2 = "custom_lobby_ok"
	elseif not DEDICATED_SERVER and not var_59_21 and not arg_59_3 and not var_59_17 then
		var_59_2 = "not_searching_for_players"
	elseif var_59_16 then
		var_59_2 = "is_searching_for_dedicated_server"
	elseif Managers.deed:has_deed() then
		var_59_2 = "lobby_has_active_deed"
	elseif var_59_24 then
		var_59_3 = NetworkLookup.dlcs[var_59_24]
		var_59_2 = "dlc_required"
	elseif not Development.parameter("allow_weave_joining") then
		if var_59_11 == "weave" and var_59_19 == "false" then
			if not Managers.weave:get_player_ids()[var_59_5] then
				var_59_2 = "cannot_join_weave"
			end
		elseif var_59_20 == "weave" and var_59_19 == "false" then
			local var_59_26 = Boot.loading_context
			local var_59_27 = var_59_26 and var_59_26.weave_data
			local var_59_28 = var_59_27 and var_59_27.player_ids

			if var_59_28 then
				if not var_59_28[var_59_5] then
					var_59_2 = "cannot_join_weave"
				end
			else
				var_59_2 = "cannot_join_weave"
			end
		end
	end

	mm_printf_force("Got request to join matchmaking lobby %s from %s, replying %s", arg_59_2, var_59_5, var_59_2)

	local var_59_29 = NetworkLookup.game_ping_reply[var_59_2]

	arg_59_0.network_transmit:send_rpc("rpc_matchmaking_request_join_lobby_reply", var_59_5, var_59_29, var_59_3)
end

MatchmakingManager.rpc_matchmaking_request_profile = function (arg_60_0, arg_60_1, arg_60_2, arg_60_3)
	local var_60_0 = CHANNEL_TO_PEER_ID[arg_60_1]
	local var_60_1, var_60_2 = Managers.mechanism:try_reserve_profile_for_peer_by_mechanism(var_60_0, arg_60_2, arg_60_3, false)

	if var_60_2 and var_60_2 ~= arg_60_2 then
		var_60_1 = var_60_1 and "previous_profile_accepted" or "profile_declined"
	else
		var_60_1 = var_60_1 and "profile_accepted" or "profile_declined"
	end

	if Managers.state.game_mode and Managers.state.game_mode:hero_is_locked(arg_60_2) then
		var_60_1 = "profile_locked"
	end

	local var_60_3 = NetworkLookup.request_profile_replies[var_60_1]

	arg_60_0.network_transmit:send_rpc("rpc_matchmaking_request_profile_reply", var_60_0, arg_60_2, var_60_3)
end

MatchmakingManager.current_state = function (arg_61_0)
	return arg_61_0._state and arg_61_0._state.NAME or "none"
end

MatchmakingManager.get_transition = function (arg_62_0)
	if arg_62_0._state and arg_62_0._state.get_transition then
		local var_62_0, var_62_1 = arg_62_0._state:get_transition()

		if var_62_0 ~= nil then
			return var_62_0, var_62_1
		end
	end

	if arg_62_0.lobby_to_join then
		return "join_lobby", arg_62_0.lobby_to_join
	end
end

MatchmakingManager.loading_context = function (arg_63_0)
	if arg_63_0._state and arg_63_0._state.loading_context then
		return arg_63_0._state:loading_context()
	end
end

MatchmakingManager.active_lobby = function (arg_64_0)
	if arg_64_0._state and arg_64_0._state.active_lobby then
		return arg_64_0._state:active_lobby()
	end

	return arg_64_0.lobby
end

MatchmakingManager.hero_available_in_lobby_data = function (arg_65_0, arg_65_1, arg_65_2, arg_65_3)
	local var_65_0 = arg_65_0.state_context.search_config

	if var_65_0 and var_65_0.allow_duplicate_heroes then
		return true
	end

	if ProfileSynchronizer.is_free_in_lobby(arg_65_1, arg_65_2, arg_65_3) then
		return true
	end

	if Managers.state.game_mode:hero_is_locked(arg_65_1) then
		return false
	end

	local var_65_1 = Managers.player:local_player()
	local var_65_2 = var_65_1.peer_id
	local var_65_3 = var_65_1:profile_id()
	local var_65_4, var_65_5 = ProfileSynchronizer.owner_in_lobby(arg_65_1, arg_65_2, arg_65_3)

	if var_65_4 == var_65_2 and var_65_5 == var_65_3 then
		return true
	end

	return false
end

MatchmakingManager.lobby_match = function (arg_66_0, arg_66_1, arg_66_2, arg_66_3, arg_66_4, arg_66_5, arg_66_6, arg_66_7, arg_66_8)
	local var_66_0 = arg_66_1.id

	if arg_66_0:lobby_listed_as_broken(var_66_0) then
		return false, "lobby listed as broken"
	end

	if arg_66_1.host == arg_66_6 then
		return false, "players own lobby"
	end

	if IS_WINDOWS then
		local var_66_1 = LobbyAux.deserialize_lobby_reservation_data(arg_66_1)

		for iter_66_0 = 1, #var_66_1 do
			local var_66_2 = var_66_1[iter_66_0]

			for iter_66_1 = 1, #var_66_2 do
				local var_66_3 = var_66_2[iter_66_1].peer_id
				local var_66_4 = Friends.relationship(var_66_3)

				if var_66_4 == 5 or var_66_4 == 6 then
					return false, "user blocked"
				end
			end
		end
	end

	if arg_66_1.twitch_enabled == "true" then
		return false, "twitch_mode"
	end

	if not (arg_66_1.matchmaking ~= "false" and arg_66_1.valid) then
		return false, "lobby is not valid"
	end

	if arg_66_1.mission_id == "prologue" then
		return false, "in prologue"
	end

	if arg_66_1.mechanism == "deus" and arg_66_3 == "any" then
		local var_66_5 = arg_66_1.selected_mission_id

		if DeusJourneySettings[var_66_5] then
			local var_66_6 = Managers.player:local_player():stats_id()
			local var_66_7 = LevelUnlockUtils.unlocked_journeys(arg_66_0.statistics_db, var_66_6)

			if not table.find(var_66_7, var_66_5) then
				return false, "Journey is not unlocked"
			end
		end
	end

	if arg_66_3 and arg_66_3 ~= "any" then
		local var_66_8 = false
		local var_66_9 = "<no lobby level>"

		if arg_66_1.selected_mission_id then
			var_66_8 = arg_66_1.selected_mission_id == arg_66_3
			var_66_9 = string.format("(%s ~= %s)", arg_66_3, arg_66_1.selected_mission_id)
		elseif arg_66_1.mission_id then
			var_66_8 = arg_66_1.mission_id == arg_66_3
			var_66_9 = string.format("(%s ~= %s)", arg_66_3, arg_66_1.mission_id)
		end

		if not var_66_8 then
			return false, "wrong mission " .. var_66_9
		end
	end

	if arg_66_2 and arg_66_1.act_key ~= arg_66_2 then
		return false, "wrong act"
	end

	if arg_66_5 == "event" then
		local var_66_10 = arg_66_1.matchmaking_type

		if not IS_PS4 then
			local var_66_11 = tonumber(var_66_10)

			var_66_10 = var_66_11 and NetworkLookup.matchmaking_types[var_66_11]
		end

		if arg_66_5 ~= var_66_10 then
			return false, "wrong game mode"
		end
	end

	if arg_66_8 == "weave" then
		if arg_66_7 ~= "false" then
			if arg_66_7 ~= (arg_66_1.selected_mission_id or arg_66_1.mission_id) then
				return false, "wrong weave name"
			end
		elseif arg_66_1.weave_quick_game ~= "true" then
			return false, "ranked weave"
		end
	end

	if arg_66_4 and not (arg_66_1.difficulty == arg_66_4) then
		return false, "wrong difficulty"
	end

	local var_66_12 = arg_66_0.get_matchmaking_settings_for_mechanism(arg_66_8)
	local var_66_13 = arg_66_1.num_players and tonumber(arg_66_1.num_players)
	local var_66_14 = arg_66_0.state_context.search_config.max_number_of_players or var_66_12.MAX_NUMBER_OF_PLAYERS

	if not (var_66_13 and var_66_13 < var_66_14) then
		return false, "no empty slot"
	end

	if script_data.unique_server_name and arg_66_1.unique_server_name ~= script_data.unique_server_name then
		Debug.text("Ignoring lobby due to mismatching unique_server_name")

		return false, "mismatching unique_server_name"
	end

	return true
end

MatchmakingManager.add_broken_lobby_client = function (arg_67_0, arg_67_1, arg_67_2, arg_67_3)
	if arg_67_1 == nil then
		return
	end

	local var_67_0 = arg_67_3 and math.huge or 20
	local var_67_1 = arg_67_2 + var_67_0

	if arg_67_1:is_dedicated_server() then
		local var_67_2 = arg_67_1:ip_address()

		mm_printf("Adding broken server: %s Due to bad connection or something: %s, ignoring it for %d seconds", var_67_2, tostring(arg_67_3), var_67_0)

		MatchmakingManager._broken_servers[var_67_2] = var_67_1

		print("Broken server, printing callstack!", Script.callstack())
	else
		local var_67_3 = arg_67_1:id()

		mm_printf("Adding broken lobby: %s Due to bad connection or something: %s, ignoring it for %d seconds", tostring(var_67_3), tostring(arg_67_3), var_67_0)

		MatchmakingManager._broken_lobbies[var_67_3] = var_67_1
	end
end

MatchmakingManager.lobby_listed_as_broken = function (arg_68_0, arg_68_1)
	return MatchmakingManager._broken_lobbies[arg_68_1]
end

MatchmakingManager.server_listed_as_broken = function (arg_69_0, arg_69_1)
	return MatchmakingManager._broken_servers[arg_69_1]
end

MatchmakingManager.broken_server_map = function (arg_70_0)
	return MatchmakingManager._broken_servers
end

MatchmakingManager.rpc_matchmaking_request_join_lobby_reply = function (arg_71_0, arg_71_1, arg_71_2, arg_71_3)
	if arg_71_0._state and arg_71_0._state.NAME == "MatchmakingStateRequestJoinGame" then
		arg_71_0._state:rpc_matchmaking_request_join_lobby_reply(arg_71_1, arg_71_2, arg_71_3)
	else
		local var_71_0 = arg_71_0._state and arg_71_0._state.NAME or "none"

		mm_printf_force("rpc_matchmaking_request_join_lobby_reply, got this in wrong state current_state:%s", var_71_0)
	end
end

MatchmakingManager.rpc_notify_connected = function (arg_72_0, arg_72_1)
	local var_72_0 = arg_72_0._state and arg_72_0._state.NAME or "none"

	if var_72_0 == "MatchmakingStateRequestJoinGame" or var_72_0 == "MatchmakingStateRequestGameServerOwnership" or var_72_0 == "MatchmakingStateReserveSlotsPlayerHosted" then
		arg_72_0._state:rpc_notify_connected(arg_72_1)
	else
		mm_printf_force("rpc_notify_connected, got this in wrong state current_state:%s", var_72_0)
	end
end

MatchmakingManager.rpc_flexmatch_game_session_id_request = function (arg_73_0, arg_73_1)
	if arg_73_0._state.rpc_flexmatch_game_session_id_request then
		arg_73_0._state:rpc_flexmatch_game_session_id_request(arg_73_1)
	else
		local var_73_0 = arg_73_0._state and arg_73_0._state.NAME or "none"

		mm_printf_force("rpc_flexmatch_game_session_id_request, got this in wrong state current_state:%s", var_73_0)
	end
end

MatchmakingManager.rpc_matchmaking_join_game = function (arg_74_0, arg_74_1)
	if arg_74_0._state and arg_74_0._state.NAME == "MatchmakingStateJoinGame" or arg_74_0._state.NAME == "MatchmakingStateWaitJoinPlayerHosted" then
		arg_74_0._state:rpc_matchmaking_join_game(arg_74_1)
	else
		local var_74_0 = arg_74_0._state and arg_74_0._state.NAME or "none"

		mm_printf_force("rpc_matchmaking_join_game, got this in wrong state current_state:%s", var_74_0)
	end
end

MatchmakingManager.rpc_matchmaking_request_profile_reply = function (arg_75_0, arg_75_1, arg_75_2, arg_75_3)
	if arg_75_0._state and arg_75_0._state.NAME == "MatchmakingStateJoinGame" then
		arg_75_0._state:rpc_matchmaking_request_profile_reply(arg_75_1, arg_75_2, arg_75_3)
	else
		local var_75_0 = arg_75_0._state and arg_75_0._state.NAME or "none"

		mm_printf_force("rpc_matchmaking_request_profile_reply, got this in wrong state current_state:%s", var_75_0)
	end
end

MatchmakingManager.rpc_matchmaking_request_profiles_data_reply = function (arg_76_0, arg_76_1, arg_76_2, arg_76_3, arg_76_4)
	if arg_76_0._state and arg_76_0._state.NAME == "MatchmakingStateRequestProfiles" then
		arg_76_0._state:rpc_matchmaking_request_profiles_data_reply(arg_76_1, arg_76_2, arg_76_3, arg_76_4)
	else
		local var_76_0 = arg_76_0._state and arg_76_0._state.NAME or "none"

		mm_printf_force("rpc_matchmaking_request_profiles_data_reply, got this in wrong state current_state:%s", var_76_0)
	end
end

MatchmakingManager.rpc_matchmaking_request_selected_level = function (arg_77_0, arg_77_1)
	if arg_77_0._state and arg_77_0._state.NAME == "MatchmakingStateHostGame" then
		local var_77_0 = arg_77_0.lobby:get_stored_lobby_data().selected_mission_id
		local var_77_1 = NetworkLookup.mission_ids[var_77_0]

		RPC.rpc_matchmaking_request_selected_level_reply(arg_77_1, var_77_1)
	else
		local var_77_2 = arg_77_0._state and arg_77_0._state.NAME or "none"

		mm_printf_force("rpc_matchmaking_request_selected_level, got this in wrong state current_state:%s", var_77_2)
	end
end

MatchmakingManager.rpc_matchmaking_request_selected_level_reply = function (arg_78_0, arg_78_1, arg_78_2)
	if arg_78_0._state and arg_78_0._state.NAME == "MatchmakingStateFriendClient" then
		arg_78_0._state:rpc_matchmaking_request_selected_level_reply(arg_78_1, arg_78_2)
	else
		local var_78_0 = arg_78_0._state and arg_78_0._state.NAME or "none"

		mm_printf_force("rpc_matchmaking_request_selected_level_reply, got this in wrong state current_state:%s", var_78_0)
	end
end

MatchmakingManager.rpc_matchmaking_request_selected_difficulty = function (arg_79_0, arg_79_1)
	if arg_79_0._state and arg_79_0._state.NAME == "MatchmakingStateHostGame" then
		local var_79_0 = arg_79_0.lobby:get_stored_lobby_data().difficulty
		local var_79_1 = NetworkLookup.difficulties[var_79_0]

		RPC.rpc_matchmaking_request_selected_difficulty_reply(arg_79_1, var_79_1)
	else
		local var_79_2 = arg_79_0._state and arg_79_0._state.NAME or "none"

		mm_printf_force("rpc_matchmaking_request_selected_difficulty, got this in wrong state current_state:%s", var_79_2)
	end
end

MatchmakingManager.rpc_matchmaking_request_selected_difficulty_reply = function (arg_80_0, arg_80_1, arg_80_2)
	if arg_80_0._state and arg_80_0._state.NAME == "MatchmakingStateFriendClient" then
		arg_80_0._state:rpc_matchmaking_request_selected_difficulty_reply(arg_80_1, arg_80_2)
	else
		local var_80_0 = arg_80_0._state and arg_80_0._state.NAME or "none"

		mm_printf_force("rpc_matchmaking_request_selected_difficulty_reply, got this in wrong state current_state:%s", var_80_0)
	end
end

MatchmakingManager.rpc_matchmaking_request_status_message = function (arg_81_0, arg_81_1)
	if arg_81_0._state and arg_81_0._state.NAME == "MatchmakingStateHostGame" then
		local var_81_0 = arg_81_0.current_status_message

		if not var_81_0 then
			return
		end

		RPC.rpc_matchmaking_status_message(arg_81_1, var_81_0)
	else
		local var_81_1 = arg_81_0._state and arg_81_0._state.NAME or "none"

		mm_printf_force("rpc_matchmaking_request_status_message, got this in wrong state current_state:%s", var_81_1)
	end
end

MatchmakingManager.rpc_matchmaking_status_message = function (arg_82_0, arg_82_1, arg_82_2)
	if arg_82_0._state and arg_82_0._state.NAME == "MatchmakingStateFriendClient" then
		arg_82_0._state:rpc_matchmaking_status_message(arg_82_1, arg_82_2)
	else
		local var_82_0 = arg_82_0._state and arg_82_0._state.NAME or "none"

		mm_printf_force("rpc_matchmaking_status_message, got this in wrong state current_state:%s", var_82_0)
	end
end

MatchmakingManager.rpc_game_server_set_group_leader = function (arg_83_0, arg_83_1, arg_83_2)
	if arg_83_2 == "0" then
		arg_83_2 = nil
	end

	Managers.party:set_leader(arg_83_2)
end

MatchmakingManager.rpc_matchmaking_broadcast_game_server_ip_address = function (arg_84_0, arg_84_1, arg_84_2)
	if arg_84_0._state and arg_84_0._state.NAME == "MatchmakingStateFriendClient" then
		arg_84_0._state:rpc_matchmaking_broadcast_game_server_ip_address(arg_84_1, arg_84_2)
	else
		local var_84_0 = arg_84_0._state and arg_84_0._state.NAME or "none"

		mm_printf_force("rpc_matchmaking_broadcast_game_server_ip_address, got this in wrong state current_state:%s", var_84_0)
	end
end

MatchmakingManager.rpc_set_quick_game = function (arg_85_0, arg_85_1, arg_85_2)
	arg_85_0:set_quick_game(arg_85_2)
end

MatchmakingManager.rpc_start_game_countdown_finished = function (arg_86_0, arg_86_1)
	arg_86_0:countdown_completed()
end

MatchmakingManager.rpc_matchmaking_sync_quickplay_data = function (arg_87_0, arg_87_1, arg_87_2)
	local var_87_0 = CHANNEL_TO_PEER_ID[arg_87_1]

	arg_87_0:_add_level_weight(var_87_0, arg_87_2)
end

MatchmakingManager.rpc_matchmaking_request_quickplay_data = function (arg_88_0, arg_88_1)
	local var_88_0 = arg_88_0:_get_unlocked_levels()
	local var_88_1 = Managers.backend:get_read_only_data("recent_quickplay_games")
	local var_88_2 = var_88_1 and cjson.decode(var_88_1) or {}
	local var_88_3 = false
	local var_88_4 = arg_88_0:_calculate_level_weights(var_88_0, var_88_2, var_88_3)

	arg_88_0.network_transmit:send_rpc_server("rpc_matchmaking_sync_quickplay_data", var_88_4)
end

MatchmakingManager.rpc_matchmaking_verify_dlc = function (arg_89_0, arg_89_1, arg_89_2)
	if arg_89_0._state then
		local var_89_0 = true

		for iter_89_0, iter_89_1 in pairs(arg_89_2) do
			local var_89_1 = NetworkLookup.dlcs[iter_89_1]

			if not Managers.unlock:is_dlc_unlocked(var_89_1) then
				var_89_0 = false

				break
			end
		end

		Managers.state.network.network_transmit:send_rpc_server("rpc_matchmaking_verify_dlc_reply", var_89_0)
	end
end

MatchmakingManager.rpc_matchmaking_verify_dlc_reply = function (arg_90_0, arg_90_1, arg_90_2)
	if arg_90_0._state and arg_90_0._state.NAME == "MatchmakingStateStartGame" then
		arg_90_0._state:rpc_matchmaking_verify_dlc_reply(arg_90_1, arg_90_2)
	else
		local var_90_0 = arg_90_0._state and arg_90_0._state.NAME or "none"

		mm_printf_force("rpc_matchmaking_verify_dlc_reply, got this in wrong state current_state:%s", var_90_0)
	end
end

MatchmakingManager.rpc_join_reserved_game_server = function (arg_91_0, arg_91_1)
	local var_91_0 = arg_91_0._state and arg_91_0._state.NAME or "none"

	if var_91_0 == "MatchmakingStateReserveLobby" then
		arg_91_0._state:rpc_join_reserved_game_server(arg_91_1)
	else
		mm_printf_force("rpc_join_reserved_game_server, got this in wrong state current_state:%s", var_91_0)
	end
end

MatchmakingManager.rpc_matchmaking_client_joined_player_hosted = function (arg_92_0, arg_92_1, arg_92_2)
	local var_92_0 = arg_92_0._state and arg_92_0._state.NAME or "none"

	if var_92_0 == "MatchmakingStateReserveSlotsPlayerHosted" then
		arg_92_0._state:rpc_matchmaking_client_joined_player_hosted(arg_92_1, arg_92_2)
	else
		mm_printf_force("rpc_matchmaking_client_joined_player_hosted, got this in wrong state current_state:%s", var_92_0)
	end
end

MatchmakingManager.rpc_matchmaking_reservation_success = function (arg_93_0, arg_93_1, arg_93_2)
	local var_93_0 = arg_93_0._state and arg_93_0._state.NAME or "none"

	if var_93_0 == "MatchmakingStateReserveSlotsPlayerHosted" then
		arg_93_0._state:rpc_matchmaking_reservation_success(arg_93_1, arg_93_2)
	else
		mm_printf_force("rpc_matchmaking_reservation_success, got this in wrong state current_state:%s", var_93_0)
	end
end

MatchmakingManager.rpc_matchmaking_request_reserve_slots = function (arg_94_0, arg_94_1, arg_94_2, arg_94_3)
	local var_94_0 = arg_94_0.lobby:id()
	local var_94_1 = CHANNEL_TO_PEER_ID[arg_94_1]
	local var_94_2 = "lobby_ok"
	local var_94_3 = 1

	if not (tostring(var_94_0) == tostring(arg_94_2)) then
		var_94_2 = "lobby_id_mismatch"
	else
		local var_94_4 = Managers.mechanism:game_mechanism()
		local var_94_5, var_94_6 = (var_94_4:get_slot_reservation_handler(Network.peer_id(), var_0_0.pending_custom_game) or var_94_4:get_slot_reservation_handler(Network.peer_id(), var_0_0.session)):try_reserve_slots(var_94_1, arg_94_3)

		if not var_94_5 then
			var_94_2 = "server_full"
		else
			var_94_3 = var_94_6
		end
	end

	local var_94_7 = NetworkLookup.game_ping_reply[var_94_2]

	arg_94_0.network_transmit:send_rpc("rpc_matchmaking_request_reserve_slots_reply", var_94_1, var_94_7, var_94_3)
end

MatchmakingManager.rpc_matchmaking_request_reserve_slots_reply = function (arg_95_0, arg_95_1, arg_95_2, arg_95_3)
	local var_95_0 = arg_95_0._state and arg_95_0._state.NAME or "none"

	if var_95_0 == "MatchmakingStateReserveSlotsPlayerHosted" then
		arg_95_0._state:rpc_matchmaking_request_reserve_slots_reply(arg_95_1, arg_95_2, arg_95_3)
	else
		mm_printf_force("rpc_matchmaking_request_reserve_slots_reply, got this in wrong state current_state:%s", var_95_0)
	end
end

MatchmakingManager.rpc_matchmaking_client_join_player_hosted = function (arg_96_0, arg_96_1, arg_96_2)
	arg_96_0:_change_state(MatchmakingStateReserveSlotsPlayerHosted, arg_96_0.params, {
		join_lobby_data = {
			id = arg_96_2
		}
	})
end

MatchmakingManager.hot_join_sync = function (arg_97_0, arg_97_1)
	arg_97_0.peers_to_sync[arg_97_1] = true

	local var_97_0 = PEER_ID_TO_CHANNEL[arg_97_1]

	RPC.rpc_set_client_game_privacy(var_97_0, arg_97_0:is_game_private())
	RPC.rpc_matchmaking_request_quickplay_data(var_97_0)
end

MatchmakingManager.countdown_completed = function (arg_98_0)
	if not arg_98_0.countdown_has_finished and not arg_98_0.is_server and Managers.party:is_leader(arg_98_0.peer_id) and arg_98_0:on_dedicated_server() then
		arg_98_0.countdown_has_finished = false

		arg_98_0.network_transmit:send_rpc_server("rpc_start_game_countdown_finished")

		return
	end

	arg_98_0.countdown_has_finished = true
end

MatchmakingManager.set_status_message = function (arg_99_0, arg_99_1)
	if arg_99_1 == arg_99_0.current_status_message then
		return
	end

	arg_99_0.current_status_message = arg_99_1

	if arg_99_0.is_server then
		arg_99_0.network_transmit:send_rpc_clients("rpc_matchmaking_status_message", arg_99_1)
	end
end

MatchmakingManager.setup_filter_requirements = function (arg_100_0, arg_100_1, arg_100_2, arg_100_3, arg_100_4)
	arg_100_3.network_hash = {
		comparison = "equal",
		value = arg_100_0._network_hash
	}
	arg_100_3.matchmaking = {
		value = "true",
		comparison = "equal"
	}

	local var_100_0 = {
		free_slots = arg_100_1,
		distance_filter = arg_100_2,
		filters = table.clone(arg_100_3),
		near_filters = table.clone(arg_100_4)
	}

	arg_100_0.lobby_finder:add_filter_requirements(var_100_0)
end

MatchmakingManager.request_join_lobby = function (arg_101_0, arg_101_1, arg_101_2)
	local var_101_0 = arg_101_2 and arg_101_2.friend_join

	if arg_101_0._state.NAME ~= "MatchmakingStateIdle" and not var_101_0 then
		mm_printf("trying to join lobby from lobby browser in wrong state %s", arg_101_0._state.NAME)

		return
	end

	local var_101_1 = MatchmakingStateRequestJoinGame
	local var_101_2 = arg_101_1.mechanism
	local var_101_3 = arg_101_1.matchmaking

	if var_101_2 == "versus" and (var_101_3 == "true" or var_101_3 == "searching") then
		local var_101_4 = arg_101_1.matchmaking_type
		local var_101_5 = NetworkLookup.matchmaking_types[tonumber(var_101_4)]
		local var_101_6
		local var_101_7 = Managers.state.game_mode

		if (var_101_7 and var_101_7:game_mode_key()) ~= "inn_vs" then
			local var_101_8 = "vs_player_hosted_lobby_wrong_mechanism_error"

			arg_101_0:send_system_chat_message(var_101_8)

			return
		end

		if var_101_3 == "searching" then
			local var_101_9 = "matchmaking_status_join_game_failed_is_searching_for_dedicated_server"

			arg_101_0:send_system_chat_message(var_101_9)

			return
		end

		if var_101_5 == "custom" then
			var_101_1 = MatchmakingStateReserveSlotsPlayerHosted
		else
			var_101_1 = MatchmakingStateReserveLobby
		end
	end

	if var_101_3 and arg_101_0._state.NAME ~= "MatchmakingStateIdle" and var_101_0 then
		local var_101_10 = "matchmaking_status_join_game_failed_" .. "match_in_progress"

		arg_101_0:send_system_chat_message(var_101_10)

		return
	end

	mm_printf("Joining lobby %s.", tostring(arg_101_1))

	local var_101_11 = {
		join_by_lobby_browser = true,
		join_lobby_data = arg_101_1
	}

	table.merge(var_101_11, arg_101_2 or {})

	arg_101_0.started_matchmaking_t = Managers.time:time("main")

	table.dump(var_101_11, "STATE_CONTEXT", 2)
	arg_101_0:_change_state(var_101_1, arg_101_0.params, var_101_11)
end

MatchmakingManager.is_joining_friend = function (arg_102_0)
	return arg_102_0.state_context.friend_join
end

MatchmakingManager.cancel_join_lobby = function (arg_103_0, arg_103_1, arg_103_2)
	arg_103_0.state_context = {}

	if arg_103_0._lobby_browser then
		arg_103_0._lobby_browser:cancel_join_lobby(arg_103_1)
	end

	if arg_103_1 == "dlc_required" and arg_103_2 then
		local var_103_0 = NetworkLookup.dlcs[arg_103_2]

		Managers.state.event:trigger("ui_show_popup", var_103_0, "upsell")
	elseif arg_103_1 == "failure_start_join_server_difficulty_requirements_failed" then
		local var_103_1 = Localize(arg_103_1)
		local var_103_2 = string.format(var_103_1, arg_103_2 or "")

		Managers.simple_popup:queue_popup(var_103_2, Localize("popup_error_topic"), "ok", Localize("popup_choice_ok"))
	elseif arg_103_1 ~= "cancelled" then
		local var_103_3 = "matchmaking_status_join_game_failed_" .. arg_103_1

		Managers.simple_popup:queue_popup(Localize(var_103_3), Localize("popup_error_topic"), "ok", Localize("popup_choice_ok"))
	end
end

MatchmakingManager.allowed_to_initiate_join_lobby = function (arg_104_0)
	return arg_104_0:_matchmaking_status() == "idle"
end

MatchmakingManager.allow_cancel_matchmaking = function (arg_105_0)
	local var_105_0 = arg_105_0._state
	local var_105_1 = Managers.lobby:query_lobby("matchmaking_join_lobby") or Managers.lobby:query_lobby("matchmaking_join_lobby") or var_105_0.lobby_client

	if var_105_1 then
		if var_105_1:is_joined() then
			return true
		end
	else
		local var_105_2 = var_105_0.NAME

		if var_105_2 ~= "MatchmakingStateIdle" and var_105_2 ~= "MatchmakingStateIngame" then
			return true
		end
	end
end

MatchmakingManager.send_system_chat_message = function (arg_106_0, arg_106_1, arg_106_2)
	local var_106_0 = 1

	arg_106_2 = arg_106_2 or ""

	local var_106_1 = true
	local var_106_2 = false

	Managers.chat:send_system_chat_message(var_106_0, arg_106_1, arg_106_2, var_106_2, var_106_1)
end

function DEBUG_LOBBIES()
	local var_107_0 = Managers.matchmaking.lobby:get_stored_lobby_data()

	table.dump(var_107_0, "lobby_data")

	local var_107_1 = Managers.matchmaking._state and Managers.matchmaking._state.active_lobby and Managers.matchmaking._state:active_lobby()
	local var_107_2 = var_107_1 and var_107_1:get_stored_lobby_data()

	if var_107_2 then
		table.dump(var_107_2, "active_lobby_data")
	else
		print("no active_lobby")
	end
end

MatchmakingManager.rpc_set_client_game_privacy = function (arg_108_0, arg_108_1, arg_108_2)
	local var_108_0 = arg_108_0.lobby

	if not arg_108_0.is_server then
		var_108_0:get_stored_lobby_data().is_private = arg_108_2 and "true" or "false"
	end
end

MatchmakingManager.set_game_privacy = function (arg_109_0, arg_109_1)
	local var_109_0 = arg_109_0.lobby

	if arg_109_0.is_server and var_109_0:is_joined() then
		local var_109_1 = arg_109_1 and "true" or "false"

		arg_109_0:_set_lobby_data(var_109_0, "is_private", var_109_1)
		Managers.state.network.network_transmit:send_rpc_clients("rpc_set_client_game_privacy", arg_109_1)
	end
end

MatchmakingManager.set_versus_custom_lobby_data = function (arg_110_0, arg_110_1)
	if arg_110_0.is_server and arg_110_0.lobby:is_joined() and Managers.mechanism:current_mechanism_name() == "versus" then
		arg_110_0:_set_lobby_data(arg_110_0.lobby, "custom_game_settings", arg_110_1)
	end
end

MatchmakingManager.set_in_progress_game_privacy = function (arg_111_0, arg_111_1)
	local var_111_0 = arg_111_0.lobby

	if arg_111_0.is_server and var_111_0:is_joined() then
		arg_111_0:set_game_privacy(arg_111_1)

		local var_111_1 = arg_111_1 and "false" or "true"

		arg_111_0:_set_lobby_data(var_111_0, "matchmaking", var_111_1)

		if not arg_111_1 then
			arg_111_0:_change_state(MatchmakingStateIngame, arg_111_0.params, {})
		else
			arg_111_0:_change_state(MatchmakingStateIdle, arg_111_0.params, {})
		end
	end
end

MatchmakingManager.set_lobby_data_match_started = function (arg_112_0, arg_112_1)
	local var_112_0 = arg_112_0.lobby

	if arg_112_0.is_server and var_112_0:is_joined() then
		local var_112_1 = arg_112_1 and "true" or "false"

		arg_112_0:_set_lobby_data(var_112_0, "match_started", var_112_1)
	end
end

MatchmakingManager._set_lobby_data = function (arg_113_0, arg_113_1, arg_113_2, arg_113_3)
	local var_113_0 = arg_113_1:get_stored_lobby_data()

	var_113_0[arg_113_2] = arg_113_3

	arg_113_1:set_lobby_data(var_113_0)
end

MatchmakingManager.is_game_private = function (arg_114_0)
	return arg_114_0.lobby:get_stored_lobby_data().is_private == "true"
end

MatchmakingManager._matchmaking_status = function (arg_115_0)
	local var_115_0 = arg_115_0._state.NAME

	if var_115_0 == "MatchmakingStateIdle" then
		return "idle"
	elseif var_115_0 == "MatchmakingStateSearchGame" then
		return "searching_for_game"
	elseif var_115_0 == "MatchmakingStateReserveLobby" or var_115_0 == "MatchmakingStateFlexmatchHost" then
		return "searching_for_servers"
	elseif var_115_0 == "MatchmakingStateHostGame" or var_115_0 == "MatchmakingStateWaitForCountdown" or var_115_0 == "MatchmakingStateStartGame" or var_115_0 == "MatchmakingStateRequestGameServerOwnership" or var_115_0 == "MatchmakingStatePlayerHostedGame" then
		return "hosting_game"
	elseif var_115_0 == "MatchmakingStateRequestJoinGame" or var_115_0 == "MatchmakingStateRequestProfiles" or var_115_0 == "MatchmakingStateJoinGame" then
		return "joining_game"
	elseif var_115_0 == "MatchmakingStateFriendClient" then
		if (arg_115_0.lobby and arg_115_0.lobby:lobby_data("mechanism")) == "versus" then
			return "searching_for_servers"
		end

		return "waiting_for_game_start"
	else
		return var_115_0
	end
end

MatchmakingManager.are_all_players_spawned = function (arg_116_0)
	local var_116_0 = arg_116_0.lobby:members():get_members()
	local var_116_1 = Managers.player

	for iter_116_0 = 1, #var_116_0 do
		local var_116_2 = var_116_0[iter_116_0]
		local var_116_3 = var_116_1:player_from_peer_id(var_116_2)

		if not var_116_3 then
			return false
		end

		local var_116_4 = var_116_3.player_unit

		if not Unit.alive(var_116_4) then
			return false
		end
	end

	return true
end

MatchmakingManager.get_reserved_slots = function (arg_117_0)
	local var_117_0 = arg_117_0.state_context.search_config
	local var_117_1 = 0
	local var_117_2

	if var_117_0 and var_117_0.is_player_hosted then
		var_117_1 = arg_117_0.lobby:lobby_data("reserved_slots_mask") or var_117_1
		var_117_2 = arg_117_0.lobby:lobby_data("mechanism")
	else
		local var_117_3 = arg_117_0._state.lobby_client or Managers.lobby:query_lobby("matchmaking_join_lobby") or Managers.lobby:query_lobby("matchmaking_join_lobby") or arg_117_0.lobby

		if not var_117_3 then
			return
		end

		var_117_1 = var_117_3:lobby_data("reserved_slots_mask") or var_117_1
		var_117_2 = var_117_3:lobby_data("mechanism")
	end

	return arg_117_0:_decode_reserved_slots_mask(var_117_1, var_117_2)
end

local var_0_7 = {}
local var_0_8 = {}

MatchmakingManager._decode_reserved_slots_mask = function (arg_118_0, arg_118_1, arg_118_2)
	table.clear(var_0_7)
	table.clear(var_0_8)

	if not arg_118_2 then
		return var_0_8
	end

	local var_118_0 = Managers.party:parties()

	for iter_118_0, iter_118_1 in pairs(var_118_0) do
		if iter_118_1.game_participating then
			var_0_7[iter_118_0] = iter_118_1.num_slots
		end
	end

	local var_118_1 = 0

	for iter_118_2, iter_118_3 in ipairs(var_0_7) do
		for iter_118_4 = 1, iter_118_3 do
			local var_118_2 = bit.band(arg_118_1, bit.lshift(1, var_118_1 + (iter_118_4 - 1))) > 0 and 1 or 0

			var_0_8[iter_118_2] = (var_0_8[iter_118_2] or 0) + var_118_2
		end

		var_118_1 = var_118_1 + iter_118_3
	end

	return var_0_8
end

local var_0_9 = {}

MatchmakingManager.search_info = function (arg_119_0)
	table.clear(var_0_9)

	if arg_119_0.is_server then
		local var_119_0 = arg_119_0.state_context.search_config

		if var_119_0 then
			var_0_9.mission_id = var_119_0.mission_id
			var_0_9.difficulty = var_119_0.difficulty
			var_0_9.quick_game = var_119_0.quick_game
			var_0_9.matchmaking_type = var_119_0.matchmaking_type
			var_0_9.mechanism = var_119_0.mechanism
		else
			local var_119_1 = arg_119_0._state.lobby_client or Managers.lobby:query_lobby("matchmaking_join_lobby") or Managers.lobby:query_lobby("matchmaking_join_lobby")

			if var_119_1 then
				local var_119_2 = var_119_1:lobby_data("mission_id")
				local var_119_3 = var_119_1:lobby_data("difficulty")
				local var_119_4 = var_119_1:lobby_data("matchmaking_type")
				local var_119_5 = var_119_1:lobby_data("weave_quick_game") == "true" or Managers.venture.quickplay:has_pending_quick_game() or Managers.venture.quickplay:is_quick_game()
				local var_119_6 = var_119_1:lobby_data("mechanism")

				var_0_9.mission_id = var_119_2
				var_0_9.difficulty = var_119_3
				var_0_9.quick_game = var_119_5
				var_0_9.mechanism = var_119_6
				var_0_9.matchmaking_type = IS_PS4 and var_119_4 or var_119_4 and NetworkLookup.matchmaking_types[tonumber(var_119_4)]
			end
		end
	else
		local var_119_7 = arg_119_0.lobby
		local var_119_8 = var_119_7:lobby_data("selected_mission_id")
		local var_119_9 = var_119_7:lobby_data("difficulty")
		local var_119_10 = var_119_7:lobby_data("matchmaking_type")
		local var_119_11 = var_119_7:lobby_data("mechanism")
		local var_119_12 = var_119_7:lobby_data("weave_quick_game") == "true" or Managers.venture.quickplay:has_pending_quick_game() or Managers.venture.quickplay:is_quick_game()

		var_0_9.mission_id = var_119_8
		var_0_9.difficulty = var_119_9
		var_0_9.quick_game = var_119_12
		var_0_9.mechanism = var_119_11
		var_0_9.matchmaking_type = IS_PS4 and var_119_10 or var_119_10 and NetworkLookup.matchmaking_types[tonumber(var_119_10)]
	end

	local var_119_13 = arg_119_0:_matchmaking_status()

	var_0_9.status = var_119_13

	return var_0_9
end

MatchmakingManager.setup_weave_filters = function (arg_120_0, arg_120_1, arg_120_2)
	local var_120_0 = math.min(arg_120_0.state_context.expansion_rule_index or 1, WeaveMatchmakingSettings.num_expansion_rules)
	local var_120_1 = WeaveMatchmakingSettings.expansion_rules[var_120_0].filters

	for iter_120_0, iter_120_1 in pairs(var_120_1) do
		local var_120_2 = iter_120_1.value or iter_120_1.fetch_function(arg_120_0._state)

		var_120_2 = iter_120_1.transform_data_function and iter_120_1.transform_data_function(var_120_2) or var_120_2

		local var_120_3 = iter_120_1.comparison

		arg_120_2[iter_120_0] = {
			value = var_120_2,
			comparison = var_120_3
		}
	end
end

MatchmakingManager.reset_joining = function (arg_121_0)
	arg_121_0._joining_this_host_peer_id = nil
end

MatchmakingManager.on_leave_game = function (arg_122_0)
	local var_122_0 = arg_122_0._state.NAME

	if var_122_0 == "MatchmakingStateReserveLobby" or var_122_0 == "MatchmakingStateReserveSlotsPlayerHosted" or var_122_0 == "MatchmakingStatePlayerHostedGame" then
		arg_122_0:cancel_matchmaking()
	end
end

MatchmakingManager.setup_weave_near_filters = function (arg_123_0, arg_123_1, arg_123_2)
	local var_123_0 = math.min(arg_123_0.state_context.expansion_rule_index or 1, WeaveMatchmakingSettings.num_expansion_rules)
	local var_123_1 = WeaveMatchmakingSettings.expansion_rules[var_123_0].near_filters

	for iter_123_0, iter_123_1 in pairs(var_123_1) do
		local var_123_2 = iter_123_1.value or iter_123_1.fetch_function(arg_123_0._state)

		var_123_2 = iter_123_1.transform_data_function and iter_123_1.transform_data_function(var_123_2) or var_123_2

		local var_123_3 = iter_123_1.comparison

		arg_123_2[#arg_123_2 + 1] = {
			key = iter_123_0,
			value = var_123_2
		}
	end
end

MatchmakingManager.debug_weave_matchmaking = function (arg_124_0, arg_124_1, arg_124_2)
	local var_124_0 = math.min(arg_124_1.expansion_rule_index or 1, WeaveMatchmakingSettings.num_expansion_rules)
	local var_124_1 = WeaveMatchmakingSettings.expansion_rules[var_124_0]

	Debug.text("::::: WeaveMatchmakingDebug :::::")
	Debug.text("")
	Debug.text("Filters:")

	for iter_124_0, iter_124_1 in pairs(var_124_1.filters) do
		local var_124_2 = iter_124_1.fetch_function(arg_124_2)

		var_124_2 = iter_124_1.transform_data_function and iter_124_1.transform_data_function(var_124_2) or var_124_2

		if iter_124_1.debug_format then
			var_124_2 = iter_124_1.debug_format(var_124_2)
		end

		Debug.text(" - " .. iter_124_0 .. ": " .. tostring(var_124_2))
	end

	Debug.text("")
	Debug.text("Near Filters:")

	for iter_124_2, iter_124_3 in pairs(var_124_1.near_filters) do
		local var_124_3 = iter_124_3.fetch_function(arg_124_2)

		var_124_3 = iter_124_3.transform_data_function and iter_124_3.transform_data_function(var_124_3) or var_124_3

		local var_124_4 = iter_124_3.requirements

		if var_124_4 then
			local var_124_5 = math.max(var_124_3 + (var_124_4.range_up or 0), 0)
			local var_124_6 = math.max(var_124_3 - (var_124_4.range_down or 0), 0)

			Debug.text(" * " .. iter_124_2 .. ": " .. tostring(var_124_3))
			Debug.text("         Min compatible value: " .. var_124_6)
			Debug.text("         Max Compatible value:" .. var_124_5)
		else
			Debug.text(" * " .. iter_124_2 .. tostring(var_124_3))
		end
	end

	Debug.text("")
	Debug.text("Expansion Rule: " .. var_124_0)
	Debug.text("")
	Debug.text("")
	Debug.text(":: Other Rules ::")

	local var_124_7 = var_124_1.other_requirements

	if var_124_7 then
		for iter_124_4, iter_124_5 in pairs(var_124_7) do
			Debug.text(" - " .. iter_124_4 .. " = " .. tostring(iter_124_5))
		end
	end
end

MatchmakingManager.rpc_matchmaking_ticket_request = function (arg_125_0, arg_125_1)
	fassert(not arg_125_0.is_server, "Client only RPC")

	if arg_125_0._state.rpc_matchmaking_ticket_request then
		arg_125_0._state:rpc_matchmaking_ticket_request()
	else
		printf("Got rpc_matchmaking_ticket_request in unexpected state: %s", arg_125_0._state.NAME)
	end
end

MatchmakingManager.rpc_matchmaking_ticket_response = function (arg_126_0, arg_126_1, arg_126_2)
	fassert(arg_126_0.is_server, "Server only RPC")

	if arg_126_0._state.rpc_matchmaking_ticket_response then
		arg_126_0._state:rpc_matchmaking_ticket_response(arg_126_1, arg_126_2)
	else
		printf("Got rpc_matchmaking_ticket_response in unexpected state: %s", arg_126_0._state.NAME)
	end
end

MatchmakingManager.rpc_matchmaking_queue_session_data = function (arg_127_0, arg_127_1, arg_127_2, arg_127_3)
	fassert(not arg_127_0.is_server, "Client only RPC")

	if arg_127_0._state.rpc_matchmaking_queue_session_data then
		arg_127_0._state:rpc_matchmaking_queue_session_data(arg_127_2, arg_127_3)
	else
		printf("Got rpc_matchmaking_queue_session_data in unexpected state: %s", arg_127_0._state.NAME)
	end
end

MatchmakingManager.is_lobby_private = function (arg_128_0)
	return arg_128_0.is_private == "true"
end

MatchmakingManager.get_matchmaking_settings_for_mechanism = function (arg_129_0)
	return MatchmakingSettingsOverrides[arg_129_0] or MatchmakingSettings
end

local var_0_10 = {
	MatchmakingStateWaitJoinPlayerHosted = true,
	MatchmakingStatePlayerHostedGame = true
}

MatchmakingManager.is_in_versus_custom_game_lobby = function (arg_130_0)
	if not arg_130_0._state then
		return false
	end

	local var_130_0 = "2"
	local var_130_1 = arg_130_0.lobby:lobby_data("matchmaking_type") == var_130_0
	local var_130_2 = Managers.mechanism:current_mechanism_name() == "versus"

	if arg_130_0._state.NAME == "MatchmakingStateFriendClient" and var_130_1 and var_130_2 then
		return true
	else
		return var_0_10[arg_130_0._state.NAME]
	end
end

MatchmakingManager.is_matchmaking_paused = function (arg_131_0)
	return arg_131_0._pause_matchmaking_until and arg_131_0._pause_matchmaking_until > arg_131_0.t
end

MatchmakingManager.pause_matchmaking_for_seconds = function (arg_132_0, arg_132_1)
	arg_132_0._pause_matchmaking_until = arg_132_0.t + arg_132_1
end

MatchmakingManager.cancel_matchmaking_for_peer = function (arg_133_0, arg_133_1)
	if arg_133_1 then
		arg_133_0.network_transmit:send_rpc("rpc_cancel_matchmaking", arg_133_1)
	end
end
