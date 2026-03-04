-- chunkname: @scripts/managers/game_mode/mechanisms/deus_base_graph_generator.lua

require("scripts/settings/dlcs/morris/deus_map_base_gen_settings")
require("scripts/settings/dlcs/morris/deus_map_seed_whitelist")
require("scripts/helpers/deus_gen_utils")

local var_0_0 = {
	"SIGNATURE",
	"ARENA",
	"TRAVEL",
	"DUMMY",
	"SHOP",
	"START"
}
local var_0_1 = {
	FINAL = "FINAL",
	NEW = "NEW",
	EXISTING = "EXISTING"
}

local function var_0_2(arg_1_0)
	local var_1_0 = {}

	for iter_1_0 = 0, arg_1_0 % 100 do
		var_1_0[#var_1_0 + 1] = " "
	end

	return table.concat(var_1_0)
end

local function var_0_3(arg_2_0, ...)
	if script_data.deus_base_graph_generator_debug then
		local var_2_0 = sprintf(...)

		print("[deus_base_graph_generator.lua] " .. var_0_2(arg_2_0) .. var_2_0)
	end
end

local function var_0_4(arg_3_0)
	print("[deus_base_graph_generator.lua] WARNING: " .. arg_3_0)
end

local function var_0_5(arg_4_0, arg_4_1)
	local var_4_0 = 0

	for iter_4_0, iter_4_1 in pairs(arg_4_1) do
		var_4_0 = var_4_0 + iter_4_1
	end

	local var_4_1 = arg_4_0(0, var_4_0 * 100)
	local var_4_2 = 0

	for iter_4_2, iter_4_3 in pairs(arg_4_1) do
		var_4_2 = var_4_2 + iter_4_3 * 100

		if var_4_1 <= var_4_2 then
			return iter_4_2
		end
	end

	return nil
end

local function var_0_6(arg_5_0)
	local var_5_0 = table.clone(var_0_0)

	for iter_5_0 = #var_5_0, 2, -1 do
		local var_5_1 = arg_5_0(1, iter_5_0)

		var_5_0[var_5_1], var_5_0[iter_5_0] = var_5_0[iter_5_0], var_5_0[var_5_1]
	end

	return var_5_0
end

local function var_0_7(arg_6_0, arg_6_1)
	local var_6_0 = {}

	for iter_6_0, iter_6_1 in pairs(arg_6_0) do
		var_6_0[#var_6_0 + 1] = iter_6_0
	end

	table.sort(var_6_0)

	for iter_6_2 = #var_6_0, 2, -1 do
		local var_6_1 = arg_6_1(1, iter_6_2)

		var_6_0[var_6_1], var_6_0[iter_6_2] = var_6_0[iter_6_2], var_6_0[var_6_1]
	end

	return var_6_0
end

local function var_0_8(arg_7_0, arg_7_1)
	for iter_7_0 = #arg_7_0, 2, -1 do
		local var_7_0 = arg_7_1(1, iter_7_0)

		arg_7_0[var_7_0], arg_7_0[iter_7_0] = arg_7_0[iter_7_0], arg_7_0[var_7_0]
	end

	return arg_7_0
end

local function var_0_9(arg_8_0, arg_8_1, arg_8_2)
	if #arg_8_0 + arg_8_2 < #arg_8_1 then
		return false
	end

	local var_8_0 = 0

	for iter_8_0, iter_8_1 in ipairs(arg_8_1) do
		if iter_8_1 == "DUMMY" then
			if arg_8_2 - var_8_0 <= 0 then
				return false
			end

			var_8_0 = var_8_0 + 1
		elseif iter_8_1 ~= arg_8_0[iter_8_0 - var_8_0] then
			return false
		end
	end

	if arg_8_2 - var_8_0 > 0 then
		return false
	end

	if #arg_8_0 + arg_8_2 == #arg_8_1 then
		return arg_8_0[#arg_8_0] == arg_8_1[#arg_8_1]
	end

	return true
end

local function var_0_10(arg_9_0, arg_9_1, arg_9_2)
	for iter_9_0, iter_9_1 in ipairs(arg_9_0[arg_9_1].prev) do
		if iter_9_1 == arg_9_2 then
			return true
		elseif var_0_10(arg_9_0, iter_9_1, arg_9_2) then
			return true
		end
	end

	return false
end

local function var_0_11(arg_10_0, arg_10_1)
	if #arg_10_0[arg_10_1].prev == 0 then
		return {}
	end

	local var_10_0 = {}

	for iter_10_0, iter_10_1 in ipairs(arg_10_0[arg_10_1].prev) do
		if arg_10_0[iter_10_1].type ~= "DUMMY" then
			var_10_0[#var_10_0 + 1] = iter_10_1
		else
			local var_10_1 = var_0_11(arg_10_0, iter_10_1)

			for iter_10_2, iter_10_3 in ipairs(var_10_1) do
				var_10_0[#var_10_0 + 1] = iter_10_3
			end
		end
	end

	return var_10_0
end

local function var_0_12(arg_11_0, arg_11_1)
	if #arg_11_0[arg_11_1].next == 0 then
		return {}
	end

	local var_11_0 = {}

	for iter_11_0, iter_11_1 in ipairs(arg_11_0[arg_11_1].next) do
		if arg_11_0[iter_11_1].type ~= "DUMMY" then
			var_11_0[#var_11_0 + 1] = iter_11_1
		else
			local var_11_1 = var_0_12(arg_11_0, iter_11_1)

			for iter_11_2, iter_11_3 in ipairs(var_11_1) do
				var_11_0[#var_11_0 + 1] = iter_11_3
			end
		end
	end

	return var_11_0
end

local function var_0_13(arg_12_0, arg_12_1, arg_12_2)
	if #arg_12_0[arg_12_1].prev == 0 then
		return {
			0
		}
	end

	local var_12_0 = {}

	for iter_12_0, iter_12_1 in ipairs(arg_12_0[arg_12_1].prev) do
		local var_12_1 = 0

		if arg_12_0[iter_12_1].type == arg_12_2 then
			var_12_1 = var_12_1 + 1
		end

		local var_12_2 = var_0_13(arg_12_0, iter_12_1, arg_12_2)

		for iter_12_2, iter_12_3 in ipairs(var_12_2) do
			var_12_0[#var_12_0 + 1] = var_12_1 + iter_12_3
		end
	end

	return var_12_0
end

local function var_0_14(arg_13_0, arg_13_1)
	local var_13_0 = arg_13_0[arg_13_1].type

	if #arg_13_0[arg_13_1].prev == 0 then
		return {
			{
				var_13_0
			}
		}
	end

	local var_13_1 = {}

	for iter_13_0, iter_13_1 in ipairs(arg_13_0[arg_13_1].prev) do
		local var_13_2 = var_0_14(arg_13_0, iter_13_1)

		for iter_13_2, iter_13_3 in ipairs(var_13_2) do
			iter_13_3[#iter_13_3 + 1] = var_13_0
			var_13_1[#var_13_1 + 1] = iter_13_3
		end
	end

	return var_13_1
end

local function var_0_15(arg_14_0, arg_14_1)
	if #arg_14_0[arg_14_1].prev == 0 or #arg_14_0[arg_14_1].prev > 1 then
		return 0
	end

	local var_14_0 = arg_14_0[arg_14_1].prev[1]
	local var_14_1 = arg_14_0[var_14_0]

	fassert(var_14_1.connected_to ~= 0, "this should never happen")

	if var_14_1.connected_to > 1 then
		return 0
	end

	local var_14_2 = arg_14_0[arg_14_1].type

	return (var_14_2 ~= "DUMMY" and var_14_2 ~= "SHOP" and 1 or 0) + var_0_15(arg_14_0, var_14_0)
end

local function var_0_16(arg_15_0, arg_15_1, arg_15_2, arg_15_3)
	return arg_15_2 <= arg_15_0 and arg_15_1 < arg_15_3 or arg_15_0 <= arg_15_2 and arg_15_3 < arg_15_1
end

local function var_0_17(arg_16_0, arg_16_1)
	if #arg_16_0[arg_16_1].next == 0 then
		return {
			{
				arg_16_1
			}
		}
	end

	local var_16_0 = {}

	for iter_16_0, iter_16_1 in ipairs(arg_16_0[arg_16_1].next) do
		local var_16_1 = var_0_17(arg_16_0, iter_16_1)

		for iter_16_2, iter_16_3 in ipairs(var_16_1) do
			iter_16_3[#iter_16_3 + 1] = arg_16_1
			var_16_0[#var_16_0 + 1] = iter_16_3
		end
	end

	return var_16_0
end

local function var_0_18(arg_17_0, arg_17_1, arg_17_2)
	local var_17_0 = var_0_12(arg_17_0, arg_17_1)

	if arg_17_2 > 1 then
		arg_17_2 = arg_17_2 - 1

		local var_17_1 = {}

		for iter_17_0, iter_17_1 in ipairs(var_17_0) do
			var_17_1[iter_17_1] = arg_17_0[iter_17_1]

			local var_17_2 = var_0_18(arg_17_0, iter_17_1, arg_17_2)

			for iter_17_2, iter_17_3 in pairs(var_17_2) do
				var_17_1[iter_17_2] = iter_17_3
			end
		end

		return var_17_1
	else
		local var_17_3 = {}

		for iter_17_4, iter_17_5 in ipairs(var_17_0) do
			var_17_3[iter_17_5] = arg_17_0[iter_17_5]
		end

		return var_17_3
	end
end

local var_0_19 = {
	check_if_not_already_connected = function(arg_18_0, arg_18_1, arg_18_2, arg_18_3)
		return not table.contains(arg_18_1[arg_18_2].next, arg_18_3)
	end,
	check_if_does_not_create_cycle = function(arg_19_0, arg_19_1, arg_19_2, arg_19_3)
		if arg_19_2 == arg_19_3 then
			return false
		end

		if var_0_10(arg_19_1, arg_19_2, arg_19_3) then
			return false
		end

		return true
	end,
	check_if_not_at_max_incoming_connections = function(arg_20_0, arg_20_1, arg_20_2, arg_20_3)
		return #arg_20_1[arg_20_3].prev < arg_20_0.MAX_INCOMING_CONNECTIONS_PER_NODE
	end,
	check_if_not_dummy = function(arg_21_0, arg_21_1, arg_21_2, arg_21_3)
		return arg_21_1[arg_21_3].type ~= "DUMMY"
	end,
	check_if_layer_above = function(arg_22_0, arg_22_1, arg_22_2, arg_22_3)
		local var_22_0 = arg_22_1[arg_22_2]
		local var_22_1 = arg_22_1[arg_22_3]

		return var_22_0.layout_x == var_22_1.layout_x - 1
	end,
	check_if_does_not_create_crossing = function(arg_23_0, arg_23_1, arg_23_2, arg_23_3)
		local var_23_0 = arg_23_1[arg_23_2]
		local var_23_1 = arg_23_1[arg_23_3]

		for iter_23_0, iter_23_1 in pairs(arg_23_1) do
			if iter_23_1.layout_x == var_23_0.layout_x then
				for iter_23_2, iter_23_3 in ipairs(iter_23_1.next) do
					if var_0_16(var_23_0.layout_y, var_23_1.layout_y, iter_23_1.layout_y, arg_23_1[iter_23_3].layout_y) then
						return false
					end
				end
			end
		end

		return true
	end,
	check_if_not_repeating_labels = function(arg_24_0, arg_24_1, arg_24_2, arg_24_3)
		local var_24_0 = var_0_17(arg_24_1, "start")

		for iter_24_0, iter_24_1 in ipairs(var_24_0) do
			local var_24_1 = {}

			for iter_24_2, iter_24_3 in ipairs(iter_24_1) do
				local var_24_2 = var_0_18(arg_24_1, iter_24_3, arg_24_0.LABEL_LOOKAHEAD)

				for iter_24_4, iter_24_5 in pairs(var_24_2) do
					if iter_24_5.label and iter_24_5.label ~= 0 then
						local var_24_3 = var_24_1[iter_24_5.type] or {}

						var_24_1[iter_24_5.type] = var_24_3

						local var_24_4 = var_24_3[iter_24_5.label] or {}

						if #var_24_4 > 0 and not table.contains(var_24_4, iter_24_4) then
							return false
						else
							var_24_4[#var_24_4 + 1] = iter_24_4
						end

						var_24_3[iter_24_5.label] = var_24_4
					end
				end
			end
		end

		return true
	end
}
local var_0_20 = {
	{
		check_if_not_over_limit_of_straight_line = function(arg_25_0, arg_25_1, arg_25_2)
			return var_0_15(arg_25_1, arg_25_2) < arg_25_0.MAX_STRAIGHT_LINE
		end,
		check_if_not_start_node = function(arg_26_0, arg_26_1, arg_26_2)
			return arg_26_0.MAX_CONNECTIONS_PER_NODE == 1 or arg_26_2 ~= "start"
		end
	},
	{
		check_if_not_over_max_paths = function(arg_27_0, arg_27_1, arg_27_2)
			return #var_0_13(arg_27_1, arg_27_2, "TRAVEL") < arg_27_0.MAX_PATHS
		end,
		check_if_not_dummy = function(arg_28_0, arg_28_1, arg_28_2)
			return arg_28_1[arg_28_2].type ~= "DUMMY"
		end,
		check_if_not_start_node = function(arg_29_0, arg_29_1, arg_29_2)
			return arg_29_0.MAX_CONNECTIONS_PER_NODE == 1 or arg_29_2 ~= "start"
		end
	},
	{
		enforce_only_start_node = function(arg_30_0, arg_30_1, arg_30_2)
			return arg_30_0.MAX_CONNECTIONS_PER_NODE == 1 or arg_30_2 == "start"
		end
	}
}
local var_0_21 = {
	NEW = {
		discourage_new_nodes_when_near_node_capacity = function(arg_31_0, arg_31_1, arg_31_2, arg_31_3)
			local var_31_0 = 0

			for iter_31_0, iter_31_1 in pairs(arg_31_1) do
				var_31_0 = var_31_0 + 1
			end

			if var_31_0 < arg_31_0.MAX_IDEAL_NODES * 0.5 then
				return arg_31_3
			end

			local var_31_1 = arg_31_0.MAX_IDEAL_NODES * 0.5
			local var_31_2 = arg_31_3
			local var_31_3 = (var_31_0 - var_31_1) / var_31_1

			return math.clamp(var_31_2 - var_31_2 * var_31_3, 1, var_31_2)
		end
	},
	EXISTING = {},
	FINAL = {}
}
local var_0_22 = {
	force_start_on_start_node = function(arg_32_0, arg_32_1, arg_32_2)
		return arg_32_2 == "START"
	end
}
local var_0_23 = {
	end_with_arena = function(arg_33_0, arg_33_1, arg_33_2)
		return arg_33_2 == "ARENA"
	end,
	only_one_signature_level_required_before_final_level = function(arg_34_0, arg_34_1, arg_34_2)
		local var_34_0 = arg_34_1.final

		while var_34_0 do
			if #var_34_0.prev ~= 1 then
				return false
			end

			local var_34_1 = arg_34_1[var_34_0.prev[1]]

			if var_34_1.type == "SIGNATURE" then
				return true
			end

			if var_34_1.type ~= "DUMMY" then
				return false
			end

			var_34_0 = var_34_1
		end

		return false
	end,
	check_minimum_nodes = function(arg_35_0, arg_35_1, arg_35_2)
		local var_35_0 = 0

		for iter_35_0, iter_35_1 in pairs(arg_35_1) do
			if iter_35_0 ~= "final" and iter_35_1.connected_to > #iter_35_1.next then
				return true
			end

			var_35_0 = var_35_0 + 1
		end

		return var_35_0 >= arg_35_0.MIN_NODES
	end
}
local var_0_24 = {
	ANY = {
		check_allowed_sequences = function(arg_36_0, arg_36_1, arg_36_2, arg_36_3)
			local var_36_0 = arg_36_0.ALLOWED_SEQUENCES
			local var_36_1 = {}

			for iter_36_0, iter_36_1 in ipairs(arg_36_1[arg_36_2].prev) do
				local var_36_2 = var_0_14(arg_36_1, iter_36_1)

				for iter_36_2, iter_36_3 in ipairs(var_36_2) do
					iter_36_3[#iter_36_3 + 1] = arg_36_3
					var_36_1[#var_36_1 + 1] = iter_36_3
				end
			end

			for iter_36_4, iter_36_5 in ipairs(var_36_1) do
				local var_36_3 = false

				for iter_36_6, iter_36_7 in ipairs(var_36_0) do
					local var_36_4 = arg_36_0._max_sequence_length - #iter_36_7

					if var_0_9(iter_36_7, iter_36_5, var_36_4) then
						var_36_3 = true

						break
					end
				end

				if not var_36_3 then
					return false
				end
			end

			return true
		end
	},
	ARENA = {
		only_on_final = function(arg_37_0, arg_37_1, arg_37_2)
			return arg_37_2 == "final"
		end
	},
	SIGNATURE = {},
	TRAVEL = {},
	SHOP = {},
	DUMMY = {
		check_if_not_creating_dummy_choice = function(arg_38_0, arg_38_1, arg_38_2)
			local var_38_0 = arg_38_1[arg_38_2].prev

			for iter_38_0, iter_38_1 in ipairs(var_38_0) do
				local var_38_1 = arg_38_1[iter_38_1].next

				for iter_38_2, iter_38_3 in ipairs(var_38_1) do
					if arg_38_1[iter_38_3].type == "DUMMY" then
						return false
					end
				end
			end

			return true
		end,
		check_if_not_creating_consecutive_dummies = function(arg_39_0, arg_39_1, arg_39_2)
			local var_39_0 = arg_39_1[arg_39_2].prev

			for iter_39_0, iter_39_1 in ipairs(var_39_0) do
				if arg_39_1[iter_39_1].type == "DUMMY" then
					return false
				end
			end

			return true
		end
	},
	START = {}
}
local var_0_25 = {
	check_if_not_repeating_label = function(arg_40_0, arg_40_1, arg_40_2)
		local var_40_0 = var_0_17(arg_40_1, "start")
		local var_40_1 = arg_40_1[arg_40_2]
		local var_40_2 = var_40_1.label
		local var_40_3 = var_40_1.type

		for iter_40_0, iter_40_1 in ipairs(var_40_0) do
			local var_40_4

			for iter_40_2, iter_40_3 in ipairs(iter_40_1) do
				local var_40_5 = var_0_18(arg_40_1, iter_40_3, arg_40_0.LABEL_LOOKAHEAD)

				for iter_40_4, iter_40_5 in pairs(var_40_5) do
					if iter_40_5.type == var_40_3 and iter_40_5.label and iter_40_5.label == var_40_2 then
						if not var_40_4 then
							var_40_4 = iter_40_4
						elseif var_40_4 ~= iter_40_4 then
							return false
						end
					end
				end
			end
		end

		return true
	end
}
local var_0_26 = {
	prefer_not_shop_if_already_having_a_shop_choice = function(arg_41_0, arg_41_1, arg_41_2, arg_41_3)
		local var_41_0 = false
		local var_41_1 = var_0_11(arg_41_1, arg_41_2)

		for iter_41_0, iter_41_1 in ipairs(var_41_1) do
			local var_41_2 = var_0_12(arg_41_1, iter_41_1)

			for iter_41_2, iter_41_3 in ipairs(var_41_2) do
				if iter_41_3 ~= arg_41_2 and arg_41_1[iter_41_3].type == "SHOP" then
					var_41_0 = true
				end
			end
		end

		if var_41_0 then
			arg_41_3[table.index_of(arg_41_3, "SHOP")] = arg_41_3[#arg_41_3]
			arg_41_3[#arg_41_3] = "SHOP"
		end
	end
}

local function var_0_27(arg_42_0, arg_42_1, arg_42_2, arg_42_3, arg_42_4)
	local var_42_0 = arg_42_0.CONNECTION_VALIDATIONS
	local var_42_1 = var_0_19

	for iter_42_0, iter_42_1 in ipairs(var_42_0) do
		if not var_42_1[iter_42_1](arg_42_0, arg_42_2, arg_42_3, arg_42_4) then
			return false
		end
	end

	return true
end

local function var_0_28(arg_43_0, arg_43_1, arg_43_2, arg_43_3, arg_43_4)
	local var_43_0 = arg_43_0.CONNECTION_COUNT_VALIDATIONS[arg_43_4]
	local var_43_1 = var_0_20[arg_43_4]

	if var_43_0 and var_43_1 then
		for iter_43_0, iter_43_1 in ipairs(var_43_0) do
			if not var_43_1[iter_43_1](arg_43_0, arg_43_2, arg_43_3) then
				return false
			end
		end
	end

	return true
end

local function var_0_29(arg_44_0, arg_44_1, arg_44_2, arg_44_3, arg_44_4)
	if arg_44_3 == "start" then
		for iter_44_0, iter_44_1 in ipairs(arg_44_0.START_NODE_VALIDATIONS) do
			if not var_0_22[iter_44_1](arg_44_0, arg_44_2, arg_44_4) then
				return false
			end
		end
	end

	if arg_44_3 == "final" then
		for iter_44_2, iter_44_3 in ipairs(arg_44_0.FINAL_NODE_VALIDATIONS) do
			if not var_0_23[iter_44_3](arg_44_0, arg_44_2, arg_44_4) then
				return false
			end
		end
	end

	for iter_44_4, iter_44_5 in ipairs(arg_44_0.NODE_TYPE_VALIDATIONS.ANY) do
		if not var_0_24.ANY[iter_44_5](arg_44_0, arg_44_2, arg_44_3, arg_44_4) then
			return false
		end
	end

	local var_44_0 = arg_44_0.NODE_TYPE_VALIDATIONS[arg_44_4]
	local var_44_1 = var_0_24[arg_44_4]

	for iter_44_6, iter_44_7 in ipairs(var_44_0) do
		if not var_44_1[iter_44_7](arg_44_0, arg_44_2, arg_44_3, arg_44_4) then
			return false
		end
	end

	return true
end

local function var_0_30(arg_45_0, arg_45_1, arg_45_2, arg_45_3)
	for iter_45_0, iter_45_1 in pairs(arg_45_2[arg_45_3].next) do
		if not var_0_29(arg_45_0, arg_45_1, arg_45_2, iter_45_1, arg_45_2[iter_45_1].type) then
			return false
		end

		if not var_0_30(arg_45_0, arg_45_1, arg_45_2, iter_45_1) then
			return false
		end
	end

	return true
end

local var_0_31
local var_0_32
local var_0_33
local var_0_34
local var_0_35
local var_0_36
local var_0_37
local var_0_38

local function var_0_39(arg_46_0, arg_46_1, arg_46_2, arg_46_3)
	local var_46_0 = arg_46_1[arg_46_2]
	local var_46_1 = arg_46_1[arg_46_3]
	local var_46_2 = false

	local function var_46_3()
		if var_46_2 then
			var_46_0.next[#var_46_0.next] = nil
			var_46_1.prev[#var_46_1.prev] = nil
			var_46_2 = false
		end
	end

	local function var_46_4()
		var_46_0.next[#var_46_0.next + 1] = arg_46_3
		var_46_1.prev[#var_46_1.prev + 1] = arg_46_2
		var_46_2 = true
	end

	local function var_46_5()
		var_46_4()

		if var_0_29(arg_46_0.config, arg_46_0.indent, arg_46_1, arg_46_3, var_46_1.type) and var_0_30(arg_46_0.config, arg_46_0.indent, arg_46_1, arg_46_3) then
			return true
		end

		var_46_3()

		return false
	end

	return {
		name = "connect_to_existing " .. arg_46_2,
		run = function()
			return var_46_5()
		end,
		retry = function()
			var_46_3()

			return false
		end
	}
end

local function var_0_40(arg_52_0, arg_52_1, arg_52_2, arg_52_3)
	local var_52_0 = arg_52_1[arg_52_2]
	local var_52_1
	local var_52_2

	local function var_52_3()
		local var_53_0 = arg_52_0.node_count

		arg_52_0.node_count = var_53_0 and var_53_0 + 1 or 1
		var_52_2 = arg_52_3 or "node_" .. arg_52_0.node_count
		var_52_1 = var_52_0.layout_x + 1

		local var_53_1 = arg_52_0.nodes_per_layer[var_52_1]

		if not var_53_1 then
			var_53_1 = {}
			arg_52_0.nodes_per_layer[var_52_1] = var_53_1
		end

		var_53_1[#var_53_1 + 1] = var_52_2

		local var_53_2 = #var_53_1

		arg_52_1[var_52_2] = {
			name = var_52_2,
			prev = {
				arg_52_2
			},
			next = {},
			layout_x = var_52_1,
			layout_y = var_53_2
		}
		var_52_0.next[#var_52_0.next + 1] = var_52_2

		local var_53_3 = {
			function()
				return var_0_31(arg_52_0, arg_52_1, var_52_2)
			end
		}

		return true, var_53_3
	end

	return {
		name = "new_node " .. arg_52_2,
		run = function()
			return var_52_3()
		end,
		retry = function()
			if var_52_2 then
				arg_52_1[var_52_2] = nil
				var_52_0.next[#var_52_0.next] = nil
				arg_52_0.node_count = arg_52_0.node_count - 1

				local var_56_0 = arg_52_0.nodes_per_layer[var_52_1]

				var_56_0[#var_56_0] = nil
			end

			return false
		end
	}
end

local function var_0_41(arg_57_0, arg_57_1, arg_57_2, arg_57_3)
	local function var_57_0()
		return var_0_7(arg_57_1, arg_57_0.random_generator)
	end

	local var_57_1

	local function var_57_2()
		if arg_57_3 == var_0_1.NEW then
			local var_59_0 = {
				function()
					return var_0_40(arg_57_0, arg_57_1, arg_57_2)
				end
			}

			return true, var_59_0
		elseif arg_57_3 == var_0_1.EXISTING then
			if not var_57_1 then
				var_57_1 = var_57_0()
			end

			local var_59_1

			while #var_57_1 > 0 do
				local var_59_2 = var_57_1[#var_57_1]

				var_57_1[#var_57_1] = nil

				if var_59_2 ~= "final" and var_0_27(arg_57_0.config, arg_57_0.indent, arg_57_1, arg_57_2, var_59_2) then
					var_59_1 = var_59_2

					break
				end
			end

			if not var_59_1 then
				return false
			end

			local var_59_3 = {
				function()
					return var_0_39(arg_57_0, arg_57_1, arg_57_2, var_59_1)
				end
			}

			return true, var_59_3
		elseif arg_57_3 == var_0_1.FINAL then
			if not arg_57_1.final then
				local var_59_4 = {
					function()
						return var_0_40(arg_57_0, arg_57_1, arg_57_2, "final")
					end
				}

				return true, var_59_4
			else
				if var_0_27(arg_57_0.config, arg_57_0.indent, arg_57_1, arg_57_2, "final") then
					local var_59_5 = {
						function()
							return var_0_39(arg_57_0, arg_57_1, arg_57_2, "final")
						end
					}

					return true, var_59_5
				end

				return false
			end
		end

		fassert(false, "shouldn't come here")
	end

	return {
		name = "connection_type " .. arg_57_2 .. " " .. arg_57_3,
		run = function()
			return var_57_2()
		end,
		retry = function()
			if arg_57_3 == var_0_1.NEW then
				return false
			elseif arg_57_3 == var_0_1.EXISTING then
				return var_57_2()
			elseif arg_57_3 == var_0_1.FINAL then
				if not arg_57_1.final then
					return false
				else
					return false
				end
			end

			fassert(false, "shouldn't come here")
		end
	}
end

local function var_0_42(arg_66_0, arg_66_1, arg_66_2)
	local function var_66_0()
		local var_67_0 = {
			[var_0_1.NEW] = 100,
			[var_0_1.EXISTING] = 100,
			[var_0_1.FINAL] = 100
		}

		for iter_67_0, iter_67_1 in pairs(var_67_0) do
			local var_67_1 = arg_66_0.config.CONNECTION_TYPE_WEIGHT_TRANSFORMS[iter_67_0]

			for iter_67_2, iter_67_3 in ipairs(var_67_1) do
				var_67_0[iter_67_0] = var_0_21[iter_67_0][iter_67_3](arg_66_0.config, arg_66_1, arg_66_2, var_67_0[iter_67_0])
			end
		end

		return var_67_0
	end

	local var_66_1

	local function var_66_2()
		if not var_66_1 then
			var_66_1 = var_66_0()
		end

		local var_68_0 = var_0_5(arg_66_0.random_generator, var_66_1)

		if var_68_0 then
			var_66_1[var_68_0] = nil
		end

		if not var_68_0 then
			return false
		end

		local var_68_1 = {
			function()
				return var_0_41(arg_66_0, arg_66_1, arg_66_2, var_68_0)
			end
		}

		return true, var_68_1
	end

	return {
		name = "connection_type " .. arg_66_2,
		run = function()
			return var_66_2()
		end,
		retry = function()
			return var_66_2()
		end
	}
end

local function var_0_43(arg_72_0, arg_72_1, arg_72_2)
	local var_72_0 = arg_72_1[arg_72_2]

	local function var_72_1()
		local var_73_0 = {}

		for iter_73_0 = 1, var_72_0.connected_to do
			var_73_0[iter_73_0] = function()
				return var_0_42(arg_72_0, arg_72_1, arg_72_2)
			end
		end

		return true, var_73_0
	end

	return {
		name = "connections " .. arg_72_2,
		run = function()
			return var_72_1()
		end,
		retry = function()
			return false
		end
	}
end

local function var_0_44(arg_77_0, arg_77_1, arg_77_2)
	local var_77_0 = arg_77_1[arg_77_2]

	local function var_77_1()
		local var_78_0 = {}

		for iter_78_0 = 1, arg_77_0.config.MAX_CONNECTIONS_PER_NODE do
			var_78_0[#var_78_0 + 1] = iter_78_0
		end

		return var_0_8(var_78_0, arg_77_0.random_generator)
	end

	local var_77_2
	local var_77_3

	local function var_77_4()
		if not var_77_2 then
			var_77_2 = var_77_1()
		end

		while #var_77_2 > 0 do
			local var_79_0 = var_77_2[#var_77_2]

			var_77_2[#var_77_2] = nil

			if (not var_77_3 or var_79_0 < var_77_3) and var_0_28(arg_77_0.config, arg_77_0.indent, arg_77_1, arg_77_2, var_79_0) then
				var_77_0.connected_to = var_79_0

				break
			end
		end

		if not var_77_0.connected_to then
			return false
		end

		var_77_3 = var_77_0.connected_to

		local var_79_1 = {
			function()
				return var_0_43(arg_77_0, arg_77_1, arg_77_2)
			end
		}

		return true, var_79_1
	end

	return {
		name = "connect " .. arg_77_2,
		run = function()
			return var_77_4()
		end,
		retry = function()
			var_77_0.connected_to = nil

			return var_77_4()
		end
	}
end

local function var_0_45(arg_83_0, arg_83_1, arg_83_2)
	local var_83_0 = arg_83_1[arg_83_2]
	local var_83_1 = var_83_0.type
	local var_83_2
	local var_83_3 = arg_83_0.config.LABELLED_NODE_TYPES[var_83_1]

	local function var_83_4()
		if var_83_3 then
			if not var_83_2 then
				var_83_2 = {}

				local var_84_0 = false
				local var_84_1

				for iter_84_0 = 1, arg_83_0.config.LABELS_AVAILABLE[var_83_1] do
					local var_84_2 = false

					for iter_84_1, iter_84_2 in pairs(arg_83_1) do
						if iter_84_2.type == var_83_1 and iter_84_2.label == iter_84_0 then
							var_83_2[#var_83_2 + 1] = iter_84_0
							var_84_2 = true

							break
						end
					end

					if not var_84_2 and not var_84_0 then
						var_83_2[#var_83_2 + 1] = iter_84_0
						var_84_1 = #var_83_2
						var_84_0 = true
					end
				end

				if var_84_0 then
					local var_84_3 = var_83_2[1]

					var_83_2[1] = var_83_2[var_84_1]
					var_83_2[var_84_1] = var_84_3
				end
			end

			while #var_83_2 > 0 do
				local var_84_4 = var_83_2[#var_83_2]

				var_83_2[#var_83_2] = nil

				local var_84_5 = arg_83_0.config.LABEL_VALIDATIONS
				local var_84_6 = var_0_25

				var_83_0.label = var_84_4

				local var_84_7 = false

				for iter_84_3, iter_84_4 in ipairs(var_84_5) do
					if not var_84_6[iter_84_4](arg_83_0.config, arg_83_1, arg_83_2) then
						var_84_7 = true

						break
					end
				end

				if var_84_7 then
					var_83_0.label = nil
				else
					break
				end
			end

			if not var_83_0.label then
				return false
			end
		end

		if arg_83_2 == "final" then
			return true
		else
			local var_84_8 = {
				function()
					return var_0_44(arg_83_0, arg_83_1, arg_83_2)
				end
			}

			return true, var_84_8
		end
	end

	return {
		name = "node_label " .. arg_83_2,
		run = function()
			return var_83_4()
		end,
		retry = function()
			if var_83_3 then
				var_83_0.label = nil

				return var_83_4()
			end

			return false
		end
	}
end

function var_0_31(arg_88_0, arg_88_1, arg_88_2)
	local var_88_0 = arg_88_1[arg_88_2]
	local var_88_1

	local function var_88_2()
		if not var_88_1 then
			var_88_1 = var_0_6(arg_88_0.random_generator)

			for iter_89_0, iter_89_1 in ipairs(arg_88_0.config.NODE_TYPE_SHUFFLERS) do
				var_0_26[iter_89_1](arg_88_0, arg_88_1, arg_88_2, var_88_1)
			end

			table.reverse(var_88_1)
		end

		while #var_88_1 > 0 do
			local var_89_0 = var_88_1[#var_88_1]

			var_88_1[#var_88_1] = nil

			if var_0_29(arg_88_0.config, arg_88_0.indent, arg_88_1, arg_88_2, var_89_0) then
				var_88_0.type = var_89_0

				break
			end
		end

		if not var_88_0.type then
			return false
		end

		local var_89_1 = {
			function()
				return var_0_45(arg_88_0, arg_88_1, arg_88_2)
			end
		}

		return true, var_89_1
	end

	return {
		name = "node " .. arg_88_2,
		run = function()
			return var_88_2()
		end,
		retry = function()
			var_88_0.type = nil

			return var_88_2()
		end
	}
end

local function var_0_46(arg_93_0)
	local var_93_0 = {}

	for iter_93_0, iter_93_1 in pairs(arg_93_0) do
		if iter_93_1.type ~= "DUMMY" then
			var_93_0[iter_93_0] = iter_93_1
		else
			local var_93_1 = iter_93_1.next
			local var_93_2 = iter_93_1.prev

			for iter_93_2, iter_93_3 in ipairs(var_93_2) do
				local var_93_3 = arg_93_0[iter_93_3]
				local var_93_4 = {}

				for iter_93_4, iter_93_5 in ipairs(var_93_3.next) do
					if iter_93_5 ~= iter_93_0 then
						var_93_4[#var_93_4 + 1] = iter_93_5
					end
				end

				for iter_93_6, iter_93_7 in ipairs(var_93_1) do
					var_93_4[#var_93_4 + 1] = iter_93_7
				end

				var_93_3.next = var_93_4
			end

			for iter_93_8, iter_93_9 in ipairs(var_93_1) do
				local var_93_5 = arg_93_0[iter_93_9]
				local var_93_6 = {}

				for iter_93_10, iter_93_11 in ipairs(var_93_5.prev) do
					if iter_93_11 ~= iter_93_0 then
						var_93_6[#var_93_6 + 1] = iter_93_11
					end
				end

				for iter_93_12, iter_93_13 in ipairs(var_93_2) do
					var_93_6[#var_93_6 + 1] = iter_93_13
				end

				var_93_5.prev = var_93_6
			end
		end
	end

	return var_93_0
end

function deus_base_graph_generator(arg_94_0, arg_94_1)
	local var_94_0 = DeusGenUtils.create_random_generator(arg_94_0)
	local var_94_1 = {
		start = {
			layout_x = 1,
			name = "start",
			layout_y = 1,
			prev = {},
			next = {}
		}
	}
	local var_94_2 = 0

	for iter_94_0, iter_94_1 in ipairs(arg_94_1.ALLOWED_SEQUENCES) do
		var_94_2 = math.max(#iter_94_1, var_94_2)
	end

	arg_94_1._max_sequence_length = var_94_2

	local var_94_3 = {
		{
			"start"
		}
	}
	local var_94_4 = {
		indent = 0,
		random_generator = var_94_0,
		config = arg_94_1,
		nodes_per_layer = var_94_3
	}

	local function var_94_5(arg_95_0, arg_95_1)
		var_94_4.indent = #arg_95_0
	end

	local var_94_6 = {
		var_0_31(var_94_4, var_94_1, "start")
	}
	local var_94_7 = DeusGenEngine.get_generator(var_94_6, var_94_5)

	return function()
		local var_96_0, var_96_1 = var_94_7()

		if var_96_0 then
			if not var_96_1 then
				var_94_1 = var_0_46(var_94_1)
			else
				Application.warning("[deus_base_graph_generator.lua] failed to generate base graph, maybe the settings are impossible to solve? error: " .. (var_96_1 or "N/A"))
			end
		end

		return var_96_0, var_96_1, var_94_1
	end
end
