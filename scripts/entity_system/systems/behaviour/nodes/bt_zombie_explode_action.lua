-- chunkname: @scripts/entity_system/systems/behaviour/nodes/bt_zombie_explode_action.lua

require("scripts/entity_system/systems/behaviour/nodes/bt_node")

BTZombieExplodeAction = class(BTZombieExplodeAction, BTNode)

function BTZombieExplodeAction.init(arg_1_0, ...)
	BTZombieExplodeAction.super.init(arg_1_0, ...)
end

BTZombieExplodeAction.name = "BTZombieExplodeAction"

function BTZombieExplodeAction.enter(arg_2_0, arg_2_1, arg_2_2, arg_2_3)
	local var_2_0 = arg_2_0._tree_node.action_data

	arg_2_2.action = var_2_0

	if var_2_0.explode_animation then
		local var_2_1 = var_2_0.explode_animation

		Managers.state.network:anim_event(arg_2_1, var_2_1)

		arg_2_2.explosion_timer = arg_2_3 + var_2_0.explosion_at_time
		arg_2_2.bot_threat_timer = arg_2_3 + var_2_0.explosion_at_time * 0.75
	else
		arg_2_2.explosion_timer = arg_2_3
	end

	arg_2_2.navigation_extension:set_enabled(false)
end

function BTZombieExplodeAction.leave(arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5)
	arg_3_2.navigation_extension:set_enabled(true)
end

function BTZombieExplodeAction.run(arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4)
	if arg_4_2.bot_threat_timer and arg_4_3 > arg_4_2.bot_threat_timer then
		local var_4_0 = arg_4_2.action
		local var_4_1 = POSITION_LOOKUP[arg_4_1]
		local var_4_2 = Vector3(0, var_4_0.radius, 1)
		local var_4_3 = var_4_0.bot_threat_duration or 1.5

		Managers.state.entity:system("ai_bot_group_system"):aoe_threat_created(var_4_1, "cylinder", var_4_2, nil, var_4_3, "Chaos Zombie")

		arg_4_2.bot_threat_timer = nil
	end

	if arg_4_3 > arg_4_2.explosion_timer then
		arg_4_0:explode(arg_4_1, arg_4_2, arg_4_3)

		return "done"
	end

	return "running"
end

function BTZombieExplodeAction.explode(arg_5_0, arg_5_1, arg_5_2, arg_5_3)
	local var_5_0 = "kinetic"
	local var_5_1 = Vector3(0, 0, -1)

	arg_5_2.explosion_finished = true

	AiUtils.kill_unit(arg_5_1, nil, nil, var_5_0, var_5_1)
end
