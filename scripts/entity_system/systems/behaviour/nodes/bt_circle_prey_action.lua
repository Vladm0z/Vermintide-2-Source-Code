-- chunkname: @scripts/entity_system/systems/behaviour/nodes/bt_circle_prey_action.lua

require("scripts/entity_system/systems/behaviour/nodes/bt_node")

BTCirclePreyAction = class(BTCirclePreyAction, BTNode)

BTCirclePreyAction.init = function (arg_1_0, ...)
	-- function 1
	BTCirclePreyAction.super.init(arg_1_0, ...)
end

BTCirclePreyAction.name = "BTCirclePreyAction"

BTCirclePreyAction.enter = function (self, arg_2_1, arg_2_2, arg_2_3)
	-- function 2
	LocomotionUtils.set_animation_driven_movement(arg_2_1, false)

	if not GwNavQueries.triangle_from_position(arg_2_2.nav_world, POSITION_LOOKUP[arg_2_1], 0.5, 0.5) then
		arg_2_2.navigation_extension:set_max_speed(arg_2_2.breed.run_speed)

		if not arg_2_2.skulk_pos then
			local unbox = arg_2_2.skulk_pos:unbox()

			self:move_to_goal(arg_2_1, arg_2_2, unbox)
		else
			local get_new_goal = self:get_new_goal(arg_2_1, arg_2_2)

			if not get_new_goal then
				arg_2_2.skulk_pos = Vector3Box(get_new_goal)

				self:move_to_goal(arg_2_1, arg_2_2, get_new_goal)
			else
				self:stop(arg_2_1, arg_2_2)
			end
		end
	else
		arg_2_2.ninja_vanish = true

		self:stop(arg_2_1, arg_2_2)
	end
end

BTCirclePreyAction.leave = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5)
	-- function 3
	if arg_3_4 == "aborted" then
		arg_3_2.need_to_recalculate_skulk_pos = true
	end

	local get_default_breed_move_speed = AiUtils.get_default_breed_move_speed(arg_3_1, arg_3_2)

	arg_3_2.navigation_extension:set_max_speed(get_default_breed_move_speed)
end

BTCirclePreyAction.run = function (self, arg_4_1, arg_4_2, arg_4_3, arg_4_4)
	-- function 4
	local navigation_extension = arg_4_2.navigation_extension

	if arg_4_2.ninja_vanish or not navigation_extension:has_reached_destination() then
		local get_new_goal = self:get_new_goal(arg_4_1, arg_4_2)

		if not get_new_goal then
			local skulk_pos = arg_4_2.skulk_pos

			skulk_pos = skulk_pos or Vector3Box()

			skulk_pos:store(get_new_goal)

			arg_4_2.skulk_pos = skulk_pos

			self:move_to_goal(arg_4_1, arg_4_2, get_new_goal)
		else
			self:stop(arg_4_1, arg_4_2)
		end
	end

	return "running"
end

BTCirclePreyAction.get_new_goal = function (arg_5_0, arg_5_1, arg_5_2)
	-- function 5
	local secondary_target = arg_5_2.secondary_target

	secondary_target = secondary_target or arg_5_2.target_unit

	if not Unit.alive(secondary_target) then
		local var_5_1 = POSITION_LOOKUP[secondary_target]
		local new_random_goal = LocomotionUtils.new_random_goal(arg_5_2.nav_world, arg_5_2, var_5_1, 5, 10, 10)

		if not new_random_goal then
			return new_random_goal
		end
	end
end

BTCirclePreyAction.move_to_goal = function (arg_6_0, arg_6_1, arg_6_2, arg_6_3)
	-- function 6
	if arg_6_2.move_state ~= "moving" then
		Managers.state.network:anim_event(arg_6_1, "move_fwd")

		arg_6_2.move_state = "moving"
	end

	arg_6_2.locomotion_extension:set_wanted_rotation(nil)
	arg_6_2.navigation_extension:move_to(arg_6_3)
end

BTCirclePreyAction.stop = function (arg_7_0, arg_7_1, arg_7_2)
	-- function 7
	if arg_7_2.move_state ~= "idle" then
		Managers.state.network:anim_event(arg_7_1, "idle")

		arg_7_2.move_state = "idle"
	end

	local navigation_extension = arg_7_2.navigation_extension

	if not navigation_extension:is_following_path() then
		navigation_extension:stop()
	end
end
