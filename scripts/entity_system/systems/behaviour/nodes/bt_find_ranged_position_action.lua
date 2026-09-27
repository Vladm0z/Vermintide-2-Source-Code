-- chunkname: @scripts/entity_system/systems/behaviour/nodes/bt_find_ranged_position_action.lua

require("scripts/entity_system/systems/behaviour/nodes/bt_node")

BTFindRangedPositionAction = class(BTFindRangedPositionAction, BTNode)

BTFindRangedPositionAction.init = function (arg_1_0, ...)
	-- function 1
	BTFindRangedPositionAction.super.init(arg_1_0, ...)
end

BTFindRangedPositionAction.name = "BTFindRangedPositionAction"

BTFindRangedPositionAction.enter = function (self, arg_2_1, arg_2_2, arg_2_3)
	-- function 2
	arg_2_2.action = self._tree_node.action_data

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

BTFindRangedPositionAction.leave = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5)
	-- function 3
	arg_3_2.find_ranged_position_t = nil
	arg_3_2.action = nil
	arg_3_2.num_failed_find_position_attempts = nil
end

BTFindRangedPositionAction.run = function (self, arg_4_1, arg_4_2, arg_4_3, arg_4_4)
	-- function 4
	local find_ranged_position_t = arg_4_2.find_ranged_position_t

	if not Unit.alive(arg_4_2.target_unit) then
		return "done"
	end

	if find_ranged_position_t < arg_4_3 then
		local _find_ranged_position = self:_find_ranged_position(arg_4_1, arg_4_2, arg_4_3)

		if not _find_ranged_position then
			arg_4_2.navigation_extension:set_enabled(true)
			arg_4_2.navigation_extension:move_to(_find_ranged_position)

			arg_4_2.ranged_position = Vector3Box(_find_ranged_position)
		else
			arg_4_2.find_ranged_position_t = arg_4_3 + 0.25
		end
	end

	return "running", "evaluate"
end

BTFindRangedPositionAction._find_ranged_position = function (arg_5_0, arg_5_1, arg_5_2, arg_5_3)
	-- function 5
	local action = arg_5_2.action
	local nav_world = arg_5_2.nav_world
	local target_unit = arg_5_2.target_unit
	local var_5_3 = POSITION_LOOKUP[target_unit]
	local pos_on_mesh = LocomotionUtils.pos_on_mesh(nav_world, var_5_3, 1, 1)

	if not pos_on_mesh then
		local inside_position_from_outside_position = GwNavQueries.inside_position_from_outside_position(nav_world, var_5_3, 6, 6, 8, 0.5)

		if not inside_position_from_outside_position then
			pos_on_mesh = inside_position_from_outside_position
		end
	end

	local var_5_6
	local num = 3

	if not pos_on_mesh then
		local var_5_8 = POSITION_LOOKUP[arg_5_1]
		local normalize = Vector3.normalize(var_5_8 - var_5_3)
		local look = Quaternion.look(normalize)
		local num_failed_find_position_attempts = arg_5_2.num_failed_find_position_attempts
		local max = math.max(-90 - num_failed_find_position_attempts * 10, -180)
		local min = math.min(90 + num_failed_find_position_attempts * 10, 180)

		for i = 1, num do
			repeat
				local pi = math.pi
				local random = math.random(action.max_dist[1], action.max_dist[2])
				local min_dist = action.min_dist
				local num_2 = math.random(max, min) * pi / 180
				local var_5_18 = Vector3(math.sin(num_2), math.cos(num_2), 0)
				local look_2 = Quaternion.look(var_5_18)
				local multiply = Quaternion.multiply(look, look_2)
				local forward = Quaternion.forward(multiply)
				local num_3 = var_5_3 + forward * random

				if not num_3 then
					local raycast, var_5_24 = GwNavQueries.raycast(nav_world, pos_on_mesh, num_3)

					if not var_5_24 then
						local distance = Vector3.distance(var_5_24, var_5_3)

						if not (min_dist < distance) then
							local num_4 = var_5_3 + forward * math.random(min_dist, distance)

							var_5_6 = LocomotionUtils.pos_on_mesh(nav_world, num_4, 1, 1)
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
			var_5_6 = LocomotionUtils.pos_on_mesh(nav_world, var_5_3, 1, 1)

			if not var_5_6 then
				local inside_position_from_outside_position_2 = GwNavQueries.inside_position_from_outside_position(nav_world, var_5_3, 6, 6, 8, 0.5)

				if not inside_position_from_outside_position_2 then
					var_5_6 = inside_position_from_outside_position_2
				end
			end
		end
	end

	return var_5_6
end
