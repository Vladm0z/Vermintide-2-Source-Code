-- chunkname: @foundation/scripts/managers/free_flight/free_flight_manager_testify.lua

return {
	move_free_flight_camera = function(arg_1_0, arg_1_1)
		local var_1_0 = MainPathUtils.point_on_mainpath(nil, arg_1_1.position)
		local var_1_1 = stingray.Quaternion.from_euler_angles_xyz(arg_1_1.rotation.x, arg_1_1.rotation.y, arg_1_1.rotation.z)

		var_1_0.z = var_1_0.z + 1

		printf("Moving camera to position x:%f, y:%f, z:%f and rotation x:%f, y:%f, z:%f", var_1_0.x, var_1_0.y, var_1_0.z, arg_1_1.rotation.x, arg_1_1.rotation.y, arg_1_1.rotation.z)
		arg_1_0:teleport_camera(1, var_1_0, var_1_1)
	end
}
