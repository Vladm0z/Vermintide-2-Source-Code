-- chunkname: @scripts/ui/dlc_versus/views/start_game_view/windows/start_game_window_versus_lobby_browser.lua

local var_0_0 = local_require("scripts/ui/views/start_game_view/windows/definitions/start_game_window_lobby_browser_console_definitions")

StartGameWindowVersusLobbyBrowser = class(StartGameWindowVersusLobbyBrowser, StartGameWindowLobbyBrowserConsole)
StartGameWindowVersusLobbyBrowser.NAME = "StartGameWindowVersusLobbyBrowser"

local var_0_1 = {
	project_hash = "bulldozer",
	config_file_name = "global",
	lobby_port = GameSettingsDevelopment.network_port,
	server_port = GameSettingsDevelopment.network_port,
	max_members = MatchmakingSettingsOverrides.versus.MAX_NUMBER_OF_PLAYERS
}

function StartGameWindowVersusLobbyBrowser.on_enter(arg_1_0, arg_1_1, arg_1_2)
	print("[StartGameWindowVersusLobbyBrowser] Enter Substate StartGameWindowVersusLobbyBrowser")

	arg_1_0._max_num_members = MatchmakingSettingsOverrides.versus.MAX_NUMBER_OF_PLAYERS
	arg_1_0._parent = arg_1_1.parent

	local var_1_0 = arg_1_1.ingame_ui_context

	arg_1_0._statistics_db = var_1_0.statistics_db

	local var_1_1 = Managers.player:local_player()

	arg_1_0._profile_name = var_1_1:profile_display_name()
	arg_1_0._career_name = var_1_1:career_name()
	arg_1_0._stats_id = var_1_1:stats_id()
	arg_1_0._friend_names = {}
	arg_1_0._lobby_finder = LobbyFinder:new(var_0_1, MatchmakingSettings.MAX_NUM_LOBBIES, IS_WINDOWS and true)

	local var_1_2 = false

	arg_1_0._current_weave = LevelUnlockUtils.current_weave(arg_1_0._statistics_db, arg_1_0._stats_id, var_1_2)
	arg_1_0._game_mode_data = var_0_0.setup_game_mode_data(arg_1_0._statistics_db, arg_1_0._stats_id)
	arg_1_0._lobby_browser_console_ui = LobbyBrowserConsoleUI:new(arg_1_0, var_1_0, arg_1_0._game_mode_data, var_0_0.show_lobbies_table, var_0_0.distance_table)

	arg_1_0:reset_filters("versus")
	Managers.matchmaking:set_active_lobby_browser(arg_1_0)
	arg_1_0:_populate_lobby_list()
	arg_1_0:change_generic_actions("default_lobby_browser")
	arg_1_0:set_input_description(nil)
	Managers.account:get_friends(2000, callback(arg_1_0, "cb_friends_collected"))
end

function StartGameWindowVersusLobbyBrowser._join(arg_2_0, arg_2_1, arg_2_2)
	Managers.matchmaking:request_join_lobby(arg_2_1, arg_2_2)

	arg_2_0.join_lobby_data_id = arg_2_1.id

	arg_2_0._parent:set_layout_by_name("versus_player_hosted_lobby")
end

function StartGameWindowVersusLobbyBrowser.is_lobby_joinable(arg_3_0, arg_3_1)
	if not Managers.player.is_server then
		return false, "matchmaking_promotion_popup_no_wom_title"
	end

	return StartGameWindowVersusLobbyBrowser.super.is_lobby_joinable(arg_3_0, arg_3_1)
end

function StartGameWindowVersusLobbyBrowser.update(arg_4_0, arg_4_1, arg_4_2)
	arg_4_0._lobby_finder:update(arg_4_1)

	if not arg_4_0:_is_refreshing() then
		if arg_4_0._do_populate then
			arg_4_0:_populate_lobby_list()
		end

		arg_4_0._searching = false
		arg_4_0._do_populate = false
	end

	arg_4_0:_update_auto_refresh(arg_4_1)
	arg_4_0._lobby_browser_console_ui:update(arg_4_1, arg_4_2, arg_4_0._searching and arg_4_0._do_populate)
end
