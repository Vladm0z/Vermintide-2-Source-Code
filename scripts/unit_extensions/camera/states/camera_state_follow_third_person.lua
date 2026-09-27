-- chunkname: @scripts/unit_extensions/camera/states/camera_state_follow_third_person.lua

CameraStateFollowThirdPerson = class(CameraStateFollowThirdPerson, CameraState)

CameraStateFollowThirdPerson.init = function (self, arg_1_1)
	-- function 1
	CameraState.init(self, arg_1_1, "follow_third_person")

	self._follow_unit = nil
	self._follow_node = 0
end

CameraStateFollowThirdPerson.on_enter = function (self, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5, arg_2_6, arg_2_7)
	-- function 2
	local camera_extension = self.camera_extension
	local get_follow_data, var_2_2 = camera_extension:get_follow_data()
	local viewport_name = camera_extension.viewport_name
	local min_leave_t = arg_2_7.min_leave_t

	min_leave_t = min_leave_t or 0
	self._min_leave_t = min_leave_t

	local override_follow_unit = arg_2_7.override_follow_unit

	if not override_follow_unit and not Unit.alive(override_follow_unit) then
		get_follow_data = override_follow_unit
	end

	if not (not get_follow_data and Unit.alive(get_follow_data)) then
		self._follow_unit = nil

		return
	end

	local override_node_name = arg_2_7.override_node_name

	if not override_node_name then
		if not Unit.has_node(get_follow_data, override_node_name) then
			var_2_2 = Unit.node(get_follow_data, override_node_name)
		else
			printf(string.format("Tried to get non existing node '%s' for unit '%s'", override_node_name, tostring(get_follow_data)))
		end
	end

	local camera_offset = arg_2_7.camera_offset

	self._camera_offset = not camera_offset and Vector3Box(camera_offset)
	self._allow_camera_movement = arg_2_7.allow_camera_movement

	local flag

	flag = arg_2_7.follow_unit_rotation ~= nil or not true or arg_2_7.follow_unit_rotation
	self._follow_unit_rotation = flag
	self._follow_unit = get_follow_data
	self._follow_node = var_2_2

	local Matrix4x4Box = Matrix4x4Box
	local world_pose

	if not Unit.alive(get_follow_data) then
		world_pose = Unit.world_pose(get_follow_data, 0)

		if not world_pose then
			-- Nothing
		end
	end

	world_pose = Matrix4x4.identity()

	::label_2_0::

	self._fallback_pose = Matrix4x4Box(world_pose)

	local camera = Managers.state.camera
	local normalize = Vector3.normalize(Vector3.flat(Quaternion.forward(Unit.local_rotation(get_follow_data, 0))))
	local atan2 = math.atan2(normalize.y, normalize.x)

	camera:set_pitch_yaw(viewport_name, -0.6, atan2)

	local set_data = Unit.set_data
	local var_2_15 = arg_2_1
	local str = "camera"
	local str_2 = "settings_node"
	local camera_node = arg_2_7.camera_node

	camera_node = camera_node or "heal_self"

	set_data(var_2_15, str, str_2, camera_node)
end

CameraStateFollowThirdPerson.on_exit = function (self, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5, arg_3_6)
	-- function 3
	self._follow_unit = nil
end

CameraStateFollowThirdPerson.refresh_follow_unit = function (self, arg_4_1, arg_4_2)
	-- function 4
	self._follow_unit = arg_4_1
	self._follow_node = arg_4_2
end

CameraStateFollowThirdPerson.update = function (self, arg_5_1, arg_5_2, arg_5_3, arg_5_4, arg_5_5)
	-- function 5
	local csm = self.csm
	local unit = self.unit
	local camera_extension = self.camera_extension
	local _follow_unit = self._follow_unit
	local _follow_node = self._follow_node

	_follow_node = _follow_node or 0

	local external_state_change = camera_extension.external_state_change
	local external_state_change_params = camera_extension.external_state_change_params
	local flag = not external_state_change_params and external_state_change_params.force_state_change

	if not external_state_change and external_state_change ~= self.name and not flag then
		csm:change_state(external_state_change, external_state_change_params)
		camera_extension:set_external_state_change(nil)

		return
	end

	if not (not _follow_unit and Unit.alive(_follow_unit) and not (arg_5_5 > self._min_leave_t)) then
		csm:change_state("observer")

		return
	end

	if not self.calculate_lerp then
		local total_lerp_time = self.total_lerp_time
		local lerp_time = self.lerp_time
		local progress = self.progress
		local min = math.min(lerp_time + arg_5_3, total_lerp_time)
		local num = min / total_lerp_time
		local smoothstep = math.smoothstep(num, 0, 1)

		if not Unit.alive(_follow_unit) then
			self._fallback_pose:store(Unit.world_pose(_follow_unit, 0))
		end

		local unbox = self._fallback_pose:unbox()
		local unbox_2 = self.camera_start_pose:unbox()
		local lerp = Matrix4x4.lerp(unbox_2, unbox, smoothstep)

		assert(Matrix4x4.is_valid(lerp), "Camera unit lerp pose invalid.")
		Unit.set_local_pose(unit, 0, lerp)

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
	elseif not self._follow_unit_rotation and self._allow_camera_movement or not Unit.alive(_follow_unit) then
		CameraStateHelper.set_local_pose(unit, _follow_unit, _follow_node)
	else
		if not self._allow_camera_movement then
			CameraStateHelper.set_camera_rotation(unit, camera_extension)
		end

		local _camera_offset = self._camera_offset

		_camera_offset = not _camera_offset and Vector3Box.unbox(self._camera_offset)

		local var_5_18

		if not Unit.alive(_follow_unit) then
			var_5_18 = Unit.world_position(_follow_unit, _follow_node)
		else
			var_5_18 = Matrix4x4.translation(self._fallback_pose:unbox())
		end

		CameraStateHelper.set_follow_camera_position(unit, var_5_18, _camera_offset, nil, arg_5_3)
	end
end
