-- chunkname: @scripts/entity_system/systems/behaviour/nodes/bt_zombie_explode_action.lua

require("scripts/entity_system/systems/behaviour/nodes/bt_node")

BTZombieExplodeAction = class(BTZombieExplodeAction, BTNode)

BTZombieExplodeAction.init = function (arg_1_0, ...)
	-- function 1
	BTZombieExplodeAction.super.init(arg_1_0, ...)
end

BTZombieExplodeAction.name = "BTZombieExplodeAction"

BTZombieExplodeAction.enter = function (self, arg_2_1, arg_2_2, arg_2_3)
	-- function 2
	local action_data = self._tree_node.action_data

	arg_2_2.action = action_data

	if not action_data.explode_animation then
		local explode_animation = action_data.explode_animation

		Managers.state.network:anim_event(arg_2_1, explode_animation)

		arg_2_2.explosion_timer = arg_2_3 + action_data.explosion_at_time
		arg_2_2.bot_threat_timer = arg_2_3 + action_data.explosion_at_time * 0.75
	else
		arg_2_2.explosion_timer = arg_2_3
	end

	arg_2_2.navigation_extension:set_enabled(false)
end

BTZombieExplodeAction.leave = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5)
	-- function 3
	arg_3_2.navigation_extension:set_enabled(true)
end

BTZombieExplodeAction.run = function (self, arg_4_1, arg_4_2, arg_4_3, arg_4_4)
	-- function 4
	if not (not arg_4_2.bot_threat_timer and not (arg_4_3 > arg_4_2.bot_threat_timer)) then
		local action = arg_4_2.action
		local var_4_1 = POSITION_LOOKUP[arg_4_1]
		local var_4_2 = Vector3(0, action.radius, 1)
		local bot_threat_duration = action.bot_threat_duration

		bot_threat_duration = bot_threat_duration or 1.5

		Managers.state.entity:system("ai_bot_group_system"):aoe_threat_created(var_4_1, "cylinder", var_4_2, nil, bot_threat_duration, "Chaos Zombie")

		arg_4_2.bot_threat_timer = nil
	end

	if arg_4_3 > arg_4_2.explosion_timer then
		self:explode(arg_4_1, arg_4_2, arg_4_3)

		return "done"
	end

	return "running"
end

BTZombieExplodeAction.explode = function (arg_5_0, arg_5_1, arg_5_2, arg_5_3)
	-- function 5
	local str = "kinetic"
	local var_5_1 = Vector3(0, 0, -1)

	arg_5_2.explosion_finished = true

	AiUtils.kill_unit(arg_5_1, nil, nil, str, var_5_1)
end
