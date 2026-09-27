-- chunkname: @scripts/managers/debug/debug_drawer.lua

DebugDrawer = class(DebugDrawer)

DebugDrawer.init = function (self, arg_1_1, arg_1_2)
	-- function 1
	self._line_object = arg_1_1
	self._mode = arg_1_2
end

DebugDrawer.reset = function (self)
	-- function 2
	LineObject.reset(self._line_object)
end

DebugDrawer.line_object = function (self)
	-- function 3
	return self._line_object
end

DebugDrawer.line = function (self, arg_4_1, arg_4_2, arg_4_3)
	-- function 4
	arg_4_3 = arg_4_3 or Color(255, 255, 255)

	LineObject.add_line(self._line_object, arg_4_3, arg_4_1, arg_4_2)
end

DebugDrawer.sphere = function (self, arg_5_1, arg_5_2, arg_5_3, arg_5_4, arg_5_5)
	-- function 5
	arg_5_3 = arg_5_3 or Color(255, 255, 255)

	LineObject.add_sphere(self._line_object, arg_5_3, arg_5_1, arg_5_2, arg_5_4 or 20, arg_5_5 or 2)
end

DebugDrawer.capsule_overlap = function (self, arg_6_1, arg_6_2, arg_6_3, arg_6_4)
	-- function 6
	fassert(arg_6_2.x == arg_6_2.z, "Passing diffent x and y size doesn't do anything, capsules overlaps are always sphere swept, not spheroid shaped.")

	local num = (arg_6_2.x + arg_6_2.z) * 0.5
	local num_2 = Quaternion.forward(arg_6_3) * (arg_6_2.y - num)
	local num_3 = arg_6_1 - num_2
	local num_4 = arg_6_1 + num_2

	self:capsule(num_3, num_4, num, arg_6_4)
end

DebugDrawer.oobb_overlap = function (self, arg_7_1, arg_7_2, arg_7_3, arg_7_4)
	-- function 7
	local from_quaternion_position = Matrix4x4.from_quaternion_position(arg_7_3, arg_7_1)

	self:box(from_quaternion_position, arg_7_2, arg_7_4)
end

DebugDrawer.box_sweep = function (self, arg_8_1, arg_8_2, arg_8_3, arg_8_4, arg_8_5)
	-- function 8
	arg_8_4 = arg_8_4 or Color(255, 255, 255)
	arg_8_5 = arg_8_5 or Color(255, 0, 0)

	local rotation = Matrix4x4.rotation(arg_8_1)
	local translation = Matrix4x4.translation(arg_8_1)
	local from_quaternion_position = Matrix4x4.from_quaternion_position(rotation, translation + arg_8_3)

	self:box(arg_8_1, arg_8_2, arg_8_4)
	self:box(from_quaternion_position, arg_8_2, arg_8_4)

	local right = Matrix4x4.right(arg_8_1)
	local forward = Matrix4x4.forward(arg_8_1)
	local up = Matrix4x4.up(arg_8_1)
	local num = right * arg_8_2.x
	local num_2 = -right * arg_8_2.x
	local num_3 = forward * arg_8_2.y
	local num_4 = -forward * arg_8_2.y
	local num_5 = up * arg_8_2.z
	local num_6 = -up * arg_8_2.z
	local num_7 = translation + num + num_3 + num_5
	local num_8 = translation + num_2 + num_3 + num_5
	local num_9 = translation + num_2 + num_4 + num_5
	local num_10 = translation + num + num_4 + num_5
	local num_11 = translation + num + num_3 + num_6
	local num_12 = translation + num_2 + num_3 + num_6
	local num_13 = translation + num_2 + num_4 + num_6
	local num_14 = translation + num + num_4 + num_6

	self:line(num_7, num_7 + arg_8_3, arg_8_5)
	self:line(num_8, num_8 + arg_8_3, arg_8_5)
	self:line(num_9, num_9 + arg_8_3, arg_8_5)
	self:line(num_10, num_10 + arg_8_3, arg_8_5)
	self:line(num_11, num_11 + arg_8_3, arg_8_5)
	self:line(num_12, num_12 + arg_8_3, arg_8_5)
	self:line(num_13, num_13 + arg_8_3, arg_8_5)
	self:line(num_14, num_14 + arg_8_3, arg_8_5)
end

DebugDrawer.capsule = function (self, arg_9_1, arg_9_2, arg_9_3, arg_9_4)
	-- function 9
	arg_9_4 = arg_9_4 or Color(255, 255, 255)

	LineObject.add_capsule(self._line_object, arg_9_4, arg_9_1, arg_9_2, arg_9_3)
end

DebugDrawer.actor = function (self, arg_10_1, arg_10_2, arg_10_3)
	-- function 10
	arg_10_2 = arg_10_2 or Color(255, 255, 255)

	Actor.debug_draw(arg_10_1, self._line_object, arg_10_2, arg_10_3)
end

DebugDrawer.box = function (self, arg_11_1, arg_11_2, arg_11_3)
	-- function 11
	arg_11_3 = arg_11_3 or Color(255, 255, 255)

	LineObject.add_box(self._line_object, arg_11_3, arg_11_1, arg_11_2)
end

DebugDrawer.cone = function (self, arg_12_1, arg_12_2, arg_12_3, arg_12_4, arg_12_5, arg_12_6)
	-- function 12
	arg_12_4 = arg_12_4 or Color(255, 255, 255)

	LineObject.add_cone(self._line_object, arg_12_4, arg_12_1, arg_12_2, arg_12_3, arg_12_5, arg_12_6)
end

DebugDrawer.circle = function (self, arg_13_1, arg_13_2, arg_13_3, arg_13_4, arg_13_5)
	-- function 13
	arg_13_4 = arg_13_4 or Color(255, 255, 255)

	LineObject.add_circle(self._line_object, arg_13_4, arg_13_1, arg_13_2, arg_13_3, arg_13_5 or 20)
end

DebugDrawer.arrow_2d = function (self, arg_14_1, arg_14_2, arg_14_3)
	-- function 14
	self:line(arg_14_1, arg_14_2, arg_14_3)

	local num = arg_14_2 - arg_14_1
	local length = Vector3.length(num)
	local cross = Vector3.cross(Vector3.normalize(num), Vector3.up())

	self:line(arg_14_2, arg_14_2 - 0.2 * num + cross * length * 0.2, arg_14_3)
	self:line(arg_14_2, arg_14_2 - 0.2 * num - cross * length * 0.2, arg_14_3)
end

DebugDrawer.cylinder = function (self, arg_15_1, arg_15_2, arg_15_3, arg_15_4, arg_15_5)
	-- function 15
	arg_15_4 = arg_15_4 or Color(255, 255, 255)
	arg_15_5 = arg_15_5 or 5

	local num = (arg_15_2 - arg_15_1) / arg_15_5
	local var_15_1 = arg_15_1
	local normalize = Vector3.normalize(num)

	LineObject.add_circle(self._line_object, arg_15_4, arg_15_1, arg_15_3, normalize, 20)

	for i = 1, arg_15_5 - 1 do
		var_15_1 = var_15_1 + num

		LineObject.add_circle(self._line_object, arg_15_4, var_15_1, arg_15_3, normalize, 20)
	end
end

DebugDrawer.vector = function (self, arg_16_1, arg_16_2, arg_16_3)
	-- function 16
	arg_16_3 = arg_16_3 or Color(255, 255, 255)

	local length = Vector3.length(arg_16_2)
	local normalize = Vector3.normalize(arg_16_2)
	local num = 0.2
	local num_2 = length * num
	local num_3 = length * num / 2
	local num_4 = arg_16_1 + arg_16_2
	local make_axes, var_16_7 = Vector3.make_axes(normalize)
	local num_5 = num_4 - normalize * num_2

	self:line(arg_16_1, num_4, arg_16_3)
	self:line(num_4, num_5 - make_axes * num_3, arg_16_3)
	self:line(num_4, num_5 + make_axes * num_3, arg_16_3)
	self:line(num_4, num_5 - var_16_7 * num_3, arg_16_3)
	self:line(num_4, num_5 + var_16_7 * num_3, arg_16_3)
end

DebugDrawer.quaternion = function (self, arg_17_1, arg_17_2, arg_17_3)
	-- function 17
	arg_17_3 = arg_17_3 or 1

	self:vector(arg_17_1, arg_17_3 * Quaternion.right(arg_17_2), Color(255, 0, 0))
	self:vector(arg_17_1, arg_17_3 * Quaternion.forward(arg_17_2), Color(0, 255, 0))
	self:vector(arg_17_1, arg_17_3 * Quaternion.up(arg_17_2), Color(0, 0, 255))
end

DebugDrawer.matrix4x4 = function (self, arg_18_1, arg_18_2)
	-- function 18
	arg_18_2 = arg_18_2 or 1

	local translation = Matrix4x4.translation(arg_18_1)

	self:sphere(translation, arg_18_2 * 0.25)

	local rotation = Matrix4x4.rotation(arg_18_1)

	self:quaternion(translation, rotation, arg_18_2)
end

DebugDrawer.unit = function (self, arg_19_1, arg_19_2)
	-- function 19
	arg_19_2 = arg_19_2 or Color(255, 255, 255)

	local box, var_19_1 = Unit.box(arg_19_1)

	self:box(box, var_19_1, arg_19_2)

	local world_position = Unit.world_position(arg_19_1, 0)

	world_position.z = world_position.z + var_19_1.z

	local world_rotation = Unit.world_rotation(arg_19_1, 0)

	self:quaternion(world_position, world_rotation)
end

DebugDrawer.navigation_mesh_search = function (self, arg_20_1)
	-- function 20
	NavigationMesh.visualize_last_search(arg_20_1, self._line_object)
end

DebugDrawer.update = function (self, arg_21_1)
	-- function 21
	if not script_data and not script_data.disable_debug_draw then
		self:reset()

		return
	end

	LineObject.dispatch(arg_21_1, self._line_object)

	if self._mode == "immediate" then
		self:reset()
	end
end
