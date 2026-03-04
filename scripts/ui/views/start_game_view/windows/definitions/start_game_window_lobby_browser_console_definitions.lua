-- chunkname: @scripts/ui/views/start_game_view/windows/definitions/start_game_window_lobby_browser_console_definitions.lua

local function var_0_0(arg_1_0, arg_1_1)
	local var_1_0 = LevelSettings
	local var_1_1 = var_1_0[arg_1_0].map_settings
	local var_1_2 = var_1_0[arg_1_1].map_settings

	return (var_1_1 and var_1_1.sorting or 0) < (var_1_2 and var_1_2.sorting or 0)
end

local function var_0_1(arg_2_0, arg_2_1)
	local var_2_0 = {}
	local var_2_1 = {}
	local var_2_2 = GameSettingsDevelopment.release_levels_only

	for iter_2_0, iter_2_1 in pairs(LevelSettings) do
		if type(iter_2_1) == "table" and (not var_2_2 or not DebugLevels[iter_2_0]) then
			local var_2_3 = iter_2_1.game_mode or iter_2_1.mechanism

			if var_2_3 and var_2_3 ~= "tutorial" and var_2_3 ~= "demo" and iter_2_1.unlockable and not iter_2_1.default and LevelUnlockUtils.level_unlocked(arg_2_0, arg_2_1, iter_2_0) then
				if not var_2_1[var_2_3] then
					local var_2_4 = GameModeSettings[var_2_3]
					local var_2_5 = var_2_4.difficulties
					local var_2_6 = var_2_4.display_name
					local var_2_7 = table.clone(var_2_5)

					var_2_7[#var_2_7 + 1] = "any"
					var_2_0[#var_2_0 + 1] = {
						levels = {},
						difficulties = var_2_7,
						game_mode_key = var_2_3,
						game_mode_display_name = var_2_6
					}
					var_2_1[var_2_3] = #var_2_0
				end

				if (not iter_2_1.supported_game_modes or iter_2_1.supported_game_modes[var_2_3]) and not iter_2_1.ommit_from_lobby_browser then
					local var_2_8 = var_2_0[var_2_1[var_2_3]].levels

					var_2_8[#var_2_8 + 1] = iter_2_0
				end
			end
		end
	end

	for iter_2_2 = 1, #var_2_0 do
		local var_2_9 = var_2_0[iter_2_2].levels

		table.sort(var_2_9, var_0_0)

		var_2_9[#var_2_9 + 1] = "any"
	end

	local function var_2_10(arg_3_0, arg_3_1)
		return Localize(arg_3_0.game_mode_display_name) < Localize(arg_3_1.game_mode_display_name)
	end

	table.sort(var_2_0, var_2_10)

	local var_2_11 = {}

	for iter_2_3 = 1, #var_2_0 do
		local var_2_12 = var_2_0[iter_2_3].game_mode_key
		local var_2_13 = #var_2_11 + 1

		var_2_11[var_2_13] = var_2_12
		var_2_11[var_2_12] = var_2_13
	end

	local var_2_14 = "weave"
	local var_2_15 = GameModeSettings[var_2_14].display_name

	var_2_0[#var_2_0 + 1] = {
		levels = {
			"any"
		},
		difficulties = {
			"any"
		},
		game_mode_key = var_2_14,
		game_mode_display_name = var_2_15
	}
	var_2_11[var_2_14] = #var_2_11 + 1
	var_2_11[#var_2_11 + 1] = var_2_14
	var_2_0.game_modes = var_2_11

	return var_2_0
end

local var_0_2 = {
	"lb_show_joinable",
	"lb_show_all"
}

if IS_PS4 then
	table.insert(var_0_2, 2, "lb_search_type_friends")
end

local var_0_3 = IS_PS4 and {
	"map_zone_options_2",
	"map_zone_options_3",
	"map_zone_options_5"
} or {
	"map_zone_options_2",
	"map_zone_options_4",
	"map_zone_options_5"
}

return {
	show_lobbies_table = var_0_2,
	distance_table = var_0_3,
	setup_game_mode_data = var_0_1
}
