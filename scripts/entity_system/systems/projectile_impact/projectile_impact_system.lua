-- chunkname: @scripts/entity_system/systems/projectile_impact/projectile_impact_system.lua

require("scripts/unit_extensions/weapons/projectiles/projectile_impact/projectile_base_impact_unit_extension")
require("scripts/unit_extensions/weapons/projectiles/projectile_impact/projectile_raycast_impact_unit_extension")
require("scripts/unit_extensions/weapons/projectiles/projectile_impact/projectile_linear_sphere_sweep_impact_unit_extension")
require("scripts/unit_extensions/weapons/projectiles/projectile_impact/projectile_fixed_impact_unit_extension")
require("scripts/unit_extensions/weapons/projectiles/projectile_impact/player_projectile_impact_unit_extension")

ProjectileImpactSystem = class(ProjectileImpactSystem, ExtensionSystemBase)

local tbl = {}
local tbl_2 = {
	"ProjectileBaseImpactUnitExtension",
	"ProjectileRaycastImpactUnitExtension",
	"PlayerProjectileImpactUnitExtension",
	"ProjectileFixedImpactUnitExtension",
	"ProjectileLinearSphereSweepImpactUnitExtension"
}

ProjectileImpactSystem.init = function (self, arg_1_1, arg_1_2)
	-- function 1
	ProjectileImpactSystem.super.init(self, arg_1_1, arg_1_2, tbl_2)

	local network_event_delegate = arg_1_1.network_event_delegate

	self.network_event_delegate = network_event_delegate

	network_event_delegate:register(self, unpack(tbl))

	self.network_transmit = Managers.state.network.network_transmit
end

ProjectileImpactSystem.destroy = function (self)
	-- function 2
	self.network_event_delegate:unregister(self)

	self.network_event_delegate = nil
	self.network_transmit = nil
end
