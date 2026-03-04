-- chunkname: @scripts/ui/views/start_game_view/states/start_game_window_layout.lua

local var_0_0 = {
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
local var_0_1 = {
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
		can_add_function = function (arg_1_0)
			return arg_1_0:is_in_mechanism("adventure")
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
		can_add_function = function (arg_2_0)
			return arg_2_0:is_in_mechanism("adventure")
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
		can_add_function = function (arg_3_0)
			return arg_3_0:is_in_mechanism("adventure")
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
		can_add_function = function (arg_4_0)
			return arg_4_0:is_in_mechanism("adventure") and arg_4_0:can_use_streaming()
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
		can_add_function = function (arg_5_0)
			return arg_5_0:is_in_mechanism("adventure")
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
local var_0_2 = {
	adventure = {
		game_mode_type = "custom",
		difficulty_index_getter_name = "completed_level_difficulty_index",
		layout_name = "area_selection_custom"
	}
}
local var_0_3 = {
	adventure = {
		game_mode_type = "twitch",
		difficulty_index_getter_name = "completed_level_difficulty_index",
		layout_name = "area_selection_twitch"
	}
}
local var_0_4 = {
	adventure = {
		game_mode_type = "adventure",
		layout_name = "difficulty_selection_adventure"
	}
}
local var_0_5 = {}

DLCUtils.map("start_game_window_layout", function (arg_6_0)
	local var_6_0 = arg_6_0.windows

	if var_6_0 then
		for iter_6_0, iter_6_1 in pairs(var_6_0) do
			var_0_0[iter_6_0] = iter_6_1
		end
	end

	local var_6_1 = arg_6_0.window_layouts

	if var_6_1 then
		for iter_6_2 = 1, #var_6_1 do
			var_0_1[#var_0_1 + 1] = var_6_1[iter_6_2]
		end
	end

	local var_6_2 = arg_6_0.mechanism_custom_game

	if var_6_2 then
		local var_6_3 = var_6_2.mechanism_name

		fassert(var_0_2[var_6_3] == nil, "Trying to set custom_game for the mechanism '%s' which is already set.", var_6_3)

		var_0_2[var_6_3] = var_6_2
	end

	local var_6_4 = arg_6_0.mechanism_twitch

	if var_6_4 then
		local var_6_5 = var_6_4.mechanism_name

		fassert(var_0_3[var_6_5] == nil, "Trying to set twitch for the mechanism '%s' which is already set.", var_6_5)

		var_0_3[var_6_5] = var_6_4
	end

	local var_6_6 = arg_6_0.mechanism_quickplay

	if var_6_6 then
		local var_6_7 = var_6_6.mechanism_name
		local var_6_8 = var_6_6.layout_name
		local var_6_9 = var_6_6.game_mode_type

		fassert(var_0_4[var_6_7] == nil, "Trying to set twitch for the mechanism '%s' which is already set.", var_6_7)

		var_0_4[var_6_7] = {
			layout_name = var_6_8,
			game_mode_type = var_6_9
		}
	end
end)
DLCUtils.merge("start_game_save_data_table_map", var_0_5)

local var_0_6 = math.huge

table.sort(var_0_1, function (arg_7_0, arg_7_1)
	return (arg_7_0.panel_sorting or var_0_6) < (arg_7_1.panel_sorting or var_0_6)
end)

local var_0_7 = 4
local var_0_8 = 3

return {
	max_alignment_windows = var_0_8,
	max_active_windows = var_0_7,
	windows = var_0_0,
	window_layouts = var_0_1,
	mechanism_custom_game_settings = var_0_2,
	mechanism_twitch_settings = var_0_3,
	mechanism_quickplay_settings = var_0_4,
	save_data_table_maps = var_0_5
}
