-- chunkname: @scripts/entity_system/systems/behaviour/nodes/bt_find_ranged_position_action.lua

require("scripts/entity_system/systems/behaviour/nodes/bt_node")

BTFindRangedPositionAction = class(BTFindRangedPositionAction, BTNode)

function BTFindRangedPositionAction.init(arg_1_0, ...)
	BTFindRangedPositionAction.super.init(arg_1_0, ...)
end

BTFindRangedPositionAction.name = "BTFindRangedPositionAction"

function BTFindRangedPositionAction.enter(arg_2_0, arg_2_1, arg_2_2, arg_2_3)
	arg_2_2.action = arg_2_0._tree_node.action_data

	if arg_2_2.move_state ~= "idle" then
		arg_2_2.move_state = "idle"
	end

	arg_2_2.find_ranged_position_t = arg_2_3 + 0.5

	arg_2_2.navigation_extension:stop()
	arg_2_2.navigation_extension:set_enabled(false)
	arg_2_2.locomotion_extension:set_wanted_velocity(Vector3(0, 0, 0))

	arg_2_2.num_failed_find_position_attempts = 0

	Managers.state.network:anim_event(arg_2_1, "idle")
	Managers.state.entity:system("ai_slot_system"):do_slot_search(arg_2_1, false)
end

function BTFindRangedPositionAction.leave(arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5)
	arg_3_2.find_ranged_position_t = nil
	arg_3_2.action = nil
	arg_3_2.num_failed_find_position_attempts = nil
end

function BTFindRangedPositionAction.run(arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4)
	local var_4_0 = arg_4_2.find_ranged_position_t

	if not Unit.alive(arg_4_2.target_unit) then
		return "done"
	end

	if var_4_0 < arg_4_3 then
		local var_4_1 = arg_4_0:_find_ranged_position(arg_4_1, arg_4_2, arg_4_3)

		if var_4_1 then
			arg_4_2.navigation_extension:set_enabled(true)
			arg_4_2.navigation_extension:move_to(var_4_1)

			arg_4_2.ranged_position = Vector3Box(var_4_1)
		else
			arg_4_2.find_ranged_position_t = arg_4_3 + 0.25
		end
	end

	return "running", "evaluate"
end

function BTFindRangedPositionAction._find_ranged_position(arg_5_0, arg_5_1, arg_5_2, arg_5_3)
	local var_5_0 = arg_5_2.action
	local var_5_1 = arg_5_2.nav_world
	local var_5_2 = arg_5_2.target_unit
	local var_5_3 = POSITION_LOOKUP[var_5_2]
	local var_5_4 = LocomotionUtils.pos_on_mesh(var_5_1, var_5_3, 1, 1)

	if not var_5_4 then
		local var_5_5 = GwNavQueries.inside_position_from_outside_position(var_5_1, var_5_3, 6, 6, 8, 0.5)

		if var_5_5 then
			var_5_4 = var_5_5
		end
	end

	local var_5_6
	local var_5_7 = 3

	if var_5_4 then
		local var_5_8 = POSITION_LOOKUP[arg_5_1]
		local var_5_9 = Vector3.normalize(var_5_8 - var_5_3)
		local var_5_10 = Quaternion.look(var_5_9)
		local var_5_11 = arg_5_2.num_failed_find_position_attempts
		local var_5_12 = math.max(-90 - var_5_11 * 10, -180)
		local var_5_13 = math.min(90 + var_5_11 * 10, 180)

		for iter_5_0 = 1, var_5_7 do
			repeat
				local var_5_14 = math.pi
				local var_5_15 = math.random(var_5_0.max_dist[1], var_5_0.max_dist[2])
				local var_5_16 = var_5_0.min_dist
				local var_5_17 = math.random(var_5_12, var_5_13) * var_5_14 / 180
				local var_5_18 = Vector3(math.sin(var_5_17), math.cos(var_5_17), 0)
				local var_5_19 = Quaternion.look(var_5_18)
				local var_5_20 = Quaternion.multiply(var_5_10, var_5_19)
				local var_5_21 = Quaternion.forward(var_5_20)
				local var_5_22 = var_5_3 + var_5_21 * var_5_15

				if var_5_22 then
					local var_5_23, var_5_24 = GwNavQueries.raycast(var_5_1, var_5_4, var_5_22)

					if var_5_24 then
						local var_5_25 = Vector3.distance(var_5_24, var_5_3)

						if var_5_16 < var_5_25 then
							local var_5_26 = var_5_3 + var_5_21 * math.random(var_5_16, var_5_25)

							var_5_6 = LocomotionUtils.pos_on_mesh(var_5_1, var_5_26, 1, 1)
						end
					end
				end

				do break end
				break
			until true
		end
	end

	if not var_5_6 then
		arg_5_2.num_failed_find_position_attempts = arg_5_2.num_failed_find_position_attempts + 1

		if arg_5_2.num_failed_find_position_attempts >= 9 then
			var_5_6 = LocomotionUtils.pos_on_mesh(var_5_1, var_5_3, 1, 1)

			if not var_5_6 then
				local var_5_27 = GwNavQueries.inside_position_from_outside_position(var_5_1, var_5_3, 6, 6, 8, 0.5)

				if var_5_27 then
					var_5_6 = var_5_27
				end
			end
		end
	end

	return var_5_6
end
