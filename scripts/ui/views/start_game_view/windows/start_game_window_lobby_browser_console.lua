-- chunkname: @scripts/ui/views/start_game_view/windows/start_game_window_lobby_browser_console.lua

require("scripts/ui/views/lobby_browser_console_ui")
require("scripts/network/lobby_aux")

local var_0_0 = local_require("scripts/ui/views/start_game_view/windows/definitions/start_game_window_lobby_browser_console_definitions")
local var_0_1 = 0
local var_0_2 = {
	project_hash = "bulldozer",
	config_file_name = "global",
	lobby_port = GameSettingsDevelopment.network_port,
	server_port = GameSettingsDevelopment.network_port,
	max_members = MatchmakingSettings.MAX_NUMBER_OF_PLAYERS
}
local var_0_3 = {
	weave = "lb_game_type_weave",
	deed = "lb_game_type_deed",
	event = "lb_game_type_event",
	custom = "lb_game_type_custom",
	demo = "lb_game_type_none",
	adventure = "lb_game_type_quick_play",
	tutorial = "lb_game_type_prologue",
	twitch = "lb_game_type_twitch",
	["n/a"] = "lb_game_type_none",
	any = "lobby_browser_mission"
}
local var_0_4 = {
	deus = "area_selection_morris_name",
	adventure = "area_selection_campaign",
	weave = "menu_weave_area_no_wom_title",
	versus = "vs_ui_versus_tag",
	any = "lobby_browser_mission"
}

StartGameWindowLobbyBrowserConsole = class(StartGameWindowLobbyBrowserConsole)
StartGameWindowLobbyBrowserConsole.NAME = "StartGameWindowLobbyBrowserConsole"

StartGameWindowLobbyBrowserConsole.on_enter = function (arg_1_0, arg_1_1, arg_1_2)
	print("[StartGameWindow] Enter Substate StartGameWindowLobbyBrowserConsole")

	arg_1_0._parent = arg_1_1.parent

	local var_1_0 = arg_1_1.ingame_ui_context

	arg_1_0._statistics_db = var_1_0.statistics_db

	local var_1_1 = Managers.player:local_player()

	arg_1_0._profile_name = var_1_1:profile_display_name()
	arg_1_0._career_name = var_1_1:career_name()
	arg_1_0._stats_id = var_1_1:stats_id()
	arg_1_0._friend_names = {}
	arg_1_0._lobby_finder = LobbyFinder:new(var_0_2, MatchmakingSettings.MAX_NUM_LOBBIES, IS_WINDOWS and true)
	arg_1_0._max_num_members = MatchmakingSettings.MAX_NUMBER_OF_PLAYERS

	local var_1_2 = false

	arg_1_0._current_weave = LevelUnlockUtils.current_weave(arg_1_0._statistics_db, arg_1_0._stats_id, var_1_2)
	arg_1_0._game_mode_data = var_0_0.setup_game_mode_data(arg_1_0._statistics_db, arg_1_0._stats_id)
	arg_1_0._lobby_browser_console_ui = LobbyBrowserConsoleUI:new(arg_1_0, var_1_0, arg_1_0._game_mode_data, var_0_0.show_lobbies_table, var_0_0.distance_table)

	arg_1_0:reset_filters()
	Managers.matchmaking:set_active_lobby_browser(arg_1_0)
	arg_1_0:_populate_lobby_list()
	arg_1_0:change_generic_actions("default_lobby_browser")
	arg_1_0:set_input_description(nil)
	Managers.account:get_friends(2000, callback(arg_1_0, "cb_friends_collected"))
end

StartGameWindowLobbyBrowserConsole.get_selected_game_mode_index = function (arg_2_0)
	local var_2_0 = arg_2_0._game_mode_data.game_modes

	return arg_2_0._selected_game_mode_index or var_2_0.adventure
end

local var_0_5 = {}

StartGameWindowLobbyBrowserConsole.cb_friends_collected = function (arg_3_0, arg_3_1)
	table.clear(arg_3_0._friend_names)

	local var_3_0 = arg_3_1 or var_0_5

	for iter_3_0, iter_3_1 in pairs(var_3_0) do
		arg_3_0._friend_names[iter_3_1.name] = true
	end
end

StartGameWindowLobbyBrowserConsole.change_generic_actions = function (arg_4_0, arg_4_1)
	arg_4_0._parent:change_generic_actions(arg_4_1)
end

StartGameWindowLobbyBrowserConsole.set_input_description = function (arg_5_0, arg_5_1)
	arg_5_0._parent:set_input_description(arg_5_1)
end

StartGameWindowLobbyBrowserConsole.on_exit = function (arg_6_0, arg_6_1)
	print("[StartGameWindow] Exit Substate StartGameWindowLobbyBrowserConsole")
	Managers.matchmaking:set_active_lobby_browser(nil)
	arg_6_0:set_input_description(nil)
	arg_6_0._lobby_finder:destroy()

	arg_6_0._lobby_finder = nil
end

StartGameWindowLobbyBrowserConsole.disable_input = function (arg_7_0, arg_7_1)
	return arg_7_1 == "show_gamercard"
end

StartGameWindowLobbyBrowserConsole.update = function (arg_8_0, arg_8_1, arg_8_2)
	arg_8_0._lobby_finder:update(arg_8_1)

	if not arg_8_0:_is_refreshing() then
		if arg_8_0._do_populate then
			arg_8_0:_populate_lobby_list()
		end

		arg_8_0._searching = false
		arg_8_0._do_populate = false
	end

	arg_8_0:_update_auto_refresh(arg_8_1)
	arg_8_0._lobby_browser_console_ui:update(arg_8_1, arg_8_2, arg_8_0._searching and arg_8_0._do_populate)
end

StartGameWindowLobbyBrowserConsole.post_update = function (arg_9_0, arg_9_1, arg_9_2)
	return
end

StartGameWindowLobbyBrowserConsole._is_refreshing = function (arg_10_0)
	return (arg_10_0._lobby_finder:is_refreshing())
end

StartGameWindowLobbyBrowserConsole.play_sound = function (arg_11_0, arg_11_1)
	arg_11_0._parent:play_sound(arg_11_1)
end

StartGameWindowLobbyBrowserConsole.cancel_join_lobby = function (arg_12_0, arg_12_1)
	arg_12_0.join_lobby_data_id = nil
end

StartGameWindowLobbyBrowserConsole._populate_lobby_list = function (arg_13_0, arg_13_1)
	local var_13_0 = arg_13_0:get_lobbies()
	local var_13_1 = true
	local var_13_2 = arg_13_0._selected_show_lobbies_index
	local var_13_3 = var_0_0.show_lobbies_table[var_13_2] or "lb_show_all"
	local var_13_4 = {}
	local var_13_5 = 0

	for iter_13_0, iter_13_1 in pairs(var_13_0) do
		local var_13_6 = iter_13_1.matchmaking_type

		if IS_PS4 then
			var_13_6 = NetworkLookup.matchmaking_types[var_13_6]
		end

		if tonumber(var_13_6) <= #NetworkLookup.matchmaking_types then
			if var_13_3 == "lb_show_joinable" then
				if arg_13_0:_valid_lobby(iter_13_1) then
					var_13_5 = var_13_5 + 1
					var_13_4[var_13_5] = iter_13_1
				end
			elseif var_13_3 == "lb_search_type_friends" then
				if arg_13_0:_is_friend_lobby(iter_13_1) then
					var_13_5 = var_13_5 + 1
					var_13_4[var_13_5] = iter_13_1
				end
			else
				var_13_5 = var_13_5 + 1
				var_13_4[var_13_5] = iter_13_1
			end
		end
	end

	arg_13_0._lobby_list_update_timer = nil

	arg_13_0._lobby_browser_console_ui:populate_lobby_list(var_13_4, var_13_1)
end

local var_0_6 = {}

StartGameWindowLobbyBrowserConsole.get_lobbies = function (arg_14_0)
	return arg_14_0._lobby_finder:lobbies() or var_0_6
end

local var_0_7 = {}

StartGameWindowLobbyBrowserConsole._valid_lobby = function (arg_15_0, arg_15_1)
	if not arg_15_1.valid then
		return false
	end

	table.clear(var_0_7)

	local var_15_0 = arg_15_1.server_info ~= nil

	if not var_15_0 then
		local var_15_1 = arg_15_1.matchmaking and arg_15_1.matchmaking ~= "false"
		local var_15_2 = arg_15_1.selected_mission_id or arg_15_1.mission_id
		local var_15_3 = arg_15_1.difficulty
		local var_15_4 = tonumber(arg_15_1.matchmaking_type)

		if not IS_PS4 or not arg_15_1.matchmaking_type then
			local var_15_5 = NetworkLookup.matchmaking_types[var_15_4]
		end

		local var_15_6 = tonumber(arg_15_1.num_players)
		local var_15_7 = arg_15_1.quick_play
		local var_15_8 = arg_15_1.mechanism

		if not var_15_1 or not var_15_2 or not var_15_3 or var_15_6 == arg_15_0._max_num_members then
			return false
		end

		if var_15_3 and var_15_8 ~= "weave" then
			local var_15_9 = DifficultySettings[var_15_3]

			if var_15_9.extra_requirement_name then
				local var_15_10 = ExtraDifficultyRequirements[var_15_9.extra_requirement_name]

				if not Development.parameter("unlock_all_difficulties") and not var_15_10.requirement_function() then
					return false
				end
			end

			if var_15_9.dlc_requirement then
				var_0_7[var_15_9.dlc_requirement] = true
			end
		end

		local var_15_11 = Managers.player
		local var_15_12 = var_15_11:local_player()
		local var_15_13 = var_15_11:statistics_db()
		local var_15_14 = var_15_12:stats_id()
		local var_15_15 = var_15_2
		local var_15_16 = MechanismSettings[var_15_8]

		if var_15_16 and var_15_16.required_dlc then
			var_0_7[var_15_16.required_dlc] = true
		end

		for iter_15_0, iter_15_1 in pairs(var_0_7) do
			if not Managers.unlock:is_dlc_unlocked(iter_15_0) then
				return false
			end
		end

		if var_15_8 == "weave" then
			local var_15_17 = WeaveSettings.templates[var_15_2]

			var_15_15 = var_15_17 and var_15_17.objectives[1].level_id or var_15_15
		end

		if not LevelUnlockUtils.level_unlocked(var_15_13, var_15_14, var_15_15) then
			return false
		end

		if var_15_8 ~= "weave" and not MatchmakingManager.is_lobby_private(arg_15_1) then
			local var_15_18 = var_15_12:profile_display_name()
			local var_15_19 = var_15_12:career_name()

			if not Managers.matchmaking:has_required_power_level(arg_15_1, var_15_18, var_15_19) then
				return false
			end
		end
	elseif var_15_0 then
		local var_15_20 = arg_15_0._current_server_name

		if var_15_20 ~= "" and string.find(arg_15_1.server_info.name, var_15_20) == nil then
			return false
		end
	else
		ferror("Sanity check")
	end

	return true
end

StartGameWindowLobbyBrowserConsole._is_friend_lobby = function (arg_16_0, arg_16_1)
	local var_16_0 = arg_16_1.name

	print(var_16_0, arg_16_0._friend_names[var_16_0])

	return arg_16_0._friend_names[var_16_0] ~= nil
end

StartGameWindowLobbyBrowserConsole.input_service = function (arg_17_0)
	return arg_17_0._parent:window_input_service()
end

StartGameWindowLobbyBrowserConsole.dirty = function (arg_18_0)
	local var_18_0 = arg_18_0._dirty

	arg_18_0._dirty = false

	return var_18_0
end

StartGameWindowLobbyBrowserConsole._update_auto_refresh = function (arg_19_0, arg_19_1)
	local var_19_0 = arg_19_0:_is_refreshing()
	local var_19_1 = arg_19_0._lobby_list_update_timer or MatchmakingSettings.TIME_BETWEEN_EACH_SEARCH

	if var_19_1 then
		local var_19_2 = var_19_1 - arg_19_1

		if var_19_2 < 0 and not var_19_0 then
			arg_19_0._lobby_list_update_timer = MatchmakingSettings.TIME_BETWEEN_EACH_SEARCH

			local var_19_3 = true

			arg_19_0:_search(var_19_3)
		else
			arg_19_0._lobby_list_update_timer = var_19_2
		end
	end

	if arg_19_0._was_refreshing and not var_19_0 then
		arg_19_0._dirty = true
	end

	arg_19_0._was_refreshing = var_19_0
end

StartGameWindowLobbyBrowserConsole.reset_filters = function (arg_20_0, arg_20_1, arg_20_2, arg_20_3, arg_20_4, arg_20_5)
	arg_20_0:set_level(arg_20_2 or "any")
	arg_20_0:set_difficulty(arg_20_3 or "any")
	arg_20_0:set_lobby_filter(arg_20_4 or (BUILD == "dev" or BUILD == "debug") and "lb_show_all" or "lb_show_joinable")
	arg_20_0:set_distance_filter(arg_20_5 or "map_zone_options_5")
	arg_20_0:set_game_mode(arg_20_1 or "any")
	arg_20_0:_search()
end

StartGameWindowLobbyBrowserConsole._create_filter_requirements = function (arg_21_0)
	local var_21_0 = arg_21_0._lobby_finder
	local var_21_1 = arg_21_0._selected_game_mode_index
	local var_21_2 = arg_21_0._game_mode_data.game_modes[arg_21_0._selected_game_mode_index] or "any"
	local var_21_3 = arg_21_0._selected_level_index
	local var_21_4 = arg_21_0:_get_levels()[var_21_3]
	local var_21_5 = arg_21_0._selected_difficulty_index
	local var_21_6 = arg_21_0:_get_difficulties()[var_21_5]
	local var_21_7 = not script_data.show_invalid_lobbies
	local var_21_8 = arg_21_0._selected_distance_index
	local var_21_9 = LobbyAux.map_lobby_distance_filter[var_21_8]
	local var_21_10 = arg_21_0._selected_show_lobbies_index
	local var_21_11 = var_0_0.show_lobbies_table[var_21_10] == "lb_show_joinable"
	local var_21_12 = 1
	local var_21_13 = {
		filters = {},
		near_filters = {},
		free_slots = var_21_12,
		distance_filter = not IS_PS4 and var_21_9
	}

	if IS_PS4 then
		local var_21_14 = Managers.account:region()

		if var_21_9 == "close" then
			var_21_13.filters.primary_region = {
				comparison = "equal",
				value = MatchmakingRegionLookup.primary[var_21_14] or MatchmakingRegionLookup.secondary[var_21_14] or "default"
			}
		elseif var_21_9 == "medium" then
			var_21_13.filters.secondary_region = {
				comparison = "equal",
				value = MatchmakingRegionLookup.secondary[var_21_14] or MatchmakingRegionLookup.primary[var_21_14] or "default"
			}
		end
	end

	local var_21_15 = Managers.eac:is_trusted()

	var_21_13.filters.eac_authorized = {
		comparison = "equal",
		value = var_21_15 and "true" or "false"
	}

	if var_21_6 ~= "any" and var_21_6 then
		var_21_13.filters.difficulty = {
			comparison = "equal",
			value = var_21_6
		}
	end

	if var_21_4 ~= "any" and var_21_4 then
		var_21_13.filters.selected_mission_id = {
			comparison = "equal",
			value = var_21_4
		}
	end

	if var_21_2 ~= "any" and var_21_2 then
		var_21_13.filters.mechanism = {
			comparison = "equal",
			value = var_21_2
		}
	end

	if var_21_7 then
		var_21_13.filters.network_hash = {
			comparison = "equal",
			value = var_21_0:network_hash()
		}
	end

	if var_21_11 then
		var_21_13.filters.matchmaking = {
			value = "false",
			comparison = "not_equal"
		}
	end

	return var_21_13
end

StartGameWindowLobbyBrowserConsole._join = function (arg_22_0, arg_22_1, arg_22_2)
	Managers.matchmaking:request_join_lobby(arg_22_1, arg_22_2)

	arg_22_0.join_lobby_data_id = arg_22_1.id
end

StartGameWindowLobbyBrowserConsole._search = function (arg_23_0, arg_23_1)
	local var_23_0 = arg_23_0:_create_filter_requirements()
	local var_23_1 = arg_23_0._lobby_finder

	if IS_WINDOWS then
		local var_23_2 = var_23_1:get_lobby_browser()

		LobbyInternal.clear_filter_requirements(var_23_2)
	else
		LobbyInternal.clear_filter_requirements()
	end

	local var_23_3 = true

	var_23_1:add_filter_requirements(var_23_0, var_23_3)

	arg_23_0._searching = true
	arg_23_0._do_populate = not arg_23_1
end

StartGameWindowLobbyBrowserConsole._get_game_modes = function (arg_24_0)
	return arg_24_0._game_mode_data.game_modes
end

StartGameWindowLobbyBrowserConsole._get_levels = function (arg_25_0)
	local var_25_0 = arg_25_0._game_mode_data
	local var_25_1 = var_25_0.game_modes

	return var_25_0[arg_25_0._selected_game_mode_index or var_25_1.adventure].levels
end

StartGameWindowLobbyBrowserConsole._get_difficulties = function (arg_26_0)
	local var_26_0 = arg_26_0._game_mode_data
	local var_26_1 = var_26_0.game_modes

	return (var_26_0[arg_26_0._selected_game_mode_index or var_26_1.adventure] or var_26_0[1]).difficulties
end

StartGameWindowLobbyBrowserConsole.completed_level_difficulty_index = function (arg_27_0, arg_27_1)
	local var_27_0 = arg_27_1.selected_mission_id

	return LevelUnlockUtils.completed_level_difficulty_index(arg_27_0._statistics_db, arg_27_0._stats_id, var_27_0) or 0
end

StartGameWindowLobbyBrowserConsole.refresh = function (arg_28_0)
	if not arg_28_0:_is_refreshing() then
		arg_28_0:_search()
	end
end

StartGameWindowLobbyBrowserConsole.set_game_mode = function (arg_29_0, arg_29_1)
	local var_29_0 = arg_29_0:_get_game_modes()
	local var_29_1 = table.find(var_29_0, arg_29_1)
	local var_29_2 = "lobby_browser_mission"
	local var_29_3 = var_29_0[var_29_1]

	if var_29_3 and var_29_3 ~= "any" then
		var_29_2 = var_0_4[var_29_3]
	end

	arg_29_0._selected_game_mode_index = var_29_1
	arg_29_0._search_timer = var_0_1
	arg_29_0._do_populate = true

	arg_29_0:set_level("any")
	arg_29_0._lobby_browser_console_ui:set_game_type_filter(Localize(var_29_2))
	arg_29_0._lobby_browser_console_ui:setup_filter_entries()
end

StartGameWindowLobbyBrowserConsole.set_level = function (arg_30_0, arg_30_1)
	local var_30_0 = arg_30_0:_get_levels()
	local var_30_1 = table.find(var_30_0, arg_30_1)
	local var_30_2 = "lobby_browser_mission"
	local var_30_3 = var_30_0[var_30_1]

	if var_30_3 ~= "any" then
		var_30_2 = LevelSettings[var_30_3].display_name
	end

	arg_30_0._selected_level_index = var_30_1
	arg_30_0._search_timer = var_0_1

	arg_30_0._lobby_browser_console_ui:set_level_filter(Localize(var_30_2))
end

StartGameWindowLobbyBrowserConsole.set_difficulty = function (arg_31_0, arg_31_1)
	local var_31_0 = arg_31_0:_get_difficulties()
	local var_31_1 = table.find(var_31_0, arg_31_1)
	local var_31_2 = "lobby_browser_difficulty"
	local var_31_3 = var_31_0[var_31_1]

	if var_31_3 ~= "any" then
		var_31_2 = DifficultySettings[var_31_3].display_name
	end

	arg_31_0._selected_difficulty_index = var_31_1
	arg_31_0._search_timer = var_0_1

	arg_31_0._lobby_browser_console_ui:set_difficulty_filter(Localize(var_31_2))
end

StartGameWindowLobbyBrowserConsole.set_lobby_filter = function (arg_32_0, arg_32_1)
	local var_32_0 = var_0_0.show_lobbies_table
	local var_32_1 = table.find(var_32_0, arg_32_1)
	local var_32_2 = var_32_0[var_32_1]

	arg_32_0._selected_show_lobbies_index = var_32_1
	arg_32_0._search_timer = var_0_1

	arg_32_0._lobby_browser_console_ui:set_show_lobbies_filter(Localize(var_32_2))
end

StartGameWindowLobbyBrowserConsole.set_distance_filter = function (arg_33_0, arg_33_1)
	local var_33_0 = var_0_0.distance_table
	local var_33_1 = table.find(var_33_0, arg_33_1)
	local var_33_2 = var_33_0[var_33_1]

	arg_33_0._selected_distance_index = var_33_1
	arg_33_0._search_timer = var_0_1

	arg_33_0._lobby_browser_console_ui:set_distance_filter(Localize(var_33_2))
end

StartGameWindowLobbyBrowserConsole.is_lobby_joinable = function (arg_34_0, arg_34_1)
	local var_34_0 = arg_34_1.selected_mission_id or arg_34_1.mission_id
	local var_34_1 = arg_34_1.difficulty
	local var_34_2 = tonumber(arg_34_1.num_players)
	local var_34_3 = arg_34_1.mechanism
	local var_34_4 = Managers.matchmaking.get_matchmaking_settings_for_mechanism(var_34_3)

	if Managers.matchmaking:is_game_matchmaking() then
		return false, "cannot_join_while_matchmaking"
	end

	if not var_34_0 or not var_34_1 or var_34_0 == "n/a" then
		return false, "dlc1_2_difficulty_unavailable"
	end

	if var_34_2 == var_34_4.MAX_NUMBER_OF_PLAYERS then
		return false, "lobby_is_full"
	end

	local var_34_5 = Managers.state.network:lobby():lobby_host()

	if arg_34_1.host == var_34_5 then
		return false, "lobby_browser_own_server_error"
	end

	if MatchmakingManager.is_lobby_private(arg_34_1) or arg_34_1.matchmaking == "false" then
		return false, "not_searching_for_players"
	end

	if not arg_34_1.valid then
		return false, "lobby_id_mismatch"
	end

	if Managers.matchmaking:is_matchmaking_paused() then
		return false, "painting_none_name"
	end

	local var_34_6 = arg_34_0._statistics_db
	local var_34_7 = arg_34_0._stats_id
	local var_34_8 = arg_34_0._profile_name
	local var_34_9 = arg_34_0._career_name
	local var_34_10 = {}
	local var_34_11 = arg_34_1.weave_quick_game == "true"
	local var_34_12 = MechanismSettings[var_34_3]
	local var_34_13

	if var_34_3 == "weave" then
		if var_34_0 ~= "false" and not var_34_11 then
			local var_34_14 = var_34_0

			if LevelUnlockUtils.weave_disabled(var_34_14) then
				return false, "weave_disabled"
			end

			local var_34_15 = false

			if not (LevelUnlockUtils.weave_unlocked(var_34_6, var_34_7, var_34_14, var_34_15) or var_34_14 == arg_34_0._current_weave) then
				return false, "weave_not_unlocked"
			end
		end
	elseif var_34_3 == "deus" and DeusJourneySettings[var_34_0] then
		local var_34_16 = LevelUnlockUtils.unlocked_journeys(var_34_6, var_34_7)

		if not table.find(var_34_16, var_34_0) then
			return false, "start_game_level_locked"
		end

		if var_34_1 then
			local var_34_17 = DifficultySettings[var_34_1]

			if var_34_17.extra_requirement_name then
				local var_34_18 = ExtraDifficultyRequirements[var_34_17.extra_requirement_name]

				if not Development.parameter("unlock_all_difficulties") and not var_34_18.requirement_function() then
					return false, "difficulty_requirements_not_met"
				end
			end

			if var_34_17.dlc_requirement then
				var_34_10[var_34_17.dlc_requirement] = true
			end
		end
	elseif var_34_3 == "versus" then
		if Managers.mechanism:current_mechanism_name() ~= "versus" then
			return false, "vs_player_hosted_lobby_wrong_mechanism_error"
		end
	else
		local var_34_19 = var_34_0

		if not (var_34_19 == "any" or LevelUnlockUtils.level_unlocked(var_34_6, var_34_7, var_34_19)) then
			local var_34_20 = LevelSettings[var_34_19].dlc_name

			if var_34_20 then
				if not Managers.unlock:is_dlc_unlocked(var_34_20) then
					return false, "dlc1_2_dlc_level_locked_tooltip"
				else
					return false, "start_game_level_locked"
				end
			else
				return false, "start_game_level_locked"
			end
		end

		if var_34_12 and var_34_12.extra_requirements_function and not var_34_12.extra_requirements_function() then
			return false, "game_mode_requirements_not_met"
		end

		if var_34_3 ~= "deus" and not MatchmakingManager.is_lobby_private(arg_34_1) and not Managers.matchmaking:has_required_power_level(arg_34_1, var_34_8, var_34_9) then
			return false, "difficulty_blocked_by_me"
		end

		if var_34_1 then
			local var_34_21 = DifficultySettings[var_34_1]

			if var_34_21.extra_requirement_name then
				local var_34_22 = ExtraDifficultyRequirements[var_34_21.extra_requirement_name]

				if not Development.parameter("unlock_all_difficulties") and not var_34_22.requirement_function() then
					var_34_13 = "difficulty_requirements_not_met"
				end
			end

			if var_34_21.dlc_requirement then
				var_34_10[var_34_21.dlc_requirement] = true
			end
		end
	end

	if var_34_12 and var_34_12.required_dlc then
		var_34_10[var_34_12.required_dlc] = true
	end

	for iter_34_0, iter_34_1 in pairs(var_34_10) do
		if not Managers.unlock:is_dlc_unlocked(iter_34_0) then
			return false, "dlc1_2_dlc_level_locked_tooltip"
		end
	end

	if var_34_13 then
		return false, var_34_13
	end

	return true, "tutorial_no_text"
end
