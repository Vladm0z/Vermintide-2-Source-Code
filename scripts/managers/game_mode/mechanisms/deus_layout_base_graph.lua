-- chunkname: @scripts/managers/game_mode/mechanisms/deus_layout_base_graph.lua

require("scripts/settings/dlcs/morris/deus_default_graph_settings")
require("scripts/settings/dlcs/morris/deus_map_layout_settings")

local function fn(self, arg_1_1, arg_1_2, arg_1_3)
	-- function 1
	arg_1_1.acc_x = math.clamp(-self.FORCE_MAX, arg_1_1.acc_x + arg_1_2, self.FORCE_MAX)
	arg_1_1.acc_y = math.clamp(-self.FORCE_MAX, arg_1_1.acc_y + arg_1_3, self.FORCE_MAX)
end

local function fn_2(self, arg_2_1, arg_2_2)
	-- function 2
	local num = arg_2_2.pos_x - arg_2_1.pos_x
	local num_2 = arg_2_2.pos_y - arg_2_1.pos_y

	if not (num ~= 0 or num_2 == 0) then
		local sqrt = math.sqrt(num * num + num_2 * num_2)
		local num_3 = num / sqrt
		local num_4 = num_2 / sqrt
		local num_5 = -1 * self.SPRING_CONSTANT * sqrt * 0.5

		fn(self, arg_2_2, num_5 * num_3, num_5 * num_4)
	end
end

local function fn_3(self, arg_3_1, arg_3_2)
	-- function 3
	local num = arg_3_2.pos_x - arg_3_1.pos_x
	local num_2 = arg_3_2.pos_y - arg_3_1.pos_y

	if not (num ~= 0 or num_2 == 0) then
		local sqrt = math.sqrt(num * num + num_2 * num_2)
		local num_3 = num / sqrt
		local num_4 = num_2 / sqrt
		local num_5 = self.REPEL_CONSTANT * (arg_3_1.mass * arg_3_2.mass / (sqrt * sqrt))

		fn(self, arg_3_2, num_5 * num_3, num_5 * num_4)
	end
end

local function fn_4(self, arg_4_1)
	-- function 4
	arg_4_1.vel_x = (arg_4_1.vel_x + arg_4_1.acc_x * self.DELTA * self.NODE_SPEED) * self.DAMPING_FACTOR
	arg_4_1.vel_y = (arg_4_1.vel_y + arg_4_1.acc_y * self.DELTA * self.NODE_SPEED) * self.DAMPING_FACTOR
	arg_4_1.pos_x = arg_4_1.pos_x + arg_4_1.vel_x
	arg_4_1.pos_y = arg_4_1.pos_y + arg_4_1.vel_y
	arg_4_1.acc_x = 0
	arg_4_1.acc_y = 0
end

local function fn_5(arg_5_0, arg_5_1, arg_5_2)
	-- function 5
	for i, v in ipairs(arg_5_2) do
		fn_2(arg_5_0, arg_5_1[v.from], arg_5_1[v.to])
		fn_2(arg_5_0, arg_5_1[v.to], arg_5_1[v.from])
	end

	for k, v_2 in pairs(arg_5_1) do
		if not v_2.anchor then
			for k_2, v_3 in pairs(arg_5_1) do
				if v_2 ~= v_3 then
					fn_3(arg_5_0, v_2, v_3)
				end
			end
		end
	end

	for k_3, v_4 in pairs(arg_5_1) do
		if not v_4.anchor then
			fn_4(arg_5_0, v_4)
		end
	end
end

local function fn_6(arg_6_0)
	-- function 6
	local tbl = {}
	local num = 0

	for k, v in pairs(arg_6_0) do
		local var_6_2 = tbl[v.layout_x]
		local layout_x = v.layout_x
		local max

		if not var_6_2 then
			max = math.max(var_6_2, v.layout_y)

			if not max then
				-- Nothing
			end
		end

		max = v.layout_y

		::label_6_0::

		tbl[layout_x] = max
		num = math.max(num, v.layout_x)
	end

	local tbl_2 = {}

	for k_2, v_2 in pairs(arg_6_0) do
		v_2 = table.clone(v_2)
		tbl_2[k_2] = v_2

		local layout_x_2 = v_2.layout_x

		v_2.layout_x = layout_x_2 / num
		v_2.layout_y = v_2.layout_y / (tbl[layout_x_2] + 1)
	end

	return tbl_2
end

local function fn_7(self, arg_7_1)
	-- function 7
	arg_7_1 = fn_6(arg_7_1)

	local tbl = {}
	local tbl_2 = {}
	local huge = math.huge
	local num = -math.huge

	for k, v in pairs(arg_7_1) do
		local num_2 = self.WIDTH * v.layout_x
		local num_3 = self.HEIGHT * v.layout_y
		local var_7_6
		local var_7_7

		huge = math.min(num_2, huge)
		num = math.max(num_2, num)

		if k == "start" then
			var_7_6 = false
			var_7_7 = self.DEFAULT_MASS
		elseif #v.next == 0 then
			var_7_6 = false
			var_7_7 = self.DEFAULT_MASS
		else
			var_7_6 = false
			var_7_7 = self.DEFAULT_MASS
		end

		tbl[k] = {
			acc_y = 0,
			acc_x = 0,
			vel_x = 0,
			vel_y = 0,
			pos_x = num_2,
			pos_y = num_3,
			anchor = var_7_6,
			mass = var_7_7
		}

		for i, v_2 in ipairs(v.next) do
			tbl_2[#tbl_2 + 1] = {
				from = k,
				to = v_2
			}
		end
	end

	tbl.start_anchor = {
		acc_y = 0,
		acc_x = 0,
		vel_x = 0,
		anchor = true,
		vel_y = 0,
		pos_y = 0,
		pos_x = huge - self.WIDTH,
		mass = self.START_MASS
	}
	tbl_2[#tbl_2 + 1] = {
		from = "start_anchor",
		to = "start"
	}
	tbl.final_anchor = {
		acc_y = 0,
		acc_x = 0,
		vel_x = 0,
		anchor = true,
		vel_y = 0,
		pos_y = 0,
		pos_x = num + self.WIDTH,
		mass = self.END_MASS
	}
	tbl_2[#tbl_2 + 1] = {
		from = "final",
		to = "final_anchor"
	}

	return tbl, tbl_2
end

local function fn_8(arg_8_0, arg_8_1, arg_8_2)
	-- function 8
	local huge = math.huge
	local num = -math.huge
	local huge_2 = math.huge
	local num_2 = -math.huge

	for k, v in pairs(arg_8_1) do
		if not arg_8_2[k] then
			huge = math.min(huge, v.pos_x)
			huge_2 = math.min(huge_2, v.pos_y)
			num = math.max(num, v.pos_x)
			num_2 = math.max(num_2, v.pos_y)
		end
	end

	local num_3 = num - huge
	local num_4 = num_2 - huge_2

	for k_2, v_2 in pairs(arg_8_1) do
		if not arg_8_2[k_2] then
			local var_8_6 = arg_8_2[k_2]
			local num_5

			if num_3 ~= 0 then
				num_5 = (v_2.pos_x - huge) / num_3

				if not num_5 then
					-- Nothing
				end
			end

			num_5 = 0

			::label_8_0::

			var_8_6.layout_x = num_5

			local var_8_8 = arg_8_2[k_2]
			local num_6

			if num_4 ~= 0 then
				num_6 = (v_2.pos_y - huge_2) / num_4

				if not num_6 then
					-- Nothing
				end
			end

			num_6 = 0

			::label_8_1::

			var_8_8.layout_y = num_6
		end
	end
end

function deus_layout_normalize(arg_9_0)
	-- function 9
	return fn_6(arg_9_0)
end

function deus_layout_base_graph(arg_10_0, arg_10_1)
	-- function 10
	local var_10_0, var_10_1 = fn_7(arg_10_1, arg_10_0)

	for i = 1, arg_10_1.LAYOUT_TICKS do
		fn_5(arg_10_1, var_10_0, var_10_1)
	end

	fn_8(arg_10_1, var_10_0, arg_10_0)

	return arg_10_0
end

function debug_deus_create_realtime_layout_updater(arg_11_0, arg_11_1)
	-- function 11
	local var_11_0, var_11_1 = fn_7(arg_11_1, arg_11_0)
	local LAYOUT_TICKS = arg_11_1.LAYOUT_TICKS

	return function ()
		-- function 12
		if LAYOUT_TICKS > 0 then
			fn_5(arg_11_1, var_11_0, var_11_1)
			fn_8(arg_11_1, var_11_0, arg_11_0)

			LAYOUT_TICKS = LAYOUT_TICKS - 1

			return false, arg_11_0
		end

		return true, arg_11_0
	end
end
