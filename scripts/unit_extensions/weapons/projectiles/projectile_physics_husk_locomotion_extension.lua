-- chunkname: @scripts/unit_extensions/weapons/projectiles/projectile_physics_husk_locomotion_extension.lua

ProjectilePhysicsHuskLocomotionExtension = class(ProjectilePhysicsHuskLocomotionExtension)
script_data.debug_projectiles = script_data.debug_projectiles or Development.parameter("debug_projectiles")

function ProjectilePhysicsHuskLocomotionExtension.init(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
	arg_1_0.unit = arg_1_2
	arg_1_0.owner_unit = arg_1_3.owner_unit
	arg_1_0.is_server = Managers.player.is_server
	arg_1_0.is_husk = not arg_1_0.is_server
	arg_1_0.stopped = false

	local var_1_0 = AiAnimUtils.position_network_scale(arg_1_3.network_position)
	local var_1_1 = AiAnimUtils.rotation_network_scale(arg_1_3.network_rotation)
	local var_1_2 = AiAnimUtils.velocity_network_scale(arg_1_3.network_velocity)
	local var_1_3 = AiAnimUtils.velocity_network_scale(arg_1_3.network_angular_velocity)
	local var_1_4 = Unit.create_actor(arg_1_2, "throw")

	Actor.teleport_position(var_1_4, var_1_0)
	Actor.teleport_rotation(var_1_4, var_1_1)
	Actor.set_velocity(var_1_4, var_1_2)
	Actor.set_angular_velocity(var_1_4, var_1_3)

	arg_1_0.physics_actor = var_1_4

	for iter_1_0 = 1, Unit.num_actors(arg_1_2) do
		local var_1_5 = Unit.actor(arg_1_2, iter_1_0)

		if var_1_5 and Actor.is_physical(var_1_5) and var_1_5 ~= var_1_4 then
			Actor.set_velocity(var_1_5, var_1_2)
			Actor.set_angular_velocity(var_1_5, var_1_3)
		end
	end
end

function ProjectilePhysicsHuskLocomotionExtension.destroy(arg_2_0)
	return
end

function ProjectilePhysicsHuskLocomotionExtension.update(arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5)
	if script_data.debug_projectiles then
		local var_3_0 = Managers.state.network
		local var_3_1 = var_3_0:unit_game_object_id(arg_3_1)
		local var_3_2 = var_3_0:game()
		local var_3_3 = GameSession.game_object_field(var_3_2, var_3_1, "debug_pos")
		local var_3_4 = Unit.local_position(arg_3_1, 0)

		QuickDrawer:line(var_3_3, var_3_4, Color(255, 0, 255, 0))
	end

	if arg_3_0.stopped then
		return
	end
end

function ProjectilePhysicsHuskLocomotionExtension.is_at_rest(arg_4_0)
	return Actor.is_sleeping(arg_4_0.physics_actor)
end

function ProjectilePhysicsHuskLocomotionExtension.teleport(arg_5_0, arg_5_1, arg_5_2)
	local var_5_0 = Matrix4x4.from_quaternion_position(arg_5_2, arg_5_1)
	local var_5_1 = arg_5_0.unit
	local var_5_2 = arg_5_0.physics_actor

	Unit.set_local_pose(var_5_1, 0, var_5_0)
	Actor.teleport_pose(var_5_2, var_5_0)

	local var_5_3 = Vector3.zero()

	Actor.set_angular_velocity(var_5_2, var_5_3)
	Actor.set_velocity(var_5_2, var_5_3)
end

function ProjectilePhysicsHuskLocomotionExtension.bounce(arg_6_0)
	return
end

function ProjectilePhysicsHuskLocomotionExtension.stop(arg_7_0)
	arg_7_0.stopped = true

	Actor.put_to_sleep(arg_7_0.physics_actor)
end

function ProjectilePhysicsHuskLocomotionExtension.drop(arg_8_0)
	arg_8_0.dropped = true

	Actor.set_velocity(arg_8_0.physics_actor, Vector3(0, 0, 0))
end

function ProjectilePhysicsHuskLocomotionExtension.has_stopped(arg_9_0)
	return arg_9_0.stopped
end
