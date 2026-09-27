-- chunkname: @scripts/entity_system/systems/behaviour/nodes/bt_mount_unit_action.lua

require("scripts/entity_system/systems/behaviour/nodes/bt_node")

BTMountUnitAction = class(BTMountUnitAction, BTNode)

BTMountUnitAction.init = function (arg_1_0, ...)
	-- function 1
	BTMountUnitAction.super.init(arg_1_0, ...)
end

BTMountUnitAction.name = "BTMountUnitAction"

BTMountUnitAction.enter = function (self, arg_2_1, arg_2_2, arg_2_3)
	-- function 2
	local network = Managers.state.network
	local action_data = self._tree_node.action_data

	arg_2_2.action = action_data

	local animation = action_data.animation

	animation = animation or "idle"

	local optional_spawn_data = arg_2_2.optional_spawn_data

	arg_2_2.navigation_extension:set_enabled(false)
	arg_2_2.locomotion_extension:set_wanted_velocity(Vector3.zero())
	network:anim_event(arg_2_1, animation)

	local mounted_data = arg_2_2.mounted_data

	arg_2_2.waiting_for_pickup = nil

	if not mounted_data then
		local mount_unit = mounted_data.mount_unit

		if not HEALTH_ALIVE[mount_unit] then
			local var_2_6 = POSITION_LOOKUP[mount_unit]
			local local_rotation = Unit.local_rotation(mount_unit, 0)

			Unit.set_local_position(arg_2_1, 0, var_2_6)
			Unit.set_local_rotation(arg_2_1, 0, local_rotation)
		end
	end
end

BTMountUnitAction.leave = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5)
	-- function 3
	arg_3_2.navigation_extension:set_enabled(true)

	arg_3_2.mounting_finished = nil
	arg_3_2.should_mount_unit = nil
	arg_3_2.goal_destination = nil

	local mounted_data = arg_3_2.mounted_data

	if not mounted_data then
		mounted_data.knocked_off_mounted_timer = nil
	end
end

local alive = Unit.alive

BTMountUnitAction.run = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4)
	-- function 4
	local mounting_finished = arg_4_2.mounting_finished
	local action = arg_4_2.action

	if not mounting_finished then
		local mounted_data = arg_4_2.mounted_data

		if not mounted_data then
			local mount_unit = mounted_data.mount_unit

			if not HEALTH_ALIVE[mount_unit] then
				local var_4_4 = BLACKBOARDS[mount_unit]

				var_4_4.mounting_finished = true
				var_4_4.linked_unit = arg_4_1
				arg_4_2.hp_at_knocked_off = nil

				local game = Managers.state.network:game()
				local go_id = Managers.state.unit_storage:go_id(mount_unit)
				local go_id_2 = Managers.state.unit_storage:go_id(arg_4_1)

				if not game and not go_id and not go_id_2 then
					GameSession.set_game_object_field(game, go_id, "animation_synced_unit_id", go_id_2)
				end
			end
		end

		return "done"
	else
		return "running"
	end
end
