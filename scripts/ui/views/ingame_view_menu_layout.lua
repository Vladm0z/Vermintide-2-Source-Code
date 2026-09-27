-- chunkname: @scripts/ui/views/ingame_view_menu_layout.lua

local function fn()
	-- function 1
	local level_key = Managers.state.game_mode:level_key()
	local local_player = Managers.player:local_player()

	if not local_player and not Unit.alive(local_player.player_unit) then
		Managers.telemetry_events:player_stuck(local_player, level_key)
	end
end

local tbl = {
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
local tbl_2 = {
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
local str = "https://vermintide2beta.com/?utm_medium=referral&utm_campaign=vermintide2beta&utm_source=ingame#challenge"
local flag

flag = not IS_XB1 and "leave_party_menu_button_name_xb1" and "leave_party_menu_button_name"

local flag_2

flag_2 = not IS_XB1 and "disband_party_menu_button_name_xb1" and "disband_party_menu_button_name"

local flag_3

flag_3 = not IS_XB1 and "quit_menu_button_name_xb1" and "quit_menu_button_name_ps4"

local tbl_3 = {}

if not IS_PS4 then
	tbl_3 = {
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
					disable_for_mechanism = tbl
				},
				{
					display_name = "interact_open_inventory_chest",
					requires_player_unit = true,
					fade = true,
					transition_state = "overview",
					transition = "hero_view_force"
				},
				{
					fade = true,
					transition = "options_menu",
					display_name = "options_menu_button_name",
					disable_for_mechanism = tbl
				},
				{
					fade = false,
					transition = "return_to_title_screen",
					display_name = flag_3
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
					disable_for_mechanism = tbl
				},
				{
					display_name = "interact_open_inventory_chest",
					requires_player_unit = true,
					fade = true,
					transition_state = "overview",
					transition = "hero_view_force"
				},
				{
					fade = true,
					transition = "options_menu",
					display_name = "options_menu_button_name",
					disable_for_mechanism = tbl
				},
				{
					fade = false,
					transition = "leave_group",
					display_name = flag_2
				},
				{
					fade = false,
					transition = "return_to_title_screen",
					display_name = flag_3
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
					disable_for_mechanism = tbl
				},
				{
					display_name = "interact_open_inventory_chest",
					requires_player_unit = true,
					fade = true,
					transition_state = "overview",
					transition = "hero_view_force"
				},
				{
					fade = true,
					transition = "options_menu",
					display_name = "options_menu_button_name",
					disable_for_mechanism = tbl
				},
				{
					fade = false,
					transition = "leave_group",
					display_name = flag
				},
				{
					fade = false,
					transition = "return_to_title_screen",
					display_name = flag_3
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
					disable_for_mechanism = tbl
				},
				{
					fade = false,
					transition = "leave_group",
					display_name = "leave_game_menu_button_name"
				},
				{
					fade = false,
					transition = "return_to_title_screen",
					display_name = flag_3
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
					disable_for_mechanism = tbl
				},
				{
					fade = false,
					transition = "leave_group",
					display_name = flag_2
				},
				{
					fade = false,
					transition = "return_to_title_screen",
					display_name = flag_3
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
					disable_for_mechanism = tbl
				},
				{
					fade = false,
					transition = "leave_group",
					display_name = flag
				},
				{
					fade = false,
					transition = "return_to_title_screen",
					display_name = flag_3
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
					transition = "leave_group",
					display_name = "leave_game_menu_button_name"
				},
				{
					transition = "return_to_title_screen",
					display_name = flag_3
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
elseif not IS_XB1 then
	tbl_3 = {
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
					disable_for_mechanism = tbl
				},
				{
					display_name = "interact_open_inventory_chest",
					requires_player_unit = true,
					fade = true,
					transition_state = "overview",
					transition = "hero_view_force"
				},
				{
					fade = true,
					transition = "options_menu",
					display_name = "options_menu_button_name",
					disable_for_mechanism = tbl
				},
				{
					fade = false,
					transition = "leave_group",
					display_name = "leave_game_menu_button_name"
				},
				{
					fade = false,
					transition = "return_to_title_screen",
					display_name = flag_3
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
					disable_for_mechanism = tbl
				},
				{
					display_name = "interact_open_inventory_chest",
					requires_player_unit = true,
					fade = true,
					transition_state = "overview",
					transition = "hero_view_force"
				},
				{
					fade = true,
					transition = "options_menu",
					display_name = "options_menu_button_name",
					disable_for_mechanism = tbl
				},
				{
					fade = false,
					transition = "leave_group",
					display_name = flag_2
				},
				{
					fade = false,
					transition = "return_to_title_screen",
					display_name = flag_3
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
					disable_for_mechanism = tbl
				},
				{
					display_name = "interact_open_inventory_chest",
					requires_player_unit = true,
					fade = true,
					transition_state = "overview",
					transition = "hero_view_force"
				},
				{
					fade = true,
					transition = "options_menu",
					display_name = "options_menu_button_name",
					disable_for_mechanism = tbl
				},
				{
					fade = false,
					transition = "leave_group",
					display_name = flag
				},
				{
					fade = false,
					transition = "return_to_title_screen",
					display_name = flag_3
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
					disable_for_mechanism = tbl
				},
				{
					fade = false,
					transition = "leave_group",
					display_name = "leave_game_menu_button_name"
				},
				{
					fade = false,
					transition = "return_to_title_screen",
					display_name = flag_3
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
					disable_for_mechanism = tbl
				},
				{
					fade = false,
					transition = "leave_group",
					display_name = flag_2
				},
				{
					fade = false,
					transition = "return_to_title_screen",
					display_name = flag_3
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
					disable_for_mechanism = tbl
				},
				{
					fade = false,
					transition = "leave_group",
					display_name = flag
				},
				{
					fade = false,
					transition = "return_to_title_screen",
					display_name = flag_3
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
					transition = "leave_group",
					display_name = "leave_game_menu_button_name"
				},
				{
					transition = "return_to_title_screen",
					display_name = flag_3
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
else
	tbl_3 = {
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
					disable_for_mechanism = tbl
				},
				{
					display_name = "interact_open_inventory_chest",
					requires_player_unit = true,
					fade = true,
					transition_state = "overview",
					transition = "hero_view_force"
				},
				{
					fade = true,
					transition = "options_menu",
					display_name = "options_menu_button_name",
					disable_for_mechanism = tbl
				},
				{
					fade = false,
					transition = "leave_group",
					display_name = "leave_game_menu_button_name"
				},
				{
					fade = false,
					transition = "return_to_title_screen",
					display_name = "menu_return_to_title_screen"
				},
				{
					fade = false,
					transition = "quit_game_hero_view_legacy",
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
					disable_for_mechanism = tbl
				},
				{
					display_name = "interact_open_inventory_chest",
					requires_player_unit = true,
					fade = true,
					transition_state = "overview",
					transition = "hero_view_force"
				},
				{
					fade = true,
					transition = "options_menu",
					display_name = "options_menu_button_name",
					disable_for_mechanism = tbl
				},
				{
					fade = false,
					transition = "leave_group",
					display_name = flag_2
				},
				{
					fade = false,
					transition = "return_to_title_screen",
					display_name = "menu_return_to_title_screen"
				},
				{
					fade = false,
					transition = "quit_game_hero_view_legacy",
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
					disable_for_mechanism = tbl
				},
				{
					display_name = "interact_open_inventory_chest",
					requires_player_unit = true,
					fade = true,
					transition_state = "overview",
					transition = "hero_view_force"
				},
				{
					fade = true,
					transition = "options_menu",
					display_name = "options_menu_button_name",
					disable_for_mechanism = tbl
				},
				{
					fade = false,
					transition = "leave_group",
					display_name = flag
				},
				{
					fade = false,
					transition = "return_to_title_screen",
					display_name = "menu_return_to_title_screen"
				},
				{
					fade = false,
					transition = "quit_game_hero_view_legacy",
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
					disable_for_mechanism = tbl
				},
				{
					fade = false,
					transition = "leave_group",
					display_name = "leave_game_menu_button_name"
				},
				{
					fade = false,
					transition = "return_to_title_screen",
					display_name = "menu_return_to_title_screen"
				},
				{
					fade = false,
					transition = "quit_game_hero_view_legacy",
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
					disable_for_mechanism = tbl
				},
				{
					fade = false,
					transition = "leave_group",
					display_name = flag_2
				},
				{
					fade = false,
					transition = "return_to_title_screen",
					display_name = "menu_return_to_title_screen"
				},
				{
					fade = false,
					transition = "quit_game_hero_view_legacy",
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
					disable_for_mechanism = tbl
				},
				{
					fade = false,
					transition = "leave_group",
					display_name = flag
				},
				{
					fade = false,
					transition = "return_to_title_screen",
					display_name = "menu_return_to_title_screen"
				},
				{
					fade = false,
					transition = "quit_game_hero_view_legacy",
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
					transition = "leave_group",
					display_name = "leave_game_menu_button_name"
				},
				{
					transition = "return_to_title_screen",
					display_name = "menu_return_to_title_screen"
				},
				{
					fade = false,
					transition = "quit_game_hero_view_legacy",
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
				},
				{
					fade = false,
					transition = "quit_game_hero_view_legacy",
					display_name = "quit_menu_button_name"
				}
			}
		}
	}
end

if not GameSettingsDevelopment.use_global_chat and not IS_WINDOWS then
	table.insert(tbl_3.in_menu.host, 4, {
		fade = false,
		transition = "chat_view",
		display_name = "chat_menu_button_name"
	})
	table.insert(tbl_3.in_menu.client, 4, {
		fade = false,
		transition = "chat_view",
		display_name = "chat_menu_button_name"
	})
	table.insert(tbl_3.in_menu.alone, 4, {
		fade = false,
		transition = "chat_view",
		display_name = "chat_menu_button_name"
	})
	table.insert(tbl_3.in_game.host, 4, {
		fade = false,
		transition = "chat_view",
		display_name = "chat_menu_button_name"
	})
	table.insert(tbl_3.in_game.client, 4, {
		fade = false,
		transition = "chat_view",
		display_name = "chat_menu_button_name"
	})
	table.insert(tbl_3.in_game.alone, 4, {
		fade = false,
		transition = "chat_view",
		display_name = "chat_menu_button_name"
	})
end

local tbl_4 = {
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
		disable_for_mechanism = tbl
	},
	{
		display_name = "inventory_menu_button_name",
		requires_player_unit = true,
		fade = true,
		transition_state = "overview",
		transition = "hero_view"
	},
	{
		fade = true,
		transition = "start_menu_view",
		display_name = "start_menu_view",
		requires_player_unit = true
	},
	{
		fade = true,
		transition = "options_menu",
		display_name = "options_menu_button_name",
		disable_for_mechanism = tbl
	},
	{
		fade = false,
		transition = "leave_group",
		display_name = "leave_game_menu_button_name"
	},
	{
		fade = false,
		transition = "quit_game",
		display_name = "quit_menu_button_name"
	}
}

return {
	menu_layouts = tbl_3,
	full_access_layout = tbl_4
}
