-- chunkname: @scripts/entity_system/systems/behaviour/nodes/bt_defensive_idle_action.lua

require("scripts/entity_system/systems/behaviour/nodes/bt_node")

BTDefensiveIdleAction = class(BTDefensiveIdleAction, BTNode)

BTDefensiveIdleAction.init = function (arg_1_0, ...)
	-- function 1
	BTDefensiveIdleAction.super.init(arg_1_0, ...)
end

BTDefensiveIdleAction.name = "BTDefensiveIdleAction"

BTDefensiveIdleAction.enter = function (self, arg_2_1, arg_2_2, arg_2_3)
	-- function 2
	local network = Managers.state.network
	local action_data = self._tree_node.action_data

	arg_2_2.action = action_data
	arg_2_2.active_node = BTDefensiveIdleAction

	local animation = action_data.animation

	network:anim_event(arg_2_1, animation)

	arg_2_2.move_state = "idle"

	if not action_data.sound_event then
		Managers.state.entity:system("audio_system"):play_audio_unit_event(action_data.sound_event, arg_2_1)
	end

	arg_2_2.navigation_extension:set_enabled(false)
	arg_2_2.locomotion_extension:set_wanted_velocity(Vector3.zero())

	arg_2_2.idle_end_time = arg_2_3 + action_data.duration
end

BTDefensiveIdleAction.leave = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5)
	-- function 3
	arg_3_2.navigation_extension:set_enabled(true)
end

BTDefensiveIdleAction.run = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4)
	-- function 4
	if arg_4_3 > arg_4_2.idle_end_time then
		return "done"
	end

	return "running"
end
