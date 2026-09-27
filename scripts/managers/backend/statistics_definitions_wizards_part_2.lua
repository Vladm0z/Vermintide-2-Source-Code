-- chunkname: @scripts/managers/backend/statistics_definitions_wizards_part_2.lua

local player = StatisticsDefinitions.player
local tbl = {
	"tower_skulls",
	"tower_wall_illusions",
	"tower_invisible_bridge",
	"tower_enable_guardian_of_lustria",
	"tower_note_puzzle",
	"tower_created_all_potions",
	"tower_time_challenge"
}

for i = 1, #tbl do
	local var_0_2 = tbl[i]

	player[var_0_2] = {
		value = 0,
		source = "player_data",
		database_name = var_0_2
	}
end
