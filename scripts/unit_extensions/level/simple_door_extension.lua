-- chunkname: @scripts/unit_extensions/level/simple_door_extension.lua

SimpleDoorExtension = class(SimpleDoorExtension)

local var_0_0 = 30
local var_0_1 = Unit.alive

SimpleDoorExtension.init = function (arg_1_0, arg_1_1, arg_1_2, arg_1_3)
	local var_1_0 = arg_1_1.world

	arg_1_0.unit = arg_1_2
	arg_1_0.world = var_1_0
	arg_1_0.is_server = Managers.player.is_server
	arg_1_0.ignore_umbra = not World.umbra_available(var_1_0)
	arg_1_0.is_umbra_gate = Unit.get_data(arg_1_2, "umbra_gate")

	local var_1_1 = Unit.get_data(arg_1_2, "door_state")

	arg_1_0.current_state = var_1_1 == 0 and "open_forward" or var_1_1 == 1 and "closed"
	arg_1_0.animation_stop_time = 0
end

SimpleDoorExtension.destroy = function (arg_2_0)
	arg_2_0:destroy_box_obstacle()

	arg_2_0.unit = nil
	arg_2_0.world = nil
end

SimpleDoorExtension.destroy_box_obstacle = function (arg_3_0)
	local var_3_0 = arg_3_0.obstacle

	if var_3_0 then
		GwNavBoxObstacle.destroy(var_3_0)
	end
end

SimpleDoorExtension.extensions_ready = function (arg_4_0)
	return
end

SimpleDoorExtension.interacted_with = function (arg_5_0, arg_5_1)
	return
end

SimpleDoorExtension.is_opening = function (arg_6_0)
	return arg_6_0.current_state ~= "closed" and arg_6_0.animation_stop_time
end

SimpleDoorExtension.is_open = function (arg_7_0)
	return arg_7_0.current_state ~= "closed"
end

SimpleDoorExtension.get_current_state = function (arg_8_0)
	return arg_8_0.current_state
end

SimpleDoorExtension.set_door_state_and_duration = function (arg_9_0, arg_9_1, arg_9_2, arg_9_3)
	if arg_9_0.current_state == arg_9_1 then
		return
	end

	local var_9_0 = arg_9_0.unit
	local var_9_1 = arg_9_1 == "closed"

	if not var_9_1 and not arg_9_0.ignore_umbra and arg_9_0.is_umbra_gate then
		World.umbra_set_gate_closed(arg_9_0.world, var_9_0, var_9_1)
	end

	arg_9_0.current_state = arg_9_1

	local var_9_2 = arg_9_2 / var_0_0 / arg_9_3

	arg_9_0.animation_stop_time = Managers.time:time("game") + var_9_2
end

SimpleDoorExtension.hot_join_sync = function (arg_10_0, arg_10_1)
	return
end

SimpleDoorExtension.update_nav_obstacle = function (arg_11_0)
	local var_11_0 = arg_11_0.current_state
	local var_11_1 = arg_11_0.obstacle

	if var_11_1 == nil then
		local var_11_2
		local var_11_3 = arg_11_0.unit
		local var_11_4 = GLOBAL_AI_NAVWORLD
		local var_11_5

		var_11_1, var_11_5 = NavigationUtils.create_exclusive_box_obstacle_from_unit_data(var_11_4, var_11_3)

		GwNavBoxObstacle.add_to_world(var_11_1)
		GwNavBoxObstacle.set_transform(var_11_1, var_11_5)

		arg_11_0.obstacle = var_11_1
	end

	local var_11_6 = var_11_0 == "closed"

	GwNavBoxObstacle.set_does_trigger_tagvolume(var_11_1, var_11_6)
end

SimpleDoorExtension.update = function (arg_12_0, arg_12_1, arg_12_2, arg_12_3, arg_12_4, arg_12_5)
	local var_12_0 = arg_12_0.animation_stop_time

	if var_12_0 and var_12_0 <= arg_12_5 then
		arg_12_0:update_nav_obstacle()

		arg_12_0.animation_stop_time = nil

		local var_12_1 = arg_12_0.current_state == "closed"

		if var_12_1 and not arg_12_0.ignore_umbra and arg_12_0.is_umbra_gate then
			World.umbra_set_gate_closed(arg_12_0.world, arg_12_1, var_12_1)
		end
	end
end
