-- chunkname: @scripts/ui/views/start_game_view/windows/start_game_window_lobby_browser_console.lua

require("scripts/ui/views/lobby_browser_console_ui")
require("scripts/network/lobby_aux")

local var_0_0 = local_require("scripts/ui/views/start_game_view/windows/definitions/start_game_window_lobby_browser_console_definitions")
local num = 0
local tbl = {
	project_hash = "bulldozer",
	config_file_name = "global",
	lobby_port = GameSettingsDevelopment.network_port,
	server_port = GameSettingsDevelopment.network_port,
	max_members = MatchmakingSettings.MAX_NUMBER_OF_PLAYERS
}
local tbl_2 = {
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
local tbl_3 = {
	deus = "area_selection_morris_name",
	adventure = "area_selection_campaign",
	weave = "menu_weave_area_no_wom_title",
	versus = "vs_ui_versus_tag",
	any = "lobby_browser_mission"
}

StartGameWindowLobbyBrowserConsole = class(StartGameWindowLobbyBrowserConsole)
StartGameWindowLobbyBrowserConsole.NAME = "StartGameWindowLobbyBrowserConsole"

StartGameWindowLobbyBrowserConsole.on_enter = function (self, arg_1_1, arg_1_2)
	-- function 1
	print("[StartGameWindow] Enter Substate StartGameWindowLobbyBrowserConsole")

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
	self._max_num_members = MatchmakingSettings.MAX_NUMBER_OF_PLAYERS

	local flag = false

	self._current_weave = LevelUnlockUtils.current_weave(self._statistics_db, self._stats_id, flag)
	self._game_mode_data = var_0_0.setup_game_mode_data(self._statistics_db, self._stats_id)
	self._lobby_browser_console_ui = LobbyBrowserConsoleUI:new(self, ingame_ui_context, self._game_mode_data, var_0_0.show_lobbies_table, var_0_0.distance_table)

	self:reset_filters()
	Managers.matchmaking:set_active_lobby_browser(self)
	self:_populate_lobby_list()
	self:change_generic_actions("default_lobby_browser")
	self:set_input_description(nil)
	Managers.account:get_friends(2000, callback(self, "cb_friends_collected"))
end

StartGameWindowLobbyBrowserConsole.get_selected_game_mode_index = function (self)
	-- function 2
	local game_modes = self._game_mode_data.game_modes
	local _selected_game_mode_index = self._selected_game_mode_index

	_selected_game_mode_index = _selected_game_mode_index or game_modes.adventure

	return _selected_game_mode_index
end

local tbl_4 = {}

StartGameWindowLobbyBrowserConsole.cb_friends_collected = function (self, arg_3_1)
	-- function 3
	table.clear(self._friend_names)

	local flag = arg_3_1 or tbl_4

	for k, v in pairs(flag) do
		self._friend_names[v.name] = true
	end
end

StartGameWindowLobbyBrowserConsole.change_generic_actions = function (self, arg_4_1)
	-- function 4
	self._parent:change_generic_actions(arg_4_1)
end

StartGameWindowLobbyBrowserConsole.set_input_description = function (self, arg_5_1)
	-- function 5
	self._parent:set_input_description(arg_5_1)
end

StartGameWindowLobbyBrowserConsole.on_exit = function (self, arg_6_1)
	-- function 6
	print("[StartGameWindow] Exit Substate StartGameWindowLobbyBrowserConsole")
	Managers.matchmaking:set_active_lobby_browser(nil)
	self:set_input_description(nil)
	self._lobby_finder:destroy()

	self._lobby_finder = nil
end

StartGameWindowLobbyBrowserConsole.disable_input = function (arg_7_0, arg_7_1)
	-- function 7
	return arg_7_1 == "show_gamercard"
end

StartGameWindowLobbyBrowserConsole.update = function (self, arg_8_1, arg_8_2)
	-- function 8
	self._lobby_finder:update(arg_8_1)

	if not self:_is_refreshing() then
		if not self._do_populate then
			self:_populate_lobby_list()
		end

		self._searching = false
		self._do_populate = false
	end

	self:_update_auto_refresh(arg_8_1)

	local _lobby_browser_console_ui = self._lobby_browser_console_ui
	local var_8_1 = _lobby_browser_console_ui
	local update = _lobby_browser_console_ui.update
	local var_8_3 = arg_8_1
	local var_8_4 = arg_8_2
	local _searching = self._searching

	_searching = not _searching and self._do_populate

	update(var_8_1, var_8_3, var_8_4, _searching)
end

StartGameWindowLobbyBrowserConsole.post_update = function (arg_9_0, arg_9_1, arg_9_2)
	-- function 9
	return
end

StartGameWindowLobbyBrowserConsole._is_refreshing = function (self)
	-- function 10
	return (self._lobby_finder:is_refreshing())
end

StartGameWindowLobbyBrowserConsole.play_sound = function (self, arg_11_1)
	-- function 11
	self._parent:play_sound(arg_11_1)
end

StartGameWindowLobbyBrowserConsole.cancel_join_lobby = function (self, arg_12_1)
	-- function 12
	self.join_lobby_data_id = nil
end

StartGameWindowLobbyBrowserConsole._populate_lobby_list = function (self, arg_13_1)
	-- function 13
	local get_lobbies = self:get_lobbies()
	local flag = true
	local _selected_show_lobbies_index = self._selected_show_lobbies_index
	local var_13_3 = var_0_0.show_lobbies_table[_selected_show_lobbies_index]

	var_13_3 = var_13_3 or "lb_show_all"

	local tbl = {}
	local num = 0

	for k, v in pairs(get_lobbies) do
		local matchmaking_type = v.matchmaking_type

		if not IS_PS4 then
			matchmaking_type = NetworkLookup.matchmaking_types[matchmaking_type]
		end

		if tonumber(matchmaking_type) <= #NetworkLookup.matchmaking_types then
			if var_13_3 == "lb_show_joinable" then
				if not self:_valid_lobby(v) then
					num = num + 1
					tbl[num] = v
				end
			elseif var_13_3 == "lb_search_type_friends" then
				if not self:_is_friend_lobby(v) then
					num = num + 1
					tbl[num] = v
				end
			else
				num = num + 1
				tbl[num] = v
			end
		end
	end

	self._lobby_list_update_timer = nil

	self._lobby_browser_console_ui:populate_lobby_list(tbl, flag)
end

local tbl_5 = {}

StartGameWindowLobbyBrowserConsole.get_lobbies = function (self)
	-- function 14
	local lobbies = self._lobby_finder:lobbies()

	lobbies = lobbies or tbl_5

	return lobbies
end

local tbl_6 = {}

StartGameWindowLobbyBrowserConsole._valid_lobby = function (self, arg_15_1)
	-- function 15
	if not arg_15_1.valid then
		return false
	end

	table.clear(tbl_6)

	local flag = arg_15_1.server_info ~= nil

	if not flag then
		local matchmaking = arg_15_1.matchmaking

		matchmaking = not matchmaking and arg_15_1.matchmaking ~= "false"

		local selected_mission_id = arg_15_1.selected_mission_id

		selected_mission_id = selected_mission_id or arg_15_1.mission_id

		local difficulty = arg_15_1.difficulty
		local var_15_4 = tonumber(arg_15_1.matchmaking_type)

		if not (not IS_PS4 and arg_15_1.matchmaking_type) then
			local var_15_5 = NetworkLookup.matchmaking_types[var_15_4]
		end

		local var_15_6 = tonumber(arg_15_1.num_players)
		local quick_play = arg_15_1.quick_play
		local mechanism = arg_15_1.mechanism

		if not (not matchmaking and not selected_mission_id and not difficulty and var_15_6 ~= self._max_num_members) then
			return false
		end

		if not (not difficulty and mechanism == "weave") then
			local var_15_9 = DifficultySettings[difficulty]

			if not var_15_9.extra_requirement_name then
				local var_15_10 = ExtraDifficultyRequirements[var_15_9.extra_requirement_name]

				if not (Development.parameter("unlock_all_difficulties") or var_15_10.requirement_function()) then
					return false
				end
			end

			if not var_15_9.dlc_requirement then
				tbl_6[var_15_9.dlc_requirement] = true
			end
		end

		local player = Managers.player
		local local_player = player:local_player()
		local statistics_db = player:statistics_db()
		local stats_id = local_player:stats_id()
		local var_15_15 = selected_mission_id
		local var_15_16 = MechanismSettings[mechanism]

		if not var_15_16 and not var_15_16.required_dlc then
			tbl_6[var_15_16.required_dlc] = true
		end

		for k, v in pairs(tbl_6) do
			if not Managers.unlock:is_dlc_unlocked(k) then
				return false
			end
		end

		if mechanism == "weave" then
			local var_15_17 = WeaveSettings.templates[selected_mission_id]

			var_15_15 = not var_15_17 and var_15_17.objectives[1].level_id and var_15_15
		end

		if not LevelUnlockUtils.level_unlocked(statistics_db, stats_id, var_15_15) then
			return false
		end

		if not (mechanism == "weave" or MatchmakingManager.is_lobby_private(arg_15_1)) then
			local profile_display_name = local_player:profile_display_name()
			local career_name = local_player:career_name()

			if not Managers.matchmaking:has_required_power_level(arg_15_1, profile_display_name, career_name) then
				return false
			end
		end
	elseif not flag then
		local _current_server_name = self._current_server_name

		if not (_current_server_name == "" or string.find(arg_15_1.server_info.name, _current_server_name) ~= nil) then
			return false
		end
	else
		ferror("Sanity check")
	end

	return true
end

StartGameWindowLobbyBrowserConsole._is_friend_lobby = function (self, arg_16_1)
	-- function 16
	local name = arg_16_1.name

	print(name, self._friend_names[name])

	return self._friend_names[name] ~= nil
end

StartGameWindowLobbyBrowserConsole.input_service = function (self)
	-- function 17
	return self._parent:window_input_service()
end

StartGameWindowLobbyBrowserConsole.dirty = function (self)
	-- function 18
	local _dirty = self._dirty

	self._dirty = false

	return _dirty
end

StartGameWindowLobbyBrowserConsole._update_auto_refresh = function (self, arg_19_1)
	-- function 19
	local _is_refreshing = self:_is_refreshing()
	local _lobby_list_update_timer = self._lobby_list_update_timer

	_lobby_list_update_timer = _lobby_list_update_timer or MatchmakingSettings.TIME_BETWEEN_EACH_SEARCH

	if not _lobby_list_update_timer then
		local num = _lobby_list_update_timer - arg_19_1

		if not (not (num < 0) or _is_refreshing) then
			self._lobby_list_update_timer = MatchmakingSettings.TIME_BETWEEN_EACH_SEARCH

			local flag = true

			self:_search(flag)
		else
			self._lobby_list_update_timer = num
		end
	end

	if not (not self._was_refreshing and _is_refreshing) then
		self._dirty = true
	end

	self._was_refreshing = _is_refreshing
end

StartGameWindowLobbyBrowserConsole.reset_filters = function (self, arg_20_1, arg_20_2, arg_20_3, arg_20_4, arg_20_5)
	-- function 20
	self:set_level(arg_20_2 or "any")
	self:set_difficulty(arg_20_3 or "any")

	local var_20_0 = self
	local set_lobby_filter = self.set_lobby_filter
	local flag

	flag = arg_20_4 or BUILD == "dev" or BUILD == "debug" or "lb_show_all" or "lb_show_joinable"

	set_lobby_filter(var_20_0, flag)
	self:set_distance_filter(arg_20_5 or "map_zone_options_5")
	self:set_game_mode(arg_20_1 or "any")
	self:_search()
end

StartGameWindowLobbyBrowserConsole._create_filter_requirements = function (self)
	-- function 21
	local _lobby_finder = self._lobby_finder
	local _selected_game_mode_index = self._selected_game_mode_index
	local var_21_2 = self._game_mode_data.game_modes[self._selected_game_mode_index]

	var_21_2 = var_21_2 or "any"

	local _selected_level_index = self._selected_level_index
	local var_21_4 = self:_get_levels()[_selected_level_index]
	local _selected_difficulty_index = self._selected_difficulty_index
	local var_21_6 = self:_get_difficulties()[_selected_difficulty_index]
	local flag = not script_data.show_invalid_lobbies
	local _selected_distance_index = self._selected_distance_index
	local var_21_9 = LobbyAux.map_lobby_distance_filter[_selected_distance_index]
	local _selected_show_lobbies_index = self._selected_show_lobbies_index
	local flag_2 = var_0_0.show_lobbies_table[_selected_show_lobbies_index] == "lb_show_joinable"
	local num = 1
	local tbl = {
		filters = {},
		near_filters = {},
		free_slots = num,
		distance_filter = not not IS_PS4 or var_21_9
	}

	if not IS_PS4 then
		local region = Managers.account:region()

		if var_21_9 == "close" then
			local filters = tbl.filters
			local tbl_2 = {
				comparison = "equal"
			}
			local var_21_17 = MatchmakingRegionLookup.primary[region]

			if not var_21_17 then
				var_21_17 = MatchmakingRegionLookup.secondary[region]
				var_21_17 = var_21_17 or "default"
			end

			tbl_2.value = var_21_17
			filters.primary_region = tbl_2
		elseif var_21_9 == "medium" then
			local filters_2 = tbl.filters
			local tbl_3 = {
				comparison = "equal"
			}
			local var_21_20 = MatchmakingRegionLookup.secondary[region]

			if not var_21_20 then
				var_21_20 = MatchmakingRegionLookup.primary[region]
				var_21_20 = var_21_20 or "default"
			end

			tbl_3.value = var_21_20
			filters_2.secondary_region = tbl_3
		end
	end

	local is_trusted = Managers.eac:is_trusted()
	local filters_3 = tbl.filters
	local tbl_4 = {
		comparison = "equal"
	}
	local flag_3

	flag_3 = not is_trusted and "true" and "false"
	tbl_4.value = flag_3
	filters_3.eac_authorized = tbl_4

	if var_21_6 == "any" or not var_21_6 then
		tbl.filters.difficulty = {
			comparison = "equal",
			value = var_21_6
		}
	end

	if var_21_4 == "any" or not var_21_4 then
		tbl.filters.selected_mission_id = {
			comparison = "equal",
			value = var_21_4
		}
	end

	if var_21_2 == "any" or not var_21_2 then
		tbl.filters.mechanism = {
			comparison = "equal",
			value = var_21_2
		}
	end

	if not flag then
		tbl.filters.network_hash = {
			comparison = "equal",
			value = _lobby_finder:network_hash()
		}
	end

	if not flag_2 then
		tbl.filters.matchmaking = {
			value = "false",
			comparison = "not_equal"
		}
	end

	return tbl
end

StartGameWindowLobbyBrowserConsole._join = function (self, arg_22_1, arg_22_2)
	-- function 22
	Managers.matchmaking:request_join_lobby(arg_22_1, arg_22_2)

	self.join_lobby_data_id = arg_22_1.id
end

StartGameWindowLobbyBrowserConsole._search = function (self, arg_23_1)
	-- function 23
	local _create_filter_requirements = self:_create_filter_requirements()
	local _lobby_finder = self._lobby_finder

	if not IS_WINDOWS then
		local get_lobby_browser = _lobby_finder:get_lobby_browser()

		LobbyInternal.clear_filter_requirements(get_lobby_browser)
	else
		LobbyInternal.clear_filter_requirements()
	end

	local flag = true

	_lobby_finder:add_filter_requirements(_create_filter_requirements, flag)

	self._searching = true
	self._do_populate = not arg_23_1
end

StartGameWindowLobbyBrowserConsole._get_game_modes = function (self)
	-- function 24
	return self._game_mode_data.game_modes
end

StartGameWindowLobbyBrowserConsole._get_levels = function (self)
	-- function 25
	local _game_mode_data = self._game_mode_data
	local game_modes = _game_mode_data.game_modes
	local _selected_game_mode_index = self._selected_game_mode_index

	_selected_game_mode_index = _selected_game_mode_index or game_modes.adventure

	return _game_mode_data[_selected_game_mode_index].levels
end

StartGameWindowLobbyBrowserConsole._get_difficulties = function (self)
	-- function 26
	local _game_mode_data = self._game_mode_data
	local game_modes = _game_mode_data.game_modes
	local _selected_game_mode_index = self._selected_game_mode_index

	_selected_game_mode_index = _selected_game_mode_index or game_modes.adventure

	local var_26_3 = _game_mode_data[_selected_game_mode_index]

	var_26_3 = var_26_3 or _game_mode_data[1]

	return var_26_3.difficulties
end

StartGameWindowLobbyBrowserConsole.completed_level_difficulty_index = function (self, arg_27_1)
	-- function 27
	local selected_mission_id = arg_27_1.selected_mission_id
	local completed_level_difficulty_index = LevelUnlockUtils.completed_level_difficulty_index(self._statistics_db, self._stats_id, selected_mission_id)

	completed_level_difficulty_index = completed_level_difficulty_index or 0

	return completed_level_difficulty_index
end

StartGameWindowLobbyBrowserConsole.refresh = function (self)
	-- function 28
	if not self:_is_refreshing() then
		self:_search()
	end
end

StartGameWindowLobbyBrowserConsole.set_game_mode = function (self, arg_29_1)
	-- function 29
	local _get_game_modes = self:_get_game_modes()
	local find = table.find(_get_game_modes, arg_29_1)
	local str = "lobby_browser_mission"
	local var_29_3 = _get_game_modes[find]

	if not (not var_29_3 and var_29_3 == "any") then
		str = tbl_3[var_29_3]
	end

	self._selected_game_mode_index = find
	self._search_timer = num
	self._do_populate = true

	self:set_level("any")
	self._lobby_browser_console_ui:set_game_type_filter(Localize(str))
	self._lobby_browser_console_ui:setup_filter_entries()
end

StartGameWindowLobbyBrowserConsole.set_level = function (self, arg_30_1)
	-- function 30
	local _get_levels = self:_get_levels()
	local find = table.find(_get_levels, arg_30_1)
	local str = "lobby_browser_mission"
	local var_30_3 = _get_levels[find]

	if var_30_3 ~= "any" then
		str = LevelSettings[var_30_3].display_name
	end

	self._selected_level_index = find
	self._search_timer = num

	self._lobby_browser_console_ui:set_level_filter(Localize(str))
end

StartGameWindowLobbyBrowserConsole.set_difficulty = function (self, arg_31_1)
	-- function 31
	local _get_difficulties = self:_get_difficulties()
	local find = table.find(_get_difficulties, arg_31_1)
	local str = "lobby_browser_difficulty"
	local var_31_3 = _get_difficulties[find]

	if var_31_3 ~= "any" then
		str = DifficultySettings[var_31_3].display_name
	end

	self._selected_difficulty_index = find
	self._search_timer = num

	self._lobby_browser_console_ui:set_difficulty_filter(Localize(str))
end

StartGameWindowLobbyBrowserConsole.set_lobby_filter = function (self, arg_32_1)
	-- function 32
	local show_lobbies_table = var_0_0.show_lobbies_table
	local find = table.find(show_lobbies_table, arg_32_1)
	local var_32_2 = show_lobbies_table[find]

	self._selected_show_lobbies_index = find
	self._search_timer = num

	self._lobby_browser_console_ui:set_show_lobbies_filter(Localize(var_32_2))
end

StartGameWindowLobbyBrowserConsole.set_distance_filter = function (self, arg_33_1)
	-- function 33
	local distance_table = var_0_0.distance_table
	local find = table.find(distance_table, arg_33_1)
	local var_33_2 = distance_table[find]

	self._selected_distance_index = find
	self._search_timer = num

	self._lobby_browser_console_ui:set_distance_filter(Localize(var_33_2))
end

StartGameWindowLobbyBrowserConsole.is_lobby_joinable = function (self, arg_34_1)
	-- function 34
	local selected_mission_id = arg_34_1.selected_mission_id

	selected_mission_id = selected_mission_id or arg_34_1.mission_id

	local difficulty = arg_34_1.difficulty
	local var_34_2 = tonumber(arg_34_1.num_players)
	local mechanism = arg_34_1.mechanism
	local get_matchmaking_settings_for_mechanism = Managers.matchmaking.get_matchmaking_settings_for_mechanism(mechanism)

	if not Managers.matchmaking:is_game_matchmaking() then
		return false, "cannot_join_while_matchmaking"
	end

	if not (not selected_mission_id and not difficulty and selected_mission_id ~= "n/a") then
		return false, "dlc1_2_difficulty_unavailable"
	end

	if var_34_2 == get_matchmaking_settings_for_mechanism.MAX_NUMBER_OF_PLAYERS then
		return false, "lobby_is_full"
	end

	local lobby_host = Managers.state.network:lobby():lobby_host()

	if arg_34_1.host == lobby_host then
		return false, "lobby_browser_own_server_error"
	end

	if not (MatchmakingManager.is_lobby_private(arg_34_1) or arg_34_1.matchmaking ~= "false") then
		return false, "not_searching_for_players"
	end

	if not arg_34_1.valid then
		return false, "lobby_id_mismatch"
	end

	if not Managers.matchmaking:is_matchmaking_paused() then
		return false, "painting_none_name"
	end

	local _statistics_db = self._statistics_db
	local _stats_id = self._stats_id
	local _profile_name = self._profile_name
	local _career_name = self._career_name
	local tbl = {}
	local flag = arg_34_1.weave_quick_game == "true"
	local var_34_12 = MechanismSettings[mechanism]
	local var_34_13

	if mechanism == "weave" then
		if not (selected_mission_id == "false" or flag) then
			local var_34_14 = selected_mission_id

			if not LevelUnlockUtils.weave_disabled(var_34_14) then
				return false, "weave_disabled"
			end

			local flag_2 = false
			local weave_unlocked = LevelUnlockUtils.weave_unlocked(_statistics_db, _stats_id, var_34_14, flag_2)

			weave_unlocked = weave_unlocked or var_34_14 == self._current_weave

			if not weave_unlocked then
				return false, "weave_not_unlocked"
			end
		end
	elseif mechanism ~= "deus" or not DeusJourneySettings[selected_mission_id] then
		local unlocked_journeys = LevelUnlockUtils.unlocked_journeys(_statistics_db, _stats_id)

		if not table.find(unlocked_journeys, selected_mission_id) then
			return false, "start_game_level_locked"
		end

		if not difficulty then
			local var_34_18 = DifficultySettings[difficulty]

			if not var_34_18.extra_requirement_name then
				local var_34_19 = ExtraDifficultyRequirements[var_34_18.extra_requirement_name]

				if not (Development.parameter("unlock_all_difficulties") or var_34_19.requirement_function()) then
					return false, "difficulty_requirements_not_met"
				end
			end

			if not var_34_18.dlc_requirement then
				tbl[var_34_18.dlc_requirement] = true
			end
		end
	elseif mechanism == "versus" then
		if Managers.mechanism:current_mechanism_name() ~= "versus" then
			return false, "vs_player_hosted_lobby_wrong_mechanism_error"
		end
	else
		local var_34_20 = selected_mission_id

		if not (var_34_20 == "any" or LevelUnlockUtils.level_unlocked(_statistics_db, _stats_id, var_34_20)) then
			local dlc_name = LevelSettings[var_34_20].dlc_name

			if not dlc_name then
				if not Managers.unlock:is_dlc_unlocked(dlc_name) then
					return false, "dlc1_2_dlc_level_locked_tooltip"
				else
					return false, "start_game_level_locked"
				end
			else
				return false, "start_game_level_locked"
			end
		end

		if not (not var_34_12 and not var_34_12.extra_requirements_function and var_34_12.extra_requirements_function()) then
			return false, "game_mode_requirements_not_met"
		end

		if not (mechanism == "deus" or MatchmakingManager.is_lobby_private(arg_34_1) or Managers.matchmaking:has_required_power_level(arg_34_1, _profile_name, _career_name)) then
			return false, "difficulty_blocked_by_me"
		end

		if not difficulty then
			local var_34_22 = DifficultySettings[difficulty]

			if not var_34_22.extra_requirement_name then
				local var_34_23 = ExtraDifficultyRequirements[var_34_22.extra_requirement_name]

				if not (Development.parameter("unlock_all_difficulties") or var_34_23.requirement_function()) then
					var_34_13 = "difficulty_requirements_not_met"
				end
			end

			if not var_34_22.dlc_requirement then
				tbl[var_34_22.dlc_requirement] = true
			end
		end
	end

	if not var_34_12 and not var_34_12.required_dlc then
		tbl[var_34_12.required_dlc] = true
	end

	for k, v in pairs(tbl) do
		if not Managers.unlock:is_dlc_unlocked(k) then
			return false, "dlc1_2_dlc_level_locked_tooltip"
		end
	end

	if not var_34_13 then
		return false, var_34_13
	end

	return true, "tutorial_no_text"
end
