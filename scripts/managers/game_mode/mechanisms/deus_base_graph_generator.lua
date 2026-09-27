-- chunkname: @scripts/managers/game_mode/mechanisms/deus_base_graph_generator.lua

require("scripts/settings/dlcs/morris/deus_map_base_gen_settings")
require("scripts/settings/dlcs/morris/deus_map_seed_whitelist")
require("scripts/helpers/deus_gen_utils")

local tbl = {
	"SIGNATURE",
	"ARENA",
	"TRAVEL",
	"DUMMY",
	"SHOP",
	"START"
}
local tbl_2 = {
	FINAL = "FINAL",
	NEW = "NEW",
	EXISTING = "EXISTING"
}

local function fn(arg_1_0)
	-- function 1
	local tbl = {}

	for i = 0, arg_1_0 % 100 do
		tbl[#tbl + 1] = " "
	end

	return table.concat(tbl)
end

local function fn_2(arg_2_0, ...)
	-- function 2
	if not script_data.deus_base_graph_generator_debug then
		local var_2_0 = sprintf(...)

		print("[deus_base_graph_generator.lua] " .. fn(arg_2_0) .. var_2_0)
	end
end

local function fn_3(arg_3_0)
	-- function 3
	print("[deus_base_graph_generator.lua] WARNING: " .. arg_3_0)
end

local function fn_4(arg_4_0, arg_4_1)
	-- function 4
	local num = 0

	for k, v in pairs(arg_4_1) do
		num = num + v
	end

	local var_4_1 = arg_4_0(0, num * 100)
	local num_2 = 0

	for k_2, v_2 in pairs(arg_4_1) do
		num_2 = num_2 + v_2 * 100

		if var_4_1 <= num_2 then
			return k_2
		end
	end

	return nil
end

local function fn_5(arg_5_0)
	-- function 5
	local clone = table.clone(tbl)

	for i = #clone, 2, -1 do
		local var_5_1 = arg_5_0(1, i)

		clone[var_5_1], clone[i] = clone[i], clone[var_5_1]
	end

	return clone
end

local function fn_6(arg_6_0, arg_6_1)
	-- function 6
	local tbl = {}

	for k, v in pairs(arg_6_0) do
		tbl[#tbl + 1] = k
	end

	table.sort(tbl)

	for k_2 = #tbl, 2, -1 do
		local var_6_1 = arg_6_1(1, k_2)

		tbl[var_6_1], tbl[k_2] = tbl[k_2], tbl[var_6_1]
	end

	return tbl
end

local function fn_7(self, arg_7_1)
	-- function 7
	for i = #self, 2, -1 do
		local var_7_0 = arg_7_1(1, i)

		self[var_7_0], self[i] = self[i], self[var_7_0]
	end

	return self
end

local function fn_8(self, arg_8_1, arg_8_2)
	-- function 8
	if #self + arg_8_2 < #arg_8_1 then
		return false
	end

	local num = 0

	for i, v in ipairs(arg_8_1) do
		if v == "DUMMY" then
			if arg_8_2 - num <= 0 then
				return false
			end

			num = num + 1
		elseif v ~= self[i - num] then
			return false
		end
	end

	if arg_8_2 - num > 0 then
		return false
	end

	if #self + arg_8_2 == #arg_8_1 then
		return self[#self] == arg_8_1[#arg_8_1]
	end

	return true
end

local function fn_9(self, arg_9_1, arg_9_2)
	-- function 9
	for i, v in ipairs(self[arg_9_1].prev) do
		if v == arg_9_2 then
			return true
		elseif not fn_9(self, v, arg_9_2) then
			return true
		end
	end

	return false
end

local function fn_10(self, arg_10_1)
	-- function 10
	if #self[arg_10_1].prev == 0 then
		return {}
	end

	local tbl = {}

	for i, v in ipairs(self[arg_10_1].prev) do
		if self[v].type ~= "DUMMY" then
			tbl[#tbl + 1] = v
		else
			local var_10_1 = fn_10(self, v)

			for i_2, v_2 in ipairs(var_10_1) do
				tbl[#tbl + 1] = v_2
			end
		end
	end

	return tbl
end

local function fn_11(self, arg_11_1)
	-- function 11
	if #self[arg_11_1].next == 0 then
		return {}
	end

	local tbl = {}

	for i, v in ipairs(self[arg_11_1].next) do
		if self[v].type ~= "DUMMY" then
			tbl[#tbl + 1] = v
		else
			local var_11_1 = fn_11(self, v)

			for i_2, v_2 in ipairs(var_11_1) do
				tbl[#tbl + 1] = v_2
			end
		end
	end

	return tbl
end

local function fn_12(self, arg_12_1, arg_12_2)
	-- function 12
	if #self[arg_12_1].prev == 0 then
		return {
			0
		}
	end

	local tbl = {}

	for i, v in ipairs(self[arg_12_1].prev) do
		local num = 0

		if self[v].type == arg_12_2 then
			num = num + 1
		end

		local var_12_2 = fn_12(self, v, arg_12_2)

		for i_2, v_2 in ipairs(var_12_2) do
			tbl[#tbl + 1] = num + v_2
		end
	end

	return tbl
end

local function fn_13(self, arg_13_1)
	-- function 13
	local type = self[arg_13_1].type

	if #self[arg_13_1].prev == 0 then
		return {
			{
				type
			}
		}
	end

	local tbl = {}

	for i, v in ipairs(self[arg_13_1].prev) do
		local var_13_2 = fn_13(self, v)

		for i_2, v_2 in ipairs(var_13_2) do
			v_2[#v_2 + 1] = type
			tbl[#tbl + 1] = v_2
		end
	end

	return tbl
end

local function fn_14(self, arg_14_1)
	-- function 14
	if not (#self[arg_14_1].prev == 0 or not (#self[arg_14_1].prev > 1)) then
		return 0
	end

	local var_14_0 = self[arg_14_1].prev[1]
	local var_14_1 = self[var_14_0]

	fassert(var_14_1.connected_to ~= 0, "this should never happen")

	if var_14_1.connected_to > 1 then
		return 0
	end

	local type = self[arg_14_1].type
	local flag

	flag = not (type == "DUMMY" or type ~= "SHOP") and 1 and 0

	return flag + fn_14(self, var_14_0)
end

local function fn_15(arg_15_0, arg_15_1, arg_15_2, arg_15_3)
	-- function 15
	return (not (arg_15_2 <= arg_15_0) or not (arg_15_1 < arg_15_3)) and not (arg_15_0 <= arg_15_2) or arg_15_3 < arg_15_1
end

local function fn_16(self, arg_16_1)
	-- function 16
	if #self[arg_16_1].next == 0 then
		return {
			{
				arg_16_1
			}
		}
	end

	local tbl = {}

	for i, v in ipairs(self[arg_16_1].next) do
		local var_16_1 = fn_16(self, v)

		for i_2, v_2 in ipairs(var_16_1) do
			v_2[#v_2 + 1] = arg_16_1
			tbl[#tbl + 1] = v_2
		end
	end

	return tbl
end

local function fn_17(self, arg_17_1, arg_17_2)
	-- function 17
	local var_17_0 = fn_11(self, arg_17_1)

	if arg_17_2 > 1 then
		arg_17_2 = arg_17_2 - 1

		local tbl = {}

		for i, v in ipairs(var_17_0) do
			tbl[v] = self[v]

			local var_17_2 = fn_17(self, v, arg_17_2)

			for k, v_2 in pairs(var_17_2) do
				tbl[k] = v_2
			end
		end

		return tbl
	else
		local tbl_2 = {}

		for i_2, v_3 in ipairs(var_17_0) do
			tbl_2[v_3] = self[v_3]
		end

		return tbl_2
	end
end

local tbl_3 = {
	check_if_not_already_connected = function (arg_18_0, arg_18_1, arg_18_2, arg_18_3)
		-- function 18
		return not table.contains(arg_18_1[arg_18_2].next, arg_18_3)
	end,
	check_if_does_not_create_cycle = function (arg_19_0, arg_19_1, arg_19_2, arg_19_3)
		-- function 19
		if arg_19_2 == arg_19_3 then
			return false
		end

		if not fn_9(arg_19_1, arg_19_2, arg_19_3) then
			return false
		end

		return true
	end,
	check_if_not_at_max_incoming_connections = function (self, arg_20_1, arg_20_2, arg_20_3)
		-- function 20
		return #arg_20_1[arg_20_3].prev < self.MAX_INCOMING_CONNECTIONS_PER_NODE
	end,
	check_if_not_dummy = function (arg_21_0, arg_21_1, arg_21_2, arg_21_3)
		-- function 21
		return arg_21_1[arg_21_3].type ~= "DUMMY"
	end,
	check_if_layer_above = function (arg_22_0, arg_22_1, arg_22_2, arg_22_3)
		-- function 22
		local var_22_0 = arg_22_1[arg_22_2]
		local var_22_1 = arg_22_1[arg_22_3]

		return var_22_0.layout_x == var_22_1.layout_x - 1
	end,
	check_if_does_not_create_crossing = function (arg_23_0, arg_23_1, arg_23_2, arg_23_3)
		-- function 23
		local var_23_0 = arg_23_1[arg_23_2]
		local var_23_1 = arg_23_1[arg_23_3]

		for k, v in pairs(arg_23_1) do
			if v.layout_x == var_23_0.layout_x then
				for i, v_2 in ipairs(v.next) do
					if not fn_15(var_23_0.layout_y, var_23_1.layout_y, v.layout_y, arg_23_1[v_2].layout_y) then
						return false
					end
				end
			end
		end

		return true
	end,
	check_if_not_repeating_labels = function (self, arg_24_1, arg_24_2, arg_24_3)
		-- function 24
		local var_24_0 = fn_16(arg_24_1, "start")

		for i, v in ipairs(var_24_0) do
			local tbl = {}

			for i_2, v_2 in ipairs(v) do
				local var_24_2 = fn_17(arg_24_1, v_2, self.LABEL_LOOKAHEAD)

				for k, v_3 in pairs(var_24_2) do
					if not (not v_3.label and v_3.label == 0) then
						local var_24_3 = tbl[v_3.type]

						var_24_3 = var_24_3 or {}
						tbl[v_3.type] = var_24_3

						local var_24_4 = var_24_3[v_3.label]

						var_24_4 = var_24_4 or {}

						if not (not (#var_24_4 > 0) or table.contains(var_24_4, k)) then
							return false
						else
							var_24_4[#var_24_4 + 1] = k
						end

						var_24_3[v_3.label] = var_24_4
					end
				end
			end
		end

		return true
	end
}
local tbl_4 = {
	{
		check_if_not_over_limit_of_straight_line = function (self, arg_25_1, arg_25_2)
			-- function 25
			return fn_14(arg_25_1, arg_25_2) < self.MAX_STRAIGHT_LINE
		end,
		check_if_not_start_node = function (self, arg_26_1, arg_26_2)
			-- function 26
			return self.MAX_CONNECTIONS_PER_NODE == 1 or arg_26_2 ~= "start"
		end
	},
	{
		check_if_not_over_max_paths = function (self, arg_27_1, arg_27_2)
			-- function 27
			return #fn_12(arg_27_1, arg_27_2, "TRAVEL") < self.MAX_PATHS
		end,
		check_if_not_dummy = function (arg_28_0, arg_28_1, arg_28_2)
			-- function 28
			return arg_28_1[arg_28_2].type ~= "DUMMY"
		end,
		check_if_not_start_node = function (self, arg_29_1, arg_29_2)
			-- function 29
			return self.MAX_CONNECTIONS_PER_NODE == 1 or arg_29_2 ~= "start"
		end
	},
	{
		enforce_only_start_node = function (self, arg_30_1, arg_30_2)
			-- function 30
			return self.MAX_CONNECTIONS_PER_NODE == 1 or arg_30_2 == "start"
		end
	}
}
local tbl_5 = {
	NEW = {
		discourage_new_nodes_when_near_node_capacity = function (self, arg_31_1, arg_31_2, arg_31_3)
			-- function 31
			local num = 0

			for k, v in pairs(arg_31_1) do
				num = num + 1
			end

			if num < self.MAX_IDEAL_NODES * 0.5 then
				return arg_31_3
			end

			local num_2 = self.MAX_IDEAL_NODES * 0.5
			local var_31_2 = arg_31_3
			local num_3 = (num - num_2) / num_2

			return math.clamp(var_31_2 - var_31_2 * num_3, 1, var_31_2)
		end
	},
	EXISTING = {},
	FINAL = {}
}
local tbl_6 = {
	force_start_on_start_node = function (arg_32_0, arg_32_1, arg_32_2)
		-- function 32
		return arg_32_2 == "START"
	end
}
local tbl_7 = {
	end_with_arena = function (arg_33_0, arg_33_1, arg_33_2)
		-- function 33
		return arg_33_2 == "ARENA"
	end,
	only_one_signature_level_required_before_final_level = function (arg_34_0, arg_34_1, arg_34_2)
		-- function 34
		local final = arg_34_1.final

		while not final do
			if #final.prev ~= 1 then
				return false
			end

			local var_34_1 = arg_34_1[final.prev[1]]

			if var_34_1.type == "SIGNATURE" then
				return true
			end

			if var_34_1.type ~= "DUMMY" then
				return false
			end

			final = var_34_1
		end

		return false
	end,
	check_minimum_nodes = function (self, arg_35_1, arg_35_2)
		-- function 35
		local num = 0

		for k, v in pairs(arg_35_1) do
			if not (k == "final" or not (v.connected_to > #v.next)) then
				return true
			end

			num = num + 1
		end

		return num >= self.MIN_NODES
	end
}
local tbl_8 = {
	ANY = {
		check_allowed_sequences = function (self, arg_36_1, arg_36_2, arg_36_3)
			-- function 36
			local ALLOWED_SEQUENCES = self.ALLOWED_SEQUENCES
			local tbl = {}

			for i, v in ipairs(arg_36_1[arg_36_2].prev) do
				local var_36_2 = fn_13(arg_36_1, v)

				for i_2, v_2 in ipairs(var_36_2) do
					v_2[#v_2 + 1] = arg_36_3
					tbl[#tbl + 1] = v_2
				end
			end

			for i_3, v_3 in ipairs(tbl) do
				local flag = false

				for i_4, v_4 in ipairs(ALLOWED_SEQUENCES) do
					local num = self._max_sequence_length - #v_4

					if not fn_8(v_4, v_3, num) then
						flag = true

						break
					end
				end

				if not flag then
					return false
				end
			end

			return true
		end
	},
	ARENA = {
		only_on_final = function (arg_37_0, arg_37_1, arg_37_2)
			-- function 37
			return arg_37_2 == "final"
		end
	},
	SIGNATURE = {},
	TRAVEL = {},
	SHOP = {},
	DUMMY = {
		check_if_not_creating_dummy_choice = function (arg_38_0, arg_38_1, arg_38_2)
			-- function 38
			local prev = arg_38_1[arg_38_2].prev

			for i, v in ipairs(prev) do
				local next = arg_38_1[v].next

				for i_2, v_2 in ipairs(next) do
					if arg_38_1[v_2].type == "DUMMY" then
						return false
					end
				end
			end

			return true
		end,
		check_if_not_creating_consecutive_dummies = function (arg_39_0, arg_39_1, arg_39_2)
			-- function 39
			local prev = arg_39_1[arg_39_2].prev

			for i, v in ipairs(prev) do
				if arg_39_1[v].type == "DUMMY" then
					return false
				end
			end

			return true
		end
	},
	START = {}
}
local tbl_9 = {
	check_if_not_repeating_label = function (self, arg_40_1, arg_40_2)
		-- function 40
		local var_40_0 = fn_16(arg_40_1, "start")
		local var_40_1 = arg_40_1[arg_40_2]
		local label = var_40_1.label
		local type = var_40_1.type

		for i, v in ipairs(var_40_0) do
			local var_40_4

			for i_2, v_2 in ipairs(v) do
				local var_40_5 = fn_17(arg_40_1, v_2, self.LABEL_LOOKAHEAD)

				for k, v_3 in pairs(var_40_5) do
					if not ((v_3.type ~= type or not v_3.label) and v_3.label ~= label) then
						if not var_40_4 then
							var_40_4 = k
						elseif var_40_4 ~= k then
							return false
						end
					end
				end
			end
		end

		return true
	end
}
local tbl_10 = {
	prefer_not_shop_if_already_having_a_shop_choice = function (arg_41_0, arg_41_1, arg_41_2, arg_41_3)
		-- function 41
		local flag = false
		local var_41_1 = fn_10(arg_41_1, arg_41_2)

		for i, v in ipairs(var_41_1) do
			local var_41_2 = fn_11(arg_41_1, v)

			for i_2, v_2 in ipairs(var_41_2) do
				if not (v_2 == arg_41_2 or arg_41_1[v_2].type ~= "SHOP") then
					flag = true
				end
			end
		end

		if not flag then
			arg_41_3[table.index_of(arg_41_3, "SHOP")] = arg_41_3[#arg_41_3]
			arg_41_3[#arg_41_3] = "SHOP"
		end
	end
}

local function fn_18(self, arg_42_1, arg_42_2, arg_42_3, arg_42_4)
	-- function 42
	local CONNECTION_VALIDATIONS = self.CONNECTION_VALIDATIONS
	local var_42_1 = tbl_3

	for i, v in ipairs(CONNECTION_VALIDATIONS) do
		if not var_42_1[v](self, arg_42_2, arg_42_3, arg_42_4) then
			return false
		end
	end

	return true
end

local function fn_19(self, arg_43_1, arg_43_2, arg_43_3, arg_43_4)
	-- function 43
	local var_43_0 = self.CONNECTION_COUNT_VALIDATIONS[arg_43_4]
	local var_43_1 = tbl_4[arg_43_4]

	if not var_43_0 and not var_43_1 then
		for i, v in ipairs(var_43_0) do
			if not var_43_1[v](self, arg_43_2, arg_43_3) then
				return false
			end
		end
	end

	return true
end

local function fn_20(self, arg_44_1, arg_44_2, arg_44_3, arg_44_4)
	-- function 44
	if arg_44_3 == "start" then
		for i, v in ipairs(self.START_NODE_VALIDATIONS) do
			if not tbl_6[v](self, arg_44_2, arg_44_4) then
				return false
			end
		end
	end

	if arg_44_3 == "final" then
		for i_2, v_2 in ipairs(self.FINAL_NODE_VALIDATIONS) do
			if not tbl_7[v_2](self, arg_44_2, arg_44_4) then
				return false
			end
		end
	end

	for i_3, v_3 in ipairs(self.NODE_TYPE_VALIDATIONS.ANY) do
		if not tbl_8.ANY[v_3](self, arg_44_2, arg_44_3, arg_44_4) then
			return false
		end
	end

	local var_44_0 = self.NODE_TYPE_VALIDATIONS[arg_44_4]
	local var_44_1 = tbl_8[arg_44_4]

	for i_4, v_4 in ipairs(var_44_0) do
		if not var_44_1[v_4](self, arg_44_2, arg_44_3, arg_44_4) then
			return false
		end
	end

	return true
end

local function fn_21(arg_45_0, arg_45_1, arg_45_2, arg_45_3)
	-- function 45
	for k, v in pairs(arg_45_2[arg_45_3].next) do
		if not fn_20(arg_45_0, arg_45_1, arg_45_2, v, arg_45_2[v].type) then
			return false
		end

		if not fn_21(arg_45_0, arg_45_1, arg_45_2, v) then
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

local function fn_22(arg_46_0, arg_46_1, arg_46_2, arg_46_3)
	-- function 46
	local var_46_0 = arg_46_1[arg_46_2]
	local var_46_1 = arg_46_1[arg_46_3]
	local flag = false

	local function fn()
		-- function 47
		if not flag then
			var_46_0.next[#var_46_0.next] = nil
			var_46_1.prev[#var_46_1.prev] = nil
			flag = false
		end
	end

	local function fn_2()
		-- function 48
		var_46_0.next[#var_46_0.next + 1] = arg_46_3
		var_46_1.prev[#var_46_1.prev + 1] = arg_46_2
		flag = true
	end

	local function fn_3()
		-- function 49
		fn_2()

		if not fn_20(arg_46_0.config, arg_46_0.indent, arg_46_1, arg_46_3, var_46_1.type) and not fn_21(arg_46_0.config, arg_46_0.indent, arg_46_1, arg_46_3) then
			return true
		end

		fn()

		return false
	end

	return {
		name = "connect_to_existing " .. arg_46_2,
		run = function ()
			-- function 50
			return fn_3()
		end,
		retry = function ()
			-- function 51
			fn()

			return false
		end
	}
end

local function fn_23(arg_52_0, arg_52_1, arg_52_2, arg_52_3)
	-- function 52
	local var_52_0 = arg_52_1[arg_52_2]
	local var_52_1
	local var_52_2

	local function fn()
		-- function 53
		local node_count = arg_52_0.node_count
		local var_53_1 = arg_52_0
		local num

		if not node_count then
			num = node_count + 1

			if not num then
				-- Nothing
			end
		end

		num = 1

		::label_53_0::

		var_53_1.node_count = num

		local var_53_3 = arg_52_3

		var_53_3 = var_53_3 or "node_" .. arg_52_0.node_count
		var_52_2 = var_53_3
		var_52_1 = var_52_0.layout_x + 1

		local var_53_4 = arg_52_0.nodes_per_layer[var_52_1]

		if not var_53_4 then
			var_53_4 = {}
			arg_52_0.nodes_per_layer[var_52_1] = var_53_4
		end

		var_53_4[#var_53_4 + 1] = var_52_2

		local count = #var_53_4

		arg_52_1[var_52_2] = {
			name = var_52_2,
			prev = {
				arg_52_2
			},
			next = {},
			layout_x = var_52_1,
			layout_y = count
		}
		var_52_0.next[#var_52_0.next + 1] = var_52_2

		local tbl = {
			function ()
				-- function 54
				return var_0_31(arg_52_0, arg_52_1, var_52_2)
			end
		}

		return true, tbl
	end

	return {
		name = "new_node " .. arg_52_2,
		run = function ()
			-- function 55
			return fn()
		end,
		retry = function ()
			-- function 56
			if not var_52_2 then
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

local function fn_24(arg_57_0, arg_57_1, arg_57_2, arg_57_3)
	-- function 57
	local function fn()
		-- function 58
		return fn_6(arg_57_1, arg_57_0.random_generator)
	end

	local var_57_1

	local function fn_2()
		-- function 59
		if arg_57_3 == tbl_2.NEW then
			local tbl = {
				function ()
					-- function 60
					return fn_23(arg_57_0, arg_57_1, arg_57_2)
				end
			}

			return true, tbl
		elseif arg_57_3 == tbl_2.EXISTING then
			if not var_57_1 then
				var_57_1 = fn()
			end

			local var_59_1

			while #var_57_1 > 0 do
				local var_59_2 = var_57_1[#var_57_1]

				var_57_1[#var_57_1] = nil

				if var_59_2 == "final" or not fn_18(arg_57_0.config, arg_57_0.indent, arg_57_1, arg_57_2, var_59_2) then
					var_59_1 = var_59_2

					break
				end
			end

			if not var_59_1 then
				return false
			end

			local tbl_3 = {
				function ()
					-- function 61
					return fn_22(arg_57_0, arg_57_1, arg_57_2, var_59_1)
				end
			}

			return true, tbl_3
		elseif arg_57_3 == tbl_2.FINAL then
			if not arg_57_1.final then
				local tbl_4 = {
					function ()
						-- function 62
						return fn_23(arg_57_0, arg_57_1, arg_57_2, "final")
					end
				}

				return true, tbl_4
			else
				if not fn_18(arg_57_0.config, arg_57_0.indent, arg_57_1, arg_57_2, "final") then
					local tbl_5 = {
						function ()
							-- function 63
							return fn_22(arg_57_0, arg_57_1, arg_57_2, "final")
						end
					}

					return true, tbl_5
				end

				return false
			end
		end

		fassert(false, "shouldn't come here")
	end

	return {
		name = "connection_type " .. arg_57_2 .. " " .. arg_57_3,
		run = function ()
			-- function 64
			return fn_2()
		end,
		retry = function ()
			-- function 65
			if arg_57_3 == tbl_2.NEW then
				return false
			elseif arg_57_3 == tbl_2.EXISTING then
				return fn_2()
			elseif arg_57_3 == tbl_2.FINAL then
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

local function fn_25(arg_66_0, arg_66_1, arg_66_2)
	-- function 66
	local function fn()
		-- function 67
		local tbl = {
			[tbl_2.NEW] = 100,
			[tbl_2.EXISTING] = 100,
			[tbl_2.FINAL] = 100
		}

		for k, v in pairs(tbl) do
			local var_67_1 = arg_66_0.config.CONNECTION_TYPE_WEIGHT_TRANSFORMS[k]

			for i, v_2 in ipairs(var_67_1) do
				tbl[k] = tbl_5[k][v_2](arg_66_0.config, arg_66_1, arg_66_2, tbl[k])
			end
		end

		return tbl
	end

	local var_66_1

	local function fn_2()
		-- function 68
		if not var_66_1 then
			var_66_1 = fn()
		end

		local var_68_0 = fn_4(arg_66_0.random_generator, var_66_1)

		if not var_68_0 then
			var_66_1[var_68_0] = nil
		end

		if not var_68_0 then
			return false
		end

		local tbl = {
			function ()
				-- function 69
				return fn_24(arg_66_0, arg_66_1, arg_66_2, var_68_0)
			end
		}

		return true, tbl
	end

	return {
		name = "connection_type " .. arg_66_2,
		run = function ()
			-- function 70
			return fn_2()
		end,
		retry = function ()
			-- function 71
			return fn_2()
		end
	}
end

local function fn_26(arg_72_0, arg_72_1, arg_72_2)
	-- function 72
	local var_72_0 = arg_72_1[arg_72_2]

	local function fn()
		-- function 73
		local tbl = {}

		for i = 1, var_72_0.connected_to do
			tbl[i] = function ()
				-- function 74
				return fn_25(arg_72_0, arg_72_1, arg_72_2)
			end
		end

		return true, tbl
	end

	return {
		name = "connections " .. arg_72_2,
		run = function ()
			-- function 75
			return fn()
		end,
		retry = function ()
			-- function 76
			return false
		end
	}
end

local function fn_27(arg_77_0, arg_77_1, arg_77_2)
	-- function 77
	local var_77_0 = arg_77_1[arg_77_2]

	local function fn()
		-- function 78
		local tbl = {}

		for i = 1, arg_77_0.config.MAX_CONNECTIONS_PER_NODE do
			tbl[#tbl + 1] = i
		end

		return fn_7(tbl, arg_77_0.random_generator)
	end

	local var_77_2
	local var_77_3

	local function fn_2()
		-- function 79
		if not var_77_2 then
			var_77_2 = fn()
		end

		while #var_77_2 > 0 do
			local var_79_0 = var_77_2[#var_77_2]

			var_77_2[#var_77_2] = nil

			if not var_77_3 and not (var_79_0 < var_77_3) or not fn_19(arg_77_0.config, arg_77_0.indent, arg_77_1, arg_77_2, var_79_0) then
				var_77_0.connected_to = var_79_0

				break
			end
		end

		if not var_77_0.connected_to then
			return false
		end

		var_77_3 = var_77_0.connected_to

		local tbl = {
			function ()
				-- function 80
				return fn_26(arg_77_0, arg_77_1, arg_77_2)
			end
		}

		return true, tbl
	end

	return {
		name = "connect " .. arg_77_2,
		run = function ()
			-- function 81
			return fn_2()
		end,
		retry = function ()
			-- function 82
			var_77_0.connected_to = nil

			return fn_2()
		end
	}
end

local function fn_28(self, arg_83_1, arg_83_2)
	-- function 83
	local var_83_0 = arg_83_1[arg_83_2]
	local type = var_83_0.type
	local var_83_2
	local var_83_3 = self.config.LABELLED_NODE_TYPES[type]

	local function fn()
		-- function 84
		if not var_83_3 then
			if not var_83_2 then
				var_83_2 = {}

				local flag = false
				local var_84_1

				for i = 1, self.config.LABELS_AVAILABLE[type] do
					local flag_2 = false

					for k, v in pairs(arg_83_1) do
						if not (v.type ~= type or v.label ~= i) then
							var_83_2[#var_83_2 + 1] = i
							flag_2 = true

							break
						end
					end

					if not (flag_2 or flag) then
						var_83_2[#var_83_2 + 1] = i
						var_84_1 = #var_83_2
						flag = true
					end
				end

				if not flag then
					local var_84_3 = var_83_2[1]

					var_83_2[1] = var_83_2[var_84_1]
					var_83_2[var_84_1] = var_84_3
				end
			end

			while #var_83_2 > 0 do
				local var_84_4 = var_83_2[#var_83_2]

				var_83_2[#var_83_2] = nil

				local LABEL_VALIDATIONS = self.config.LABEL_VALIDATIONS
				local var_84_6 = tbl_9

				var_83_0.label = var_84_4

				local flag_3 = false

				for i_2, v_2 in ipairs(LABEL_VALIDATIONS) do
					if not var_84_6[v_2](self.config, arg_83_1, arg_83_2) then
						flag_3 = true

						break
					end
				end

				if not flag_3 then
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
			local tbl = {
				function ()
					-- function 85
					return fn_27(self, arg_83_1, arg_83_2)
				end
			}

			return true, tbl
		end
	end

	return {
		name = "node_label " .. arg_83_2,
		run = function ()
			-- function 86
			return fn()
		end,
		retry = function ()
			-- function 87
			if not var_83_3 then
				var_83_0.label = nil

				return fn()
			end

			return false
		end
	}
end

function var_0_31(arg_88_0, arg_88_1, arg_88_2)
	-- function 88
	local var_88_0 = arg_88_1[arg_88_2]
	local var_88_1

	local function fn()
		-- function 89
		if not var_88_1 then
			var_88_1 = fn_5(arg_88_0.random_generator)

			for i, v in ipairs(arg_88_0.config.NODE_TYPE_SHUFFLERS) do
				tbl_10[v](arg_88_0, arg_88_1, arg_88_2, var_88_1)
			end

			table.reverse(var_88_1)
		end

		while #var_88_1 > 0 do
			local var_89_0 = var_88_1[#var_88_1]

			var_88_1[#var_88_1] = nil

			if not fn_20(arg_88_0.config, arg_88_0.indent, arg_88_1, arg_88_2, var_89_0) then
				var_88_0.type = var_89_0

				break
			end
		end

		if not var_88_0.type then
			return false
		end

		local tbl = {
			function ()
				-- function 90
				return fn_28(arg_88_0, arg_88_1, arg_88_2)
			end
		}

		return true, tbl
	end

	return {
		name = "node " .. arg_88_2,
		run = function ()
			-- function 91
			return fn()
		end,
		retry = function ()
			-- function 92
			var_88_0.type = nil

			return fn()
		end
	}
end

local function fn_29(self)
	-- function 93
	local tbl = {}

	for k, v in pairs(self) do
		if v.type ~= "DUMMY" then
			tbl[k] = v
		else
			local next = v.next
			local prev = v.prev

			for i, v_2 in ipairs(prev) do
				local var_93_3 = self[v_2]
				local tbl_2 = {}

				for i_2, v_3 in ipairs(var_93_3.next) do
					if v_3 ~= k then
						tbl_2[#tbl_2 + 1] = v_3
					end
				end

				for i_3, v_4 in ipairs(next) do
					tbl_2[#tbl_2 + 1] = v_4
				end

				var_93_3.next = tbl_2
			end

			for i_4, v_5 in ipairs(next) do
				local var_93_5 = self[v_5]
				local tbl_3 = {}

				for i_5, v_6 in ipairs(var_93_5.prev) do
					if v_6 ~= k then
						tbl_3[#tbl_3 + 1] = v_6
					end
				end

				for i_6, v_7 in ipairs(prev) do
					tbl_3[#tbl_3 + 1] = v_7
				end

				var_93_5.prev = tbl_3
			end
		end
	end

	return tbl
end

function deus_base_graph_generator(arg_94_0, arg_94_1)
	-- function 94
	local create_random_generator = DeusGenUtils.create_random_generator(arg_94_0)
	local tbl = {
		start = {
			layout_x = 1,
			name = "start",
			layout_y = 1,
			prev = {},
			next = {}
		}
	}
	local num = 0

	for i, v in ipairs(arg_94_1.ALLOWED_SEQUENCES) do
		num = math.max(#v, num)
	end

	arg_94_1._max_sequence_length = num

	local tbl_2 = {
		{
			"start"
		}
	}
	local tbl_3 = {
		indent = 0,
		random_generator = create_random_generator,
		config = arg_94_1,
		nodes_per_layer = tbl_2
	}

	local function fn(arg_95_0, arg_95_1)
		-- function 95
		tbl_3.indent = #arg_95_0
	end

	local tbl_4 = {
		var_0_31(tbl_3, tbl, "start")
	}
	local get_generator = DeusGenEngine.get_generator(tbl_4, fn)

	return function ()
		-- function 96
		local var_96_0, var_96_1 = get_generator()

		if not var_96_0 then
			if not var_96_1 then
				tbl = fn_29(tbl)
			else
				Application.warning("[deus_base_graph_generator.lua] failed to generate base graph, maybe the settings are impossible to solve? error: " .. (var_96_1 or "N/A"))
			end
		end

		return var_96_0, var_96_1, tbl
	end
end
