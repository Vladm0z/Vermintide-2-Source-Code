-- chunkname: @scripts/ui/views/start_game_view/windows/definitions/start_game_window_lobby_browser_definitions.lua

local game_start_windows = UISettings.game_start_windows
local frame = game_start_windows.frame
local size = game_start_windows.size
local spacing = game_start_windows.spacing
local num = size[1] + spacing
local large_window_frame = game_start_windows.large_window_frame
local var_0_6 = UIFrameSettings[large_window_frame].texture_sizes.vertical[1]
local tbl = {
	size[1] * 3 + spacing * 2 + var_0_6 * 2,
	size[2] + var_0_6 * 2
}
local tbl_2 = {
	400,
	tbl[2]
}
local tbl_3 = {
	400,
	tbl[2]
}
local tbl_4 = {
	tbl[1] - tbl_2[1] - tbl_3[1],
	tbl[2] - 50
}
local tbl_5 = {
	300,
	120
}
local tbl_6 = {
	tbl_5[1],
	85
}
local tbl_7 = {
	tbl_5[1],
	163
}
local tbl_8 = {
	250,
	30
}
local tbl_9 = {
	tbl_8[1],
	tbl_8[2] * 1 + 5
}
local tbl_10 = {
	on_enter = {
		{
			name = "fade_in",
			start_progress = 0,
			end_progress = 0.3,
			init = function (arg_1_0, arg_1_1, arg_1_2, arg_1_3)
				-- function 1
				arg_1_3.render_settings.alpha_multiplier = 0
			end,
			update = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4)
				-- function 2
				local easeOutCubic = math.easeOutCubic(arg_2_3)

				arg_2_4.render_settings.alpha_multiplier = easeOutCubic
			end,
			on_complete = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3)
				-- function 3
				return
			end
		}
	},
	on_exit = {
		{
			name = "fade_out",
			start_progress = 0,
			end_progress = 0.3,
			init = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3)
				-- function 4
				arg_4_3.render_settings.alpha_multiplier = 1
			end,
			update = function (arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4)
				-- function 5
				local easeOutCubic = math.easeOutCubic(arg_5_3)

				arg_5_4.render_settings.alpha_multiplier = 1 - easeOutCubic
			end,
			on_complete = function (arg_6_0, arg_6_1, arg_6_2, arg_6_3)
				-- function 6
				return
			end
		}
	}
}
local tbl_11 = {
	root = {
		is_root = true,
		size = {
			1920,
			1080
		},
		position = {
			0,
			0,
			UILayer.default
		}
	},
	root_fit = {
		scale = "fit",
		size = {
			1920,
			1080
		},
		position = {
			0,
			0,
			UILayer.default
		}
	},
	menu_root = {
		vertical_alignment = "center",
		parent = "root",
		horizontal_alignment = "center",
		size = {
			1920,
			1080
		},
		position = {
			0,
			0,
			0
		}
	},
	window = {
		vertical_alignment = "center",
		parent = "menu_root",
		horizontal_alignment = "center",
		size = tbl,
		position = {
			num,
			0,
			1
		}
	},
	filter_frame = {
		vertical_alignment = "center",
		parent = "window",
		horizontal_alignment = "left",
		size = tbl_2,
		position = {
			0,
			0,
			1
		}
	},
	filter_frame_edge = {
		vertical_alignment = "bottom",
		parent = "filter_frame",
		horizontal_alignment = "right",
		size = {
			0,
			tbl[2] - 5
		},
		position = {
			0,
			0,
			50
		}
	},
	search_button = {
		vertical_alignment = "bottom",
		parent = "filter_frame",
		horizontal_alignment = "center",
		size = {
			400,
			80
		},
		position = {
			0,
			0,
			1
		}
	},
	reset_button = {
		vertical_alignment = "bottom",
		parent = "filter_frame",
		horizontal_alignment = "center",
		size = {
			400,
			80
		},
		position = {
			0,
			80,
			1
		}
	},
	lobby_list_frame = {
		vertical_alignment = "bottom",
		parent = "filter_frame",
		horizontal_alignment = "right",
		size = tbl_4,
		position = {
			tbl_4[1],
			0,
			1
		}
	},
	lobby_list_tabs = {
		vertical_alignment = "top",
		parent = "filter_frame",
		horizontal_alignment = "right",
		size = {
			tbl_4[1],
			40
		},
		position = {
			tbl_4[1],
			-5,
			1
		}
	},
	lobby_list_tabs_divider = {
		vertical_alignment = "top",
		parent = "lobby_list_frame",
		horizontal_alignment = "center",
		size = {
			tbl_4[1] - 4,
			0
		},
		position = {
			2,
			0,
			51
		}
	},
	title_text_detail = {
		vertical_alignment = "top",
		parent = "window",
		horizontal_alignment = "center",
		size = {
			264,
			32
		},
		position = {
			0,
			21 - var_0_6,
			30
		}
	},
	title_text_detail_glow = {
		vertical_alignment = "top",
		parent = "title_text_detail",
		horizontal_alignment = "center",
		size = {
			544,
			16
		},
		position = {
			0,
			5,
			-1
		}
	},
	title_text = {
		vertical_alignment = "center",
		parent = "title_text_detail",
		horizontal_alignment = "center",
		size = {
			size[1],
			50
		},
		position = {
			0,
			25,
			1
		}
	},
	lobby_info_frame = {
		vertical_alignment = "bottom",
		parent = "lobby_list_frame",
		horizontal_alignment = "right",
		size = tbl_3,
		position = {
			tbl_3[1],
			0,
			1
		}
	},
	lobby_info_divider = {
		vertical_alignment = "bottom",
		parent = "lobby_info_frame",
		horizontal_alignment = "left",
		size = {
			0,
			tbl[2] - 5
		},
		position = {
			0,
			0,
			50
		}
	},
	lobby_info_host = {
		vertical_alignment = "top",
		parent = "lobby_info_frame",
		horizontal_alignment = "center",
		size = {
			tbl_3[1],
			32
		},
		position = {
			0,
			0,
			1
		}
	},
	lobby_info_level_image_frame = {
		vertical_alignment = "top",
		parent = "lobby_info_frame",
		horizontal_alignment = "center",
		size = {
			180,
			180
		},
		position = {
			0,
			-40,
			2
		}
	},
	lobby_info_level_image = {
		vertical_alignment = "center",
		parent = "lobby_info_level_image_frame",
		horizontal_alignment = "center",
		size = {
			168,
			168
		},
		position = {
			0,
			0,
			-1
		}
	},
	lobby_info_level_text = {
		vertical_alignment = "bottom",
		parent = "lobby_info_level_image_frame",
		horizontal_alignment = "center",
		size = {
			tbl_3[1] - 40,
			32
		},
		position = {
			0,
			-50,
			0
		}
	},
	wind_icon_bg = {
		vertical_alignment = "bottom",
		parent = "lobby_info_level_image_frame",
		horizontal_alignment = "center",
		size = {
			62.05,
			62.05
		},
		position = {
			0,
			-20,
			2
		}
	},
	wind_icon_slot = {
		vertical_alignment = "center",
		parent = "wind_icon_bg",
		horizontal_alignment = "center",
		size = {
			54.4,
			54.4
		},
		position = {
			0,
			0,
			1
		}
	},
	wind_icon_glow = {
		vertical_alignment = "center",
		parent = "wind_icon_slot",
		horizontal_alignment = "center",
		size = {
			43.35,
			45.05
		},
		position = {
			0,
			0,
			1
		}
	},
	wind_icon = {
		vertical_alignment = "center",
		parent = "wind_icon_slot",
		horizontal_alignment = "center",
		size = {
			54.4,
			54.4
		},
		position = {
			0,
			0,
			2
		}
	},
	lobby_info_weave_level_text = {
		vertical_alignment = "top",
		parent = "lobby_info_frame",
		horizontal_alignment = "center",
		size = {
			tbl_3[1] - 20,
			32
		},
		position = {
			0,
			-20,
			0
		}
	},
	lobby_info_wind_text = {
		vertical_alignment = "bottom",
		parent = "lobby_info_level_text",
		horizontal_alignment = "center",
		size = {
			tbl_3[1],
			32
		},
		position = {
			0,
			-40,
			0
		}
	},
	lobby_info_hero_tabs = {
		vertical_alignment = "bottom",
		parent = "lobby_info_level_text",
		horizontal_alignment = "center",
		size = {
			0,
			0
		},
		position = {
			0,
			-120,
			1
		}
	},
	lobby_info_box_info_frame_lobbies = {
		vertical_alignment = "center",
		parent = "lobby_info_frame",
		horizontal_alignment = "center",
		size = tbl_5,
		position = {
			0,
			-60,
			1
		}
	},
	lobby_info_box_host_lobbies = {
		vertical_alignment = "top",
		parent = "lobby_info_box_info_frame_lobbies",
		horizontal_alignment = "center",
		size = {
			tbl_5[1] - 20,
			16
		},
		position = {
			0,
			-10,
			1
		}
	},
	lobby_info_box_game_type_lobbies = {
		vertical_alignment = "bottom",
		parent = "lobby_info_box_host_lobbies",
		horizontal_alignment = "center",
		size = {
			tbl_5[1] - 20,
			16
		},
		position = {
			0,
			-16,
			1
		}
	},
	lobby_info_box_level_name_lobbies = {
		vertical_alignment = "bottom",
		parent = "lobby_info_box_game_type_lobbies",
		horizontal_alignment = "center",
		size = {
			tbl_5[1] - 20,
			16
		},
		position = {
			0,
			-16,
			1
		}
	},
	lobby_info_box_difficulty_lobbies = {
		vertical_alignment = "bottom",
		parent = "lobby_info_box_level_name_lobbies",
		horizontal_alignment = "center",
		size = {
			tbl_5[1] - 20,
			16
		},
		position = {
			0,
			-16,
			1
		}
	},
	lobby_info_box_players_lobbies = {
		vertical_alignment = "bottom",
		parent = "lobby_info_box_difficulty_lobbies",
		horizontal_alignment = "center",
		size = {
			tbl_5[1] - 20,
			16
		},
		position = {
			0,
			-16,
			1
		}
	},
	lobby_info_box_status_lobbies = {
		vertical_alignment = "bottom",
		parent = "lobby_info_box_players_lobbies",
		horizontal_alignment = "center",
		size = {
			tbl_5[1] - 20,
			16
		},
		position = {
			0,
			-16,
			1
		}
	},
	lobby_info_box_info_frame_lobbies_weaves = {
		vertical_alignment = "center",
		parent = "lobby_info_frame",
		horizontal_alignment = "center",
		size = tbl_6,
		position = {
			0,
			-30,
			1
		}
	},
	lobby_info_box_host_lobbies_weaves = {
		vertical_alignment = "top",
		parent = "lobby_info_box_info_frame_lobbies_weaves",
		horizontal_alignment = "center",
		size = {
			tbl_6[1] - 20,
			16
		},
		position = {
			0,
			-10,
			1
		}
	},
	lobby_info_box_game_type_lobbies_weaves = {
		vertical_alignment = "bottom",
		parent = "lobby_info_box_host_lobbies_weaves",
		horizontal_alignment = "center",
		size = {
			tbl_6[1] - 20,
			16
		},
		position = {
			0,
			-16,
			1
		}
	},
	lobby_info_box_level_name_lobbies_weaves = {
		vertical_alignment = "bottom",
		parent = "lobby_info_box_game_type_lobbies_weaves",
		horizontal_alignment = "center",
		size = {
			tbl_6[1] - 20,
			16
		},
		position = {
			0,
			-16,
			1
		}
	},
	lobby_info_box_players_lobbies_weaves = {
		vertical_alignment = "bottom",
		parent = "lobby_info_box_game_type_lobbies_weaves",
		horizontal_alignment = "center",
		size = {
			tbl_6[1] - 20,
			16
		},
		position = {
			0,
			-16,
			1
		}
	},
	lobby_info_box_status_lobbies_weaves = {
		vertical_alignment = "bottom",
		parent = "lobby_info_box_players_lobbies_weaves",
		horizontal_alignment = "center",
		size = {
			tbl_6[1] - 20,
			16
		},
		position = {
			0,
			-16,
			1
		}
	},
	lobby_info_box_twitch_logo = {
		vertical_alignment = "center",
		parent = "lobby_info_box_status_servers",
		horizontal_alignment = "center",
		size = {
			130,
			29
		},
		position = {
			0,
			0,
			1
		}
	},
	lobby_info_box_info_frame_servers = {
		vertical_alignment = "center",
		parent = "lobby_info_frame",
		horizontal_alignment = "center",
		size = tbl_7,
		position = {
			0,
			-100,
			1
		}
	},
	lobby_info_box_name_servers = {
		vertical_alignment = "top",
		parent = "lobby_info_box_info_frame_servers",
		horizontal_alignment = "center",
		size = {
			tbl_7[1] - 20,
			16
		},
		position = {
			0,
			-10,
			1
		}
	},
	lobby_info_box_ip_adress_servers = {
		vertical_alignment = "top",
		parent = "lobby_info_box_name_servers",
		horizontal_alignment = "center",
		size = {
			tbl_7[1] - 20,
			16
		},
		position = {
			0,
			-16,
			1
		}
	},
	lobby_info_box_password_protected_servers = {
		vertical_alignment = "bottom",
		parent = "lobby_info_box_ip_adress_servers",
		horizontal_alignment = "center",
		size = {
			tbl_7[1] - 20,
			16
		},
		position = {
			0,
			-16,
			1
		}
	},
	lobby_info_box_ping_servers = {
		vertical_alignment = "bottom",
		parent = "lobby_info_box_password_protected_servers",
		horizontal_alignment = "center",
		size = {
			tbl_7[1] - 20,
			16
		},
		position = {
			0,
			-16,
			1
		}
	},
	lobby_info_box_favorite_servers = {
		vertical_alignment = "bottom",
		parent = "lobby_info_box_ping_servers",
		horizontal_alignment = "center",
		size = {
			tbl_7[1] - 20,
			16
		},
		position = {
			0,
			-16,
			1
		}
	},
	lobby_info_box_level_name_servers = {
		vertical_alignment = "bottom",
		parent = "lobby_info_box_favorite_servers",
		horizontal_alignment = "center",
		size = {
			tbl_7[1] - 20,
			16
		},
		position = {
			0,
			-16,
			1
		}
	},
	lobby_info_box_difficulty_servers = {
		vertical_alignment = "bottom",
		parent = "lobby_info_box_level_name_servers",
		horizontal_alignment = "center",
		size = {
			tbl_7[1] - 20,
			16
		},
		position = {
			0,
			-16,
			1
		}
	},
	lobby_info_box_players_servers = {
		vertical_alignment = "bottom",
		parent = "lobby_info_box_difficulty_servers",
		horizontal_alignment = "center",
		size = {
			tbl_7[1] - 20,
			16
		},
		position = {
			0,
			-16,
			1
		}
	},
	lobby_info_box_status_servers = {
		vertical_alignment = "bottom",
		parent = "lobby_info_box_players_servers",
		horizontal_alignment = "center",
		size = {
			tbl_7[1] - 20,
			16
		},
		position = {
			0,
			-16,
			1
		}
	},
	lobby_info_dedicated_server_buttons_frame = {
		vertical_alignment = "bottom",
		parent = "lobby_info_frame",
		horizontal_alignment = "center",
		size = tbl_9,
		position = {
			0,
			140,
			1
		}
	},
	lobby_info_add_to_favorites_button = {
		vertical_alignment = "top",
		parent = "lobby_info_dedicated_server_buttons_frame",
		horizontal_alignment = "center",
		size = tbl_8,
		position = {
			0,
			-5,
			-1
		}
	},
	lobby_info_refresh_button = {
		vertical_alignment = "bottom",
		parent = "lobby_info_add_to_favorites_button",
		horizontal_alignment = "center",
		size = tbl_8,
		position = {
			0,
			-tbl_8[2],
			0
		}
	},
	mutator_window = {
		vertical_alignment = "bottom",
		parent = "lobby_info_box_info_frame_lobbies",
		horizontal_alignment = "center",
		size = {
			tbl_3[1],
			0
		},
		position = {
			0,
			35,
			1
		}
	},
	mutator_icon = {
		vertical_alignment = "top",
		parent = "mutator_window",
		horizontal_alignment = "left",
		size = {
			60,
			60
		},
		position = {
			10,
			-50,
			5
		}
	},
	mutator_icon_frame = {
		vertical_alignment = "center",
		parent = "mutator_icon",
		horizontal_alignment = "center",
		size = {
			60,
			60
		},
		position = {
			0,
			0,
			1
		}
	},
	mutator_title_text = {
		vertical_alignment = "top",
		parent = "mutator_window",
		horizontal_alignment = "left",
		size = {
			tbl_3[1] * 0.6,
			50
		},
		position = {
			10,
			-5,
			1
		}
	},
	mutator_title_divider = {
		vertical_alignment = "bottom",
		parent = "mutator_title_text",
		horizontal_alignment = "left",
		size = {
			450,
			4
		},
		position = {
			0,
			10,
			1
		}
	},
	mutator_description_text = {
		vertical_alignment = "top",
		parent = "mutator_icon",
		horizontal_alignment = "left",
		size = {
			tbl_3[1] - 110,
			60
		},
		position = {
			90,
			0,
			1
		}
	},
	objective_title = {
		vertical_alignment = "bottom",
		parent = "mutator_icon",
		horizontal_alignment = "left",
		size = {
			tbl_3[1],
			40
		},
		position = {
			0,
			-60,
			3
		}
	},
	objective_title_bg = {
		vertical_alignment = "center",
		parent = "objective_title",
		horizontal_alignment = "center",
		size = {
			467,
			59
		},
		position = {
			0,
			0,
			-1
		}
	},
	objective_1 = {
		vertical_alignment = "bottom",
		parent = "objective_title",
		horizontal_alignment = "center",
		size = {
			tbl_3[1],
			30
		},
		position = {
			0,
			-35,
			3
		}
	},
	objective_2 = {
		vertical_alignment = "bottom",
		parent = "objective_1",
		horizontal_alignment = "center",
		size = {
			tbl_3[1],
			30
		},
		position = {
			0,
			-35,
			0
		}
	},
	name_input_box = {
		vertical_alignment = "top",
		parent = "filter_frame",
		horizontal_alignment = "center",
		position = {
			0,
			-130,
			1
		},
		size = {
			340,
			40
		}
	},
	name_input_box_banner = {
		parent = "name_input_box",
		position = {
			0,
			30,
			1
		},
		size = {
			340,
			56
		}
	},
	search_type_stepper = {
		vertical_alignment = "top",
		parent = "name_input_box",
		horizontal_alignment = "center",
		position = {
			0,
			-85,
			0
		},
		size = {
			240,
			40
		}
	},
	search_type_banner = {
		parent = "search_type_stepper",
		position = {
			-45,
			30,
			1
		},
		size = {
			340,
			56
		}
	},
	join_button = {
		vertical_alignment = "bottom",
		parent = "lobby_info_frame",
		horizontal_alignment = "center",
		size = {
			400,
			80
		},
		position = {
			0,
			0,
			1
		}
	},
	invalid_checkbox = {
		parent = "filter_frame",
		horizontal_alignment = "left",
		position = {
			10,
			200,
			1
		},
		size = {
			300,
			34
		}
	},
	game_mode_stepper = {
		vertical_alignment = "top",
		parent = "filter_frame",
		horizontal_alignment = "center",
		position = {
			0,
			-130,
			1
		},
		size = {
			240,
			40
		}
	},
	game_mode_banner = {
		parent = "game_mode_stepper",
		position = {
			-45,
			30,
			1
		},
		size = {
			340,
			56
		}
	},
	level_stepper = {
		vertical_alignment = "top",
		parent = "game_mode_stepper",
		horizontal_alignment = "center",
		position = {
			0,
			-85,
			1
		},
		size = {
			240,
			40
		}
	},
	level_banner = {
		parent = "level_stepper",
		position = {
			-45,
			30,
			1
		},
		size = {
			340,
			56
		}
	},
	difficulty_stepper = {
		vertical_alignment = "top",
		parent = "level_stepper",
		horizontal_alignment = "center",
		position = {
			0,
			-85,
			0
		},
		size = {
			240,
			40
		}
	},
	difficulty_banner = {
		parent = "difficulty_stepper",
		position = {
			-45,
			30,
			1
		},
		size = {
			340,
			56
		}
	},
	show_lobbies_stepper = {
		vertical_alignment = "top",
		parent = "difficulty_stepper",
		horizontal_alignment = "center",
		position = {
			0,
			-85,
			0
		},
		size = {
			240,
			40
		}
	},
	show_lobbies_banner = {
		parent = "show_lobbies_stepper",
		position = {
			-45,
			30,
			1
		},
		size = {
			340,
			56
		}
	},
	distance_stepper = {
		vertical_alignment = "top",
		parent = "show_lobbies_stepper",
		horizontal_alignment = "center",
		position = {
			0,
			-85,
			0
		},
		size = {
			240,
			40
		}
	},
	distance_banner = {
		parent = "distance_stepper",
		position = {
			-45,
			30,
			1
		},
		size = {
			340,
			56
		}
	},
	filter_divider = {
		vertical_alignment = "bottom",
		parent = "search_button",
		horizontal_alignment = "center",
		position = {
			0,
			93,
			2
		},
		size = {
			301,
			18
		}
	},
	lobby_type_button = {
		vertical_alignment = "top",
		parent = "filter_frame",
		horizontal_alignment = "center",
		position = {
			0,
			-5,
			0
		},
		size = {
			400,
			50
		}
	}
}

local function fn(arg_7_0, arg_7_1)
	-- function 7
	local LevelSettings = LevelSettings
	local map_settings = LevelSettings[arg_7_0].map_settings
	local map_settings_2 = LevelSettings[arg_7_1].map_settings
	local sorting

	if not map_settings then
		sorting = map_settings.sorting

		if not sorting then
			sorting = 0
		end
	else
		sorting = 0
	end

	local sorting_2

	if not map_settings_2 then
		sorting_2 = map_settings_2.sorting

		if not sorting_2 then
			sorting_2 = 0
		end
	else
		sorting_2 = 0
	end

	return sorting < sorting_2
end

local function fn_2(arg_8_0, arg_8_1)
	-- function 8
	local tbl = {}
	local tbl_2 = {}
	local release_levels_only = GameSettingsDevelopment.release_levels_only

	for k, v in pairs(LevelSettings) do
		if not (type(v) ~= "table" or not release_levels_only or DebugLevels[k]) then
			local game_mode = v.game_mode

			game_mode = game_mode or v.mechanism

			if not (not game_mode and game_mode == "tutorial" or game_mode == "demo") then
				local unlockable = v.unlockable

				unlockable = not unlockable and not v.default

				if not unlockable and not LevelUnlockUtils.level_unlocked(arg_8_0, arg_8_1, k) then
					if not tbl_2[game_mode] then
						local var_8_5 = GameModeSettings[game_mode]
						local difficulties = var_8_5.difficulties
						local display_name = var_8_5.display_name
						local clone = table.clone(difficulties)

						clone[#clone + 1] = "any"
						tbl[#tbl + 1] = {
							levels = {},
							difficulties = clone,
							game_mode_key = game_mode,
							game_mode_display_name = display_name
						}
						tbl_2[game_mode] = #tbl
					end

					if not (not v.supported_game_modes and v.supported_game_modes[game_mode] and v.ommit_from_lobby_browser) then
						local levels = tbl[tbl_2[game_mode]].levels

						levels[#levels + 1] = k
					end
				end
			end
		end
	end

	for k_2 = 1, #tbl do
		local levels_2 = tbl[k_2].levels

		table.sort(levels_2, fn)

		levels_2[#levels_2 + 1] = "any"
	end

	local function fn_2(self, arg_9_1)
		-- function 9
		return Localize(self.game_mode_display_name) < Localize(arg_9_1.game_mode_display_name)
	end

	table.sort(tbl, fn_2)

	local tbl_3 = {}

	for l = 1, #tbl do
		local game_mode_key = tbl[l].game_mode_key
		local num = #tbl_3 + 1

		tbl_3[num] = game_mode_key
		tbl_3[game_mode_key] = num
	end

	local str = "weave"
	local var_8_16 = GameModeSettings[str]
	local difficulties_2 = var_8_16.difficulties
	local display_name_2 = var_8_16.display_name
	local num_2 = #tbl + 1
	local clone_2 = table.clone(difficulties_2)

	clone_2[#clone_2 + 1] = "any"
	tbl[num_2] = {
		difficulties = clone_2,
		game_mode_key = str,
		game_mode_display_name = display_name_2
	}
	tbl_3[str] = #tbl_3 + 1
	tbl_3[#tbl_3 + 1] = str

	local str_2 = "any"

	tbl_3[str_2] = #tbl_3 + 1
	tbl_3[#tbl_3 + 1] = str_2
	tbl.game_modes = tbl_3

	return tbl
end

local tbl_12 = {
	"lb_show_joinable",
	"lb_show_all"
}
local tbl_13

if not IS_PS4 then
	tbl_13 = {
		"map_zone_options_2",
		"map_zone_options_3",
		"map_zone_options_5"
	}

	if not tbl_13 then
		-- Nothing
	end
end

tbl_13 = {
	"map_zone_options_2",
	"map_zone_options_4",
	"map_zone_options_5"
}

::label_0_0::

local tbl_14 = {
	"internet",
	"lan",
	"friends",
	"favorites",
	"history"
}
local tbl_15 = {
	"lb_search_type_internet",
	"lb_search_type_lan",
	"lb_search_type_friends",
	"lb_search_type_favorites",
	"lb_search_type_history"
}

local function fn_3()
	-- function 10
	return {
		vertical_alignment = "center",
		horizontal_alignment = "center",
		localize = false,
		font_size = 28,
		font_type = "hell_shark",
		text_color = Colors.get_color_table_with_alpha("cheeseburger", 255)
	}
end

local function fn_4()
	-- function 11
	return {
		vertical_alignment = "center",
		horizontal_alignment = "center",
		localize = true,
		font_size = 28,
		font_type = "hell_shark",
		text_color = Colors.get_color_table_with_alpha("cheeseburger", 255)
	}
end

local function fn_5(arg_12_0, arg_12_1)
	-- function 12
	return {
		element = {
			passes = {
				{
					texture_id = "bottom_edge",
					style_id = "bottom_edge",
					pass_type = "tiled_texture"
				},
				{
					texture_id = "edge_holder_left",
					style_id = "edge_holder_left",
					pass_type = "texture"
				},
				{
					texture_id = "edge_holder_right",
					style_id = "edge_holder_right",
					pass_type = "texture"
				}
			}
		},
		content = {
			edge_holder_right = "menu_frame_09_divider_right",
			edge_holder_left = "menu_frame_09_divider_left",
			bottom_edge = "menu_frame_09_divider"
		},
		style = {
			bottom_edge = {
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					0,
					0,
					6
				},
				size = {
					arg_12_1[1],
					5
				},
				texture_tiling_size = {
					arg_12_1[1] - 10,
					5
				}
			},
			edge_holder_left = {
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					0,
					-6,
					10
				},
				size = {
					9,
					17
				}
			},
			edge_holder_right = {
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					arg_12_1[1] - 9,
					-6,
					10
				},
				size = {
					9,
					17
				}
			}
		},
		scenegraph_id = arg_12_0,
		offset = {
			0,
			0,
			0
		}
	}
end

local function fn_6(arg_13_0, arg_13_1)
	-- function 13
	return {
		element = {
			passes = {
				{
					texture_id = "edge",
					style_id = "edge",
					pass_type = "tiled_texture"
				},
				{
					texture_id = "edge_holder_top",
					style_id = "edge_holder_top",
					pass_type = "texture"
				},
				{
					texture_id = "edge_holder_bottom",
					style_id = "edge_holder_bottom",
					pass_type = "texture"
				}
			}
		},
		content = {
			edge = "menu_frame_09_divider_vertical",
			edge_holder_top = "menu_frame_09_divider_top",
			edge_holder_bottom = "menu_frame_09_divider_bottom"
		},
		style = {
			edge = {
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					0,
					6,
					6
				},
				size = {
					5,
					arg_13_1[2] - 9
				},
				texture_tiling_size = {
					5,
					arg_13_1[2] - 9
				}
			},
			edge_holder_top = {
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					-6,
					arg_13_1[2] - 7,
					10
				},
				size = {
					17,
					9
				}
			},
			edge_holder_bottom = {
				color = {
					255,
					255,
					255,
					255
				},
				offset = {
					-6,
					3,
					10
				},
				size = {
					17,
					9
				}
			}
		},
		scenegraph_id = arg_13_0,
		offset = {
			0,
			0,
			0
		}
	}
end

local function fn_7(arg_14_0, arg_14_1, arg_14_2, arg_14_3, arg_14_4, arg_14_5)
	-- function 14
	local var_14_0

	if not arg_14_5 then
		var_14_0 = "button_" .. arg_14_5
	else
		var_14_0 = "button_normal"
	end

	local get_color_table_with_alpha = Colors.get_color_table_with_alpha(var_14_0, 255)
	local str = "button_bg_01"
	local get_atlas_settings_by_texture_name = UIAtlasHelper.get_atlas_settings_by_texture_name(str)
	local tbl = {
		element = {
			passes = {
				{
					style_id = "button_background",
					pass_type = "hotspot",
					content_id = "button_hotspot"
				},
				{
					style_id = "button_background",
					pass_type = "texture_uv",
					content_id = "button_background"
				},
				{
					texture_id = "bottom_edge",
					style_id = "button_edge",
					pass_type = "tiled_texture"
				},
				{
					texture_id = "glass_top",
					style_id = "glass_top",
					pass_type = "texture"
				},
				{
					texture_id = "glow",
					style_id = "glow",
					pass_type = "texture"
				},
				{
					texture_id = "hover_glow",
					style_id = "hover_glow",
					pass_type = "texture",
					content_check_function = function (self)
						-- function 15
						local button_hotspot = self.button_hotspot
						local is_selected

						if not button_hotspot.disable_button then
							is_selected = button_hotspot.is_selected

							if not is_selected then
								is_selected = button_hotspot.is_hover
							end
						else
							is_selected = false
						end

						if false then
							is_selected = true
						end

						return is_selected
					end
				},
				{
					style_id = "button_text",
					pass_type = "text",
					text_id = "button_text",
					content_check_function = function (self)
						-- function 16
						return not self.button_hotspot.disable_button
					end
				},
				{
					style_id = "button_text_disabled",
					pass_type = "text",
					text_id = "button_text",
					content_check_function = function (self)
						-- function 17
						return self.button_hotspot.disable_button
					end
				},
				{
					style_id = "button_text_shadow",
					pass_type = "text",
					text_id = "button_text"
				},
				{
					style_id = "button_clicked_rect",
					pass_type = "rect",
					content_check_function = function (self)
						-- function 18
						local is_clicked = self.button_hotspot.is_clicked

						return not is_clicked and is_clicked == 0
					end
				},
				{
					style_id = "button_disabled_rect",
					pass_type = "rect",
					content_check_function = function (self)
						-- function 19
						return self.button_hotspot.disable_button
					end
				},
				{
					texture_id = "bottom_edge",
					style_id = "bottom_edge",
					pass_type = "tiled_texture",
					content_check_function = function (self)
						-- function 20
						return self.use_bottom_edge
					end
				},
				{
					texture_id = "edge_holder_left",
					style_id = "edge_holder_left",
					pass_type = "texture",
					content_check_function = function (self)
						-- function 21
						return self.use_bottom_edge
					end
				},
				{
					texture_id = "edge_holder_right",
					style_id = "edge_holder_right",
					pass_type = "texture",
					content_check_function = function (self)
						-- function 22
						return self.use_bottom_edge
					end
				}
			}
		}
	}
	local tbl_2 = {
		edge_holder_left = "menu_frame_09_divider_left",
		edge_holder_right = "menu_frame_09_divider_right",
		glass_top = "button_glass_01",
		bottom_edge = "menu_frame_09_divider",
		use_bottom_edge = arg_14_4,
		button_hotspot = {},
		button_text = arg_14_2 or "n/a"
	}
	local str_2

	if not arg_14_5 then
		str_2 = "button_state_hover_" .. arg_14_5

		if not str_2 then
			-- Nothing
		end
	end

	str_2 = "button_state_hover"

	::label_14_0::

	tbl_2.hover_glow = str_2

	local str_3

	if not arg_14_5 then
		str_3 = "button_state_normal_" .. arg_14_5

		if not str_3 then
			-- Nothing
		end
	end

	str_3 = "button_state_normal"

	::label_14_1::

	tbl_2.glow = str_3
	tbl_2.button_background = {
		uvs = {
			{
				0,
				1 - math.min(arg_14_1[2] / get_atlas_settings_by_texture_name.size[2], 1)
			},
			{
				math.min(arg_14_1[1] / get_atlas_settings_by_texture_name.size[1], 1),
				1
			}
		},
		texture_id = str
	}
	tbl.content = tbl_2
	tbl.style = {
		button_background = {
			color = get_color_table_with_alpha,
			offset = {
				0,
				0,
				2
			},
			size = arg_14_1
		},
		button_edge = {
			color = {
				255,
				255,
				255,
				255
			},
			offset = {
				0,
				arg_14_1[2],
				3
			},
			size = {
				arg_14_1[1],
				5
			},
			texture_tiling_size = {
				arg_14_1[1],
				5
			}
		},
		glass_top = {
			color = {
				255,
				255,
				255,
				255
			},
			offset = {
				0,
				arg_14_1[2] - 4,
				3
			},
			size = {
				arg_14_1[1],
				5
			}
		},
		glow = {
			color = {
				255,
				255,
				255,
				255
			},
			offset = {
				0,
				5,
				3
			},
			size = {
				arg_14_1[1],
				arg_14_1[2] - 5
			}
		},
		hover_glow = {
			color = {
				255,
				255,
				255,
				255
			},
			offset = {
				0,
				5,
				2
			},
			size = {
				arg_14_1[1],
				arg_14_1[2] - 5
			}
		},
		bottom_edge = {
			color = {
				255,
				255,
				255,
				255
			},
			offset = {
				5,
				0,
				6
			},
			size = {
				arg_14_1[1] - 10,
				5
			},
			texture_tiling_size = {
				arg_14_1[1] - 10,
				5
			}
		},
		edge_holder_left = {
			color = {
				255,
				255,
				255,
				255
			},
			offset = {
				3,
				-6,
				10
			},
			size = {
				9,
				17
			}
		},
		edge_holder_right = {
			color = {
				255,
				255,
				255,
				255
			},
			offset = {
				arg_14_1[1] - 12,
				-6,
				10
			},
			size = {
				9,
				17
			}
		},
		button_text = {
			upper_case = true,
			word_wrap = true,
			horizontal_alignment = "center",
			vertical_alignment = "center",
			font_type = "hell_shark_header",
			font_size = arg_14_3 or 24,
			text_color = Colors.get_color_table_with_alpha("font_button_normal", 255),
			offset = {
				0,
				2,
				4
			},
			size = arg_14_1
		},
		button_text_disabled = {
			upper_case = true,
			word_wrap = true,
			horizontal_alignment = "center",
			vertical_alignment = "center",
			font_type = "hell_shark_header",
			font_size = arg_14_3 or 24,
			text_color = Colors.get_color_table_with_alpha("gray", 255),
			offset = {
				0,
				2,
				4
			},
			size = arg_14_1
		},
		button_text_shadow = {
			upper_case = true,
			word_wrap = true,
			horizontal_alignment = "center",
			vertical_alignment = "center",
			font_type = "hell_shark_header",
			font_size = arg_14_3 or 24,
			text_color = Colors.get_color_table_with_alpha("black", 255),
			offset = {
				2,
				0,
				3
			},
			size = arg_14_1
		},
		button_clicked_rect = {
			color = {
				100,
				0,
				0,
				0
			},
			offset = {
				0,
				0,
				5
			},
			size = arg_14_1
		},
		button_disabled_rect = {
			color = {
				150,
				5,
				5,
				5
			},
			offset = {
				0,
				0,
				5
			},
			size = arg_14_1
		}
	}
	tbl.scenegraph_id = arg_14_0
	tbl.offset = {
		0,
		0,
		0
	}

	return tbl
end

local tbl_16 = {}

for i = 1, #ProfilePriority do
	tbl_16[#tbl_16 + 1] = "unit_frame_portrait_default"
end

local num_2 = 0.75
local num_3 = 96 * num_2
local num_4 = 112 * num_2
local num_5 = 5 * num_2

hero_entry_frame_size = {
	86 * num_2,
	108 * num_2
}

local function fn_8(arg_23_0, arg_23_1)
	-- function 23
	return {
		element = {
			passes = {
				{
					texture_id = "background",
					style_id = "background",
					pass_type = "texture",
					content_check_function = function (self)
						-- function 24
						return self.text ~= "tutorial_no_text"
					end
				},
				{
					texture_id = "icon",
					style_id = "icon",
					pass_type = "texture",
					content_check_function = function (self)
						-- function 25
						return self.text ~= "tutorial_no_text"
					end
				},
				{
					style_id = "text",
					pass_type = "text",
					text_id = "text",
					content_check_function = function (self)
						-- function 26
						return self.text ~= "tutorial_no_text"
					end
				},
				{
					style_id = "text_shadow",
					pass_type = "text",
					text_id = "text",
					content_check_function = function (self)
						-- function 27
						return self.text ~= "tutorial_no_text"
					end
				}
			}
		},
		content = {
			text = "-",
			icon = "trial_gem",
			background = "chest_upgrade_fill_glow"
		},
		style = {
			background = {
				color = {
					0,
					255,
					255,
					255
				},
				offset = {
					0,
					0,
					0
				}
			},
			icon = {
				vertical_alignment = "center",
				horizontal_alignment = "left",
				texture_size = {
					49,
					44
				},
				color = Colors.get_color_table_with_alpha("font_default", 255),
				offset = {
					0,
					0,
					1
				}
			},
			text = {
				word_wrap = true,
				localize = true,
				font_size = 26,
				horizontal_alignment = "left",
				vertical_alignment = "center",
				dynamic_font_size = true,
				font_type = "hell_shark",
				size = {
					arg_23_1[1] - 60,
					arg_23_1[2]
				},
				text_color = Colors.get_color_table_with_alpha("font_default", 255),
				offset = {
					50,
					0,
					2
				}
			},
			text_shadow = {
				word_wrap = true,
				localize = true,
				font_size = 26,
				horizontal_alignment = "left",
				vertical_alignment = "center",
				dynamic_font_size = true,
				font_type = "hell_shark",
				size = {
					arg_23_1[1] - 60,
					arg_23_1[2]
				},
				text_color = Colors.get_color_table_with_alpha("black", 255),
				offset = {
					52,
					-2,
					1
				}
			}
		},
		offset = {
			0,
			0,
			0
		},
		scenegraph_id = arg_23_0
	}
end

local tbl_17 = {
	word_wrap = false,
	upper_case = true,
	localize = false,
	use_shadow = true,
	font_size = 32,
	horizontal_alignment = "center",
	vertical_alignment = "top",
	dynamic_font_size = true,
	font_type = "hell_shark_header",
	text_color = Colors.get_color_table_with_alpha("font_title", 255),
	offset = {
		0,
		0,
		2
	}
}
local tbl_18 = {
	font_size = 32,
	upper_case = true,
	localize = false,
	use_shadow = true,
	word_wrap = false,
	horizontal_alignment = "center",
	vertical_alignment = "top",
	dynamic_font_size = true,
	font_type = "hell_shark_header",
	text_color = Colors.get_color_table_with_alpha("font_title", 255),
	offset = {
		0,
		0,
		2
	}
}
local tbl_19 = {
	font_size = 20,
	upper_case = false,
	localize = false,
	use_shadow = true,
	word_wrap = true,
	horizontal_alignment = "center",
	vertical_alignment = "top",
	font_type = "hell_shark_header",
	text_color = Colors.get_color_table_with_alpha("white", 255),
	offset = {
		0,
		0,
		2
	}
}
local tbl_20 = {
	font_size = 32,
	upper_case = false,
	localize = true,
	use_shadow = true,
	word_wrap = true,
	horizontal_alignment = "left",
	vertical_alignment = "top",
	dynamic_font_size = true,
	font_type = "hell_shark_header",
	text_color = Colors.get_color_table_with_alpha("font_title", 255),
	offset = {
		0,
		0,
		2
	}
}
local tbl_21 = {
	font_size = 18,
	use_shadow = true,
	localize = true,
	dynamic_font_size_word_wrap = true,
	word_wrap = true,
	horizontal_alignment = "left",
	vertical_alignment = "top",
	font_type = "hell_shark",
	text_color = Colors.get_color_table_with_alpha("font_default", 255),
	offset = {
		0,
		0,
		2
	}
}
local tbl_22 = {
	font_size = 28,
	upper_case = true,
	localize = true,
	use_shadow = true,
	word_wrap = true,
	horizontal_alignment = "center",
	vertical_alignment = "center",
	font_type = "hell_shark_header",
	text_color = Colors.get_color_table_with_alpha("font_button_normal", 255),
	offset = {
		0,
		0,
		2
	}
}
local tbl_23 = {
	font_size = 16,
	upper_case = true,
	localize = false,
	use_shadow = true,
	word_wrap = true,
	horizontal_alignment = "left",
	vertical_alignment = "center",
	font_type = "arial",
	text_color = Colors.get_color_table_with_alpha("white", 255),
	offset = {
		0,
		0,
		2
	}
}
local tbl_24 = {
	font_size = 16,
	upper_case = true,
	localize = false,
	use_shadow = true,
	horizontal_alignment = "right",
	vertical_alignment = "center",
	font_type = "arial",
	text_color = Colors.get_color_table_with_alpha("white", 255),
	offset = {
		80,
		0,
		2
	},
	size = {
		200,
		16
	}
}
local tbl_25 = {
	font_size = 16,
	upper_case = true,
	localize = false,
	dynamic_font_size_word_wrap = true,
	word_wrap = true,
	use_shadow = true,
	horizontal_alignment = "right",
	vertical_alignment = "center",
	font_type = "arial",
	text_color = Colors.get_color_table_with_alpha("white", 255),
	offset = {
		30,
		0,
		2
	},
	size = {
		250,
		16
	}
}
local tbl_26 = {
	base = {
		window_frame = UIWidgets.create_frame("window", tbl_11.window.size, frame, 10),
		filter_frame_edge = fn_6("filter_frame_edge", tbl_11.filter_frame_edge.size),
		lobby_info_divider = fn_6("lobby_info_divider", tbl_11.lobby_info_divider.size),
		lobby_list_tabs_divider = fn_5("lobby_list_tabs_divider", tbl_11.lobby_list_tabs_divider.size),
		search_button = fn_7("search_button", tbl_11.search_button.size, Localize("lb_search"), 32, false, "green"),
		reset_button = fn_7("reset_button", tbl_11.reset_button.size, Localize("lb_reset_filters"), 32, false),
		lobby_type_button = fn_7("lobby_type_button", tbl_11.lobby_type_button.size, Localize("lb_lobby_type_lobbies"), 32, false),
		join_button = fn_7("join_button", tbl_11.join_button.size, Localize("lb_join"), 32, false),
		invalid_checkbox = UIWidgets.create_checkbox_widget("lb_show_invalid", "", "invalid_checkbox", 10, {
			-40,
			0,
			4
		})
	},
	lobbies = {
		game_type_stepper = UIWidgets.create_stepper("game_mode_stepper", tbl_11.game_mode_stepper.size),
		level_stepper = UIWidgets.create_stepper("level_stepper", tbl_11.level_stepper.size),
		difficulty_stepper = UIWidgets.create_stepper("difficulty_stepper", tbl_11.difficulty_stepper.size),
		show_lobbies_stepper = UIWidgets.create_stepper("show_lobbies_stepper", tbl_11.show_lobbies_stepper.size),
		distance_stepper = UIWidgets.create_stepper("distance_stepper", tbl_11.distance_stepper.size),
		game_mode_banner_widget = UIWidgets.create_title_and_tooltip("game_mode_banner", tbl_11.level_banner.size, "lb_game_type", "lb_game_type_tooltip", fn_4()),
		level_banner_widget = UIWidgets.create_title_and_tooltip("level_banner", tbl_11.level_banner.size, "map_level_setting", "map_level_setting_tooltip", fn_4()),
		difficulty_banner_widget = UIWidgets.create_title_and_tooltip("difficulty_banner", tbl_11.difficulty_banner.size, "map_difficulty_setting", "map_difficulty_setting_tooltip", fn_4()),
		show_lobbies_banner_widget = UIWidgets.create_title_and_tooltip("show_lobbies_banner", tbl_11.show_lobbies_banner.size, "lb_show_lobbies", "lb_show_lobbies_tooltip", fn_4()),
		distance_banner_widget = UIWidgets.create_title_and_tooltip("distance_banner", tbl_11.distance_banner.size, "map_search_zone_setting", "map_search_zone_setting_tooltip", fn_4())
	},
	servers = {
		name_input_box = UIWidgets.create_text_input_rect("name_input_box", tbl_11.name_input_box.size, {
			5,
			10,
			0
		}),
		search_type_stepper = UIWidgets.create_stepper("search_type_stepper", tbl_11.search_type_stepper.size),
		name_input_box_banner = UIWidgets.create_title_and_tooltip("name_input_box_banner", tbl_11.name_input_box_banner.size, "lb_server_name", "lb_server_name_tooltip", fn_4()),
		search_type_banner_widget = UIWidgets.create_title_and_tooltip("search_type_banner", tbl_11.search_type_banner.size, "lb_search_type_setting", "lb_search_type_setting_tooltip", fn_4())
	},
	lobby_info_box_base = {
		level_image_frame = UIWidgets.create_simple_texture("map_frame_00", "lobby_info_level_image_frame"),
		level_image = UIWidgets.create_simple_texture("level_icon_01", "lobby_info_level_image"),
		level_name = UIWidgets.create_simple_text("level_name", "lobby_info_level_text", nil, nil, tbl_17),
		hero_tabs = UIWidgets.create_icon_selector("lobby_info_hero_tabs", {
			num_3,
			num_4
		}, tbl_16, num_5, true, hero_entry_frame_size, true)
	},
	lobby_info_box_weaves = {
		wind_icon = UIWidgets.create_simple_texture("icon_wind_azyr", "wind_icon"),
		wind_icon_glow = UIWidgets.create_simple_texture("winds_icon_background_glow", "wind_icon_glow"),
		wind_icon_bg = UIWidgets.create_simple_texture("weave_item_icon_border_selected", "wind_icon_bg"),
		wind_icon_slot = UIWidgets.create_simple_texture("weave_item_icon_border_center", "wind_icon_slot"),
		mutator_icon = UIWidgets.create_simple_texture("icons_placeholder", "mutator_icon"),
		mutator_icon_frame = UIWidgets.create_simple_texture("talent_frame", "mutator_icon_frame"),
		mutator_title_text = UIWidgets.create_simple_text("n/a", "mutator_title_text", nil, nil, tbl_20),
		mutator_title_divider = UIWidgets.create_simple_texture("infoslate_frame_02_horizontal", "mutator_title_divider"),
		mutator_description_text = UIWidgets.create_simple_text("n/a", "mutator_description_text", nil, nil, tbl_21),
		objective_title_bg = UIWidgets.create_simple_texture("menu_subheader_bg", "objective_title_bg"),
		objective_title = UIWidgets.create_simple_text("weave_objective_title", "objective_title", nil, nil, tbl_22),
		objective_1 = fn_8("objective_1", tbl_11.objective_1.size),
		objective_2 = fn_8("objective_2", tbl_11.objective_2.size),
		weave_name = UIWidgets.create_simple_text("weave_name", "lobby_info_weave_level_text", nil, nil, tbl_18),
		wind_name = UIWidgets.create_simple_text("wind_name", "lobby_info_wind_text", nil, nil, tbl_19)
	},
	lobby_info_box_deus = {
		expedition_icon = UIWidgets.create_expedition_widget_func("lobby_info_level_image", nil, DeusJourneySettings.journey_cave, "journey_cave", {
			width = 800,
			spacing_x = 40
		}, 1.2),
		level_name = UIWidgets.create_simple_text("level_name", "lobby_info_level_text", nil, nil, tbl_17),
		hero_tabs = UIWidgets.create_icon_selector("lobby_info_hero_tabs", {
			num_3,
			num_4
		}, tbl_16, num_5, true, hero_entry_frame_size, true)
	},
	lobby_info_box_lobbies_weaves = {
		info_frame = UIWidgets.create_frame("lobby_info_box_info_frame_lobbies_weaves", tbl_11.lobby_info_box_info_frame_lobbies_weaves.size, frame, 5),
		info_frame_host_title = UIWidgets.create_simple_text(Localize("lb_host") .. ":", "lobby_info_box_host_lobbies_weaves", nil, nil, tbl_23),
		info_frame_host_text = UIWidgets.create_simple_text("host", "lobby_info_box_host_lobbies_weaves", nil, nil, tbl_24),
		info_frame_players_title = UIWidgets.create_simple_text(Localize("lb_players") .. ":", "lobby_info_box_players_lobbies_weaves", nil, nil, tbl_23),
		info_frame_players_text = UIWidgets.create_simple_text("1/4", "lobby_info_box_players_lobbies_weaves", nil, nil, tbl_24),
		info_frame_status_title = UIWidgets.create_simple_text(Localize("lb_status") .. ":", "lobby_info_box_status_lobbies_weaves", nil, nil, tbl_23),
		info_frame_status_text = UIWidgets.create_simple_text("Started", "lobby_info_box_status_lobbies_weaves", nil, nil, tbl_24),
		info_frame_game_type_title = UIWidgets.create_simple_text(Localize("lb_game_type") .. ":", "lobby_info_box_game_type_lobbies_weaves", nil, nil, tbl_23),
		info_frame_game_type_text = UIWidgets.create_simple_text(Localize("lb_game_type_weave"), "lobby_info_box_game_type_lobbies_weaves", nil, nil, tbl_24)
	},
	lobby_info_box_lobbies_deus = {
		info_frame = UIWidgets.create_frame("lobby_info_box_info_frame_lobbies", tbl_11.lobby_info_box_info_frame_lobbies.size, frame, 5),
		info_frame_host_title = UIWidgets.create_simple_text(Localize("lb_host") .. ":", "lobby_info_box_host_lobbies", nil, nil, tbl_23),
		info_frame_host_text = UIWidgets.create_simple_text("host", "lobby_info_box_host_lobbies", nil, nil, tbl_24),
		info_frame_level_name_title = UIWidgets.create_simple_text(Localize("lb_level") .. ":", "lobby_info_box_level_name_lobbies", nil, nil, tbl_23),
		info_frame_level_name_text = UIWidgets.create_simple_text("level_name", "lobby_info_box_level_name_lobbies", nil, nil, tbl_25),
		info_frame_difficulty_title = UIWidgets.create_simple_text(Localize("lb_difficulty") .. ":", "lobby_info_box_difficulty_lobbies", nil, nil, tbl_23),
		info_frame_difficulty_text = UIWidgets.create_simple_text("difficulty", "lobby_info_box_difficulty_lobbies", nil, nil, tbl_24),
		info_frame_players_title = UIWidgets.create_simple_text(Localize("lb_players") .. ":", "lobby_info_box_players_lobbies", nil, nil, tbl_23),
		info_frame_players_text = UIWidgets.create_simple_text("1/4", "lobby_info_box_players_lobbies", nil, nil, tbl_24),
		info_frame_status_title = UIWidgets.create_simple_text(Localize("lb_status") .. ":", "lobby_info_box_status_lobbies", nil, nil, tbl_23),
		info_frame_status_text = UIWidgets.create_simple_text("Started", "lobby_info_box_status_lobbies", nil, nil, tbl_24),
		info_frame_game_type_title = UIWidgets.create_simple_text(Localize("lb_game_type") .. ":", "lobby_info_box_game_type_lobbies", nil, nil, tbl_23),
		info_frame_game_type_text = UIWidgets.create_simple_text(Localize("lb_game_type_none"), "lobby_info_box_game_type_lobbies", nil, nil, tbl_24),
		info_frame_twitch_logo = UIWidgets.create_simple_texture("twitch_logo_new", "lobby_info_box_twitch_logo", nil, nil, nil, nil)
	},
	lobby_info_box_lobbies = {
		info_frame = UIWidgets.create_frame("lobby_info_box_info_frame_lobbies", tbl_11.lobby_info_box_info_frame_lobbies.size, frame, 5),
		info_frame_host_title = UIWidgets.create_simple_text(Localize("lb_host") .. ":", "lobby_info_box_host_lobbies", nil, nil, tbl_23),
		info_frame_host_text = UIWidgets.create_simple_text("host", "lobby_info_box_host_lobbies", nil, nil, tbl_24),
		info_frame_level_name_title = UIWidgets.create_simple_text(Localize("lb_level") .. ":", "lobby_info_box_level_name_lobbies", nil, nil, tbl_23),
		info_frame_level_name_text = UIWidgets.create_simple_text("level_name", "lobby_info_box_level_name_lobbies", nil, nil, tbl_25),
		info_frame_difficulty_title = UIWidgets.create_simple_text(Localize("lb_difficulty") .. ":", "lobby_info_box_difficulty_lobbies", nil, nil, tbl_23),
		info_frame_difficulty_text = UIWidgets.create_simple_text("difficulty", "lobby_info_box_difficulty_lobbies", nil, nil, tbl_24),
		info_frame_players_title = UIWidgets.create_simple_text(Localize("lb_players") .. ":", "lobby_info_box_players_lobbies", nil, nil, tbl_23),
		info_frame_players_text = UIWidgets.create_simple_text("1/4", "lobby_info_box_players_lobbies", nil, nil, tbl_24),
		info_frame_status_title = UIWidgets.create_simple_text(Localize("lb_status") .. ":", "lobby_info_box_status_lobbies", nil, nil, tbl_23),
		info_frame_status_text = UIWidgets.create_simple_text("Started", "lobby_info_box_status_lobbies", nil, nil, tbl_24),
		info_frame_game_type_title = UIWidgets.create_simple_text(Localize("lb_game_type") .. ":", "lobby_info_box_game_type_lobbies", nil, nil, tbl_23),
		info_frame_game_type_text = UIWidgets.create_simple_text(Localize("lb_game_type_none"), "lobby_info_box_game_type_lobbies", nil, nil, tbl_24),
		info_frame_twitch_logo = UIWidgets.create_simple_texture("twitch_logo_new", "lobby_info_box_twitch_logo", nil, nil, nil, nil)
	},
	lobby_info_box_servers = {
		info_frame = UIWidgets.create_frame("lobby_info_box_info_frame_servers", tbl_11.lobby_info_box_info_frame_servers.size, frame, 5),
		info_frame_name_title = UIWidgets.create_simple_text(Localize("lb_name") .. ":", "lobby_info_box_name_servers", nil, nil, tbl_23),
		info_frame_name_text = UIWidgets.create_simple_text("server_name", "lobby_info_box_name_servers", nil, nil, tbl_24),
		info_frame_ip_adress_title = UIWidgets.create_simple_text(Localize("lb_ip_adress") .. ":", "lobby_info_box_ip_adress_servers", nil, nil, tbl_23),
		info_frame_ip_adress_text = UIWidgets.create_simple_text("1.3.3.7", "lobby_info_box_ip_adress_servers", nil, nil, tbl_24),
		info_frame_password_protected_title = UIWidgets.create_simple_text(Localize("lb_password_protected") .. ":", "lobby_info_box_password_protected_servers", nil, nil, tbl_23),
		info_frame_password_protected_text = UIWidgets.create_simple_text("Yes", "lobby_info_box_password_protected_servers", nil, nil, tbl_24),
		info_frame_ping_title = UIWidgets.create_simple_text(Localize("lb_ping") .. ":", "lobby_info_box_ping_servers", nil, nil, tbl_23),
		info_frame_ping_text = UIWidgets.create_simple_text("1337", "lobby_info_box_ping_servers", nil, nil, tbl_24),
		info_frame_favorite_title = UIWidgets.create_simple_text(Localize("lb_favorite") .. ":", "lobby_info_box_favorite_servers", nil, nil, tbl_23),
		info_frame_favorite_text = UIWidgets.create_simple_text("Yes", "lobby_info_box_favorite_servers", nil, nil, tbl_24),
		info_frame_level_name_title = UIWidgets.create_simple_text(Localize("lb_level") .. ":", "lobby_info_box_level_name_servers", nil, nil, tbl_23),
		info_frame_level_name_text = UIWidgets.create_simple_text("level_name", "lobby_info_box_level_name_servers", nil, nil, tbl_25),
		info_frame_difficulty_title = UIWidgets.create_simple_text(Localize("lb_difficulty") .. ":", "lobby_info_box_difficulty_servers", nil, nil, tbl_23),
		info_frame_difficulty_text = UIWidgets.create_simple_text("difficulty", "lobby_info_box_difficulty_servers", nil, nil, tbl_24),
		info_frame_players_title = UIWidgets.create_simple_text(Localize("lb_players") .. ":", "lobby_info_box_players_servers", nil, nil, tbl_23),
		info_frame_players_text = UIWidgets.create_simple_text("1/4", "lobby_info_box_players_servers", nil, nil, tbl_24),
		info_frame_status_title = UIWidgets.create_simple_text(Localize("lb_status") .. ":", "lobby_info_box_status_servers", nil, nil, tbl_23),
		info_frame_status_text = UIWidgets.create_simple_text("Started", "lobby_info_box_status_servers", nil, nil, tbl_24),
		info_frame_game_type_title = UIWidgets.create_simple_text(Localize("lb_game_type") .. ":", "lobby_info_box_game_type_lobbies", nil, nil, tbl_23),
		info_frame_game_type_text = UIWidgets.create_simple_text(Localize("lb_game_type_none"), "lobby_info_box_game_type_lobbies", nil, nil, tbl_24),
		server_buttons_frame = UIWidgets.create_frame("lobby_info_dedicated_server_buttons_frame", tbl_11.lobby_info_dedicated_server_buttons_frame.size, frame, 5),
		add_to_favorites_button = fn_7("lobby_info_add_to_favorites_button", tbl_11.lobby_info_add_to_favorites_button.size, Localize("lb_add_to_favorites"), 20, false)
	}
}

table.clear(tbl_26.base.lobby_type_button.element.passes)

return {
	show_lobbies_table = tbl_12,
	distance_table = tbl_13,
	setup_game_mode_data = fn_2,
	search_type_table = tbl_14,
	search_type_text_table = tbl_15,
	scenegraph_definition = tbl_11,
	animation_definitions = tbl_10,
	widgets = tbl_26
}
