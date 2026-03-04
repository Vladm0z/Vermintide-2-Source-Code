-- chunkname: @scripts/entity_system/systems/behaviour/nodes/bt_loot_rat_dodge_action.lua

require("scripts/entity_system/systems/behaviour/nodes/bt_node")

BTLootRatDodgeAction = class(BTLootRatDodgeAction, BTNode)

BTLootRatDodgeAction.init = function (arg_1_0, ...)
	BTLootRatDodgeAction.super.init(arg_1_0, ...)
end

BTLootRatDodgeAction.name = "BTLootRatDodgeAction"

local var_0_0 = POSITION_LOOKUP
local var_0_1 = script_data

BTLootRatDodgeAction.enter = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3)
	local var_2_0 = arg_2_0._tree_node.action_data

	arg_2_2.action = var_2_0

	local var_2_1 = arg_2_2.dodge_vector:unbox()
	local var_2_2 = arg_2_2.threat_vector:unbox()
	local var_2_3, var_2_4, var_2_5 = arg_2_0:dodge(arg_2_1, arg_2_2, var_2_1, var_2_2)

	if var_2_3 then
		arg_2_2.is_dodging = true
		arg_2_2.pass_check_position = Vector3Box(var_2_4)
		arg_2_2.dodge_end_time = arg_2_3 + var_2_0.dodge_time
		arg_2_2.move_state = nil

		LocomotionUtils.set_animation_driven_movement(arg_2_1, false)

		local var_2_6 = arg_2_2.navigation_extension

		var_2_6:set_max_speed(arg_2_2.breed.run_speed)
		var_2_6:move_to(var_2_3)

		local var_2_7 = arg_2_2.locomotion_extension

		var_2_7:set_rotation_speed(20)
		var_2_7:set_movement_type("snap_to_navmesh")
		Managers.state.network:anim_event(arg_2_1, var_2_5 and var_2_0.dodge_right_anim or not var_2_5 and var_2_0.dodge_left_anim or var_2_0.dodge_anim)

		if var_0_1.debug_ai_movement then
			local var_2_8 = var_0_0[arg_2_1]

			QuickDrawerStay:sphere(var_2_3, 0.2, Color(255, 255, 0))
			QuickDrawerStay:sphere(var_2_4, 0.2, Color(255, 0, 0))
			QuickDrawerStay:line(var_2_8, var_2_3, Color(255, 255, 0))
		end
	end
end

BTLootRatDodgeAction.run = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
	if not arg_3_2.is_dodging then
		return "done"
	end

	if arg_3_2.anim_cb_dodge_finished then
		return "done"
	end

	if arg_3_3 > arg_3_2.dodge_end_time then
		return "done"
	end

	local var_3_0 = arg_3_2.pass_check_position:unbox() - var_0_0[arg_3_1]
	local var_3_1 = Unit.local_rotation(arg_3_1, 0)
	local var_3_2 = Quaternion.forward(var_3_1)
	local var_3_3 = Vector3.dot(Vector3.normalize(var_3_0), var_3_2)

	if not arg_3_2.do_pass_check and var_3_3 > 0.5 then
		arg_3_2.do_pass_check = true
	end

	if arg_3_2.do_pass_check and var_3_3 < 0 then
		return "done"
	end

	return "running"
end

BTLootRatDodgeAction.leave = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4, arg_4_5)
	arg_4_2.action = nil
	arg_4_2.is_dodging = nil
	arg_4_2.pass_check_position = nil
	arg_4_2.dodge_end_time = nil
	arg_4_2.do_pass_check = nil
	arg_4_2.dodge_vector = nil
	arg_4_2.threat_vector = nil
	arg_4_2.anim_cb_dodge_finished = nil

	local var_4_0 = AiUtils.get_default_breed_move_speed(arg_4_1, arg_4_2)

	arg_4_2.navigation_extension:set_max_speed(var_4_0)

	if var_0_1.debug_ai_movement then
		local var_4_1 = var_0_0[arg_4_1]

		QuickDrawerStay:sphere(var_4_1, 0.25, Color(0, 255, 0))
	end
end

BTLootRatDodgeAction.dodge = function (arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4)
	local var_5_0 = var_0_0[arg_5_1]
	local var_5_1 = arg_5_2.locomotion_extension:current_velocity()
	local var_5_2 = Vector3.normalize(var_5_1)
	local var_5_3 = Vector3.normalize(arg_5_3)
	local var_5_4 = Vector3.cross(-arg_5_4, Vector3.up())

	if Vector3.cross(var_5_3, arg_5_4).z > 0 then
		var_5_4 = -var_5_4
	end

	local var_5_5 = var_5_4 * 2 + var_5_2
	local var_5_6 = arg_5_2.action.dodge_distance
	local var_5_7 = var_5_6 - 0.3
	local var_5_8 = var_5_0 + var_5_5 * var_5_6
	local var_5_9 = arg_5_0:try_dodge_position(arg_5_1, arg_5_2, var_5_0, var_5_8)

	if var_5_9 then
		local var_5_10 = var_5_0 + var_5_5 * var_5_7

		return var_5_9, var_5_10, Vector3.cross(var_5_5, var_5_2).z > 0
	end

	local var_5_11 = var_5_0 - var_5_5 * var_5_6
	local var_5_12 = arg_5_0:try_dodge_position(arg_5_1, arg_5_2, var_5_0, var_5_11)

	if var_5_12 then
		local var_5_13 = var_5_0 - var_5_5 * var_5_7

		return var_5_12, var_5_13, Vector3.cross(-var_5_5, var_5_2).z > 0
	end
end

BTLootRatDodgeAction.try_dodge_position = function (arg_6_0, arg_6_1, arg_6_2, arg_6_3, arg_6_4)
	local var_6_0, var_6_1 = GwNavQueries.triangle_from_position(arg_6_2.nav_world, arg_6_4, 3, 3)

	if var_6_0 then
		Vector3.set_z(arg_6_4, var_6_1)

		if GwNavQueries.raycast(arg_6_2.nav_world, arg_6_3, arg_6_4) then
			return arg_6_4
		end
	end
end
