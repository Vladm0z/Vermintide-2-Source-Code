-- chunkname: @scripts/entity_system/systems/behaviour/nodes/bt_circle_prey_action.lua

require("scripts/entity_system/systems/behaviour/nodes/bt_node")

BTCirclePreyAction = class(BTCirclePreyAction, BTNode)

function BTCirclePreyAction.init(arg_1_0, ...)
	BTCirclePreyAction.super.init(arg_1_0, ...)
end

BTCirclePreyAction.name = "BTCirclePreyAction"

function BTCirclePreyAction.enter(arg_2_0, arg_2_1, arg_2_2, arg_2_3)
	LocomotionUtils.set_animation_driven_movement(arg_2_1, false)

	if GwNavQueries.triangle_from_position(arg_2_2.nav_world, POSITION_LOOKUP[arg_2_1], 0.5, 0.5) then
		arg_2_2.navigation_extension:set_max_speed(arg_2_2.breed.run_speed)

		if arg_2_2.skulk_pos then
			local var_2_0 = arg_2_2.skulk_pos:unbox()

			arg_2_0:move_to_goal(arg_2_1, arg_2_2, var_2_0)
		else
			local var_2_1 = arg_2_0:get_new_goal(arg_2_1, arg_2_2)

			if var_2_1 then
				arg_2_2.skulk_pos = Vector3Box(var_2_1)

				arg_2_0:move_to_goal(arg_2_1, arg_2_2, var_2_1)
			else
				arg_2_0:stop(arg_2_1, arg_2_2)
			end
		end
	else
		arg_2_2.ninja_vanish = true

		arg_2_0:stop(arg_2_1, arg_2_2)
	end
end

function BTCirclePreyAction.leave(arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5)
	if arg_3_4 == "aborted" then
		arg_3_2.need_to_recalculate_skulk_pos = true
	end

	local var_3_0 = AiUtils.get_default_breed_move_speed(arg_3_1, arg_3_2)

	arg_3_2.navigation_extension:set_max_speed(var_3_0)
end

function BTCirclePreyAction.run(arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4)
	local var_4_0 = arg_4_2.navigation_extension

	if not arg_4_2.ninja_vanish and var_4_0:has_reached_destination() then
		local var_4_1 = arg_4_0:get_new_goal(arg_4_1, arg_4_2)

		if var_4_1 then
			local var_4_2 = arg_4_2.skulk_pos or Vector3Box()

			var_4_2:store(var_4_1)

			arg_4_2.skulk_pos = var_4_2

			arg_4_0:move_to_goal(arg_4_1, arg_4_2, var_4_1)
		else
			arg_4_0:stop(arg_4_1, arg_4_2)
		end
	end

	return "running"
end

function BTCirclePreyAction.get_new_goal(arg_5_0, arg_5_1, arg_5_2)
	local var_5_0 = arg_5_2.secondary_target or arg_5_2.target_unit

	if Unit.alive(var_5_0) then
		local var_5_1 = POSITION_LOOKUP[var_5_0]
		local var_5_2 = LocomotionUtils.new_random_goal(arg_5_2.nav_world, arg_5_2, var_5_1, 5, 10, 10)

		if var_5_2 then
			return var_5_2
		end
	end
end

function BTCirclePreyAction.move_to_goal(arg_6_0, arg_6_1, arg_6_2, arg_6_3)
	if arg_6_2.move_state ~= "moving" then
		Managers.state.network:anim_event(arg_6_1, "move_fwd")

		arg_6_2.move_state = "moving"
	end

	arg_6_2.locomotion_extension:set_wanted_rotation(nil)
	arg_6_2.navigation_extension:move_to(arg_6_3)
end

function BTCirclePreyAction.stop(arg_7_0, arg_7_1, arg_7_2)
	if arg_7_2.move_state ~= "idle" then
		Managers.state.network:anim_event(arg_7_1, "idle")

		arg_7_2.move_state = "idle"
	end

	local var_7_0 = arg_7_2.navigation_extension

	if var_7_0:is_following_path() then
		var_7_0:stop()
	end
end
