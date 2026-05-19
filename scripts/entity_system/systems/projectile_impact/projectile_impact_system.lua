-- chunkname: @scripts/entity_system/systems/projectile_impact/projectile_impact_system.lua

require("scripts/unit_extensions/weapons/projectiles/projectile_impact/projectile_base_impact_unit_extension")
require("scripts/unit_extensions/weapons/projectiles/projectile_impact/projectile_raycast_impact_unit_extension")
require("scripts/unit_extensions/weapons/projectiles/projectile_impact/projectile_linear_sphere_sweep_impact_unit_extension")
require("scripts/unit_extensions/weapons/projectiles/projectile_impact/projectile_fixed_impact_unit_extension")
require("scripts/unit_extensions/weapons/projectiles/projectile_impact/player_projectile_impact_unit_extension")

ProjectileImpactSystem = class(ProjectileImpactSystem, ExtensionSystemBase)

local var_0_0 = {}
local var_0_1 = {
	"ProjectileBaseImpactUnitExtension",
	"ProjectileRaycastImpactUnitExtension",
	"PlayerProjectileImpactUnitExtension",
	"ProjectileFixedImpactUnitExtension",
	"ProjectileLinearSphereSweepImpactUnitExtension"
}

function ProjectileImpactSystem.init(arg_1_0, arg_1_1, arg_1_2)
	ProjectileImpactSystem.super.init(arg_1_0, arg_1_1, arg_1_2, var_0_1)

	local var_1_0 = arg_1_1.network_event_delegate

	arg_1_0.network_event_delegate = var_1_0

	var_1_0:register(arg_1_0, unpack(var_0_0))

	arg_1_0.network_transmit = Managers.state.network.network_transmit
end

function ProjectileImpactSystem.destroy(arg_2_0)
	arg_2_0.network_event_delegate:unregister(arg_2_0)

	arg_2_0.network_event_delegate = nil
	arg_2_0.network_transmit = nil
end
