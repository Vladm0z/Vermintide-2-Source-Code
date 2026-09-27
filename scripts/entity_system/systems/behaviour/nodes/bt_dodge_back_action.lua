-- chunkname: @scripts/entity_system/systems/behaviour/nodes/bt_dodge_back_action.lua

require("scripts/entity_system/systems/behaviour/nodes/bt_node")

BTDodgeBackAction = class(BTDodgeBackAction, BTNode)

BTDodgeBackAction.init = function (arg_1_0, ...)
	-- function 1
	BTDodgeBackAction.super.init(arg_1_0, ...)
end

BTDodgeBackAction.name = "BTDodgeBackAction"

local function fn(self)
	-- function 2
	if type(self) == "table" then
		return self[Math.random(1, #self)]
	else
		return self
	end
end

BTDodgeBackAction.enter = function (self, arg_3_1, arg_3_2, arg_3_3)
	-- function 3
	arg_3_2.action = self._tree_node.action_data
	arg_3_2.active_node = BTDodgeBackAction
	arg_3_2.start_finished = nil
	arg_3_2.start_started_since = arg_3_3

	local navigation_extension = arg_3_2.navigation_extension
	local action = arg_3_2.action
	local dodge_back_animation = action.dodge_back_animation
	local move_speed = action.move_speed

	if not move_speed then
		navigation_extension:set_max_speed(move_speed)
	end

	local var_3_4 = fn(dodge_back_animation)

	Managers.state.network:anim_event(arg_3_1, var_3_4)

	arg_3_2.move_state = "moving"

	local var_3_5 = POSITION_LOOKUP[arg_3_1]
	local var_3_6 = POSITION_LOOKUP[arg_3_2.target_unit]
	local num = var_3_5 + Vector3.normalize(var_3_5 - var_3_6) * action.dodge_distance
	local num_2 = 2
	local num_3 = 2
	local nav_world = arg_3_2.nav_world
	local triangle_from_position, var_3_12 = GwNavQueries.triangle_from_position(nav_world, num, num_2, num_3)
	local var_3_13

	if not triangle_from_position then
		var_3_13 = Vector3.copy(num)
		var_3_13.z = var_3_12
	else
		local num_4 = 1
		local num_5 = 0.05

		var_3_13 = GwNavQueries.inside_position_from_outside_position(nav_world, num, num_2, num_3, num_4, num_5)
	end

	if not var_3_13 then
		navigation_extension:move_to(var_3_13)
		Managers.state.entity:system("ai_slot_system"):do_slot_search(arg_3_1, false)
	end
end

BTDodgeBackAction.leave = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4, arg_4_5)
	-- function 4
	arg_4_2.start_finished = nil
	arg_4_2.start_started_since = nil

	Managers.state.entity:system("ai_slot_system"):do_slot_search(arg_4_1, true)

	arg_4_2.active_node = nil

	local get_default_breed_move_speed = AiUtils.get_default_breed_move_speed(arg_4_1, arg_4_2)

	arg_4_2.navigation_extension:set_max_speed(get_default_breed_move_speed)
end

BTDodgeBackAction.run = function (arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4)
	-- function 5
	if not (arg_5_2.start_finished or not (arg_5_3 - arg_5_2.start_started_since > 10)) then
		return "done"
	end

	local rotation_towards_unit_flat = LocomotionUtils.rotation_towards_unit_flat(arg_5_1, arg_5_2.target_unit)

	arg_5_2.locomotion_extension:set_wanted_rotation(rotation_towards_unit_flat)

	return "running"
end

BTDodgeBackAction.anim_cb_combat_step_stop = function (arg_6_0, arg_6_1, arg_6_2)
	-- function 6
	local navigation_extension = arg_6_2.navigation_extension

	if not navigation_extension:is_following_path() then
		navigation_extension:stop()
	end
end
