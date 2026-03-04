-- chunkname: @scripts/managers/backend/statistics_definitions_divine.lua

local var_0_0 = StatisticsDefinitions.player
local var_0_1 = {
	"divine_nautical_miles_challenge",
	"divine_anchor_challenge",
	"divine_sink_ships_challenge",
	"divine_cannon_challenge",
	"divine_chaos_warrior_challenge",
	"divine_all_challenges"
}

for iter_0_0 = 1, #var_0_1 do
	local var_0_2 = var_0_1[iter_0_0]

	var_0_0[var_0_2] = {
		value = 0,
		source = "player_data",
		database_name = var_0_2
	}
end
