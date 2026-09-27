-- chunkname: @scripts/managers/achievements/achievement_templates_karak_azgaraz_part_4.lua

local add_event_challenge = AchievementTemplateHelper.add_event_challenge
local add_levels_complete_challenge = AchievementTemplateHelper.add_levels_complete_challenge
local add_meta_challenge = AchievementTemplateHelper.add_meta_challenge
local achievements = AchievementTemplates.achievements
local add_console_achievements = AchievementTemplateHelper.add_console_achievements
local tbl = {}
local tbl_2 = {}
local tbl_3 = {}
local tbl_4 = {
	LevelSettings.dlc_dwarf_whaling
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
	local str = "karak_azgaraz_complete_dlc_dwarf_whaling_" .. tbl_6[var_0_11]
	local str_2 = "achievement_dwarf_" .. tbl_6[var_0_11]

	tbl_3[i] = str

	add_levels_complete_challenge(achievements, str, tbl_4, DifficultySettings[var_0_11].rank, str_2, nil, tbl[str], tbl_2[str])
end

achievements.dwarf_feculent_buboes = {
	name = "achv_dwarf_feculent_buboes_name",
	display_completion_ui = true,
	icon = "achievement_dwarf_feculent_buboes",
	desc = "achv_dwarf_feculent_buboes_desc",
	events = {
		"dwarf_feculent_buboes"
	},
	completed = function (self, arg_1_1, arg_1_2)
		-- function 1
		return self:get_persistent_stat(arg_1_1, "dwarf_feculent_buboes") >= 1
	end,
	on_event = function (self, arg_2_1, arg_2_2, arg_2_3, arg_2_4)
		-- function 2
		self:increment_stat(arg_2_1, "dwarf_feculent_buboes")
	end
}
achievements.dwarf_statue_emote = {
	name = "achv_dwarf_statue_emote_name",
	display_completion_ui = true,
	icon = "achievement_dwarf_statue_emote",
	desc = "achv_dwarf_statue_emote_desc",
	events = {
		"dwarf_statue_emote"
	},
	completed = function (self, arg_3_1, arg_3_2)
		-- function 3
		return self:get_persistent_stat(arg_3_1, "dwarf_statue_emote") >= 1
	end,
	on_event = function (self, arg_4_1, arg_4_2, arg_4_3, arg_4_4)
		-- function 4
		if not arg_4_4[1] then
			arg_4_2.end_t = nil

			return
		end

		local local_player = Managers.player:local_player()
		local flag = not local_player and local_player.player_unit

		if not flag then
			return
		end

		local state_machine = ScriptUnit.extension(flag, "character_state_machine_system").state_machine
		local flag_2 = not state_machine and state_machine.state_current

		if not (not flag_2 and flag_2.name == "emote") then
			arg_4_2.end_t = nil

			return
		end

		self:increment_stat(arg_4_1, "dwarf_statue_emote")
	end
}
achievements.dwarf_go_fish = {
	name = "achv_dwarf_go_fish_name",
	display_completion_ui = true,
	icon = "achievement_dwarf_go_fish",
	desc = "achv_dwarf_go_fish_desc",
	events = {
		"dwarf_go_fish"
	},
	completed = function (self, arg_5_1, arg_5_2)
		-- function 5
		return self:get_persistent_stat(arg_5_1, "dwarf_go_fish") >= 1
	end,
	on_event = function (self, arg_6_1, arg_6_2, arg_6_3, arg_6_4)
		-- function 6
		self:increment_stat(arg_6_1, "dwarf_go_fish")
	end
}

local num = 75

achievements.dwarf_barrel_kill = {
	name = "achv_dwarf_barrel_kill_name",
	display_completion_ui = true,
	icon = "achievement_dwarf_barrel_kill",
	desc = "achv_dwarf_barrel_kill_desc",
	events = {
		"register_kill"
	},
	completed = function (self, arg_7_1, arg_7_2)
		-- function 7
		return self:get_persistent_stat(arg_7_1, "dwarf_barrel_kill") >= 1
	end,
	on_event = function (self, arg_8_1, arg_8_2, arg_8_3, arg_8_4)
		-- function 8
		local level_key = Managers.state.game_mode:level_key()

		if not (not level_key and level_key == "dlc_dwarf_whaling") then
			return
		end

		if not arg_8_2.current_kills then
			arg_8_2.current_kills = 0
		end

		if arg_8_4[3][7] == "lamp_oil_fire" then
			arg_8_2.current_kills = arg_8_2.current_kills + 1
		end

		if arg_8_2.current_kills >= num then
			self:increment_stat(arg_8_1, "dwarf_barrel_kill")
		end
	end
}
achievements.dwarf_elevator_speedrun = {
	name = "achv_dwarf_elevator_speedrun_name",
	display_completion_ui = true,
	icon = "achievement_dwarf_elevator_speedrun",
	desc = "achv_dwarf_elevator_speedrun_desc",
	events = {
		"dwarf_elevator_speedrun"
	},
	completed = function (self, arg_9_1, arg_9_2)
		-- function 9
		return self:get_persistent_stat(arg_9_1, "dwarf_elevator_speedrun") >= 1
	end,
	on_event = function (self, arg_10_1, arg_10_2, arg_10_3, arg_10_4)
		-- function 10
		self:increment_stat(arg_10_1, "dwarf_elevator_speedrun")
	end
}
whaling_all_challenges = table.clone(tbl_3)

table.remove(whaling_all_challenges, #whaling_all_challenges)

whaling_all_challenges[#whaling_all_challenges + 1] = "dwarf_feculent_buboes"
whaling_all_challenges[#whaling_all_challenges + 1] = "dwarf_statue_emote"
whaling_all_challenges[#whaling_all_challenges + 1] = "dwarf_go_fish"
whaling_all_challenges[#whaling_all_challenges + 1] = "dwarf_barrel_kill"
whaling_all_challenges[#whaling_all_challenges + 1] = "dwarf_elevator_speedrun"

add_meta_challenge(achievements, "whaling_all_challenges", whaling_all_challenges, "achievement_dwarf_meta", nil, nil, nil)
