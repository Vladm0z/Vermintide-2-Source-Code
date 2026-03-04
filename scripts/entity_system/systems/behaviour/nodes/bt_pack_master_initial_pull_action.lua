-- chunkname: @scripts/entity_system/systems/behaviour/nodes/bt_pack_master_initial_pull_action.lua

require("scripts/entity_system/systems/behaviour/nodes/bt_node")

BTPackMasterInitialPullAction = class(BTPackMasterInitialPullAction, BTNode)

BTPackMasterInitialPullAction.init = function (arg_1_0, ...)
	BTPackMasterInitialPullAction.super.init(arg_1_0, ...)
end

BTPackMasterInitialPullAction.name = "BTPackMasterInitialPullAction"

BTPackMasterInitialPullAction.enter = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3)
	arg_2_2.action = arg_2_0._tree_node.action_data

	local var_2_0 = arg_2_2.navigation_extension

	AiUtils.allow_smart_object_layers(var_2_0, false)
	arg_2_0:_find_pull_position(arg_2_1, arg_2_2, arg_2_3)

	if arg_2_2.pull_position_end then
		Unit.set_local_rotation(arg_2_1, 0, Quaternion.look(arg_2_2.pull_position_start:unbox() - arg_2_2.pull_position_end:unbox(), Vector3.up()))
		StatusUtils.set_grabbed_by_pack_master_network("pack_master_pulling", arg_2_2.drag_target_unit, true, arg_2_1)
		LocomotionUtils.set_animation_driven_movement(arg_2_1, true, false, false)
	end

	AiUtils.show_polearm(arg_2_1, false)
end

BTPackMasterInitialPullAction._find_pull_position = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3)
	local var_3_0 = arg_3_2.action
	local var_3_1 = arg_3_2.nav_world
	local var_3_2 = POSITION_LOOKUP[arg_3_1]
	local var_3_3 = arg_3_2.drag_target_unit
	local var_3_4 = POSITION_LOOKUP[var_3_3]
	local var_3_5 = Vector3.normalize(var_3_2 - var_3_4)
	local var_3_6 = math.atan2(var_3_5.y, var_3_5.x, 0)
	local var_3_7 = arg_3_2.navigation_extension:traverse_logic()
	local var_3_8 = 10

	for iter_3_0 = 1, var_3_8 do
		local var_3_9 = math.degrees_to_radians(45 * iter_3_0 / var_3_8)
		local var_3_10 = var_3_6 + var_3_9
		local var_3_11 = var_3_2 + var_3_0.pull_distance * Vector3(math.cos(var_3_10), math.sin(var_3_10), 0)
		local var_3_12, var_3_13 = GwNavQueries.triangle_from_position(var_3_1, var_3_11, 0.5, 0.5)
		local var_3_14 = GwNavQueries.raycango(var_3_1, var_3_2, var_3_11, var_3_7)

		if var_3_12 and var_3_14 then
			var_3_11.z = var_3_13
			arg_3_2.pull_position_end = Vector3Box(var_3_11)

			break
		else
			local var_3_15 = var_3_6 - var_3_9
			local var_3_16 = var_3_2 + var_3_0.pull_distance * Vector3(math.cos(var_3_15), math.sin(var_3_15), 0)
			local var_3_17, var_3_18 = GwNavQueries.triangle_from_position(var_3_1, var_3_16, 0.5, 0.5)
			local var_3_19 = GwNavQueries.raycango(var_3_1, var_3_2, var_3_16, var_3_7)

			if var_3_17 and var_3_19 then
				var_3_16.z = var_3_18
				arg_3_2.pull_position_end = Vector3Box(var_3_16)

				break
			end
		end
	end

	arg_3_2.pull_position_start = Vector3Box(var_3_2)
	arg_3_2.pull_t_end = arg_3_3 + var_3_0.pull_time
end

BTPackMasterInitialPullAction.leave = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4, arg_4_5)
	arg_4_2.pull_position_start = nil
	arg_4_2.pull_position_end = nil
	arg_4_2.pull_t_end = nil

	if arg_4_4 ~= "done" and Unit.alive(arg_4_2.drag_target_unit) then
		StatusUtils.set_grabbed_by_pack_master_network("pack_master_pulling", arg_4_2.drag_target_unit, false, arg_4_1)

		arg_4_2.target_unit = nil
		arg_4_2.drag_target_unit = nil

		AiUtils.show_polearm(arg_4_1, true)
	end

	local var_4_0 = arg_4_2.navigation_extension

	AiUtils.allow_smart_object_layers(var_4_0, true)

	if not arg_4_5 then
		LocomotionUtils.set_animation_driven_movement(arg_4_1, false)
		arg_4_2.locomotion_extension:set_movement_type("snap_to_navmesh")
	end

	arg_4_2.attack_cooldown = arg_4_3 + arg_4_2.action.cooldown
end

BTPackMasterInitialPullAction.run = function (arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4)
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
