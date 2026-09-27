-- chunkname: @scripts/entity_system/systems/behaviour/nodes/bot/bt_bot_teleport_to_ally_action.lua

require("scripts/entity_system/systems/behaviour/nodes/bt_node")

BTBotTeleportToAllyAction = class(BTBotTeleportToAllyAction, BTNode)

BTBotTeleportToAllyAction.init = function (arg_1_0, ...)
	-- function 1
	BTBotTeleportToAllyAction.super.init(arg_1_0, ...)
end

BTBotTeleportToAllyAction.name = "BTBotTeleportToAllyAction"

BTBotTeleportToAllyAction.leave = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5)
	-- function 2
	return
end

BTBotTeleportToAllyAction.enter = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3)
	-- function 3
	return
end

local num = 5
local num_2 = math.pi / (2 * num)
local num_3 = 5

BTBotTeleportToAllyAction.run = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4)
	-- function 4
	local follow_unit = arg_4_2.ai_bot_group_extension.data.follow_unit
	local nav_world = arg_4_2.nav_world
	local navigation_extension = arg_4_2.navigation_extension
	local traverse_logic = navigation_extension:traverse_logic()
	local var_4_4
	local game = Managers.state.network:game()

	if not game then
		local go_id = Managers.state.unit_storage:go_id(follow_unit)

		var_4_4 = -GameSession.game_object_field(game, go_id, "aim_direction")
	else
		local local_rotation = Unit.local_rotation(follow_unit, 0)

		var_4_4 = -Quaternion.forward(local_rotation)
	end

	local last_position_on_navmesh = ScriptUnit.extension(follow_unit, "whereabouts_system"):last_position_on_navmesh()
	local var_4_9
	local num_4 = -math.huge
	local num_5 = 1

	for i = 0, num do
		local flag

		flag = not (i > 0) or not 2 or 1

		local flag_2 = false

		for j = 1, flag do
			local num_6 = num_5 * num_2 * i
			local axis_angle = Quaternion.axis_angle(Vector3.up(), num_6)
			local num_7 = last_position_on_navmesh + Quaternion.rotate(axis_angle, var_4_4) * num_3
			local raycast, var_4_18 = GwNavQueries.raycast(nav_world, last_position_on_navmesh, num_7, traverse_logic)

			if not raycast then
				var_4_9 = var_4_18
				num_4 = num_3
				flag_2 = true

				break
			end

			local distance_squared = Vector3.distance_squared(last_position_on_navmesh, var_4_18)

			if num_4 < distance_squared then
				var_4_9 = var_4_18
				num_4 = distance_squared
			end

			num_5 = -num_5
		end

		if not flag_2 then
			break
		end
	end

	arg_4_2.locomotion_extension:teleport_to(var_4_9)

	local status_extension = arg_4_2.status_extension

	if not status_extension then
		status_extension:set_falling_height(true, var_4_9.z)
		status_extension:set_ignore_next_fall_damage(true)
	end

	arg_4_2.has_teleported = true

	navigation_extension:teleport(var_4_9)
	arg_4_2.ai_extension:clear_failed_paths()

	arg_4_2.follow.needs_target_position_refresh = true

	return "done"
end
