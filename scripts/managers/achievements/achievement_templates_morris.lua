-- chunkname: @scripts/managers/achievements/achievement_templates_morris.lua

local function fn(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
	-- function 1
	local difficulty = Managers.state.difficulty

	if not difficulty then
		return false
	end

	local get_default_difficulties = difficulty:get_default_difficulties()
	local completed_journey_difficulty_index = LevelUnlockUtils.completed_journey_difficulty_index(arg_1_0, arg_1_1, arg_1_2)

	if not completed_journey_difficulty_index then
		return false
	end

	local var_1_3 = get_default_difficulties[completed_journey_difficulty_index]

	if not var_1_3 then
		return false
	end

	return arg_1_3 <= DifficultySettings[var_1_3].rank
end

local function fn_2(arg_2_0, arg_2_1, arg_2_2, arg_2_3)
	-- function 2
	local difficulty = Managers.state.difficulty

	if not difficulty then
		return false
	end

	local get_default_difficulties = difficulty:get_default_difficulties()
	local completed_journey_dominant_god_difficulty_index = LevelUnlockUtils.completed_journey_dominant_god_difficulty_index(arg_2_0, arg_2_1, arg_2_2)

	if not completed_journey_dominant_god_difficulty_index then
		return false
	end

	local var_2_3 = get_default_difficulties[completed_journey_dominant_god_difficulty_index]

	if not var_2_3 then
		return false
	end

	return arg_2_3 <= DifficultySettings[var_2_3].rank
end

local function fn_3(arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
	-- function 3
	local difficulty = Managers.state.difficulty

	if not difficulty then
		return false
	end

	local get_default_difficulties = difficulty:get_default_difficulties()
	local completed_hero_journey_difficulty_index = LevelUnlockUtils.completed_hero_journey_difficulty_index(arg_3_0, arg_3_1, arg_3_2, arg_3_3)

	if not completed_hero_journey_difficulty_index then
		return false
	end

	local var_3_3 = get_default_difficulties[completed_hero_journey_difficulty_index]

	if not var_3_3 then
		return false
	end

	return arg_3_4 <= DifficultySettings[var_3_3].rank
end

local function fn_4(self, arg_4_1, arg_4_2, arg_4_3, arg_4_4, arg_4_5, arg_4_6, arg_4_7)
	-- function 4
	self[arg_4_1] = {
		name = "achv_" .. arg_4_1 .. "_name",
		desc = "achv_" .. arg_4_1 .. "_desc",
		icon = arg_4_4 or "achievement_trophy_" .. arg_4_1,
		required_dlc = arg_4_5,
		ID_XB1 = arg_4_6,
		ID_PS4 = arg_4_7,
		completed = function (arg_5_0, arg_5_1)
			-- function 5
			return fn(arg_5_0, arg_5_1, arg_4_2, arg_4_3)
		end
	}
end

local function fn_5(self, arg_6_1, arg_6_2, arg_6_3, arg_6_4, arg_6_5, arg_6_6, arg_6_7)
	-- function 6
	self[arg_6_1] = {
		name = "achv_" .. arg_6_1 .. "_name",
		desc = "achv_" .. arg_6_1 .. "_desc",
		icon = arg_6_4 or "achievement_trophy_" .. arg_6_1,
		required_dlc = arg_6_5,
		ID_XB1 = arg_6_6,
		ID_PS4 = arg_6_7,
		progress = function (self, arg_7_1)
			-- function 7
			local num = 0

			for i = 1, #arg_6_2 do
				local var_7_1 = arg_6_2[i]

				num = num + self:get_persistent_stat(arg_7_1, "opened_shrines", var_7_1)
			end

			return {
				num,
				arg_6_3
			}
		end,
		completed = function (self, arg_8_1)
			-- function 8
			local num = 0

			for i = 1, #arg_6_2 do
				local var_8_1 = arg_6_2[i]

				num = num + self:get_persistent_stat(arg_8_1, "opened_shrines", var_8_1)
			end

			return num >= arg_6_3
		end
	}
end

local function fn_6(self, arg_9_1, arg_9_2, arg_9_3, arg_9_4, arg_9_5, arg_9_6, arg_9_7)
	-- function 9
	self[arg_9_1] = {
		name = "achv_" .. arg_9_1 .. "_name",
		desc = "achv_" .. arg_9_1 .. "_desc",
		icon = arg_9_4 or "achievement_trophy_" .. arg_9_1,
		required_dlc = arg_9_5,
		ID_XB1 = arg_9_6,
		ID_PS4 = arg_9_7,
		completed = function (arg_10_0, arg_10_1)
			-- function 10
			return fn_2(arg_10_0, arg_10_1, arg_9_2, arg_9_3)
		end
	}
end

local function fn_7(self, arg_11_1, arg_11_2, arg_11_3, arg_11_4, arg_11_5, arg_11_6, arg_11_7, arg_11_8)
	-- function 11
	local var_11_0 = DifficultyRankLookup[arg_11_4]
	local var_11_1 = DifficultySettings[var_11_0]

	self[arg_11_1] = {
		name = "achv_" .. arg_11_1 .. "_name",
		desc = "achv_" .. arg_11_1 .. "_desc",
		icon = arg_11_5 or "achievement_trophy_" .. arg_11_1,
		required_dlc = arg_11_6,
		required_dlc_extra = var_11_1.dlc_requirement,
		ID_XB1 = arg_11_7,
		ID_PS4 = arg_11_8,
		completed = function (arg_12_0, arg_12_1)
			-- function 12
			return fn_3(arg_12_0, arg_12_1, arg_11_2, arg_11_3, arg_11_4)
		end
	}
end

local achievements = AchievementTemplates.achievements

fn_4(achievements, "morris_complete_journey_citadel", "journey_citadel", DifficultySettings.normal.rank, "achievement_morris_citadel", "morris", 92, "084")

if not IS_CONSOLE then
	fn_4(achievements, "morris_complete_journey_citadel_champion", "journey_citadel", DifficultySettings.harder.rank, "achievement_morris_citadel", "morris", 93, "085")
	fn_4(achievements, "morris_complete_journey_citadel_legend", "journey_citadel", DifficultySettings.hardest.rank, "achievement_morris_citadel", "morris", 94, "086")
	fn_5(achievements, "morris_opened_shrines_swap_weapon", {
		DEUS_CHEST_TYPES.swap_melee,
		DEUS_CHEST_TYPES.swap_ranged
	}, 30, nil, nil, 99, nil)
	fn_5(achievements, "morris_opened_shrines_upgrade", {
		DEUS_CHEST_TYPES.upgrade
	}, 20, nil, nil, 100, nil)
	fn_5(achievements, "morris_opened_shrines_power_up", {
		DEUS_CHEST_TYPES.power_up
	}, 30, nil, nil, 101, nil)
end

fn_6(achievements, "morris_complete_journey_dominant_god_nurgle", DEUS_GOD_TYPES.NURGLE, DifficultySettings.normal.rank, "achievement_morris_nurgle", "morris", 95, nil)
fn_6(achievements, "morris_complete_journey_dominant_god_khorne", DEUS_GOD_TYPES.KHORNE, DifficultySettings.normal.rank, "achievement_morris_khorne", "morris", 96, nil)
fn_6(achievements, "morris_complete_journey_dominant_god_slaanesh", DEUS_GOD_TYPES.SLAANESH, DifficultySettings.normal.rank, "achievement_morris_slaanesh", "morris", 97, nil)
fn_6(achievements, "morris_complete_journey_dominant_god_tzeentch", DEUS_GOD_TYPES.TZEENTCH, DifficultySettings.normal.rank, "achievement_morris_tzeentch", "morris", 98, nil)
fn_6(achievements, "morris_complete_journey_dominant_god_belakor", DEUS_GOD_TYPES.BELAKOR, DifficultySettings.normal.rank, "achievement_morris_tzeentch", "belakor", 99, nil)

local tbl = {
	"harder",
	"hardest",
	"cataclysm"
}
local tbl_2 = {
	we = "achievement_morris_kerillian_",
	bw = "achievement_morris_sienna_",
	wh = "achievement_morris_victor_",
	dr = "achievement_morris_bardin_",
	es = "achievement_morris_markus_"
}

for i, v in ipairs(SPProfilesAbbreviation) do
	for i_2, v_2 in ipairs(AvailableJourneyOrder) do
		for i_3, v_3 in ipairs(tbl) do
			local var_0_10 = DifficultyMapping[v_3]
			local rank = DifficultySettings[v_3].rank
			local format = string.format("morris_complete_%s_%s_%s", v_2, v, var_0_10)
			local str = tbl_2[v] .. i_3

			fn_7(achievements, format, v, v_2, rank, str, "morris", nil, nil)
		end
	end
end
