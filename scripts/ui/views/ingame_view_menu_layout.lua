-- chunkname: @scripts/ui/views/ingame_view_menu_layout.lua

local function var_0_0()
	local var_1_0 = Managers.state.game_mode:level_key()
	local var_1_1 = Managers.player:local_player()

	if var_1_1 and Unit.alive(var_1_1.player_unit) then
		Managers.telemetry_events:player_stuck(var_1_1, var_1_0)
	end
end

local var_0_1 = {
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
local var_0_2 = {
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
local var_0_3 = "https://vermintide2beta.com/?utm_medium=referral&utm_campaign=vermintide2beta&utm_source=ingame#challenge"
local var_0_4 = IS_XB1 and "leave_party_menu_button_name_xb1" or "leave_party_menu_button_name"
local var_0_5 = IS_XB1 and "disband_party_menu_button_name_xb1" or "disband_party_menu_button_name"
local var_0_6 = IS_XB1 and "quit_menu_button_name_xb1" or "quit_menu_button_name_ps4"
local var_0_7 = {}

if IS_PS4 then
	var_0_7 = {
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
					disable_for_mechanism = var_0_1
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
					disable_for_mechanism = var_0_1
				},
				{
					fade = false,
					transition = "return_to_title_screen",
					display_name = var_0_6
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
					disable_for_mechanism = var_0_1
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
					disable_for_mechanism = var_0_1
				},
				{
					fade = false,
					transition = "leave_group",
					display_name = var_0_5
				},
				{
					fade = false,
					transition = "return_to_title_screen",
					display_name = var_0_6
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
					disable_for_mechanism = var_0_1
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
					disable_for_mechanism = var_0_1
				},
				{
					fade = false,
					transition = "leave_group",
					display_name = var_0_4
				},
				{
					fade = false,
					transition = "return_to_title_screen",
					display_name = var_0_6
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
					disable_for_mechanism = var_0_1
				},
				{
					fade = false,
					transition = "leave_group",
					display_name = "leave_game_menu_button_name"
				},
				{
					fade = false,
					transition = "return_to_title_screen",
					display_name = var_0_6
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
					disable_for_mechanism = var_0_1
				},
				{
					fade = false,
					transition = "leave_group",
					display_name = var_0_5
				},
				{
					fade = false,
					transition = "return_to_title_screen",
					display_name = var_0_6
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
					disable_for_mechanism = var_0_1
				},
				{
					fade = false,
					transition = "leave_group",
					display_name = var_0_4
				},
				{
					fade = false,
					transition = "return_to_title_screen",
					display_name = var_0_6
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
					display_name = var_0_6
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
elseif IS_XB1 then
	var_0_7 = {
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
					disable_for_mechanism = var_0_1
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
					disable_for_mechanism = var_0_1
				},
				{
					fade = false,
					transition = "leave_group",
					display_name = "leave_game_menu_button_name"
				},
				{
					fade = false,
					transition = "return_to_title_screen",
					display_name = var_0_6
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
					disable_for_mechanism = var_0_1
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
					disable_for_mechanism = var_0_1
				},
				{
					fade = false,
					transition = "leave_group",
					display_name = var_0_5
				},
				{
					fade = false,
					transition = "return_to_title_screen",
					display_name = var_0_6
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
					disable_for_mechanism = var_0_1
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
					disable_for_mechanism = var_0_1
				},
				{
					fade = false,
					transition = "leave_group",
					display_name = var_0_4
				},
				{
					fade = false,
					transition = "return_to_title_screen",
					display_name = var_0_6
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
					disable_for_mechanism = var_0_1
				},
				{
					fade = false,
					transition = "leave_group",
					display_name = "leave_game_menu_button_name"
				},
				{
					fade = false,
					transition = "return_to_title_screen",
					display_name = var_0_6
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
					disable_for_mechanism = var_0_1
				},
				{
					fade = false,
					transition = "leave_group",
					display_name = var_0_5
				},
				{
					fade = false,
					transition = "return_to_title_screen",
					display_name = var_0_6
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
					disable_for_mechanism = var_0_1
				},
				{
					fade = false,
					transition = "leave_group",
					display_name = var_0_4
				},
				{
					fade = false,
					transition = "return_to_title_screen",
					display_name = var_0_6
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
					display_name = var_0_6
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
	var_0_7 = {
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
					disable_for_mechanism = var_0_1
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
					disable_for_mechanism = var_0_1
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
					disable_for_mechanism = var_0_1
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
					disable_for_mechanism = var_0_1
				},
				{
					fade = false,
					transition = "leave_group",
					display_name = var_0_5
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
					disable_for_mechanism = var_0_1
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
					disable_for_mechanism = var_0_1
				},
				{
					fade = false,
					transition = "leave_group",
					display_name = var_0_4
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
					disable_for_mechanism = var_0_1
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
					disable_for_mechanism = var_0_1
				},
				{
					fade = false,
					transition = "leave_group",
					display_name = var_0_5
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
					disable_for_mechanism = var_0_1
				},
				{
					fade = false,
					transition = "leave_group",
					display_name = var_0_4
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

if GameSettingsDevelopment.use_global_chat and IS_WINDOWS then
	table.insert(var_0_7.in_menu.host, 4, {
		fade = false,
		transition = "chat_view",
		display_name = "chat_menu_button_name"
	})
	table.insert(var_0_7.in_menu.client, 4, {
		fade = false,
		transition = "chat_view",
		display_name = "chat_menu_button_name"
	})
	table.insert(var_0_7.in_menu.alone, 4, {
		fade = false,
		transition = "chat_view",
		display_name = "chat_menu_button_name"
	})
	table.insert(var_0_7.in_game.host, 4, {
		fade = false,
		transition = "chat_view",
		display_name = "chat_menu_button_name"
	})
	table.insert(var_0_7.in_game.client, 4, {
		fade = false,
		transition = "chat_view",
		display_name = "chat_menu_button_name"
	})
	table.insert(var_0_7.in_game.alone, 4, {
		fade = false,
		transition = "chat_view",
		display_name = "chat_menu_button_name"
	})
end

local var_0_8 = {
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
		disable_for_mechanism = var_0_1
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
		disable_for_mechanism = var_0_1
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
	menu_layouts = var_0_7,
	full_access_layout = var_0_8
}
