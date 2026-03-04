-- chunkname: @scripts/managers/backend/statistics_definitions_cog.lua

local var_0_0 = StatisticsDefinitions.player

var_0_0.cog_kills_bardin_engineer_career_skill_weapon = {
	value = 0,
	database_name = "cog_kills_bardin_engineer_career_skill_weapon",
	source = "player_data"
}
var_0_0.cog_kills_bardin_engineer_career_skill_weapon_heavy = {
	value = 0,
	database_name = "cog_kills_bardin_engineer_career_skill_weapon_heavy",
	source = "player_data"
}
var_0_0.cog_kills_dr_2h_cog_hammer = {
	value = 0,
	database_name = "cog_kills_dr_2h_cog_hammer",
	source = "player_data"
}

local var_0_1 = {
	"complete_all_helmgart_levels_recruit_dr_engineer",
	"complete_all_helmgart_levels_veteran_dr_engineer",
	"complete_all_helmgart_levels_champion_dr_engineer",
	"complete_all_helmgart_levels_legend_dr_engineer",
	"cog_complete_100_missions_dr_engineer",
	"climbing_enemies_killed",
	"steam_pistol_headshots",
	"cog_bomb_kills",
	"clutch_pumps",
	"hammer_cliff_pushes",
	"cog_exploding_barrel_kills",
	"cog_hammer_kill_storm",
	"cog_hammer_kill_leech",
	"cog_hammer_kill_hale",
	"cog_penta_bomb",
	"cog_air_bomb",
	"cog_crank_kill",
	"cog_kill_barrage",
	"cog_all_kill_barrage",
	"cog_long_bomb",
	"cog_steam_elite_kill",
	"cog_hammer_axe_kills",
	"cog_wizard_hammer",
	"cog_steam_alt",
	"cog_bomb_grind",
	"cog_chain_headshot",
	"cog_crank_kill_ratling",
	"cog_pistol_headshot_grind",
	"cog_clutch_pump",
	"cog_hammer_cliff_push",
	"cog_only_crank",
	"cog_long_crank_fire",
	"cog_missing_cog",
	"complete_all_engineer_challenges"
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
	"dr_2h_cog_hammer",
	"dr_steam_pistol",
	"bardin_engineer_career_skill_weapon",
	"bardin_engineer_career_skill_weapon_heavy"
}

for iter_0_1, iter_0_2 in pairs(var_0_3) do
	var_0_0.weapon_kills_per_breed[iter_0_2] = {}
end

for iter_0_3, iter_0_4 in pairs(Breeds) do
	for iter_0_5, iter_0_6 in pairs(var_0_3) do
		local var_0_4 = iter_0_6 .. "_" .. iter_0_3

		var_0_0.weapon_kills_per_breed[iter_0_6][iter_0_3] = {
			value = 0,
			source = "player_data",
			database_name = var_0_4
		}
	end
end

local var_0_5 = {
	dr_engineer = true
}

for iter_0_7, iter_0_8 in pairs(CareerSettings) do
	if var_0_5[iter_0_7] then
		var_0_0.mission_streak[iter_0_7] = {}

		for iter_0_9, iter_0_10 in pairs(LevelSettings) do
			if table.contains(UnlockableLevels, iter_0_9) then
				local var_0_6 = "mission_streak_" .. iter_0_7 .. "_" .. iter_0_9

				var_0_0.mission_streak[iter_0_7][iter_0_9] = {
					value = 0,
					source = "player_data",
					database_name = var_0_6
				}
			end
		end
	end
end
