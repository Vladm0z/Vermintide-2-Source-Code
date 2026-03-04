-- chunkname: @scripts/managers/backend/statistics_definitions_termite_part_2.lua

local var_0_0 = StatisticsDefinitions.player
local var_0_1 = {
	"termite2_mushroom_challenge",
	"termite2_water_challenge",
	"termite2_timer_challenge",
	"termite2_all_challenges"
}

for iter_0_0 = 1, #var_0_1 do
	local var_0_2 = var_0_1[iter_0_0]

	var_0_0[var_0_2] = {
		value = 0,
		source = "player_data",
		database_name = var_0_2
	}
end
