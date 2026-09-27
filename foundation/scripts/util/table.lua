-- chunkname: @foundation/scripts/util/table.lua

require("foundation/scripts/util/class")

table.is_empty = function (arg_1_0)
	-- function 1
	return next(arg_1_0) == nil
end

table.size = function (arg_2_0)
	-- function 2
	local num = 0

	for k in pairs(arg_2_0) do
		num = num + 1
	end

	return num
end

if not pcall(require, "table.new") then
	Script.new_array = function (arg_3_0)
		-- function 3
		return table.new(arg_3_0, 0)
	end

	Script.new_map = function (arg_4_0)
		-- function 4
		return table.new(0, arg_4_0)
	end

	Script.new_table = table.new
end

table.clone = function (arg_5_0, arg_5_1)
	-- function 5
	local tbl = {}

	if not arg_5_1 then
		local var_5_1 = getmetatable(arg_5_0)

		assert(var_5_1 == nil or var_5_1.__mt_cloneable, "Metatables will be sliced off")
	end

	for k, v in pairs(arg_5_0) do
		if type(v) ~= "table" or not is_class_instance(v) then
			tbl[k] = v
		else
			tbl[k] = table.clone(v, arg_5_1)
		end
	end

	return tbl
end

table.shallow_copy = function (arg_6_0, arg_6_1, arg_6_2)
	-- function 6
	local flag = arg_6_2 or {}

	if not arg_6_1 then
		local var_6_1 = getmetatable(arg_6_0)

		assert(var_6_1 == nil or var_6_1.__mt_cloneable, "Metatables will be sliced off")
	end

	for k, v in pairs(arg_6_0) do
		flag[k] = v
	end

	return flag
end

table.copy_array = function (self, arg_7_1, arg_7_2)
	-- function 7
	local flag = arg_7_2 or {}

	if not arg_7_1 then
		local var_7_1 = getmetatable(self)

		assert(var_7_1 == nil or var_7_1.__mt_cloneable, "Metatables will be sliced off")
	end

	for i = 1, #self do
		flag[i] = self[i]
	end

	return flag
end

table.crop = function (self, arg_8_1)
	-- function 8
	local tbl = {}
	local num = 0

	for i = arg_8_1, #self do
		num = num + 1
		tbl[num] = self[i]
	end

	return tbl, num
end

table.compare = function (arg_9_0, arg_9_1, arg_9_2)
	-- function 9
	arg_9_2 = arg_9_2 or {}

	for k, v in pairs(arg_9_0) do
		if not table.contains(arg_9_2, k) then
			for k_2, v_2 in pairs(arg_9_1) do
				if not (k ~= k_2 or v == v_2) then
					return false
				end
			end
		end
	end

	return true
end

table.recursive_compare = function (arg_10_0, arg_10_1)
	-- function 10
	local flag = true

	for k, v in pairs(arg_10_0) do
		if type(v) == "table" then
			local var_10_1 = arg_10_1[k]

			if type(var_10_1) == "table" then
				flag = table.recursive_compare(v, arg_10_1[k])

				if not flag then
					break
				end
			else
				flag = false

				break
			end
		else
			for k_2, v_2 in pairs(arg_10_1) do
				if not (k ~= k_2 or v == v_2) then
					return false
				end
			end
		end
	end

	return flag
end

table.create_copy = function (self, arg_11_1)
	-- function 11
	if not self then
		return table.clone(arg_11_1)
	else
		local var_11_0 = getmetatable(arg_11_1)

		assert(var_11_0 == nil or var_11_0.__mt_cloneable, "Metatables will be sliced off")

		for k, v in pairs(arg_11_1) do
			if type(v) ~= "table" or not is_class_instance(v) then
				self[k] = v
			else
				self[k] = table.create_copy(self[k], v)
			end
		end

		for k_2, v_2 in pairs(self) do
			if arg_11_1[k_2] == nil then
				self[k_2] = nil
			end
		end

		return self
	end
end

table.clone_instance = function (arg_12_0)
	-- function 12
	local clone = table.clone(arg_12_0)

	setmetatable(clone, getmetatable(arg_12_0))

	return clone
end

table.merge = function (self, arg_13_1)
	-- function 13
	for k, v in pairs(arg_13_1) do
		self[k] = v
	end

	return self
end

table.merge_recursive = function (self, arg_14_1)
	-- function 14
	for k, v in pairs(arg_14_1) do
		local flag = type(v) == "table"

		if not (not flag and type(self[k]) ~= "table") then
			table.merge_recursive(self[k], v)
		elseif not flag then
			self[k] = table.clone(v)
		else
			self[k] = v
		end
	end
end

table.merge_varargs = function (arg_15_0, arg_15_1, ...)
	-- function 15
	local tbl = {
		unpack(arg_15_0, 1, arg_15_1)
	}
	local var_15_1 = select("#", ...)

	for i = 1, var_15_1 do
		tbl[arg_15_1 + i] = select(i, ...)
	end

	return tbl, arg_15_1 + var_15_1
end

table.pack = function (...)
	-- function 16
	return {
		...
	}, select("#", ...)
end

table.append_recursive = function (self, arg_17_1)
	-- function 17
	for k, v in pairs(arg_17_1) do
		local flag = type(v) == "table"

		if not (not flag and type(self[k]) ~= "table") then
			table.append_recursive(self[k], v)
		elseif self[k] == nil then
			if not flag then
				self[k] = table.clone(v)
			else
				self[k] = v
			end
		end
	end
end

table.append = function (self, arg_18_1)
	-- function 18
	local count = #self

	for i = 1, #arg_18_1 do
		count = count + 1
		self[count] = arg_18_1[i]
	end

	return self
end

table.append_unique = function (self, arg_19_1)
	-- function 19
	local count = #self

	for i = 1, #arg_19_1 do
		if not table.contains(self, arg_19_1[i]) then
			count = count + 1
			self[count] = arg_19_1[i]
		end
	end
end

table.append_non_indexed = function (self, arg_20_1)
	-- function 20
	local count = #self

	for k, v in pairs(arg_20_1) do
		count = count + 1
		self[count] = v
	end

	return self
end

table.contains = function (arg_21_0, arg_21_1)
	-- function 21
	for k, v in pairs(arg_21_0) do
		if v == arg_21_1 then
			return true
		end
	end

	return false
end

table.find = function (arg_22_0, arg_22_1)
	-- function 22
	for k, v in pairs(arg_22_0) do
		if v == arg_22_1 then
			return k
		end
	end

	return nil
end

table.find_by_key = function (arg_23_0, arg_23_1, arg_23_2)
	-- function 23
	for k, v in pairs(arg_23_0) do
		if v[arg_23_1] == arg_23_2 then
			return k, v
		end
	end

	return nil
end

table.index_of = function (self, arg_24_1, arg_24_2)
	-- function 24
	arg_24_2 = arg_24_2 or 1

	for i = arg_24_2, #self do
		if self[i] == arg_24_1 then
			return i
		end
	end

	return -1
end

table.slice = function (self, arg_25_1, arg_25_2)
	-- function 25
	local min = math.min(arg_25_1 + arg_25_2 - 1, #self)
	local tbl = {}

	for i = arg_25_1, min do
		tbl[#tbl + 1] = self[i]
	end

	return tbl
end

table.sorted = function (arg_26_0, arg_26_1, arg_26_2)
	-- function 26
	local alloc_table

	if not arg_26_2 then
		alloc_table = FrameTable.alloc_table()

		if not alloc_table then
			-- Nothing
		end
	end

	alloc_table = {}

	::label_26_0::

	for k, v in pairs(arg_26_0) do
		alloc_table[#alloc_table + 1] = k
	end

	if not arg_26_1 then
		table.sort(alloc_table, function (arg_27_0, arg_27_1)
			-- function 27
			return arg_26_1(arg_26_0, arg_27_0, arg_27_1)
		end)
	else
		table.sort(alloc_table)
	end

	local num = 0

	return function ()
		-- function 28
		num = num + 1

		if not alloc_table[num] then
			return alloc_table[num], arg_26_0[alloc_table[num]]
		end
	end
end

table.reverse = function (self)
	-- function 29
	local count = #self

	for i = 1, math.floor(count / 2) do
		self[i], self[count - i + 1] = self[count - i + 1], self[i]
	end
end

if not pcall(require, "table.clear") then
	table.clear = require("table.clear")
else
	table.clear = function (self)
		-- function 30
		for k in pairs(self) do
			self[k] = nil
		end
	end
end

table.clear_array = function (self, arg_31_1)
	-- function 31
	for i = 1, arg_31_1 or #self do
		self[i] = nil
	end
end

local function fn(arg_32_0, arg_32_1, arg_32_2, arg_32_3, arg_32_4)
	-- function 32
	if arg_32_3 < arg_32_2 then
		return
	end

	local rep = string.rep("  ", arg_32_2 + 1)
	local flag

	flag = arg_32_0 ~= nil or not "" or "[" .. tostring(arg_32_0) .. "]"

	local str = rep .. flag

	if type(arg_32_1) == "table" then
		local var_32_3 = str
		local flag_2

		flag_2 = arg_32_0 ~= nil or not "" or " = "
		str = var_32_3 .. flag_2

		print(str .. "table")

		if not arg_32_3 then
			for k, v in pairs(arg_32_1) do
				fn(k, v, arg_32_2 + 1, arg_32_3, arg_32_4)
			end
		end

		local var_32_5 = getmetatable(arg_32_1)

		if not var_32_5 then
			print(str .. "metatable")

			if not arg_32_3 then
				for k_2, v_2 in pairs(var_32_5) do
					if not (k_2 == "__index" or k_2 == "super") then
						fn(k_2, v_2, arg_32_2 + 1, arg_32_3, arg_32_4)
					end
				end
			end
		end
	elseif not (type(arg_32_1) == "function" or type(arg_32_1) == "thread" or type(arg_32_1) == "userdata" or arg_32_1 ~= nil) then
		arg_32_4(str .. " = " .. tostring(arg_32_1))
	else
		arg_32_4(str .. " = " .. tostring(arg_32_1) .. " (" .. type(arg_32_1) .. ")")
	end
end

table.dump = function (arg_33_0, arg_33_1, arg_33_2, arg_33_3)
	-- function 33
	arg_33_3 = arg_33_3 or print

	if not arg_33_1 then
		arg_33_3(string.format("<%s>", arg_33_1))
	end

	if not arg_33_0 then
		for k, v in pairs(arg_33_0) do
			fn(k, v, 0, arg_33_2 or 0, arg_33_3)
		end
	else
		arg_33_3("no table!")
	end

	if not arg_33_1 then
		arg_33_3(string.format("</%s>", arg_33_1))
	end
end

function is_array(arg_34_0)
	-- function 34
	for k, v in pairs(arg_34_0) do
		if type(k) ~= "number" then
			return false
		end
	end

	return true
end

function array_dump_string(arg_35_0, arg_35_1)
	-- function 35
	local str = "{\n"

	for i, v in ipairs(arg_35_0) do
		str = str .. string.rep("\t", arg_35_1) .. value_to_string(v, arg_35_1)

		if next(arg_35_0, i) ~= nil then
			str = str .. ",\n"
		end
	end

	return str .. "\n" .. string.rep("\t", arg_35_1 - 1) .. "}"
end

function value_to_string(arg_36_0, arg_36_1)
	-- function 36
	if type(arg_36_0) ~= "table" or not is_array(arg_36_0) then
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
	-- function 37
	local str = "{\n"

	for k, v in pairs(arg_37_0) do
		str = str .. string.rep("\t", arg_37_1) .. k .. " = " .. value_to_string(v, arg_37_1)

		if next(arg_37_0, k) ~= nil then
			str = str .. ",\n"
		end
	end

	return str .. "\n" .. string.rep("\t", arg_37_1 - 1) .. "}"
end

table.dump_string = function (arg_38_0, arg_38_1)
	-- function 38
	if not is_array(arg_38_0) then
		return array_dump_string(arg_38_0, arg_38_1 or 1)
	else
		return table_dump_string(arg_38_0, arg_38_1 or 1)
	end
end

local tbl = {}

table.minidump = function (arg_39_0, arg_39_1)
	-- function 39
	local var_39_0 = tbl
	local num = 1

	if not arg_39_1 then
		var_39_0[1] = "["
		var_39_0[2] = arg_39_1
		var_39_0[3] = "] "
		num = 4
	end

	for k, v in pairs(arg_39_0) do
		var_39_0[num] = k
		var_39_0[num + 1] = " = "
		var_39_0[num + 2] = tostring(v)
		var_39_0[num + 3] = "; "
		num = num + 4
	end

	local concat = table.concat(var_39_0, 1, num - 2)

	table.clear(var_39_0)

	return concat
end

table.shuffle = function (self, arg_40_1)
	-- function 40
	if not arg_40_1 then
		for i = #self, 2, -1 do
			local var_40_0
			local var_40_1

			arg_40_1, var_40_1 = Math.next_random(arg_40_1, i)
			self[var_40_1], self[i] = self[i], self[var_40_1]
		end
	else
		for j = #self, 2, -1 do
			local random = Math.random(j)

			self[random], self[j] = self[j], self[random]
		end
	end

	return arg_40_1
end

table.max = function (arg_41_0)
	-- function 41
	local var_41_0, var_41_1 = next(arg_41_0)

	for k, v in pairs(arg_41_0) do
		if var_41_1 < v then
			var_41_0, var_41_1 = k, v
		end
	end

	return var_41_0, var_41_1
end

table.max_func = function (arg_42_0, arg_42_1)
	-- function 42
	local var_42_0, var_42_1 = next(arg_42_0)

	for k, v in pairs(arg_42_0) do
		if arg_42_1(v) > arg_42_1(var_42_1) then
			var_42_0, var_42_1 = k, v
		end
	end

	return var_42_0, var_42_1
end

table.min = function (arg_43_0)
	-- function 43
	local var_43_0, var_43_1 = next(arg_43_0)

	for k, v in pairs(arg_43_0) do
		if v < var_43_1 then
			var_43_0, var_43_1 = k, v
		end
	end

	return var_43_0, var_43_1
end

table.for_each = function (self, arg_44_1)
	-- function 44
	for k, v in pairs(self) do
		self[k] = arg_44_1(v)
	end
end

function _add_tabs(arg_45_0, arg_45_1)
	-- function 45
	for i = 1, arg_45_1 do
		arg_45_0 = arg_45_0 .. "\t"
	end

	return arg_45_0
end

local var_0_2
local var_0_3

local function fn_2(arg_46_0, arg_46_1, arg_46_2, arg_46_3)
	-- function 46
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

function var_0_3(self, arg_47_1, arg_47_2, arg_47_3)
	-- function 47
	local tbl = {
		"{\n"
	}
	local rep = string.rep("\t", arg_47_1 - 1)
	local str = rep .. "\t"
	local count = #self

	for i = 1, count do
		tbl[#tbl + 1] = str

		table.append(tbl, fn_2(self[i], arg_47_1, arg_47_2, arg_47_3))

		tbl[#tbl + 1] = ",\n"
	end

	for k, v in pairs(self) do
		local flag = type(k) == "number"

		if not ((flag or arg_47_3 or k:sub(1, 1) ~= "_") and not flag and k < 1 or not (count < k)) then
			local var_47_5

			if not flag then
				var_47_5 = string.format("[%i]", k)
			else
				var_47_5 = tostring(k)
			end

			tbl[#tbl + 1] = str
			tbl[#tbl + 1] = var_47_5
			tbl[#tbl + 1] = " = "

			table.append(tbl, fn_2(v, arg_47_1, arg_47_2, arg_47_3))

			tbl[#tbl + 1] = ",\n"
		end
	end

	tbl[#tbl + 1] = rep
	tbl[#tbl + 1] = "}"

	return tbl
end

table.tostring = function (arg_48_0, arg_48_1, arg_48_2)
	-- function 48
	return table.concat(var_0_3(arg_48_0, 1, arg_48_1 or 1, arg_48_2))
end

table.set = function (arg_49_0, arg_49_1)
	-- function 49
	arg_49_1 = arg_49_1 or {}

	for i, v in ipairs(arg_49_0) do
		arg_49_1[v] = true
	end

	return arg_49_1
end

table.mirror_table = function (arg_50_0, arg_50_1)
	-- function 50
	assert(arg_50_0 ~= arg_50_1)

	local flag = arg_50_1 or {}

	for k, v in pairs(arg_50_0) do
		flag[k] = v
		flag[v] = k
	end

	return flag
end

table.mirror_array = function (arg_51_0, arg_51_1)
	-- function 51
	assert(arg_51_0 ~= arg_51_1)

	local flag = arg_51_1 or {}

	for i, v in ipairs(arg_51_0) do
		flag[i] = v
		flag[v] = i
	end

	return flag
end

table.mirror_array_inplace = function (self)
	-- function 52
	for i, v in ipairs(self) do
		self[v] = i
	end

	return self
end

table.keys = function (arg_53_0, arg_53_1, arg_53_2)
	-- function 53
	arg_53_1 = arg_53_1 or {}

	local flag = arg_53_2 or 0

	for k in pairs(arg_53_0) do
		flag = flag + 1
		arg_53_1[flag] = k
	end

	return arg_53_1, flag
end

table.split_unordered = function (arg_54_0)
	-- function 54
	local tbl = {}
	local tbl_2 = {}
	local flag = true

	for k, v in pairs(arg_54_0) do
		if not flag then
			tbl[k] = v
		else
			tbl_2[k] = v
		end

		flag = not flag
	end

	return tbl, tbl_2
end

table.keys_if = function (arg_55_0, arg_55_1, arg_55_2)
	-- function 55
	arg_55_1 = arg_55_1 or {}

	local num = 0

	for k, v in pairs(arg_55_0) do
		if not arg_55_2(k, v) then
			num = num + 1
			arg_55_1[num] = k
		end
	end

	return arg_55_1, num
end

table.values = function (arg_56_0, arg_56_1)
	-- function 56
	arg_56_1 = arg_56_1 or {}

	local num = 0

	for k, v in pairs(arg_56_0) do
		num = num + 1
		arg_56_1[num] = v
	end

	return arg_56_1, num
end

table.append_varargs = function (self, ...)
	-- function 57
	local var_57_0 = select("#", ...)
	local count = #self

	for i = 1, var_57_0 do
		self[count + i] = select(i, ...)
	end

	return self
end

table.array_to_table = function (self, arg_58_1, arg_58_2)
	-- function 58
	for i = 1, arg_58_1, 2 do
		arg_58_2[self[i]] = self[i + 1]
	end
end

table.table_to_array = function (arg_59_0, arg_59_1)
	-- function 59
	assert(#arg_59_1 == 0)

	local num = 0

	for k, v in pairs(arg_59_0) do
		arg_59_1[num + 1] = k
		arg_59_1[num + 2] = v
		num = num + 2
	end

	return num
end

table.add_meta_logging = function (arg_60_0, arg_60_1, arg_60_2)
	-- function 60
	local flag = arg_60_0 or {}

	if not arg_60_1 then
		local tbl = {
			__index = function (arg_61_0, arg_61_1)
				-- function 61
				local var_61_0 = rawget(flag, arg_61_1)

				print("meta getting", arg_60_2, arg_61_1, var_61_0)

				return var_61_0
			end
		}

		setmetatable(tbl, tbl)

		tbl.__newindex = function (arg_62_0, arg_62_1, arg_62_2)
			-- function 62
			print("meta setting", arg_60_2, arg_62_1, arg_62_2)
			rawset(flag, arg_62_1, arg_62_2)
		end

		return tbl
	else
		return flag
	end
end

local function fn_3(self, arg_63_1)
	-- function 63
	arg_63_1 = arg_63_1 - 1

	local var_63_0 = self[arg_63_1]

	if not var_63_0 then
		return arg_63_1, var_63_0
	end
end

function ripairs(arg_64_0)
	-- function 64
	return fn_3, arg_64_0, #arg_64_0 + 1
end

table.swap_delete = function (self, arg_65_1)
	-- function 65
	local count = #self
	local var_65_1 = self[arg_65_1]

	self[arg_65_1] = self[count]
	self[count] = nil

	return var_65_1
end

table.array_remove_if = function (self, arg_66_1)
	-- function 66
	local num = 1
	local var_66_1

	for i = 1, #self do
		local var_66_2

		var_66_2, self[i] = self[i]

		if not arg_66_1(var_66_2) then
			self[num], num = var_66_2, num + 1
		end
	end
end

table.remove_if = function (self, arg_67_1)
	-- function 67
	for k, v in pairs(self) do
		if not arg_67_1(k, v) then
			self[k] = nil
		end
	end
end

;({}).__index = function (arg_68_0, arg_68_1)
	-- function 68
	return error("Don't know `" .. tostring(arg_68_1) .. "` for enum.")
end

table.enum = function (...)
	-- function 69
	local tbl = {}

	for i = 1, select("#", ...) do
		local var_69_1 = select(i, ...)

		tbl[var_69_1] = var_69_1
	end

	return tbl
end

table.ordered_enum = function (...)
	-- function 70
	local tbl = {}

	for i = 1, select("#", ...) do
		local var_70_1 = select(i, ...)

		tbl[var_70_1] = var_70_1
		tbl[i] = var_70_1
	end

	return tbl
end

table.enum_safe = function (...)
	-- function 71
	local tbl = {}

	for i = 1, select("#", ...) do
		local var_71_1 = select(i, ...)

		tbl[var_71_1] = var_71_1
	end

	return tbl
end

table.map = function (arg_72_0, arg_72_1)
	-- function 72
	local tbl = {}

	for k, v in pairs(arg_72_0) do
		tbl[k] = arg_72_1(v)
	end

	return tbl
end

table.filter = function (arg_73_0, arg_73_1, arg_73_2)
	-- function 73
	arg_73_2 = arg_73_2 or {}

	for k, v in pairs(arg_73_0) do
		if arg_73_1(v) == true then
			arg_73_2[k] = v
		end
	end

	return arg_73_2
end

table.filter_to_array = function (arg_74_0, arg_74_1, arg_74_2)
	-- function 74
	arg_74_2 = arg_74_2 or {}

	local num = 0

	for k, v in pairs(arg_74_0) do
		if not arg_74_1(v) then
			num = num + 1
			arg_74_2[num] = v
		end
	end

	return arg_74_2, num
end

table.filter_array = function (self, arg_75_1, arg_75_2)
	-- function 75
	arg_75_2 = arg_75_2 or {}

	local num = 0

	for i = 1, #self do
		local var_75_1 = self[i]

		if not arg_75_1(var_75_1) then
			num = num + 1
			arg_75_2[num] = var_75_1
		end
	end

	return arg_75_2, num
end

table.get_value_or_last = function (self, arg_76_1)
	-- function 76
	local var_76_0 = self[arg_76_1]

	var_76_0 = var_76_0 or self[#self]

	return var_76_0
end

table.autovivified = function (arg_77_0)
	-- function 77
	arg_77_0 = arg_77_0 or TNEW

	return setmetatable({}, {
		__index = function (self, arg_78_1)
			-- function 78
			local var_78_0 = arg_77_0(arg_78_1)

			self[arg_78_1] = var_78_0

			return var_78_0
		end
	})
end

table.every = function (arg_79_0, arg_79_1)
	-- function 79
	for k, v in pairs(arg_79_0) do
		if not arg_79_1(k, v) then
			return false
		end
	end

	return true
end

table.find_func = function (arg_80_0, arg_80_1)
	-- function 80
	for k, v in pairs(arg_80_0) do
		if not arg_80_1(k, v) then
			return k, v
		end
	end
end

table.find_func_array = function (self, arg_81_1)
	-- function 81
	for i = 1, #self do
		local var_81_0 = self[i]

		if not arg_81_1(var_81_0) then
			return i, var_81_0
		end
	end
end

table.random = function (self)
	-- function 82
	return self[math.random(1, #self)]
end

table.recursive_readonlytable = function (arg_83_0)
	-- function 83
	setmetatable(arg_83_0, {
		__newindex = function (arg_84_0, arg_84_1, arg_84_2)
			-- function 84
			error("Trying to modify read only table.")
		end
	})

	for k, v in pairs(arg_83_0) do
		if type(v) == "table" then
			table.recursive_readonlytable(v)
		end
	end
end

table.flat = function (arg_85_0, arg_85_1, arg_85_2)
	-- function 85
	arg_85_1 = arg_85_1 or 1
	arg_85_2 = (arg_85_2 or 0) + 1

	local tbl = {}

	for k, v in pairs(arg_85_0) do
		if not (type(v) ~= "table" or not (arg_85_2 <= arg_85_1)) then
			table.append(tbl, table.flat(v, arg_85_1, arg_85_2))
		else
			tbl[#tbl + 1] = v
		end
	end

	return tbl
end

table.make_strict = function (arg_86_0, arg_86_1, arg_86_2)
	-- function 86
	assert(getmetatable(arg_86_0) == nil, "Cannot call make_strict on a table with a metatable")

	arg_86_2 = arg_86_2 or "strict table"
	arg_86_1 = arg_86_1 or arg_86_0

	return setmetatable(arg_86_0, {
		__class_name = arg_86_2,
		__index = function (arg_87_0, arg_87_1)
			-- function 87
			if arg_86_1[arg_87_1] == nil then
				ferror("Reading from key %q not in interface <%s>", arg_87_1, arg_86_2)
			end

			return nil
		end,
		__newindex = function (arg_88_0, arg_88_1, arg_88_2)
			-- function 88
			if arg_86_1[arg_88_1] == nil then
				ferror("Writing to key %q not in interface <%s>", arg_88_1, arg_86_2)
			end

			return rawset(arg_88_0, arg_88_1, arg_88_2)
		end
	})
end

table.select_array = function (self, arg_89_1)
	-- function 89
	local tbl = {}

	for i = 1, #self do
		tbl[#tbl + 1] = arg_89_1(i, self[i])
	end

	return tbl
end

table.select_map = function (arg_90_0, arg_90_1)
	-- function 90
	local tbl = {}

	for k, v in pairs(arg_90_0) do
		tbl[k] = arg_90_1(k, v)
	end

	return tbl
end

table.array_to_map = function (arg_91_0, arg_91_1)
	-- function 91
	local tbl = {}

	for k, v in pairs(arg_91_0) do
		local var_91_1, var_91_2 = arg_91_1(k, v)

		tbl[var_91_1] = var_91_2
	end

	return tbl
end

table.map_to_array = function (arg_92_0, arg_92_1)
	-- function 92
	local tbl = {}
	local num = 0

	for k, v in pairs(arg_92_0) do
		local var_92_2 = arg_92_1(k, v)

		if not var_92_2 then
			num = num + 1
			tbl[num] = var_92_2
		end
	end

	return tbl
end

table.remove_empty_values = function (arg_93_0)
	-- function 93
	if not table.is_empty(arg_93_0) then
		return nil
	end

	local tbl = {}

	for k, v in pairs(arg_93_0) do
		if k ~= StrictNil then
			local var_93_1 = type(v)

			if var_93_1 == "table" then
				if not table.is_empty(v) then
					tbl[k] = table.remove_empty_values(v)
				end
			elseif not (var_93_1 ~= "string" or v == "") then
				tbl[k] = v
			elseif var_93_1 ~= "nil" then
				tbl[k] = v
			end
		end
	end

	if not table.is_empty(tbl) then
		return nil
	else
		return tbl
	end
end

local function fn_4(self, arg_94_1, arg_94_2, arg_94_3)
	-- function 94
	local var_94_0 = self[arg_94_2]
	local num = arg_94_1 - 1

	for i = arg_94_1, arg_94_2 - 1 do
		local var_94_2

		if not arg_94_3 then
			var_94_2 = arg_94_3(self[i], var_94_0)
		else
			var_94_2 = var_94_0 >= self[i]
		end

		if not var_94_2 then
			num = num + 1
			self[num], self[i] = self[i], self[num]
		end
	end

	self[num + 1], self[arg_94_2] = self[arg_94_2], self[num + 1]

	return num + 1
end

local function fn_5(arg_95_0, arg_95_1, arg_95_2, arg_95_3)
	-- function 95
	if arg_95_1 < arg_95_2 then
		local var_95_0 = fn_4(arg_95_0, arg_95_1, arg_95_2, arg_95_3)

		fn_5(arg_95_0, arg_95_1, var_95_0 - 1, arg_95_3)
		fn_5(arg_95_0, var_95_0 + 1, arg_95_2, arg_95_3)
	end
end

table.sort_span = function (arg_96_0, arg_96_1, arg_96_2, arg_96_3)
	-- function 96
	fn_5(arg_96_0, arg_96_1, arg_96_2, arg_96_3)
end

table.array_average = function (self, arg_97_1, arg_97_2)
	-- function 97
	if not arg_97_2 then
		local index_wrapper = math.index_wrapper
		local index = self.index

		index = index or 0

		local var_97_2 = index_wrapper(index + 1, arg_97_1)

		self[var_97_2] = arg_97_2
		self.index = var_97_2
	end

	local count = #self
	local num = 0
	local num_2 = 0
	local num_3 = 0

	for i = 1, count do
		local var_97_7 = self[i]

		num = num + var_97_7
		num_2 = not (var_97_7 < num_2) or not var_97_7 or num_2
		num_3 = not (num_3 < var_97_7) or not var_97_7 or num_3
	end

	return num / count, num_2, num_3
end

table.convert_lookup = function (self, arg_98_1)
	-- function 98
	for i = 1, #self do
		self[i] = arg_98_1[self[i]]
	end

	return self
end

table.enum_lookup = function (...)
	-- function 99
	local tbl = {
		...
	}
	local mirror_array = table.mirror_array(tbl)

	return table.ordered_enum(unpack(mirror_array)), mirror_array
end

table.insert_unique = function (arg_100_0, arg_100_1, arg_100_2)
	-- function 100
	if not (table.find(arg_100_0, arg_100_1) or not arg_100_2 or table.insert(arg_100_0, arg_100_2, arg_100_1)) then
		local insert = table.insert(arg_100_0, arg_100_1)
	end
end

table.remove_array_value = function (self, arg_101_1)
	-- function 101
	local num = 1
	local num_2 = 1
	local count = #self

	while num <= count do
		if self[num] == arg_101_1 then
			self[num] = nil
		else
			num_2 = num_2 + 1
		end

		num = num + 1
		self[num_2] = self[num]
	end

	return self
end

table.fill = function (self, arg_102_1, arg_102_2)
	-- function 102
	for i = 1, arg_102_1 do
		self[i] = arg_102_2
	end

	return self
end

table.count_if = function (arg_103_0, arg_103_1)
	-- function 103
	local num = 0

	for k, v in pairs(arg_103_0) do
		if not arg_103_1(k, v) then
			num = num + 1
		end
	end

	return num
end

table.shallow_equal = function (self, arg_104_1)
	-- function 104
	for k, v in pairs(self) do
		if self[k] ~= arg_104_1[k] then
			return false
		end
	end

	for k_2, v_2 in pairs(arg_104_1) do
		if arg_104_1[k_2] ~= self[k_2] then
			return false
		end
	end

	return true
end

table.safe_get = function (arg_105_0, ...)
	-- function 105
	local var_105_0 = arg_105_0

	for i = 1, select("#", ...) do
		var_105_0 = var_105_0[select(i, ...)]

		if not var_105_0 then
			return nil
		end
	end

	return var_105_0
end
