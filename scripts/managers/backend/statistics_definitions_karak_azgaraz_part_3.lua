-- chunkname: @scripts/managers/backend/statistics_definitions_karak_azgaraz_part_3.lua

local var_0_0 = StatisticsDefinitions.player
local var_0_1 = {
	"dwarf_pressure_pad",
	"dwarf_big_jump",
	"dwarf_crows",
	"dwarf_speedrun"
}

for iter_0_0 = 1, #var_0_1 do
	local var_0_2 = var_0_1[iter_0_0]

	var_0_0[var_0_2] = {
		value = 0,
		source = "player_data",
		database_name = var_0_2
	}
end
