-- chunkname: @scripts/managers/achievements/achievement_templates_morris.lua

local function var_0_0(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
	local var_1_0 = Managers.state.difficulty

	if not var_1_0 then
		return false
	end

	local var_1_1 = var_1_0:get_default_difficulties()
	local var_1_2 = LevelUnlockUtils.completed_journey_difficulty_index(arg_1_0, arg_1_1, arg_1_2)

	if not var_1_2 then
		return false
	end

	local var_1_3 = var_1_1[var_1_2]

	if not var_1_3 then
		return false
	end

	return arg_1_3 <= DifficultySettings[var_1_3].rank
end

local function var_0_1(arg_2_0, arg_2_1, arg_2_2, arg_2_3)
	local var_2_0 = Managers.state.difficulty

	if not var_2_0 then
		return false
	end

	local var_2_1 = var_2_0:get_default_difficulties()
	local var_2_2 = LevelUnlockUtils.completed_journey_dominant_god_difficulty_index(arg_2_0, arg_2_1, arg_2_2)

	if not var_2_2 then
		return false
	end

	local var_2_3 = var_2_1[var_2_2]

	if not var_2_3 then
		return false
	end

	return arg_2_3 <= DifficultySettings[var_2_3].rank
end

local function var_0_2(arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
	local var_3_0 = Managers.state.difficulty

	if not var_3_0 then
		return false
	end

	local var_3_1 = var_3_0:get_default_difficulties()
	local var_3_2 = LevelUnlockUtils.completed_hero_journey_difficulty_index(arg_3_0, arg_3_1, arg_3_2, arg_3_3)

	if not var_3_2 then
		return false
	end

	local var_3_3 = var_3_1[var_3_2]

	if not var_3_3 then
		return false
	end

	return arg_3_4 <= DifficultySettings[var_3_3].rank
end

local function var_0_3(arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4, arg_4_5, arg_4_6, arg_4_7)
	arg_4_0[arg_4_1] = {
		name = "achv_" .. arg_4_1 .. "_name",
		desc = "achv_" .. arg_4_1 .. "_desc",
		icon = arg_4_4 or "achievement_trophy_" .. arg_4_1,
		required_dlc = arg_4_5,
		ID_XB1 = arg_4_6,
		ID_PS4 = arg_4_7,
		completed = function (arg_5_0, arg_5_1)
			return var_0_0(arg_5_0, arg_5_1, arg_4_2, arg_4_3)
		end
	}
end

local function var_0_4(arg_6_0, arg_6_1, arg_6_2, arg_6_3, arg_6_4, arg_6_5, arg_6_6, arg_6_7)
	arg_6_0[arg_6_1] = {
		name = "achv_" .. arg_6_1 .. "_name",
		desc = "achv_" .. arg_6_1 .. "_desc",
		icon = arg_6_4 or "achievement_trophy_" .. arg_6_1,
		required_dlc = arg_6_5,
		ID_XB1 = arg_6_6,
		ID_PS4 = arg_6_7,
		progress = function (arg_7_0, arg_7_1)
			local var_7_0 = 0

			for iter_7_0 = 1, #arg_6_2 do
				local var_7_1 = arg_6_2[iter_7_0]

				var_7_0 = var_7_0 + arg_7_0:get_persistent_stat(arg_7_1, "opened_shrines", var_7_1)
			end

			return {
				var_7_0,
				arg_6_3
			}
		end,
		completed = function (arg_8_0, arg_8_1)
			local var_8_0 = 0

			for iter_8_0 = 1, #arg_6_2 do
				local var_8_1 = arg_6_2[iter_8_0]

				var_8_0 = var_8_0 + arg_8_0:get_persistent_stat(arg_8_1, "opened_shrines", var_8_1)
			end

			return var_8_0 >= arg_6_3
		end
	}
end

local function var_0_5(arg_9_0, arg_9_1, arg_9_2, arg_9_3, arg_9_4, arg_9_5, arg_9_6, arg_9_7)
	arg_9_0[arg_9_1] = {
		name = "achv_" .. arg_9_1 .. "_name",
		desc = "achv_" .. arg_9_1 .. "_desc",
		icon = arg_9_4 or "achievement_trophy_" .. arg_9_1,
		required_dlc = arg_9_5,
		ID_XB1 = arg_9_6,
		ID_PS4 = arg_9_7,
		completed = function (arg_10_0, arg_10_1)
			return var_0_1(arg_10_0, arg_10_1, arg_9_2, arg_9_3)
		end
	}
end

local function var_0_6(arg_11_0, arg_11_1, arg_11_2, arg_11_3, arg_11_4, arg_11_5, arg_11_6, arg_11_7, arg_11_8)
	local var_11_0 = DifficultyRankLookup[arg_11_4]
	local var_11_1 = DifficultySettings[var_11_0]

	arg_11_0[arg_11_1] = {
		name = "achv_" .. arg_11_1 .. "_name",
		desc = "achv_" .. arg_11_1 .. "_desc",
		icon = arg_11_5 or "achievement_trophy_" .. arg_11_1,
		required_dlc = arg_11_6,
		required_dlc_extra = var_11_1.dlc_requirement,
		ID_XB1 = arg_11_7,
		ID_PS4 = arg_11_8,
		completed = function (arg_12_0, arg_12_1)
			return var_0_2(arg_12_0, arg_12_1, arg_11_2, arg_11_3, arg_11_4)
		end
	}
end

local var_0_7 = AchievementTemplates.achievements

var_0_3(var_0_7, "morris_complete_journey_citadel", "journey_citadel", DifficultySettings.normal.rank, "achievement_morris_citadel", "morris", 92, "084")

if IS_CONSOLE then
	var_0_3(var_0_7, "morris_complete_journey_citadel_champion", "journey_citadel", DifficultySettings.harder.rank, "achievement_morris_citadel", "morris", 93, "085")
	var_0_3(var_0_7, "morris_complete_journey_citadel_legend", "journey_citadel", DifficultySettings.hardest.rank, "achievement_morris_citadel", "morris", 94, "086")
	var_0_4(var_0_7, "morris_opened_shrines_swap_weapon", {
		DEUS_CHEST_TYPES.swap_melee,
		DEUS_CHEST_TYPES.swap_ranged
	}, 30, nil, nil, 99, nil)
	var_0_4(var_0_7, "morris_opened_shrines_upgrade", {
		DEUS_CHEST_TYPES.upgrade
	}, 20, nil, nil, 100, nil)
	var_0_4(var_0_7, "morris_opened_shrines_power_up", {
		DEUS_CHEST_TYPES.power_up
	}, 30, nil, nil, 101, nil)
end

var_0_5(var_0_7, "morris_complete_journey_dominant_god_nurgle", DEUS_GOD_TYPES.NURGLE, DifficultySettings.normal.rank, "achievement_morris_nurgle", "morris", 95, nil)
var_0_5(var_0_7, "morris_complete_journey_dominant_god_khorne", DEUS_GOD_TYPES.KHORNE, DifficultySettings.normal.rank, "achievement_morris_khorne", "morris", 96, nil)
var_0_5(var_0_7, "morris_complete_journey_dominant_god_slaanesh", DEUS_GOD_TYPES.SLAANESH, DifficultySettings.normal.rank, "achievement_morris_slaanesh", "morris", 97, nil)
var_0_5(var_0_7, "morris_complete_journey_dominant_god_tzeentch", DEUS_GOD_TYPES.TZEENTCH, DifficultySettings.normal.rank, "achievement_morris_tzeentch", "morris", 98, nil)
var_0_5(var_0_7, "morris_complete_journey_dominant_god_belakor", DEUS_GOD_TYPES.BELAKOR, DifficultySettings.normal.rank, "achievement_morris_tzeentch", "belakor", 99, nil)

local var_0_8 = {
	"harder",
	"hardest",
	"cataclysm"
}
local var_0_9 = {
	we = "achievement_morris_kerillian_",
	bw = "achievement_morris_sienna_",
	wh = "achievement_morris_victor_",
	dr = "achievement_morris_bardin_",
	es = "achievement_morris_markus_"
}

for iter_0_0, iter_0_1 in ipairs(SPProfilesAbbreviation) do
	for iter_0_2, iter_0_3 in ipairs(AvailableJourneyOrder) do
		for iter_0_4, iter_0_5 in ipairs(var_0_8) do
			local var_0_10 = DifficultyMapping[iter_0_5]
			local var_0_11 = DifficultySettings[iter_0_5].rank
			local var_0_12 = string.format("morris_complete_%s_%s_%s", iter_0_3, iter_0_1, var_0_10)
			local var_0_13 = var_0_9[iter_0_1] .. iter_0_4

			var_0_6(var_0_7, var_0_12, iter_0_1, iter_0_3, var_0_11, var_0_13, "morris", nil, nil)
		end
	end
end
