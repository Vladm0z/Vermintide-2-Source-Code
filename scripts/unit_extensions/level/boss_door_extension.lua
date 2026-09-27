-- chunkname: @scripts/unit_extensions/level/boss_door_extension.lua

BossDoorExtension = class(BossDoorExtension)

local num = 30
local num_2 = 3
local tbl = {
	chaos_troll = "lua_closed_troll",
	chaos_spawn = "lua_closed_stormfiend",
	beastmen_minotaur = "lua_closed_stormfiend",
	skaven_rat_ogre = "lua_closed_stormfiend",
	skaven_stormfiend = "lua_closed_stormfiend"
}

BossDoorExtension.init = function (self, arg_1_1, arg_1_2, arg_1_3)
	-- function 1
	local world = arg_1_1.world

	self.unit = arg_1_2
	self.world = world
	self.is_server = Managers.player.is_server
	self.current_state = "open"
	self.state_to_nav_obstacle_map = {}
	self.ignore_umbra = not World.umbra_available(world)
	self.breeds_failed_leaving_smart_object = {}
	self.num_attackers = 0
	self.animation_stop_time = 0
end

BossDoorExtension.extensions_ready = function (arg_2_0)
	-- function 2
	return
end

BossDoorExtension.update_nav_obstacles = function (self)
	-- function 3
	local current_state = self.current_state
	local state_to_nav_obstacle_map = self.state_to_nav_obstacle_map

	for k, v in pairs(state_to_nav_obstacle_map) do
		local flag = k == current_state

		GwNavBoxObstacle.set_does_trigger_tagvolume(v, flag)
	end
end

BossDoorExtension.set_door_state = function (self, arg_4_1, arg_4_2)
	-- function 4
	if self.current_state == arg_4_1 then
		return
	end

	local unit = self.unit
	local flag

	flag = arg_4_1 ~= "closed" or not "lua_close" or "lua_open"

	Unit.flow_event(unit, flag)

	local var_4_2 = tbl[arg_4_2]

	if not var_4_2 then
		Unit.flow_event(unit, var_4_2)
	end

	local flag_2

	flag_2 = arg_4_1 == "closed"
	self.current_state = arg_4_1
	self.breed_name = arg_4_2
end

BossDoorExtension.get_current_state = function (self)
	-- function 5
	return self.current_state
end

BossDoorExtension.update = function (self, arg_6_1, arg_6_2, arg_6_3, arg_6_4, arg_6_5)
	-- function 6
	local animation_stop_time = self.animation_stop_time

	if not (not animation_stop_time and not (animation_stop_time <= arg_6_5)) then
		self:update_nav_obstacles()

		self.animation_stop_time = nil
	end
end

BossDoorExtension.hot_join_sync = function (self, arg_7_1)
	-- function 7
	local current_level = LevelHelper:current_level(self.world)
	local unit_index = Level.unit_index(current_level, self.unit)
	local current_state = self.current_state
	local var_7_3 = NetworkLookup.door_states[current_state]
	local breed_name = self.breed_name

	breed_name = breed_name or "n/a"

	local var_7_5 = NetworkLookup.breeds[breed_name]
	local var_7_6 = PEER_ID_TO_CHANNEL[arg_7_1]

	RPC.rpc_sync_boss_door_state(var_7_6, unit_index, var_7_3, var_7_5)
end

BossDoorExtension.destroy = function (self)
	-- function 8
	self:destroy_box_obstacles()

	self.unit = nil
	self.world = nil
end

BossDoorExtension.destroy_box_obstacles = function (self)
	-- function 9
	if not self.state_to_nav_obstacle_map then
		for k, v in pairs(self.state_to_nav_obstacle_map) do
			GwNavBoxObstacle.destroy(v)
		end

		self.state_to_nav_obstacle_map = nil
	end
end

BossDoorExtension.animation_played = function (self, arg_10_1, arg_10_2)
	-- function 10
	local num_2 = arg_10_1 / num / arg_10_2

	self.animation_stop_time = Managers.time:time("game") + num_2
end

BossDoorExtension.is_open = function (self)
	-- function 11
	return self.current_state == "open"
end
