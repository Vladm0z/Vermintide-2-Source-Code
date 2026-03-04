-- chunkname: @scripts/ui/views/ingame_view_menu_layout_console.lua

local function var_0_0()
	local var_1_0 = Managers.state.game_mode:level_key()
	local var_1_1 = Managers.player:local_player()

	if var_1_1 and Unit.alive(var_1_1.player_unit) then
		Managers.telemetry_events:player_stuck(var_1_1, var_1_0)
	end
end

local var_0_1 = "https://vermintide2beta.com/?utm_medium=referral&utm_campaign=vermintide2beta&utm_source=ingame#challenge"
local var_0_2 = IS_XB1 and "leave_party_menu_button_name_xb1" or "leave_party_menu_button_name"
local var_0_3 = IS_XB1 and "disband_party_menu_button_name_xb1" or "disband_party_menu_button_name"
local var_0_4 = IS_XB1 and "quit_menu_button_name_xb1" or "quit_menu_button_name_ps4"
local var_0_5 = {}

function demo_inverted_func()
	local var_2_0 = Managers.input:get_service("Player")

	if IS_WINDOWS then
		local var_2_1 = "win32"

		return var_2_0:get_active_filters(var_2_1).look.function_data.filter_type == "scale_vector3" and "menu_invert_controls" or "menu_non_invert_controls"
	else
		local var_2_2 = PLATFORM

		return var_2_0:get_active_filters(var_2_2).look_controller.function_data.filter_type == "scale_vector3_xy_accelerated_x" and "menu_invert_controls" or "menu_non_invert_controls"
	end
end

local function var_0_6(arg_3_0)
	return arg_3_0.force_ingame_menu
end

local function var_0_7(arg_4_0)
	return Managers.state.game_mode:game_mode_key() == "inn_vs" and var_0_6(arg_4_0)
end

local var_0_8 = {
	adventure = {
		matchmaking = false,
		matchmaking_ready = true,
		not_matchmaking = false
	},
	versus = {
		matchmaking = false,
		matchmaking_ready = true,
		not_matchmaking = false
	},
	deus = {
		matchmaking = false,
		matchmaking_ready = true,
		not_matchmaking = false
	}
}
local var_0_9 = {
	adventure = {
		matchmaking = false,
		matchmaking_ready = true,
		not_matchmaking = false
	},
	versus = {
		matchmaking = true,
		matchmaking_ready = true,
		not_matchmaking = true
	},
	deus = {
		matchmaking = false,
		matchmaking_ready = true,
		not_matchmaking = false
	}
}
local var_0_10 = {
	force_ingame_menu = true,
	display_name = "tutorial_menu_header",
	force_open = true,
	fade = false,
	transition_state = "handbook",
	transition = "hero_view",
	disable_for_mechanism = var_0_8
}

if IS_PS4 then
	var_0_5 = {
		in_menu = {
			alone = {
				{
					fade = false,
					transition = "exit_menu",
					display_name = "return_to_game_button_name"
				},
				{
					display_name = "profile_menu_button_name",
					requires_player_unit = true,
					fade = true,
					transition_state = "character",
					transition = "character_selection",
					disable_for_mechanism = var_0_8
				},
				var_0_10,
				{
					fade = true,
					transition = "options_menu",
					display_name = "options_menu_button_name",
					disable_for_mechanism = var_0_8
				},
				{
					fade = true,
					transition = "console_friends_menu",
					display_name = "console_friends_menu_button_name",
					disable_for_mechanism = var_0_8
				},
				{
					fade = false,
					transition = "leave_group_hero_view",
					display_name = "leave_game_menu_button_name"
				},
				{
					fade = false,
					transition = "return_to_title_screen_hero_view",
					display_name = var_0_4
				}
			},
			host = {
				{
					fade = false,
					transition = "exit_menu",
					display_name = "return_to_game_button_name"
				},
				{
					display_name = "profile_menu_button_name",
					requires_player_unit = true,
					fade = true,
					transition_state = "character",
					transition = "character_selection",
					disable_for_mechanism = var_0_8
				},
				var_0_10,
				{
					fade = true,
					transition = "options_menu",
					display_name = "options_menu_button_name",
					disable_for_mechanism = var_0_8
				},
				{
					fade = true,
					transition = "console_friends_menu",
					display_name = "console_friends_menu_button_name",
					disable_for_mechanism = var_0_8
				},
				{
					fade = false,
					transition = "leave_group_hero_view",
					display_name = var_0_3
				},
				{
					fade = false,
					transition = "return_to_title_screen_hero_view",
					display_name = var_0_4
				}
			},
			client = {
				{
					fade = false,
					transition = "exit_menu",
					display_name = "return_to_game_button_name"
				},
				{
					display_name = "profile_menu_button_name",
					requires_player_unit = true,
					fade = true,
					transition_state = "character",
					transition = "character_selection",
					disable_for_mechanism = var_0_8
				},
				var_0_10,
				{
					fade = true,
					transition = "options_menu",
					display_name = "options_menu_button_name",
					disable_for_mechanism = var_0_8
				},
				{
					fade = true,
					transition = "console_friends_menu",
					display_name = "console_friends_menu_button_name",
					disable_for_mechanism = var_0_8
				},
				{
					fade = false,
					transition = "leave_group_hero_view",
					display_name = var_0_2
				},
				{
					fade = false,
					transition = "return_to_title_screen_hero_view",
					display_name = var_0_4
				}
			},
			demo = {
				{
					transition = "exit_menu",
					display_name = "return_to_game_button_name"
				},
				{
					transition = "restart_demo_hero_view",
					display_name = "menu_restart"
				},
				{
					transition = "demo_invert_controls",
					display_name = "menu_invert_controls",
					display_name_func = demo_inverted_func
				},
				{
					transition = "return_to_demo_title_screen_hero_view",
					display_name = "menu_return_to_title_screen"
				}
			},
			offline = {
				{
					fade = false,
					transition = "exit_menu",
					display_name = "return_to_game_button_name"
				},
				{
					display_name = "profile_menu_button_name",
					requires_player_unit = true,
					fade = true,
					transition_state = "character",
					transition = "character_selection",
					disable_for_mechanism = var_0_8
				},
				var_0_10,
				{
					fade = true,
					transition = "options_menu",
					display_name = "options_menu_button_name",
					disable_for_mechanism = var_0_8
				},
				{
					fade = false,
					transition = "return_to_title_screen_hero_view",
					display_name = var_0_4
				}
			}
		},
		in_game = {
			alone = {
				{
					fade = false,
					transition = "exit_menu",
					display_name = "return_to_game_button_name"
				},
				{
					fade = true,
					transition = "options_menu",
					display_name = "options_menu_button_name",
					disable_for_mechanism = var_0_8
				},
				{
					fade = true,
					transition = "console_friends_menu",
					display_name = "console_friends_menu_button_name",
					disable_for_mechanism = var_0_8
				},
				{
					fade = false,
					transition = "leave_group_hero_view",
					display_name = "leave_game_menu_button_name"
				},
				{
					fade = false,
					transition = "return_to_title_screen_hero_view",
					display_name = var_0_4
				}
			},
			host = {
				{
					fade = false,
					transition = "exit_menu",
					display_name = "return_to_game_button_name"
				},
				{
					fade = true,
					transition = "options_menu",
					display_name = "options_menu_button_name",
					disable_for_mechanism = var_0_8
				},
				{
					fade = true,
					transition = "console_friends_menu",
					display_name = "console_friends_menu_button_name",
					disable_for_mechanism = var_0_8
				},
				{
					fade = false,
					transition = "leave_group_hero_view",
					display_name = var_0_3
				},
				{
					fade = false,
					transition = "return_to_title_screen_hero_view",
					display_name = var_0_4
				}
			},
			client = {
				{
					fade = false,
					transition = "exit_menu",
					display_name = "return_to_game_button_name"
				},
				{
					fade = true,
					transition = "options_menu",
					display_name = "options_menu_button_name",
					disable_for_mechanism = var_0_8
				},
				{
					fade = true,
					transition = "console_friends_menu",
					display_name = "console_friends_menu_button_name",
					disable_for_mechanism = var_0_8
				},
				{
					fade = false,
					transition = "leave_group_hero_view",
					display_name = var_0_2
				},
				{
					fade = false,
					transition = "return_to_title_screen_hero_view",
					display_name = var_0_4
				}
			},
			tutorial = {
				{
					transition = "exit_menu",
					display_name = "return_to_game_button_name"
				},
				{
					transition = "options_menu",
					display_name = "options_menu_button_name"
				},
				{
					fade = false,
					transition = "leave_group_hero_view",
					display_name = "leave_game_menu_button_name"
				},
				{
					transition = "return_to_title_screen_hero_view",
					display_name = var_0_4
				}
			},
			demo = {
				{
					transition = "exit_menu",
					display_name = "return_to_game_button_name"
				},
				{
					transition = "restart_demo_hero_view",
					display_name = "menu_restart"
				},
				{
					transition = "demo_invert_controls",
					display_name = "menu_invert_controls",
					display_name_func = demo_inverted_func
				},
				{
					transition = "return_to_demo_title_screen_hero_view",
					display_name = "menu_return_to_title_screen"
				}
			},
			offline = {
				{
					fade = false,
					transition = "exit_menu",
					display_name = "return_to_game_button_name"
				},
				{
					fade = true,
					transition = "options_menu",
					display_name = "options_menu_button_name",
					disable_for_mechanism = var_0_8
				},
				{
					fade = false,
					transition = "leave_group_hero_view",
					display_name = "leave_game_menu_button_name"
				},
				{
					fade = false,
					transition = "return_to_title_screen_hero_view",
					display_name = var_0_4
				}
			}
		}
	}
elseif IS_XB1 then
	var_0_5 = {
		in_menu = {
			alone = {
				{
					fade = false,
					transition = "exit_menu",
					display_name = "return_to_game_button_name"
				},
				{
					display_name = "profile_menu_button_name",
					requires_player_unit = true,
					fade = true,
					transition_state = "character",
					transition = "character_selection",
					disable_for_mechanism = var_0_8
				},
				var_0_10,
				{
					fade = true,
					transition = "options_menu",
					display_name = "options_menu_button_name",
					disable_for_mechanism = var_0_8
				},
				{
					fade = true,
					transition = "console_friends_menu",
					display_name = "console_friends_menu_button_name",
					disable_for_mechanism = var_0_8
				},
				{
					fade = false,
					transition = "leave_group_hero_view",
					display_name = "leave_game_menu_button_name"
				},
				{
					fade = false,
					transition = "return_to_title_screen_hero_view",
					display_name = var_0_4
				}
			},
			host = {
				{
					fade = false,
					transition = "exit_menu",
					display_name = "return_to_game_button_name"
				},
				{
					display_name = "profile_menu_button_name",
					requires_player_unit = true,
					fade = true,
					transition_state = "character",
					transition = "character_selection",
					disable_for_mechanism = var_0_8
				},
				var_0_10,
				{
					fade = true,
					transition = "options_menu",
					display_name = "options_menu_button_name",
					disable_for_mechanism = var_0_8
				},
				{
					fade = true,
					transition = "console_friends_menu",
					display_name = "console_friends_menu_button_name",
					disable_for_mechanism = var_0_8
				},
				{
					fade = false,
					transition = "leave_group_hero_view",
					display_name = var_0_3
				},
				{
					fade = false,
					transition = "return_to_title_screen_hero_view",
					display_name = var_0_4
				}
			},
			client = {
				{
					fade = false,
					transition = "exit_menu",
					display_name = "return_to_game_button_name"
				},
				{
					display_name = "profile_menu_button_name",
					requires_player_unit = true,
					fade = true,
					transition_state = "character",
					transition = "character_selection",
					disable_for_mechanism = var_0_8
				},
				var_0_10,
				{
					fade = true,
					transition = "options_menu",
					display_name = "options_menu_button_name",
					disable_for_mechanism = var_0_8
				},
				{
					fade = true,
					transition = "console_friends_menu",
					display_name = "console_friends_menu_button_name",
					disable_for_mechanism = var_0_8
				},
				{
					fade = false,
					transition = "leave_group_hero_view",
					display_name = var_0_2
				},
				{
					fade = false,
					transition = "return_to_title_screen_hero_view",
					display_name = var_0_4
				}
			},
			demo = {
				{
					transition = "exit_menu",
					display_name = "return_to_game_button_name"
				},
				{
					transition = "restart_demo_hero_view",
					display_name = "menu_restart"
				},
				{
					transition = "demo_invert_controls",
					display_name = "menu_invert_controls",
					display_name_func = demo_inverted_func
				},
				{
					transition = "return_to_demo_title_screen_hero_view",
					display_name = "menu_return_to_title_screen"
				}
			},
			offline = {
				{
					fade = false,
					transition = "exit_menu",
					display_name = "return_to_game_button_name"
				},
				{
					display_name = "profile_menu_button_name",
					requires_player_unit = true,
					fade = true,
					transition_state = "character",
					transition = "character_selection",
					disable_for_mechanism = var_0_8
				},
				var_0_10,
				{
					fade = true,
					transition = "options_menu",
					display_name = "options_menu_button_name",
					disable_for_mechanism = var_0_8
				},
				{
					fade = false,
					transition = "return_to_title_screen_hero_view",
					display_name = var_0_4
				}
			}
		},
		in_game = {
			alone = {
				{
					fade = false,
					transition = "exit_menu",
					display_name = "return_to_game_button_name"
				},
				{
					fade = true,
					transition = "options_menu",
					display_name = "options_menu_button_name",
					disable_for_mechanism = var_0_8
				},
				{
					fade = true,
					transition = "console_friends_menu",
					display_name = "console_friends_menu_button_name",
					disable_for_mechanism = var_0_8
				},
				{
					fade = false,
					transition = "leave_group_hero_view",
					display_name = "leave_game_menu_button_name"
				},
				{
					fade = false,
					transition = "return_to_title_screen_hero_view",
					display_name = var_0_4
				}
			},
			host = {
				{
					fade = false,
					transition = "exit_menu",
					display_name = "return_to_game_button_name"
				},
				{
					fade = true,
					transition = "options_menu",
					display_name = "options_menu_button_name",
					disable_for_mechanism = var_0_8
				},
				{
					fade = true,
					transition = "console_friends_menu",
					display_name = "console_friends_menu_button_name",
					disable_for_mechanism = var_0_8
				},
				{
					fade = false,
					transition = "leave_group_hero_view",
					display_name = var_0_3
				},
				{
					fade = false,
					transition = "return_to_title_screen_hero_view",
					display_name = var_0_4
				}
			},
			client = {
				{
					fade = false,
					transition = "exit_menu",
					display_name = "return_to_game_button_name"
				},
				{
					fade = true,
					transition = "options_menu",
					display_name = "options_menu_button_name",
					disable_for_mechanism = var_0_8
				},
				{
					fade = true,
					transition = "console_friends_menu",
					display_name = "console_friends_menu_button_name",
					disable_for_mechanism = var_0_8
				},
				{
					fade = false,
					transition = "leave_group_hero_view",
					display_name = var_0_2
				},
				{
					fade = false,
					transition = "return_to_title_screen_hero_view",
					display_name = var_0_4
				}
			},
			tutorial = {
				{
					transition = "exit_menu",
					display_name = "return_to_game_button_name"
				},
				{
					transition = "options_menu",
					display_name = "options_menu_button_name"
				},
				{
					fade = false,
					transition = "leave_group_hero_view",
					display_name = "leave_game_menu_button_name"
				},
				{
					transition = "return_to_title_screen_hero_view",
					display_name = var_0_4
				}
			},
			demo = {
				{
					transition = "exit_menu",
					display_name = "return_to_game_button_name"
				},
				{
					transition = "restart_demo_hero_view",
					display_name = "menu_restart"
				},
				{
					transition = "demo_invert_controls",
					display_name = "menu_invert_controls",
					display_name_func = demo_inverted_func
				},
				{
					transition = "return_to_demo_title_screen_hero_view",
					display_name = "menu_return_to_title_screen"
				}
			},
			offline = {
				{
					fade = false,
					transition = "exit_menu",
					display_name = "return_to_game_button_name"
				},
				{
					fade = true,
					transition = "options_menu",
					display_name = "options_menu_button_name",
					disable_for_mechanism = var_0_8
				},
				{
					fade = false,
					transition = "leave_group_hero_view",
					display_name = "leave_game_menu_button_name"
				},
				{
					fade = false,
					transition = "return_to_title_screen_hero_view",
					display_name = var_0_4
				}
			}
		}
	}
else
	var_0_5 = {
		in_menu = {
			alone = {
				{
					fade = false,
					transition = "exit_menu",
					display_name = "return_to_game_button_name"
				},
				{
					display_name = "profile_menu_button_name",
					requires_player_unit = true,
					fade = true,
					transition_state = "character",
					transition = "character_selection",
					disable_for_mechanism = var_0_8
				},
				{
					display_name = "inventory_menu_button_name",
					requires_player_unit = true,
					fade = true,
					transition_state = "overview",
					transition = "hero_view",
					force_open = true,
					disable_for_mechanism = var_0_8,
					can_add_function = var_0_6
				},
				{
					display_name = "interact_loot",
					requires_player_unit = true,
					fade = true,
					transition_state = "loot",
					transition = "spoils_of_war",
					force_open = true,
					disable_for_mechanism = var_0_9,
					can_add_function = var_0_6
				},
				var_0_10,
				{
					fade = true,
					transition = "options_menu",
					display_name = "options_menu_button_name",
					disable_for_mechanism = var_0_8
				},
				{
					fade = false,
					transition = "return_to_pc_menu_hero_view",
					display_name = "menu_return_to_title_screen"
				},
				{
					fade = false,
					transition = "quit_game_hero_view",
					display_name = "quit_menu_button_name"
				}
			},
			host = {
				{
					fade = false,
					transition = "exit_menu",
					display_name = "return_to_game_button_name"
				},
				{
					display_name = "profile_menu_button_name",
					requires_player_unit = true,
					fade = true,
					transition_state = "character",
					transition = "character_selection",
					disable_for_mechanism = var_0_8
				},
				{
					display_name = "inventory_menu_button_name",
					requires_player_unit = true,
					fade = true,
					transition_state = "overview",
					transition = "hero_view",
					force_open = true,
					disable_for_mechanism = var_0_8,
					can_add_function = var_0_6
				},
				{
					display_name = "interact_loot",
					requires_player_unit = true,
					fade = true,
					transition_state = "loot",
					transition = "spoils_of_war",
					force_open = true,
					disable_for_mechanism = var_0_9,
					can_add_function = var_0_6
				},
				var_0_10,
				{
					fade = true,
					transition = "options_menu",
					display_name = "options_menu_button_name",
					disable_for_mechanism = var_0_8
				},
				{
					fade = false,
					transition = "leave_group_hero_view",
					display_name = var_0_3
				},
				{
					fade = false,
					transition = "return_to_pc_menu_hero_view",
					display_name = "menu_return_to_title_screen"
				},
				{
					fade = false,
					transition = "quit_game_hero_view",
					display_name = "quit_menu_button_name"
				}
			},
			client = {
				{
					fade = false,
					transition = "exit_menu",
					display_name = "return_to_game_button_name"
				},
				{
					display_name = "profile_menu_button_name",
					requires_player_unit = true,
					fade = true,
					transition_state = "character",
					transition = "character_selection",
					disable_for_mechanism = var_0_8
				},
				{
					display_name = "inventory_menu_button_name",
					requires_player_unit = true,
					fade = true,
					transition_state = "overview",
					transition = "hero_view",
					force_open = true,
					disable_for_mechanism = var_0_8,
					can_add_function = var_0_6
				},
				{
					display_name = "interact_loot",
					requires_player_unit = true,
					fade = true,
					transition_state = "loot",
					transition = "spoils_of_war",
					force_open = true,
					disable_for_mechanism = var_0_9,
					can_add_function = var_0_6
				},
				var_0_10,
				{
					fade = true,
					transition = "options_menu",
					display_name = "options_menu_button_name",
					disable_for_mechanism = var_0_8
				},
				{
					fade = false,
					transition = "leave_group_hero_view",
					display_name = var_0_2
				},
				{
					fade = false,
					transition = "return_to_pc_menu_hero_view",
					display_name = "menu_return_to_title_screen"
				},
				{
					fade = false,
					transition = "quit_game_hero_view",
					display_name = "quit_menu_button_name"
				}
			},
			demo = {
				{
					transition = "exit_menu",
					display_name = "return_to_game_button_name"
				},
				{
					transition = "restart_demo",
					display_name = "menu_restart"
				},
				{
					transition = "demo_invert_controls",
					display_name = "menu_invert_controls",
					display_name_func = demo_inverted_func
				},
				{
					transition = "return_to_demo_title_screen",
					display_name = "menu_return_to_title_screen"
				}
			}
		},
		in_game = {
			alone = {
				{
					fade = false,
					transition = "exit_menu",
					display_name = "return_to_game_button_name"
				},
				{
					fade = true,
					transition = "options_menu",
					display_name = "options_menu_button_name",
					disable_for_mechanism = var_0_8
				},
				{
					fade = false,
					transition = "leave_group_hero_view",
					display_name = "leave_game_menu_button_name"
				},
				{
					fade = false,
					transition = "quit_game_hero_view",
					display_name = "quit_menu_button_name"
				}
			},
			host = {
				{
					fade = false,
					transition = "exit_menu",
					display_name = "return_to_game_button_name"
				},
				{
					fade = true,
					transition = "options_menu",
					display_name = "options_menu_button_name",
					disable_for_mechanism = var_0_8
				},
				{
					fade = false,
					transition = "leave_group_hero_view",
					display_name = var_0_3
				},
				{
					fade = false,
					transition = "quit_game_hero_view",
					display_name = "quit_menu_button_name"
				}
			},
			client = {
				{
					fade = false,
					transition = "exit_menu",
					display_name = "return_to_game_button_name"
				},
				{
					fade = true,
					transition = "options_menu",
					display_name = "options_menu_button_name",
					disable_for_mechanism = var_0_8
				},
				{
					fade = false,
					transition = "leave_group_hero_view",
					display_name = var_0_2
				},
				{
					fade = false,
					transition = "quit_game_hero_view",
					display_name = "quit_menu_button_name"
				}
			},
			tutorial = {
				{
					transition = "exit_menu",
					display_name = "return_to_game_button_name"
				},
				{
					transition = "options_menu",
					display_name = "options_menu_button_name"
				},
				{
					fade = false,
					transition = "leave_group_hero_view",
					display_name = "leave_game_menu_button_name"
				},
				{
					transition = "quit_game_hero_view",
					display_name = "quit_menu_button_name"
				}
			},
			demo = {
				{
					transition = "exit_menu",
					display_name = "return_to_game_button_name"
				},
				{
					transition = "restart_demo",
					display_name = "menu_restart"
				},
				{
					transition = "demo_invert_controls",
					display_name = "menu_invert_controls"
				},
				{
					transition = "return_to_demo_title_screen",
					display_name = "menu_return_to_title_screen"
				}
			}
		}
	}
end

if GameSettingsDevelopment.use_global_chat and IS_WINDOWS then
	table.insert(var_0_5.in_menu.host, 4, {
		fade = false,
		transition = "chat_view",
		display_name = "chat_menu_button_name"
	})
	table.insert(var_0_5.in_menu.client, 4, {
		fade = false,
		transition = "chat_view",
		display_name = "chat_menu_button_name"
	})
	table.insert(var_0_5.in_menu.alone, 4, {
		fade = false,
		transition = "chat_view",
		display_name = "chat_menu_button_name"
	})
	table.insert(var_0_5.in_game.host, 4, {
		fade = false,
		transition = "chat_view",
		display_name = "chat_menu_button_name"
	})
	table.insert(var_0_5.in_game.client, 4, {
		fade = false,
		transition = "chat_view",
		display_name = "chat_menu_button_name"
	})
	table.insert(var_0_5.in_game.alone, 4, {
		fade = false,
		transition = "chat_view",
		display_name = "chat_menu_button_name"
	})
end

local var_0_11 = {
	{
		display_name = "profile_menu_button_name",
		fade = true,
		transition_state = "character",
		transition = "character_selection",
		disable_for_mechanism = {
			adventure = {
				matchmaking = false,
				matchmaking_ready = false,
				not_matchmaking = false
			},
			versus = {
				matchmaking = false,
				matchmaking_ready = false,
				not_matchmaking = false
			},
			deus = {
				matchmaking = false,
				matchmaking_ready = false,
				not_matchmaking = false
			}
		}
	},
	{
		display_name = "inventory_menu_button_name",
		requires_player_unit = true,
		fade = true,
		transition_state = "overview",
		transition = "hero_view",
		force_open = true,
		disable_for_mechanism = var_0_8,
		can_add_function = var_0_6
	},
	{
		requires_player_unit = true,
		transition_sub_state = "talents",
		display_name = "hero_window_talents",
		force_open = true,
		fade = true,
		transition = "hero_view",
		transition_state = "overview",
		disable_for_mechanism = var_0_8,
		can_add_function = var_0_6
	},
	{
		requires_player_unit = true,
		transition_sub_state = "cosmetics",
		display_name = "hero_window_cosmetics",
		force_open = true,
		fade = true,
		transition = "hero_view",
		transition_state = "overview",
		disable_for_mechanism = var_0_8,
		can_add_function = var_0_6
	},
	{
		display_name = "achievements",
		requires_player_unit = true,
		fade = true,
		transition_state = "achievements",
		transition = "hero_view"
	},
	{
		display_name = "start_menu_view",
		requires_player_unit = true,
		fade = false,
		transition = "start_menu_view",
		disable_for_mechanism = var_0_8
	},
	{
		fade = true,
		transition = "options_menu",
		display_name = "options_menu_button_name",
		disable_for_mechanism = var_0_8
	},
	{
		fade = true,
		transition = "console_friends_menu",
		display_name = "console_friends_menu_button_name",
		disable_for_mechanism = var_0_8
	},
	{
		fade = false,
		transition = "return_to_title_screen_hero_view",
		display_name = "menu_return_to_title_screen"
	},
	{
		fade = false,
		transition = "leave_group_hero_view",
		display_name = "leave_game_menu_button_name"
	},
	{
		fade = false,
		transition = "quit_game_hero_view",
		display_name = "quit_menu_button_name"
	}
}

return {
	menu_layouts = var_0_5,
	full_access_layout = var_0_11
}
