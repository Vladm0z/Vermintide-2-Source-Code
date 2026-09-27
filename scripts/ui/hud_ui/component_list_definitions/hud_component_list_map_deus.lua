-- chunkname: @scripts/ui/hud_ui/component_list_definitions/hud_component_list_map_deus.lua

local var_0_0 = local_require("scripts/ui/hud_ui/component_list_definitions/hud_component_list_adventure")
local scripts_ui_hud_ui_component_list_definitions_hud_component_list_deus_common = require("scripts/ui/hud_ui/component_list_definitions/hud_component_list_deus_common")
local tbl = {
	{
		class_name = "IngameNewsTickerUI",
		filename = "scripts/ui/hud_ui/ingame_news_ticker_ui",
		visibility_groups = {
			"entering_mission",
			"hero_selection_popup",
			"mission_vote",
			"game_mode_disable_hud",
			"cutscene",
			"realism",
			"dead",
			"alive"
		},
		validation_function = function (arg_1_0, arg_1_1)
			-- function 1
			return not script_data.disable_news_ticker
		end
	},
	{
		use_hud_scale = true,
		class_name = "TwitchVoteUI",
		filename = "scripts/ui/hud_ui/twitch_vote_ui",
		visibility_groups = {
			"realism",
			"alive",
			"dead"
		},
		validation_function = function (arg_2_0, arg_2_1)
			-- function 2
			return true
		end
	}
}
local tbl_2 = {
	class_name = "IngamePlayerListUI"
}
local flag

flag = not GameSettingsDevelopment.use_new_tab_menu and "scripts/ui/views/ingame_player_list_ui_v2" and "scripts/ui/views/ingame_player_list_ui"
tbl_2.filename = flag
tbl_2.visibility_groups = {
	"tab_menu",
	"realism",
	"game_mode_disable_hud",
	"dead",
	"alive"
}
tbl[3] = tbl_2
tbl[4] = {
	use_hud_scale = true,
	class_name = "SubtitleGui",
	filename = "scripts/ui/views/subtitle_gui",
	visibility_groups = {
		"cutscene",
		"realism",
		"dead",
		"alive"
	},
	validation_function = function (arg_3_0, arg_3_1)
		-- function 3
		if not arg_3_1 then
			return true
		else
			local twitch = Managers.twitch

			if not twitch then
				twitch = Managers.twitch:is_connected()
				twitch = twitch or Managers.twitch:is_activated()
			end

			if not twitch then
				return true
			end
		end
	end
}
tbl[5] = {
	use_hud_scale = true,
	class_name = "DeusRunStatsView",
	filename = "scripts/ui/views/deus_menu/deus_run_stats_view",
	visibility_groups = {
		"deus_run_stats",
		"game_mode_disable_hud",
		"dead",
		"alive"
	}
}

DLCUtils.append("ingame_hud_components", tbl)
table.append(tbl, scripts_ui_hud_ui_component_list_definitions_hud_component_list_deus_common.components)

local tbl_3 = {}

table.append(tbl_3, scripts_ui_hud_ui_component_list_definitions_hud_component_list_deus_common.visibility_groups)
table.append(tbl_3, var_0_0.visibility_groups)

return {
	components = tbl,
	visibility_groups = tbl_3
}
