-- chunkname: @scripts/unit_extensions/camera/states/camera_state_attract.lua

CameraStateFollowAttract = class(CameraStateFollowAttract, CameraState)

CameraStateFollowAttract.init = function (self, arg_1_1)
	-- function 1
	CameraState.init(self, arg_1_1, "attract")

	self._follow_unit = nil
	self._follow_node = 0
end

CameraStateFollowAttract.on_enter = function (self, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5, arg_2_6, arg_2_7)
	-- function 2
	local camera_extension = self.camera_extension
	local get_follow_data, var_2_2 = camera_extension:get_follow_data()
	local viewport_name = camera_extension.viewport_name

	self._follow_unit = get_follow_data
	self._follow_node = var_2_2

	local camera = Managers.state.camera
	local normalize = Vector3.normalize(Vector3.flat(Quaternion.forward(Unit.local_rotation(get_follow_data, 0))))
	local atan2 = math.atan2(normalize.y, normalize.x)

	camera:set_pitch_yaw(viewport_name, -0.6, atan2)
	Unit.set_data(arg_2_1, "camera", "settings_node", "attract_mode")
end

CameraStateFollowAttract.on_exit = function (self, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5, arg_3_6)
	-- function 3
	self._follow_unit = nil
end

CameraStateFollowAttract.refresh_follow_unit = function (self, arg_4_1, arg_4_2)
	-- function 4
	self._follow_unit = arg_4_1
	self._follow_node = arg_4_2
end

CameraStateFollowAttract.update = function (self, arg_5_1, arg_5_2, arg_5_3, arg_5_4, arg_5_5)
	-- function 5
	local csm = self.csm
	local unit = self.unit
	local camera_extension = self.camera_extension
	local _follow_unit = self._follow_unit
	local _follow_node = self._follow_node

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

	CameraStateHelper.set_local_pose(unit, _follow_unit, _follow_node)
end
