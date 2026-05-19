-- chunkname: @scripts/settings/level_unlock_settings.lua

require("scripts/settings/act_settings")
require("scripts/settings/area_settings")

GameActs = {}
MainGameLevels = {}
HelmgartLevels = {}
UnlockableLevels = {}
UnlockableLevelsByGameMode = {}
DLCProgressionOrder = {}
LevelGameModeTypes = {}
RequiredLevelUnlocksByLevel = {}
NoneActLevels = {}
SurvivalLevels = {}
DebugLevels = {}
GameActsOrder = {
	"prologue",
	"act_1",
	"act_2",
	"act_3",
	"act_4"
}
AdventureActStartId = 2
MapPresentationActs = {
	"act_1",
	"act_2",
	"act_3",
	"act_4"
}
GameActsDisplayNames = {
	act_1 = "act_1_display_name",
	prologue = "prologue_display_name",
	act_4 = "act_4_display_name",
	act_3 = "act_3_display_name",
	act_2 = "act_2_display_name"
}

DLCUtils.dofile("level_unlock_settings")

local var_0_0 = {}

require("scripts/settings/packaged_levels")

local function var_0_1(arg_1_0)
	if rawget(_G, "PACKAGED_LEVEL_PACKAGE_NAMES") then
		local var_1_0 = arg_1_0.packages

		for iter_1_0 = 1, #var_1_0 do
			local var_1_1 = var_1_0[iter_1_0]

			if not PACKAGED_LEVEL_PACKAGE_NAMES[var_1_1] then
				return false
			end
		end
	end

	return true
end

local var_0_2 = true

local function var_0_3(arg_2_0, arg_2_1)
	if type(arg_2_1) == "table" then
		local var_2_0 = false
		local var_2_1 = arg_2_1.packages

		for iter_2_0 = 1, #var_2_1 do
			if string.find(var_2_1[iter_2_0], "^resource_packages/levels/debug/") then
				var_2_0 = true

				break
			end
		end

		if var_2_0 then
			DebugLevels[arg_2_0] = true
		end

		if not arg_2_1.act then
			return false
		end

		local var_2_2 = LevelSettings[arg_2_0]

		if var_0_2 then
			local var_2_3 = arg_2_1.unlockable
			local var_2_4 = var_0_1(arg_2_1)

			return not var_2_2.hub_level and var_2_3 and var_2_4 and not var_2_0
		else
			local var_2_5 = arg_2_1.unlockable

			return not var_2_2.hub_level and var_2_5
		end
	end
end

for iter_0_0, iter_0_1 in pairs(LevelSettings) do
	if var_0_3(iter_0_0, iter_0_1) then
		local var_0_4 = iter_0_1.game_mode or iter_0_1.mechanism

		if var_0_4 then
			if not LevelGameModeTypes[var_0_4] then
				LevelGameModeTypes[var_0_4] = true
			end

			if not UnlockableLevelsByGameMode[var_0_4] then
				UnlockableLevelsByGameMode[var_0_4] = {}
			end

			UnlockableLevelsByGameMode[var_0_4][#UnlockableLevelsByGameMode[var_0_4] + 1] = iter_0_0
		end

		local var_0_5 = iter_0_1.act

		if not GameActs[var_0_5] then
			GameActs[var_0_5] = {}
		end

		if not table.find(MapPresentationActs, var_0_5) then
			MapPresentationActs[#MapPresentationActs + 1] = var_0_5
		end

		GameActs[var_0_5][#GameActs[var_0_5] + 1] = iter_0_0
		UnlockableLevels[#UnlockableLevels + 1] = iter_0_0

		if iter_0_1.main_game_level then
			MainGameLevels[#MainGameLevels + 1] = iter_0_0
		end
	end
end

local var_0_6

for iter_0_2 = 1, #MainGameLevels do
	if MainGameLevels[iter_0_2] == "prologue" then
		var_0_6 = iter_0_2
	end
end

HelmgartLevels = table.clone(MainGameLevels)

if var_0_6 then
	table.remove(HelmgartLevels, var_0_6)
end

for iter_0_3, iter_0_4 in ipairs(UnlockableLevels) do
	local var_0_7 = LevelSettings[iter_0_4]
	local var_0_8 = var_0_7.act_unlock_order

	if var_0_8 and var_0_8 > 0 then
		local var_0_9 = var_0_7.act
		local var_0_10 = GameActs[var_0_9]
		local var_0_11 = {}

		for iter_0_5, iter_0_6 in ipairs(var_0_10) do
			local var_0_12 = LevelSettings[iter_0_6].act_unlock_order

			if var_0_12 and var_0_12 < var_0_8 then
				var_0_11[#var_0_11 + 1] = iter_0_6
			end
		end

		RequiredLevelUnlocksByLevel[iter_0_4] = var_0_11
	end
end

for iter_0_7, iter_0_8 in pairs(GameActs) do
	table.sort(iter_0_8, function(arg_3_0, arg_3_1)
		return LevelSettings[arg_3_0].act_unlock_order < LevelSettings[arg_3_1].act_unlock_order
	end)
end

LevelUnlockUtils = {}

function LevelUnlockUtils.unlocked_level_difficulty_index(arg_4_0, arg_4_1, arg_4_2)
	local var_4_0, var_4_1 = Managers.state.difficulty:get_default_difficulties()
	local var_4_2 = table.find(var_4_0, var_4_1)
	local var_4_3 = #var_4_0
	local var_4_4 = LevelUnlockUtils.completed_level_difficulty_index(arg_4_0, arg_4_1, arg_4_2)

	return math.max(math.min(var_4_4 + 1, var_4_3), var_4_2)
end

function LevelUnlockUtils.completed_level_difficulty_index(arg_5_0, arg_5_1, arg_5_2)
	local var_5_0 = LevelDifficultyDBNames[arg_5_2]

	if var_5_0 then
		return math.min(5, arg_5_0:get_persistent_stat(arg_5_1, "completed_levels_difficulty", var_5_0))
	else
		return 0
	end
end

function LevelUnlockUtils.is_journey_disabled(arg_6_0)
	return (Managers.mechanism and Managers.mechanism:mechanism_setting_for_title("override_journeys") or var_0_0)[arg_6_0] == false
end

function LevelUnlockUtils.is_chaos_waste_god_disabled(arg_7_0)
	return (Managers.mechanism and Managers.mechanism:mechanism_setting_for_title("override_gods") or var_0_0)[arg_7_0] == false
end

function LevelUnlockUtils.unlocked_journeys(arg_8_0, arg_8_1)
	local var_8_0 = {}

	for iter_8_0 = 1, #AvailableJourneyOrder do
		local var_8_1 = AvailableJourneyOrder[iter_8_0]

		if #var_8_0 == 0 then
			if not LevelUnlockUtils.is_journey_disabled(var_8_1) then
				var_8_0[#var_8_0 + 1] = var_8_1
			end
		else
			local var_8_2 = LevelUnlockUtils.completed_journey_difficulty_index(arg_8_0, arg_8_1, AvailableJourneyOrder[iter_8_0 - 1])

			if not script_data.unlock_all_levels and (not var_8_2 or var_8_2 == 0) then
				break
			elseif not LevelUnlockUtils.is_journey_disabled(var_8_1) then
				var_8_0[#var_8_0 + 1] = var_8_1
			end
		end
	end

	return var_8_0
end

function LevelUnlockUtils.completed_journey_difficulty_index(arg_9_0, arg_9_1, arg_9_2)
	local var_9_0 = JourneyDifficultyDBNames[arg_9_2]

	if var_9_0 then
		return (arg_9_0:get_persistent_stat(arg_9_1, "completed_journeys_difficulty", var_9_0))
	else
		return 0
	end
end

function LevelUnlockUtils.completed_hero_journey_difficulty_index(arg_10_0, arg_10_1, arg_10_2, arg_10_3)
	local var_10_0 = JourneyDifficultyDBNames[arg_10_3]

	if var_10_0 then
		return (arg_10_0:get_persistent_stat(arg_10_1, "completed_hero_journey_difficulty", arg_10_2, var_10_0))
	else
		return 0
	end
end

function LevelUnlockUtils.completed_journey_dominant_god_difficulty_index(arg_11_0, arg_11_1, arg_11_2)
	local var_11_0 = JourneyDominantGodDifficultyDBNames[arg_11_2]

	if var_11_0 then
		return (arg_11_0:get_persistent_stat(arg_11_1, "completed_journey_dominant_god_difficulty", var_11_0))
	else
		return 0
	end
end

function LevelUnlockUtils.highest_completed_difficulty_index_by_act(arg_12_0, arg_12_1, arg_12_2)
	local var_12_0 = GameActs[arg_12_2]

	if not var_12_0 then
		print(table.dump(GameActs, nil, 2))
		fassert(false, "act name is not included in GameActs: %s", tostring(arg_12_2))

		return math.huge
	end

	local var_12_1 = math.huge

	for iter_12_0, iter_12_1 in ipairs(var_12_0) do
		local var_12_2 = LevelUnlockUtils.completed_level_difficulty_index(arg_12_0, arg_12_1, iter_12_1)

		if not var_12_2 or var_12_2 > 5 or var_12_2 < 0 then
			fassert(false, "highest completed difficulty index was incorrect: %s", var_12_2 and tostring(var_12_2) or "n/a")
		end

		if var_12_2 < var_12_1 then
			var_12_1 = var_12_2
		end
	end

	return var_12_1
end

function LevelUnlockUtils.completed_adventure_difficulty(arg_13_0, arg_13_1)
	return 1
end

function LevelUnlockUtils.completed_main_game_difficulty(arg_14_0, arg_14_1)
	local var_14_0 = math.huge

	for iter_14_0, iter_14_1 in ipairs(MainGameLevels) do
		local var_14_1 = LevelUnlockUtils.completed_level_difficulty_index(arg_14_0, arg_14_1, iter_14_1)

		if var_14_1 < var_14_0 then
			var_14_0 = var_14_1
		end
	end

	return var_14_0
end

function LevelUnlockUtils.completed_dlc_difficulty(arg_15_0, arg_15_1, arg_15_2)
	local var_15_0

	for iter_15_0, iter_15_1 in pairs(AreaSettings) do
		if iter_15_1.dlc_name == arg_15_2 then
			var_15_0 = iter_15_1

			break
		end
	end

	fassert(var_15_0, "Area settings for dlc: %s does not exist.", arg_15_2)

	local var_15_1 = var_15_0.acts

	fassert(var_15_1, "Acts for dlc: %s does not exist.", arg_15_2)

	local var_15_2 = math.huge

	for iter_15_2, iter_15_3 in ipairs(var_15_1) do
		local var_15_3 = LevelUnlockUtils.highest_completed_difficulty_index_by_act(arg_15_0, arg_15_1, iter_15_3)

		if var_15_3 < var_15_2 then
			var_15_2 = var_15_3
		end
	end

	return var_15_2
end

local function var_0_13(arg_16_0, arg_16_1)
	local var_16_0 = LevelSettings
	local var_16_1 = var_16_0[arg_16_0].map_settings
	local var_16_2 = var_16_0[arg_16_1].map_settings

	return (var_16_1.sorting or 99) < (var_16_2.sorting or 99)
end

function LevelUnlockUtils.is_level_disabled(arg_17_0)
	local var_17_0 = Managers.mechanism and Managers.mechanism:mechanism_setting_for_title("override_levels")

	return var_17_0 and var_17_0[arg_17_0] == false
end

local var_0_14 = {}

function LevelUnlockUtils.get_required_completed_levels(arg_18_0, arg_18_1, arg_18_2)
	table.clear(var_0_14)

	local var_18_0 = LevelSettings[arg_18_2].required_acts

	if var_18_0 then
		for iter_18_0, iter_18_1 in ipairs(var_18_0) do
			local var_18_1
			local var_18_2 = -1
			local var_18_3 = GameActs[iter_18_1]

			for iter_18_2, iter_18_3 in ipairs(var_18_3) do
				if not LevelUnlockUtils.is_level_disabled(iter_18_3) then
					local var_18_4 = LevelSettings[iter_18_3]

					if var_18_2 < var_18_4.act_presentation_order then
						var_18_2 = var_18_4.act_presentation_order
						var_18_1 = iter_18_3
					end
				end
			end

			if var_18_1 then
				local var_18_5 = arg_18_0:get_persistent_stat(arg_18_1, "completed_levels", var_18_1)

				if not (var_18_5 and var_18_5 ~= 0) then
					var_0_14[var_18_1] = true
				end
			end
		end
	end

	local var_18_6 = RequiredLevelUnlocksByLevel[arg_18_2]

	if var_18_6 then
		local var_18_7
		local var_18_8 = -1

		for iter_18_4, iter_18_5 in ipairs(var_18_6) do
			if not LevelUnlockUtils.is_level_disabled(iter_18_5) then
				local var_18_9 = LevelSettings[iter_18_5]

				if var_18_8 < var_18_9.act_presentation_order then
					var_18_8 = var_18_9.act_presentation_order
					var_18_7 = iter_18_5
				end
			end
		end

		if var_18_7 then
			local var_18_10 = arg_18_0:get_persistent_stat(arg_18_1, "completed_levels", var_18_7)

			if not (var_18_10 and var_18_10 ~= 0) then
				var_0_14[var_18_7] = true
			end
		end
	end

	return var_0_14
end

function LevelUnlockUtils.current_weave(arg_19_0, arg_19_1, arg_19_2)
	if script_data.unlock_all_levels then
		return WeaveSettings.templates_ordered[#WeaveSettings.templates_ordered].name
	end

	if not arg_19_2 then
		local var_19_0 = WeaveSettings.templates_ordered[1]
		local var_19_1 = var_19_0.dlc_name

		if var_19_1 and not Managers.unlock:is_dlc_unlocked(var_19_1) then
			return var_19_0.name
		end
	end

	local var_19_2 = WeaveSettings.templates_ordered
	local var_19_3 = #var_19_2
	local var_19_4 = 1
	local var_19_5 = false

	for iter_19_0 = 1, var_19_3 do
		local var_19_6 = var_19_2[iter_19_0]

		if LevelUnlockUtils.weave_unlocked(arg_19_0, arg_19_1, var_19_6.name, arg_19_2) then
			local var_19_7 = iter_19_0 + 1

			if var_19_2[var_19_7] and not LevelUnlockUtils.weave_disabled(var_19_7) then
				var_19_4 = var_19_7
			end
		else
			break
		end
	end

	return var_19_2[var_19_4].name
end

function LevelUnlockUtils.weave_disabled(arg_20_0)
	local var_20_0 = Managers.mechanism and Managers.mechanism:mechanism_setting_for_title("override_weaves") or var_0_0

	if var_20_0.levels and var_20_0.levels[arg_20_0] ~= nil then
		return not var_20_0.levels[arg_20_0]
	end

	local var_20_1 = WeaveSettings.templates[arg_20_0]

	if not var_20_1 then
		return false
	end

	if var_20_0.winds and var_20_0.winds[var_20_1.wind] ~= nil then
		return not var_20_0.winds[var_20_1.wind]
	end

	return false
end

function LevelUnlockUtils.weave_unlocked(arg_21_0, arg_21_1, arg_21_2, arg_21_3, arg_21_4)
	if script_data.unlock_all_levels then
		return true
	end

	local var_21_0 = WeaveSettings.templates[arg_21_2]

	if not var_21_0 then
		printf("LevelUnlockUtils.weave_unlocked: Unable to join weave '%s', no weave_data was found.", arg_21_2)

		return false
	end

	if not arg_21_3 then
		local var_21_1 = var_21_0.dlc_name

		if var_21_1 and not Managers.unlock:is_dlc_unlocked(var_21_1) then
			return false
		end
	end

	local var_21_2 = var_21_0.tier
	local var_21_3 = var_21_2 <= 40 and arg_21_0:get_persistent_stat(arg_21_1, "completed_weaves", arg_21_2) > 0
	local var_21_4 = false

	if not var_21_3 then
		local var_21_5 = arg_21_4 and math.max(arg_21_4, 1) or 1
		local var_21_6 = arg_21_4 and math.max(arg_21_4, 4) or 4

		for iter_21_0 = var_21_5, var_21_6 do
			local var_21_7 = ScorpionSeasonalSettings.get_weave_score_stat(var_21_2, iter_21_0)

			var_21_4 = arg_21_0:get_persistent_stat(arg_21_1, ScorpionSeasonalSettings.current_season_name, var_21_7) > 0

			if var_21_4 then
				break
			end
		end
	end

	return var_21_3 or var_21_4
end

function LevelUnlockUtils.level_unlocked(arg_22_0, arg_22_1, arg_22_2, arg_22_3)
	if script_data.unlock_all_levels then
		return true
	end

	if LevelUnlockUtils.is_level_disabled(arg_22_2) then
		return false
	end

	if arg_22_2 == "any" then
		return true
	end

	local var_22_0 = LevelUnlockUtils.get_act_key_by_level(arg_22_2)
	local var_22_1 = LevelSettings[arg_22_2]

	if not arg_22_3 then
		local var_22_2 = var_22_1.dlc_name

		if var_22_2 and not Managers.unlock:is_dlc_unlocked(var_22_2) then
			return false
		end
	end

	if not var_22_0 then
		local var_22_3 = var_22_1.required_act_completed

		if var_22_3 and not LevelUnlockUtils.act_completed(arg_22_0, arg_22_1, var_22_3) then
			return false
		end
	else
		local var_22_4 = var_22_1.required_acts

		if var_22_4 then
			for iter_22_0, iter_22_1 in ipairs(var_22_4) do
				if not LevelUnlockUtils.act_unlocked(arg_22_0, arg_22_1, iter_22_1) then
					return false
				end
			end
		end

		local var_22_5 = RequiredLevelUnlocksByLevel[arg_22_2]

		if var_22_5 then
			for iter_22_2, iter_22_3 in ipairs(var_22_5) do
				if not LevelUnlockUtils.is_level_disabled(iter_22_3) then
					local var_22_6 = arg_22_0:get_persistent_stat(arg_22_1, "completed_levels", iter_22_3)

					if not (var_22_6 and var_22_6 ~= 0) then
						return false
					end
				end
			end
		end
	end

	return true
end

function LevelUnlockUtils.all_levels_completed(arg_23_0, arg_23_1)
	local var_23_0 = UnlockableLevelsByGameMode.adventure

	for iter_23_0, iter_23_1 in ipairs(var_23_0) do
		if arg_23_0:get_persistent_stat(arg_23_1, "completed_levels", iter_23_1) == 0 then
			return false
		end
	end

	return true
end

function LevelUnlockUtils.get_act_key_by_level(arg_24_0)
	for iter_24_0, iter_24_1 in pairs(GameActs) do
		for iter_24_2, iter_24_3 in ipairs(iter_24_1) do
			if arg_24_0 == iter_24_3 then
				return iter_24_0
			end
		end
	end
end

function LevelUnlockUtils.act_unlocked(arg_25_0, arg_25_1, arg_25_2)
	assert(GameActs[arg_25_2] ~= nil, "Act %s does not exist.", arg_25_2)

	local var_25_0 = GameActs[arg_25_2]

	for iter_25_0, iter_25_1 in ipairs(var_25_0) do
		if not LevelUnlockUtils.is_level_disabled(iter_25_1) then
			local var_25_1 = arg_25_0:get_persistent_stat(arg_25_1, "completed_levels", iter_25_1)

			if not (var_25_1 and var_25_1 ~= 0) then
				return false
			end
		end
	end

	return true
end

function LevelUnlockUtils.act_completed(arg_26_0, arg_26_1, arg_26_2)
	assert(GameActs[arg_26_2] ~= nil, "Act %s does not exist.", arg_26_2)

	local var_26_0 = GameActs[arg_26_2]

	for iter_26_0, iter_26_1 in ipairs(var_26_0) do
		local var_26_1 = arg_26_0:get_persistent_stat(arg_26_1, "completed_levels", iter_26_1)

		if not (var_26_1 and var_26_1 ~= 0) then
			return false
		end
	end

	return true
end

function LevelUnlockUtils.num_acts_completed(arg_27_0, arg_27_1)
	local var_27_0 = 0

	for iter_27_0, iter_27_1 in pairs(GameActs) do
		if LevelUnlockUtils.act_completed(arg_27_0, arg_27_1, iter_27_0) then
			var_27_0 = var_27_0 + 1
		end
	end

	return var_27_0
end

function LevelUnlockUtils.all_dlc_levels_completed(arg_28_0, arg_28_1, arg_28_2)
	local var_28_0

	for iter_28_0, iter_28_1 in pairs(AreaSettings) do
		if iter_28_1.dlc_name == arg_28_2 then
			var_28_0 = iter_28_1

			break
		end
	end

	fassert(var_28_0, "Area settings for dlc: %s does not exist.", arg_28_2)

	local var_28_1 = var_28_0.acts

	fassert(var_28_1, "Acts for dlc: %s does not exist.", arg_28_2)

	for iter_28_2, iter_28_3 in ipairs(var_28_1) do
		if not LevelUnlockUtils.act_completed(arg_28_0, arg_28_1, iter_28_3) then
			return false
		end
	end

	return true
end

function LevelUnlockUtils.set_all_acts_incompleted()
	local var_29_0 = Managers.player
	local var_29_1 = var_29_0:statistics_db()
	local var_29_2 = var_29_0:local_player():stats_id()

	for iter_29_0, iter_29_1 in ipairs(GameActsOrder) do
		local var_29_3 = math.min(iter_29_0 + 1, #GameActsOrder)
		local var_29_4 = GameActsOrder[var_29_3]

		fassert(var_29_4, "Could not find act for index %d.", var_29_3)

		for iter_29_2, iter_29_3 in ipairs(GameActsOrder) do
			local var_29_5 = GameActs[iter_29_3]

			for iter_29_4, iter_29_5 in ipairs(var_29_5) do
				local var_29_6 = var_29_1:get_persistent_stat(var_29_2, "completed_levels", iter_29_5)

				while var_29_6 > 0 do
					var_29_1:decrement_stat(var_29_2, "completed_levels", iter_29_5)

					var_29_6 = var_29_1:get_persistent_stat(var_29_2, "completed_levels", iter_29_5)
				end
			end
		end
	end

	local var_29_7 = {}

	var_29_1:generate_backend_stats(var_29_2, var_29_7)
	Managers.backend:set_stats(var_29_7)
end

function LevelUnlockUtils.get_next_adventure_level(arg_30_0, arg_30_1)
	for iter_30_0 = AdventureActStartId, #GameActsOrder do
		local var_30_0 = GameActsOrder[iter_30_0]

		if not LevelUnlockUtils.act_completed(arg_30_0, arg_30_1, var_30_0) then
			local var_30_1 = GameActs[var_30_0]

			for iter_30_1 = 1, #var_30_1 do
				local var_30_2 = var_30_1[iter_30_1]

				if LevelUnlockUtils.completed_level_difficulty_index(arg_30_0, arg_30_1, var_30_2) <= 0 then
					return var_30_2
				end
			end
		end
	end

	return nil
end

function LevelUnlockUtils.debug_set_completed_game_difficulty(arg_31_0)
	local var_31_0 = Managers.player:statistics_db()
	local var_31_1 = Managers.player:local_player():stats_id()

	for iter_31_0, iter_31_1 in pairs(LevelDifficultyDBNames) do
		local var_31_2 = var_31_0:set_stat(var_31_1, "completed_levels_difficulty", iter_31_1, arg_31_0)
	end

	local var_31_3 = {}

	var_31_0:generate_backend_stats(var_31_1, var_31_3)
	Managers.backend:set_stats(var_31_3)
	Managers.backend:commit()
end

function LevelUnlockUtils.debug_set_completed_journey_difficulty(arg_32_0, arg_32_1)
	local var_32_0 = Managers.player:statistics_db()
	local var_32_1 = Managers.player:local_player():stats_id()
	local var_32_2 = JourneyDifficultyDBNames[arg_32_0]

	var_32_0:set_stat(var_32_1, "completed_journeys_difficulty", var_32_2, arg_32_1)

	local var_32_3 = {}

	var_32_0:generate_backend_stats(var_32_1, var_32_3)
	Managers.backend:set_stats(var_32_3)
	Managers.backend:commit()
end

function LevelUnlockUtils.debug_set_completed_hero_journey_difficulty(arg_33_0, arg_33_1, arg_33_2)
	local var_33_0 = Managers.player:statistics_db()
	local var_33_1 = Managers.player:local_player():stats_id()
	local var_33_2 = JourneyDifficultyDBNames[arg_33_1]

	var_33_0:set_stat(var_33_1, "completed_hero_journey_difficulty", arg_33_0, var_33_2, arg_33_2)

	local var_33_3 = {}

	var_33_0:generate_backend_stats(var_33_1, var_33_3)
	Managers.backend:set_stats(var_33_3)
	Managers.backend:commit()
end

function LevelUnlockUtils.debug_unlock_act(arg_34_0)
	local var_34_0 = Managers.player
	local var_34_1 = var_34_0:statistics_db()
	local var_34_2 = var_34_0:local_player():stats_id()
	local var_34_3 = math.min(arg_34_0 + 1, #GameActsOrder)
	local var_34_4 = GameActsOrder[var_34_3]

	assert(var_34_4, "Could not find act for index %d.", var_34_3)

	local var_34_5 = false

	for iter_34_0, iter_34_1 in ipairs(GameActsOrder) do
		if iter_34_1 == var_34_4 then
			var_34_5 = true
		end

		local var_34_6 = GameActs[iter_34_1]

		for iter_34_2, iter_34_3 in ipairs(var_34_6) do
			if not var_34_5 then
				var_34_1:increment_stat(var_34_2, "completed_levels", iter_34_3)
			else
				local var_34_7 = var_34_1:get_persistent_stat(var_34_2, "completed_levels", iter_34_3)

				while var_34_7 > 0 do
					var_34_1:decrement_stat(var_34_2, "completed_levels", iter_34_3)

					var_34_7 = var_34_1:get_persistent_stat(var_34_2, "completed_levels", iter_34_3)
				end
			end
		end
	end

	local var_34_8 = {}

	var_34_1:generate_backend_stats(var_34_2, var_34_8)
	Managers.backend:set_stats(var_34_8)
	Managers.backend:commit()
end

function LevelUnlockUtils.debug_completed_act_levels(arg_35_0, arg_35_1)
	local var_35_0 = Managers.player
	local var_35_1 = var_35_0:statistics_db()
	local var_35_2 = var_35_0:local_player():stats_id()
	local var_35_3 = GameActs[arg_35_0]

	if not var_35_3 then
		print("Could not find any levels for act", arg_35_0)

		return
	end

	for iter_35_0, iter_35_1 in ipairs(var_35_3) do
		if arg_35_1 then
			var_35_1:increment_stat(var_35_2, "completed_levels", iter_35_1)
		else
			var_35_1:set_stat(var_35_2, "completed_levels", iter_35_1, 0)
		end
	end

	local var_35_4 = {}

	var_35_1:generate_backend_stats(var_35_2, var_35_4)
	Managers.backend:set_stats(var_35_4)
	Managers.backend:commit()
end

function LevelUnlockUtils.debug_complete_level(arg_36_0)
	local var_36_0 = Managers.player
	local var_36_1 = var_36_0:statistics_db()
	local var_36_2 = var_36_0:local_player():stats_id()

	var_36_1:set_stat(var_36_2, "completed_levels", arg_36_0, 1)

	local var_36_3 = {}

	var_36_1:generate_backend_stats(var_36_2, var_36_3)
	Managers.backend:set_stats(var_36_3)
	Managers.backend:commit()
end
