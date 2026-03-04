-- chunkname: @scripts/managers/backend/statistics_definitions_holly.lua

local var_0_0 = StatisticsDefinitions.player

var_0_0.holly_magnus_barrel_relay_race = {
	value = 0,
	database_name = "holly_magnus_barrel_relay_race",
	source = "player_data"
}
var_0_0.holly_magnus_barrel_relay_race_hardest = {
	value = 0,
	database_name = "holly_magnus_barrel_relay_race_hardest",
	source = "player_data"
}
var_0_0.holly_magnus_secret_room = {
	value = 0,
	database_name = "holly_magnus_secret_room",
	source = "player_data"
}
var_0_0.holly_magnus_gutter_runner_treasure = {
	value = 0,
	database_name = "holly_magnus_gutter_runner_treasure",
	source = "player_data"
}
var_0_0.holly_magnus_gutter_runner_treasure_hardest = {
	value = 0,
	database_name = "holly_magnus_gutter_runner_treasure_hardest",
	source = "player_data"
}
var_0_0.holly_magnus_rune = {
	value = 0,
	database_name = "holly_magnus_rune",
	source = "player_data"
}
var_0_0.holly_forest_ambush_synchronized_explosives = {
	value = 0,
	database_name = "holly_forest_ambush_synchronized_explosives",
	source = "player_data"
}
var_0_0.holly_forest_ambush_synchronized_explosives_hardest = {
	value = 0,
	database_name = "holly_forest_ambush_synchronized_explosives_hardest",
	source = "player_data"
}
var_0_0.holly_forest_ambush_bretonnian_dance = {
	value = 0,
	database_name = "holly_forest_ambush_bretonnian_dance",
	source = "player_data"
}
var_0_0.holly_forest_ambush_dragonbane_gem = {
	value = 0,
	database_name = "holly_forest_ambush_dragonbane_gem",
	source = "player_data"
}
var_0_0.holly_forest_ambush_rune = {
	value = 0,
	database_name = "holly_forest_ambush_rune",
	source = "player_data"
}
var_0_0.holly_cemetery_sleep = {
	value = 0,
	database_name = "holly_cemetery_sleep",
	source = "player_data"
}
var_0_0.holly_cemetery_rune = {
	value = 0,
	database_name = "holly_cemetery_rune",
	source = "player_data"
}
var_0_0.holly_cemetery_bones = {
	value = 0,
	database_name = "holly_cemetery_bones",
	source = "player_data"
}
var_0_0.holly_cemetery_synchronized_chains = {
	value = 0,
	database_name = "holly_cemetery_synchronized_chains",
	source = "player_data"
}
var_0_0.holly_cemetery_synchronized_chains_hardest = {
	value = 0,
	database_name = "holly_cemetery_synchronized_chains_hardest",
	source = "player_data"
}
var_0_0.holly_find_all_runes = {
	value = 0,
	database_name = "holly_find_all_runes",
	source = "player_data"
}
var_0_0.holly_difficulty_selection_plaza = {
	value = 1,
	database_name = "holly_difficulty_selection_plaza",
	source = "player_data"
}
var_0_0.holly_kills_we_1h_axe = {
	value = 0,
	database_name = "holly_kills_we_1h_axe",
	source = "player_data"
}
var_0_0.holly_kills_bw_1h_crowbill = {
	value = 0,
	database_name = "holly_kills_bw_1h_crowbill",
	source = "player_data"
}
var_0_0.holly_kills_wh_dual_wield_axe_falchion = {
	value = 0,
	database_name = "holly_kills_wh_dual_wield_axe_falchion",
	source = "player_data"
}
var_0_0.holly_kills_dr_dual_wield_hammers = {
	value = 0,
	database_name = "holly_kills_dr_dual_wield_hammers",
	source = "player_data"
}
var_0_0.holly_kills_es_dual_wield_hammer_sword = {
	value = 0,
	database_name = "holly_kills_es_dual_wield_hammer_sword",
	source = "player_data"
}

local var_0_1 = {
	"warcamp",
	"skaven_stronghold",
	"ground_zero",
	"skittergate"
}
local var_0_2 = {
	"we_1h_axe",
	"bw_1h_crowbill",
	"wh_dual_wield_axe_falchion",
	"dr_dual_wield_hammers",
	"es_dual_wield_hammer_sword"
}

for iter_0_0 = 1, #var_0_1 do
	local var_0_3 = var_0_1[iter_0_0]

	for iter_0_1 = 1, #var_0_2 do
		local var_0_4 = var_0_2[iter_0_1]
		local var_0_5 = "holly_completed_level_" .. var_0_3 .. "_with_" .. var_0_4

		var_0_0[var_0_5] = {
			value = 0,
			source = "player_data",
			database_name = var_0_5
		}
	end
end
