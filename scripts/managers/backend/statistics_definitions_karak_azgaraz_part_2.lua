-- chunkname: @scripts/managers/backend/statistics_definitions_karak_azgaraz_part_2.lua

local player = StatisticsDefinitions.player
local tbl = {
	"dwarf_towers",
	"dwarf_chain_speed",
	"dwarf_jump_puzzle",
	"dwarf_push"
}

for i = 1, #tbl do
	local var_0_2 = tbl[i]

	player[var_0_2] = {
		value = 0,
		source = "player_data",
		database_name = var_0_2
	}
end
