-- chunkname: @scripts/helpers/deus_power_up_utils.lua

require("scripts/settings/dlcs/morris/deus_power_up_settings")

local var_0_0 = require("scripts/utils/byte_array")
local var_0_1 = require("scripts/utils/lib_deflate")

PowerUpClientIdCount = PowerUpClientIdCount or 0

local function var_0_2()
	return math.random_seed()
end

local function var_0_3(arg_2_0, arg_2_1, arg_2_2, arg_2_3)
	if table.is_empty(arg_2_1) then
		return arg_2_0, nil
	end

	local var_2_0
	local var_2_1

	arg_2_0, var_2_1 = Math.next_random(arg_2_0)

	if arg_2_3 == 0 then
		return arg_2_0, nil
	end

	local var_2_2 = 0
	local var_2_3 = 1 / arg_2_3

	for iter_2_0 = 1, #arg_2_1 do
		local var_2_4 = arg_2_1[iter_2_0]

		var_2_2 = var_2_2 + arg_2_2[iter_2_0] * var_2_3

		if var_2_1 < var_2_2 then
			return arg_2_0, var_2_4
		end
	end

	return arg_2_0, arg_2_1[#arg_2_1]
end

local function var_0_4(arg_3_0)
	local var_3_0 = {}
	local var_3_1 = {}

	for iter_3_0, iter_3_1 in pairs(arg_3_0) do
		for iter_3_2, iter_3_3 in pairs(iter_3_1) do
			local var_3_2 = (var_3_1[iter_3_2] or iter_3_3.max_amount) - 1

			var_3_1[iter_3_2] = var_3_2

			if var_3_2 <= 0 then
				var_3_0[iter_3_2] = true
			end
		end
	end

	return var_3_0
end

local function var_0_5(arg_4_0, arg_4_1, arg_4_2)
	local var_4_0 = arg_4_2.default

	if var_4_0 and table.contains(var_4_0, arg_4_1) then
		return true
	end

	local var_4_1 = arg_4_2[arg_4_0]

	if var_4_1 and table.contains(var_4_1, arg_4_1) then
		return true
	end

	return false
end

local function var_0_6(arg_5_0)
	if table.is_empty(arg_5_0) then
		return true
	end

	for iter_5_0 = 1, #arg_5_0 do
		if Managers.state.game_mode:has_activated_mutator(arg_5_0[iter_5_0]) then
			return true
		end
	end

	return false
end

local function var_0_7(arg_6_0, arg_6_1, arg_6_2)
	local var_6_0 = arg_6_2.incompatibility
	local var_6_1 = arg_6_2.name

	for iter_6_0, iter_6_1 in pairs(arg_6_1) do
		for iter_6_2, iter_6_3 in pairs(iter_6_1) do
			local var_6_2 = iter_6_3.incompatibility

			if var_6_2 and var_0_5(arg_6_0, var_6_1, var_6_2) then
				return true
			end

			if var_6_0 and var_0_5(arg_6_0, iter_6_2, var_6_0) then
				return true
			end
		end
	end

	return false
end

local function var_0_8(arg_7_0, arg_7_1, arg_7_2, arg_7_3, arg_7_4)
	local var_7_0 = {}

	for iter_7_0, iter_7_1 in ipairs(arg_7_1) do
		var_7_0[iter_7_1.name] = true
	end

	local var_7_1 = var_0_4(arg_7_2)

	for iter_7_2, iter_7_3 in pairs(var_7_1) do
		var_7_0[iter_7_2] = true
	end

	local var_7_2 = DeusPowerUpExclusionList[arg_7_0] or {}

	for iter_7_4, iter_7_5 in pairs(var_7_2) do
		var_7_0[iter_7_4] = true
	end

	local var_7_3 = DeusPowerUpSettings.num_set_boons_weight_multiplier
	local var_7_4 = 0
	local var_7_5 = {}
	local var_7_6 = {}
	local var_7_7 = DeusPowerUpsArrayByRarity[arg_7_3] or DeusPowerUpsArray or {}

	for iter_7_6, iter_7_7 in ipairs(var_7_7) do
		local var_7_8 = iter_7_7.name
		local var_7_9 = DeusPowerUps[iter_7_7.rarity][var_7_8]
		local var_7_10 = var_7_9.name

		if not var_7_0[var_7_10] and var_0_6(var_7_9.mutators) and table.contains(var_7_9.availability, arg_7_4) and not var_0_7(arg_7_0, arg_7_2, iter_7_7) then
			table.insert(var_7_6, var_7_9)

			local var_7_11 = var_7_9.weight
			local var_7_12 = DeusPowerUpSetLookup[var_7_9.rarity][var_7_10]

			if var_7_12 then
				local var_7_13 = 1

				for iter_7_8 = 1, #var_7_12 do
					local var_7_14 = var_7_12[iter_7_8]

					for iter_7_9 = 1, #var_7_14.pieces do
						local var_7_15 = var_7_14.pieces[iter_7_9]

						if arg_7_2[var_7_15.rarity][var_7_15.name] then
							var_7_13 = var_7_13 + (var_7_3 - 1)
						end
					end
				end

				var_7_11 = var_7_11 * var_7_13
			end

			var_7_4 = var_7_4 + var_7_11

			table.insert(var_7_5, var_7_11)
		end
	end

	return var_7_6, var_7_5, var_7_4
end

local var_0_9 = table.select_map(table.set(DeusPowerUpRarities), function(arg_8_0, arg_8_1)
	return {}
end)

local function var_0_10(arg_9_0, arg_9_1, arg_9_2, arg_9_3, arg_9_4, arg_9_5, arg_9_6, arg_9_7)
	local var_9_0
	local var_9_1
	local var_9_2

	for iter_9_0 = 1, #arg_9_2 do
		local var_9_3 = arg_9_2[iter_9_0]

		var_0_9[var_9_3.rarity][var_9_3.name] = DeusPowerUps[var_9_3.rarity][var_9_3.name]
	end

	if arg_9_7 then
		local var_9_4 = table.index_of(DeusPowerUpRarities, arg_9_7)

		for iter_9_1 = var_9_4, 1, -1 do
			arg_9_7 = DeusPowerUpRarities[iter_9_1]
			var_9_0, var_9_1, var_9_2 = var_0_8(arg_9_6, arg_9_1, var_0_9, arg_9_7, arg_9_5)

			if #var_9_0 > 0 then
				break
			end
		end

		if #var_9_0 == 0 then
			for iter_9_2 = var_9_4 + 1, #DeusPowerUpRarities do
				arg_9_7 = DeusPowerUpRarities[iter_9_2]
				var_9_0, var_9_1, var_9_2 = var_0_8(arg_9_6, arg_9_1, var_0_9, arg_9_7, arg_9_5)

				if #var_9_0 > 0 then
					break
				end
			end
		end

		fassert(#var_9_0 > 0, "not enough power_ups left in the pool")
	else
		var_9_0, var_9_1, var_9_2 = var_0_8(arg_9_6, arg_9_1, var_0_9, nil, arg_9_5)
	end

	local var_9_5
	local var_9_6

	arg_9_0, var_9_6 = var_0_3(arg_9_0, var_9_0, var_9_1, var_9_2)

	if not var_9_6 then
		return
	end

	local var_9_7 = {
		name = var_9_6.name,
		rarity = var_9_6.rarity,
		client_id = var_0_2()
	}

	for iter_9_3 in pairs(var_0_9) do
		table.clear(var_0_9[iter_9_3])
	end

	return arg_9_0, var_9_7
end

local function var_0_11(arg_10_0, arg_10_1)
	return {
		name = arg_10_0,
		rarity = arg_10_1,
		client_id = var_0_2()
	}
end

local function var_0_12(arg_11_0)
	local var_11_0 = DeusPowerUpTemplates[arg_11_0]
	local var_11_1 = var_11_0.display_name
	local var_11_2 = var_11_0.description_values

	return UIUtils.format_localized_description(var_11_1, var_11_2)
end

DeusPowerUpUtils = DeusPowerUpUtils or {}

function DeusPowerUpUtils.get_talent_from_power_up(arg_12_0, arg_12_1, arg_12_2, arg_12_3)
	local var_12_0 = SPProfiles[arg_12_2].careers[arg_12_3]
	local var_12_1 = var_12_0.profile_name
	local var_12_2 = var_12_0.talent_tree_index
	local var_12_3 = TalentTrees[var_12_1][var_12_2][arg_12_1][arg_12_0]
	local var_12_4 = TalentIDLookup[var_12_3]

	return TalentUtils.get_talent_by_id(var_12_1, var_12_4.talent_id)
end

function DeusPowerUpUtils.get_talent_power_up_from_tier_and_column(arg_13_0, arg_13_1)
	local var_13_0 = DeusPowerUpTalentLookup[arg_13_0][arg_13_1]

	for iter_13_0, iter_13_1 in pairs(DeusPowerUps) do
		local var_13_1 = iter_13_1[var_13_0]

		if var_13_1 then
			return var_13_1, iter_13_0
		end
	end

	ferror("could not find power_up for tier %s and column %s", arg_13_0, arg_13_1)
end

function DeusPowerUpUtils.get_power_up_description(arg_14_0, arg_14_1, arg_14_2)
	local var_14_0 = DeusPowerUps[arg_14_0.rarity][arg_14_0.name]

	if var_14_0.talent then
		local var_14_1 = DeusPowerUpUtils.get_talent_from_power_up(var_14_0.talent_index, var_14_0.talent_tier, arg_14_1, arg_14_2)

		return UIUtils.get_talent_description(var_14_1)
	else
		return (UIUtils.get_trait_description(nil, var_14_0))
	end
end

function DeusPowerUpUtils.get_power_up_icon(arg_15_0, arg_15_1, arg_15_2)
	local var_15_0 = DeusPowerUps[arg_15_0.rarity][arg_15_0.name]

	if var_15_0.talent then
		return DeusPowerUpUtils.get_talent_from_power_up(var_15_0.talent_index, var_15_0.talent_tier, arg_15_1, arg_15_2).icon
	else
		return var_15_0.icon
	end
end

function DeusPowerUpUtils.get_power_up_name_text(arg_16_0, arg_16_1, arg_16_2, arg_16_3, arg_16_4)
	local var_16_0
	local var_16_1 = ""

	if arg_16_1 and arg_16_2 then
		local var_16_2 = DeusPowerUpUtils.get_talent_from_power_up(arg_16_1, arg_16_2, arg_16_3, arg_16_4)

		var_16_0 = Localize(var_16_2.display_name or var_16_2.name)
	else
		var_16_0 = var_0_12(arg_16_0)
	end

	return var_16_0, var_16_1
end

function DeusPowerUpUtils.power_ups_to_string(arg_17_0)
	local var_17_0 = {}

	for iter_17_0, iter_17_1 in ipairs(arg_17_0) do
		table.insert(var_17_0, iter_17_1.name)
		table.insert(var_17_0, "/")
		table.insert(var_17_0, iter_17_1.rarity)
		table.insert(var_17_0, "/")
		table.insert(var_17_0, iter_17_1.client_id)
		table.insert(var_17_0, ",")
	end

	return table.concat(var_17_0, "")
end

assert(table.size(DeusPowerUpTemplates) <= 256, "[DeusPowerUpUtils] Number of power ups exceeds expectation. Change 'ByteArray.write_uint8' to 'ByteArray.write_uint16' in DeusPowerUpUtils.power_ups_to_encoded_string, and it's counterpart 'encoded_string_to_power_ups'")

function DeusPowerUpUtils.power_ups_to_encoded_string(arg_18_0)
	local var_18_0 = {}

	for iter_18_0 = 1, #arg_18_0 do
		local var_18_1 = arg_18_0[iter_18_0]

		var_0_0.write_uint8(var_18_0, NetworkLookup.deus_power_up_templates[var_18_1.name])
		var_0_0.write_uint8(var_18_0, NetworkLookup.rarities[var_18_1.rarity])
		var_0_0.write_int32(var_18_0, var_18_1.client_id)
	end

	local var_18_2 = var_0_0.read_string(var_18_0)

	return (var_0_1:CompressDeflate(var_18_2))
end

local var_0_13 = {}

function DeusPowerUpUtils.encoded_string_to_power_ups(arg_19_0)
	local var_19_0 = var_0_1:DecompressDeflate(arg_19_0)

	var_0_0.write_string(var_0_13, var_19_0)

	local var_19_1 = {}
	local var_19_2 = 1
	local var_19_3
	local var_19_4
	local var_19_5

	repeat
		local var_19_6

		var_19_6, var_19_2 = var_0_0.read_uint8(var_0_13, var_19_2)

		local var_19_7

		var_19_7, var_19_2 = var_0_0.read_uint8(var_0_13, var_19_2)

		local var_19_8

		var_19_8, var_19_2 = var_0_0.read_int32(var_0_13, var_19_2)

		table.insert(var_19_1, {
			name = NetworkLookup.deus_power_up_templates[var_19_6],
			rarity = NetworkLookup.rarities[var_19_7],
			client_id = var_19_8
		})
	until not var_0_13[var_19_2]

	table.clear(var_0_13)

	return var_19_1
end

function DeusPowerUpUtils.generate_specific_power_up(arg_20_0, arg_20_1)
	return var_0_11(arg_20_0, arg_20_1)
end

function DeusPowerUpUtils.generate_random_power_ups(arg_21_0, arg_21_1, arg_21_2, arg_21_3, arg_21_4, arg_21_5, arg_21_6, arg_21_7)
	local var_21_0 = {}
	local var_21_1 = true

	arg_21_2 = table.shallow_copy(arg_21_2, var_21_1)

	for iter_21_0 = 1, arg_21_1 do
		local var_21_2
		local var_21_3

		arg_21_0, var_21_3 = var_0_10(arg_21_0, var_21_0, arg_21_2, arg_21_3, arg_21_4, arg_21_5, arg_21_6, arg_21_7)

		if var_21_3 then
			table.insert(var_21_0, var_21_3)
			table.insert(arg_21_2, var_21_3)
		end
	end

	return arg_21_0, var_21_0
end

function DeusPowerUpUtils.activate_deus_power_up(arg_22_0, arg_22_1, arg_22_2, arg_22_3, arg_22_4, arg_22_5, arg_22_6, arg_22_7)
	fassert(arg_22_0 and arg_22_1 and arg_22_2 and arg_22_3 and arg_22_4 and arg_22_5 and arg_22_6 and arg_22_7, "DeusPowerUpUtils.activate_deus_power_up invalid arguments")

	local var_22_0 = DeusPowerUps[arg_22_0.rarity][arg_22_0.name]

	if var_22_0.talent then
		local var_22_1 = SPProfiles[arg_22_6].careers[arg_22_7]
		local var_22_2 = var_22_1.name
		local var_22_3 = var_22_1.profile_name
		local var_22_4 = var_22_1.talent_tree_index
		local var_22_5 = arg_22_2:get_talent_ids(var_22_2)
		local var_22_6 = var_22_0.talent_index
		local var_22_7 = var_22_0.talent_tier
		local var_22_8 = TalentTrees[var_22_3][var_22_4][var_22_7][var_22_6]
		local var_22_9 = TalentIDLookup[var_22_8].talent_id

		var_22_5[#var_22_5 + 1] = var_22_9

		arg_22_3:set_deus_talent_ids(var_22_2, var_22_5)
		ScriptUnit.extension(arg_22_5, "talent_system"):talents_changed()
		ScriptUnit.extension(arg_22_5, "inventory_system"):apply_buffs_to_ammo()
	else
		arg_22_1:add_buff(arg_22_5, var_22_0.buff_name, arg_22_5)
	end
end
