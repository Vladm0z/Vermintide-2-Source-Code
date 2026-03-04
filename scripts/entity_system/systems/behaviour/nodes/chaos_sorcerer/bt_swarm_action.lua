-- chunkname: @scripts/entity_system/systems/behaviour/nodes/chaos_sorcerer/bt_swarm_action.lua

require("scripts/entity_system/systems/behaviour/nodes/bt_node")

BTSwarmAction = class(BTSwarmAction, BTNode)
BTSwarmAction.name = "BTSwarmAction"

BTSwarmAction.init = function (arg_1_0, ...)
	BTSwarmAction.super.init(arg_1_0, ...)
end

BTSwarmAction.enter = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3)
	arg_2_2.action = arg_2_0._tree_node.action_data
	arg_2_2.active_node = BTSwarmAction
	arg_2_2.abort_action = not arg_2_0:_calculate_swarm_targets(arg_2_1, arg_2_2)

	arg_2_2.navigation_extension:stop()

	arg_2_2.swarm_start = true
	arg_2_2.summoning = true
	arg_2_2.attack_finished = false
end

BTSwarmAction._calculate_swarm_targets = function (arg_3_0, arg_3_1, arg_3_2)
	arg_3_2.valid_swarm_targets = {}

	local var_3_0 = arg_3_2.side.ENEMY_PLAYER_AND_BOT_UNITS
	local var_3_1 = {}
	local var_3_2 = {}

	for iter_3_0, iter_3_1 in pairs(var_3_0) do
		local var_3_3 = ScriptUnit.extension(iter_3_1, "status_system")

		if var_3_3 and not var_3_3:is_invisible() and not var_3_3:is_disabled() then
			if not Managers.player:owner(iter_3_1).bot_player then
				var_3_1[#var_3_1 + 1] = iter_3_1
			else
				var_3_2[#var_3_2 + 1] = iter_3_1
			end
		end
	end

	if #var_3_1 > 1 then
		arg_3_2.valid_swarm_targets = var_3_1
	else
		arg_3_2.valid_swarm_targets = var_3_2
	end

	if #arg_3_2.valid_swarm_targets < 2 then
		return false
	end

	return true
end

BTSwarmAction.leave = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4, arg_4_5)
	arg_4_2.active_node = nil
	arg_4_2.summoning = nil
	arg_4_2.ready_to_summon = false
	arg_4_2.abort_action = nil
	arg_4_2.attack_finished = nil
end

BTSwarmAction.anim_cb_damage = function (arg_5_0, arg_5_1, arg_5_2)
	local var_5_0 = arg_5_2.action
	local var_5_1 = AiUtils.spawn_overpowering_blob(Managers.state.network, arg_5_2.target_unit, var_5_0.health, var_5_0.duration)
	local var_5_2 = "slow_bomb"

	StatusUtils.set_overpowered_network(arg_5_2.target_unit, true, var_5_2, var_5_1)
end

BTSwarmAction.anim_cb_attack_finished = function (arg_6_0, arg_6_1, arg_6_2)
	arg_6_2.attack_finished = true
end

BTSwarmAction.run = function (arg_7_0, arg_7_1, arg_7_2, arg_7_3, arg_7_4)
	if arg_7_2.abort_action or arg_7_2.attack_finished then
		return "done"
	end

	local var_7_0 = arg_7_2.action

	if arg_7_2.swarm_start then
		Managers.state.network:anim_event(arg_7_1, var_7_0.cast_anim)

		arg_7_2.swarm_start = nil
	end

	local var_7_1 = ScriptUnit.extension(arg_7_2.target_unit, "status_system")

	if not (var_7_1 and not var_7_1:is_invisible() and not var_7_1:is_disabled()) then
		if not arg_7_0:_calculate_swarm_targets(arg_7_1, arg_7_2) then
			return "done"
		end

		local var_7_2

		while not var_7_2 or var_7_2 == arg_7_2.target_unit do
			var_7_2 = arg_7_2.valid_swarm_targets[math.random(#arg_7_2.valid_swarm_targets)]
		end

		arg_7_2.target_unit = var_7_2
	end

	return "running"
end
