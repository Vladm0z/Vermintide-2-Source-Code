-- chunkname: @scripts/managers/camera/cameras/base_camera.lua

BaseCamera = class(BaseCamera)

BaseCamera.init = function (self, arg_1_1)
	-- function 1
	self._root_node = arg_1_1
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

BaseCamera.parse_parameters = function (self, arg_2_1, arg_2_2)
	-- function 2
	if not arg_2_1.name then
		self._name = arg_2_1.name
	end

	local num = math.pi / 180

	self._fade_to_black = arg_2_1.fade_to_black

	local vertical_fov = arg_2_1.vertical_fov

	vertical_fov = not vertical_fov and arg_2_1.vertical_fov * num
	self._vertical_fov = vertical_fov

	local should_apply_fov_multiplier = arg_2_1.should_apply_fov_multiplier

	should_apply_fov_multiplier = should_apply_fov_multiplier or arg_2_2:should_apply_fov_multiplier()
	self._should_apply_fov_multiplier = should_apply_fov_multiplier

	local num_2

	if not arg_2_1.default_fov then
		num_2 = arg_2_1.default_fov * num

		if not num_2 then
			-- Nothing
		end
	end

	num_2 = arg_2_2:default_fov()

	::label_2_0::

	self._default_fov = num_2

	local near_range = arg_2_1.near_range

	near_range = near_range or arg_2_2:near_range()
	self._near_range = near_range

	local far_range = arg_2_1.far_range

	far_range = far_range or arg_2_2:far_range()
	self._far_range = far_range

	local num_3

	if not arg_2_1.pitch_min then
		num_3 = arg_2_1.pitch_min * num

		if not num_3 then
			-- Nothing
		end
	end

	num_3 = arg_2_2:pitch_min()

	::label_2_1::

	self._pitch_min = num_3

	local num_4

	if not arg_2_1.pitch_max then
		num_4 = arg_2_1.pitch_max * num

		if not num_4 then
			-- Nothing
		end
	end

	num_4 = arg_2_2:pitch_max()

	::label_2_2::

	self._pitch_max = num_4

	local num_5

	if not arg_2_1.pitch_speed then
		num_5 = arg_2_1.pitch_speed * num

		if not num_5 then
			-- Nothing
		end
	end

	num_5 = arg_2_2:pitch_speed()

	::label_2_3::

	self._pitch_speed = num_5

	local num_6

	if not arg_2_1.yaw_speed then
		num_6 = arg_2_1.yaw_speed * num

		if not num_6 then
			-- Nothing
		end
	end

	num_6 = arg_2_2:yaw_speed()

	::label_2_4::

	self._yaw_speed = num_6

	local num_7

	if not arg_2_1.pitch_offset then
		num_7 = arg_2_1.pitch_offset * num

		if not num_7 then
			-- Nothing
		end
	end

	num_7 = arg_2_2:pitch_offset()

	::label_2_5::

	self._pitch_offset = num_7

	local safe_position_offset = arg_2_1.safe_position_offset

	safe_position_offset = safe_position_offset or arg_2_2:safe_position_offset()
	self._safe_position_offset = safe_position_offset

	local tree_transitions = arg_2_1.tree_transitions

	tree_transitions = tree_transitions or arg_2_2:tree_transitions()
	self._tree_transitions = tree_transitions

	local node_transitions = arg_2_1.node_transitions

	node_transitions = node_transitions or arg_2_2:node_transitions()
	self._node_transitions = node_transitions

	if not arg_2_1.dof_enabled then
		local _environment_params = self._environment_params

		_environment_params = _environment_params or {}
		self._environment_params = _environment_params
		self._environment_params.dof_enabled = arg_2_1.dof_enabled
		self._environment_params.focal_distance = arg_2_1.focal_distance
		self._environment_params.focal_region = arg_2_1.focal_region
		self._environment_params.focal_padding = arg_2_1.focal_padding
		self._environment_params.focal_scale = arg_2_1.focal_scale
	end

	local yaw_origin = arg_2_1.yaw_origin

	yaw_origin = not yaw_origin and arg_2_1.yaw_origin * math.pi / 180
	self._yaw_origin = yaw_origin

	local pitch_origin = arg_2_1.pitch_origin

	pitch_origin = not pitch_origin and arg_2_1.pitch_origin * math.pi / 180
	self._pitch_origin = pitch_origin

	local constraint = arg_2_1.constraint

	constraint = constraint or arg_2_2:constraint_function()
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
	local identity = Matrix4x4.identity()

	Matrix4x4.set_translation(identity, self:position())
	Matrix4x4.set_rotation(identity, self:rotation())

	return identity
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

	_vertical_fov = _vertical_fov or self._parent_node:vertical_fov()

	return _vertical_fov
end

BaseCamera.fade_to_black = function (self)
	-- function 19
	local _fade_to_black = self._fade_to_black

	_fade_to_black = _fade_to_black or self._parent_node:fade_to_black()

	return _fade_to_black
end

BaseCamera.shading_environment = function (self)
	-- function 20
	local _environment_params = self._environment_params

	if not _environment_params then
		_environment_params = self._parent_node
		_environment_params = not _environment_params and self._parent_node:shading_environment()
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

BaseCamera.set_parent_node = function (self, arg_30_1)
	-- function 30
	self._parent_node = arg_30_1
end

BaseCamera.add_child_node = function (arg_31_0, arg_31_1)
	-- function 31
	arg_31_0._children[#arg_31_0._children + 1] = arg_31_1

	arg_31_1:set_parent_node(arg_31_0)
end

BaseCamera.set_active = function (self, arg_32_1)
	-- function 32
	local active = self:active()

	if not arg_32_1 then
		self._active = self._active + 1
	else
		self._active = self._active - 1
	end

	local active_2 = self:active()

	if not (not self._parent_node and active == active_2) then
		self._parent_node:set_active_child(active_2)
	end
end

BaseCamera.active = function (self)
	-- function 33
	return self._active > 0 or self._active_children > 0
end

BaseCamera.set_active_child = function (self, arg_34_1)
	-- function 34
	local active = self:active()

	if not arg_34_1 then
		self._active_children = self._active_children + 1
	else
		self._active_children = self._active_children - 1
	end

	local active_2 = self:active()

	if not (not self._parent_node and active == active_2) then
		self._parent_node:set_active_child(active_2)
	end
end

BaseCamera.set_root_unit = function (self, arg_35_1, arg_35_2)
	-- function 35
	self._root_unit = arg_35_1
	arg_35_2 = arg_35_2 or self._object_name
	self._root_object = Unit.node(arg_35_1, arg_35_2)

	for i, v in ipairs(self._children) do
		v:set_root_unit(arg_35_1, arg_35_2)
	end
end

BaseCamera.root_unit = function (self)
	-- function 36
	return self._root_unit, self._object_name
end

BaseCamera.set_root_position = function (self, arg_37_1)
	-- function 37
	self._root_position:store(arg_37_1)

	for i, v in ipairs(self._children) do
		v:set_root_position(arg_37_1)
	end
end

BaseCamera.set_root_rotation = function (self, arg_38_1)
	-- function 38
	self._root_rotation:store(arg_38_1)

	for i, v in ipairs(self._children) do
		v:set_root_rotation(arg_38_1)
	end
end

BaseCamera.set_root_vertical_fov = function (self, arg_39_1)
	-- function 39
	self._vertical_fov = arg_39_1

	for i, v in ipairs(self._children) do
		v:set_root_vertical_fov(arg_39_1)
	end
end

BaseCamera.set_root_near_range = function (self, arg_40_1)
	-- function 40
	self._near_range = arg_40_1

	for i, v in ipairs(self._children) do
		v:set_root_near_range(arg_40_1)
	end
end

BaseCamera.set_root_far_range = function (self, arg_41_1)
	-- function 41
	self._far_range = arg_41_1

	for i, v in ipairs(self._children) do
		v:set_root_far_range(arg_41_1)
	end
end

BaseCamera.set_root_dof_enabled = function (self, arg_42_1)
	-- function 42
	self._environment_params.dof_enabled = arg_42_1

	for i, v in ipairs(self._children) do
		v:set_root_dof_enabled(arg_42_1)
	end
end

BaseCamera.set_root_focal_distance = function (self, arg_43_1)
	-- function 43
	self._environment_params.focal_distance = arg_43_1

	for i, v in ipairs(self._children) do
		v:set_root_focal_distance(arg_43_1)
	end
end

BaseCamera.set_root_focal_region = function (self, arg_44_1)
	-- function 44
	self._environment_params.focal_region = arg_44_1

	for i, v in ipairs(self._children) do
		v:set_root_focal_region(arg_44_1)
	end
end

BaseCamera.set_root_focal_padding = function (self, arg_45_1)
	-- function 45
	self._environment_params.focal_padding = arg_45_1

	for i, v in ipairs(self._children) do
		v:set_root_focal_padding(arg_45_1)
	end
end

BaseCamera.set_root_focal_scale = function (self, arg_46_1)
	-- function 46
	self._environment_params.focal_scale = arg_46_1

	for i, v in ipairs(self._children) do
		v:set_root_focal_scale(arg_46_1)
	end
end

BaseCamera.update = function (self, arg_47_1, arg_47_2, arg_47_3, arg_47_4)
	-- function 47
	assert(Vector3.is_valid(arg_47_2), "Trying to set invalid camera position")
	self._position:store(arg_47_2)
	self._rotation:store(arg_47_3)

	if not script_data.camera_debug and not Managers.state.debug then
		self:_debug_draw()
	end

	for i, v in ipairs(self._children) do
		if not v:active() then
			v:update(arg_47_1, arg_47_2, arg_47_3, arg_47_4)
		end
	end
end

BaseCamera.destroy = function (self)
	-- function 48
	for i, v in ipairs(self._children) do
		v:destroy()
	end

	self._children = {}
	self._parent_node = nil
end

BaseCamera._debug_draw = function (self)
	-- function 49
	local _parent_node = self._parent_node

	_parent_node = not _parent_node and self._parent_node:position()

	local _position = self._position
	local _rotation = self._rotation
	local drawer = Managers.state.debug:drawer({
		name = "CAMERA_DEBUG_DRAW" .. self:name()
	})

	if not DebugKeyHandler.key_pressed("z", "clear camera debug") then
		drawer:reset()
	end

	if not _parent_node then
		drawer:vector(_parent_node, _position:unbox() - _parent_node, Color(70, 255, 255, 255))
	end

	drawer:quaternion(_position:unbox(), _rotation:unbox())
end
