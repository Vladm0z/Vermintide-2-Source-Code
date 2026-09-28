-- chunkname: @scripts/managers/decal/decal_manager.lua

require("scripts/settings/decal_settings")

DecalManager = class(DecalManager)

DecalManager.init = function (self, world)
	-- function 1
	self._decal_system = EngineOptimizedManagers.decal_manager_init(self._decal_system, world)

	for pool_name, setting in pairs(DecalSettings) do
		EngineOptimizedManagers.decal_manager_add_setting(self._decal_system, pool_name, setting.life_time, setting.pool_size, unpack(setting.units))
	end
end

DecalManager.destroy = function (self)
	-- function 2
	EngineOptimizedManagers.decal_manager_destroy(self._decal_system)
end

DecalManager.add_projection_decal = function (self, unit_name, hit_unit, hit_actor, position, rotation, extents, normal)
	-- function 3
	local t = Managers.time:time("game")

	EngineOptimizedManagers.decal_manager_add_decal(self._decal_system, unit_name, position, rotation, normal, extents, hit_actor, hit_unit, t)
end

DecalManager.update = function (self, dt, t)
	-- function 4
	EngineOptimizedManagers.decal_manager_update(self._decal_system, t)
end

DecalManager.clear_all_of_type = function (self, pool_name)
	-- function 5
	EngineOptimizedManagers.decal_manager_clear_all_of_type(self._decal_system, pool_name)
end

DecalManager.move_decals = function (self, from_unit, to_unit)
	-- function 6
	EngineOptimizedManagers.decal_manager_move_decals(self._decal_system, from_unit, to_unit)
end
