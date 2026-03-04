-- chunkname: @scripts/settings/dlcs/termite/termite_level_settings_part_2.lua

local var_0_0 = DLCSettings.termite_part_2

var_0_0.level_settings = "levels/honduras_dlcs/termite/level_settings_termite_part_2"
var_0_0.missions = {
	termite_lvl2_start = {
		mission_template_name = "goal",
		text = "termite_lvl2_start"
	},
	termite_lvl2_valves = {
		text = "termite_lvl2_valves",
		mission_template_name = "collect",
		collect_amount = 4
	},
	termite_lvl2_bomb = {
		mission_template_name = "goal",
		text = "termite_lvl2_bomb"
	},
	termite_lvl2_follow_bomb = {
		mission_template_name = "goal",
		text = "termite_lvl2_follow_bomb"
	},
	termite_lvl2_escape = {
		mission_template_name = "goal",
		text = "termite_lvl2_escape"
	},
	termite_lvl2_boss = {
		mission_template_name = "goal",
		text = "termite_lvl2_boss"
	},
	termite_lvl2_exit = {
		mission_template_name = "goal",
		text = "termite_lvl2_exit"
	}
}
