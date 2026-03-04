-- chunkname: @scripts/entity_system/systems/behaviour/nodes/bt_target_unreachable_action.lua

require("scripts/entity_system/systems/behaviour/nodes/bt_node")

BTTargetUnreachableAction = class(BTTargetUnreachableAction, BTNode)

function BTTargetUnreachableAction.init(arg_1_0, ...)
	BTTargetUnreachableAction.super.init(arg_1_0, ...)
end

BTTargetUnreachableAction.name = "BTTargetUnreachableAction"

function BTTargetUnreachableAction.enter(arg_2_0, arg_2_1, arg_2_2, arg_2_3)
	arg_2_2.action = arg_2_0._tree_node.action_data
	arg_2_2.unreachable_timer = arg_2_2.chasing_timer or 0
end

function BTTargetUnreachableAction.leave(arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5)
	local var_3_0 = AiUtils.get_default_breed_move_speed(arg_3_1, arg_3_2)

	arg_3_2.navigation_extension:set_max_speed(var_3_0)
end

function BTTargetUnreachableAction.run(arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4)
	local var_4_0 = POSITION_LOOKUP[arg_4_1]
	local var_4_1 = arg_4_2.target_unit

	if not var_4_1 then
		return "done"
	end

	local var_4_2 = POSITION_LOOKUP[var_4_1]
	local var_4_3 = Vector3.distance_squared(var_4_2, var_4_0)
	local var_4_4
	local var_4_5 = math.huge
	local var_4_6 = arg_4_2.breed.reach_distance^2
	local var_4_7
	local var_4_8
	local var_4_9 = ScriptUnit.has_extension(var_4_1, "whereabouts_system")

	if var_4_9 then
		local var_4_10, var_4_11 = var_4_9:closest_positions_when_outside_navmesh()

		for iter_4_0 = 1, #var_4_10 do
			local var_4_12 = var_4_10[iter_4_0]:unbox()
			local var_4_13 = 0
			local var_4_14 = Vector3.distance_squared(var_4_2, var_4_12)

			if var_4_14 < var_4_6 * 4 then
				var_4_13 = var_4_14
			else
				var_4_13 = var_4_13 + Vector3.distance_squared(var_4_12, var_4_0) + var_4_3
			end

			if var_4_13 < var_4_5 then
				var_4_4 = var_4_12
				var_4_5 = var_4_13
			end
		end

		arg_4_2.target_outside_navmesh = not var_4_11
	else
		if var_4_3 < 1 then
			local var_4_15 = var_4_0 + Vector3.normalize(var_4_0 - var_4_2) * 1.5

			var_4_4 = ConflictUtils.find_center_tri(arg_4_2.nav_world, var_4_15, 0.7, 0.7)
		end

		arg_4_2.target_outside_navmesh = false
	end

	local var_4_16 = arg_4_2.navigation_extension

	if var_4_4 then
		var_4_16:move_to(var_4_4)
	end

	local var_4_17 = arg_4_2.locomotion_extension

	arg_4_0:move_closer(arg_4_1, arg_4_2, var_4_17, var_4_16)

	arg_4_2.unreachable_timer = arg_4_2.unreachable_timer + arg_4_4

	return "running", "evaluate"
end

function BTTargetUnreachableAction.move_closer(arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4)
	local var_5_0 = POSITION_LOOKUP[arg_5_1]
	local var_5_1 = arg_5_4:distance_to_destination_sq(var_5_0)

	if var_5_1 < 1 then
		arg_5_4:set_max_speed(arg_5_2.breed.walk_speed)
	elseif var_5_1 > 4 then
		arg_5_4:set_max_speed(arg_5_2.breed.run_speed)
	end

	local var_5_2 = arg_5_4:is_following_path()

	if arg_5_2.move_state ~= "moving" and var_5_2 and var_5_1 > 0.25 then
		print("GO TO UNREACHABLE MOVING, DIST_SQ=", var_5_1, arg_5_1)

		arg_5_2.move_state = "moving"

		local var_5_3 = arg_5_2.action
		local var_5_4, var_5_5 = LocomotionUtils.get_start_anim(arg_5_1, arg_5_2, var_5_3.start_anims)

		Managers.state.network:anim_event(arg_5_1, var_5_4 or var_5_3.move_anim)
	elseif arg_5_2.move_state ~= "idle" and (not var_5_2 or var_5_1 < 0.04000000000000001) then
		print("GO TO UNREACHABLE IDLE, DIST_SQ=", var_5_1, arg_5_1)

		arg_5_2.move_state = "idle"

		Managers.state.network:anim_event(arg_5_1, "idle")
	end

	if arg_5_2.move_state == "moving" then
		arg_5_3:set_wanted_rotation(nil)
	else
		local var_5_6 = LocomotionUtils.rotation_towards_unit_flat(arg_5_1, arg_5_2.target_unit)

		arg_5_3:set_wanted_rotation(var_5_6)
	end
end

function BTTargetUnreachableAction._debug_distance_text(arg_6_0, arg_6_1, arg_6_2)
	if script_data.debug_ai_movement then
		local var_6_0 = POSITION_LOOKUP[arg_6_1]
		local var_6_1 = arg_6_2:destination()
		local var_6_2 = arg_6_2:distance_to_destination(var_6_0)
		local var_6_3 = Vector3.flat(var_6_1 - var_6_0)
		local var_6_4 = Vector3.length(var_6_3)

		Debug.text("Unreachable distance to target: %.2f Flat: %.2f", var_6_2, var_6_4)
	end
end
