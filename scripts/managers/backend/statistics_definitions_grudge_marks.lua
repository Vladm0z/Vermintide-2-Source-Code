-- chunkname: @scripts/managers/backend/statistics_definitions_grudge_marks.lua

local player = StatisticsDefinitions.player

player.grudge_mark_kills = {}
player.grudge_marks_kills_per_career_per_monster = {}
player.grudge_marks_kills_per_career_per_expedition = {}

local tbl = {}

for i = 1, #tbl do
	local var_0_2 = tbl[i]

	player[var_0_2] = {
		value = 0,
		source = "player_data",
		database_name = var_0_2
	}
end

local tbl_2 = {
	"skaven_rat_ogre",
	"skaven_stormfiend",
	"chaos_spawn",
	"beastmen_minotaur",
	"chaos_troll",
	"chaos_troll_chief"
}
local tbl_3 = {
	"journey_ruin",
	"journey_ice",
	"journey_cave",
	"journey_citadel"
}

for k, v in pairs(CareerSettings) do
	if k ~= "empire_soldier_tutorial" then
		local breed = CareerSettings[k].breed

		if not breed and not breed.is_hero then
			local str = "grudge_mark_kills_" .. k

			player.grudge_mark_kills[k] = {
				value = 0,
				source = "player_data",
				database_name = str
			}
			player.grudge_marks_kills_per_career_per_monster[k] = {}

			for l = 1, #tbl_2 do
				local var_0_7 = tbl_2[l]
				local str_2 = "grudge_marks_kills_per_" .. k .. "_per_" .. var_0_7

				player.grudge_marks_kills_per_career_per_monster[k][var_0_7] = {
					value = 0,
					source = "player_data",
					database_name = str_2
				}
			end

			player.grudge_marks_kills_per_career_per_expedition[k] = {}

			for i4 = 1, #tbl_3 do
				local var_0_9 = tbl_3[i4]
				local str_3 = "grudge_marks_kills_per_" .. k .. "_per_" .. var_0_9

				player.grudge_marks_kills_per_career_per_expedition[k][var_0_9] = {
					value = 0,
					source = "player_data",
					database_name = str_3
				}
			end
		end
	end
end
