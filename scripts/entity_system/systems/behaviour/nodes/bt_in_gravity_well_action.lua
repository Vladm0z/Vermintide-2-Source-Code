-- chunkname: @scripts/entity_system/systems/behaviour/nodes/bt_in_gravity_well_action.lua

require("scripts/entity_system/systems/behaviour/nodes/bt_node")

BTInGravityWellAction = class(BTInGravityWellAction, BTNode)

function BTInGravityWellAction.init(arg_1_0, ...)
	BTInGravityWellAction.super.init(arg_1_0, ...)
end

BTInGravityWellAction.name = "BTInGravityWellAction"

local var_0_0 = 0.35

function BTInGravityWellAction.enter(arg_2_0, arg_2_1, arg_2_2, arg_2_3)
	local var_2_0 = arg_2_2.locomotion_extension

	arg_2_2.navigation_extension:set_enabled(false)

	local var_2_1 = arg_2_2.breed
	local var_2_2 = var_2_1.stagger_in_air_mover_check_radius or var_0_0
	local var_2_3 = POSITION_LOOKUP[arg_2_1]
	local var_2_4 = 1
	local var_2_5 = Vector3(var_2_2, var_2_4, var_2_2)
	local var_2_6 = Quaternion.look(Vector3.down(), Vector3.forward())
	local var_2_7 = arg_2_2.world
	local var_2_8 = World.get_data(var_2_7, "physics_world")
	local var_2_9 = var_2_4 - var_2_2 > 0 and "capsule" or "sphere"
	local var_2_10, var_2_11 = PhysicsWorld.immediate_overlap(var_2_8, "position", var_2_3, "rotation", var_2_6, "size", var_2_5, "shape", var_2_9, "types", "both", "collision_filter", "filter_environment_overlap")

	if var_2_11 == 0 then
		local var_2_12 = var_2_1.override_mover_move_distance

		var_2_0:set_movement_type("constrained_by_mover", var_2_12)
	end

	arg_2_2.attack_aborted = true
	arg_2_2.move_state = "stagger"
	arg_2_2.action = arg_2_0._tree_node.action_data
	arg_2_2.spawn_to_running = nil
end

function BTInGravityWellAction._set_wanted_velocity(arg_3_0, arg_3_1, arg_3_2, arg_3_3)
	local var_3_0 = arg_3_2.locomotion_extension
	local var_3_1 = arg_3_2.gravity_well_position:unbox()
	local var_3_2 = arg_3_2.gravity_well_strength
	local var_3_3 = var_3_1 - arg_3_3
	local var_3_4 = Vector3.normalize(var_3_3)
	local var_3_5 = Vector3.length_squared(var_3_3)
	local var_3_6 = var_3_0:current_velocity()
	local var_3_7 = false
	local var_3_8

	if var_3_5 < 1 then
		var_3_8 = (var_3_6 - var_3_4 * Vector3.dot(var_3_6, var_3_4)) * (1 - 5 * arg_3_1)
	else
		local var_3_9 = var_3_2 / var_3_5

		var_3_7 = var_3_9 < 0.1
		var_3_8 = var_3_6 + arg_3_1 * (var_3_4 * var_3_9)
		var_3_8.z = math.min(var_3_8.z, 2)
	end

	var_3_0:set_wanted_velocity(var_3_8)
	var_3_0:set_wanted_rotation(Quaternion.look(Vector3.flat(-var_3_4), Vector3.up()))

	return var_3_8, var_3_7
end

function BTInGravityWellAction.leave(arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4, arg_4_5)
	arg_4_2.action = nil
	arg_4_2.stagger_hit_wall = nil

	local var_4_0 = arg_4_2.locomotion_extension

	var_4_0:set_movement_type("snap_to_navmesh")
	var_4_0:set_wanted_velocity(Vector3.zero())
	arg_4_2.navigation_extension:set_enabled(true)

	arg_4_2.gravity_well_position = nil
	arg_4_2.gravity_well_strength = nil
	arg_4_2.gravity_well_time = nil
end

function BTInGravityWellAction.run(arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4)
	local var_5_0 = POSITION_LOOKUP[arg_5_1]
	local var_5_1, var_5_2 = arg_5_0:_set_wanted_velocity(arg_5_4, arg_5_2, var_5_0)
	local var_5_3 = arg_5_2.locomotion_extension

	if var_5_3.movement_type ~= "constrained_by_mover" and not arg_5_2.stagger_hit_wall then
		local var_5_4 = arg_5_2.nav_world
		local var_5_5 = arg_5_2.world
		local var_5_6 = World.physics_world(var_5_5)
		local var_5_7 = arg_5_2.navigation_extension:traverse_logic()
		local var_5_8 = LocomotionUtils.navmesh_movement_check(var_5_0, var_5_1, var_5_4, var_5_6, var_5_7)

		if var_5_8 == "navmesh_hit_wall" then
			arg_5_2.stagger_hit_wall = true
		elseif var_5_8 == "navmesh_use_mover" then
			local var_5_9 = arg_5_2.breed.override_mover_move_distance
			local var_5_10 = true

			if not var_5_3:set_movement_type("constrained_by_mover", var_5_9, var_5_10) then
				var_5_3:set_movement_type("snap_to_navmesh")

				arg_5_2.stagger_hit_wall = true
			end
		end
	end

	return (var_5_2 or arg_5_3 > arg_5_2.gravity_well_time) and "done" or "running"
end
