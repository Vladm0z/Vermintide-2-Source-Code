-- chunkname: @scripts/managers/backend/statistics_definitions_penny_part_3.lua

local player = StatisticsDefinitions.player
local tbl = {
	"penny_castle_chalice",
	"penny_castle_skull",
	"penny_castle_flask",
	"penny_castle_eruptions",
	"penny_castle_no_kill"
}

for i = 1, #tbl do
	local var_0_2 = tbl[i]

	player[var_0_2] = {
		value = 0,
		source = "player_data",
		database_name = var_0_2
	}
end
