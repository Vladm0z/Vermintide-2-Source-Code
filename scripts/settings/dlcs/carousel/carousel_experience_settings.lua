-- chunkname: @scripts/settings/dlcs/carousel/carousel_experience_settings.lua

local var_0_0 = {
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
local var_0_1 = #var_0_0
local var_0_2 = 0

for iter_0_0 = 1, var_0_1 do
	var_0_2 = var_0_2 + var_0_0[iter_0_0]
end

ExperienceSettings = ExperienceSettings or {}

function ExperienceSettings.get_versus_level()
	local var_1_0 = ExperienceSettings.get_versus_experience()

	return ExperienceSettings.get_versus_level_from_experience(var_1_0)
end

function ExperienceSettings.get_versus_player_level(arg_2_0)
	local var_2_0 = Managers.state.network:game()

	if not var_2_0 then
		return nil
	end

	local var_2_1 = Managers.state.unit_storage
	local var_2_2 = arg_2_0.player_unit
	local var_2_3 = var_2_1:go_id(var_2_2)

	if not var_2_3 then
		return nil
	end

	return (GameSession.game_object_field(var_2_0, var_2_3, "versus_level"))
end

function ExperienceSettings.get_versus_experience()
	return Managers.backend:get_interface("versus"):get_profile_data("experience") or 0
end

function ExperienceSettings.get_versus_level_from_experience(arg_4_0)
	arg_4_0 = arg_4_0 or 0

	assert(arg_4_0 >= 0, "Negative XP!??")

	local var_4_0 = 0
	local var_4_1 = 0
	local var_4_2 = 0
	local var_4_3 = 0
	local var_4_4

	if arg_4_0 >= var_0_2 then
		return var_0_1, var_4_2, var_4_3
	end

	for iter_4_0 = 1, var_0_1 do
		local var_4_5 = var_4_0

		var_4_0 = var_4_0 + var_0_0[iter_4_0]

		if arg_4_0 < var_4_0 then
			var_4_1 = iter_4_0 - 1
			var_4_3 = arg_4_0 - var_4_5
			var_4_2 = var_4_3 / var_0_0[iter_4_0]

			break
		end
	end

	return var_4_1, var_4_2, var_4_3
end

function ExperienceSettings.get_versus_progress_breakdown(arg_5_0, arg_5_1)
	local var_5_0, var_5_1 = ExperienceSettings.get_versus_level_from_experience(arg_5_0)
	local var_5_2, var_5_3 = ExperienceSettings.get_versus_level_from_experience(arg_5_0 + arg_5_1)
	local var_5_4 = {}

	for iter_5_0 = var_5_0, var_5_2 do
		if not var_0_0[iter_5_0 + 1] then
			var_5_4[iter_5_0] = 0
		else
			local var_5_5 = var_0_0[iter_5_0 + 1] * (iter_5_0 == var_5_2 and var_5_3 or 1)

			var_5_4[iter_5_0] = (var_5_5 - var_5_5 * var_5_1) / arg_5_1
			var_5_1 = 0
		end
	end

	return var_5_4, var_5_0
end

ExperienceSettings.max_versus_experience = var_0_2
ExperienceSettings.max_versus_level = var_0_1
