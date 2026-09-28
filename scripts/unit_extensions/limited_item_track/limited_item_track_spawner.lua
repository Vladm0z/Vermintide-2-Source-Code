-- chunkname: @scripts/unit_extensions/limited_item_track/limited_item_track_spawner.lua

require("scripts/unit_extensions/limited_item_track/limited_item_track_spawner_templates")

LimitedItemTrackSpawner = class(LimitedItemTrackSpawner)

LimitedItemTrackSpawner.init = function (self, world, unit, extension_init_data)
	-- function 1
	assert(Managers.player.is_server, "Spawner should only exist on server")
	assert(extension_init_data.pool > 0, "Can't have pool less than 1")

	self.world = world
	self.unit = unit
	self.num_items = 0
	self.items = {}
	self.socketed_items = {}
	self.num_socketed_items = 0
	self.pool = extension_init_data.pool
	self.template_name = extension_init_data.template_name
	self.time_between_spawns = 2
	self.time_to_spawn = 0
	self.pool_exhausted = false
	self.network_manager = extension_init_data.network_manager

	local template_name = self.template_name
	local init_func = LimitedItemTrackSpawnerTemplates[template_name].init_func

	self.spawn_data = init_func(world, unit, extension_init_data)
end

LimitedItemTrackSpawner.extensions_ready = function (self)
	-- function 2
	Unit.flow_event(self.unit, "lua_spawner_initialized")
end

LimitedItemTrackSpawner.destroy = function (self)
	-- function 3
	return
end

LimitedItemTrackSpawner.update = function (self, unit, input, dt, context, t)
	-- function 4
	return
end

LimitedItemTrackSpawner.socket_item = function (self, unit)
	-- function 5
	local id = self:find_item_id(unit)

	self.socketed_items[id] = unit
	self.num_socketed_items = table.size(self.socketed_items)
end

LimitedItemTrackSpawner.spawn_item = function (self)
	-- function 6
	local self_unit = self.unit
	local id = self:find_empty_id()

	fassert(id, "Found no empty id")

	local spawn_data = self.spawn_data

	spawn_data.id = id

	local template_name = self.template_name
	local spawn_func = LimitedItemTrackSpawnerTemplates[template_name].spawn_func
	local unit = spawn_func(self.world, self_unit, self.spawn_data)

	self.items[id] = unit
	self.num_items = self.num_items + 1

	Unit.flow_event(self_unit, "lua_spawner_spawn_item")
end

LimitedItemTrackSpawner.find_item_id = function (self, unit)
	-- function 7
	local pool = self.pool
	local items = self.items

	for i = 1, pool do
		local item = items[i]

		if item == unit then
			return i
		end
	end
end

LimitedItemTrackSpawner.find_empty_id = function (self)
	-- function 8
	local pool = self.pool
	local items = self.items

	for i = 1, pool do
		local item = items[i]

		if not item then
			return i
		end
	end
end

LimitedItemTrackSpawner.remove = function (self, id)
	-- function 9
	local items = self.items

	if items[id] then
		items[id] = nil
		self.num_items = self.num_items - 1
		self.pool_exhausted = false
	end
end

LimitedItemTrackSpawner.transform = function (self, id)
	-- function 10
	local items = self.items

	if items[id] then
		items[id] = true
	end
end

LimitedItemTrackSpawner.is_transformed = function (self, id)
	-- function 11
	local item = self.items[id]

	if type(item) == "boolean" then
		return true
	else
		return false
	end
end

LimitedItemTrackSpawner.is_any_transformed = function (self)
	-- function 12
	local pool = self.pool
	local items = self.items

	for i = 1, pool do
		if self:is_transformed(i) then
			return true
		end
	end

	return false
end

LimitedItemTrackSpawner.is_any_item_spawned = function (self)
	-- function 13
	local pool = self.pool
	local items = self.items

	return #items > 0
end
