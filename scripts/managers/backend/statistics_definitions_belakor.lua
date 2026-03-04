-- chunkname: @scripts/managers/backend/statistics_definitions_belakor.lua

local var_0_0 = StatisticsDefinitions.player
local var_0_1 = {
	"blk_three_champions",
	"blk_fast_arena",
	"blk_fast_kill_totems",
	"blk_synced_destruction",
	"blk_white_run",
	"blk_clutch_skull",
	"blk_no_totem",
	"blk_hitless_skull"
}

for iter_0_0 = 1, #var_0_1 do
	local var_0_2 = var_0_1[iter_0_0]

	var_0_0[var_0_2] = {
		value = 0,
		source = "player_data",
		database_name = var_0_2
	}
end
