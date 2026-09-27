-- chunkname: @scripts/entity_system/systems/behaviour/nodes/chaos_sorcerer/bt_swarm_action.lua

require("scripts/entity_system/systems/behaviour/nodes/bt_node")

BTSwarmAction = class(BTSwarmAction, BTNode)
BTSwarmAction.name = "BTSwarmAction"

BTSwarmAction.init = function (arg_1_0, ...)
	-- function 1
	BTSwarmAction.super.init(arg_1_0, ...)
end

BTSwarmAction.enter = function (self, arg_2_1, arg_2_2, arg_2_3)
	-- function 2
	arg_2_2.action = self._tree_node.action_data
	arg_2_2.active_node = BTSwarmAction
	arg_2_2.abort_action = not self:_calculate_swarm_targets(arg_2_1, arg_2_2)

	arg_2_2.navigation_extension:stop()

	arg_2_2.swarm_start = true
	arg_2_2.summoning = true
	arg_2_2.attack_finished = false
end

BTSwarmAction._calculate_swarm_targets = function (arg_3_0, arg_3_1, arg_3_2)
	-- function 3
	arg_3_2.valid_swarm_targets = {}

	local ENEMY_PLAYER_AND_BOT_UNITS = arg_3_2.side.ENEMY_PLAYER_AND_BOT_UNITS
	local tbl = {}
	local tbl_2 = {}

	for k, v in pairs(ENEMY_PLAYER_AND_BOT_UNITS) do
		local extension = ScriptUnit.extension(v, "status_system")

		if not (not extension and not not extension:is_invisible() or not extension:is_disabled()) then
			if not Managers.player:owner(v).bot_player then
				tbl[#tbl + 1] = v
			else
				tbl_2[#tbl_2 + 1] = v
			end
		end
	end

	if #tbl > 1 then
		arg_3_2.valid_swarm_targets = tbl
	else
		arg_3_2.valid_swarm_targets = tbl_2
	end

	if #arg_3_2.valid_swarm_targets < 2 then
		return false
	end

	return true
end

BTSwarmAction.leave = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4, arg_4_5)
	-- function 4
	arg_4_2.active_node = nil
	arg_4_2.summoning = nil
	arg_4_2.ready_to_summon = false
	arg_4_2.abort_action = nil
	arg_4_2.attack_finished = nil
end

BTSwarmAction.anim_cb_damage = function (arg_5_0, arg_5_1, arg_5_2)
	-- function 5
	local action = arg_5_2.action
	local spawn_overpowering_blob = AiUtils.spawn_overpowering_blob(Managers.state.network, arg_5_2.target_unit, action.health, action.duration)
	local str = "slow_bomb"

	StatusUtils.set_overpowered_network(arg_5_2.target_unit, true, str, spawn_overpowering_blob)
end

BTSwarmAction.anim_cb_attack_finished = function (arg_6_0, arg_6_1, arg_6_2)
	-- function 6
	arg_6_2.attack_finished = true
end

BTSwarmAction.run = function (self, arg_7_1, arg_7_2, arg_7_3, arg_7_4)
	-- function 7
	if arg_7_2.abort_action or not arg_7_2.attack_finished then
		return "done"
	end

	local action = arg_7_2.action

	if not arg_7_2.swarm_start then
		Managers.state.network:anim_event(arg_7_1, action.cast_anim)

		arg_7_2.swarm_start = nil
	end

	local extension = ScriptUnit.extension(arg_7_2.target_unit, "status_system")

	if not (not extension and not not extension:is_invisible() or not extension:is_disabled()) then
		if not self:_calculate_swarm_targets(arg_7_1, arg_7_2) then
			return "done"
		end

		local var_7_2

		while not (not var_7_2 and var_7_2 ~= arg_7_2.target_unit) do
			var_7_2 = arg_7_2.valid_swarm_targets[math.random(#arg_7_2.valid_swarm_targets)]
		end

		arg_7_2.target_unit = var_7_2
	end

	return "running"
end
