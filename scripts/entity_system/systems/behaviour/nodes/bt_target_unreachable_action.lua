-- chunkname: @scripts/entity_system/systems/behaviour/nodes/bt_target_unreachable_action.lua

require("scripts/entity_system/systems/behaviour/nodes/bt_node")

BTTargetUnreachableAction = class(BTTargetUnreachableAction, BTNode)

BTTargetUnreachableAction.init = function (arg_1_0, ...)
	-- function 1
	BTTargetUnreachableAction.super.init(arg_1_0, ...)
end

BTTargetUnreachableAction.name = "BTTargetUnreachableAction"

BTTargetUnreachableAction.enter = function (self, arg_2_1, arg_2_2, arg_2_3)
	-- function 2
	arg_2_2.action = self._tree_node.action_data

	local chasing_timer = arg_2_2.chasing_timer

	chasing_timer = chasing_timer or 0
	arg_2_2.unreachable_timer = chasing_timer
end

BTTargetUnreachableAction.leave = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5)
	-- function 3
	local get_default_breed_move_speed = AiUtils.get_default_breed_move_speed(arg_3_1, arg_3_2)

	arg_3_2.navigation_extension:set_max_speed(get_default_breed_move_speed)
end

BTTargetUnreachableAction.run = function (self, arg_4_1, arg_4_2, arg_4_3, arg_4_4)
	-- function 4
	local var_4_0 = POSITION_LOOKUP[arg_4_1]
	local target_unit = arg_4_2.target_unit

	if not target_unit then
		return "done"
	end

	local var_4_2 = POSITION_LOOKUP[target_unit]
	local distance_squared = Vector3.distance_squared(var_4_2, var_4_0)
	local var_4_4
	local huge = math.huge
	local num = arg_4_2.breed.reach_distance^2
	local var_4_7
	local var_4_8
	local has_extension = ScriptUnit.has_extension(target_unit, "whereabouts_system")

	if not has_extension then
		local closest_positions_when_outside_navmesh, var_4_11 = has_extension:closest_positions_when_outside_navmesh()

		for i = 1, #closest_positions_when_outside_navmesh do
			local unbox = closest_positions_when_outside_navmesh[i]:unbox()
			local num_2 = 0
			local distance_squared_2 = Vector3.distance_squared(var_4_2, unbox)

			if distance_squared_2 < num * 4 then
				num_2 = distance_squared_2
			else
				num_2 = num_2 + Vector3.distance_squared(unbox, var_4_0) + distance_squared
			end

			if num_2 < huge then
				var_4_4 = unbox
				huge = num_2
			end
		end

		arg_4_2.target_outside_navmesh = not var_4_11
	else
		if distance_squared < 1 then
			local num_3 = var_4_0 + Vector3.normalize(var_4_0 - var_4_2) * 1.5

			var_4_4 = ConflictUtils.find_center_tri(arg_4_2.nav_world, num_3, 0.7, 0.7)
		end

		arg_4_2.target_outside_navmesh = false
	end

	local navigation_extension = arg_4_2.navigation_extension

	if not var_4_4 then
		navigation_extension:move_to(var_4_4)
	end

	local locomotion_extension = arg_4_2.locomotion_extension

	self:move_closer(arg_4_1, arg_4_2, locomotion_extension, navigation_extension)

	arg_4_2.unreachable_timer = arg_4_2.unreachable_timer + arg_4_4

	return "running", "evaluate"
end

BTTargetUnreachableAction.move_closer = function (arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4)
	-- function 5
	local var_5_0 = POSITION_LOOKUP[arg_5_1]
	local distance_to_destination_sq = arg_5_4:distance_to_destination_sq(var_5_0)

	if distance_to_destination_sq < 1 then
		arg_5_4:set_max_speed(arg_5_2.breed.walk_speed)
	elseif distance_to_destination_sq > 4 then
		arg_5_4:set_max_speed(arg_5_2.breed.run_speed)
	end

	local is_following_path = arg_5_4:is_following_path()

	if not ((arg_5_2.move_state == "moving" or not is_following_path) and not (distance_to_destination_sq > 0.25)) then
		print("GO TO UNREACHABLE MOVING, DIST_SQ=", distance_to_destination_sq, arg_5_1)

		arg_5_2.move_state = "moving"

		local action = arg_5_2.action
		local get_start_anim, var_5_5 = LocomotionUtils.get_start_anim(arg_5_1, arg_5_2, action.start_anims)

		Managers.state.network:anim_event(arg_5_1, get_start_anim or action.move_anim)
	elseif not (arg_5_2.move_state == "idle" or not is_following_path or not (distance_to_destination_sq < 0.04000000000000001)) then
		print("GO TO UNREACHABLE IDLE, DIST_SQ=", distance_to_destination_sq, arg_5_1)

		arg_5_2.move_state = "idle"

		Managers.state.network:anim_event(arg_5_1, "idle")
	end

	if arg_5_2.move_state == "moving" then
		arg_5_3:set_wanted_rotation(nil)
	else
		local rotation_towards_unit_flat = LocomotionUtils.rotation_towards_unit_flat(arg_5_1, arg_5_2.target_unit)

		arg_5_3:set_wanted_rotation(rotation_towards_unit_flat)
	end
end

BTTargetUnreachableAction._debug_distance_text = function (arg_6_0, arg_6_1, arg_6_2)
	-- function 6
	if not script_data.debug_ai_movement then
		local var_6_0 = POSITION_LOOKUP[arg_6_1]
		local destination = arg_6_2:destination()
		local distance_to_destination = arg_6_2:distance_to_destination(var_6_0)
		local flat = Vector3.flat(destination - var_6_0)
		local length = Vector3.length(flat)

		Debug.text("Unreachable distance to target: %.2f Flat: %.2f", distance_to_destination, length)
	end
end
