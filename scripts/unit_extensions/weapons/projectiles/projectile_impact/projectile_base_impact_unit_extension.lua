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

ProjectileBaseImpactUnitExtension.init = function (self, extension_init_context, unit, extension_init_data)
	-- function 1
	local world = extension_init_context.world

	self.world = world
	self.unit = unit
	self.physics_world = World.get_data(world, "physics_world")
	self.impact_buffer = pdArray.new()
end

ProjectileBaseImpactUnitExtension.update = function (self, unit, input, dt, context, t)
	-- function 2
	pdArray.set_empty(self.impact_buffer)
end

local temp_table = {}

ProjectileBaseImpactUnitExtension.impact = function (self, hit_unit, hit_position, hit_direction, hit_normal, hit_actor_index)
	-- function 3
	local impact_buffer = self.impact_buffer

	temp_table[ProjectileImpactDataIndex.UNIT] = hit_unit
	temp_table[ProjectileImpactDataIndex.POSITION] = Vector3Box(hit_position)
	temp_table[ProjectileImpactDataIndex.DIRECTION] = Vector3Box(hit_direction)
	temp_table[ProjectileImpactDataIndex.NORMAL] = Vector3Box(hit_normal)
	temp_table[ProjectileImpactDataIndex.ACTOR_INDEX] = hit_actor_index

	pdArray.push_back5(impact_buffer, unpack(temp_table))

	if Unit.actor(hit_unit, hit_actor_index) == nil then
		print("hitting pickup?")
		print(hit_actor_index)
		print(Unit.find_actor(hit_unit, "c_afro"))
	end
end

ProjectileBaseImpactUnitExtension.recent_impacts = function (self)
	-- function 4
	return pdArray.data(self.impact_buffer)
end
