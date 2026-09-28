-- chunkname: @scripts/ui/views/start_game_view/windows/start_game_window_lobby_browser_console.lua

require("scripts/ui/views/lobby_browser_console_ui")
require("scripts/network/lobby_aux")

local definitions = local_require("scripts/ui/views/start_game_view/windows/definitions/start_game_window_lobby_browser_console_definitions")
local input_delay_before_start_new_search = 0
local network_options = {
	project_hash = "bulldozer",
	config_file_name = "global",
	lobby_port = GameSettingsDevelopment.network_port,
	server_port = GameSettingsDevelopment.network_port,
	max_members = MatchmakingSettings.MAX_NUMBER_OF_PLAYERS
}
local GAME_MODE_LOOKUP_STRINGS = {
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
local GAME_TYPE_LOOKUP_STRINGS = {
	deus = "area_selection_morris_name",
	adventure = "area_selection_campaign",
	weave = "menu_weave_area_no_wom_title",
	versus = "vs_ui_versus_tag",
	any = "lobby_browser_mission"
}

StartGameWindowLobbyBrowserConsole = class(StartGameWindowLobbyBrowserConsole)
StartGameWindowLobbyBrowserConsole.NAME = "StartGameWindowLobbyBrowserConsole"

StartGameWindowLobbyBrowserConsole.on_enter = function (self, params, offset)
	-- function 1
	print("[StartGameWindow] Enter Substate StartGameWindowLobbyBrowserConsole")

	self._parent = params.parent

	local ingame_ui_context = params.ingame_ui_context

	self._statistics_db = ingame_ui_context.statistics_db

	local player_manager = Managers.player
	local local_player = player_manager:local_player()

	self._profile_name = local_player:profile_display_name()
	self._career_name = local_player:career_name()
	self._stats_id = local_player:stats_id()
	self._friend_names = {}

	local LobbyFinder = LobbyFinder
	local var_1_1 = LobbyFinder
	local new = LobbyFinder.new
	local var_1_3 = network_options
	local MAX_NUM_LOBBIES = MatchmakingSettings.MAX_NUM_LOBBIES
	local IS_WINDOWS = IS_WINDOWS

	IS_WINDOWS = not not IS_WINDOWS and not not true

	local lobby_finder = new(var_1_1, var_1_3, MAX_NUM_LOBBIES, IS_WINDOWS)

	self._lobby_finder = lobby_finder
	self._max_num_members = MatchmakingSettings.MAX_NUMBER_OF_PLAYERS

	local ignore_dlc_check = false

	self._current_weave = LevelUnlockUtils.current_weave(self._statistics_db, self._stats_id, ignore_dlc_check)
	self._game_mode_data = definitions.setup_game_mode_data(self._statistics_db, self._stats_id)
	self._lobby_browser_console_ui = LobbyBrowserConsoleUI:new(self, ingame_ui_context, self._game_mode_data, definitions.show_lobbies_table, definitions.distance_table)

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

	_selected_game_mode_index = not not _selected_game_mode_index or not not game_modes.adventure

	return _selected_game_mode_index
end

local EMPTY_DATA = {}

StartGameWindowLobbyBrowserConsole.cb_friends_collected = function (self, friend_data)
	-- function 3
	table.clear(self._friend_names)

	local friend_data = not not friend_data or not not EMPTY_DATA

	for account_id, data in pairs(friend_data) do
		self._friend_names[data.name] = true
	end
end

StartGameWindowLobbyBrowserConsole.change_generic_actions = function (self, input_actions)
	-- function 4
	self._parent:change_generic_actions(input_actions)
end

StartGameWindowLobbyBrowserConsole.set_input_description = function (self, input_actions)
	-- function 5
	self._parent:set_input_description(input_actions)
end

StartGameWindowLobbyBrowserConsole.on_exit = function (self, params)
	-- function 6
	print("[StartGameWindow] Exit Substate StartGameWindowLobbyBrowserConsole")
	Managers.matchmaking:set_active_lobby_browser(nil)
	self:set_input_description(nil)
	self._lobby_finder:destroy()

	self._lobby_finder = nil
end

StartGameWindowLobbyBrowserConsole.disable_input = function (self, input_name)
	-- function 7
	return input_name == "show_gamercard"
end

StartGameWindowLobbyBrowserConsole.update = function (self, dt, t)
	-- function 8
	self._lobby_finder:update(dt)

	local is_refreshing = self:_is_refreshing()

	if not is_refreshing then
		if self._do_populate then
			self:_populate_lobby_list()
		end

		self._searching = false
		self._do_populate = false
	end

	self:_update_auto_refresh(dt)

	local _lobby_browser_console_ui = self._lobby_browser_console_ui
	local var_8_1 = _lobby_browser_console_ui
	local update = _lobby_browser_console_ui.update
	local var_8_3 = dt
	local var_8_4 = t
	local _searching = self._searching

	_searching = not not _searching and not not self._do_populate

	update(var_8_1, var_8_3, var_8_4, _searching)
end

StartGameWindowLobbyBrowserConsole.post_update = function (self, dt, t)
	-- function 9
	return
end

StartGameWindowLobbyBrowserConsole._is_refreshing = function (self)
	-- function 10
	local is_refreshing = self._lobby_finder:is_refreshing()

	return is_refreshing
end

StartGameWindowLobbyBrowserConsole.play_sound = function (self, event)
	-- function 11
	self._parent:play_sound(event)
end

StartGameWindowLobbyBrowserConsole.cancel_join_lobby = function (self, status_message)
	-- function 12
	self.join_lobby_data_id = nil
end

StartGameWindowLobbyBrowserConsole._populate_lobby_list = function (self, auto_update)
	-- function 13
	local lobbies = self:get_lobbies()
	local ignore_scroll_reset = true
	local show_lobbies_index = self._selected_show_lobbies_index
	local var_13_0 = definitions.show_lobbies_table[show_lobbies_index]

	if not var_13_0 then
		-- Nothing
	end

	var_13_0 = "lb_show_all"

	local show_filter = var_13_0

	::label_13_0::

	local lobbies_to_present = {}
	local lobby_count = 0

	for _, lobby_data in pairs(lobbies) do
		local matchmaking_type_id = lobby_data.matchmaking_type

		if IS_PS4 then
			matchmaking_type_id = NetworkLookup.matchmaking_types[matchmaking_type_id]
		end

		if tonumber(matchmaking_type_id) <= #NetworkLookup.matchmaking_types then
			if show_filter == "lb_show_joinable" then
				if self:_valid_lobby(lobby_data) then
					lobby_count = lobby_count + 1
					lobbies_to_present[lobby_count] = lobby_data
				end
			elseif show_filter == "lb_search_type_friends" then
				if self:_is_friend_lobby(lobby_data) then
					lobby_count = lobby_count + 1
					lobbies_to_present[lobby_count] = lobby_data
				end
			else
				lobby_count = lobby_count + 1
				lobbies_to_present[lobby_count] = lobby_data
			end
		end
	end

	self._lobby_list_update_timer = nil

	self._lobby_browser_console_ui:populate_lobby_list(lobbies_to_present, ignore_scroll_reset)
end

local empty_lobby_list = {}

StartGameWindowLobbyBrowserConsole.get_lobbies = function (self)
	-- function 14
	local lobby_finder = self._lobby_finder
	local lobbies_2 = lobby_finder:lobbies()

	if not lobbies_2 then
		-- Nothing
	end

	lobbies_2 = empty_lobby_list

	local lobbies = lobbies_2

	::label_14_0::

	return lobbies
end

local REQUIRED_DLCS = {}

StartGameWindowLobbyBrowserConsole._valid_lobby = function (self, lobby_data)
	-- function 15
	local is_valid = lobby_data.valid

	if not is_valid then
		return false
	end

	table.clear(REQUIRED_DLCS)

	local is_server = lobby_data.server_info ~= nil

	if not is_server then
		local matchmaking = lobby_data.matchmaking

		if matchmaking then
			-- Nothing
		end

		if lobby_data.matchmaking == "false" then
			matchmaking = false

			goto label_15_0
		end

		matchmaking = true

		local is_matchmaking = matchmaking

		::label_15_0::

		local selected_mission_id = lobby_data.selected_mission_id

		if not selected_mission_id then
			-- Nothing
		end

		selected_mission_id = lobby_data.mission_id

		local mission_id = selected_mission_id

		::label_15_1::

		local difficulty = lobby_data.difficulty
		local matchmaking_types_index = tonumber(lobby_data.matchmaking_type)
		local matchmaking_type_2

		if IS_PS4 then
			matchmaking_type_2 = lobby_data.matchmaking_type

			if not matchmaking_type_2 then
				-- Nothing
			end
		end

		matchmaking_type_2 = NetworkLookup.matchmaking_types[matchmaking_types_index]

		local matchmaking_type = matchmaking_type_2

		::label_15_2::

		local num_players = tonumber(lobby_data.num_players)
		local quick_play = lobby_data.quick_play
		local mechanism = lobby_data.mechanism

		if not is_matchmaking or not mission_id or not difficulty or num_players == self._max_num_members then
			return false
		end

		if difficulty and mechanism ~= "weave" then
			local difficulty_settings = DifficultySettings[difficulty]

			if difficulty_settings.extra_requirement_name then
				local extra_requirement = ExtraDifficultyRequirements[difficulty_settings.extra_requirement_name]

				if not Development.parameter("unlock_all_difficulties") and not extra_requirement.requirement_function() then
					return false
				end
			end

			if difficulty_settings.dlc_requirement then
				REQUIRED_DLCS[difficulty_settings.dlc_requirement] = true
			end
		end

		local player_manager = Managers.player
		local player = player_manager:local_player()
		local statistics_db = player_manager:statistics_db()
		local player_stats_id = player:stats_id()
		local level_key = mission_id
		local mechanism_settings = MechanismSettings[mechanism]

		if mechanism_settings and mechanism_settings.required_dlc then
			REQUIRED_DLCS[mechanism_settings.required_dlc] = true
		end

		for dlc_name, _ in pairs(REQUIRED_DLCS) do
			if not Managers.unlock:is_dlc_unlocked(dlc_name) then
				return false
			end
		end

		if mechanism == "weave" then
			local weave_template = WeaveSettings.templates[mission_id]

			if weave_template and not weave_template.objectives[1].level_id then
				-- Nothing
			end
		end

		local level_unlocked = LevelUnlockUtils.level_unlocked(statistics_db, player_stats_id, level_key)

		if not level_unlocked then
			return false
		end

		if mechanism ~= "weave" then
			local private_game = MatchmakingManager.is_lobby_private(lobby_data)

			if not private_game then
				local profile_name = player:profile_display_name()
				local career_name = player:career_name()
				local has_required_power_level = Managers.matchmaking:has_required_power_level(lobby_data, profile_name, career_name)

				if not has_required_power_level then
					return false
				end
			end
		end
	elseif is_server then
		local wanted_server_name = self._current_server_name

		if wanted_server_name ~= "" and string.find(lobby_data.server_info.name, wanted_server_name) == nil then
			return false
		end
	else
		ferror("Sanity check")
	end

	return true
end

StartGameWindowLobbyBrowserConsole._is_friend_lobby = function (self, lobby_data)
	-- function 16
	local name = lobby_data.name

	print(name, self._friend_names[name])

	return self._friend_names[name] ~= nil
end

StartGameWindowLobbyBrowserConsole.input_service = function (self)
	-- function 17
	return self._parent:window_input_service()
end

StartGameWindowLobbyBrowserConsole.dirty = function (self)
	-- function 18
	local dirty = self._dirty

	self._dirty = false

	return dirty
end

StartGameWindowLobbyBrowserConsole._update_auto_refresh = function (self, dt)
	-- function 19
	local is_refreshing = self:_is_refreshing()
	local _lobby_list_update_timer = self._lobby_list_update_timer

	if not _lobby_list_update_timer then
		-- Nothing
	end

	_lobby_list_update_timer = MatchmakingSettings.TIME_BETWEEN_EACH_SEARCH

	local lobby_list_update_timer = _lobby_list_update_timer

	::label_19_0::

	if lobby_list_update_timer then
		lobby_list_update_timer = lobby_list_update_timer - dt

		if lobby_list_update_timer < 0 and not is_refreshing then
			self._lobby_list_update_timer = MatchmakingSettings.TIME_BETWEEN_EACH_SEARCH

			local skip_populate = true

			self:_search(skip_populate)
		else
			self._lobby_list_update_timer = lobby_list_update_timer
		end
	end

	if self._was_refreshing and not is_refreshing then
		self._dirty = true
	end

	self._was_refreshing = is_refreshing
end

StartGameWindowLobbyBrowserConsole.reset_filters = function (self, selected_game_mode, selected_level, selected_difficulty, selected_filter, selected_distance)
	-- function 20
	self:set_level(not not selected_level or not not "any")
	self:set_difficulty(not not selected_difficulty or not not "any")

	local var_20_0 = self
	local set_lobby_filter = self.set_lobby_filter
	local flag

	flag = not not selected_filter or (BUILD == "dev" or BUILD == "debug") and not not "lb_show_all" or not not "lb_show_joinable"

	set_lobby_filter(var_20_0, flag)
	self:set_distance_filter(not not selected_distance or not not "map_zone_options_5")
	self:set_game_mode(not not selected_game_mode or not not "any")
	self:_search()
end

StartGameWindowLobbyBrowserConsole._create_filter_requirements = function (self)
	-- function 21
	local lobby_finder = self._lobby_finder
	local game_mode_index = self._selected_game_mode_index
	local var_21_0 = self._game_mode_data.game_modes[self._selected_game_mode_index]

	if not var_21_0 then
		-- Nothing
	end

	var_21_0 = "any"

	local mechanism = var_21_0

	::label_21_0::

	local level_index = self._selected_level_index
	local levels_table = self:_get_levels()
	local level_key = levels_table[level_index]
	local difficulty_index = self._selected_difficulty_index
	local difficulty_table = self:_get_difficulties()
	local difficulty_key = difficulty_table[difficulty_index]
	local only_show_valid_lobbies = not script_data.show_invalid_lobbies
	local distance_index = self._selected_distance_index
	local distance_filter = LobbyAux.map_lobby_distance_filter[distance_index]
	local show_lobbies_index = self._selected_show_lobbies_index
	local only_show_joinable = definitions.show_lobbies_table[show_lobbies_index] == "lb_show_joinable"
	local free_slots = 1
	local requirements = {
		filters = {},
		near_filters = {},
		free_slots = free_slots,
		distance_filter = not IS_PS4 and not not distance_filter
	}

	if IS_PS4 then
		local user_region = Managers.account:region()

		if distance_filter == "close" then
			local filters = requirements.filters
			local tbl = {
				comparison = "equal"
			}
			local var_21_3 = MatchmakingRegionLookup.primary[user_region]

			if not var_21_3 then
				var_21_3 = MatchmakingRegionLookup.secondary[user_region]
				var_21_3 = not not var_21_3 or not not "default"
			end

			tbl.value = var_21_3
			filters.primary_region = tbl
		elseif distance_filter == "medium" then
			local filters_2 = requirements.filters
			local tbl_2 = {
				comparison = "equal"
			}
			local var_21_6 = MatchmakingRegionLookup.secondary[user_region]

			if not var_21_6 then
				var_21_6 = MatchmakingRegionLookup.primary[user_region]
				var_21_6 = not not var_21_6 or not not "default"
			end

			tbl_2.value = var_21_6
			filters_2.secondary_region = tbl_2
		end
	end

	local eac_authorized = Managers.eac:is_trusted()
	local filters_3 = requirements.filters
	local tbl_3 = {
		comparison = "equal"
	}
	local flag

	flag = (not eac_authorized or not "true") and not not "false"
	tbl_3.value = flag
	filters_3.eac_authorized = tbl_3

	if difficulty_key ~= "any" and difficulty_key then
		requirements.filters.difficulty = {
			comparison = "equal",
			value = difficulty_key
		}
	end

	if level_key ~= "any" and level_key then
		requirements.filters.selected_mission_id = {
			comparison = "equal",
			value = level_key
		}
	end

	if mechanism ~= "any" and mechanism then
		requirements.filters.mechanism = {
			comparison = "equal",
			value = mechanism
		}
	end

	if only_show_valid_lobbies then
		requirements.filters.network_hash = {
			comparison = "equal",
			value = lobby_finder:network_hash()
		}
	end

	if only_show_joinable then
		requirements.filters.matchmaking = {
			value = "false",
			comparison = "not_equal"
		}
	end

	return requirements
end

StartGameWindowLobbyBrowserConsole._join = function (self, lobby_data, join_params)
	-- function 22
	Managers.matchmaking:request_join_lobby(lobby_data, join_params)

	self.join_lobby_data_id = lobby_data.id
end

StartGameWindowLobbyBrowserConsole._search = function (self, skip_populate)
	-- function 23
	local requirements = self:_create_filter_requirements()
	local lobby_finder = self._lobby_finder

	if IS_WINDOWS then
		local lobby_browser = lobby_finder:get_lobby_browser()

		LobbyInternal.clear_filter_requirements(lobby_browser)
	else
		LobbyInternal.clear_filter_requirements()
	end

	local force_refresh = true

	lobby_finder:add_filter_requirements(requirements, force_refresh)

	self._searching = true
	self._do_populate = not skip_populate
end

StartGameWindowLobbyBrowserConsole._get_game_modes = function (self)
	-- function 24
	local game_mode_data = self._game_mode_data
	local game_modes = game_mode_data.game_modes

	return game_modes
end

StartGameWindowLobbyBrowserConsole._get_levels = function (self)
	-- function 25
	local game_mode_data = self._game_mode_data
	local game_modes = game_mode_data.game_modes
	local _selected_game_mode_index = self._selected_game_mode_index

	if not _selected_game_mode_index then
		-- Nothing
	end

	_selected_game_mode_index = game_modes.adventure

	local game_mode_index = _selected_game_mode_index

	::label_25_0::

	local data = game_mode_data[game_mode_index]
	local levels = data.levels

	return levels
end

StartGameWindowLobbyBrowserConsole._get_difficulties = function (self)
	-- function 26
	local game_mode_data = self._game_mode_data
	local game_modes = game_mode_data.game_modes
	local _selected_game_mode_index = self._selected_game_mode_index

	if not _selected_game_mode_index then
		-- Nothing
	end

	_selected_game_mode_index = game_modes.adventure

	local game_mode_index = _selected_game_mode_index

	::label_26_0::

	local var_26_1 = game_mode_data[game_mode_index]

	if not var_26_1 then
		-- Nothing
	end

	var_26_1 = game_mode_data[1]

	local data = var_26_1

	::label_26_1::

	local difficulties = data.difficulties

	return difficulties
end

StartGameWindowLobbyBrowserConsole.completed_level_difficulty_index = function (self, lobby_data)
	-- function 27
	local level_key = lobby_data.selected_mission_id
	local completed_level_difficulty_index = LevelUnlockUtils.completed_level_difficulty_index(self._statistics_db, self._stats_id, level_key)

	if not completed_level_difficulty_index then
		-- Nothing
	end

	completed_level_difficulty_index = 0

	local completed_difficulty_index = completed_level_difficulty_index

	::label_27_0::

	return completed_difficulty_index
end

StartGameWindowLobbyBrowserConsole.refresh = function (self)
	-- function 28
	if not self:_is_refreshing() then
		self:_search()
	end
end

StartGameWindowLobbyBrowserConsole.set_game_mode = function (self, game_mode)
	-- function 29
	local game_modes_table = self:_get_game_modes()
	local new_index = table.find(game_modes_table, game_mode)
	local game_mode_display_name = "lobby_browser_mission"
	local game_mode = game_modes_table[new_index]

	if game_mode and game_mode ~= "any" then
		game_mode_display_name = GAME_TYPE_LOOKUP_STRINGS[game_mode]
	end

	self._selected_game_mode_index = new_index
	self._search_timer = input_delay_before_start_new_search
	self._do_populate = true

	self:set_level("any")
	self._lobby_browser_console_ui:set_game_type_filter(Localize(game_mode_display_name))
	self._lobby_browser_console_ui:setup_filter_entries()
end

StartGameWindowLobbyBrowserConsole.set_level = function (self, level)
	-- function 30
	local levels_table = self:_get_levels()
	local new_index = table.find(levels_table, level)
	local level_display_name = "lobby_browser_mission"
	local level = levels_table[new_index]

	if level ~= "any" then
		local level_setting = LevelSettings[level]

		level_display_name = level_setting.display_name
	end

	self._selected_level_index = new_index
	self._search_timer = input_delay_before_start_new_search

	self._lobby_browser_console_ui:set_level_filter(Localize(level_display_name))
end

StartGameWindowLobbyBrowserConsole.set_difficulty = function (self, difficulty)
	-- function 31
	local difficulties_table = self:_get_difficulties()
	local new_index = table.find(difficulties_table, difficulty)
	local difficulty_display_name = "lobby_browser_difficulty"
	local difficulty = difficulties_table[new_index]

	if difficulty ~= "any" then
		local difficulty_setting = DifficultySettings[difficulty]

		difficulty_display_name = difficulty_setting.display_name
	end

	self._selected_difficulty_index = new_index
	self._search_timer = input_delay_before_start_new_search

	self._lobby_browser_console_ui:set_difficulty_filter(Localize(difficulty_display_name))
end

StartGameWindowLobbyBrowserConsole.set_lobby_filter = function (self, lobby_filter)
	-- function 32
	local show_lobbies_table = definitions.show_lobbies_table
	local new_index = table.find(show_lobbies_table, lobby_filter)
	local show_lobbies_text = show_lobbies_table[new_index]

	self._selected_show_lobbies_index = new_index
	self._search_timer = input_delay_before_start_new_search

	self._lobby_browser_console_ui:set_show_lobbies_filter(Localize(show_lobbies_text))
end

StartGameWindowLobbyBrowserConsole.set_distance_filter = function (self, distance)
	-- function 33
	local distance_table = definitions.distance_table
	local new_index = table.find(distance_table, distance)
	local distance_text = distance_table[new_index]

	self._selected_distance_index = new_index
	self._search_timer = input_delay_before_start_new_search

	self._lobby_browser_console_ui:set_distance_filter(Localize(distance_text))
end

StartGameWindowLobbyBrowserConsole.is_lobby_joinable = function (self, lobby_data)
	-- function 34
	local selected_mission_id = lobby_data.selected_mission_id

	if not selected_mission_id then
		-- Nothing
	end

	selected_mission_id = lobby_data.mission_id

	local mission_id = selected_mission_id

	::label_34_0::

	local difficulty = lobby_data.difficulty
	local num_players = tonumber(lobby_data.num_players)
	local mechanism = lobby_data.mechanism
	local matchmaking_settings = Managers.matchmaking.get_matchmaking_settings_for_mechanism(mechanism)

	if Managers.matchmaking:is_game_matchmaking() then
		return false, "cannot_join_while_matchmaking"
	end

	if not mission_id or not difficulty or mission_id == "n/a" then
		return false, "dlc1_2_difficulty_unavailable"
	end

	if num_players == matchmaking_settings.MAX_NUMBER_OF_PLAYERS then
		return false, "lobby_is_full"
	end

	local current_lobby = Managers.state.network:lobby()
	local host = current_lobby:lobby_host()

	if lobby_data.host == host then
		return false, "lobby_browser_own_server_error"
	end

	if MatchmakingManager.is_lobby_private(lobby_data) or lobby_data.matchmaking == "false" then
		return false, "not_searching_for_players"
	end

	if not lobby_data.valid then
		return false, "lobby_id_mismatch"
	end

	if Managers.matchmaking:is_matchmaking_paused() then
		return false, "painting_none_name"
	end

	local statistics_db = self._statistics_db
	local player_stats_id = self._stats_id
	local profile_name = self._profile_name
	local career_name = self._career_name
	local required_dlcs = {}
	local weave_quick_game = lobby_data.weave_quick_game == "true"
	local mechanism_settings = MechanismSettings[mechanism]
	local difficulty_lock_reason

	if mechanism == "weave" then
		if mission_id ~= "false" and not weave_quick_game then
			local weave_name = mission_id
			local weave_disabled = LevelUnlockUtils.weave_disabled(weave_name)

			if weave_disabled then
				return false, "weave_disabled"
			end

			local ignore_dlc_check = false
			local weave_unlocked_2 = LevelUnlockUtils.weave_unlocked(statistics_db, player_stats_id, weave_name, ignore_dlc_check)

			if not weave_unlocked_2 then
				-- Nothing
			end

			if weave_name ~= self._current_weave then
				weave_unlocked_2 = false

				goto label_34_1
			end

			weave_unlocked_2 = true

			local weave_unlocked = weave_unlocked_2

			::label_34_1::

			if not weave_unlocked then
				return false, "weave_not_unlocked"
			end
		end
	elseif mechanism == "deus" and DeusJourneySettings[mission_id] then
		local unlocked_journeys = LevelUnlockUtils.unlocked_journeys(statistics_db, player_stats_id)
		local journey_unlocked = table.find(unlocked_journeys, mission_id)

		if not journey_unlocked then
			return false, "start_game_level_locked"
		end

		if difficulty then
			local difficulty_settings = DifficultySettings[difficulty]

			if difficulty_settings.extra_requirement_name then
				local extra_requirement = ExtraDifficultyRequirements[difficulty_settings.extra_requirement_name]

				if not Development.parameter("unlock_all_difficulties") and not extra_requirement.requirement_function() then
					return false, "difficulty_requirements_not_met"
				end
			end

			if difficulty_settings.dlc_requirement then
				required_dlcs[difficulty_settings.dlc_requirement] = true
			end
		end
	elseif mechanism == "versus" then
		if Managers.mechanism:current_mechanism_name() ~= "versus" then
			return false, "vs_player_hosted_lobby_wrong_mechanism_error"
		end
	else
		local level_key = mission_id
		local level_unlocked = level_key == "any" or not not LevelUnlockUtils.level_unlocked(statistics_db, player_stats_id, level_key)

		if not level_unlocked then
			local settings = LevelSettings[level_key]
			local dlc_name = settings.dlc_name

			if dlc_name then
				local is_unlocked = Managers.unlock:is_dlc_unlocked(dlc_name)

				if not is_unlocked then
					return false, "dlc1_2_dlc_level_locked_tooltip"
				else
					return false, "start_game_level_locked"
				end
			else
				return false, "start_game_level_locked"
			end
		end

		if mechanism_settings and mechanism_settings.extra_requirements_function and not mechanism_settings.extra_requirements_function() then
			return false, "game_mode_requirements_not_met"
		end

		if mechanism ~= "deus" then
			local private_game = MatchmakingManager.is_lobby_private(lobby_data)

			if not private_game then
				local has_required_power_level = Managers.matchmaking:has_required_power_level(lobby_data, profile_name, career_name)

				if not has_required_power_level then
					return false, "difficulty_blocked_by_me"
				end
			end
		end

		if difficulty then
			local difficulty_settings = DifficultySettings[difficulty]

			if difficulty_settings.extra_requirement_name then
				local extra_requirement = ExtraDifficultyRequirements[difficulty_settings.extra_requirement_name]

				if not Development.parameter("unlock_all_difficulties") and not extra_requirement.requirement_function() then
					difficulty_lock_reason = "difficulty_requirements_not_met"
				end
			end

			if difficulty_settings.dlc_requirement then
				required_dlcs[difficulty_settings.dlc_requirement] = true
			end
		end
	end

	if mechanism_settings and mechanism_settings.required_dlc then
		required_dlcs[mechanism_settings.required_dlc] = true
	end

	for dlc_name, _ in pairs(required_dlcs) do
		if not Managers.unlock:is_dlc_unlocked(dlc_name) then
			return false, "dlc1_2_dlc_level_locked_tooltip"
		end
	end

	if difficulty_lock_reason then
		return false, difficulty_lock_reason
	end

	return true, "tutorial_no_text"
end
