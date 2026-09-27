-- chunkname: @scripts/managers/backend/statistics_definitions_belakor.lua

local player = StatisticsDefinitions.player
local tbl = {
	"blk_three_champions",
	"blk_fast_arena",
	"blk_fast_kill_totems",
	"blk_synced_destruction",
	"blk_white_run",
	"blk_clutch_skull",
	"blk_no_totem",
	"blk_hitless_skull"
}

for i = 1, #tbl do
	local var_0_2 = tbl[i]

	player[var_0_2] = {
		value = 0,
		source = "player_data",
		database_name = var_0_2
	}
end
