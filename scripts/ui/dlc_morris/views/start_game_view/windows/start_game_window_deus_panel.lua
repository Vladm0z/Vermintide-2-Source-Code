-- chunkname: @scripts/ui/dlc_morris/views/start_game_view/windows/start_game_window_deus_panel.lua

local var_0_0 = local_require("scripts/ui/dlc_morris/views/start_game_view/windows/definitions/start_game_window_deus_panel_definitions")

StartGameWindowDeusPanel = class(StartGameWindowDeusPanel, StartGameWindowPanelConsole)
StartGameWindowDeusPanel.NAME = "StartGameWindowDeusPanel"

StartGameWindowDeusPanel._create_ui_elements = function (arg_1_0, arg_1_1, arg_1_2, arg_1_3)
	return StartGameWindowDeusPanel.super._create_ui_elements(arg_1_0, var_0_0, arg_1_2, arg_1_3)
end
