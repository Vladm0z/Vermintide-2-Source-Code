-- chunkname: @scripts/managers/backend/statistics_definitions_wizards_part_1.lua

local player = StatisticsDefinitions.player
local tbl = {
	"trail_cog_strike",
	"trail_shatterer",
	"trail_sleigher",
	"trail_beacons_are_lit",
	"trail_bonfire_watch_tower",
	"trail_bonfire_river_path",
	"trail_bonfire_lookout_point"
}

for i = 1, #tbl do
	local var_0_2 = tbl[i]

	player[var_0_2] = {
		value = 0,
		source = "player_data",
		database_name = var_0_2
	}
end
