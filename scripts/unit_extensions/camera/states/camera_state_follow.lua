-- chunkname: @scripts/unit_extensions/camera/states/camera_state_follow.lua

CameraStateFollow = class(CameraStateFollow, CameraState)

CameraStateFollow.init = function (self, arg_1_1)
	-- function 1
	CameraState.init(self, arg_1_1, "follow")

	self._follow_unit = nil
	self._follow_node = 0
end

CameraStateFollow.on_enter = function (self, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5, arg_2_6, arg_2_7)
	-- function 2
	local get_follow_data, var_2_1 = self.camera_extension:get_follow_data()

	self._follow_unit = get_follow_data
	self._follow_node = var_2_1

	Unit.set_data(arg_2_1, "camera", "settings_node", "first_person_node")

	local current_mechanism_name = Managers.mechanism:current_mechanism_name()

	if not (arg_2_6 == "camera_state_interaction" or current_mechanism_name ~= "versus" or arg_2_6 ~= "observer") then
		self.total_lerp_time = UISettings.map.camera_time_exit
		self.lerp_time = 0
		self.progress = 0
		self.calculate_lerp = true
		self.camera_start_pose = Matrix4x4Box(Unit.world_pose(arg_2_1, 0))
	end
end

CameraStateFollow.on_exit = function (self, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5, arg_3_6)
	-- function 3
	self._follow_unit = nil
end

CameraStateFollow.update = function (self, arg_4_1, arg_4_2, arg_4_3, arg_4_4, arg_4_5)
	-- function 4
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

	if not self.calculate_lerp then
		local total_lerp_time = self.total_lerp_time
		local lerp_time = self.lerp_time
		local progress = self.progress
		local min = math.min(lerp_time + arg_4_3, total_lerp_time)
		local num = min / total_lerp_time
		local smoothstep = math.smoothstep(num, 0, 1)
		local world_pose = Unit.world_pose(_follow_unit, 0)
		local unbox = self.camera_start_pose:unbox()
		local lerp = Matrix4x4.lerp(unbox, world_pose, smoothstep)

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
	end
end
