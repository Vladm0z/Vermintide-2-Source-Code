-- chunkname: @scripts/managers/backend/statistics_definitions_termite_part_3.lua

local var_0_0 = StatisticsDefinitions.player
local var_0_1 = {
	"termite3_collectible_challenge",
	"termite3_searchlight_challenge",
	"termite3_generator_challenge",
	"termite3_portal_challenge",
	"termite3_all_challenges"
}

for iter_0_0 = 1, #var_0_1 do
	local var_0_2 = var_0_1[iter_0_0]

	var_0_0[var_0_2] = {
		value = 0,
		source = "player_data",
		database_name = var_0_2
	}
end
