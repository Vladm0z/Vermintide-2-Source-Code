-- chunkname: @scripts/managers/game_mode/mechanisms/shared_state_versus_spec.lua

local scripts_utils_lib_deflate = require("scripts/utils/lib_deflate")
local scripts_utils_byte_array = require("scripts/utils/byte_array")

local function fn(self)
	-- function 1
	local var_1_0 = NetworkLookup.equipment_slots[self.weapon_slot]
	local get_cosmetic_id = CosmeticUtils.get_cosmetic_id(self.weapon_slot, self.weapon)
	local get_cosmetic_id_2 = CosmeticUtils.get_cosmetic_id("slot_pose", self.weapon_pose)
	local get_cosmetic_id_3 = CosmeticUtils.get_cosmetic_id("slot_pose_skin", self.weapon_pose_skin)
	local get_cosmetic_id_4 = CosmeticUtils.get_cosmetic_id("slot_skin", self.hero_skin)
	local get_cosmetic_id_5 = CosmeticUtils.get_cosmetic_id("slot_hat", self.hat)
	local get_cosmetic_id_6 = CosmeticUtils.get_cosmetic_id("slot_frame", self.frame)
	local alloc_table = FrameTable.alloc_table()
	local num = 1
	local write_uint8, var_1_10 = scripts_utils_byte_array.write_uint8(alloc_table, var_1_0, num)
	local write_uint16, var_1_12 = scripts_utils_byte_array.write_uint16(write_uint8, get_cosmetic_id, var_1_10)
	local write_uint16_2, var_1_14 = scripts_utils_byte_array.write_uint16(write_uint16, get_cosmetic_id_2, var_1_12)
	local write_uint16_3, var_1_16 = scripts_utils_byte_array.write_uint16(write_uint16_2, get_cosmetic_id_3, var_1_14)
	local write_uint16_4, var_1_18 = scripts_utils_byte_array.write_uint16(write_uint16_3, get_cosmetic_id_4, var_1_16)
	local write_uint16_5, var_1_20 = scripts_utils_byte_array.write_uint16(write_uint16_4, get_cosmetic_id_5, var_1_18)
	local write_uint16_6, var_1_22 = scripts_utils_byte_array.write_uint16(write_uint16_5, get_cosmetic_id_6, var_1_20)
	local pactsworn_cosmetics = self.pactsworn_cosmetics
	local size = table.size(pactsworn_cosmetics)
	local write_uint8_2, var_1_26 = scripts_utils_byte_array.write_uint8(write_uint16_6, size, var_1_22)

	for k, v in pairs(pactsworn_cosmetics) do
		local index = PROFILES_BY_NAME[k].index
		local var_1_28 = NetworkLookup.equipment_slots[v.weapon_slot]
		local get_cosmetic_id_7 = CosmeticUtils.get_cosmetic_id(v.weapon_slot, v.skin)
		local get_cosmetic_id_8 = CosmeticUtils.get_cosmetic_id(v.weapon_slot, v.weapon)

		write_uint8_2, var_1_26 = scripts_utils_byte_array.write_uint8(write_uint8_2, index, var_1_26)
		write_uint8_2, var_1_26 = scripts_utils_byte_array.write_uint8(write_uint8_2, var_1_28, var_1_26)
		write_uint8_2, var_1_26 = scripts_utils_byte_array.write_uint16(write_uint8_2, get_cosmetic_id_7, var_1_26)
		write_uint8_2, var_1_26 = scripts_utils_byte_array.write_uint16(write_uint8_2, get_cosmetic_id_8, var_1_26)
	end

	local read_string = scripts_utils_byte_array.read_string(write_uint8_2)

	return (scripts_utils_lib_deflate:CompressDeflate(read_string))
end

local function fn_2(arg_2_0)
	-- function 2
	local DecompressDeflate = scripts_utils_lib_deflate:DecompressDeflate(arg_2_0)
	local alloc_table = FrameTable.alloc_table()

	scripts_utils_byte_array.write_string(alloc_table, DecompressDeflate)

	local var_2_2
	local var_2_3
	local var_2_4
	local var_2_5
	local var_2_6
	local var_2_7
	local var_2_8
	local var_2_9
	local tbl = {}
	local num = 1
	local read_uint8, var_2_13 = scripts_utils_byte_array.read_uint8(alloc_table, num)
	local read_uint16, var_2_15 = scripts_utils_byte_array.read_uint16(alloc_table, var_2_13)
	local read_uint16_2, var_2_17 = scripts_utils_byte_array.read_uint16(alloc_table, var_2_15)
	local read_uint16_3, var_2_19 = scripts_utils_byte_array.read_uint16(alloc_table, var_2_17)
	local read_uint16_4, var_2_21 = scripts_utils_byte_array.read_uint16(alloc_table, var_2_19)
	local read_uint16_5, var_2_23 = scripts_utils_byte_array.read_uint16(alloc_table, var_2_21)
	local read_uint16_6, var_2_25 = scripts_utils_byte_array.read_uint16(alloc_table, var_2_23)
	local read_uint8_2, var_2_27 = scripts_utils_byte_array.read_uint8(alloc_table, var_2_25)

	for i = 1, read_uint8_2 do
		local var_2_28
		local var_2_29
		local var_2_30
		local var_2_31
		local read_uint8_3

		read_uint8_3, var_2_27 = scripts_utils_byte_array.read_uint8(alloc_table, var_2_27)

		local read_uint8_4

		read_uint8_4, var_2_27 = scripts_utils_byte_array.read_uint8(alloc_table, var_2_27)

		local read_uint16_7

		read_uint16_7, var_2_27 = scripts_utils_byte_array.read_uint16(alloc_table, var_2_27)

		local read_uint16_8

		read_uint16_8, var_2_27 = scripts_utils_byte_array.read_uint16(alloc_table, var_2_27)

		local display_name = SPProfiles[read_uint8_3].display_name
		local var_2_37 = NetworkLookup.equipment_slots[read_uint8_4]
		local get_cosmetic_name = CosmeticUtils.get_cosmetic_name(var_2_37, read_uint16_7)
		local get_cosmetic_name_2 = CosmeticUtils.get_cosmetic_name(var_2_37, read_uint16_8)

		tbl[display_name] = {
			skin = get_cosmetic_name,
			weapon = get_cosmetic_name_2,
			weapon_slot = var_2_37
		}
	end

	local var_2_40 = NetworkLookup.equipment_slots[read_uint8]

	return {
		weapon_slot = var_2_40,
		weapon = CosmeticUtils.get_cosmetic_name(var_2_40, read_uint16),
		weapon_pose = CosmeticUtils.get_cosmetic_name("slot_pose", read_uint16_2),
		weapon_pose_skin = CosmeticUtils.get_cosmetic_name("slot_pose_skin", read_uint16_3),
		hero_skin = CosmeticUtils.get_cosmetic_name("slot_skin", read_uint16_4),
		hat = CosmeticUtils.get_cosmetic_name("slot_hat", read_uint16_5),
		frame = CosmeticUtils.get_cosmetic_name("slot_frame", read_uint16_6),
		pactsworn_cosmetics = tbl
	}
end

local tbl = {
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
			encode = fn,
			decode = fn_2
		}
	}
}

SharedState.validate_spec(tbl)

return tbl
