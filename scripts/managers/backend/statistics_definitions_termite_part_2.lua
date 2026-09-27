-- chunkname: @scripts/managers/backend/statistics_definitions_termite_part_2.lua

local player = StatisticsDefinitions.player
local tbl = {
	"termite2_mushroom_challenge",
	"termite2_water_challenge",
	"termite2_timer_challenge",
	"termite2_all_challenges"
}

for i = 1, #tbl do
	local var_0_2 = tbl[i]

	player[var_0_2] = {
		value = 0,
		source = "player_data",
		database_name = var_0_2
	}
end
