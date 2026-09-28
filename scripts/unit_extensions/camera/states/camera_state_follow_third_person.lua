-- chunkname: @scripts/unit_extensions/camera/states/camera_state_follow_third_person.lua

CameraStateFollowThirdPerson = class(CameraStateFollowThirdPerson, CameraState)

CameraStateFollowThirdPerson.init = function (self, camera_state_init_context)
	-- function 1
	CameraState.init(self, camera_state_init_context, "follow_third_person")

	self._follow_unit = nil
	self._follow_node = 0
end

CameraStateFollowThirdPerson.on_enter = function (self, unit, input, dt, context, t, previous_state, params)
	-- function 2
	local camera_extension = self.camera_extension
	local follow_unit, follow_node = camera_extension:get_follow_data()
	local viewport_name = camera_extension.viewport_name
	local min_leave_t = params.min_leave_t

	min_leave_t = not not min_leave_t or not not 0
	self._min_leave_t = min_leave_t

	local override_follow_unit = params.override_follow_unit

	if override_follow_unit and Unit.alive(override_follow_unit) then
		follow_unit = override_follow_unit
	end

	if not follow_unit or not Unit.alive(follow_unit) then
		self._follow_unit = nil

		return
	end

	local override_node_name = params.override_node_name

	if override_node_name then
		if Unit.has_node(follow_unit, override_node_name) then
			follow_node = Unit.node(follow_unit, override_node_name)
		else
			printf(string.format("Tried to get non existing node '%s' for unit '%s'", override_node_name, tostring(follow_unit)))
		end
	end

	local camera_offset = params.camera_offset

	self._camera_offset = not not camera_offset and not not Vector3Box(camera_offset)
	self._allow_camera_movement = params.allow_camera_movement

	local flag

	flag = (params.follow_unit_rotation ~= nil or not true) and not not params.follow_unit_rotation
	self._follow_unit_rotation = flag
	self._follow_unit = follow_unit
	self._follow_node = follow_node

	local Matrix4x4Box = Matrix4x4Box
	local world_pose

	if Unit.alive(follow_unit) then
		world_pose = Unit.world_pose(follow_unit, 0)

		if not world_pose then
			-- Nothing
		end
	end

	world_pose = Matrix4x4.identity()

	::label_2_0::

	self._fallback_pose = Matrix4x4Box(world_pose)

	local camera_manager = Managers.state.camera
	local root_look_dir = Vector3.normalize(Vector3.flat(Quaternion.forward(Unit.local_rotation(follow_unit, 0))))
	local yaw = math.atan2(root_look_dir.y, root_look_dir.x)

	camera_manager:set_pitch_yaw(viewport_name, -0.6, yaw)

	local set_data = Unit.set_data
	local var_2_5 = unit
	local str = "camera"
	local str_2 = "settings_node"
	local camera_node = params.camera_node

	camera_node = not not camera_node or not not "heal_self"

	set_data(var_2_5, str, str_2, camera_node)
end

CameraStateFollowThirdPerson.on_exit = function (self, unit, input, dt, context, t, next_state)
	-- function 3
	self._follow_unit = nil
end

CameraStateFollowThirdPerson.refresh_follow_unit = function (self, follow_unit, follow_node)
	-- function 4
	self._follow_unit = follow_unit
	self._follow_node = follow_node
end

CameraStateFollowThirdPerson.update = function (self, unit, input, dt, context, t)
	-- function 5
	local csm = self.csm
	local unit = self.unit
	local camera_extension = self.camera_extension
	local follow_unit = self._follow_unit
	local _follow_node = self._follow_node

	if not _follow_node then
		-- Nothing
	end

	_follow_node = 0

	local follow_node = _follow_node

	::label_5_0::

	local external_state_change = camera_extension.external_state_change
	local external_state_change_params = camera_extension.external_state_change_params
	local force_state_change = not not external_state_change_params and not not external_state_change_params.force_state_change

	if external_state_change and (external_state_change ~= self.name or force_state_change) then
		csm:change_state(external_state_change, external_state_change_params)
		camera_extension:set_external_state_change(nil)

		return
	end

	if not follow_unit or not Unit.alive(follow_unit) and t > self._min_leave_t then
		csm:change_state("observer")

		return
	end

	if self.calculate_lerp then
		local total_lerp_time = self.total_lerp_time
		local lerp_time = self.lerp_time
		local progress = self.progress
		local current_lerp_time = math.min(lerp_time + dt, total_lerp_time)
		local current_progress = current_lerp_time / total_lerp_time
		local smoothstep = math.smoothstep(current_progress, 0, 1)

		if Unit.alive(follow_unit) then
			self._fallback_pose:store(Unit.world_pose(follow_unit, 0))
		end

		local camera_target_pose = self._fallback_pose:unbox()
		local camera_pose = self.camera_start_pose:unbox()
		local lerp_pose = Matrix4x4.lerp(camera_pose, camera_target_pose, smoothstep)

		assert(Matrix4x4.is_valid(lerp_pose), "Camera unit lerp pose invalid.")
		Unit.set_local_pose(unit, 0, lerp_pose)

		if progress == 1 then
			self.calculate_lerp = nil
			self.camera_start_pose = nil
			self.total_lerp_time = nil
			self.lerp_time = nil
			self.progress = nil
		else
			self.progress = current_progress
			self.lerp_time = current_lerp_time
		end
	elseif self._follow_unit_rotation and not self._allow_camera_movement and Unit.alive(follow_unit) then
		CameraStateHelper.set_local_pose(unit, follow_unit, follow_node)
	else
		if self._allow_camera_movement then
			CameraStateHelper.set_camera_rotation(unit, camera_extension)
		end

		local _camera_offset = self._camera_offset

		if _camera_offset then
			-- Nothing
		end

		_camera_offset = Vector3Box.unbox(self._camera_offset)

		local camera_offset = _camera_offset

		::label_5_1::

		local position

		if Unit.alive(follow_unit) then
			position = Unit.world_position(follow_unit, follow_node)
		else
			position = Matrix4x4.translation(self._fallback_pose:unbox())
		end

		CameraStateHelper.set_follow_camera_position(unit, position, camera_offset, nil, dt)
	end
end
