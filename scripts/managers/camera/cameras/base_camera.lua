-- chunkname: @scripts/managers/camera/cameras/base_camera.lua

BaseCamera = class(BaseCamera)

function BaseCamera.init(arg_1_0, arg_1_1)
	arg_1_0._root_node = arg_1_1
	arg_1_0._children = {}
	arg_1_0._name = ""
	arg_1_0._root_unit = nil
	arg_1_0._root_object = nil
	arg_1_0._root_position = Vector3Box()
	arg_1_0._root_rotation = QuaternionBox()
	arg_1_0._position = Vector3Box()
	arg_1_0._rotation = QuaternionBox()
	arg_1_0._vertical_fov = nil
	arg_1_0._near_range = nil
	arg_1_0._far_range = nil
	arg_1_0._pitch_offset = nil
	arg_1_0._active = 0
	arg_1_0._active_children = 0
end

function BaseCamera.parse_parameters(arg_2_0, arg_2_1, arg_2_2)
	if arg_2_1.name then
		arg_2_0._name = arg_2_1.name
	end

	local var_2_0 = math.pi / 180

	arg_2_0._fade_to_black = arg_2_1.fade_to_black
	arg_2_0._vertical_fov = arg_2_1.vertical_fov and arg_2_1.vertical_fov * var_2_0
	arg_2_0._should_apply_fov_multiplier = arg_2_1.should_apply_fov_multiplier or arg_2_2:should_apply_fov_multiplier()
	arg_2_0._default_fov = arg_2_1.default_fov and arg_2_1.default_fov * var_2_0 or arg_2_2:default_fov()
	arg_2_0._near_range = arg_2_1.near_range or arg_2_2:near_range()
	arg_2_0._far_range = arg_2_1.far_range or arg_2_2:far_range()
	arg_2_0._pitch_min = arg_2_1.pitch_min and arg_2_1.pitch_min * var_2_0 or arg_2_2:pitch_min()
	arg_2_0._pitch_max = arg_2_1.pitch_max and arg_2_1.pitch_max * var_2_0 or arg_2_2:pitch_max()
	arg_2_0._pitch_speed = arg_2_1.pitch_speed and arg_2_1.pitch_speed * var_2_0 or arg_2_2:pitch_speed()
	arg_2_0._yaw_speed = arg_2_1.yaw_speed and arg_2_1.yaw_speed * var_2_0 or arg_2_2:yaw_speed()
	arg_2_0._pitch_offset = arg_2_1.pitch_offset and arg_2_1.pitch_offset * var_2_0 or arg_2_2:pitch_offset()
	arg_2_0._safe_position_offset = arg_2_1.safe_position_offset or arg_2_2:safe_position_offset()
	arg_2_0._tree_transitions = arg_2_1.tree_transitions or arg_2_2:tree_transitions()
	arg_2_0._node_transitions = arg_2_1.node_transitions or arg_2_2:node_transitions()

	if arg_2_1.dof_enabled then
		arg_2_0._environment_params = arg_2_0._environment_params or {}
		arg_2_0._environment_params.dof_enabled = arg_2_1.dof_enabled
		arg_2_0._environment_params.focal_distance = arg_2_1.focal_distance
		arg_2_0._environment_params.focal_region = arg_2_1.focal_region
		arg_2_0._environment_params.focal_padding = arg_2_1.focal_padding
		arg_2_0._environment_params.focal_scale = arg_2_1.focal_scale
	end

	arg_2_0._yaw_origin = arg_2_1.yaw_origin and arg_2_1.yaw_origin * math.pi / 180
	arg_2_0._pitch_origin = arg_2_1.pitch_origin and arg_2_1.pitch_origin * math.pi / 180
	arg_2_0._constraint_function = arg_2_1.constraint or arg_2_2:constraint_function()
end

function BaseCamera.should_apply_fov_multiplier(arg_3_0)
	return arg_3_0._should_apply_fov_multiplier
end

function BaseCamera.default_fov(arg_4_0)
	return arg_4_0._default_fov
end

function BaseCamera.constraint_function(arg_5_0)
	return arg_5_0._constraint_function
end

function BaseCamera.node_transitions(arg_6_0)
	return arg_6_0._node_transitions
end

function BaseCamera.tree_transitions(arg_7_0)
	return arg_7_0._tree_transitions
end

function BaseCamera.safe_position_offset(arg_8_0)
	return arg_8_0._safe_position_offset
end

function BaseCamera.pitch_offset(arg_9_0)
	return arg_9_0._pitch_offset
end

function BaseCamera.pitch_speed(arg_10_0)
	return arg_10_0._pitch_speed
end

function BaseCamera.yaw_speed(arg_11_0)
	return arg_11_0._yaw_speed
end

function BaseCamera.pitch_min(arg_12_0)
	return arg_12_0._pitch_min
end

function BaseCamera.pitch_max(arg_13_0)
	return arg_13_0._pitch_max
end

function BaseCamera.name(arg_14_0)
	return arg_14_0._name
end

function BaseCamera.pose(arg_15_0)
	local var_15_0 = Matrix4x4.identity()

	Matrix4x4.set_translation(var_15_0, arg_15_0:position())
	Matrix4x4.set_rotation(var_15_0, arg_15_0:rotation())

	return var_15_0
end

function BaseCamera.position(arg_16_0)
	return arg_16_0._position:unbox()
end

function BaseCamera.rotation(arg_17_0)
	return arg_17_0._rotation:unbox()
end

function BaseCamera.vertical_fov(arg_18_0)
	return arg_18_0._vertical_fov or arg_18_0._parent_node:vertical_fov()
end

function BaseCamera.fade_to_black(arg_19_0)
	return arg_19_0._fade_to_black or arg_19_0._parent_node:fade_to_black()
end

function BaseCamera.shading_environment(arg_20_0)
	return arg_20_0._environment_params or arg_20_0._parent_node and arg_20_0._parent_node:shading_environment()
end

function BaseCamera.near_range(arg_21_0)
	return arg_21_0._near_range
end

function BaseCamera.far_range(arg_22_0)
	return arg_22_0._far_range
end

function BaseCamera.dof_enabled(arg_23_0)
	return arg_23_0._environment_params.dof_enabled
end

function BaseCamera.focal_distance(arg_24_0)
	return arg_24_0._environment_params.focal_distance
end

function BaseCamera.focal_region(arg_25_0)
	return arg_25_0._environment_params.focal_region
end

function BaseCamera.focal_padding(arg_26_0)
	return arg_26_0._environment_params.focal_padding
end

function BaseCamera.focal_scale(arg_27_0)
	return arg_27_0._environment_params.focal_scale
end

function BaseCamera.parent_node(arg_28_0)
	return arg_28_0._parent_node
end

function BaseCamera.root_node(arg_29_0)
	return arg_29_0._root_node
end

function BaseCamera.set_parent_node(arg_30_0, arg_30_1)
	arg_30_0._parent_node = arg_30_1
end

function BaseCamera.add_child_node(arg_31_0, arg_31_1)
	arg_31_0._children[#arg_31_0._children + 1] = arg_31_1

	arg_31_1:set_parent_node(arg_31_0)
end

function BaseCamera.set_active(arg_32_0, arg_32_1)
	local var_32_0 = arg_32_0:active()

	if arg_32_1 then
		arg_32_0._active = arg_32_0._active + 1
	else
		arg_32_0._active = arg_32_0._active - 1
	end

	local var_32_1 = arg_32_0:active()

	if arg_32_0._parent_node and var_32_0 ~= var_32_1 then
		arg_32_0._parent_node:set_active_child(var_32_1)
	end
end

function BaseCamera.active(arg_33_0)
	return arg_33_0._active > 0 or arg_33_0._active_children > 0
end

function BaseCamera.set_active_child(arg_34_0, arg_34_1)
	local var_34_0 = arg_34_0:active()

	if arg_34_1 then
		arg_34_0._active_children = arg_34_0._active_children + 1
	else
		arg_34_0._active_children = arg_34_0._active_children - 1
	end

	local var_34_1 = arg_34_0:active()

	if arg_34_0._parent_node and var_34_0 ~= var_34_1 then
		arg_34_0._parent_node:set_active_child(var_34_1)
	end
end

function BaseCamera.set_root_unit(arg_35_0, arg_35_1, arg_35_2)
	arg_35_0._root_unit = arg_35_1
	arg_35_2 = arg_35_2 or arg_35_0._object_name
	arg_35_0._root_object = Unit.node(arg_35_1, arg_35_2)

	for iter_35_0, iter_35_1 in ipairs(arg_35_0._children) do
		iter_35_1:set_root_unit(arg_35_1, arg_35_2)
	end
end

function BaseCamera.root_unit(arg_36_0)
	return arg_36_0._root_unit, arg_36_0._object_name
end

function BaseCamera.set_root_position(arg_37_0, arg_37_1)
	arg_37_0._root_position:store(arg_37_1)

	for iter_37_0, iter_37_1 in ipairs(arg_37_0._children) do
		iter_37_1:set_root_position(arg_37_1)
	end
end

function BaseCamera.set_root_rotation(arg_38_0, arg_38_1)
	arg_38_0._root_rotation:store(arg_38_1)

	for iter_38_0, iter_38_1 in ipairs(arg_38_0._children) do
		iter_38_1:set_root_rotation(arg_38_1)
	end
end

function BaseCamera.set_root_vertical_fov(arg_39_0, arg_39_1)
	arg_39_0._vertical_fov = arg_39_1

	for iter_39_0, iter_39_1 in ipairs(arg_39_0._children) do
		iter_39_1:set_root_vertical_fov(arg_39_1)
	end
end

function BaseCamera.set_root_near_range(arg_40_0, arg_40_1)
	arg_40_0._near_range = arg_40_1

	for iter_40_0, iter_40_1 in ipairs(arg_40_0._children) do
		iter_40_1:set_root_near_range(arg_40_1)
	end
end

function BaseCamera.set_root_far_range(arg_41_0, arg_41_1)
	arg_41_0._far_range = arg_41_1

	for iter_41_0, iter_41_1 in ipairs(arg_41_0._children) do
		iter_41_1:set_root_far_range(arg_41_1)
	end
end

function BaseCamera.set_root_dof_enabled(arg_42_0, arg_42_1)
	arg_42_0._environment_params.dof_enabled = arg_42_1

	for iter_42_0, iter_42_1 in ipairs(arg_42_0._children) do
		iter_42_1:set_root_dof_enabled(arg_42_1)
	end
end

function BaseCamera.set_root_focal_distance(arg_43_0, arg_43_1)
	arg_43_0._environment_params.focal_distance = arg_43_1

	for iter_43_0, iter_43_1 in ipairs(arg_43_0._children) do
		iter_43_1:set_root_focal_distance(arg_43_1)
	end
end

function BaseCamera.set_root_focal_region(arg_44_0, arg_44_1)
	arg_44_0._environment_params.focal_region = arg_44_1

	for iter_44_0, iter_44_1 in ipairs(arg_44_0._children) do
		iter_44_1:set_root_focal_region(arg_44_1)
	end
end

function BaseCamera.set_root_focal_padding(arg_45_0, arg_45_1)
	arg_45_0._environment_params.focal_padding = arg_45_1

	for iter_45_0, iter_45_1 in ipairs(arg_45_0._children) do
		iter_45_1:set_root_focal_padding(arg_45_1)
	end
end

function BaseCamera.set_root_focal_scale(arg_46_0, arg_46_1)
	arg_46_0._environment_params.focal_scale = arg_46_1

	for iter_46_0, iter_46_1 in ipairs(arg_46_0._children) do
		iter_46_1:set_root_focal_scale(arg_46_1)
	end
end

function BaseCamera.update(arg_47_0, arg_47_1, arg_47_2, arg_47_3, arg_47_4)
	assert(Vector3.is_valid(arg_47_2), "Trying to set invalid camera position")
	arg_47_0._position:store(arg_47_2)
	arg_47_0._rotation:store(arg_47_3)

	if script_data.camera_debug and Managers.state.debug then
		arg_47_0:_debug_draw()
	end

	for iter_47_0, iter_47_1 in ipairs(arg_47_0._children) do
		if iter_47_1:active() then
			iter_47_1:update(arg_47_1, arg_47_2, arg_47_3, arg_47_4)
		end
	end
end

function BaseCamera.destroy(arg_48_0)
	for iter_48_0, iter_48_1 in ipairs(arg_48_0._children) do
		iter_48_1:destroy()
	end

	arg_48_0._children = {}
	arg_48_0._parent_node = nil
end

function BaseCamera._debug_draw(arg_49_0)
	local var_49_0 = arg_49_0._parent_node and arg_49_0._parent_node:position()
	local var_49_1 = arg_49_0._position
	local var_49_2 = arg_49_0._rotation
	local var_49_3 = Managers.state.debug:drawer({
		name = "CAMERA_DEBUG_DRAW" .. arg_49_0:name()
	})

	if DebugKeyHandler.key_pressed("z", "clear camera debug") then
		var_49_3:reset()
	end

	if var_49_0 then
		var_49_3:vector(var_49_0, var_49_1:unbox() - var_49_0, Color(70, 255, 255, 255))
	end

	var_49_3:quaternion(var_49_1:unbox(), var_49_2:unbox())
end
