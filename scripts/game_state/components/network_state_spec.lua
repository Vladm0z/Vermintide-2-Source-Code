-- chunkname: @scripts/game_state/components/network_state_spec.lua

local var_0_0 = require("scripts/utils/lib_deflate")
local var_0_1 = require("scripts/utils/byte_array")

local function var_0_2(arg_1_0)
	local var_1_0 = {}
	local var_1_1 = NetworkLookup.inventory_packages

	for iter_1_0, iter_1_1 in pairs(arg_1_0) do
		local var_1_2 = var_1_1[iter_1_0]

		assert(var_1_2, "No existing inventory package for attempted name %q", iter_1_0)

		var_1_0[#var_1_0 + 1] = var_1_2
	end

	return var_1_0
end

local function var_0_3(arg_2_0)
	local var_2_0 = {}

	for iter_2_0, iter_2_1 in ipairs(arg_2_0) do
		var_2_0[#var_2_0 + 1] = {
			iter_2_1.peer_id,
			iter_2_1.local_player_id,
			iter_2_1.profile_index,
			iter_2_1.career_index,
			iter_2_1.is_bot
		}
	end

	return cjson.encode(var_2_0)
end

local function var_0_4(arg_3_0)
	local var_3_0 = cjson.decode(arg_3_0)
	local var_3_1 = {}

	for iter_3_0, iter_3_1 in ipairs(var_3_0) do
		local var_3_2 = {
			peer_id = iter_3_1[1],
			local_player_id = iter_3_1[2],
			profile_index = iter_3_1[3],
			career_index = iter_3_1[4],
			is_bot = iter_3_1[5]
		}

		var_3_1[#var_3_1 + 1] = var_3_2
	end

	return var_3_1
end

local function var_0_5(arg_4_0)
	local var_4_0 = var_0_2(arg_4_0.third_person)
	local var_4_1 = var_0_2(arg_4_0.first_person)
	local var_4_2 = {}

	var_0_1.write_int32(var_4_2, arg_4_0.inventory_id)
	var_0_1.write_hash(var_4_2, arg_4_0.inventory_hash)
	var_0_1.write_int32(var_4_2, #var_4_1)

	for iter_4_0 = 1, #var_4_1 do
		var_0_1.write_int32(var_4_2, var_4_1[iter_4_0])
	end

	var_0_1.write_int32(var_4_2, #var_4_0)

	for iter_4_1 = 1, #var_4_0 do
		var_0_1.write_int32(var_4_2, var_4_0[iter_4_1])
	end

	local var_4_3 = var_0_1.read_string(var_4_2)

	return (var_0_0:CompressDeflate(var_4_3))
end

local function var_0_6(arg_5_0)
	local var_5_0 = var_0_0:DecompressDeflate(arg_5_0)
	local var_5_1 = {}

	var_0_1.write_string(var_5_1, var_5_0)

	local var_5_2 = 1
	local var_5_3
	local var_5_4
	local var_5_5, var_5_6 = var_0_1.read_int32(var_5_1, var_5_2)
	local var_5_7, var_5_8 = var_0_1.read_hash(var_5_1, var_5_6)
	local var_5_9
	local var_5_10, var_5_11 = var_0_1.read_int32(var_5_1, var_5_8)
	local var_5_12 = {}

	for iter_5_0 = 1, var_5_10 do
		local var_5_13
		local var_5_14

		var_5_14, var_5_11 = var_0_1.read_int32(var_5_1, var_5_11)
		var_5_12[NetworkLookup.inventory_packages[var_5_14]] = false
	end

	local var_5_15
	local var_5_16, var_5_17 = var_0_1.read_int32(var_5_1, var_5_11)
	local var_5_18 = {}

	for iter_5_1 = 1, var_5_16 do
		local var_5_19
		local var_5_20

		var_5_20, var_5_17 = var_0_1.read_int32(var_5_1, var_5_17)
		var_5_18[NetworkLookup.inventory_packages[var_5_20]] = false
	end

	return {
		inventory_id = var_5_5,
		inventory_hash = var_5_7,
		first_person = var_5_12,
		third_person = var_5_18
	}
end

local function var_0_7(arg_6_0)
	return string.format("%d:%d", arg_6_0.profile_index, arg_6_0.career_index)
end

local function var_0_8(arg_7_0)
	local var_7_0 = string.split(arg_7_0, ":")

	return {
		profile_index = tonumber(var_7_0[1]),
		career_index = tonumber(var_7_0[2])
	}
end

local function var_0_9(arg_8_0)
	return string.format("%d:%d:%d", arg_8_0.profile_index, arg_8_0.career_index, arg_8_0.party_id)
end

local function var_0_10(arg_9_0)
	local var_9_0 = string.split(arg_9_0, ":")

	return {
		profile_index = tonumber(var_9_0[1]),
		career_index = tonumber(var_9_0[2]),
		party_id = tonumber(var_9_0[3])
	}
end

local function var_0_11(arg_10_0)
	return table.concat(arg_10_0, ",")
end

local function var_0_12(arg_11_0)
	return (arg_11_0.split_deprecated(arg_11_0, ","))
end

local function var_0_13(arg_12_0)
	local var_12_0 = {}

	for iter_12_0, iter_12_1 in ipairs(arg_12_0) do
		var_12_0[iter_12_0] = NetworkLookup.conflict_director_lock_lookup[iter_12_1]
	end

	return table.concat(var_12_0, ",")
end

local function var_0_14(arg_13_0)
	local var_13_0 = arg_13_0.split_deprecated(arg_13_0, ",")
	local var_13_1 = {}

	for iter_13_0, iter_13_1 in ipairs(var_13_0) do
		var_13_1[iter_13_0] = NetworkLookup.conflict_director_lock_lookup[tonumber(iter_13_1)]
	end

	return var_13_1
end

local function var_0_15(arg_14_0)
	local var_14_0 = {}

	for iter_14_0, iter_14_1 in ipairs(arg_14_0) do
		var_14_0[iter_14_0] = NetworkLookup.network_packages[iter_14_1]
	end

	return table.concat(var_14_0, ",")
end

local function var_0_16(arg_15_0)
	local var_15_0 = arg_15_0.split_deprecated(arg_15_0, ",")
	local var_15_1 = {}

	for iter_15_0, iter_15_1 in ipairs(var_15_0) do
		var_15_1[iter_15_0] = NetworkLookup.network_packages[tonumber(iter_15_1)]
	end

	return var_15_1
end

local function var_0_17(arg_16_0)
	local var_16_0 = table.clone(arg_16_0, true)
	local var_16_1 = var_16_0.mutators
	local var_16_2

	var_16_2 = var_16_1 and table.convert_lookup(var_16_1, NetworkLookup.mutator_templates)

	local var_16_3 = var_16_0.boons
	local var_16_4

	var_16_4 = var_16_3 and table.convert_lookup(var_16_3, NetworkLookup.deus_power_up_templates)

	return cjson.encode(var_16_0)
end

local function var_0_18(arg_17_0)
	local var_17_0 = cjson.decode(arg_17_0)
	local var_17_1 = var_17_0.mutators
	local var_17_2

	var_17_2 = var_17_1 and table.convert_lookup(var_17_1, NetworkLookup.mutator_templates)

	local var_17_3 = var_17_0.boons
	local var_17_4

	var_17_4 = var_17_3 and table.convert_lookup(var_17_3, NetworkLookup.deus_power_up_templates)

	return var_17_0
end

local function var_0_19(arg_18_0)
	return function (arg_19_0)
		return NetworkLookup[arg_18_0][arg_19_0]
	end
end

local function var_0_20(arg_20_0)
	return function (arg_21_0)
		return NetworkLookup[arg_20_0][arg_21_0]
	end
end

local function var_0_21(arg_22_0)
	return arg_22_0 == "load_next_level" and 0 or 1
end

local function var_0_22(arg_23_0)
	if arg_23_0 == 0 then
		return "load_next_level"
	else
		return "reload_level"
	end
end

local function var_0_23(arg_24_0)
	local var_24_0 = math.ceil(#NetworkLookup.breeds / 8)
	local var_24_1 = {}

	for iter_24_0 = 1, var_24_0 do
		var_24_1[iter_24_0] = 0
	end

	for iter_24_1 in pairs(arg_24_0) do
		local var_24_2 = NetworkLookup.breeds[iter_24_1]
		local var_24_3 = (var_24_2 - 1) % 8
		local var_24_4 = math.ceil(var_24_2 / 8)
		local var_24_5 = var_24_1[var_24_4]

		var_24_1[var_24_4] = bit.bor(var_24_5, 2^var_24_3)
	end

	local var_24_6 = var_0_1.read_string(var_24_1)

	return (var_0_0:CompressDeflate(var_24_6))
end

local function var_0_24(arg_25_0)
	local var_25_0 = var_0_0:DecompressDeflate(arg_25_0)
	local var_25_1 = {}

	var_0_1.write_string(var_25_1, var_25_0)

	local var_25_2 = {}

	for iter_25_0 = 1, #var_25_1 do
		local var_25_3 = tonumber(var_25_1[iter_25_0])

		if var_25_3 ~= 0 then
			for iter_25_1 = 0, 7 do
				if bit.band(var_25_3, 2^iter_25_1) ~= 0 then
					local var_25_4 = iter_25_1 + 1 + 8 * (iter_25_0 - 1)

					var_25_2[NetworkLookup.breeds[var_25_4]] = true
				end
			end
		end
	end

	return var_25_2
end

local function var_0_25(arg_26_0)
	local var_26_0 = math.ceil(#NetworkLookup.pickup_names / 8)
	local var_26_1 = {}

	for iter_26_0 = 1, var_26_0 do
		var_26_1[iter_26_0] = 0
	end

	for iter_26_1 in pairs(arg_26_0) do
		local var_26_2 = NetworkLookup.pickup_names[iter_26_1]
		local var_26_3 = (var_26_2 - 1) % 8
		local var_26_4 = math.ceil(var_26_2 / 8)
		local var_26_5 = var_26_1[var_26_4]

		var_26_1[var_26_4] = bit.bor(var_26_5, 2^var_26_3)
	end

	local var_26_6 = var_0_1.read_string(var_26_1)

	return (var_0_0:CompressDeflate(var_26_6))
end

local function var_0_26(arg_27_0)
	local var_27_0 = var_0_0:DecompressDeflate(arg_27_0)
	local var_27_1 = {}

	var_0_1.write_string(var_27_1, var_27_0)

	local var_27_2 = {}

	for iter_27_0 = 1, #var_27_1 do
		local var_27_3 = tonumber(var_27_1[iter_27_0])

		if var_27_3 ~= 0 then
			for iter_27_1 = 0, 7 do
				if bit.band(var_27_3, 2^iter_27_1) ~= 0 then
					local var_27_4 = iter_27_1 + 1 + 8 * (iter_27_0 - 1)

					var_27_2[NetworkLookup.pickup_names[var_27_4]] = true
				end
			end
		end
	end

	return var_27_2
end

local function var_0_27(arg_28_0)
	local var_28_0 = math.ceil(#NetworkLookup.dlcs / 8)
	local var_28_1 = {}

	for iter_28_0 = 1, var_28_0 do
		var_28_1[iter_28_0] = 0
	end

	for iter_28_1 in pairs(arg_28_0) do
		local var_28_2 = NetworkLookup.dlcs[iter_28_1]
		local var_28_3 = (var_28_2 - 1) % 8
		local var_28_4 = math.ceil(var_28_2 / 8)
		local var_28_5 = var_28_1[var_28_4]

		var_28_1[var_28_4] = bit.bor(var_28_5, 2^var_28_3)
	end

	local var_28_6 = var_0_1.read_string(var_28_1)

	return (var_0_0:CompressDeflate(var_28_6))
end

local function var_0_28(arg_29_0)
	local var_29_0 = var_0_0:DecompressDeflate(arg_29_0)
	local var_29_1 = {}

	var_0_1.write_string(var_29_1, var_29_0)

	local var_29_2 = {}

	for iter_29_0 = 1, #var_29_1 do
		local var_29_3 = tonumber(var_29_1[iter_29_0])

		if var_29_3 ~= 0 then
			for iter_29_1 = 0, 7 do
				if bit.band(var_29_3, 2^iter_29_1) ~= 0 then
					local var_29_4 = iter_29_1 + 1 + 8 * (iter_29_0 - 1)

					var_29_2[NetworkLookup.dlcs[var_29_4]] = true
				end
			end
		end
	end

	return var_29_2
end

local function var_0_29(arg_30_0)
	local var_30_0 = math.ceil(#NetworkLookup.mutator_templates / 8)
	local var_30_1 = {}

	for iter_30_0 = 1, var_30_0 do
		var_30_1[iter_30_0] = 0
	end

	for iter_30_1 in pairs(arg_30_0) do
		local var_30_2 = NetworkLookup.mutator_templates[iter_30_1]
		local var_30_3 = (var_30_2 - 1) % 8
		local var_30_4 = math.ceil(var_30_2 / 8)
		local var_30_5 = var_30_1[var_30_4]

		var_30_1[var_30_4] = bit.bor(var_30_5, 2^var_30_3)
	end

	local var_30_6 = var_0_1.read_string(var_30_1)

	return (var_0_0:CompressDeflate(var_30_6))
end

local function var_0_30(arg_31_0)
	local var_31_0 = var_0_0:DecompressDeflate(arg_31_0)
	local var_31_1 = {}

	var_0_1.write_string(var_31_1, var_31_0)

	local var_31_2 = {}

	for iter_31_0 = 1, #var_31_1 do
		local var_31_3 = tonumber(var_31_1[iter_31_0])

		if var_31_3 ~= 0 then
			for iter_31_1 = 0, 7 do
				if bit.band(var_31_3, 2^iter_31_1) ~= 0 then
					local var_31_4 = iter_31_1 + 1 + 8 * (iter_31_0 - 1)

					var_31_2[NetworkLookup.mutator_templates[var_31_4]] = true
				end
			end
		end
	end

	return var_31_2
end

local var_0_31 = {
	server = {
		peer_ingame = {
			clear_when_peer_id_leaves = true,
			default_value = false,
			type = "boolean",
			composite_keys = {
				peer_id = true
			}
		},
		peer_hot_join_synced = {
			clear_when_peer_id_leaves = true,
			default_value = false,
			type = "boolean",
			composite_keys = {
				peer_id = true
			}
		},
		profile_index_reservation = {
			default_value = "",
			type = "string",
			composite_keys = {
				profile_index = true,
				party_id = true
			}
		},
		persistent_hero_reservation = {
			type = "table",
			default_value = {
				profile_index = 0,
				career_index = 0,
				party_id = 0
			},
			composite_keys = {
				peer_id = true
			},
			encode = var_0_9,
			decode = var_0_10
		},
		bot_profile = {
			type = "table",
			default_value = {
				profile_index = 0,
				career_index = 0
			},
			composite_keys = {
				party_id = true,
				local_player_id = true
			},
			encode = var_0_7,
			decode = var_0_8
		},
		full_profile_peers = {
			type = "table",
			default_value = {},
			composite_keys = {},
			encode = var_0_3,
			decode = var_0_4
		},
		peers = {
			type = "table",
			default_value = {},
			composite_keys = {},
			encode = var_0_11,
			decode = var_0_12
		},
		level_key = {
			default_value = "inn_level",
			type = "string",
			composite_keys = {}
		},
		level_seed = {
			default_value = 0,
			type = "number",
			composite_keys = {}
		},
		conflict_director = {
			default_value = "inn_level",
			type = "string",
			composite_keys = {}
		},
		game_mode = {
			default_value = "inn",
			type = "string",
			composite_keys = {}
		},
		environment_variation_id = {
			default_value = 0,
			type = "number",
			composite_keys = {}
		},
		locked_director_functions = {
			type = "table",
			default_value = {},
			composite_keys = {},
			encode = var_0_13,
			decode = var_0_14
		},
		difficulty = {
			type = "string",
			default_value = "normal",
			composite_keys = {},
			encode = var_0_19("difficulties"),
			decode = var_0_20("difficulties")
		},
		difficulty_tweak = {
			default_value = 0,
			type = "number",
			composite_keys = {}
		},
		extra_packages = {
			type = "table",
			default_value = {},
			composite_keys = {},
			encode = var_0_15,
			decode = var_0_16
		},
		mechanism = {
			type = "string",
			default_value = "adventure",
			composite_keys = {},
			encode = var_0_19("mechanism_keys"),
			decode = var_0_20("mechanism_keys")
		},
		level_session_id = {
			default_value = 0,
			type = "number",
			composite_keys = {}
		},
		level_transition_type = {
			type = "string",
			default_value = "load_next_level",
			composite_keys = {},
			encode = var_0_21,
			decode = var_0_22
		},
		side_order_state = {
			default_value = 1,
			type = "number",
			composite_keys = {}
		},
		game_mode_event_data = {
			type = "table",
			default_value = {},
			composite_keys = {},
			encode = var_0_17,
			decode = var_0_18
		},
		initialized_mutator_map = {
			type = "table",
			default_value = {},
			composite_keys = {},
			encode = var_0_29,
			decode = var_0_30
		},
		session_breed_map = {
			mute_print = true,
			type = "table",
			default_value = {},
			composite_keys = {},
			encode = var_0_23,
			decode = var_0_24
		},
		startup_breed_map = {
			type = "table",
			default_value = {},
			composite_keys = {},
			encode = var_0_23,
			decode = var_0_24
		},
		session_pickup_map = {
			mute_print = true,
			type = "table",
			default_value = {},
			composite_keys = {},
			encode = var_0_25,
			decode = var_0_26
		}
	},
	peer = {
		inventory_list = {
			type = "table",
			composite_keys = {
				local_player_id = true
			},
			default_value = {
				inventory_id = 0,
				inventory_hash = "0000000000000000",
				first_person = {},
				third_person = {}
			},
			encode = var_0_5,
			decode = var_0_6
		},
		loaded_inventory_id = {
			default_value = 0,
			clear_when_peer_id_leaves = true,
			type = "number",
			composite_keys = {
				peer_id = true,
				local_player_id = true
			}
		},
		actually_ingame = {
			clear_when_peer_id_leaves = true,
			default_value = false,
			type = "boolean",
			composite_keys = {
				peer_id = true
			}
		},
		loaded_session_breed_map = {
			mute_print = true,
			type = "table",
			default_value = {},
			composite_keys = {},
			encode = var_0_23,
			decode = var_0_24
		},
		loaded_session_pickup_map = {
			mute_print = true,
			type = "table",
			default_value = {},
			composite_keys = {},
			encode = var_0_25,
			decode = var_0_26
		},
		unlocked_dlcs = {
			mute_print = true,
			type = "table",
			default_value = {},
			composite_keys = {},
			encode = var_0_27,
			decode = var_0_28,
			immediate_initialization = function (arg_32_0, arg_32_1)
				local var_32_0 = Managers.unlock
				local var_32_1 = NetworkLookup.dlcs
				local var_32_2 = {}

				for iter_32_0 = 1, #var_32_1 do
					local var_32_3 = var_32_1[iter_32_0]

					var_32_2[var_32_3] = var_32_0:is_dlc_unlocked(var_32_3)
				end

				return arg_32_0:get_key("unlocked_dlcs"), var_32_2
			end
		},
		loaded_mutator_map = {
			mute_print = true,
			type = "table",
			default_value = {},
			composite_keys = {},
			encode = var_0_29,
			decode = var_0_30
		}
	}
}

SharedState.validate_spec(var_0_31)

return var_0_31
