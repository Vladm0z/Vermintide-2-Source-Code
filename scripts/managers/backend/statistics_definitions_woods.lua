-- chunkname: @scripts/managers/backend/statistics_definitions_woods.lua

local player = StatisticsDefinitions.player
local tbl = {
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

for i = 1, #tbl do
	local var_0_2 = tbl[i]

	player[var_0_2] = {
		value = 0,
		source = "player_data",
		database_name = var_0_2
	}
end

local tbl_2 = {
	we_thornsister = true
}

for k, v in pairs(CareerSettings) do
	if not tbl_2[k] then
		player.mission_streak[k] = {}

		for k_2, v_2 in pairs(LevelSettings) do
			if not table.contains(UnlockableLevels, k_2) then
				local str = "mission_streak_" .. k .. "_" .. k_2

				player.mission_streak[k][k_2] = {
					value = 0,
					source = "player_data",
					database_name = str
				}
			end
		end
	end
end
