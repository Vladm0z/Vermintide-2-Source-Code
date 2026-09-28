-- chunkname: @scripts/ui/views/start_game_view/states/start_game_window_layout_console.lua

local windows = {
	panel = {
		ignore_alignment = true,
		name = "panel",
		class_name = "StartGameWindowPanelConsole"
	},
	background = {
		ignore_alignment = true,
		name = "background",
		class_name = "StartGameWindowBackgroundConsole"
	},
	custom_game_overview = {
		ignore_alignment = true,
		name = "custom_game_overview",
		class_name = "StartGameWindowCustomGameOverviewConsole"
	},
	adventure_overview = {
		ignore_alignment = true,
		name = "adventure_overview",
		class_name = "StartGameWindowAdventureOverviewConsole"
	},
	additional_settings = {
		ignore_alignment = true,
		name = "additional_settings",
		class_name = "StartGameWindowAdditionalSettingsConsole"
	},
	mutator_overview = {
		ignore_alignment = true,
		name = "mutator_overview",
		class_name = "StartGameWindowHeroicDeedOverviewConsole"
	},
	mutator_grid = {
		ignore_alignment = true,
		name = "mutator_grid",
		class_name = "StartGameWindowMutatorGridConsole"
	},
	mutator_summary = {
		ignore_alignment = true,
		name = "mutator_summary",
		class_name = "StartGameWindowMutatorSummaryConsole"
	},
	difficulty = {
		ignore_alignment = true,
		name = "difficulty",
		class_name = "StartGameWindowDifficultyConsole"
	},
	mission_selection = {
		ignore_alignment = true,
		name = "mission_selection",
		class_name = "StartGameWindowMissionSelectionConsole"
	},
	area_selection = {
		ignore_alignment = true,
		name = "area_selection",
		class_name = "StartGameWindowAreaSelectionConsoleV2"
	},
	twitch_overview = {
		ignore_alignment = true,
		name = "twitch_overview",
		class_name = "StartGameWindowTwitchOverviewConsole"
	},
	console_lobby_browser = {
		ignore_alignment = true,
		name = "console_lobby_browser",
		class_name = "StartGameWindowLobbyBrowserConsole"
	}
}
local window_layouts = {
	{
		sound_event_enter = "play_gui_lobby_button_00_quickplay",
		display_name = "start_game_window_adventure_title",
		game_mode_option = true,
		name = "adventure",
		disable_function_name = "_adventure_disable_function",
		save_data_table = "adventure",
		panel_sorting = 10,
		background_object_set = "quick_play",
		input_focus_window = "adventure_overview",
		close_on_exit = true,
		background_flow_event = "quick_play",
		windows = {
			adventure_overview = 3,
			panel = 1,
			background = 2
		},
		can_add_function = function (overview)
			-- function 1
			return overview:is_in_mechanism("adventure")
		end
	},
	{
		sound_event_enter = "play_gui_lobby_button_00_custom",
		display_name = "start_game_window_specific_title",
		game_mode_option = true,
		name = "custom_game",
		disable_function_name = "_custom_game_disable_function",
		save_data_table = "custom",
		panel_sorting = 20,
		background_object_set = "custom_game",
		input_focus_window = "custom_game_overview",
		close_on_exit = true,
		background_flow_event = "custom_game",
		windows = {
			custom_game_overview = 3,
			panel = 1,
			background = 2,
			additional_settings = 4
		},
		can_add_function = function (overview)
			-- function 2
			return overview:is_in_mechanism("adventure")
		end
	},
	{
		sound_event_enter = "play_gui_lobby_button_00_heroic_deed",
		display_name = "start_game_window_mutator_title",
		game_mode_option = true,
		name = "heroic_deeds",
		disable_function_name = "_heroic_deed_disable_function",
		save_data_table = "deeds",
		panel_sorting = 30,
		background_object_set = "deeds",
		input_focus_window = "mutator_overview",
		close_on_exit = true,
		background_flow_event = "deeds",
		windows = {
			mutator_overview = 3,
			panel = 1,
			background = 2,
			mutator_summary = 4
		},
		can_add_function = function (overview)
			-- function 3
			return overview:is_in_mechanism("adventure")
		end
	},
	{
		sound_event_enter = "play_gui_lobby_button_00_custom",
		disable_function_name = "_streaming_disable_function",
		display_name = "start_game_window_twitch",
		game_mode_option = true,
		name = "twitch",
		save_data_table = "custom",
		panel_sorting = 40,
		background_object_set = "twitch",
		input_focus_window = "twitch_overview",
		close_on_exit = true,
		background_flow_event = "twitch",
		windows = {
			twitch_overview = 3,
			panel = 1,
			background = 2
		},
		can_add_function = function (overview)
			-- function 4
			local is_in_mechanism = overview:is_in_mechanism("adventure")

			is_in_mechanism = not not is_in_mechanism and not not overview:can_use_streaming()

			return is_in_mechanism
		end
	},
	{
		sound_event_enter = "play_gui_lobby_button_00_lobby_browser",
		save_data_table = "lobby_browser",
		display_name = "start_game_window_lobby_browser",
		name = "console_lobby_browser",
		disable_function_name = "_lobby_browser_disable_function",
		panel_sorting = 100,
		background_object_set = "lobby_browser",
		close_on_exit = true,
		background_flow_event = "lobby_browser",
		windows = {
			console_lobby_browser = 3,
			panel = 1,
			background = 2
		},
		can_add_function = function (overview)
			-- function 5
			local is_in_mechanism = overview:is_in_mechanism("adventure")

			is_in_mechanism = not not is_in_mechanism and not not not IS_XB1

			return is_in_mechanism
		end
	},
	{
		sound_event_enter = "play_gui_lobby_button_00_custom",
		name = "difficulty_selection_adventure",
		save_data_table = "adventure",
		input_focus_window = "difficulty",
		close_on_exit = false,
		windows = {
			difficulty = 3,
			panel = 1,
			background = 2
		}
	},
	{
		sound_event_enter = "play_gui_lobby_button_00_custom",
		name = "difficulty_selection_custom",
		save_data_table = "custom",
		input_focus_window = "difficulty",
		close_on_exit = false,
		windows = {
			difficulty = 3,
			panel = 1,
			background = 2
		}
	},
	{
		sound_event_enter = "play_gui_lobby_button_00_custom",
		name = "area_selection",
		save_data_table = "custom",
		input_focus_window = "area_selection",
		return_to_top_level = true,
		close_on_exit = false,
		windows = {
			area_selection = 3,
			panel = 1,
			background = 2
		}
	},
	{
		sound_event_enter = "play_gui_lobby_button_00_custom",
		name = "mission_selection",
		save_data_table = "custom",
		input_focus_window = "mission_selection",
		close_on_exit = false,
		windows = {
			panel = 1,
			background = 2,
			mission_selection = 3
		}
	},
	{
		sound_event_enter = "play_gui_lobby_button_04_heroic_deed_select",
		name = "heroic_deed_selection",
		save_data_table = "deeds",
		input_focus_window = "mutator_grid",
		close_on_exit = false,
		windows = {
			mutator_grid = 3,
			panel = 1,
			background = 2,
			mutator_summary = 4
		}
	}
}
local tbl = {
	default = {
		{
			input_action = "confirm",
			priority = 2,
			description_text = "input_description_select"
		},
		{
			input_action = "back",
			priority = 3,
			description_text = "input_description_close"
		},
		{
			input_action = "right_stick_press",
			priority = 4,
			description_text = "input_description_level_preferences",
			content_check_function = function ()
				-- function 6
				return PLATFORM == "xb1" and not not DLCSettings.quick_play_preferences
			end
		},
		{
			input_action = "show_gamercard",
			priority = 5,
			description_text = "map_friend_button_tooltip",
			content_check_function = function ()
				-- function 7
				return not IS_WINDOWS and not not not Managers.account:offline_mode()
			end
		}
	},
	default_custom_game = {
		{
			input_action = "d_vertical",
			priority = 1,
			description_text = "input_description_navigate",
			ignore_keybinding = true
		},
		{
			input_action = "confirm",
			priority = 2,
			description_text = "input_description_select"
		},
		{
			input_action = "back",
			priority = 3,
			description_text = "input_description_close"
		},
		{
			input_action = "right_stick_press",
			priority = 4,
			description_text = "input_description_additional_options"
		},
		{
			input_action = "show_gamercard",
			priority = 5,
			description_text = "map_friend_button_tooltip",
			content_check_function = function ()
				-- function 8
				return not IS_WINDOWS and not not not Managers.account:offline_mode()
			end
		}
	},
	offline_custom_game = {
		{
			input_action = "d_vertical",
			priority = 1,
			description_text = "input_description_navigate",
			ignore_keybinding = true
		},
		{
			input_action = "confirm",
			priority = 2,
			description_text = "input_description_select"
		},
		{
			input_action = "back",
			priority = 3,
			description_text = "input_description_close"
		}
	},
	default_twitch = {
		{
			input_action = "d_vertical",
			priority = 1,
			description_text = "input_description_navigate",
			ignore_keybinding = true
		},
		{
			input_action = "confirm",
			priority = 2,
			description_text = "input_description_select"
		},
		{
			input_action = "back",
			priority = 3,
			description_text = "input_description_close"
		},
		{
			input_action = "special_1",
			priority = 4,
			description_text = "input_description_connect"
		},
		{
			input_action = "show_gamercard",
			priority = 5,
			description_text = "map_friend_button_tooltip",
			content_check_function = function ()
				-- function 9
				return not IS_WINDOWS and not not not Managers.account:offline_mode()
			end
		}
	},
	default_twitch_connected = {
		{
			input_action = "d_vertical",
			priority = 1,
			description_text = "input_description_navigate",
			ignore_keybinding = true
		},
		{
			input_action = "confirm",
			priority = 2,
			description_text = "input_description_select"
		},
		{
			input_action = "back",
			priority = 3,
			description_text = "input_description_close"
		},
		{
			input_action = "special_1",
			priority = 4,
			description_text = "input_description_disconnect"
		},
		{
			input_action = "show_gamercard",
			priority = 5,
			description_text = "map_friend_button_tooltip",
			content_check_function = function ()
				-- function 10
				return not IS_WINDOWS and not not not Managers.account:offline_mode()
			end
		}
	},
	default_twitch_client = {
		{
			input_action = "back",
			priority = 1,
			description_text = "input_description_close"
		},
		{
			input_action = "special_1",
			priority = 2,
			description_text = "input_description_connect"
		},
		{
			input_action = "show_gamercard",
			priority = 3,
			description_text = "map_friend_button_tooltip",
			content_check_function = function ()
				-- function 11
				return not IS_WINDOWS and not not not Managers.account:offline_mode()
			end
		}
	},
	default_twitch_client_connected = {
		{
			input_action = "back",
			priority = 1,
			description_text = "input_description_close"
		},
		{
			input_action = "special_1",
			priority = 2,
			description_text = "input_description_disconnect"
		},
		{
			input_action = "show_gamercard",
			priority = 3,
			description_text = "map_friend_button_tooltip",
			content_check_function = function ()
				-- function 12
				return not IS_WINDOWS and not not not Managers.account:offline_mode()
			end
		}
	},
	default_weave_quick_play = {
		{
			input_action = "d_horizontal",
			priority = 1,
			description_text = "input_description_navigate",
			ignore_keybinding = true
		},
		{
			input_action = "confirm",
			priority = 2,
			description_text = "input_description_select"
		},
		{
			input_action = "back",
			priority = 3,
			description_text = "input_description_close"
		},
		{
			input_action = "show_gamercard",
			priority = 4,
			description_text = "map_friend_button_tooltip",
			content_check_function = function ()
				-- function 13
				return not IS_WINDOWS and not not not Managers.account:offline_mode()
			end
		},
		{
			input_action = "trigger_cycle_next",
			priority = 5,
			description_text = "start_game_window_adventure_header"
		}
	},
	default_weave = {
		{
			input_action = "d_vertical",
			priority = 1,
			description_text = "input_description_select",
			ignore_keybinding = true
		},
		{
			input_action = "back",
			priority = 2,
			description_text = "input_description_close"
		},
		{
			input_action = "show_gamercard",
			priority = 3,
			description_text = "map_friend_button_tooltip",
			content_check_function = function ()
				-- function 14
				return not IS_WINDOWS and not not not Managers.account:offline_mode()
			end
		},
		{
			input_action = "trigger_cycle_next",
			priority = 4,
			description_text = "start_game_window_adventure_header"
		}
	},
	default_weave_find_group = {
		{
			input_action = "back",
			priority = 2,
			description_text = "input_description_close"
		},
		{
			input_action = "show_gamercard",
			priority = 3,
			description_text = "map_friend_button_tooltip",
			content_check_function = function ()
				-- function 15
				return not IS_WINDOWS and not not not Managers.account:offline_mode()
			end
		}
	},
	select_difficulty = {
		ignore_generic_actions = true,
		actions = {
			{
				input_action = "d_vertical",
				priority = 1,
				description_text = "input_description_navigate",
				ignore_keybinding = true
			},
			{
				input_action = "back",
				priority = 3,
				description_text = "input_description_back"
			}
		}
	},
	select_difficulty_buy = {
		ignore_generic_actions = true,
		actions = {
			{
				input_action = "d_vertical",
				priority = 1,
				description_text = "input_description_navigate",
				ignore_keybinding = true
			},
			{
				input_action = "confirm",
				priority = 2,
				description_text = "menu_weave_area_no_wom_button"
			},
			{
				input_action = "back",
				priority = 3,
				description_text = "input_description_back"
			}
		}
	},
	select_difficulty_confirm = {
		ignore_generic_actions = true,
		actions = {
			{
				input_action = "d_vertical",
				priority = 1,
				description_text = "input_description_navigate",
				ignore_keybinding = true
			},
			{
				input_action = "confirm",
				priority = 2,
				description_text = "input_description_select"
			},
			{
				input_action = "back",
				priority = 3,
				description_text = "input_description_back"
			}
		}
	}
}
local tbl_2 = {
	ignore_generic_actions = true
}
local tbl_3 = {
	{
		input_action = "d_horizontal",
		priority = 1,
		description_text = "input_description_navigate",
		ignore_keybinding = true
	}
}
local tbl_4 = {
	input_action = "confirm",
	priority = 2
}
local flag

flag = (not IS_XB1 or not "dlc1_4_input_description_storepage") and not not "buy_now"
tbl_4.description_text = flag
tbl_3[2] = tbl_4
tbl_3[3] = {
	input_action = "back",
	priority = 3,
	description_text = "input_description_back"
}
tbl_2.actions = tbl_3
tbl.select_area_buy = tbl_2
tbl.select_area_base = {
	ignore_generic_actions = true,
	actions = {
		{
			input_action = "d_horizontal",
			priority = 1,
			description_text = "input_description_navigate",
			ignore_keybinding = true
		},
		{
			input_action = "back",
			priority = 3,
			description_text = "input_description_back"
		}
	}
}
tbl.select_area_confirm = {
	ignore_generic_actions = true,
	actions = {
		{
			input_action = "d_horizontal",
			priority = 1,
			description_text = "input_description_navigate",
			ignore_keybinding = true
		},
		{
			input_action = "confirm",
			priority = 2,
			description_text = "input_description_select"
		},
		{
			input_action = "back",
			priority = 3,
			description_text = "input_description_back"
		}
	}
}
tbl.select_mission = {
	ignore_generic_actions = true,
	actions = {
		{
			input_action = "d_pad",
			priority = 1,
			description_text = "input_description_navigate",
			ignore_keybinding = true
		},
		{
			input_action = "back",
			priority = 3,
			description_text = "input_description_back"
		}
	}
}
tbl.select_mission_confirm = {
	ignore_generic_actions = true,
	actions = {
		{
			input_action = "d_pad",
			priority = 1,
			description_text = "input_description_navigate",
			ignore_keybinding = true
		},
		{
			input_action = "confirm",
			priority = 2,
			description_text = "input_description_select"
		},
		{
			input_action = "back",
			priority = 3,
			description_text = "input_description_back"
		}
	}
}
tbl.select_heroic_deed = {
	ignore_generic_actions = true,
	actions = {
		{
			input_action = "d_pad",
			priority = 1,
			description_text = "input_description_navigate",
			ignore_keybinding = true
		},
		{
			input_action = "confirm",
			priority = 2,
			description_text = "input_description_select"
		},
		{
			input_action = "back",
			priority = 3,
			description_text = "input_description_back"
		},
		{
			input_action = "right_stick_press",
			priority = 4,
			description_text = "input_description_mark_delete"
		},
		{
			input_action = "special_1",
			priority = 5,
			description_text = "input_description_delete_selection"
		},
		{
			input_action = "refresh",
			priority = 6,
			description_text = "input_description_clear_all"
		}
	}
}
tbl.play_available = {
	actions = {
		{
			input_action = "refresh",
			priority = 6,
			description_text = "input_description_play"
		}
	}
}
tbl.play_available_lock = {
	actions = {
		{
			input_action = "refresh",
			priority = 6,
			description_text = "input_description_play"
		},
		{
			input_action = "right_stick_press",
			priority = 7,
			description_text = "start_game_window_disallow_join"
		}
	}
}
tbl.search_available = {
	actions = {
		{
			input_action = "refresh",
			priority = 6,
			description_text = "lb_search"
		}
	}
}
tbl.cancel_matchmaking = {
	actions = {
		{
			input_action = "refresh",
			priority = 6,
			description_text = "cancel_matchmaking"
		}
	}
}
tbl.cancel_matchmaking_lock = {
	actions = {
		{
			input_action = "refresh",
			priority = 6,
			description_text = "cancel_matchmaking"
		},
		{
			input_action = "right_stick_press",
			priority = 7,
			description_text = "start_game_window_disallow_join"
		}
	}
}
tbl.set_next_weave_available = {
	actions = {
		{
			input_action = "refresh",
			priority = 1,
			description_text = "input_description_play"
		}
	}
}
tbl.play_available_set_next_weave_available = {
	actions = {
		{
			input_action = "special_1",
			priority = 1,
			description_text = "input_description_set_next_weave"
		},
		{
			input_action = "refresh",
			priority = 6,
			description_text = "input_description_play"
		}
	}
}
tbl.cancel_available_set_next_weave_available = {
	actions = {
		{
			input_action = "special_1",
			priority = 1,
			description_text = "input_description_set_next_weave"
		},
		{
			input_action = "refresh",
			priority = 6,
			description_text = "cancel_matchmaking"
		}
	}
}
tbl.set_next_weave_available = {
	actions = {
		{
			input_action = "special_1",
			priority = 1,
			description_text = "input_description_set_next_weave"
		}
	}
}
tbl.set_next_weave_available_lock = {
	actions = {
		{
			input_action = "refresh",
			priority = 1,
			description_text = "input_description_play"
		},
		{
			input_action = "right_stick_press",
			priority = 7,
			description_text = "start_game_window_disallow_join"
		}
	}
}
tbl.play_available_set_next_weave_available_lock = {
	actions = {
		{
			input_action = "special_1",
			priority = 1,
			description_text = "input_description_set_next_weave"
		},
		{
			input_action = "refresh",
			priority = 6,
			description_text = "input_description_play"
		},
		{
			input_action = "right_stick_press",
			priority = 7,
			description_text = "start_game_window_disallow_join"
		}
	}
}
tbl.cancel_available_set_next_weave_available_lock = {
	actions = {
		{
			input_action = "special_1",
			priority = 1,
			description_text = "input_description_set_next_weave"
		},
		{
			input_action = "refresh",
			priority = 6,
			description_text = "cancel_matchmaking"
		},
		{
			input_action = "right_stick_press",
			priority = 7,
			description_text = "start_game_window_disallow_join"
		}
	}
}
tbl.set_next_weave_available_lock = {
	actions = {
		{
			input_action = "special_1",
			priority = 1,
			description_text = "input_description_set_next_weave"
		},
		{
			input_action = "right_stick_press",
			priority = 7,
			description_text = "start_game_window_disallow_join"
		}
	}
}
tbl.default_lobby_browser = {
	{
		input_action = "left_stick",
		priority = 1,
		description_text = "input_description_navigate",
		ignore_keybinding = true
	},
	{
		input_action = "back",
		priority = 10,
		description_text = "input_description_close"
	}
}
tbl.filter = {
	actions = {
		{
			input_action = "special_1",
			priority = 2,
			description_text = "menu_description_refresh"
		},
		{
			input_action = "left_stick_press",
			priority = 3,
			description_text = "lb_reset_filters"
		},
		{
			input_action = "right_stick_press",
			priority = 4,
			description_text = "input_description_filter"
		}
	}
}
tbl.join_filter = {
	actions = {
		{
			input_action = "special_1",
			priority = 2,
			description_text = "menu_description_refresh"
		},
		{
			input_action = "left_stick_press",
			priority = 3,
			description_text = "lb_reset_filters"
		},
		{
			input_action = "right_stick_press",
			priority = 4,
			description_text = "input_description_filter"
		},
		{
			input_action = "refresh",
			priority = 5,
			description_text = "join_menu_button_name"
		}
	}
}
tbl.set_filter = {
	actions = {
		{
			input_action = "confirm",
			priority = 2,
			description_text = "input_description_select"
		}
	}
}

local generic_input_actions = tbl

DLCUtils.merge("start_game_layout_console_generic_inputs", generic_input_actions)

local mechanism_custom_game_settings = {
	adventure = {
		game_mode_type = "custom",
		difficulty_index_getter_name = "completed_level_difficulty_index",
		layout_name = "area_selection"
	}
}
local mechanism_twitch_settings = {
	adventure = {
		game_mode_type = "twitch",
		difficulty_index_getter_name = "completed_level_difficulty_index",
		layout_name = "area_selection"
	}
}
local mechanism_quickplay_settings = {
	adventure = {
		game_mode_type = "adventure",
		layout_name = "area_selection"
	}
}
local save_data_table_maps = {}

DLCUtils.map("start_game_window_layout_console", function (start_game_window_layout_console)
	-- function 16
	local new_windows = start_game_window_layout_console.windows

	if new_windows then
		for name, window in pairs(new_windows) do
			windows[name] = window
		end
	end

	local new_window_layouts = start_game_window_layout_console.window_layouts

	if new_window_layouts then
		for i = 1, #new_window_layouts do
			window_layouts[#window_layouts + 1] = new_window_layouts[i]
		end
	end

	local dlc_mechanism_custom_game = start_game_window_layout_console.mechanism_custom_game

	if dlc_mechanism_custom_game then
		local mechanism_name = dlc_mechanism_custom_game.mechanism_name

		fassert(mechanism_custom_game_settings[mechanism_name] == nil, "Trying to set custom_game for the mechanism '%s' which is already set.", mechanism_name)

		mechanism_custom_game_settings[mechanism_name] = dlc_mechanism_custom_game
	end

	local dlc_mechanism_twitch = start_game_window_layout_console.mechanism_twitch

	if dlc_mechanism_twitch then
		local mechanism_name = dlc_mechanism_twitch.mechanism_name

		fassert(mechanism_twitch_settings[mechanism_name] == nil, "Trying to set twitch for the mechanism '%s' which is already set.", mechanism_name)

		mechanism_twitch_settings[mechanism_name] = dlc_mechanism_twitch
	end

	local dlc_mechanism_quickplay = start_game_window_layout_console.mechanism_quickplay

	if dlc_mechanism_quickplay then
		local mechanism_name = dlc_mechanism_quickplay.mechanism_name

		fassert(mechanism_quickplay_settings[mechanism_name] == nil, "Trying to set twitch for the mechanism '%s' which is already set.", mechanism_name)

		mechanism_quickplay_settings[mechanism_name] = dlc_mechanism_quickplay
	end
end)
DLCUtils.merge("start_game_save_data_table_map_console", save_data_table_maps)

local HUGE = math.huge

table.sort(window_layouts, function (a, b)
	-- function 17
	local panel_sorting = a.panel_sorting

	panel_sorting = not not panel_sorting or not not HUGE

	local panel_sorting_2 = b.panel_sorting

	panel_sorting_2 = not not panel_sorting_2 or not not HUGE

	return panel_sorting < panel_sorting_2
end)

local video_resources = {}

for area_name, settings in pairs(AreaSettings) do
	local video_settings = settings.video_settings

	video_resources[area_name] = video_settings
end

local MAX_ACTIVE_WINDOWS = 5

return {
	max_active_windows = MAX_ACTIVE_WINDOWS,
	windows = windows,
	window_layouts = window_layouts,
	generic_input_actions = generic_input_actions,
	video_resources = video_resources,
	mechanism_custom_game_settings = mechanism_custom_game_settings,
	mechanism_twitch_settings = mechanism_twitch_settings,
	mechanism_quickplay_settings = mechanism_quickplay_settings,
	save_data_table_maps = save_data_table_maps
}
