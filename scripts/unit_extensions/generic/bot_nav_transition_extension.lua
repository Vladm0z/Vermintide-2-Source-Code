-- chunkname: @scripts/unit_extensions/generic/bot_nav_transition_extension.lua

BotNavTransitionExtension = class(BotNavTransitionExtension)

BotNavTransitionExtension.init = function (arg_1_0, arg_1_1, arg_1_2)
	arg_1_0._unit = arg_1_2
	arg_1_0._is_server = Managers.state.network.is_server

	if arg_1_0._is_server then
		arg_1_0._transition_unit = BotNavTransitionExtension.try_create_transition(arg_1_2, 0, Managers.state.bot_nav_transition, QuickDrawerStay)
	end
end

BotNavTransitionExtension.try_create_transition = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4)
	local var_2_0 = arg_2_1 or 0
	local var_2_1 = Unit.world_position(arg_2_0, var_2_0)
	local var_2_2 = Unit.world_position(arg_2_0, Unit.node(arg_2_0, "waypoint"))
	local var_2_3 = Unit.world_position(arg_2_0, Unit.node(arg_2_0, "destination"))
	local var_2_4 = Unit.get_data(arg_2_0, "jump")
	local var_2_5

	if var_2_4 and Vector3.distance_squared(var_2_1, var_2_2) > 0.25 then
		return nil, var_2_5
	else
		local var_2_6, var_2_7 = arg_2_2:create_transition(var_2_1, var_2_2, var_2_3, var_2_4, true, arg_2_3)

		if arg_2_4 and not var_2_6 then
			var_2_5 = string.format("Hand placed bot nav transition from %s to %s does not result in valid transition", tostring(var_2_1), tostring(var_2_3))

			Application.error(var_2_5)
			arg_2_3:line(var_2_1, var_2_1 + Vector3.up() * 15, Colors.get("red"))
		else
			fassert(var_2_6, "Hand placed bot nav transition from %s to %s does not result in valid transition", var_2_1, var_2_3)
		end

		return var_2_7, var_2_5
	end
end

BotNavTransitionExtension.destroy = function (arg_3_0)
	if arg_3_0._is_server and arg_3_0._transition_unit then
		Managers.state.bot_nav_transition:unregister_transition(arg_3_0._transition_unit)
	end
end
