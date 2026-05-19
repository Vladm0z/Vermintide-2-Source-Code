-- chunkname: @scripts/unit_extensions/weapons/projectiles/projectile_linker_extension.lua

ProjectileLinkerExtension = class(ProjectileLinkerExtension)

function ProjectileLinkerExtension.init(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
	arg_1_0._world = arg_1_1.world
	arg_1_0._owner_unit = arg_1_2
	arg_1_0.linked_projectiles = {}
end

function ProjectileLinkerExtension.extensions_ready(arg_2_0)
	return
end

function ProjectileLinkerExtension.link_projectile(arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
	local var_3_0 = arg_3_0._owner_unit
	local var_3_1 = arg_3_0._world
	local var_3_2 = Unit.world_rotation(var_3_0, arg_3_4)
	local var_3_3 = Quaternion.multiply(Quaternion.inverse(var_3_2), arg_3_3)

	World.link_unit(var_3_1, arg_3_1, 0, var_3_0, arg_3_4)
	Unit.set_local_position(arg_3_1, 0, arg_3_2)
	Unit.set_local_rotation(arg_3_1, 0, var_3_3)
	World.update_unit(var_3_1, arg_3_1)

	arg_3_0.linked_projectiles[#arg_3_0.linked_projectiles + 1] = arg_3_1
end

function ProjectileLinkerExtension.unlink_projectile(arg_4_0, arg_4_1)
	if not Unit.alive(arg_4_1) then
		return
	end

	if table.index_of(arg_4_0.linked_projectiles, arg_4_1) == -1 then
		return
	end

	local var_4_0 = arg_4_0._world

	World.unlink_unit(var_4_0, arg_4_1)

	if Unit.find_actor(arg_4_1, "throw") then
		Unit.create_actor(arg_4_1, "throw")
	end

	Unit.set_local_position(arg_4_1, 0, Unit.world_position(arg_4_1, 0))
	Unit.set_local_rotation(arg_4_1, 0, Unit.world_rotation(arg_4_1, 0))
	World.update_unit(var_4_0, arg_4_1)
	table.remove(arg_4_0.linked_projectiles, table.index_of(arg_4_0.linked_projectiles, arg_4_1))
end

function ProjectileLinkerExtension.destroy(arg_5_0)
	return
end
