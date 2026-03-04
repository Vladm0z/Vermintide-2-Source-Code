-- chunkname: @scripts/unit_extensions/level/big_boy_destructible_extension.lua

BigBoyDestructibleExtension = class(BigBoyDestructibleExtension)

local var_0_0 = 30
local var_0_1 = 3
local var_0_2 = Unit.alive

BigBoyDestructibleExtension.init = function (arg_1_0, arg_1_1, arg_1_2, arg_1_3)
	arg_1_0.unit = arg_1_2
	arg_1_0.world = arg_1_1.world
	arg_1_0.is_server = Managers.player.is_server

	local var_1_0 = Unit.get_data(arg_1_2, "move_to_exit_when_opened")

	arg_1_0.move_to_exit_when_opened = var_1_0 == nil or var_1_0

	local var_1_1 = Unit.get_data(arg_1_2, "door_state")

	arg_1_0.current_state = var_1_1 == 0 and "open_forward" or var_1_1 == 1 and "closed" or var_1_1 == 2 and "open_backward"
	arg_1_0.state_to_nav_obstacle_map = {}
	arg_1_0.animation_stop_time = 0
	arg_1_0.dead = false
	arg_1_0.breeds_failed_leaving_smart_object = {}
	arg_1_0.frames_since_obstacle_update = nil
	arg_1_0.num_attackers = 0
end

BigBoyDestructibleExtension.extensions_ready = function (arg_2_0)
	arg_2_0.health_extension = ScriptUnit.extension(arg_2_0.unit, "health_system")
end

BigBoyDestructibleExtension.animation_played = function (arg_3_0, arg_3_1, arg_3_2)
	local var_3_0 = arg_3_1 / var_0_0 / arg_3_2

	arg_3_0.animation_stop_time = Managers.time:time("game") + var_3_0
end

BigBoyDestructibleExtension.update_nav_obstacles = function (arg_4_0)
	local var_4_0 = arg_4_0.current_state
	local var_4_1 = arg_4_0.state_to_nav_obstacle_map

	if not var_4_1[var_4_0] then
		local var_4_2 = arg_4_0.unit
		local var_4_3 = GLOBAL_AI_NAVWORLD
		local var_4_4, var_4_5 = NavigationUtils.create_exclusive_box_obstacle_from_unit_data(var_4_3, var_4_2)

		GwNavBoxObstacle.add_to_world(var_4_4)
		GwNavBoxObstacle.set_transform(var_4_4, var_4_5)

		var_4_1[var_4_0] = var_4_4
	end

	for iter_4_0, iter_4_1 in pairs(var_4_1) do
		local var_4_6 = iter_4_0 == var_4_0

		GwNavBoxObstacle.set_does_trigger_tagvolume(iter_4_1, var_4_6)
	end

	arg_4_0.frames_since_obstacle_update = 0
end

BigBoyDestructibleExtension._get_animation_flow_event = function (arg_5_0, arg_5_1, arg_5_2)
	local var_5_0 = arg_5_0.animation_flow_events[arg_5_1][arg_5_2]

	fassert(var_5_0, "Door animation event from %s to %s unavailable", arg_5_1, arg_5_2)

	return var_5_0
end

BigBoyDestructibleExtension.update_nav_graphs = function (arg_6_0)
	local var_6_0 = arg_6_0.unit
	local var_6_1 = Managers.state.entity:system("nav_graph_system")

	if arg_6_0:is_open() or arg_6_0.dead then
		var_6_1:remove_nav_graph(var_6_0)
	else
		var_6_1:add_nav_graph(var_6_0)
	end
end

BigBoyDestructibleExtension.update = function (arg_7_0, arg_7_1, arg_7_2, arg_7_3, arg_7_4, arg_7_5)
	local var_7_0 = arg_7_0.frames_since_obstacle_update

	if var_7_0 then
		local var_7_1 = var_7_0 + 1

		if var_7_1 == var_0_1 then
			arg_7_0:update_nav_graphs()
			arg_7_0:handle_breeds_failed_leaving_smart_object()

			arg_7_0.frames_since_obstacle_update = nil
		else
			arg_7_0.frames_since_obstacle_update = var_7_1
		end
	end

	if arg_7_0.dead then
		return
	end

	local var_7_2 = arg_7_0.animation_stop_time

	if var_7_2 and var_7_2 <= arg_7_5 then
		arg_7_0:update_nav_obstacles()

		arg_7_0.animation_stop_time = nil
	end

	if not arg_7_0.health_extension:is_alive() then
		arg_7_0.dead = true

		arg_7_0:destroy_box_obstacles()
	end
end

BigBoyDestructibleExtension.register_breed_failed_leaving_smart_object = function (arg_8_0, arg_8_1)
	if arg_8_0.breeds_failed_leaving_smart_object == nil then
		return
	end

	arg_8_0.breeds_failed_leaving_smart_object[arg_8_1] = true
end

BigBoyDestructibleExtension.handle_breeds_failed_leaving_smart_object = function (arg_9_0)
	if arg_9_0.breeds_failed_leaving_smart_object == nil then
		return
	end

	for iter_9_0, iter_9_1 in pairs(arg_9_0.breeds_failed_leaving_smart_object) do
		if var_0_2(iter_9_0) then
			local var_9_0 = ScriptUnit.has_extension(iter_9_0, "ai_navigation_system")

			if var_9_0 then
				var_9_0:reset_destination()
			end
		end
	end

	arg_9_0.breeds_failed_leaving_smart_object = {}
end

BigBoyDestructibleExtension.destroy = function (arg_10_0)
	arg_10_0:destroy_box_obstacles()

	arg_10_0.unit = nil
	arg_10_0.world = nil
	arg_10_0.health_extension = nil
	arg_10_0.breeds_failed_leaving_smart_object = nil
end

BigBoyDestructibleExtension.destroy_box_obstacles = function (arg_11_0)
	if arg_11_0.state_to_nav_obstacle_map then
		for iter_11_0, iter_11_1 in pairs(arg_11_0.state_to_nav_obstacle_map) do
			GwNavBoxObstacle.destroy(iter_11_1)
		end

		arg_11_0.state_to_nav_obstacle_map = nil
	end

	arg_11_0.frames_since_obstacle_update = 0
end

BigBoyDestructibleExtension.is_open = function (arg_12_0)
	return arg_12_0.dead
end

BigBoyDestructibleExtension.is_opening = function (arg_13_0)
	return false
end
