-- chunkname: @scripts/managers/backend/statistics_definitions_cog.lua

local player = StatisticsDefinitions.player

player.cog_kills_bardin_engineer_career_skill_weapon = {
	value = 0,
	database_name = "cog_kills_bardin_engineer_career_skill_weapon",
	source = "player_data"
}
player.cog_kills_bardin_engineer_career_skill_weapon_heavy = {
	value = 0,
	database_name = "cog_kills_bardin_engineer_career_skill_weapon_heavy",
	source = "player_data"
}
player.cog_kills_dr_2h_cog_hammer = {
	value = 0,
	database_name = "cog_kills_dr_2h_cog_hammer",
	source = "player_data"
}

local tbl = {
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

for i = 1, #tbl do
	local var_0_2 = tbl[i]

	player[var_0_2] = {
		value = 0,
		source = "player_data",
		database_name = var_0_2
	}
end

local tbl_2 = {
	"dr_2h_cog_hammer",
	"dr_steam_pistol",
	"bardin_engineer_career_skill_weapon",
	"bardin_engineer_career_skill_weapon_heavy"
}

for k, v in pairs(tbl_2) do
	player.weapon_kills_per_breed[v] = {}
end

for k_2, v_2 in pairs(Breeds) do
	for k_3, v_3 in pairs(tbl_2) do
		local str = v_3 .. "_" .. k_2

		player.weapon_kills_per_breed[v_3][k_2] = {
			value = 0,
			source = "player_data",
			database_name = str
		}
	end
end

local tbl_3 = {
	dr_engineer = true
}

for k_4, v_4 in pairs(CareerSettings) do
	if not tbl_3[k_4] then
		player.mission_streak[k_4] = {}

		for k_5, v_5 in pairs(LevelSettings) do
			if not table.contains(UnlockableLevels, k_5) then
				local str_2 = "mission_streak_" .. k_4 .. "_" .. k_5

				player.mission_streak[k_4][k_5] = {
					value = 0,
					source = "player_data",
					database_name = str_2
				}
			end
		end
	end
end
