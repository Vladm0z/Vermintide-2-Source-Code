-- chunkname: @scripts/unit_extensions/weapons/projectiles/projectile_physics_unit_locomotion_extension.lua

ProjectilePhysicsUnitLocomotionExtension = class(ProjectilePhysicsUnitLocomotionExtension)

local script_data = script_data
local debug_projectiles = script_data.debug_projectiles

debug_projectiles = debug_projectiles or Development.parameter("debug_projectiles")
script_data.debug_projectiles = debug_projectiles

ProjectilePhysicsUnitLocomotionExtension.init = function (self, arg_1_1, arg_1_2, arg_1_3)
	-- function 1
	self.unit = arg_1_2
	self.physics_world = World.get_data(arg_1_1.world, "physics_world")
	self.owner_unit = arg_1_3.owner_unit
	self.network_position = arg_1_3.network_position
	self.network_rotation = arg_1_3.network_rotation
	self.network_velocity = arg_1_3.network_velocity
	self.network_angular_velocity = arg_1_3.network_angular_velocity
	self.is_server = Managers.player.is_server
	self.is_husk = not self.is_server
	self.stopped = false
	self.dropped = false
	self.owner_peer_id = arg_1_3.owner_peer_id

	local network = Managers.state.network

	self.game = network:game()
	self.network_manager = network

	local position_network_scale = AiAnimUtils.position_network_scale(self.network_position)
	local rotation_network_scale = AiAnimUtils.rotation_network_scale(self.network_rotation)
	local velocity_network_scale = AiAnimUtils.velocity_network_scale(self.network_velocity)
	local velocity_network_scale_2 = AiAnimUtils.velocity_network_scale(self.network_angular_velocity)
	local create_actor = Unit.create_actor(arg_1_2, "throw")

	Actor.teleport_position(create_actor, position_network_scale)
	Actor.teleport_rotation(create_actor, rotation_network_scale)
	Actor.set_velocity(create_actor, velocity_network_scale)
	Actor.set_angular_velocity(create_actor, velocity_network_scale_2)

	self.physics_actor = create_actor

	for i = 1, Unit.num_actors(arg_1_2) do
		local actor = Unit.actor(arg_1_2, i)

		if not (not actor and not Actor.is_physical(actor) and actor == create_actor) then
			Actor.set_velocity(actor, velocity_network_scale)
			Actor.set_angular_velocity(actor, velocity_network_scale_2)
		end
	end
end

ProjectilePhysicsUnitLocomotionExtension.destroy = function (arg_2_0)
	-- function 2
	return
end

local num = 0.1
local num_2 = 0.5

ProjectilePhysicsUnitLocomotionExtension.update = function (self, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5)
	-- function 3
	if not self.stopped then
		return
	end

	local physics_actor = self.physics_actor
	local velocity = Actor.velocity(physics_actor)

	if not (Vector3.length(velocity) <= num) then
		self.stop_time = nil

		return
	end

	local stop_time = self.stop_time

	stop_time = stop_time or 0

	local num_3 = stop_time + arg_3_3

	self.stop_time = num_3

	if num_3 >= num_2 then
		self:stop()
	end
end

local num_3 = 1

ProjectilePhysicsUnitLocomotionExtension.bounce = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4, arg_4_5)
	-- function 4
	if Vector3.length(arg_4_5) > num_3 then
		-- Nothing
	end
end

ProjectilePhysicsUnitLocomotionExtension.stop = function (self)
	-- function 5
	self.stopped = true

	Actor.put_to_sleep(self.physics_actor)

	local network_manager = self.network_manager
	local unit_game_object_id = network_manager:unit_game_object_id(self.unit)

	network_manager.network_transmit:send_rpc_clients("rpc_projectile_stopped", unit_game_object_id)
end

ProjectilePhysicsUnitLocomotionExtension.drop = function (self)
	-- function 6
	self.dropped = true

	Actor.set_velocity(self.physics_actor, Vector3(0, 0, 0))

	local network_manager = self.network_manager
	local unit_game_object_id = network_manager:unit_game_object_id(self.unit)

	network_manager.network_transmit:send_rpc_clients("rpc_drop_projectile", unit_game_object_id)
end

ProjectilePhysicsUnitLocomotionExtension.has_stopped = function (self)
	-- function 7
	return self.stopped
end
