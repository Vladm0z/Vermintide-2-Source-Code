-- chunkname: @scripts/managers/decal/decal_manager.lua

require("scripts/settings/decal_settings")

DecalManager = class(DecalManager)

DecalManager.init = function (self, arg_1_1)
	-- function 1
	self._decal_system = EngineOptimizedManagers.decal_manager_init(self._decal_system, arg_1_1)

	for k, v in pairs(DecalSettings) do
		EngineOptimizedManagers.decal_manager_add_setting(self._decal_system, k, v.life_time, v.pool_size, unpack(v.units))
	end
end

DecalManager.destroy = function (self)
	-- function 2
	EngineOptimizedManagers.decal_manager_destroy(self._decal_system)
end

DecalManager.add_projection_decal = function (self, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5, arg_3_6, arg_3_7)
	-- function 3
	local time = Managers.time:time("game")

	EngineOptimizedManagers.decal_manager_add_decal(self._decal_system, arg_3_1, arg_3_4, arg_3_5, arg_3_7, arg_3_6, arg_3_3, arg_3_2, time)
end

DecalManager.update = function (self, arg_4_1, arg_4_2)
	-- function 4
	EngineOptimizedManagers.decal_manager_update(self._decal_system, arg_4_2)
end

DecalManager.clear_all_of_type = function (self, arg_5_1)
	-- function 5
	EngineOptimizedManagers.decal_manager_clear_all_of_type(self._decal_system, arg_5_1)
end

DecalManager.move_decals = function (self, arg_6_1, arg_6_2)
	-- function 6
	EngineOptimizedManagers.decal_manager_move_decals(self._decal_system, arg_6_1, arg_6_2)
end
