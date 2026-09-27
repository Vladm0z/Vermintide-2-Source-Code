-- chunkname: @scripts/ui/dlc_versus/views/start_game_view/windows/start_game_window_versus_lobby_browser.lua

local var_0_0 = local_require("scripts/ui/views/start_game_view/windows/definitions/start_game_window_lobby_browser_console_definitions")

StartGameWindowVersusLobbyBrowser = class(StartGameWindowVersusLobbyBrowser, StartGameWindowLobbyBrowserConsole)
StartGameWindowVersusLobbyBrowser.NAME = "StartGameWindowVersusLobbyBrowser"

local tbl = {
	project_hash = "bulldozer",
	config_file_name = "global",
	lobby_port = GameSettingsDevelopment.network_port,
	server_port = GameSettingsDevelopment.network_port,
	max_members = MatchmakingSettingsOverrides.versus.MAX_NUMBER_OF_PLAYERS
}

StartGameWindowVersusLobbyBrowser.on_enter = function (self, arg_1_1, arg_1_2)
	-- function 1
	print("[StartGameWindowVersusLobbyBrowser] Enter Substate StartGameWindowVersusLobbyBrowser")

	self._max_num_members = MatchmakingSettingsOverrides.versus.MAX_NUMBER_OF_PLAYERS
	self._parent = arg_1_1.parent

	local ingame_ui_context = arg_1_1.ingame_ui_context

	self._statistics_db = ingame_ui_context.statistics_db

	local local_player = Managers.player:local_player()

	self._profile_name = local_player:profile_display_name()
	self._career_name = local_player:career_name()
	self._stats_id = local_player:stats_id()
	self._friend_names = {}

	local LobbyFinder = LobbyFinder
	local var_1_3 = LobbyFinder
	local new = LobbyFinder.new
	local var_1_5 = tbl
	local MAX_NUM_LOBBIES = MatchmakingSettings.MAX_NUM_LOBBIES
	local IS_WINDOWS = IS_WINDOWS

	IS_WINDOWS = not IS_WINDOWS and true
	self._lobby_finder = new(var_1_3, var_1_5, MAX_NUM_LOBBIES, IS_WINDOWS)

	local flag = false

	self._current_weave = LevelUnlockUtils.current_weave(self._statistics_db, self._stats_id, flag)
	self._game_mode_data = var_0_0.setup_game_mode_data(self._statistics_db, self._stats_id)
	self._lobby_browser_console_ui = LobbyBrowserConsoleUI:new(self, ingame_ui_context, self._game_mode_data, var_0_0.show_lobbies_table, var_0_0.distance_table)

	self:reset_filters("versus")
	Managers.matchmaking:set_active_lobby_browser(self)
	self:_populate_lobby_list()
	self:change_generic_actions("default_lobby_browser")
	self:set_input_description(nil)
	Managers.account:get_friends(2000, callback(self, "cb_friends_collected"))
end

StartGameWindowVersusLobbyBrowser._join = function (self, arg_2_1, arg_2_2)
	-- function 2
	Managers.matchmaking:request_join_lobby(arg_2_1, arg_2_2)

	self.join_lobby_data_id = arg_2_1.id

	self._parent:set_layout_by_name("versus_player_hosted_lobby")
end

StartGameWindowVersusLobbyBrowser.is_lobby_joinable = function (arg_3_0, arg_3_1)
	-- function 3
	if not Managers.player.is_server then
		return false, "matchmaking_promotion_popup_no_wom_title"
	end

	return StartGameWindowVersusLobbyBrowser.super.is_lobby_joinable(arg_3_0, arg_3_1)
end

StartGameWindowVersusLobbyBrowser.update = function (self, arg_4_1, arg_4_2)
	-- function 4
	self._lobby_finder:update(arg_4_1)

	if not self:_is_refreshing() then
		if not self._do_populate then
			self:_populate_lobby_list()
		end

		self._searching = false
		self._do_populate = false
	end

	self:_update_auto_refresh(arg_4_1)

	local _lobby_browser_console_ui = self._lobby_browser_console_ui
	local var_4_1 = _lobby_browser_console_ui
	local update = _lobby_browser_console_ui.update
	local var_4_3 = arg_4_1
	local var_4_4 = arg_4_2
	local _searching = self._searching

	_searching = not _searching and self._do_populate

	update(var_4_1, var_4_3, var_4_4, _searching)
end
