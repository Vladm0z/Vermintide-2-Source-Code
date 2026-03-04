-- chunkname: @scripts/managers/backend/statistics_definitions_morris.lua

local var_0_0 = StatisticsDefinitions.player

JourneyDifficultyDBNames = JourneyDifficultyDBNames or {}
var_0_0.completed_journeys_difficulty = {}

for iter_0_0, iter_0_1 in ipairs(AvailableJourneyOrder) do
	local var_0_1 = iter_0_1 .. "_difficulty_completed"

	JourneyDifficultyDBNames[iter_0_1] = var_0_1

	local var_0_2 = {
		value = 0,
		source = "player_data",
		sync_to_host = true,
		database_name = var_0_1
	}

	var_0_0.completed_journeys_difficulty[var_0_1] = var_0_2
end

JourneyDominantGodDifficultyDBNames = JourneyDominantGodDifficultyDBNames or {}
var_0_0.completed_journey_dominant_god_difficulty = {}

for iter_0_2, iter_0_3 in pairs(DEUS_GOD_TYPES) do
	local var_0_3 = iter_0_3 .. "_deus_god_difficulty_completed"

	JourneyDominantGodDifficultyDBNames[iter_0_3] = var_0_3

	local var_0_4 = {
		value = 0,
		source = "player_data",
		sync_to_host = true,
		database_name = var_0_3
	}

	var_0_0.completed_journey_dominant_god_difficulty[var_0_3] = var_0_4
end

var_0_0.completed_hero_journey_difficulty = {}

for iter_0_4, iter_0_5 in ipairs(SPProfilesAbbreviation) do
	var_0_0.completed_hero_journey_difficulty[iter_0_5] = {}

	for iter_0_6, iter_0_7 in ipairs(AvailableJourneyOrder) do
		local var_0_5 = iter_0_7 .. "_difficulty_completed"
		local var_0_6 = iter_0_5 .. "_" .. var_0_5
		local var_0_7 = {
			value = 0,
			source = "player_data",
			sync_to_host = true,
			database_name = var_0_6
		}

		var_0_0.completed_hero_journey_difficulty[iter_0_5][var_0_5] = var_0_7
	end
end

var_0_0.opened_shrines = {}

for iter_0_8, iter_0_9 in pairs(DEUS_CHEST_TYPES) do
	local var_0_8 = iter_0_9 .. "_shrine_opened"

	var_0_0.opened_shrines[iter_0_9] = {
		value = 0,
		source = "player_data",
		database_name = var_0_8
	}
end
