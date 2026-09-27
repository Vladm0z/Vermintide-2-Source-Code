-- chunkname: @scripts/unit_extensions/camera/states/camera_state_follow_third_person_tunneling.lua

CameraStateFollowThirdPersonTunneling = class(CameraStateFollowThirdPersonTunneling, CameraState)

CameraStateFollowThirdPersonTunneling.init = function (arg_1_0, arg_1_1)
	-- function 1
	CameraState.init(arg_1_0, arg_1_1, "follow_third_person_tunneling")
end

CameraStateFollowThirdPersonTunneling.on_enter = function (self, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5, arg_2_6, arg_2_7)
	-- function 2
	local camera_extension = self.camera_extension
	local get_follow_data, var_2_2 = camera_extension:get_follow_data()
	local viewport_name = camera_extension.viewport_name

	self._follow_unit = get_follow_data
	self._follow_node = var_2_2
	self._unit = arg_2_1

	local camera = Managers.state.camera
	local normalize = Vector3.normalize(Vector3.flat(Quaternion.forward(Unit.local_rotation(get_follow_data, 0))))
	local atan2 = math.atan2(normalize.y, normalize.x)

	camera:set_pitch_yaw(viewport_name, -0.6, atan2)
	Unit.set_data(arg_2_1, "camera", "settings_node", "tunneling")

	self.total_lerp_time = 2
	self.lerp_time = 0
	self.progress = 0
	self.calculate_lerp = true
	self.camera_start_pose = Matrix4x4Box(Unit.local_pose(arg_2_1, 0))
end

CameraStateFollowThirdPersonTunneling.on_exit = function (self, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5, arg_3_6)
	-- function 3
	self._follow_unit = nil
end

CameraStateFollowThirdPersonTunneling.update_tunnel_camera_position = function (self, arg_4_1)
	-- function 4
	local _unit = self._unit

	Unit.set_local_position(_unit, 0, arg_4_1)

	local _follow_unit = self._follow_unit
	local num = Unit.local_position(_follow_unit, 0) - arg_4_1
	local look = Quaternion.look(num)

	Unit.set_local_rotation(_unit, 0, look)

	self.calculate_lerp = true
	self.total_lerp_time = 2
	self.lerp_time = 0
	self.progress = 0
	self.calculate_lerp = true
	self.camera_start_pose = Matrix4x4Box(Unit.local_pose(_unit, 0))
end

CameraStateFollowThirdPersonTunneling.update = function (self, arg_5_1, arg_5_2, arg_5_3, arg_5_4, arg_5_5)
	-- function 5
	local csm = self.csm
	local camera_extension = self.camera_extension
	local _follow_unit = self._follow_unit

	if not Unit.alive(_follow_unit) then
		csm:change_state("idle")

		return
	end

	local external_state_change = camera_extension.external_state_change
	local external_state_change_params = camera_extension.external_state_change_params

	if not (not external_state_change and external_state_change == self.name) then
		csm:change_state(external_state_change, external_state_change_params)
		camera_extension:set_external_state_change(nil)

		return
	end

	if not self.calculate_lerp then
		local total_lerp_time = self.total_lerp_time
		local lerp_time = self.lerp_time
		local progress = self.progress
		local min = math.min(lerp_time + arg_5_3, total_lerp_time)
		local num = min / total_lerp_time
		local smoothstep = math.smoothstep(num, 0, 1)
		local local_pose = Unit.local_pose(_follow_unit, 0)
		local unbox = self.camera_start_pose:unbox()
		local lerp = Matrix4x4.lerp(unbox, local_pose, smoothstep)

		Unit.set_local_pose(arg_5_1, 0, lerp)

		if progress == 1 then
			self.calculate_lerp = nil
			self.camera_start_pose = nil
			self.total_lerp_time = nil
			self.lerp_time = nil
			self.progress = nil
		else
			self.progress = num
			self.lerp_time = min
		end
	end
end
