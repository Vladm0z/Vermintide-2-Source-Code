-- chunkname: @scripts/managers/backend/statistics_definitions_steak.lua

local var_0_0 = StatisticsDefinitions.player

var_0_0.scorpion_crater_pendant = {
	value = 0,
	database_name = "scorpion_crater_pendant",
	source = "player_data"
}

for iter_0_0 = 1, 3 do
	local var_0_1 = "scorpion_crater_dark_tongue_" .. iter_0_0

	var_0_0[var_0_1] = {
		value = 0,
		source = "player_data",
		database_name = var_0_1
	}
end

var_0_0.scorpion_crater_detour = {
	value = 0,
	database_name = "scorpion_crater_detour",
	source = "player_data"
}
var_0_0.scorpion_crater_ambush = {
	value = 0,
	database_name = "scorpion_crater_ambush",
	source = "player_data"
}
