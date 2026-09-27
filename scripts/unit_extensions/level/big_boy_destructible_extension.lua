-- chunkname: @scripts/unit_extensions/level/big_boy_destructible_extension.lua

BigBoyDestructibleExtension = class(BigBoyDestructibleExtension)

local num = 30
local num_2 = 3
local alive = Unit.alive

BigBoyDestructibleExtension.init = function (self, arg_1_1, arg_1_2, arg_1_3)
	-- function 1
	self.unit = arg_1_2
	self.world = arg_1_1.world
	self.is_server = Managers.player.is_server

	local get_data = Unit.get_data(arg_1_2, "move_to_exit_when_opened")

	self.move_to_exit_when_opened = get_data == nil or get_data

	local get_data_2 = Unit.get_data(arg_1_2, "door_state")
	local flag

	flag = (get_data_2 ~= 0 or not "open_forward" or get_data_2 ~= 1) and (not "closed" or get_data_2 ~= 2 or "open_backward")
	self.current_state = flag
	self.state_to_nav_obstacle_map = {}
	self.animation_stop_time = 0
	self.dead = false
	self.breeds_failed_leaving_smart_object = {}
	self.frames_since_obstacle_update = nil
	self.num_attackers = 0
end

BigBoyDestructibleExtension.extensions_ready = function (self)
	-- function 2
	self.health_extension = ScriptUnit.extension(self.unit, "health_system")
end

BigBoyDestructibleExtension.animation_played = function (self, arg_3_1, arg_3_2)
	-- function 3
	local num_2 = arg_3_1 / num / arg_3_2

	self.animation_stop_time = Managers.time:time("game") + num_2
end

BigBoyDestructibleExtension.update_nav_obstacles = function (self)
	-- function 4
	local current_state = self.current_state
	local state_to_nav_obstacle_map = self.state_to_nav_obstacle_map

	if not state_to_nav_obstacle_map[current_state] then
		local unit = self.unit
		local GLOBAL_AI_NAVWORLD = GLOBAL_AI_NAVWORLD
		local create_exclusive_box_obstacle_from_unit_data, var_4_5 = NavigationUtils.create_exclusive_box_obstacle_from_unit_data(GLOBAL_AI_NAVWORLD, unit)

		GwNavBoxObstacle.add_to_world(create_exclusive_box_obstacle_from_unit_data)
		GwNavBoxObstacle.set_transform(create_exclusive_box_obstacle_from_unit_data, var_4_5)

		state_to_nav_obstacle_map[current_state] = create_exclusive_box_obstacle_from_unit_data
	end

	for k, v in pairs(state_to_nav_obstacle_map) do
		local flag = k == current_state

		GwNavBoxObstacle.set_does_trigger_tagvolume(v, flag)
	end

	self.frames_since_obstacle_update = 0
end

BigBoyDestructibleExtension._get_animation_flow_event = function (self, arg_5_1, arg_5_2)
	-- function 5
	local var_5_0 = self.animation_flow_events[arg_5_1][arg_5_2]

	fassert(var_5_0, "Door animation event from %s to %s unavailable", arg_5_1, arg_5_2)

	return var_5_0
end

BigBoyDestructibleExtension.update_nav_graphs = function (self)
	-- function 6
	local unit = self.unit
	local system = Managers.state.entity:system("nav_graph_system")

	if self:is_open() or not self.dead then
		system:remove_nav_graph(unit)
	else
		system:add_nav_graph(unit)
	end
end

BigBoyDestructibleExtension.update = function (self, arg_7_1, arg_7_2, arg_7_3, arg_7_4, arg_7_5)
	-- function 7
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

	if not (not animation_stop_time and not (animation_stop_time <= arg_7_5)) then
		self:update_nav_obstacles()

		self.animation_stop_time = nil
	end

	if not self.health_extension:is_alive() then
		self.dead = true

		self:destroy_box_obstacles()
	end
end

BigBoyDestructibleExtension.register_breed_failed_leaving_smart_object = function (self, arg_8_1)
	-- function 8
	if self.breeds_failed_leaving_smart_object == nil then
		return
	end

	self.breeds_failed_leaving_smart_object[arg_8_1] = true
end

BigBoyDestructibleExtension.handle_breeds_failed_leaving_smart_object = function (self)
	-- function 9
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

BigBoyDestructibleExtension.destroy = function (self)
	-- function 10
	self:destroy_box_obstacles()

	self.unit = nil
	self.world = nil
	self.health_extension = nil
	self.breeds_failed_leaving_smart_object = nil
end

BigBoyDestructibleExtension.destroy_box_obstacles = function (self)
	-- function 11
	if not self.state_to_nav_obstacle_map then
		for k, v in pairs(self.state_to_nav_obstacle_map) do
			GwNavBoxObstacle.destroy(v)
		end

		self.state_to_nav_obstacle_map = nil
	end

	self.frames_since_obstacle_update = 0
end

BigBoyDestructibleExtension.is_open = function (self)
	-- function 12
	return self.dead
end

BigBoyDestructibleExtension.is_opening = function (arg_13_0)
	-- function 13
	return false
end
