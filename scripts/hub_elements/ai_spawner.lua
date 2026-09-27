-- chunkname: @scripts/hub_elements/ai_spawner.lua

require("scripts/settings/breeds")

AISpawner = class(AISpawner)
AI_TEST_COUNTER = 0

AISpawner.init = function (self, arg_1_1, arg_1_2)
	-- function 1
	self._spawner_system = Managers.state.entity:system("spawner_system")
	self._config = {}
	self._breed_list = {}
	self._world = arg_1_1
	self._unit = arg_1_2
	self._num_queued_units = 0
	self._next_spawn = 0
	self._max_amount = 0
	self._spawned_units = {}
	self._spawned_unit_handles = {}
	self._activate_version = 0

	if not Unit.has_data(arg_1_2, "spawner_settings") then
		local check_for_enabled = self:check_for_enabled()

		if check_for_enabled ~= nil then
			local get_data = Unit.get_data(arg_1_2, "terror_event_id")

			get_data = not get_data and get_data == "" or get_data

			local get_data_2 = Unit.get_data(arg_1_2, "hidden")

			self._spawner_system:register_enabled_spawner(arg_1_2, get_data, get_data_2)

			local num = 0
			local tbl = {}

			while not Unit.has_data(arg_1_2, "spawner_settings", check_for_enabled, "animation_events", num) do
				tbl[#tbl + 1] = Unit.get_data(arg_1_2, "spawner_settings", check_for_enabled, "animation_events", num)
				num = num + 1
			end

			self._config = {
				name = check_for_enabled,
				animation_events = tbl,
				node = Unit.get_data(arg_1_2, "spawner_settings", check_for_enabled, "node"),
				spawn_rate = Unit.get_data(arg_1_2, "spawner_settings", check_for_enabled, "spawn_rate")
			}
		end
	else
		local get_data_3 = Unit.get_data(self._unit, "terror_event_id")

		get_data_3 = not get_data_3 and get_data_3 == "" or get_data_3

		self._spawner_system:register_raw_spawner(self._unit, get_data_3)
	end
end

AISpawner.check_for_enabled = function (self)
	-- function 2
	local num = 1
	local str = "spawner"

	repeat
		local str_2 = "spawner" .. num

		if not Unit.has_data(self._unit, "spawner_settings", str_2) then
			if not Unit.get_data(self._unit, "spawner_settings", str_2, "enabled") then
				return str_2
			end
		else
			return nil
		end

		num = num + 1
	until true
end

AISpawner.on_activate = function (self, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
	-- function 3
	table.clear(self._spawned_unit_handles)
	table.clear(self._spawned_units)

	self._activate_version = self._activate_version + 1

	local tbl = {
		arg_3_2,
		arg_3_3,
		arg_3_4
	}
	local _breed_list = self._breed_list
	local count = #_breed_list

	self._max_amount = self._max_amount + #arg_3_1

	local num = count + 1

	for i = 1, #arg_3_1 do
		_breed_list[num] = arg_3_1[i]
		num = num + 1
		_breed_list[num] = tbl
		num = num + 1
	end
end

AISpawner.on_deactivate = function (self)
	-- function 4
	self._max_amount = 0
	self._num_queued_units = 0

	self._spawner_system:deactivate_spawner(self._unit)
	table.clear(self._breed_list)
end

AISpawner.update = function (self, arg_5_1, arg_5_2, arg_5_3, arg_5_4, arg_5_5)
	-- function 5
	if arg_5_5 > self._next_spawn then
		if self._num_queued_units < self._max_amount then
			self:spawn_unit()

			self._next_spawn = arg_5_5 + 1 / self._config.spawn_rate
		elseif not self:done_spawning() then
			Unit.flow_event(self._unit, "lua_all_units_spawned")
			self:on_deactivate()
		end
	end
end

AISpawner.done_spawning = function (self)
	-- function 6
	return #self._spawned_units == self._max_amount
end

AISpawner.spawned_units = function (self)
	-- function 7
	return self._spawned_units
end

AISpawner.spawn_rate = function (self)
	-- function 8
	return self._config.spawn_rate
end

AISpawner.spawn_unit = function (self)
	-- function 9
	local _breed_list = self._breed_list
	local count = #_breed_list
	local var_9_2 = _breed_list[count]

	_breed_list[count] = nil

	local num = count - 1
	local var_9_4 = _breed_list[num]

	_breed_list[num] = nil

	local var_9_5 = Breeds[var_9_4]
	local _unit = self._unit

	Unit.flow_event(_unit, "lua_spawn")

	local conflict = Managers.state.conflict
	local str = "ai_spawner"
	local node = Unit.node(_unit, self._config.node)
	local scene_graph_parent = Unit.scene_graph_parent(_unit, node)
	local world_rotation = Unit.world_rotation(_unit, scene_graph_parent)
	local local_rotation = Unit.local_rotation(_unit, node)
	local multiply = Quaternion.multiply(world_rotation, local_rotation)
	local flag

	flag = not Unit.get_data(self._unit, "hidden") and "horde_hidden" and "horde"

	local world_position = Unit.world_position(_unit, node)
	local animation_events = self._config.animation_events

	if flag ~= "horde_hidden" or not var_9_5.use_regular_horde_spawning then
		flag = "horde"
	end

	local flag_2 = flag ~= "horde" or animation_events[math.random(#animation_events)]
	local var_9_18 = var_9_2[1]
	local var_9_19 = var_9_2[3]

	var_9_19 = var_9_19 or {}
	var_9_19.side_id = var_9_18

	local _activate_version = self._activate_version
	local spawned_func = var_9_19.spawned_func

	if not spawned_func then
		var_9_19.spawned_func = function (arg_10_0, ...)
			-- function 10
			spawned_func(arg_10_0, ...)

			if _activate_version == self._activate_version then
				self._spawned_units[#self._spawned_units + 1] = arg_10_0
			end
		end
	end

	local var_9_22 = var_9_2[2]

	self._num_queued_units = self._num_queued_units + 1
	self._spawned_unit_handles[self._num_queued_units] = conflict:spawn_queued_unit(var_9_5, Vector3Box(world_position), QuaternionBox(multiply), str, flag_2, flag, var_9_19, var_9_22)

	conflict:add_horde(1)
end

AISpawner.spawn_rotation = function (self)
	-- function 11
	local _unit = self._unit

	return Unit.world_rotation(_unit, Unit.node(_unit, self._config.node))
end

AISpawner.spawn_position = function (self)
	-- function 12
	local _unit = self._unit

	return Unit.world_position(_unit, Unit.node(_unit, self._config.node))
end

AISpawner.get_spawner_name = function (self)
	-- function 13
	return self._config.name
end

AISpawner.destroy = function (arg_14_0)
	-- function 14
	return
end
