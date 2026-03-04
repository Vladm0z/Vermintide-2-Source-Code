-- chunkname: @scripts/entity_system/systems/behaviour/nodes/bt_allied_avoid_combat_action.lua

require("scripts/entity_system/systems/behaviour/nodes/bt_node")

BTAlliedAvoidCombatAction = class(BTAlliedAvoidCombatAction, BTNode)

BTAlliedAvoidCombatAction.init = function (arg_1_0, ...)
	BTAlliedAvoidCombatAction.super.init(arg_1_0, ...)
end

BTAlliedAvoidCombatAction.name = "BTAlliedAvoidCombatAction"

BTAlliedAvoidCombatAction.enter = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3)
	arg_2_2.action = arg_2_0._tree_node.action_data
	arg_2_2.target_status_extension = ScriptUnit.extension(arg_2_2.player_controller_unit, "status_system")

	local var_2_0 = POSITION_LOOKUP[arg_2_1]
	local var_2_1 = POSITION_LOOKUP[arg_2_2.player_controller_unit]
	local var_2_2 = LocomotionUtils.pos_on_mesh(arg_2_2.nav_world, var_2_1, 1, 1) or var_2_0

	arg_2_2.wanted_flee_pos = Vector3Box(var_2_2)

	arg_2_2.navigation_extension:set_max_speed(arg_2_2.breed.run_speed)
end

BTAlliedAvoidCombatAction.leave = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5)
	local var_3_0 = AiUtils.get_default_breed_move_speed(arg_3_1, arg_3_2)

	arg_3_2.navigation_extension:set_max_speed(var_3_0)
	Unit.set_unit_visibility(arg_3_1, true)

	if arg_3_2.player_controller_unit then
		local var_3_1 = POSITION_LOOKUP[arg_3_2.player_controller_unit]

		arg_3_2.locomotion_extension:teleport_to(var_3_1)
	end

	arg_3_2.wanted_flee_pos = nil
end

BTAlliedAvoidCombatAction.run = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4)
	local var_4_0 = arg_4_2.locomotion_extension

	arg_4_0:flee(arg_4_1, arg_4_3, arg_4_4, arg_4_2, var_4_0)

	return "running", "evaluate"
end

BTAlliedAvoidCombatAction._go_idle = function (arg_5_0, arg_5_1, arg_5_2, arg_5_3)
	arg_5_2.move_state = "idle"

	local var_5_0 = arg_5_2.action

	Managers.state.network:anim_event(arg_5_1, var_5_0.idle_anim or "idle")
	Unit.set_unit_visibility(arg_5_1, false)
end

BTAlliedAvoidCombatAction._go_moving = function (arg_6_0, arg_6_1, arg_6_2, arg_6_3)
	arg_6_2.move_state = "moving"

	Managers.state.network:anim_event(arg_6_1, arg_6_3.move_anim)
end

BTAlliedAvoidCombatAction.flee = function (arg_7_0, arg_7_1, arg_7_2, arg_7_3, arg_7_4, arg_7_5)
	local var_7_0 = arg_7_4.action
	local var_7_1 = arg_7_4.navigation_extension

	arg_7_0:_move_to_flee_location(arg_7_1, arg_7_4, arg_7_2, arg_7_3)

	local var_7_2 = var_7_1:destination() - POSITION_LOOKUP[arg_7_1]

	Vector3.set_z(var_7_2, 0)

	local var_7_3 = Vector3.length_squared(var_7_2)
	local var_7_4 = var_7_1:is_following_path()

	if arg_7_4.move_state ~= "moving" and var_7_4 and var_7_3 > 0.25 then
		arg_7_0:_go_moving(arg_7_1, arg_7_4, var_7_0)
	elseif arg_7_4.move_state ~= "idle" and (not var_7_4 or var_7_3 < 0.04000000000000001) then
		arg_7_0:_go_idle(arg_7_1, arg_7_4, arg_7_5)
	end

	local var_7_5 = arg_7_4.target_status_extension and arg_7_4.target_status_extension:get_pacing_intensity()

	arg_7_4.target_is_in_combat = var_7_5 and var_7_5 > 0
end

BTAlliedAvoidCombatAction._move_to_flee_location = function (arg_8_0, arg_8_1, arg_8_2, arg_8_3, arg_8_4)
	local var_8_0 = arg_8_2.navigation_extension
	local var_8_1 = arg_8_2.wanted_flee_pos:unbox()

	var_8_0:move_to(var_8_1)
end
