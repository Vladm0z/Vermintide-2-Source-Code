-- chunkname: @scripts/unit_extensions/limited_item_track/limited_item_track_spawner.lua

require("scripts/unit_extensions/limited_item_track/limited_item_track_spawner_templates")

LimitedItemTrackSpawner = class(LimitedItemTrackSpawner)

LimitedItemTrackSpawner.init = function (self, arg_1_1, arg_1_2, arg_1_3)
	-- function 1
	assert(Managers.player.is_server, "Spawner should only exist on server")
	assert(arg_1_3.pool > 0, "Can't have pool less than 1")

	self.world = arg_1_1
	self.unit = arg_1_2
	self.num_items = 0
	self.items = {}
	self.socketed_items = {}
	self.num_socketed_items = 0
	self.pool = arg_1_3.pool
	self.template_name = arg_1_3.template_name
	self.time_between_spawns = 2
	self.time_to_spawn = 0
	self.pool_exhausted = false
	self.network_manager = arg_1_3.network_manager

	local template_name = self.template_name

	self.spawn_data = LimitedItemTrackSpawnerTemplates[template_name].init_func(arg_1_1, arg_1_2, arg_1_3)
end

LimitedItemTrackSpawner.extensions_ready = function (self)
	-- function 2
	Unit.flow_event(self.unit, "lua_spawner_initialized")
end

LimitedItemTrackSpawner.destroy = function (arg_3_0)
	-- function 3
	return
end

LimitedItemTrackSpawner.update = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4, arg_4_5)
	-- function 4
	return
end

LimitedItemTrackSpawner.socket_item = function (self, arg_5_1)
	-- function 5
	local find_item_id = self:find_item_id(arg_5_1)

	self.socketed_items[find_item_id] = arg_5_1
	self.num_socketed_items = table.size(self.socketed_items)
end

LimitedItemTrackSpawner.spawn_item = function (self)
	-- function 6
	local unit = self.unit
	local find_empty_id = self:find_empty_id()

	fassert(find_empty_id, "Found no empty id")

	self.spawn_data.id = find_empty_id

	local template_name = self.template_name
	local spawn_func = LimitedItemTrackSpawnerTemplates[template_name].spawn_func(self.world, unit, self.spawn_data)

	self.items[find_empty_id] = spawn_func
	self.num_items = self.num_items + 1

	Unit.flow_event(unit, "lua_spawner_spawn_item")
end

LimitedItemTrackSpawner.find_item_id = function (self, arg_7_1)
	-- function 7
	local pool = self.pool
	local items = self.items

	for i = 1, pool do
		if items[i] == arg_7_1 then
			return i
		end
	end
end

LimitedItemTrackSpawner.find_empty_id = function (self)
	-- function 8
	local pool = self.pool
	local items = self.items

	for i = 1, pool do
		if not items[i] then
			return i
		end
	end
end

LimitedItemTrackSpawner.remove = function (self, arg_9_1)
	-- function 9
	local items = self.items

	if not items[arg_9_1] then
		items[arg_9_1] = nil
		self.num_items = self.num_items - 1
		self.pool_exhausted = false
	end
end

LimitedItemTrackSpawner.transform = function (self, arg_10_1)
	-- function 10
	local items = self.items

	if not items[arg_10_1] then
		items[arg_10_1] = true
	end
end

LimitedItemTrackSpawner.is_transformed = function (self, arg_11_1)
	-- function 11
	local var_11_0 = self.items[arg_11_1]

	if type(var_11_0) == "boolean" then
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
		if not self:is_transformed(i) then
			return true
		end
	end

	return false
end

LimitedItemTrackSpawner.is_any_item_spawned = function (self)
	-- function 13
	local pool = self.pool

	return #self.items > 0
end
