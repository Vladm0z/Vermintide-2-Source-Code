-- chunkname: @scripts/ui/hud_ui/component_list_definitions/hud_component_list_map_deus.lua

local adventure_settings = local_require("scripts/ui/hud_ui/component_list_definitions/hud_component_list_adventure")
local common_settings = require("scripts/ui/hud_ui/component_list_definitions/hud_component_list_deus_common")
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
		validation_function = function (context, is_in_inn)
			-- function 1
			local disable_news_ticker = script_data.disable_news_ticker

			return not disable_news_ticker
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
		validation_function = function (context, is_in_inn)
			-- function 2
			local use_twitch_ui = true

			return use_twitch_ui
		end
	}
}
local tbl_2 = {
	class_name = "IngamePlayerListUI"
}
local flag

flag = (not GameSettingsDevelopment.use_new_tab_menu or not "scripts/ui/views/ingame_player_list_ui_v2") and not not "scripts/ui/views/ingame_player_list_ui"
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
	validation_function = function (context, is_in_inn)
		-- function 3
		if is_in_inn then
			return true
		else
			local twitch = Managers.twitch

			if twitch then
				-- Nothing
			end

			twitch = Managers.twitch:is_connected()

			if not twitch then
				-- Nothing
			end

			twitch = Managers.twitch:is_activated()

			local use_twitch_ui = twitch

			::label_3_0::

			if not use_twitch_ui then
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

local components = tbl

DLCUtils.append("ingame_hud_components", components)
table.append(components, common_settings.components)

local visibility_groups = {}

table.append(visibility_groups, common_settings.visibility_groups)
table.append(visibility_groups, adventure_settings.visibility_groups)

return {
	components = components,
	visibility_groups = visibility_groups
}
