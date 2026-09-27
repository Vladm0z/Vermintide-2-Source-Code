-- chunkname: @scripts/managers/backend/statistics_definitions_karak_azgaraz_part_4.lua

local player = StatisticsDefinitions.player
local tbl = {
	"dwarf_feculent_buboes",
	"dwarf_statue_emote",
	"dwarf_go_fish",
	"dwarf_barrel_kill",
	"dwarf_elevator_speedrun",
	"whaling_all_challenges"
}

for i = 1, #tbl do
	local var_0_2 = tbl[i]

	player[var_0_2] = {
		value = 0,
		source = "player_data",
		database_name = var_0_2
	}
end
