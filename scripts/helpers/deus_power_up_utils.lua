-- chunkname: @scripts/helpers/deus_power_up_utils.lua

require("scripts/settings/dlcs/morris/deus_power_up_settings")

local scripts_utils_byte_array = require("scripts/utils/byte_array")
local scripts_utils_lib_deflate = require("scripts/utils/lib_deflate")
local PowerUpClientIdCount = PowerUpClientIdCount

PowerUpClientIdCount = PowerUpClientIdCount or 0
PowerUpClientIdCount = PowerUpClientIdCount

local function fn()
	-- function 1
	return math.random_seed()
end

local function fn_2(arg_2_0, arg_2_1, arg_2_2, arg_2_3)
	-- function 2
	if not table.is_empty(arg_2_1) then
		return arg_2_0, nil
	end

	local var_2_0
	local var_2_1

	arg_2_0, var_2_1 = Math.next_random(arg_2_0)

	if arg_2_3 == 0 then
		return arg_2_0, nil
	end

	local num = 0
	local num_2 = 1 / arg_2_3

	for i = 1, #arg_2_1 do
		local var_2_4 = arg_2_1[i]

		num = num + arg_2_2[i] * num_2

		if var_2_1 < num then
			return arg_2_0, var_2_4
		end
	end

	return arg_2_0, arg_2_1[#arg_2_1]
end

local function fn_3(arg_3_0)
	-- function 3
	local tbl = {}
	local tbl_2 = {}

	for k, v in pairs(arg_3_0) do
		for k_2, v_2 in pairs(v) do
			local var_3_2 = tbl_2[k_2]

			var_3_2 = var_3_2 or v_2.max_amount

			local num = var_3_2 - 1

			tbl_2[k_2] = num

			if num <= 0 then
				tbl[k_2] = true
			end
		end
	end

	return tbl
end

local function fn_4(arg_4_0, arg_4_1, arg_4_2)
	-- function 4
	local default = arg_4_2.default

	if not default and not table.contains(default, arg_4_1) then
		return true
	end

	local var_4_1 = arg_4_2[arg_4_0]

	if not var_4_1 and not table.contains(var_4_1, arg_4_1) then
		return true
	end

	return false
end

local function fn_5(self)
	-- function 5
	if not table.is_empty(self) then
		return true
	end

	for i = 1, #self do
		if not Managers.state.game_mode:has_activated_mutator(self[i]) then
			return true
		end
	end

	return false
end

local function fn_6(arg_6_0, arg_6_1, arg_6_2)
	-- function 6
	local incompatibility = arg_6_2.incompatibility
	local name = arg_6_2.name

	for k, v in pairs(arg_6_1) do
		for k_2, v_2 in pairs(v) do
			local incompatibility_2 = v_2.incompatibility

			if not incompatibility_2 and not fn_4(arg_6_0, name, incompatibility_2) then
				return true
			end

			if not incompatibility and not fn_4(arg_6_0, k_2, incompatibility) then
				return true
			end
		end
	end

	return false
end

local function fn_7(arg_7_0, arg_7_1, arg_7_2, arg_7_3, arg_7_4)
	-- function 7
	local tbl = {}

	for i, v in ipairs(arg_7_1) do
		tbl[v.name] = true
	end

	local var_7_1 = fn_3(arg_7_2)

	for k, v_2 in pairs(var_7_1) do
		tbl[k] = true
	end

	local var_7_2 = DeusPowerUpExclusionList[arg_7_0]

	var_7_2 = var_7_2 or {}

	for k_2, v_3 in pairs(var_7_2) do
		tbl[k_2] = true
	end

	local num_set_boons_weight_multiplier = DeusPowerUpSettings.num_set_boons_weight_multiplier
	local num = 0
	local tbl_2 = {}
	local tbl_3 = {}
	local var_7_7 = DeusPowerUpsArrayByRarity[arg_7_3]

	if not var_7_7 then
		var_7_7 = DeusPowerUpsArray
		var_7_7 = var_7_7 or {}
	end

	for i_2, v_4 in ipairs(var_7_7) do
		local name = v_4.name
		local var_7_9 = DeusPowerUps[v_4.rarity][name]
		local name_2 = var_7_9.name

		if not ((tbl[name_2] or not fn_5(var_7_9.mutators) or not table.contains(var_7_9.availability, arg_7_4)) and fn_6(arg_7_0, arg_7_2, v_4)) then
			table.insert(tbl_3, var_7_9)

			local weight = var_7_9.weight
			local var_7_12 = DeusPowerUpSetLookup[var_7_9.rarity][name_2]

			if not var_7_12 then
				local num_2 = 1

				for i8 = 1, #var_7_12 do
					local var_7_14 = var_7_12[i8]

					for i9 = 1, #var_7_14.pieces do
						local var_7_15 = var_7_14.pieces[i9]

						if not arg_7_2[var_7_15.rarity][var_7_15.name] then
							num_2 = num_2 + (num_set_boons_weight_multiplier - 1)
						end
					end
				end

				weight = weight * num_2
			end

			num = num + weight

			table.insert(tbl_2, weight)
		end
	end

	return tbl_3, tbl_2, num
end

local select_map = table.select_map(table.set(DeusPowerUpRarities), function (arg_8_0, arg_8_1)
	-- function 8
	return {}
end)

local function fn_8(arg_9_0, arg_9_1, arg_9_2, arg_9_3, arg_9_4, arg_9_5, arg_9_6, arg_9_7)
	-- function 9
	local var_9_0
	local var_9_1
	local var_9_2

	for i = 1, #arg_9_2 do
		local var_9_3 = arg_9_2[i]

		select_map[var_9_3.rarity][var_9_3.name] = DeusPowerUps[var_9_3.rarity][var_9_3.name]
	end

	if not arg_9_7 then
		local index_of = table.index_of(DeusPowerUpRarities, arg_9_7)

		for j = index_of, 1, -1 do
			arg_9_7 = DeusPowerUpRarities[j]
			var_9_0, var_9_1, var_9_2 = fn_7(arg_9_6, arg_9_1, select_map, arg_9_7, arg_9_5)

			if #var_9_0 > 0 then
				break
			end
		end

		if #var_9_0 == 0 then
			for k = index_of + 1, #DeusPowerUpRarities do
				arg_9_7 = DeusPowerUpRarities[k]
				var_9_0, var_9_1, var_9_2 = fn_7(arg_9_6, arg_9_1, select_map, arg_9_7, arg_9_5)

				if #var_9_0 > 0 then
					break
				end
			end
		end

		fassert(#var_9_0 > 0, "not enough power_ups left in the pool")
	else
		var_9_0, var_9_1, var_9_2 = fn_7(arg_9_6, arg_9_1, select_map, nil, arg_9_5)
	end

	local var_9_5
	local var_9_6

	arg_9_0, var_9_6 = fn_2(arg_9_0, var_9_0, var_9_1, var_9_2)

	if not var_9_6 then
		return
	end

	local tbl = {
		name = var_9_6.name,
		rarity = var_9_6.rarity,
		client_id = fn()
	}

	for k_2 in pairs(select_map) do
		table.clear(select_map[k_2])
	end

	return arg_9_0, tbl
end

local function fn_9(arg_10_0, arg_10_1)
	-- function 10
	return {
		name = arg_10_0,
		rarity = arg_10_1,
		client_id = fn()
	}
end

local function fn_10(arg_11_0)
	-- function 11
	local var_11_0 = DeusPowerUpTemplates[arg_11_0]
	local display_name = var_11_0.display_name
	local description_values = var_11_0.description_values

	return UIUtils.format_localized_description(display_name, description_values)
end

local DeusPowerUpUtils = DeusPowerUpUtils

DeusPowerUpUtils = DeusPowerUpUtils or {}
DeusPowerUpUtils = DeusPowerUpUtils

DeusPowerUpUtils.get_talent_from_power_up = function (arg_12_0, arg_12_1, arg_12_2, arg_12_3)
	-- function 12
	local var_12_0 = SPProfiles[arg_12_2].careers[arg_12_3]
	local profile_name = var_12_0.profile_name
	local talent_tree_index = var_12_0.talent_tree_index
	local var_12_3 = TalentTrees[profile_name][talent_tree_index][arg_12_1][arg_12_0]
	local var_12_4 = TalentIDLookup[var_12_3]

	return TalentUtils.get_talent_by_id(profile_name, var_12_4.talent_id)
end

DeusPowerUpUtils.get_talent_power_up_from_tier_and_column = function (arg_13_0, arg_13_1)
	-- function 13
	local var_13_0 = DeusPowerUpTalentLookup[arg_13_0][arg_13_1]

	for k, v in pairs(DeusPowerUps) do
		local var_13_1 = v[var_13_0]

		if not var_13_1 then
			return var_13_1, k
		end
	end

	ferror("could not find power_up for tier %s and column %s", arg_13_0, arg_13_1)
end

DeusPowerUpUtils.get_power_up_description = function (self, arg_14_1, arg_14_2)
	-- function 14
	local var_14_0 = DeusPowerUps[self.rarity][self.name]

	if not var_14_0.talent then
		local get_talent_from_power_up = DeusPowerUpUtils.get_talent_from_power_up(var_14_0.talent_index, var_14_0.talent_tier, arg_14_1, arg_14_2)

		return UIUtils.get_talent_description(get_talent_from_power_up)
	else
		return (UIUtils.get_trait_description(nil, var_14_0))
	end
end

DeusPowerUpUtils.get_power_up_icon = function (self, arg_15_1, arg_15_2)
	-- function 15
	local var_15_0 = DeusPowerUps[self.rarity][self.name]

	if not var_15_0.talent then
		return DeusPowerUpUtils.get_talent_from_power_up(var_15_0.talent_index, var_15_0.talent_tier, arg_15_1, arg_15_2).icon
	else
		return var_15_0.icon
	end
end

DeusPowerUpUtils.get_power_up_name_text = function (arg_16_0, arg_16_1, arg_16_2, arg_16_3, arg_16_4)
	-- function 16
	local var_16_0
	local str = ""

	if not arg_16_1 and not arg_16_2 then
		local get_talent_from_power_up = DeusPowerUpUtils.get_talent_from_power_up(arg_16_1, arg_16_2, arg_16_3, arg_16_4)
		local Localize = Localize
		local display_name = get_talent_from_power_up.display_name

		display_name = display_name or get_talent_from_power_up.name
		var_16_0 = Localize(display_name)
	else
		var_16_0 = fn_10(arg_16_0)
	end

	return var_16_0, str
end

DeusPowerUpUtils.power_ups_to_string = function (arg_17_0)
	-- function 17
	local tbl = {}

	for i, v in ipairs(arg_17_0) do
		table.insert(tbl, v.name)
		table.insert(tbl, "/")
		table.insert(tbl, v.rarity)
		table.insert(tbl, "/")
		table.insert(tbl, v.client_id)
		table.insert(tbl, ",")
	end

	return table.concat(tbl, "")
end

assert(table.size(DeusPowerUpTemplates) <= 256, "[DeusPowerUpUtils] Number of power ups exceeds expectation. Change 'ByteArray.write_uint8' to 'ByteArray.write_uint16' in DeusPowerUpUtils.power_ups_to_encoded_string, and it's counterpart 'encoded_string_to_power_ups'")

DeusPowerUpUtils.power_ups_to_encoded_string = function (self)
	-- function 18
	local tbl = {}

	for i = 1, #self do
		local var_18_1 = self[i]

		scripts_utils_byte_array.write_uint8(tbl, NetworkLookup.deus_power_up_templates[var_18_1.name])
		scripts_utils_byte_array.write_uint8(tbl, NetworkLookup.rarities[var_18_1.rarity])
		scripts_utils_byte_array.write_int32(tbl, var_18_1.client_id)
	end

	local read_string = scripts_utils_byte_array.read_string(tbl)

	return (scripts_utils_lib_deflate:CompressDeflate(read_string))
end

local tbl = {}

DeusPowerUpUtils.encoded_string_to_power_ups = function (arg_19_0)
	-- function 19
	local DecompressDeflate = scripts_utils_lib_deflate:DecompressDeflate(arg_19_0)

	scripts_utils_byte_array.write_string(tbl, DecompressDeflate)

	local tbl_2 = {}
	local num = 1
	local var_19_3
	local var_19_4
	local var_19_5

	repeat
		local read_uint8

		read_uint8, num = scripts_utils_byte_array.read_uint8(tbl, num)

		local read_uint8_2

		read_uint8_2, num = scripts_utils_byte_array.read_uint8(tbl, num)

		local read_int32

		read_int32, num = scripts_utils_byte_array.read_int32(tbl, num)

		table.insert(tbl_2, {
			name = NetworkLookup.deus_power_up_templates[read_uint8],
			rarity = NetworkLookup.rarities[read_uint8_2],
			client_id = read_int32
		})
	until not tbl[num]

	table.clear(tbl)

	return tbl_2
end

DeusPowerUpUtils.generate_specific_power_up = function (arg_20_0, arg_20_1)
	-- function 20
	return fn_9(arg_20_0, arg_20_1)
end

DeusPowerUpUtils.generate_random_power_ups = function (arg_21_0, arg_21_1, arg_21_2, arg_21_3, arg_21_4, arg_21_5, arg_21_6, arg_21_7)
	-- function 21
	local tbl = {}
	local flag = true

	arg_21_2 = table.shallow_copy(arg_21_2, flag)

	for i = 1, arg_21_1 do
		local var_21_2
		local var_21_3

		arg_21_0, var_21_3 = fn_8(arg_21_0, tbl, arg_21_2, arg_21_3, arg_21_4, arg_21_5, arg_21_6, arg_21_7)

		if not var_21_3 then
			table.insert(tbl, var_21_3)
			table.insert(arg_21_2, var_21_3)
		end
	end

	return arg_21_0, tbl
end

DeusPowerUpUtils.activate_deus_power_up = function (self, arg_22_1, arg_22_2, arg_22_3, arg_22_4, arg_22_5, arg_22_6, arg_22_7)
	-- function 22
	fassert(not self and not arg_22_1 and not arg_22_2 and not arg_22_3 and not arg_22_4 and not arg_22_5 and not arg_22_6 and arg_22_7, "DeusPowerUpUtils.activate_deus_power_up invalid arguments")

	local var_22_0 = DeusPowerUps[self.rarity][self.name]

	if not var_22_0.talent then
		local var_22_1 = SPProfiles[arg_22_6].careers[arg_22_7]
		local name = var_22_1.name
		local profile_name = var_22_1.profile_name
		local talent_tree_index = var_22_1.talent_tree_index
		local get_talent_ids = arg_22_2:get_talent_ids(name)
		local talent_index = var_22_0.talent_index
		local talent_tier = var_22_0.talent_tier
		local var_22_8 = TalentTrees[profile_name][talent_tree_index][talent_tier][talent_index]
		local talent_id = TalentIDLookup[var_22_8].talent_id

		get_talent_ids[#get_talent_ids + 1] = talent_id

		arg_22_3:set_deus_talent_ids(name, get_talent_ids)
		ScriptUnit.extension(arg_22_5, "talent_system"):talents_changed()
		ScriptUnit.extension(arg_22_5, "inventory_system"):apply_buffs_to_ammo()
	else
		arg_22_1:add_buff(arg_22_5, var_22_0.buff_name, arg_22_5)
	end
end
