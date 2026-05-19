-- chunkname: @scripts/entity_system/systems/behaviour/nodes/bt_skulk_idle_action.lua

require("scripts/entity_system/systems/behaviour/nodes/bt_node")

BTSkulkIdleAction = class(BTSkulkIdleAction, BTNode)
BTSkulkIdleAction.name = "BTSkulkIdleAction"

function BTSkulkIdleAction.init(arg_1_0, ...)
	BTSkulkIdleAction.super.init(arg_1_0, ...)
end

function BTSkulkIdleAction.enter(arg_2_0, arg_2_1, arg_2_2, arg_2_3)
	arg_2_2.action = arg_2_0._tree_node.action_data

	local var_2_0 = arg_2_2.skulk_data

	var_2_0.skulk_idle_timer = arg_2_3 + math.random(5, 10)

	Managers.state.network:anim_event(arg_2_1, "to_crouch")
	Managers.state.network:anim_event(arg_2_1, "idle")
	arg_2_2.navigation_extension:set_enabled(false)
	arg_2_2.locomotion_extension:set_wanted_velocity(Vector3.zero())
	ScriptUnit.extension(arg_2_1, "ai_system"):set_perception("perception_all_seeing_re_evaluate", "pick_ninja_skulking_target")

	if not var_2_0.attack_timer or arg_2_3 > var_2_0.attack_timer then
		var_2_0.attack_timer = arg_2_3 + math.random(25, 30)
	end
end

function BTSkulkIdleAction.leave(arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5)
	Managers.state.network:anim_event(arg_3_1, "to_upright")

	if arg_3_2.approach_target then
		arg_3_2.skulk_data.attack_timer = nil
	end

	arg_3_2.navigation_extension:set_enabled(true)
end

local var_0_0 = {}
local var_0_1 = 400

function BTSkulkIdleAction.run(arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4)
	local var_4_0 = arg_4_2.skulk_data

	if arg_4_3 > var_4_0.attack_timer then
		arg_4_2.approach_target = true

		return "failed"
	end

	if PerceptionUtils.special_opportunity(arg_4_1, arg_4_2) > 0 then
		arg_4_2.approach_target = true

		return "failed"
	end

	if arg_4_3 > var_4_0.skulk_idle_timer then
		return "done"
	end

	local var_4_1 = POSITION_LOOKUP[arg_4_1]
	local var_4_2 = arg_4_2.side.ENEMY_PLAYER_AND_BOT_POSITIONS

	for iter_4_0 = 1, #var_4_2 do
		local var_4_3 = var_4_2[iter_4_0]

		if Vector3.distance_squared(var_4_1, var_4_3) < var_0_1 then
			return "done"
		end
	end

	return "running"
end

function BTSkulkIdleAction.pick_new_hiding_place(arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4)
	return
end
