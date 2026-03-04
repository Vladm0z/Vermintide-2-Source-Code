-- chunkname: @scripts/helpers/rarity_utils.lua

require("scripts/settings/dlcs/morris/rarity_settings")

RarityUtils = RarityUtils or {}

RarityUtils.get_previous_rarity = function (arg_1_0)
	local var_1_0 = RaritySettings
	local var_1_1 = var_1_0[arg_1_0].order
	local var_1_2 = arg_1_0
	local var_1_3 = 0

	for iter_1_0, iter_1_1 in pairs(var_1_0) do
		if var_1_1 > iter_1_1.order and var_1_3 < iter_1_1.order then
			var_1_2 = iter_1_0
			var_1_3 = var_1_0[var_1_2].order
		end
	end

	local var_1_4 = var_1_2 ~= arg_1_0

	return var_1_2, var_1_4
end

RarityUtils.get_lower_rarities = function (arg_2_0)
	local var_2_0 = RaritySettings
	local var_2_1 = var_2_0[arg_2_0].order
	local var_2_2 = {}

	for iter_2_0, iter_2_1 in pairs(var_2_0) do
		if var_2_1 > iter_2_1.order then
			table.insert(var_2_2, iter_2_0)
		end
	end

	return var_2_2
end

RarityUtils.get_higher_rarities = function (arg_3_0)
	local var_3_0 = RaritySettings
	local var_3_1 = var_3_0[arg_3_0].order
	local var_3_2 = {}

	for iter_3_0, iter_3_1 in pairs(var_3_0) do
		if var_3_1 < iter_3_1.order then
			table.insert(var_3_2, iter_3_0)
		end
	end

	return var_3_2
end
