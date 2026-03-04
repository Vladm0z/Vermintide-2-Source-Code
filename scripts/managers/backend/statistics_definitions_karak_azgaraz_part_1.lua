-- chunkname: @scripts/managers/backend/statistics_definitions_karak_azgaraz_part_1.lua

local var_0_0 = StatisticsDefinitions.player
local var_0_1 = {
	"dwarf_valaya_emote",
	"dwarf_rune",
	"dwarf_barrel_carry",
	"dwarf_bells",
	"dwarf_pressure"
}

for iter_0_0 = 1, #var_0_1 do
	local var_0_2 = var_0_1[iter_0_0]

	var_0_0[var_0_2] = {
		value = 0,
		source = "player_data",
		database_name = var_0_2
	}
end
