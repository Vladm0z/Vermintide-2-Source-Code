-- chunkname: @scripts/entity_system/systems/behaviour/nodes/bt_defensive_idle_action.lua

require("scripts/entity_system/systems/behaviour/nodes/bt_node")

BTDefensiveIdleAction = class(BTDefensiveIdleAction, BTNode)

function BTDefensiveIdleAction.init(arg_1_0, ...)
	BTDefensiveIdleAction.super.init(arg_1_0, ...)
end

BTDefensiveIdleAction.name = "BTDefensiveIdleAction"

function BTDefensiveIdleAction.enter(arg_2_0, arg_2_1, arg_2_2, arg_2_3)
	local var_2_0 = Managers.state.network
	local var_2_1 = arg_2_0._tree_node.action_data

	arg_2_2.action = var_2_1
	arg_2_2.active_node = BTDefensiveIdleAction

	local var_2_2 = var_2_1.animation

	var_2_0:anim_event(arg_2_1, var_2_2)

	arg_2_2.move_state = "idle"

	if var_2_1.sound_event then
		Managers.state.entity:system("audio_system"):play_audio_unit_event(var_2_1.sound_event, arg_2_1)
	end

	arg_2_2.navigation_extension:set_enabled(false)
	arg_2_2.locomotion_extension:set_wanted_velocity(Vector3.zero())

	arg_2_2.idle_end_time = arg_2_3 + var_2_1.duration
end

function BTDefensiveIdleAction.leave(arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5)
	arg_3_2.navigation_extension:set_enabled(true)
end

function BTDefensiveIdleAction.run(arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4)
	if arg_4_3 > arg_4_2.idle_end_time then
		return "done"
	end

	return "running"
end
