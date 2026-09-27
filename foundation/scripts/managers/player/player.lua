-- chunkname: @foundation/scripts/managers/player/player.lua

Player = class(Player)
Player._allowed_transitions = {
	despawned = {
		spawned = true
	},
	queued_for_despawn = {
		despawned = true
	},
	spawned = {
		queued_for_despawn = true,
		despawned = true
	}
}

Player.init = function (self, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5)
	-- function 1
	self.network_manager = arg_1_1
	self.input_source = arg_1_2
	self.viewport_name = arg_1_3
	self.viewport_world_name = arg_1_4
	self.owned_units = {}
	self.is_server = arg_1_5
	self.camera_follow_unit = nil
	self._spawn_state = "despawned"
end

Player.destroy = function (self)
	-- function 2
	self.network_manager = nil
end

Player.set_camera_follow_unit = function (self, arg_3_1)
	-- function 3
	self.camera_follow_unit = arg_3_1
end

Player.needs_despawn = function (self)
	-- function 4
	return self._spawn_state == "spawned"
end

Player.mark_as_queued_for_despawn = function (self)
	-- function 5
	self:_set_spawn_state("queued_for_despawn")
end

Player._set_spawn_state = function (self, arg_6_1)
	-- function 6
	fassert(arg_6_1 == "spawned" or arg_6_1 == "queued_for_despawn" or arg_6_1 == "despawned", "Invalid spawn state %s", arg_6_1)
	fassert(Player._allowed_transitions[self._spawn_state][arg_6_1], "Spawn state transition from %s to %s is not allowed", self._spawn_state, arg_6_1)

	self._spawn_state = arg_6_1
end

Player.spawn_state = function (self)
	-- function 7
	return self._spawn_state
end
