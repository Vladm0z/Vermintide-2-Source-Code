-- chunkname: @scripts/managers/backend/statistics_definitions_lake.lua

local player = StatisticsDefinitions.player
local tbl = {
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

player.weapon_kills_per_breed.markus_questingknight_career_skill_weapon = {}

for k, v in pairs(Breeds) do
	player.weapon_kills_per_breed.markus_questingknight_career_skill_weapon[k] = {
		value = 0,
		source = "player_data",
		database_name = k
	}
end

for k_2 = 1, #tbl do
	local var_0_2 = tbl[k_2]

	player[var_0_2] = {
		value = 0,
		source = "player_data",
		database_name = var_0_2
	}
end

local tbl_2 = {
	es_questingknight = true
}

for k_3, v_2 in pairs(CareerSettings) do
	if not tbl_2[k_3] then
		player.mission_streak[k_3] = {}

		for k_4, v_3 in pairs(LevelSettings) do
			if not table.contains(UnlockableLevels, k_4) then
				local str = "mission_streak_" .. k_3 .. "_" .. k_4

				player.mission_streak[k_3][k_4] = {
					value = 0,
					source = "player_data",
					database_name = str
				}
			end
		end
	end
end
