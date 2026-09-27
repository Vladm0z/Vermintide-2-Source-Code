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

local tbl = {}

require("scripts/settings/packaged_levels")

local function fn(self)
	-- function 1
	if not rawget(_G, "PACKAGED_LEVEL_PACKAGE_NAMES") then
		local packages = self.packages

		for i = 1, #packages do
			local var_1_1 = packages[i]

			if not PACKAGED_LEVEL_PACKAGE_NAMES[var_1_1] then
				return false
			end
		end
	end

	return true
end

local flag = true

local function fn_2(arg_2_0, arg_2_1)
	-- function 2
	if type(arg_2_1) == "table" then
		local flag_2 = false
		local packages = arg_2_1.packages

		for i = 1, #packages do
			if not string.find(packages[i], "^resource_packages/levels/debug/") then
				flag_2 = true

				break
			end
		end

		if not flag_2 then
			DebugLevels[arg_2_0] = true
		end

		if not arg_2_1.act then
			return false
		end

		local var_2_2 = LevelSettings[arg_2_0]

		if not flag then
			local unlockable = arg_2_1.unlockable
			local var_2_4 = fn(arg_2_1)

			return (not not var_2_2.hub_level or not unlockable) and not var_2_4 and not flag_2
		else
			local unlockable_2 = arg_2_1.unlockable

			return not not var_2_2.hub_level or unlockable_2
		end
	end
end

for k, v in pairs(LevelSettings) do
	if not fn_2(k, v) then
		local game_mode = v.game_mode

		game_mode = game_mode or v.mechanism

		if not game_mode then
			if not LevelGameModeTypes[game_mode] then
				LevelGameModeTypes[game_mode] = true
			end

			if not UnlockableLevelsByGameMode[game_mode] then
				UnlockableLevelsByGameMode[game_mode] = {}
			end

			UnlockableLevelsByGameMode[game_mode][#UnlockableLevelsByGameMode[game_mode] + 1] = k
		end

		local act = v.act

		if not GameActs[act] then
			GameActs[act] = {}
		end

		if not table.find(MapPresentationActs, act) then
			MapPresentationActs[#MapPresentationActs + 1] = act
		end

		GameActs[act][#GameActs[act] + 1] = k
		UnlockableLevels[#UnlockableLevels + 1] = k

		if not v.main_game_level then
			MainGameLevels[#MainGameLevels + 1] = k
		end
	end
end

local var_0_6

for k_2 = 1, #MainGameLevels do
	if MainGameLevels[k_2] == "prologue" then
		var_0_6 = k_2
	end
end

HelmgartLevels = table.clone(MainGameLevels)

if not var_0_6 then
	table.remove(HelmgartLevels, var_0_6)
end

for i, v_2 in ipairs(UnlockableLevels) do
	local var_0_7 = LevelSettings[v_2]
	local act_unlock_order = var_0_7.act_unlock_order

	if not (not act_unlock_order and not (act_unlock_order > 0)) then
		local act_2 = var_0_7.act
		local var_0_10 = GameActs[act_2]
		local tbl_2 = {}

		for i_2, v_3 in ipairs(var_0_10) do
			local act_unlock_order_2 = LevelSettings[v_3].act_unlock_order

			if not (not act_unlock_order_2 and not (act_unlock_order_2 < act_unlock_order)) then
				tbl_2[#tbl_2 + 1] = v_3
			end
		end

		RequiredLevelUnlocksByLevel[v_2] = tbl_2
	end
end

for k_3, v_4 in pairs(GameActs) do
	table.sort(v_4, function (arg_3_0, arg_3_1)
		-- function 3
		return LevelSettings[arg_3_0].act_unlock_order < LevelSettings[arg_3_1].act_unlock_order
	end)
end

LevelUnlockUtils = {}

LevelUnlockUtils.unlocked_level_difficulty_index = function (arg_4_0, arg_4_1, arg_4_2)
	-- function 4
	local get_default_difficulties, var_4_1 = Managers.state.difficulty:get_default_difficulties()
	local find = table.find(get_default_difficulties, var_4_1)
	local count = #get_default_difficulties
	local completed_level_difficulty_index = LevelUnlockUtils.completed_level_difficulty_index(arg_4_0, arg_4_1, arg_4_2)

	return math.max(math.min(completed_level_difficulty_index + 1, count), find)
end

LevelUnlockUtils.completed_level_difficulty_index = function (self, arg_5_1, arg_5_2)
	-- function 5
	local var_5_0 = LevelDifficultyDBNames[arg_5_2]

	if not var_5_0 then
		return math.min(5, self:get_persistent_stat(arg_5_1, "completed_levels_difficulty", var_5_0))
	else
		return 0
	end
end

LevelUnlockUtils.is_journey_disabled = function (arg_6_0)
	-- function 6
	local mechanism_setting_for_title

	if not Managers.mechanism then
		mechanism_setting_for_title = Managers.mechanism:mechanism_setting_for_title("override_journeys")

		if not mechanism_setting_for_title then
			-- Nothing
		end
	end

	mechanism_setting_for_title = tbl

	::label_6_0::

	return mechanism_setting_for_title[arg_6_0] == false
end

LevelUnlockUtils.is_chaos_waste_god_disabled = function (arg_7_0)
	-- function 7
	local mechanism_setting_for_title

	if not Managers.mechanism then
		mechanism_setting_for_title = Managers.mechanism:mechanism_setting_for_title("override_gods")

		if not mechanism_setting_for_title then
			-- Nothing
		end
	end

	mechanism_setting_for_title = tbl

	::label_7_0::

	return mechanism_setting_for_title[arg_7_0] == false
end

LevelUnlockUtils.unlocked_journeys = function (arg_8_0, arg_8_1)
	-- function 8
	local tbl = {}

	for i = 1, #AvailableJourneyOrder do
		local var_8_1 = AvailableJourneyOrder[i]

		if #tbl == 0 then
			if not LevelUnlockUtils.is_journey_disabled(var_8_1) then
				tbl[#tbl + 1] = var_8_1
			end
		else
			local completed_journey_difficulty_index = LevelUnlockUtils.completed_journey_difficulty_index(arg_8_0, arg_8_1, AvailableJourneyOrder[i - 1])

			if not (script_data.unlock_all_levels or not completed_journey_difficulty_index or completed_journey_difficulty_index ~= 0) then
				break
			elseif not LevelUnlockUtils.is_journey_disabled(var_8_1) then
				tbl[#tbl + 1] = var_8_1
			end
		end
	end

	return tbl
end

LevelUnlockUtils.completed_journey_difficulty_index = function (self, arg_9_1, arg_9_2)
	-- function 9
	local var_9_0 = JourneyDifficultyDBNames[arg_9_2]

	if not var_9_0 then
		return (self:get_persistent_stat(arg_9_1, "completed_journeys_difficulty", var_9_0))
	else
		return 0
	end
end

LevelUnlockUtils.completed_hero_journey_difficulty_index = function (self, arg_10_1, arg_10_2, arg_10_3)
	-- function 10
	local var_10_0 = JourneyDifficultyDBNames[arg_10_3]

	if not var_10_0 then
		return (self:get_persistent_stat(arg_10_1, "completed_hero_journey_difficulty", arg_10_2, var_10_0))
	else
		return 0
	end
end

LevelUnlockUtils.completed_journey_dominant_god_difficulty_index = function (self, arg_11_1, arg_11_2)
	-- function 11
	local var_11_0 = JourneyDominantGodDifficultyDBNames[arg_11_2]

	if not var_11_0 then
		return (self:get_persistent_stat(arg_11_1, "completed_journey_dominant_god_difficulty", var_11_0))
	else
		return 0
	end
end

LevelUnlockUtils.highest_completed_difficulty_index_by_act = function (arg_12_0, arg_12_1, arg_12_2)
	-- function 12
	local var_12_0 = GameActs[arg_12_2]

	if not var_12_0 then
		print(table.dump(GameActs, nil, 2))
		fassert(false, "act name is not included in GameActs: %s", tostring(arg_12_2))

		return math.huge
	end

	local huge = math.huge

	for i, v in ipairs(var_12_0) do
		local completed_level_difficulty_index = LevelUnlockUtils.completed_level_difficulty_index(arg_12_0, arg_12_1, v)

		if not (not completed_level_difficulty_index and completed_level_difficulty_index > 5 or not (completed_level_difficulty_index < 0)) then
			local fassert = fassert
			local flag = false
			local str = "highest completed difficulty index was incorrect: %s"
			local var_12_6

			if not completed_level_difficulty_index then
				var_12_6 = tostring(completed_level_difficulty_index)

				if not var_12_6 then
					-- Nothing
				end
			end

			var_12_6 = "n/a"

			::label_12_0::

			fassert(flag, str, var_12_6)
		end

		if completed_level_difficulty_index < huge then
			huge = completed_level_difficulty_index
		end
	end

	return huge
end

LevelUnlockUtils.completed_adventure_difficulty = function (arg_13_0, arg_13_1)
	-- function 13
	return 1
end

LevelUnlockUtils.completed_main_game_difficulty = function (arg_14_0, arg_14_1)
	-- function 14
	local huge = math.huge

	for i, v in ipairs(MainGameLevels) do
		local completed_level_difficulty_index = LevelUnlockUtils.completed_level_difficulty_index(arg_14_0, arg_14_1, v)

		if completed_level_difficulty_index < huge then
			huge = completed_level_difficulty_index
		end
	end

	return huge
end

LevelUnlockUtils.completed_dlc_difficulty = function (arg_15_0, arg_15_1, arg_15_2)
	-- function 15
	local var_15_0

	for k, v in pairs(AreaSettings) do
		if v.dlc_name == arg_15_2 then
			var_15_0 = v

			break
		end
	end

	fassert(var_15_0, "Area settings for dlc: %s does not exist.", arg_15_2)

	local acts = var_15_0.acts

	fassert(acts, "Acts for dlc: %s does not exist.", arg_15_2)

	local huge = math.huge

	for i, v_2 in ipairs(acts) do
		local highest_completed_difficulty_index_by_act = LevelUnlockUtils.highest_completed_difficulty_index_by_act(arg_15_0, arg_15_1, v_2)

		if highest_completed_difficulty_index_by_act < huge then
			huge = highest_completed_difficulty_index_by_act
		end
	end

	return huge
end

local function fn_3(arg_16_0, arg_16_1)
	-- function 16
	local LevelSettings = LevelSettings
	local map_settings = LevelSettings[arg_16_0].map_settings
	local map_settings_2 = LevelSettings[arg_16_1].map_settings
	local sorting = map_settings.sorting

	sorting = sorting or 99

	local sorting_2 = map_settings_2.sorting

	sorting_2 = sorting_2 or 99

	return sorting < sorting_2
end

LevelUnlockUtils.is_level_disabled = function (arg_17_0)
	-- function 17
	local mechanism = Managers.mechanism

	mechanism = not mechanism and Managers.mechanism:mechanism_setting_for_title("override_levels")

	return not mechanism and mechanism[arg_17_0] == false
end

local tbl_3 = {}

LevelUnlockUtils.get_required_completed_levels = function (self, arg_18_1, arg_18_2)
	-- function 18
	table.clear(tbl_3)

	local required_acts = LevelSettings[arg_18_2].required_acts

	if not required_acts then
		for i, v in ipairs(required_acts) do
			local var_18_1
			local num = -1
			local var_18_3 = GameActs[v]

			for i_2, v_2 in ipairs(var_18_3) do
				if not LevelUnlockUtils.is_level_disabled(v_2) then
					local var_18_4 = LevelSettings[v_2]

					if num < var_18_4.act_presentation_order then
						num = var_18_4.act_presentation_order
						var_18_1 = v_2
					end
				end
			end

			if not var_18_1 then
				local get_persistent_stat = self:get_persistent_stat(arg_18_1, "completed_levels", var_18_1)

				if not (not get_persistent_stat and get_persistent_stat ~= 0) then
					tbl_3[var_18_1] = true
				end
			end
		end
	end

	local var_18_6 = RequiredLevelUnlocksByLevel[arg_18_2]

	if not var_18_6 then
		local var_18_7
		local num_2 = -1

		for i_3, v_3 in ipairs(var_18_6) do
			if not LevelUnlockUtils.is_level_disabled(v_3) then
				local var_18_9 = LevelSettings[v_3]

				if num_2 < var_18_9.act_presentation_order then
					num_2 = var_18_9.act_presentation_order
					var_18_7 = v_3
				end
			end
		end

		if not var_18_7 then
			local get_persistent_stat_2 = self:get_persistent_stat(arg_18_1, "completed_levels", var_18_7)

			if not (not get_persistent_stat_2 and get_persistent_stat_2 ~= 0) then
				tbl_3[var_18_7] = true
			end
		end
	end

	return tbl_3
end

LevelUnlockUtils.current_weave = function (arg_19_0, arg_19_1, arg_19_2)
	-- function 19
	if not script_data.unlock_all_levels then
		return WeaveSettings.templates_ordered[#WeaveSettings.templates_ordered].name
	end

	if not arg_19_2 then
		local var_19_0 = WeaveSettings.templates_ordered[1]
		local dlc_name = var_19_0.dlc_name

		if not (not dlc_name and Managers.unlock:is_dlc_unlocked(dlc_name)) then
			return var_19_0.name
		end
	end

	local templates_ordered = WeaveSettings.templates_ordered
	local count = #templates_ordered
	local num = 1
	local flag = false

	for i = 1, count do
		local var_19_6 = templates_ordered[i]

		if not LevelUnlockUtils.weave_unlocked(arg_19_0, arg_19_1, var_19_6.name, arg_19_2) then
			local num_2 = i + 1

			if not (not templates_ordered[num_2] and LevelUnlockUtils.weave_disabled(num_2)) then
				num = num_2
			end
		else
			break
		end
	end

	return templates_ordered[num].name
end

LevelUnlockUtils.weave_disabled = function (arg_20_0)
	-- function 20
	local mechanism_setting_for_title

	if not Managers.mechanism then
		mechanism_setting_for_title = Managers.mechanism:mechanism_setting_for_title("override_weaves")

		if not mechanism_setting_for_title then
			-- Nothing
		end
	end

	mechanism_setting_for_title = tbl

	::label_20_0::

	if not (not mechanism_setting_for_title.levels and mechanism_setting_for_title.levels[arg_20_0] == nil) then
		return not mechanism_setting_for_title.levels[arg_20_0]
	end

	local var_20_1 = WeaveSettings.templates[arg_20_0]

	if not var_20_1 then
		return false
	end

	if not (not mechanism_setting_for_title.winds and mechanism_setting_for_title.winds[var_20_1.wind] == nil) then
		return not mechanism_setting_for_title.winds[var_20_1.wind]
	end

	return false
end

LevelUnlockUtils.weave_unlocked = function (self, arg_21_1, arg_21_2, arg_21_3, arg_21_4)
	-- function 21
	if not script_data.unlock_all_levels then
		return true
	end

	local var_21_0 = WeaveSettings.templates[arg_21_2]

	if not var_21_0 then
		printf("LevelUnlockUtils.weave_unlocked: Unable to join weave '%s', no weave_data was found.", arg_21_2)

		return false
	end

	if not arg_21_3 then
		local dlc_name = var_21_0.dlc_name

		if not (not dlc_name and Managers.unlock:is_dlc_unlocked(dlc_name)) then
			return false
		end
	end

	local tier = var_21_0.tier
	local flag = not (tier <= 40) or self:get_persistent_stat(arg_21_1, "completed_weaves", arg_21_2) > 0
	local flag_2 = false

	if not flag then
		local max

		if not arg_21_4 then
			max = math.max(arg_21_4, 1)

			if not max then
				-- Nothing
			end
		end

		max = 1

		do
			local max_2
		end

		::label_21_0::

		if not arg_21_4 then
			max_2 = math.max(arg_21_4, 4)

			if not max_2 then
				-- Nothing
			end
		end

		max_2 = 4

		::label_21_1::

		for i = max, max_2 do
			local get_weave_score_stat = ScorpionSeasonalSettings.get_weave_score_stat(tier, i)

			flag_2 = self:get_persistent_stat(arg_21_1, ScorpionSeasonalSettings.current_season_name, get_weave_score_stat) > 0

			if not flag_2 then
				break
			end
		end
	end

	return flag or flag_2
end

LevelUnlockUtils.level_unlocked = function (self, arg_22_1, arg_22_2, arg_22_3)
	-- function 22
	if not script_data.unlock_all_levels then
		return true
	end

	if not LevelUnlockUtils.is_level_disabled(arg_22_2) then
		return false
	end

	if arg_22_2 == "any" then
		return true
	end

	local get_act_key_by_level = LevelUnlockUtils.get_act_key_by_level(arg_22_2)
	local var_22_1 = LevelSettings[arg_22_2]

	if not arg_22_3 then
		local dlc_name = var_22_1.dlc_name

		if not (not dlc_name and Managers.unlock:is_dlc_unlocked(dlc_name)) then
			return false
		end
	end

	if not get_act_key_by_level then
		local required_act_completed = var_22_1.required_act_completed

		if not (not required_act_completed and LevelUnlockUtils.act_completed(self, arg_22_1, required_act_completed)) then
			return false
		end
	else
		local required_acts = var_22_1.required_acts

		if not required_acts then
			for i, v in ipairs(required_acts) do
				if not LevelUnlockUtils.act_unlocked(self, arg_22_1, v) then
					return false
				end
			end
		end

		local var_22_5 = RequiredLevelUnlocksByLevel[arg_22_2]

		if not var_22_5 then
			for i_2, v_2 in ipairs(var_22_5) do
				if not LevelUnlockUtils.is_level_disabled(v_2) then
					local get_persistent_stat = self:get_persistent_stat(arg_22_1, "completed_levels", v_2)

					if not (not get_persistent_stat and get_persistent_stat ~= 0) then
						return false
					end
				end
			end
		end
	end

	return true
end

LevelUnlockUtils.all_levels_completed = function (self, arg_23_1)
	-- function 23
	local adventure = UnlockableLevelsByGameMode.adventure

	for i, v in ipairs(adventure) do
		if self:get_persistent_stat(arg_23_1, "completed_levels", v) == 0 then
			return false
		end
	end

	return true
end

LevelUnlockUtils.get_act_key_by_level = function (arg_24_0)
	-- function 24
	for k, v in pairs(GameActs) do
		for i, v_2 in ipairs(v) do
			if arg_24_0 == v_2 then
				return k
			end
		end
	end
end

LevelUnlockUtils.act_unlocked = function (self, arg_25_1, arg_25_2)
	-- function 25
	assert(GameActs[arg_25_2] ~= nil, "Act %s does not exist.", arg_25_2)

	local var_25_0 = GameActs[arg_25_2]

	for i, v in ipairs(var_25_0) do
		if not LevelUnlockUtils.is_level_disabled(v) then
			local get_persistent_stat = self:get_persistent_stat(arg_25_1, "completed_levels", v)

			if not (not get_persistent_stat and get_persistent_stat ~= 0) then
				return false
			end
		end
	end

	return true
end

LevelUnlockUtils.act_completed = function (self, arg_26_1, arg_26_2)
	-- function 26
	assert(GameActs[arg_26_2] ~= nil, "Act %s does not exist.", arg_26_2)

	local var_26_0 = GameActs[arg_26_2]

	for i, v in ipairs(var_26_0) do
		local get_persistent_stat = self:get_persistent_stat(arg_26_1, "completed_levels", v)

		if not (not get_persistent_stat and get_persistent_stat ~= 0) then
			return false
		end
	end

	return true
end

LevelUnlockUtils.num_acts_completed = function (arg_27_0, arg_27_1)
	-- function 27
	local num = 0

	for k, v in pairs(GameActs) do
		if not LevelUnlockUtils.act_completed(arg_27_0, arg_27_1, k) then
			num = num + 1
		end
	end

	return num
end

LevelUnlockUtils.all_dlc_levels_completed = function (arg_28_0, arg_28_1, arg_28_2)
	-- function 28
	local var_28_0

	for k, v in pairs(AreaSettings) do
		if v.dlc_name == arg_28_2 then
			var_28_0 = v

			break
		end
	end

	fassert(var_28_0, "Area settings for dlc: %s does not exist.", arg_28_2)

	local acts = var_28_0.acts

	fassert(acts, "Acts for dlc: %s does not exist.", arg_28_2)

	for i, v_2 in ipairs(acts) do
		if not LevelUnlockUtils.act_completed(arg_28_0, arg_28_1, v_2) then
			return false
		end
	end

	return true
end

LevelUnlockUtils.set_all_acts_incompleted = function ()
	-- function 29
	local player = Managers.player
	local statistics_db = player:statistics_db()
	local stats_id = player:local_player():stats_id()

	for i, v in ipairs(GameActsOrder) do
		local min = math.min(i + 1, #GameActsOrder)
		local var_29_4 = GameActsOrder[min]

		fassert(var_29_4, "Could not find act for index %d.", min)

		for i_2, v_2 in ipairs(GameActsOrder) do
			local var_29_5 = GameActs[v_2]

			for i_3, v_3 in ipairs(var_29_5) do
				local get_persistent_stat = statistics_db:get_persistent_stat(stats_id, "completed_levels", v_3)

				while get_persistent_stat > 0 do
					statistics_db:decrement_stat(stats_id, "completed_levels", v_3)

					get_persistent_stat = statistics_db:get_persistent_stat(stats_id, "completed_levels", v_3)
				end
			end
		end
	end

	local tbl = {}

	statistics_db:generate_backend_stats(stats_id, tbl)
	Managers.backend:set_stats(tbl)
end

LevelUnlockUtils.get_next_adventure_level = function (arg_30_0, arg_30_1)
	-- function 30
	for i = AdventureActStartId, #GameActsOrder do
		local var_30_0 = GameActsOrder[i]

		if not LevelUnlockUtils.act_completed(arg_30_0, arg_30_1, var_30_0) then
			local var_30_1 = GameActs[var_30_0]

			for j = 1, #var_30_1 do
				local var_30_2 = var_30_1[j]

				if LevelUnlockUtils.completed_level_difficulty_index(arg_30_0, arg_30_1, var_30_2) <= 0 then
					return var_30_2
				end
			end
		end
	end

	return nil
end

LevelUnlockUtils.debug_set_completed_game_difficulty = function (arg_31_0)
	-- function 31
	local statistics_db = Managers.player:statistics_db()
	local stats_id = Managers.player:local_player():stats_id()

	for k, v in pairs(LevelDifficultyDBNames) do
		local set_stat = statistics_db:set_stat(stats_id, "completed_levels_difficulty", v, arg_31_0)
	end

	local tbl = {}

	statistics_db:generate_backend_stats(stats_id, tbl)
	Managers.backend:set_stats(tbl)
	Managers.backend:commit()
end

LevelUnlockUtils.debug_set_completed_journey_difficulty = function (arg_32_0, arg_32_1)
	-- function 32
	local statistics_db = Managers.player:statistics_db()
	local stats_id = Managers.player:local_player():stats_id()
	local var_32_2 = JourneyDifficultyDBNames[arg_32_0]

	statistics_db:set_stat(stats_id, "completed_journeys_difficulty", var_32_2, arg_32_1)

	local tbl = {}

	statistics_db:generate_backend_stats(stats_id, tbl)
	Managers.backend:set_stats(tbl)
	Managers.backend:commit()
end

LevelUnlockUtils.debug_set_completed_hero_journey_difficulty = function (arg_33_0, arg_33_1, arg_33_2)
	-- function 33
	local statistics_db = Managers.player:statistics_db()
	local stats_id = Managers.player:local_player():stats_id()
	local var_33_2 = JourneyDifficultyDBNames[arg_33_1]

	statistics_db:set_stat(stats_id, "completed_hero_journey_difficulty", arg_33_0, var_33_2, arg_33_2)

	local tbl = {}

	statistics_db:generate_backend_stats(stats_id, tbl)
	Managers.backend:set_stats(tbl)
	Managers.backend:commit()
end

LevelUnlockUtils.debug_unlock_act = function (arg_34_0)
	-- function 34
	local player = Managers.player
	local statistics_db = player:statistics_db()
	local stats_id = player:local_player():stats_id()
	local min = math.min(arg_34_0 + 1, #GameActsOrder)
	local var_34_4 = GameActsOrder[min]

	assert(var_34_4, "Could not find act for index %d.", min)

	local flag = false

	for i, v in ipairs(GameActsOrder) do
		if v == var_34_4 then
			flag = true
		end

		local var_34_6 = GameActs[v]

		for i_2, v_2 in ipairs(var_34_6) do
			if not flag then
				statistics_db:increment_stat(stats_id, "completed_levels", v_2)
			else
				local get_persistent_stat = statistics_db:get_persistent_stat(stats_id, "completed_levels", v_2)

				while get_persistent_stat > 0 do
					statistics_db:decrement_stat(stats_id, "completed_levels", v_2)

					get_persistent_stat = statistics_db:get_persistent_stat(stats_id, "completed_levels", v_2)
				end
			end
		end
	end

	local tbl = {}

	statistics_db:generate_backend_stats(stats_id, tbl)
	Managers.backend:set_stats(tbl)
	Managers.backend:commit()
end

LevelUnlockUtils.debug_completed_act_levels = function (arg_35_0, arg_35_1)
	-- function 35
	local player = Managers.player
	local statistics_db = player:statistics_db()
	local stats_id = player:local_player():stats_id()
	local var_35_3 = GameActs[arg_35_0]

	if not var_35_3 then
		print("Could not find any levels for act", arg_35_0)

		return
	end

	for i, v in ipairs(var_35_3) do
		if not arg_35_1 then
			statistics_db:increment_stat(stats_id, "completed_levels", v)
		else
			statistics_db:set_stat(stats_id, "completed_levels", v, 0)
		end
	end

	local tbl = {}

	statistics_db:generate_backend_stats(stats_id, tbl)
	Managers.backend:set_stats(tbl)
	Managers.backend:commit()
end

LevelUnlockUtils.debug_complete_level = function (arg_36_0)
	-- function 36
	local player = Managers.player
	local statistics_db = player:statistics_db()
	local stats_id = player:local_player():stats_id()

	statistics_db:set_stat(stats_id, "completed_levels", arg_36_0, 1)

	local tbl = {}

	statistics_db:generate_backend_stats(stats_id, tbl)
	Managers.backend:set_stats(tbl)
	Managers.backend:commit()
end
