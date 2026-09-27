-- chunkname: @scripts/ui/views/start_game_view/states/start_game_window_layout.lua

local tbl = {
	game_mode = {
		class_name = "StartGameWindowGameMode",
		name = "game_mode"
	},
	adventure = {
		class_name = "StartGameWindowAdventure",
		name = "adventure"
	},
	adventure_settings = {
		class_name = "StartGameWindowAdventureSettings",
		name = "adventure_settings"
	},
	settings = {
		class_name = "StartGameWindowSettings",
		name = "settings"
	},
	mission = {
		class_name = "StartGameWindowMission",
		name = "mission"
	},
	mutator = {
		class_name = "StartGameWindowMutator",
		name = "mutator"
	},
	mutator_list = {
		class_name = "StartGameWindowMutatorList",
		name = "mutator_list"
	},
	mutator_grid = {
		class_name = "StartGameWindowMutatorGrid",
		name = "mutator_grid"
	},
	mutator_summary = {
		class_name = "StartGameWindowMutatorSummary",
		name = "mutator_summary"
	},
	difficulty = {
		class_name = "StartGameWindowDifficulty",
		name = "difficulty"
	},
	mission_selection = {
		class_name = "StartGameWindowMissionSelection",
		name = "mission_selection"
	},
	twitch_login = {
		class_name = "StartGameWindowTwitchLogin",
		name = "twitch_login"
	},
	twitch_game_settings = {
		class_name = "StartGameWindowTwitchGameSettings",
		name = "twitch_game_settings"
	},
	lobby_browser = {
		class_name = "StartGameWindowLobbyBrowser",
		name = "lobby_browser"
	},
	area_selection = {
		class_name = "StartGameWindowAreaSelection",
		name = "area_selection"
	},
	adventure_mode = {
		class_name = "StartGameWindowAdventureMode",
		name = "adventure_mode"
	},
	adventure_mode_settings = {
		class_name = "StartGameWindowAdventureModeSettings",
		name = "adventure_mode_settings"
	}
}
local tbl_2 = {
	{
		sound_event_enter = "play_gui_lobby_button_00_quickplay",
		name = "adventure",
		display_name = "start_game_window_adventure_title",
		background_icon_name = "menu_options_button_image_02",
		game_mode_option = true,
		save_data_table = "adventure",
		panel_sorting = 10,
		close_on_exit = true,
		icon_name = "options_button_icon_quickplay",
		windows = {
			adventure_settings = 3,
			game_mode = 1,
			adventure = 2
		},
		can_add_function = function (self)
			-- function 1
			return self:is_in_mechanism("adventure")
		end
	},
	{
		sound_event_enter = "play_gui_lobby_button_00_custom",
		name = "custom_game",
		display_name = "start_game_window_specific_title",
		background_icon_name = "menu_options_button_image_04",
		game_mode_option = true,
		save_data_table = "custom",
		panel_sorting = 20,
		close_on_exit = true,
		icon_name = "options_button_icon_custom",
		windows = {
			settings = 3,
			game_mode = 1,
			mission = 2
		},
		can_add_function = function (self)
			-- function 2
			return self:is_in_mechanism("adventure")
		end
	},
	{
		sound_event_enter = "play_gui_lobby_button_00_heroic_deed",
		name = "heroic_deeds",
		display_name = "start_game_window_mutator_title",
		background_icon_name = "menu_options_button_image_05",
		game_mode_option = true,
		save_data_table = "deeds",
		panel_sorting = 30,
		close_on_exit = true,
		icon_name = "options_button_icon_deed",
		windows = {
			mutator = 2,
			game_mode = 1,
			mutator_list = 3
		},
		can_add_function = function (self)
			-- function 3
			return self:is_in_mechanism("adventure")
		end
	},
	{
		sound_event_enter = "play_gui_lobby_button_00_custom",
		name = "twitch",
		display_name = "start_game_window_twitch",
		background_icon_name = "menu_options_button_image_03",
		game_mode_option = true,
		save_data_table = "twitch",
		panel_sorting = 40,
		close_on_exit = true,
		icon_name = "options_button_icon_twitch",
		windows = {
			twitch_login = 2,
			game_mode = 1,
			twitch_game_settings = 3
		},
		can_add_function = function (self)
			-- function 4
			local is_in_mechanism = self:is_in_mechanism("adventure")

			is_in_mechanism = not is_in_mechanism and self:can_use_streaming()

			return is_in_mechanism
		end
	},
	{
		sound_event_enter = "play_gui_lobby_button_00_lobby_browser",
		display_name = "start_game_window_lobby_browser",
		name = "lobby_browser",
		reset_on_exit = true,
		save_data_table = "lobby_browser",
		close_on_exit = false,
		icon_name = "lobby_browser_icon",
		windows = {
			lobby_browser = 1
		},
		can_add_function = function (self)
			-- function 5
			return self:is_in_mechanism("adventure")
		end
	},
	{
		sound_event_enter = "play_gui_lobby_button_01_difficulty",
		name = "difficulty_selection_adventure",
		save_data_table = "adventure",
		close_on_exit = false,
		windows = {
			difficulty = 1
		}
	},
	{
		sound_event_enter = "play_gui_lobby_button_01_difficulty",
		name = "difficulty_selection_custom",
		display_name = "start_game_window_difficulty",
		save_data_table = "custom",
		close_on_exit = false,
		windows = {
			difficulty = 1
		}
	},
	{
		sound_event_enter = "play_gui_lobby_button_01_difficulty",
		name = "difficulty_selection_twitch",
		display_name = "start_game_window_difficulty",
		save_data_table = "twitch",
		close_on_exit = false,
		windows = {
			difficulty = 1
		}
	},
	{
		sound_event_enter = "play_gui_lobby_button_02_mission_select",
		name = "area_selection_custom",
		display_name = "start_game_window_mission",
		save_data_table = "custom",
		close_on_exit = false,
		windows = {
			area_selection = 1
		}
	},
	{
		sound_event_enter = "play_gui_lobby_button_02_mission_select",
		name = "mission_selection_custom",
		save_data_table = "custom",
		close_on_exit = false,
		windows = {
			mission_selection = 1
		}
	},
	{
		sound_event_enter = "play_gui_lobby_button_02_mission_select",
		name = "area_selection_twitch",
		display_name = "start_game_window_mission",
		save_data_table = "twitch",
		close_on_exit = false,
		windows = {
			area_selection = 1
		}
	},
	{
		sound_event_enter = "play_gui_lobby_button_02_mission_select",
		name = "mission_selection_twitch",
		save_data_table = "twitch",
		close_on_exit = false,
		windows = {
			mission_selection = 1
		}
	},
	{
		sound_event_enter = "play_gui_lobby_button_04_heroic_deed_select",
		name = "heroic_deed_selection",
		display_name = "start_game_window_mutator_desc",
		save_data_table = "deeds",
		close_on_exit = false,
		windows = {
			mutator_summary = 3,
			mutator_grid = 1
		}
	}
}
local tbl_3 = {
	adventure = {
		game_mode_type = "custom",
		difficulty_index_getter_name = "completed_level_difficulty_index",
		layout_name = "area_selection_custom"
	}
}
local tbl_4 = {
	adventure = {
		game_mode_type = "twitch",
		difficulty_index_getter_name = "completed_level_difficulty_index",
		layout_name = "area_selection_twitch"
	}
}
local tbl_5 = {
	adventure = {
		game_mode_type = "adventure",
		layout_name = "difficulty_selection_adventure"
	}
}
local tbl_6 = {}

DLCUtils.map("start_game_window_layout", function (self)
	-- function 6
	local windows = self.windows

	if not windows then
		for k, v in pairs(windows) do
			tbl[k] = v
		end
	end

	local window_layouts = self.window_layouts

	if not window_layouts then
		for k_2 = 1, #window_layouts do
			tbl_2[#tbl_2 + 1] = window_layouts[k_2]
		end
	end

	local mechanism_custom_game = self.mechanism_custom_game

	if not mechanism_custom_game then
		local mechanism_name = mechanism_custom_game.mechanism_name

		fassert(tbl_3[mechanism_name] == nil, "Trying to set custom_game for the mechanism '%s' which is already set.", mechanism_name)

		tbl_3[mechanism_name] = mechanism_custom_game
	end

	local mechanism_twitch = self.mechanism_twitch

	if not mechanism_twitch then
		local mechanism_name_2 = mechanism_twitch.mechanism_name

		fassert(tbl_4[mechanism_name_2] == nil, "Trying to set twitch for the mechanism '%s' which is already set.", mechanism_name_2)

		tbl_4[mechanism_name_2] = mechanism_twitch
	end

	local mechanism_quickplay = self.mechanism_quickplay

	if not mechanism_quickplay then
		local mechanism_name_3 = mechanism_quickplay.mechanism_name
		local layout_name = mechanism_quickplay.layout_name
		local game_mode_type = mechanism_quickplay.game_mode_type

		fassert(tbl_5[mechanism_name_3] == nil, "Trying to set twitch for the mechanism '%s' which is already set.", mechanism_name_3)

		tbl_5[mechanism_name_3] = {
			layout_name = layout_name,
			game_mode_type = game_mode_type
		}
	end
end)
DLCUtils.merge("start_game_save_data_table_map", tbl_6)

local huge = math.huge

table.sort(tbl_2, function (self, arg_7_1)
	-- function 7
	local panel_sorting = self.panel_sorting

	panel_sorting = panel_sorting or huge

	local panel_sorting_2 = arg_7_1.panel_sorting

	panel_sorting_2 = panel_sorting_2 or huge

	return panel_sorting < panel_sorting_2
end)

local num = 4
local num_2 = 3

return {
	max_alignment_windows = num_2,
	max_active_windows = num,
	windows = tbl,
	window_layouts = tbl_2,
	mechanism_custom_game_settings = tbl_3,
	mechanism_twitch_settings = tbl_4,
	mechanism_quickplay_settings = tbl_5,
	save_data_table_maps = tbl_6
}
