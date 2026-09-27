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

local scripts_managers_game_mode_mechanisms_reservation_handler_types = require("scripts/managers/game_mode/mechanisms/reservation_handler_types")

DLCUtils.require_list("matchmaking_state_files")

MatchmakingManager = class(MatchmakingManager)

local script_data = script_data
local matchmaking_debug = script_data.matchmaking_debug

matchmaking_debug = matchmaking_debug or Development.parameter("matchmaking_debug")
script_data.matchmaking_debug = matchmaking_debug

local testify = script_data.testify

testify = not testify and require("scripts/managers/matchmaking/matchmaking_manager_testify")

function mm_printf(arg_1_0, ...)
	-- function 1
	if not script_data.matchmaking_debug then
		arg_1_0 = "[Matchmaking] " .. arg_1_0

		printf(arg_1_0, ...)
	end
end

function mm_printf_force(arg_2_0, ...)
	-- function 2
	arg_2_0 = "[Matchmaking] " .. arg_2_0

	printf(arg_2_0, ...)
end

local flag

flag = not Development.parameter("network_timeout_really_long") and 10000 and 0

local flag_2

flag_2 = not DEDICATED_SERVER and true and false

local tbl = {
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
	JOIN_LOBBY_TIME_UNTIL_AUTO_CANCEL = 20 + flag,
	REQUEST_JOIN_LOBBY_REPLY_TIME = 30 + flag,
	REQUEST_PROFILES_REPLY_TIME = 10 + flag
}
local str

if GameSettingsDevelopment.network_mode == "lan" then
	str = "close"
else
	if Application.user_setting("max_quick_play_search_range") ~= "medium" then
		str = Application.user_setting("max_quick_play_search_range")

		if not str then
			-- Nothing
		end
	end

	str = "close" or DefaultUserSettings.get("user_settings", "max_quick_play_search_range")
end

::label_0_0::

tbl.max_distance_filter = str
tbl.allowed_profiles = {
	true,
	true,
	true,
	true,
	true
}
tbl.hero_search_filter = {
	true,
	true,
	true,
	true,
	true
}
tbl.quickplay_level_select_settings = {
	loss_multiplier = 1,
	win_multiplier = 1,
	base_level_weight = 1,
	amount_of_relevant_games = 20,
	progression_multiplier = 10
}
MatchmakingSettings = tbl

local tbl_2 = {}
local tbl_3 = {
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
	LOBBY_FINDER_UPDATE_INTERVAL = 1
}
local str_2

if GameSettingsDevelopment.network_mode == "lan" then
	str_2 = "close"
else
	if Application.user_setting("max_quick_play_search_range") ~= "medium" then
		str_2 = Application.user_setting("max_quick_play_search_range")

		if not str_2 then
			-- Nothing
		end
	end

	str_2 = "close" or DefaultUserSettings.get("user_settings", "max_quick_play_search_range")
end

::label_0_1::

tbl_3.max_distance_filter = str_2
tbl_3.allowed_profiles = {
	true,
	true,
	true,
	true,
	true
}
tbl_3.hero_search_filter = {
	true,
	true,
	true,
	true,
	true
}
tbl_3.quickplay_level_select_settings = {
	loss_multiplier = 1,
	win_multiplier = 1,
	base_level_weight = 1,
	amount_of_relevant_games = 20,
	progression_multiplier = 10
}
tbl_2.versus = tbl_3
MatchmakingSettingsOverrides = tbl_2

local tbl_4 = {
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
local tbl_5 = {
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
local MatchmakingManager = MatchmakingManager
local _broken_lobbies = MatchmakingManager._broken_lobbies

_broken_lobbies = _broken_lobbies or {}
MatchmakingManager._broken_lobbies = _broken_lobbies

local MatchmakingManager_2 = MatchmakingManager
local _broken_servers = MatchmakingManager._broken_servers

_broken_servers = _broken_servers or {}
MatchmakingManager_2._broken_servers = _broken_servers

MatchmakingManager.init = function (self, arg_3_1)
	-- function 3
	self.params = arg_3_1
	self.network_transmit = arg_3_1.network_transmit
	self.lobby = arg_3_1.lobby
	self.peer_id = arg_3_1.peer_id
	self.is_server = arg_3_1.is_server
	self.profile_synchronizer = arg_3_1.profile_synchronizer
	self.statistics_db = arg_3_1.statistics_db
	self.network_server = arg_3_1.network_server
	self._network_hash = self.lobby.network_hash
	self._power_level_timer = 0
	self.party_owned_dlcs = {}
	self._level_weights = {}
	self.peers_to_sync = {}

	local network_options = LobbySetup.network_options()

	if not DEDICATED_SERVER then
		local var_3_1 = LobbyFinder:new(network_options, MatchmakingSettings.MAX_NUM_LOBBIES, true)

		self.lobby_finder = var_3_1
		arg_3_1.lobby_finder = var_3_1
	end

	arg_3_1.network_options = network_options
	arg_3_1.matchmaking_manager = self
	arg_3_1.network_hash = self.lobby.network_hash
	self.state_context = {}
	self.debug = {
		text = "",
		progression = "",
		lobby_timer = 0,
		state = "",
		hero = "",
		difficulty = "",
		level = ""
	}

	if not self.is_server then
		self._joining_this_host_peer_id = self.lobby:lobby_host()

		self:_change_state(MatchmakingStateIdle, self.params, {})

		local get_network_state = Managers.mechanism:network_handler():get_network_state()

		get_network_state:register_callback("server_data_updated", self, "on_client_game_mode_event_data_updated", "game_mode_event_data")

		local get_game_mode_event_data = get_network_state:get_game_mode_event_data()

		if not table.is_empty(get_game_mode_event_data) then
			self:set_game_mode_event_data(get_game_mode_event_data)
		else
			self:clear_game_mode_event_data()
		end
	else
		self:_change_state(MatchmakingStateIdle, self.params, {})
	end

	self:reset_lobby_filters()
	mm_printf("initializing")

	local mm_printf = mm_printf
	local str = "my_peer_id: %s, I am %s"
	local peer_id = Network.peer_id()
	local flag

	flag = not self.is_server and "server" and "client"

	mm_printf(str, peer_id, flag)

	self.lobby_finder_timer = 0
	self.profile_update_time = 0
	self._leader_peer_id = nil
	self.countdown_has_finished = false

	if not arg_3_1.game_mode_event_data then
		self:set_game_mode_event_data(arg_3_1.game_mode_event_data)
	end
end

MatchmakingManager.reset_lobby_filters = function (self)
	-- function 4
	if not DEDICATED_SERVER then
		return
	end

	if not IS_WINDOWS then
		local get_lobby_browser = self.lobby_finder:get_lobby_browser()

		LobbyInternal.clear_filter_requirements(get_lobby_browser)
	else
		LobbyInternal.clear_filter_requirements()
	end
end

MatchmakingManager.game_mode_event_data = function (self)
	-- function 5
	return self._game_mode_event_data
end

MatchmakingManager.have_game_mode_event_data = function (self)
	-- function 6
	local _game_mode_event_data = self._game_mode_event_data

	_game_mode_event_data = not _game_mode_event_data and not table.is_empty(self._game_mode_event_data)

	return _game_mode_event_data
end

MatchmakingManager.set_game_mode_event_data = function (self, arg_7_1)
	-- function 7
	self._game_mode_event_data = arg_7_1

	if not self.is_server then
		local mutators = arg_7_1.mutators

		fassert(#mutators <= NetworkConstants.mutator_array.max_size, "Too many mutators defined for event! (%d|%d)", #mutators, NetworkConstants.mutator_array.max_size)
		self.network_server:get_network_state():set_game_mode_event_data(arg_7_1)
	end
end

MatchmakingManager.clear_game_mode_event_data = function (self)
	-- function 8
	self._game_mode_event_data = nil

	if not self.is_server then
		self.network_server:get_network_state():set_game_mode_event_data({})
	end
end

MatchmakingManager.on_client_game_mode_event_data_updated = function (self, arg_9_1, arg_9_2, arg_9_3, arg_9_4, arg_9_5, arg_9_6, arg_9_7)
	-- function 9
	if not table.is_empty(arg_9_7) then
		self:set_game_mode_event_data(arg_9_7)
	else
		self:clear_game_mode_event_data()
	end
end

MatchmakingManager.set_statistics_db = function (self, arg_10_1)
	-- function 10
	self.statistics_db = arg_10_1
	self.params.statistics_db = arg_10_1
end

MatchmakingManager.set_active_lobby_browser = function (self, arg_11_1)
	-- function 11
	self._lobby_browser = arg_11_1
end

MatchmakingManager.setup_post_init_data = function (self, arg_12_1)
	-- function 12
	self.is_in_inn = arg_12_1.is_in_inn
	self.difficulty_manager = arg_12_1.difficulty
	self.params.hero_spawner_handler = arg_12_1.hero_spawner_handler
	self.params.difficulty = arg_12_1.difficulty
	self.params.wwise_world = arg_12_1.wwise_world

	local is_server = self.is_server

	if not arg_12_1.reset_matchmaking and not is_server then
		self:cancel_matchmaking()
	end

	if not is_server then
		if self.lobby:lobby_data("matchmaking") == "true" then
			self:_change_state(MatchmakingStateIngame, self.params, {})
		else
			self:_change_state(MatchmakingStateIdle, self.params, {})
		end
	end

	local map_save_data = SaveData.map_save_data

	if not map_save_data then
		MatchmakingSettings.host_games = map_save_data.host_option
		MatchmakingSettings.auto_ready = map_save_data.selected_ready_option
	end

	self.profile_update_time = 0
	self._power_level_timer = 0

	self:_update_power_level(0)
end

MatchmakingManager.waystone_is_active = function (self)
	-- function 13
	local _waystone_is_active = self._waystone_is_active

	_waystone_is_active = _waystone_is_active or false

	local _waystone_type = self._waystone_type

	_waystone_type = _waystone_type or 0

	return _waystone_is_active, _waystone_type
end

MatchmakingManager.activate_waystone_portal = function (self, arg_14_1)
	-- function 14
	self._waystone_is_active = arg_14_1 ~= nil
	self._waystone_type = arg_14_1

	local event = Managers.state.event

	if not event then
		event:trigger("activate_waystone_portal", arg_14_1)
	end
end

MatchmakingManager.destroy = function (self)
	-- function 15
	mm_printf("destroying")
	self:_terminate_dangling_matchmaking_lobbies()

	if not self._state and not self._state.on_exit then
		self._state:on_exit()
	end

	if not self.lobby_finder then
		self.lobby_finder:destroy()
	end

	if not self.afk_popup_id then
		Managers.popup:cancel_popup(self.afk_popup_id)

		self.afk_popup_id = nil
	end
end

MatchmakingManager.register_rpcs = function (self, arg_16_1)
	-- function 16
	mm_printf("register rpcs")
	fassert(self.network_event_delegate == nil, "trying to register rpcs without a network_event_delegate..")

	self.network_event_delegate = arg_16_1
	self.params.network_event_delegate = arg_16_1

	arg_16_1:register(self, unpack(tbl_4))
end

MatchmakingManager.unregister_rpcs = function (self)
	-- function 17
	mm_printf("unregister rpcs")
	fassert(self.network_event_delegate ~= nil, "trying to unregister rpcs without a network_event_delegate..")
	self.network_event_delegate:unregister(self)

	self.params.network_event_delegate = nil
	self.network_event_delegate = nil
end

MatchmakingManager._change_state = function (self, arg_18_1, arg_18_2, arg_18_3, arg_18_4)
	-- function 18
	if not (not self._state and self._state.NAME ~= arg_18_1.NAME) then
		mm_printf("Ignoring state transision %s because we are already there", arg_18_1.NAME)

		return
	end

	if not self._state then
		if not self._state.on_exit then
			mm_printf("Exiting state %s with on_exit()", self._state.NAME)
			self._state:on_exit(self._state.NAME)
		else
			mm_printf("Exiting %s", self._state.NAME)
		end
	end

	self._state = arg_18_1:new(arg_18_2, arg_18_4)
	self._state.parent = self._parent
	self.state_context = arg_18_3

	if not self._state.on_enter then
		mm_printf("Entering %s on_enter() ", arg_18_1.NAME)
		self._state:on_enter(arg_18_3)
	else
		mm_printf("Entering %s", arg_18_1.NAME)
	end
end

MatchmakingManager._remove_old_broken_lobbies = function (arg_19_0, arg_19_1)
	-- function 19
	local _broken_lobbies = MatchmakingManager._broken_lobbies

	for k, v in pairs(_broken_lobbies) do
		if v < arg_19_1 then
			mm_printf("Removing broken lobby %s, perhaps it will now work again?!", tostring(k))

			_broken_lobbies[k] = nil
		end
	end

	local _broken_servers = MatchmakingManager._broken_servers

	for k_2, v_2 in pairs(_broken_servers) do
		if v_2 < arg_19_1 then
			mm_printf("Removing broken server %s, perhaps it will now work again?!", k_2)

			_broken_servers[k_2] = nil
		end
	end
end

MatchmakingManager.update = function (self, arg_20_1, arg_20_2)
	-- function 20
	if not self._state then
		local NAME = self._state.NAME
		local update, var_20_2, var_20_3 = self._state:update(arg_20_1, arg_20_2)

		if not update then
			self:_change_state(update, self.params, var_20_2, var_20_3)
		end
	end

	self:_update_power_level(arg_20_2)
	self:_update_afk_logic(arg_20_1, arg_20_2)
	self:_remove_old_broken_lobbies(arg_20_2)

	if not self.is_server and not next(self.peers_to_sync) then
		local is_game_matchmaking, var_20_5 = self:is_game_matchmaking()
		local search_info = self:search_info()
		local mission_id = search_info.mission_id
		local difficulty = search_info.difficulty
		local quick_game = search_info.quick_game

		quick_game = quick_game or false

		local mechanism = search_info.mechanism
		local var_20_11

		if not mission_id then
			var_20_11 = NetworkLookup.mission_ids[mission_id]

			if not var_20_11 then
				-- Nothing
			end
		end

		var_20_11 = NetworkLookup.mission_ids["n/a"]

		do
			local var_20_12
		end

		::label_20_0::

		if not difficulty then
			var_20_12 = NetworkLookup.difficulties[difficulty]

			if not var_20_12 then
				-- Nothing
			end
		end

		var_20_12 = NetworkLookup.difficulties.normal

		do
			local var_20_13
		end

		::label_20_1::

		if not mechanism then
			var_20_13 = NetworkLookup.mechanisms[mechanism]

			if not var_20_13 then
				-- Nothing
			end
		end

		var_20_13 = NetworkLookup.mechanisms.adventure

		::label_20_2::

		for k, v in pairs(self.peers_to_sync) do
			self.peers_to_sync[k] = nil

			local var_20_14 = PEER_ID_TO_CHANNEL[k]

			RPC.rpc_set_matchmaking(var_20_14, is_game_matchmaking, var_20_5, var_20_11, var_20_12, quick_game, var_20_13)
		end
	end

	if not ((DEDICATED_SERVER or not self._joining_this_host_peer_id) and PEER_ID_TO_CHANNEL[self._joining_this_host_peer_id] ~= nil) then
		print("No connection to host, cancelling matchmaking")
		self:cancel_matchmaking()
	end

	if not script_data.testify then
		Testify:poll_requests_through_handler(testify, self)
	end

	self.t = arg_20_2
end

MatchmakingManager._update_afk_logic = function (self, arg_21_1, arg_21_2)
	-- function 21
	local lobby = self.lobby

	if not self.is_server and not lobby:is_joined() then
		local _state = self._state

		_state = not _state and self._state.NAME

		if not (_state == "MatchmakingStateHostGame" or _state == "MatchmakingStateSearchGame") and not self.is_in_inn then
			local num = arg_21_2 - Managers.input.last_active_time
			local flag = num > MatchmakingSettings.afk_warn_timer
			local flag_2 = num > MatchmakingSettings.afk_force_stop_mm_timer
			local flag_3 = _G.Window == nil or Window.flash_window == nil or not Window.has_focus()

			if not (not flag and self.afk_popup_id ~= nil) then
				self.afk_popup_id = Managers.popup:queue_popup(Localize("popup_afk_warning"), Localize("popup_error_topic"), "ok", Localize("button_ok"))

				if not flag_3 then
					Window.flash_window(nil, "start", 5)
				end

				self:send_system_chat_message("popup_afk_warning")
			elseif not flag_2 then
				if not self.afk_popup_id then
					Managers.popup:cancel_popup(self.afk_popup_id)
				end

				self.afk_popup_id = Managers.popup:queue_popup(Localize("popup_afk_mm_cancelled"), Localize("popup_error_topic"), "ok", Localize("button_ok"))

				if not flag_3 then
					Window.flash_window(nil, "start", 1)
				end

				self:send_system_chat_message("popup_afk_mm_cancelled")
				self:cancel_matchmaking()
			end
		end

		if not self.afk_popup_id and not Managers.popup:query_result(self.afk_popup_id) then
			self.afk_popup_id = nil
		end
	end
end

local tbl_6 = {}

MatchmakingManager._update_power_level = function (self, arg_22_1)
	-- function 22
	if arg_22_1 < self._power_level_timer then
		return
	end

	self._power_level_timer = arg_22_1 + 5

	local peer_id = Network.peer_id()
	local is_server = self.is_server
	local local_player = Managers.player:local_player()

	if not local_player then
		local sync_data_active = local_player:sync_data_active()
		local profile_display_name = local_player:profile_display_name()
		local career_name = local_player:career_name()
		local lobby_data = self.lobby:lobby_data("matchmaking_type")
		local flag = not lobby_data and not IS_PS4 and lobby_data and NetworkLookup.matchmaking_types[tonumber(lobby_data)]

		if not sync_data_active and not profile_display_name and not career_name then
			local get_total_power_level = BackendUtils.get_total_power_level(profile_display_name, career_name, flag)

			if get_total_power_level ~= local_player:get_data("power_level") then
				local_player:set_data("power_level", get_total_power_level)
			end

			local best_aquired_power_level = local_player:best_aquired_power_level()

			if best_aquired_power_level ~= local_player:get_data("best_aquired_power_level") then
				local_player:set_data("best_aquired_power_level", best_aquired_power_level)
				local_player:reevaluate_highest_difficulty()
			end
		end
	end

	if not is_server then
		self:_set_power_level()
	end
end

MatchmakingManager.get_average_power_level = function (arg_23_0)
	-- function 23
	local num = 0
	local num_2 = 0
	local human_players = Managers.player:human_players()

	for k, v in pairs(human_players) do
		if not v:sync_data_active() then
			local get_data = v:get_data("power_level")

			if not get_data then
				num = num + get_data
				num_2 = num_2 + 1
			end
		end
	end

	if num_2 == 0 then
		return 0
	end

	return math.floor(num / num_2)
end

MatchmakingManager.get_average_weave_progression = function (arg_24_0)
	-- function 24
	return 1
end

MatchmakingManager.has_required_power_level = function (arg_25_0, arg_25_1, arg_25_2, arg_25_3)
	-- function 25
	local difficulty = arg_25_1.difficulty

	if not difficulty then
		return false
	end

	local var_25_1 = DifficultySettings[difficulty]

	if not var_25_1 then
		return false
	end

	if BackendUtils.get_total_power_level(arg_25_2, arg_25_3) < var_25_1.required_power_level then
		return false
	end

	return true
end

MatchmakingManager._set_power_level = function (self)
	-- function 26
	fassert(self.is_server, "You need to be the server.")

	local get_average_power_level = self:get_average_power_level()
	local get_stored_lobby_data = self.lobby:get_stored_lobby_data()

	if get_average_power_level ~= get_stored_lobby_data.power_level then
		get_stored_lobby_data.power_level = get_average_power_level

		self.lobby:set_lobby_data(get_stored_lobby_data)
	end
end

MatchmakingManager.state = function (self)
	-- function 27
	return self._state
end

MatchmakingManager.gather_party_unlocked_journeys = function (self)
	-- function 28
	local tbl = {}
	local players = Managers.player:players()

	for k, v in pairs(players) do
		tbl[k] = {}
		tbl[k] = LevelUnlockUtils.unlocked_journeys(self.statistics_db, k)
	end

	local tbl_2 = {}

	for i, v_2 in ipairs(AvailableJourneyOrder) do
		local flag = true

		for k_2, v_3 in pairs(tbl) do
			if not table.find(v_3, v_2) then
				flag = false
			end
		end

		if not flag then
			tbl_2[#tbl_2 + 1] = v_2
		end
	end

	return tbl_2
end

MatchmakingManager.party_has_level_unlocked = function (self, arg_29_1, arg_29_2, arg_29_3, arg_29_4)
	-- function 29
	local var_29_0 = LevelSettings[arg_29_1]
	local human_players = Managers.player:human_players()
	local statistics_db = self.statistics_db
	local _level_weights = self._level_weights
	local flag = false

	for k, v in pairs(human_players) do
		local stats_id = v:stats_id()

		if not arg_29_3 and not var_29_0.dlc_name then
			return false
		end

		if not var_29_0.dlc_name then
			if (LevelUnlockUtils.level_unlocked(statistics_db, stats_id, arg_29_1, true) or not arg_29_4) and not var_29_0.not_quickplayable then
				return false
			end
		elseif not LevelUnlockUtils.level_unlocked(statistics_db, stats_id, arg_29_1, true) and not var_29_0.not_quickplayable then
			return false
		end

		if not arg_29_2 then
			if not var_29_0.dlc_name then
				local peer_id = v.peer_id

				if not _level_weights[peer_id] and not _level_weights[peer_id][arg_29_1] then
					flag = true
				end
			else
				flag = true
			end
		end
	end

	if not arg_29_2 then
		return flag
	end

	return true
end

MatchmakingManager._get_unlocked_levels_by_party = function (self, arg_30_1, arg_30_2, arg_30_3, arg_30_4)
	-- function 30
	local tbl = {}

	arg_30_4 = arg_30_4 or {}

	local adventure = UnlockableLevelsByGameMode.adventure

	for i, v in ipairs(adventure) do
		if not (not self:party_has_level_unlocked(v, arg_30_1, arg_30_2, arg_30_3) and table.contains(arg_30_4, v)) then
			tbl[#tbl + 1] = v
		end
	end

	return tbl
end

MatchmakingManager._get_unlocked_levels = function (self, arg_31_1)
	-- function 31
	local tbl = {}
	local statistics_db = self.statistics_db
	local local_player = Managers.player:local_player()
	local adventure = UnlockableLevelsByGameMode.adventure

	for i, v in ipairs(adventure) do
		local stats_id = local_player:stats_id()

		if not LevelUnlockUtils.level_unlocked(statistics_db, stats_id, v) then
			tbl[#tbl + 1] = v
		end
	end

	return tbl
end

MatchmakingManager._get_level_key_from_level_weights = function (self, arg_32_1, arg_32_2)
	-- function 32
	fassert(#arg_32_1 > 0, "Empty level_keys list")

	local _level_weights = self._level_weights
	local tbl = {}
	local num = 0

	for k, v in pairs(_level_weights) do
		num = num + 1
	end

	for k_2 = 1, #arg_32_1 do
		tbl[k_2] = 0

		local var_32_3 = arg_32_1[k_2]

		for k_3, v_2 in pairs(_level_weights) do
			if not v_2[var_32_3] then
				tbl[k_2] = tbl[k_2] + v_2[var_32_3]
			end
		end

		tbl[k_2] = tbl[k_2] / num
	end

	local var_32_4, var_32_5 = LoadedDice.create(tbl, false)
	local roll = LoadedDice.roll(var_32_4, var_32_5)
	local tbl_2 = {}

	for i5 = 1, #tbl do
		local num_2 = 1

		for i6 = 1, #tbl do
			if tbl[i6] > tbl[num_2] then
				num_2 = i6
			end
		end

		local var_32_9 = arg_32_1[num_2]

		if not var_32_9 and tbl[num_2] >= 0 and not arg_32_2 then
			tbl_2[#tbl_2 + 1] = var_32_9
		end

		tbl[num_2] = -1
	end

	local get_hub_level_key = Managers.mechanism:game_mechanism():get_hub_level_key()

	tbl_2[#tbl_2 + 1] = get_hub_level_key

	return arg_32_1[roll], tbl_2
end

MatchmakingManager._calculate_level_weights = function (self, arg_33_1, arg_33_2)
	-- function 33
	fassert(#arg_33_1 > 0, "Empty level_keys list")

	local quickplay_level_select_settings = MatchmakingSettings.quickplay_level_select_settings
	local local_player = Managers.player:local_player()
	local statistics_db = self.statistics_db
	local unlockable_level_keys = NetworkLookup.unlockable_level_keys
	local stats_id = local_player:stats_id()
	local flag = arg_33_2 or {}
	local tbl = {}

	for i = 1, #NetworkLookup.unlockable_level_keys do
		tbl[i] = -1
	end

	for j = 1, #arg_33_1 do
		local var_33_7 = arg_33_1[j]
		local var_33_8 = unlockable_level_keys[var_33_7]
		local progression_multiplier

		tbl[var_33_8], progression_multiplier = quickplay_level_select_settings.base_level_weight, quickplay_level_select_settings.progression_multiplier

		local completed_level_difficulty_index = LevelUnlockUtils.completed_level_difficulty_index(statistics_db, stats_id, var_33_7)

		if not (not completed_level_difficulty_index and completed_level_difficulty_index ~= 0) then
			tbl[var_33_8] = tbl[var_33_8] * progression_multiplier
		end
	end

	local function fn(self, arg_34_1)
		-- function 34
		return self.timestamp > arg_34_1.timestamp
	end

	table.sort(flag, fn)

	local amount_of_relevant_games = quickplay_level_select_settings.amount_of_relevant_games

	while amount_of_relevant_games < #flag do
		flag[#flag] = nil
	end

	local win_multiplier = quickplay_level_select_settings.win_multiplier
	local loss_multiplier = quickplay_level_select_settings.loss_multiplier

	for k = 1, #flag do
		local level_name = flag[k].level_name

		if not level_name and not table.contains(unlockable_level_keys, level_name) then
			local var_33_16 = unlockable_level_keys[level_name]

			if not var_33_16 then
				local flag_2 = not flag[k].game_won and win_multiplier and loss_multiplier

				tbl[var_33_16] = tbl[var_33_16] - flag_2 * (#flag - k + 1) / #flag

				if tbl[var_33_16] < 0 then
					tbl[var_33_16] = 0
				end
			end
		end
	end

	return tbl
end

MatchmakingManager._add_level_weight = function (self, arg_35_1, arg_35_2)
	-- function 35
	local _level_weights = self._level_weights
	local tbl = {}
	local unlockable_level_keys = NetworkLookup.unlockable_level_keys

	for k, v in pairs(arg_35_2) do
		if v ~= -1 then
			tbl[unlockable_level_keys[k]] = v
		end
	end

	_level_weights[arg_35_1] = tbl
end

MatchmakingManager._remove_irrelevant_level_weights = function (self)
	-- function 36
	local _level_weights = self._level_weights
	local human_players = Managers.player:human_players()

	for k, v in pairs(_level_weights) do
		local flag = false

		for k_2, v_2 in pairs(human_players) do
			if k == v_2.peer_id then
				flag = true

				break
			end
		end

		if not flag then
			_level_weights[k] = nil
		end
	end

	self._level_weights = _level_weights
end

MatchmakingManager.get_weighed_random_unlocked_level = function (self, arg_37_1, arg_37_2, arg_37_3)
	-- function 37
	local get_read_only_data = Managers.backend:get_read_only_data("recent_quickplay_games")
	local decode

	if not get_read_only_data then
		decode = cjson.decode(get_read_only_data)

		if not decode then
			-- Nothing
		end
	end

	decode = {}

	::label_37_0::

	local flag = self.state_context.search_config.game_mode == "event"

	if not DEDICATED_SERVER then
		local _get_unlocked_levels = self:_get_unlocked_levels()
		local _calculate_level_weights = self:_calculate_level_weights(_get_unlocked_levels, decode)
		local peer_id = Managers.player:local_player().peer_id

		self:_add_level_weight(peer_id, _calculate_level_weights)
	end

	self:_remove_irrelevant_level_weights()

	local flag_2 = true

	if not not script_data.settings.use_beta_mode then
		flag_2 = not self:_party_has_completed_act("act_4")

		if not arg_37_2 then
			flag_2 = false
		end
	end

	local _get_unlocked_levels_by_party = self:_get_unlocked_levels_by_party(arg_37_1, flag_2, flag, arg_37_3)
	local _get_level_key_from_level_weights, var_37_9 = self:_get_level_key_from_level_weights(_get_unlocked_levels_by_party, flag)

	return _get_level_key_from_level_weights, var_37_9
end

MatchmakingManager._party_has_completed_act = function (self, arg_38_1)
	-- function 38
	local human_players = Managers.player:human_players()
	local statistics_db = self.statistics_db

	for k, v in pairs(human_players) do
		local stats_id = v:stats_id()

		if not LevelUnlockUtils.act_completed(statistics_db, stats_id, arg_38_1) then
			return false
		end
	end

	return true
end

MatchmakingManager.set_matchmaking_data = function (self, arg_39_1, arg_39_2, arg_39_3, arg_39_4, arg_39_5, arg_39_6, arg_39_7, arg_39_8, arg_39_9)
	-- function 39
	local get_current_level_keys = Managers.level_transition_handler:get_current_level_keys()
	local count = #self.lobby:members():get_members()
	local flag = not arg_39_5
	local get_stored_lobby_data = self.lobby:get_stored_lobby_data()

	get_stored_lobby_data.mission_id = get_current_level_keys

	local var_39_4

	if not IS_PS4 then
		var_39_4 = NetworkLookup.matchmaking_types[arg_39_4]

		if not var_39_4 then
			-- Nothing
		end
	end

	var_39_4 = arg_39_4

	::label_39_0::

	get_stored_lobby_data.matchmaking_type = var_39_4
	get_stored_lobby_data.act_key = arg_39_3

	local flag_2

	flag_2 = not flag and "true" and "false"
	get_stored_lobby_data.matchmaking = flag_2
	get_stored_lobby_data.selected_mission_id = arg_39_1 or LevelHelper:current_level_settings().level_id
	get_stored_lobby_data.unique_server_name = LobbyAux.get_unique_server_name()
	get_stored_lobby_data.custom_server_name = "n/a"
	get_stored_lobby_data.host = Network.peer_id()
	get_stored_lobby_data.num_players = count
	get_stored_lobby_data.difficulty = arg_39_2

	local flag_3

	flag_3 = arg_39_9 ~= "weave" or arg_39_6 or not "true" or "false"
	get_stored_lobby_data.weave_quick_game = flag_3
	get_stored_lobby_data.country_code = Managers.account:region()

	local flag_4

	flag_4 = not GameSettingsDevelopment.twitch_enabled and not Managers.twitch:is_connected() and not Managers.twitch:game_mode_supported(arg_39_4, arg_39_2) and "true" and "false"
	get_stored_lobby_data.twitch_enabled = flag_4

	local flag_5

	flag_5 = not arg_39_7 and "true" and "false"
	get_stored_lobby_data.eac_authorized = flag_5
	get_stored_lobby_data.mechanism = arg_39_9
	get_stored_lobby_data.match_started = "true"

	print("[MATCHMAKING] - Hosting game on mission:", get_current_level_keys, arg_39_1, arg_39_8)
	self.lobby:set_lobby_data(get_stored_lobby_data)
end

MatchmakingManager.on_dedicated_server = function (self)
	-- function 40
	return self.lobby:is_dedicated_server()
end

MatchmakingManager.weave_vote_result = function (self, arg_41_1)
	-- function 41
	if self._state.NAME == "MatchmakingStateSearchForWeaveGroup" then
		self._state:weave_vote_result(arg_41_1)
	elseif not (not IS_XB1 and self._state.NAME ~= "MatchmakingStateRequestJoinGame") then
		self._state:weave_vote_result(arg_41_1)
	else
		self:cancel_matchmaking()
	end
end

MatchmakingManager.find_game = function (self, arg_42_1)
	-- function 42
	if not self.is_server then
		local dedicated_server = arg_42_1.dedicated_server

		fassert(dedicated_server ~= nil, "Dedicated server game wasn't set!")

		self.state_context = {}
		self.state_context.search_config = table.clone(arg_42_1)
		self.state_context.started_matchmaking_t = Managers.time:time("main")

		local private_game = arg_42_1.private_game

		fassert(private_game ~= nil, "Private game wasn't set!")

		local quick_game = arg_42_1.quick_game

		fassert(quick_game ~= nil, "Quick game wasn't set!")

		local join_method = arg_42_1.join_method

		if join_method == "party" then
			fassert(arg_42_1.party_lobby_host ~= nil, "Missing party lobby for party join")
		end

		local var_42_4

		if not dedicated_server then
			if join_method == "party" then
				fassert(arg_42_1.wait_for_join_message ~= nil, "Missing wait_for_join_message for dedicated server party join.")

				if not arg_42_1.aws then
					var_42_4 = MatchmakingStateFlexmatchHost
				else
					var_42_4 = MatchmakingStateReserveLobby
				end
			else
				fassert(false, "Join method %s not implemented", join_method)
			end
		else
			local flag = self.network_server:num_active_peers() > 1
			local always_host = arg_42_1.always_host

			if private_game or flag or always_host or not flag_2 then
				if not quick_game and not IS_XB1 then
					local flag_3 = false

					if not Managers.account:offline_mode() then
						flag_3 = false
					end

					local excluded_level_keys = arg_42_1.excluded_level_keys

					self.state_context.search_config.mission_id = self:get_weighed_random_unlocked_level(flag_3, false, excluded_level_keys)
				end

				if not arg_42_1.matchmaking_start_state then
					var_42_4 = rawget(_G, arg_42_1.matchmaking_start_state)
				else
					var_42_4 = MatchmakingStateHostGame
				end
			elseif not arg_42_1.matchmaking_start_state then
				var_42_4 = rawget(_G, arg_42_1.matchmaking_start_state)
			else
				var_42_4 = MatchmakingStateSearchGame
			end
		end

		local search_info = self:search_info()
		local mission_id = search_info.mission_id
		local difficulty = search_info.difficulty
		local quick_game_2 = search_info.quick_game
		local mechanism = search_info.mechanism
		local var_42_14

		if not mission_id then
			var_42_14 = NetworkLookup.mission_ids[mission_id]

			if not var_42_14 then
				-- Nothing
			end
		end

		var_42_14 = NetworkLookup.mission_ids["n/a"]

		do
			local var_42_15
		end

		::label_42_0::

		if not difficulty then
			var_42_15 = NetworkLookup.difficulties[difficulty]

			if not var_42_15 then
				-- Nothing
			end
		end

		var_42_15 = NetworkLookup.difficulties.normal

		do
			local var_42_16
		end

		::label_42_1::

		if not mechanism then
			var_42_16 = NetworkLookup.mechanisms[mechanism]

			if not var_42_16 then
				-- Nothing
			end
		end

		var_42_16 = NetworkLookup.mechanisms.adventure

		::label_42_2::

		self.network_transmit:send_rpc_clients("rpc_set_matchmaking", true, private_game, var_42_14, var_42_15, quick_game_2, var_42_16)
		self:_change_state(var_42_4, self.params, self.state_context)

		self.start_matchmaking_time = 1000000

		Managers.venture.quickplay:set_has_pending_quick_game(quick_game_2)
	end
end

MatchmakingManager._terminate_dangling_matchmaking_lobbies = function (arg_43_0)
	-- function 43
	if not Managers.lobby:query_lobby("matchmaking_join_lobby") then
		Managers.lobby:destroy_lobby("matchmaking_join_lobby")
	end
end

MatchmakingManager.cancel_matchmaking = function (self)
	-- function 44
	mm_printf("Cancelling matchmaking")

	if not self:is_game_matchmaking() then
		if not (self.is_server or self.lobby:is_dedicated_server()) then
			self._joining_this_host_peer_id = nil
		end

		mm_printf("Wasn't really matchmaking to begin with...")

		return
	end

	local party = Managers.party

	if self.is_server or not self.lobby:is_dedicated_server() then
		if not party:is_leader(self.peer_id) then
			self.network_transmit:send_rpc_server("rpc_cancel_matchmaking")
		end

		return
	end

	if IS_WINDOWS or not IS_LINUX then
		local local_player = Managers.player:local_player(1)
		local str = "cancelled"
		local started_matchmaking_t = self.state_context.started_matchmaking_t

		if started_matchmaking_t ~= nil then
			local time = Managers.time:time("main")

			time = time or started_matchmaking_t

			local num = time - started_matchmaking_t
			local strict_matchmaking = self.state_context.search_config.strict_matchmaking

			Managers.telemetry_events:matchmaking_cancelled(local_player, num, self.state_context.search_config)
		end
	end

	self.state_context = {}

	if not self._state then
		if not self._state.terminate then
			self._state:terminate()
		end

		self:_terminate_dangling_matchmaking_lobbies()

		if not self._state.lobby_client then
			self._state.lobby_client:destroy()

			self._state.lobby_client = nil
		end

		if not self._state._lobby_unclaimed then
			self._state._lobby_unclaimed:destroy()

			self._state._lobby_unclaimed = nil
		end

		local ui = Managers.ui

		if not ui:get_active_popup("profile_picker") then
			ui:close_popup("profile_picker")
		end

		local game_mechanism = Managers.mechanism:game_mechanism()

		if not game_mechanism.is_hosting_versus_custom_game and not game_mechanism:is_hosting_versus_custom_game() then
			game_mechanism:set_is_hosting_versus_custom_game(false)
		end

		self:_change_state(MatchmakingStateIdle, self.params, self.state_context, "cancel_matchmaking")
	end

	if not self.is_server then
		local get_stored_lobby_data = self.lobby:get_stored_lobby_data()

		get_stored_lobby_data.matchmaking = "false"
		get_stored_lobby_data.difficulty = "normal"
		get_stored_lobby_data.selected_mission_id = LevelHelper:current_level_settings().level_id
		get_stored_lobby_data.custom_game_settings = "n/a"
		get_stored_lobby_data.custom_server_name = "n/a"

		local var_44_10

		if not IS_PS4 then
			var_44_10 = NetworkLookup.matchmaking_types["n/a"]

			if not var_44_10 then
				-- Nothing
			end
		end

		var_44_10 = "n/a"

		::label_44_0::

		get_stored_lobby_data.matchmaking_type = var_44_10

		self.lobby:set_lobby_data(get_stored_lobby_data)

		local var_44_11 = NetworkLookup.mission_ids["n/a"]
		local normal = NetworkLookup.difficulties.normal
		local adventure = NetworkLookup.mechanisms.adventure
		local flag = false

		Managers.state.difficulty:set_difficulty("normal", 0)

		if not IS_XB1 then
			self.lobby:enable_matchmaking(false)
		end

		self.network_transmit:send_rpc_clients("rpc_set_matchmaking", false, false, var_44_11, normal, flag, adventure)
		self:reset_lobby_filters()

		if not DEDICATED_SERVER then
			party:set_leader(self.network_server.lobby_host:lobby_host())
		end

		Managers.level_transition_handler:clear_next_level()

		local network_handler = Managers.mechanism:network_handler()
		local flag_2 = not network_handler and network_handler:get_match_handler()

		if not flag_2 then
			flag_2:send_rpc_down("rpc_cancel_matchmaking")
		end

		if not Managers.venture.quickplay then
			Managers.venture.quickplay:set_has_pending_quick_game(false)
		end
	else
		party:set_leader(nil)
	end

	self._joining_this_host_peer_id = nil
end

MatchmakingManager.force_start_game = function (self)
	-- function 45
	self:_try_call_state_method("force_start_game")
end

MatchmakingManager.set_selected_level = function (self, arg_46_1)
	-- function 46
	assert(self.is_server)

	local get_stored_lobby_data = self.lobby:get_stored_lobby_data()

	get_stored_lobby_data.selected_mission_id = arg_46_1

	self.lobby:set_lobby_data(get_stored_lobby_data)

	local search_config = self.state_context.search_config

	if not search_config then
		search_config.mission_id = arg_46_1
	end
end

MatchmakingManager.get_selected_level = function (self)
	-- function 47
	return self.lobby:get_stored_lobby_data().selected_mission_id
end

MatchmakingManager.is_player_hosting = function (self)
	-- function 48
	local state_context = self.state_context
	local flag = not state_context and state_context.search_config

	return not flag and flag.is_player_hosted
end

MatchmakingManager.is_matchmaking_versus = function (self)
	-- function 49
	local lobby = self.lobby

	lobby = not lobby and self.lobby:lobby_data("mechanism")

	local lobby_client = self._state.lobby_client

	if not lobby_client then
		lobby_client = Managers.lobby:query_lobby("matchmaking_session_lobby")
		lobby_client = lobby_client or Managers.lobby:query_lobby("matchmaking_join_lobby")
	end

	local flag = not lobby_client and lobby_client:lobby_data("mechanism")
	local flag_2 = self._state.NAME ~= "MatchmakingStateIdle"
	local lobby_2 = self.lobby

	lobby_2 = not lobby_2 and self.lobby:lobby_data("matchmaking") == "true"

	local flag_3 = not lobby_client and lobby_client:lobby_data("matchmaking") == "true"

	return (flag_2 or lobby_2 or not flag_3 or lobby == "versus") and flag == "versus"
end

MatchmakingManager.is_matchmaking_in_inn = function (self)
	-- function 50
	local NAME = self._state.NAME
	local flag = NAME ~= "MatchmakingStateIdle"
	local is_in_inn = self.is_in_inn

	is_in_inn = not is_in_inn and flag

	return is_in_inn, NAME
end

MatchmakingManager.is_game_matchmaking = function (self)
	-- function 51
	local flag = self._state.NAME ~= "MatchmakingStateIdle"
	local state_context = self.state_context

	state_context = not state_context and self.state_context.search_config

	local private_game

	if not state_context then
		private_game = state_context.private_game

		if not private_game then
			-- Nothing
		end
	end

	private_game = false

	::label_51_0::

	local reason = self._state.reason

	return flag, private_game, reason
end

MatchmakingManager.active_game_mode = function (self)
	-- function 52
	local flag = not (self._state.NAME ~= "MatchmakingStateIdle") and self.lobby:lobby_data("matchmaking_type")

	if not IS_PS4 then
		flag = not flag and NetworkLookup.matchmaking_types[tonumber(flag)]
	end

	return flag
end

MatchmakingManager._try_call_state_method = function (self, arg_53_1, ...)
	-- function 53
	local _state = self._state
	local flag = not _state and _state[arg_53_1]

	if not flag then
		flag(_state, ...)
	else
		local NAME

		if not _state then
			NAME = _state.NAME

			if not NAME then
				-- Nothing
			end
		end

		NAME = "none"

		::label_53_0::

		Crashify.print_exception("MatchmakingManager", "Method %q not supported by state %q!", arg_53_1, NAME)
	end
end

MatchmakingManager.rpc_set_matchmaking = function (self, arg_54_1, arg_54_2, arg_54_3, arg_54_4, arg_54_5, arg_54_6, arg_54_7)
	-- function 54
	if not self.is_server then
		mm_printf_force("Set matchmaking=%s, private_game=%s", tostring(arg_54_2), tostring(arg_54_3))

		if not arg_54_2 then
			local var_54_0 = NetworkLookup.mechanisms[arg_54_7]
			local tbl = {
				private_game = arg_54_3,
				mechanism = var_54_0
			}

			self:_change_state(MatchmakingStateFriendClient, self.params, tbl)
		else
			if not Managers.lobby:query_lobby("matchmaking_join_lobby") then
				Managers.lobby:destroy_lobby("matchmaking_join_lobby")
			end

			local _state = self._state

			if not _state.lobby_client then
				_state.lobby_client:destroy()

				_state.lobby_client = nil
			end

			self:_change_state(MatchmakingStateIdle, self.params, {})
		end
	end
end

MatchmakingManager.rpc_cancel_matchmaking = function (self, arg_55_1)
	-- function 55
	if not self.is_server then
		return
	end

	local var_55_0 = CHANNEL_TO_PEER_ID[arg_55_1]

	if not Managers.party:is_leader(var_55_0) then
		return
	end

	self:cancel_matchmaking()
end

MatchmakingManager.rpc_matchmaking_request_profiles_data = function (self, arg_56_1)
	-- function 56
	local var_56_0 = CHANNEL_TO_PEER_ID[arg_56_1]
	local get_stored_lobby_data = self.lobby:get_stored_lobby_data()
	local net_pack_lobby_profile_slots, var_56_3 = ProfileSynchronizer.net_pack_lobby_profile_slots(get_stored_lobby_data)
	local reserved_party_id_by_peer = Managers.mechanism:reserved_party_id_by_peer(var_56_0)

	self.network_transmit:send_rpc("rpc_matchmaking_request_profiles_data_reply", var_56_0, net_pack_lobby_profile_slots, var_56_3, reserved_party_id_by_peer)
end

MatchmakingManager._extract_dlcs = function (arg_57_0, arg_57_1)
	-- function 57
	local tbl = {}

	for i, v in ipairs(arg_57_1) do
		tbl[NetworkLookup.dlcs[v]] = true
	end

	return tbl
end

MatchmakingManager._missing_required_dlc = function (arg_58_0, arg_58_1, arg_58_2, arg_58_3)
	-- function 58
	local flag = not arg_58_1 and MechanismSettings[arg_58_1]

	if not (not flag and not flag.required_dlc and arg_58_3[flag.required_dlc]) then
		return flag.required_dlc
	end

	local flag_2 = not arg_58_2 and DifficultySettings[arg_58_2]

	if not (not flag_2 and not flag_2.dlc_requirement and arg_58_3[flag_2.dlc_requirement]) then
		return flag_2.dlc_requirement
	end

	return nil
end

MatchmakingManager.rpc_matchmaking_request_join_lobby = function (self, arg_59_1, arg_59_2, arg_59_3, arg_59_4)
	-- function 59
	local id = self.lobby:id()
	local var_59_1 = tostring(id)

	arg_59_2 = tostring(arg_59_2)

	local str = "lobby_ok"
	local num = 1
	local var_59_4

	if not DEDICATED_SERVER then
		var_59_4 = var_59_1 == arg_59_2
	else
		var_59_4 = not LobbyInternal.lobby_id_match and LobbyInternal.lobby_id_match(var_59_1, arg_59_2) or var_59_1 == arg_59_2
	end

	local var_59_5 = CHANNEL_TO_PEER_ID[arg_59_1]
	local _extract_dlcs = self:_extract_dlcs(arg_59_4)
	local game_mode = Managers.state.game_mode
	local difficulty = Managers.state.difficulty
	local mechanism = Managers.mechanism
	local game_mechanism = mechanism:game_mechanism()
	local flag = not game_mode and game_mode:game_mode_key()
	local flag_2 = not difficulty and difficulty:get_difficulty()
	local is_venture_over = mechanism:is_venture_over()
	local mechanism_try_call, var_59_15 = mechanism:mechanism_try_call("is_hosting_versus_custom_game")
	local var_59_16
	local var_59_17

	if not DEDICATED_SERVER then
		local var_59_18 = tbl_5[self._state.NAME]

		if var_59_18 == "adventure" then
			var_59_17 = true
		elseif var_59_18 == "versus" then
			var_59_16 = true
		end
	end

	local lobby_data = self.lobby:lobby_data("matchmaking")
	local lobby_data_2 = self.lobby:lobby_data("mechanism")
	local flag_3 = false

	if not DEDICATED_SERVER then
		flag_3 = not IS_CONSOLE and true and LobbyInternal.is_friend(var_59_5)
	end

	local var_59_22

	if (DEDICATED_SERVER or not IS_WINDOWS) and not rawget(_G, "Friends") then
		local relationship = Friends.relationship(var_59_5)

		var_59_22 = relationship == 5 or relationship == 6
	end

	local flag_4 = not not flag_3 or self:_missing_required_dlc(lobby_data_2, flag_2, _extract_dlcs)
	local user_setting = Application.user_setting("friend_join_mode")

	if not var_59_4 then
		str = "lobby_id_mismatch"
	elseif not var_59_22 then
		str = "user_blocked"
	elseif not is_venture_over then
		str = "game_mode_ended"
	elseif not (DEDICATED_SERVER or not arg_59_3 and user_setting ~= "host_friends_only" or flag_3) then
		str = "friend_joining_friends_only"
	elseif not ((DEDICATED_SERVER or not arg_59_3) and user_setting ~= "disabled") then
		str = "friend_joining_disabled"
	elseif not var_59_15 and arg_59_3 and not flag_3 then
		str = "custom_lobby_ok"
	elseif not (DEDICATED_SERVER or flag_3 or arg_59_3 or var_59_17) then
		str = "not_searching_for_players"
	elseif not var_59_16 then
		str = "is_searching_for_dedicated_server"
	elseif not Managers.deed:has_deed() then
		str = "lobby_has_active_deed"
	elseif not flag_4 then
		num = NetworkLookup.dlcs[flag_4]
		str = "dlc_required"
	elseif not Development.parameter("allow_weave_joining") then
		if not (flag ~= "weave" or lobby_data ~= "false") then
			if not Managers.weave:get_player_ids()[var_59_5] then
				str = "cannot_join_weave"
			end
		elseif not (lobby_data_2 ~= "weave" or lobby_data ~= "false") then
			local loading_context = Boot.loading_context
			local flag_5 = not loading_context and loading_context.weave_data
			local flag_6 = not flag_5 and flag_5.player_ids

			if not flag_6 then
				if not flag_6[var_59_5] then
					str = "cannot_join_weave"
				end
			else
				str = "cannot_join_weave"
			end
		end
	end

	mm_printf_force("Got request to join matchmaking lobby %s from %s, replying %s", arg_59_2, var_59_5, str)

	local var_59_29 = NetworkLookup.game_ping_reply[str]

	self.network_transmit:send_rpc("rpc_matchmaking_request_join_lobby_reply", var_59_5, var_59_29, num)
end

MatchmakingManager.rpc_matchmaking_request_profile = function (self, arg_60_1, arg_60_2, arg_60_3)
	-- function 60
	local var_60_0 = CHANNEL_TO_PEER_ID[arg_60_1]
	local try_reserve_profile_for_peer_by_mechanism, var_60_2 = Managers.mechanism:try_reserve_profile_for_peer_by_mechanism(var_60_0, arg_60_2, arg_60_3, false)

	if not (not var_60_2 and var_60_2 == arg_60_2) then
		try_reserve_profile_for_peer_by_mechanism = not try_reserve_profile_for_peer_by_mechanism and "previous_profile_accepted" and "profile_declined"
	else
		try_reserve_profile_for_peer_by_mechanism = not try_reserve_profile_for_peer_by_mechanism and "profile_accepted" and "profile_declined"
	end

	if not Managers.state.game_mode and not Managers.state.game_mode:hero_is_locked(arg_60_2) then
		try_reserve_profile_for_peer_by_mechanism = "profile_locked"
	end

	local var_60_3 = NetworkLookup.request_profile_replies[try_reserve_profile_for_peer_by_mechanism]

	self.network_transmit:send_rpc("rpc_matchmaking_request_profile_reply", var_60_0, arg_60_2, var_60_3)
end

MatchmakingManager.current_state = function (self)
	-- function 61
	local NAME

	if not self._state then
		NAME = self._state.NAME

		if not NAME then
			-- Nothing
		end
	end

	NAME = "none"

	::label_61_0::

	return NAME
end

MatchmakingManager.get_transition = function (self)
	-- function 62
	if not self._state and not self._state.get_transition then
		local get_transition, var_62_1 = self._state:get_transition()

		if get_transition ~= nil then
			return get_transition, var_62_1
		end
	end

	if not self.lobby_to_join then
		return "join_lobby", self.lobby_to_join
	end
end

MatchmakingManager.loading_context = function (self)
	-- function 63
	if not self._state and not self._state.loading_context then
		return self._state:loading_context()
	end
end

MatchmakingManager.active_lobby = function (self)
	-- function 64
	if not self._state and not self._state.active_lobby then
		return self._state:active_lobby()
	end

	return self.lobby
end

MatchmakingManager.hero_available_in_lobby_data = function (self, arg_65_1, arg_65_2, arg_65_3)
	-- function 65
	local search_config = self.state_context.search_config

	if not search_config and not search_config.allow_duplicate_heroes then
		return true
	end

	if not ProfileSynchronizer.is_free_in_lobby(arg_65_1, arg_65_2, arg_65_3) then
		return true
	end

	if not Managers.state.game_mode:hero_is_locked(arg_65_1) then
		return false
	end

	local local_player = Managers.player:local_player()
	local peer_id = local_player.peer_id
	local profile_id = local_player:profile_id()
	local owner_in_lobby, var_65_5 = ProfileSynchronizer.owner_in_lobby(arg_65_1, arg_65_2, arg_65_3)

	if not (owner_in_lobby ~= peer_id or var_65_5 ~= profile_id) then
		return true
	end

	return false
end

MatchmakingManager.lobby_match = function (self, arg_66_1, arg_66_2, arg_66_3, arg_66_4, arg_66_5, arg_66_6, arg_66_7, arg_66_8)
	-- function 66
	local id = arg_66_1.id

	if not self:lobby_listed_as_broken(id) then
		return false, "lobby listed as broken"
	end

	if arg_66_1.host == arg_66_6 then
		return false, "players own lobby"
	end

	if not IS_WINDOWS then
		local deserialize_lobby_reservation_data = LobbyAux.deserialize_lobby_reservation_data(arg_66_1)

		for i = 1, #deserialize_lobby_reservation_data do
			local var_66_2 = deserialize_lobby_reservation_data[i]

			for j = 1, #var_66_2 do
				local peer_id = var_66_2[j].peer_id
				local var_66_4 = rawget(_G, "Friends")

				var_66_4 = not var_66_4 and Friends.relationship(peer_id)

				if not (var_66_4 == 5 or var_66_4 == 6) then
					return false, "user blocked"
				end
			end
		end
	end

	if arg_66_1.twitch_enabled == "true" then
		return false, "twitch_mode"
	end

	if not (arg_66_1.matchmaking == "false" or arg_66_1.valid) then
		return false, "lobby is not valid"
	end

	if arg_66_1.mission_id == "prologue" then
		return false, "in prologue"
	end

	if not (arg_66_1.mechanism ~= "deus" or arg_66_3 ~= "any") then
		local selected_mission_id = arg_66_1.selected_mission_id

		if not DeusJourneySettings[selected_mission_id] then
			local stats_id = Managers.player:local_player():stats_id()
			local unlocked_journeys = LevelUnlockUtils.unlocked_journeys(self.statistics_db, stats_id)

			if not table.find(unlocked_journeys, selected_mission_id) then
				return false, "Journey is not unlocked"
			end
		end
	end

	if not (not arg_66_3 and arg_66_3 == "any") then
		local flag = false
		local str = "<no lobby level>"

		if not arg_66_1.selected_mission_id then
			flag = arg_66_1.selected_mission_id == arg_66_3
			str = string.format("(%s ~= %s)", arg_66_3, arg_66_1.selected_mission_id)
		elseif not arg_66_1.mission_id then
			flag = arg_66_1.mission_id == arg_66_3
			str = string.format("(%s ~= %s)", arg_66_3, arg_66_1.mission_id)
		end

		if not flag then
			return false, "wrong mission " .. str
		end
	end

	if not (not arg_66_2 and arg_66_1.act_key == arg_66_2) then
		return false, "wrong act"
	end

	if arg_66_5 == "event" then
		local matchmaking_type = arg_66_1.matchmaking_type

		if not IS_PS4 then
			local var_66_11 = tonumber(matchmaking_type)

			matchmaking_type = not var_66_11 and NetworkLookup.matchmaking_types[var_66_11]
		end

		if arg_66_5 ~= matchmaking_type then
			return false, "wrong game mode"
		end
	end

	if arg_66_8 == "weave" then
		if arg_66_7 ~= "false" then
			local selected_mission_id_2 = arg_66_1.selected_mission_id

			selected_mission_id_2 = selected_mission_id_2 or arg_66_1.mission_id

			if arg_66_7 ~= selected_mission_id_2 then
				return false, "wrong weave name"
			end
		elseif arg_66_1.weave_quick_game ~= "true" then
			return false, "ranked weave"
		end
	end

	if not (not arg_66_4 and arg_66_1.difficulty == arg_66_4) then
		return false, "wrong difficulty"
	end

	local get_matchmaking_settings_for_mechanism = self.get_matchmaking_settings_for_mechanism(arg_66_8)
	local num_players = arg_66_1.num_players

	num_players = not num_players and tonumber(arg_66_1.num_players)

	local max_number_of_players = self.state_context.search_config.max_number_of_players

	max_number_of_players = max_number_of_players or get_matchmaking_settings_for_mechanism.MAX_NUMBER_OF_PLAYERS

	if not (not num_players and num_players < max_number_of_players) then
		return false, "no empty slot"
	end

	if not (not script_data.unique_server_name and arg_66_1.unique_server_name == script_data.unique_server_name) then
		Debug.text("Ignoring lobby due to mismatching unique_server_name")

		return false, "mismatching unique_server_name"
	end

	return true
end

MatchmakingManager.add_broken_lobby_client = function (arg_67_0, arg_67_1, arg_67_2, arg_67_3)
	-- function 67
	if arg_67_1 == nil then
		return
	end

	local huge

	if not arg_67_3 then
		huge = math.huge

		if not huge then
			-- Nothing
		end
	end

	huge = 20

	::label_67_0::

	local num = arg_67_2 + huge

	if not arg_67_1:is_dedicated_server() then
		local ip_address = arg_67_1:ip_address()

		mm_printf("Adding broken server: %s Due to bad connection or something: %s, ignoring it for %d seconds", ip_address, tostring(arg_67_3), huge)

		MatchmakingManager._broken_servers[ip_address] = num

		print("Broken server, printing callstack!", Script.callstack())
	else
		local id = arg_67_1:id()

		mm_printf("Adding broken lobby: %s Due to bad connection or something: %s, ignoring it for %d seconds", tostring(id), tostring(arg_67_3), huge)

		MatchmakingManager._broken_lobbies[id] = num
	end
end

MatchmakingManager.lobby_listed_as_broken = function (arg_68_0, arg_68_1)
	-- function 68
	return MatchmakingManager._broken_lobbies[arg_68_1]
end

MatchmakingManager.server_listed_as_broken = function (arg_69_0, arg_69_1)
	-- function 69
	return MatchmakingManager._broken_servers[arg_69_1]
end

MatchmakingManager.broken_server_map = function (arg_70_0)
	-- function 70
	return MatchmakingManager._broken_servers
end

MatchmakingManager.rpc_matchmaking_request_join_lobby_reply = function (self, arg_71_1, arg_71_2, arg_71_3)
	-- function 71
	if not (not self._state and self._state.NAME ~= "MatchmakingStateRequestJoinGame") then
		self._state:rpc_matchmaking_request_join_lobby_reply(arg_71_1, arg_71_2, arg_71_3)
	else
		local NAME

		if not self._state then
			NAME = self._state.NAME

			if not NAME then
				-- Nothing
			end
		end

		NAME = "none"

		::label_71_0::

		mm_printf_force("rpc_matchmaking_request_join_lobby_reply, got this in wrong state current_state:%s", NAME)
	end
end

MatchmakingManager.rpc_notify_connected = function (self, arg_72_1)
	-- function 72
	local NAME

	if not self._state then
		NAME = self._state.NAME

		if not NAME then
			-- Nothing
		end
	end

	NAME = "none"

	::label_72_0::

	if not (NAME == "MatchmakingStateRequestJoinGame" or NAME == "MatchmakingStateRequestGameServerOwnership" or NAME ~= "MatchmakingStateReserveSlotsPlayerHosted") then
		self._state:rpc_notify_connected(arg_72_1)
	else
		mm_printf_force("rpc_notify_connected, got this in wrong state current_state:%s", NAME)
	end
end

MatchmakingManager.rpc_flexmatch_game_session_id_request = function (self, arg_73_1)
	-- function 73
	if not self._state.rpc_flexmatch_game_session_id_request then
		self._state:rpc_flexmatch_game_session_id_request(arg_73_1)
	else
		local NAME

		if not self._state then
			NAME = self._state.NAME

			if not NAME then
				-- Nothing
			end
		end

		NAME = "none"

		::label_73_0::

		mm_printf_force("rpc_flexmatch_game_session_id_request, got this in wrong state current_state:%s", NAME)
	end
end

MatchmakingManager.rpc_matchmaking_join_game = function (self, arg_74_1)
	-- function 74
	if not (not self._state and self._state.NAME == "MatchmakingStateJoinGame" or self._state.NAME ~= "MatchmakingStateWaitJoinPlayerHosted") then
		self._state:rpc_matchmaking_join_game(arg_74_1)
	else
		local NAME

		if not self._state then
			NAME = self._state.NAME

			if not NAME then
				-- Nothing
			end
		end

		NAME = "none"

		::label_74_0::

		mm_printf_force("rpc_matchmaking_join_game, got this in wrong state current_state:%s", NAME)
	end
end

MatchmakingManager.rpc_matchmaking_request_profile_reply = function (self, arg_75_1, arg_75_2, arg_75_3)
	-- function 75
	if not (not self._state and self._state.NAME ~= "MatchmakingStateJoinGame") then
		self._state:rpc_matchmaking_request_profile_reply(arg_75_1, arg_75_2, arg_75_3)
	else
		local NAME

		if not self._state then
			NAME = self._state.NAME

			if not NAME then
				-- Nothing
			end
		end

		NAME = "none"

		::label_75_0::

		mm_printf_force("rpc_matchmaking_request_profile_reply, got this in wrong state current_state:%s", NAME)
	end
end

MatchmakingManager.rpc_matchmaking_request_profiles_data_reply = function (self, arg_76_1, arg_76_2, arg_76_3, arg_76_4)
	-- function 76
	if not (not self._state and self._state.NAME ~= "MatchmakingStateRequestProfiles") then
		self._state:rpc_matchmaking_request_profiles_data_reply(arg_76_1, arg_76_2, arg_76_3, arg_76_4)
	else
		local NAME

		if not self._state then
			NAME = self._state.NAME

			if not NAME then
				-- Nothing
			end
		end

		NAME = "none"

		::label_76_0::

		mm_printf_force("rpc_matchmaking_request_profiles_data_reply, got this in wrong state current_state:%s", NAME)
	end
end

MatchmakingManager.rpc_matchmaking_request_selected_level = function (self, arg_77_1)
	-- function 77
	if not (not self._state and self._state.NAME ~= "MatchmakingStateHostGame") then
		local selected_mission_id = self.lobby:get_stored_lobby_data().selected_mission_id
		local var_77_1 = NetworkLookup.mission_ids[selected_mission_id]

		RPC.rpc_matchmaking_request_selected_level_reply(arg_77_1, var_77_1)
	else
		local NAME

		if not self._state then
			NAME = self._state.NAME

			if not NAME then
				-- Nothing
			end
		end

		NAME = "none"

		::label_77_0::

		mm_printf_force("rpc_matchmaking_request_selected_level, got this in wrong state current_state:%s", NAME)
	end
end

MatchmakingManager.rpc_matchmaking_request_selected_level_reply = function (self, arg_78_1, arg_78_2)
	-- function 78
	if not (not self._state and self._state.NAME ~= "MatchmakingStateFriendClient") then
		self._state:rpc_matchmaking_request_selected_level_reply(arg_78_1, arg_78_2)
	else
		local NAME

		if not self._state then
			NAME = self._state.NAME

			if not NAME then
				-- Nothing
			end
		end

		NAME = "none"

		::label_78_0::

		mm_printf_force("rpc_matchmaking_request_selected_level_reply, got this in wrong state current_state:%s", NAME)
	end
end

MatchmakingManager.rpc_matchmaking_request_selected_difficulty = function (self, arg_79_1)
	-- function 79
	if not (not self._state and self._state.NAME ~= "MatchmakingStateHostGame") then
		local difficulty = self.lobby:get_stored_lobby_data().difficulty
		local var_79_1 = NetworkLookup.difficulties[difficulty]

		RPC.rpc_matchmaking_request_selected_difficulty_reply(arg_79_1, var_79_1)
	else
		local NAME

		if not self._state then
			NAME = self._state.NAME

			if not NAME then
				-- Nothing
			end
		end

		NAME = "none"

		::label_79_0::

		mm_printf_force("rpc_matchmaking_request_selected_difficulty, got this in wrong state current_state:%s", NAME)
	end
end

MatchmakingManager.rpc_matchmaking_request_selected_difficulty_reply = function (self, arg_80_1, arg_80_2)
	-- function 80
	if not (not self._state and self._state.NAME ~= "MatchmakingStateFriendClient") then
		self._state:rpc_matchmaking_request_selected_difficulty_reply(arg_80_1, arg_80_2)
	else
		local NAME

		if not self._state then
			NAME = self._state.NAME

			if not NAME then
				-- Nothing
			end
		end

		NAME = "none"

		::label_80_0::

		mm_printf_force("rpc_matchmaking_request_selected_difficulty_reply, got this in wrong state current_state:%s", NAME)
	end
end

MatchmakingManager.rpc_matchmaking_request_status_message = function (self, arg_81_1)
	-- function 81
	if not (not self._state and self._state.NAME ~= "MatchmakingStateHostGame") then
		local current_status_message = self.current_status_message

		if not current_status_message then
			return
		end

		RPC.rpc_matchmaking_status_message(arg_81_1, current_status_message)
	else
		local NAME

		if not self._state then
			NAME = self._state.NAME

			if not NAME then
				-- Nothing
			end
		end

		NAME = "none"

		::label_81_0::

		mm_printf_force("rpc_matchmaking_request_status_message, got this in wrong state current_state:%s", NAME)
	end
end

MatchmakingManager.rpc_matchmaking_status_message = function (self, arg_82_1, arg_82_2)
	-- function 82
	if not (not self._state and self._state.NAME ~= "MatchmakingStateFriendClient") then
		self._state:rpc_matchmaking_status_message(arg_82_1, arg_82_2)
	else
		local NAME

		if not self._state then
			NAME = self._state.NAME

			if not NAME then
				-- Nothing
			end
		end

		NAME = "none"

		::label_82_0::

		mm_printf_force("rpc_matchmaking_status_message, got this in wrong state current_state:%s", NAME)
	end
end

MatchmakingManager.rpc_game_server_set_group_leader = function (arg_83_0, arg_83_1, arg_83_2)
	-- function 83
	if arg_83_2 == "0" then
		arg_83_2 = nil
	end

	Managers.party:set_leader(arg_83_2)
end

MatchmakingManager.rpc_matchmaking_broadcast_game_server_ip_address = function (self, arg_84_1, arg_84_2)
	-- function 84
	if not (not self._state and self._state.NAME ~= "MatchmakingStateFriendClient") then
		self._state:rpc_matchmaking_broadcast_game_server_ip_address(arg_84_1, arg_84_2)
	else
		local NAME

		if not self._state then
			NAME = self._state.NAME

			if not NAME then
				-- Nothing
			end
		end

		NAME = "none"

		::label_84_0::

		mm_printf_force("rpc_matchmaking_broadcast_game_server_ip_address, got this in wrong state current_state:%s", NAME)
	end
end

MatchmakingManager.rpc_set_quick_game = function (self, arg_85_1, arg_85_2)
	-- function 85
	self:set_quick_game(arg_85_2)
end

MatchmakingManager.rpc_start_game_countdown_finished = function (self, arg_86_1)
	-- function 86
	self:countdown_completed()
end

MatchmakingManager.rpc_matchmaking_sync_quickplay_data = function (self, arg_87_1, arg_87_2)
	-- function 87
	local var_87_0 = CHANNEL_TO_PEER_ID[arg_87_1]

	self:_add_level_weight(var_87_0, arg_87_2)
end

MatchmakingManager.rpc_matchmaking_request_quickplay_data = function (self, arg_88_1)
	-- function 88
	local _get_unlocked_levels = self:_get_unlocked_levels()
	local get_read_only_data = Managers.backend:get_read_only_data("recent_quickplay_games")
	local decode

	if not get_read_only_data then
		decode = cjson.decode(get_read_only_data)

		if not decode then
			-- Nothing
		end
	end

	decode = {}

	::label_88_0::

	local flag = false
	local _calculate_level_weights = self:_calculate_level_weights(_get_unlocked_levels, decode, flag)

	self.network_transmit:send_rpc_server("rpc_matchmaking_sync_quickplay_data", _calculate_level_weights)
end

MatchmakingManager.rpc_matchmaking_verify_dlc = function (self, arg_89_1, arg_89_2)
	-- function 89
	if not self._state then
		local flag = true

		for k, v in pairs(arg_89_2) do
			local var_89_1 = NetworkLookup.dlcs[v]

			if not Managers.unlock:is_dlc_unlocked(var_89_1) then
				flag = false

				break
			end
		end

		Managers.state.network.network_transmit:send_rpc_server("rpc_matchmaking_verify_dlc_reply", flag)
	end
end

MatchmakingManager.rpc_matchmaking_verify_dlc_reply = function (self, arg_90_1, arg_90_2)
	-- function 90
	if not (not self._state and self._state.NAME ~= "MatchmakingStateStartGame") then
		self._state:rpc_matchmaking_verify_dlc_reply(arg_90_1, arg_90_2)
	else
		local NAME

		if not self._state then
			NAME = self._state.NAME

			if not NAME then
				-- Nothing
			end
		end

		NAME = "none"

		::label_90_0::

		mm_printf_force("rpc_matchmaking_verify_dlc_reply, got this in wrong state current_state:%s", NAME)
	end
end

MatchmakingManager.rpc_join_reserved_game_server = function (self, arg_91_1)
	-- function 91
	local NAME

	if not self._state then
		NAME = self._state.NAME

		if not NAME then
			-- Nothing
		end
	end

	NAME = "none"

	::label_91_0::

	if NAME == "MatchmakingStateReserveLobby" then
		self._state:rpc_join_reserved_game_server(arg_91_1)
	else
		mm_printf_force("rpc_join_reserved_game_server, got this in wrong state current_state:%s", NAME)
	end
end

MatchmakingManager.rpc_matchmaking_client_joined_player_hosted = function (self, arg_92_1, arg_92_2)
	-- function 92
	local NAME

	if not self._state then
		NAME = self._state.NAME

		if not NAME then
			-- Nothing
		end
	end

	NAME = "none"

	::label_92_0::

	if NAME == "MatchmakingStateReserveSlotsPlayerHosted" then
		self._state:rpc_matchmaking_client_joined_player_hosted(arg_92_1, arg_92_2)
	else
		mm_printf_force("rpc_matchmaking_client_joined_player_hosted, got this in wrong state current_state:%s", NAME)
	end
end

MatchmakingManager.rpc_matchmaking_reservation_success = function (self, arg_93_1, arg_93_2)
	-- function 93
	local NAME

	if not self._state then
		NAME = self._state.NAME

		if not NAME then
			-- Nothing
		end
	end

	NAME = "none"

	::label_93_0::

	if NAME == "MatchmakingStateReserveSlotsPlayerHosted" then
		self._state:rpc_matchmaking_reservation_success(arg_93_1, arg_93_2)
	else
		mm_printf_force("rpc_matchmaking_reservation_success, got this in wrong state current_state:%s", NAME)
	end
end

MatchmakingManager.rpc_matchmaking_request_reserve_slots = function (self, arg_94_1, arg_94_2, arg_94_3)
	-- function 94
	local id = self.lobby:id()
	local var_94_1 = CHANNEL_TO_PEER_ID[arg_94_1]
	local str = "lobby_ok"
	local num = 1

	if not (tostring(id) == tostring(arg_94_2)) then
		str = "lobby_id_mismatch"
	else
		local game_mechanism = Managers.mechanism:game_mechanism()
		local get_slot_reservation_handler = game_mechanism:get_slot_reservation_handler(Network.peer_id(), scripts_managers_game_mode_mechanisms_reservation_handler_types.pending_custom_game)

		get_slot_reservation_handler = get_slot_reservation_handler or game_mechanism:get_slot_reservation_handler(Network.peer_id(), scripts_managers_game_mode_mechanisms_reservation_handler_types.session)

		local try_reserve_slots, var_94_7 = get_slot_reservation_handler:try_reserve_slots(var_94_1, arg_94_3)

		if not try_reserve_slots then
			str = "server_full"
		else
			num = var_94_7
		end
	end

	local var_94_8 = NetworkLookup.game_ping_reply[str]

	self.network_transmit:send_rpc("rpc_matchmaking_request_reserve_slots_reply", var_94_1, var_94_8, num)
end

MatchmakingManager.rpc_matchmaking_request_reserve_slots_reply = function (self, arg_95_1, arg_95_2, arg_95_3)
	-- function 95
	local NAME

	if not self._state then
		NAME = self._state.NAME

		if not NAME then
			-- Nothing
		end
	end

	NAME = "none"

	::label_95_0::

	if NAME == "MatchmakingStateReserveSlotsPlayerHosted" then
		self._state:rpc_matchmaking_request_reserve_slots_reply(arg_95_1, arg_95_2, arg_95_3)
	else
		mm_printf_force("rpc_matchmaking_request_reserve_slots_reply, got this in wrong state current_state:%s", NAME)
	end
end

MatchmakingManager.rpc_matchmaking_client_join_player_hosted = function (self, arg_96_1, arg_96_2)
	-- function 96
	self:_change_state(MatchmakingStateReserveSlotsPlayerHosted, self.params, {
		join_lobby_data = {
			id = arg_96_2
		}
	})
end

MatchmakingManager.hot_join_sync = function (self, arg_97_1)
	-- function 97
	self.peers_to_sync[arg_97_1] = true

	local var_97_0 = PEER_ID_TO_CHANNEL[arg_97_1]

	RPC.rpc_set_client_game_privacy(var_97_0, self:is_game_private())
	RPC.rpc_matchmaking_request_quickplay_data(var_97_0)
end

MatchmakingManager.countdown_completed = function (self)
	-- function 98
	local is_leader

	if not (self.countdown_has_finished or self.is_server) then
		is_leader = Managers.party:is_leader(self.peer_id)

		if not is_leader then
			is_leader = self:on_dedicated_server()
		end
	else
		is_leader = false
	end

	if false then
		is_leader = true
	end

	if not is_leader then
		self.countdown_has_finished = false

		self.network_transmit:send_rpc_server("rpc_start_game_countdown_finished")

		return
	end

	self.countdown_has_finished = true
end

MatchmakingManager.set_status_message = function (self, arg_99_1)
	-- function 99
	if arg_99_1 == self.current_status_message then
		return
	end

	self.current_status_message = arg_99_1

	if not self.is_server then
		self.network_transmit:send_rpc_clients("rpc_matchmaking_status_message", arg_99_1)
	end
end

MatchmakingManager.setup_filter_requirements = function (self, arg_100_1, arg_100_2, arg_100_3, arg_100_4)
	-- function 100
	arg_100_3.network_hash = {
		comparison = "equal",
		value = self._network_hash
	}
	arg_100_3.matchmaking = {
		value = "true",
		comparison = "equal"
	}

	local tbl = {
		free_slots = arg_100_1,
		distance_filter = arg_100_2,
		filters = table.clone(arg_100_3),
		near_filters = table.clone(arg_100_4)
	}

	self.lobby_finder:add_filter_requirements(tbl)
end

MatchmakingManager.request_join_lobby = function (self, arg_101_1, arg_101_2)
	-- function 101
	local flag = not arg_101_2 and arg_101_2.friend_join

	if not (self._state.NAME == "MatchmakingStateIdle" or flag) then
		mm_printf("trying to join lobby from lobby browser in wrong state %s", self._state.NAME)

		return
	end

	local MatchmakingStateRequestJoinGame = MatchmakingStateRequestJoinGame
	local mechanism = arg_101_1.mechanism
	local matchmaking = arg_101_1.matchmaking

	if not (mechanism ~= "versus" or matchmaking == "true" or matchmaking ~= "searching") then
		local matchmaking_type = arg_101_1.matchmaking_type
		local var_101_5 = NetworkLookup.matchmaking_types[tonumber(matchmaking_type)]
		local var_101_6
		local game_mode = Managers.state.game_mode

		if (not game_mode and game_mode:game_mode_key()) ~= "inn_vs" then
			local str = "vs_player_hosted_lobby_wrong_mechanism_error"

			self:send_system_chat_message(str)

			return
		end

		if matchmaking == "searching" then
			local str_2 = "matchmaking_status_join_game_failed_is_searching_for_dedicated_server"

			self:send_system_chat_message(str_2)

			return
		end

		if var_101_5 == "custom" then
			MatchmakingStateRequestJoinGame = MatchmakingStateReserveSlotsPlayerHosted
		else
			MatchmakingStateRequestJoinGame = MatchmakingStateReserveLobby
		end
	end

	if not matchmaking and self._state.NAME == "MatchmakingStateIdle" or not flag then
		local str_3 = "matchmaking_status_join_game_failed_" .. "match_in_progress"

		self:send_system_chat_message(str_3)

		return
	end

	mm_printf("Joining lobby %s.", tostring(arg_101_1))

	local tbl = {
		join_by_lobby_browser = true,
		join_lobby_data = arg_101_1
	}

	table.merge(tbl, arg_101_2 or {})

	self.started_matchmaking_t = Managers.time:time("main")

	table.dump(tbl, "STATE_CONTEXT", 2)
	self:_change_state(MatchmakingStateRequestJoinGame, self.params, tbl)
end

MatchmakingManager.is_joining_friend = function (self)
	-- function 102
	return self.state_context.friend_join
end

MatchmakingManager.cancel_join_lobby = function (self, arg_103_1, arg_103_2)
	-- function 103
	self.state_context = {}

	if not self._lobby_browser then
		self._lobby_browser:cancel_join_lobby(arg_103_1)
	end

	if arg_103_1 ~= "dlc_required" or not arg_103_2 then
		local var_103_0 = NetworkLookup.dlcs[arg_103_2]

		Managers.state.event:trigger("ui_show_popup", var_103_0, "upsell")
	elseif arg_103_1 == "failure_start_join_server_difficulty_requirements_failed" then
		local var_103_1 = Localize(arg_103_1)
		local format = string.format(var_103_1, arg_103_2 or "")

		Managers.simple_popup:queue_popup(format, Localize("popup_error_topic"), "ok", Localize("popup_choice_ok"))
	elseif arg_103_1 ~= "cancelled" then
		local str = "matchmaking_status_join_game_failed_" .. arg_103_1

		Managers.simple_popup:queue_popup(Localize(str), Localize("popup_error_topic"), "ok", Localize("popup_choice_ok"))
	end
end

MatchmakingManager.allowed_to_initiate_join_lobby = function (self)
	-- function 104
	return self:_matchmaking_status() == "idle"
end

MatchmakingManager.allow_cancel_matchmaking = function (self)
	-- function 105
	local _state = self._state
	local query_lobby = Managers.lobby:query_lobby("matchmaking_join_lobby")

	if not query_lobby then
		query_lobby = Managers.lobby:query_lobby("matchmaking_join_lobby")
		query_lobby = query_lobby or _state.lobby_client
	end

	if not query_lobby then
		if not query_lobby:is_joined() then
			return true
		end
	else
		local NAME = _state.NAME

		if not (NAME == "MatchmakingStateIdle" or NAME == "MatchmakingStateIngame") then
			return true
		end
	end
end

MatchmakingManager.send_system_chat_message = function (arg_106_0, arg_106_1, arg_106_2)
	-- function 106
	local num = 1

	arg_106_2 = arg_106_2 or ""

	local flag = true
	local flag_2 = false

	Managers.chat:send_system_chat_message(num, arg_106_1, arg_106_2, flag_2, flag)
end

function DEBUG_LOBBIES()
	-- function 107
	local get_stored_lobby_data = Managers.matchmaking.lobby:get_stored_lobby_data()

	table.dump(get_stored_lobby_data, "lobby_data")

	local _state = Managers.matchmaking._state

	if not _state then
		_state = Managers.matchmaking._state.active_lobby
		_state = not _state and Managers.matchmaking._state:active_lobby()
	end

	local flag = not _state and _state:get_stored_lobby_data()

	if not flag then
		table.dump(flag, "active_lobby_data")
	else
		print("no active_lobby")
	end
end

MatchmakingManager.rpc_set_client_game_privacy = function (self, arg_108_1, arg_108_2)
	-- function 108
	local lobby = self.lobby

	if not self.is_server then
		local get_stored_lobby_data = lobby:get_stored_lobby_data()
		local flag

		flag = not arg_108_2 and "true" and "false"
		get_stored_lobby_data.is_private = flag
	end
end

MatchmakingManager.set_game_privacy = function (self, arg_109_1)
	-- function 109
	local lobby = self.lobby

	if not self.is_server and not lobby:is_joined() then
		local flag

		flag = not arg_109_1 and "true" and "false"

		self:_set_lobby_data(lobby, "is_private", flag)
		Managers.state.network.network_transmit:send_rpc_clients("rpc_set_client_game_privacy", arg_109_1)
	end
end

MatchmakingManager.set_versus_custom_lobby_data = function (self, arg_110_1)
	-- function 110
	if not (not self.is_server and not self.lobby:is_joined() and Managers.mechanism:current_mechanism_name() ~= "versus") then
		self:_set_lobby_data(self.lobby, "custom_game_settings", arg_110_1)
	end
end

MatchmakingManager.set_in_progress_game_privacy = function (self, arg_111_1)
	-- function 111
	local lobby = self.lobby

	if not self.is_server and not lobby:is_joined() then
		self:set_game_privacy(arg_111_1)

		local flag

		flag = not arg_111_1 and "false" and "true"

		self:_set_lobby_data(lobby, "matchmaking", flag)

		if not arg_111_1 then
			self:_change_state(MatchmakingStateIngame, self.params, {})
		else
			self:_change_state(MatchmakingStateIdle, self.params, {})
		end
	end
end

MatchmakingManager.set_lobby_data_match_started = function (self, arg_112_1)
	-- function 112
	local lobby = self.lobby

	if not self.is_server and not lobby:is_joined() then
		local flag

		flag = not arg_112_1 and "true" and "false"

		self:_set_lobby_data(lobby, "match_started", flag)
	end
end

MatchmakingManager._set_lobby_data = function (arg_113_0, arg_113_1, arg_113_2, arg_113_3)
	-- function 113
	local get_stored_lobby_data = arg_113_1:get_stored_lobby_data()

	get_stored_lobby_data[arg_113_2] = arg_113_3

	arg_113_1:set_lobby_data(get_stored_lobby_data)
end

MatchmakingManager.is_game_private = function (self)
	-- function 114
	return self.lobby:get_stored_lobby_data().is_private == "true"
end

MatchmakingManager._matchmaking_status = function (self)
	-- function 115
	local NAME = self._state.NAME

	if NAME == "MatchmakingStateIdle" then
		return "idle"
	elseif NAME == "MatchmakingStateSearchGame" then
		return "searching_for_game"
	elseif not (NAME == "MatchmakingStateReserveLobby" or NAME ~= "MatchmakingStateFlexmatchHost") then
		return "searching_for_servers"
	elseif not (NAME == "MatchmakingStateHostGame" or NAME == "MatchmakingStateWaitForCountdown" or NAME == "MatchmakingStateStartGame" or NAME == "MatchmakingStateRequestGameServerOwnership" or NAME ~= "MatchmakingStatePlayerHostedGame") then
		return "hosting_game"
	elseif not (NAME == "MatchmakingStateRequestJoinGame" or NAME == "MatchmakingStateRequestProfiles" or NAME ~= "MatchmakingStateJoinGame") then
		return "joining_game"
	elseif NAME == "MatchmakingStateFriendClient" then
		local lobby = self.lobby

		lobby = not lobby and self.lobby:lobby_data("mechanism")

		if lobby == "versus" then
			return "searching_for_servers"
		end

		return "waiting_for_game_start"
	else
		return NAME
	end
end

MatchmakingManager.are_all_players_spawned = function (self)
	-- function 116
	local get_members = self.lobby:members():get_members()
	local player = Managers.player

	for i = 1, #get_members do
		local var_116_2 = get_members[i]
		local player_from_peer_id = player:player_from_peer_id(var_116_2)

		if not player_from_peer_id then
			return false
		end

		local player_unit = player_from_peer_id.player_unit

		if not Unit.alive(player_unit) then
			return false
		end
	end

	return true
end

MatchmakingManager.get_reserved_slots = function (self)
	-- function 117
	local search_config = self.state_context.search_config
	local num = 0
	local var_117_2

	if not search_config and not search_config.is_player_hosted then
		num = self.lobby:lobby_data("reserved_slots_mask") or num
		var_117_2 = self.lobby:lobby_data("mechanism")
	else
		local lobby_client = self._state.lobby_client

		if not lobby_client then
			lobby_client = Managers.lobby:query_lobby("matchmaking_join_lobby")

			if not lobby_client then
				lobby_client = Managers.lobby:query_lobby("matchmaking_join_lobby")
				lobby_client = lobby_client or self.lobby
			end
		end

		if not lobby_client then
			return
		end

		num = lobby_client:lobby_data("reserved_slots_mask") or num
		var_117_2 = lobby_client:lobby_data("mechanism")
	end

	return self:_decode_reserved_slots_mask(num, var_117_2)
end

local tbl_7 = {}
local tbl_8 = {}

MatchmakingManager._decode_reserved_slots_mask = function (arg_118_0, arg_118_1, arg_118_2)
	-- function 118
	table.clear(tbl_7)
	table.clear(tbl_8)

	if not arg_118_2 then
		return tbl_8
	end

	local parties = Managers.party:parties()

	for k, v in pairs(parties) do
		if not v.game_participating then
			tbl_7[k] = v.num_slots
		end
	end

	local num = 0

	for i, v_2 in ipairs(tbl_7) do
		for i4 = 1, v_2 do
			local flag

			flag = not (bit.band(arg_118_1, bit.lshift(1, num + (i4 - 1))) > 0) or not 1 or 0

			local var_118_3 = tbl_8
			local var_118_4 = tbl_8[i]

			var_118_4 = var_118_4 or 0
			var_118_3[i] = var_118_4 + flag
		end

		num = num + v_2
	end

	return tbl_8
end

local tbl_9 = {}

MatchmakingManager.search_info = function (self)
	-- function 119
	table.clear(tbl_9)

	if not self.is_server then
		local search_config = self.state_context.search_config

		if not search_config then
			tbl_9.mission_id = search_config.mission_id
			tbl_9.difficulty = search_config.difficulty
			tbl_9.quick_game = search_config.quick_game
			tbl_9.matchmaking_type = search_config.matchmaking_type
			tbl_9.mechanism = search_config.mechanism
		else
			local lobby_client = self._state.lobby_client

			if not lobby_client then
				lobby_client = Managers.lobby:query_lobby("matchmaking_join_lobby")
				lobby_client = lobby_client or Managers.lobby:query_lobby("matchmaking_join_lobby")
			end

			if not lobby_client then
				local lobby_data = lobby_client:lobby_data("mission_id")
				local lobby_data_2 = lobby_client:lobby_data("difficulty")
				local lobby_data_3 = lobby_client:lobby_data("matchmaking_type")

				if not (lobby_client:lobby_data("weave_quick_game") == "true") then
					-- Nothing
				end

				::label_119_0::

				local has_pending_quick_game = Managers.venture.quickplay:has_pending_quick_game()

				has_pending_quick_game = has_pending_quick_game or Managers.venture.quickplay:is_quick_game()

				::label_119_1::

				local lobby_data_4 = lobby_client:lobby_data("mechanism")

				tbl_9.mission_id = lobby_data
				tbl_9.difficulty = lobby_data_2
				tbl_9.quick_game = has_pending_quick_game
				tbl_9.mechanism = lobby_data_4
				tbl_9.matchmaking_type = not IS_PS4 and lobby_data_3 and not lobby_data_3 or NetworkLookup.matchmaking_types[tonumber(lobby_data_3)]
			end
		end
	else
		local lobby = self.lobby
		local lobby_data_5 = lobby:lobby_data("selected_mission_id")
		local lobby_data_6 = lobby:lobby_data("difficulty")
		local lobby_data_7 = lobby:lobby_data("matchmaking_type")
		local lobby_data_8 = lobby:lobby_data("mechanism")

		if not (lobby:lobby_data("weave_quick_game") == "true") then
			-- Nothing
		end

		::label_119_2::

		local has_pending_quick_game_2 = Managers.venture.quickplay:has_pending_quick_game()

		has_pending_quick_game_2 = has_pending_quick_game_2 or Managers.venture.quickplay:is_quick_game()

		::label_119_3::

		tbl_9.mission_id = lobby_data_5
		tbl_9.difficulty = lobby_data_6
		tbl_9.quick_game = has_pending_quick_game_2
		tbl_9.mechanism = lobby_data_8
		tbl_9.matchmaking_type = not IS_PS4 and lobby_data_7 and not lobby_data_7 or NetworkLookup.matchmaking_types[tonumber(lobby_data_7)]
	end

	local _matchmaking_status = self:_matchmaking_status()

	tbl_9.status = _matchmaking_status

	return tbl_9
end

MatchmakingManager.setup_weave_filters = function (self, arg_120_1, arg_120_2)
	-- function 120
	local min = math.min
	local expansion_rule_index = self.state_context.expansion_rule_index

	expansion_rule_index = expansion_rule_index or 1

	local var_120_2 = min(expansion_rule_index, WeaveMatchmakingSettings.num_expansion_rules)
	local filters = WeaveMatchmakingSettings.expansion_rules[var_120_2].filters

	for k, v in pairs(filters) do
		local value = v.value

		value = value or v.fetch_function(self._state)
		value = not v.transform_data_function and v.transform_data_function(value) and value

		local comparison = v.comparison

		arg_120_2[k] = {
			value = value,
			comparison = comparison
		}
	end
end

MatchmakingManager.reset_joining = function (self)
	-- function 121
	self._joining_this_host_peer_id = nil
end

MatchmakingManager.on_leave_game = function (self)
	-- function 122
	local NAME = self._state.NAME

	if not (NAME == "MatchmakingStateReserveLobby" or NAME == "MatchmakingStateReserveSlotsPlayerHosted" or NAME ~= "MatchmakingStatePlayerHostedGame") then
		self:cancel_matchmaking()
	end
end

MatchmakingManager.setup_weave_near_filters = function (self, arg_123_1, arg_123_2)
	-- function 123
	local min = math.min
	local expansion_rule_index = self.state_context.expansion_rule_index

	expansion_rule_index = expansion_rule_index or 1

	local var_123_2 = min(expansion_rule_index, WeaveMatchmakingSettings.num_expansion_rules)
	local near_filters = WeaveMatchmakingSettings.expansion_rules[var_123_2].near_filters

	for k, v in pairs(near_filters) do
		local value = v.value

		value = value or v.fetch_function(self._state)
		value = not v.transform_data_function and v.transform_data_function(value) and value

		local comparison = v.comparison

		arg_123_2[#arg_123_2 + 1] = {
			key = k,
			value = value
		}
	end
end

MatchmakingManager.debug_weave_matchmaking = function (arg_124_0, arg_124_1, arg_124_2)
	-- function 124
	local min = math.min
	local expansion_rule_index = arg_124_1.expansion_rule_index

	expansion_rule_index = expansion_rule_index or 1

	local var_124_2 = min(expansion_rule_index, WeaveMatchmakingSettings.num_expansion_rules)
	local var_124_3 = WeaveMatchmakingSettings.expansion_rules[var_124_2]

	Debug.text("::::: WeaveMatchmakingDebug :::::")
	Debug.text("")
	Debug.text("Filters:")

	for k, v in pairs(var_124_3.filters) do
		local fetch_function = v.fetch_function(arg_124_2)

		fetch_function = not v.transform_data_function and v.transform_data_function(fetch_function) and fetch_function

		if not v.debug_format then
			fetch_function = v.debug_format(fetch_function)
		end

		Debug.text(" - " .. k .. ": " .. tostring(fetch_function))
	end

	Debug.text("")
	Debug.text("Near Filters:")

	for k_2, v_2 in pairs(var_124_3.near_filters) do
		local fetch_function_2 = v_2.fetch_function(arg_124_2)

		fetch_function_2 = not v_2.transform_data_function and v_2.transform_data_function(fetch_function_2) and fetch_function_2

		local requirements = v_2.requirements

		if not requirements then
			local max = math.max
			local range_up = requirements.range_up

			range_up = range_up or 0

			local var_124_9 = max(fetch_function_2 + range_up, 0)
			local max_2 = math.max
			local range_down = requirements.range_down

			range_down = range_down or 0

			local var_124_12 = max_2(fetch_function_2 - range_down, 0)

			Debug.text(" * " .. k_2 .. ": " .. tostring(fetch_function_2))
			Debug.text("         Min compatible value: " .. var_124_12)
			Debug.text("         Max Compatible value:" .. var_124_9)
		else
			Debug.text(" * " .. k_2 .. tostring(fetch_function_2))
		end
	end

	Debug.text("")
	Debug.text("Expansion Rule: " .. var_124_2)
	Debug.text("")
	Debug.text("")
	Debug.text(":: Other Rules ::")

	local other_requirements = var_124_3.other_requirements

	if not other_requirements then
		for k_3, v_3 in pairs(other_requirements) do
			Debug.text(" - " .. k_3 .. " = " .. tostring(v_3))
		end
	end
end

MatchmakingManager.rpc_matchmaking_ticket_request = function (self, arg_125_1)
	-- function 125
	fassert(not self.is_server, "Client only RPC")

	if not self._state.rpc_matchmaking_ticket_request then
		self._state:rpc_matchmaking_ticket_request()
	else
		printf("Got rpc_matchmaking_ticket_request in unexpected state: %s", self._state.NAME)
	end
end

MatchmakingManager.rpc_matchmaking_ticket_response = function (self, arg_126_1, arg_126_2)
	-- function 126
	fassert(self.is_server, "Server only RPC")

	if not self._state.rpc_matchmaking_ticket_response then
		self._state:rpc_matchmaking_ticket_response(arg_126_1, arg_126_2)
	else
		printf("Got rpc_matchmaking_ticket_response in unexpected state: %s", self._state.NAME)
	end
end

MatchmakingManager.rpc_matchmaking_queue_session_data = function (self, arg_127_1, arg_127_2, arg_127_3)
	-- function 127
	fassert(not self.is_server, "Client only RPC")

	if not self._state.rpc_matchmaking_queue_session_data then
		self._state:rpc_matchmaking_queue_session_data(arg_127_2, arg_127_3)
	else
		printf("Got rpc_matchmaking_queue_session_data in unexpected state: %s", self._state.NAME)
	end
end

MatchmakingManager.is_lobby_private = function (self)
	-- function 128
	return self.is_private == "true"
end

MatchmakingManager.get_matchmaking_settings_for_mechanism = function (arg_129_0)
	-- function 129
	local var_129_0 = MatchmakingSettingsOverrides[arg_129_0]

	var_129_0 = var_129_0 or MatchmakingSettings

	return var_129_0
end

local tbl_10 = {
	MatchmakingStateWaitJoinPlayerHosted = true,
	MatchmakingStatePlayerHostedGame = true
}

MatchmakingManager.is_in_versus_custom_game_lobby = function (self)
	-- function 130
	if not self._state then
		return false
	end

	local str = "2"
	local flag = self.lobby:lobby_data("matchmaking_type") == str
	local flag_2 = Managers.mechanism:current_mechanism_name() == "versus"

	if (self._state.NAME ~= "MatchmakingStateFriendClient" or not flag) and not flag_2 then
		return true
	else
		return tbl_10[self._state.NAME]
	end
end

MatchmakingManager.is_matchmaking_paused = function (self)
	-- function 131
	local _pause_matchmaking_until = self._pause_matchmaking_until

	_pause_matchmaking_until = not _pause_matchmaking_until and self._pause_matchmaking_until > self.t

	return _pause_matchmaking_until
end

MatchmakingManager.pause_matchmaking_for_seconds = function (self, arg_132_1)
	-- function 132
	self._pause_matchmaking_until = self.t + arg_132_1
end

MatchmakingManager.cancel_matchmaking_for_peer = function (self, arg_133_1)
	-- function 133
	if not arg_133_1 then
		self.network_transmit:send_rpc("rpc_cancel_matchmaking", arg_133_1)
	end
end
