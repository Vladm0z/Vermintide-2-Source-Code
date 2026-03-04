-- chunkname: @scripts/entity_system/systems/behaviour/nodes/bt_grey_seer_mounted_action.lua

require("scripts/entity_system/systems/behaviour/nodes/bt_node")

BTGreySeerMountedAction = class(BTGreySeerMountedAction, BTNode)

BTGreySeerMountedAction.init = function (arg_1_0, ...)
	BTGreySeerMountedAction.super.init(arg_1_0, ...)
end

BTGreySeerMountedAction.name = "BTGreySeerMountedAction"

BTGreySeerMountedAction.enter = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3)
	arg_2_2.navigation_extension:set_enabled(false)
	arg_2_2.locomotion_extension:set_wanted_velocity(Vector3.zero())

	local var_2_0 = Managers.state.network:game()
	local var_2_1 = Managers.state.unit_storage:go_id(arg_2_1)

	arg_2_2.move_state = "moving"

	local var_2_2 = Managers.state.network
	local var_2_3 = ScriptUnit.extension(arg_2_1, "health_system")
	local var_2_4 = arg_2_2.hit_reaction_extension
	local var_2_5 = var_2_2.network_transmit

	var_2_4:set_hit_effect_template_id("HitEffectsSkavenGreySeerMounted")

	var_2_3.is_invincible = true

	GameSession.set_game_object_field(var_2_0, var_2_1, "show_health_bar", false)
	var_2_5:send_rpc_clients("rpc_set_hit_reaction_template", var_2_1, "HitEffectsSkavenGreySeerMounted")

	arg_2_2.current_hit_reaction_type = "mounted"
end

BTGreySeerMountedAction.leave = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5)
	arg_3_2.navigation_extension:set_enabled(true)

	local var_3_0 = Managers.state.network
	local var_3_1 = var_3_0:game()
	local var_3_2 = Managers.state.unit_storage:go_id(arg_3_1)
	local var_3_3 = ScriptUnit.extension(arg_3_1, "health_system")
	local var_3_4 = arg_3_2.hit_reaction_extension
	local var_3_5 = var_3_0.network_transmit

	var_3_4:set_hit_effect_template_id("HitEffectsSkavenGreySeer")

	var_3_3.is_invincible = false

	GameSession.set_game_object_field(var_3_1, var_3_2, "show_health_bar", true)
	var_3_5:send_rpc_clients("rpc_set_hit_reaction_template", var_3_2, "HitEffectsSkavenGreySeer")

	arg_3_2.current_hit_reaction_type = "on_ground"
end

local var_0_0 = Unit.alive

BTGreySeerMountedAction.run = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4)
	local var_4_0 = arg_4_2.mounted_data

	if Unit.alive(var_4_0.mount_unit) and not var_4_0.knocked_off_mounted_timer and not arg_4_2.knocked_off_mount then
		local var_4_1 = Unit.local_rotation(var_4_0.mount_unit, 0)
		local var_4_2 = Unit.local_position(var_4_0.mount_unit, 0)

		Unit.set_local_position(arg_4_1, 0, var_4_2)
		Unit.set_local_rotation(arg_4_1, 0, var_4_1)
	end

	return "running"
end
