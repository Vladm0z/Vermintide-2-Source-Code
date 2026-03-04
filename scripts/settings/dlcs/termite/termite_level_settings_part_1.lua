-- chunkname: @scripts/settings/dlcs/termite/termite_level_settings_part_1.lua

local var_0_0 = DLCSettings.termite_part_1

var_0_0.level_settings = "levels/honduras_dlcs/termite/level_settings_termite_part_1"
var_0_0.level_unlock_settings = "levels/honduras_dlcs/termite/level_unlock_settings_termite"
var_0_0.missions = {
	termite_lvl1_follow_stream = {
		mission_template_name = "goal",
		text = "termite_lvl1_follow_stream"
	},
	termite_lvl1_reach_temple = {
		mission_template_name = "goal",
		text = "termite_lvl1_reach_temple"
	},
	termite_lvl1_find_entrance = {
		mission_template_name = "goal",
		text = "termite_lvl1_find_entrance"
	},
	termite_lvl1_find_waystone = {
		mission_template_name = "goal",
		text = "termite_lvl1_find_waystone"
	},
	termite_lvl1_repair_waystone = {
		mission_template_name = "goal",
		text = "termite_lvl1_repair_waystone"
	},
	termite_lvl1_find_waystone_pieces = {
		text = "termite_lvl1_find_waystone_pieces",
		mission_template_name = "collect",
		collect_amount = 4
	},
	termite_lvl1_escape = {
		mission_template_name = "goal",
		text = "termite_lvl1_escape"
	}
}
