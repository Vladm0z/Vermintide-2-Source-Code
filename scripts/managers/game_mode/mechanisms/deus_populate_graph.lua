-- chunkname: @scripts/managers/game_mode/mechanisms/deus_populate_graph.lua

require("scripts/settings/dlcs/morris/deus_map_populate_settings")
require("scripts/managers/game_mode/mechanisms/deus_gen_engine")
require("scripts/helpers/deus_gen_utils")

local function var_0_0(arg_1_0, arg_1_1)
	for iter_1_0 = #arg_1_0, 2, -1 do
		local var_1_0 = arg_1_1(1, iter_1_0)

		arg_1_0[var_1_0], arg_1_0[iter_1_0] = arg_1_0[iter_1_0], arg_1_0[var_1_0]
	end

	return arg_1_0
end

local function var_0_1(arg_2_0, arg_2_1)
	local var_2_0 = {}

	for iter_2_0, iter_2_1 in pairs(arg_2_0) do
		var_2_0[#var_2_0 + 1] = iter_2_0
	end

	table.sort(var_2_0)

	for iter_2_2 = #var_2_0, 2, -1 do
		local var_2_1 = arg_2_1(1, iter_2_2)

		var_2_0[var_2_1], var_2_0[iter_2_2] = var_2_0[iter_2_2], var_2_0[var_2_1]
	end

	return var_2_0
end

local function var_0_2(arg_3_0)
	local var_3_0 = {}

	for iter_3_0, iter_3_1 in pairs(arg_3_0) do
		var_3_0[#var_3_0 + 1] = iter_3_1
	end

	return var_3_0
end

local function var_0_3(arg_4_0, arg_4_1)
	local var_4_0 = {}

	for iter_4_0, iter_4_1 in pairs(arg_4_0) do
		if arg_4_1 < iter_4_1.run_progress then
			var_4_0[#var_4_0 + 1] = iter_4_1
		end
	end

	return var_4_0
end

local function var_0_4(arg_5_0, arg_5_1)
	local var_5_0 = {}

	for iter_5_0, iter_5_1 in ipairs(arg_5_0) do
		if table.contains(arg_5_1, iter_5_1.type) then
			var_5_0[#var_5_0 + 1] = iter_5_1
		end
	end

	return var_5_0
end

local function var_0_5(arg_6_0, arg_6_1)
	if #arg_6_0[arg_6_1].prev == 0 then
		return {
			{
				arg_6_1
			}
		}
	end

	local var_6_0 = {}

	for iter_6_0, iter_6_1 in ipairs(arg_6_0[arg_6_1].prev) do
		local var_6_1 = var_0_5(arg_6_0, iter_6_1)

		for iter_6_2, iter_6_3 in ipairs(var_6_1) do
			iter_6_3[#iter_6_3 + 1] = arg_6_1
			var_6_0[#var_6_0 + 1] = iter_6_3
		end
	end

	return var_6_0
end

local function var_0_6(arg_7_0, arg_7_1)
	local var_7_0 = {}

	local function var_7_1(arg_8_0)
		for iter_8_0, iter_8_1 in ipairs(arg_7_0[arg_8_0].next) do
			if not var_7_0[iter_8_1] then
				var_7_0[iter_8_1] = true

				var_7_1(iter_8_1)
			end
		end
	end

	local function var_7_2(arg_9_0)
		for iter_9_0, iter_9_1 in ipairs(arg_7_0[arg_9_0].prev) do
			if not var_7_0[iter_9_1] then
				var_7_0[iter_9_1] = true

				var_7_2(iter_9_1)
			end
		end
	end

	var_7_1(arg_7_1)
	var_7_2(arg_7_1)

	return var_7_0
end

local function var_0_7(arg_10_0, arg_10_1)
	if #arg_10_0[arg_10_1].next == 0 then
		return {}
	end

	local var_10_0 = {}

	for iter_10_0, iter_10_1 in ipairs(arg_10_0[arg_10_1].next) do
		local var_10_1 = arg_10_0[iter_10_1].type

		if var_10_1 == "SIGNATURE" or var_10_1 == "TRAVEL" or var_10_1 == "ARENA" then
			var_10_0[#var_10_0 + 1] = iter_10_1
		else
			local var_10_2 = var_0_7(arg_10_0, iter_10_1)

			for iter_10_2, iter_10_3 in ipairs(var_10_2) do
				var_10_0[#var_10_0 + 1] = iter_10_3
			end
		end
	end

	return var_10_0
end

local function var_0_8(arg_11_0, arg_11_1, arg_11_2)
	if arg_11_2 > 1 then
		arg_11_2 = arg_11_2 - 1

		local var_11_0 = {}

		for iter_11_0, iter_11_1 in ipairs(arg_11_0[arg_11_1].next) do
			local var_11_1 = var_0_8(arg_11_0, iter_11_1, arg_11_2)

			for iter_11_2, iter_11_3 in pairs(var_11_1) do
				var_11_0[iter_11_2] = iter_11_3
			end
		end

		return var_11_0
	else
		return arg_11_0[arg_11_1].next
	end
end

local function var_0_9(arg_12_0, arg_12_1, arg_12_2, arg_12_3)
	local var_12_0 = arg_12_1[arg_12_2].prev

	for iter_12_0, iter_12_1 in ipairs(var_12_0) do
		local var_12_1 = arg_12_1[iter_12_1]

		for iter_12_2, iter_12_3 in ipairs(var_12_1.next) do
			local var_12_2 = arg_12_1[iter_12_3]

			if iter_12_3 ~= arg_12_2 and var_12_2.level == arg_12_3 then
				return false
			end
		end
	end

	return true
end

local function var_0_10(arg_13_0, arg_13_1, arg_13_2, arg_13_3)
	local var_13_0 = var_0_5(arg_13_1, arg_13_2)

	for iter_13_0, iter_13_1 in ipairs(var_13_0) do
		for iter_13_2 = #iter_13_1, 1, -1 do
			local var_13_1 = iter_13_1[iter_13_2]

			if var_13_1 ~= arg_13_2 and arg_13_1[var_13_1].level == arg_13_3 then
				return false
			end
		end
	end

	return true
end

local function var_0_11(arg_14_0, arg_14_1, arg_14_2, arg_14_3)
	local var_14_0 = arg_14_1[arg_14_2]

	for iter_14_0, iter_14_1 in ipairs(var_14_0.next) do
		if #arg_14_1[iter_14_1].next == 0 then
			return arg_14_0.SPECIFIC_SIGNATURE_LEVEL == arg_14_3
		end
	end

	return true
end

local var_0_12 = {
	SIGNATURE = {
		prevent_same_level_choice = var_0_9,
		last_signature_level_is_specific_level = var_0_11,
		prevent_same_level_on_same_path = var_0_10
	},
	TRAVEL = {
		prevent_same_level_choice = var_0_9,
		prevent_same_level_on_same_path = var_0_10
	},
	SHOP = {
		prevent_same_level_choice = var_0_9
	},
	ARENA = {}
}
local var_0_13 = {
	lower_priority_of_already_used_levels_on_path = function(arg_15_0, arg_15_1, arg_15_2, arg_15_3)
		local function var_15_0(arg_16_0, arg_16_1)
			if arg_15_1[arg_16_0].level == arg_16_1 then
				return true
			end

			for iter_16_0, iter_16_1 in ipairs(arg_15_1[arg_16_0].prev) do
				if var_15_0(iter_16_1, arg_16_1) then
					return true
				end
			end

			return false
		end

		local var_15_1 = #arg_15_3

		for iter_15_0 = #arg_15_3, 1, -1 do
			local var_15_2 = arg_15_3[iter_15_0]

			if var_15_0(arg_15_2, var_15_2) then
				arg_15_3[iter_15_0] = arg_15_3[var_15_1]
				arg_15_3[var_15_1] = var_15_2
				var_15_1 = var_15_1 - 1
			end
		end
	end
}
local var_0_14 = {
	last_signature_level_is_specific_level = function(arg_17_0, arg_17_1, arg_17_2)
		local var_17_0 = arg_17_0.config.SPECIFIC_SIGNATURE_LEVEL

		fassert(var_17_0, "you need to specify a SPECIFIC_SIGNATURE_LEVEL when using LABEL_OVERRIDES.last_signature_level_is_specific_level")

		local var_17_1 = arg_17_2.SIGNATURE
		local var_17_2

		for iter_17_0, iter_17_1 in ipairs(arg_17_1.final.prev) do
			local var_17_3 = arg_17_1[iter_17_1]

			if var_17_3.type == "SIGNATURE" then
				var_17_2 = var_17_3.label

				break
			end
		end

		fassert(var_17_2, "a graph needs to have a signature level just before the end in order for LABEL_OVERRIDES.last_signature_level_is_specific_level to work")

		local var_17_4

		for iter_17_2, iter_17_3 in pairs(var_17_1) do
			if iter_17_3 == var_17_0 then
				var_17_4 = iter_17_2

				break
			end
		end

		fassert(var_17_4, sprintf("In LABEL_OVERRIDES.last_signature_level_is_specific_level the level %s was not found in the level availability", var_17_0))

		var_17_1[var_17_4], var_17_1[var_17_2] = var_17_1[var_17_2], var_17_0

		return arg_17_2
	end
}
local var_0_15 = {
	prevent_modifier_on_curse_abundance_of_life = function(arg_18_0, arg_18_1, arg_18_2, arg_18_3)
		return arg_18_1[arg_18_2].curse ~= "curse_abundance_of_life" or not table.contains(arg_18_3, "increased_grenades") and not table.contains(arg_18_3, "increased_healing")
	end
}

local function var_0_16(arg_19_0, arg_19_1, arg_19_2, arg_19_3, arg_19_4)
	local var_19_0 = arg_19_2[arg_19_3].type
	local var_19_1 = arg_19_0.LEVEL_VALIDATIONS[var_19_0]
	local var_19_2 = var_0_12[var_19_0]

	for iter_19_0, iter_19_1 in ipairs(var_19_1) do
		if not var_19_2[iter_19_1](arg_19_0, arg_19_2, arg_19_3, arg_19_4) then
			return false
		end
	end

	return true
end

local function var_0_17(arg_20_0, arg_20_1, arg_20_2)
	local var_20_0 = arg_20_1[arg_20_2]

	if not var_0_16(arg_20_0.config, arg_20_0.indent, arg_20_1, arg_20_2, var_20_0.level, arg_20_0.indent) then
		return false
	end

	for iter_20_0, iter_20_1 in ipairs(var_20_0.next) do
		if not var_0_17(arg_20_0, arg_20_1, iter_20_1) then
			return false
		end
	end

	return true
end

local function var_0_18(arg_21_0, arg_21_1, arg_21_2, arg_21_3)
	local var_21_0 = arg_21_1[arg_21_2].type
	local var_21_1 = arg_21_0.config.LEVEL_AVAILABILITY[var_21_0]
	local var_21_2 = table.clone(var_21_1[arg_21_3].paths)

	local function var_21_3(arg_22_0)
		local var_22_0 = arg_21_1[arg_22_0]

		if var_22_0.level == arg_21_3 then
			local var_22_1 = table.index_of(var_21_2, var_22_0.path)

			if var_22_1 ~= -1 then
				table.swap_delete(var_21_2, var_22_1)
			end
		end
	end

	local function var_21_4(arg_23_0)
		local var_23_0 = arg_21_1[arg_23_0]

		for iter_23_0, iter_23_1 in ipairs(var_23_0.prev) do
			var_21_3(iter_23_1)
			var_21_4(iter_23_1)
		end
	end

	local function var_21_5(arg_24_0)
		local var_24_0 = arg_21_1[arg_24_0]

		for iter_24_0, iter_24_1 in ipairs(var_24_0.next) do
			var_21_3(iter_24_1)
			var_21_5(iter_24_1)
		end
	end

	var_21_3(arg_21_2)
	var_21_4(arg_21_2)
	var_21_5(arg_21_2)

	return var_21_2
end

local var_0_19
local var_0_20
local var_0_21

local function var_0_22(arg_25_0, arg_25_1, arg_25_2)
	local function var_25_0()
		local var_26_0 = arg_25_1[arg_25_2]
		local var_26_1 = var_0_0(table.clone(var_26_0.next), arg_25_0.random_generator)
		local var_26_2 = {}

		for iter_26_0 = 1, #var_26_1 do
			var_26_2[iter_26_0] = function()
				return var_0_19(arg_25_0, arg_25_1, var_26_1[iter_26_0])
			end
		end

		return true, var_26_2
	end

	return {
		name = "connections " .. arg_25_2,
		run = function()
			return var_25_0()
		end,
		retry = function()
			return false
		end
	}
end

function var_0_19(arg_30_0, arg_30_1, arg_30_2)
	local var_30_0 = arg_30_1[arg_30_2]
	local var_30_1 = var_30_0.type

	return {
		name = "node " .. arg_30_2,
		run = function()
			if var_30_0.level then
				return var_0_17(arg_30_0, arg_30_1, arg_30_2)
			end

			local var_31_0 = {
				function()
					return var_0_20(arg_30_0, arg_30_1, arg_30_2)
				end
			}

			return true, var_31_0
		end,
		retry = function()
			return false
		end
	}
end

function var_0_20(arg_34_0, arg_34_1, arg_34_2)
	local var_34_0 = arg_34_1[arg_34_2]
	local var_34_1 = var_34_0.type
	local var_34_2 = var_34_0.label
	local var_34_3 = arg_34_0.config.LEVEL_AVAILABILITY[var_34_1]

	local function var_34_4()
		local var_35_0 = var_0_1(var_34_3, arg_34_0.random_generator)

		for iter_35_0, iter_35_1 in ipairs(arg_34_0.config.LEVEL_SHUFFLERS) do
			var_0_13[iter_35_1](arg_34_0, arg_34_1, arg_34_2, var_35_0)
		end

		table.reverse(var_35_0)

		return var_35_0
	end

	local var_34_5

	local function var_34_6()
		if var_34_2 and var_34_2 ~= 0 then
			var_34_0.level = arg_34_0.shuffled_levels_for_labels[var_34_1][var_34_2]

			local var_36_0 = var_34_3[var_34_0.level].paths
			local var_36_1 = var_0_0(table.clone(var_36_0), arg_34_0.random_generator)

			var_34_0.path = var_36_1[1]
		else
			if not var_34_5 then
				var_34_5 = var_34_4()
			end

			while #var_34_5 > 0 do
				local var_36_2 = var_34_5[#var_34_5]

				var_34_5[#var_34_5] = nil

				if var_0_16(arg_34_0.config, arg_34_0.indent, arg_34_1, arg_34_2, var_36_2) then
					if var_34_0.type == "SHOP" then
						var_34_0.level = var_36_2

						break
					else
						local var_36_3 = var_0_18(arg_34_0, arg_34_1, arg_34_2, var_36_2)

						if #var_36_3 == 0 then
							-- block empty
						else
							local var_36_4 = var_0_0(table.clone(var_36_3), arg_34_0.random_generator)

							var_34_0.level = var_36_2
							var_34_0.path = var_36_4[1]

							break
						end
					end
				end
			end
		end

		if not var_34_0.level then
			return false
		end

		local var_36_5 = {
			function()
				return var_0_22(arg_34_0, arg_34_1, arg_34_2)
			end
		}

		return true, var_36_5
	end

	return {
		name = "level " .. arg_34_2,
		run = function()
			return var_34_6()
		end,
		retry = function()
			var_34_0.level = nil
			var_34_0.path = nil

			if var_34_2 and var_34_2 ~= 0 then
				return false
			else
				return var_34_6()
			end
		end
	}
end

local function var_0_23(arg_40_0, arg_40_1)
	local var_40_0 = -1
	local var_40_1 = -1

	for iter_40_0, iter_40_1 in ipairs(arg_40_1) do
		if not arg_40_0[iter_40_1].run_progress then
			if var_40_0 == -1 then
				var_40_0 = iter_40_0
			end

			var_40_1 = iter_40_0
		elseif var_40_0 ~= -1 then
			return var_40_0, var_40_1
		end
	end

	return var_40_0, var_40_1
end

local function var_0_24(arg_41_0, arg_41_1)
	local var_41_0 = {}

	for iter_41_0, iter_41_1 in ipairs(arg_41_1) do
		if arg_41_0[iter_41_1].type ~= "START" then
			var_41_0[#var_41_0 + 1] = iter_41_1
		end
	end

	return var_41_0
end

local function var_0_25(arg_42_0, arg_42_1, arg_42_2, arg_42_3)
	local var_42_0 = arg_42_0[arg_42_1[arg_42_2 - 1]]
	local var_42_1 = arg_42_0[arg_42_1[arg_42_3 + 1]]
	local var_42_2 = var_42_0 and var_42_0.run_progress or 0
	local var_42_3 = var_42_1 and var_42_1.run_progress or 0.9999
	local var_42_4 = arg_42_3 - arg_42_2
	local var_42_5 = 0

	if var_42_0 then
		var_42_4 = var_42_4 + 1
		var_42_5 = 1
	end

	if var_42_1 then
		var_42_4 = var_42_4 + 1
	end

	for iter_42_0 = arg_42_2, arg_42_3 do
		local var_42_6 = iter_42_0 - arg_42_2
		local var_42_7 = math.lerp(var_42_2, var_42_3, (var_42_6 + var_42_5) / var_42_4)

		arg_42_0[arg_42_1[iter_42_0]].run_progress = var_42_7
	end
end

local function var_0_26(arg_43_0, arg_43_1)
	local var_43_0 = var_0_5(arg_43_1, "final")

	table.sort(var_43_0, function(arg_44_0, arg_44_1)
		return #arg_44_0 > #arg_44_1
	end)

	for iter_43_0, iter_43_1 in ipairs(var_43_0) do
		local var_43_1 = var_0_24(arg_43_1, iter_43_1)

		while true do
			local var_43_2, var_43_3 = var_0_23(arg_43_1, var_43_1)

			if var_43_2 == -1 then
				break
			end

			var_0_25(arg_43_1, var_43_1, var_43_2, var_43_3)
		end

		for iter_43_2, iter_43_3 in ipairs(iter_43_1) do
			local var_43_4 = arg_43_1[iter_43_3]

			if var_43_4.run_progress == nil then
				var_43_4.run_progress = 0
			end
		end
	end
end

local function var_0_27(arg_45_0, arg_45_1, arg_45_2)
	local var_45_0 = arg_45_1.type
	local var_45_1 = arg_45_0.config.AVAILABLE_CURSES[var_45_0][arg_45_2]

	arg_45_1.curse = var_45_1[arg_45_0.random_generator(1, #var_45_1)]
	arg_45_1.god = arg_45_2
end

local function var_0_28(arg_46_0, arg_46_1, arg_46_2)
	local var_46_0 = arg_46_1[arg_46_2]
	local var_46_1 = var_0_0(table.clone(arg_46_0.config.AVAILABLE_MINOR_MODIFIERS), arg_46_0.random_generator)

	local function var_46_2(arg_47_0)
		for iter_47_0, iter_47_1 in ipairs(arg_46_0.config.MINOR_MODIFIER_VALIDATORS) do
			if not var_0_15[iter_47_1](arg_46_0, arg_46_1, arg_46_2, arg_47_0) then
				return false
			end
		end

		return true
	end

	for iter_46_0, iter_46_1 in ipairs(var_46_1) do
		if var_46_2(iter_46_1) then
			var_46_0.minor_modifier_group = iter_46_1

			return
		end
	end
end

local function var_0_29(arg_48_0, arg_48_1, arg_48_2, arg_48_3, arg_48_4, arg_48_5)
	local var_48_0 = {
		god = arg_48_2,
		center_key = arg_48_3,
		nodes = {}
	}
	local var_48_1 = arg_48_1[arg_48_3]

	var_0_27(arg_48_0, var_48_1, arg_48_2)
	table.swap_delete(arg_48_5, table.index_of(arg_48_5, var_48_1))

	var_48_0.nodes[#var_48_0.nodes + 1] = var_48_1.name

	for iter_48_0 = #arg_48_5, 1, -1 do
		local var_48_2 = arg_48_5[iter_48_0]
		local var_48_3 = var_48_1.layout_x - var_48_2.layout_x
		local var_48_4 = var_48_1.layout_y - var_48_2.layout_y

		if arg_48_4 > var_48_3 * var_48_3 + var_48_4 * var_48_4 then
			var_0_27(arg_48_0, var_48_2, arg_48_2)
			table.swap_delete(arg_48_5, iter_48_0)

			var_48_0.nodes[#var_48_0.nodes + 1] = var_48_2.name
		end
	end

	arg_48_0.hot_spots[#arg_48_0.hot_spots + 1] = var_48_0

	return arg_48_5
end

local function var_0_30(arg_49_0, arg_49_1)
	local var_49_0 = arg_49_0.random_generator(arg_49_0.config.CURSES_HOT_SPOTS_MIN_COUNT, arg_49_0.config.CURSES_HOT_SPOTS_MAX_COUNT)
	local var_49_1 = var_0_3(arg_49_1, arg_49_0.config.CURSES_MIN_PROGRESS)
	local var_49_2 = var_0_4(var_49_1, arg_49_0.config.CURSEABLE_NODE_TYPES)

	if not arg_49_0.config.NO_DOMINANT_GOD then
		local var_49_3 = arg_49_0.config.CURSES_HOT_SPOT_MAX_RANGE * arg_49_0.config.CURSES_HOT_SPOT_MAX_RANGE

		var_49_2 = var_0_29(arg_49_0, arg_49_1, arg_49_0.dominant_god, "final", var_49_3, var_49_2)
	end

	local var_49_4 = {}
	local var_49_5 = arg_49_0.config.AVAILABLE_GODS

	for iter_49_0 = 2, var_49_0 do
		if #var_49_4 == 0 then
			for iter_49_1, iter_49_2 in ipairs(var_49_5) do
				if arg_49_0.config.NO_DOMINANT_GOD or iter_49_2 ~= arg_49_0.dominant_god then
					var_49_4[#var_49_4 + 1] = iter_49_2
				end
			end
		end

		local var_49_6 = arg_49_0.random_generator(1, #var_49_4)
		local var_49_7 = var_49_4[var_49_6]

		table.swap_delete(var_49_4, var_49_6)

		if #var_49_2 > 0 then
			local var_49_8 = var_49_2[arg_49_0.random_generator(1, #var_49_2)]
			local var_49_9 = arg_49_0.config.CURSES_HOT_SPOT_MIN_RANGE + arg_49_0.random_generator() * (arg_49_0.config.CURSES_HOT_SPOT_MAX_RANGE - arg_49_0.config.CURSES_HOT_SPOT_MAX_RANGE)

			var_49_2 = var_0_29(arg_49_0, arg_49_1, var_49_7, var_49_8.name, var_49_9 * var_49_9, var_49_2)
		end
	end
end

local function var_0_31(arg_50_0, arg_50_1)
	local var_50_0 = {}
	local var_50_1 = arg_50_0.config.ARENA_BELAKOR_SHOWS_UP_IN_DEPTH

	for iter_50_0, iter_50_1 in pairs(arg_50_1) do
		if iter_50_1.type ~= "START" and iter_50_1.type ~= "SHOP" and iter_50_1.type ~= "ARENA" then
			local var_50_2
			local var_50_3 = var_0_8(arg_50_1, iter_50_0, var_50_1)
			local var_50_4 = {}

			for iter_50_2, iter_50_3 in ipairs(var_50_3) do
				if arg_50_1[iter_50_3].type == "SHOP" then
					local var_50_5 = var_0_7(arg_50_1, iter_50_3)

					for iter_50_4, iter_50_5 in ipairs(var_50_5) do
						var_50_4[#var_50_4 + 1] = iter_50_5
					end
				else
					var_50_4[#var_50_4 + 1] = iter_50_3
				end
			end

			for iter_50_6, iter_50_7 in ipairs(var_50_4) do
				local var_50_6 = arg_50_1[iter_50_7]

				repeat
					if #var_50_6.next == 0 then
						var_50_6 = nil

						break
					end

					var_50_6 = arg_50_1[var_50_6.next[1]]
				until var_50_6.type == "SIGNATURE" or var_50_6.type == "TRAVEL"

				if var_50_6 then
					var_50_2 = var_50_2 or {}
					var_50_2[iter_50_7] = true
				end
			end

			if var_50_2 then
				local var_50_7 = {}

				for iter_50_8, iter_50_9 in pairs(var_50_2) do
					var_50_7[#var_50_7 + 1] = iter_50_8
				end

				iter_50_1.possible_arena_belakor_nodes = var_50_7
				var_50_0[#var_50_0 + 1] = iter_50_0
			end
		end
	end

	local var_50_8 = table.mirror_array_inplace(var_50_0)
	local var_50_9 = var_0_7(arg_50_1, "start")
	local var_50_10 = {}

	for iter_50_10 = 1, #var_50_9 do
		local var_50_11 = var_50_9[iter_50_10]

		if var_50_8[var_50_11] then
			local var_50_12 = {}
			local var_50_13 = 1

			var_50_10[#var_50_10 + 1] = var_50_12
			var_50_12[var_50_13] = var_50_9[iter_50_10]

			local var_50_14 = var_0_8(arg_50_1, var_50_11, 1)

			for iter_50_11 = 1, #var_50_14 do
				if var_50_8[var_50_14[iter_50_11]] then
					var_50_13 = var_50_13 + 1
					var_50_12[var_50_13] = var_50_14[iter_50_11]
				end
			end
		end
	end

	local var_50_15 = arg_50_0.random_generator
	local var_50_16 = {}

	for iter_50_12 = 1, #var_50_10 do
		local var_50_17 = var_50_10[iter_50_12]
		local var_50_18 = #var_50_17

		if var_50_18 > 0 then
			local var_50_19 = var_50_17[var_50_15(1, var_50_18)]

			var_50_16[#var_50_16 + 1] = var_50_19

			for iter_50_13 = iter_50_12 + 1, #var_50_10 do
				local var_50_20 = var_50_10[iter_50_13]

				if table.contains(var_50_20, var_50_19) then
					table.clear(var_50_20)
				else
					for iter_50_14 = 1, #var_50_17 do
						local var_50_21 = table.find(var_50_20, var_50_17[iter_50_14])

						if var_50_21 then
							table.remove(var_50_20, var_50_21)
						end
					end
				end
			end
		end
	end

	for iter_50_15 = 1, #var_50_16 do
		local var_50_22 = var_50_16[iter_50_15]

		var_0_27(arg_50_0, arg_50_1[var_50_22], "belakor")
	end
end

local function var_0_32(arg_51_0, arg_51_1)
	local var_51_0 = var_0_3(arg_51_1, arg_51_0.config.MINOR_MODIFIABLE_MIN_PROGRESS)
	local var_51_1 = var_0_4(var_51_0, arg_51_0.config.MINOR_MODIFIABLE_NODE_TYPES)

	for iter_51_0, iter_51_1 in ipairs(var_51_1) do
		if arg_51_0.random_generator() < arg_51_0.config.MINOR_MODIFIABLE_NODE_CHANCE then
			var_0_28(arg_51_0, arg_51_1, iter_51_1.name)
		end
	end
end

local function var_0_33(arg_52_0, arg_52_1)
	for iter_52_0, iter_52_1 in pairs(arg_52_1) do
		if iter_52_1.type == "SIGNATURE" or iter_52_1.type == "TRAVEL" or iter_52_1.type == "ARENA" then
			local var_52_0 = arg_52_0.config.CONFLICT_DIRECTORS[iter_52_1.god] or arg_52_0.config.CONFLICT_DIRECTORS.default

			iter_52_1.conflict_settings = var_52_0[arg_52_0.random_generator(1, #var_52_0)]
		end
	end
end

local function var_0_34(arg_53_0, arg_53_1, arg_53_2)
	for iter_53_0, iter_53_1 in pairs(arg_53_1) do
		if arg_53_2 == arg_53_0[iter_53_0].terror_event_power_up then
			return true
		end
	end

	return false
end

local function var_0_35(arg_54_0, arg_54_1, arg_54_2)
	local var_54_0 = arg_54_0[arg_54_1].next

	if arg_54_2 > 1 then
		arg_54_2 = arg_54_2 - 1

		local var_54_1 = {}

		for iter_54_0, iter_54_1 in ipairs(var_54_0) do
			var_54_1[iter_54_1] = arg_54_0[iter_54_1]

			local var_54_2 = var_0_35(arg_54_0, iter_54_1, arg_54_2)

			for iter_54_2, iter_54_3 in pairs(var_54_2) do
				var_54_1[iter_54_2] = iter_54_3
			end
		end

		return var_54_1
	else
		local var_54_3 = {}

		for iter_54_4, iter_54_5 in ipairs(var_54_0) do
			var_54_3[iter_54_5] = arg_54_0[iter_54_5]
		end

		return var_54_3
	end
end

local function var_0_36(arg_55_0, arg_55_1)
	local var_55_0 = arg_55_0.random_generator
	local var_55_1 = var_0_1(arg_55_1, var_55_0)

	for iter_55_0, iter_55_1 in ipairs(var_55_1) do
		local var_55_2 = arg_55_1[iter_55_1]

		if var_55_2.type == "SIGNATURE" or var_55_2.type == "TRAVEL" then
			local var_55_3 = var_0_6(arg_55_1, iter_55_1)

			for iter_55_2, iter_55_3 in ipairs(var_55_2.prev) do
				local var_55_4 = var_0_35(arg_55_1, iter_55_3, arg_55_0.config.POWER_UP_LOOKAHEAD)

				for iter_55_4, iter_55_5 in pairs(var_55_4) do
					if iter_55_5.type == "SIGNATURE" or iter_55_5.type == "TRAVEL" then
						var_55_3[iter_55_4] = iter_55_5
					end
				end
			end

			local var_55_5 = var_0_0(table.clone(arg_55_0.config.TERROR_POWER_UPS), var_55_0)

			for iter_55_6, iter_55_7 in ipairs(var_55_5) do
				local var_55_6 = iter_55_7[1]
				local var_55_7 = iter_55_7[2]

				if not var_0_34(arg_55_1, var_55_3, var_55_6) then
					var_55_2.terror_event_power_up = var_55_6
					var_55_2.terror_event_power_up_rarity = var_55_7

					break
				end
			end

			if not var_55_2.terror_event_power_up then
				Application.warning("could not assign power_up to node, add more power_ups or reduce lookahead in the settings.")
			end
		end
	end
end

local function var_0_37(arg_56_0, arg_56_1, arg_56_2)
	return arg_56_0 .. "_" .. arg_56_2 .. "_path" .. arg_56_1
end

function deus_generate_seeds(arg_57_0)
	local var_57_0 = DeusGenUtils.create_random_generator(arg_57_0)
	local var_57_1, var_57_2 = var_57_0()
	local var_57_3, var_57_4 = var_57_0()
	local var_57_5, var_57_6 = var_57_0()
	local var_57_7, var_57_8 = var_57_0()
	local var_57_9, var_57_10 = var_57_0()

	return {
		weapon_pickup_seed = var_57_2,
		pickups_seed = var_57_4,
		mutator_seed = var_57_6,
		blessings_seed = var_57_8,
		power_ups_seed = var_57_10
	}
end

function deus_populate_graph(arg_58_0, arg_58_1, arg_58_2, arg_58_3, arg_58_4)
	local var_58_0 = DeusGenUtils.create_random_generator(arg_58_1)
	local var_58_1 = table.clone(arg_58_0)
	local var_58_2 = {
		indent = 0,
		random_generator = var_58_0,
		config = arg_58_2,
		dominant_god = arg_58_3,
		hot_spots = {}
	}
	local var_58_3 = {}
	local var_58_4 = {}

	for iter_58_0, iter_58_1 in pairs(arg_58_2.LEVEL_AVAILABILITY) do
		var_58_4[#var_58_4 + 1] = iter_58_0
	end

	table.sort(var_58_4)

	for iter_58_2, iter_58_3 in pairs(var_58_4) do
		local var_58_5 = arg_58_2.LEVEL_AVAILABILITY[iter_58_3]

		var_58_3[iter_58_3] = var_0_1(var_58_5, var_58_0)
	end

	for iter_58_4, iter_58_5 in ipairs(arg_58_2.LABEL_OVERRIDES) do
		var_58_3 = var_0_14[iter_58_5](var_58_2, var_58_1, var_58_3)
	end

	var_58_2.shuffled_levels_for_labels = var_58_3

	local function var_58_6(arg_59_0, arg_59_1)
		var_58_2.indent = #arg_59_0
	end

	local var_58_7 = {
		var_0_22(var_58_2, var_58_1, "start")
	}
	local var_58_8 = DeusGenEngine.get_generator(var_58_7, var_58_6)
	local var_58_9
	local var_58_10
	local var_58_11 = 100000

	for iter_58_6 = 1, var_58_11 do
		var_58_10, var_58_9 = var_58_8()

		if var_58_10 then
			if var_58_9 then
				Application.warning("[deus_populate_graph.lua] failed to populate graph, maybe the settings are impossible to solve? error: " .. (var_58_9 or "N/A"))

				return nil
			end

			break
		end
	end

	if not var_58_10 then
		Application.warning("[deus_populate_graph.lua] failed to populate graph, maybe the settings are impossible to solve? error: " .. (var_58_9 or "N/A"))

		return nil
	end

	var_0_26(var_58_2, var_58_1)
	var_0_30(var_58_2, var_58_1)

	if arg_58_4 then
		var_0_31(var_58_2, var_58_1)
	end

	var_0_32(var_58_2, var_58_1)
	var_0_33(var_58_2, var_58_1)
	var_0_36(var_58_2, var_58_1)

	local var_58_12 = {}

	for iter_58_7, iter_58_8 in pairs(var_58_1) do
		local var_58_13, var_58_14 = var_58_0()
		local var_58_15 = deus_generate_seeds(var_58_14)
		local var_58_16 = var_58_15.weapon_pickup_seed
		local var_58_17 = var_58_15.pickups_seed
		local var_58_18 = var_58_15.mutator_seed
		local var_58_19 = var_58_15.blessings_seed
		local var_58_20 = var_58_15.power_ups_seed
		local var_58_21 = {
			layout_x = iter_58_8.layout_x,
			layout_y = iter_58_8.layout_y,
			level_seed = var_58_14,
			weapon_pickup_seed = var_58_16,
			system_seeds = {
				pickups = var_58_17,
				mutator = var_58_18,
				blessings = var_58_19,
				power_ups = var_58_20
			},
			theme = iter_58_8.god or "wastes",
			minor_modifier_group = iter_58_8.minor_modifier_group,
			run_progress = iter_58_8.run_progress,
			conflict_settings = iter_58_8.conflict_settings or "disabled",
			level_type = iter_58_8.type,
			mutators = arg_58_2.MUTATORS[iter_58_8.type],
			terror_event_power_up = iter_58_8.terror_event_power_up,
			terror_event_power_up_rarity = iter_58_8.terror_event_power_up_rarity,
			possible_arena_belakor_nodes = iter_58_8.possible_arena_belakor_nodes,
			next = table.clone(iter_58_8.next)
		}

		if script_data.deus_shoppify_run and iter_58_8.type ~= "START" and iter_58_8.type ~= "ARENA" then
			local var_58_22 = table.keys(DeusShopSettings.shop_types)

			iter_58_8.level = var_58_22[var_58_0(1, #var_58_22)]
			iter_58_8.type = "SHOP"
		end

		if iter_58_8.type == "SIGNATURE" or iter_58_8.type == "TRAVEL" or iter_58_8.type == "ARENA" then
			var_58_21.base_level = iter_58_8.level
			var_58_21.path = iter_58_8.path

			local var_58_23 = arg_58_2.LEVEL_AVAILABILITY[iter_58_8.type][iter_58_8.level].themes

			if not table.contains(var_58_23, iter_58_8.god or "wastes") then
				local var_58_24 = var_58_23[1]

				Application.warning(string.format("[deus_populate_graph.lua] theme %s not found for level %s, using %s", iter_58_8.god or "wastes", iter_58_8.level, var_58_24))

				var_58_21.level = var_0_37(iter_58_8.level, iter_58_8.path, var_58_24)
			else
				var_58_21.level = var_0_37(iter_58_8.level, iter_58_8.path, iter_58_8.god or "wastes")
			end

			local var_58_25 = arg_58_2.LEVEL_ALIAS[var_58_21.level]

			if arg_58_2.LEVEL_ALIAS[var_58_21.level] then
				var_58_21.level = var_58_25
			end

			var_58_21.curse = iter_58_8.curse
			var_58_21.node_type = "ingame"
		elseif iter_58_8.type == "SHOP" then
			var_58_21.base_level = iter_58_8.level
			var_58_21.level = iter_58_8.level
			var_58_21.path = 0
			var_58_21.node_type = "shop"
		elseif iter_58_8.type == "START" then
			var_58_21.level = "dlc_morris_map"
			var_58_21.path = 0
			var_58_21.base_level = "dlc_morris_map"
			var_58_21.node_type = "start"
		end

		printf("Generated node with: Level <%s>, level_seed <%s>, Run progress <%s>", var_58_21.level, var_58_14, var_58_21.run_progress)

		var_58_12[iter_58_7] = var_58_21
	end

	return var_58_12
end
