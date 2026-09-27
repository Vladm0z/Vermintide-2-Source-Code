-- chunkname: @scripts/managers/backend/statistics_definitions_karak_azgaraz_part_1.lua

local player = StatisticsDefinitions.player
local tbl = {
	"dwarf_valaya_emote",
	"dwarf_rune",
	"dwarf_barrel_carry",
	"dwarf_bells",
	"dwarf_pressure"
}

for i = 1, #tbl do
	local var_0_2 = tbl[i]

	player[var_0_2] = {
		value = 0,
		source = "player_data",
		database_name = var_0_2
	}
end
