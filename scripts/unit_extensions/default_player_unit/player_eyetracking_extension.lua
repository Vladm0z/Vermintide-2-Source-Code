-- chunkname: @scripts/unit_extensions/default_player_unit/player_eyetracking_extension.lua

PlayerEyeTrackingExtension = class(PlayerEyeTrackingExtension)

PlayerEyeTrackingExtension.init = function (self, arg_1_1, arg_1_2, arg_1_3)
	-- function 1
	self.world = arg_1_1.world
	self.physics_world = World.get_data(self.world, "physics_world")
	self.unit = arg_1_2
	self.current_gaze_forward = Vector3Box()

	self.current_gaze_forward:store(Vector3.forward())

	self.is_aiming = false
	self.is_aiming_cancelled = false
	self.extended_view = {
		pitch = 0,
		yaw = 0
	}
	self.aim_fade_out_time = 0.4
	self.current_fade_out_time = 0
	self.time_since_last_gaze_point = 100
	self.eyetracking_options_opened = false
	self.is_connected = true

	if not rawget(_G, "Tobii") then
		local user_setting = Application.user_setting("tobii_extended_view_sensitivity")

		if user_setting ~= nil then
			Tobii.set_extended_view_responsiveness(user_setting / 100)
		end

		local user_setting_2 = Application.user_setting("tobii_extended_view_use_head_tracking")

		if user_setting_2 ~= nil then
			Tobii.set_extended_view_use_head_tracking(user_setting_2)
		end
	end
end

PlayerEyeTrackingExtension.update = function (self, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5)
	-- function 2
	if not (not rawget(_G, "Tobii") and Application.user_setting("tobii_eyetracking")) then
		return
	end

	self.is_connected = Tobii.get_is_connected()

	if not self.is_connected then
		return
	end

	self:update_extended_view(arg_2_3)
	self:update_forward_rayhit()
	self:calc_gaze_forward()
end

PlayerEyeTrackingExtension.set_eyetracking_options_opened = function (self, arg_3_1)
	-- function 3
	self.eyetracking_options_opened = arg_3_1
end

PlayerEyeTrackingExtension.update_extended_view = function (self, arg_4_1)
	-- function 4
	if not self.is_aiming then
		self.current_fade_out_time = self.current_fade_out_time + arg_4_1

		if self.current_fade_out_time > self.aim_fade_out_time then
			self.current_fade_out_time = self.aim_fade_out_time
		end
	else
		self.current_fade_out_time = self.current_fade_out_time - arg_4_1

		if self.current_fade_out_time < 0 then
			self.current_fade_out_time = 0
		end

		local get_extended_view, var_4_1 = Tobii.get_extended_view()

		self.extended_view.yaw = get_extended_view
		self.extended_view.pitch = var_4_1
	end

	self.extended_view.yaw = self.extended_view.yaw * (1 - self.current_fade_out_time / self.aim_fade_out_time)
	self.extended_view.pitch = self.extended_view.pitch * (1 - self.current_fade_out_time / self.aim_fade_out_time)

	local flag = not Managers.input:get_service("Player"):is_blocked()
	local system = Managers.state.entity:system("cutscene_system")

	if not (self.eyetracking_options_opened or not flag or not system or not system.active_camera or system.ingame_hud_enabled) then
		self.extended_view.yaw = 0.15 * self.extended_view.yaw
		self.extended_view.pitch = 0.15 * self.extended_view.pitch
	end

	if not system and not system.active_camera then
		self.extended_view.yaw = 0
		self.extended_view.pitch = 0
	end

	Managers.state.camera:set_tobii_extended_view(self.extended_view.yaw, self.extended_view.pitch)
end

PlayerEyeTrackingExtension.get_extended_view = function (self, arg_5_1)
	-- function 5
	return self.extended_view.yaw, self.extended_view.pitch
end

PlayerEyeTrackingExtension.get_direction_without_extended_view = function (self, arg_6_1)
	-- function 6
	if not Application.user_setting("tobii_extended_view") then
		return arg_6_1
	end

	local var_6_0 = Quaternion(Vector3.up(), self.extended_view.yaw)
	local multiply = Quaternion.multiply(Quaternion.inverse(arg_6_1), var_6_0)
	local multiply_2 = Quaternion.multiply(multiply, arg_6_1)
	local var_6_3 = Quaternion(Vector3.right(), -self.extended_view.pitch)
	local multiply_3 = Quaternion.multiply(multiply_2, var_6_3)

	return Quaternion.multiply(arg_6_1, multiply_3)
end

PlayerEyeTrackingExtension.update_forward_rayhit = function (self)
	-- function 7
	local extension = ScriptUnit.extension(self.unit, "first_person_system")
	local current_position = extension:current_position()
	local current_rotation = extension:current_rotation()
	local forward = Quaternion.forward(current_rotation)
	local immediate_raycast, var_7_5 = self.physics_world:immediate_raycast(current_position + forward, forward, 100, "closest", "collision_filter", "filter_ray_ping")

	if not immediate_raycast then
		var_7_5 = current_position + forward * 100
	end

	if not self.forward_rayhit_position then
		self.forward_rayhit_position:store(var_7_5)
	else
		self.forward_rayhit_position = Vector3Box(var_7_5)
	end
end

PlayerEyeTrackingExtension.update_gaze_rayhit = function (self)
	-- function 8
	local current_position = ScriptUnit.extension(self.unit, "first_person_system"):current_position()
	local gaze_forward = self:gaze_forward()
	local immediate_raycast, var_8_3 = self.physics_world:immediate_raycast(current_position + gaze_forward, gaze_forward, 100, "closest", "collision_filter", "filter_ray_ping")

	if not immediate_raycast then
		var_8_3 = current_position + gaze_forward * 100
	end

	if not self.gaze_rayhit_position then
		self.gaze_rayhit_position:store(var_8_3)
	else
		self.gaze_rayhit_position = Vector3Box(var_8_3)
	end
end

PlayerEyeTrackingExtension.calc_gaze_forward = function (self)
	-- function 9
	local extension = ScriptUnit.extension(self.unit, "first_person_system")
	local get_gaze_point, var_9_2 = Tobii.get_gaze_point()
	local res_w = RESOLUTION_LOOKUP.res_w
	local res_h = RESOLUTION_LOOKUP.res_h
	local num = res_w * (1 + get_gaze_point) * 0.5
	local num_2 = res_h * (1 + var_9_2) * 0.5
	local viewport_name = Managers.player:owner(self.unit).viewport_name
	local viewport = ScriptWorld.viewport(self.world, viewport_name)
	local camera = ScriptViewport.camera(viewport)
	local screen_to_world = Camera.screen_to_world(camera, Vector3(num, num_2, 0), 0.1)
	local current_position = extension:current_position()
	local normalize = Vector3.normalize(screen_to_world - current_position)

	self.current_gaze_forward:store(normalize)
end

PlayerEyeTrackingExtension.gaze_forward = function (self)
	-- function 10
	return self.current_gaze_forward:unbox()
end

PlayerEyeTrackingExtension.gaze_rotation = function (self)
	-- function 11
	local gaze_forward = self:gaze_forward()

	return Quaternion.look(gaze_forward, Vector3.up())
end

PlayerEyeTrackingExtension.get_forward_rayhit = function (self)
	-- function 12
	local unbox

	if not self.forward_rayhit_position then
		unbox = self.forward_rayhit_position:unbox()

		if not unbox then
			-- Nothing
		end
	end

	unbox = nil

	::label_12_0::

	return unbox
end

PlayerEyeTrackingExtension.get_gaze_rayhit = function (self)
	-- function 13
	self:update_gaze_rayhit()

	local unbox

	if not self.gaze_rayhit_position then
		unbox = self.gaze_rayhit_position:unbox()

		if not unbox then
			-- Nothing
		end
	end

	unbox = nil

	::label_13_0::

	return unbox
end

PlayerEyeTrackingExtension.get_is_aiming = function (self)
	-- function 14
	return self.is_aiming
end

PlayerEyeTrackingExtension.set_is_aiming = function (self, arg_15_1)
	-- function 15
	self.is_aiming = arg_15_1
end

PlayerEyeTrackingExtension.get_aim_at_gaze_cancelled = function (self)
	-- function 16
	return self.is_aiming_cancelled
end

PlayerEyeTrackingExtension.set_aim_at_gaze_cancelled = function (self, arg_17_1)
	-- function 17
	self.is_aiming_cancelled = arg_17_1
end

PlayerEyeTrackingExtension.get_is_feature_enabled = function (self, arg_18_1)
	-- function 18
	local var_18_0 = rawget(_G, "Tobii")

	var_18_0 = not var_18_0 and Application.user_setting("tobii_eyetracking")

	if not var_18_0 then
		-- Nothing
	end

	::label_18_0::

	local is_connected = self.is_connected

	if not is_connected then
		is_connected = Application.user_setting(arg_18_1)
		is_connected = not is_connected and Tobii.get_time_since_last_gaze_point() < 5
	end

	::label_18_1::

	return is_connected
end

PlayerEyeTrackingExtension.get_is_connected = function (self)
	-- function 19
	return self.is_connected
end
