-- chunkname: @scripts/helpers/rarity_utils.lua

require("scripts/settings/dlcs/morris/rarity_settings")

local RarityUtils = RarityUtils

RarityUtils = RarityUtils or {}
RarityUtils = RarityUtils

RarityUtils.get_previous_rarity = function (arg_1_0)
	-- function 1
	local RaritySettings = RaritySettings
	local order = RaritySettings[arg_1_0].order
	local var_1_2 = arg_1_0
	local num = 0

	for k, v in pairs(RaritySettings) do
		if not (not (order > v.order) or not (num < v.order)) then
			var_1_2 = k
			num = RaritySettings[var_1_2].order
		end
	end

	local flag = var_1_2 ~= arg_1_0

	return var_1_2, flag
end

RarityUtils.get_lower_rarities = function (arg_2_0)
	-- function 2
	local RaritySettings = RaritySettings
	local order = RaritySettings[arg_2_0].order
	local tbl = {}

	for k, v in pairs(RaritySettings) do
		if order > v.order then
			table.insert(tbl, k)
		end
	end

	return tbl
end

RarityUtils.get_higher_rarities = function (arg_3_0)
	-- function 3
	local RaritySettings = RaritySettings
	local order = RaritySettings[arg_3_0].order
	local tbl = {}

	for k, v in pairs(RaritySettings) do
		if order < v.order then
			table.insert(tbl, k)
		end
	end

	return tbl
end
