-- chunkname: @scripts/game_state/title_screen_substates/win32/state_title_screen_main_menu_settings.lua

local function fn(arg_1_0)
	-- function 1
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
						-- function 2
						Managers.music:trigger_event("Play_console_menu_start_game")

						local get_starting_level = AdventureMechanism.get_starting_level()

						arg_1_0:_start_game(get_starting_level)
					end
				},
				{
					description = "start_menu_cw_description",
					video = "chaos_wastes",
					tag = "start_menu_cw_tag",
					logo_texture = "chaos_wastes_logo",
					text = "area_selection_morris_name",
					callback = function ()
						-- function 3
						Managers.music:trigger_event("Play_console_menu_start_game")

						local get_starting_level = DeusMechanism.get_starting_level()

						arg_1_0:_start_game(get_starting_level)
					end
				},
				{
					description = "start_menu_vs_description",
					video = "versus",
					tag = "start_menu_vs_tag",
					logo_texture = "versus_logo",
					text = "vs_ui_versus_tag",
					conditional_func = function ()
						-- function 4
						if not GameSettingsDevelopment.use_backend then
							return true
						end

						local versus = Managers.backend:get_title_settings().versus

						return not versus and versus.active
					end,
					callback = function ()
						-- function 5
						Managers.music:trigger_event("Play_console_menu_start_game")

						local get_starting_level = VersusMechanism.get_starting_level()

						arg_1_0:_start_game(get_starting_level)
					end
				}
			}
		},
		{
			text = "start_menu_options",
			callback = function ()
				-- function 6
				arg_1_0:_activate_view("options_view")
			end
		},
		{
			text = "start_menu_cinematics",
			callback = function ()
				-- function 7
				Managers.music:trigger_event("Play_console_menu_select")
				Managers.music:trigger_event("play_gui_start_menu_generic_whoosh")
				arg_1_0:_activate_view("cinematics_view")
			end
		},
		{
			text = "start_menu_tutorial",
			callback = function ()
				-- function 8
				Managers.music:trigger_event("Play_console_menu_start_game")
				arg_1_0:_start_game("prologue")
			end
		},
		{
			text = "start_menu_credits",
			callback = function ()
				-- function 9
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
	create_menu_layout = fn
}
