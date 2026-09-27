-- chunkname: @scripts/unit_extensions/weapons/projectiles/projectile_linker_extension.lua

ProjectileLinkerExtension = class(ProjectileLinkerExtension)

ProjectileLinkerExtension.init = function (self, arg_1_1, arg_1_2, arg_1_3)
	-- function 1
	self._world = arg_1_1.world
	self._owner_unit = arg_1_2
	self.linked_projectiles = {}
end

ProjectileLinkerExtension.extensions_ready = function (arg_2_0)
	-- function 2
	return
end

ProjectileLinkerExtension.link_projectile = function (self, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
	-- function 3
	local _owner_unit = self._owner_unit
	local _world = self._world
	local world_rotation = Unit.world_rotation(_owner_unit, arg_3_4)
	local multiply = Quaternion.multiply(Quaternion.inverse(world_rotation), arg_3_3)

	World.link_unit(_world, arg_3_1, 0, _owner_unit, arg_3_4)
	Unit.set_local_position(arg_3_1, 0, arg_3_2)
	Unit.set_local_rotation(arg_3_1, 0, multiply)
	World.update_unit(_world, arg_3_1)

	self.linked_projectiles[#self.linked_projectiles + 1] = arg_3_1
end

ProjectileLinkerExtension.unlink_projectile = function (self, arg_4_1)
	-- function 4
	if not Unit.alive(arg_4_1) then
		return
	end

	if table.index_of(self.linked_projectiles, arg_4_1) == -1 then
		return
	end

	local _world = self._world

	World.unlink_unit(_world, arg_4_1)

	if not Unit.find_actor(arg_4_1, "throw") then
		Unit.create_actor(arg_4_1, "throw")
	end

	Unit.set_local_position(arg_4_1, 0, Unit.world_position(arg_4_1, 0))
	Unit.set_local_rotation(arg_4_1, 0, Unit.world_rotation(arg_4_1, 0))
	World.update_unit(_world, arg_4_1)
	table.remove(self.linked_projectiles, table.index_of(self.linked_projectiles, arg_4_1))
end

ProjectileLinkerExtension.destroy = function (arg_5_0)
	-- function 5
	return
end
