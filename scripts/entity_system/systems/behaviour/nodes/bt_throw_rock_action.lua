-- chunkname: @scripts/entity_system/systems/behaviour/nodes/bt_throw_rock_action.lua

require("scripts/entity_system/systems/behaviour/nodes/bt_node")

BTThrowRockAction = class(BTThrowRockAction, BTNode)

function BTThrowRockAction.init(arg_1_0, ...)
	BTThrowRockAction.super.init(arg_1_0, ...)
end

BTThrowRockAction.name = "BTThrowRockAction"

function BTThrowRockAction.enter(arg_2_0, arg_2_1, arg_2_2, arg_2_3)
	local var_2_0 = arg_2_0._tree_node.action_data

	Managers.state.network:anim_event(arg_2_1, var_2_0.attack_anim)

	arg_2_2.attack_cooldown = arg_2_3 + var_2_0.cooldown
end

function BTThrowRockAction.leave(arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5)
	print("BTThrowRockAction LEAVE")

	arg_3_2.running_attack_action = nil
end

function BTThrowRockAction.run(arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4)
	local var_4_0 = LocomotionUtils.rotation_towards_unit(arg_4_1, arg_4_2.target_unit)

	arg_4_2.locomotion_extension:set_wanted_rotation(var_4_0)

	if arg_4_3 > arg_4_2.attack_cooldown then
		arg_4_2.running_attack_action = nil
	end
end
