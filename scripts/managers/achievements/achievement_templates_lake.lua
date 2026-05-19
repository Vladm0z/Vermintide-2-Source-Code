-- chunkname: @scripts/managers/achievements/achievement_templates_lake.lua

local var_0_0 = AchievementTemplateHelper.add_event_challenge
local var_0_1 = AchievementTemplateHelper.add_levels_complete_challenge
local var_0_2 = AchievementTemplateHelper.add_levels_complete_per_hero_challenge
local var_0_3 = AchievementTemplateHelper.add_levels_streak_per_hero_challenge
local var_0_4 = AchievementTemplateHelper.add_career_mission_count_challenge
local var_0_5 = AchievementTemplateHelper.add_weapon_kills_per_breeds_challenge
local var_0_6 = AchievementTemplateHelper.add_meta_challenge
local var_0_7 = AchievementTemplateHelper.add_health_challenge
local var_0_8 = AchievementTemplateHelper.add_stat_count_challenge
local var_0_9 = AchievementTemplateHelper.PLACEHOLDER_ICON
local var_0_10 = AchievementTemplates.achievements
local var_0_11 = DLCSettings.lake
local var_0_12 = {}
local var_0_13 = {}
local var_0_14 = {
	"normal",
	"hard",
	"harder",
	"hardest",
	"cataclysm"
}
local var_0_15 = HelmgartLevels

var_0_0(var_0_10, "lake_charge_stagger", nil, nil, "lake_upgrade", var_0_12.lake_charge_stagger, var_0_13.lake_charge_stagger)
var_0_0(var_0_10, "lake_bastard_block", nil, nil, "lake_upgrade", var_0_12.lake_bastard_block, var_0_13.lake_bastard_block)
var_0_0(var_0_10, "lake_speed_quest", nil, {
	var_0_11.speed_quest_complete_time
}, "lake_upgrade", nil, nil)
var_0_0(var_0_10, "lake_timing_quest", nil, {
	var_0_11.timing_quest_complete_margain
}, "lake_upgrade", nil, nil)

local var_0_16 = {
	"harder",
	"hardest",
	"cataclysm"
}

var_0_4(var_0_10, "lake_complete_100_missions", "completed_career_levels", "es_questingknight", var_0_14, 100, nil, nil, "lake_upgrade", nil, nil)
var_0_7(var_0_10, "lake_untouchable", "es_questingknight", 0.9, nil, "lake_upgrade", nil, nil)

local var_0_17 = {}
local var_0_18 = {}

for iter_0_0, iter_0_1 in pairs(Breeds) do
	if Breeds[iter_0_0].elite == true then
		var_0_17[#var_0_17 + 1] = iter_0_0
	end

	if Breeds[iter_0_0].boss == true then
		var_0_18[#var_0_18 + 1] = iter_0_0
	end
end

var_0_10.lake_kill_register = {
	display_completion_ui = false,
	required_dlc = "lake_upgrade",
	events = {
		"register_kill"
	},
	completed = function(arg_1_0, arg_1_1, arg_1_2)
		local var_1_0 = 0

		for iter_1_0 = 1, #var_0_18 do
			var_1_0 = var_1_0 + arg_1_0:get_persistent_stat(arg_1_1, "weapon_kills_per_breed", "markus_questingknight_career_skill_weapon", var_0_18[iter_1_0])
		end

		return var_1_0 >= 5
	end,
	on_event = function(arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4)
		local var_2_0 = arg_2_4[3]
		local var_2_1 = var_2_0 and var_2_0[DamageDataIndex.ATTACKER]

		if not ALIVE[var_2_1] then
			return
		end

		local var_2_2 = Managers.player:local_player()
		local var_2_3 = var_2_2 and var_2_2.player_unit

		if not var_2_3 or var_2_3 ~= var_2_1 then
			return
		end

		local var_2_4 = ScriptUnit.has_extension(var_2_1, "career_system")

		if not var_2_4 or var_2_4:career_name() ~= "es_questingknight" then
			return false
		end

		local var_2_5 = var_2_0[DamageDataIndex.DAMAGE_SOURCE_NAME]

		if not var_2_5 or var_2_5 ~= "markus_questingknight_career_skill_weapon" then
			return false
		end

		local var_2_6 = arg_2_4[4]

		if not table.contains(var_0_18, var_2_6.name) then
			return false
		end

		if var_2_5 and var_2_6 and var_2_6.name then
			arg_2_0:increment_stat(arg_2_1, "weapon_kills_per_breed", var_2_5, var_2_6.name)
		end
	end
}

var_0_5(var_0_10, "lake_boss_killblow", {
	"markus_questingknight_career_skill_weapon"
}, var_0_18, 5, nil, "lake_upgrade", true, nil, nil)

local var_0_19 = GameActs.act_1
local var_0_20 = GameActs.act_2
local var_0_21 = GameActs.act_3
local var_0_22 = DifficultySettings.hardest.rank

var_0_2(var_0_10, "lake_mission_streak_act1_legend", var_0_19, var_0_22, "es_questingknight", true, nil, "lake_upgrade", var_0_12.lake_mission_streak_act1, var_0_13.lake_mission_streak_act1)
var_0_2(var_0_10, "lake_mission_streak_act2_legend", var_0_20, var_0_22, "es_questingknight", true, nil, "lake_upgrade", var_0_12.lake_mission_streak_act2, var_0_13.lake_mission_streak_act2)
var_0_2(var_0_10, "lake_mission_streak_act3_legend", var_0_21, var_0_22, "es_questingknight", true, nil, "lake_upgrade", var_0_12.lake_mission_streak_act3, var_0_13.lake_mission_streak_act3)

for iter_0_2 = 1, #var_0_14 do
	local var_0_23 = var_0_14[iter_0_2]
	local var_0_24 = "lake_complete_all_helmgart_levels_" .. DifficultyMapping[var_0_23]

	var_0_2(var_0_10, var_0_24, var_0_15, DifficultySettings[var_0_23].rank, "es_questingknight", false, nil, "lake_upgrade", var_0_12.complete_all_helmgart_levels, var_0_13.complete_all_helmgart_levels)
end

local var_0_25 = {
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

var_0_6(var_0_10, "complete_all_grailknight_challenges", var_0_25, nil, "lake_upgrade", nil, nil)

QuestSettings.track_bastard_block_breeds.hero_es_questingknight = true
QuestSettings.track_charge_stagger_breeds.es_questingknight = true
