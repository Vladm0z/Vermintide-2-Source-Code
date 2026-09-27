-- chunkname: @scripts/managers/game_mode/mechanisms/deus_populate_graph.lua

require("scripts/settings/dlcs/morris/deus_map_populate_settings")
require("scripts/managers/game_mode/mechanisms/deus_gen_engine")
require("scripts/helpers/deus_gen_utils")

local function fn(self, arg_1_1)
	-- function 1
	for i = #self, 2, -1 do
		local var_1_0 = arg_1_1(1, i)

		self[var_1_0], self[i] = self[i], self[var_1_0]
	end

	return self
end

local function fn_2(arg_2_0, arg_2_1)
	-- function 2
	local tbl = {}

	for k, v in pairs(arg_2_0) do
		tbl[#tbl + 1] = k
	end

	table.sort(tbl)

	for k_2 = #tbl, 2, -1 do
		local var_2_1 = arg_2_1(1, k_2)

		tbl[var_2_1], tbl[k_2] = tbl[k_2], tbl[var_2_1]
	end

	return tbl
end

local function fn_3(arg_3_0)
	-- function 3
	local tbl = {}

	for k, v in pairs(arg_3_0) do
		tbl[#tbl + 1] = v
	end

	return tbl
end

local function fn_4(arg_4_0, arg_4_1)
	-- function 4
	local tbl = {}

	for k, v in pairs(arg_4_0) do
		if arg_4_1 < v.run_progress then
			tbl[#tbl + 1] = v
		end
	end

	return tbl
end

local function fn_5(arg_5_0, arg_5_1)
	-- function 5
	local tbl = {}

	for i, v in ipairs(arg_5_0) do
		if not table.contains(arg_5_1, v.type) then
			tbl[#tbl + 1] = v
		end
	end

	return tbl
end

local function fn_6(self, arg_6_1)
	-- function 6
	if #self[arg_6_1].prev == 0 then
		return {
			{
				arg_6_1
			}
		}
	end

	local tbl = {}

	for i, v in ipairs(self[arg_6_1].prev) do
		local var_6_1 = fn_6(self, v)

		for i_2, v_2 in ipairs(var_6_1) do
			v_2[#v_2 + 1] = arg_6_1
			tbl[#tbl + 1] = v_2
		end
	end

	return tbl
end

local function fn_7(arg_7_0, arg_7_1)
	-- function 7
	local tbl = {}

	local function fn(arg_8_0)
		-- function 8
		for i, v in ipairs(arg_7_0[arg_8_0].next) do
			if not tbl[v] then
				tbl[v] = true

				fn(v)
			end
		end
	end

	local function fn_2(arg_9_0)
		-- function 9
		for i, v in ipairs(arg_7_0[arg_9_0].prev) do
			if not tbl[v] then
				tbl[v] = true

				fn_2(v)
			end
		end
	end

	fn(arg_7_1)
	fn_2(arg_7_1)

	return tbl
end

local function fn_8(self, arg_10_1)
	-- function 10
	if #self[arg_10_1].next == 0 then
		return {}
	end

	local tbl = {}

	for i, v in ipairs(self[arg_10_1].next) do
		local type = self[v].type

		if not (type == "SIGNATURE" or type == "TRAVEL" or type ~= "ARENA") then
			tbl[#tbl + 1] = v
		else
			local var_10_2 = fn_8(self, v)

			for i_2, v_2 in ipairs(var_10_2) do
				tbl[#tbl + 1] = v_2
			end
		end
	end

	return tbl
end

local function fn_9(self, arg_11_1, arg_11_2)
	-- function 11
	if arg_11_2 > 1 then
		arg_11_2 = arg_11_2 - 1

		local tbl = {}

		for i, v in ipairs(self[arg_11_1].next) do
			local var_11_1 = fn_9(self, v, arg_11_2)

			for k, v_2 in pairs(var_11_1) do
				tbl[k] = v_2
			end
		end

		return tbl
	else
		return self[arg_11_1].next
	end
end

local function fn_10(arg_12_0, arg_12_1, arg_12_2, arg_12_3)
	-- function 12
	local prev = arg_12_1[arg_12_2].prev

	for i, v in ipairs(prev) do
		local var_12_1 = arg_12_1[v]

		for i_2, v_2 in ipairs(var_12_1.next) do
			local var_12_2 = arg_12_1[v_2]

			if not (v_2 == arg_12_2 or var_12_2.level ~= arg_12_3) then
				return false
			end
		end
	end

	return true
end

local function fn_11(arg_13_0, arg_13_1, arg_13_2, arg_13_3)
	-- function 13
	local var_13_0 = fn_6(arg_13_1, arg_13_2)

	for i, v in ipairs(var_13_0) do
		for k = #v, 1, -1 do
			local var_13_1 = v[k]

			if not (var_13_1 == arg_13_2 or arg_13_1[var_13_1].level ~= arg_13_3) then
				return false
			end
		end
	end

	return true
end

local function fn_12(self, arg_14_1, arg_14_2, arg_14_3)
	-- function 14
	local var_14_0 = arg_14_1[arg_14_2]

	for i, v in ipairs(var_14_0.next) do
		if #arg_14_1[v].next == 0 then
			return self.SPECIFIC_SIGNATURE_LEVEL == arg_14_3
		end
	end

	return true
end

local tbl = {
	SIGNATURE = {
		prevent_same_level_choice = fn_10,
		last_signature_level_is_specific_level = fn_12,
		prevent_same_level_on_same_path = fn_11
	},
	TRAVEL = {
		prevent_same_level_choice = fn_10,
		prevent_same_level_on_same_path = fn_11
	},
	SHOP = {
		prevent_same_level_choice = fn_10
	},
	ARENA = {}
}
local tbl_2 = {
	lower_priority_of_already_used_levels_on_path = function (arg_15_0, arg_15_1, arg_15_2, arg_15_3)
		-- function 15
		local function fn(arg_16_0, arg_16_1)
			-- function 16
			if arg_15_1[arg_16_0].level == arg_16_1 then
				return true
			end

			for i, v in ipairs(arg_15_1[arg_16_0].prev) do
				if not fn(v, arg_16_1) then
					return true
				end
			end

			return false
		end

		local count = #arg_15_3

		for i = #arg_15_3, 1, -1 do
			local var_15_2 = arg_15_3[i]

			if not fn(arg_15_2, var_15_2) then
				arg_15_3[i] = arg_15_3[count]
				arg_15_3[count] = var_15_2
				count = count - 1
			end
		end
	end
}
local tbl_3 = {
	last_signature_level_is_specific_level = function (self, arg_17_1, arg_17_2)
		-- function 17
		local SPECIFIC_SIGNATURE_LEVEL = self.config.SPECIFIC_SIGNATURE_LEVEL

		fassert(SPECIFIC_SIGNATURE_LEVEL, "you need to specify a SPECIFIC_SIGNATURE_LEVEL when using LABEL_OVERRIDES.last_signature_level_is_specific_level")

		local SIGNATURE = arg_17_2.SIGNATURE
		local var_17_2

		for i, v in ipairs(arg_17_1.final.prev) do
			local var_17_3 = arg_17_1[v]

			if var_17_3.type == "SIGNATURE" then
				var_17_2 = var_17_3.label

				break
			end
		end

		fassert(var_17_2, "a graph needs to have a signature level just before the end in order for LABEL_OVERRIDES.last_signature_level_is_specific_level to work")

		local var_17_4

		for k, v_2 in pairs(SIGNATURE) do
			if v_2 == SPECIFIC_SIGNATURE_LEVEL then
				var_17_4 = k

				break
			end
		end

		fassert(var_17_4, sprintf("In LABEL_OVERRIDES.last_signature_level_is_specific_level the level %s was not found in the level availability", SPECIFIC_SIGNATURE_LEVEL))

		SIGNATURE[var_17_4], SIGNATURE[var_17_2] = SIGNATURE[var_17_2], SPECIFIC_SIGNATURE_LEVEL

		return arg_17_2
	end
}
local tbl_4 = {
	prevent_modifier_on_curse_abundance_of_life = function (arg_18_0, arg_18_1, arg_18_2, arg_18_3)
		-- function 18
		return arg_18_1[arg_18_2].curse ~= "curse_abundance_of_life" or not not table.contains(arg_18_3, "increased_grenades") or not table.contains(arg_18_3, "increased_healing")
	end
}

local function fn_13(self, arg_19_1, arg_19_2, arg_19_3, arg_19_4)
	-- function 19
	local type = arg_19_2[arg_19_3].type
	local var_19_1 = self.LEVEL_VALIDATIONS[type]
	local var_19_2 = tbl[type]

	for i, v in ipairs(var_19_1) do
		if not var_19_2[v](self, arg_19_2, arg_19_3, arg_19_4) then
			return false
		end
	end

	return true
end

local function fn_14(self, arg_20_1, arg_20_2)
	-- function 20
	local var_20_0 = arg_20_1[arg_20_2]

	if not fn_13(self.config, self.indent, arg_20_1, arg_20_2, var_20_0.level, self.indent) then
		return false
	end

	for i, v in ipairs(var_20_0.next) do
		if not fn_14(self, arg_20_1, v) then
			return false
		end
	end

	return true
end

local function fn_15(self, arg_21_1, arg_21_2, arg_21_3)
	-- function 21
	local type = arg_21_1[arg_21_2].type
	local var_21_1 = self.config.LEVEL_AVAILABILITY[type]
	local clone = table.clone(var_21_1[arg_21_3].paths)

	local function fn(arg_22_0)
		-- function 22
		local var_22_0 = arg_21_1[arg_22_0]

		if var_22_0.level == arg_21_3 then
			local index_of = table.index_of(clone, var_22_0.path)

			if index_of ~= -1 then
				table.swap_delete(clone, index_of)
			end
		end
	end

	local function fn_2(arg_23_0)
		-- function 23
		local var_23_0 = arg_21_1[arg_23_0]

		for i, v in ipairs(var_23_0.prev) do
			fn(v)
			fn_2(v)
		end
	end

	local function fn_3(arg_24_0)
		-- function 24
		local var_24_0 = arg_21_1[arg_24_0]

		for i, v in ipairs(var_24_0.next) do
			fn(v)
			fn_3(v)
		end
	end

	fn(arg_21_2)
	fn_2(arg_21_2)
	fn_3(arg_21_2)

	return clone
end

local var_0_19
local var_0_20
local var_0_21

local function fn_16(arg_25_0, arg_25_1, arg_25_2)
	-- function 25
	local function fn_2()
		-- function 26
		local var_26_0 = arg_25_1[arg_25_2]
		local var_26_1 = fn(table.clone(var_26_0.next), arg_25_0.random_generator)
		local tbl = {}

		for i = 1, #var_26_1 do
			tbl[i] = function ()
				-- function 27
				return var_0_19(arg_25_0, arg_25_1, var_26_1[i])
			end
		end

		return true, tbl
	end

	return {
		name = "connections " .. arg_25_2,
		run = function ()
			-- function 28
			return fn_2()
		end,
		retry = function ()
			-- function 29
			return false
		end
	}
end

function var_0_19(arg_30_0, arg_30_1, arg_30_2)
	-- function 30
	local var_30_0 = arg_30_1[arg_30_2]
	local type = var_30_0.type

	return {
		name = "node " .. arg_30_2,
		run = function ()
			-- function 31
			if not var_30_0.level then
				return fn_14(arg_30_0, arg_30_1, arg_30_2)
			end

			local tbl = {
				function ()
					-- function 32
					return var_0_20(arg_30_0, arg_30_1, arg_30_2)
				end
			}

			return true, tbl
		end,
		retry = function ()
			-- function 33
			return false
		end
	}
end

function var_0_20(self, arg_34_1, arg_34_2)
	-- function 34
	local var_34_0 = arg_34_1[arg_34_2]
	local type = var_34_0.type
	local label = var_34_0.label
	local var_34_3 = self.config.LEVEL_AVAILABILITY[type]

	local function fn_3()
		-- function 35
		local var_35_0 = fn_2(var_34_3, self.random_generator)

		for i, v in ipairs(self.config.LEVEL_SHUFFLERS) do
			tbl_2[v](self, arg_34_1, arg_34_2, var_35_0)
		end

		table.reverse(var_35_0)

		return var_35_0
	end

	local var_34_5

	local function fn_4()
		-- function 36
		if not (not label and label == 0) then
			var_34_0.level = self.shuffled_levels_for_labels[type][label]

			local paths = var_34_3[var_34_0.level].paths
			local var_36_1 = fn(table.clone(paths), self.random_generator)

			var_34_0.path = var_36_1[1]
		else
			if not var_34_5 then
				var_34_5 = fn_3()
			end

			while #var_34_5 > 0 do
				local var_36_2 = var_34_5[#var_34_5]

				var_34_5[#var_34_5] = nil

				if not fn_13(self.config, self.indent, arg_34_1, arg_34_2, var_36_2) then
					if var_34_0.type == "SHOP" then
						var_34_0.level = var_36_2

						break
					else
						local var_36_3 = fn_15(self, arg_34_1, arg_34_2, var_36_2)

						if #var_36_3 == 0 then
							-- Nothing
						else
							local var_36_4 = fn(table.clone(var_36_3), self.random_generator)

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

		local tbl = {
			function ()
				-- function 37
				return fn_16(self, arg_34_1, arg_34_2)
			end
		}

		return true, tbl
	end

	return {
		name = "level " .. arg_34_2,
		run = function ()
			-- function 38
			return fn_4()
		end,
		retry = function ()
			-- function 39
			var_34_0.level = nil
			var_34_0.path = nil

			if not (not label and label == 0) then
				return false
			else
				return fn_4()
			end
		end
	}
end

local function fn_17(self, arg_40_1)
	-- function 40
	local num = -1
	local num_2 = -1

	for i, v in ipairs(arg_40_1) do
		if not self[v].run_progress then
			if num == -1 then
				num = i
			end

			num_2 = i
		elseif num ~= -1 then
			return num, num_2
		end
	end

	return num, num_2
end

local function fn_18(self, arg_41_1)
	-- function 41
	local tbl = {}

	for i, v in ipairs(arg_41_1) do
		if self[v].type ~= "START" then
			tbl[#tbl + 1] = v
		end
	end

	return tbl
end

local function fn_19(self, arg_42_1, arg_42_2, arg_42_3)
	-- function 42
	local var_42_0 = self[arg_42_1[arg_42_2 - 1]]
	local var_42_1 = self[arg_42_1[arg_42_3 + 1]]
	local run_progress

	if not var_42_0 then
		run_progress = var_42_0.run_progress

		if not run_progress then
			-- Nothing
		end
	end

	run_progress = 0

	do
		local run_progress_2
	end

	::label_42_0::

	if not var_42_1 then
		run_progress_2 = var_42_1.run_progress

		if not run_progress_2 then
			-- Nothing
		end
	end

	run_progress_2 = 0.9999

	::label_42_1::

	local num = arg_42_3 - arg_42_2
	local num_2 = 0

	if not var_42_0 then
		num = num + 1
		num_2 = 1
	end

	if not var_42_1 then
		num = num + 1
	end

	for i = arg_42_2, arg_42_3 do
		local num_3 = i - arg_42_2
		local lerp = math.lerp(run_progress, run_progress_2, (num_3 + num_2) / num)

		self[arg_42_1[i]].run_progress = lerp
	end
end

local function fn_20(arg_43_0, arg_43_1)
	-- function 43
	local var_43_0 = fn_6(arg_43_1, "final")

	table.sort(var_43_0, function (arg_44_0, arg_44_1)
		-- function 44
		return #arg_44_0 > #arg_44_1
	end)

	for i, v in ipairs(var_43_0) do
		local var_43_1 = fn_18(arg_43_1, v)

		while true do
			local var_43_2, var_43_3 = fn_17(arg_43_1, var_43_1)

			if var_43_2 == -1 then
				break
			end

			fn_19(arg_43_1, var_43_1, var_43_2, var_43_3)
		end

		for i_2, v_2 in ipairs(v) do
			local var_43_4 = arg_43_1[v_2]

			if var_43_4.run_progress == nil then
				var_43_4.run_progress = 0
			end
		end
	end
end

local function fn_21(self, arg_45_1, arg_45_2)
	-- function 45
	local type = arg_45_1.type
	local var_45_1 = self.config.AVAILABLE_CURSES[type][arg_45_2]

	arg_45_1.curse = var_45_1[self.random_generator(1, #var_45_1)]
	arg_45_1.god = arg_45_2
end

local function fn_22(self, arg_46_1, arg_46_2)
	-- function 46
	local var_46_0 = arg_46_1[arg_46_2]
	local var_46_1 = fn(table.clone(self.config.AVAILABLE_MINOR_MODIFIERS), self.random_generator)

	local function fn_2(arg_47_0)
		-- function 47
		for i, v in ipairs(self.config.MINOR_MODIFIER_VALIDATORS) do
			if not tbl_4[v](self, arg_46_1, arg_46_2, arg_47_0) then
				return false
			end
		end

		return true
	end

	for i, v in ipairs(var_46_1) do
		if not fn_2(v) then
			var_46_0.minor_modifier_group = v

			return
		end
	end
end

local function fn_23(arg_48_0, arg_48_1, arg_48_2, arg_48_3, arg_48_4, arg_48_5)
	-- function 48
	local tbl = {
		god = arg_48_2,
		center_key = arg_48_3,
		nodes = {}
	}
	local var_48_1 = arg_48_1[arg_48_3]

	fn_21(arg_48_0, var_48_1, arg_48_2)
	table.swap_delete(arg_48_5, table.index_of(arg_48_5, var_48_1))

	tbl.nodes[#tbl.nodes + 1] = var_48_1.name

	for i = #arg_48_5, 1, -1 do
		local var_48_2 = arg_48_5[i]
		local num = var_48_1.layout_x - var_48_2.layout_x
		local num_2 = var_48_1.layout_y - var_48_2.layout_y

		if arg_48_4 > num * num + num_2 * num_2 then
			fn_21(arg_48_0, var_48_2, arg_48_2)
			table.swap_delete(arg_48_5, i)

			tbl.nodes[#tbl.nodes + 1] = var_48_2.name
		end
	end

	arg_48_0.hot_spots[#arg_48_0.hot_spots + 1] = tbl

	return arg_48_5
end

local function fn_24(self, arg_49_1)
	-- function 49
	local random_generator = self.random_generator(self.config.CURSES_HOT_SPOTS_MIN_COUNT, self.config.CURSES_HOT_SPOTS_MAX_COUNT)
	local var_49_1 = fn_4(arg_49_1, self.config.CURSES_MIN_PROGRESS)
	local var_49_2 = fn_5(var_49_1, self.config.CURSEABLE_NODE_TYPES)

	if not self.config.NO_DOMINANT_GOD then
		local num = self.config.CURSES_HOT_SPOT_MAX_RANGE * self.config.CURSES_HOT_SPOT_MAX_RANGE

		var_49_2 = fn_23(self, arg_49_1, self.dominant_god, "final", num, var_49_2)
	end

	local tbl = {}
	local AVAILABLE_GODS = self.config.AVAILABLE_GODS

	for i = 2, random_generator do
		if #tbl == 0 then
			for i_2, v in ipairs(AVAILABLE_GODS) do
				if not (self.config.NO_DOMINANT_GOD or v == self.dominant_god) then
					tbl[#tbl + 1] = v
				end
			end
		end

		local random_generator_2 = self.random_generator(1, #tbl)
		local var_49_7 = tbl[random_generator_2]

		table.swap_delete(tbl, random_generator_2)

		if #var_49_2 > 0 then
			local var_49_8 = var_49_2[self.random_generator(1, #var_49_2)]
			local num_2 = self.config.CURSES_HOT_SPOT_MIN_RANGE + self.random_generator() * (self.config.CURSES_HOT_SPOT_MAX_RANGE - self.config.CURSES_HOT_SPOT_MAX_RANGE)

			var_49_2 = fn_23(self, arg_49_1, var_49_7, var_49_8.name, num_2 * num_2, var_49_2)
		end
	end
end

local function fn_25(self, arg_50_1)
	-- function 50
	local tbl = {}
	local ARENA_BELAKOR_SHOWS_UP_IN_DEPTH = self.config.ARENA_BELAKOR_SHOWS_UP_IN_DEPTH

	for k, v in pairs(arg_50_1) do
		if not (v.type == "START" or v.type == "SHOP" or v.type == "ARENA") then
			local var_50_2
			local var_50_3 = fn_9(arg_50_1, k, ARENA_BELAKOR_SHOWS_UP_IN_DEPTH)
			local tbl_2 = {}

			for i, v_2 in ipairs(var_50_3) do
				if arg_50_1[v_2].type == "SHOP" then
					local var_50_5 = fn_8(arg_50_1, v_2)

					for i_2, v_3 in ipairs(var_50_5) do
						tbl_2[#tbl_2 + 1] = v_3
					end
				else
					tbl_2[#tbl_2 + 1] = v_2
				end
			end

			for i_3, v_4 in ipairs(tbl_2) do
				local var_50_6 = arg_50_1[v_4]

				repeat
					if #var_50_6.next == 0 then
						var_50_6 = nil

						break
					end

					var_50_6 = arg_50_1[var_50_6.next[1]]
				until not (var_50_6.type == "SIGNATURE" or var_50_6.type ~= "TRAVEL")

				if not var_50_6 then
					var_50_2 = var_50_2 or {}
					var_50_2[v_4] = true
				end
			end

			if not var_50_2 then
				local tbl_3 = {}

				for k_2, v_5 in pairs(var_50_2) do
					tbl_3[#tbl_3 + 1] = k_2
				end

				v.possible_arena_belakor_nodes = tbl_3
				tbl[#tbl + 1] = k
			end
		end
	end

	local mirror_array_inplace = table.mirror_array_inplace(tbl)
	local var_50_9 = fn_8(arg_50_1, "start")
	local tbl_4 = {}

	for i10 = 1, #var_50_9 do
		local var_50_11 = var_50_9[i10]

		if not mirror_array_inplace[var_50_11] then
			local tbl_5 = {}
			local num = 1

			tbl_4[#tbl_4 + 1] = tbl_5
			tbl_5[num] = var_50_9[i10]

			local var_50_14 = fn_9(arg_50_1, var_50_11, 1)

			for i11 = 1, #var_50_14 do
				if not mirror_array_inplace[var_50_14[i11]] then
					num = num + 1
					tbl_5[num] = var_50_14[i11]
				end
			end
		end
	end

	local random_generator = self.random_generator
	local tbl_6 = {}

	for i12 = 1, #tbl_4 do
		local var_50_17 = tbl_4[i12]
		local count = #var_50_17

		if count > 0 then
			local var_50_19 = var_50_17[random_generator(1, count)]

			tbl_6[#tbl_6 + 1] = var_50_19

			for i13 = i12 + 1, #tbl_4 do
				local var_50_20 = tbl_4[i13]

				if not table.contains(var_50_20, var_50_19) then
					table.clear(var_50_20)
				else
					for i14 = 1, #var_50_17 do
						local find = table.find(var_50_20, var_50_17[i14])

						if not find then
							table.remove(var_50_20, find)
						end
					end
				end
			end
		end
	end

	for i15 = 1, #tbl_6 do
		local var_50_22 = tbl_6[i15]

		fn_21(self, arg_50_1[var_50_22], "belakor")
	end
end

local function fn_26(self, arg_51_1)
	-- function 51
	local var_51_0 = fn_4(arg_51_1, self.config.MINOR_MODIFIABLE_MIN_PROGRESS)
	local var_51_1 = fn_5(var_51_0, self.config.MINOR_MODIFIABLE_NODE_TYPES)

	for i, v in ipairs(var_51_1) do
		if not (self.random_generator() < self.config.MINOR_MODIFIABLE_NODE_CHANCE) then
			fn_22(self, arg_51_1, v.name)
		end
	end
end

local function fn_27(self, arg_52_1)
	-- function 52
	for k, v in pairs(arg_52_1) do
		if not (v.type == "SIGNATURE" or v.type == "TRAVEL" or v.type ~= "ARENA") then
			local var_52_0 = self.config.CONFLICT_DIRECTORS[v.god]

			var_52_0 = var_52_0 or self.config.CONFLICT_DIRECTORS.default
			v.conflict_settings = var_52_0[self.random_generator(1, #var_52_0)]
		end
	end
end

local function fn_28(self, arg_53_1, arg_53_2)
	-- function 53
	for k, v in pairs(arg_53_1) do
		if arg_53_2 == self[k].terror_event_power_up then
			return true
		end
	end

	return false
end

local function fn_29(self, arg_54_1, arg_54_2)
	-- function 54
	local next = self[arg_54_1].next

	if arg_54_2 > 1 then
		arg_54_2 = arg_54_2 - 1

		local tbl = {}

		for i, v in ipairs(next) do
			tbl[v] = self[v]

			local var_54_2 = fn_29(self, v, arg_54_2)

			for k, v_2 in pairs(var_54_2) do
				tbl[k] = v_2
			end
		end

		return tbl
	else
		local tbl_2 = {}

		for i_2, v_3 in ipairs(next) do
			tbl_2[v_3] = self[v_3]
		end

		return tbl_2
	end
end

local function fn_30(self, arg_55_1)
	-- function 55
	local random_generator = self.random_generator
	local var_55_1 = fn_2(arg_55_1, random_generator)

	for i, v in ipairs(var_55_1) do
		local var_55_2 = arg_55_1[v]

		if not (var_55_2.type == "SIGNATURE" or var_55_2.type ~= "TRAVEL") then
			local var_55_3 = fn_7(arg_55_1, v)

			for i_2, v_2 in ipairs(var_55_2.prev) do
				local var_55_4 = fn_29(arg_55_1, v_2, self.config.POWER_UP_LOOKAHEAD)

				for k, v_3 in pairs(var_55_4) do
					if not (v_3.type == "SIGNATURE" or v_3.type ~= "TRAVEL") then
						var_55_3[k] = v_3
					end
				end
			end

			local var_55_5 = fn(table.clone(self.config.TERROR_POWER_UPS), random_generator)

			for i_3, v_4 in ipairs(var_55_5) do
				local var_55_6 = v_4[1]
				local var_55_7 = v_4[2]

				if not fn_28(arg_55_1, var_55_3, var_55_6) then
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

local function fn_31(arg_56_0, arg_56_1, arg_56_2)
	-- function 56
	return arg_56_0 .. "_" .. arg_56_2 .. "_path" .. arg_56_1
end

function deus_generate_seeds(arg_57_0)
	-- function 57
	local create_random_generator = DeusGenUtils.create_random_generator(arg_57_0)
	local var_57_1, var_57_2 = create_random_generator()
	local var_57_3, var_57_4 = create_random_generator()
	local var_57_5, var_57_6 = create_random_generator()
	local var_57_7, var_57_8 = create_random_generator()
	local var_57_9, var_57_10 = create_random_generator()

	return {
		weapon_pickup_seed = var_57_2,
		pickups_seed = var_57_4,
		mutator_seed = var_57_6,
		blessings_seed = var_57_8,
		power_ups_seed = var_57_10
	}
end

function deus_populate_graph(arg_58_0, arg_58_1, arg_58_2, arg_58_3, arg_58_4)
	-- function 58
	local create_random_generator = DeusGenUtils.create_random_generator(arg_58_1)
	local clone = table.clone(arg_58_0)
	local tbl = {
		indent = 0,
		random_generator = create_random_generator,
		config = arg_58_2,
		dominant_god = arg_58_3,
		hot_spots = {}
	}
	local tbl_2 = {}
	local tbl_4 = {}

	for k, v in pairs(arg_58_2.LEVEL_AVAILABILITY) do
		tbl_4[#tbl_4 + 1] = k
	end

	table.sort(tbl_4)

	for k_2, v_2 in pairs(tbl_4) do
		local var_58_5 = arg_58_2.LEVEL_AVAILABILITY[v_2]

		tbl_2[v_2] = fn_2(var_58_5, create_random_generator)
	end

	for i, v_3 in ipairs(arg_58_2.LABEL_OVERRIDES) do
		tbl_2 = tbl_3[v_3](tbl, clone, tbl_2)
	end

	tbl.shuffled_levels_for_labels = tbl_2

	local function fn(arg_59_0, arg_59_1)
		-- function 59
		tbl.indent = #arg_59_0
	end

	local tbl_5 = {
		fn_16(tbl, clone, "start")
	}
	local get_generator = DeusGenEngine.get_generator(tbl_5, fn)
	local var_58_9
	local var_58_10
	local num = 100000

	for i6 = 1, num do
		var_58_10, var_58_9 = get_generator()

		if not var_58_10 then
			if not var_58_9 then
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

	fn_20(tbl, clone)
	fn_24(tbl, clone)

	if not arg_58_4 then
		fn_25(tbl, clone)
	end

	fn_26(tbl, clone)
	fn_27(tbl, clone)
	fn_30(tbl, clone)

	local tbl_6 = {}

	for k_3, v_4 in pairs(clone) do
		local var_58_13, var_58_14 = create_random_generator()
		local var_58_15 = deus_generate_seeds(var_58_14)
		local weapon_pickup_seed = var_58_15.weapon_pickup_seed
		local pickups_seed = var_58_15.pickups_seed
		local mutator_seed = var_58_15.mutator_seed
		local blessings_seed = var_58_15.blessings_seed
		local power_ups_seed = var_58_15.power_ups_seed
		local tbl_7 = {
			layout_x = v_4.layout_x,
			layout_y = v_4.layout_y,
			level_seed = var_58_14,
			weapon_pickup_seed = weapon_pickup_seed,
			system_seeds = {
				pickups = pickups_seed,
				mutator = mutator_seed,
				blessings = blessings_seed,
				power_ups = power_ups_seed
			}
		}
		local god = v_4.god

		god = god or "wastes"
		tbl_7.theme = god
		tbl_7.minor_modifier_group = v_4.minor_modifier_group
		tbl_7.run_progress = v_4.run_progress

		local conflict_settings = v_4.conflict_settings

		conflict_settings = conflict_settings or "disabled"
		tbl_7.conflict_settings = conflict_settings
		tbl_7.level_type = v_4.type
		tbl_7.mutators = arg_58_2.MUTATORS[v_4.type]
		tbl_7.terror_event_power_up = v_4.terror_event_power_up
		tbl_7.terror_event_power_up_rarity = v_4.terror_event_power_up_rarity
		tbl_7.possible_arena_belakor_nodes = v_4.possible_arena_belakor_nodes
		tbl_7.next = table.clone(v_4.next)

		if not (not script_data.deus_shoppify_run and v_4.type == "START" or v_4.type == "ARENA") then
			local keys = table.keys(DeusShopSettings.shop_types)

			v_4.level = keys[create_random_generator(1, #keys)]
			v_4.type = "SHOP"
		end

		if not (v_4.type == "SIGNATURE" or v_4.type == "TRAVEL" or v_4.type ~= "ARENA") then
			tbl_7.base_level = v_4.level
			tbl_7.path = v_4.path

			local themes = arg_58_2.LEVEL_AVAILABILITY[v_4.type][v_4.level].themes
			local contains = table.contains
			local var_58_27 = themes
			local god_2 = v_4.god

			god_2 = god_2 or "wastes"

			if not contains(var_58_27, god_2) then
				local var_58_29 = themes[1]
				local warning = Application.warning
				local format = string.format
				local str = "[deus_populate_graph.lua] theme %s not found for level %s, using %s"
				local god_3 = v_4.god

				god_3 = god_3 or "wastes"

				warning(format(str, god_3, v_4.level, var_58_29))

				tbl_7.level = fn_31(v_4.level, v_4.path, var_58_29)
			else
				local var_58_34 = fn_31
				local level = v_4.level
				local path = v_4.path
				local god_4 = v_4.god

				god_4 = god_4 or "wastes"
				tbl_7.level = var_58_34(level, path, god_4)
			end

			local var_58_38 = arg_58_2.LEVEL_ALIAS[tbl_7.level]

			if not arg_58_2.LEVEL_ALIAS[tbl_7.level] then
				tbl_7.level = var_58_38
			end

			tbl_7.curse = v_4.curse
			tbl_7.node_type = "ingame"
		elseif v_4.type == "SHOP" then
			tbl_7.base_level = v_4.level
			tbl_7.level = v_4.level
			tbl_7.path = 0
			tbl_7.node_type = "shop"
		elseif v_4.type == "START" then
			tbl_7.level = "dlc_morris_map"
			tbl_7.path = 0
			tbl_7.base_level = "dlc_morris_map"
			tbl_7.node_type = "start"
		end

		printf("Generated node with: Level <%s>, level_seed <%s>, Run progress <%s>", tbl_7.level, var_58_14, tbl_7.run_progress)

		tbl_6[k_3] = tbl_7
	end

	return tbl_6
end
