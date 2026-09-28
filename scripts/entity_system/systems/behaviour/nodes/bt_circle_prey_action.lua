-- chunkname: @scripts/entity_system/systems/behaviour/nodes/bt_circle_prey_action.lua

require("scripts/entity_system/systems/behaviour/nodes/bt_node")

BTCirclePreyAction = class(BTCirclePreyAction, BTNode)

BTCirclePreyAction.init = function (self, ...)
	-- function 1
	BTCirclePreyAction.super.init(self, ...)
end

BTCirclePreyAction.name = "BTCirclePreyAction"

BTCirclePreyAction.enter = function (self, unit, blackboard, t)
	-- function 2
	LocomotionUtils.set_animation_driven_movement(unit, false)

	local is_on_navmesh = GwNavQueries.triangle_from_position(blackboard.nav_world, POSITION_LOOKUP[unit], 0.5, 0.5)

	if is_on_navmesh then
		local navigation_extension = blackboard.navigation_extension

		navigation_extension:set_max_speed(blackboard.breed.run_speed)

		if blackboard.skulk_pos then
			local goal_position = blackboard.skulk_pos:unbox()

			self:move_to_goal(unit, blackboard, goal_position)
		else
			local goal_position = self:get_new_goal(unit, blackboard)

			if goal_position then
				blackboard.skulk_pos = Vector3Box(goal_position)

				self:move_to_goal(unit, blackboard, goal_position)
			else
				self:stop(unit, blackboard)
			end
		end
	else
		blackboard.ninja_vanish = true

		self:stop(unit, blackboard)
	end
end

BTCirclePreyAction.leave = function (self, unit, blackboard, t, reason, destroy)
	-- function 3
	if reason == "aborted" then
		blackboard.need_to_recalculate_skulk_pos = true
	end

	local default_move_speed = AiUtils.get_default_breed_move_speed(unit, blackboard)
	local navigation_extension = blackboard.navigation_extension

	navigation_extension:set_max_speed(default_move_speed)
end

BTCirclePreyAction.run = function (self, unit, blackboard, t, dt)
	-- function 4
	local navigation_extension = blackboard.navigation_extension

	if not blackboard.ninja_vanish and navigation_extension:has_reached_destination() then
		local goal_position = self:get_new_goal(unit, blackboard)

		if goal_position then
			local skulk_pos = blackboard.skulk_pos

			if not skulk_pos then
				-- Nothing
			end

			skulk_pos = Vector3Box()

			local skulk_pos_box = skulk_pos

			::label_4_0::

			skulk_pos_box:store(goal_position)

			blackboard.skulk_pos = skulk_pos_box

			self:move_to_goal(unit, blackboard, goal_position)
		else
			self:stop(unit, blackboard)
		end
	end

	return "running"
end

BTCirclePreyAction.get_new_goal = function (self, unit, blackboard)
	-- function 5
	local secondary_target = blackboard.secondary_target

	if not secondary_target then
		-- Nothing
	end

	secondary_target = blackboard.target_unit

	local target_unit = secondary_target

	::label_5_0::

	if Unit.alive(target_unit) then
		local target_position = POSITION_LOOKUP[target_unit]
		local goal_position = LocomotionUtils.new_random_goal(blackboard.nav_world, blackboard, target_position, 5, 10, 10)

		if goal_position then
			return goal_position
		end
	end
end

BTCirclePreyAction.move_to_goal = function (self, unit, blackboard, goal_position)
	-- function 6
	if blackboard.move_state ~= "moving" then
		Managers.state.network:anim_event(unit, "move_fwd")

		blackboard.move_state = "moving"
	end

	local locomotion_extension = blackboard.locomotion_extension

	locomotion_extension:set_wanted_rotation(nil)

	local navigation_extension = blackboard.navigation_extension

	navigation_extension:move_to(goal_position)
end

BTCirclePreyAction.stop = function (self, unit, blackboard)
	-- function 7
	if blackboard.move_state ~= "idle" then
		Managers.state.network:anim_event(unit, "idle")

		blackboard.move_state = "idle"
	end

	local navigation_extension = blackboard.navigation_extension

	if navigation_extension:is_following_path() then
		navigation_extension:stop()
	end
end
