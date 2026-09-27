-- chunkname: @scripts/ui/views/start_game_view/windows/start_game_window_weave_lobby_browser_console.lua

local var_0_0 = local_require("scripts/ui/views/start_game_view/windows/definitions/start_game_window_lobby_browser_console_definitions")

StartGameWindowWeaveLobbyBrowserConsole = class(StartGameWindowWeaveLobbyBrowserConsole, StartGameWindowLobbyBrowserConsole)
StartGameWindowWeaveLobbyBrowserConsole.NAME = "StartGameWindowWeaveLobbyBrowserConsole"

local tbl = {
	project_hash = "bulldozer",
	config_file_name = "global",
	lobby_port = GameSettingsDevelopment.network_port,
	server_port = GameSettingsDevelopment.network_port,
	max_members = MatchmakingSettings.MAX_NUMBER_OF_PLAYERS
}

StartGameWindowWeaveLobbyBrowserConsole.on_enter = function (self, arg_1_1, arg_1_2)
	-- function 1
	print("[StartGameWindowWeaveLobbyBrowserConsole] Enter Substate StartGameWindowWeaveLobbyBrowserConsole")

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

	self:reset_filters("weave")
	Managers.matchmaking:set_active_lobby_browser(self)
	self:_populate_lobby_list()
	self:change_generic_actions("default_lobby_browser")
	self:set_input_description(nil)
	Managers.account:get_friends(2000, callback(self, "cb_friends_collected"))
end
