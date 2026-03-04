-- chunkname: @scripts/unit_extensions/level/door_extension.lua

DoorExtension = class(DoorExtension)

local var_0_0 = 30
local var_0_1 = 3
local var_0_2 = Unit.alive

DoorExtension.init = function (arg_1_0, arg_1_1, arg_1_2, arg_1_3)
	local var_1_0 = arg_1_1.world

	arg_1_0.unit = arg_1_2
	arg_1_0.world = var_1_0
	arg_1_0.is_server = Managers.player.is_server
	arg_1_0.ignore_umbra = not World.umbra_available(var_1_0)
	arg_1_0.is_umbra_gate = Unit.get_data(arg_1_2, "umbra_gate")

	local var_1_1 = Unit.get_data(arg_1_2, "move_to_exit_when_opened")

	arg_1_0.move_to_exit_when_opened = var_1_1 == nil or var_1_1
	arg_1_0.ai_attack_re_eval_time = Unit.get_data(arg_1_2, "ai_attack_re_eval_time")

	local var_1_2 = Unit.get_data(arg_1_2, "door_state")

	arg_1_0.current_state = var_1_2 == 0 and "open_forward" or var_1_2 == 1 and "closed" or var_1_2 == 2 and "open_backward"
	arg_1_0.animation_flow_events = {
		closed = {
			open_backward = "lua_open_backward",
			open_forward = "lua_open_forward"
		},
		open_forward = {
			closed = "lua_close_forward",
			open_backward = "lua_swing_forward"
		},
		open_backward = {
			closed = "lua_close_backward",
			open_forward = "lua_swing_backward"
		}
	}
	arg_1_0.state_to_nav_obstacle_map = {}
	arg_1_0.animation_stop_time = 0
	arg_1_0.dead = false
	arg_1_0.breeds_failed_leaving_smart_object = {}
	arg_1_0.frames_since_obstacle_update = nil
	arg_1_0.num_attackers = 0
end

DoorExtension.extensions_ready = function (arg_2_0)
	arg_2_0.health_extension = ScriptUnit.extension(arg_2_0.unit, "health_system")
end

DoorExtension.update_nav_graphs = function (arg_3_0)
	local var_3_0 = arg_3_0.unit
	local var_3_1 = Managers.state.entity:system("nav_graph_system")

	if arg_3_0:is_open() or arg_3_0.dead then
		var_3_1:remove_nav_graph(var_3_0)
	else
		var_3_1:add_nav_graph(var_3_0)
	end
end

DoorExtension.animation_played = function (arg_4_0, arg_4_1, arg_4_2)
	local var_4_0 = arg_4_1 / var_0_0 / arg_4_2

	arg_4_0.animation_stop_time = Managers.time:time("game") + var_4_0
end

DoorExtension.update_nav_obstacles = function (arg_5_0)
	local var_5_0 = arg_5_0.unit
	local var_5_1 = arg_5_0.current_state
	local var_5_2 = arg_5_0.state_to_nav_obstacle_map
	local var_5_3 = Unit.get_data(var_5_0, "navtag_volume", "clip_navmesh")

	if Unit.has_data(var_5_0, "navtag_volume", "clip_navmesh") == false then
		var_5_3 = true
	end

	if not var_5_2[var_5_1] and var_5_3 ~= false and not Unit.get_data(var_5_0, "navtag_volume", "no_obstacle") then
		local var_5_4 = arg_5_0.unit
		local var_5_5 = GLOBAL_AI_NAVWORLD
		local var_5_6, var_5_7 = NavigationUtils.create_exclusive_box_obstacle_from_unit_data(var_5_5, var_5_4)

		if var_5_6 then
			GwNavBoxObstacle.add_to_world(var_5_6)
			GwNavBoxObstacle.set_transform(var_5_6, var_5_7)

			var_5_2[var_5_1] = var_5_6
		end
	end

	for iter_5_0, iter_5_1 in pairs(var_5_2) do
		local var_5_8 = iter_5_0 == var_5_1

		GwNavBoxObstacle.set_does_trigger_tagvolume(iter_5_1, var_5_8)
	end

	arg_5_0.frames_since_obstacle_update = 0
end

DoorExtension.interacted_with = function (arg_6_0, arg_6_1)
	local var_6_0 = arg_6_0.unit
	local var_6_1 = arg_6_0.current_state
	local var_6_2

	if var_6_1 == "open_backward" or var_6_1 == "open_forward" then
		var_6_2 = "closed"
	elseif var_6_1 == "closed" then
		local var_6_3 = Unit.world_position(var_6_0, 0)
		local var_6_4 = Unit.world_rotation(var_6_0, 0)
		local var_6_5 = var_6_3 - POSITION_LOOKUP[arg_6_1]
		local var_6_6 = Vector3.normalize(Vector3.flat(var_6_5))
		local var_6_7 = Quaternion.forward(var_6_4)
		local var_6_8 = Vector3.normalize(Vector3.flat(var_6_7))

		var_6_2 = Vector3.dot(var_6_6, var_6_8) >= 0 and "open_backward" or "open_forward"
	end

	arg_6_0:set_door_state(var_6_2)
end

DoorExtension.set_door_state = function (arg_7_0, arg_7_1)
	local var_7_0 = arg_7_0.current_state

	if var_7_0 == arg_7_1 then
		return
	end

	local var_7_1 = arg_7_0.unit
	local var_7_2 = arg_7_0:_get_animation_flow_event(var_7_0, arg_7_1)

	Unit.flow_event(var_7_1, var_7_2)

	local var_7_3 = arg_7_1 == "closed"

	if not var_7_3 and not arg_7_0.ignore_umbra and arg_7_0.is_umbra_gate then
		World.umbra_set_gate_closed(arg_7_0.world, var_7_1, var_7_3)
	end

	arg_7_0.current_state = arg_7_1
end

DoorExtension.get_current_state = function (arg_8_0)
	return arg_8_0.current_state
end

DoorExtension._get_animation_flow_event = function (arg_9_0, arg_9_1, arg_9_2)
	local var_9_0 = arg_9_0.animation_flow_events[arg_9_1][arg_9_2]

	fassert(var_9_0, "Door animation event from %s to %s unavailable", arg_9_1, arg_9_2)

	return var_9_0
end

DoorExtension.update = function (arg_10_0, arg_10_1, arg_10_2, arg_10_3, arg_10_4, arg_10_5)
	local var_10_0 = arg_10_0.frames_since_obstacle_update

	if var_10_0 then
		local var_10_1 = var_10_0 + 1

		if var_10_1 == var_0_1 then
			arg_10_0:update_nav_graphs()
			arg_10_0:handle_breeds_failed_leaving_smart_object()

			arg_10_0.frames_since_obstacle_update = nil
		else
			arg_10_0.frames_since_obstacle_update = var_10_1
		end
	end

	if arg_10_0.dead then
		return
	end

	local var_10_2 = arg_10_0.animation_stop_time

	if var_10_2 and var_10_2 <= arg_10_5 then
		arg_10_0:update_nav_obstacles()

		arg_10_0.animation_stop_time = nil

		local var_10_3 = arg_10_0.current_state == "closed"

		if var_10_3 and not arg_10_0.ignore_umbra and arg_10_0.is_umbra_gate then
			World.umbra_set_gate_closed(arg_10_0.world, arg_10_1, var_10_3)
		end
	end

	if not HEALTH_ALIVE[arg_10_1] then
		arg_10_0.dead = true

		arg_10_0:destroy_box_obstacles()
	end
end

DoorExtension.register_breed_failed_leaving_smart_object = function (arg_11_0, arg_11_1)
	if arg_11_0.breeds_failed_leaving_smart_object == nil then
		return
	end

	arg_11_0.breeds_failed_leaving_smart_object[arg_11_1] = true
end

DoorExtension.handle_breeds_failed_leaving_smart_object = function (arg_12_0)
	if arg_12_0.breeds_failed_leaving_smart_object == nil then
		return
	end

	for iter_12_0, iter_12_1 in pairs(arg_12_0.breeds_failed_leaving_smart_object) do
		if var_0_2(iter_12_0) then
			local var_12_0 = ScriptUnit.has_extension(iter_12_0, "ai_navigation_system")

			if var_12_0 then
				var_12_0:reset_destination()
			end
		end
	end

	arg_12_0.breeds_failed_leaving_smart_object = {}
end

DoorExtension.hot_join_sync = function (arg_13_0, arg_13_1)
	local var_13_0 = LevelHelper:current_level(arg_13_0.world)
	local var_13_1 = Level.unit_index(var_13_0, arg_13_0.unit)

	if var_13_1 then
		local var_13_2 = arg_13_0.current_state
		local var_13_3 = NetworkLookup.door_states[var_13_2]
		local var_13_4 = PEER_ID_TO_CHANNEL[arg_13_1]

		RPC.rpc_sync_door_state(var_13_4, var_13_1, var_13_3)
	end
end

DoorExtension.destroy = function (arg_14_0)
	arg_14_0:destroy_box_obstacles()

	arg_14_0.unit = nil
	arg_14_0.world = nil
	arg_14_0.health_extension = nil
	arg_14_0.breeds_failed_leaving_smart_object = nil
end

DoorExtension.destroy_box_obstacles = function (arg_15_0)
	if arg_15_0.state_to_nav_obstacle_map then
		for iter_15_0, iter_15_1 in pairs(arg_15_0.state_to_nav_obstacle_map) do
			GwNavBoxObstacle.destroy(iter_15_1)
		end

		arg_15_0.state_to_nav_obstacle_map = nil
	end

	arg_15_0.frames_since_obstacle_update = 0
end

DoorExtension.is_open = function (arg_16_0)
	return arg_16_0.current_state ~= "closed"
end

DoorExtension.is_opening = function (arg_17_0)
	return arg_17_0.current_state ~= "closed" and (arg_17_0.animation_stop_time or arg_17_0.frames_since_obstacle_update)
end
