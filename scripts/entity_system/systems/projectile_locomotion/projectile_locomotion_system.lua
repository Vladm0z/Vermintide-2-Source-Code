-- chunkname: @scripts/entity_system/systems/projectile_locomotion/projectile_locomotion_system.lua

require("scripts/unit_extensions/weapons/projectiles/projectile_physics_husk_locomotion_extension")
require("scripts/unit_extensions/weapons/projectiles/projectile_physics_unit_locomotion_extension")
require("scripts/unit_extensions/weapons/projectiles/projectile_script_unit_locomotion_extension")
require("scripts/unit_extensions/weapons/projectiles/projectile_sticky_locomotion")

ProjectileLocomotionSystem = class(ProjectileLocomotionSystem, ExtensionSystemBase)

local tbl = {
	"rpc_set_projectile_state",
	"rpc_projectile_stick_unit",
	"rpc_projectile_stick_position",
	"rpc_hot_join_sync_projectile_sticky"
}
local tbl_2 = {
	"ProjectilePhysicsHuskLocomotionExtension",
	"ProjectilePhysicsUnitLocomotionExtension",
	"ProjectileScriptUnitLocomotionExtension",
	"ProjectileTrueFlightLocomotionExtension",
	"ProjectileHomingSkullLocomotionExtension",
	"ProjectileExtrapolatedHuskLocomotionExtension",
	"ProjectileStickyLocomotion",
	"ProjectileEtherealSkullLocomotionExtension"
}

ProjectileLocomotionSystem.init = function (self, arg_1_1, arg_1_2)
	-- function 1
	ProjectileLocomotionSystem.super.init(self, arg_1_1, arg_1_2, tbl_2)

	local network_event_delegate = arg_1_1.network_event_delegate

	self.network_event_delegate = network_event_delegate

	network_event_delegate:register(self, unpack(tbl))

	self._server_position_corrected_pickups = {}
end

ProjectileLocomotionSystem.on_add_extension = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4, ...)
	-- function 2
	if not (arg_2_3 == "ProjectilePhysicsHuskLocomotionExtension" or arg_2_3 ~= "ProjectilePhysicsUnitLocomotionExtension") then
		arg_2_0._server_position_corrected_pickups[arg_2_2] = arg_2_2
	end

	return ProjectileLocomotionSystem.super.on_add_extension(arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4, ...)
end

ProjectileLocomotionSystem.on_remove_extension = function (arg_3_0, arg_3_1, arg_3_2, ...)
	-- function 3
	arg_3_0._server_position_corrected_pickups[arg_3_1] = nil

	return ProjectileLocomotionSystem.super.on_remove_extension(arg_3_0, arg_3_1, arg_3_2, ...)
end

ProjectileLocomotionSystem.update = function (self, arg_4_1, arg_4_2)
	-- function 4
	ProjectileLocomotionSystem.super.update(self, arg_4_1, arg_4_2)

	if not self.is_server then
		self:_server_sync_position_rotation(arg_4_1, arg_4_2)
	else
		self:_client_validate_position_rotation(arg_4_1, arg_4_2)
	end
end

ProjectileLocomotionSystem.destroy = function (self)
	-- function 5
	self.network_event_delegate:unregister(self)
end

ProjectileLocomotionSystem._server_sync_position_rotation = function (self, arg_6_1, arg_6_2)
	-- function 6
	local game = Managers.state.network:game()

	if not game then
		local POSITION_LOOKUP = POSITION_LOOKUP
		local set_game_object_field = GameSession.set_game_object_field
		local unit_storage = Managers.state.unit_storage
		local local_rotation = Unit.local_rotation
		local min = NetworkConstants.position.min
		local max = NetworkConstants.position.max

		for k, v in pairs(self._server_position_corrected_pickups) do
			local go_id = unit_storage:go_id(k)
			local clamp = Vector3.clamp(POSITION_LOOKUP[k], min, max)
			local var_6_9 = local_rotation(k, 0)

			set_game_object_field(game, go_id, "position", clamp)
			set_game_object_field(game, go_id, "rotation", var_6_9)
		end
	end
end

local num = 0.05
local num_2 = 5

ProjectileLocomotionSystem._client_validate_position_rotation = function (self, arg_7_1, arg_7_2)
	-- function 7
	local game = Managers.state.network:game()

	if not game then
		local POSITION_LOOKUP = POSITION_LOOKUP
		local game_object_field = GameSession.game_object_field
		local distance_squared = Vector3.distance_squared
		local extension = ScriptUnit.extension
		local local_position = Unit.local_position
		local unit_storage = Managers.state.unit_storage

		for k, v in pairs(self._server_position_corrected_pickups) do
			local go_id = unit_storage:go_id(k)
			local var_7_8 = game_object_field(game, go_id, "position")
			local var_7_9 = POSITION_LOOKUP[k]

			var_7_9 = var_7_9 or local_position(k, 0)

			local var_7_10 = extension(k, "projectile_locomotion_system")
			local var_7_11

			if not var_7_10:is_at_rest() then
				var_7_11 = num

				if not var_7_11 then
					-- Nothing
				end
			end

			var_7_11 = num_2

			::label_7_0::

			if distance_squared(var_7_8, var_7_9) > var_7_11 * var_7_11 then
				local var_7_12 = game_object_field(game, go_id, "rotation")

				var_7_10:teleport(var_7_8, var_7_12)
			end
		end
	end
end

ProjectileLocomotionSystem.rpc_set_projectile_state = function (self, arg_8_1, arg_8_2, arg_8_3)
	-- function 8
	local unit = self.unit_storage:unit(arg_8_2)

	ScriptUnit.extension(unit, "projectile_locomotion_system"):set_projectile_state(unit, arg_8_3)
end

ProjectileLocomotionSystem.rpc_projectile_stick_unit = function (self, arg_9_1, arg_9_2, arg_9_3)
	-- function 9
	local unit = self.unit_storage:unit(arg_9_2)
	local extension = ScriptUnit.extension(unit, "projectile_locomotion_system")
	local unit_2 = self.unit_storage:unit(arg_9_3)

	extension:stick_to_unit(unit_2)

	if not self.is_server then
		local var_9_3 = CHANNEL_TO_PEER_ID[arg_9_1]

		Managers.state.network.network_transmit:send_rpc_clients_except("rpc_projectile_stick_unit", var_9_3, arg_9_2, arg_9_3)
	end
end

ProjectileLocomotionSystem.rpc_projectile_stick_position = function (self, arg_10_1, arg_10_2, arg_10_3)
	-- function 10
	local unit = self.unit_storage:unit(arg_10_2)

	ScriptUnit.extension(unit, "projectile_locomotion_system"):stick_to_position(arg_10_3)

	if not self.is_server then
		local var_10_1 = CHANNEL_TO_PEER_ID[arg_10_1]

		Managers.state.network.network_transmit:send_rpc_clients_except("rpc_projectile_stick_position", var_10_1, arg_10_2, arg_10_3)
	end
end

ProjectileLocomotionSystem.rpc_hot_join_sync_projectile_sticky = function (self, arg_11_1, arg_11_2, arg_11_3, arg_11_4)
	-- function 11
	local unit = self.unit_storage:unit(arg_11_2)

	if not unit then
		ScriptUnit.extension(unit, "projectile_locomotion_system"):hot_join_sync_projectile_sticky(arg_11_3, arg_11_4)
	end
end
