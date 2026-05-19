-- chunkname: @scripts/entity_system/systems/behaviour/nodes/bt_observe_poison_wind_action.lua

require("scripts/entity_system/systems/behaviour/nodes/bt_node")

BTObservePoisonWind = class(BTObservePoisonWind, BTNode)
BTObservePoisonWind.name = "BTObservePoisonWind"

function BTObservePoisonWind.init(arg_1_0, ...)
	BTObservePoisonWind.super.init(arg_1_0, ...)
end

function BTObservePoisonWind.enter(arg_2_0, arg_2_1, arg_2_2, arg_2_3)
	arg_2_2.action = arg_2_0._tree_node.action_data

	arg_2_2.navigation_extension:set_enabled(false)
	arg_2_2.locomotion_extension:set_wanted_velocity(Vector3.zero())

	arg_2_2.explosion_impact = nil
	arg_2_2.observe_poison_wind = {}

	Managers.state.network:anim_event(arg_2_1, "attack_throw_look")
end

function BTObservePoisonWind.leave(arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5)
	arg_3_2.observe_poison_wind = nil
	arg_3_2.action = nil

	arg_3_2.navigation_extension:set_enabled(true)
end

function BTObservePoisonWind.run(arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4)
	local var_4_0 = arg_4_2.throw_globe_data

	if not var_4_0 then
		return "done"
	end

	if arg_4_2.target_dist < 5 then
		return "done"
	end

	if arg_4_3 > (var_4_0.next_throw_at or -math.huge) then
		return "done"
	end

	local var_4_1 = arg_4_2.locomotion_extension
	local var_4_2 = arg_4_2.throw_globe_data.throw_pos:unbox()
	local var_4_3 = LocomotionUtils.look_at_position_flat(arg_4_1, var_4_2)

	var_4_1:set_wanted_rotation(var_4_3)

	if arg_4_2.explosion_impact then
		Managers.state.network:anim_event(arg_4_1, "attack_throw_score")

		arg_4_2.observe_poison_wind.score_anim = true
		arg_4_2.explosion_impact = nil
	end

	if arg_4_2.observe_poison_wind.score_anim and arg_4_2.anim_cb_attack_throw_score_finished then
		arg_4_2.anim_cb_attack_throw_score_finished = nil

		return "done"
	end

	return "running"
end
