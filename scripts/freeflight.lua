-- chunkname: @scripts/freeflight.lua

FreeFlight = class(FreeFlight)

FreeFlight.init = function (self, arg_1_1, arg_1_2)
	-- function 1
	self.camera = arg_1_1
	self.unit = arg_1_2
	self.translation_speed = 0.2

	if not IS_WINDOWS then
		self.rotation_speed = 0.003
	else
		self.rotation_speed = 0.03
	end
end

FreeFlight.update = function (self, arg_2_1)
	-- function 2
	local tbl = {}

	if not IS_WINDOWS then
		tbl.pan = Mouse.axis(Mouse.axis_index("mouse"))
		tbl.accelerate = Vector3.y(Mouse.axis(Mouse.axis_index("wheel")))
		tbl.move = Vector3(Keyboard.button(Keyboard.button_index("d")) - Keyboard.button(Keyboard.button_index("a")), Keyboard.button(Keyboard.button_index("w")) - Keyboard.button(Keyboard.button_index("s")), Keyboard.button(Keyboard.button_index("e")) - Keyboard.button(Keyboard.button_index("q")))
	end

	if PLATFORM == "ps3" then
		tbl.pan = Pad1.axis(Pad1.axis_index("right"))

		Vector3.set_y(tbl.pan, -tbl.pan.y)

		tbl.move = Pad1.axis(Pad1.axis_index("left"))
		tbl.accelerate = Pad1.button(Pad1.button_index("r2_trigger")) - Pad1.button(Pad1.button_index("r1_trigger"))
	end

	local num = self.translation_speed * 0.1

	self.translation_speed = self.translation_speed + tbl.accelerate * num

	if self.translation_speed < 0.001 then
		self.translation_speed = 0.001
	end

	local local_pose = Camera.local_pose(self.camera)
	local translation = Matrix4x4.translation(local_pose)

	Matrix4x4.set_translation(local_pose, Vector3(0, 0, 0))

	local var_2_4 = Quaternion(Vector3(0, 0, 1), -Vector3.x(tbl.pan) * self.rotation_speed)
	local var_2_5 = Quaternion(Matrix4x4.x(local_pose), -Vector3.y(tbl.pan) * self.rotation_speed)
	local multiply = Quaternion.multiply(var_2_4, var_2_5)
	local multiply_2 = Matrix4x4.multiply(local_pose, Matrix4x4.from_quaternion(multiply))
	local transform = Matrix4x4.transform(multiply_2, tbl.move * self.translation_speed)
	local add = Vector3.add(translation, transform)

	Matrix4x4.set_translation(multiply_2, add)
	Camera.set_local_pose(self.camera, self.unit, multiply_2)
end
