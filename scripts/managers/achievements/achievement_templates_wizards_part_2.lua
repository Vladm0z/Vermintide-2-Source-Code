-- chunkname: @scripts/managers/achievements/achievement_templates_wizards_part_2.lua

local add_event_challenge = AchievementTemplateHelper.add_event_challenge
local add_levels_complete_challenge = AchievementTemplateHelper.add_levels_complete_challenge
local add_meta_challenge = AchievementTemplateHelper.add_meta_challenge
local PLACEHOLDER_ICON = AchievementTemplateHelper.PLACEHOLDER_ICON
local achievements = AchievementTemplates.achievements
local add_console_achievements = AchievementTemplateHelper.add_console_achievements
local tbl = {
	tower_hardest = 111,
	tower_wall_illusions = 108,
	tower_note_puzzle = 110,
	tower_skulls = 107,
	tower_created_all_potions = 109
}
local tbl_2 = {
	tower_skulls = "088",
	tower_wall_illusions = "089"
}
local tbl_3 = {}
local tbl_4 = {
	LevelSettings.dlc_wizards_tower
}
local tbl_5 = {
	"normal",
	"hard",
	"harder",
	"hardest",
	"cataclysm"
}
local tbl_6 = {
	hardest = "legend",
	hard = "veteran",
	harder = "champion",
	cataclysm = "cataclysm",
	normal = "recruit"
}

for i = 1, #tbl_5 do
	local var_0_12 = Difficulties[i]
	local str = "tower_" .. var_0_12
	local str_2 = "achievement_wizards_tower_" .. tbl_6[var_0_12]

	tbl_3[i] = str

	add_levels_complete_challenge(achievements, str, tbl_4, DifficultySettings[var_0_12].rank, str_2, nil, tbl[str], tbl_2[str])
end

achievements.tower_skulls = {
	name = "achv_tower_skulls_name",
	display_completion_ui = true,
	icon = "achievement_wizards_tower_skulls",
	desc = "achv_tower_skulls_desc",
	events = {
		"on_tower_skull_found"
	},
	completed = function (self, arg_1_1, arg_1_2)
		-- function 1
		return self:get_persistent_stat(arg_1_1, "tower_skulls") >= 1
	end,
	on_event = function (self, arg_2_1, arg_2_2, arg_2_3, arg_2_4)
		-- function 2
		if not arg_2_2.num_skulls then
			arg_2_2.num_skulls = arg_2_2.num_skulls + 1
		else
			arg_2_2.num_skulls = 1
		end

		if arg_2_2.num_skulls == 10 then
			self:increment_stat(arg_2_1, "tower_skulls")
		end
	end
}
achievements.tower_wall_illusions = {
	name = "achv_tower_wall_illusions_name",
	display_completion_ui = true,
	icon = "achievement_wizards_tower_wall_illusions",
	desc = "achv_tower_wall_illusions_desc",
	events = {
		"tower_wall_illusion_found"
	},
	completed = function (self, arg_3_1, arg_3_2)
		-- function 3
		return self:get_persistent_stat(arg_3_1, "tower_wall_illusions") >= 1
	end,
	on_event = function (self, arg_4_1, arg_4_2, arg_4_3, arg_4_4)
		-- function 4
		local var_4_0 = arg_4_4[1]

		if not arg_4_2[var_4_0] then
			return
		end

		arg_4_2[var_4_0] = true

		if not arg_4_2.num_illusions_found then
			arg_4_2.num_illusions_found = 1
		else
			arg_4_2.num_illusions_found = arg_4_2.num_illusions_found + 1
		end

		if arg_4_2.num_illusions_found == 4 then
			self:increment_stat(arg_4_1, "tower_wall_illusions")
		end

		print("wall illusion found " .. var_4_0)
	end
}
achievements.tower_invisible_bridge = {
	name = "achv_tower_invisible_bridge_name",
	display_completion_ui = true,
	icon = "achievement_wizards_tower_invisible_bridge",
	desc = "achv_tower_invisible_bridge_desc",
	events = {
		"update_tower_invisible_bridge_challenge"
	},
	completed = function (self, arg_5_1, arg_5_2)
		-- function 5
		return self:get_persistent_stat(arg_5_1, "tower_invisible_bridge") >= 1
	end,
	on_event = function (self, arg_6_1, arg_6_2, arg_6_3, arg_6_4)
		-- function 6
		if not arg_6_2.done then
			return
		end

		if arg_6_4[1] == true then
			self:increment_stat(arg_6_1, "tower_invisible_bridge")
		end

		arg_6_2.done = true
	end
}
achievements.tower_enable_guardian_of_lustria = {
	name = "achv_tower_guardian_of_lustria_name",
	display_completion_ui = true,
	icon = "achievement_wizards_tower_guardian_of_lustria",
	desc = "achv_tower_guardian_of_lustria_desc",
	events = {
		"tower_enable_guardian_of_lustria"
	},
	completed = function (self, arg_7_1, arg_7_2)
		-- function 7
		return self:get_persistent_stat(arg_7_1, "tower_enable_guardian_of_lustria") >= 1
	end,
	on_event = function (self, arg_8_1, arg_8_2, arg_8_3, arg_8_4)
		-- function 8
		self:increment_stat(arg_8_1, "tower_enable_guardian_of_lustria")
	end
}
achievements.tower_note_puzzle = {
	name = "achv_tower_note_puzzle_name",
	display_completion_ui = true,
	icon = "achievement_wizards_tower_note_puzzle",
	desc = "achv_tower_note_puzzle_desc",
	events = {
		"tower_note_puzzle"
	},
	completed = function (self, arg_9_1, arg_9_2)
		-- function 9
		return self:get_persistent_stat(arg_9_1, "tower_note_puzzle") >= 1
	end,
	on_event = function (self, arg_10_1, arg_10_2, arg_10_3, arg_10_4)
		-- function 10
		self:increment_stat(arg_10_1, "tower_note_puzzle")
	end
}
achievements.tower_created_all_potions = {
	name = "achv_tower_created_all_potions_name",
	display_completion_ui = true,
	icon = "achievement_wizards_tower_created_all_potions",
	desc = "achv_tower_created_all_potions_desc",
	events = {
		"tower_potion_created"
	},
	completed = function (self, arg_11_1, arg_11_2)
		-- function 11
		return self:get_persistent_stat(arg_11_1, "tower_created_all_potions") >= 1
	end,
	on_event = function (self, arg_12_1, arg_12_2, arg_12_3, arg_12_4)
		-- function 12
		if not arg_12_2.done then
			return
		end

		arg_12_2[arg_12_4[1]] = true

		if not arg_12_2.hp and not arg_12_2.sp and not arg_12_2.cr and not arg_12_2.db then
			self:increment_stat(arg_12_1, "tower_created_all_potions")

			arg_12_2.done = true
		end
	end
}

local flag

flag = not IS_WINDOWS and 12 and 13
achievements.tower_time_challenge = {
	name = "achv_tower_time_challenge_name",
	display_completion_ui = true,
	icon = "achievement_wizards_tower_time_challenge",
	desc = function ()
		-- function 13
		return string.format(Localize("achv_tower_time_challenge_desc"), flag)
	end,
	events = {
		"gameplay_start",
		"register_completed_level"
	},
	completed = function (self, arg_14_1, arg_14_2)
		-- function 14
		return self:get_persistent_stat(arg_14_1, "tower_time_challenge") >= 1
	end,
	on_event = function (self, arg_15_1, arg_15_2, arg_15_3, arg_15_4)
		-- function 15
		local time = Managers.time:time("game")

		if arg_15_3 == "gameplay_start" then
			arg_15_2.start_t = time

			return
		end

		local start_t = arg_15_2.start_t

		if not start_t then
			print("[Challenge] Speedrun invalidated. Likely due to hot-join.")

			return
		end

		local var_15_2, var_15_3, var_15_4, var_15_5 = unpack(arg_15_4)

		if not (var_15_3 ~= "dlc_wizards_tower" or not (flag * 60 > time - start_t)) then
			self:increment_stat(arg_15_1, "tower_time_challenge")
		end
	end
}
all_wizards_challenges = table.clone(tbl_3)

table.remove(all_wizards_challenges, #all_wizards_challenges)

all_wizards_challenges[#all_wizards_challenges + 1] = "tower_skulls"
all_wizards_challenges[#all_wizards_challenges + 1] = "tower_wall_illusions"
all_wizards_challenges[#all_wizards_challenges + 1] = "tower_invisible_bridge"
all_wizards_challenges[#all_wizards_challenges + 1] = "tower_enable_guardian_of_lustria"
all_wizards_challenges[#all_wizards_challenges + 1] = "tower_note_puzzle"
all_wizards_challenges[#all_wizards_challenges + 1] = "tower_created_all_potions"
all_wizards_challenges[#all_wizards_challenges + 1] = "tower_time_challenge"

add_meta_challenge(achievements, "tower_all_challenges", all_wizards_challenges, "achievement_wizards_tower_all_challenges", nil, tbl[name], tbl_2[name])
add_console_achievements(tbl, tbl_2)
