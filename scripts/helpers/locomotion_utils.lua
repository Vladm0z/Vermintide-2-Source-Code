-- chunkname: @scripts/helpers/locomotion_utils.lua

LocomotionUtils = {}

local local_position = Unit.local_position
local set_local_rotation = Unit.set_local_rotation
local look = Quaternion.look

LocomotionUtils.follow_target = function (arg_1_0, arg_1_1, arg_1_2, arg_1_3)
	-- function 1
	if not Unit.alive(arg_1_1.target_unit) then
		return
	end

	local breed = arg_1_1.breed
	local var_1_1 = local_position(arg_1_0, 0)
	local var_1_2 = local_position(arg_1_1.target_unit, 0)
	local var_1_3

	if not arg_1_1.remembered_threat_pos then
		var_1_3 = Vector3.distance(Vector3Box.unbox(arg_1_1.remembered_threat_pos), var_1_2) > 1
	else
		arg_1_1.remembered_threat_pos = Vector3Box()
		var_1_3 = true
	end

	if not var_1_3 then
		Vector3Box.store(arg_1_1.remembered_threat_pos, var_1_2)

		local num = Unit.local_position(arg_1_1.target_unit, 0) - Vector3.normalize(var_1_2 - var_1_1) * breed.radius
		local triangle_from_position, var_1_6 = GwNavQueries.triangle_from_position(arg_1_1.nav_world, num)

		if not triangle_from_position then
			num.z = var_1_6

			ScriptUnit.extension(arg_1_0, "ai_system"):navigation():move_to(num)

			arg_1_1.target_outside_navmesh = false
		else
			arg_1_1.target_outside_navmesh = true
		end
	end
end

LocomotionUtils.follow_target_ogre = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3)
	-- function 2
	local target_unit = arg_2_1.target_unit

	if not Unit.alive(target_unit) then
		return
	end

	local var_2_1 = POSITION_LOOKUP[arg_2_0]
	local has_extension = ScriptUnit.has_extension(target_unit, "status_system")
	local var_2_3
	local var_2_4

	if not has_extension then
		var_2_3, var_2_4 = has_extension:get_is_on_ladder()
	end

	local var_2_5
	local var_2_6

	if not var_2_3 then
		local get_ladder_coordinates, var_2_8 = Managers.state.bot_nav_transition:get_ladder_coordinates(var_2_4)

		var_2_5 = get_ladder_coordinates
		var_2_6 = get_ladder_coordinates
	else
		var_2_5 = POSITION_LOOKUP[target_unit]
	end

	local var_2_9

	if not arg_2_1.remembered_threat_pos then
		var_2_9 = Vector3.distance(Vector3Box.unbox(arg_2_1.remembered_threat_pos), var_2_5) > 1

		if not (var_2_9 or not (arg_2_2 > arg_2_1.next_move_check)) then
			arg_2_1.next_move_check = arg_2_2 + 2

			local nav_world = arg_2_1.nav_world
			local triangle_from_position, var_2_12 = GwNavQueries.triangle_from_position(nav_world, var_2_5, 2, 2)

			if not triangle_from_position then
				var_2_9 = true
			end
		end
	else
		arg_2_1.remembered_threat_pos = Vector3Box(var_2_5)
		var_2_9 = true
	end

	if not var_2_9 then
		Vector3Box.store(arg_2_1.remembered_threat_pos, var_2_5)

		local num = var_2_5 - var_2_1
		local breed = arg_2_1.breed
		local nav_world_2 = arg_2_1.nav_world

		var_2_6 = var_2_6 or Unit.local_position(arg_2_1.target_unit, 0) - Vector3.normalize(num) * breed.radius

		local var_2_16
		local var_2_17
		local var_2_18
		local triangle_from_position_2, var_2_20 = GwNavQueries.triangle_from_position(nav_world_2, var_2_6, 30, 30)

		if not (not triangle_from_position_2 and not (math.abs(var_2_6[3] - var_2_20) <= 2)) then
			var_2_6.z = var_2_20

			arg_2_1.navigation_extension:move_to(var_2_6)

			arg_2_1.target_outside_navmesh = false

			return var_2_6
		end

		local num_2 = 2
		local num_3 = 2
		local num_4 = 3
		local num_5 = 3
		local inside_position_from_outside_position = GwNavQueries.inside_position_from_outside_position(nav_world_2, var_2_6, num_2, num_3, num_4, num_5)

		if not inside_position_from_outside_position then
			arg_2_1.navigation_extension:move_to(inside_position_from_outside_position)

			arg_2_1.target_outside_navmesh = false

			return inside_position_from_outside_position
		end

		if not triangle_from_position_2 then
			var_2_6.z = var_2_20

			arg_2_1.navigation_extension:move_to(var_2_6)

			arg_2_1.target_outside_navmesh = false

			return var_2_6
		end

		if Vector3.length(num) > 5 then
			local triangle_from_position_3, var_2_27 = GwNavQueries.triangle_from_position(nav_world_2, var_2_5, 2, 2)

			if not triangle_from_position_3 then
				local var_2_28 = Vector3(var_2_5.x, var_2_5.y, var_2_27)

				arg_2_1.navigation_extension:move_to(var_2_28)

				arg_2_1.target_outside_navmesh = false

				return var_2_28
			end
		end

		arg_2_1.target_outside_navmesh = true
	end
end

local tbl = {
	ROTATION_LERP_LOOK_AT = 20
}

LocomotionUtils.update_combat_rotation = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3)
	-- function 3
	local var_3_0 = local_position(arg_3_0, 0)
	local local_rotation = Unit.local_rotation(arg_3_0, 0)
	local local_position_2 = Unit.local_position(arg_3_1.target_unit, 0)
	local var_3_3 = look(local_position_2 - var_3_0, Vector3.up())
	local smoothstep = math.smoothstep(arg_3_3 * tbl.ROTATION_LERP_LOOK_AT, 0, 1)
	local lerp = Quaternion.lerp(local_rotation, var_3_3, smoothstep)

	set_local_rotation(arg_3_0, 0, lerp)
end

LocomotionUtils.look_at_target_rotation = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3)
	-- function 4
	local var_4_0 = local_position(arg_4_0, 0)
	local local_rotation = Unit.local_rotation(arg_4_0, 0)
	local local_position_2 = Unit.local_position(arg_4_1.target_unit, 0)
	local var_4_3 = look(local_position_2 - var_4_0, Vector3.up())
	local smoothstep = math.smoothstep(arg_4_3 * tbl.ROTATION_LERP_LOOK_AT, 0, 1)

	return (Quaternion.lerp(local_rotation, var_4_3, smoothstep))
end

LocomotionUtils.look_at_target_rotation_flat = function (arg_5_0, arg_5_1, arg_5_2, arg_5_3)
	-- function 5
	local var_5_0 = local_position(arg_5_0, 0)
	local local_rotation = Unit.local_rotation(arg_5_0, 0)
	local num = Unit.local_position(arg_5_1.target_unit, 0) - var_5_0

	Vector3.set_z(num, 0)

	local var_5_3 = look(num, Vector3.up())
	local smoothstep = math.smoothstep(arg_5_3 * tbl.ROTATION_LERP_LOOK_AT, 0, 1)

	return (Quaternion.lerp(local_rotation, var_5_3, smoothstep))
end

LocomotionUtils.rotation_towards_unit = function (arg_6_0, arg_6_1)
	-- function 6
	local var_6_0 = local_position(arg_6_0, 0)
	local var_6_1 = local_position(arg_6_1, 0)
	local normalize = Vector3.normalize(var_6_1 - var_6_0)

	return (look(normalize))
end

LocomotionUtils.rotation_towards_unit_flat = function (arg_7_0, arg_7_1)
	-- function 7
	local var_7_0 = local_position(arg_7_0, 0)
	local num = local_position(arg_7_1, 0) - var_7_0

	num.z = 0

	local normalize = Vector3.normalize(num)

	return (look(normalize))
end

LocomotionUtils.look_at_position = function (arg_8_0, arg_8_1)
	-- function 8
	local var_8_0 = local_position(arg_8_0, 0)
	local normalize = Vector3.normalize(arg_8_1 - var_8_0)

	return (look(normalize, Vector3.up()))
end

LocomotionUtils.look_at_position_flat = function (arg_9_0, arg_9_1)
	-- function 9
	local var_9_0 = local_position(arg_9_0, 0)
	local flat = Vector3.flat(arg_9_1 - var_9_0)
	local normalize = Vector3.normalize(flat)

	return (look(normalize, Vector3.up()))
end

LocomotionUtils.get_attack_anim = function (arg_10_0, arg_10_1, arg_10_2)
	-- function 10
	if not arg_10_2 then
		local target_unit = arg_10_1.target_unit
		local local_position = Unit.local_position(target_unit, 0)
		local local_position_2 = Unit.local_position(arg_10_0, 0)
		local normalize = Vector3.normalize(local_position_2 - local_position)
		local forward = Quaternion.forward(Unit.local_rotation(arg_10_0, 0))
		local dot = Vector3.dot(forward, normalize)
		local clamp = math.clamp(dot, -1, 1)
		local acos = math.acos(clamp)

		if acos > math.pi * 0.95 then
			return arg_10_2.directly_fwd[1], arg_10_2.directly_fwd[2]
		elseif acos > math.pi * 0.75 then
			return arg_10_2.fwd[1], arg_10_2.fwd[2]
		elseif acos < math.pi * 0.25 then
			return arg_10_2.bwd[1], arg_10_2.bwd[2]
		elseif Vector3.cross(forward, normalize).z > 0 then
			return arg_10_2.right[1], arg_10_2.right[2]
		else
			return arg_10_2.left[1], arg_10_2.left[2]
		end
	end

	return nil, false
end

LocomotionUtils.get_start_anim = function (arg_11_0, arg_11_1, arg_11_2)
	-- function 11
	if not arg_11_2 then
		local target_unit = arg_11_1.target_unit
		local local_position = Unit.local_position(target_unit, 0)
		local local_position_2 = Unit.local_position(arg_11_0, 0)
		local normalize = Vector3.normalize(local_position_2 - local_position)
		local forward = Quaternion.forward(Unit.local_rotation(arg_11_0, 0))
		local dot = Vector3.dot(forward, normalize)
		local clamp = math.clamp(dot, -1, 1)
		local acos = math.acos(clamp)

		if acos > math.pi * 0.75 then
			return arg_11_2.fwd
		elseif acos < math.pi * 0.25 then
			return arg_11_2.bwd, true
		elseif Vector3.cross(forward, normalize).z > 0 then
			return arg_11_2.right
		else
			return arg_11_2.left
		end
	end
end

LocomotionUtils.constrain_on_clients = function (arg_12_0, arg_12_1, arg_12_2, arg_12_3)
	-- function 12
	local network = Managers.state.network

	if not network:game() then
		local alloc_table = FrameTable.alloc_table()

		if not arg_12_1 then
			alloc_table[1] = Vector3(math.min(arg_12_2.x, arg_12_3.x), math.min(arg_12_2.y, arg_12_3.y), math.min(arg_12_2.z, arg_12_3.z))
			alloc_table[2] = Vector3(math.max(arg_12_2.x, arg_12_3.x), math.max(arg_12_2.y, arg_12_3.y), math.max(arg_12_2.z, arg_12_3.z))
		end

		local go_id = Managers.state.unit_storage:go_id(arg_12_0)

		network.network_transmit:send_rpc_clients("rpc_constrain_ai", go_id, arg_12_1, alloc_table)
	end
end

LocomotionUtils.set_animation_driven_movement = function (arg_13_0, arg_13_1, arg_13_2, arg_13_3, arg_13_4)
	-- function 13
	ScriptUnit.extension(arg_13_0, "locomotion_system"):set_animation_driven(arg_13_1, arg_13_2, arg_13_3, arg_13_4)
end

LocomotionUtils.set_animation_translation_scale = function (arg_14_0, arg_14_1)
	-- function 14
	local extension = ScriptUnit.extension(arg_14_0, "locomotion_system")
	local get_animation_translation_scale = extension:get_animation_translation_scale()

	if not Vector3.equal(get_animation_translation_scale, arg_14_1) then
		extension:set_animation_translation_scale(arg_14_1)

		local network = Managers.state.network

		if not network:game() then
			local go_id = Managers.state.unit_storage:go_id(arg_14_0)

			if not network.is_server then
				network.network_transmit:send_rpc_clients("rpc_set_animation_translation_scale", go_id, arg_14_1)
			else
				network.network_transmit:send_rpc_server("rpc_set_animation_translation_scale", go_id, arg_14_1)
			end
		end
	end
end

LocomotionUtils.set_animation_rotation_scale = function (arg_15_0, arg_15_1)
	-- function 15
	local extension = ScriptUnit.extension(arg_15_0, "locomotion_system")

	if extension:get_animation_rotation_scale() ~= arg_15_1 then
		extension:set_animation_rotation_scale(arg_15_1)

		local network = Managers.state.network

		if not network:game() then
			local go_id = Managers.state.unit_storage:go_id(arg_15_0)

			network.network_transmit:send_rpc_clients("rpc_set_animation_rotation_scale", go_id, arg_15_1)
		end
	end
end

LocomotionUtils.update_local_animation_driven_movement = function (arg_16_0, arg_16_1)
	-- function 16
	local animation_wanted_root_pose = Unit.animation_wanted_root_pose(arg_16_0)
	local translation = Matrix4x4.translation(animation_wanted_root_pose)

	Unit.set_local_position(arg_16_0, 0, translation)

	local rotation = Matrix4x4.rotation(animation_wanted_root_pose)

	Unit.set_local_rotation(arg_16_0, 0, rotation)
end

LocomotionUtils.update_local_animation_driven_movement_with_parent = function (arg_17_0, arg_17_1, arg_17_2)
	-- function 17
	local master_unit = arg_17_2.master_unit

	if not (not master_unit and Unit.alive(master_unit)) then
		return
	end

	local local_position = Unit.local_position(master_unit, 0)
	local animation_wanted_root_pose = Unit.animation_wanted_root_pose(arg_17_0)

	Unit.set_local_position(arg_17_0, 0, local_position)

	local rotation = Matrix4x4.rotation(animation_wanted_root_pose)

	Unit.set_local_rotation(arg_17_0, 0, rotation)
end

LocomotionUtils.update_local_animation_driven_movement_with_mover = function (arg_18_0, arg_18_1)
	-- function 18
	local animation_wanted_root_pose = Unit.animation_wanted_root_pose(arg_18_0)
	local num = Matrix4x4.translation(animation_wanted_root_pose) - POSITION_LOOKUP[arg_18_0]
	local mover = Unit.mover(arg_18_0)

	Mover.move(mover, num, arg_18_1)

	local position = Mover.position(mover)

	Unit.set_local_position(arg_18_0, 0, position)

	local rotation = Matrix4x4.rotation(animation_wanted_root_pose)

	Unit.set_local_rotation(arg_18_0, 0, rotation)
end

LocomotionUtils.update_local_animation_driven_movement_plus_mover = function (arg_19_0, arg_19_1)
	-- function 19
	local mover = Unit.mover(arg_19_0)
	local animation_wanted_root_pose = Unit.animation_wanted_root_pose(arg_19_0)
	local translation = Matrix4x4.translation(animation_wanted_root_pose)
	local num = translation - Mover.position(mover)

	Mover.move(mover, num, arg_19_1)
	Unit.set_local_position(arg_19_0, 0, translation)

	local rotation = Matrix4x4.rotation(animation_wanted_root_pose)

	Unit.set_local_rotation(arg_19_0, 0, rotation)
end

LocomotionUtils.update_local_animation_driven_movement_with_min_z = function (arg_20_0, arg_20_1, arg_20_2)
	-- function 20
	local animation_wanted_root_pose = Unit.animation_wanted_root_pose(arg_20_0)
	local translation = Matrix4x4.translation(animation_wanted_root_pose)

	if arg_20_2 > translation.z then
		Vector3.set_z(translation, arg_20_2)
	end

	Unit.set_local_position(arg_20_0, 0, translation)

	local rotation = Matrix4x4.rotation(animation_wanted_root_pose)

	Unit.set_local_rotation(arg_20_0, 0, rotation)
end

LocomotionUtils.new_random_goal = function (arg_21_0, arg_21_1, arg_21_2, arg_21_3, arg_21_4, arg_21_5, arg_21_6, arg_21_7, arg_21_8)
	-- function 21
	local flag = arg_21_7 or 30
	local flag_2 = arg_21_8 or 30
	local num = 0

	while num < arg_21_5 do
		local num_2 = arg_21_3 + math.random() * (arg_21_4 - arg_21_3)
		local var_21_4 = Vector3(num_2, 0, 1.5)
		local num_3 = arg_21_2 + Quaternion.rotate(Quaternion(Vector3.up(), math.degrees_to_radians(Math.random(1, 360))), var_21_4)

		if not arg_21_6 then
			arg_21_6[#arg_21_6 + 1] = Vector3Box(num_3)
		end

		local triangle_from_position, var_21_7 = GwNavQueries.triangle_from_position(arg_21_0, num_3, flag, flag_2)

		if not triangle_from_position then
			num_3.z = var_21_7

			return num_3
		end

		num = num + 1
	end
end

LocomotionUtils.new_random_goal_uniformly_distributed = function (arg_22_0, arg_22_1, arg_22_2, arg_22_3, arg_22_4, arg_22_5, arg_22_6, arg_22_7, arg_22_8)
	-- function 22
	arg_22_7 = arg_22_7 or 30
	arg_22_8 = arg_22_8 or 30

	local num = 0

	while num < arg_22_5 do
		local num_2 = (arg_22_3 / arg_22_4)^2
		local num_3 = num_2 + Math.random() * (1 - num_2)
		local num_4 = math.sqrt(num_3) * arg_22_4
		local var_22_4 = Vector3(num_4, 0, 1.5)
		local num_5 = arg_22_2 + Quaternion.rotate(Quaternion(Vector3.up(), Math.random() * math.pi * 2), var_22_4)

		if not arg_22_6 then
			arg_22_6[#arg_22_6 + 1] = Vector3Box(num_5)
		end

		local triangle_from_position, var_22_7 = GwNavQueries.triangle_from_position(arg_22_0, num_5, arg_22_7, arg_22_8)

		if not triangle_from_position then
			num_5.z = var_22_7

			return num_5
		end

		num = num + 1
	end
end

LocomotionUtils.new_random_goal_uniformly_distributed_with_inside_from_outside_on_last = function (arg_23_0, arg_23_1, arg_23_2, arg_23_3, arg_23_4, arg_23_5, arg_23_6, arg_23_7, arg_23_8, arg_23_9)
	-- function 23
	local flag = arg_23_7 or 30
	local flag_2 = arg_23_8 or 30
	local flag_3 = arg_23_9 or 3
	local num = 0.1
	local num_2 = 0

	while num_2 < arg_23_5 do
		local num_3 = (arg_23_3 / arg_23_4)^2
		local num_4 = num_3 + Math.random() * (1 - num_3)
		local num_5 = math.sqrt(num_4) * arg_23_4
		local var_23_8 = Vector3(num_5, 0, 1.5)
		local num_6 = arg_23_2 + Quaternion.rotate(Quaternion(Vector3.up(), Math.random() * math.pi * 2), var_23_8)

		if not arg_23_6 then
			arg_23_6[#arg_23_6 + 1] = Vector3Box(num_6)
		end

		local triangle_from_position, var_23_11 = GwNavQueries.triangle_from_position(arg_23_0, num_6, flag, flag_2)

		if not triangle_from_position then
			num_6.z = var_23_11

			return num_6
		end

		if num_2 == arg_23_5 - 1 then
			local inside_position_from_outside_position = GwNavQueries.inside_position_from_outside_position(arg_23_0, num_6, flag, flag_2, flag_3, num)

			if not inside_position_from_outside_position then
				return inside_position_from_outside_position
			end
		end

		num_2 = num_2 + 1
	end
end

LocomotionUtils.new_random_goal_in_front_of_unit = function (arg_24_0, arg_24_1, arg_24_2, arg_24_3, arg_24_4, arg_24_5, arg_24_6, arg_24_7, arg_24_8, arg_24_9)
	-- function 24
	local flag

	flag = arg_24_8 or 30

	local flag_2

	flag_2 = arg_24_9 or 30

	local num = 0
	local local_position = Unit.local_position(arg_24_1, 0)

	while num < arg_24_4 do
		local has_extension = ScriptUnit.has_extension(arg_24_1, "locomotion_system")
		local var_24_5
		local var_24_6

		if not has_extension and not has_extension.average_velocity then
			local flat = Vector3.flat(has_extension:average_velocity())

			var_24_6 = Vector3.length(flat)

			if var_24_6 > 0.1 then
				var_24_5 = flat
			else
				var_24_5 = Quaternion.forward(Unit.local_rotation(arg_24_1, 0))
			end
		else
			var_24_5 = Quaternion.forward(Unit.local_rotation(arg_24_1, 0))
			var_24_6 = 0
		end

		local num_2 = 0
		local num_3 = 4
		local auto_lerp = math.auto_lerp(num_2, num_3, arg_24_2, arg_24_3, var_24_6)
		local lerp = math.lerp(arg_24_6, arg_24_7, Math.random())

		if Math.random() < 0.5 then
			lerp = -lerp
		end

		local normalize = Vector3.normalize(var_24_5)
		local cross = Vector3.cross(normalize, Vector3.up())
		local num_4 = local_position + normalize * auto_lerp + cross * lerp

		if not arg_24_5 then
			arg_24_5[#arg_24_5 + 1] = Vector3Box(num_4)
		end

		local triangle_from_position, var_24_16 = GwNavQueries.triangle_from_position(arg_24_0, num_4, 30, 30)

		if not triangle_from_position then
			num_4.z = var_24_16

			return num_4
		end

		num = num + 1
	end

	return nil
end

LocomotionUtils.new_goal_in_transport = function (arg_25_0, arg_25_1, arg_25_2)
	-- function 25
	local num = 0
	local get_inside_transport_unit = ScriptUnit.extension(arg_25_2, "status_system"):get_inside_transport_unit()

	if not Unit.alive(get_inside_transport_unit) then
		local assign_position_to_bot = ScriptUnit.extension(get_inside_transport_unit, "transportation_system"):assign_position_to_bot()
		local triangle_from_position, var_25_4 = GwNavQueries.triangle_from_position(arg_25_0, assign_position_to_bot, 30, 30)

		if not triangle_from_position then
			assign_position_to_bot.z = var_25_4

			return assign_position_to_bot
		end
	end

	return nil
end

LocomotionUtils.outside_goal = function (arg_26_0, arg_26_1, arg_26_2, arg_26_3, arg_26_4, arg_26_5, arg_26_6, arg_26_7, arg_26_8)
	-- function 26
	local num = 0
	local flat = Vector3.flat(arg_26_1 - arg_26_2)

	if Vector3.length_squared(flat) < 0.001 then
		return
	end

	local num_2 = arg_26_4 - arg_26_3
	local num_3 = (arg_26_3 + arg_26_4) * 0.5
	local num_4 = num_2 / arg_26_6
	local normalize = Vector3.normalize(flat)
	local degrees_to_radians = math.degrees_to_radians(arg_26_5)

	while num < arg_26_6 do
		local num_5 = (num % 2 - 0.5) * 2
		local num_6 = num_3 + (math.floor(num * 0.5) + Math.random()) * num_5 * num_4
		local num_7 = normalize * num_6
		local num_8 = arg_26_2 + Quaternion.rotate(Quaternion(Vector3.up(), degrees_to_radians), num_7)
		local triangle_from_position, var_26_12 = GwNavQueries.triangle_from_position(arg_26_0, num_8, arg_26_7 or 30, arg_26_8 or 30)

		if not triangle_from_position then
			num_8.z = var_26_12

			return num_8, num_6
		end

		num = num + 1
	end
end

local num = 10
local num_2 = 0
local num_3 = 4
local num_4 = 8
local num_5 = 3

LocomotionUtils.pick_visible_outside_goal = function (self)
	-- function 27
	local max_tries = self.max_tries

	max_tries = max_tries or num

	local min_angle = self.min_angle

	min_angle = min_angle or num_2

	local min_angle_step = self.min_angle_step

	min_angle_step = min_angle_step or num_3

	local max_angle_step = self.max_angle_step

	max_angle_step = max_angle_step or num_4

	local outside_goal_tries = self.outside_goal_tries

	outside_goal_tries = outside_goal_tries or num_5

	local nav_world = self.nav_world
	local physics_world = self.physics_world
	local from_unit = self.from_unit
	local to_unit = self.to_unit
	local from_node_name = self.from_node_name
	local to_node_name = self.to_node_name
	local min_distance = self.min_distance
	local max_distance = self.max_distance
	local above = self.above
	local below = self.below
	local node = Unit.node(from_unit, from_node_name)
	local world_position = Unit.world_position(from_unit, node)
	local node_2 = Unit.node(to_unit, to_node_name)
	local world_position_2 = Unit.world_position(to_unit, node_2)
	local var_27_19
	local min_wanted_radius = self.min_wanted_radius
	local flag = not min_wanted_radius and min_wanted_radius^2
	local radius_check_directions = self.radius_check_directions
	local flag_2 = not radius_check_directions and #radius_check_directions
	local traverse_logic = self.traverse_logic
	local var_27_25 = POSITION_LOOKUP[from_unit]
	local var_27_26 = POSITION_LOOKUP[to_unit]
	local direction = self.direction

	direction = direction or 1 - math.random(0, 1) * 2

	local num_6 = Vector3.up() * 0.05
	local var_27_29

	for i = 1, 2 do
		for j = 1, max_tries do
			local num_7 = min_angle + math.random(min_angle_step * j, max_angle_step * j) * direction
			local outside_goal, var_27_32 = LocomotionUtils.outside_goal(nav_world, var_27_25, var_27_26, min_distance, max_distance, num_7, outside_goal_tries, above, below)

			if not outside_goal then
				local is_position_in_line_of_sight, var_27_34 = PerceptionUtils.is_position_in_line_of_sight(from_unit, world_position, outside_goal + num_6, physics_world)
				local var_27_35
				local var_27_36

				if not is_position_in_line_of_sight then
					local var_27_37

					var_27_35, var_27_37 = PerceptionUtils.is_position_in_line_of_sight(to_unit, world_position_2, outside_goal + num_6, physics_world)
					var_27_29 = var_27_35
				end

				if not var_27_35 and not radius_check_directions then
					var_27_19 = math.huge

					for k = 1, flag_2 do
						local num_8 = outside_goal + radius_check_directions[k]:unbox()
						local var_27_39
						local var_27_40

						if not traverse_logic then
							local raycast

							raycast, var_27_40 = GwNavQueries.raycast(nav_world, outside_goal, num_8, traverse_logic)
						else
							local raycast_2

							raycast_2, var_27_40 = GwNavQueries.raycast(nav_world, outside_goal, num_8)
						end

						local distance_squared = Vector3.distance_squared(outside_goal, var_27_40)

						if distance_squared < flag then
							var_27_29 = false

							break
						elseif distance_squared < var_27_19 then
							var_27_19 = distance_squared
						end
					end
				end

				if not var_27_29 then
					local flag_3 = not var_27_19 and math.sqrt(var_27_19)

					return outside_goal, flag_3, var_27_32, direction
				end
			end
		end

		direction = -direction
	end
end

LocomotionUtils.test_pos = function (arg_28_0, arg_28_1)
	-- function 28
	local num = 0
	local num_2 = 0

	for i = -10, 10 do
		for j = -10, 10 do
			local num_3 = arg_28_1 + Vector3(i, j, 0)
			local pos_on_mesh = LocomotionUtils.pos_on_mesh(arg_28_0, num_3)

			if not pos_on_mesh then
				QuickDrawer:sphere(pos_on_mesh, 0.2, Color(255, 144, 43, 207))

				num_2 = num_2 + 1
			else
				num = num + 1
			end
		end
	end

	Debug.text("Points ok %.2f fail: %d", num_2 / (num_2 + num), num)
end

LocomotionUtils.get_close_pos_on_mesh = function (arg_29_0, arg_29_1, arg_29_2)
	-- function 29
	local tbl = {}
	local triangle_from_position, var_29_2, var_29_3, var_29_4, var_29_5 = GwNavQueries.triangle_from_position(arg_29_0, arg_29_1, 30, 30)

	if not triangle_from_position then
		local var_29_6 = Vector3(arg_29_1.x, arg_29_1.y, var_29_2)

		print("BOSS POINT FOUND AT FIRST POINT OK!")

		return var_29_6
	end

	tbl[#tbl + 1] = Vector3Box(arg_29_1)
	arg_29_2 = arg_29_2 or 4

	for i = 1, 4 do
		for j = -1, 1 do
			for k = -1, 1 do
				if not (j ~= 0 or k == 0) then
					local num = arg_29_1 + Vector3(j * i, k * i, 0)
					local triangle_from_position_2, var_29_9, var_29_10, var_29_11, var_29_12 = GwNavQueries.triangle_from_position(arg_29_0, num, 30, 30)

					if not triangle_from_position_2 then
						local var_29_13 = Vector3(num.x, num.y, var_29_9)

						print("BOSS POINT FOUND AFTER", #tbl, "TRIES")

						return var_29_13, tbl
					end

					tbl[#tbl + 1] = Vector3Box(num)
				end
			end
		end
	end

	return nil, tbl
end

LocomotionUtils.get_close_pos_below_on_mesh = function (arg_30_0, arg_30_1, arg_30_2, arg_30_3, arg_30_4)
	-- function 30
	arg_30_3 = arg_30_3 or 1
	arg_30_4 = arg_30_4 or 8

	local tbl = {}
	local triangle_from_position, var_30_2, var_30_3, var_30_4, var_30_5 = GwNavQueries.triangle_from_position(arg_30_0, arg_30_1, arg_30_3, arg_30_4)

	if not triangle_from_position then
		return (Vector3(arg_30_1.x, arg_30_1.y, var_30_2))
	end

	tbl[#tbl + 1] = Vector3Box(arg_30_1)
	arg_30_2 = arg_30_2 or 4

	for i = 1, 4 do
		for j = -1, 1 do
			for k = -1, 1 do
				if not (j ~= 0 or k == 0) then
					local num = arg_30_1 + Vector3(j * i, k * i, 0)
					local triangle_from_position_2, var_30_8, var_30_9, var_30_10, var_30_11 = GwNavQueries.triangle_from_position(arg_30_0, num, arg_30_3, arg_30_4)

					if not triangle_from_position_2 then
						return Vector3(num.x, num.y, var_30_8), tbl
					end

					tbl[#tbl + 1] = Vector3Box(num)
				end
			end
		end
	end

	return nil, tbl
end

local tbl_2 = {
	1,
	0,
	0.707,
	0.707,
	0,
	1,
	-0.707,
	0.707,
	-1,
	0,
	-0.707,
	-0.707,
	0,
	-1,
	0.707,
	-0.707
}

LocomotionUtils.mesh_positions_closest_to_outside_pos = function (arg_31_0, arg_31_1, arg_31_2, arg_31_3)
	-- function 31
	local count = #tbl_2

	for i = 1, count, 2 do
		local num = arg_31_1 + Vector3(tbl_2[i] * arg_31_2, tbl_2[i + 1] * arg_31_2, 0)
		local triangle_from_position, var_31_3, var_31_4, var_31_5, var_31_6 = GwNavQueries.triangle_from_position(arg_31_0, num, 30, 30)

		if not triangle_from_position then
			arg_31_3[#arg_31_3 + 1] = Vector3Box(num.x, num.y, var_31_3)
		end
	end

	return #arg_31_3 > 0
end

LocomotionUtils.closest_mesh_positions_outward = function (arg_32_0, arg_32_1, arg_32_2, arg_32_3)
	-- function 32
	local num = 3
	local ceil = math.ceil(arg_32_2 / num)
	local count = #tbl_2

	for i = 1, count, 2 do
		local var_32_3 = tbl_2[i]
		local var_32_4 = tbl_2[i + 1]

		for j = 1, ceil do
			local num_2 = arg_32_1 + Vector3(var_32_3 * j * num, var_32_4 * j * num, 0)
			local inside_position_from_outside_position = GwNavQueries.inside_position_from_outside_position(arg_32_0, num_2, 30, 30)

			if not inside_position_from_outside_position then
				arg_32_3[#arg_32_3 + 1] = Vector3Box(inside_position_from_outside_position)

				break
			end
		end
	end
end

LocomotionUtils.pos_on_mesh = function (arg_33_0, arg_33_1, arg_33_2, arg_33_3)
	-- function 33
	arg_33_2 = arg_33_2 or 30
	arg_33_3 = arg_33_3 or 30

	local triangle_from_position, var_33_1 = GwNavQueries.triangle_from_position(arg_33_0, arg_33_1, arg_33_2, arg_33_3)

	if not triangle_from_position then
		return (Vector3(arg_33_1.x, arg_33_1.y, var_33_1))
	end
end

LocomotionUtils.ray_can_go_on_mesh = function (arg_34_0, arg_34_1, arg_34_2, arg_34_3, arg_34_4, arg_34_5)
	-- function 34
	local pos_on_mesh = LocomotionUtils.pos_on_mesh(arg_34_0, arg_34_1, arg_34_4, arg_34_5)
	local flag = not pos_on_mesh and LocomotionUtils.pos_on_mesh(arg_34_0, arg_34_2, arg_34_4, arg_34_5)
	local var_34_2

	if not arg_34_3 then
		var_34_2 = not flag and GwNavQueries.raycango(arg_34_0, pos_on_mesh, flag, arg_34_3)
	else
		var_34_2 = not flag and GwNavQueries.raycango(arg_34_0, pos_on_mesh, flag)
	end

	return var_34_2, pos_on_mesh, flag
end

LocomotionUtils.raycast_on_navmesh = function (arg_35_0, arg_35_1, arg_35_2, arg_35_3, arg_35_4, arg_35_5, arg_35_6)
	-- function 35
	local pos_on_mesh = LocomotionUtils.pos_on_mesh(arg_35_0, arg_35_1, arg_35_4, arg_35_5)
	local flag = not pos_on_mesh and arg_35_6 and not arg_35_2 and LocomotionUtils.pos_on_mesh(arg_35_0, arg_35_2, arg_35_4, arg_35_5)
	local var_35_2
	local var_35_3

	if not flag then
		if not arg_35_3 then
			var_35_2, var_35_3 = GwNavQueries.raycast(arg_35_0, pos_on_mesh, flag, arg_35_3)
		else
			var_35_2, var_35_3 = GwNavQueries.raycast(arg_35_0, pos_on_mesh, flag)
		end
	end

	return var_35_2, pos_on_mesh, flag, var_35_3
end

local num_6 = 0.9

LocomotionUtils.is_on_flat_ground_raycast = function (arg_36_0, arg_36_1)
	-- function 36
	local num = arg_36_1 + Vector3.up() * 0.1
	local immediate_raycast, var_36_2, var_36_3, var_36_4 = PhysicsWorld.immediate_raycast(arg_36_0, num, Vector3.down(), 0.15, "closest", "collision_filter", "filter_ai_mover")
	local var_36_5

	if not immediate_raycast then
		var_36_5 = Vector3.dot(var_36_4, Vector3.up()) > num_6
	end

	return var_36_5
end

local num_7 = 0.0001
local num_8 = 0.25
local num_9 = 0.25
local num_10 = 0.3
local num_11 = 1.3
local num_12 = 0.4

LocomotionUtils.navmesh_movement_check = function (arg_37_0, arg_37_1, arg_37_2, arg_37_3, arg_37_4)
	-- function 37
	local flag = Vector3.length_squared(arg_37_1) > num_7
	local normalize

	if not flag then
		normalize = Vector3.normalize(arg_37_1)

		if not normalize then
			-- Nothing
		end
	end

	normalize = Vector3.zero()

	::label_37_0::

	local num = arg_37_0 + normalize * num_10
	local ray_can_go_on_mesh, var_37_4, var_37_5 = LocomotionUtils.ray_can_go_on_mesh(arg_37_2, arg_37_0, num, arg_37_4, num_8, num_9)
	local str = "navmesh_ok"

	if ray_can_go_on_mesh or not flag then
		local is_on_flat_ground_raycast = LocomotionUtils.is_on_flat_ground_raycast(arg_37_3, arg_37_0)
		local var_37_8
		local var_37_9
		local var_37_10

		if not is_on_flat_ground_raycast then
			local num_2 = arg_37_0 + Vector3.up() * num_12
			local var_37_12

			var_37_8, var_37_12 = PhysicsWorld.immediate_raycast(arg_37_3, num_2, normalize, num_11, "closest", "collision_filter", "filter_ai_mover")
		end

		str = not var_37_8 and "navmesh_hit_wall" and "navmesh_use_mover"
	end

	return str
end

local num_13 = 1
local num_14 = 2
local num_15 = 3
local num_16 = 4

LocomotionUtils.clear_los = function (arg_38_0, arg_38_1, arg_38_2, arg_38_3, arg_38_4)
	-- function 38
	local num = arg_38_2 - arg_38_1
	local length = Vector3.length(num)
	local immediate_raycast, var_38_3 = PhysicsWorld.immediate_raycast(arg_38_0, arg_38_1, num, length, "all", "collision_filter", "filter_ai_mover")

	if not immediate_raycast then
		for i = 1, var_38_3 do
			local var_38_4 = immediate_raycast[i][num_16]
			local unit = Actor.unit(var_38_4)

			if not (unit == arg_38_3 or unit == arg_38_4) then
				return false
			end
		end
	end

	return true
end

LocomotionUtils.target_in_los = function (arg_39_0, arg_39_1)
	-- function 39
	if not Unit.alive(arg_39_1.target_unit) then
		return
	end

	local node = Unit.node(arg_39_1.target_unit, "j_neck")
	local world_position = Unit.world_position(arg_39_1.target_unit, node)
	local node_2 = Unit.node(arg_39_0, "j_neck")
	local world_position_2 = Unit.world_position(arg_39_0, node_2)
	local num = world_position - world_position_2
	local length = Vector3.length(num)
	local get_data = World.get_data(arg_39_1.world, "physics_world")
	local immediate_raycast = PhysicsWorld.immediate_raycast(get_data, world_position_2, num, length, "all", "collision_filter", "filter_ray_projectile")

	if not immediate_raycast then
		local count = #immediate_raycast

		for i = 1, count do
			local var_39_9 = immediate_raycast[i][num_16]
			local unit = Actor.unit(var_39_9)

			if not (unit == arg_39_0 or unit == arg_39_1.target_unit) then
				return false
			end
		end
	end

	return true
end

LocomotionUtils.enable_linked_movement = function (arg_40_0, arg_40_1, arg_40_2, arg_40_3, arg_40_4)
	-- function 40
	if not Managers.player:owner(arg_40_1).remote then
		local unit_storage = Managers.state.unit_storage
		local go_id = unit_storage:go_id(arg_40_1)
		local owner = unit_storage:owner(go_id)
		local current_level = LevelHelper:current_level(arg_40_0)
		local unit_index = Level.unit_index(current_level, arg_40_2)
		local network = Managers.state.network

		if not network:game() then
			network.network_transmit:send_rpc("rpc_enable_linked_movement", owner, go_id, unit_index, arg_40_3, arg_40_4)
		end
	else
		ScriptUnit.extension(arg_40_1, "locomotion_system"):enable_linked_movement(arg_40_2, arg_40_3, arg_40_4)
	end
end

LocomotionUtils.disable_linked_movement = function (arg_41_0)
	-- function 41
	local owner = Managers.player:owner(arg_41_0)

	if not owner and not owner.remote then
		local unit_storage = Managers.state.unit_storage
		local go_id = unit_storage:go_id(arg_41_0)
		local owner_2 = unit_storage:owner(go_id)
		local network = Managers.state.network

		if not network:game() then
			network.network_transmit:send_rpc("rpc_disable_linked_movement", owner_2, go_id)
		end
	else
		ScriptUnit.extension(arg_41_0, "locomotion_system"):disable_linked_movement()
	end
end

LocomotionUtils.calculate_wanted_lerp_velocity = function (arg_42_0, arg_42_1, arg_42_2, arg_42_3, arg_42_4, arg_42_5, arg_42_6)
	-- function 42
	local min = math.min(1, (arg_42_6 - arg_42_3) / (arg_42_4 - arg_42_3))
	local lerp = Vector3.lerp(arg_42_1, arg_42_2, min)
	local num = Vector3.distance(arg_42_0, lerp) / arg_42_5
end

LocomotionUtils.in_crosshairs_dodge = function (arg_43_0, arg_43_1, arg_43_2, arg_43_3, arg_43_4, arg_43_5, arg_43_6)
	-- function 43
	arg_43_5 = arg_43_5 or 0
	arg_43_6 = arg_43_6 or math.huge

	local ENEMY_PLAYER_AND_BOT_UNITS = Managers.state.side.side_by_unit[arg_43_0].ENEMY_PLAYER_AND_BOT_UNITS
	local aim_times = arg_43_1.aim_times

	aim_times = aim_times or {}
	arg_43_1.aim_times = aim_times

	local aim_times_2 = arg_43_1.aim_times
	local debug_ai_movement = script_data.debug_ai_movement

	for i = 1, #ENEMY_PLAYER_AND_BOT_UNITS do
		local var_43_4 = ENEMY_PLAYER_AND_BOT_UNITS[i]
		local extension = ScriptUnit.extension(var_43_4, "inventory_system")
		local flag = extension:get_wielded_slot_name() == "slot_ranged"
		local get_wielded_slot_item_template = extension:get_wielded_slot_item_template()

		if not get_wielded_slot_item_template and not get_wielded_slot_item_template.no_dodge then
			flag = false
		end

		if not flag then
			local world_position = Unit.world_position(arg_43_0, Unit.node(arg_43_0, "j_neck"))
			local num = world_position - Unit.world_position(var_43_4, Unit.node(var_43_4, "camera_attach"))
			local current_rotation = ScriptUnit.extension(var_43_4, "locomotion_system"):current_rotation()
			local forward = Quaternion.forward(current_rotation)
			local length = Vector3.length(num)
			local num_2 = num - forward * length
			local length_2 = Vector3.length(num_2)
			local var_43_15

			if not (not (length_2 < arg_43_3) or not (arg_43_5 < length) or not (length < arg_43_6)) then
				local local_rotation = Unit.local_rotation(arg_43_0, 0)
				local forward_2 = Quaternion.forward(local_rotation)
				local normalize = Vector3.normalize(num)

				if Vector3.dot(normalize, forward_2) < -0.3 then
					if not arg_43_4 then
						local var_43_19 = aim_times_2[var_43_4]

						if not var_43_19 then
							var_43_19 = arg_43_2 + arg_43_4
							aim_times_2[var_43_4] = var_43_19
						elseif var_43_19 < arg_43_2 then
							return num_2, forward
						end

						if not debug_ai_movement then
							QuickDrawer:sphere(world_position, arg_43_3, Color(0, 255, 0))
							QuickDrawer:cylinder(world_position, world_position + Vector3(0, 0, var_43_19 - arg_43_2), 0.2, Color(0, 255, 0))
						end

						var_43_15 = true
					else
						return num_2, forward
					end
				elseif not debug_ai_movement then
					QuickDrawer:sphere(world_position, arg_43_3)
				end
			end

			if not var_43_15 then
				aim_times_2[var_43_4] = nil
			end
		end
	end
end

LocomotionUtils.separate_mover_fallbacks = function (arg_44_0, arg_44_1)
	-- function 44
	local separate, var_44_1, var_44_2, var_44_3 = Mover.separate(arg_44_0, arg_44_1)

	if not separate and not var_44_3 then
		Mover.set_position(arg_44_0, var_44_3)
	end

	return not separate and var_44_3 and not separate
end

LocomotionUtils.on_alerted_dodge = function (arg_45_0, arg_45_1, arg_45_2, arg_45_3)
	-- function 45
	local world_position = Unit.world_position(arg_45_0, Unit.node(arg_45_0, "j_neck"))
	local var_45_1
	local var_45_2
	local get_actual_attacker_unit = AiUtils.get_actual_attacker_unit(arg_45_3)

	if not DamageUtils.is_player_unit(get_actual_attacker_unit) then
		local has_extension = ScriptUnit.has_extension(get_actual_attacker_unit, "locomotion_system")
		local has_node = Unit.has_node(get_actual_attacker_unit, "camera_attach")

		has_node = not has_node and Unit.node(get_actual_attacker_unit, "camera_attach")
		var_45_2 = has_extension:current_rotation()
		var_45_1 = Unit.world_position(get_actual_attacker_unit, has_node)
	else
		var_45_2 = Unit.world_rotation(get_actual_attacker_unit, 0)
		var_45_1 = Unit.world_position(get_actual_attacker_unit, 0)
	end

	local num = world_position - var_45_1
	local forward = Quaternion.forward(var_45_2)

	return num - forward * Vector3.length(num), forward
end

LocomotionUtils.get_vortex_spin_velocity = function (arg_46_0, arg_46_1, arg_46_2, arg_46_3, arg_46_4, arg_46_5, arg_46_6, arg_46_7)
	-- function 46
	local num = 0.0001
	local num_2 = arg_46_0 - arg_46_1
	local flat = Vector3.flat(num_2)
	local normalize = Vector3.normalize(flat)
	local length = Vector3.length(flat)
	local num_3 = arg_46_4 / math.max(length, num) * arg_46_7
	local axis_angle = Quaternion.axis_angle(arg_46_3, num_3)
	local var_46_7

	if arg_46_2 < length then
		var_46_7 = math.max(length - arg_46_5 * arg_46_7, arg_46_2)
	else
		var_46_7 = math.min(length + arg_46_5 * arg_46_7, arg_46_2)
	end

	local num_4 = num_2.z + arg_46_6 * arg_46_7
	local num_5 = (arg_46_1 + Quaternion.rotate(axis_angle, normalize) * var_46_7 + num_4 * arg_46_3 - arg_46_0) / math.max(arg_46_7, num)
	local cross = Vector3.cross(normalize, Vector3.up())

	return num_5, var_46_7, num_4, cross
end

local function fn(...)
	-- function 47
	if not script_data.debug_big_boy_turning then
		Debug.sticky_text(...)
	end
end

LocomotionUtils.check_start_turning = function (arg_48_0, arg_48_1, arg_48_2, arg_48_3)
	-- function 48
	local start_anims_name = arg_48_3.action.start_anims_name
	local breed = arg_48_3.breed

	fassert(start_anims_name, "Breed %s is using big boy turning without having start_anims defined in follow action", breed.name)

	local locomotion_extension = arg_48_3.locomotion_extension
	local navigation_extension = arg_48_3.navigation_extension
	local var_48_4 = POSITION_LOOKUP[arg_48_0]
	local wanted_destination = arg_48_3.wanted_destination

	wanted_destination = not wanted_destination and arg_48_3.wanted_destination:unbox()

	if not wanted_destination then
		return
	end

	local is_computing_path = navigation_extension:is_computing_path()
	local is_following_path = navigation_extension:is_following_path()

	if not (is_computing_path or is_following_path) then
		return
	end

	local get_current_and_next_node_positions_in_nav_path, var_48_9, var_48_10 = navigation_extension:get_current_and_next_node_positions_in_nav_path()

	if not (get_current_and_next_node_positions_in_nav_path == nil or var_48_9 ~= nil) then
		return
	end

	local flag = not var_48_10 and var_48_10 and var_48_9
	local normalize = Vector3.normalize(flag - get_current_and_next_node_positions_in_nav_path)
	local world_rotation = Unit.world_rotation(arg_48_0, 0)
	local forward = Quaternion.forward(world_rotation)
	local right = Quaternion.right(world_rotation)
	local normalize_2 = Vector3.normalize(navigation_extension:desired_velocity())

	LocomotionUtils.update_leaning(arg_48_0, arg_48_3, flag)

	local dot = Vector3.dot(right, normalize)
	local dot_2 = Vector3.dot(forward, normalize)
	local abs = math.abs(dot)
	local abs_2 = math.abs(dot_2)

	if not (dot_2 > breed.big_boy_turning_dot) then
		return
	end

	local var_48_21

	if abs_2 < abs then
		if dot > 0 then
			var_48_21 = start_anims_name.right
		else
			var_48_21 = start_anims_name.left
		end
	else
		var_48_21 = start_anims_name.bwd
	end

	Managers.state.network:anim_event(arg_48_0, var_48_21)

	arg_48_3.move_animation_name = var_48_21
	arg_48_3.rotate_towards_position = Vector3Box(var_48_9)
	arg_48_3.is_turning = true
	arg_48_3.anim_cb_rotation_start = nil
	arg_48_3.anim_cb_move = nil
end

LocomotionUtils.update_leaning = function (arg_49_0, arg_49_1, arg_49_2)
	-- function 49
	if not arg_49_1.enabled_animation_movement_system then
		local go_id = Managers.state.unit_storage:go_id(arg_49_0)

		Managers.state.network.network_transmit:send_rpc_all("rpc_enable_animation_movement_system", go_id, true)

		arg_49_1.enabled_animation_movement_system = true
	end

	local lean_target_position_boxed = arg_49_1.lean_target_position_boxed

	lean_target_position_boxed = lean_target_position_boxed or Vector3Box()
	arg_49_1.lean_target_position_boxed = lean_target_position_boxed

	arg_49_1.lean_target_position_boxed:store(arg_49_2)
end

LocomotionUtils.update_turning = function (arg_50_0, arg_50_1, arg_50_2, arg_50_3)
	-- function 50
	local locomotion_extension = arg_50_3.locomotion_extension
	local navigation_extension = arg_50_3.navigation_extension
	local var_50_2 = POSITION_LOOKUP[arg_50_0]

	if not arg_50_3.anim_cb_rotation_start then
		arg_50_3.anim_cb_rotation_start = nil

		if not arg_50_3.is_turning then
			local unbox = arg_50_3.rotate_towards_position:unbox()
			local get_animation_rotation_scale = AiAnimUtils.get_animation_rotation_scale(arg_50_0, unbox, arg_50_3.move_animation_name, arg_50_3.action.start_anims_data)

			locomotion_extension:use_lerp_rotation(false)
			LocomotionUtils.set_animation_driven_movement(arg_50_0, true, false, false)
			LocomotionUtils.set_animation_rotation_scale(arg_50_0, get_animation_rotation_scale)

			arg_50_3.animation_rotation_lock = true
		end
	end

	if not arg_50_3.anim_cb_move then
		arg_50_3.anim_cb_move = nil

		LocomotionUtils.reset_turning(arg_50_0, arg_50_3)
	end
end

LocomotionUtils.reset_turning = function (arg_51_0, arg_51_1)
	-- function 51
	arg_51_1.is_turning = false

	LocomotionUtils.set_animation_driven_movement(arg_51_0, false)
	LocomotionUtils.set_animation_rotation_scale(arg_51_0, 1)

	local go_id = Managers.state.unit_storage:go_id(arg_51_0)

	Managers.state.network.network_transmit:send_rpc_all("rpc_enable_animation_movement_system", go_id, false)

	arg_51_1.lean_target_position_boxed = nil
	arg_51_1.enabled_animation_movement_system = nil
end
