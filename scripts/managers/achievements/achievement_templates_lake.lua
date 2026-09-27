-- chunkname: @scripts/managers/achievements/achievement_templates_lake.lua

local add_event_challenge = AchievementTemplateHelper.add_event_challenge
local add_levels_complete_challenge = AchievementTemplateHelper.add_levels_complete_challenge
local add_levels_complete_per_hero_challenge = AchievementTemplateHelper.add_levels_complete_per_hero_challenge
local add_levels_streak_per_hero_challenge = AchievementTemplateHelper.add_levels_streak_per_hero_challenge
local add_career_mission_count_challenge = AchievementTemplateHelper.add_career_mission_count_challenge
local add_weapon_kills_per_breeds_challenge = AchievementTemplateHelper.add_weapon_kills_per_breeds_challenge
local add_meta_challenge = AchievementTemplateHelper.add_meta_challenge
local add_health_challenge = AchievementTemplateHelper.add_health_challenge
local add_stat_count_challenge = AchievementTemplateHelper.add_stat_count_challenge
local PLACEHOLDER_ICON = AchievementTemplateHelper.PLACEHOLDER_ICON
local achievements = AchievementTemplates.achievements
local lake = DLCSettings.lake
local tbl = {}
local tbl_2 = {}
local tbl_3 = {
	"normal",
	"hard",
	"harder",
	"hardest",
	"cataclysm"
}
local HelmgartLevels = HelmgartLevels

add_event_challenge(achievements, "lake_charge_stagger", nil, nil, "lake_upgrade", tbl.lake_charge_stagger, tbl_2.lake_charge_stagger)
add_event_challenge(achievements, "lake_bastard_block", nil, nil, "lake_upgrade", tbl.lake_bastard_block, tbl_2.lake_bastard_block)
add_event_challenge(achievements, "lake_speed_quest", nil, {
	lake.speed_quest_complete_time
}, "lake_upgrade", nil, nil)
add_event_challenge(achievements, "lake_timing_quest", nil, {
	lake.timing_quest_complete_margain
}, "lake_upgrade", nil, nil)

local tbl_4 = {
	"harder",
	"hardest",
	"cataclysm"
}

add_career_mission_count_challenge(achievements, "lake_complete_100_missions", "completed_career_levels", "es_questingknight", tbl_3, 100, nil, nil, "lake_upgrade", nil, nil)
add_health_challenge(achievements, "lake_untouchable", "es_questingknight", 0.9, nil, "lake_upgrade", nil, nil)

local tbl_5 = {}
local tbl_6 = {}

for k, v in pairs(Breeds) do
	if Breeds[k].elite == true then
		tbl_5[#tbl_5 + 1] = k
	end

	if Breeds[k].boss == true then
		tbl_6[#tbl_6 + 1] = k
	end
end

achievements.lake_kill_register = {
	display_completion_ui = false,
	required_dlc = "lake_upgrade",
	events = {
		"register_kill"
	},
	completed = function (self, arg_1_1, arg_1_2)
		-- function 1
		local num = 0

		for i = 1, #tbl_6 do
			num = num + self:get_persistent_stat(arg_1_1, "weapon_kills_per_breed", "markus_questingknight_career_skill_weapon", tbl_6[i])
		end

		return num >= 5
	end,
	on_event = function (self, arg_2_1, arg_2_2, arg_2_3, arg_2_4)
		-- function 2
		local var_2_0 = arg_2_4[3]
		local flag = not var_2_0 and var_2_0[DamageDataIndex.ATTACKER]

		if not ALIVE[flag] then
			return
		end

		local local_player = Managers.player:local_player()
		local flag_2 = not local_player and local_player.player_unit

		if not (not flag_2 and flag_2 == flag) then
			return
		end

		local has_extension = ScriptUnit.has_extension(flag, "career_system")

		if not (not has_extension and has_extension:career_name() == "es_questingknight") then
			return false
		end

		local var_2_5 = var_2_0[DamageDataIndex.DAMAGE_SOURCE_NAME]

		if not (not var_2_5 and var_2_5 == "markus_questingknight_career_skill_weapon") then
			return false
		end

		local var_2_6 = arg_2_4[4]

		if not table.contains(tbl_6, var_2_6.name) then
			return false
		end

		if not var_2_5 and not var_2_6 and not var_2_6.name then
			self:increment_stat(arg_2_1, "weapon_kills_per_breed", var_2_5, var_2_6.name)
		end
	end
}

add_weapon_kills_per_breeds_challenge(achievements, "lake_boss_killblow", {
	"markus_questingknight_career_skill_weapon"
}, tbl_6, 5, nil, "lake_upgrade", true, nil, nil)

local act_1 = GameActs.act_1
local act_2 = GameActs.act_2
local act_3 = GameActs.act_3
local rank = DifficultySettings.hardest.rank

add_levels_complete_per_hero_challenge(achievements, "lake_mission_streak_act1_legend", act_1, rank, "es_questingknight", true, nil, "lake_upgrade", tbl.lake_mission_streak_act1, tbl_2.lake_mission_streak_act1)
add_levels_complete_per_hero_challenge(achievements, "lake_mission_streak_act2_legend", act_2, rank, "es_questingknight", true, nil, "lake_upgrade", tbl.lake_mission_streak_act2, tbl_2.lake_mission_streak_act2)
add_levels_complete_per_hero_challenge(achievements, "lake_mission_streak_act3_legend", act_3, rank, "es_questingknight", true, nil, "lake_upgrade", tbl.lake_mission_streak_act3, tbl_2.lake_mission_streak_act3)

for k_2 = 1, #tbl_3 do
	local var_0_23 = tbl_3[k_2]
	local str = "lake_complete_all_helmgart_levels_" .. DifficultyMapping[var_0_23]

	add_levels_complete_per_hero_challenge(achievements, str, HelmgartLevels, DifficultySettings[var_0_23].rank, "es_questingknight", false, nil, "lake_upgrade", tbl.complete_all_helmgart_levels, tbl_2.complete_all_helmgart_levels)
end

local tbl_7 = {
	"lake_complete_all_helmgart_levels_recruit_es_questingknight",
	"lake_complete_all_helmgart_levels_veteran_es_questingknight",
	"lake_complete_all_helmgart_levels_champion_es_questingknight",
	"lake_complete_all_helmgart_levels_legend_es_questingknight",
	"lake_complete_100_missions_es_questingknight",
	"lake_mission_streak_act1_legend_es_questingknight",
	"lake_mission_streak_act2_legend_es_questingknight",
	"lake_mission_streak_act3_legend_es_questingknight",
	"lake_boss_killblow",
	"lake_charge_stagger",
	"lake_bastard_block",
	"lake_untouchable",
	"lake_speed_quest",
	"lake_timing_quest"
}

add_meta_challenge(achievements, "complete_all_grailknight_challenges", tbl_7, nil, "lake_upgrade", nil, nil)

QuestSettings.track_bastard_block_breeds.hero_es_questingknight = true
QuestSettings.track_charge_stagger_breeds.es_questingknight = true
