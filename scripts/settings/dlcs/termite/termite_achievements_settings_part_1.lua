-- chunkname: @scripts/settings/dlcs/termite/termite_achievements_settings_part_1.lua

local var_0_0 = DLCSettings.termite_part_1

var_0_0.achievement_outline = {
	levels = {
		entries = {},
		categories = {
			{
				sorting = 9,
				name = "area_selection_termite_name",
				entries = {
					"termite1_skaven_markings_challenge",
					"termite1_bell_challenge",
					"termite1_towers_challenge",
					"termite1_waystone_timer_challenge_easy",
					"termite1_waystone_timer_challenge_hard",
					"termite1_complete_recruit",
					"termite1_complete_veteran",
					"termite1_complete_champion",
					"termite1_complete_legend",
					"termite1_complete_cataclysm",
					"termite1_all_challenges"
				}
			}
		}
	}
}
var_0_0.achievement_template_file_names = {
	"scripts/managers/achievements/achievement_templates_termite_part_1"
}
