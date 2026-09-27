-- chunkname: @scripts/unit_extensions/camera/states/camera_state_interaction.lua

CameraStateInteraction = class(CameraStateInteraction, CameraState)

CameraStateInteraction.init = function (arg_1_0, arg_1_1)
	-- function 1
	CameraState.init(arg_1_0, arg_1_1, "camera_state_interaction")
end

CameraStateInteraction.on_enter = function (self, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5, arg_2_6, arg_2_7)
	-- function 2
	local camera_interaction_name = arg_2_7.camera_interaction_name
	local world = Managers.world

	if not world:has_world("level_world") then
		local var_2_2
		local world_2 = world:world("level_world")
		local get_current_level_key = Managers.level_transition_handler:get_current_level_key()
		local level_name = LevelSettings[get_current_level_key].level_name
		local level = ScriptWorld.level(world_2, level_name)

		if not level then
			local units = Level.units(level)

			for i, v in ipairs(units) do
				if not (not Unit.has_data(v, "camera_interaction_name") and Unit.get_data(v, "camera_interaction_name") ~= camera_interaction_name) then
					var_2_2 = v

					break
				end
			end
		end

		self.camera_target_unit = var_2_2
		self.total_lerp_time = UISettings.map.camera_time_enter
		self.lerp_time = 0
		self.progress = 0
		self.calculate_lerp = true
		self.camera_start_pose = Matrix4x4Box(Unit.world_pose(arg_2_1, 0))
	end
end

CameraStateInteraction.on_exit = function (self, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5, arg_3_6)
	-- function 3
	self.camera_target_unit = nil
end

CameraStateInteraction.update = function (self, arg_4_1, arg_4_2, arg_4_3, arg_4_4, arg_4_5)
	-- function 4
	local csm = self.csm
	local unit = self.unit
	local camera_extension = self.camera_extension
	local camera_target_unit = self.camera_target_unit

	if not Unit.alive(camera_target_unit) then
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

	if not self.calculate_lerp and not camera_target_unit then
		local total_lerp_time = self.total_lerp_time
		local lerp_time = self.lerp_time
		local progress = self.progress
		local min = math.min(lerp_time + arg_4_3, total_lerp_time)
		local num = min / total_lerp_time
		local smoothstep = math.smoothstep(num, 0, 1)
		local world_pose = Unit.world_pose(camera_target_unit, 0)
		local unbox = self.camera_start_pose:unbox()
		local lerp = Matrix4x4.lerp(unbox, world_pose, smoothstep)

		assert(Matrix4x4.is_valid(lerp), "Camera lerp pose invalid.")
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
