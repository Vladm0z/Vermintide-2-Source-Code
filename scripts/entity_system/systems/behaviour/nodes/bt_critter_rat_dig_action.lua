-- chunkname: @scripts/entity_system/systems/behaviour/nodes/bt_critter_rat_dig_action.lua

require("scripts/entity_system/systems/behaviour/nodes/bt_node")

BTCritterRatDigAction = class(BTCritterRatDigAction, BTNode)

BTCritterRatDigAction.init = function (arg_1_0, ...)
	BTCritterRatDigAction.super.init(arg_1_0, ...)
end

BTCritterRatDigAction.name = "BTCritterRatDigAction"

BTCritterRatDigAction.enter = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3)
	arg_2_2.navigation_extension:set_enabled(false)
	arg_2_2.locomotion_extension:set_wanted_velocity(Vector3.zero())
	Managers.state.network:anim_event(arg_2_1, "dig_ground")
end

BTCritterRatDigAction.leave = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5)
	if arg_3_4 ~= "aborted" then
		Managers.state.conflict:destroy_unit(arg_3_1, arg_3_2, "dig_ground")
	else
		arg_3_2.navigation_extension:set_enabled(true)
	end
end

BTCritterRatDigAction.run = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3)
	if arg_4_2.anim_cb_dig_finished then
		return "done"
	else
		return "running"
	end
end
