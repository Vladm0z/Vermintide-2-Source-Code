-- chunkname: @scripts/managers/backend/statistics_definitions_morris.lua

local player = StatisticsDefinitions.player
local JourneyDifficultyDBNames = JourneyDifficultyDBNames

JourneyDifficultyDBNames = JourneyDifficultyDBNames or {}
JourneyDifficultyDBNames = JourneyDifficultyDBNames
player.completed_journeys_difficulty = {}

for i, v in ipairs(AvailableJourneyOrder) do
	local str = v .. "_difficulty_completed"

	JourneyDifficultyDBNames[v] = str

	local tbl = {
		value = 0,
		source = "player_data",
		sync_to_host = true,
		database_name = str
	}

	player.completed_journeys_difficulty[str] = tbl
end

local JourneyDominantGodDifficultyDBNames = JourneyDominantGodDifficultyDBNames

JourneyDominantGodDifficultyDBNames = JourneyDominantGodDifficultyDBNames or {}
JourneyDominantGodDifficultyDBNames = JourneyDominantGodDifficultyDBNames
player.completed_journey_dominant_god_difficulty = {}

for k, v_2 in pairs(DEUS_GOD_TYPES) do
	local str_2 = v_2 .. "_deus_god_difficulty_completed"

	JourneyDominantGodDifficultyDBNames[v_2] = str_2

	local tbl_2 = {
		value = 0,
		source = "player_data",
		sync_to_host = true,
		database_name = str_2
	}

	player.completed_journey_dominant_god_difficulty[str_2] = tbl_2
end

player.completed_hero_journey_difficulty = {}

for i_2, v_3 in ipairs(SPProfilesAbbreviation) do
	player.completed_hero_journey_difficulty[v_3] = {}

	for i_3, v_4 in ipairs(AvailableJourneyOrder) do
		local str_3 = v_4 .. "_difficulty_completed"
		local str_4 = v_3 .. "_" .. str_3
		local tbl_3 = {
			value = 0,
			source = "player_data",
			sync_to_host = true,
			database_name = str_4
		}

		player.completed_hero_journey_difficulty[v_3][str_3] = tbl_3
	end
end

player.opened_shrines = {}

for k_2, v_5 in pairs(DEUS_CHEST_TYPES) do
	local str_5 = v_5 .. "_shrine_opened"

	player.opened_shrines[v_5] = {
		value = 0,
		source = "player_data",
		database_name = str_5
	}
end
