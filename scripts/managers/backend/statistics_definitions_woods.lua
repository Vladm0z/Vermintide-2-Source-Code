-- chunkname: @scripts/managers/backend/statistics_definitions_woods.lua

local var_0_0 = StatisticsDefinitions.player
local var_0_1 = {
	"complete_all_helmgart_levels_recruit_we_thornsister",
	"complete_all_helmgart_levels_veteran_we_thornsister",
	"complete_all_helmgart_levels_champion_we_thornsister",
	"complete_all_helmgart_levels_legend_we_thornsister",
	"woods_complete_100_missions_we_thornsister",
	"woods_javelin_melee_kills",
	"woods_lift_kills",
	"woods_javelin_combo",
	"woods_triple_lift",
	"woods_heal_grind",
	"woods_amount_healed",
	"woods_wall_kill_grind",
	"woods_wall_kill",
	"woods_bleed_grind",
	"woods_bleed_tics",
	"woods_chaos_pinata",
	"woods_bleed_boss",
	"woods_wall_kill_gutter",
	"woods_ability_combo",
	"woods_wall_tank",
	"woods_wall_hits_soaked",
	"woods_wall_block_ratling",
	"woods_ratling_shots_soaked",
	"woods_wall_dual_save",
	"woods_free_ability_grind",
	"woods_free_abilities_used"
}

for iter_0_0 = 1, #var_0_1 do
	local var_0_2 = var_0_1[iter_0_0]

	var_0_0[var_0_2] = {
		value = 0,
		source = "player_data",
		database_name = var_0_2
	}
end

local var_0_3 = {
	we_thornsister = true
}

for iter_0_1, iter_0_2 in pairs(CareerSettings) do
	if var_0_3[iter_0_1] then
		var_0_0.mission_streak[iter_0_1] = {}

		for iter_0_3, iter_0_4 in pairs(LevelSettings) do
			if table.contains(UnlockableLevels, iter_0_3) then
				local var_0_4 = "mission_streak_" .. iter_0_1 .. "_" .. iter_0_3

				var_0_0.mission_streak[iter_0_1][iter_0_3] = {
					value = 0,
					source = "player_data",
					database_name = var_0_4
				}
			end
		end
	end
end
