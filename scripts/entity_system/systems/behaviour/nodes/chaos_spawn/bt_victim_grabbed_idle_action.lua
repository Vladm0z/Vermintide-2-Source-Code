-- chunkname: @scripts/entity_system/systems/behaviour/nodes/chaos_spawn/bt_victim_grabbed_idle_action.lua

require("scripts/entity_system/systems/behaviour/nodes/bt_node")

BTVictimGrabbedIdleAction = class(BTVictimGrabbedIdleAction, BTNode)
BTVictimGrabbedIdleAction.name = "BTVictimGrabbedIdleAction"

function BTVictimGrabbedIdleAction.init(arg_1_0, ...)
	BTVictimGrabbedIdleAction.super.init(arg_1_0, ...)
end

function BTVictimGrabbedIdleAction.enter(arg_2_0, arg_2_1, arg_2_2, arg_2_3)
	local var_2_0 = Managers.state.network
	local var_2_1 = "idle_grabbed"

	arg_2_2.action = arg_2_0._tree_node.action_data

	if arg_2_2.move_state ~= "idle" then
		var_2_0:anim_event(arg_2_1, var_2_1)

		arg_2_2.move_state = "idle"
	end

	arg_2_2.navigation_extension:set_enabled(false)
	arg_2_2.locomotion_extension:set_wanted_velocity(Vector3.zero())
	StatusUtils.set_grabbed_by_chaos_spawn_status_network(arg_2_2.victim_grabbed, "idle")

	arg_2_2.grabbed_state = "idle"
end

function BTVictimGrabbedIdleAction.leave(arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5)
	arg_3_2.navigation_extension:set_enabled(true)
end

local var_0_0 = Unit.alive

function BTVictimGrabbedIdleAction.run(arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4)
	local var_4_0 = arg_4_2.target_unit

	if var_0_0(var_4_0) then
		local var_4_1 = LocomotionUtils.rotation_towards_unit_flat(arg_4_1, var_4_0)

		arg_4_2.locomotion_extension:set_wanted_rotation(var_4_1)
	end

	return "running"
end
