-- chunkname: @scripts/managers/achievements/achievement_templates_wizards_part_2.lua

local var_0_0 = AchievementTemplateHelper.add_event_challenge
local var_0_1 = AchievementTemplateHelper.add_levels_complete_challenge
local var_0_2 = AchievementTemplateHelper.add_meta_challenge
local var_0_3 = AchievementTemplateHelper.PLACEHOLDER_ICON
local var_0_4 = AchievementTemplates.achievements
local var_0_5 = AchievementTemplateHelper.add_console_achievements
local var_0_6 = {
	tower_hardest = 111,
	tower_wall_illusions = 108,
	tower_note_puzzle = 110,
	tower_skulls = 107,
	tower_created_all_potions = 109
}
local var_0_7 = {
	tower_skulls = "088",
	tower_wall_illusions = "089"
}
local var_0_8 = {}
local var_0_9 = {
	LevelSettings.dlc_wizards_tower
}
local var_0_10 = {
	"normal",
	"hard",
	"harder",
	"hardest",
	"cataclysm"
}
local var_0_11 = {
	hardest = "legend",
	hard = "veteran",
	harder = "champion",
	cataclysm = "cataclysm",
	normal = "recruit"
}

for iter_0_0 = 1, #var_0_10 do
	local var_0_12 = Difficulties[iter_0_0]
	local var_0_13 = "tower_" .. var_0_12
	local var_0_14 = "achievement_wizards_tower_" .. var_0_11[var_0_12]

	var_0_8[iter_0_0] = var_0_13

	var_0_1(var_0_4, var_0_13, var_0_9, DifficultySettings[var_0_12].rank, var_0_14, nil, var_0_6[var_0_13], var_0_7[var_0_13])
end

var_0_4.tower_skulls = {
	name = "achv_tower_skulls_name",
	display_completion_ui = true,
	icon = "achievement_wizards_tower_skulls",
	desc = "achv_tower_skulls_desc",
	events = {
		"on_tower_skull_found"
	},
	completed = function (arg_1_0, arg_1_1, arg_1_2)
		return arg_1_0:get_persistent_stat(arg_1_1, "tower_skulls") >= 1
	end,
	on_event = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4)
		if arg_2_2.num_skulls then
			arg_2_2.num_skulls = arg_2_2.num_skulls + 1
		else
			arg_2_2.num_skulls = 1
		end

		if arg_2_2.num_skulls == 10 then
			arg_2_0:increment_stat(arg_2_1, "tower_skulls")
		end
	end
}
var_0_4.tower_wall_illusions = {
	name = "achv_tower_wall_illusions_name",
	display_completion_ui = true,
	icon = "achievement_wizards_tower_wall_illusions",
	desc = "achv_tower_wall_illusions_desc",
	events = {
		"tower_wall_illusion_found"
	},
	completed = function (arg_3_0, arg_3_1, arg_3_2)
		return arg_3_0:get_persistent_stat(arg_3_1, "tower_wall_illusions") >= 1
	end,
	on_event = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4)
		local var_4_0 = arg_4_4[1]

		if arg_4_2[var_4_0] then
			return
		end

		arg_4_2[var_4_0] = true

		if not arg_4_2.num_illusions_found then
			arg_4_2.num_illusions_found = 1
		else
			arg_4_2.num_illusions_found = arg_4_2.num_illusions_found + 1
		end

		if arg_4_2.num_illusions_found == 4 then
			arg_4_0:increment_stat(arg_4_1, "tower_wall_illusions")
		end

		print("wall illusion found " .. var_4_0)
	end
}
var_0_4.tower_invisible_bridge = {
	name = "achv_tower_invisible_bridge_name",
	display_completion_ui = true,
	icon = "achievement_wizards_tower_invisible_bridge",
	desc = "achv_tower_invisible_bridge_desc",
	events = {
		"update_tower_invisible_bridge_challenge"
	},
	completed = function (arg_5_0, arg_5_1, arg_5_2)
		return arg_5_0:get_persistent_stat(arg_5_1, "tower_invisible_bridge") >= 1
	end,
	on_event = function (arg_6_0, arg_6_1, arg_6_2, arg_6_3, arg_6_4)
		if arg_6_2.done then
			return
		end

		if arg_6_4[1] == true then
			arg_6_0:increment_stat(arg_6_1, "tower_invisible_bridge")
		end

		arg_6_2.done = true
	end
}
var_0_4.tower_enable_guardian_of_lustria = {
	name = "achv_tower_guardian_of_lustria_name",
	display_completion_ui = true,
	icon = "achievement_wizards_tower_guardian_of_lustria",
	desc = "achv_tower_guardian_of_lustria_desc",
	events = {
		"tower_enable_guardian_of_lustria"
	},
	completed = function (arg_7_0, arg_7_1, arg_7_2)
		return arg_7_0:get_persistent_stat(arg_7_1, "tower_enable_guardian_of_lustria") >= 1
	end,
	on_event = function (arg_8_0, arg_8_1, arg_8_2, arg_8_3, arg_8_4)
		arg_8_0:increment_stat(arg_8_1, "tower_enable_guardian_of_lustria")
	end
}
var_0_4.tower_note_puzzle = {
	name = "achv_tower_note_puzzle_name",
	display_completion_ui = true,
	icon = "achievement_wizards_tower_note_puzzle",
	desc = "achv_tower_note_puzzle_desc",
	events = {
		"tower_note_puzzle"
	},
	completed = function (arg_9_0, arg_9_1, arg_9_2)
		return arg_9_0:get_persistent_stat(arg_9_1, "tower_note_puzzle") >= 1
	end,
	on_event = function (arg_10_0, arg_10_1, arg_10_2, arg_10_3, arg_10_4)
		arg_10_0:increment_stat(arg_10_1, "tower_note_puzzle")
	end
}
var_0_4.tower_created_all_potions = {
	name = "achv_tower_created_all_potions_name",
	display_completion_ui = true,
	icon = "achievement_wizards_tower_created_all_potions",
	desc = "achv_tower_created_all_potions_desc",
	events = {
		"tower_potion_created"
	},
	completed = function (arg_11_0, arg_11_1, arg_11_2)
		return arg_11_0:get_persistent_stat(arg_11_1, "tower_created_all_potions") >= 1
	end,
	on_event = function (arg_12_0, arg_12_1, arg_12_2, arg_12_3, arg_12_4)
		if arg_12_2.done then
			return
		end

		arg_12_2[arg_12_4[1]] = true

		if arg_12_2.hp and arg_12_2.sp and arg_12_2.cr and arg_12_2.db then
			arg_12_0:increment_stat(arg_12_1, "tower_created_all_potions")

			arg_12_2.done = true
		end
	end
}

local var_0_15 = IS_WINDOWS and 12 or 13

var_0_4.tower_time_challenge = {
	name = "achv_tower_time_challenge_name",
	display_completion_ui = true,
	icon = "achievement_wizards_tower_time_challenge",
	desc = function ()
		return string.format(Localize("achv_tower_time_challenge_desc"), var_0_15)
	end,
	events = {
		"gameplay_start",
		"register_completed_level"
	},
	completed = function (arg_14_0, arg_14_1, arg_14_2)
		return arg_14_0:get_persistent_stat(arg_14_1, "tower_time_challenge") >= 1
	end,
	on_event = function (arg_15_0, arg_15_1, arg_15_2, arg_15_3, arg_15_4)
		local var_15_0 = Managers.time:time("game")

		if arg_15_3 == "gameplay_start" then
			arg_15_2.start_t = var_15_0

			return
		end

		local var_15_1 = arg_15_2.start_t

		if not var_15_1 then
			print("[Challenge] Speedrun invalidated. Likely due to hot-join.")

			return
		end

		local var_15_2, var_15_3, var_15_4, var_15_5 = unpack(arg_15_4)

		if var_15_3 == "dlc_wizards_tower" and var_0_15 * 60 > var_15_0 - var_15_1 then
			arg_15_0:increment_stat(arg_15_1, "tower_time_challenge")
		end
	end
}
all_wizards_challenges = table.clone(var_0_8)

table.remove(all_wizards_challenges, #all_wizards_challenges)

all_wizards_challenges[#all_wizards_challenges + 1] = "tower_skulls"
all_wizards_challenges[#all_wizards_challenges + 1] = "tower_wall_illusions"
all_wizards_challenges[#all_wizards_challenges + 1] = "tower_invisible_bridge"
all_wizards_challenges[#all_wizards_challenges + 1] = "tower_enable_guardian_of_lustria"
all_wizards_challenges[#all_wizards_challenges + 1] = "tower_note_puzzle"
all_wizards_challenges[#all_wizards_challenges + 1] = "tower_created_all_potions"
all_wizards_challenges[#all_wizards_challenges + 1] = "tower_time_challenge"

var_0_2(var_0_4, "tower_all_challenges", all_wizards_challenges, "achievement_wizards_tower_all_challenges", nil, var_0_6[name], var_0_7[name])
var_0_5(var_0_6, var_0_7)
