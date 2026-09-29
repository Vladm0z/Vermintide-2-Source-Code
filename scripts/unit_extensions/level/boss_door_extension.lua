-- chunkname: @scripts/unit_extensions/level/boss_door_extension.lua

BossDoorExtension = class(BossDoorExtension)

local SIMPLE_ANIMATION_FPS = 30
local NAVMESH_UPDATE_DELAY = 3
local flow_event_by_breed = {
	chaos_troll = "lua_closed_troll",
	chaos_spawn = "lua_closed_stormfiend",
	beastmen_minotaur = "lua_closed_stormfiend",
	skaven_rat_ogre = "lua_closed_stormfiend",
	skaven_stormfiend = "lua_closed_stormfiend"
}

BossDoorExtension.init = function (self, extension_init_context, unit, extension_init_data)
	-- function 1
	local world = extension_init_context.world

	self.unit = unit
	self.world = world
	self.is_server = Managers.player.is_server
	self.current_state = "open"
	self.state_to_nav_obstacle_map = {}
	self.ignore_umbra = not World.umbra_available(world)
	self.breeds_failed_leaving_smart_object = {}
	self.num_attackers = 0
	self.animation_stop_time = 0
end

BossDoorExtension.extensions_ready = function (self)
	-- function 2
	return
end

BossDoorExtension.update_nav_obstacles = function (self)
	-- function 3
	local current_state = self.current_state
	local obstacles = self.state_to_nav_obstacle_map

	for obstacle_state, obstacle in pairs(obstacles) do
		local does_trigger = obstacle_state == current_state

		GwNavBoxObstacle.set_does_trigger_tagvolume(obstacle, does_trigger)
	end
end

BossDoorExtension.set_door_state = function (self, new_state, breed_name)
	-- function 4
	local current_state = self.current_state

	if current_state == new_state then
		return
	end

	local unit = self.unit
	local state_flow_event = new_state ~= "closed" and not not "lua_open" or not (new_state ~= "closed") and not not "lua_close"

	Unit.flow_event(unit, state_flow_event)

	local effect_flow_event = flow_event_by_breed[breed_name]

	if effect_flow_event then
		Unit.flow_event(unit, effect_flow_event)
	end

	local closed = new_state == "closed"

	self.current_state = new_state
	self.breed_name = breed_name
end

BossDoorExtension.get_current_state = function (self)
	-- function 5
	return self.current_state
end

BossDoorExtension.update = function (self, unit, input, dt, context, t)
	-- function 6
	local animation_stop_time = self.animation_stop_time

	if animation_stop_time and animation_stop_time <= t then
		self:update_nav_obstacles()

		self.animation_stop_time = nil
	end
end

BossDoorExtension.hot_join_sync = function (self, peer_id)
	-- function 7
	local level = LevelHelper:current_level(self.world)
	local level_index = Level.unit_index(level, self.unit)
	local door_state = self.current_state
	local door_state_id = NetworkLookup.door_states[door_state]
	local breed_name = not not self.breed_name
	local breed_id = NetworkLookup.breeds[breed_name]
	local channel_id = PEER_ID_TO_CHANNEL[peer_id]

	RPC.rpc_sync_boss_door_state(channel_id, level_index, door_state_id, breed_id)
end

BossDoorExtension.destroy = function (self)
	-- function 8
	self:destroy_box_obstacles()

	self.unit = nil
	self.world = nil
end

BossDoorExtension.destroy_box_obstacles = function (self)
	-- function 9
	if self.state_to_nav_obstacle_map then
		for _, obstacle in pairs(self.state_to_nav_obstacle_map) do
			GwNavBoxObstacle.destroy(obstacle)
		end

		self.state_to_nav_obstacle_map = nil
	end
end

BossDoorExtension.animation_played = function (self, frames, speed)
	-- function 10
	local animation_length = frames / SIMPLE_ANIMATION_FPS / speed
	local t = Managers.time:time("game")

	self.animation_stop_time = t + animation_length
end

BossDoorExtension.is_open = function (self)
	-- function 11
	return self.current_state == "open"
end
