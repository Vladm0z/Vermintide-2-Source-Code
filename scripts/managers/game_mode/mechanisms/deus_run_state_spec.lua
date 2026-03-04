-- chunkname: @scripts/managers/game_mode/mechanisms/deus_run_state_spec.lua

local var_0_0 = require("scripts/utils/lib_deflate")
local var_0_1 = require("scripts/utils/byte_array")
local var_0_2 = 100000

local function var_0_3(arg_1_0)
	return table.concat(arg_1_0, ",")
end

local function var_0_4(arg_2_0)
	return (arg_2_0.split_deprecated(arg_2_0, ","))
end

local function var_0_5(arg_3_0)
	local var_3_0 = {}

	for iter_3_0, iter_3_1 in pairs(arg_3_0) do
		var_3_0[#var_3_0 + 1] = iter_3_0
		var_3_0[#var_3_0 + 1] = iter_3_1
	end

	return table.concat(var_3_0, ",")
end

local function var_0_6(arg_4_0)
	local var_4_0 = string.split_deprecated(arg_4_0, ",")
	local var_4_1 = {}

	for iter_4_0 = 1, #var_4_0, 2 do
		var_4_1[var_4_0[iter_4_0]] = var_4_0[iter_4_0 + 1]
	end

	return var_4_1
end

local function var_0_7(arg_5_0)
	return cjson.encode(arg_5_0)
end

local function var_0_8(arg_6_0)
	return (cjson.decode(arg_6_0))
end

local var_0_9 = {}

local function var_0_10(arg_7_0)
	table.clear(var_0_9)

	for iter_7_0 = 1, #arg_7_0 do
		local var_7_0 = arg_7_0[iter_7_0]

		var_0_1.write_int32(var_0_9, NetworkLookup.deus_power_up_templates[var_7_0.name])
		var_0_1.write_int32(var_0_9, NetworkLookup.rarities[var_7_0.rarity])
		var_0_1.write_int32(var_0_9, var_7_0.client_id)
	end

	local var_7_1 = var_0_1.read_string(var_0_9)

	return (var_0_0:CompressDeflate(var_7_1))
end

local function var_0_11(arg_8_0)
	local var_8_0 = var_0_0:DecompressDeflate(arg_8_0)

	table.clear(var_0_9)
	var_0_1.write_string(var_0_9, var_8_0)

	local var_8_1 = {}
	local var_8_2 = 1

	while var_8_2 < #var_0_9 do
		local var_8_3 = var_0_1.read_int32(var_0_9, var_8_2)

		var_8_2 = var_8_2 + 4

		local var_8_4 = NetworkLookup.deus_power_up_templates[var_8_3]
		local var_8_5 = var_0_1.read_int32(var_0_9, var_8_2)

		var_8_2 = var_8_2 + 4

		local var_8_6 = NetworkLookup.rarities[var_8_5]
		local var_8_7 = var_0_1.read_int32(var_0_9, var_8_2)

		var_8_2 = var_8_2 + 4
		var_8_1[#var_8_1 + 1] = {
			name = var_8_4,
			rarity = var_8_6,
			client_id = var_8_7
		}
	end

	return var_8_1
end

local function var_0_12(arg_9_0)
	return math.round(arg_9_0 * var_0_2)
end

local function var_0_13(arg_10_0)
	return arg_10_0 / var_0_2
end

local function var_0_14(arg_11_0)
	local var_11_0 = SpawningHelper.netpack_additional_items(arg_11_0)

	return table.concat(var_11_0, ",")
end

local function var_0_15(arg_12_0)
	local var_12_0 = string.split_deprecated(arg_12_0, ",")
	local var_12_1 = SpawningHelper.unnetpack_additional_items(var_12_0)

	return (table.clone(var_12_1))
end

local function var_0_16(arg_13_0)
	local var_13_0 = {}

	for iter_13_0 = 1, #arg_13_0 do
		local var_13_1 = arg_13_0[iter_13_0]

		table.insert(var_13_0, NetworkLookup.deus_power_up_templates[var_13_1])
	end

	return table.concat(var_13_0, ",")
end

local function var_0_17(arg_14_0)
	local var_14_0 = {}
	local var_14_1 = string.split_deprecated(arg_14_0, ",")

	for iter_14_0 = 1, #var_14_1 do
		local var_14_2 = var_14_1[iter_14_0]
		local var_14_3 = NetworkLookup.deus_power_up_templates[tonumber(var_14_2)]

		var_14_0[#var_14_0 + 1] = var_14_3
	end

	return var_14_0
end

local function var_0_18(arg_15_0)
	local var_15_0 = {}

	for iter_15_0 = 1, #arg_15_0 do
		local var_15_1 = arg_15_0[iter_15_0]

		table.insert(var_15_0, NetworkLookup.deus_blessings[var_15_1])
	end

	return table.concat(var_15_0, ",")
end

local function var_0_19(arg_16_0)
	local var_16_0 = {}
	local var_16_1 = string.split_deprecated(arg_16_0, ",")

	for iter_16_0 = 1, #var_16_1 do
		local var_16_2 = var_16_1[iter_16_0]
		local var_16_3 = NetworkLookup.deus_blessings[tonumber(var_16_2)]

		var_16_0[#var_16_0 + 1] = var_16_3
	end

	return var_16_0
end

local function var_0_20(arg_17_0)
	local var_17_0 = {}

	for iter_17_0, iter_17_1 in pairs(arg_17_0) do
		var_17_0[#var_17_0 + 1] = NetworkLookup.rarities[iter_17_0]
		var_17_0[#var_17_0 + 1] = tostring(iter_17_1)
	end

	return table.concat(var_17_0, ",")
end

local function var_0_21(arg_18_0)
	local var_18_0 = string.split_deprecated(arg_18_0, ",")
	local var_18_1 = {}

	for iter_18_0 = 1, #var_18_0, 2 do
		local var_18_2 = var_18_0[iter_18_0]
		local var_18_3 = var_18_0[iter_18_0 + 1]

		var_18_1[NetworkLookup.rarities[tonumber(var_18_2)]] = tonumber(var_18_3)
	end

	return var_18_1
end

local function var_0_22(arg_19_0)
	return var_0_0:CompressDeflate(arg_19_0)
end

local function var_0_23(arg_20_0)
	return var_0_0:DecompressDeflate(arg_20_0)
end

local var_0_24 = {
	server = {
		run_node_key = {
			default_value = "start",
			type = "string",
			composite_keys = {}
		},
		run_ended = {
			default_value = false,
			type = "boolean",
			composite_keys = {}
		},
		completed_level_count = {
			default_value = 0,
			type = "number",
			composite_keys = {}
		},
		traversed_nodes = {
			type = "table",
			default_value = {},
			composite_keys = {},
			encode = var_0_3,
			decode = var_0_4
		},
		blessings_with_buyer = {
			type = "table",
			default_value = {},
			composite_keys = {},
			encode = var_0_5,
			decode = var_0_6
		},
		blessing_lifetimes = {
			type = "table",
			default_value = {},
			composite_keys = {},
			encode = var_0_7,
			decode = var_0_8
		},
		peer_initialized = {
			default_value = false,
			type = "boolean",
			composite_keys = {
				peer_id = true
			}
		},
		profile_initialized = {
			default_value = false,
			type = "boolean",
			composite_keys = {
				peer_id = true,
				career_index = true,
				profile_index = true,
				local_player_id = true
			}
		},
		cursed_levels_completed = {
			default_value = 0,
			type = "number",
			composite_keys = {
				peer_id = true
			}
		},
		cursed_chests_purified = {
			default_value = 0,
			type = "number",
			composite_keys = {
				peer_id = true
			}
		},
		coin_chests_collected = {
			default_value = 0,
			type = "number",
			composite_keys = {
				peer_id = true
			}
		},
		spawned_once = {
			default_value = false,
			type = "boolean",
			composite_keys = {
				peer_id = true,
				career_index = true,
				profile_index = true,
				local_player_id = true
			}
		},
		power_ups = {
			type = "table",
			default_value = {},
			composite_keys = {
				peer_id = true,
				career_index = true,
				profile_index = true,
				local_player_id = true
			},
			encode = var_0_10,
			decode = var_0_11
		},
		party_power_ups = {
			type = "table",
			default_value = {},
			composite_keys = {},
			encode = var_0_10,
			decode = var_0_11
		},
		persistent_buffs = {
			type = "table",
			default_value = {},
			composite_keys = {
				peer_id = true,
				career_index = true,
				profile_index = true,
				local_player_id = true
			},
			encode = var_0_3,
			decode = var_0_4
		},
		soft_currency = {
			default_value = 0,
			type = "number",
			composite_keys = {
				peer_id = true,
				local_player_id = true
			}
		},
		health_percentage = {
			type = "number",
			default_value = 1,
			composite_keys = {
				peer_id = true,
				career_index = true,
				profile_index = true,
				local_player_id = true
			},
			encode = var_0_12,
			decode = var_0_13
		},
		health_state = {
			default_value = "alive",
			type = "string",
			composite_keys = {
				peer_id = true,
				career_index = true,
				profile_index = true,
				local_player_id = true
			}
		},
		melee_ammo = {
			type = "number",
			default_value = 1,
			composite_keys = {
				peer_id = true,
				career_index = true,
				profile_index = true,
				local_player_id = true
			},
			encode = var_0_12,
			decode = var_0_13
		},
		ranged_ammo = {
			type = "number",
			default_value = 1,
			composite_keys = {
				peer_id = true,
				career_index = true,
				profile_index = true,
				local_player_id = true
			},
			encode = var_0_12,
			decode = var_0_13
		},
		healthkit = {
			default_value = "",
			type = "string",
			composite_keys = {
				peer_id = true,
				career_index = true,
				profile_index = true,
				local_player_id = true
			}
		},
		potion = {
			default_value = "",
			type = "string",
			composite_keys = {
				peer_id = true,
				career_index = true,
				profile_index = true,
				local_player_id = true
			}
		},
		grenade = {
			default_value = "",
			type = "string",
			composite_keys = {
				peer_id = true,
				career_index = true,
				profile_index = true,
				local_player_id = true
			}
		},
		additional_items = {
			type = "table",
			default_value = {},
			composite_keys = {
				peer_id = true,
				career_index = true,
				profile_index = true,
				local_player_id = true
			},
			encode = var_0_14,
			decode = var_0_15
		},
		slot_melee = {
			type = "string",
			default_value = "",
			composite_keys = {
				peer_id = true,
				career_index = true,
				profile_index = true,
				local_player_id = true
			},
			encode = var_0_22,
			decode = var_0_23
		},
		slot_ranged = {
			type = "string",
			default_value = "",
			composite_keys = {
				peer_id = true,
				career_index = true,
				profile_index = true,
				local_player_id = true
			},
			encode = var_0_22,
			decode = var_0_23
		},
		twitch_vote = {
			default_value = "",
			type = "string",
			composite_keys = {}
		},
		persisted_score = {
			type = "table",
			default_value = {},
			composite_keys = {
				peer_id = true,
				local_player_id = true
			},
			encode = var_0_7,
			decode = var_0_8
		},
		bought_power_ups = {
			type = "table",
			default_value = {},
			composite_keys = {},
			encode = var_0_16,
			decode = var_0_17
		},
		bought_blessings = {
			type = "table",
			default_value = {},
			composite_keys = {},
			encode = var_0_18,
			decode = var_0_19
		},
		ground_coins_picked_up = {
			default_value = 0,
			type = "number",
			composite_keys = {}
		},
		monster_coins_picked_up = {
			default_value = 0,
			type = "number",
			composite_keys = {}
		},
		melee_swap_chests_used = {
			type = "table",
			default_value = {},
			composite_keys = {},
			encode = var_0_20,
			decode = var_0_21
		},
		ranged_swap_chests_used = {
			type = "table",
			default_value = {},
			composite_keys = {},
			encode = var_0_20,
			decode = var_0_21
		},
		upgrade_chests_used = {
			type = "table",
			default_value = {},
			composite_keys = {},
			encode = var_0_20,
			decode = var_0_21
		},
		power_up_chests_used = {
			default_value = 0,
			type = "number",
			composite_keys = {}
		},
		coins_earned = {
			default_value = 0,
			type = "number",
			composite_keys = {}
		},
		coins_spent = {
			default_value = 0,
			type = "number",
			composite_keys = {}
		},
		host_migration_count = {
			default_value = 0,
			type = "number",
			composite_keys = {}
		},
		arena_belakor_node = {
			default_value = "",
			type = "string",
			composite_keys = {}
		},
		seen_arena_belakor_node = {
			default_value = false,
			type = "boolean",
			composite_keys = {
				peer_id = true
			}
		},
		granted_non_party_end_of_level_power_ups = {
			type = "table",
			default_value = {},
			composite_keys = {
				peer_id = true,
				career_index = true,
				profile_index = true,
				local_player_id = true
			},
			encode = var_0_3,
			decode = var_0_4
		}
	},
	peer = {
		telemetry_id = {
			default_value = "",
			type = "string",
			composite_keys = {}
		},
		player_level = {
			default_value = 1,
			type = "number",
			composite_keys = {}
		},
		player_name = {
			default_value = "Player",
			type = "string",
			composite_keys = {}
		},
		player_frame = {
			default_value = "default",
			type = "string",
			composite_keys = {}
		},
		versus_player_level = {
			default_value = 0,
			type = "number",
			composite_keys = {}
		}
	}
}

SharedState.validate_spec(var_0_24)

return var_0_24
