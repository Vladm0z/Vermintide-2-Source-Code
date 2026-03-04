-- chunkname: @scripts/managers/backend/statistics_definitions_karak_azgaraz_part_2.lua

local var_0_0 = StatisticsDefinitions.player
local var_0_1 = {
	"dwarf_towers",
	"dwarf_chain_speed",
	"dwarf_jump_puzzle",
	"dwarf_push"
}

for iter_0_0 = 1, #var_0_1 do
	local var_0_2 = var_0_1[iter_0_0]

	var_0_0[var_0_2] = {
		value = 0,
		source = "player_data",
		database_name = var_0_2
	}
end
