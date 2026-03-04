-- chunkname: @scripts/ui/dlc_morris/views/start_game_view/windows/start_game_window_deus_additional_settings.lua

StartGameWindowDeusAdditionalSettings = class(StartGameWindowDeusAdditionalSettings, StartGameWindowAdditionalSettingsConsole)
StartGameWindowDeusAdditionalSettings.NAME = "StartGameWindowDeusAdditionalSettings"

local var_0_0 = local_require("scripts/ui/dlc_morris/views/start_game_view/windows/definitions/start_game_window_deus_additional_settings_definitions")

function StartGameWindowDeusAdditionalSettings.create_ui_elements(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
	StartGameWindowDeusAdditionalSettings.super.create_ui_elements(arg_1_0, var_0_0, arg_1_2, arg_1_3)
end
