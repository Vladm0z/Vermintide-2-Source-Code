-- chunkname: @scripts/managers/backend/statistics_definitions_penny_part_1.lua

local player = StatisticsDefinitions.player
local tbl = {
	"penny_portals_portal",
	"penny_portals_heads",
	"penny_portals_vintage",
	"penny_portals_hideout",
	"penny_portals_cleanser"
}

for i = 1, #tbl do
	local var_0_2 = tbl[i]

	player[var_0_2] = {
		value = 0,
		source = "player_data",
		database_name = var_0_2
	}
end
