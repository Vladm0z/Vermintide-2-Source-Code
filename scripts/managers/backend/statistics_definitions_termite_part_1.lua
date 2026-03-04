-- chunkname: @scripts/managers/backend/statistics_definitions_termite_part_1.lua

local var_0_0 = StatisticsDefinitions.player
local var_0_1 = {
	"termite1_skaven_markings_challenge",
	"termite1_bell_challenge",
	"termite1_towers_challenge",
	"termite1_waystone_timer_challenge_easy",
	"termite1_waystone_timer_challenge_hard",
	"termite1_all_challenges"
}

for iter_0_0 = 1, #var_0_1 do
	local var_0_2 = var_0_1[iter_0_0]

	var_0_0[var_0_2] = {
		value = 0,
		source = "player_data",
		database_name = var_0_2
	}
end
