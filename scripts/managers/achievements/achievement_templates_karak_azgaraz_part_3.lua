-- chunkname: @scripts/managers/achievements/achievement_templates_karak_azgaraz_part_3.lua

local add_event_challenge = AchievementTemplateHelper.add_event_challenge
local add_levels_complete_challenge = AchievementTemplateHelper.add_levels_complete_challenge
local add_meta_challenge = AchievementTemplateHelper.add_meta_challenge
local achievements = AchievementTemplates.achievements
local add_console_achievements = AchievementTemplateHelper.add_console_achievements
local tbl = {
	karak_azgaraz_complete_dlc_dwarf_beacons_legend = 121,
	dwarf_big_jump = 118,
	dwarf_pressure_pad = 114,
	dwarf_crows = 115
}
local tbl_2 = {
	dwarf_crows = "091"
}
local tbl_3 = {}
local tbl_4 = {
	LevelSettings.dlc_dwarf_beacons
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
	local var_0_11 = tbl_5[i]
	local str = "karak_azgaraz_complete_dlc_dwarf_beacons_" .. tbl_6[var_0_11]
	local str_2 = "achievement_beacons_" .. tbl_6[var_0_11]

	tbl_3[i] = str

	add_levels_complete_challenge(achievements, str, tbl_4, DifficultySettings[var_0_11].rank, str_2, nil, tbl[str], tbl_2[str])
end

achievements.dwarf_pressure_pad = {
	name = "achv_dwarf_pressure_pad_name",
	display_completion_ui = true,
	icon = "achievement_dwarf_pressure_pad",
	desc = "achv_dwarf_pressure_pad_desc",
	events = {
		"dwarf_pressure_pad"
	},
	completed = function (self, arg_1_1, arg_1_2)
		-- function 1
		return self:get_persistent_stat(arg_1_1, "dwarf_pressure_pad") >= 1
	end,
	on_event = function (self, arg_2_1, arg_2_2, arg_2_3, arg_2_4)
		-- function 2
		local var_2_0 = arg_2_4[1]
		local var_2_1 = arg_2_4[2]
		local var_2_2 = arg_2_4[3]

		if var_2_2 or Managers.player:unit_owner(var_2_0).bot_player or not arg_2_2.challenge_over then
			return
		end

		if not arg_2_2.num_on_pad then
			arg_2_2.num_on_pad = 0
		end

		if not (not var_2_2 and not arg_2_2.num_on_pad and not (arg_2_2.num_on_pad >= 1)) then
			self:increment_stat(arg_2_1, "dwarf_pressure_pad")

			arg_2_2.challenge_over = true
		elseif not var_2_1 then
			arg_2_2.num_on_pad = arg_2_2.num_on_pad + 1
		else
			arg_2_2.num_on_pad = arg_2_2.num_on_pad - 1

			if arg_2_2.num_on_pad < 1 then
				arg_2_2.challenge_over = true
			end
		end
	end
}
achievements.dwarf_big_jump = {
	name = "achv_dwarf_big_jump_name",
	display_completion_ui = true,
	icon = "achievement_dwarf_big_jump",
	desc = "achv_dwarf_big_jump_desc",
	events = {
		"dwarf_big_jump"
	},
	completed = function (self, arg_3_1, arg_3_2)
		-- function 3
		return self:get_persistent_stat(arg_3_1, "dwarf_big_jump") >= 1
	end,
	on_event = function (self, arg_4_1, arg_4_2, arg_4_3, arg_4_4)
		-- function 4
		local var_4_0 = arg_4_4[1]
		local time = Managers.time:time("game")

		if not (not var_4_0 and not arg_4_2.exit_t and not (time < arg_4_2.exit_t)) then
			self:increment_stat(arg_4_1, "dwarf_big_jump")
		elseif not var_4_0 then
			arg_4_2.exit_t = time + 4
		end
	end
}
achievements.dwarf_crows = {
	name = "achv_dwarf_crows_name",
	display_completion_ui = true,
	icon = "achievement_dwarf_crows",
	desc = "achv_dwarf_crows_desc",
	events = {
		"dwarf_crows"
	},
	completed = function (self, arg_5_1, arg_5_2)
		-- function 5
		return self:get_persistent_stat(arg_5_1, "dwarf_crows") >= 1
	end,
	on_event = function (self, arg_6_1, arg_6_2, arg_6_3, arg_6_4)
		-- function 6
		self:increment_stat(arg_6_1, "dwarf_crows")
	end
}
achievements.dwarf_speedrun = {
	name = "achv_dwarf_speedrun_name",
	display_completion_ui = true,
	icon = "achievement_dwarf_speedrun",
	desc = "achv_dwarf_speedrun_desc",
	events = {
		"dwarf_speedrun_start",
		"dwarf_speedrun_end"
	},
	completed = function (self, arg_7_1, arg_7_2)
		-- function 7
		return self:get_persistent_stat(arg_7_1, "dwarf_speedrun") >= 1
	end,
	on_event = function (self, arg_8_1, arg_8_2, arg_8_3, arg_8_4)
		-- function 8
		if arg_8_3 == "dwarf_speedrun_start" then
			arg_8_2.started = true

			return
		end

		if arg_8_3 ~= "dwarf_speedrun_end" or not arg_8_2.started then
			self:increment_stat(arg_8_1, "dwarf_speedrun")
		end
	end
}
beacons_all_challenges = table.clone(tbl_3)

table.remove(beacons_all_challenges, #beacons_all_challenges)

beacons_all_challenges[#beacons_all_challenges + 1] = "dwarf_pressure_pad"
beacons_all_challenges[#beacons_all_challenges + 1] = "dwarf_big_jump"
beacons_all_challenges[#beacons_all_challenges + 1] = "dwarf_crows"
beacons_all_challenges[#beacons_all_challenges + 1] = "dwarf_speedrun"

add_meta_challenge(achievements, "beacons_all_challenges", beacons_all_challenges, "achievement_beacons_meta", nil, tbl[name], tbl_2[name])
add_console_achievements(tbl, tbl_2)
