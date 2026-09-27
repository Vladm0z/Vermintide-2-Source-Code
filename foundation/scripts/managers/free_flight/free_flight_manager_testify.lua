-- chunkname: @foundation/scripts/managers/free_flight/free_flight_manager_testify.lua

return {
	move_free_flight_camera = function (self, arg_1_1)
		-- function 1
		local point_on_mainpath = MainPathUtils.point_on_mainpath(nil, arg_1_1.position)
		local from_euler_angles_xyz = stingray.Quaternion.from_euler_angles_xyz(arg_1_1.rotation.x, arg_1_1.rotation.y, arg_1_1.rotation.z)

		point_on_mainpath.z = point_on_mainpath.z + 1

		printf("Moving camera to position x:%f, y:%f, z:%f and rotation x:%f, y:%f, z:%f", point_on_mainpath.x, point_on_mainpath.y, point_on_mainpath.z, arg_1_1.rotation.x, arg_1_1.rotation.y, arg_1_1.rotation.z)
		self:teleport_camera(1, point_on_mainpath, from_euler_angles_xyz)
	end
}
