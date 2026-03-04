-- chunkname: @scripts/utils/ik_chain.lua

IkChain = class(IkChain)

local function var_0_0(arg_1_0, arg_1_1, arg_1_2)
	for iter_1_0 = 1, arg_1_2 do
		arg_1_1[iter_1_0] = arg_1_0[iter_1_0]:unbox()
	end

	return arg_1_1
end

local function var_0_1(arg_2_0, arg_2_1, arg_2_2)
	for iter_2_0 = 1, arg_2_2 do
		arg_2_1[iter_2_0]:store(arg_2_0[iter_2_0])
	end
end

IkChain.init = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5)
	arg_3_0._nodes = {}

	local var_3_0 = {}
	local var_3_1 = 0
	local var_3_2 = {}

	for iter_3_0 = 1, #arg_3_1 - 1 do
		local var_3_3 = Vector3.length(arg_3_1[iter_3_0] - arg_3_1[iter_3_0 + 1])

		var_3_0[iter_3_0] = var_3_3
		var_3_1 = var_3_1 + var_3_3
	end

	for iter_3_1 = 1, #arg_3_1 do
		var_3_2[iter_3_1] = Vector3Box(arg_3_1[iter_3_1])
	end

	arg_3_0.n = #arg_3_1
	arg_3_0.tolerance = arg_3_4 or 0.1
	arg_3_0.target_pos = Vector3Box(arg_3_3)
	arg_3_0.aim_pos = Vector3Box(arg_3_1[arg_3_0.n])
	arg_3_0.joints = var_3_2
	arg_3_0.lengths = var_3_0
	arg_3_0.origin_pos = Vector3Box(arg_3_1[1])
	arg_3_0.totallength = var_3_1

	if arg_3_5 then
		arg_3_0.constrain_angle = arg_3_5
		arg_3_0.dot_constrain = math.cos(arg_3_5)
	end
end

IkChain.set_origin_pos = function (arg_4_0, arg_4_1)
	arg_4_0.origin_pos:store(arg_4_1)
end

IkChain.set_target_pos = function (arg_5_0, arg_5_1, arg_5_2)
	arg_5_0.target_pos:store(arg_5_1)

	arg_5_0.acc = arg_5_2 or 1
end

IkChain.set_whip = function (arg_6_0, arg_6_1)
	arg_6_0.whip_angle_velocity = arg_6_1
end

IkChain.update_whip = function (arg_7_0, arg_7_1, arg_7_2, arg_7_3, arg_7_4)
	local var_7_0 = 1
	local var_7_1 = 2
	local var_7_2 = Quaternion.axis_angle(Vector3.up(), arg_7_3 % 6.28)
	local var_7_3 = arg_7_1[var_7_0]
	local var_7_4 = arg_7_1[var_7_1] - var_7_3

	arg_7_1[var_7_1] = var_7_3 + Quaternion.rotate(var_7_2, var_7_4)

	QuickDrawer:line(arg_7_1[var_7_0], arg_7_1[var_7_1], Color(20, 255, 175))
end

IkChain.debug_draw = function (arg_8_0, arg_8_1, arg_8_2)
	local var_8_0 = arg_8_0.constrain_angle and Color(120, 0, 120) or Color(120, 255, 0)
	local var_8_1 = Color(0, 155, 255)

	for iter_8_0 = 1, arg_8_2 - 1 do
		QuickDrawer:line(arg_8_1[iter_8_0], arg_8_1[iter_8_0 + 1], var_8_0)
		QuickDrawer:sphere(arg_8_1[iter_8_0], 0.05 + iter_8_0 * 0.01, var_8_1)
	end

	QuickDrawer:sphere(arg_8_1[arg_8_2], 0.05, var_8_1)
	QuickDrawer:sphere(arg_8_0.target_pos:unbox(), 0.1, Color(255, 45, 0))
	QuickDrawer:sphere(arg_8_0.aim_pos:unbox(), 0.095, Color(255, 0, 200))
end

IkChain.backward = function (arg_9_0, arg_9_1, arg_9_2, arg_9_3, arg_9_4)
	arg_9_1[arg_9_3] = arg_9_4

	for iter_9_0 = arg_9_3 - 1, 1, -1 do
		local var_9_0 = arg_9_1[iter_9_0 + 1] - arg_9_1[iter_9_0]
		local var_9_1 = arg_9_2[iter_9_0] / Vector3.length(var_9_0)

		arg_9_1[iter_9_0] = (1 - var_9_1) * arg_9_1[iter_9_0 + 1] + var_9_1 * arg_9_1[iter_9_0]
	end
end

IkChain.forward = function (arg_10_0, arg_10_1, arg_10_2, arg_10_3, arg_10_4)
	arg_10_1[1] = arg_10_4

	for iter_10_0 = 1, arg_10_3 - 1 do
		local var_10_0 = arg_10_1[iter_10_0 + 1] - arg_10_1[iter_10_0]
		local var_10_1 = arg_10_2[iter_10_0] / Vector3.length(var_10_0)
		local var_10_2 = (1 - var_10_1) * arg_10_1[iter_10_0] + var_10_1 * arg_10_1[iter_10_0 + 1]

		arg_10_1[iter_10_0 + 1] = var_10_2
	end
end

local var_0_2 = 0.7
local var_0_3 = math.acos(var_0_2)

IkChain.forward_constrained = function (arg_11_0, arg_11_1, arg_11_2, arg_11_3, arg_11_4)
	local var_11_0 = arg_11_0.dot_constrain
	local var_11_1 = arg_11_0.constrain_angle
	local var_11_2 = Vector3.up()

	arg_11_1[1] = arg_11_4

	local var_11_3 = Vector3.normalize(arg_11_1[2] - arg_11_4)

	for iter_11_0 = 1, arg_11_3 - 1 do
		local var_11_4 = arg_11_1[iter_11_0 + 1] - arg_11_1[iter_11_0]
		local var_11_5 = arg_11_2[iter_11_0] / Vector3.length(var_11_4)
		local var_11_6 = (1 - var_11_5) * arg_11_1[iter_11_0] + var_11_5 * arg_11_1[iter_11_0 + 1]
		local var_11_7 = Vector3.normalize(var_11_6 - arg_11_1[iter_11_0])

		if var_11_0 < Vector3.dot(var_11_3, var_11_7) then
			arg_11_1[iter_11_0 + 1] = var_11_6
		else
			local var_11_8 = Vector3.cross(var_11_3, var_11_7)
			local var_11_9 = Quaternion(var_11_8, var_11_1)
			local var_11_10 = Quaternion.rotate(var_11_9, var_11_3)

			arg_11_1[iter_11_0 + 1] = arg_11_1[iter_11_0] + var_11_10 * arg_11_2[iter_11_0]
		end

		var_11_3 = Vector3.normalize(arg_11_1[iter_11_0 + 1] - arg_11_1[iter_11_0])
	end
end

local var_0_4 = {}

IkChain.solve = function (arg_12_0, arg_12_1, arg_12_2)
	local var_12_0 = arg_12_0.target_pos:unbox()
	local var_12_1 = arg_12_0.aim_pos:unbox()
	local var_12_2 = var_12_1 + (var_12_0 - var_12_1) * (arg_12_0.acc or 1) * arg_12_2

	arg_12_0.aim_pos:store(var_12_2)

	local var_12_3 = arg_12_0.origin_pos:unbox()
	local var_12_4 = arg_12_0.n
	local var_12_5 = var_0_0(arg_12_0.joints, var_0_4, var_12_4)

	if arg_12_0.whip_angle_velocity then
		arg_12_0:update_whip(var_12_5, arg_12_0.whip_angle_velocity, arg_12_1, arg_12_2)
	end

	local var_12_6 = arg_12_0.lengths
	local var_12_7 = 0

	if Vector3.length(var_12_5[1] - var_12_2) > arg_12_0.totallength then
		for iter_12_0 = 1, var_12_4 - 1 do
			local var_12_8 = Vector3.length(var_12_2 - var_12_5[iter_12_0])
			local var_12_9 = var_12_6[iter_12_0] / var_12_8

			var_12_5[iter_12_0 + 1] = (1 - var_12_9) * var_12_5[iter_12_0] + var_12_9 * var_12_2
		end
	else
		local var_12_10 = Vector3.length(var_12_5[var_12_4] - var_12_2)

		while var_12_10 > arg_12_0.tolerance do
			arg_12_0:backward(var_12_5, var_12_6, var_12_4, var_12_2)

			if arg_12_0.constrain_angle then
				arg_12_0:forward_constrained(var_12_5, var_12_6, var_12_4, var_12_3)
			else
				arg_12_0:forward(var_12_5, var_12_6, var_12_4, var_12_3)
			end

			var_12_10 = Vector3.length(var_12_5[var_12_4] - var_12_2)
			var_12_7 = var_12_7 + 1

			if var_12_7 > 10 then
				break
			end
		end
	end

	var_0_1(var_12_5, arg_12_0.joints, var_12_4)
	arg_12_0:debug_draw(var_12_5, var_12_4)
	Debug.text("Solving tentacle: %d iterations, %d joints", var_12_7, arg_12_0.n)
end

IkChain.solve_dragging = function (arg_13_0, arg_13_1, arg_13_2)
	local var_13_0 = arg_13_0.target_pos:unbox()
	local var_13_1 = arg_13_0.aim_pos:unbox()
	local var_13_2 = var_13_1 + (var_13_0 - var_13_1) * (arg_13_0.acc or 1) * arg_13_2

	arg_13_0.aim_pos:store(var_13_2)

	local var_13_3 = arg_13_0.origin_pos:unbox()
	local var_13_4 = arg_13_0.n
	local var_13_5 = var_0_0(arg_13_0.joints, var_0_4, var_13_4)
	local var_13_6 = arg_13_0.lengths
	local var_13_7 = 0

	if Vector3.length(var_13_5[1] - var_13_2) > arg_13_0.totallength then
		for iter_13_0 = 1, var_13_4 - 1 do
			local var_13_8 = Vector3.length(var_13_2 - var_13_5[iter_13_0])
			local var_13_9 = var_13_6[iter_13_0] / var_13_8

			var_13_5[iter_13_0 + 1] = (1 - var_13_9) * var_13_5[iter_13_0] + var_13_9 * var_13_2
		end
	else
		arg_13_0:backward(var_13_5, var_13_6, var_13_4, var_13_2)
	end

	var_0_1(var_13_5, arg_13_0.joints, var_13_4)
	arg_13_0:debug_draw(var_13_5, var_13_4)
	Debug.text("Solving tentacle dragging: %d iterations, %d joints", var_13_7, arg_13_0.n)
end
