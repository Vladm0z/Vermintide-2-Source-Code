-- chunkname: @scripts/managers/backend/statistics_definitions_wizards_part_1.lua

local var_0_0 = StatisticsDefinitions.player
local var_0_1 = {
	"trail_cog_strike",
	"trail_shatterer",
	"trail_sleigher",
	"trail_beacons_are_lit",
	"trail_bonfire_watch_tower",
	"trail_bonfire_river_path",
	"trail_bonfire_lookout_point"
}

for iter_0_0 = 1, #var_0_1 do
	local var_0_2 = var_0_1[iter_0_0]

	var_0_0[var_0_2] = {
		value = 0,
		source = "player_data",
		database_name = var_0_2
	}
end
