-- chunkname: @scripts/unit_extensions/camera/states/camera_state_helper.lua

CameraStateHelper = CameraStateHelper or {}

CameraStateHelper.set_local_pose = function (arg_1_0, arg_1_1, arg_1_2)
	local var_1_0 = Unit.local_pose(arg_1_1, arg_1_2)
	local var_1_1 = arg_1_2

	assert(Matrix4x4.is_valid(var_1_0), "Camera unit pose invalid.")

	while var_1_1 ~= 0 do
		local var_1_2 = Unit.scene_graph_parent(arg_1_1, var_1_1)
		local var_1_3 = Unit.local_pose(arg_1_1, var_1_2)

		assert(Matrix4x4.is_valid(var_1_3), "Camera unit parent pose invalid.")

		var_1_0 = Matrix4x4.multiply(var_1_0, var_1_3)
		var_1_1 = var_1_2
	end

	Unit.set_local_pose(arg_1_0, 0, var_1_0)
end

local var_0_0 = math.pi / 2 - math.pi / 15

CameraStateHelper.set_camera_rotation = function (arg_2_0, arg_2_1)
	local var_2_0 = Managers.input
	local var_2_1 = Managers.state.camera
	local var_2_2 = var_2_0:get_service("Player")
	local var_2_3 = var_2_0:is_device_active("gamepad") and var_2_2:get("look_controller_3p") or var_2_2:get("look")
	local var_2_4 = Vector3.zero()

	if var_2_3 then
		local var_2_5 = arg_2_1.viewport_name

		var_2_4 = var_2_4 + var_2_3 * (var_2_1:has_viewport(var_2_5) and var_2_1:fov(var_2_5) / 0.785 or 1)
	end

	local var_2_6 = Unit.local_rotation(arg_2_0, 0)
	local var_2_7 = Quaternion.yaw(var_2_6) - var_2_4.x
	local var_2_8 = math.clamp(Quaternion.pitch(var_2_6) + var_2_4.y, -var_0_0, var_0_0)
	local var_2_9 = Quaternion(Vector3.up(), var_2_7)
	local var_2_10 = Quaternion(Vector3.right(), var_2_8)
	local var_2_11 = Quaternion.multiply(var_2_9, var_2_10)

	Unit.set_local_rotation(arg_2_0, 0, var_2_11)

	return Vector3.length_squared(var_2_4) > 0
end

CameraStateHelper.set_follow_camera_position = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
	if arg_3_2 then
		arg_3_1 = arg_3_1 + arg_3_2
	end

	local var_3_0

	if arg_3_3 then
		var_3_0 = arg_3_1

		Managers.state.event:trigger("camera_teleported")
	else
		local var_3_1 = Unit.world_position(arg_3_0, 0)
		local var_3_2 = math.min(arg_3_4 * 10, 1)

		var_3_0 = Vector3.lerp(var_3_1, arg_3_1, var_3_2)
	end

	fassert(Vector3.is_valid(var_3_0), "Camera position invalid.")
	Unit.set_local_position(arg_3_0, 0, var_3_0)
end

CameraStateHelper.set_camera_rotation_observe_static = function (arg_4_0, arg_4_1)
	local var_4_0 = Unit.local_rotation(arg_4_1, 0)
	local var_4_1 = Quaternion.look(Quaternion.forward(var_4_0), Vector3.up())
	local var_4_2 = Quaternion.right(var_4_1)
	local var_4_3 = Quaternion.axis_angle(var_4_2, -math.pi * 0.07)
	local var_4_4 = Quaternion.multiply(var_4_3, var_4_1)

	Unit.set_local_rotation(arg_4_0, 0, var_4_4)
end

CameraStateHelper.get_valid_unit_to_observe = function (arg_5_0, arg_5_1, arg_5_2, arg_5_3)
	local var_5_0 = FrameTable.alloc_table()
	local var_5_1 = table.values(Managers.player:human_and_bot_players())

	table.sort(var_5_1, function (arg_6_0, arg_6_1)
		local var_6_0 = arg_6_0:network_id()
		local var_6_1 = arg_6_1:network_id()

		if var_6_0 == var_6_1 then
			return arg_6_0:local_player_id() < arg_6_1:local_player_id()
		end

		return PlayerUtils.peer_id_compare(var_6_0, var_6_1)
	end)

	for iter_5_0 = 1, #var_5_1 do
		var_5_0[#var_5_0 + 1] = var_5_1[iter_5_0].player_unit
	end

	local var_5_2 = Managers.state.game_mode:game_mode()

	if var_5_2.get_extra_observer_units then
		local var_5_3

		if arg_5_3 then
			var_5_3 = Managers.party:get_status_from_unique_id(arg_5_3:unique_id()).slot_id
		end

		local var_5_4 = var_5_2:get_extra_observer_units(var_5_3)

		if var_5_4 then
			table.append(var_5_0, var_5_4)
		end
	end

	local var_5_5 = Managers.state.side
	local var_5_6 = arg_5_1 and arg_5_1:name()
	local var_5_7

	if var_5_6 then
		local var_5_8 = Managers.state.game_mode:settings()
		local var_5_9 = var_5_8.side_settings and var_5_8.side_settings[var_5_6]

		var_5_7 = var_5_9 and var_5_9.observe_sides
	end

	local var_5_10 = #var_5_0

	if var_5_10 <= 0 then
		return
	end

	local var_5_11 = arg_5_2 and table.index_of(var_5_0, arg_5_2)

	if not var_5_11 or var_5_11 < 1 then
		var_5_11 = 1
	end

	local var_5_12 = math.index_wrapper(var_5_11, var_5_10)
	local var_5_13 = var_5_12
	local var_5_14 = var_5_0[var_5_12]
	local var_5_15 = arg_5_0 and -1 or 1

	repeat
		var_5_12 = math.index_wrapper(var_5_12 + var_5_15, var_5_10)

		local var_5_16 = var_5_0[var_5_12]
		local var_5_17 = Unit.alive(var_5_16)

		if var_5_7 then
			local var_5_18 = Managers.player:owner(var_5_16)

			if var_5_18 and var_5_18.player_unit then
				local var_5_19 = var_5_18 and var_5_5:get_side_from_player_unique_id(var_5_18:unique_id())
				local var_5_20 = var_5_19 and var_5_7[var_5_19:name()]

				var_5_17 = not var_5_20 or var_5_20()
			end
		end

		if var_5_17 then
			var_5_14 = var_5_16

			break
		end

		if var_5_12 == var_5_13 then
			break
		end
	until false

	return var_5_14
end
