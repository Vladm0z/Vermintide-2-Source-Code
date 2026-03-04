-- chunkname: @scripts/game_state/title_screen_substates/win32/state_title_screen_main_menu_settings.lua

local function var_0_0(arg_1_0)
	return {
		{
			text = "start_game_menu_button_name",
			callback = callback(arg_1_0, "_check_prologue_status"),
			layout = {
				{
					description = "start_menu_adventure_description",
					video = "adventure",
					text = "tutorial_intro_adventure",
					info_slate = "start_menu_recommended_tag",
					tag = "start_menu_adventure_tag",
					callback = function ()
						Managers.music:trigger_event("Play_console_menu_start_game")

						local var_2_0 = AdventureMechanism.get_starting_level()

						arg_1_0:_start_game(var_2_0)
					end
				},
				{
					description = "start_menu_cw_description",
					video = "chaos_wastes",
					tag = "start_menu_cw_tag",
					logo_texture = "chaos_wastes_logo",
					text = "area_selection_morris_name",
					callback = function ()
						Managers.music:trigger_event("Play_console_menu_start_game")

						local var_3_0 = DeusMechanism.get_starting_level()

						arg_1_0:_start_game(var_3_0)
					end
				},
				{
					description = "start_menu_vs_description",
					video = "versus",
					tag = "start_menu_vs_tag",
					logo_texture = "versus_logo",
					text = "vs_ui_versus_tag",
					conditional_func = function ()
						if not GameSettingsDevelopment.use_backend then
							return true
						end

						local var_4_0 = Managers.backend:get_title_settings().versus

						return var_4_0 and var_4_0.active
					end,
					callback = function ()
						Managers.music:trigger_event("Play_console_menu_start_game")

						local var_5_0 = VersusMechanism.get_starting_level()

						arg_1_0:_start_game(var_5_0)
					end
				}
			}
		},
		{
			text = "start_menu_options",
			callback = function ()
				arg_1_0:_activate_view("options_view")
			end
		},
		{
			text = "start_menu_cinematics",
			callback = function ()
				Managers.music:trigger_event("Play_console_menu_select")
				Managers.music:trigger_event("play_gui_start_menu_generic_whoosh")
				arg_1_0:_activate_view("cinematics_view")
			end
		},
		{
			text = "start_menu_tutorial",
			callback = function ()
				Managers.music:trigger_event("Play_console_menu_start_game")
				arg_1_0:_start_game("prologue")
			end
		},
		{
			text = "start_menu_credits",
			callback = function ()
				Managers.music:trigger_event("Play_console_menu_select")
				arg_1_0:_activate_view("credits_view")
			end
		},
		{
			text = "menu_quit",
			callback = callback(arg_1_0, "_quit_game")
		}
	}
end

return {
	create_menu_layout = var_0_0
}
