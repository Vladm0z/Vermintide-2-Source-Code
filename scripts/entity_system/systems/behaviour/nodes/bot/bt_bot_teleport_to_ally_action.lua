-- chunkname: @scripts/entity_system/systems/behaviour/nodes/bot/bt_bot_teleport_to_ally_action.lua

require("scripts/entity_system/systems/behaviour/nodes/bt_node")

BTBotTeleportToAllyAction = class(BTBotTeleportToAllyAction, BTNode)

function BTBotTeleportToAllyAction.init(arg_1_0, ...)
	BTBotTeleportToAllyAction.super.init(arg_1_0, ...)
end

BTBotTeleportToAllyAction.name = "BTBotTeleportToAllyAction"

function BTBotTeleportToAllyAction.leave(arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5)
	return
end

function BTBotTeleportToAllyAction.enter(arg_3_0, arg_3_1, arg_3_2, arg_3_3)
	return
end

local var_0_0 = 5
local var_0_1 = math.pi / (2 * var_0_0)
local var_0_2 = 5

function BTBotTeleportToAllyAction.run(arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4)
	local var_4_0 = arg_4_2.ai_bot_group_extension.data.follow_unit
	local var_4_1 = arg_4_2.nav_world
	local var_4_2 = arg_4_2.navigation_extension
	local var_4_3 = var_4_2:traverse_logic()
	local var_4_4
	local var_4_5 = Managers.state.network:game()

	if var_4_5 then
		local var_4_6 = Managers.state.unit_storage:go_id(var_4_0)

		var_4_4 = -GameSession.game_object_field(var_4_5, var_4_6, "aim_direction")
	else
		local var_4_7 = Unit.local_rotation(var_4_0, 0)

		var_4_4 = -Quaternion.forward(var_4_7)
	end

	local var_4_8 = ScriptUnit.extension(var_4_0, "whereabouts_system"):last_position_on_navmesh()
	local var_4_9
	local var_4_10 = -math.huge
	local var_4_11 = 1

	for iter_4_0 = 0, var_0_0 do
		local var_4_12 = iter_4_0 > 0 and 2 or 1
		local var_4_13 = false

		for iter_4_1 = 1, var_4_12 do
			local var_4_14 = var_4_11 * var_0_1 * iter_4_0
			local var_4_15 = Quaternion.axis_angle(Vector3.up(), var_4_14)
			local var_4_16 = var_4_8 + Quaternion.rotate(var_4_15, var_4_4) * var_0_2
			local var_4_17, var_4_18 = GwNavQueries.raycast(var_4_1, var_4_8, var_4_16, var_4_3)

			if var_4_17 then
				var_4_9 = var_4_18
				var_4_10 = var_0_2
				var_4_13 = true

				break
			end

			local var_4_19 = Vector3.distance_squared(var_4_8, var_4_18)

			if var_4_10 < var_4_19 then
				var_4_9 = var_4_18
				var_4_10 = var_4_19
			end

			var_4_11 = -var_4_11
		end

		if var_4_13 then
			break
		end
	end

	arg_4_2.locomotion_extension:teleport_to(var_4_9)

	local var_4_20 = arg_4_2.status_extension

	if var_4_20 then
		var_4_20:set_falling_height(true, var_4_9.z)
		var_4_20:set_ignore_next_fall_damage(true)
	end

	arg_4_2.has_teleported = true

	var_4_2:teleport(var_4_9)
	arg_4_2.ai_extension:clear_failed_paths()

	arg_4_2.follow.needs_target_position_refresh = true

	return "done"
end
