-- chunkname: @scripts/entity_system/systems/behaviour/nodes/bt_pack_master_initial_pull_action.lua

require("scripts/entity_system/systems/behaviour/nodes/bt_node")

BTPackMasterInitialPullAction = class(BTPackMasterInitialPullAction, BTNode)

BTPackMasterInitialPullAction.init = function (arg_1_0, ...)
	-- function 1
	BTPackMasterInitialPullAction.super.init(arg_1_0, ...)
end

BTPackMasterInitialPullAction.name = "BTPackMasterInitialPullAction"

BTPackMasterInitialPullAction.enter = function (self, arg_2_1, arg_2_2, arg_2_3)
	-- function 2
	arg_2_2.action = self._tree_node.action_data

	local navigation_extension = arg_2_2.navigation_extension

	AiUtils.allow_smart_object_layers(navigation_extension, false)
	self:_find_pull_position(arg_2_1, arg_2_2, arg_2_3)

	if not arg_2_2.pull_position_end then
		Unit.set_local_rotation(arg_2_1, 0, Quaternion.look(arg_2_2.pull_position_start:unbox() - arg_2_2.pull_position_end:unbox(), Vector3.up()))
		StatusUtils.set_grabbed_by_pack_master_network("pack_master_pulling", arg_2_2.drag_target_unit, true, arg_2_1)
		LocomotionUtils.set_animation_driven_movement(arg_2_1, true, false, false)
	end

	AiUtils.show_polearm(arg_2_1, false)
end

BTPackMasterInitialPullAction._find_pull_position = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3)
	-- function 3
	local action = arg_3_2.action
	local nav_world = arg_3_2.nav_world
	local var_3_2 = POSITION_LOOKUP[arg_3_1]
	local drag_target_unit = arg_3_2.drag_target_unit
	local var_3_4 = POSITION_LOOKUP[drag_target_unit]
	local normalize = Vector3.normalize(var_3_2 - var_3_4)
	local atan2 = math.atan2(normalize.y, normalize.x, 0)
	local traverse_logic = arg_3_2.navigation_extension:traverse_logic()
	local num = 10

	for i = 1, num do
		local degrees_to_radians = math.degrees_to_radians(45 * i / num)
		local num_2 = atan2 + degrees_to_radians
		local num_3 = var_3_2 + action.pull_distance * Vector3(math.cos(num_2), math.sin(num_2), 0)
		local triangle_from_position, var_3_13 = GwNavQueries.triangle_from_position(nav_world, num_3, 0.5, 0.5)
		local raycango = GwNavQueries.raycango(nav_world, var_3_2, num_3, traverse_logic)

		if not triangle_from_position and not raycango then
			num_3.z = var_3_13
			arg_3_2.pull_position_end = Vector3Box(num_3)

			break
		else
			local num_4 = atan2 - degrees_to_radians
			local num_5 = var_3_2 + action.pull_distance * Vector3(math.cos(num_4), math.sin(num_4), 0)
			local triangle_from_position_2, var_3_18 = GwNavQueries.triangle_from_position(nav_world, num_5, 0.5, 0.5)
			local raycango_2 = GwNavQueries.raycango(nav_world, var_3_2, num_5, traverse_logic)

			if not triangle_from_position_2 and not raycango_2 then
				num_5.z = var_3_18
				arg_3_2.pull_position_end = Vector3Box(num_5)

				break
			end
		end
	end

	arg_3_2.pull_position_start = Vector3Box(var_3_2)
	arg_3_2.pull_t_end = arg_3_3 + action.pull_time
end

BTPackMasterInitialPullAction.leave = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4, arg_4_5)
	-- function 4
	arg_4_2.pull_position_start = nil
	arg_4_2.pull_position_end = nil
	arg_4_2.pull_t_end = nil

	if arg_4_4 == "done" or not Unit.alive(arg_4_2.drag_target_unit) then
		StatusUtils.set_grabbed_by_pack_master_network("pack_master_pulling", arg_4_2.drag_target_unit, false, arg_4_1)

		arg_4_2.target_unit = nil
		arg_4_2.drag_target_unit = nil

		AiUtils.show_polearm(arg_4_1, true)
	end

	local navigation_extension = arg_4_2.navigation_extension

	AiUtils.allow_smart_object_layers(navigation_extension, true)

	if not arg_4_5 then
		LocomotionUtils.set_animation_driven_movement(arg_4_1, false)
		arg_4_2.locomotion_extension:set_movement_type("snap_to_navmesh")
	end

	arg_4_2.attack_cooldown = arg_4_3 + arg_4_2.action.cooldown
end

BTPackMasterInitialPullAction.run = function (arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4)
	-- function 5
	if not AiUtils.is_of_interest_to_packmaster(arg_5_1, arg_5_2.drag_target_unit) then
		return "failed"
	end

	if arg_5_2.pull_position_end == nil then
		return "done"
	end

	if arg_5_3 > arg_5_2.pull_t_end then
		return "done"
	end

	return "running"
end
