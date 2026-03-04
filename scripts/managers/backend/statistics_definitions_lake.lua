-- chunkname: @scripts/managers/backend/statistics_definitions_lake.lua

local var_0_0 = StatisticsDefinitions.player
local var_0_1 = {
	"complete_all_helmgart_levels_recruit_es_questingknight",
	"complete_all_helmgart_levels_veteran_es_questingknight",
	"complete_all_helmgart_levels_champion_es_questingknight",
	"complete_all_helmgart_levels_legend_es_questingknight",
	"lake_complete_100_missions_es_questingknight",
	"lake_boss_killblow",
	"lake_untouchable",
	"lake_charge_stagger",
	"lake_bastard_block",
	"lake_speed_quest",
	"lake_timing_quest",
	"complete_all_grailknight_challenges"
}

var_0_0.weapon_kills_per_breed.markus_questingknight_career_skill_weapon = {}

for iter_0_0, iter_0_1 in pairs(Breeds) do
	var_0_0.weapon_kills_per_breed.markus_questingknight_career_skill_weapon[iter_0_0] = {
		value = 0,
		source = "player_data",
		database_name = iter_0_0
	}
end

for iter_0_2 = 1, #var_0_1 do
	local var_0_2 = var_0_1[iter_0_2]

	var_0_0[var_0_2] = {
		value = 0,
		source = "player_data",
		database_name = var_0_2
	}
end

local var_0_3 = {
	es_questingknight = true
}

for iter_0_3, iter_0_4 in pairs(CareerSettings) do
	if var_0_3[iter_0_3] then
		var_0_0.mission_streak[iter_0_3] = {}

		for iter_0_5, iter_0_6 in pairs(LevelSettings) do
			if table.contains(UnlockableLevels, iter_0_5) then
				local var_0_4 = "mission_streak_" .. iter_0_3 .. "_" .. iter_0_5

				var_0_0.mission_streak[iter_0_3][iter_0_5] = {
					value = 0,
					source = "player_data",
					database_name = var_0_4
				}
			end
		end
	end
end
