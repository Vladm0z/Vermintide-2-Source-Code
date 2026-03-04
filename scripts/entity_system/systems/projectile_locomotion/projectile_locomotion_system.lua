-- chunkname: @scripts/entity_system/systems/projectile_locomotion/projectile_locomotion_system.lua

require("scripts/unit_extensions/weapons/projectiles/projectile_physics_husk_locomotion_extension")
require("scripts/unit_extensions/weapons/projectiles/projectile_physics_unit_locomotion_extension")
require("scripts/unit_extensions/weapons/projectiles/projectile_script_unit_locomotion_extension")
require("scripts/unit_extensions/weapons/projectiles/projectile_sticky_locomotion")

ProjectileLocomotionSystem = class(ProjectileLocomotionSystem, ExtensionSystemBase)

local var_0_0 = {
	"rpc_set_projectile_state",
	"rpc_projectile_stick_unit",
	"rpc_projectile_stick_position",
	"rpc_hot_join_sync_projectile_sticky"
}
local var_0_1 = {
	"ProjectilePhysicsHuskLocomotionExtension",
	"ProjectilePhysicsUnitLocomotionExtension",
	"ProjectileScriptUnitLocomotionExtension",
	"ProjectileTrueFlightLocomotionExtension",
	"ProjectileHomingSkullLocomotionExtension",
	"ProjectileExtrapolatedHuskLocomotionExtension",
	"ProjectileStickyLocomotion",
	"ProjectileEtherealSkullLocomotionExtension"
}

ProjectileLocomotionSystem.init = function (arg_1_0, arg_1_1, arg_1_2)
	ProjectileLocomotionSystem.super.init(arg_1_0, arg_1_1, arg_1_2, var_0_1)

	local var_1_0 = arg_1_1.network_event_delegate

	arg_1_0.network_event_delegate = var_1_0

	var_1_0:register(arg_1_0, unpack(var_0_0))

	arg_1_0._server_position_corrected_pickups = {}
end

ProjectileLocomotionSystem.on_add_extension = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4, ...)
	if arg_2_3 == "ProjectilePhysicsHuskLocomotionExtension" or arg_2_3 == "ProjectilePhysicsUnitLocomotionExtension" then
		arg_2_0._server_position_corrected_pickups[arg_2_2] = arg_2_2
	end

	return ProjectileLocomotionSystem.super.on_add_extension(arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4, ...)
end

ProjectileLocomotionSystem.on_remove_extension = function (arg_3_0, arg_3_1, arg_3_2, ...)
	arg_3_0._server_position_corrected_pickups[arg_3_1] = nil

	return ProjectileLocomotionSystem.super.on_remove_extension(arg_3_0, arg_3_1, arg_3_2, ...)
end

ProjectileLocomotionSystem.update = function (arg_4_0, arg_4_1, arg_4_2)
	ProjectileLocomotionSystem.super.update(arg_4_0, arg_4_1, arg_4_2)

	if arg_4_0.is_server then
		arg_4_0:_server_sync_position_rotation(arg_4_1, arg_4_2)
	else
		arg_4_0:_client_validate_position_rotation(arg_4_1, arg_4_2)
	end
end

ProjectileLocomotionSystem.destroy = function (arg_5_0)
	arg_5_0.network_event_delegate:unregister(arg_5_0)
end

ProjectileLocomotionSystem._server_sync_position_rotation = function (arg_6_0, arg_6_1, arg_6_2)
	local var_6_0 = Managers.state.network:game()

	if var_6_0 then
		local var_6_1 = POSITION_LOOKUP
		local var_6_2 = GameSession.set_game_object_field
		local var_6_3 = Managers.state.unit_storage
		local var_6_4 = Unit.local_rotation
		local var_6_5 = NetworkConstants.position.min
		local var_6_6 = NetworkConstants.position.max

		for iter_6_0, iter_6_1 in pairs(arg_6_0._server_position_corrected_pickups) do
			local var_6_7 = var_6_3:go_id(iter_6_0)
			local var_6_8 = Vector3.clamp(var_6_1[iter_6_0], var_6_5, var_6_6)
			local var_6_9 = var_6_4(iter_6_0, 0)

			var_6_2(var_6_0, var_6_7, "position", var_6_8)
			var_6_2(var_6_0, var_6_7, "rotation", var_6_9)
		end
	end
end

local var_0_2 = 0.05
local var_0_3 = 5

ProjectileLocomotionSystem._client_validate_position_rotation = function (arg_7_0, arg_7_1, arg_7_2)
	local var_7_0 = Managers.state.network:game()

	if var_7_0 then
		local var_7_1 = POSITION_LOOKUP
		local var_7_2 = GameSession.game_object_field
		local var_7_3 = Vector3.distance_squared
		local var_7_4 = ScriptUnit.extension
		local var_7_5 = Unit.local_position
		local var_7_6 = Managers.state.unit_storage

		for iter_7_0, iter_7_1 in pairs(arg_7_0._server_position_corrected_pickups) do
			local var_7_7 = var_7_6:go_id(iter_7_0)
			local var_7_8 = var_7_2(var_7_0, var_7_7, "position")
			local var_7_9 = var_7_1[iter_7_0] or var_7_5(iter_7_0, 0)
			local var_7_10 = var_7_4(iter_7_0, "projectile_locomotion_system")
			local var_7_11 = var_7_10:is_at_rest() and var_0_2 or var_0_3

			if var_7_3(var_7_8, var_7_9) > var_7_11 * var_7_11 then
				local var_7_12 = var_7_2(var_7_0, var_7_7, "rotation")

				var_7_10:teleport(var_7_8, var_7_12)
			end
		end
	end
end

ProjectileLocomotionSystem.rpc_set_projectile_state = function (arg_8_0, arg_8_1, arg_8_2, arg_8_3)
	local var_8_0 = arg_8_0.unit_storage:unit(arg_8_2)

	ScriptUnit.extension(var_8_0, "projectile_locomotion_system"):set_projectile_state(var_8_0, arg_8_3)
end

ProjectileLocomotionSystem.rpc_projectile_stick_unit = function (arg_9_0, arg_9_1, arg_9_2, arg_9_3)
	local var_9_0 = arg_9_0.unit_storage:unit(arg_9_2)
	local var_9_1 = ScriptUnit.extension(var_9_0, "projectile_locomotion_system")
	local var_9_2 = arg_9_0.unit_storage:unit(arg_9_3)

	var_9_1:stick_to_unit(var_9_2)

	if arg_9_0.is_server then
		local var_9_3 = CHANNEL_TO_PEER_ID[arg_9_1]

		Managers.state.network.network_transmit:send_rpc_clients_except("rpc_projectile_stick_unit", var_9_3, arg_9_2, arg_9_3)
	end
end

ProjectileLocomotionSystem.rpc_projectile_stick_position = function (arg_10_0, arg_10_1, arg_10_2, arg_10_3)
	local var_10_0 = arg_10_0.unit_storage:unit(arg_10_2)

	ScriptUnit.extension(var_10_0, "projectile_locomotion_system"):stick_to_position(arg_10_3)

	if arg_10_0.is_server then
		local var_10_1 = CHANNEL_TO_PEER_ID[arg_10_1]

		Managers.state.network.network_transmit:send_rpc_clients_except("rpc_projectile_stick_position", var_10_1, arg_10_2, arg_10_3)
	end
end

ProjectileLocomotionSystem.rpc_hot_join_sync_projectile_sticky = function (arg_11_0, arg_11_1, arg_11_2, arg_11_3, arg_11_4)
	local var_11_0 = arg_11_0.unit_storage:unit(arg_11_2)

	if var_11_0 then
		ScriptUnit.extension(var_11_0, "projectile_locomotion_system"):hot_join_sync_projectile_sticky(arg_11_3, arg_11_4)
	end
end
