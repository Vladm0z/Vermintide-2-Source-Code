-- chunkname: @scripts/unit_extensions/level/door_extension.lua

DoorExtension = class(DoorExtension)

local num = 30
local num_2 = 3
local alive = Unit.alive

DoorExtension.init = function (self, arg_1_1, arg_1_2, arg_1_3)
	-- function 1
	local world = arg_1_1.world

	self.unit = arg_1_2
	self.world = world
	self.is_server = Managers.player.is_server
	self.ignore_umbra = not World.umbra_available(world)
	self.is_umbra_gate = Unit.get_data(arg_1_2, "umbra_gate")

	local get_data = Unit.get_data(arg_1_2, "move_to_exit_when_opened")

	self.move_to_exit_when_opened = get_data == nil or get_data
	self.ai_attack_re_eval_time = Unit.get_data(arg_1_2, "ai_attack_re_eval_time")

	local get_data_2 = Unit.get_data(arg_1_2, "door_state")
	local flag

	flag = (get_data_2 ~= 0 or not "open_forward" or get_data_2 ~= 1) and (not "closed" or get_data_2 ~= 2 or "open_backward")
	self.current_state = flag
	self.animation_flow_events = {
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
	self.state_to_nav_obstacle_map = {}
	self.animation_stop_time = 0
	self.dead = false
	self.breeds_failed_leaving_smart_object = {}
	self.frames_since_obstacle_update = nil
	self.num_attackers = 0
end

DoorExtension.extensions_ready = function (self)
	-- function 2
	self.health_extension = ScriptUnit.extension(self.unit, "health_system")
end

DoorExtension.update_nav_graphs = function (self)
	-- function 3
	local unit = self.unit
	local system = Managers.state.entity:system("nav_graph_system")

	if self:is_open() or not self.dead then
		system:remove_nav_graph(unit)
	else
		system:add_nav_graph(unit)
	end
end

DoorExtension.animation_played = function (self, arg_4_1, arg_4_2)
	-- function 4
	local num_2 = arg_4_1 / num / arg_4_2

	self.animation_stop_time = Managers.time:time("game") + num_2
end

DoorExtension.update_nav_obstacles = function (self)
	-- function 5
	local unit = self.unit
	local current_state = self.current_state
	local state_to_nav_obstacle_map = self.state_to_nav_obstacle_map
	local get_data = Unit.get_data(unit, "navtag_volume", "clip_navmesh")

	if Unit.has_data(unit, "navtag_volume", "clip_navmesh") == false then
		get_data = true
	end

	if not (state_to_nav_obstacle_map[current_state] or get_data == false or Unit.get_data(unit, "navtag_volume", "no_obstacle")) then
		local unit_2 = self.unit
		local GLOBAL_AI_NAVWORLD = GLOBAL_AI_NAVWORLD
		local create_exclusive_box_obstacle_from_unit_data, var_5_7 = NavigationUtils.create_exclusive_box_obstacle_from_unit_data(GLOBAL_AI_NAVWORLD, unit_2)

		if not create_exclusive_box_obstacle_from_unit_data then
			GwNavBoxObstacle.add_to_world(create_exclusive_box_obstacle_from_unit_data)
			GwNavBoxObstacle.set_transform(create_exclusive_box_obstacle_from_unit_data, var_5_7)

			state_to_nav_obstacle_map[current_state] = create_exclusive_box_obstacle_from_unit_data
		end
	end

	for k, v in pairs(state_to_nav_obstacle_map) do
		local flag = k == current_state

		GwNavBoxObstacle.set_does_trigger_tagvolume(v, flag)
	end

	self.frames_since_obstacle_update = 0
end

DoorExtension.interacted_with = function (self, arg_6_1)
	-- function 6
	local unit = self.unit
	local current_state = self.current_state
	local var_6_2

	if not (current_state == "open_backward" or current_state ~= "open_forward") then
		var_6_2 = "closed"
	elseif current_state == "closed" then
		local world_position = Unit.world_position(unit, 0)
		local world_rotation = Unit.world_rotation(unit, 0)
		local num = world_position - POSITION_LOOKUP[arg_6_1]
		local normalize = Vector3.normalize(Vector3.flat(num))
		local forward = Quaternion.forward(world_rotation)
		local normalize_2 = Vector3.normalize(Vector3.flat(forward))

		var_6_2 = not (Vector3.dot(normalize, normalize_2) >= 0) and "open_backward" and "open_forward"
	end

	self:set_door_state(var_6_2)
end

DoorExtension.set_door_state = function (self, arg_7_1)
	-- function 7
	local current_state = self.current_state

	if current_state == arg_7_1 then
		return
	end

	local unit = self.unit
	local _get_animation_flow_event = self:_get_animation_flow_event(current_state, arg_7_1)

	Unit.flow_event(unit, _get_animation_flow_event)

	local flag = arg_7_1 == "closed"

	if flag or self.ignore_umbra or not self.is_umbra_gate then
		World.umbra_set_gate_closed(self.world, unit, flag)
	end

	self.current_state = arg_7_1
end

DoorExtension.get_current_state = function (self)
	-- function 8
	return self.current_state
end

DoorExtension._get_animation_flow_event = function (self, arg_9_1, arg_9_2)
	-- function 9
	local var_9_0 = self.animation_flow_events[arg_9_1][arg_9_2]

	fassert(var_9_0, "Door animation event from %s to %s unavailable", arg_9_1, arg_9_2)

	return var_9_0
end

DoorExtension.update = function (self, arg_10_1, arg_10_2, arg_10_3, arg_10_4, arg_10_5)
	-- function 10
	local frames_since_obstacle_update = self.frames_since_obstacle_update

	if not frames_since_obstacle_update then
		local num = frames_since_obstacle_update + 1

		if num == num_2 then
			self:update_nav_graphs()
			self:handle_breeds_failed_leaving_smart_object()

			self.frames_since_obstacle_update = nil
		else
			self.frames_since_obstacle_update = num
		end
	end

	if not self.dead then
		return
	end

	local animation_stop_time = self.animation_stop_time

	if not (not animation_stop_time and not (animation_stop_time <= arg_10_5)) then
		self:update_nav_obstacles()

		self.animation_stop_time = nil

		local flag = self.current_state == "closed"

		if not flag and self.ignore_umbra or not self.is_umbra_gate then
			World.umbra_set_gate_closed(self.world, arg_10_1, flag)
		end
	end

	if not HEALTH_ALIVE[arg_10_1] then
		self.dead = true

		self:destroy_box_obstacles()
	end
end

DoorExtension.register_breed_failed_leaving_smart_object = function (self, arg_11_1)
	-- function 11
	if self.breeds_failed_leaving_smart_object == nil then
		return
	end

	self.breeds_failed_leaving_smart_object[arg_11_1] = true
end

DoorExtension.handle_breeds_failed_leaving_smart_object = function (self)
	-- function 12
	if self.breeds_failed_leaving_smart_object == nil then
		return
	end

	for k, v in pairs(self.breeds_failed_leaving_smart_object) do
		if not alive(k) then
			local has_extension = ScriptUnit.has_extension(k, "ai_navigation_system")

			if not has_extension then
				has_extension:reset_destination()
			end
		end
	end

	self.breeds_failed_leaving_smart_object = {}
end

DoorExtension.hot_join_sync = function (self, arg_13_1)
	-- function 13
	local current_level = LevelHelper:current_level(self.world)
	local unit_index = Level.unit_index(current_level, self.unit)

	if not unit_index then
		local current_state = self.current_state
		local var_13_3 = NetworkLookup.door_states[current_state]
		local var_13_4 = PEER_ID_TO_CHANNEL[arg_13_1]

		RPC.rpc_sync_door_state(var_13_4, unit_index, var_13_3)
	end
end

DoorExtension.destroy = function (self)
	-- function 14
	self:destroy_box_obstacles()

	self.unit = nil
	self.world = nil
	self.health_extension = nil
	self.breeds_failed_leaving_smart_object = nil
end

DoorExtension.destroy_box_obstacles = function (self)
	-- function 15
	if not self.state_to_nav_obstacle_map then
		for k, v in pairs(self.state_to_nav_obstacle_map) do
			GwNavBoxObstacle.destroy(v)
		end

		self.state_to_nav_obstacle_map = nil
	end

	self.frames_since_obstacle_update = 0
end

DoorExtension.is_open = function (self)
	-- function 16
	return self.current_state ~= "closed"
end

DoorExtension.is_opening = function (self)
	-- function 17
	local animation_stop_time

	if self.current_state ~= "closed" then
		animation_stop_time = self.animation_stop_time

		if not animation_stop_time then
			animation_stop_time = self.frames_since_obstacle_update
		end
	else
		animation_stop_time = false
	end

	if false then
		animation_stop_time = true
	end

	return animation_stop_time
end
