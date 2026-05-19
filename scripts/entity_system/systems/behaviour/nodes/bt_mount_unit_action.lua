-- chunkname: @scripts/entity_system/systems/behaviour/nodes/bt_mount_unit_action.lua

require("scripts/entity_system/systems/behaviour/nodes/bt_node")

BTMountUnitAction = class(BTMountUnitAction, BTNode)

function BTMountUnitAction.init(arg_1_0, ...)
	BTMountUnitAction.super.init(arg_1_0, ...)
end

BTMountUnitAction.name = "BTMountUnitAction"

function BTMountUnitAction.enter(arg_2_0, arg_2_1, arg_2_2, arg_2_3)
	local var_2_0 = Managers.state.network
	local var_2_1 = arg_2_0._tree_node.action_data

	arg_2_2.action = var_2_1

	local var_2_2 = var_2_1.animation or "idle"
	local var_2_3 = arg_2_2.optional_spawn_data

	arg_2_2.navigation_extension:set_enabled(false)
	arg_2_2.locomotion_extension:set_wanted_velocity(Vector3.zero())
	var_2_0:anim_event(arg_2_1, var_2_2)

	local var_2_4 = arg_2_2.mounted_data

	arg_2_2.waiting_for_pickup = nil

	if var_2_4 then
		local var_2_5 = var_2_4.mount_unit

		if HEALTH_ALIVE[var_2_5] then
			local var_2_6 = POSITION_LOOKUP[var_2_5]
			local var_2_7 = Unit.local_rotation(var_2_5, 0)

			Unit.set_local_position(arg_2_1, 0, var_2_6)
			Unit.set_local_rotation(arg_2_1, 0, var_2_7)
		end
	end
end

function BTMountUnitAction.leave(arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5)
	arg_3_2.navigation_extension:set_enabled(true)

	arg_3_2.mounting_finished = nil
	arg_3_2.should_mount_unit = nil
	arg_3_2.goal_destination = nil

	local var_3_0 = arg_3_2.mounted_data

	if var_3_0 then
		var_3_0.knocked_off_mounted_timer = nil
	end
end

local var_0_0 = Unit.alive

function BTMountUnitAction.run(arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4)
	local var_4_0 = arg_4_2.mounting_finished
	local var_4_1 = arg_4_2.action

	if var_4_0 then
		local var_4_2 = arg_4_2.mounted_data

		if var_4_2 then
			local var_4_3 = var_4_2.mount_unit

			if HEALTH_ALIVE[var_4_3] then
				local var_4_4 = BLACKBOARDS[var_4_3]

				var_4_4.mounting_finished = true
				var_4_4.linked_unit = arg_4_1
				arg_4_2.hp_at_knocked_off = nil

				local var_4_5 = Managers.state.network:game()
				local var_4_6 = Managers.state.unit_storage:go_id(var_4_3)
				local var_4_7 = Managers.state.unit_storage:go_id(arg_4_1)

				if var_4_5 and var_4_6 and var_4_7 then
					GameSession.set_game_object_field(var_4_5, var_4_6, "animation_synced_unit_id", var_4_7)
				end
			end
		end

		return "done"
	else
		return "running"
	end
end
