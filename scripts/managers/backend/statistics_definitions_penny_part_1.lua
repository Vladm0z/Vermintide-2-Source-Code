-- chunkname: @scripts/managers/backend/statistics_definitions_penny_part_1.lua

local var_0_0 = StatisticsDefinitions.player
local var_0_1 = {
	"penny_portals_portal",
	"penny_portals_heads",
	"penny_portals_vintage",
	"penny_portals_hideout",
	"penny_portals_cleanser"
}

for iter_0_0 = 1, #var_0_1 do
	local var_0_2 = var_0_1[iter_0_0]

	var_0_0[var_0_2] = {
		value = 0,
		source = "player_data",
		database_name = var_0_2
	}
end
