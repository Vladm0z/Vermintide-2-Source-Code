-- chunkname: @foundation/scripts/util/table.lua

require("foundation/scripts/util/class")

table.is_empty = function (arg_1_0)
	return next(arg_1_0) == nil
end

table.size = function (arg_2_0)
	local var_2_0 = 0

	for iter_2_0 in pairs(arg_2_0) do
		var_2_0 = var_2_0 + 1
	end

	return var_2_0
end

if pcall(require, "table.new") then
	Script.new_array = function (arg_3_0)
		return table.new(arg_3_0, 0)
	end

	Script.new_map = function (arg_4_0)
		return table.new(0, arg_4_0)
	end

	Script.new_table = table.new
end

table.clone = function (arg_5_0, arg_5_1)
	local var_5_0 = {}

	if not arg_5_1 then
		local var_5_1 = getmetatable(arg_5_0)

		assert(var_5_1 == nil or var_5_1.__mt_cloneable, "Metatables will be sliced off")
	end

	for iter_5_0, iter_5_1 in pairs(arg_5_0) do
		if type(iter_5_1) ~= "table" or is_class_instance(iter_5_1) then
			var_5_0[iter_5_0] = iter_5_1
		else
			var_5_0[iter_5_0] = table.clone(iter_5_1, arg_5_1)
		end
	end

	return var_5_0
end

table.shallow_copy = function (arg_6_0, arg_6_1, arg_6_2)
	local var_6_0 = arg_6_2 or {}

	if not arg_6_1 then
		local var_6_1 = getmetatable(arg_6_0)

		assert(var_6_1 == nil or var_6_1.__mt_cloneable, "Metatables will be sliced off")
	end

	for iter_6_0, iter_6_1 in pairs(arg_6_0) do
		var_6_0[iter_6_0] = iter_6_1
	end

	return var_6_0
end

table.copy_array = function (arg_7_0, arg_7_1, arg_7_2)
	local var_7_0 = arg_7_2 or {}

	if not arg_7_1 then
		local var_7_1 = getmetatable(arg_7_0)

		assert(var_7_1 == nil or var_7_1.__mt_cloneable, "Metatables will be sliced off")
	end

	for iter_7_0 = 1, #arg_7_0 do
		var_7_0[iter_7_0] = arg_7_0[iter_7_0]
	end

	return var_7_0
end

table.crop = function (arg_8_0, arg_8_1)
	local var_8_0 = {}
	local var_8_1 = 0

	for iter_8_0 = arg_8_1, #arg_8_0 do
		var_8_1 = var_8_1 + 1
		var_8_0[var_8_1] = arg_8_0[iter_8_0]
	end

	return var_8_0, var_8_1
end

table.compare = function (arg_9_0, arg_9_1, arg_9_2)
	arg_9_2 = arg_9_2 or {}

	for iter_9_0, iter_9_1 in pairs(arg_9_0) do
		if not table.contains(arg_9_2, iter_9_0) then
			for iter_9_2, iter_9_3 in pairs(arg_9_1) do
				if iter_9_0 == iter_9_2 and iter_9_1 ~= iter_9_3 then
					return false
				end
			end
		end
	end

	return true
end

table.recursive_compare = function (arg_10_0, arg_10_1)
	local var_10_0 = true

	for iter_10_0, iter_10_1 in pairs(arg_10_0) do
		if type(iter_10_1) == "table" then
			local var_10_1 = arg_10_1[iter_10_0]

			if type(var_10_1) == "table" then
				var_10_0 = table.recursive_compare(iter_10_1, arg_10_1[iter_10_0])

				if not var_10_0 then
					break
				end
			else
				var_10_0 = false

				break
			end
		else
			for iter_10_2, iter_10_3 in pairs(arg_10_1) do
				if iter_10_0 == iter_10_2 and iter_10_1 ~= iter_10_3 then
					return false
				end
			end
		end
	end

	return var_10_0
end

table.create_copy = function (arg_11_0, arg_11_1)
	if not arg_11_0 then
		return table.clone(arg_11_1)
	else
		local var_11_0 = getmetatable(arg_11_1)

		assert(var_11_0 == nil or var_11_0.__mt_cloneable, "Metatables will be sliced off")

		for iter_11_0, iter_11_1 in pairs(arg_11_1) do
			if type(iter_11_1) ~= "table" or is_class_instance(iter_11_1) then
				arg_11_0[iter_11_0] = iter_11_1
			else
				arg_11_0[iter_11_0] = table.create_copy(arg_11_0[iter_11_0], iter_11_1)
			end
		end

		for iter_11_2, iter_11_3 in pairs(arg_11_0) do
			if arg_11_1[iter_11_2] == nil then
				arg_11_0[iter_11_2] = nil
			end
		end

		return arg_11_0
	end
end

table.clone_instance = function (arg_12_0)
	local var_12_0 = table.clone(arg_12_0)

	setmetatable(var_12_0, getmetatable(arg_12_0))

	return var_12_0
end

table.merge = function (arg_13_0, arg_13_1)
	for iter_13_0, iter_13_1 in pairs(arg_13_1) do
		arg_13_0[iter_13_0] = iter_13_1
	end

	return arg_13_0
end

table.merge_recursive = function (arg_14_0, arg_14_1)
	for iter_14_0, iter_14_1 in pairs(arg_14_1) do
		local var_14_0 = type(iter_14_1) == "table"

		if var_14_0 and type(arg_14_0[iter_14_0]) == "table" then
			table.merge_recursive(arg_14_0[iter_14_0], iter_14_1)
		elseif var_14_0 then
			arg_14_0[iter_14_0] = table.clone(iter_14_1)
		else
			arg_14_0[iter_14_0] = iter_14_1
		end
	end
end

table.merge_varargs = function (arg_15_0, arg_15_1, ...)
	local var_15_0 = {
		unpack(arg_15_0, 1, arg_15_1)
	}
	local var_15_1 = select("#", ...)

	for iter_15_0 = 1, var_15_1 do
		var_15_0[arg_15_1 + iter_15_0] = select(iter_15_0, ...)
	end

	return var_15_0, arg_15_1 + var_15_1
end

table.pack = function (...)
	return {
		...
	}, select("#", ...)
end

table.append_recursive = function (arg_17_0, arg_17_1)
	for iter_17_0, iter_17_1 in pairs(arg_17_1) do
		local var_17_0 = type(iter_17_1) == "table"

		if var_17_0 and type(arg_17_0[iter_17_0]) == "table" then
			table.append_recursive(arg_17_0[iter_17_0], iter_17_1)
		elseif arg_17_0[iter_17_0] == nil then
			if var_17_0 then
				arg_17_0[iter_17_0] = table.clone(iter_17_1)
			else
				arg_17_0[iter_17_0] = iter_17_1
			end
		end
	end
end

table.append = function (arg_18_0, arg_18_1)
	local var_18_0 = #arg_18_0

	for iter_18_0 = 1, #arg_18_1 do
		var_18_0 = var_18_0 + 1
		arg_18_0[var_18_0] = arg_18_1[iter_18_0]
	end

	return arg_18_0
end

table.append_unique = function (arg_19_0, arg_19_1)
	local var_19_0 = #arg_19_0

	for iter_19_0 = 1, #arg_19_1 do
		if not table.contains(arg_19_0, arg_19_1[iter_19_0]) then
			var_19_0 = var_19_0 + 1
			arg_19_0[var_19_0] = arg_19_1[iter_19_0]
		end
	end
end

table.append_non_indexed = function (arg_20_0, arg_20_1)
	local var_20_0 = #arg_20_0

	for iter_20_0, iter_20_1 in pairs(arg_20_1) do
		var_20_0 = var_20_0 + 1
		arg_20_0[var_20_0] = iter_20_1
	end

	return arg_20_0
end

table.contains = function (arg_21_0, arg_21_1)
	for iter_21_0, iter_21_1 in pairs(arg_21_0) do
		if iter_21_1 == arg_21_1 then
			return true
		end
	end

	return false
end

table.find = function (arg_22_0, arg_22_1)
	for iter_22_0, iter_22_1 in pairs(arg_22_0) do
		if iter_22_1 == arg_22_1 then
			return iter_22_0
		end
	end

	return nil
end

table.find_by_key = function (arg_23_0, arg_23_1, arg_23_2)
	for iter_23_0, iter_23_1 in pairs(arg_23_0) do
		if iter_23_1[arg_23_1] == arg_23_2 then
			return iter_23_0, iter_23_1
		end
	end

	return nil
end

table.index_of = function (arg_24_0, arg_24_1, arg_24_2)
	arg_24_2 = arg_24_2 or 1

	for iter_24_0 = arg_24_2, #arg_24_0 do
		if arg_24_0[iter_24_0] == arg_24_1 then
			return iter_24_0
		end
	end

	return -1
end

table.slice = function (arg_25_0, arg_25_1, arg_25_2)
	local var_25_0 = math.min(arg_25_1 + arg_25_2 - 1, #arg_25_0)
	local var_25_1 = {}

	for iter_25_0 = arg_25_1, var_25_0 do
		var_25_1[#var_25_1 + 1] = arg_25_0[iter_25_0]
	end

	return var_25_1
end

table.sorted = function (arg_26_0, arg_26_1, arg_26_2)
	local var_26_0 = arg_26_2 and FrameTable.alloc_table() or {}

	for iter_26_0, iter_26_1 in pairs(arg_26_0) do
		var_26_0[#var_26_0 + 1] = iter_26_0
	end

	if arg_26_1 then
		table.sort(var_26_0, function (arg_27_0, arg_27_1)
			return arg_26_1(arg_26_0, arg_27_0, arg_27_1)
		end)
	else
		table.sort(var_26_0)
	end

	local var_26_1 = 0

	return function ()
		var_26_1 = var_26_1 + 1

		if var_26_0[var_26_1] then
			return var_26_0[var_26_1], arg_26_0[var_26_0[var_26_1]]
		end
	end
end

table.reverse = function (arg_29_0)
	local var_29_0 = #arg_29_0

	for iter_29_0 = 1, math.floor(var_29_0 / 2) do
		arg_29_0[iter_29_0], arg_29_0[var_29_0 - iter_29_0 + 1] = arg_29_0[var_29_0 - iter_29_0 + 1], arg_29_0[iter_29_0]
	end
end

if pcall(require, "table.clear") then
	table.clear = require("table.clear")
else
	table.clear = function (arg_30_0)
		for iter_30_0 in pairs(arg_30_0) do
			arg_30_0[iter_30_0] = nil
		end
	end
end

table.clear_array = function (arg_31_0, arg_31_1)
	for iter_31_0 = 1, arg_31_1 or #arg_31_0 do
		arg_31_0[iter_31_0] = nil
	end
end

local function var_0_0(arg_32_0, arg_32_1, arg_32_2, arg_32_3, arg_32_4)
	if arg_32_3 < arg_32_2 then
		return
	end

	local var_32_0 = string.rep("  ", arg_32_2 + 1) .. (arg_32_0 == nil and "" or "[" .. tostring(arg_32_0) .. "]")

	if type(arg_32_1) == "table" then
		var_32_0 = var_32_0 .. (arg_32_0 == nil and "" or " = ")

		print(var_32_0 .. "table")

		if arg_32_3 then
			for iter_32_0, iter_32_1 in pairs(arg_32_1) do
				var_0_0(iter_32_0, iter_32_1, arg_32_2 + 1, arg_32_3, arg_32_4)
			end
		end

		local var_32_1 = getmetatable(arg_32_1)

		if var_32_1 then
			print(var_32_0 .. "metatable")

			if arg_32_3 then
				for iter_32_2, iter_32_3 in pairs(var_32_1) do
					if iter_32_2 ~= "__index" and iter_32_2 ~= "super" then
						var_0_0(iter_32_2, iter_32_3, arg_32_2 + 1, arg_32_3, arg_32_4)
					end
				end
			end
		end
	elseif type(arg_32_1) == "function" or type(arg_32_1) == "thread" or type(arg_32_1) == "userdata" or arg_32_1 == nil then
		arg_32_4(var_32_0 .. " = " .. tostring(arg_32_1))
	else
		arg_32_4(var_32_0 .. " = " .. tostring(arg_32_1) .. " (" .. type(arg_32_1) .. ")")
	end
end

table.dump = function (arg_33_0, arg_33_1, arg_33_2, arg_33_3)
	arg_33_3 = arg_33_3 or print

	if arg_33_1 then
		arg_33_3(string.format("<%s>", arg_33_1))
	end

	if arg_33_0 then
		for iter_33_0, iter_33_1 in pairs(arg_33_0) do
			var_0_0(iter_33_0, iter_33_1, 0, arg_33_2 or 0, arg_33_3)
		end
	else
		arg_33_3("no table!")
	end

	if arg_33_1 then
		arg_33_3(string.format("</%s>", arg_33_1))
	end
end

function is_array(arg_34_0)
	for iter_34_0, iter_34_1 in pairs(arg_34_0) do
		if type(iter_34_0) ~= "number" then
			return false
		end
	end

	return true
end

function array_dump_string(arg_35_0, arg_35_1)
	local var_35_0 = "{\n"

	for iter_35_0, iter_35_1 in ipairs(arg_35_0) do
		var_35_0 = var_35_0 .. string.rep("\t", arg_35_1) .. value_to_string(iter_35_1, arg_35_1)

		if next(arg_35_0, iter_35_0) ~= nil then
			var_35_0 = var_35_0 .. ",\n"
		end
	end

	return var_35_0 .. "\n" .. string.rep("\t", arg_35_1 - 1) .. "}"
end

function value_to_string(arg_36_0, arg_36_1)
	if type(arg_36_0) == "table" and is_array(arg_36_0) then
		return array_dump_string(arg_36_0, arg_36_1 + 1)
	elseif type(arg_36_0) == "table" then
		return table_dump_string(arg_36_0, arg_36_1 + 1)
	elseif type(arg_36_0) == "string" then
		return "\"" .. arg_36_0 .. "\""
	elseif type(arg_36_0) == "boolean" then
		return tostring(arg_36_0)
	else
		return arg_36_0
	end
end

function table_dump_string(arg_37_0, arg_37_1)
	local var_37_0 = "{\n"

	for iter_37_0, iter_37_1 in pairs(arg_37_0) do
		var_37_0 = var_37_0 .. string.rep("\t", arg_37_1) .. iter_37_0 .. " = " .. value_to_string(iter_37_1, arg_37_1)

		if next(arg_37_0, iter_37_0) ~= nil then
			var_37_0 = var_37_0 .. ",\n"
		end
	end

	return var_37_0 .. "\n" .. string.rep("\t", arg_37_1 - 1) .. "}"
end

table.dump_string = function (arg_38_0, arg_38_1)
	if is_array(arg_38_0) then
		return array_dump_string(arg_38_0, arg_38_1 or 1)
	else
		return table_dump_string(arg_38_0, arg_38_1 or 1)
	end
end

local var_0_1 = {}

table.minidump = function (arg_39_0, arg_39_1)
	local var_39_0 = var_0_1
	local var_39_1 = 1

	if arg_39_1 then
		var_39_0[1] = "["
		var_39_0[2] = arg_39_1
		var_39_0[3] = "] "
		var_39_1 = 4
	end

	for iter_39_0, iter_39_1 in pairs(arg_39_0) do
		var_39_0[var_39_1] = iter_39_0
		var_39_0[var_39_1 + 1] = " = "
		var_39_0[var_39_1 + 2] = tostring(iter_39_1)
		var_39_0[var_39_1 + 3] = "; "
		var_39_1 = var_39_1 + 4
	end

	local var_39_2 = table.concat(var_39_0, 1, var_39_1 - 2)

	table.clear(var_39_0)

	return var_39_2
end

table.shuffle = function (arg_40_0, arg_40_1)
	if arg_40_1 then
		for iter_40_0 = #arg_40_0, 2, -1 do
			local var_40_0
			local var_40_1

			arg_40_1, var_40_1 = Math.next_random(arg_40_1, iter_40_0)
			arg_40_0[var_40_1], arg_40_0[iter_40_0] = arg_40_0[iter_40_0], arg_40_0[var_40_1]
		end
	else
		for iter_40_1 = #arg_40_0, 2, -1 do
			local var_40_2 = Math.random(iter_40_1)

			arg_40_0[var_40_2], arg_40_0[iter_40_1] = arg_40_0[iter_40_1], arg_40_0[var_40_2]
		end
	end

	return arg_40_1
end

table.max = function (arg_41_0)
	local var_41_0, var_41_1 = next(arg_41_0)

	for iter_41_0, iter_41_1 in pairs(arg_41_0) do
		if var_41_1 < iter_41_1 then
			var_41_0, var_41_1 = iter_41_0, iter_41_1
		end
	end

	return var_41_0, var_41_1
end

table.max_func = function (arg_42_0, arg_42_1)
	local var_42_0, var_42_1 = next(arg_42_0)

	for iter_42_0, iter_42_1 in pairs(arg_42_0) do
		if arg_42_1(iter_42_1) > arg_42_1(var_42_1) then
			var_42_0, var_42_1 = iter_42_0, iter_42_1
		end
	end

	return var_42_0, var_42_1
end

table.min = function (arg_43_0)
	local var_43_0, var_43_1 = next(arg_43_0)

	for iter_43_0, iter_43_1 in pairs(arg_43_0) do
		if iter_43_1 < var_43_1 then
			var_43_0, var_43_1 = iter_43_0, iter_43_1
		end
	end

	return var_43_0, var_43_1
end

table.for_each = function (arg_44_0, arg_44_1)
	for iter_44_0, iter_44_1 in pairs(arg_44_0) do
		arg_44_0[iter_44_0] = arg_44_1(iter_44_1)
	end
end

function _add_tabs(arg_45_0, arg_45_1)
	for iter_45_0 = 1, arg_45_1 do
		arg_45_0 = arg_45_0 .. "\t"
	end

	return arg_45_0
end

local var_0_2
local var_0_3

local function var_0_4(arg_46_0, arg_46_1, arg_46_2, arg_46_3)
	if type(arg_46_0) == "table" then
		if arg_46_1 <= arg_46_2 then
			return var_0_3(arg_46_0, arg_46_1 + 1, arg_46_2, arg_46_3)
		else
			return {
				"(rec-limit)"
			}
		end
	elseif type(arg_46_0) == "string" then
		return {
			"\"",
			arg_46_0,
			"\""
		}
	else
		return {
			tostring(arg_46_0)
		}
	end
end

function var_0_3(arg_47_0, arg_47_1, arg_47_2, arg_47_3)
	local var_47_0 = {
		"{\n"
	}
	local var_47_1 = string.rep("\t", arg_47_1 - 1)
	local var_47_2 = var_47_1 .. "\t"
	local var_47_3 = #arg_47_0

	for iter_47_0 = 1, var_47_3 do
		var_47_0[#var_47_0 + 1] = var_47_2

		table.append(var_47_0, var_0_4(arg_47_0[iter_47_0], arg_47_1, arg_47_2, arg_47_3))

		var_47_0[#var_47_0 + 1] = ",\n"
	end

	for iter_47_1, iter_47_2 in pairs(arg_47_0) do
		local var_47_4 = type(iter_47_1) == "number"

		if (var_47_4 or not arg_47_3 or iter_47_1:sub(1, 1) ~= "_") and (not var_47_4 or iter_47_1 < 1 or var_47_3 < iter_47_1) then
			local var_47_5

			if var_47_4 then
				var_47_5 = string.format("[%i]", iter_47_1)
			else
				var_47_5 = tostring(iter_47_1)
			end

			var_47_0[#var_47_0 + 1] = var_47_2
			var_47_0[#var_47_0 + 1] = var_47_5
			var_47_0[#var_47_0 + 1] = " = "

			table.append(var_47_0, var_0_4(iter_47_2, arg_47_1, arg_47_2, arg_47_3))

			var_47_0[#var_47_0 + 1] = ",\n"
		end
	end

	var_47_0[#var_47_0 + 1] = var_47_1
	var_47_0[#var_47_0 + 1] = "}"

	return var_47_0
end

table.tostring = function (arg_48_0, arg_48_1, arg_48_2)
	return table.concat(var_0_3(arg_48_0, 1, arg_48_1 or 1, arg_48_2))
end

table.set = function (arg_49_0, arg_49_1)
	arg_49_1 = arg_49_1 or {}

	for iter_49_0, iter_49_1 in ipairs(arg_49_0) do
		arg_49_1[iter_49_1] = true
	end

	return arg_49_1
end

table.mirror_table = function (arg_50_0, arg_50_1)
	assert(arg_50_0 ~= arg_50_1)

	local var_50_0 = arg_50_1 or {}

	for iter_50_0, iter_50_1 in pairs(arg_50_0) do
		var_50_0[iter_50_0] = iter_50_1
		var_50_0[iter_50_1] = iter_50_0
	end

	return var_50_0
end

table.mirror_array = function (arg_51_0, arg_51_1)
	assert(arg_51_0 ~= arg_51_1)

	local var_51_0 = arg_51_1 or {}

	for iter_51_0, iter_51_1 in ipairs(arg_51_0) do
		var_51_0[iter_51_0] = iter_51_1
		var_51_0[iter_51_1] = iter_51_0
	end

	return var_51_0
end

table.mirror_array_inplace = function (arg_52_0)
	for iter_52_0, iter_52_1 in ipairs(arg_52_0) do
		arg_52_0[iter_52_1] = iter_52_0
	end

	return arg_52_0
end

table.keys = function (arg_53_0, arg_53_1, arg_53_2)
	arg_53_1 = arg_53_1 or {}

	local var_53_0 = arg_53_2 or 0

	for iter_53_0 in pairs(arg_53_0) do
		var_53_0 = var_53_0 + 1
		arg_53_1[var_53_0] = iter_53_0
	end

	return arg_53_1, var_53_0
end

table.split_unordered = function (arg_54_0)
	local var_54_0 = {}
	local var_54_1 = {}
	local var_54_2 = true

	for iter_54_0, iter_54_1 in pairs(arg_54_0) do
		if var_54_2 then
			var_54_0[iter_54_0] = iter_54_1
		else
			var_54_1[iter_54_0] = iter_54_1
		end

		var_54_2 = not var_54_2
	end

	return var_54_0, var_54_1
end

table.keys_if = function (arg_55_0, arg_55_1, arg_55_2)
	arg_55_1 = arg_55_1 or {}

	local var_55_0 = 0

	for iter_55_0, iter_55_1 in pairs(arg_55_0) do
		if arg_55_2(iter_55_0, iter_55_1) then
			var_55_0 = var_55_0 + 1
			arg_55_1[var_55_0] = iter_55_0
		end
	end

	return arg_55_1, var_55_0
end

table.values = function (arg_56_0, arg_56_1)
	arg_56_1 = arg_56_1 or {}

	local var_56_0 = 0

	for iter_56_0, iter_56_1 in pairs(arg_56_0) do
		var_56_0 = var_56_0 + 1
		arg_56_1[var_56_0] = iter_56_1
	end

	return arg_56_1, var_56_0
end

table.append_varargs = function (arg_57_0, ...)
	local var_57_0 = select("#", ...)
	local var_57_1 = #arg_57_0

	for iter_57_0 = 1, var_57_0 do
		arg_57_0[var_57_1 + iter_57_0] = select(iter_57_0, ...)
	end

	return arg_57_0
end

table.array_to_table = function (arg_58_0, arg_58_1, arg_58_2)
	for iter_58_0 = 1, arg_58_1, 2 do
		arg_58_2[arg_58_0[iter_58_0]] = arg_58_0[iter_58_0 + 1]
	end
end

table.table_to_array = function (arg_59_0, arg_59_1)
	assert(#arg_59_1 == 0)

	local var_59_0 = 0

	for iter_59_0, iter_59_1 in pairs(arg_59_0) do
		arg_59_1[var_59_0 + 1] = iter_59_0
		arg_59_1[var_59_0 + 2] = iter_59_1
		var_59_0 = var_59_0 + 2
	end

	return var_59_0
end

table.add_meta_logging = function (arg_60_0, arg_60_1, arg_60_2)
	local var_60_0 = arg_60_0 or {}

	if arg_60_1 then
		local var_60_1 = {
			__index = function (arg_61_0, arg_61_1)
				local var_61_0 = rawget(var_60_0, arg_61_1)

				print("meta getting", arg_60_2, arg_61_1, var_61_0)

				return var_61_0
			end
		}

		setmetatable(var_60_1, var_60_1)

		var_60_1.__newindex = function (arg_62_0, arg_62_1, arg_62_2)
			print("meta setting", arg_60_2, arg_62_1, arg_62_2)
			rawset(var_60_0, arg_62_1, arg_62_2)
		end

		return var_60_1
	else
		return var_60_0
	end
end

local function var_0_5(arg_63_0, arg_63_1)
	arg_63_1 = arg_63_1 - 1

	local var_63_0 = arg_63_0[arg_63_1]

	if var_63_0 then
		return arg_63_1, var_63_0
	end
end

function ripairs(arg_64_0)
	return var_0_5, arg_64_0, #arg_64_0 + 1
end

table.swap_delete = function (arg_65_0, arg_65_1)
	local var_65_0 = #arg_65_0
	local var_65_1 = arg_65_0[arg_65_1]

	arg_65_0[arg_65_1] = arg_65_0[var_65_0]
	arg_65_0[var_65_0] = nil

	return var_65_1
end

table.array_remove_if = function (arg_66_0, arg_66_1)
	local var_66_0 = 1
	local var_66_1

	for iter_66_0 = 1, #arg_66_0 do
		local var_66_2

		var_66_2, arg_66_0[iter_66_0] = arg_66_0[iter_66_0]

		if not arg_66_1(var_66_2) then
			arg_66_0[var_66_0], var_66_0 = var_66_2, var_66_0 + 1
		end
	end
end

table.remove_if = function (arg_67_0, arg_67_1)
	for iter_67_0, iter_67_1 in pairs(arg_67_0) do
		if arg_67_1(iter_67_0, iter_67_1) then
			arg_67_0[iter_67_0] = nil
		end
	end
end

;({}).__index = function (arg_68_0, arg_68_1)
	return error("Don't know `" .. tostring(arg_68_1) .. "` for enum.")
end

table.enum = function (...)
	local var_69_0 = {}

	for iter_69_0 = 1, select("#", ...) do
		local var_69_1 = select(iter_69_0, ...)

		var_69_0[var_69_1] = var_69_1
	end

	return var_69_0
end

table.ordered_enum = function (...)
	local var_70_0 = {}

	for iter_70_0 = 1, select("#", ...) do
		local var_70_1 = select(iter_70_0, ...)

		var_70_0[var_70_1] = var_70_1
		var_70_0[iter_70_0] = var_70_1
	end

	return var_70_0
end

table.enum_safe = function (...)
	local var_71_0 = {}

	for iter_71_0 = 1, select("#", ...) do
		local var_71_1 = select(iter_71_0, ...)

		var_71_0[var_71_1] = var_71_1
	end

	return var_71_0
end

table.map = function (arg_72_0, arg_72_1)
	local var_72_0 = {}

	for iter_72_0, iter_72_1 in pairs(arg_72_0) do
		var_72_0[iter_72_0] = arg_72_1(iter_72_1)
	end

	return var_72_0
end

table.filter = function (arg_73_0, arg_73_1, arg_73_2)
	arg_73_2 = arg_73_2 or {}

	for iter_73_0, iter_73_1 in pairs(arg_73_0) do
		if arg_73_1(iter_73_1) == true then
			arg_73_2[iter_73_0] = iter_73_1
		end
	end

	return arg_73_2
end

table.filter_to_array = function (arg_74_0, arg_74_1, arg_74_2)
	arg_74_2 = arg_74_2 or {}

	local var_74_0 = 0

	for iter_74_0, iter_74_1 in pairs(arg_74_0) do
		if arg_74_1(iter_74_1) then
			var_74_0 = var_74_0 + 1
			arg_74_2[var_74_0] = iter_74_1
		end
	end

	return arg_74_2, var_74_0
end

table.filter_array = function (arg_75_0, arg_75_1, arg_75_2)
	arg_75_2 = arg_75_2 or {}

	local var_75_0 = 0

	for iter_75_0 = 1, #arg_75_0 do
		local var_75_1 = arg_75_0[iter_75_0]

		if arg_75_1(var_75_1) then
			var_75_0 = var_75_0 + 1
			arg_75_2[var_75_0] = var_75_1
		end
	end

	return arg_75_2, var_75_0
end

table.get_value_or_last = function (arg_76_0, arg_76_1)
	return arg_76_0[arg_76_1] or arg_76_0[#arg_76_0]
end

table.autovivified = function (arg_77_0)
	arg_77_0 = arg_77_0 or TNEW

	return setmetatable({}, {
		__index = function (arg_78_0, arg_78_1)
			local var_78_0 = arg_77_0(arg_78_1)

			arg_78_0[arg_78_1] = var_78_0

			return var_78_0
		end
	})
end

table.every = function (arg_79_0, arg_79_1)
	for iter_79_0, iter_79_1 in pairs(arg_79_0) do
		if not arg_79_1(iter_79_0, iter_79_1) then
			return false
		end
	end

	return true
end

table.find_func = function (arg_80_0, arg_80_1)
	for iter_80_0, iter_80_1 in pairs(arg_80_0) do
		if arg_80_1(iter_80_0, iter_80_1) then
			return iter_80_0, iter_80_1
		end
	end
end

table.find_func_array = function (arg_81_0, arg_81_1)
	for iter_81_0 = 1, #arg_81_0 do
		local var_81_0 = arg_81_0[iter_81_0]

		if arg_81_1(var_81_0) then
			return iter_81_0, var_81_0
		end
	end
end

table.random = function (arg_82_0)
	return arg_82_0[math.random(1, #arg_82_0)]
end

table.recursive_readonlytable = function (arg_83_0)
	setmetatable(arg_83_0, {
		__newindex = function (arg_84_0, arg_84_1, arg_84_2)
			error("Trying to modify read only table.")
		end
	})

	for iter_83_0, iter_83_1 in pairs(arg_83_0) do
		if type(iter_83_1) == "table" then
			table.recursive_readonlytable(iter_83_1)
		end
	end
end

table.flat = function (arg_85_0, arg_85_1, arg_85_2)
	arg_85_1 = arg_85_1 or 1
	arg_85_2 = (arg_85_2 or 0) + 1

	local var_85_0 = {}

	for iter_85_0, iter_85_1 in pairs(arg_85_0) do
		if type(iter_85_1) == "table" and arg_85_2 <= arg_85_1 then
			table.append(var_85_0, table.flat(iter_85_1, arg_85_1, arg_85_2))
		else
			var_85_0[#var_85_0 + 1] = iter_85_1
		end
	end

	return var_85_0
end

table.make_strict = function (arg_86_0, arg_86_1, arg_86_2)
	assert(getmetatable(arg_86_0) == nil, "Cannot call make_strict on a table with a metatable")

	arg_86_2 = arg_86_2 or "strict table"
	arg_86_1 = arg_86_1 or arg_86_0

	return setmetatable(arg_86_0, {
		__class_name = arg_86_2,
		__index = function (arg_87_0, arg_87_1)
			if arg_86_1[arg_87_1] == nil then
				ferror("Reading from key %q not in interface <%s>", arg_87_1, arg_86_2)
			end

			return nil
		end,
		__newindex = function (arg_88_0, arg_88_1, arg_88_2)
			if arg_86_1[arg_88_1] == nil then
				ferror("Writing to key %q not in interface <%s>", arg_88_1, arg_86_2)
			end

			return rawset(arg_88_0, arg_88_1, arg_88_2)
		end
	})
end

table.select_array = function (arg_89_0, arg_89_1)
	local var_89_0 = {}

	for iter_89_0 = 1, #arg_89_0 do
		var_89_0[#var_89_0 + 1] = arg_89_1(iter_89_0, arg_89_0[iter_89_0])
	end

	return var_89_0
end

table.select_map = function (arg_90_0, arg_90_1)
	local var_90_0 = {}

	for iter_90_0, iter_90_1 in pairs(arg_90_0) do
		var_90_0[iter_90_0] = arg_90_1(iter_90_0, iter_90_1)
	end

	return var_90_0
end

table.array_to_map = function (arg_91_0, arg_91_1)
	local var_91_0 = {}

	for iter_91_0, iter_91_1 in pairs(arg_91_0) do
		local var_91_1, var_91_2 = arg_91_1(iter_91_0, iter_91_1)

		var_91_0[var_91_1] = var_91_2
	end

	return var_91_0
end

table.map_to_array = function (arg_92_0, arg_92_1)
	local var_92_0 = {}
	local var_92_1 = 0

	for iter_92_0, iter_92_1 in pairs(arg_92_0) do
		local var_92_2 = arg_92_1(iter_92_0, iter_92_1)

		if var_92_2 then
			var_92_1 = var_92_1 + 1
			var_92_0[var_92_1] = var_92_2
		end
	end

	return var_92_0
end

table.remove_empty_values = function (arg_93_0)
	if table.is_empty(arg_93_0) then
		return nil
	end

	local var_93_0 = {}

	for iter_93_0, iter_93_1 in pairs(arg_93_0) do
		if iter_93_0 ~= StrictNil then
			local var_93_1 = type(iter_93_1)

			if var_93_1 == "table" then
				if not table.is_empty(iter_93_1) then
					var_93_0[iter_93_0] = table.remove_empty_values(iter_93_1)
				end
			elseif var_93_1 == "string" and iter_93_1 ~= "" then
				var_93_0[iter_93_0] = iter_93_1
			elseif var_93_1 ~= "nil" then
				var_93_0[iter_93_0] = iter_93_1
			end
		end
	end

	if table.is_empty(var_93_0) then
		return nil
	else
		return var_93_0
	end
end

local function var_0_6(arg_94_0, arg_94_1, arg_94_2, arg_94_3)
	local var_94_0 = arg_94_0[arg_94_2]
	local var_94_1 = arg_94_1 - 1

	for iter_94_0 = arg_94_1, arg_94_2 - 1 do
		local var_94_2

		if arg_94_3 then
			var_94_2 = arg_94_3(arg_94_0[iter_94_0], var_94_0)
		else
			var_94_2 = var_94_0 >= arg_94_0[iter_94_0]
		end

		if var_94_2 then
			var_94_1 = var_94_1 + 1
			arg_94_0[var_94_1], arg_94_0[iter_94_0] = arg_94_0[iter_94_0], arg_94_0[var_94_1]
		end
	end

	arg_94_0[var_94_1 + 1], arg_94_0[arg_94_2] = arg_94_0[arg_94_2], arg_94_0[var_94_1 + 1]

	return var_94_1 + 1
end

local function var_0_7(arg_95_0, arg_95_1, arg_95_2, arg_95_3)
	if arg_95_1 < arg_95_2 then
		local var_95_0 = var_0_6(arg_95_0, arg_95_1, arg_95_2, arg_95_3)

		var_0_7(arg_95_0, arg_95_1, var_95_0 - 1, arg_95_3)
		var_0_7(arg_95_0, var_95_0 + 1, arg_95_2, arg_95_3)
	end
end

table.sort_span = function (arg_96_0, arg_96_1, arg_96_2, arg_96_3)
	var_0_7(arg_96_0, arg_96_1, arg_96_2, arg_96_3)
end

table.array_average = function (arg_97_0, arg_97_1, arg_97_2)
	if arg_97_2 then
		local var_97_0 = math.index_wrapper((arg_97_0.index or 0) + 1, arg_97_1)

		arg_97_0[var_97_0] = arg_97_2
		arg_97_0.index = var_97_0
	end

	local var_97_1 = #arg_97_0
	local var_97_2 = 0
	local var_97_3 = 0
	local var_97_4 = 0

	for iter_97_0 = 1, var_97_1 do
		local var_97_5 = arg_97_0[iter_97_0]

		var_97_2 = var_97_2 + var_97_5
		var_97_3 = var_97_5 < var_97_3 and var_97_5 or var_97_3
		var_97_4 = var_97_4 < var_97_5 and var_97_5 or var_97_4
	end

	return var_97_2 / var_97_1, var_97_3, var_97_4
end

table.convert_lookup = function (arg_98_0, arg_98_1)
	for iter_98_0 = 1, #arg_98_0 do
		arg_98_0[iter_98_0] = arg_98_1[arg_98_0[iter_98_0]]
	end

	return arg_98_0
end

table.enum_lookup = function (...)
	local var_99_0 = {
		...
	}
	local var_99_1 = table.mirror_array(var_99_0)

	return table.ordered_enum(unpack(var_99_1)), var_99_1
end

table.insert_unique = function (arg_100_0, arg_100_1, arg_100_2)
	if not table.find(arg_100_0, arg_100_1) and (not arg_100_2 or not table.insert(arg_100_0, arg_100_2, arg_100_1)) then
		local var_100_0 = table.insert(arg_100_0, arg_100_1)
	end
end

table.remove_array_value = function (arg_101_0, arg_101_1)
	local var_101_0 = 1
	local var_101_1 = 1
	local var_101_2 = #arg_101_0

	while var_101_0 <= var_101_2 do
		if arg_101_0[var_101_0] == arg_101_1 then
			arg_101_0[var_101_0] = nil
		else
			var_101_1 = var_101_1 + 1
		end

		var_101_0 = var_101_0 + 1
		arg_101_0[var_101_1] = arg_101_0[var_101_0]
	end

	return arg_101_0
end

table.fill = function (arg_102_0, arg_102_1, arg_102_2)
	for iter_102_0 = 1, arg_102_1 do
		arg_102_0[iter_102_0] = arg_102_2
	end

	return arg_102_0
end

table.count_if = function (arg_103_0, arg_103_1)
	local var_103_0 = 0

	for iter_103_0, iter_103_1 in pairs(arg_103_0) do
		if arg_103_1(iter_103_0, iter_103_1) then
			var_103_0 = var_103_0 + 1
		end
	end

	return var_103_0
end

table.shallow_equal = function (arg_104_0, arg_104_1)
	for iter_104_0, iter_104_1 in pairs(arg_104_0) do
		if arg_104_0[iter_104_0] ~= arg_104_1[iter_104_0] then
			return false
		end
	end

	for iter_104_2, iter_104_3 in pairs(arg_104_1) do
		if arg_104_1[iter_104_2] ~= arg_104_0[iter_104_2] then
			return false
		end
	end

	return true
end

table.safe_get = function (arg_105_0, ...)
	local var_105_0 = arg_105_0

	for iter_105_0 = 1, select("#", ...) do
		var_105_0 = var_105_0[select(iter_105_0, ...)]

		if not var_105_0 then
			return nil
		end
	end

	return var_105_0
end
