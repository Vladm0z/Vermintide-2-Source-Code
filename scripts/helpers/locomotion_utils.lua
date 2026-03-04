-- chunkname: @scripts/helpers/locomotion_utils.lua

LocomotionUtils = {}

local var_0_0 = Unit.local_position
local var_0_1 = Unit.set_local_rotation
local var_0_2 = Quaternion.look

LocomotionUtils.follow_target = function (arg_1_0, arg_1_1, arg_1_2, arg_1_3)
	if not Unit.alive(arg_1_1.target_unit) then
		return
	end

	local var_1_0 = arg_1_1.breed
	local var_1_1 = var_0_0(arg_1_0, 0)
	local var_1_2 = var_0_0(arg_1_1.target_unit, 0)
	local var_1_3

	if arg_1_1.remembered_threat_pos then
		var_1_3 = Vector3.distance(Vector3Box.unbox(arg_1_1.remembered_threat_pos), var_1_2) > 1
	else
		arg_1_1.remembered_threat_pos = Vector3Box()
		var_1_3 = true
	end

	if var_1_3 then
		Vector3Box.store(arg_1_1.remembered_threat_pos, var_1_2)

		local var_1_4 = Unit.local_position(arg_1_1.target_unit, 0) - Vector3.normalize(var_1_2 - var_1_1) * var_1_0.radius
		local var_1_5, var_1_6 = GwNavQueries.triangle_from_position(arg_1_1.nav_world, var_1_4)

		if var_1_5 then
			var_1_4.z = var_1_6

			ScriptUnit.extension(arg_1_0, "ai_system"):navigation():move_to(var_1_4)

			arg_1_1.target_outside_navmesh = false
		else
			arg_1_1.target_outside_navmesh = true
		end
	end
end

LocomotionUtils.follow_target_ogre = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3)
	local var_2_0 = arg_2_1.target_unit

	if not Unit.alive(var_2_0) then
		return
	end

	local var_2_1 = POSITION_LOOKUP[arg_2_0]
	local var_2_2 = ScriptUnit.has_extension(var_2_0, "status_system")
	local var_2_3
	local var_2_4

	if var_2_2 then
		var_2_3, var_2_4 = var_2_2:get_is_on_ladder()
	end

	local var_2_5
	local var_2_6

	if var_2_3 then
		local var_2_7, var_2_8 = Managers.state.bot_nav_transition:get_ladder_coordinates(var_2_4)

		var_2_5 = var_2_7
		var_2_6 = var_2_7
	else
		var_2_5 = POSITION_LOOKUP[var_2_0]
	end

	local var_2_9

	if arg_2_1.remembered_threat_pos then
		var_2_9 = Vector3.distance(Vector3Box.unbox(arg_2_1.remembered_threat_pos), var_2_5) > 1

		if not var_2_9 and arg_2_2 > arg_2_1.next_move_check then
			arg_2_1.next_move_check = arg_2_2 + 2

			local var_2_10 = arg_2_1.nav_world
			local var_2_11, var_2_12 = GwNavQueries.triangle_from_position(var_2_10, var_2_5, 2, 2)

			if not var_2_11 then
				var_2_9 = true
			end
		end
	else
		arg_2_1.remembered_threat_pos = Vector3Box(var_2_5)
		var_2_9 = true
	end

	if var_2_9 then
		Vector3Box.store(arg_2_1.remembered_threat_pos, var_2_5)

		local var_2_13 = var_2_5 - var_2_1
		local var_2_14 = arg_2_1.breed
		local var_2_15 = arg_2_1.nav_world

		var_2_6 = var_2_6 or Unit.local_position(arg_2_1.target_unit, 0) - Vector3.normalize(var_2_13) * var_2_14.radius

		local var_2_16
		local var_2_17
		local var_2_18
		local var_2_19, var_2_20 = GwNavQueries.triangle_from_position(var_2_15, var_2_6, 30, 30)

		if var_2_19 and math.abs(var_2_6[3] - var_2_20) <= 2 then
			var_2_6.z = var_2_20

			arg_2_1.navigation_extension:move_to(var_2_6)

			arg_2_1.target_outside_navmesh = false

			return var_2_6
		end

		local var_2_21 = 2
		local var_2_22 = 2
		local var_2_23 = 3
		local var_2_24 = 3
		local var_2_25 = GwNavQueries.inside_position_from_outside_position(var_2_15, var_2_6, var_2_21, var_2_22, var_2_23, var_2_24)

		if var_2_25 then
			arg_2_1.navigation_extension:move_to(var_2_25)

			arg_2_1.target_outside_navmesh = false

			return var_2_25
		end

		if var_2_19 then
			var_2_6.z = var_2_20

			arg_2_1.navigation_extension:move_to(var_2_6)

			arg_2_1.target_outside_navmesh = false

			return var_2_6
		end

		if Vector3.length(var_2_13) > 5 then
			local var_2_26, var_2_27 = GwNavQueries.triangle_from_position(var_2_15, var_2_5, 2, 2)

			if var_2_26 then
				local var_2_28 = Vector3(var_2_5.x, var_2_5.y, var_2_27)

				arg_2_1.navigation_extension:move_to(var_2_28)

				arg_2_1.target_outside_navmesh = false

				return var_2_28
			end
		end

		arg_2_1.target_outside_navmesh = true
	end
end

local var_0_3 = {
	ROTATION_LERP_LOOK_AT = 20
}

LocomotionUtils.update_combat_rotation = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3)
	local var_3_0 = var_0_0(arg_3_0, 0)
	local var_3_1 = Unit.local_rotation(arg_3_0, 0)
	local var_3_2 = Unit.local_position(arg_3_1.target_unit, 0)
	local var_3_3 = var_0_2(var_3_2 - var_3_0, Vector3.up())
	local var_3_4 = math.smoothstep(arg_3_3 * var_0_3.ROTATION_LERP_LOOK_AT, 0, 1)
	local var_3_5 = Quaternion.lerp(var_3_1, var_3_3, var_3_4)

	var_0_1(arg_3_0, 0, var_3_5)
end

LocomotionUtils.look_at_target_rotation = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3)
	local var_4_0 = var_0_0(arg_4_0, 0)
	local var_4_1 = Unit.local_rotation(arg_4_0, 0)
	local var_4_2 = Unit.local_position(arg_4_1.target_unit, 0)
	local var_4_3 = var_0_2(var_4_2 - var_4_0, Vector3.up())
	local var_4_4 = math.smoothstep(arg_4_3 * var_0_3.ROTATION_LERP_LOOK_AT, 0, 1)

	return (Quaternion.lerp(var_4_1, var_4_3, var_4_4))
end

LocomotionUtils.look_at_target_rotation_flat = function (arg_5_0, arg_5_1, arg_5_2, arg_5_3)
	local var_5_0 = var_0_0(arg_5_0, 0)
	local var_5_1 = Unit.local_rotation(arg_5_0, 0)
	local var_5_2 = Unit.local_position(arg_5_1.target_unit, 0) - var_5_0

	Vector3.set_z(var_5_2, 0)

	local var_5_3 = var_0_2(var_5_2, Vector3.up())
	local var_5_4 = math.smoothstep(arg_5_3 * var_0_3.ROTATION_LERP_LOOK_AT, 0, 1)

	return (Quaternion.lerp(var_5_1, var_5_3, var_5_4))
end

LocomotionUtils.rotation_towards_unit = function (arg_6_0, arg_6_1)
	local var_6_0 = var_0_0(arg_6_0, 0)
	local var_6_1 = var_0_0(arg_6_1, 0)
	local var_6_2 = Vector3.normalize(var_6_1 - var_6_0)

	return (var_0_2(var_6_2))
end

LocomotionUtils.rotation_towards_unit_flat = function (arg_7_0, arg_7_1)
	local var_7_0 = var_0_0(arg_7_0, 0)
	local var_7_1 = var_0_0(arg_7_1, 0) - var_7_0

	var_7_1.z = 0

	local var_7_2 = Vector3.normalize(var_7_1)

	return (var_0_2(var_7_2))
end

LocomotionUtils.look_at_position = function (arg_8_0, arg_8_1)
	local var_8_0 = var_0_0(arg_8_0, 0)
	local var_8_1 = Vector3.normalize(arg_8_1 - var_8_0)

	return (var_0_2(var_8_1, Vector3.up()))
end

LocomotionUtils.look_at_position_flat = function (arg_9_0, arg_9_1)
	local var_9_0 = var_0_0(arg_9_0, 0)
	local var_9_1 = Vector3.flat(arg_9_1 - var_9_0)
	local var_9_2 = Vector3.normalize(var_9_1)

	return (var_0_2(var_9_2, Vector3.up()))
end

LocomotionUtils.get_attack_anim = function (arg_10_0, arg_10_1, arg_10_2)
	if arg_10_2 then
		local var_10_0 = arg_10_1.target_unit
		local var_10_1 = Unit.local_position(var_10_0, 0)
		local var_10_2 = Unit.local_position(arg_10_0, 0)
		local var_10_3 = Vector3.normalize(var_10_2 - var_10_1)
		local var_10_4 = Quaternion.forward(Unit.local_rotation(arg_10_0, 0))
		local var_10_5 = Vector3.dot(var_10_4, var_10_3)
		local var_10_6 = math.clamp(var_10_5, -1, 1)
		local var_10_7 = math.acos(var_10_6)

		if var_10_7 > math.pi * 0.95 then
			return arg_10_2.directly_fwd[1], arg_10_2.directly_fwd[2]
		elseif var_10_7 > math.pi * 0.75 then
			return arg_10_2.fwd[1], arg_10_2.fwd[2]
		elseif var_10_7 < math.pi * 0.25 then
			return arg_10_2.bwd[1], arg_10_2.bwd[2]
		elseif Vector3.cross(var_10_4, var_10_3).z > 0 then
			return arg_10_2.right[1], arg_10_2.right[2]
		else
			return arg_10_2.left[1], arg_10_2.left[2]
		end
	end

	return nil, false
end

LocomotionUtils.get_start_anim = function (arg_11_0, arg_11_1, arg_11_2)
	if arg_11_2 then
		local var_11_0 = arg_11_1.target_unit
		local var_11_1 = Unit.local_position(var_11_0, 0)
		local var_11_2 = Unit.local_position(arg_11_0, 0)
		local var_11_3 = Vector3.normalize(var_11_2 - var_11_1)
		local var_11_4 = Quaternion.forward(Unit.local_rotation(arg_11_0, 0))
		local var_11_5 = Vector3.dot(var_11_4, var_11_3)
		local var_11_6 = math.clamp(var_11_5, -1, 1)
		local var_11_7 = math.acos(var_11_6)

		if var_11_7 > math.pi * 0.75 then
			return arg_11_2.fwd
		elseif var_11_7 < math.pi * 0.25 then
			return arg_11_2.bwd, true
		elseif Vector3.cross(var_11_4, var_11_3).z > 0 then
			return arg_11_2.right
		else
			return arg_11_2.left
		end
	end
end

LocomotionUtils.constrain_on_clients = function (arg_12_0, arg_12_1, arg_12_2, arg_12_3)
	local var_12_0 = Managers.state.network

	if var_12_0:game() then
		local var_12_1 = FrameTable.alloc_table()

		if arg_12_1 then
			var_12_1[1] = Vector3(math.min(arg_12_2.x, arg_12_3.x), math.min(arg_12_2.y, arg_12_3.y), math.min(arg_12_2.z, arg_12_3.z))
			var_12_1[2] = Vector3(math.max(arg_12_2.x, arg_12_3.x), math.max(arg_12_2.y, arg_12_3.y), math.max(arg_12_2.z, arg_12_3.z))
		end

		local var_12_2 = Managers.state.unit_storage:go_id(arg_12_0)

		var_12_0.network_transmit:send_rpc_clients("rpc_constrain_ai", var_12_2, arg_12_1, var_12_1)
	end
end

LocomotionUtils.set_animation_driven_movement = function (arg_13_0, arg_13_1, arg_13_2, arg_13_3, arg_13_4)
	ScriptUnit.extension(arg_13_0, "locomotion_system"):set_animation_driven(arg_13_1, arg_13_2, arg_13_3, arg_13_4)
end

LocomotionUtils.set_animation_translation_scale = function (arg_14_0, arg_14_1)
	local var_14_0 = ScriptUnit.extension(arg_14_0, "locomotion_system")
	local var_14_1 = var_14_0:get_animation_translation_scale()

	if not Vector3.equal(var_14_1, arg_14_1) then
		var_14_0:set_animation_translation_scale(arg_14_1)

		local var_14_2 = Managers.state.network

		if var_14_2:game() then
			local var_14_3 = Managers.state.unit_storage:go_id(arg_14_0)

			if var_14_2.is_server then
				var_14_2.network_transmit:send_rpc_clients("rpc_set_animation_translation_scale", var_14_3, arg_14_1)
			else
				var_14_2.network_transmit:send_rpc_server("rpc_set_animation_translation_scale", var_14_3, arg_14_1)
			end
		end
	end
end

LocomotionUtils.set_animation_rotation_scale = function (arg_15_0, arg_15_1)
	local var_15_0 = ScriptUnit.extension(arg_15_0, "locomotion_system")

	if var_15_0:get_animation_rotation_scale() ~= arg_15_1 then
		var_15_0:set_animation_rotation_scale(arg_15_1)

		local var_15_1 = Managers.state.network

		if var_15_1:game() then
			local var_15_2 = Managers.state.unit_storage:go_id(arg_15_0)

			var_15_1.network_transmit:send_rpc_clients("rpc_set_animation_rotation_scale", var_15_2, arg_15_1)
		end
	end
end

LocomotionUtils.update_local_animation_driven_movement = function (arg_16_0, arg_16_1)
	local var_16_0 = Unit.animation_wanted_root_pose(arg_16_0)
	local var_16_1 = Matrix4x4.translation(var_16_0)

	Unit.set_local_position(arg_16_0, 0, var_16_1)

	local var_16_2 = Matrix4x4.rotation(var_16_0)

	Unit.set_local_rotation(arg_16_0, 0, var_16_2)
end

LocomotionUtils.update_local_animation_driven_movement_with_parent = function (arg_17_0, arg_17_1, arg_17_2)
	local var_17_0 = arg_17_2.master_unit

	if not var_17_0 or not Unit.alive(var_17_0) then
		return
	end

	local var_17_1 = Unit.local_position(var_17_0, 0)
	local var_17_2 = Unit.animation_wanted_root_pose(arg_17_0)

	Unit.set_local_position(arg_17_0, 0, var_17_1)

	local var_17_3 = Matrix4x4.rotation(var_17_2)

	Unit.set_local_rotation(arg_17_0, 0, var_17_3)
end

LocomotionUtils.update_local_animation_driven_movement_with_mover = function (arg_18_0, arg_18_1)
	local var_18_0 = Unit.animation_wanted_root_pose(arg_18_0)
	local var_18_1 = Matrix4x4.translation(var_18_0) - POSITION_LOOKUP[arg_18_0]
	local var_18_2 = Unit.mover(arg_18_0)

	Mover.move(var_18_2, var_18_1, arg_18_1)

	local var_18_3 = Mover.position(var_18_2)

	Unit.set_local_position(arg_18_0, 0, var_18_3)

	local var_18_4 = Matrix4x4.rotation(var_18_0)

	Unit.set_local_rotation(arg_18_0, 0, var_18_4)
end

LocomotionUtils.update_local_animation_driven_movement_plus_mover = function (arg_19_0, arg_19_1)
	local var_19_0 = Unit.mover(arg_19_0)
	local var_19_1 = Unit.animation_wanted_root_pose(arg_19_0)
	local var_19_2 = Matrix4x4.translation(var_19_1)
	local var_19_3 = var_19_2 - Mover.position(var_19_0)

	Mover.move(var_19_0, var_19_3, arg_19_1)
	Unit.set_local_position(arg_19_0, 0, var_19_2)

	local var_19_4 = Matrix4x4.rotation(var_19_1)

	Unit.set_local_rotation(arg_19_0, 0, var_19_4)
end

LocomotionUtils.update_local_animation_driven_movement_with_min_z = function (arg_20_0, arg_20_1, arg_20_2)
	local var_20_0 = Unit.animation_wanted_root_pose(arg_20_0)
	local var_20_1 = Matrix4x4.translation(var_20_0)

	if arg_20_2 > var_20_1.z then
		Vector3.set_z(var_20_1, arg_20_2)
	end

	Unit.set_local_position(arg_20_0, 0, var_20_1)

	local var_20_2 = Matrix4x4.rotation(var_20_0)

	Unit.set_local_rotation(arg_20_0, 0, var_20_2)
end

LocomotionUtils.new_random_goal = function (arg_21_0, arg_21_1, arg_21_2, arg_21_3, arg_21_4, arg_21_5, arg_21_6, arg_21_7, arg_21_8)
	local var_21_0 = arg_21_7 or 30
	local var_21_1 = arg_21_8 or 30
	local var_21_2 = 0

	while var_21_2 < arg_21_5 do
		local var_21_3 = arg_21_3 + math.random() * (arg_21_4 - arg_21_3)
		local var_21_4 = Vector3(var_21_3, 0, 1.5)
		local var_21_5 = arg_21_2 + Quaternion.rotate(Quaternion(Vector3.up(), math.degrees_to_radians(Math.random(1, 360))), var_21_4)

		if arg_21_6 then
			arg_21_6[#arg_21_6 + 1] = Vector3Box(var_21_5)
		end

		local var_21_6, var_21_7 = GwNavQueries.triangle_from_position(arg_21_0, var_21_5, var_21_0, var_21_1)

		if var_21_6 then
			var_21_5.z = var_21_7

			return var_21_5
		end

		var_21_2 = var_21_2 + 1
	end
end

LocomotionUtils.new_random_goal_uniformly_distributed = function (arg_22_0, arg_22_1, arg_22_2, arg_22_3, arg_22_4, arg_22_5, arg_22_6, arg_22_7, arg_22_8)
	arg_22_7 = arg_22_7 or 30
	arg_22_8 = arg_22_8 or 30

	local var_22_0 = 0

	while var_22_0 < arg_22_5 do
		local var_22_1 = (arg_22_3 / arg_22_4)^2
		local var_22_2 = var_22_1 + Math.random() * (1 - var_22_1)
		local var_22_3 = math.sqrt(var_22_2) * arg_22_4
		local var_22_4 = Vector3(var_22_3, 0, 1.5)
		local var_22_5 = arg_22_2 + Quaternion.rotate(Quaternion(Vector3.up(), Math.random() * math.pi * 2), var_22_4)

		if arg_22_6 then
			arg_22_6[#arg_22_6 + 1] = Vector3Box(var_22_5)
		end

		local var_22_6, var_22_7 = GwNavQueries.triangle_from_position(arg_22_0, var_22_5, arg_22_7, arg_22_8)

		if var_22_6 then
			var_22_5.z = var_22_7

			return var_22_5
		end

		var_22_0 = var_22_0 + 1
	end
end

LocomotionUtils.new_random_goal_uniformly_distributed_with_inside_from_outside_on_last = function (arg_23_0, arg_23_1, arg_23_2, arg_23_3, arg_23_4, arg_23_5, arg_23_6, arg_23_7, arg_23_8, arg_23_9)
	local var_23_0 = arg_23_7 or 30
	local var_23_1 = arg_23_8 or 30
	local var_23_2 = arg_23_9 or 3
	local var_23_3 = 0.1
	local var_23_4 = 0

	while var_23_4 < arg_23_5 do
		local var_23_5 = (arg_23_3 / arg_23_4)^2
		local var_23_6 = var_23_5 + Math.random() * (1 - var_23_5)
		local var_23_7 = math.sqrt(var_23_6) * arg_23_4
		local var_23_8 = Vector3(var_23_7, 0, 1.5)
		local var_23_9 = arg_23_2 + Quaternion.rotate(Quaternion(Vector3.up(), Math.random() * math.pi * 2), var_23_8)

		if arg_23_6 then
			arg_23_6[#arg_23_6 + 1] = Vector3Box(var_23_9)
		end

		local var_23_10, var_23_11 = GwNavQueries.triangle_from_position(arg_23_0, var_23_9, var_23_0, var_23_1)

		if var_23_10 then
			var_23_9.z = var_23_11

			return var_23_9
		end

		if var_23_4 == arg_23_5 - 1 then
			local var_23_12 = GwNavQueries.inside_position_from_outside_position(arg_23_0, var_23_9, var_23_0, var_23_1, var_23_2, var_23_3)

			if var_23_12 then
				return var_23_12
			end
		end

		var_23_4 = var_23_4 + 1
	end
end

LocomotionUtils.new_random_goal_in_front_of_unit = function (arg_24_0, arg_24_1, arg_24_2, arg_24_3, arg_24_4, arg_24_5, arg_24_6, arg_24_7, arg_24_8, arg_24_9)
	local var_24_0

	var_24_0 = arg_24_8 or 30

	local var_24_1

	var_24_1 = arg_24_9 or 30

	local var_24_2 = 0
	local var_24_3 = Unit.local_position(arg_24_1, 0)

	while var_24_2 < arg_24_4 do
		local var_24_4 = ScriptUnit.has_extension(arg_24_1, "locomotion_system")
		local var_24_5
		local var_24_6

		if var_24_4 and var_24_4.average_velocity then
			local var_24_7 = Vector3.flat(var_24_4:average_velocity())

			var_24_6 = Vector3.length(var_24_7)

			if var_24_6 > 0.1 then
				var_24_5 = var_24_7
			else
				var_24_5 = Quaternion.forward(Unit.local_rotation(arg_24_1, 0))
			end
		else
			var_24_5 = Quaternion.forward(Unit.local_rotation(arg_24_1, 0))
			var_24_6 = 0
		end

		local var_24_8 = 0
		local var_24_9 = 4
		local var_24_10 = math.auto_lerp(var_24_8, var_24_9, arg_24_2, arg_24_3, var_24_6)
		local var_24_11 = math.lerp(arg_24_6, arg_24_7, Math.random())

		if Math.random() < 0.5 then
			var_24_11 = -var_24_11
		end

		local var_24_12 = Vector3.normalize(var_24_5)
		local var_24_13 = Vector3.cross(var_24_12, Vector3.up())
		local var_24_14 = var_24_3 + var_24_12 * var_24_10 + var_24_13 * var_24_11

		if arg_24_5 then
			arg_24_5[#arg_24_5 + 1] = Vector3Box(var_24_14)
		end

		local var_24_15, var_24_16 = GwNavQueries.triangle_from_position(arg_24_0, var_24_14, 30, 30)

		if var_24_15 then
			var_24_14.z = var_24_16

			return var_24_14
		end

		var_24_2 = var_24_2 + 1
	end

	return nil
end

LocomotionUtils.new_goal_in_transport = function (arg_25_0, arg_25_1, arg_25_2)
	local var_25_0 = 0
	local var_25_1 = ScriptUnit.extension(arg_25_2, "status_system"):get_inside_transport_unit()

	if Unit.alive(var_25_1) then
		local var_25_2 = ScriptUnit.extension(var_25_1, "transportation_system"):assign_position_to_bot()
		local var_25_3, var_25_4 = GwNavQueries.triangle_from_position(arg_25_0, var_25_2, 30, 30)

		if var_25_3 then
			var_25_2.z = var_25_4

			return var_25_2
		end
	end

	return nil
end

LocomotionUtils.outside_goal = function (arg_26_0, arg_26_1, arg_26_2, arg_26_3, arg_26_4, arg_26_5, arg_26_6, arg_26_7, arg_26_8)
	local var_26_0 = 0
	local var_26_1 = Vector3.flat(arg_26_1 - arg_26_2)

	if Vector3.length_squared(var_26_1) < 0.001 then
		return
	end

	local var_26_2 = arg_26_4 - arg_26_3
	local var_26_3 = (arg_26_3 + arg_26_4) * 0.5
	local var_26_4 = var_26_2 / arg_26_6
	local var_26_5 = Vector3.normalize(var_26_1)
	local var_26_6 = math.degrees_to_radians(arg_26_5)

	while var_26_0 < arg_26_6 do
		local var_26_7 = (var_26_0 % 2 - 0.5) * 2
		local var_26_8 = var_26_3 + (math.floor(var_26_0 * 0.5) + Math.random()) * var_26_7 * var_26_4
		local var_26_9 = var_26_5 * var_26_8
		local var_26_10 = arg_26_2 + Quaternion.rotate(Quaternion(Vector3.up(), var_26_6), var_26_9)
		local var_26_11, var_26_12 = GwNavQueries.triangle_from_position(arg_26_0, var_26_10, arg_26_7 or 30, arg_26_8 or 30)

		if var_26_11 then
			var_26_10.z = var_26_12

			return var_26_10, var_26_8
		end

		var_26_0 = var_26_0 + 1
	end
end

local var_0_4 = 10
local var_0_5 = 0
local var_0_6 = 4
local var_0_7 = 8
local var_0_8 = 3

LocomotionUtils.pick_visible_outside_goal = function (arg_27_0)
	local var_27_0 = arg_27_0.max_tries or var_0_4
	local var_27_1 = arg_27_0.min_angle or var_0_5
	local var_27_2 = arg_27_0.min_angle_step or var_0_6
	local var_27_3 = arg_27_0.max_angle_step or var_0_7
	local var_27_4 = arg_27_0.outside_goal_tries or var_0_8
	local var_27_5 = arg_27_0.nav_world
	local var_27_6 = arg_27_0.physics_world
	local var_27_7 = arg_27_0.from_unit
	local var_27_8 = arg_27_0.to_unit
	local var_27_9 = arg_27_0.from_node_name
	local var_27_10 = arg_27_0.to_node_name
	local var_27_11 = arg_27_0.min_distance
	local var_27_12 = arg_27_0.max_distance
	local var_27_13 = arg_27_0.above
	local var_27_14 = arg_27_0.below
	local var_27_15 = Unit.node(var_27_7, var_27_9)
	local var_27_16 = Unit.world_position(var_27_7, var_27_15)
	local var_27_17 = Unit.node(var_27_8, var_27_10)
	local var_27_18 = Unit.world_position(var_27_8, var_27_17)
	local var_27_19
	local var_27_20 = arg_27_0.min_wanted_radius
	local var_27_21 = var_27_20 and var_27_20^2
	local var_27_22 = arg_27_0.radius_check_directions
	local var_27_23 = var_27_22 and #var_27_22
	local var_27_24 = arg_27_0.traverse_logic
	local var_27_25 = POSITION_LOOKUP[var_27_7]
	local var_27_26 = POSITION_LOOKUP[var_27_8]
	local var_27_27 = arg_27_0.direction or 1 - math.random(0, 1) * 2
	local var_27_28 = Vector3.up() * 0.05
	local var_27_29

	for iter_27_0 = 1, 2 do
		for iter_27_1 = 1, var_27_0 do
			local var_27_30 = var_27_1 + math.random(var_27_2 * iter_27_1, var_27_3 * iter_27_1) * var_27_27
			local var_27_31, var_27_32 = LocomotionUtils.outside_goal(var_27_5, var_27_25, var_27_26, var_27_11, var_27_12, var_27_30, var_27_4, var_27_13, var_27_14)

			if var_27_31 then
				local var_27_33, var_27_34 = PerceptionUtils.is_position_in_line_of_sight(var_27_7, var_27_16, var_27_31 + var_27_28, var_27_6)
				local var_27_35
				local var_27_36

				if var_27_33 then
					local var_27_37

					var_27_35, var_27_37 = PerceptionUtils.is_position_in_line_of_sight(var_27_8, var_27_18, var_27_31 + var_27_28, var_27_6)
					var_27_29 = var_27_35
				end

				if var_27_35 and var_27_22 then
					var_27_19 = math.huge

					for iter_27_2 = 1, var_27_23 do
						local var_27_38 = var_27_31 + var_27_22[iter_27_2]:unbox()
						local var_27_39
						local var_27_40

						if var_27_24 then
							local var_27_41

							var_27_41, var_27_40 = GwNavQueries.raycast(var_27_5, var_27_31, var_27_38, var_27_24)
						else
							local var_27_42

							var_27_42, var_27_40 = GwNavQueries.raycast(var_27_5, var_27_31, var_27_38)
						end

						local var_27_43 = Vector3.distance_squared(var_27_31, var_27_40)

						if var_27_43 < var_27_21 then
							var_27_29 = false

							break
						elseif var_27_43 < var_27_19 then
							var_27_19 = var_27_43
						end
					end
				end

				if var_27_29 then
					local var_27_44 = var_27_19 and math.sqrt(var_27_19)

					return var_27_31, var_27_44, var_27_32, var_27_27
				end
			end
		end

		var_27_27 = -var_27_27
	end
end

LocomotionUtils.test_pos = function (arg_28_0, arg_28_1)
	local var_28_0 = 0
	local var_28_1 = 0

	for iter_28_0 = -10, 10 do
		for iter_28_1 = -10, 10 do
			local var_28_2 = arg_28_1 + Vector3(iter_28_0, iter_28_1, 0)
			local var_28_3 = LocomotionUtils.pos_on_mesh(arg_28_0, var_28_2)

			if var_28_3 then
				QuickDrawer:sphere(var_28_3, 0.2, Color(255, 144, 43, 207))

				var_28_1 = var_28_1 + 1
			else
				var_28_0 = var_28_0 + 1
			end
		end
	end

	Debug.text("Points ok %.2f fail: %d", var_28_1 / (var_28_1 + var_28_0), var_28_0)
end

LocomotionUtils.get_close_pos_on_mesh = function (arg_29_0, arg_29_1, arg_29_2)
	local var_29_0 = {}
	local var_29_1, var_29_2, var_29_3, var_29_4, var_29_5 = GwNavQueries.triangle_from_position(arg_29_0, arg_29_1, 30, 30)

	if var_29_1 then
		local var_29_6 = Vector3(arg_29_1.x, arg_29_1.y, var_29_2)

		print("BOSS POINT FOUND AT FIRST POINT OK!")

		return var_29_6
	end

	var_29_0[#var_29_0 + 1] = Vector3Box(arg_29_1)
	arg_29_2 = arg_29_2 or 4

	for iter_29_0 = 1, 4 do
		for iter_29_1 = -1, 1 do
			for iter_29_2 = -1, 1 do
				if iter_29_1 ~= 0 or iter_29_2 ~= 0 then
					local var_29_7 = arg_29_1 + Vector3(iter_29_1 * iter_29_0, iter_29_2 * iter_29_0, 0)
					local var_29_8, var_29_9, var_29_10, var_29_11, var_29_12 = GwNavQueries.triangle_from_position(arg_29_0, var_29_7, 30, 30)

					if var_29_8 then
						local var_29_13 = Vector3(var_29_7.x, var_29_7.y, var_29_9)

						print("BOSS POINT FOUND AFTER", #var_29_0, "TRIES")

						return var_29_13, var_29_0
					end

					var_29_0[#var_29_0 + 1] = Vector3Box(var_29_7)
				end
			end
		end
	end

	return nil, var_29_0
end

LocomotionUtils.get_close_pos_below_on_mesh = function (arg_30_0, arg_30_1, arg_30_2, arg_30_3, arg_30_4)
	arg_30_3 = arg_30_3 or 1
	arg_30_4 = arg_30_4 or 8

	local var_30_0 = {}
	local var_30_1, var_30_2, var_30_3, var_30_4, var_30_5 = GwNavQueries.triangle_from_position(arg_30_0, arg_30_1, arg_30_3, arg_30_4)

	if var_30_1 then
		return (Vector3(arg_30_1.x, arg_30_1.y, var_30_2))
	end

	var_30_0[#var_30_0 + 1] = Vector3Box(arg_30_1)
	arg_30_2 = arg_30_2 or 4

	for iter_30_0 = 1, 4 do
		for iter_30_1 = -1, 1 do
			for iter_30_2 = -1, 1 do
				if iter_30_1 ~= 0 or iter_30_2 ~= 0 then
					local var_30_6 = arg_30_1 + Vector3(iter_30_1 * iter_30_0, iter_30_2 * iter_30_0, 0)
					local var_30_7, var_30_8, var_30_9, var_30_10, var_30_11 = GwNavQueries.triangle_from_position(arg_30_0, var_30_6, arg_30_3, arg_30_4)

					if var_30_7 then
						return Vector3(var_30_6.x, var_30_6.y, var_30_8), var_30_0
					end

					var_30_0[#var_30_0 + 1] = Vector3Box(var_30_6)
				end
			end
		end
	end

	return nil, var_30_0
end

local var_0_9 = {
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
	local var_31_0 = #var_0_9

	for iter_31_0 = 1, var_31_0, 2 do
		local var_31_1 = arg_31_1 + Vector3(var_0_9[iter_31_0] * arg_31_2, var_0_9[iter_31_0 + 1] * arg_31_2, 0)
		local var_31_2, var_31_3, var_31_4, var_31_5, var_31_6 = GwNavQueries.triangle_from_position(arg_31_0, var_31_1, 30, 30)

		if var_31_2 then
			arg_31_3[#arg_31_3 + 1] = Vector3Box(var_31_1.x, var_31_1.y, var_31_3)
		end
	end

	return #arg_31_3 > 0
end

LocomotionUtils.closest_mesh_positions_outward = function (arg_32_0, arg_32_1, arg_32_2, arg_32_3)
	local var_32_0 = 3
	local var_32_1 = math.ceil(arg_32_2 / var_32_0)
	local var_32_2 = #var_0_9

	for iter_32_0 = 1, var_32_2, 2 do
		local var_32_3 = var_0_9[iter_32_0]
		local var_32_4 = var_0_9[iter_32_0 + 1]

		for iter_32_1 = 1, var_32_1 do
			local var_32_5 = arg_32_1 + Vector3(var_32_3 * iter_32_1 * var_32_0, var_32_4 * iter_32_1 * var_32_0, 0)
			local var_32_6 = GwNavQueries.inside_position_from_outside_position(arg_32_0, var_32_5, 30, 30)

			if var_32_6 then
				arg_32_3[#arg_32_3 + 1] = Vector3Box(var_32_6)

				break
			end
		end
	end
end

LocomotionUtils.pos_on_mesh = function (arg_33_0, arg_33_1, arg_33_2, arg_33_3)
	arg_33_2 = arg_33_2 or 30
	arg_33_3 = arg_33_3 or 30

	local var_33_0, var_33_1 = GwNavQueries.triangle_from_position(arg_33_0, arg_33_1, arg_33_2, arg_33_3)

	if var_33_0 then
		return (Vector3(arg_33_1.x, arg_33_1.y, var_33_1))
	end
end

LocomotionUtils.ray_can_go_on_mesh = function (arg_34_0, arg_34_1, arg_34_2, arg_34_3, arg_34_4, arg_34_5)
	local var_34_0 = LocomotionUtils.pos_on_mesh(arg_34_0, arg_34_1, arg_34_4, arg_34_5)
	local var_34_1 = var_34_0 and LocomotionUtils.pos_on_mesh(arg_34_0, arg_34_2, arg_34_4, arg_34_5)
	local var_34_2

	if arg_34_3 then
		var_34_2 = var_34_1 and GwNavQueries.raycango(arg_34_0, var_34_0, var_34_1, arg_34_3)
	else
		var_34_2 = var_34_1 and GwNavQueries.raycango(arg_34_0, var_34_0, var_34_1)
	end

	return var_34_2, var_34_0, var_34_1
end

LocomotionUtils.raycast_on_navmesh = function (arg_35_0, arg_35_1, arg_35_2, arg_35_3, arg_35_4, arg_35_5, arg_35_6)
	local var_35_0 = LocomotionUtils.pos_on_mesh(arg_35_0, arg_35_1, arg_35_4, arg_35_5)
	local var_35_1 = var_35_0 and (not arg_35_6 and arg_35_2 or LocomotionUtils.pos_on_mesh(arg_35_0, arg_35_2, arg_35_4, arg_35_5))
	local var_35_2
	local var_35_3

	if var_35_1 then
		if arg_35_3 then
			var_35_2, var_35_3 = GwNavQueries.raycast(arg_35_0, var_35_0, var_35_1, arg_35_3)
		else
			var_35_2, var_35_3 = GwNavQueries.raycast(arg_35_0, var_35_0, var_35_1)
		end
	end

	return var_35_2, var_35_0, var_35_1, var_35_3
end

local var_0_10 = 0.9

LocomotionUtils.is_on_flat_ground_raycast = function (arg_36_0, arg_36_1)
	local var_36_0 = arg_36_1 + Vector3.up() * 0.1
	local var_36_1, var_36_2, var_36_3, var_36_4 = PhysicsWorld.immediate_raycast(arg_36_0, var_36_0, Vector3.down(), 0.15, "closest", "collision_filter", "filter_ai_mover")
	local var_36_5

	if var_36_1 then
		var_36_5 = Vector3.dot(var_36_4, Vector3.up()) > var_0_10
	end

	return var_36_5
end

local var_0_11 = 0.0001
local var_0_12 = 0.25
local var_0_13 = 0.25
local var_0_14 = 0.3
local var_0_15 = 1.3
local var_0_16 = 0.4

LocomotionUtils.navmesh_movement_check = function (arg_37_0, arg_37_1, arg_37_2, arg_37_3, arg_37_4)
	local var_37_0 = Vector3.length_squared(arg_37_1) > var_0_11
	local var_37_1 = var_37_0 and Vector3.normalize(arg_37_1) or Vector3.zero()
	local var_37_2 = arg_37_0 + var_37_1 * var_0_14
	local var_37_3, var_37_4, var_37_5 = LocomotionUtils.ray_can_go_on_mesh(arg_37_2, arg_37_0, var_37_2, arg_37_4, var_0_12, var_0_13)
	local var_37_6 = "navmesh_ok"

	if not var_37_3 and var_37_0 then
		local var_37_7 = LocomotionUtils.is_on_flat_ground_raycast(arg_37_3, arg_37_0)
		local var_37_8
		local var_37_9
		local var_37_10

		if var_37_7 then
			local var_37_11 = arg_37_0 + Vector3.up() * var_0_16
			local var_37_12

			var_37_8, var_37_12 = PhysicsWorld.immediate_raycast(arg_37_3, var_37_11, var_37_1, var_0_15, "closest", "collision_filter", "filter_ai_mover")
		end

		var_37_6 = var_37_8 and "navmesh_hit_wall" or "navmesh_use_mover"
	end

	return var_37_6
end

local var_0_17 = 1
local var_0_18 = 2
local var_0_19 = 3
local var_0_20 = 4

LocomotionUtils.clear_los = function (arg_38_0, arg_38_1, arg_38_2, arg_38_3, arg_38_4)
	local var_38_0 = arg_38_2 - arg_38_1
	local var_38_1 = Vector3.length(var_38_0)
	local var_38_2, var_38_3 = PhysicsWorld.immediate_raycast(arg_38_0, arg_38_1, var_38_0, var_38_1, "all", "collision_filter", "filter_ai_mover")

	if var_38_2 then
		for iter_38_0 = 1, var_38_3 do
			local var_38_4 = var_38_2[iter_38_0][var_0_20]
			local var_38_5 = Actor.unit(var_38_4)

			if not (var_38_5 == arg_38_3) and var_38_5 ~= arg_38_4 then
				return false
			end
		end
	end

	return true
end

LocomotionUtils.target_in_los = function (arg_39_0, arg_39_1)
	if not Unit.alive(arg_39_1.target_unit) then
		return
	end

	local var_39_0 = Unit.node(arg_39_1.target_unit, "j_neck")
	local var_39_1 = Unit.world_position(arg_39_1.target_unit, var_39_0)
	local var_39_2 = Unit.node(arg_39_0, "j_neck")
	local var_39_3 = Unit.world_position(arg_39_0, var_39_2)
	local var_39_4 = var_39_1 - var_39_3
	local var_39_5 = Vector3.length(var_39_4)
	local var_39_6 = World.get_data(arg_39_1.world, "physics_world")
	local var_39_7 = PhysicsWorld.immediate_raycast(var_39_6, var_39_3, var_39_4, var_39_5, "all", "collision_filter", "filter_ray_projectile")

	if var_39_7 then
		local var_39_8 = #var_39_7

		for iter_39_0 = 1, var_39_8 do
			local var_39_9 = var_39_7[iter_39_0][var_0_20]
			local var_39_10 = Actor.unit(var_39_9)

			if not (var_39_10 == arg_39_0) and var_39_10 ~= arg_39_1.target_unit then
				return false
			end
		end
	end

	return true
end

LocomotionUtils.enable_linked_movement = function (arg_40_0, arg_40_1, arg_40_2, arg_40_3, arg_40_4)
	if Managers.player:owner(arg_40_1).remote then
		local var_40_0 = Managers.state.unit_storage
		local var_40_1 = var_40_0:go_id(arg_40_1)
		local var_40_2 = var_40_0:owner(var_40_1)
		local var_40_3 = LevelHelper:current_level(arg_40_0)
		local var_40_4 = Level.unit_index(var_40_3, arg_40_2)
		local var_40_5 = Managers.state.network

		if var_40_5:game() then
			var_40_5.network_transmit:send_rpc("rpc_enable_linked_movement", var_40_2, var_40_1, var_40_4, arg_40_3, arg_40_4)
		end
	else
		ScriptUnit.extension(arg_40_1, "locomotion_system"):enable_linked_movement(arg_40_2, arg_40_3, arg_40_4)
	end
end

LocomotionUtils.disable_linked_movement = function (arg_41_0)
	local var_41_0 = Managers.player:owner(arg_41_0)

	if var_41_0 and var_41_0.remote then
		local var_41_1 = Managers.state.unit_storage
		local var_41_2 = var_41_1:go_id(arg_41_0)
		local var_41_3 = var_41_1:owner(var_41_2)
		local var_41_4 = Managers.state.network

		if var_41_4:game() then
			var_41_4.network_transmit:send_rpc("rpc_disable_linked_movement", var_41_3, var_41_2)
		end
	else
		ScriptUnit.extension(arg_41_0, "locomotion_system"):disable_linked_movement()
	end
end

LocomotionUtils.calculate_wanted_lerp_velocity = function (arg_42_0, arg_42_1, arg_42_2, arg_42_3, arg_42_4, arg_42_5, arg_42_6)
	local var_42_0 = math.min(1, (arg_42_6 - arg_42_3) / (arg_42_4 - arg_42_3))
	local var_42_1 = Vector3.lerp(arg_42_1, arg_42_2, var_42_0)
	local var_42_2 = Vector3.distance(arg_42_0, var_42_1) / arg_42_5
end

LocomotionUtils.in_crosshairs_dodge = function (arg_43_0, arg_43_1, arg_43_2, arg_43_3, arg_43_4, arg_43_5, arg_43_6)
	arg_43_5 = arg_43_5 or 0
	arg_43_6 = arg_43_6 or math.huge

	local var_43_0 = Managers.state.side.side_by_unit[arg_43_0].ENEMY_PLAYER_AND_BOT_UNITS

	arg_43_1.aim_times = arg_43_1.aim_times or {}

	local var_43_1 = arg_43_1.aim_times
	local var_43_2 = script_data.debug_ai_movement

	for iter_43_0 = 1, #var_43_0 do
		local var_43_3 = var_43_0[iter_43_0]
		local var_43_4 = ScriptUnit.extension(var_43_3, "inventory_system")
		local var_43_5 = var_43_4:get_wielded_slot_name() == "slot_ranged"
		local var_43_6 = var_43_4:get_wielded_slot_item_template()

		if var_43_6 and var_43_6.no_dodge then
			var_43_5 = false
		end

		if var_43_5 then
			local var_43_7 = Unit.world_position(arg_43_0, Unit.node(arg_43_0, "j_neck"))
			local var_43_8 = var_43_7 - Unit.world_position(var_43_3, Unit.node(var_43_3, "camera_attach"))
			local var_43_9 = ScriptUnit.extension(var_43_3, "locomotion_system"):current_rotation()
			local var_43_10 = Quaternion.forward(var_43_9)
			local var_43_11 = Vector3.length(var_43_8)
			local var_43_12 = var_43_8 - var_43_10 * var_43_11
			local var_43_13 = Vector3.length(var_43_12)
			local var_43_14

			if var_43_13 < arg_43_3 and arg_43_5 < var_43_11 and var_43_11 < arg_43_6 then
				local var_43_15 = Unit.local_rotation(arg_43_0, 0)
				local var_43_16 = Quaternion.forward(var_43_15)
				local var_43_17 = Vector3.normalize(var_43_8)

				if Vector3.dot(var_43_17, var_43_16) < -0.3 then
					if arg_43_4 then
						local var_43_18 = var_43_1[var_43_3]

						if not var_43_18 then
							var_43_18 = arg_43_2 + arg_43_4
							var_43_1[var_43_3] = var_43_18
						elseif var_43_18 < arg_43_2 then
							return var_43_12, var_43_10
						end

						if var_43_2 then
							QuickDrawer:sphere(var_43_7, arg_43_3, Color(0, 255, 0))
							QuickDrawer:cylinder(var_43_7, var_43_7 + Vector3(0, 0, var_43_18 - arg_43_2), 0.2, Color(0, 255, 0))
						end

						var_43_14 = true
					else
						return var_43_12, var_43_10
					end
				elseif var_43_2 then
					QuickDrawer:sphere(var_43_7, arg_43_3)
				end
			end

			if not var_43_14 then
				var_43_1[var_43_3] = nil
			end
		end
	end
end

LocomotionUtils.separate_mover_fallbacks = function (arg_44_0, arg_44_1)
	local var_44_0, var_44_1, var_44_2, var_44_3 = Mover.separate(arg_44_0, arg_44_1)

	if var_44_0 and var_44_3 then
		Mover.set_position(arg_44_0, var_44_3)
	end

	return var_44_0 and var_44_3 or not var_44_0
end

LocomotionUtils.on_alerted_dodge = function (arg_45_0, arg_45_1, arg_45_2, arg_45_3)
	local var_45_0 = Unit.world_position(arg_45_0, Unit.node(arg_45_0, "j_neck"))
	local var_45_1
	local var_45_2
	local var_45_3 = AiUtils.get_actual_attacker_unit(arg_45_3)

	if DamageUtils.is_player_unit(var_45_3) then
		local var_45_4 = ScriptUnit.has_extension(var_45_3, "locomotion_system")
		local var_45_5 = Unit.has_node(var_45_3, "camera_attach") and Unit.node(var_45_3, "camera_attach")

		var_45_2 = var_45_4:current_rotation()
		var_45_1 = Unit.world_position(var_45_3, var_45_5)
	else
		var_45_2 = Unit.world_rotation(var_45_3, 0)
		var_45_1 = Unit.world_position(var_45_3, 0)
	end

	local var_45_6 = var_45_0 - var_45_1
	local var_45_7 = Quaternion.forward(var_45_2)

	return var_45_6 - var_45_7 * Vector3.length(var_45_6), var_45_7
end

LocomotionUtils.get_vortex_spin_velocity = function (arg_46_0, arg_46_1, arg_46_2, arg_46_3, arg_46_4, arg_46_5, arg_46_6, arg_46_7)
	local var_46_0 = 0.0001
	local var_46_1 = arg_46_0 - arg_46_1
	local var_46_2 = Vector3.flat(var_46_1)
	local var_46_3 = Vector3.normalize(var_46_2)
	local var_46_4 = Vector3.length(var_46_2)
	local var_46_5 = arg_46_4 / math.max(var_46_4, var_46_0) * arg_46_7
	local var_46_6 = Quaternion.axis_angle(arg_46_3, var_46_5)
	local var_46_7

	if arg_46_2 < var_46_4 then
		var_46_7 = math.max(var_46_4 - arg_46_5 * arg_46_7, arg_46_2)
	else
		var_46_7 = math.min(var_46_4 + arg_46_5 * arg_46_7, arg_46_2)
	end

	local var_46_8 = var_46_1.z + arg_46_6 * arg_46_7
	local var_46_9 = (arg_46_1 + Quaternion.rotate(var_46_6, var_46_3) * var_46_7 + var_46_8 * arg_46_3 - arg_46_0) / math.max(arg_46_7, var_46_0)
	local var_46_10 = Vector3.cross(var_46_3, Vector3.up())

	return var_46_9, var_46_7, var_46_8, var_46_10
end

local function var_0_21(...)
	if script_data.debug_big_boy_turning then
		Debug.sticky_text(...)
	end
end

LocomotionUtils.check_start_turning = function (arg_48_0, arg_48_1, arg_48_2, arg_48_3)
	local var_48_0 = arg_48_3.action.start_anims_name
	local var_48_1 = arg_48_3.breed

	fassert(var_48_0, "Breed %s is using big boy turning without having start_anims defined in follow action", var_48_1.name)

	local var_48_2 = arg_48_3.locomotion_extension
	local var_48_3 = arg_48_3.navigation_extension
	local var_48_4 = POSITION_LOOKUP[arg_48_0]

	if not (arg_48_3.wanted_destination and arg_48_3.wanted_destination:unbox()) then
		return
	end

	local var_48_5 = var_48_3:is_computing_path()
	local var_48_6 = var_48_3:is_following_path()

	if var_48_5 or not var_48_6 then
		return
	end

	local var_48_7, var_48_8, var_48_9 = var_48_3:get_current_and_next_node_positions_in_nav_path()

	if var_48_7 == nil or var_48_8 == nil then
		return
	end

	local var_48_10 = var_48_9 and var_48_9 or var_48_8
	local var_48_11 = Vector3.normalize(var_48_10 - var_48_7)
	local var_48_12 = Unit.world_rotation(arg_48_0, 0)
	local var_48_13 = Quaternion.forward(var_48_12)
	local var_48_14 = Quaternion.right(var_48_12)
	local var_48_15 = Vector3.normalize(var_48_3:desired_velocity())

	LocomotionUtils.update_leaning(arg_48_0, arg_48_3, var_48_10)

	local var_48_16 = Vector3.dot(var_48_14, var_48_11)
	local var_48_17 = Vector3.dot(var_48_13, var_48_11)
	local var_48_18 = math.abs(var_48_16)
	local var_48_19 = math.abs(var_48_17)

	if var_48_17 > var_48_1.big_boy_turning_dot then
		return
	end

	local var_48_20

	if var_48_19 < var_48_18 then
		if var_48_16 > 0 then
			var_48_20 = var_48_0.right
		else
			var_48_20 = var_48_0.left
		end
	else
		var_48_20 = var_48_0.bwd
	end

	Managers.state.network:anim_event(arg_48_0, var_48_20)

	arg_48_3.move_animation_name = var_48_20
	arg_48_3.rotate_towards_position = Vector3Box(var_48_8)
	arg_48_3.is_turning = true
	arg_48_3.anim_cb_rotation_start = nil
	arg_48_3.anim_cb_move = nil
end

LocomotionUtils.update_leaning = function (arg_49_0, arg_49_1, arg_49_2)
	if not arg_49_1.enabled_animation_movement_system then
		local var_49_0 = Managers.state.unit_storage:go_id(arg_49_0)

		Managers.state.network.network_transmit:send_rpc_all("rpc_enable_animation_movement_system", var_49_0, true)

		arg_49_1.enabled_animation_movement_system = true
	end

	arg_49_1.lean_target_position_boxed = arg_49_1.lean_target_position_boxed or Vector3Box()

	arg_49_1.lean_target_position_boxed:store(arg_49_2)
end

LocomotionUtils.update_turning = function (arg_50_0, arg_50_1, arg_50_2, arg_50_3)
	local var_50_0 = arg_50_3.locomotion_extension
	local var_50_1 = arg_50_3.navigation_extension
	local var_50_2 = POSITION_LOOKUP[arg_50_0]

	if arg_50_3.anim_cb_rotation_start then
		arg_50_3.anim_cb_rotation_start = nil

		if arg_50_3.is_turning then
			local var_50_3 = arg_50_3.rotate_towards_position:unbox()
			local var_50_4 = AiAnimUtils.get_animation_rotation_scale(arg_50_0, var_50_3, arg_50_3.move_animation_name, arg_50_3.action.start_anims_data)

			var_50_0:use_lerp_rotation(false)
			LocomotionUtils.set_animation_driven_movement(arg_50_0, true, false, false)
			LocomotionUtils.set_animation_rotation_scale(arg_50_0, var_50_4)

			arg_50_3.animation_rotation_lock = true
		end
	end

	if arg_50_3.anim_cb_move then
		arg_50_3.anim_cb_move = nil

		LocomotionUtils.reset_turning(arg_50_0, arg_50_3)
	end
end

LocomotionUtils.reset_turning = function (arg_51_0, arg_51_1)
	arg_51_1.is_turning = false

	LocomotionUtils.set_animation_driven_movement(arg_51_0, false)
	LocomotionUtils.set_animation_rotation_scale(arg_51_0, 1)

	local var_51_0 = Managers.state.unit_storage:go_id(arg_51_0)

	Managers.state.network.network_transmit:send_rpc_all("rpc_enable_animation_movement_system", var_51_0, false)

	arg_51_1.lean_target_position_boxed = nil
	arg_51_1.enabled_animation_movement_system = nil
end
