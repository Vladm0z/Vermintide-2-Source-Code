-- chunkname: @scripts/unit_extensions/weapons/projectiles/projectile_impact/projectile_base_impact_unit_extension.lua

ProjectileBaseImpactUnitExtension = class(ProjectileBaseImpactUnitExtension)
ProjectileImpactDataIndex = {
	POSITION = 2,
	ACTOR_INDEX = 5,
	UNIT = 1,
	STRIDE = 5,
	DIRECTION = 3,
	NORMAL = 4
}

ProjectileBaseImpactUnitExtension.init = function (self, arg_1_1, arg_1_2, arg_1_3)
	-- function 1
	local world = arg_1_1.world

	self.world = world
	self.unit = arg_1_2
	self.physics_world = World.get_data(world, "physics_world")
	self.impact_buffer = pdArray.new()
end

ProjectileBaseImpactUnitExtension.update = function (self, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5)
	-- function 2
	pdArray.set_empty(self.impact_buffer)
end

local tbl = {}

ProjectileBaseImpactUnitExtension.impact = function (self, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5)
	-- function 3
	local impact_buffer = self.impact_buffer

	tbl[ProjectileImpactDataIndex.UNIT] = arg_3_1
	tbl[ProjectileImpactDataIndex.POSITION] = Vector3Box(arg_3_2)
	tbl[ProjectileImpactDataIndex.DIRECTION] = Vector3Box(arg_3_3)
	tbl[ProjectileImpactDataIndex.NORMAL] = Vector3Box(arg_3_4)
	tbl[ProjectileImpactDataIndex.ACTOR_INDEX] = arg_3_5

	pdArray.push_back5(impact_buffer, unpack(tbl))

	if Unit.actor(arg_3_1, arg_3_5) == nil then
		print("hitting pickup?")
		print(arg_3_5)
		print(Unit.find_actor(arg_3_1, "c_afro"))
	end
end

ProjectileBaseImpactUnitExtension.recent_impacts = function (self)
	-- function 4
	return pdArray.data(self.impact_buffer)
end
