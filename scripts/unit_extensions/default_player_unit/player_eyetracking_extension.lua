-- chunkname: @scripts/unit_extensions/default_player_unit/player_eyetracking_extension.lua

PlayerEyeTrackingExtension = class(PlayerEyeTrackingExtension)

function PlayerEyeTrackingExtension.init(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
	arg_1_0.world = arg_1_1.world
	arg_1_0.physics_world = World.get_data(arg_1_0.world, "physics_world")
	arg_1_0.unit = arg_1_2
	arg_1_0.current_gaze_forward = Vector3Box()

	arg_1_0.current_gaze_forward:store(Vector3.forward())

	arg_1_0.is_aiming = false
	arg_1_0.is_aiming_cancelled = false
	arg_1_0.extended_view = {
		pitch = 0,
		yaw = 0
	}
	arg_1_0.aim_fade_out_time = 0.4
	arg_1_0.current_fade_out_time = 0
	arg_1_0.time_since_last_gaze_point = 100
	arg_1_0.eyetracking_options_opened = false
	arg_1_0.is_connected = true

	if rawget(_G, "Tobii") then
		local var_1_0 = Application.user_setting("tobii_extended_view_sensitivity")

		if var_1_0 ~= nil then
			Tobii.set_extended_view_responsiveness(var_1_0 / 100)
		end

		local var_1_1 = Application.user_setting("tobii_extended_view_use_head_tracking")

		if var_1_1 ~= nil then
			Tobii.set_extended_view_use_head_tracking(var_1_1)
		end
	end
end

function PlayerEyeTrackingExtension.update(arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5)
	if not rawget(_G, "Tobii") or not Application.user_setting("tobii_eyetracking") then
		return
	end

	arg_2_0.is_connected = Tobii.get_is_connected()

	if not arg_2_0.is_connected then
		return
	end

	arg_2_0:update_extended_view(arg_2_3)
	arg_2_0:update_forward_rayhit()
	arg_2_0:calc_gaze_forward()
end

function PlayerEyeTrackingExtension.set_eyetracking_options_opened(arg_3_0, arg_3_1)
	arg_3_0.eyetracking_options_opened = arg_3_1
end

function PlayerEyeTrackingExtension.update_extended_view(arg_4_0, arg_4_1)
	if arg_4_0.is_aiming then
		arg_4_0.current_fade_out_time = arg_4_0.current_fade_out_time + arg_4_1

		if arg_4_0.current_fade_out_time > arg_4_0.aim_fade_out_time then
			arg_4_0.current_fade_out_time = arg_4_0.aim_fade_out_time
		end
	else
		arg_4_0.current_fade_out_time = arg_4_0.current_fade_out_time - arg_4_1

		if arg_4_0.current_fade_out_time < 0 then
			arg_4_0.current_fade_out_time = 0
		end

		local var_4_0, var_4_1 = Tobii.get_extended_view()

		arg_4_0.extended_view.yaw = var_4_0
		arg_4_0.extended_view.pitch = var_4_1
	end

	arg_4_0.extended_view.yaw = arg_4_0.extended_view.yaw * (1 - arg_4_0.current_fade_out_time / arg_4_0.aim_fade_out_time)
	arg_4_0.extended_view.pitch = arg_4_0.extended_view.pitch * (1 - arg_4_0.current_fade_out_time / arg_4_0.aim_fade_out_time)

	local var_4_2 = not Managers.input:get_service("Player"):is_blocked()
	local var_4_3 = Managers.state.entity:system("cutscene_system")

	if not arg_4_0.eyetracking_options_opened and (not var_4_2 or var_4_3 and var_4_3.active_camera and not var_4_3.ingame_hud_enabled) then
		arg_4_0.extended_view.yaw = 0.15 * arg_4_0.extended_view.yaw
		arg_4_0.extended_view.pitch = 0.15 * arg_4_0.extended_view.pitch
	end

	if var_4_3 and var_4_3.active_camera then
		arg_4_0.extended_view.yaw = 0
		arg_4_0.extended_view.pitch = 0
	end

	Managers.state.camera:set_tobii_extended_view(arg_4_0.extended_view.yaw, arg_4_0.extended_view.pitch)
end

function PlayerEyeTrackingExtension.get_extended_view(arg_5_0, arg_5_1)
	return arg_5_0.extended_view.yaw, arg_5_0.extended_view.pitch
end

function PlayerEyeTrackingExtension.get_direction_without_extended_view(arg_6_0, arg_6_1)
	if not Application.user_setting("tobii_extended_view") then
		return arg_6_1
	end

	local var_6_0 = Quaternion(Vector3.up(), arg_6_0.extended_view.yaw)
	local var_6_1 = Quaternion.multiply(Quaternion.inverse(arg_6_1), var_6_0)
	local var_6_2 = Quaternion.multiply(var_6_1, arg_6_1)
	local var_6_3 = Quaternion(Vector3.right(), -arg_6_0.extended_view.pitch)
	local var_6_4 = Quaternion.multiply(var_6_2, var_6_3)

	return Quaternion.multiply(arg_6_1, var_6_4)
end

function PlayerEyeTrackingExtension.update_forward_rayhit(arg_7_0)
	local var_7_0 = ScriptUnit.extension(arg_7_0.unit, "first_person_system")
	local var_7_1 = var_7_0:current_position()
	local var_7_2 = var_7_0:current_rotation()
	local var_7_3 = Quaternion.forward(var_7_2)
	local var_7_4, var_7_5 = arg_7_0.physics_world:immediate_raycast(var_7_1 + var_7_3, var_7_3, 100, "closest", "collision_filter", "filter_ray_ping")

	if not var_7_4 then
		var_7_5 = var_7_1 + var_7_3 * 100
	end

	if arg_7_0.forward_rayhit_position then
		arg_7_0.forward_rayhit_position:store(var_7_5)
	else
		arg_7_0.forward_rayhit_position = Vector3Box(var_7_5)
	end
end

function PlayerEyeTrackingExtension.update_gaze_rayhit(arg_8_0)
	local var_8_0 = ScriptUnit.extension(arg_8_0.unit, "first_person_system"):current_position()
	local var_8_1 = arg_8_0:gaze_forward()
	local var_8_2, var_8_3 = arg_8_0.physics_world:immediate_raycast(var_8_0 + var_8_1, var_8_1, 100, "closest", "collision_filter", "filter_ray_ping")

	if not var_8_2 then
		var_8_3 = var_8_0 + var_8_1 * 100
	end

	if arg_8_0.gaze_rayhit_position then
		arg_8_0.gaze_rayhit_position:store(var_8_3)
	else
		arg_8_0.gaze_rayhit_position = Vector3Box(var_8_3)
	end
end

function PlayerEyeTrackingExtension.calc_gaze_forward(arg_9_0)
	local var_9_0 = ScriptUnit.extension(arg_9_0.unit, "first_person_system")
	local var_9_1, var_9_2 = Tobii.get_gaze_point()
	local var_9_3 = RESOLUTION_LOOKUP.res_w
	local var_9_4 = RESOLUTION_LOOKUP.res_h
	local var_9_5 = var_9_3 * (1 + var_9_1) * 0.5
	local var_9_6 = var_9_4 * (1 + var_9_2) * 0.5
	local var_9_7 = Managers.player:owner(arg_9_0.unit).viewport_name
	local var_9_8 = ScriptWorld.viewport(arg_9_0.world, var_9_7)
	local var_9_9 = ScriptViewport.camera(var_9_8)
	local var_9_10 = Camera.screen_to_world(var_9_9, Vector3(var_9_5, var_9_6, 0), 0.1)
	local var_9_11 = var_9_0:current_position()
	local var_9_12 = Vector3.normalize(var_9_10 - var_9_11)

	arg_9_0.current_gaze_forward:store(var_9_12)
end

function PlayerEyeTrackingExtension.gaze_forward(arg_10_0)
	return arg_10_0.current_gaze_forward:unbox()
end

function PlayerEyeTrackingExtension.gaze_rotation(arg_11_0)
	local var_11_0 = arg_11_0:gaze_forward()

	return Quaternion.look(var_11_0, Vector3.up())
end

function PlayerEyeTrackingExtension.get_forward_rayhit(arg_12_0)
	return arg_12_0.forward_rayhit_position and arg_12_0.forward_rayhit_position:unbox() or nil
end

function PlayerEyeTrackingExtension.get_gaze_rayhit(arg_13_0)
	arg_13_0:update_gaze_rayhit()

	return arg_13_0.gaze_rayhit_position and arg_13_0.gaze_rayhit_position:unbox() or nil
end

function PlayerEyeTrackingExtension.get_is_aiming(arg_14_0)
	return arg_14_0.is_aiming
end

function PlayerEyeTrackingExtension.set_is_aiming(arg_15_0, arg_15_1)
	arg_15_0.is_aiming = arg_15_1
end

function PlayerEyeTrackingExtension.get_aim_at_gaze_cancelled(arg_16_0)
	return arg_16_0.is_aiming_cancelled
end

function PlayerEyeTrackingExtension.set_aim_at_gaze_cancelled(arg_17_0, arg_17_1)
	arg_17_0.is_aiming_cancelled = arg_17_1
end

function PlayerEyeTrackingExtension.get_is_feature_enabled(arg_18_0, arg_18_1)
	return rawget(_G, "Tobii") and Application.user_setting("tobii_eyetracking") and arg_18_0.is_connected and Application.user_setting(arg_18_1) and Tobii.get_time_since_last_gaze_point() < 5
end

function PlayerEyeTrackingExtension.get_is_connected(arg_19_0)
	return arg_19_0.is_connected
end
