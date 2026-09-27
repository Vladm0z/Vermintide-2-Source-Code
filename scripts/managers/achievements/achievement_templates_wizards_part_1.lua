-- chunkname: @scripts/managers/achievements/achievement_templates_wizards_part_1.lua

local add_event_challenge = AchievementTemplateHelper.add_event_challenge
local add_levels_complete_challenge = AchievementTemplateHelper.add_levels_complete_challenge
local add_meta_challenge = AchievementTemplateHelper.add_meta_challenge
local PLACEHOLDER_ICON = AchievementTemplateHelper.PLACEHOLDER_ICON
local achievements = AchievementTemplates.achievements
local PLACEHOLDER_ICON_2 = AchievementTemplateHelper.PLACEHOLDER_ICON
local add_console_achievements = AchievementTemplateHelper.add_console_achievements
local tbl = {
	trail_sleigher = 104,
	trail_shatterer = 102,
	trail_beacons_are_lit = 105,
	onions_complete_trail_legend = 106,
	trail_cog_strike = 103
}
local tbl_2 = {
	trail_beacons_are_lit = "087"
}
local tbl_3 = {}
local tbl_4 = {
	LevelSettings.dlc_wizards_trail
}
local tbl_5 = {
	"normal",
	"hard",
	"harder",
	"hardest",
	"cataclysm"
}

for i = 1, #tbl_5 do
	local var_0_12 = tbl_5[i]
	local var_0_13 = DifficultyMapping[var_0_12]
	local str = "onions_complete_trail_" .. var_0_13

	tbl_3[i] = str

	add_levels_complete_challenge(achievements, str, tbl_4, DifficultySettings[var_0_12].rank, "achievement_wizards_trail_complete_" .. var_0_13, nil, tbl[str], tbl_2[str])
end

achievements.trail_cog_strike = {
	name = "achv_onions_cog_strike_name",
	display_completion_ui = true,
	icon = "achievement_wizards_trail_push_enemies_with_cog",
	desc = "achv_onions_cog_strike_desc",
	events = {
		"on_trail_cog_strike",
		"on_trail_cog_reset_stat"
	},
	completed = function (self, arg_1_1, arg_1_2)
		-- function 1
		return self:get_persistent_stat(arg_1_1, "trail_cog_strike") >= 1
	end,
	on_event = function (self, arg_2_1, arg_2_2, arg_2_3, arg_2_4)
		-- function 2
		if arg_2_3 == "on_trail_cog_strike" then
			if not (not arg_2_2.current_hits and arg_2_2.units) then
				arg_2_2.current_hits = 0
				arg_2_2.units = {}
			end

			local var_2_0 = arg_2_4[1]

			if not arg_2_2.units[var_2_0] then
				return
			end

			arg_2_2.units[var_2_0] = true
			arg_2_2.current_hits = arg_2_2.current_hits + 1

			if arg_2_2.current_hits >= 10 then
				self:increment_stat(arg_2_1, "trail_cog_strike")

				arg_2_2.current_hits = 0
			end
		elseif arg_2_3 == "on_trail_cog_reset_stat" then
			arg_2_2.current_hits = 0
			arg_2_2.units = {}
		end
	end
}
achievements.trail_shatterer = {
	name = "achv_onions_icicles_name",
	display_completion_ui = true,
	icon = "achievement_wizards_trail_break_icicles",
	desc = "achv_onions_icicles_desc",
	completed = function (self, arg_3_1, arg_3_2)
		-- function 3
		return self:get_persistent_stat(arg_3_1, "trail_shatterer") >= 1
	end
}
achievements.trail_sleigher = {
	name = "achv_onions_sleigh_kills_name",
	display_completion_ui = true,
	icon = "achievement_wizards_trail_kill_enemies_with_sleigh",
	desc = "achv_onions_sleigh_kills_desc",
	progress = function (self, arg_4_1, arg_4_2)
		-- function 4
		local get_persistent_stat = self:get_persistent_stat(arg_4_1, "trail_sleigher")

		get_persistent_stat = get_persistent_stat or 0

		return {
			get_persistent_stat,
			50
		}
	end,
	completed = function (self, arg_5_1, arg_5_2)
		-- function 5
		return self:get_persistent_stat(arg_5_1, "trail_sleigher") >= 50
	end
}
achievements.trail_beacons_are_lit = {
	name = "achv_onions_light_beacons_name",
	display_completion_ui = true,
	icon = "achievement_wizards_trail_light_bonfires",
	desc = "achv_onions_light_beacons_desc",
	progress = function (self, arg_6_1, arg_6_2)
		-- function 6
		local get_persistent_stat = self:get_persistent_stat(arg_6_1, "trail_bonfire_watch_tower")

		get_persistent_stat = get_persistent_stat or 0

		local get_persistent_stat_2 = self:get_persistent_stat(arg_6_1, "trail_bonfire_river_path")

		get_persistent_stat_2 = get_persistent_stat_2 or 0

		local get_persistent_stat_3 = self:get_persistent_stat(arg_6_1, "trail_bonfire_lookout_point")

		get_persistent_stat_3 = get_persistent_stat_3 or 0

		if get_persistent_stat > 1 then
			get_persistent_stat = 1
		end

		if get_persistent_stat_2 > 1 then
			get_persistent_stat_2 = 1
		end

		if get_persistent_stat_3 > 1 then
			get_persistent_stat_3 = 1
		end

		local num = 0
		local num_2 = get_persistent_stat + get_persistent_stat_2 + get_persistent_stat_3

		return {
			num_2,
			3
		}
	end,
	completed = function (self, arg_7_1, arg_7_2)
		-- function 7
		local get_persistent_stat = self:get_persistent_stat(arg_7_1, "trail_bonfire_watch_tower")
		local get_persistent_stat_2 = self:get_persistent_stat(arg_7_1, "trail_bonfire_river_path")
		local get_persistent_stat_3 = self:get_persistent_stat(arg_7_1, "trail_bonfire_lookout_point")

		if not (not (get_persistent_stat >= 1) or not (get_persistent_stat_2 >= 1) or not (get_persistent_stat_3 >= 1)) then
			return true
		end
	end
}
all_trail_challenges = table.clone(tbl_3)

table.remove(all_trail_challenges, #all_trail_challenges)

all_trail_challenges[#all_trail_challenges + 1] = "trail_cog_strike"
all_trail_challenges[#all_trail_challenges + 1] = "trail_shatterer"
all_trail_challenges[#all_trail_challenges + 1] = "trail_sleigher"
all_trail_challenges[#all_trail_challenges + 1] = "trail_beacons_are_lit"

add_meta_challenge(achievements, "onions_complete_all", all_trail_challenges, "achievement_wizards_trail_complete_all_challenges", nil, tbl[name], tbl_2[name])
add_console_achievements(tbl, tbl_2)
