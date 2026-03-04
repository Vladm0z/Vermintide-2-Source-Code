-- chunkname: @scripts/freeflight.lua

FreeFlight = class(FreeFlight)

FreeFlight.init = function (arg_1_0, arg_1_1, arg_1_2)
	arg_1_0.camera = arg_1_1
	arg_1_0.unit = arg_1_2
	arg_1_0.translation_speed = 0.2

	if IS_WINDOWS then
		arg_1_0.rotation_speed = 0.003
	else
		arg_1_0.rotation_speed = 0.03
	end
end

FreeFlight.update = function (arg_2_0, arg_2_1)
	local var_2_0 = {}

	if IS_WINDOWS then
		var_2_0.pan = Mouse.axis(Mouse.axis_index("mouse"))
		var_2_0.accelerate = Vector3.y(Mouse.axis(Mouse.axis_index("wheel")))
		var_2_0.move = Vector3(Keyboard.button(Keyboard.button_index("d")) - Keyboard.button(Keyboard.button_index("a")), Keyboard.button(Keyboard.button_index("w")) - Keyboard.button(Keyboard.button_index("s")), Keyboard.button(Keyboard.button_index("e")) - Keyboard.button(Keyboard.button_index("q")))
	end

	if PLATFORM == "ps3" then
		var_2_0.pan = Pad1.axis(Pad1.axis_index("right"))

		Vector3.set_y(var_2_0.pan, -var_2_0.pan.y)

		var_2_0.move = Pad1.axis(Pad1.axis_index("left"))
		var_2_0.accelerate = Pad1.button(Pad1.button_index("r2_trigger")) - Pad1.button(Pad1.button_index("r1_trigger"))
	end

	local var_2_1 = arg_2_0.translation_speed * 0.1

	arg_2_0.translation_speed = arg_2_0.translation_speed + var_2_0.accelerate * var_2_1

	if arg_2_0.translation_speed < 0.001 then
		arg_2_0.translation_speed = 0.001
	end

	local var_2_2 = Camera.local_pose(arg_2_0.camera)
	local var_2_3 = Matrix4x4.translation(var_2_2)

	Matrix4x4.set_translation(var_2_2, Vector3(0, 0, 0))

	local var_2_4 = Quaternion(Vector3(0, 0, 1), -Vector3.x(var_2_0.pan) * arg_2_0.rotation_speed)
	local var_2_5 = Quaternion(Matrix4x4.x(var_2_2), -Vector3.y(var_2_0.pan) * arg_2_0.rotation_speed)
	local var_2_6 = Quaternion.multiply(var_2_4, var_2_5)
	local var_2_7 = Matrix4x4.multiply(var_2_2, Matrix4x4.from_quaternion(var_2_6))
	local var_2_8 = Matrix4x4.transform(var_2_7, var_2_0.move * arg_2_0.translation_speed)
	local var_2_9 = Vector3.add(var_2_3, var_2_8)

	Matrix4x4.set_translation(var_2_7, var_2_9)
	Camera.set_local_pose(arg_2_0.camera, arg_2_0.unit, var_2_7)
end
