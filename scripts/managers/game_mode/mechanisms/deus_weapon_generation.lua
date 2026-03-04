-- chunkname: @scripts/managers/game_mode/mechanisms/deus_weapon_generation.lua

require("scripts/settings/dlcs/morris/deus_weapons")
require("scripts/helpers/deus_gen_utils")

local var_0_0 = 100000
local var_0_1 = {}

for iter_0_0, iter_0_1 in pairs(DeusDropRarityWeights) do
	local var_0_2 = {}
	local var_0_3 = #iter_0_1.plentiful

	for iter_0_2 = 1, var_0_3 do
		local var_0_4 = 0

		for iter_0_3, iter_0_4 in pairs(iter_0_1) do
			var_0_4 = var_0_4 + iter_0_4[iter_0_2]
		end

		for iter_0_5, iter_0_6 in pairs(iter_0_1) do
			var_0_2[iter_0_5] = var_0_2[iter_0_5] or {}
			var_0_2[iter_0_5][iter_0_2] = iter_0_6[iter_0_2] / var_0_4
		end
	end

	var_0_1[iter_0_0] = var_0_2
end

local function var_0_5(arg_1_0, arg_1_1, arg_1_2)
	fassert(arg_1_2 < 1 and arg_1_2 >= 0, "Run progress should never be equal or higher than 1.0")

	local var_1_0 = var_0_1[arg_1_1] or var_0_1.default
	local var_1_1
	local var_1_2 = 0

	for iter_1_0, iter_1_1 in pairs(var_1_0) do
		var_1_1 = var_1_1 or math.floor(#iter_1_1 * arg_1_2 + 1)
		var_1_2 = var_1_2 + iter_1_1[var_1_1]
	end

	local var_1_3 = arg_1_0(1, var_1_2 * 100)
	local var_1_4 = 0

	for iter_1_2, iter_1_3 in pairs(var_1_0) do
		var_1_4 = var_1_4 + iter_1_3[var_1_1] * 100

		if var_1_3 <= var_1_4 then
			return iter_1_2
		end
	end

	fassert(false, "shouldn't happen, something wrong with the code")
end

local function var_0_6(arg_2_0, arg_2_1, arg_2_2)
	local var_2_0 = DeusDropPowerlevelRanges[arg_2_1] or DeusDropPowerlevelRanges.default
	local var_2_1 = var_2_0[arg_2_0][1]
	local var_2_2 = var_2_0[arg_2_0][2]

	return math.ceil(math.lerp(var_2_1, var_2_2, arg_2_2))
end

local function var_0_7(arg_3_0, arg_3_1, arg_3_2)
	local var_3_0 = 1 / table.size(arg_3_0)
	local var_3_1 = 0
	local var_3_2 = 0
	local var_3_3 = DeusWeaponGroups

	for iter_3_0, iter_3_1 in pairs(arg_3_0) do
		if var_3_3[iter_3_0].slot_type == "melee" then
			var_3_1 = var_3_1 + var_3_0
		else
			var_3_2 = var_3_2 + var_3_0
		end
	end

	return var_3_1 * arg_3_1, var_3_2 * arg_3_2
end

local function var_0_8(arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4)
	local var_4_0, var_4_1 = var_0_7(arg_4_2[arg_4_0], arg_4_3, arg_4_4)
	local var_4_2

	if var_4_0 > 0 and var_4_1 > 0 then
		var_4_2 = var_4_0 > arg_4_1(0, var_4_0 + var_4_1) and "melee" or "ranged"
	else
		var_4_2 = var_4_0 > 0 and "melee" or "ranged"
	end

	return var_4_2
end

local function var_0_9(arg_5_0, arg_5_1, arg_5_2, arg_5_3)
	local var_5_0 = {}
	local var_5_1 = DeusWeaponGroups

	for iter_5_0, iter_5_1 in pairs(arg_5_2[arg_5_1]) do
		if var_5_1[iter_5_0].slot_type == arg_5_0 then
			table.insert(var_5_0, iter_5_1)
		end
	end

	fassert(#var_5_0 > 0, "Failed to generate a weapon due to weapon_pool state : " .. table.tostring(arg_5_2))

	return var_5_0[arg_5_3(1, #var_5_0)]
end

local var_0_10 = {}

local function var_0_11(arg_6_0, arg_6_1)
	local var_6_0 = DeusWeapons[arg_6_0]
	local var_6_1 = ItemMasterList[var_6_0.base_item]
	local var_6_2

	if var_6_0.fixed_skin then
		var_6_2 = {
			var_6_0.fixed_skin
		}
	elseif var_6_1.skin_combination_table then
		local var_6_3 = var_6_1.skin_combination_table
		local var_6_4

		if var_0_10[var_6_3] then
			var_6_4 = var_0_10[var_6_3]
		else
			local var_6_5 = WeaponSkins.skin_combinations[var_6_3]

			if var_6_5 then
				var_6_4 = table.clone(var_6_5)
				var_0_10[var_6_3] = var_6_4
			end
		end

		var_6_2 = var_6_4 and var_6_4[arg_6_1]
	end

	if var_6_2 then
		local var_6_6 = Managers.backend:get_interface("crafting"):get_unlocked_weapon_skins()

		for iter_6_0 = #var_6_2, 1, -1 do
			if not var_6_6[var_6_2[iter_6_0]] then
				table.remove(var_6_2, iter_6_0)
			end
		end
	end

	return var_6_2
end

local function var_0_12(arg_7_0, arg_7_1)
	local var_7_0 = DeusWeapons[arg_7_0]
	local var_7_1 = WeaponProperties.combinations[var_7_0.property_table_name]

	return var_7_1 and var_7_1[arg_7_1]
end

local function var_0_13(arg_8_0, arg_8_1)
	if arg_8_1 ~= "exotic" and arg_8_1 ~= "unique" then
		return
	end

	local var_8_0 = DeusWeapons[arg_8_0]
	local var_8_1

	return var_8_0.baked_trait_combinations
end

local function var_0_14(arg_9_0)
	return DeusWeapons[arg_9_0].archetypes
end

local function var_0_15(arg_10_0, arg_10_1, arg_10_2, arg_10_3, arg_10_4, arg_10_5)
	local var_10_0 = DeusWeapons[arg_10_0]
	local var_10_1 = ItemMasterList[var_10_0.base_item]
	local var_10_2 = {
		power_level = arg_10_4,
		data = var_10_1,
		rarity = arg_10_5,
		key = var_10_0.base_item,
		deus_item_key = arg_10_0,
		properties = arg_10_1,
		traits = arg_10_2,
		skin = arg_10_3
	}

	var_10_2.bypass_skin_ownership_check = true

	return var_10_2
end

local function var_0_16(arg_11_0, arg_11_1, arg_11_2, arg_11_3, arg_11_4)
	local var_11_0 = var_0_6(arg_11_3, arg_11_1, arg_11_2)
	local var_11_1 = var_0_14(arg_11_0)
	local var_11_2
	local var_11_3

	if var_11_1 then
		local var_11_4 = arg_11_4(1, #var_11_1)
		local var_11_5 = DeusWeaponArchetypes[var_11_1[var_11_4]]

		var_11_2 = var_11_5.properties
		var_11_3 = var_11_5.traits
	else
		local var_11_6 = var_0_12(arg_11_0, arg_11_3)

		if var_11_6 and #var_11_6 > 0 then
			local var_11_7 = var_11_6[arg_11_4(1, #var_11_6)]

			var_11_2 = {}

			for iter_11_0, iter_11_1 in ipairs(var_11_7) do
				local var_11_8

				var_11_2[iter_11_1] = arg_11_3 == "unique" and 1 or arg_11_4(1, 100) / 100
			end
		end

		local var_11_9 = var_0_13(arg_11_0, arg_11_3)

		if var_11_9 and #var_11_9 > 0 then
			local var_11_10 = var_11_9[arg_11_4(1, #var_11_9)]

			var_11_3 = {}

			for iter_11_2, iter_11_3 in ipairs(var_11_10) do
				var_11_3[#var_11_3 + 1] = iter_11_3
			end
		end
	end

	local var_11_11 = var_0_11(arg_11_0, arg_11_3)
	local var_11_12 = var_11_11 and #var_11_11 > 0 and var_11_11[arg_11_4(1, #var_11_11)] or nil

	return var_0_15(arg_11_0, var_11_2, var_11_3, var_11_12, var_11_0, arg_11_3)
end

local function var_0_17(arg_12_0, arg_12_1, arg_12_2, arg_12_3, arg_12_4)
	local var_12_0 = var_0_6(arg_12_3, arg_12_1, arg_12_2)
	local var_12_1 = arg_12_0.deus_item_key
	local var_12_2 = {}
	local var_12_3 = arg_12_0.properties or {}
	local var_12_4 = {}
	local var_12_5 = arg_12_0.traits or {}
	local var_12_6 = var_0_12(var_12_1, arg_12_3) or {}
	local var_12_7 = {}

	for iter_12_0, iter_12_1 in ipairs(var_12_6) do
		local var_12_8 = true

		for iter_12_2, iter_12_3 in pairs(var_12_3) do
			var_12_8 = var_12_8 and table.contains(iter_12_1, iter_12_2)
		end

		if var_12_8 then
			table.insert(var_12_7, iter_12_1)
		end
	end

	if #var_12_7 > 0 then
		local var_12_9 = var_12_7[arg_12_4(1, #var_12_7)]

		for iter_12_4, iter_12_5 in ipairs(var_12_9) do
			local var_12_10
			local var_12_11 = table.contains(table.keys(var_12_3), iter_12_5)

			if arg_12_3 == "unique" then
				var_12_10 = 1
			elseif var_12_11 then
				var_12_10 = var_12_3[iter_12_5]
			else
				var_12_10 = arg_12_4(1, 100) / 100
			end

			var_12_2[iter_12_5] = var_12_10
		end
	end

	local var_12_12 = var_0_13(var_12_1, arg_12_3) or {}
	local var_12_13 = {}

	for iter_12_6, iter_12_7 in ipairs(var_12_12) do
		local var_12_14 = true

		for iter_12_8, iter_12_9 in ipairs(var_12_5) do
			var_12_14 = var_12_14 and table.contains(iter_12_7, iter_12_9)
		end

		if var_12_14 then
			table.insert(var_12_13, iter_12_7)
		end
	end

	if #var_12_13 > 0 then
		local var_12_15 = var_12_13[arg_12_4(1, #var_12_13)]

		for iter_12_10, iter_12_11 in ipairs(var_12_15) do
			var_12_4[#var_12_4 + 1] = iter_12_11
		end
	end

	local var_12_16 = var_0_11(var_12_1, arg_12_3)
	local var_12_17 = var_12_16 and #var_12_16 > 0 and var_12_16[arg_12_4(1, #var_12_16)] or nil

	return var_0_15(var_12_1, var_12_2, var_12_4, var_12_17, var_12_0, arg_12_3)
end

DeusWeaponGeneration = DeusWeaponGeneration or {}

DeusWeaponGeneration.serialize_weapon = function (arg_13_0)
	local var_13_0 = {}

	fassert(arg_13_0.deus_item_key, "weapon malformed.")

	var_13_0[#var_13_0 + 1] = "item_key="
	var_13_0[#var_13_0 + 1] = arg_13_0.deus_item_key
	var_13_0[#var_13_0 + 1] = ","
	var_13_0[#var_13_0 + 1] = "powerlevel="
	var_13_0[#var_13_0 + 1] = tostring(arg_13_0.power_level)
	var_13_0[#var_13_0 + 1] = ","
	var_13_0[#var_13_0 + 1] = "rarity="
	var_13_0[#var_13_0 + 1] = arg_13_0.rarity

	if arg_13_0.skin then
		var_13_0[#var_13_0 + 1] = ","
		var_13_0[#var_13_0 + 1] = "skin="
		var_13_0[#var_13_0 + 1] = arg_13_0.skin
	end

	if arg_13_0.properties then
		for iter_13_0, iter_13_1 in pairs(arg_13_0.properties) do
			var_13_0[#var_13_0 + 1] = ","
			var_13_0[#var_13_0 + 1] = "property="
			var_13_0[#var_13_0 + 1] = iter_13_0
			var_13_0[#var_13_0 + 1] = ":"
			var_13_0[#var_13_0 + 1] = math.round(iter_13_1 * var_0_0)
		end
	end

	if arg_13_0.traits then
		for iter_13_2, iter_13_3 in ipairs(arg_13_0.traits) do
			var_13_0[#var_13_0 + 1] = ","
			var_13_0[#var_13_0 + 1] = "trait="
			var_13_0[#var_13_0 + 1] = iter_13_3
		end
	end

	return table.concat(var_13_0)
end

DeusWeaponGeneration.deserialize_weapon = function (arg_14_0)
	local var_14_0
	local var_14_1
	local var_14_2
	local var_14_3
	local var_14_4
	local var_14_5
	local var_14_6 = string.split_deprecated(arg_14_0, ",")

	for iter_14_0, iter_14_1 in ipairs(var_14_6) do
		local var_14_7 = string.split_deprecated(iter_14_1, "=")
		local var_14_8 = var_14_7[1]
		local var_14_9 = var_14_7[2]

		if var_14_8 == "item_key" then
			var_14_0 = var_14_9
		elseif var_14_8 == "skin" then
			var_14_3 = var_14_9
		elseif var_14_8 == "trait" then
			var_14_2 = var_14_2 or {}
			var_14_2[#var_14_2 + 1] = var_14_9
		elseif var_14_8 == "property" then
			local var_14_10 = string.split_deprecated(var_14_9, ":")

			var_14_1 = var_14_1 or {}
			var_14_1[var_14_10[1]] = tonumber(var_14_10[2]) / var_0_0
		elseif var_14_8 == "powerlevel" then
			var_14_4 = tonumber(var_14_9)
		elseif var_14_8 == "rarity" then
			var_14_5 = var_14_9
		end
	end

	return var_0_15(var_14_0, var_14_1, var_14_2, var_14_3, var_14_4, var_14_5)
end

DeusWeaponGeneration.create_weapon = function (arg_15_0, arg_15_1, arg_15_2, arg_15_3, arg_15_4, arg_15_5)
	return var_0_15(arg_15_0, arg_15_1, arg_15_2, arg_15_3, arg_15_4, arg_15_5)
end

DeusWeaponGeneration.get_possibilities_for_item_key = function (arg_16_0, arg_16_1, arg_16_2, arg_16_3)
	local var_16_0 = var_0_14(arg_16_0)
	local var_16_1 = var_0_11(arg_16_0, arg_16_3)
	local var_16_2 = var_0_6(arg_16_3, arg_16_1, arg_16_2)
	local var_16_3
	local var_16_4

	if not var_16_0 then
		var_16_3 = var_0_12(arg_16_0, arg_16_3)
		var_16_4 = var_0_13(arg_16_0, arg_16_3)
	end

	return var_16_2, var_16_0, var_16_3, var_16_4, var_16_1 and #var_16_1 > 0 and var_16_1 or nil
end

DeusWeaponGeneration.generate_item_from_item_key = function (arg_17_0, arg_17_1, arg_17_2, arg_17_3, arg_17_4)
	local var_17_0 = DeusGenUtils.create_random_generator(arg_17_4)

	return var_0_16(arg_17_0, arg_17_1, arg_17_2, arg_17_3, var_17_0)
end

DeusWeaponGeneration.get_random_rarity = function (arg_18_0, arg_18_1, arg_18_2)
	local var_18_0 = DeusGenUtils.create_random_generator(arg_18_2)

	return var_0_5(var_18_0, arg_18_0, arg_18_1)
end

DeusWeaponGeneration.upgrade_item = function (arg_19_0, arg_19_1, arg_19_2, arg_19_3, arg_19_4)
	local var_19_0 = DeusGenUtils.create_random_generator(arg_19_4)

	return var_0_17(arg_19_0, arg_19_1, arg_19_2, arg_19_3, var_19_0)
end

DeusWeaponGeneration.generate_weapon = function (arg_20_0, arg_20_1, arg_20_2, arg_20_3, arg_20_4, arg_20_5, arg_20_6)
	local var_20_0 = DeusGenUtils.create_random_generator(arg_20_3)
	local var_20_1 = var_0_8(arg_20_2, var_20_0, arg_20_4, arg_20_5, arg_20_6)
	local var_20_2 = var_0_9(var_20_1, arg_20_2, arg_20_4, var_20_0)

	if not var_20_2 then
		return
	end

	return var_0_16(var_20_2, arg_20_0, arg_20_1, arg_20_2, var_20_0)
end

DeusWeaponGeneration.generate_weapon_for_slot = function (arg_21_0, arg_21_1, arg_21_2, arg_21_3, arg_21_4, arg_21_5)
	local var_21_0 = DeusGenUtils.create_random_generator(arg_21_3)
	local var_21_1 = var_0_9(arg_21_5, arg_21_2, arg_21_4, var_21_0)

	if not var_21_1 then
		return
	end

	return var_0_16(var_21_1, arg_21_0, arg_21_1, arg_21_2, var_21_0)
end

DeusWeaponGeneration.generate_weapon_pool = function (arg_22_0, arg_22_1)
	local var_22_0 = {}

	for iter_22_0, iter_22_1 in pairs(DeusDropRarityWeights) do
		for iter_22_2 in pairs(iter_22_1) do
			var_22_0[iter_22_2] = {}
		end
	end

	for iter_22_3, iter_22_4 in pairs(DeusWeaponGroups) do
		local var_22_1 = table.contains(iter_22_4.can_wield, arg_22_0)

		if arg_22_1[iter_22_3] and var_22_1 then
			local var_22_2 = iter_22_4.default

			for iter_22_5, iter_22_6 in pairs(var_22_0) do
				iter_22_6[iter_22_3] = var_22_2
			end

			for iter_22_7, iter_22_8 in pairs(iter_22_4.items_per_rarity) do
				for iter_22_9, iter_22_10 in ipairs(iter_22_8) do
					var_22_0[iter_22_7][iter_22_3] = iter_22_10
				end
			end
		end
	end

	return var_22_0
end

DeusWeaponGeneration.get_weapon_pool_slot_amounts = function (arg_23_0, arg_23_1)
	local var_23_0 = {}
	local var_23_1 = DeusWeaponGroups

	for iter_23_0, iter_23_1 in pairs(arg_23_0) do
		for iter_23_2, iter_23_3 in pairs(iter_23_1) do
			local var_23_2 = var_23_1[iter_23_2].slot_type

			var_23_0[iter_23_0] = var_23_0[iter_23_0] or {}
			var_23_0[iter_23_0][var_23_2] = var_23_0[iter_23_0][var_23_2] or 0

			if arg_23_1[iter_23_0][iter_23_2] ~= nil then
				var_23_0[iter_23_0][var_23_2] = var_23_0[iter_23_0][var_23_2] + 1
			end
		end
	end

	return var_23_0
end
