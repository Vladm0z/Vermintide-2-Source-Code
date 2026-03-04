-- chunkname: @scripts/managers/backend/statistics_definitions_grudge_marks.lua

local var_0_0 = StatisticsDefinitions.player

var_0_0.grudge_mark_kills = {}
var_0_0.grudge_marks_kills_per_career_per_monster = {}
var_0_0.grudge_marks_kills_per_career_per_expedition = {}

local var_0_1 = {}

for iter_0_0 = 1, #var_0_1 do
	local var_0_2 = var_0_1[iter_0_0]

	var_0_0[var_0_2] = {
		value = 0,
		source = "player_data",
		database_name = var_0_2
	}
end

local var_0_3 = {
	"skaven_rat_ogre",
	"skaven_stormfiend",
	"chaos_spawn",
	"beastmen_minotaur",
	"chaos_troll",
	"chaos_troll_chief"
}
local var_0_4 = {
	"journey_ruin",
	"journey_ice",
	"journey_cave",
	"journey_citadel"
}

for iter_0_1, iter_0_2 in pairs(CareerSettings) do
	if iter_0_1 ~= "empire_soldier_tutorial" then
		local var_0_5 = CareerSettings[iter_0_1].breed

		if var_0_5 and var_0_5.is_hero then
			local var_0_6 = "grudge_mark_kills_" .. iter_0_1

			var_0_0.grudge_mark_kills[iter_0_1] = {
				value = 0,
				source = "player_data",
				database_name = var_0_6
			}
			var_0_0.grudge_marks_kills_per_career_per_monster[iter_0_1] = {}

			for iter_0_3 = 1, #var_0_3 do
				local var_0_7 = var_0_3[iter_0_3]
				local var_0_8 = "grudge_marks_kills_per_" .. iter_0_1 .. "_per_" .. var_0_7

				var_0_0.grudge_marks_kills_per_career_per_monster[iter_0_1][var_0_7] = {
					value = 0,
					source = "player_data",
					database_name = var_0_8
				}
			end

			var_0_0.grudge_marks_kills_per_career_per_expedition[iter_0_1] = {}

			for iter_0_4 = 1, #var_0_4 do
				local var_0_9 = var_0_4[iter_0_4]
				local var_0_10 = "grudge_marks_kills_per_" .. iter_0_1 .. "_per_" .. var_0_9

				var_0_0.grudge_marks_kills_per_career_per_expedition[iter_0_1][var_0_9] = {
					value = 0,
					source = "player_data",
					database_name = var_0_10
				}
			end
		end
	end
end
