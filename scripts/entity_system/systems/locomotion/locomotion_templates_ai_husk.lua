-- chunkname: @scripts/entity_system/systems/locomotion/locomotion_templates_ai_husk.lua

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

var_0_0.AiHuskLocomotionExtension = {}

function var_0_0.AiHuskLocomotionExtension.init(arg_3_0, arg_3_1)
	arg_3_0.nav_world = arg_3_1
	arg_3_0.destroy_units = {}
	arg_3_0.all_update_units = {}
	arg_3_0.affected_by_gravity_update_units = {}
	arg_3_0.pure_network_update_units = {}
	arg_3_0.other_update_units = {}
end

local var_0_8 = false

function var_0_0.AiHuskLocomotionExtension.update(arg_4_0, arg_4_1, arg_4_2)
	local var_4_0 = Managers.state.network:game()

	if var_4_0 == nil then
		return
	end

	arg_4_0.game = var_4_0

	if var_0_8 then
		var_0_0.AiHuskLocomotionExtension.update_alive(arg_4_0, arg_4_1, arg_4_2)
		var_0_0.AiHuskLocomotionExtension.update_pure_network_update_units(arg_4_0, arg_4_1, arg_4_2)
		var_0_0.AiHuskLocomotionExtension.update_other_update_units_navmesh_check(arg_4_0, arg_4_1, arg_4_2)
		var_0_0.AiHuskLocomotionExtension.update_other_update_units(arg_4_0, arg_4_1, arg_4_2)
	else
		var_0_0.AiHuskLocomotionExtension.update_other_update_units_navmesh_check(arg_4_0, arg_4_1, arg_4_2)
		EngineOptimizedExtensions.ai_husk_locomotion_update(arg_4_2, var_4_0, arg_4_0.all_update_units)
	end
end

function var_0_0.AiHuskLocomotionExtension.update_alive(arg_5_0, arg_5_1, arg_5_2)
	local var_5_0 = arg_5_0.all_update_units
	local var_5_1 = arg_5_0.pure_network_update_units
	local var_5_2 = arg_5_0.other_update_units

	for iter_5_0, iter_5_1 in pairs(var_5_0) do
		if not HEALTH_ALIVE[iter_5_0] then
			var_5_0[iter_5_0] = nil
			var_5_1[iter_5_0] = nil
			var_5_2[iter_5_0] = nil
		end
	end
end

function var_0_0.AiHuskLocomotionExtension.update_pure_network_update_units(arg_6_0, arg_6_1, arg_6_2)
	local var_6_0 = GameSession.game_object_field
	local var_6_1 = Vector3.length_squared
	local var_6_2 = Vector3.length
	local var_6_3 = Profiler.record_statistics
	local var_6_4 = Unit.set_local_position
	local var_6_5 = Unit.set_local_rotation
	local var_6_6 = Unit.local_rotation
	local var_6_7 = Quaternion.lerp
	local var_6_8 = math.min
	local var_6_9 = math.max
	local var_6_10 = Vector3.zero()
	local var_6_11 = POSITION_LOOKUP
	local var_6_12 = NetworkConstants.VELOCITY_EPSILON * NetworkConstants.VELOCITY_EPSILON
	local var_6_13 = 0.0001
	local var_6_14 = 0.1
	local var_6_15 = 0.97
	local var_6_16 = math.min(arg_6_2 * 15, 1)
	local var_6_17 = arg_6_0.game
	local var_6_18 = Managers.state.unit_storage

	for iter_6_0, iter_6_1 in pairs(arg_6_0.pure_network_update_units) do
		local var_6_19 = var_6_11[iter_6_0]
		local var_6_20 = var_6_18:go_id(iter_6_0)
		local var_6_21 = var_6_0(var_6_17, var_6_20, "position")
		local var_6_22 = var_6_0(var_6_17, var_6_20, "has_teleported")
		local var_6_23 = var_6_0(var_6_17, var_6_20, "yaw_rot")
		local var_6_24 = var_6_0(var_6_17, var_6_20, "velocity")

		if var_6_12 > var_6_1(var_6_24) then
			var_6_24 = Vector3(0, 0, 0)
		end

		local var_6_25

		if iter_6_1.has_teleported ~= var_6_22 then
			iter_6_1.has_teleported = var_6_22
			iter_6_1._pos_lerp_time = 0

			iter_6_1.last_lerp_position:store(var_6_21)
			iter_6_1.last_lerp_position_offset:store(var_6_10)
			iter_6_1.accumulated_movement:store(var_6_10)

			var_6_25 = var_6_21
		else
			local var_6_26 = iter_6_1.last_lerp_position:unbox()
			local var_6_27 = iter_6_1.last_lerp_position_offset:unbox()
			local var_6_28 = iter_6_1.accumulated_movement:unbox()

			iter_6_1._pos_lerp_time = iter_6_1._pos_lerp_time + arg_6_2

			local var_6_29 = iter_6_1._pos_lerp_time / var_6_14
			local var_6_30 = var_6_28 + var_6_24 * arg_6_2
			local var_6_31 = Vector3.lerp(var_6_27, var_6_10, var_6_8(var_6_29, 1))

			var_6_25 = var_6_26 + var_6_30 + var_6_31

			if var_6_13 < var_6_1(var_6_21 - var_6_26) then
				iter_6_1._pos_lerp_time = 0

				iter_6_1.last_lerp_position:store(var_6_21)
				iter_6_1.last_lerp_position_offset:store(var_6_25 - var_6_21)
				iter_6_1.accumulated_movement:store(var_6_10)
			else
				iter_6_1.accumulated_movement:store(var_6_30)
			end
		end

		if iter_6_1.is_constrained then
			var_6_25 = Vector3.clamp_3d(var_6_25, iter_6_1.constrain_min, iter_6_1.constrain_max)
		end

		var_6_4(iter_6_0, 0, var_6_25)

		local var_6_32 = var_6_6(iter_6_0, 0)
		local var_6_33 = Quaternion(Vector3.up(), var_6_23)

		var_6_5(iter_6_0, 0, var_6_7(var_6_32, var_6_33, var_6_16))
		iter_6_1._velocity:store(var_6_24)

		local var_6_34 = Unit.mover(iter_6_0)

		assert(var_6_34 == nil, "remove this assert if you see this")

		local var_6_35 = Vector3(var_6_24.x, var_6_24.y, 0)
		local var_6_36 = Vector3.length(var_6_35)

		Unit.animation_set_variable(iter_6_0, iter_6_1._move_speed_anim_var, var_6_9(var_6_36, var_6_15))
	end
end

local var_0_9 = 0.5

function var_0_0.AiHuskLocomotionExtension.update_other_update_units_navmesh_check(arg_7_0, arg_7_1, arg_7_2)
	local var_7_0 = arg_7_0.nav_world
	local var_7_1
	local var_7_2

	for iter_7_0, iter_7_1 in pairs(arg_7_0.other_update_units) do
		if not iter_7_1.is_network_driven and not iter_7_1.hit_wall and Unit.mover(iter_7_0) == nil then
			local var_7_3 = Unit.local_position(iter_7_0, 0)

			var_7_2 = var_7_2 or iter_7_1:traverse_logic()
			var_7_1 = var_7_1 or World.physics_world(iter_7_1._world)

			local var_7_4 = iter_7_1:current_velocity()
			local var_7_5 = LocomotionUtils.navmesh_movement_check(var_7_3, var_7_4, var_7_0, var_7_1, var_7_2)

			if var_7_5 == "navmesh_hit_wall" then
				iter_7_1.hit_wall = true
			elseif var_7_5 == "navmesh_use_mover" then
				iter_7_1:set_mover_disable_reason("not_constrained_by_mover", false)

				local var_7_6 = Unit.mover(iter_7_0)

				if var_7_6 then
					local var_7_7 = iter_7_1.breed.override_mover_move_distance or var_0_9

					Mover.set_position(var_7_6, var_7_3)

					if LocomotionUtils.separate_mover_fallbacks(var_7_6, var_7_7) then
						local var_7_8 = Mover.position(var_7_6)

						Unit.set_local_position(iter_7_0, 0, var_7_8)
					else
						iter_7_1:set_mover_disable_reason("not_constrained_by_mover", true)

						iter_7_1.hit_wall = true
					end
				end
			end
		end
	end
end

function var_0_0.AiHuskLocomotionExtension.update_other_update_units(arg_8_0, arg_8_1, arg_8_2)
	local var_8_0 = GameSession.game_object_field
	local var_8_1 = Vector3.length_squared
	local var_8_2 = Vector3.length
	local var_8_3 = Unit.set_local_position
	local var_8_4 = Unit.set_local_rotation
	local var_8_5 = Unit.local_rotation
	local var_8_6 = Quaternion.lerp
	local var_8_7 = NetworkConstants.VELOCITY_EPSILON * NetworkConstants.VELOCITY_EPSILON
	local var_8_8 = 0.97
	local var_8_9 = arg_8_0.game
	local var_8_10 = Managers.state.unit_storage
	local var_8_11 = arg_8_0.nav_world
	local var_8_12

	for iter_8_0, iter_8_1 in pairs(arg_8_0.other_update_units) do
		local var_8_13 = var_8_10:go_id(iter_8_0)
		local var_8_14 = Unit.local_position(iter_8_0, 0)

		var_8_12 = var_8_12 or iter_8_1:traverse_logic()

		local var_8_15 = Unit.animation_wanted_root_pose(iter_8_0)
		local var_8_16 = Matrix4x4.translation(var_8_15)
		local var_8_17

		if iter_8_1.has_network_driven_rotation then
			local var_8_18 = var_8_0(var_8_9, var_8_13, "yaw_rot")

			var_8_17 = Quaternion(Vector3.up(), var_8_18)
		else
			local var_8_19 = Matrix4x4.rotation(var_8_15)
			local var_8_20 = Unit.local_rotation(iter_8_0, 0)
			local var_8_21 = Quaternion.up(var_8_20)
			local var_8_22 = Quaternion.inverse(var_8_20)
			local var_8_23 = Quaternion.multiply(var_8_22, var_8_19)
			local var_8_24 = Quaternion.yaw(var_8_23) * iter_8_1._animation_rotation_scale

			var_8_17 = Quaternion.multiply(var_8_20, Quaternion(var_8_21, var_8_24))
		end

		local var_8_25 = var_8_0(var_8_9, var_8_13, "velocity")

		if var_8_7 > var_8_1(var_8_25) then
			var_8_25 = Vector3(0, 0, 0)
		end

		local var_8_26 = var_8_25
		local var_8_27
		local var_8_28
		local var_8_29 = Unit.mover(iter_8_0)

		if iter_8_1.is_affected_by_gravity and var_8_29 ~= nil then
			var_8_26.z = iter_8_1._velocity:unbox().z - 9.82 * arg_8_2

			Mover.move(var_8_29, var_8_26 * arg_8_2, arg_8_2)

			var_8_27 = Mover.position(var_8_29)
			var_8_28 = (var_8_27 - var_8_14) / arg_8_2

			if Mover.collides_down(var_8_29) and Mover.standing_frames(var_8_29) > 0 then
				var_8_28.z = 0
			else
				var_8_28.z = var_8_26.z
			end
		else
			var_8_27 = GwNavQueries.move_on_navmesh(var_8_11, var_8_14, var_8_26, arg_8_2, var_8_12)
			var_8_28 = var_8_26
		end

		if iter_8_1.is_constrained then
			var_8_27 = Vector3.clamp_3d(var_8_27, iter_8_1.constrain_min, iter_8_1.constrain_max)
		end

		var_8_3(iter_8_0, 0, var_8_27)
		var_8_4(iter_8_0, 0, var_8_17)
		iter_8_1._velocity:store(var_8_28)

		iter_8_1._pos_lerp_time = 0

		iter_8_1.last_lerp_position:store(var_8_27)
		iter_8_1.last_lerp_position_offset:store(Vector3(0, 0, 0))
		iter_8_1.accumulated_movement:store(Vector3(0, 0, 0))

		if var_8_29 ~= nil then
			Mover.set_position(var_8_29, var_8_27)
		end

		local var_8_30 = Vector3(var_8_28.x, var_8_28.y, 0)
		local var_8_31 = var_8_2(var_8_30)

		Unit.animation_set_variable(iter_8_0, iter_8_1._move_speed_anim_var, math.max(var_8_31, var_8_8))
	end
end
