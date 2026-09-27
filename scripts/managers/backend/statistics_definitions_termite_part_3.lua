-- chunkname: @scripts/managers/backend/statistics_definitions_termite_part_3.lua

local player = StatisticsDefinitions.player
local tbl = {
	"termite3_collectible_challenge",
	"termite3_searchlight_challenge",
	"termite3_generator_challenge",
	"termite3_portal_challenge",
	"termite3_all_challenges"
}

for i = 1, #tbl do
	local var_0_2 = tbl[i]

	player[var_0_2] = {
		value = 0,
		source = "player_data",
		database_name = var_0_2
	}
end
