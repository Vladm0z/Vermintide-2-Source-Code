-- chunkname: @scripts/managers/decal/decal_manager.lua

require("scripts/settings/decal_settings")

DecalManager = class(DecalManager)

DecalManager.init = function (arg_1_0, arg_1_1)
	arg_1_0._decal_system = EngineOptimizedManagers.decal_manager_init(arg_1_0._decal_system, arg_1_1)

	for iter_1_0, iter_1_1 in pairs(DecalSettings) do
		EngineOptimizedManagers.decal_manager_add_setting(arg_1_0._decal_system, iter_1_0, iter_1_1.life_time, iter_1_1.pool_size, unpack(iter_1_1.units))
	end
end

DecalManager.destroy = function (arg_2_0)
	EngineOptimizedManagers.decal_manager_destroy(arg_2_0._decal_system)
end

DecalManager.add_projection_decal = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5, arg_3_6, arg_3_7)
	local var_3_0 = Managers.time:time("game")

	EngineOptimizedManagers.decal_manager_add_decal(arg_3_0._decal_system, arg_3_1, arg_3_4, arg_3_5, arg_3_7, arg_3_6, arg_3_3, arg_3_2, var_3_0)
end

DecalManager.update = function (arg_4_0, arg_4_1, arg_4_2)
	EngineOptimizedManagers.decal_manager_update(arg_4_0._decal_system, arg_4_2)
end

DecalManager.clear_all_of_type = function (arg_5_0, arg_5_1)
	EngineOptimizedManagers.decal_manager_clear_all_of_type(arg_5_0._decal_system, arg_5_1)
end

DecalManager.move_decals = function (arg_6_0, arg_6_1, arg_6_2)
	EngineOptimizedManagers.decal_manager_move_decals(arg_6_0._decal_system, arg_6_1, arg_6_2)
end
