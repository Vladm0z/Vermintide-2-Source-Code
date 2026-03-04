-- chunkname: @scripts/managers/achievements/achievement_templates_wizards_part_1.lua

local var_0_0 = AchievementTemplateHelper.add_event_challenge
local var_0_1 = AchievementTemplateHelper.add_levels_complete_challenge
local var_0_2 = AchievementTemplateHelper.add_meta_challenge
local var_0_3 = AchievementTemplateHelper.PLACEHOLDER_ICON
local var_0_4 = AchievementTemplates.achievements
local var_0_5 = AchievementTemplateHelper.PLACEHOLDER_ICON
local var_0_6 = AchievementTemplateHelper.add_console_achievements
local var_0_7 = {
	trail_sleigher = 104,
	trail_shatterer = 102,
	trail_beacons_are_lit = 105,
	onions_complete_trail_legend = 106,
	trail_cog_strike = 103
}
local var_0_8 = {
	trail_beacons_are_lit = "087"
}
local var_0_9 = {}
local var_0_10 = {
	LevelSettings.dlc_wizards_trail
}
local var_0_11 = {
	"normal",
	"hard",
	"harder",
	"hardest",
	"cataclysm"
}

for iter_0_0 = 1, #var_0_11 do
	local var_0_12 = var_0_11[iter_0_0]
	local var_0_13 = DifficultyMapping[var_0_12]
	local var_0_14 = "onions_complete_trail_" .. var_0_13

	var_0_9[iter_0_0] = var_0_14

	var_0_1(var_0_4, var_0_14, var_0_10, DifficultySettings[var_0_12].rank, "achievement_wizards_trail_complete_" .. var_0_13, nil, var_0_7[var_0_14], var_0_8[var_0_14])
end

var_0_4.trail_cog_strike = {
	name = "achv_onions_cog_strike_name",
	display_completion_ui = true,
	icon = "achievement_wizards_trail_push_enemies_with_cog",
	desc = "achv_onions_cog_strike_desc",
	events = {
		"on_trail_cog_strike",
		"on_trail_cog_reset_stat"
	},
	completed = function (arg_1_0, arg_1_1, arg_1_2)
		return arg_1_0:get_persistent_stat(arg_1_1, "trail_cog_strike") >= 1
	end,
	on_event = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4)
		if arg_2_3 == "on_trail_cog_strike" then
			if not arg_2_2.current_hits or not arg_2_2.units then
				arg_2_2.current_hits = 0
				arg_2_2.units = {}
			end

			local var_2_0 = arg_2_4[1]

			if arg_2_2.units[var_2_0] then
				return
			end

			arg_2_2.units[var_2_0] = true
			arg_2_2.current_hits = arg_2_2.current_hits + 1

			if arg_2_2.current_hits >= 10 then
				arg_2_0:increment_stat(arg_2_1, "trail_cog_strike")

				arg_2_2.current_hits = 0
			end
		elseif arg_2_3 == "on_trail_cog_reset_stat" then
			arg_2_2.current_hits = 0
			arg_2_2.units = {}
		end
	end
}
var_0_4.trail_shatterer = {
	name = "achv_onions_icicles_name",
	display_completion_ui = true,
	icon = "achievement_wizards_trail_break_icicles",
	desc = "achv_onions_icicles_desc",
	completed = function (arg_3_0, arg_3_1, arg_3_2)
		return arg_3_0:get_persistent_stat(arg_3_1, "trail_shatterer") >= 1
	end
}
var_0_4.trail_sleigher = {
	name = "achv_onions_sleigh_kills_name",
	display_completion_ui = true,
	icon = "achievement_wizards_trail_kill_enemies_with_sleigh",
	desc = "achv_onions_sleigh_kills_desc",
	progress = function (arg_4_0, arg_4_1, arg_4_2)
		local var_4_0 = arg_4_0:get_persistent_stat(arg_4_1, "trail_sleigher") or 0

		return {
			var_4_0,
			50
		}
	end,
	completed = function (arg_5_0, arg_5_1, arg_5_2)
		return arg_5_0:get_persistent_stat(arg_5_1, "trail_sleigher") >= 50
	end
}
var_0_4.trail_beacons_are_lit = {
	name = "achv_onions_light_beacons_name",
	display_completion_ui = true,
	icon = "achievement_wizards_trail_light_bonfires",
	desc = "achv_onions_light_beacons_desc",
	progress = function (arg_6_0, arg_6_1, arg_6_2)
		local var_6_0 = arg_6_0:get_persistent_stat(arg_6_1, "trail_bonfire_watch_tower") or 0
		local var_6_1 = arg_6_0:get_persistent_stat(arg_6_1, "trail_bonfire_river_path") or 0
		local var_6_2 = arg_6_0:get_persistent_stat(arg_6_1, "trail_bonfire_lookout_point") or 0

		if var_6_0 > 1 then
			var_6_0 = 1
		end

		if var_6_1 > 1 then
			var_6_1 = 1
		end

		if var_6_2 > 1 then
			var_6_2 = 1
		end

		local var_6_3 = 0
		local var_6_4 = var_6_0 + var_6_1 + var_6_2

		return {
			var_6_4,
			3
		}
	end,
	completed = function (arg_7_0, arg_7_1, arg_7_2)
		local var_7_0 = arg_7_0:get_persistent_stat(arg_7_1, "trail_bonfire_watch_tower")
		local var_7_1 = arg_7_0:get_persistent_stat(arg_7_1, "trail_bonfire_river_path")
		local var_7_2 = arg_7_0:get_persistent_stat(arg_7_1, "trail_bonfire_lookout_point")

		if var_7_0 >= 1 and var_7_1 >= 1 and var_7_2 >= 1 then
			return true
		end
	end
}
all_trail_challenges = table.clone(var_0_9)

table.remove(all_trail_challenges, #all_trail_challenges)

all_trail_challenges[#all_trail_challenges + 1] = "trail_cog_strike"
all_trail_challenges[#all_trail_challenges + 1] = "trail_shatterer"
all_trail_challenges[#all_trail_challenges + 1] = "trail_sleigher"
all_trail_challenges[#all_trail_challenges + 1] = "trail_beacons_are_lit"

var_0_2(var_0_4, "onions_complete_all", all_trail_challenges, "achievement_wizards_trail_complete_all_challenges", nil, var_0_7[name], var_0_8[name])
var_0_6(var_0_7, var_0_8)
