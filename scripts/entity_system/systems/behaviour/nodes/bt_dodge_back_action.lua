-- chunkname: @scripts/entity_system/systems/behaviour/nodes/bt_dodge_back_action.lua

require("scripts/entity_system/systems/behaviour/nodes/bt_node")

BTDodgeBackAction = class(BTDodgeBackAction, BTNode)

BTDodgeBackAction.init = function (arg_1_0, ...)
	BTDodgeBackAction.super.init(arg_1_0, ...)
end

BTDodgeBackAction.name = "BTDodgeBackAction"

local function var_0_0(arg_2_0)
	if type(arg_2_0) == "table" then
		return arg_2_0[Math.random(1, #arg_2_0)]
	else
		return arg_2_0
	end
end

BTDodgeBackAction.enter = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3)
	arg_3_2.action = arg_3_0._tree_node.action_data
	arg_3_2.active_node = BTDodgeBackAction
	arg_3_2.start_finished = nil
	arg_3_2.start_started_since = arg_3_3

	local var_3_0 = arg_3_2.navigation_extension
	local var_3_1 = arg_3_2.action
	local var_3_2 = var_3_1.dodge_back_animation
	local var_3_3 = var_3_1.move_speed

	if var_3_3 then
		var_3_0:set_max_speed(var_3_3)
	end

	local var_3_4 = var_0_0(var_3_2)

	Managers.state.network:anim_event(arg_3_1, var_3_4)

	arg_3_2.move_state = "moving"

	local var_3_5 = POSITION_LOOKUP[arg_3_1]
	local var_3_6 = POSITION_LOOKUP[arg_3_2.target_unit]
	local var_3_7 = var_3_5 + Vector3.normalize(var_3_5 - var_3_6) * var_3_1.dodge_distance
	local var_3_8 = 2
	local var_3_9 = 2
	local var_3_10 = arg_3_2.nav_world
	local var_3_11, var_3_12 = GwNavQueries.triangle_from_position(var_3_10, var_3_7, var_3_8, var_3_9)
	local var_3_13

	if var_3_11 then
		var_3_13 = Vector3.copy(var_3_7)
		var_3_13.z = var_3_12
	else
		local var_3_14 = 1
		local var_3_15 = 0.05

		var_3_13 = GwNavQueries.inside_position_from_outside_position(var_3_10, var_3_7, var_3_8, var_3_9, var_3_14, var_3_15)
	end

	if var_3_13 then
		var_3_0:move_to(var_3_13)
		Managers.state.entity:system("ai_slot_system"):do_slot_search(arg_3_1, false)
	end
end

BTDodgeBackAction.leave = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4, arg_4_5)
	arg_4_2.start_finished = nil
	arg_4_2.start_started_since = nil

	Managers.state.entity:system("ai_slot_system"):do_slot_search(arg_4_1, true)

	arg_4_2.active_node = nil

	local var_4_0 = AiUtils.get_default_breed_move_speed(arg_4_1, arg_4_2)

	arg_4_2.navigation_extension:set_max_speed(var_4_0)
end

BTDodgeBackAction.run = function (arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4)
	if arg_5_2.start_finished or arg_5_3 - arg_5_2.start_started_since > 10 then
		return "done"
	end

	local var_5_0 = LocomotionUtils.rotation_towards_unit_flat(arg_5_1, arg_5_2.target_unit)

	arg_5_2.locomotion_extension:set_wanted_rotation(var_5_0)

	return "running"
end

BTDodgeBackAction.anim_cb_combat_step_stop = function (arg_6_0, arg_6_1, arg_6_2)
	local var_6_0 = arg_6_2.navigation_extension

	if var_6_0:is_following_path() then
		var_6_0:stop()
	end
end
