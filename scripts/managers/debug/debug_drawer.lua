-- chunkname: @scripts/managers/debug/debug_drawer.lua

DebugDrawer = class(DebugDrawer)

DebugDrawer.init = function (arg_1_0, arg_1_1, arg_1_2)
	arg_1_0._line_object = arg_1_1
	arg_1_0._mode = arg_1_2
end

DebugDrawer.reset = function (arg_2_0)
	LineObject.reset(arg_2_0._line_object)
end

DebugDrawer.line_object = function (arg_3_0)
	return arg_3_0._line_object
end

DebugDrawer.line = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3)
	arg_4_3 = arg_4_3 or Color(255, 255, 255)

	LineObject.add_line(arg_4_0._line_object, arg_4_3, arg_4_1, arg_4_2)
end

DebugDrawer.sphere = function (arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4, arg_5_5)
	arg_5_3 = arg_5_3 or Color(255, 255, 255)

	LineObject.add_sphere(arg_5_0._line_object, arg_5_3, arg_5_1, arg_5_2, arg_5_4 or 20, arg_5_5 or 2)
end

DebugDrawer.capsule_overlap = function (arg_6_0, arg_6_1, arg_6_2, arg_6_3, arg_6_4)
	fassert(arg_6_2.x == arg_6_2.z, "Passing diffent x and y size doesn't do anything, capsules overlaps are always sphere swept, not spheroid shaped.")

	local var_6_0 = (arg_6_2.x + arg_6_2.z) * 0.5
	local var_6_1 = Quaternion.forward(arg_6_3) * (arg_6_2.y - var_6_0)
	local var_6_2 = arg_6_1 - var_6_1
	local var_6_3 = arg_6_1 + var_6_1

	arg_6_0:capsule(var_6_2, var_6_3, var_6_0, arg_6_4)
end

DebugDrawer.oobb_overlap = function (arg_7_0, arg_7_1, arg_7_2, arg_7_3, arg_7_4)
	local var_7_0 = Matrix4x4.from_quaternion_position(arg_7_3, arg_7_1)

	arg_7_0:box(var_7_0, arg_7_2, arg_7_4)
end

DebugDrawer.box_sweep = function (arg_8_0, arg_8_1, arg_8_2, arg_8_3, arg_8_4, arg_8_5)
	arg_8_4 = arg_8_4 or Color(255, 255, 255)
	arg_8_5 = arg_8_5 or Color(255, 0, 0)

	local var_8_0 = Matrix4x4.rotation(arg_8_1)
	local var_8_1 = Matrix4x4.translation(arg_8_1)
	local var_8_2 = Matrix4x4.from_quaternion_position(var_8_0, var_8_1 + arg_8_3)

	arg_8_0:box(arg_8_1, arg_8_2, arg_8_4)
	arg_8_0:box(var_8_2, arg_8_2, arg_8_4)

	local var_8_3 = Matrix4x4.right(arg_8_1)
	local var_8_4 = Matrix4x4.forward(arg_8_1)
	local var_8_5 = Matrix4x4.up(arg_8_1)
	local var_8_6 = var_8_3 * arg_8_2.x
	local var_8_7 = -var_8_3 * arg_8_2.x
	local var_8_8 = var_8_4 * arg_8_2.y
	local var_8_9 = -var_8_4 * arg_8_2.y
	local var_8_10 = var_8_5 * arg_8_2.z
	local var_8_11 = -var_8_5 * arg_8_2.z
	local var_8_12 = var_8_1 + var_8_6 + var_8_8 + var_8_10
	local var_8_13 = var_8_1 + var_8_7 + var_8_8 + var_8_10
	local var_8_14 = var_8_1 + var_8_7 + var_8_9 + var_8_10
	local var_8_15 = var_8_1 + var_8_6 + var_8_9 + var_8_10
	local var_8_16 = var_8_1 + var_8_6 + var_8_8 + var_8_11
	local var_8_17 = var_8_1 + var_8_7 + var_8_8 + var_8_11
	local var_8_18 = var_8_1 + var_8_7 + var_8_9 + var_8_11
	local var_8_19 = var_8_1 + var_8_6 + var_8_9 + var_8_11

	arg_8_0:line(var_8_12, var_8_12 + arg_8_3, arg_8_5)
	arg_8_0:line(var_8_13, var_8_13 + arg_8_3, arg_8_5)
	arg_8_0:line(var_8_14, var_8_14 + arg_8_3, arg_8_5)
	arg_8_0:line(var_8_15, var_8_15 + arg_8_3, arg_8_5)
	arg_8_0:line(var_8_16, var_8_16 + arg_8_3, arg_8_5)
	arg_8_0:line(var_8_17, var_8_17 + arg_8_3, arg_8_5)
	arg_8_0:line(var_8_18, var_8_18 + arg_8_3, arg_8_5)
	arg_8_0:line(var_8_19, var_8_19 + arg_8_3, arg_8_5)
end

DebugDrawer.capsule = function (arg_9_0, arg_9_1, arg_9_2, arg_9_3, arg_9_4)
	arg_9_4 = arg_9_4 or Color(255, 255, 255)

	LineObject.add_capsule(arg_9_0._line_object, arg_9_4, arg_9_1, arg_9_2, arg_9_3)
end

DebugDrawer.actor = function (arg_10_0, arg_10_1, arg_10_2, arg_10_3)
	arg_10_2 = arg_10_2 or Color(255, 255, 255)

	Actor.debug_draw(arg_10_1, arg_10_0._line_object, arg_10_2, arg_10_3)
end

DebugDrawer.box = function (arg_11_0, arg_11_1, arg_11_2, arg_11_3)
	arg_11_3 = arg_11_3 or Color(255, 255, 255)

	LineObject.add_box(arg_11_0._line_object, arg_11_3, arg_11_1, arg_11_2)
end

DebugDrawer.cone = function (arg_12_0, arg_12_1, arg_12_2, arg_12_3, arg_12_4, arg_12_5, arg_12_6)
	arg_12_4 = arg_12_4 or Color(255, 255, 255)

	LineObject.add_cone(arg_12_0._line_object, arg_12_4, arg_12_1, arg_12_2, arg_12_3, arg_12_5, arg_12_6)
end

DebugDrawer.circle = function (arg_13_0, arg_13_1, arg_13_2, arg_13_3, arg_13_4, arg_13_5)
	arg_13_4 = arg_13_4 or Color(255, 255, 255)

	LineObject.add_circle(arg_13_0._line_object, arg_13_4, arg_13_1, arg_13_2, arg_13_3, arg_13_5 or 20)
end

DebugDrawer.arrow_2d = function (arg_14_0, arg_14_1, arg_14_2, arg_14_3)
	arg_14_0:line(arg_14_1, arg_14_2, arg_14_3)

	local var_14_0 = arg_14_2 - arg_14_1
	local var_14_1 = Vector3.length(var_14_0)
	local var_14_2 = Vector3.cross(Vector3.normalize(var_14_0), Vector3.up())

	arg_14_0:line(arg_14_2, arg_14_2 - 0.2 * var_14_0 + var_14_2 * var_14_1 * 0.2, arg_14_3)
	arg_14_0:line(arg_14_2, arg_14_2 - 0.2 * var_14_0 - var_14_2 * var_14_1 * 0.2, arg_14_3)
end

DebugDrawer.cylinder = function (arg_15_0, arg_15_1, arg_15_2, arg_15_3, arg_15_4, arg_15_5)
	arg_15_4 = arg_15_4 or Color(255, 255, 255)
	arg_15_5 = arg_15_5 or 5

	local var_15_0 = (arg_15_2 - arg_15_1) / arg_15_5
	local var_15_1 = arg_15_1
	local var_15_2 = Vector3.normalize(var_15_0)

	LineObject.add_circle(arg_15_0._line_object, arg_15_4, arg_15_1, arg_15_3, var_15_2, 20)

	for iter_15_0 = 1, arg_15_5 - 1 do
		var_15_1 = var_15_1 + var_15_0

		LineObject.add_circle(arg_15_0._line_object, arg_15_4, var_15_1, arg_15_3, var_15_2, 20)
	end
end

DebugDrawer.vector = function (arg_16_0, arg_16_1, arg_16_2, arg_16_3)
	arg_16_3 = arg_16_3 or Color(255, 255, 255)

	local var_16_0 = Vector3.length(arg_16_2)
	local var_16_1 = Vector3.normalize(arg_16_2)
	local var_16_2 = 0.2
	local var_16_3 = var_16_0 * var_16_2
	local var_16_4 = var_16_0 * var_16_2 / 2
	local var_16_5 = arg_16_1 + arg_16_2
	local var_16_6, var_16_7 = Vector3.make_axes(var_16_1)
	local var_16_8 = var_16_5 - var_16_1 * var_16_3

	arg_16_0:line(arg_16_1, var_16_5, arg_16_3)
	arg_16_0:line(var_16_5, var_16_8 - var_16_6 * var_16_4, arg_16_3)
	arg_16_0:line(var_16_5, var_16_8 + var_16_6 * var_16_4, arg_16_3)
	arg_16_0:line(var_16_5, var_16_8 - var_16_7 * var_16_4, arg_16_3)
	arg_16_0:line(var_16_5, var_16_8 + var_16_7 * var_16_4, arg_16_3)
end

DebugDrawer.quaternion = function (arg_17_0, arg_17_1, arg_17_2, arg_17_3)
	arg_17_3 = arg_17_3 or 1

	arg_17_0:vector(arg_17_1, arg_17_3 * Quaternion.right(arg_17_2), Color(255, 0, 0))
	arg_17_0:vector(arg_17_1, arg_17_3 * Quaternion.forward(arg_17_2), Color(0, 255, 0))
	arg_17_0:vector(arg_17_1, arg_17_3 * Quaternion.up(arg_17_2), Color(0, 0, 255))
end

DebugDrawer.matrix4x4 = function (arg_18_0, arg_18_1, arg_18_2)
	arg_18_2 = arg_18_2 or 1

	local var_18_0 = Matrix4x4.translation(arg_18_1)

	arg_18_0:sphere(var_18_0, arg_18_2 * 0.25)

	local var_18_1 = Matrix4x4.rotation(arg_18_1)

	arg_18_0:quaternion(var_18_0, var_18_1, arg_18_2)
end

DebugDrawer.unit = function (arg_19_0, arg_19_1, arg_19_2)
	arg_19_2 = arg_19_2 or Color(255, 255, 255)

	local var_19_0, var_19_1 = Unit.box(arg_19_1)

	arg_19_0:box(var_19_0, var_19_1, arg_19_2)

	local var_19_2 = Unit.world_position(arg_19_1, 0)

	var_19_2.z = var_19_2.z + var_19_1.z

	local var_19_3 = Unit.world_rotation(arg_19_1, 0)

	arg_19_0:quaternion(var_19_2, var_19_3)
end

DebugDrawer.navigation_mesh_search = function (arg_20_0, arg_20_1)
	NavigationMesh.visualize_last_search(arg_20_1, arg_20_0._line_object)
end

DebugDrawer.update = function (arg_21_0, arg_21_1)
	if script_data and script_data.disable_debug_draw then
		arg_21_0:reset()

		return
	end

	LineObject.dispatch(arg_21_1, arg_21_0._line_object)

	if arg_21_0._mode == "immediate" then
		arg_21_0:reset()
	end
end
