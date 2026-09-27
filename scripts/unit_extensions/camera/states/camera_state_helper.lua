-- chunkname: @scripts/unit_extensions/camera/states/camera_state_helper.lua

local CameraStateHelper = CameraStateHelper

CameraStateHelper = CameraStateHelper or {}
CameraStateHelper = CameraStateHelper

CameraStateHelper.set_local_pose = function (arg_1_0, arg_1_1, arg_1_2)
	-- function 1
	local local_pose = Unit.local_pose(arg_1_1, arg_1_2)
	local var_1_1 = arg_1_2

	assert(Matrix4x4.is_valid(local_pose), "Camera unit pose invalid.")

	while var_1_1 ~= 0 do
		local scene_graph_parent = Unit.scene_graph_parent(arg_1_1, var_1_1)
		local local_pose_2 = Unit.local_pose(arg_1_1, scene_graph_parent)

		assert(Matrix4x4.is_valid(local_pose_2), "Camera unit parent pose invalid.")

		local_pose = Matrix4x4.multiply(local_pose, local_pose_2)
		var_1_1 = scene_graph_parent
	end

	Unit.set_local_pose(arg_1_0, 0, local_pose)
end

local num = math.pi / 2 - math.pi / 15

CameraStateHelper.set_camera_rotation = function (arg_2_0, arg_2_1)
	-- function 2
	local input = Managers.input
	local camera = Managers.state.camera
	local get_service = input:get_service("Player")
	local get

	if not input:is_device_active("gamepad") then
		get = get_service:get("look_controller_3p")

		if not get then
			-- Nothing
		end
	end

	get = get_service:get("look")

	::label_2_0::

	local zero = Vector3.zero()

	if not get then
		local viewport_name = arg_2_1.viewport_name
		local num_2

		if not camera:has_viewport(viewport_name) then
			num_2 = camera:fov(viewport_name) / 0.785

			if not num_2 then
				-- Nothing
			end
		end

		num_2 = 1

		::label_2_1::

		zero = zero + get * num_2
	end

	local local_rotation = Unit.local_rotation(arg_2_0, 0)
	local num_3 = Quaternion.yaw(local_rotation) - zero.x
	local clamp = math.clamp(Quaternion.pitch(local_rotation) + zero.y, -num, num)
	local var_2_10 = Quaternion(Vector3.up(), num_3)
	local var_2_11 = Quaternion(Vector3.right(), clamp)
	local multiply = Quaternion.multiply(var_2_10, var_2_11)

	Unit.set_local_rotation(arg_2_0, 0, multiply)

	return Vector3.length_squared(zero) > 0
end

CameraStateHelper.set_follow_camera_position = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
	-- function 3
	if not arg_3_2 then
		arg_3_1 = arg_3_1 + arg_3_2
	end

	local var_3_0

	if not arg_3_3 then
		var_3_0 = arg_3_1

		Managers.state.event:trigger("camera_teleported")
	else
		local world_position = Unit.world_position(arg_3_0, 0)
		local min = math.min(arg_3_4 * 10, 1)

		var_3_0 = Vector3.lerp(world_position, arg_3_1, min)
	end

	fassert(Vector3.is_valid(var_3_0), "Camera position invalid.")
	Unit.set_local_position(arg_3_0, 0, var_3_0)
end

CameraStateHelper.set_camera_rotation_observe_static = function (arg_4_0, arg_4_1)
	-- function 4
	local local_rotation = Unit.local_rotation(arg_4_1, 0)
	local look = Quaternion.look(Quaternion.forward(local_rotation), Vector3.up())
	local right = Quaternion.right(look)
	local axis_angle = Quaternion.axis_angle(right, -math.pi * 0.07)
	local multiply = Quaternion.multiply(axis_angle, look)

	Unit.set_local_rotation(arg_4_0, 0, multiply)
end

CameraStateHelper.get_valid_unit_to_observe = function (arg_5_0, arg_5_1, arg_5_2, arg_5_3)
	-- function 5
	local alloc_table = FrameTable.alloc_table()
	local values = table.values(Managers.player:human_and_bot_players())

	table.sort(values, function (self, arg_6_1)
		-- function 6
		local network_id = self:network_id()
		local network_id_2 = arg_6_1:network_id()

		if network_id == network_id_2 then
			return self:local_player_id() < arg_6_1:local_player_id()
		end

		return PlayerUtils.peer_id_compare(network_id, network_id_2)
	end)

	for i = 1, #values do
		alloc_table[#alloc_table + 1] = values[i].player_unit
	end

	local game_mode = Managers.state.game_mode:game_mode()

	if not game_mode.get_extra_observer_units then
		local var_5_3

		if not arg_5_3 then
			var_5_3 = Managers.party:get_status_from_unique_id(arg_5_3:unique_id()).slot_id
		end

		local get_extra_observer_units = game_mode:get_extra_observer_units(var_5_3)

		if not get_extra_observer_units then
			table.append(alloc_table, get_extra_observer_units)
		end
	end

	local side = Managers.state.side
	local flag = not arg_5_1 and arg_5_1:name()
	local var_5_7

	if not flag then
		local settings = Managers.state.game_mode:settings()
		local side_settings = settings.side_settings

		side_settings = not side_settings and settings.side_settings[flag]
		var_5_7 = not side_settings and side_settings.observe_sides
	end

	local count = #alloc_table

	if count <= 0 then
		return
	end

	local flag_2 = not arg_5_2 and table.index_of(alloc_table, arg_5_2)

	if not (not flag_2 and not (flag_2 < 1)) then
		flag_2 = 1
	end

	local index_wrapper = math.index_wrapper(flag_2, count)
	local var_5_13 = index_wrapper
	local var_5_14 = alloc_table[index_wrapper]
	local flag_3

	flag_3 = not arg_5_0 and -1 and 1

	repeat
		index_wrapper = math.index_wrapper(index_wrapper + flag_3, count)

		local var_5_16 = alloc_table[index_wrapper]
		local alive = Unit.alive(var_5_16)

		if not var_5_7 then
			local owner = Managers.player:owner(var_5_16)

			if not (not owner and owner.player_unit) then
				local flag_4 = not owner and side:get_side_from_player_unique_id(owner:unique_id())
				local flag_5 = not flag_4 and var_5_7[flag_4:name()]

				alive = not flag_5 and flag_5()
			end
		end

		if not alive then
			var_5_14 = var_5_16

			break
		end

		if index_wrapper == var_5_13 then
			break
		end
	until false

	return var_5_14
end
