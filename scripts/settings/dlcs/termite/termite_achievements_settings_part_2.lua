-- chunkname: @scripts/settings/dlcs/termite/termite_achievements_settings_part_2.lua

local var_0_0 = DLCSettings.termite_part_2

var_0_0.achievement_outline = {
	levels = {
		entries = {},
		categories = {
			{
				sorting = 9,
				name = "area_selection_termite_name",
				entries = {
					"termite2_mushroom_challenge",
					"termite2_water_challenge",
					"termite2_timer_challenge",
					"termite2_complete_recruit",
					"termite2_complete_veteran",
					"termite2_complete_champion",
					"termite2_complete_legend",
					"termite2_complete_cataclysm",
					"termite2_all_challenges"
				}
			}
		}
	}
}
var_0_0.achievement_template_file_names = {
	"scripts/managers/achievements/achievement_templates_termite_part_2"
}
