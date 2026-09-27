-- chunkname: @scripts/entity_system/systems/behaviour/nodes/bt_in_gravity_well_action.lua

require("scripts/entity_system/systems/behaviour/nodes/bt_node")

BTInGravityWellAction = class(BTInGravityWellAction, BTNode)

BTInGravityWellAction.init = function (arg_1_0, ...)
	-- function 1
	BTInGravityWellAction.super.init(arg_1_0, ...)
end

BTInGravityWellAction.name = "BTInGravityWellAction"

local num = 0.35

BTInGravityWellAction.enter = function (self, arg_2_1, arg_2_2, arg_2_3)
	-- function 2
	local locomotion_extension = arg_2_2.locomotion_extension

	arg_2_2.navigation_extension:set_enabled(false)

	local breed = arg_2_2.breed
	local stagger_in_air_mover_check_radius = breed.stagger_in_air_mover_check_radius

	stagger_in_air_mover_check_radius = stagger_in_air_mover_check_radius or num

	local var_2_3 = POSITION_LOOKUP[arg_2_1]
	local num_2 = 1
	local var_2_5 = Vector3(stagger_in_air_mover_check_radius, num_2, stagger_in_air_mover_check_radius)
	local look = Quaternion.look(Vector3.down(), Vector3.forward())
	local world = arg_2_2.world
	local get_data = World.get_data(world, "physics_world")
	local flag

	flag = not (num_2 - stagger_in_air_mover_check_radius > 0) or not "capsule" or "sphere"

	local immediate_overlap, var_2_11 = PhysicsWorld.immediate_overlap(get_data, "position", var_2_3, "rotation", look, "size", var_2_5, "shape", flag, "types", "both", "collision_filter", "filter_environment_overlap")

	if var_2_11 == 0 then
		local override_mover_move_distance = breed.override_mover_move_distance

		locomotion_extension:set_movement_type("constrained_by_mover", override_mover_move_distance)
	end

	arg_2_2.attack_aborted = true
	arg_2_2.move_state = "stagger"
	arg_2_2.action = self._tree_node.action_data
	arg_2_2.spawn_to_running = nil
end

BTInGravityWellAction._set_wanted_velocity = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3)
	-- function 3
	local locomotion_extension = arg_3_2.locomotion_extension
	local unbox = arg_3_2.gravity_well_position:unbox()
	local gravity_well_strength = arg_3_2.gravity_well_strength
	local num = unbox - arg_3_3
	local normalize = Vector3.normalize(num)
	local length_squared = Vector3.length_squared(num)
	local current_velocity = locomotion_extension:current_velocity()
	local flag = false
	local var_3_8

	if length_squared < 1 then
		var_3_8 = (current_velocity - normalize * Vector3.dot(current_velocity, normalize)) * (1 - 5 * arg_3_1)
	else
		local num_2 = gravity_well_strength / length_squared

		flag = num_2 < 0.1
		var_3_8 = current_velocity + arg_3_1 * (normalize * num_2)
		var_3_8.z = math.min(var_3_8.z, 2)
	end

	locomotion_extension:set_wanted_velocity(var_3_8)
	locomotion_extension:set_wanted_rotation(Quaternion.look(Vector3.flat(-normalize), Vector3.up()))

	return var_3_8, flag
end

BTInGravityWellAction.leave = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4, arg_4_5)
	-- function 4
	arg_4_2.action = nil
	arg_4_2.stagger_hit_wall = nil

	local locomotion_extension = arg_4_2.locomotion_extension

	locomotion_extension:set_movement_type("snap_to_navmesh")
	locomotion_extension:set_wanted_velocity(Vector3.zero())
	arg_4_2.navigation_extension:set_enabled(true)

	arg_4_2.gravity_well_position = nil
	arg_4_2.gravity_well_strength = nil
	arg_4_2.gravity_well_time = nil
end

BTInGravityWellAction.run = function (self, arg_5_1, arg_5_2, arg_5_3, arg_5_4)
	-- function 5
	local var_5_0 = POSITION_LOOKUP[arg_5_1]
	local _set_wanted_velocity, var_5_2 = self:_set_wanted_velocity(arg_5_4, arg_5_2, var_5_0)
	local locomotion_extension = arg_5_2.locomotion_extension

	if not (locomotion_extension.movement_type == "constrained_by_mover" or arg_5_2.stagger_hit_wall) then
		local nav_world = arg_5_2.nav_world
		local world = arg_5_2.world
		local physics_world = World.physics_world(world)
		local traverse_logic = arg_5_2.navigation_extension:traverse_logic()
		local navmesh_movement_check = LocomotionUtils.navmesh_movement_check(var_5_0, _set_wanted_velocity, nav_world, physics_world, traverse_logic)

		if navmesh_movement_check == "navmesh_hit_wall" then
			arg_5_2.stagger_hit_wall = true
		elseif navmesh_movement_check == "navmesh_use_mover" then
			local override_mover_move_distance = arg_5_2.breed.override_mover_move_distance
			local flag = true

			if not locomotion_extension:set_movement_type("constrained_by_mover", override_mover_move_distance, flag) then
				locomotion_extension:set_movement_type("snap_to_navmesh")

				arg_5_2.stagger_hit_wall = true
			end
		end
	end

	local flag_2

	flag_2 = var_5_2 or arg_5_3 > arg_5_2.gravity_well_time or "done" or "running"

	return flag_2
end
