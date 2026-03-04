-- chunkname: @scripts/utils/async_level_spawner.lua

AsyncLevelSpawner = class(AsyncLevelSpawner)

function AsyncLevelSpawner.init(arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4)
	local var_1_0 = arg_1_0:_setup_world(arg_1_1)

	arg_1_0._world = var_1_0
	arg_1_0._level_name = arg_1_2
	arg_1_0._level_spawn_time_budget = arg_1_4

	local var_1_1
	local var_1_2
	local var_1_3
	local var_1_4
	local var_1_5 = true
	local var_1_6, var_1_7 = ScriptWorld.spawn_level(var_1_0, arg_1_2, arg_1_3, var_1_1, var_1_2, var_1_4, var_1_3, var_1_5)

	arg_1_0._level = var_1_7
end

function AsyncLevelSpawner.destroy(arg_2_0)
	if arg_2_0._level then
		ScriptWorld.destroy_level(arg_2_0._world, arg_2_0._level_name)

		arg_2_0._level = nil
	end

	if arg_2_0._world then
		Managers.world:destroy_world(arg_2_0._world)

		arg_2_0._world = nil
	end
end

function AsyncLevelSpawner.update(arg_3_0)
	local var_3_0 = Level.update_spawn_time_sliced(arg_3_0._level, arg_3_0._level_spawn_time_budget)

	if var_3_0 then
		local var_3_1
		local var_3_2
		local var_3_3

		var_3_3, arg_3_0._world = arg_3_0._world, var_3_1

		local var_3_4

		var_3_4, arg_3_0._level = arg_3_0._level, var_3_2

		return var_3_0, var_3_3, var_3_4
	end

	return var_3_0
end

function AsyncLevelSpawner._setup_world(arg_4_0, arg_4_1)
	local var_4_0 = 1
	local var_4_1 = {
		Application.ENABLE_UMBRA,
		Application.ENABLE_VOLUMETRICS
	}

	if Application.user_setting("disable_apex_cloth") then
		table.insert(var_4_1, Application.DISABLE_APEX_CLOTH)
	else
		table.insert(var_4_1, Application.APEX_LOD_RESOURCE_BUDGET)
		table.insert(var_4_1, Application.user_setting("apex_lod_resource_budget") or ApexClothQuality.high.apex_lod_resource_budget)
	end

	local var_4_2
	local var_4_3
	local var_4_4 = Managers.world:create_world(arg_4_1, var_4_2, var_4_3, var_4_0, unpack(var_4_1))

	ScriptWorld.deactivate(var_4_4)

	return var_4_4
end
