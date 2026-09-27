-- chunkname: @scripts/managers/backend/statistics_definitions_steak.lua

local player = StatisticsDefinitions.player

player.scorpion_crater_pendant = {
	value = 0,
	database_name = "scorpion_crater_pendant",
	source = "player_data"
}

for i = 1, 3 do
	local str = "scorpion_crater_dark_tongue_" .. i

	player[str] = {
		value = 0,
		source = "player_data",
		database_name = str
	}
end

player.scorpion_crater_detour = {
	value = 0,
	database_name = "scorpion_crater_detour",
	source = "player_data"
}
player.scorpion_crater_ambush = {
	value = 0,
	database_name = "scorpion_crater_ambush",
	source = "player_data"
}
