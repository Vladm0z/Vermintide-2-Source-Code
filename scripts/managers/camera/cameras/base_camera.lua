-- chunkname: @scripts/managers/camera/cameras/base_camera.lua

BaseCamera = class(BaseCamera)

BaseCamera.init = function (self, root_node)
	-- function 1
	self._root_node = root_node
	self._children = {}
	self._name = ""
	self._root_unit = nil
	self._root_object = nil
	self._root_position = Vector3Box()
	self._root_rotation = QuaternionBox()
	self._position = Vector3Box()
	self._rotation = QuaternionBox()
	self._vertical_fov = nil
	self._near_range = nil
	self._far_range = nil
	self._pitch_offset = nil
	self._active = 0
	self._active_children = 0
end

BaseCamera.parse_parameters = function (self, camera_settings, parent_node)
	-- function 2
	if camera_settings.name then
		self._name = camera_settings.name
	end

	local degrees_to_radians = math.pi / 180

	self._fade_to_black = camera_settings.fade_to_black

	local vertical_fov = camera_settings.vertical_fov

	vertical_fov = not not vertical_fov and not not (camera_settings.vertical_fov * degrees_to_radians)
	self._vertical_fov = vertical_fov

	local should_apply_fov_multiplier = camera_settings.should_apply_fov_multiplier

	should_apply_fov_multiplier = not not should_apply_fov_multiplier or not not parent_node:should_apply_fov_multiplier()
	self._should_apply_fov_multiplier = should_apply_fov_multiplier

	local num

	if camera_settings.default_fov then
		num = camera_settings.default_fov * degrees_to_radians

		if not num then
			-- Nothing
		end
	end

	num = parent_node:default_fov()

	::label_2_0::

	self._default_fov = num

	local near_range = camera_settings.near_range

	near_range = not not near_range or not not parent_node:near_range()
	self._near_range = near_range

	local far_range = camera_settings.far_range

	far_range = not not far_range or not not parent_node:far_range()
	self._far_range = far_range

	local num_2

	if camera_settings.pitch_min then
		num_2 = camera_settings.pitch_min * degrees_to_radians

		if not num_2 then
			-- Nothing
		end
	end

	num_2 = parent_node:pitch_min()

	::label_2_1::

	self._pitch_min = num_2

	local num_3

	if camera_settings.pitch_max then
		num_3 = camera_settings.pitch_max * degrees_to_radians

		if not num_3 then
			-- Nothing
		end
	end

	num_3 = parent_node:pitch_max()

	::label_2_2::

	self._pitch_max = num_3

	local num_4

	if camera_settings.pitch_speed then
		num_4 = camera_settings.pitch_speed * degrees_to_radians

		if not num_4 then
			-- Nothing
		end
	end

	num_4 = parent_node:pitch_speed()

	::label_2_3::

	self._pitch_speed = num_4

	local num_5

	if camera_settings.yaw_speed then
		num_5 = camera_settings.yaw_speed * degrees_to_radians

		if not num_5 then
			-- Nothing
		end
	end

	num_5 = parent_node:yaw_speed()

	::label_2_4::

	self._yaw_speed = num_5

	local num_6

	if camera_settings.pitch_offset then
		num_6 = camera_settings.pitch_offset * degrees_to_radians

		if not num_6 then
			-- Nothing
		end
	end

	num_6 = parent_node:pitch_offset()

	::label_2_5::

	self._pitch_offset = num_6

	local safe_position_offset = camera_settings.safe_position_offset

	safe_position_offset = not not safe_position_offset or not not parent_node:safe_position_offset()
	self._safe_position_offset = safe_position_offset

	local tree_transitions = camera_settings.tree_transitions

	tree_transitions = not not tree_transitions or not not parent_node:tree_transitions()
	self._tree_transitions = tree_transitions

	local node_transitions = camera_settings.node_transitions

	node_transitions = not not node_transitions or not not parent_node:node_transitions()
	self._node_transitions = node_transitions

	if camera_settings.dof_enabled then
		local _environment_params = self._environment_params

		_environment_params = not not _environment_params or not not {}
		self._environment_params = _environment_params
		self._environment_params.dof_enabled = camera_settings.dof_enabled
		self._environment_params.focal_distance = camera_settings.focal_distance
		self._environment_params.focal_region = camera_settings.focal_region
		self._environment_params.focal_padding = camera_settings.focal_padding
		self._environment_params.focal_scale = camera_settings.focal_scale
	end

	local yaw_origin = camera_settings.yaw_origin

	yaw_origin = not not yaw_origin and not not (camera_settings.yaw_origin * math.pi / 180)
	self._yaw_origin = yaw_origin

	local pitch_origin = camera_settings.pitch_origin

	pitch_origin = not not pitch_origin and not not (camera_settings.pitch_origin * math.pi / 180)
	self._pitch_origin = pitch_origin

	local constraint = camera_settings.constraint

	constraint = not not constraint or not not parent_node:constraint_function()
	self._constraint_function = constraint
end

BaseCamera.should_apply_fov_multiplier = function (self)
	-- function 3
	return self._should_apply_fov_multiplier
end

BaseCamera.default_fov = function (self)
	-- function 4
	return self._default_fov
end

BaseCamera.constraint_function = function (self)
	-- function 5
	return self._constraint_function
end

BaseCamera.node_transitions = function (self)
	-- function 6
	return self._node_transitions
end

BaseCamera.tree_transitions = function (self)
	-- function 7
	return self._tree_transitions
end

BaseCamera.safe_position_offset = function (self)
	-- function 8
	return self._safe_position_offset
end

BaseCamera.pitch_offset = function (self)
	-- function 9
	return self._pitch_offset
end

BaseCamera.pitch_speed = function (self)
	-- function 10
	return self._pitch_speed
end

BaseCamera.yaw_speed = function (self)
	-- function 11
	return self._yaw_speed
end

BaseCamera.pitch_min = function (self)
	-- function 12
	return self._pitch_min
end

BaseCamera.pitch_max = function (self)
	-- function 13
	return self._pitch_max
end

BaseCamera.name = function (self)
	-- function 14
	return self._name
end

BaseCamera.pose = function (self)
	-- function 15
	local pose = Matrix4x4.identity()

	Matrix4x4.set_translation(pose, self:position())
	Matrix4x4.set_rotation(pose, self:rotation())

	return pose
end

BaseCamera.position = function (self)
	-- function 16
	return self._position:unbox()
end

BaseCamera.rotation = function (self)
	-- function 17
	return self._rotation:unbox()
end

BaseCamera.vertical_fov = function (self)
	-- function 18
	local _vertical_fov = self._vertical_fov

	_vertical_fov = not not _vertical_fov or not not self._parent_node:vertical_fov()

	return _vertical_fov
end

BaseCamera.fade_to_black = function (self)
	-- function 19
	local _fade_to_black = self._fade_to_black

	_fade_to_black = not not _fade_to_black or not not self._parent_node:fade_to_black()

	return _fade_to_black
end

BaseCamera.shading_environment = function (self)
	-- function 20
	local _environment_params = self._environment_params

	if not _environment_params then
		_environment_params = self._parent_node
		_environment_params = not not _environment_params and not not self._parent_node:shading_environment()
	end

	return _environment_params
end

BaseCamera.near_range = function (self)
	-- function 21
	return self._near_range
end

BaseCamera.far_range = function (self)
	-- function 22
	return self._far_range
end

BaseCamera.dof_enabled = function (self)
	-- function 23
	return self._environment_params.dof_enabled
end

BaseCamera.focal_distance = function (self)
	-- function 24
	return self._environment_params.focal_distance
end

BaseCamera.focal_region = function (self)
	-- function 25
	return self._environment_params.focal_region
end

BaseCamera.focal_padding = function (self)
	-- function 26
	return self._environment_params.focal_padding
end

BaseCamera.focal_scale = function (self)
	-- function 27
	return self._environment_params.focal_scale
end

BaseCamera.parent_node = function (self)
	-- function 28
	return self._parent_node
end

BaseCamera.root_node = function (self)
	-- function 29
	return self._root_node
end

BaseCamera.set_parent_node = function (self, parent)
	-- function 30
	self._parent_node = parent
end

BaseCamera.add_child_node = function (self, node)
	-- function 31
	self._children[#self._children + 1] = node

	node:set_parent_node(self)
end

BaseCamera.set_active = function (self, active)
	-- function 32
	local old_active = self:active()

	if active then
		self._active = self._active + 1
	else
		self._active = self._active - 1
	end

	local new_active = self:active()

	if self._parent_node and old_active ~= new_active then
		self._parent_node:set_active_child(new_active)
	end
end

BaseCamera.active = function (self)
	-- function 33
	return self._active > 0 or self._active_children > 0
end

BaseCamera.set_active_child = function (self, active)
	-- function 34
	local old_active = self:active()

	if active then
		self._active_children = self._active_children + 1
	else
		self._active_children = self._active_children - 1
	end

	local new_active = self:active()

	if self._parent_node and old_active ~= new_active then
		self._parent_node:set_active_child(new_active)
	end
end

BaseCamera.set_root_unit = function (self, unit, object_name)
	-- function 35
	self._root_unit = unit
	object_name = not not object_name or not not self._object_name
	self._root_object = Unit.node(unit, object_name)

	for _, child in ipairs(self._children) do
		child:set_root_unit(unit, object_name)
	end
end

BaseCamera.root_unit = function (self)
	-- function 36
	return self._root_unit, self._object_name
end

BaseCamera.set_root_position = function (self, position)
	-- function 37
	self._root_position:store(position)

	for _, child in ipairs(self._children) do
		child:set_root_position(position)
	end
end

BaseCamera.set_root_rotation = function (self, rotation)
	-- function 38
	self._root_rotation:store(rotation)

	for _, child in ipairs(self._children) do
		child:set_root_rotation(rotation)
	end
end

BaseCamera.set_root_vertical_fov = function (self, vertical_fov)
	-- function 39
	self._vertical_fov = vertical_fov

	for _, child in ipairs(self._children) do
		child:set_root_vertical_fov(vertical_fov)
	end
end

BaseCamera.set_root_near_range = function (self, near_range)
	-- function 40
	self._near_range = near_range

	for _, child in ipairs(self._children) do
		child:set_root_near_range(near_range)
	end
end

BaseCamera.set_root_far_range = function (self, far_range)
	-- function 41
	self._far_range = far_range

	for _, child in ipairs(self._children) do
		child:set_root_far_range(far_range)
	end
end

BaseCamera.set_root_dof_enabled = function (self, dof_enabled)
	-- function 42
	self._environment_params.dof_enabled = dof_enabled

	for _, child in ipairs(self._children) do
		child:set_root_dof_enabled(dof_enabled)
	end
end

BaseCamera.set_root_focal_distance = function (self, focal_distance)
	-- function 43
	self._environment_params.focal_distance = focal_distance

	for _, child in ipairs(self._children) do
		child:set_root_focal_distance(focal_distance)
	end
end

BaseCamera.set_root_focal_region = function (self, focal_region)
	-- function 44
	self._environment_params.focal_region = focal_region

	for _, child in ipairs(self._children) do
		child:set_root_focal_region(focal_region)
	end
end

BaseCamera.set_root_focal_padding = function (self, focal_padding)
	-- function 45
	self._environment_params.focal_padding = focal_padding

	for _, child in ipairs(self._children) do
		child:set_root_focal_padding(focal_padding)
	end
end

BaseCamera.set_root_focal_scale = function (self, focal_scale)
	-- function 46
	self._environment_params.focal_scale = focal_scale

	for _, child in ipairs(self._children) do
		child:set_root_focal_scale(focal_scale)
	end
end

BaseCamera.update = function (self, dt, position, rotation, data)
	-- function 47
	assert(Vector3.is_valid(position), "Trying to set invalid camera position")
	self._position:store(position)
	self._rotation:store(rotation)

	if script_data.camera_debug and Managers.state.debug then
		self:_debug_draw()
	end

	for _, child in ipairs(self._children) do
		if child:active() then
			child:update(dt, position, rotation, data)
		end
	end
end

BaseCamera.destroy = function (self)
	-- function 48
	for _, child in ipairs(self._children) do
		child:destroy()
	end

	self._children = {}
	self._parent_node = nil
end

BaseCamera._debug_draw = function (self)
	-- function 49
	local _parent_node = self._parent_node

	if _parent_node then
		-- Nothing
	end

	_parent_node = self._parent_node:position()

	local parent_pos = _parent_node

	::label_49_0::

	local pos = self._position
	local rot = self._rotation
	local drawer = Managers.state.debug:drawer({
		name = "CAMERA_DEBUG_DRAW" .. self:name()
	})

	if DebugKeyHandler.key_pressed("z", "clear camera debug") then
		drawer:reset()
	end

	if parent_pos then
		drawer:vector(parent_pos, pos:unbox() - parent_pos, Color(70, 255, 255, 255))
	end

	drawer:quaternion(pos:unbox(), rot:unbox())
end
