-- chunkname: @scripts/managers/game_mode/mechanisms/deus_layout_base_graph.lua

require("scripts/settings/dlcs/morris/deus_default_graph_settings")
require("scripts/settings/dlcs/morris/deus_map_layout_settings")

local function var_0_0(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
	arg_1_1.acc_x = math.clamp(-arg_1_0.FORCE_MAX, arg_1_1.acc_x + arg_1_2, arg_1_0.FORCE_MAX)
	arg_1_1.acc_y = math.clamp(-arg_1_0.FORCE_MAX, arg_1_1.acc_y + arg_1_3, arg_1_0.FORCE_MAX)
end

local function var_0_1(arg_2_0, arg_2_1, arg_2_2)
	local var_2_0 = arg_2_2.pos_x - arg_2_1.pos_x
	local var_2_1 = arg_2_2.pos_y - arg_2_1.pos_y

	if var_2_0 ~= 0 or var_2_1 ~= 0 then
		local var_2_2 = math.sqrt(var_2_0 * var_2_0 + var_2_1 * var_2_1)
		local var_2_3 = var_2_0 / var_2_2
		local var_2_4 = var_2_1 / var_2_2
		local var_2_5 = -1 * arg_2_0.SPRING_CONSTANT * var_2_2 * 0.5

		var_0_0(arg_2_0, arg_2_2, var_2_5 * var_2_3, var_2_5 * var_2_4)
	end
end

local function var_0_2(arg_3_0, arg_3_1, arg_3_2)
	local var_3_0 = arg_3_2.pos_x - arg_3_1.pos_x
	local var_3_1 = arg_3_2.pos_y - arg_3_1.pos_y

	if var_3_0 ~= 0 or var_3_1 ~= 0 then
		local var_3_2 = math.sqrt(var_3_0 * var_3_0 + var_3_1 * var_3_1)
		local var_3_3 = var_3_0 / var_3_2
		local var_3_4 = var_3_1 / var_3_2
		local var_3_5 = arg_3_0.REPEL_CONSTANT * (arg_3_1.mass * arg_3_2.mass / (var_3_2 * var_3_2))

		var_0_0(arg_3_0, arg_3_2, var_3_5 * var_3_3, var_3_5 * var_3_4)
	end
end

local function var_0_3(arg_4_0, arg_4_1)
	arg_4_1.vel_x = (arg_4_1.vel_x + arg_4_1.acc_x * arg_4_0.DELTA * arg_4_0.NODE_SPEED) * arg_4_0.DAMPING_FACTOR
	arg_4_1.vel_y = (arg_4_1.vel_y + arg_4_1.acc_y * arg_4_0.DELTA * arg_4_0.NODE_SPEED) * arg_4_0.DAMPING_FACTOR
	arg_4_1.pos_x = arg_4_1.pos_x + arg_4_1.vel_x
	arg_4_1.pos_y = arg_4_1.pos_y + arg_4_1.vel_y
	arg_4_1.acc_x = 0
	arg_4_1.acc_y = 0
end

local function var_0_4(arg_5_0, arg_5_1, arg_5_2)
	for iter_5_0, iter_5_1 in ipairs(arg_5_2) do
		var_0_1(arg_5_0, arg_5_1[iter_5_1.from], arg_5_1[iter_5_1.to])
		var_0_1(arg_5_0, arg_5_1[iter_5_1.to], arg_5_1[iter_5_1.from])
	end

	for iter_5_2, iter_5_3 in pairs(arg_5_1) do
		if not iter_5_3.anchor then
			for iter_5_4, iter_5_5 in pairs(arg_5_1) do
				if iter_5_3 ~= iter_5_5 then
					var_0_2(arg_5_0, iter_5_3, iter_5_5)
				end
			end
		end
	end

	for iter_5_6, iter_5_7 in pairs(arg_5_1) do
		if not iter_5_7.anchor then
			var_0_3(arg_5_0, iter_5_7)
		end
	end
end

local function var_0_5(arg_6_0)
	local var_6_0 = {}
	local var_6_1 = 0

	for iter_6_0, iter_6_1 in pairs(arg_6_0) do
		local var_6_2 = var_6_0[iter_6_1.layout_x]

		var_6_0[iter_6_1.layout_x] = var_6_2 and math.max(var_6_2, iter_6_1.layout_y) or iter_6_1.layout_y
		var_6_1 = math.max(var_6_1, iter_6_1.layout_x)
	end

	local var_6_3 = {}

	for iter_6_2, iter_6_3 in pairs(arg_6_0) do
		iter_6_3 = table.clone(iter_6_3)
		var_6_3[iter_6_2] = iter_6_3

		local var_6_4 = iter_6_3.layout_x

		iter_6_3.layout_x = var_6_4 / var_6_1
		iter_6_3.layout_y = iter_6_3.layout_y / (var_6_0[var_6_4] + 1)
	end

	return var_6_3
end

local function var_0_6(arg_7_0, arg_7_1)
	arg_7_1 = var_0_5(arg_7_1)

	local var_7_0 = {}
	local var_7_1 = {}
	local var_7_2 = math.huge
	local var_7_3 = -math.huge

	for iter_7_0, iter_7_1 in pairs(arg_7_1) do
		local var_7_4 = arg_7_0.WIDTH * iter_7_1.layout_x
		local var_7_5 = arg_7_0.HEIGHT * iter_7_1.layout_y
		local var_7_6
		local var_7_7

		var_7_2 = math.min(var_7_4, var_7_2)
		var_7_3 = math.max(var_7_4, var_7_3)

		if iter_7_0 == "start" then
			var_7_6 = false
			var_7_7 = arg_7_0.DEFAULT_MASS
		elseif #iter_7_1.next == 0 then
			var_7_6 = false
			var_7_7 = arg_7_0.DEFAULT_MASS
		else
			var_7_6 = false
			var_7_7 = arg_7_0.DEFAULT_MASS
		end

		var_7_0[iter_7_0] = {
			acc_y = 0,
			acc_x = 0,
			vel_x = 0,
			vel_y = 0,
			pos_x = var_7_4,
			pos_y = var_7_5,
			anchor = var_7_6,
			mass = var_7_7
		}

		for iter_7_2, iter_7_3 in ipairs(iter_7_1.next) do
			var_7_1[#var_7_1 + 1] = {
				from = iter_7_0,
				to = iter_7_3
			}
		end
	end

	var_7_0.start_anchor = {
		acc_y = 0,
		acc_x = 0,
		vel_x = 0,
		anchor = true,
		vel_y = 0,
		pos_y = 0,
		pos_x = var_7_2 - arg_7_0.WIDTH,
		mass = arg_7_0.START_MASS
	}
	var_7_1[#var_7_1 + 1] = {
		from = "start_anchor",
		to = "start"
	}
	var_7_0.final_anchor = {
		acc_y = 0,
		acc_x = 0,
		vel_x = 0,
		anchor = true,
		vel_y = 0,
		pos_y = 0,
		pos_x = var_7_3 + arg_7_0.WIDTH,
		mass = arg_7_0.END_MASS
	}
	var_7_1[#var_7_1 + 1] = {
		from = "final",
		to = "final_anchor"
	}

	return var_7_0, var_7_1
end

local function var_0_7(arg_8_0, arg_8_1, arg_8_2)
	local var_8_0 = math.huge
	local var_8_1 = -math.huge
	local var_8_2 = math.huge
	local var_8_3 = -math.huge

	for iter_8_0, iter_8_1 in pairs(arg_8_1) do
		if arg_8_2[iter_8_0] then
			var_8_0 = math.min(var_8_0, iter_8_1.pos_x)
			var_8_2 = math.min(var_8_2, iter_8_1.pos_y)
			var_8_1 = math.max(var_8_1, iter_8_1.pos_x)
			var_8_3 = math.max(var_8_3, iter_8_1.pos_y)
		end
	end

	local var_8_4 = var_8_1 - var_8_0
	local var_8_5 = var_8_3 - var_8_2

	for iter_8_2, iter_8_3 in pairs(arg_8_1) do
		if arg_8_2[iter_8_2] then
			arg_8_2[iter_8_2].layout_x = var_8_4 ~= 0 and (iter_8_3.pos_x - var_8_0) / var_8_4 or 0
			arg_8_2[iter_8_2].layout_y = var_8_5 ~= 0 and (iter_8_3.pos_y - var_8_2) / var_8_5 or 0
		end
	end
end

function deus_layout_normalize(arg_9_0)
	return var_0_5(arg_9_0)
end

function deus_layout_base_graph(arg_10_0, arg_10_1)
	local var_10_0, var_10_1 = var_0_6(arg_10_1, arg_10_0)

	for iter_10_0 = 1, arg_10_1.LAYOUT_TICKS do
		var_0_4(arg_10_1, var_10_0, var_10_1)
	end

	var_0_7(arg_10_1, var_10_0, arg_10_0)

	return arg_10_0
end

function debug_deus_create_realtime_layout_updater(arg_11_0, arg_11_1)
	local var_11_0, var_11_1 = var_0_6(arg_11_1, arg_11_0)
	local var_11_2 = arg_11_1.LAYOUT_TICKS

	return function()
		if var_11_2 > 0 then
			var_0_4(arg_11_1, var_11_0, var_11_1)
			var_0_7(arg_11_1, var_11_0, arg_11_0)

			var_11_2 = var_11_2 - 1

			return false, arg_11_0
		end

		return true, arg_11_0
	end
end
