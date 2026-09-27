-- chunkname: @scripts/entity_system/systems/behaviour/nodes/bt_defend_standard_action.lua

require("scripts/entity_system/systems/behaviour/nodes/bt_node")

BTDefendStandardAction = class(BTDefendStandardAction, BTNode)

BTDefendStandardAction.init = function (arg_1_0, ...)
	-- function 1
	BTDefendStandardAction.super.init(arg_1_0, ...)
end

BTDefendStandardAction.name = "BTDefendStandardAction"

local function fn(self)
	-- function 2
	if type(self) == "table" then
		return self[Math.random(1, #self)]
	else
		return self
	end
end

BTDefendStandardAction.enter = function (self, arg_3_1, arg_3_2, arg_3_3)
	-- function 3
	arg_3_2.action = self._tree_node.action_data
	arg_3_2.active_node = BTDefendStandardAction

	Managers.state.entity:system("ai_slot_system"):do_slot_search(arg_3_1, false)

	local local_position = Unit.local_position(arg_3_2.standard_unit, 0)

	arg_3_2.navigation_extension:move_to(local_position)

	arg_3_2.standard_position_boxed = Vector3Box(local_position)

	Managers.state.network:anim_event(arg_3_1, "move_start_fwd")

	arg_3_2.move_state = "moving"
	arg_3_2.moving_to_defend_standard = true
end

BTDefendStandardAction.leave = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4, arg_4_5)
	-- function 4
	local get_default_breed_move_speed = AiUtils.get_default_breed_move_speed(arg_4_1, arg_4_2)
	local navigation_extension = arg_4_2.navigation_extension

	navigation_extension:set_enabled(true)
	navigation_extension:set_max_speed(get_default_breed_move_speed)

	arg_4_2.action = nil
	arg_4_2.active_node = nil
	arg_4_2.moving_to_defend_standard = nil
	arg_4_2.next_move_adjustment_t = nil
	arg_4_2.reached_standard = nil
	arg_4_2.standard_position_boxed = nil

	Managers.state.entity:system("ai_slot_system"):do_slot_search(arg_4_1, true)

	arg_4_2.move_state = "idle"
end

BTDefendStandardAction.run = function (self, arg_5_1, arg_5_2, arg_5_3, arg_5_4)
	-- function 5
	if not HEALTH_ALIVE[arg_5_2.standard_unit] then
		return "done"
	end

	local unbox = arg_5_2.standard_position_boxed:unbox()
	local var_5_1 = POSITION_LOOKUP[arg_5_1]

	if not (not (Vector3.distance(unbox, var_5_1) < 2.5) or arg_5_2.reached_standard) then
		arg_5_2.reached_standard = true

		Managers.state.network:anim_event(arg_5_1, "idle")
		self:_enable_navigation(arg_5_2, false)

		arg_5_2.next_move_adjustment_t = arg_5_3 + 1

		arg_5_2.navigation_extension:set_max_speed(arg_5_2.breed.walk_speed)
	end

	if not arg_5_2.reached_standard then
		local target_unit = arg_5_2.target_unit

		if not HEALTH_ALIVE[target_unit] then
			local rotation_towards_unit_flat = LocomotionUtils.rotation_towards_unit_flat(arg_5_1, target_unit)

			arg_5_2.locomotion_extension:set_wanted_rotation(rotation_towards_unit_flat)

			local target_distance_to_standard = arg_5_2.target_distance_to_standard

			if not (not target_distance_to_standard and not (target_distance_to_standard < arg_5_2.breed.defensive_threshold_distance)) then
				return "done"
			end

			if arg_5_3 > arg_5_2.next_move_adjustment_t then
				self:_adjust_defend_position(arg_5_1, arg_5_2, target_unit, var_5_1, unbox, rotation_towards_unit_flat)

				arg_5_2.next_move_adjustment_t = arg_5_3 + 1
			elseif not (not arg_5_2.navigation_extension:has_reached_destination() and arg_5_2.has_reached_adjustment_position) then
				self:_enable_navigation(arg_5_2, false)
				Managers.state.network:anim_event(arg_5_1, "idle")

				arg_5_2.has_reached_adjustment_position = true
			end
		end
	end

	return "running"
end

BTDefendStandardAction._adjust_defend_position = function (self, arg_6_1, arg_6_2, arg_6_3, arg_6_4, arg_6_5, arg_6_6)
	-- function 6
	local var_6_0 = POSITION_LOOKUP[arg_6_3]
	local num = arg_6_5 + Vector3.normalize(var_6_0 - arg_6_5) * Math.random_range(1, 1.5)
	local nav_world = arg_6_2.nav_world
	local num_2 = 1
	local num_3 = 1
	local triangle_from_position, var_6_6 = GwNavQueries.triangle_from_position(nav_world, num, num_2, num_3)
	local var_6_7

	if not triangle_from_position then
		var_6_7 = Vector3.copy(num)
		var_6_7.z = var_6_6
	else
		local num_4 = 1
		local num_5 = 0.05

		var_6_7 = GwNavQueries.inside_position_from_outside_position(nav_world, num, num_2, num_3, num_4, num_5)
	end

	if not (not var_6_7 and not (Vector3.distance(arg_6_4, var_6_7) > 1)) then
		self:_enable_navigation(arg_6_2, true)

		arg_6_2.has_reached_adjustment_position = nil

		arg_6_2.navigation_extension:move_to(var_6_7)

		local normalize = Vector3.normalize(var_6_7 - arg_6_4)
		local _calculate_walk_dir = self:_calculate_walk_dir(Quaternion.right(arg_6_6), Quaternion.forward(arg_6_6), normalize, arg_6_4)
		local _calculate_walk_animation = self:_calculate_walk_animation(_calculate_walk_dir)

		Managers.state.network:anim_event(arg_6_1, _calculate_walk_animation)

		arg_6_2.move_state = "moving"
	end
end

BTDefendStandardAction._enable_navigation = function (arg_7_0, arg_7_1, arg_7_2)
	-- function 7
	if not arg_7_2 then
		arg_7_1.navigation_extension:set_enabled(true)
	else
		arg_7_1.navigation_extension:set_enabled(false)
		arg_7_1.locomotion_extension:set_wanted_velocity(Vector3(0, 0, 0))
	end
end

BTDefendStandardAction._calculate_walk_animation = function (arg_8_0, arg_8_1)
	-- function 8
	local var_8_0
	local flag

	flag = (arg_8_1 ~= "right" or not "move_right_walk" or arg_8_1 ~= "left") and (not "move_left_walk" or arg_8_1 ~= "forward" or not "move_fwd_walk" or "move_bwd_walk")

	return flag
end

BTDefendStandardAction._calculate_walk_dir = function (arg_9_0, arg_9_1, arg_9_2, arg_9_3, arg_9_4)
	-- function 9
	local dot = Vector3.dot(arg_9_1, arg_9_3)
	local dot_2 = Vector3.dot(arg_9_2, arg_9_3)
	local abs = math.abs(dot)
	local abs_2 = math.abs(dot_2)

	arg_9_3 = (not (abs_2 < abs) or not (dot > 0) or not "right" or not (abs_2 < abs)) and (not "left" or not (dot_2 > 0) or not "forward" or "backward")

	return arg_9_3
end
