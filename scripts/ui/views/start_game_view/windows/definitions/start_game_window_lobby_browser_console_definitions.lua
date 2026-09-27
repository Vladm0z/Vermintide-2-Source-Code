-- chunkname: @scripts/ui/views/start_game_view/windows/definitions/start_game_window_lobby_browser_console_definitions.lua

local function fn(arg_1_0, arg_1_1)
	-- function 1
	local LevelSettings = LevelSettings
	local map_settings = LevelSettings[arg_1_0].map_settings
	local map_settings_2 = LevelSettings[arg_1_1].map_settings
	local sorting

	if not map_settings then
		sorting = map_settings.sorting

		if not sorting then
			-- Nothing
		end
	end

	sorting = 0

	do
		local sorting_2
	end

	::label_1_0::

	if not map_settings_2 then
		sorting_2 = map_settings_2.sorting

		if not sorting_2 then
			-- Nothing
		end
	end

	sorting_2 = 0

	::label_1_1::

	return sorting < sorting_2
end

local function fn_2(arg_2_0, arg_2_1)
	-- function 2
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

				if not unlockable and not LevelUnlockUtils.level_unlocked(arg_2_0, arg_2_1, k) then
					if not tbl_2[game_mode] then
						local var_2_5 = GameModeSettings[game_mode]
						local difficulties = var_2_5.difficulties
						local display_name = var_2_5.display_name
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

	local function fn_2(self, arg_3_1)
		-- function 3
		return Localize(self.game_mode_display_name) < Localize(arg_3_1.game_mode_display_name)
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
	local display_name_2 = GameModeSettings[str].display_name

	tbl[#tbl + 1] = {
		levels = {
			"any"
		},
		difficulties = {
			"any"
		},
		game_mode_key = str,
		game_mode_display_name = display_name_2
	}
	tbl_3[str] = #tbl_3 + 1
	tbl_3[#tbl_3 + 1] = str
	tbl.game_modes = tbl_3

	return tbl
end

local tbl = {
	"lb_show_joinable",
	"lb_show_all"
}

if not IS_PS4 then
	table.insert(tbl, 2, "lb_search_type_friends")
end

local tbl_2

if not IS_PS4 then
	tbl_2 = {
		"map_zone_options_2",
		"map_zone_options_3",
		"map_zone_options_5"
	}

	if not tbl_2 then
		-- Nothing
	end
end

tbl_2 = {
	"map_zone_options_2",
	"map_zone_options_4",
	"map_zone_options_5"
}

::label_0_0::

return {
	show_lobbies_table = tbl,
	distance_table = tbl_2,
	setup_game_mode_data = fn_2
}
