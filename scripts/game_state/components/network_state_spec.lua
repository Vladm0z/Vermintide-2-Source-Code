-- chunkname: @scripts/game_state/components/network_state_spec.lua

local scripts_utils_lib_deflate = require("scripts/utils/lib_deflate")
local scripts_utils_byte_array = require("scripts/utils/byte_array")

local function fn(arg_1_0)
	-- function 1
	local tbl = {}
	local inventory_packages = NetworkLookup.inventory_packages

	for k, v in pairs(arg_1_0) do
		local var_1_2 = inventory_packages[k]

		assert(var_1_2, "No existing inventory package for attempted name %q", k)

		tbl[#tbl + 1] = var_1_2
	end

	return tbl
end

local function fn_2(arg_2_0)
	-- function 2
	local tbl = {}

	for i, v in ipairs(arg_2_0) do
		tbl[#tbl + 1] = {
			v.peer_id,
			v.local_player_id,
			v.profile_index,
			v.career_index,
			v.is_bot
		}
	end

	return cjson.encode(tbl)
end

local function fn_3(arg_3_0)
	-- function 3
	local decode = cjson.decode(arg_3_0)
	local tbl = {}

	for i, v in ipairs(decode) do
		local tbl_2 = {
			peer_id = v[1],
			local_player_id = v[2],
			profile_index = v[3],
			career_index = v[4],
			is_bot = v[5]
		}

		tbl[#tbl + 1] = tbl_2
	end

	return tbl
end

local function fn_4(self)
	-- function 4
	local var_4_0 = fn(self.third_person)
	local var_4_1 = fn(self.first_person)
	local tbl = {}

	scripts_utils_byte_array.write_int32(tbl, self.inventory_id)
	scripts_utils_byte_array.write_hash(tbl, self.inventory_hash)
	scripts_utils_byte_array.write_int32(tbl, #var_4_1)

	for i = 1, #var_4_1 do
		scripts_utils_byte_array.write_int32(tbl, var_4_1[i])
	end

	scripts_utils_byte_array.write_int32(tbl, #var_4_0)

	for j = 1, #var_4_0 do
		scripts_utils_byte_array.write_int32(tbl, var_4_0[j])
	end

	local read_string = scripts_utils_byte_array.read_string(tbl)

	return (scripts_utils_lib_deflate:CompressDeflate(read_string))
end

local function fn_5(arg_5_0)
	-- function 5
	local DecompressDeflate = scripts_utils_lib_deflate:DecompressDeflate(arg_5_0)
	local tbl = {}

	scripts_utils_byte_array.write_string(tbl, DecompressDeflate)

	local num = 1
	local var_5_3
	local var_5_4
	local read_int32, var_5_6 = scripts_utils_byte_array.read_int32(tbl, num)
	local read_hash, var_5_8 = scripts_utils_byte_array.read_hash(tbl, var_5_6)
	local var_5_9
	local read_int32_2, var_5_11 = scripts_utils_byte_array.read_int32(tbl, var_5_8)
	local tbl_2 = {}

	for i = 1, read_int32_2 do
		local var_5_13
		local read_int32_3

		read_int32_3, var_5_11 = scripts_utils_byte_array.read_int32(tbl, var_5_11)
		tbl_2[NetworkLookup.inventory_packages[read_int32_3]] = false
	end

	local var_5_15
	local read_int32_4, var_5_17 = scripts_utils_byte_array.read_int32(tbl, var_5_11)
	local tbl_3 = {}

	for j = 1, read_int32_4 do
		local var_5_19
		local read_int32_5

		read_int32_5, var_5_17 = scripts_utils_byte_array.read_int32(tbl, var_5_17)
		tbl_3[NetworkLookup.inventory_packages[read_int32_5]] = false
	end

	return {
		inventory_id = read_int32,
		inventory_hash = read_hash,
		first_person = tbl_2,
		third_person = tbl_3
	}
end

local function fn_6(self)
	-- function 6
	return string.format("%d:%d", self.profile_index, self.career_index)
end

local function fn_7(arg_7_0)
	-- function 7
	local split = string.split(arg_7_0, ":")

	return {
		profile_index = tonumber(split[1]),
		career_index = tonumber(split[2])
	}
end

local function fn_8(self)
	-- function 8
	return string.format("%d:%d:%d", self.profile_index, self.career_index, self.party_id)
end

local function fn_9(arg_9_0)
	-- function 9
	local split = string.split(arg_9_0, ":")

	return {
		profile_index = tonumber(split[1]),
		career_index = tonumber(split[2]),
		party_id = tonumber(split[3])
	}
end

local function fn_10(arg_10_0)
	-- function 10
	return table.concat(arg_10_0, ",")
end

local function fn_11(self)
	-- function 11
	return (self.split_deprecated(self, ","))
end

local function fn_12(arg_12_0)
	-- function 12
	local tbl = {}

	for i, v in ipairs(arg_12_0) do
		tbl[i] = NetworkLookup.conflict_director_lock_lookup[v]
	end

	return table.concat(tbl, ",")
end

local function fn_13(self)
	-- function 13
	local split_deprecated = self.split_deprecated(self, ",")
	local tbl = {}

	for i, v in ipairs(split_deprecated) do
		tbl[i] = NetworkLookup.conflict_director_lock_lookup[tonumber(v)]
	end

	return tbl
end

local function fn_14(arg_14_0)
	-- function 14
	local tbl = {}

	for i, v in ipairs(arg_14_0) do
		tbl[i] = NetworkLookup.network_packages[v]
	end

	return table.concat(tbl, ",")
end

local function fn_15(self)
	-- function 15
	local split_deprecated = self.split_deprecated(self, ",")
	local tbl = {}

	for i, v in ipairs(split_deprecated) do
		tbl[i] = NetworkLookup.network_packages[tonumber(v)]
	end

	return tbl
end

local function fn_16(arg_16_0)
	-- function 16
	local clone = table.clone(arg_16_0, true)
	local mutators = clone.mutators
	local flag

	flag = not mutators and table.convert_lookup(mutators, NetworkLookup.mutator_templates)

	local boons = clone.boons
	local flag_2

	flag_2 = not boons and table.convert_lookup(boons, NetworkLookup.deus_power_up_templates)

	return cjson.encode(clone)
end

local function fn_17(arg_17_0)
	-- function 17
	local decode = cjson.decode(arg_17_0)
	local mutators = decode.mutators
	local flag

	flag = not mutators and table.convert_lookup(mutators, NetworkLookup.mutator_templates)

	local boons = decode.boons
	local flag_2

	flag_2 = not boons and table.convert_lookup(boons, NetworkLookup.deus_power_up_templates)

	return decode
end

local function fn_18(arg_18_0)
	-- function 18
	return function (arg_19_0)
		-- function 19
		return NetworkLookup[arg_18_0][arg_19_0]
	end
end

local function fn_19(arg_20_0)
	-- function 20
	return function (arg_21_0)
		-- function 21
		return NetworkLookup[arg_20_0][arg_21_0]
	end
end

local function fn_20(arg_22_0)
	-- function 22
	local flag

	flag = arg_22_0 ~= "load_next_level" or not 0 or 1

	return flag
end

local function fn_21(arg_23_0)
	-- function 23
	if arg_23_0 == 0 then
		return "load_next_level"
	else
		return "reload_level"
	end
end

local function fn_22(arg_24_0)
	-- function 24
	local ceil = math.ceil(#NetworkLookup.breeds / 8)
	local tbl = {}

	for i = 1, ceil do
		tbl[i] = 0
	end

	for k in pairs(arg_24_0) do
		local var_24_2 = NetworkLookup.breeds[k]
		local num = (var_24_2 - 1) % 8
		local ceil_2 = math.ceil(var_24_2 / 8)
		local var_24_5 = tbl[ceil_2]

		tbl[ceil_2] = bit.bor(var_24_5, 2^num)
	end

	local read_string = scripts_utils_byte_array.read_string(tbl)

	return (scripts_utils_lib_deflate:CompressDeflate(read_string))
end

local function fn_23(arg_25_0)
	-- function 25
	local DecompressDeflate = scripts_utils_lib_deflate:DecompressDeflate(arg_25_0)
	local tbl = {}

	scripts_utils_byte_array.write_string(tbl, DecompressDeflate)

	local tbl_2 = {}

	for i = 1, #tbl do
		local var_25_3 = tonumber(tbl[i])

		if var_25_3 ~= 0 then
			for j = 0, 7 do
				if not (bit.band(var_25_3, 2^j) ~= 0) then
					local num = j + 1 + 8 * (i - 1)

					tbl_2[NetworkLookup.breeds[num]] = true
				end
			end
		end
	end

	return tbl_2
end

local function fn_24(arg_26_0)
	-- function 26
	local ceil = math.ceil(#NetworkLookup.pickup_names / 8)
	local tbl = {}

	for i = 1, ceil do
		tbl[i] = 0
	end

	for k in pairs(arg_26_0) do
		local var_26_2 = NetworkLookup.pickup_names[k]
		local num = (var_26_2 - 1) % 8
		local ceil_2 = math.ceil(var_26_2 / 8)
		local var_26_5 = tbl[ceil_2]

		tbl[ceil_2] = bit.bor(var_26_5, 2^num)
	end

	local read_string = scripts_utils_byte_array.read_string(tbl)

	return (scripts_utils_lib_deflate:CompressDeflate(read_string))
end

local function fn_25(arg_27_0)
	-- function 27
	local DecompressDeflate = scripts_utils_lib_deflate:DecompressDeflate(arg_27_0)
	local tbl = {}

	scripts_utils_byte_array.write_string(tbl, DecompressDeflate)

	local tbl_2 = {}

	for i = 1, #tbl do
		local var_27_3 = tonumber(tbl[i])

		if var_27_3 ~= 0 then
			for j = 0, 7 do
				if not (bit.band(var_27_3, 2^j) ~= 0) then
					local num = j + 1 + 8 * (i - 1)

					tbl_2[NetworkLookup.pickup_names[num]] = true
				end
			end
		end
	end

	return tbl_2
end

local function fn_26(arg_28_0)
	-- function 28
	local ceil = math.ceil(#NetworkLookup.dlcs / 8)
	local tbl = {}

	for i = 1, ceil do
		tbl[i] = 0
	end

	for k in pairs(arg_28_0) do
		local var_28_2 = NetworkLookup.dlcs[k]
		local num = (var_28_2 - 1) % 8
		local ceil_2 = math.ceil(var_28_2 / 8)
		local var_28_5 = tbl[ceil_2]

		tbl[ceil_2] = bit.bor(var_28_5, 2^num)
	end

	local read_string = scripts_utils_byte_array.read_string(tbl)

	return (scripts_utils_lib_deflate:CompressDeflate(read_string))
end

local function fn_27(arg_29_0)
	-- function 29
	local DecompressDeflate = scripts_utils_lib_deflate:DecompressDeflate(arg_29_0)
	local tbl = {}

	scripts_utils_byte_array.write_string(tbl, DecompressDeflate)

	local tbl_2 = {}

	for i = 1, #tbl do
		local var_29_3 = tonumber(tbl[i])

		if var_29_3 ~= 0 then
			for j = 0, 7 do
				if not (bit.band(var_29_3, 2^j) ~= 0) then
					local num = j + 1 + 8 * (i - 1)

					tbl_2[NetworkLookup.dlcs[num]] = true
				end
			end
		end
	end

	return tbl_2
end

local function fn_28(arg_30_0)
	-- function 30
	local ceil = math.ceil(#NetworkLookup.mutator_templates / 8)
	local tbl = {}

	for i = 1, ceil do
		tbl[i] = 0
	end

	for k in pairs(arg_30_0) do
		local var_30_2 = NetworkLookup.mutator_templates[k]
		local num = (var_30_2 - 1) % 8
		local ceil_2 = math.ceil(var_30_2 / 8)
		local var_30_5 = tbl[ceil_2]

		tbl[ceil_2] = bit.bor(var_30_5, 2^num)
	end

	local read_string = scripts_utils_byte_array.read_string(tbl)

	return (scripts_utils_lib_deflate:CompressDeflate(read_string))
end

local function fn_29(arg_31_0)
	-- function 31
	local DecompressDeflate = scripts_utils_lib_deflate:DecompressDeflate(arg_31_0)
	local tbl = {}

	scripts_utils_byte_array.write_string(tbl, DecompressDeflate)

	local tbl_2 = {}

	for i = 1, #tbl do
		local var_31_3 = tonumber(tbl[i])

		if var_31_3 ~= 0 then
			for j = 0, 7 do
				if not (bit.band(var_31_3, 2^j) ~= 0) then
					local num = j + 1 + 8 * (i - 1)

					tbl_2[NetworkLookup.mutator_templates[num]] = true
				end
			end
		end
	end

	return tbl_2
end

local tbl = {
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
			encode = fn_8,
			decode = fn_9
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
			encode = fn_6,
			decode = fn_7
		},
		full_profile_peers = {
			type = "table",
			default_value = {},
			composite_keys = {},
			encode = fn_2,
			decode = fn_3
		},
		peers = {
			type = "table",
			default_value = {},
			composite_keys = {},
			encode = fn_10,
			decode = fn_11
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
			encode = fn_12,
			decode = fn_13
		},
		difficulty = {
			type = "string",
			default_value = "normal",
			composite_keys = {},
			encode = fn_18("difficulties"),
			decode = fn_19("difficulties")
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
			encode = fn_14,
			decode = fn_15
		},
		mechanism = {
			type = "string",
			default_value = "adventure",
			composite_keys = {},
			encode = fn_18("mechanism_keys"),
			decode = fn_19("mechanism_keys")
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
			encode = fn_20,
			decode = fn_21
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
			encode = fn_16,
			decode = fn_17
		},
		initialized_mutator_map = {
			type = "table",
			default_value = {},
			composite_keys = {},
			encode = fn_28,
			decode = fn_29
		},
		session_breed_map = {
			mute_print = true,
			type = "table",
			default_value = {},
			composite_keys = {},
			encode = fn_22,
			decode = fn_23
		},
		startup_breed_map = {
			type = "table",
			default_value = {},
			composite_keys = {},
			encode = fn_22,
			decode = fn_23
		},
		session_pickup_map = {
			mute_print = true,
			type = "table",
			default_value = {},
			composite_keys = {},
			encode = fn_24,
			decode = fn_25
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
			encode = fn_4,
			decode = fn_5
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
			encode = fn_22,
			decode = fn_23
		},
		loaded_session_pickup_map = {
			mute_print = true,
			type = "table",
			default_value = {},
			composite_keys = {},
			encode = fn_24,
			decode = fn_25
		},
		unlocked_dlcs = {
			mute_print = true,
			type = "table",
			default_value = {},
			composite_keys = {},
			encode = fn_26,
			decode = fn_27,
			immediate_initialization = function (self, arg_32_1)
				-- function 32
				local unlock = Managers.unlock
				local dlcs = NetworkLookup.dlcs
				local tbl = {}

				for i = 1, #dlcs do
					local var_32_3 = dlcs[i]

					tbl[var_32_3] = unlock:is_dlc_unlocked(var_32_3)
				end

				return self:get_key("unlocked_dlcs"), tbl
			end
		},
		loaded_mutator_map = {
			mute_print = true,
			type = "table",
			default_value = {},
			composite_keys = {},
			encode = fn_28,
			decode = fn_29
		}
	}
}

SharedState.validate_spec(tbl)

return tbl
