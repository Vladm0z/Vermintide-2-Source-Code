-- chunkname: @scripts/settings/dlcs/carousel/carousel_experience_settings.lua

local tbl = {
	0,
	1500,
	1501,
	1503,
	1506,
	1509,
	1513,
	1518,
	1523,
	1529,
	1536,
	1543,
	1551,
	1560,
	1569,
	1579,
	1590,
	1601,
	1613,
	1626,
	1639,
	1653,
	1668,
	1683,
	1699,
	1716,
	1733,
	1751,
	1770,
	1789,
	1809,
	1830,
	1851,
	1873,
	1896,
	1919,
	1943,
	1968,
	1993,
	2019,
	2046,
	2073,
	2101,
	2130,
	2159,
	2189,
	2220,
	2251,
	2283,
	2316,
	2349,
	2383,
	2418,
	2453,
	2489,
	2526,
	2563,
	2601,
	2640,
	2679,
	2719,
	2760,
	2801,
	2843,
	2886,
	2929,
	2973,
	3018,
	3063,
	3109,
	3156,
	3203,
	3251,
	3300,
	3349,
	3399,
	3450,
	3501,
	3553,
	3606,
	3659,
	3713,
	3768,
	3823,
	3879,
	3936,
	3993,
	4051,
	4110,
	4169,
	4229,
	4290,
	4351,
	4413,
	4476,
	4539,
	4603,
	4668,
	4733,
	4799,
	4866,
	4933,
	5001,
	5070,
	5139,
	5209,
	5280,
	5351,
	5423,
	5496,
	5569,
	5643,
	5718,
	5793,
	5869,
	5946,
	6023,
	6101,
	6180,
	6259,
	6339,
	6420,
	6501,
	6583,
	6666,
	6749,
	6833,
	6918,
	7003,
	7089,
	7176,
	7263,
	7351,
	7440,
	7529,
	7619,
	7710,
	7801,
	7893,
	7986,
	8079,
	8173,
	8268,
	8363,
	8459,
	8556,
	8653,
	8751,
	8850,
	8949,
	9049,
	9150,
	9251,
	9353,
	9456,
	9559,
	9663,
	9768,
	9873,
	9979,
	10086,
	10193,
	10301,
	10410,
	10519,
	10629,
	10740,
	10851,
	10963,
	11076,
	11189,
	11303,
	11418,
	11533,
	11649,
	11766,
	11883,
	12001,
	12120,
	12239,
	12359,
	12480,
	12601,
	12723,
	12846,
	12969,
	13093,
	13218,
	13343,
	13469,
	13596,
	13723,
	13851,
	13980,
	14109,
	14239,
	14370,
	14501,
	14633,
	14766,
	14899,
	15033,
	15168,
	15303,
	15439,
	15576,
	15713,
	15851,
	15990,
	16129,
	16269,
	16410,
	16551,
	16693,
	16836,
	16979,
	17123,
	17268,
	17413,
	17559,
	17706,
	17853,
	18001,
	18150,
	18299,
	18449,
	18600,
	18751,
	18903,
	19056,
	19209,
	19363,
	19518,
	19673,
	19829,
	19986,
	20143,
	20301,
	20460,
	20619,
	20779,
	20940,
	21101,
	21263,
	21426,
	21589,
	21753,
	21918,
	22083,
	22249
}
local count = #tbl
local num = 0

for i = 1, count do
	num = num + tbl[i]
end

local ExperienceSettings = ExperienceSettings

ExperienceSettings = ExperienceSettings or {}
ExperienceSettings = ExperienceSettings

ExperienceSettings.get_versus_level = function ()
	-- function 1
	local get_versus_experience = ExperienceSettings.get_versus_experience()

	return ExperienceSettings.get_versus_level_from_experience(get_versus_experience)
end

ExperienceSettings.get_versus_player_level = function (self)
	-- function 2
	local game = Managers.state.network:game()

	if not game then
		return nil
	end

	local unit_storage = Managers.state.unit_storage
	local player_unit = self.player_unit
	local go_id = unit_storage:go_id(player_unit)

	if not go_id then
		return nil
	end

	return (GameSession.game_object_field(game, go_id, "versus_level"))
end

ExperienceSettings.get_versus_experience = function ()
	-- function 3
	return Managers.backend:get_interface("versus"):get_profile_data("experience") or 0
end

ExperienceSettings.get_versus_level_from_experience = function (arg_4_0)
	-- function 4
	arg_4_0 = arg_4_0 or 0

	assert(arg_4_0 >= 0, "Negative XP!??")

	local num_2 = 0
	local num_3 = 0
	local num_4 = 0
	local num_5 = 0
	local var_4_4

	if arg_4_0 >= num then
		return count, num_4, num_5
	end

	for i = 1, count do
		local var_4_5 = num_2

		num_2 = num_2 + tbl[i]

		if arg_4_0 < num_2 then
			num_3 = i - 1
			num_5 = arg_4_0 - var_4_5
			num_4 = num_5 / tbl[i]

			break
		end
	end

	return num_3, num_4, num_5
end

ExperienceSettings.get_versus_progress_breakdown = function (arg_5_0, arg_5_1)
	-- function 5
	local get_versus_level_from_experience, var_5_1 = ExperienceSettings.get_versus_level_from_experience(arg_5_0)
	local get_versus_level_from_experience_2, var_5_3 = ExperienceSettings.get_versus_level_from_experience(arg_5_0 + arg_5_1)
	local tbl_2 = {}

	for i = get_versus_level_from_experience, get_versus_level_from_experience_2 do
		if not tbl[i + 1] then
			tbl_2[i] = 0
		else
			local num = tbl[i + 1] * (i ~= get_versus_level_from_experience_2 or not var_5_3 or 1)

			tbl_2[i] = (num - num * var_5_1) / arg_5_1
			var_5_1 = 0
		end
	end

	return tbl_2, get_versus_level_from_experience
end

ExperienceSettings.max_versus_experience = num
ExperienceSettings.max_versus_level = count
