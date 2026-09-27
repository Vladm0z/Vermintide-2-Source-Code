-- chunkname: @scripts/unit_extensions/generic/bot_nav_transition_extension.lua

BotNavTransitionExtension = class(BotNavTransitionExtension)

BotNavTransitionExtension.init = function (self, arg_1_1, arg_1_2)
	-- function 1
	self._unit = arg_1_2
	self._is_server = Managers.state.network.is_server

	if not self._is_server then
		self._transition_unit = BotNavTransitionExtension.try_create_transition(arg_1_2, 0, Managers.state.bot_nav_transition, QuickDrawerStay)
	end
end

BotNavTransitionExtension.try_create_transition = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4)
	-- function 2
	local flag = arg_2_1 or 0
	local world_position = Unit.world_position(arg_2_0, flag)
	local world_position_2 = Unit.world_position(arg_2_0, Unit.node(arg_2_0, "waypoint"))
	local world_position_3 = Unit.world_position(arg_2_0, Unit.node(arg_2_0, "destination"))
	local get_data = Unit.get_data(arg_2_0, "jump")
	local var_2_5

	if not (not get_data and not (Vector3.distance_squared(world_position, world_position_2) > 0.25)) then
		return nil, var_2_5
	else
		local create_transition, var_2_7 = arg_2_2:create_transition(world_position, world_position_2, world_position_3, get_data, true, arg_2_3)

		if not (not arg_2_4 and create_transition) then
			var_2_5 = string.format("Hand placed bot nav transition from %s to %s does not result in valid transition", tostring(world_position), tostring(world_position_3))

			Application.error(var_2_5)
			arg_2_3:line(world_position, world_position + Vector3.up() * 15, Colors.get("red"))
		else
			fassert(create_transition, "Hand placed bot nav transition from %s to %s does not result in valid transition", world_position, world_position_3)
		end

		return var_2_7, var_2_5
	end
end

BotNavTransitionExtension.destroy = function (self)
	-- function 3
	if not self._is_server and not self._transition_unit then
		Managers.state.bot_nav_transition:unregister_transition(self._transition_unit)
	end
end
