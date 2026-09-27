-- chunkname: @scripts/managers/game_mode/mechanisms/deus_weapon_generation.lua

require("scripts/settings/dlcs/morris/deus_weapons")
require("scripts/helpers/deus_gen_utils")

local num = 100000
local tbl = {}

for k, v in pairs(DeusDropRarityWeights) do
	local tbl_2 = {}
	local count = #v.plentiful

	for k_2 = 1, count do
		local num_2 = 0

		for k_3, v_2 in pairs(v) do
			num_2 = num_2 + v_2[k_2]
		end

		for k_4, v_3 in pairs(v) do
			local var_0_5 = tbl_2[k_4]

			var_0_5 = var_0_5 or {}
			tbl_2[k_4] = var_0_5
			tbl_2[k_4][k_2] = v_3[k_2] / num_2
		end
	end

	tbl[k] = tbl_2
end

local function fn(arg_1_0, arg_1_1, arg_1_2)
	-- function 1
	fassert(not (arg_1_2 < 1) or arg_1_2 >= 0, "Run progress should never be equal or higher than 1.0")

	local var_1_0 = tbl[arg_1_1]

	var_1_0 = var_1_0 or tbl.default

	local var_1_1
	local num = 0

	for k, v in pairs(var_1_0) do
		var_1_1 = var_1_1 or math.floor(#v * arg_1_2 + 1)
		num = num + v[var_1_1]
	end

	local var_1_3 = arg_1_0(1, num * 100)
	local num_2 = 0

	for k_2, v_2 in pairs(var_1_0) do
		num_2 = num_2 + v_2[var_1_1] * 100

		if var_1_3 <= num_2 then
			return k_2
		end
	end

	fassert(false, "shouldn't happen, something wrong with the code")
end

local function fn_2(arg_2_0, arg_2_1, arg_2_2)
	-- function 2
	local var_2_0 = DeusDropPowerlevelRanges[arg_2_1]

	var_2_0 = var_2_0 or DeusDropPowerlevelRanges.default

	local var_2_1 = var_2_0[arg_2_0][1]
	local var_2_2 = var_2_0[arg_2_0][2]

	return math.ceil(math.lerp(var_2_1, var_2_2, arg_2_2))
end

local function fn_3(arg_3_0, arg_3_1, arg_3_2)
	-- function 3
	local num = 1 / table.size(arg_3_0)
	local num_2 = 0
	local num_3 = 0
	local DeusWeaponGroups = DeusWeaponGroups

	for k, v in pairs(arg_3_0) do
		if DeusWeaponGroups[k].slot_type == "melee" then
			num_2 = num_2 + num
		else
			num_3 = num_3 + num
		end
	end

	return num_2 * arg_3_1, num_3 * arg_3_2
end

local function fn_4(arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4)
	-- function 4
	local var_4_0, var_4_1 = fn_3(arg_4_2[arg_4_0], arg_4_3, arg_4_4)
	local var_4_2

	if not (not (var_4_0 > 0) or not (var_4_1 > 0)) then
		var_4_2 = not (var_4_0 > arg_4_1(0, var_4_0 + var_4_1)) or not "melee" or "ranged"
	else
		var_4_2 = not (var_4_0 > 0) or not "melee" or "ranged"
	end

	return var_4_2
end

local function fn_5(arg_5_0, arg_5_1, arg_5_2, arg_5_3)
	-- function 5
	local tbl = {}
	local DeusWeaponGroups = DeusWeaponGroups

	for k, v in pairs(arg_5_2[arg_5_1]) do
		if DeusWeaponGroups[k].slot_type == arg_5_0 then
			table.insert(tbl, v)
		end
	end

	fassert(#tbl > 0, "Failed to generate a weapon due to weapon_pool state : " .. table.tostring(arg_5_2))

	return tbl[arg_5_3(1, #tbl)]
end

local tbl_3 = {}

local function fn_6(arg_6_0, arg_6_1)
	-- function 6
	local var_6_0 = DeusWeapons[arg_6_0]
	local var_6_1 = ItemMasterList[var_6_0.base_item]
	local var_6_2

	if not var_6_0.fixed_skin then
		var_6_2 = {
			var_6_0.fixed_skin
		}
	elseif not var_6_1.skin_combination_table then
		local skin_combination_table = var_6_1.skin_combination_table
		local var_6_4

		if not tbl_3[skin_combination_table] then
			var_6_4 = tbl_3[skin_combination_table]
		else
			local var_6_5 = WeaponSkins.skin_combinations[skin_combination_table]

			if not var_6_5 then
				var_6_4 = table.clone(var_6_5)
				tbl_3[skin_combination_table] = var_6_4
			end
		end

		var_6_2 = not var_6_4 and var_6_4[arg_6_1]
	end

	if not var_6_2 then
		local get_unlocked_weapon_skins = Managers.backend:get_interface("crafting"):get_unlocked_weapon_skins()

		for i = #var_6_2, 1, -1 do
			if not get_unlocked_weapon_skins[var_6_2[i]] then
				table.remove(var_6_2, i)
			end
		end
	end

	return var_6_2
end

local function fn_7(arg_7_0, arg_7_1)
	-- function 7
	local var_7_0 = DeusWeapons[arg_7_0]
	local var_7_1 = WeaponProperties.combinations[var_7_0.property_table_name]

	return not var_7_1 and var_7_1[arg_7_1]
end

local function fn_8(arg_8_0, arg_8_1)
	-- function 8
	if not (arg_8_1 == "exotic" or arg_8_1 == "unique") then
		return
	end

	local var_8_0 = DeusWeapons[arg_8_0]
	local var_8_1

	return var_8_0.baked_trait_combinations
end

local function fn_9(arg_9_0)
	-- function 9
	return DeusWeapons[arg_9_0].archetypes
end

local function fn_10(arg_10_0, arg_10_1, arg_10_2, arg_10_3, arg_10_4, arg_10_5)
	-- function 10
	local var_10_0 = DeusWeapons[arg_10_0]
	local var_10_1 = ItemMasterList[var_10_0.base_item]
	local tbl = {
		power_level = arg_10_4,
		data = var_10_1,
		rarity = arg_10_5,
		key = var_10_0.base_item,
		deus_item_key = arg_10_0,
		properties = arg_10_1,
		traits = arg_10_2,
		skin = arg_10_3
	}

	tbl.bypass_skin_ownership_check = true

	return tbl
end

local function fn_11(arg_11_0, arg_11_1, arg_11_2, arg_11_3, arg_11_4)
	-- function 11
	local var_11_0 = fn_2(arg_11_3, arg_11_1, arg_11_2)
	local var_11_1 = fn_9(arg_11_0)
	local var_11_2
	local var_11_3

	if not var_11_1 then
		local var_11_4 = arg_11_4(1, #var_11_1)
		local var_11_5 = DeusWeaponArchetypes[var_11_1[var_11_4]]

		var_11_2 = var_11_5.properties
		var_11_3 = var_11_5.traits
	else
		local var_11_6 = fn_7(arg_11_0, arg_11_3)

		if not (not var_11_6 and not (#var_11_6 > 0)) then
			local var_11_7 = var_11_6[arg_11_4(1, #var_11_6)]

			var_11_2 = {}

			for i, v in ipairs(var_11_7) do
				local var_11_8
				local flag

				flag = arg_11_3 ~= "unique" or not 1 or arg_11_4(1, 100) / 100
				var_11_2[v] = flag
			end
		end

		local var_11_10 = fn_8(arg_11_0, arg_11_3)

		if not (not var_11_10 and not (#var_11_10 > 0)) then
			local var_11_11 = var_11_10[arg_11_4(1, #var_11_10)]

			var_11_3 = {}

			for i_2, v_2 in ipairs(var_11_11) do
				var_11_3[#var_11_3 + 1] = v_2
			end
		end
	end

	local var_11_12 = fn_6(arg_11_0, arg_11_3)
	local var_11_13

	if not (not var_11_12 and not (#var_11_12 > 0)) then
		var_11_13 = var_11_12[arg_11_4(1, #var_11_12)]

		if not var_11_13 then
			-- Nothing
		end
	end

	var_11_13 = nil

	::label_11_0::

	return fn_10(arg_11_0, var_11_2, var_11_3, var_11_13, var_11_0, arg_11_3)
end

local function fn_12(self, arg_12_1, arg_12_2, arg_12_3, arg_12_4)
	-- function 12
	local var_12_0 = fn_2(arg_12_3, arg_12_1, arg_12_2)
	local deus_item_key = self.deus_item_key
	local tbl = {}
	local properties = self.properties

	properties = properties or {}

	local tbl_2 = {}
	local traits = self.traits

	traits = traits or {}

	local var_12_6 = fn_7(deus_item_key, arg_12_3)

	var_12_6 = var_12_6 or {}

	local tbl_3 = {}

	for i, v in ipairs(var_12_6) do
		local flag = true

		for k, v_2 in pairs(properties) do
			flag = not flag and table.contains(v, k)
		end

		if not flag then
			table.insert(tbl_3, v)
		end
	end

	if #tbl_3 > 0 then
		local var_12_9 = tbl_3[arg_12_4(1, #tbl_3)]

		for i_2, v_3 in ipairs(var_12_9) do
			local var_12_10
			local contains = table.contains(table.keys(properties), v_3)

			if arg_12_3 == "unique" then
				var_12_10 = 1
			elseif not contains then
				var_12_10 = properties[v_3]
			else
				var_12_10 = arg_12_4(1, 100) / 100
			end

			tbl[v_3] = var_12_10
		end
	end

	local var_12_12 = fn_8(deus_item_key, arg_12_3)

	var_12_12 = var_12_12 or {}

	local tbl_4 = {}

	for i_3, v_4 in ipairs(var_12_12) do
		local flag_2 = true

		for i_4, v_5 in ipairs(traits) do
			flag_2 = not flag_2 and table.contains(v_4, v_5)
		end

		if not flag_2 then
			table.insert(tbl_4, v_4)
		end
	end

	if #tbl_4 > 0 then
		local var_12_15 = tbl_4[arg_12_4(1, #tbl_4)]

		for i_5, v_6 in ipairs(var_12_15) do
			tbl_2[#tbl_2 + 1] = v_6
		end
	end

	local var_12_16 = fn_6(deus_item_key, arg_12_3)
	local var_12_17

	if not (not var_12_16 and not (#var_12_16 > 0)) then
		var_12_17 = var_12_16[arg_12_4(1, #var_12_16)]

		if not var_12_17 then
			-- Nothing
		end
	end

	var_12_17 = nil

	::label_12_0::

	return fn_10(deus_item_key, tbl, tbl_2, var_12_17, var_12_0, arg_12_3)
end

local DeusWeaponGeneration = DeusWeaponGeneration

DeusWeaponGeneration = DeusWeaponGeneration or {}
DeusWeaponGeneration = DeusWeaponGeneration

DeusWeaponGeneration.serialize_weapon = function (self)
	-- function 13
	local tbl = {}

	fassert(self.deus_item_key, "weapon malformed.")

	tbl[#tbl + 1] = "item_key="
	tbl[#tbl + 1] = self.deus_item_key
	tbl[#tbl + 1] = ","
	tbl[#tbl + 1] = "powerlevel="
	tbl[#tbl + 1] = tostring(self.power_level)
	tbl[#tbl + 1] = ","
	tbl[#tbl + 1] = "rarity="
	tbl[#tbl + 1] = self.rarity

	if not self.skin then
		tbl[#tbl + 1] = ","
		tbl[#tbl + 1] = "skin="
		tbl[#tbl + 1] = self.skin
	end

	if not self.properties then
		for k, v in pairs(self.properties) do
			tbl[#tbl + 1] = ","
			tbl[#tbl + 1] = "property="
			tbl[#tbl + 1] = k
			tbl[#tbl + 1] = ":"
			tbl[#tbl + 1] = math.round(v * num)
		end
	end

	if not self.traits then
		for i, v_2 in ipairs(self.traits) do
			tbl[#tbl + 1] = ","
			tbl[#tbl + 1] = "trait="
			tbl[#tbl + 1] = v_2
		end
	end

	return table.concat(tbl)
end

DeusWeaponGeneration.deserialize_weapon = function (arg_14_0)
	-- function 14
	local var_14_0
	local var_14_1
	local var_14_2
	local var_14_3
	local var_14_4
	local var_14_5
	local split_deprecated = string.split_deprecated(arg_14_0, ",")

	for i, v in ipairs(split_deprecated) do
		local split_deprecated_2 = string.split_deprecated(v, "=")
		local var_14_8 = split_deprecated_2[1]
		local var_14_9 = split_deprecated_2[2]

		if var_14_8 == "item_key" then
			var_14_0 = var_14_9
		elseif var_14_8 == "skin" then
			var_14_3 = var_14_9
		elseif var_14_8 == "trait" then
			var_14_2 = var_14_2 or {}
			var_14_2[#var_14_2 + 1] = var_14_9
		elseif var_14_8 == "property" then
			local split_deprecated_3 = string.split_deprecated(var_14_9, ":")

			var_14_1 = var_14_1 or {}
			var_14_1[split_deprecated_3[1]] = tonumber(split_deprecated_3[2]) / num
		elseif var_14_8 == "powerlevel" then
			var_14_4 = tonumber(var_14_9)
		elseif var_14_8 == "rarity" then
			var_14_5 = var_14_9
		end
	end

	return fn_10(var_14_0, var_14_1, var_14_2, var_14_3, var_14_4, var_14_5)
end

DeusWeaponGeneration.create_weapon = function (arg_15_0, arg_15_1, arg_15_2, arg_15_3, arg_15_4, arg_15_5)
	-- function 15
	return fn_10(arg_15_0, arg_15_1, arg_15_2, arg_15_3, arg_15_4, arg_15_5)
end

DeusWeaponGeneration.get_possibilities_for_item_key = function (arg_16_0, arg_16_1, arg_16_2, arg_16_3)
	-- function 16
	local var_16_0 = fn_9(arg_16_0)
	local var_16_1 = fn_6(arg_16_0, arg_16_3)
	local var_16_2 = fn_2(arg_16_3, arg_16_1, arg_16_2)
	local var_16_3
	local var_16_4

	if not var_16_0 then
		var_16_3 = fn_7(arg_16_0, arg_16_3)
		var_16_4 = fn_8(arg_16_0, arg_16_3)
	end

	return var_16_2, var_16_0, var_16_3, var_16_4, not var_16_1 and #var_16_1 > 0 and var_16_1 and nil
end

DeusWeaponGeneration.generate_item_from_item_key = function (arg_17_0, arg_17_1, arg_17_2, arg_17_3, arg_17_4)
	-- function 17
	local create_random_generator = DeusGenUtils.create_random_generator(arg_17_4)

	return fn_11(arg_17_0, arg_17_1, arg_17_2, arg_17_3, create_random_generator)
end

DeusWeaponGeneration.get_random_rarity = function (arg_18_0, arg_18_1, arg_18_2)
	-- function 18
	local create_random_generator = DeusGenUtils.create_random_generator(arg_18_2)

	return fn(create_random_generator, arg_18_0, arg_18_1)
end

DeusWeaponGeneration.upgrade_item = function (arg_19_0, arg_19_1, arg_19_2, arg_19_3, arg_19_4)
	-- function 19
	local create_random_generator = DeusGenUtils.create_random_generator(arg_19_4)

	return fn_12(arg_19_0, arg_19_1, arg_19_2, arg_19_3, create_random_generator)
end

DeusWeaponGeneration.generate_weapon = function (arg_20_0, arg_20_1, arg_20_2, arg_20_3, arg_20_4, arg_20_5, arg_20_6)
	-- function 20
	local create_random_generator = DeusGenUtils.create_random_generator(arg_20_3)
	local var_20_1 = fn_4(arg_20_2, create_random_generator, arg_20_4, arg_20_5, arg_20_6)
	local var_20_2 = fn_5(var_20_1, arg_20_2, arg_20_4, create_random_generator)

	if not var_20_2 then
		return
	end

	return fn_11(var_20_2, arg_20_0, arg_20_1, arg_20_2, create_random_generator)
end

DeusWeaponGeneration.generate_weapon_for_slot = function (arg_21_0, arg_21_1, arg_21_2, arg_21_3, arg_21_4, arg_21_5)
	-- function 21
	local create_random_generator = DeusGenUtils.create_random_generator(arg_21_3)
	local var_21_1 = fn_5(arg_21_5, arg_21_2, arg_21_4, create_random_generator)

	if not var_21_1 then
		return
	end

	return fn_11(var_21_1, arg_21_0, arg_21_1, arg_21_2, create_random_generator)
end

DeusWeaponGeneration.generate_weapon_pool = function (arg_22_0, arg_22_1)
	-- function 22
	local tbl = {}

	for k, v in pairs(DeusDropRarityWeights) do
		for k_2 in pairs(v) do
			tbl[k_2] = {}
		end
	end

	for k_3, v_2 in pairs(DeusWeaponGroups) do
		local contains = table.contains(v_2.can_wield, arg_22_0)

		if not arg_22_1[k_3] and not contains then
			local default = v_2.default

			for k_4, v_3 in pairs(tbl) do
				v_3[k_3] = default
			end

			for k_5, v_4 in pairs(v_2.items_per_rarity) do
				for i, v_5 in ipairs(v_4) do
					tbl[k_5][k_3] = v_5
				end
			end
		end
	end

	return tbl
end

DeusWeaponGeneration.get_weapon_pool_slot_amounts = function (arg_23_0, arg_23_1)
	-- function 23
	local tbl = {}
	local DeusWeaponGroups = DeusWeaponGroups

	for k, v in pairs(arg_23_0) do
		for k_2, v_2 in pairs(v) do
			local slot_type = DeusWeaponGroups[k_2].slot_type
			local var_23_3 = tbl[k]

			var_23_3 = var_23_3 or {}
			tbl[k] = var_23_3

			local var_23_4 = tbl[k]
			local var_23_5 = tbl[k][slot_type]

			var_23_5 = var_23_5 or 0
			var_23_4[slot_type] = var_23_5

			if not (arg_23_1[k][k_2] ~= nil) then
				tbl[k][slot_type] = tbl[k][slot_type] + 1
			end
		end
	end

	return tbl
end
