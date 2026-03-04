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

function ProjectileBaseImpactUnitExtension.init(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
	local var_1_0 = arg_1_1.world

	arg_1_0.world = var_1_0
	arg_1_0.unit = arg_1_2
	arg_1_0.physics_world = World.get_data(var_1_0, "physics_world")
	arg_1_0.impact_buffer = pdArray.new()
end

function ProjectileBaseImpactUnitExtension.update(arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5)
	pdArray.set_empty(arg_2_0.impact_buffer)
end

local var_0_0 = {}

function ProjectileBaseImpactUnitExtension.impact(arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5)
	local var_3_0 = arg_3_0.impact_buffer

	var_0_0[ProjectileImpactDataIndex.UNIT] = arg_3_1
	var_0_0[ProjectileImpactDataIndex.POSITION] = Vector3Box(arg_3_2)
	var_0_0[ProjectileImpactDataIndex.DIRECTION] = Vector3Box(arg_3_3)
	var_0_0[ProjectileImpactDataIndex.NORMAL] = Vector3Box(arg_3_4)
	var_0_0[ProjectileImpactDataIndex.ACTOR_INDEX] = arg_3_5

	pdArray.push_back5(var_3_0, unpack(var_0_0))

	if Unit.actor(arg_3_1, arg_3_5) == nil then
		print("hitting pickup?")
		print(arg_3_5)
		print(Unit.find_actor(arg_3_1, "c_afro"))
	end
end

function ProjectileBaseImpactUnitExtension.recent_impacts(arg_4_0)
	return pdArray.data(arg_4_0.impact_buffer)
end
