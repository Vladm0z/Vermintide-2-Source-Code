-- chunkname: @scripts/unit_extensions/weapons/projectiles/projectile_physics_unit_locomotion_extension.lua

ProjectilePhysicsUnitLocomotionExtension = class(ProjectilePhysicsUnitLocomotionExtension)
script_data.debug_projectiles = script_data.debug_projectiles or Development.parameter("debug_projectiles")

ProjectilePhysicsUnitLocomotionExtension.init = function (arg_1_0, arg_1_1, arg_1_2, arg_1_3)
	arg_1_0.unit = arg_1_2
	arg_1_0.physics_world = World.get_data(arg_1_1.world, "physics_world")
	arg_1_0.owner_unit = arg_1_3.owner_unit
	arg_1_0.network_position = arg_1_3.network_position
	arg_1_0.network_rotation = arg_1_3.network_rotation
	arg_1_0.network_velocity = arg_1_3.network_velocity
	arg_1_0.network_angular_velocity = arg_1_3.network_angular_velocity
	arg_1_0.is_server = Managers.player.is_server
	arg_1_0.is_husk = not arg_1_0.is_server
	arg_1_0.stopped = false
	arg_1_0.dropped = false
	arg_1_0.owner_peer_id = arg_1_3.owner_peer_id

	local var_1_0 = Managers.state.network

	arg_1_0.game = var_1_0:game()
	arg_1_0.network_manager = var_1_0

	local var_1_1 = AiAnimUtils.position_network_scale(arg_1_0.network_position)
	local var_1_2 = AiAnimUtils.rotation_network_scale(arg_1_0.network_rotation)
	local var_1_3 = AiAnimUtils.velocity_network_scale(arg_1_0.network_velocity)
	local var_1_4 = AiAnimUtils.velocity_network_scale(arg_1_0.network_angular_velocity)
	local var_1_5 = Unit.create_actor(arg_1_2, "throw")

	Actor.teleport_position(var_1_5, var_1_1)
	Actor.teleport_rotation(var_1_5, var_1_2)
	Actor.set_velocity(var_1_5, var_1_3)
	Actor.set_angular_velocity(var_1_5, var_1_4)

	arg_1_0.physics_actor = var_1_5

	for iter_1_0 = 1, Unit.num_actors(arg_1_2) do
		local var_1_6 = Unit.actor(arg_1_2, iter_1_0)

		if var_1_6 and Actor.is_physical(var_1_6) and var_1_6 ~= var_1_5 then
			Actor.set_velocity(var_1_6, var_1_3)
			Actor.set_angular_velocity(var_1_6, var_1_4)
		end
	end
end

ProjectilePhysicsUnitLocomotionExtension.destroy = function (arg_2_0)
	return
end

local var_0_0 = 0.1
local var_0_1 = 0.5

ProjectilePhysicsUnitLocomotionExtension.update = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5)
	if arg_3_0.stopped then
		return
	end

	local var_3_0 = arg_3_0.physics_actor
	local var_3_1 = Actor.velocity(var_3_0)

	if not (Vector3.length(var_3_1) <= var_0_0) then
		arg_3_0.stop_time = nil

		return
	end

	local var_3_2 = (arg_3_0.stop_time or 0) + arg_3_3

	arg_3_0.stop_time = var_3_2

	if var_3_2 >= var_0_1 then
		arg_3_0:stop()
	end
end

local var_0_2 = 1

ProjectilePhysicsUnitLocomotionExtension.bounce = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4, arg_4_5)
	if Vector3.length(arg_4_5) > var_0_2 then
		-- Nothing
	end
end

ProjectilePhysicsUnitLocomotionExtension.stop = function (arg_5_0)
	arg_5_0.stopped = true

	Actor.put_to_sleep(arg_5_0.physics_actor)

	local var_5_0 = arg_5_0.network_manager
	local var_5_1 = var_5_0:unit_game_object_id(arg_5_0.unit)

	var_5_0.network_transmit:send_rpc_clients("rpc_projectile_stopped", var_5_1)
end

ProjectilePhysicsUnitLocomotionExtension.drop = function (arg_6_0)
	arg_6_0.dropped = true

	Actor.set_velocity(arg_6_0.physics_actor, Vector3(0, 0, 0))

	local var_6_0 = arg_6_0.network_manager
	local var_6_1 = var_6_0:unit_game_object_id(arg_6_0.unit)

	var_6_0.network_transmit:send_rpc_clients("rpc_drop_projectile", var_6_1)
end

ProjectilePhysicsUnitLocomotionExtension.has_stopped = function (arg_7_0)
	return arg_7_0.stopped
end
