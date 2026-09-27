-- chunkname: @scripts/entity_system/systems/behaviour/nodes/chaos_spawn/bt_victim_grabbed_idle_action.lua

require("scripts/entity_system/systems/behaviour/nodes/bt_node")

BTVictimGrabbedIdleAction = class(BTVictimGrabbedIdleAction, BTNode)
BTVictimGrabbedIdleAction.name = "BTVictimGrabbedIdleAction"

BTVictimGrabbedIdleAction.init = function (arg_1_0, ...)
	-- function 1
	BTVictimGrabbedIdleAction.super.init(arg_1_0, ...)
end

BTVictimGrabbedIdleAction.enter = function (self, arg_2_1, arg_2_2, arg_2_3)
	-- function 2
	local network = Managers.state.network
	local str = "idle_grabbed"

	arg_2_2.action = self._tree_node.action_data

	if arg_2_2.move_state ~= "idle" then
		network:anim_event(arg_2_1, str)

		arg_2_2.move_state = "idle"
	end

	arg_2_2.navigation_extension:set_enabled(false)
	arg_2_2.locomotion_extension:set_wanted_velocity(Vector3.zero())
	StatusUtils.set_grabbed_by_chaos_spawn_status_network(arg_2_2.victim_grabbed, "idle")

	arg_2_2.grabbed_state = "idle"
end

BTVictimGrabbedIdleAction.leave = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5)
	-- function 3
	arg_3_2.navigation_extension:set_enabled(true)
end

local alive = Unit.alive

BTVictimGrabbedIdleAction.run = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4)
	-- function 4
	local target_unit = arg_4_2.target_unit

	if not alive(target_unit) then
		local rotation_towards_unit_flat = LocomotionUtils.rotation_towards_unit_flat(arg_4_1, target_unit)

		arg_4_2.locomotion_extension:set_wanted_rotation(rotation_towards_unit_flat)
	end

	return "running"
end
