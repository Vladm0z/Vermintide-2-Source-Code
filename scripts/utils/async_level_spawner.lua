-- chunkname: @scripts/utils/async_level_spawner.lua

AsyncLevelSpawner = class(AsyncLevelSpawner)

AsyncLevelSpawner.init = function (self, arg_1_1, arg_1_2, arg_1_3, arg_1_4)
	-- function 1
	local _setup_world = self:_setup_world(arg_1_1)

	self._world = _setup_world
	self._level_name = arg_1_2
	self._level_spawn_time_budget = arg_1_4

	local var_1_1
	local var_1_2
	local var_1_3
	local var_1_4
	local flag = true
	local spawn_level, var_1_7 = ScriptWorld.spawn_level(_setup_world, arg_1_2, arg_1_3, var_1_1, var_1_2, var_1_4, var_1_3, flag)

	self._level = var_1_7
end

AsyncLevelSpawner.destroy = function (self)
	-- function 2
	if not self._level then
		ScriptWorld.destroy_level(self._world, self._level_name)

		self._level = nil
	end

	if not self._world then
		Managers.world:destroy_world(self._world)

		self._world = nil
	end
end

AsyncLevelSpawner.update = function (self)
	-- function 3
	local update_spawn_time_sliced = Level.update_spawn_time_sliced(self._level, self._level_spawn_time_budget)

	if not update_spawn_time_sliced then
		local var_3_1
		local var_3_2
		local _world

		_world, self._world = self._world, var_3_1

		local _level

		_level, self._level = self._level, var_3_2

		return update_spawn_time_sliced, _world, _level
	end

	return update_spawn_time_sliced
end

AsyncLevelSpawner._setup_world = function (arg_4_0, arg_4_1)
	-- function 4
	local num = 1
	local tbl = {
		Application.ENABLE_UMBRA,
		Application.ENABLE_VOLUMETRICS
	}

	if not Application.user_setting("disable_apex_cloth") then
		table.insert(tbl, Application.DISABLE_APEX_CLOTH)
	else
		table.insert(tbl, Application.APEX_LOD_RESOURCE_BUDGET)

		local insert = table.insert
		local var_4_3 = tbl
		local user_setting = Application.user_setting("apex_lod_resource_budget")

		user_setting = user_setting or ApexClothQuality.high.apex_lod_resource_budget

		insert(var_4_3, user_setting)
	end

	local var_4_5
	local var_4_6
	local create_world = Managers.world:create_world(arg_4_1, var_4_5, var_4_6, num, unpack(tbl))

	ScriptWorld.deactivate(create_world)

	return create_world
end
