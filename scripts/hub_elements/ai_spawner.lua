-- chunkname: @scripts/hub_elements/ai_spawner.lua

require("scripts/settings/breeds")

AISpawner = class(AISpawner)
AI_TEST_COUNTER = 0

AISpawner.init = function (self, world, unit)
	-- function 1
	self._spawner_system = Managers.state.entity:system("spawner_system")
	self._config = {}
	self._breed_list = {}
	self._world = world
	self._unit = unit
	self._num_queued_units = 0
	self._next_spawn = 0
	self._max_amount = 0
	self._spawned_units = {}
	self._spawned_unit_handles = {}
	self._activate_version = 0

	if Unit.has_data(unit, "spawner_settings") then
		local spawner_name = self:check_for_enabled()

		if spawner_name ~= nil then
			local terror_event_id = Unit.get_data(unit, "terror_event_id")

			terror_event_id = not not terror_event_id and terror_event_id ~= "" and not not terror_event_id

			local hidden = Unit.get_data(unit, "hidden")

			self._spawner_system:register_enabled_spawner(unit, terror_event_id, hidden)

			local i = 0
			local animation_events = {}

			while Unit.has_data(unit, "spawner_settings", spawner_name, "animation_events", i) do
				animation_events[#animation_events + 1] = Unit.get_data(unit, "spawner_settings", spawner_name, "animation_events", i)
				i = i + 1
			end

			self._config = {
				name = spawner_name,
				animation_events = animation_events,
				node = Unit.get_data(unit, "spawner_settings", spawner_name, "node"),
				spawn_rate = Unit.get_data(unit, "spawner_settings", spawner_name, "spawn_rate")
			}
		end
	else
		local terror_event_id = Unit.get_data(self._unit, "terror_event_id")

		terror_event_id = not not terror_event_id and terror_event_id ~= "" and not not terror_event_id

		self._spawner_system:register_raw_spawner(self._unit, terror_event_id)
	end
end

AISpawner.check_for_enabled = function (self)
	-- function 2
	local i = 1
	local name = "spawner"

	repeat
		name = "spawner" .. i

		if Unit.has_data(self._unit, "spawner_settings", name) then
			if Unit.get_data(self._unit, "spawner_settings", name, "enabled") then
				return name
			end
		else
			return nil
		end

		i = i + 1
	until true
end

AISpawner.on_activate = function (self, breed_list, side_id, group_template, optional_data)
	-- function 3
	table.clear(self._spawned_unit_handles)
	table.clear(self._spawned_units)

	self._activate_version = self._activate_version + 1

	local spawn_data = {
		side_id,
		group_template,
		optional_data
	}
	local list = self._breed_list
	local size = #list

	self._max_amount = self._max_amount + #breed_list

	local j = size + 1

	for i = 1, #breed_list do
		list[j] = breed_list[i]
		j = j + 1
		list[j] = spawn_data
		j = j + 1
	end
end

AISpawner.on_deactivate = function (self)
	-- function 4
	self._max_amount = 0
	self._num_queued_units = 0

	self._spawner_system:deactivate_spawner(self._unit)
	table.clear(self._breed_list)
end

AISpawner.update = function (self, unit, input, dt, context, t)
	-- function 5
	if t > self._next_spawn then
		if self._num_queued_units < self._max_amount then
			self:spawn_unit()

			self._next_spawn = t + 1 / self._config.spawn_rate
		elseif self:done_spawning() then
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
	local breed_list = self._breed_list
	local last = #breed_list
	local spawn_data = breed_list[last]

	breed_list[last] = nil
	last = last - 1

	local breed_name = breed_list[last]

	breed_list[last] = nil

	local breed = Breeds[breed_name]
	local unit = self._unit

	Unit.flow_event(unit, "lua_spawn")

	local conflict_director = Managers.state.conflict
	local spawn_category = "ai_spawner"
	local node = Unit.node(unit, self._config.node)
	local parent_index = Unit.scene_graph_parent(unit, node)
	local parent_world_rotation = Unit.world_rotation(unit, parent_index)
	local spawn_node_rotation = Unit.local_rotation(unit, node)
	local spawn_rotation = Quaternion.multiply(parent_world_rotation, spawn_node_rotation)
	local str

	if Unit.get_data(self._unit, "hidden") then
		str = "horde_hidden"

		goto label_9_0
	end

	str = "horde"

	local spawn_type = str

	::label_9_0::

	local spawn_pos = Unit.world_position(unit, node)
	local animation_events = self._config.animation_events

	if spawn_type == "horde_hidden" and breed.use_regular_horde_spawning then
		spawn_type = "horde"
	end

	local spawn_animation = spawn_type == "horde" and not not animation_events[math.random(#animation_events)]
	local side_id = spawn_data[1]
	local var_9_1 = spawn_data[3]

	if not var_9_1 then
		-- Nothing
	end

	var_9_1 = {}

	local optional_data = var_9_1

	::label_9_1::

	optional_data.side_id = side_id

	local activate_version = self._activate_version
	local spawned_func = optional_data.spawned_func

	if spawned_func then
		optional_data.spawned_func = function (spawned_unit, ...)
			-- function 10
			spawned_func(spawned_unit, ...)

			if activate_version == self._activate_version then
				self._spawned_units[#self._spawned_units + 1] = spawned_unit
			end
		end
	end

	local group_template = spawn_data[2]

	self._num_queued_units = self._num_queued_units + 1
	self._spawned_unit_handles[self._num_queued_units] = conflict_director:spawn_queued_unit(breed, Vector3Box(spawn_pos), QuaternionBox(spawn_rotation), spawn_category, spawn_animation, spawn_type, optional_data, group_template)

	conflict_director:add_horde(1)
end

AISpawner.spawn_rotation = function (self)
	-- function 11
	local unit = self._unit

	return Unit.world_rotation(unit, Unit.node(unit, self._config.node))
end

AISpawner.spawn_position = function (self)
	-- function 12
	local unit = self._unit

	return Unit.world_position(unit, Unit.node(unit, self._config.node))
end

AISpawner.get_spawner_name = function (self)
	-- function 13
	return self._config.name
end

AISpawner.destroy = function (self)
	-- function 14
	return
end
