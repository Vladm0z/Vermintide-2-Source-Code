-- chunkname: @scripts/managers/game_mode/mechanisms/shared_state_versus_spec.lua

local var_0_0 = require("scripts/utils/lib_deflate")
local var_0_1 = require("scripts/utils/byte_array")

local function var_0_2(arg_1_0)
	local var_1_0 = NetworkLookup.equipment_slots[arg_1_0.weapon_slot]
	local var_1_1 = CosmeticUtils.get_cosmetic_id(arg_1_0.weapon_slot, arg_1_0.weapon)
	local var_1_2 = CosmeticUtils.get_cosmetic_id("slot_pose", arg_1_0.weapon_pose)
	local var_1_3 = CosmeticUtils.get_cosmetic_id("slot_pose_skin", arg_1_0.weapon_pose_skin)
	local var_1_4 = CosmeticUtils.get_cosmetic_id("slot_skin", arg_1_0.hero_skin)
	local var_1_5 = CosmeticUtils.get_cosmetic_id("slot_hat", arg_1_0.hat)
	local var_1_6 = CosmeticUtils.get_cosmetic_id("slot_frame", arg_1_0.frame)
	local var_1_7 = FrameTable.alloc_table()
	local var_1_8 = 1
	local var_1_9, var_1_10 = var_0_1.write_uint8(var_1_7, var_1_0, var_1_8)
	local var_1_11, var_1_12 = var_0_1.write_uint16(var_1_9, var_1_1, var_1_10)
	local var_1_13, var_1_14 = var_0_1.write_uint16(var_1_11, var_1_2, var_1_12)
	local var_1_15, var_1_16 = var_0_1.write_uint16(var_1_13, var_1_3, var_1_14)
	local var_1_17, var_1_18 = var_0_1.write_uint16(var_1_15, var_1_4, var_1_16)
	local var_1_19, var_1_20 = var_0_1.write_uint16(var_1_17, var_1_5, var_1_18)
	local var_1_21, var_1_22 = var_0_1.write_uint16(var_1_19, var_1_6, var_1_20)
	local var_1_23 = arg_1_0.pactsworn_cosmetics
	local var_1_24 = table.size(var_1_23)
	local var_1_25, var_1_26 = var_0_1.write_uint8(var_1_21, var_1_24, var_1_22)

	for iter_1_0, iter_1_1 in pairs(var_1_23) do
		local var_1_27 = PROFILES_BY_NAME[iter_1_0].index
		local var_1_28 = NetworkLookup.equipment_slots[iter_1_1.weapon_slot]
		local var_1_29 = CosmeticUtils.get_cosmetic_id(iter_1_1.weapon_slot, iter_1_1.skin)
		local var_1_30 = CosmeticUtils.get_cosmetic_id(iter_1_1.weapon_slot, iter_1_1.weapon)

		var_1_25, var_1_26 = var_0_1.write_uint8(var_1_25, var_1_27, var_1_26)
		var_1_25, var_1_26 = var_0_1.write_uint8(var_1_25, var_1_28, var_1_26)
		var_1_25, var_1_26 = var_0_1.write_uint16(var_1_25, var_1_29, var_1_26)
		var_1_25, var_1_26 = var_0_1.write_uint16(var_1_25, var_1_30, var_1_26)
	end

	local var_1_31 = var_0_1.read_string(var_1_25)

	return (var_0_0:CompressDeflate(var_1_31))
end

local function var_0_3(arg_2_0)
	local var_2_0 = var_0_0:DecompressDeflate(arg_2_0)
	local var_2_1 = FrameTable.alloc_table()

	var_0_1.write_string(var_2_1, var_2_0)

	local var_2_2
	local var_2_3
	local var_2_4
	local var_2_5
	local var_2_6
	local var_2_7
	local var_2_8
	local var_2_9
	local var_2_10 = {}
	local var_2_11 = 1
	local var_2_12, var_2_13 = var_0_1.read_uint8(var_2_1, var_2_11)
	local var_2_14, var_2_15 = var_0_1.read_uint16(var_2_1, var_2_13)
	local var_2_16, var_2_17 = var_0_1.read_uint16(var_2_1, var_2_15)
	local var_2_18, var_2_19 = var_0_1.read_uint16(var_2_1, var_2_17)
	local var_2_20, var_2_21 = var_0_1.read_uint16(var_2_1, var_2_19)
	local var_2_22, var_2_23 = var_0_1.read_uint16(var_2_1, var_2_21)
	local var_2_24, var_2_25 = var_0_1.read_uint16(var_2_1, var_2_23)
	local var_2_26, var_2_27 = var_0_1.read_uint8(var_2_1, var_2_25)

	for iter_2_0 = 1, var_2_26 do
		local var_2_28
		local var_2_29
		local var_2_30
		local var_2_31
		local var_2_32

		var_2_32, var_2_27 = var_0_1.read_uint8(var_2_1, var_2_27)

		local var_2_33

		var_2_33, var_2_27 = var_0_1.read_uint8(var_2_1, var_2_27)

		local var_2_34

		var_2_34, var_2_27 = var_0_1.read_uint16(var_2_1, var_2_27)

		local var_2_35

		var_2_35, var_2_27 = var_0_1.read_uint16(var_2_1, var_2_27)

		local var_2_36 = SPProfiles[var_2_32].display_name
		local var_2_37 = NetworkLookup.equipment_slots[var_2_33]
		local var_2_38 = CosmeticUtils.get_cosmetic_name(var_2_37, var_2_34)
		local var_2_39 = CosmeticUtils.get_cosmetic_name(var_2_37, var_2_35)

		var_2_10[var_2_36] = {
			skin = var_2_38,
			weapon = var_2_39,
			weapon_slot = var_2_37
		}
	end

	local var_2_40 = NetworkLookup.equipment_slots[var_2_12]

	return {
		weapon_slot = var_2_40,
		weapon = CosmeticUtils.get_cosmetic_name(var_2_40, var_2_14),
		weapon_pose = CosmeticUtils.get_cosmetic_name("slot_pose", var_2_16),
		weapon_pose_skin = CosmeticUtils.get_cosmetic_name("slot_pose_skin", var_2_18),
		hero_skin = CosmeticUtils.get_cosmetic_name("slot_skin", var_2_20),
		hat = CosmeticUtils.get_cosmetic_name("slot_hat", var_2_22),
		frame = CosmeticUtils.get_cosmetic_name("slot_frame", var_2_24),
		pactsworn_cosmetics = var_2_10
	}
end

local var_0_4 = {
	server = {
		match_ended = {
			default_value = false,
			type = "boolean",
			composite_keys = {}
		},
		party_won_early = {
			default_value = false,
			type = "boolean",
			composite_keys = {}
		},
		match_id = {
			default_value = "missing id",
			type = "string",
			composite_keys = {}
		}
	},
	peer = {
		hero_cosmetics = {
			type = "table",
			composite_keys = {
				local_player_id = true
			},
			default_value = {
				pactsworn_cosmetics = {}
			},
			encode = var_0_2,
			decode = var_0_3
		}
	}
}

SharedState.validate_spec(var_0_4)

return var_0_4
