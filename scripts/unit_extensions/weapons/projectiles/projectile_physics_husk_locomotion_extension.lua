-- chunkname: @scripts/unit_extensions/weapons/projectiles/projectile_physics_husk_locomotion_extension.lua

ProjectilePhysicsHuskLocomotionExtension = class(ProjectilePhysicsHuskLocomotionExtension)

local script_data = script_data
local debug_projectiles = script_data.debug_projectiles

debug_projectiles = debug_projectiles or Development.parameter("debug_projectiles")
script_data.debug_projectiles = debug_projectiles

ProjectilePhysicsHuskLocomotionExtension.init = function (self, arg_1_1, arg_1_2, arg_1_3)
	-- function 1
	self.unit = arg_1_2
	self.owner_unit = arg_1_3.owner_unit
	self.is_server = Managers.player.is_server
	self.is_husk = not self.is_server
	self.stopped = false

	local position_network_scale = AiAnimUtils.position_network_scale(arg_1_3.network_position)
	local rotation_network_scale = AiAnimUtils.rotation_network_scale(arg_1_3.network_rotation)
	local velocity_network_scale = AiAnimUtils.velocity_network_scale(arg_1_3.network_velocity)
	local velocity_network_scale_2 = AiAnimUtils.velocity_network_scale(arg_1_3.network_angular_velocity)
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

ProjectilePhysicsHuskLocomotionExtension.destroy = function (arg_2_0)
	-- function 2
	return
end

ProjectilePhysicsHuskLocomotionExtension.update = function (self, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5)
	-- function 3
	if not script_data.debug_projectiles then
		local network = Managers.state.network
		local unit_game_object_id = network:unit_game_object_id(arg_3_1)
		local game = network:game()
		local game_object_field = GameSession.game_object_field(game, unit_game_object_id, "debug_pos")
		local local_position = Unit.local_position(arg_3_1, 0)

		QuickDrawer:line(game_object_field, local_position, Color(255, 0, 255, 0))
	end

	if not self.stopped then
		return
	end
end

ProjectilePhysicsHuskLocomotionExtension.is_at_rest = function (self)
	-- function 4
	return Actor.is_sleeping(self.physics_actor)
end

ProjectilePhysicsHuskLocomotionExtension.teleport = function (self, arg_5_1, arg_5_2)
	-- function 5
	local from_quaternion_position = Matrix4x4.from_quaternion_position(arg_5_2, arg_5_1)
	local unit = self.unit
	local physics_actor = self.physics_actor

	Unit.set_local_pose(unit, 0, from_quaternion_position)
	Actor.teleport_pose(physics_actor, from_quaternion_position)

	local zero = Vector3.zero()

	Actor.set_angular_velocity(physics_actor, zero)
	Actor.set_velocity(physics_actor, zero)
end

ProjectilePhysicsHuskLocomotionExtension.bounce = function (arg_6_0)
	-- function 6
	return
end

ProjectilePhysicsHuskLocomotionExtension.stop = function (self)
	-- function 7
	self.stopped = true

	Actor.put_to_sleep(self.physics_actor)
end

ProjectilePhysicsHuskLocomotionExtension.drop = function (self)
	-- function 8
	self.dropped = true

	Actor.set_velocity(self.physics_actor, Vector3(0, 0, 0))
end

ProjectilePhysicsHuskLocomotionExtension.has_stopped = function (self)
	-- function 9
	return self.stopped
end
