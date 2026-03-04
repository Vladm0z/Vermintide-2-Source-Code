-- chunkname: @scripts/entity_system/systems/locomotion/locomotion_templates_ai.lua

LocomotionTemplates = LocomotionTemplates or {}

local var_0_0 = LocomotionTemplates
local var_0_1
local var_0_2
local var_0_3 = true

if var_0_3 then
	local var_0_4 = Profiler.start
	local var_0_5 = Profiler.stop
else
	local function var_0_6()
		return
	end

	local function var_0_7()
		return
	end
end

var_0_0.AILocomotionExtension = {}

var_0_0.AILocomotionExtension.init = function (arg_3_0, arg_3_1)
	arg_3_0.nav_world = arg_3_1
	arg_3_0.destroy_units = {}
	arg_3_0.all_update_units = {}
	arg_3_0.affected_by_gravity_update_units = {}
	arg_3_0.animation_update_units = {}
	arg_3_0.animation_and_script_update_units = {}
	arg_3_0.rotation_speed_modifier_update_units = {}
	arg_3_0.script_driven_update_units = {}
	arg_3_0.snap_to_navmesh_update_units = {}
	arg_3_0.get_to_navmesh_update_units = {}
	arg_3_0.mover_constrained_update_units = {}
end

var_0_0.AILocomotionExtension.update = function (arg_4_0, arg_4_1, arg_4_2)
	var_0_0.AILocomotionExtension.validate2(arg_4_0, arg_4_1, arg_4_2)
	var_0_0.AILocomotionExtension.update_alive(arg_4_0, arg_4_1, arg_4_2)
	var_0_0.AILocomotionExtension.update_velocity(arg_4_0, arg_4_1, arg_4_2)
	var_0_0.AILocomotionExtension.update_animation_driven_units(arg_4_0, arg_4_1, arg_4_2)
	var_0_0.AILocomotionExtension.update_gravity(arg_4_0, arg_4_1, arg_4_2)
	var_0_0.AILocomotionExtension.update_rotation(arg_4_0, arg_4_1, arg_4_2)
	var_0_0.AILocomotionExtension.update_position(arg_4_0, arg_4_1, arg_4_2)
	var_0_0.AILocomotionExtension.update_out_of_range(arg_4_0, arg_4_1, arg_4_2)
	var_0_0.AILocomotionExtension.update_network(arg_4_0, arg_4_1, arg_4_2)
end

var_0_0.AILocomotionExtension.validate2 = function (arg_5_0, arg_5_1, arg_5_2)
	local var_5_0 = arg_5_0.all_update_units
	local var_5_1 = arg_5_0.snap_to_navmesh_update_units
	local var_5_2 = arg_5_0.get_to_navmesh_update_units
	local var_5_3 = arg_5_0.mover_constrained_update_units
	local var_5_4 = arg_5_0.script_driven_update_units

	for iter_5_0, iter_5_1 in pairs(var_5_0) do
		assert(var_5_4[iter_5_0] ~= nil or var_5_1[iter_5_0] ~= nil or var_5_3[iter_5_0] ~= nil or var_5_2[iter_5_0] ~= nil)

		local var_5_5 = iter_5_1._wanted_velocity

		if var_5_5 then
			fassert(Vector3.is_valid(var_5_5), "Invalid velocity %s", var_5_5)
		end
	end
end

var_0_0.AILocomotionExtension.update_alive = function (arg_6_0, arg_6_1, arg_6_2)
	for iter_6_0, iter_6_1 in pairs(arg_6_0.destroy_units) do
		arg_6_0.destroy_units[iter_6_0] = nil
		arg_6_0.all_update_units[iter_6_0] = nil
		arg_6_0.affected_by_gravity_update_units[iter_6_0] = nil
		arg_6_0.animation_update_units[iter_6_0] = nil
		arg_6_0.animation_and_script_update_units[iter_6_0] = nil
		arg_6_0.rotation_speed_modifier_update_units[iter_6_0] = nil
		arg_6_0.script_driven_update_units[iter_6_0] = nil
		arg_6_0.snap_to_navmesh_update_units[iter_6_0] = nil
		arg_6_0.get_to_navmesh_update_units[iter_6_0] = nil
		arg_6_0.mover_constrained_update_units[iter_6_0] = nil
	end
end

var_0_0.AILocomotionExtension.update_velocity = function (arg_7_0, arg_7_1, arg_7_2)
	for iter_7_0, iter_7_1 in pairs(arg_7_0.all_update_units) do
		iter_7_1._wanted_velocity = iter_7_1._wanted_velocity or iter_7_1._velocity:unbox()
	end
end

var_0_0.AILocomotionExtension.update_gravity = function (arg_8_0, arg_8_1, arg_8_2)
	for iter_8_0, iter_8_1 in pairs(arg_8_0.affected_by_gravity_update_units) do
		iter_8_1._wanted_velocity.z = iter_8_1._velocity.z - iter_8_1._gravity * arg_8_2
	end
end

var_0_0.AILocomotionExtension.update_animation_driven_units = function (arg_9_0, arg_9_1, arg_9_2)
	for iter_9_0, iter_9_1 in pairs(arg_9_0.animation_update_units) do
		local var_9_0 = Unit.animation_wanted_root_pose(iter_9_0)
		local var_9_1 = Matrix4x4.translation(var_9_0)
		local var_9_2 = Matrix4x4.rotation(var_9_0)
		local var_9_3 = Unit.local_position(iter_9_0, 0)
		local var_9_4 = Unit.local_rotation(iter_9_0, 0)
		local var_9_5 = Quaternion.up(var_9_4)
		local var_9_6 = Quaternion.inverse(var_9_4)
		local var_9_7 = Quaternion.multiply(var_9_6, var_9_2)
		local var_9_8 = Quaternion.yaw(var_9_7) * iter_9_1._animation_rotation_scale
		local var_9_9 = Quaternion.multiply(var_9_4, Quaternion(var_9_5, var_9_8))
		local var_9_10 = (var_9_1 - var_9_3) / arg_9_2

		iter_9_1._wanted_velocity = Vector3.multiply_elements(var_9_10, iter_9_1:get_animation_translation_scale())
		iter_9_1._wanted_rotation = var_9_9
	end

	for iter_9_2, iter_9_3 in pairs(arg_9_0.animation_and_script_update_units) do
		local var_9_11 = Unit.animation_wanted_root_pose(iter_9_2)
		local var_9_12 = (Matrix4x4.translation(var_9_11) - Unit.local_position(iter_9_2, 0)) / arg_9_2

		iter_9_3._wanted_velocity = Vector3.multiply_elements(var_9_12, iter_9_3:get_animation_translation_scale())
	end
end

var_0_0.AILocomotionExtension.update_rotation = function (arg_10_0, arg_10_1, arg_10_2)
	local var_10_0 = Vector3.length_squared
	local var_10_1 = Vector3.flat
	local var_10_2 = Quaternion.look
	local var_10_3 = Vector3.up()
	local var_10_4 = Unit.set_local_rotation
	local var_10_5 = Unit.local_rotation
	local var_10_6 = Quaternion.lerp

	for iter_10_0, iter_10_1 in pairs(arg_10_0.all_update_units) do
		repeat
			local var_10_7 = iter_10_1._wanted_velocity
			local var_10_8 = iter_10_1._wanted_rotation

			if not var_10_8 then
				local var_10_9 = var_10_1(var_10_7)

				if var_10_0(var_10_9) < 0.010000000000000002 then
					break
				end

				var_10_8 = var_10_2(var_10_9, var_10_3)
			end

			iter_10_1._wanted_rotation = nil

			if iter_10_1._lerp_rotation then
				local var_10_10 = iter_10_1._rotation_speed * iter_10_1._rotation_speed_modifier * arg_10_2

				if var_10_10 >= 1 then
					local var_10_11 = var_10_8

					var_10_4(iter_10_0, 0, var_10_11)

					break
				end

				local var_10_12 = var_10_5(iter_10_0, 0)
				local var_10_13 = var_10_6(var_10_12, var_10_8, var_10_10)

				var_10_4(iter_10_0, 0, var_10_13)

				break
			end

			var_10_4(iter_10_0, 0, var_10_8)
		until true
	end

	for iter_10_2, iter_10_3 in pairs(arg_10_0.rotation_speed_modifier_update_units) do
		local var_10_14 = iter_10_3._rotation_speed_modifier_lerp_end_time - iter_10_3._rotation_speed_modifier_lerp_start_time
		local var_10_15 = math.max(0, arg_10_1 - iter_10_3._rotation_speed_modifier_lerp_start_time) / var_10_14

		if var_10_15 >= 1 then
			iter_10_3._rotation_speed_modifier = 1
			iter_10_3._rotation_speed_modifier_lerp_end_time = nil
			iter_10_3._rotation_speed_modifier_lerp_start_time = nil
			iter_10_3._rotation_speed_modifier_lerp_start_value = nil
			arg_10_0.rotation_speed_modifier_update_units[iter_10_2] = nil
		else
			iter_10_3._rotation_speed_modifier = math.lerp(iter_10_3._rotation_speed_modifier_lerp_start_value, 1, var_10_15)
		end
	end
end

var_0_0.AILocomotionExtension.update_position = function (arg_11_0, arg_11_1, arg_11_2)
	local var_11_0 = Unit.local_position
	local var_11_1 = Unit.set_local_position
	local var_11_2 = Unit.mover
	local var_11_3 = Mover.move
	local var_11_4 = arg_11_0.nav_world
	local var_11_5 = 0.0001

	if arg_11_2 == 0 then
		arg_11_2 = 0.00016666666666666666
	end

	for iter_11_0, iter_11_1 in pairs(arg_11_0.script_driven_update_units) do
		local var_11_6 = iter_11_1._wanted_velocity
		local var_11_7 = var_11_0(iter_11_0, 0) + var_11_6 * arg_11_2

		iter_11_1._velocity:store(var_11_6)
		var_11_1(iter_11_0, 0, var_11_7)
	end

	for iter_11_2, iter_11_3 in pairs(arg_11_0.get_to_navmesh_update_units) do
		local var_11_8
		local var_11_9
		local var_11_10 = POSITION_LOOKUP[iter_11_2]
		local var_11_11 = BLACKBOARDS[iter_11_2]

		if var_11_11.navigation_extension:has_reached_destination(0.1) then
			var_11_8 = Vector3(0, 0, 0)
			var_11_9 = var_11_10
		else
			local var_11_12, var_11_13 = GwNavQueries.triangle_from_position(var_11_4, var_11_10, 0.5, 0.5)

			if var_11_12 then
				arg_11_0.get_to_navmesh_update_units[iter_11_2] = nil
				arg_11_0.snap_to_navmesh_update_units[iter_11_2] = iter_11_3
			else
				local var_11_14 = GwNavQueries.inside_position_from_outside_position(var_11_4, var_11_10, 1, 1, 5)

				if var_11_14 then
					if arg_11_0.animation_update_units[iter_11_2] then
						var_11_8 = iter_11_3._wanted_velocity
						var_11_9 = var_11_10 - var_11_8 * arg_11_2
					else
						local var_11_15 = var_11_11.breed.run_speed
						local var_11_16 = var_11_10 - var_11_14

						var_11_8 = Vector3.normalize(var_11_16) * var_11_15
						var_11_9 = var_11_10 - var_11_8 * arg_11_2
						var_11_8.z = 0
					end
				else
					var_11_8 = Vector3(0, 0, 0)
					var_11_9 = var_11_10
				end

				iter_11_3._velocity:store(var_11_8)
				var_11_1(iter_11_2, 0, var_11_9)
			end
		end
	end

	local var_11_17 = Vector3.length_squared
	local var_11_18 = GwNavQueries.move_on_navmesh
	local var_11_19 = GwNavQueries.triangle_from_position

	for iter_11_4, iter_11_5 in pairs(arg_11_0.snap_to_navmesh_update_units) do
		local var_11_20 = iter_11_5._wanted_velocity
		local var_11_21 = var_11_0(iter_11_4, 0)
		local var_11_22 = var_11_17(Vector3.flat(var_11_20))
		local var_11_23
		local var_11_24
		local var_11_25 = var_11_18(var_11_4, var_11_21, var_11_20, arg_11_2)
		local var_11_26 = (var_11_25 - var_11_21) / arg_11_2

		iter_11_5._velocity:store(var_11_26)
		var_11_1(iter_11_4, 0, var_11_25)
	end

	for iter_11_6, iter_11_7 in pairs(arg_11_0.mover_constrained_update_units) do
		local var_11_27

		if iter_11_7._mover_displacement_duration then
			iter_11_7._mover_displacement_t = iter_11_7._mover_displacement_t - arg_11_2
			var_11_27 = iter_11_7._mover_displacement:unbox() * (iter_11_7._mover_displacement_t / iter_11_7._mover_displacement_duration)

			if iter_11_7._mover_displacement_t <= 0 then
				iter_11_7._mover_displacement_duration = nil
			end
		else
			var_11_27 = Vector3(0, 0, 0)
		end

		local var_11_28 = var_11_0(iter_11_6, 0)
		local var_11_29 = iter_11_7._wanted_velocity
		local var_11_30 = Unit.mover(iter_11_6)

		var_11_3(var_11_30, var_11_29 * arg_11_2, arg_11_2)

		local var_11_31 = Mover.position(var_11_30) - var_11_27
		local var_11_32 = (var_11_31 - var_11_28) / arg_11_2

		if Mover.collides_down(var_11_30) and Mover.standing_frames(var_11_30) > 0 then
			var_11_32.z = 0
			iter_11_7._is_falling = false
		else
			var_11_32.z = var_11_29.z

			if iter_11_7._check_falling then
				local var_11_33 = Vector3.distance_squared(iter_11_7._last_fall_position:unbox(), var_11_31)

				if not iter_11_7._is_falling or var_11_33 > 0.0625 then
					local var_11_34 = World.get_data(iter_11_7._world, "physics_world")
					local var_11_35 = 0.5
					local var_11_36 = 1.5
					local var_11_37 = Vector3(var_11_35, var_11_36, var_11_35)
					local var_11_38 = Quaternion.look(Vector3(0, 0, 1))
					local var_11_39 = var_11_31 + Vector3(0, 0, -1)
					local var_11_40 = var_11_36 - var_11_35 > 0 and "capsule" or "sphere"
					local var_11_41, var_11_42 = PhysicsWorld.immediate_overlap(var_11_34, "shape", var_11_40, "position", var_11_39, "rotation", var_11_38, "size", var_11_37, "collision_filter", "filter_environment_overlap")

					iter_11_7._is_falling = var_11_42 == 0

					iter_11_7._last_fall_position:store(var_11_31)
				end
			end
		end

		iter_11_7._velocity:store(var_11_32)
		var_11_1(iter_11_6, 0, var_11_31)
	end

	local var_11_43 = Mover.set_position

	for iter_11_8, iter_11_9 in pairs(arg_11_0.all_update_units) do
		iter_11_9._wanted_velocity = nil

		local var_11_44 = var_11_2(iter_11_8)

		if var_11_44 and arg_11_0.mover_constrained_update_units[iter_11_8] == nil then
			var_11_43(var_11_44, var_11_0(iter_11_8, 0))
		end
	end
end

var_0_0.AILocomotionExtension.update_out_of_range = function (arg_12_0, arg_12_1, arg_12_2)
	local var_12_0 = Managers.state.conflict
	local var_12_1 = Unit.local_position
	local var_12_2 = ScriptUnit.extension
	local var_12_3 = NetworkConstants.position.min
	local var_12_4 = NetworkConstants.position.max

	for iter_12_0, iter_12_1 in pairs(arg_12_0.all_update_units) do
		local var_12_5 = var_12_1(iter_12_0, 0)
		local var_12_6 = var_12_5.x
		local var_12_7 = var_12_5.y
		local var_12_8 = var_12_5.z
		local var_12_9 = var_12_6 < var_12_3 or var_12_4 < var_12_6
		local var_12_10 = var_12_7 < var_12_3 or var_12_4 < var_12_7
		local var_12_11 = var_12_8 < var_12_3 or var_12_4 < var_12_8

		if var_12_9 or var_12_10 or var_12_11 then
			local var_12_12 = var_12_2(iter_12_0, "ai_system")._blackboard

			arg_12_0.all_update_units[iter_12_0] = nil

			var_12_0:destroy_unit(iter_12_0, var_12_12, "out_of_range")
		end
	end
end

var_0_0.AILocomotionExtension.update_network = function (arg_13_0, arg_13_1, arg_13_2)
	local var_13_0 = Managers.state.network:game()

	if var_13_0 == nil then
		return
	end

	local var_13_1 = Managers.state.unit_storage
	local var_13_2 = Unit.local_position
	local var_13_3 = Unit.local_rotation
	local var_13_4 = Vector3.min
	local var_13_5 = Vector3.max
	local var_13_6 = GameSession.set_game_object_field
	local var_13_7 = NetworkConstants.enemy_velocity
	local var_13_8 = var_13_7.min
	local var_13_9 = var_13_7.max
	local var_13_10 = Vector3(var_13_8, var_13_8, var_13_8)
	local var_13_11 = Vector3(var_13_9, var_13_9, var_13_9)

	for iter_13_0, iter_13_1 in pairs(arg_13_0.all_update_units) do
		local var_13_12 = var_13_1:go_id(iter_13_0)
		local var_13_13 = var_13_2(iter_13_0, 0)
		local var_13_14 = var_13_3(iter_13_0, 0)
		local var_13_15 = Quaternion.yaw(var_13_14)
		local var_13_16 = iter_13_1._velocity:unbox()

		var_13_6(var_13_0, var_13_12, "position", var_13_13)
		var_13_6(var_13_0, var_13_12, "yaw_rot", var_13_15)

		local var_13_17 = var_13_4(var_13_5(var_13_16, var_13_10), var_13_11)

		var_13_6(var_13_0, var_13_12, "velocity", var_13_17)
	end
end
