-- chunkname: @scripts/managers/game_mode/mechanisms/deus_run_state_spec.lua

local scripts_utils_lib_deflate = require("scripts/utils/lib_deflate")
local scripts_utils_byte_array = require("scripts/utils/byte_array")
local num = 100000

local function fn(arg_1_0)
	-- function 1
	return table.concat(arg_1_0, ",")
end

local function fn_2(self)
	-- function 2
	return (self.split_deprecated(self, ","))
end

local function fn_3(arg_3_0)
	-- function 3
	local tbl = {}

	for k, v in pairs(arg_3_0) do
		tbl[#tbl + 1] = k
		tbl[#tbl + 1] = v
	end

	return table.concat(tbl, ",")
end

local function fn_4(arg_4_0)
	-- function 4
	local split_deprecated = string.split_deprecated(arg_4_0, ",")
	local tbl = {}

	for i = 1, #split_deprecated, 2 do
		tbl[split_deprecated[i]] = split_deprecated[i + 1]
	end

	return tbl
end

local function fn_5(arg_5_0)
	-- function 5
	return cjson.encode(arg_5_0)
end

local function fn_6(arg_6_0)
	-- function 6
	return (cjson.decode(arg_6_0))
end

local tbl = {}

local function fn_7(self)
	-- function 7
	table.clear(tbl)

	for i = 1, #self do
		local var_7_0 = self[i]

		scripts_utils_byte_array.write_int32(tbl, NetworkLookup.deus_power_up_templates[var_7_0.name])
		scripts_utils_byte_array.write_int32(tbl, NetworkLookup.rarities[var_7_0.rarity])
		scripts_utils_byte_array.write_int32(tbl, var_7_0.client_id)
	end

	local read_string = scripts_utils_byte_array.read_string(tbl)

	return (scripts_utils_lib_deflate:CompressDeflate(read_string))
end

local function fn_8(arg_8_0)
	-- function 8
	local DecompressDeflate = scripts_utils_lib_deflate:DecompressDeflate(arg_8_0)

	table.clear(tbl)
	scripts_utils_byte_array.write_string(tbl, DecompressDeflate)

	local tbl_2 = {}
	local num = 1

	while num < #tbl do
		local read_int32 = scripts_utils_byte_array.read_int32(tbl, num)

		num = num + 4

		local var_8_4 = NetworkLookup.deus_power_up_templates[read_int32]
		local read_int32_2 = scripts_utils_byte_array.read_int32(tbl, num)

		num = num + 4

		local var_8_6 = NetworkLookup.rarities[read_int32_2]
		local read_int32_3 = scripts_utils_byte_array.read_int32(tbl, num)

		num = num + 4
		tbl_2[#tbl_2 + 1] = {
			name = var_8_4,
			rarity = var_8_6,
			client_id = read_int32_3
		}
	end

	return tbl_2
end

local function fn_9(arg_9_0)
	-- function 9
	return math.round(arg_9_0 * num)
end

local function fn_10(arg_10_0)
	-- function 10
	return arg_10_0 / num
end

local function fn_11(arg_11_0)
	-- function 11
	local netpack_additional_items = SpawningHelper.netpack_additional_items(arg_11_0)

	return table.concat(netpack_additional_items, ",")
end

local function fn_12(arg_12_0)
	-- function 12
	local split_deprecated = string.split_deprecated(arg_12_0, ",")
	local unnetpack_additional_items = SpawningHelper.unnetpack_additional_items(split_deprecated)

	return (table.clone(unnetpack_additional_items))
end

local function fn_13(self)
	-- function 13
	local tbl = {}

	for i = 1, #self do
		local var_13_1 = self[i]

		table.insert(tbl, NetworkLookup.deus_power_up_templates[var_13_1])
	end

	return table.concat(tbl, ",")
end

local function fn_14(arg_14_0)
	-- function 14
	local tbl = {}
	local split_deprecated = string.split_deprecated(arg_14_0, ",")

	for i = 1, #split_deprecated do
		local var_14_2 = split_deprecated[i]
		local var_14_3 = NetworkLookup.deus_power_up_templates[tonumber(var_14_2)]

		tbl[#tbl + 1] = var_14_3
	end

	return tbl
end

local function fn_15(self)
	-- function 15
	local tbl = {}

	for i = 1, #self do
		local var_15_1 = self[i]

		table.insert(tbl, NetworkLookup.deus_blessings[var_15_1])
	end

	return table.concat(tbl, ",")
end

local function fn_16(arg_16_0)
	-- function 16
	local tbl = {}
	local split_deprecated = string.split_deprecated(arg_16_0, ",")

	for i = 1, #split_deprecated do
		local var_16_2 = split_deprecated[i]
		local var_16_3 = NetworkLookup.deus_blessings[tonumber(var_16_2)]

		tbl[#tbl + 1] = var_16_3
	end

	return tbl
end

local function fn_17(arg_17_0)
	-- function 17
	local tbl = {}

	for k, v in pairs(arg_17_0) do
		tbl[#tbl + 1] = NetworkLookup.rarities[k]
		tbl[#tbl + 1] = tostring(v)
	end

	return table.concat(tbl, ",")
end

local function fn_18(arg_18_0)
	-- function 18
	local split_deprecated = string.split_deprecated(arg_18_0, ",")
	local tbl = {}

	for i = 1, #split_deprecated, 2 do
		local var_18_2 = split_deprecated[i]
		local var_18_3 = split_deprecated[i + 1]

		tbl[NetworkLookup.rarities[tonumber(var_18_2)]] = tonumber(var_18_3)
	end

	return tbl
end

local function fn_19(arg_19_0)
	-- function 19
	return scripts_utils_lib_deflate:CompressDeflate(arg_19_0)
end

local function fn_20(arg_20_0)
	-- function 20
	return scripts_utils_lib_deflate:DecompressDeflate(arg_20_0)
end

local tbl_2 = {
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
			encode = fn,
			decode = fn_2
		},
		blessings_with_buyer = {
			type = "table",
			default_value = {},
			composite_keys = {},
			encode = fn_3,
			decode = fn_4
		},
		blessing_lifetimes = {
			type = "table",
			default_value = {},
			composite_keys = {},
			encode = fn_5,
			decode = fn_6
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
			encode = fn_7,
			decode = fn_8
		},
		party_power_ups = {
			type = "table",
			default_value = {},
			composite_keys = {},
			encode = fn_7,
			decode = fn_8
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
			encode = fn,
			decode = fn_2
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
			encode = fn_9,
			decode = fn_10
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
			encode = fn_9,
			decode = fn_10
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
			encode = fn_9,
			decode = fn_10
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
			encode = fn_11,
			decode = fn_12
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
			encode = fn_19,
			decode = fn_20
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
			encode = fn_19,
			decode = fn_20
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
			encode = fn_5,
			decode = fn_6
		},
		bought_power_ups = {
			type = "table",
			default_value = {},
			composite_keys = {},
			encode = fn_13,
			decode = fn_14
		},
		bought_blessings = {
			type = "table",
			default_value = {},
			composite_keys = {},
			encode = fn_15,
			decode = fn_16
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
			encode = fn_17,
			decode = fn_18
		},
		ranged_swap_chests_used = {
			type = "table",
			default_value = {},
			composite_keys = {},
			encode = fn_17,
			decode = fn_18
		},
		upgrade_chests_used = {
			type = "table",
			default_value = {},
			composite_keys = {},
			encode = fn_17,
			decode = fn_18
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
			encode = fn,
			decode = fn_2
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

SharedState.validate_spec(tbl_2)

return tbl_2
