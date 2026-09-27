-- chunkname: @scripts/unit_extensions/level/simple_door_extension.lua

SimpleDoorExtension = class(SimpleDoorExtension)

local num = 30
local alive = Unit.alive

SimpleDoorExtension.init = function (self, arg_1_1, arg_1_2, arg_1_3)
	-- function 1
	local world = arg_1_1.world

	self.unit = arg_1_2
	self.world = world
	self.is_server = Managers.player.is_server
	self.ignore_umbra = not World.umbra_available(world)
	self.is_umbra_gate = Unit.get_data(arg_1_2, "umbra_gate")

	local get_data = Unit.get_data(arg_1_2, "door_state")
	local flag

	flag = (get_data ~= 0 or not "open_forward" or get_data ~= 1) and "closed"
	self.current_state = flag
	self.animation_stop_time = 0
end

SimpleDoorExtension.destroy = function (self)
	-- function 2
	self:destroy_box_obstacle()

	self.unit = nil
	self.world = nil
end

SimpleDoorExtension.destroy_box_obstacle = function (self)
	-- function 3
	local obstacle = self.obstacle

	if not obstacle then
		GwNavBoxObstacle.destroy(obstacle)
	end
end

SimpleDoorExtension.extensions_ready = function (arg_4_0)
	-- function 4
	return
end

SimpleDoorExtension.interacted_with = function (arg_5_0, arg_5_1)
	-- function 5
	return
end

SimpleDoorExtension.is_opening = function (self)
	-- function 6
	return self.current_state == "closed" or self.animation_stop_time
end

SimpleDoorExtension.is_open = function (self)
	-- function 7
	return self.current_state ~= "closed"
end

SimpleDoorExtension.get_current_state = function (self)
	-- function 8
	return self.current_state
end

SimpleDoorExtension.set_door_state_and_duration = function (self, arg_9_1, arg_9_2, arg_9_3)
	-- function 9
	if self.current_state == arg_9_1 then
		return
	end

	local unit = self.unit
	local flag = arg_9_1 == "closed"

	if flag or self.ignore_umbra or not self.is_umbra_gate then
		World.umbra_set_gate_closed(self.world, unit, flag)
	end

	self.current_state = arg_9_1

	local num_2 = arg_9_2 / num / arg_9_3

	self.animation_stop_time = Managers.time:time("game") + num_2
end

SimpleDoorExtension.hot_join_sync = function (arg_10_0, arg_10_1)
	-- function 10
	return
end

SimpleDoorExtension.update_nav_obstacle = function (self)
	-- function 11
	local current_state = self.current_state
	local obstacle = self.obstacle

	if obstacle == nil then
		local var_11_2
		local unit = self.unit
		local GLOBAL_AI_NAVWORLD = GLOBAL_AI_NAVWORLD
		local var_11_5

		obstacle, var_11_5 = NavigationUtils.create_exclusive_box_obstacle_from_unit_data(GLOBAL_AI_NAVWORLD, unit)

		GwNavBoxObstacle.add_to_world(obstacle)
		GwNavBoxObstacle.set_transform(obstacle, var_11_5)

		self.obstacle = obstacle
	end

	local flag = current_state == "closed"

	GwNavBoxObstacle.set_does_trigger_tagvolume(obstacle, flag)
end

SimpleDoorExtension.update = function (self, arg_12_1, arg_12_2, arg_12_3, arg_12_4, arg_12_5)
	-- function 12
	local animation_stop_time = self.animation_stop_time

	if not (not animation_stop_time and not (animation_stop_time <= arg_12_5)) then
		self:update_nav_obstacle()

		self.animation_stop_time = nil

		local flag = self.current_state == "closed"

		if not flag and self.ignore_umbra or not self.is_umbra_gate then
			World.umbra_set_gate_closed(self.world, arg_12_1, flag)
		end
	end
end
