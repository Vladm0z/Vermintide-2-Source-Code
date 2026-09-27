-- chunkname: @scripts/managers/camera/cameras/root_camera.lua

require("scripts/managers/camera/cameras/base_camera")

RootCamera = class(RootCamera, BaseCamera)

RootCamera.init = function (self)
	-- function 1
	BaseCamera.init(self, self)

	self._aim_pitch = 0
	self._aim_yaw = 0
	self._pitch_min = -math.huge
	self._pitch_max = math.huge
	self._environment_params = {}
end

RootCamera.set_root_unit = function (self, arg_2_1, arg_2_2, arg_2_3)
	-- function 2
	BaseCamera.set_root_unit(self, arg_2_1, arg_2_2)

	if not arg_2_3 then
		local world_rotation = Unit.world_rotation(arg_2_1, 0)
		local forward = Quaternion.forward(world_rotation)
		local var_2_2 = Vector3(forward.x, forward.y, 0)
		local normalize = Vector3.normalize(var_2_2)
		local atan2 = math.atan2(normalize.x, normalize.y)

		if not script_data.spawn_debug then
			Managers.state.debug:drawer({
				name = "spawn"
			}):quaternion(Unit.world_position(arg_2_1, 0), Unit.world_rotation(arg_2_1, 0), 1)
		end

		self._aim_yaw = -atan2
	end
end

RootCamera.parse_parameters = function (self, arg_3_1, arg_3_2)
	-- function 3
	if not arg_3_1.name then
		self._name = arg_3_1.name
	end

	local num = math.pi / 180
	local vertical_fov = arg_3_1.vertical_fov

	vertical_fov = not vertical_fov and arg_3_1.vertical_fov * num
	self._vertical_fov = vertical_fov

	local should_apply_fov_multiplier = arg_3_1.should_apply_fov_multiplier

	should_apply_fov_multiplier = should_apply_fov_multiplier or false
	self._should_apply_fov_multiplier = should_apply_fov_multiplier

	local num_2

	if not arg_3_1.default_fov then
		num_2 = arg_3_1.default_fov * num

		if not num_2 then
			-- Nothing
		end
	end

	num_2 = self._vertical_fov

	::label_3_0::

	self._default_fov = num_2
	self._near_range = arg_3_1.near_range
	self._far_range = arg_3_1.far_range

	local pitch_min = arg_3_1.pitch_min

	pitch_min = not pitch_min and arg_3_1.pitch_min * num
	self._pitch_min = pitch_min

	local pitch_max = arg_3_1.pitch_max

	pitch_max = not pitch_max and arg_3_1.pitch_max * num
	self._pitch_max = pitch_max

	local pitch_speed = arg_3_1.pitch_speed

	pitch_speed = not pitch_speed and arg_3_1.pitch_speed * num
	self._pitch_speed = pitch_speed

	local yaw_speed = arg_3_1.yaw_speed

	yaw_speed = not yaw_speed and arg_3_1.yaw_speed * num
	self._yaw_speed = yaw_speed

	local pitch_offset = arg_3_1.pitch_offset

	pitch_offset = not pitch_offset and arg_3_1.pitch_offset * num
	self._pitch_offset = pitch_offset
	self._safe_position_offset = arg_3_1.safe_position_offset
	self._tree_transitions = arg_3_1.tree_transitions
	self._node_transitions = arg_3_1.node_transitions

	local fade_to_black = arg_3_1.fade_to_black

	fade_to_black = fade_to_black or 0
	self._fade_to_black = fade_to_black

	if not arg_3_1.root_object_name then
		self._object_name = arg_3_1.root_object_name
	end
end

RootCamera.update = function (self, arg_4_1, arg_4_2, arg_4_3, arg_4_4)
	-- function 4
	if not self:active() then
		return
	end

	local var_4_0
	local var_4_1
	local _root_unit = self._root_unit
	local _root_object = self._root_object

	if not _root_unit and not Unit.alive(_root_unit) then
		var_4_0 = Unit.world_position(_root_unit, _root_object)
		var_4_1 = Unit.world_rotation(_root_unit, _root_object)

		self._root_position:store(var_4_0)
		self._root_rotation:store(var_4_1)
	else
		var_4_0 = self._root_position:unbox()
		var_4_1 = self._root_rotation:unbox()
	end

	BaseCamera.update(self, arg_4_1, var_4_0, var_4_1, arg_4_2)
end

RootCamera.update_pitch_yaw = function (self, arg_5_1, arg_5_2, arg_5_3)
	-- function 5
	local pitch_speed = arg_5_2.pitch_speed

	pitch_speed = pitch_speed or self._pitch_speed

	local yaw_speed = arg_5_2.yaw_speed

	yaw_speed = yaw_speed or self._yaw_speed

	local num = 1
	local num_2 = 1
	local var_5_4
	local unbox

	if not arg_5_2.look_controller_input then
		unbox = arg_5_2.look_controller_input:unbox()

		if not unbox then
			-- Nothing
		end
	end

	unbox = Vector3(0, 0, 0)

	::label_5_0::

	if not self._root_unit and not Unit.alive(self._root_unit) then
		num = 1
		num_2 = 1
		var_5_4 = Unit.get_data(self._root_unit, "camera", "dynamic_max_yaw_speed")
	end

	local var_5_6

	if not var_5_4 and not yaw_speed then
		local _accumulated_dt = self._accumulated_dt

		_accumulated_dt = _accumulated_dt or 0
		self._accumulated_dt = _accumulated_dt

		if math.abs(unbox.x) > 0 then
			local num_3 = var_5_4 * (self._accumulated_dt + arg_5_1)

			var_5_6 = math.clamp(unbox.x * yaw_speed * num_2, -num_3, num_3)
			self._accumulated_dt = 0
		else
			var_5_6 = 0
			self._accumulated_dt = self._accumulated_dt + arg_5_1

			if self._accumulated_dt > 0.1 then
				self._accumulated_dt = 0
			end
		end
	elseif not yaw_speed then
		self._accumulated_dt = 0
		var_5_6 = unbox.x * yaw_speed * num_2
	end

	local num_4 = unbox.y * pitch_speed * num
	local constraint_function = arg_5_3:constraint_function()

	if not constraint_function then
		local local_rotation = Unit.local_rotation(self._root_unit, 0)
		local forward = Quaternion.forward(local_rotation)
		local normalize = Vector3.normalize(Vector3.flat(forward))
		local atan2 = math.atan2(normalize.x, normalize.y)
		local num_5 = (atan2 + self._aim_yaw + math.pi) % (2 * math.pi) - math.pi
		local _aim_pitch = self._aim_pitch
		local var_5_17, var_5_18 = constraint_function(num_5, _aim_pitch, var_5_6, num_4)

		self._aim_yaw = (var_5_17 - atan2) % (2 * math.pi)

		if not var_5_18 then
			if not pitch_speed then
				self._aim_pitch = math.clamp(self._aim_pitch + num_4, self._pitch_min, self._pitch_max)
			end
		else
			self._aim_pitch = var_5_18
		end
	else
		if not pitch_speed then
			self._aim_pitch = math.clamp(self._aim_pitch + num_4, self._pitch_min, self._pitch_max)
		end

		if not yaw_speed then
			self._aim_yaw = (self._aim_yaw - var_5_6) % (2 * math.pi)
		end
	end
end

RootCamera.aim_pitch = function (self)
	-- function 6
	return self._aim_pitch
end

RootCamera.aim_yaw = function (self)
	-- function 7
	return self._aim_yaw
end

RootCamera.set_aim_pitch = function (self, arg_8_1)
	-- function 8
	self._aim_pitch = arg_8_1
end

RootCamera.set_aim_yaw = function (self, arg_9_1)
	-- function 9
	self._aim_yaw = arg_9_1
end
