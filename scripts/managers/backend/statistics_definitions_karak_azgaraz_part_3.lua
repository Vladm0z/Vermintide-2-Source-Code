-- chunkname: @scripts/managers/backend/statistics_definitions_karak_azgaraz_part_3.lua

local player = StatisticsDefinitions.player
local tbl = {
	"dwarf_pressure_pad",
	"dwarf_big_jump",
	"dwarf_crows",
	"dwarf_speedrun"
}

for i = 1, #tbl do
	local var_0_2 = tbl[i]

	player[var_0_2] = {
		value = 0,
		source = "player_data",
		database_name = var_0_2
	}
end
