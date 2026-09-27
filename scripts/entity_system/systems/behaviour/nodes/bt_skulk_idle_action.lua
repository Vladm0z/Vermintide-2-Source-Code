-- chunkname: @scripts/entity_system/systems/behaviour/nodes/bt_skulk_idle_action.lua

require("scripts/entity_system/systems/behaviour/nodes/bt_node")

BTSkulkIdleAction = class(BTSkulkIdleAction, BTNode)
BTSkulkIdleAction.name = "BTSkulkIdleAction"

BTSkulkIdleAction.init = function (arg_1_0, ...)
	-- function 1
	BTSkulkIdleAction.super.init(arg_1_0, ...)
end

BTSkulkIdleAction.enter = function (self, arg_2_1, arg_2_2, arg_2_3)
	-- function 2
	arg_2_2.action = self._tree_node.action_data

	local skulk_data = arg_2_2.skulk_data

	skulk_data.skulk_idle_timer = arg_2_3 + math.random(5, 10)

	Managers.state.network:anim_event(arg_2_1, "to_crouch")
	Managers.state.network:anim_event(arg_2_1, "idle")
	arg_2_2.navigation_extension:set_enabled(false)
	arg_2_2.locomotion_extension:set_wanted_velocity(Vector3.zero())
	ScriptUnit.extension(arg_2_1, "ai_system"):set_perception("perception_all_seeing_re_evaluate", "pick_ninja_skulking_target")

	if not (not skulk_data.attack_timer and not (arg_2_3 > skulk_data.attack_timer)) then
		skulk_data.attack_timer = arg_2_3 + math.random(25, 30)
	end
end

BTSkulkIdleAction.leave = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5)
	-- function 3
	Managers.state.network:anim_event(arg_3_1, "to_upright")

	if not arg_3_2.approach_target then
		arg_3_2.skulk_data.attack_timer = nil
	end

	arg_3_2.navigation_extension:set_enabled(true)
end

local tbl = {}
local num = 400

BTSkulkIdleAction.run = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4)
	-- function 4
	local skulk_data = arg_4_2.skulk_data

	if arg_4_3 > skulk_data.attack_timer then
		arg_4_2.approach_target = true

		return "failed"
	end

	if PerceptionUtils.special_opportunity(arg_4_1, arg_4_2) > 0 then
		arg_4_2.approach_target = true

		return "failed"
	end

	if arg_4_3 > skulk_data.skulk_idle_timer then
		return "done"
	end

	local var_4_1 = POSITION_LOOKUP[arg_4_1]
	local ENEMY_PLAYER_AND_BOT_POSITIONS = arg_4_2.side.ENEMY_PLAYER_AND_BOT_POSITIONS

	for i = 1, #ENEMY_PLAYER_AND_BOT_POSITIONS do
		local var_4_3 = ENEMY_PLAYER_AND_BOT_POSITIONS[i]

		if Vector3.distance_squared(var_4_1, var_4_3) < num then
			return "done"
		end
	end

	return "running"
end

BTSkulkIdleAction.pick_new_hiding_place = function (arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4)
	-- function 5
	return
end
