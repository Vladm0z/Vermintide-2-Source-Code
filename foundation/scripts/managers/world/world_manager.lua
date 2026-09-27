-- chunkname: @foundation/scripts/managers/world/world_manager.lua

require("foundation/scripts/util/script_world")

WorldManager = class(WorldManager)

WorldManager.init = function (self)
	-- function 1
	self._worlds = {}
	self._disabled_worlds = {}
	self._update_queue = {}
	self._anim_update_callbacks = {}
	self._scene_update_callbacks = {}
	self._update_done_callbacks = {}
	self._queued_worlds_to_release = {}
	self._wwise_worlds = {}
end

WorldManager.create_world = function (self, arg_2_1, arg_2_2, arg_2_3, arg_2_4, ...)
	-- function 2
	fassert(self._worlds[arg_2_1] == nil, "World %q already exists", arg_2_1)

	local flag = true
	local var_2_1 = select("#", ...)

	for i = 1, var_2_1 do
		if select(i, ...) == Application.DISABLE_PHYSICS then
			flag = false
		end
	end

	local new_world = Application.new_world(arg_2_1, ...)

	World.set_data(new_world, "name", arg_2_1)
	World.set_data(new_world, "layer", arg_2_4 or 1)
	World.set_data(new_world, "active", true)
	World.set_data(new_world, "has_physics_world", flag)

	if not flag then
		local physics_world = World.physics_world(new_world)

		World.set_data(new_world, "physics_world", physics_world)
	end

	if not arg_2_2 then
		ScriptWorld.create_shading_environment(new_world, arg_2_2, arg_2_3, "default")
	end

	World.set_data(new_world, "levels", {})
	World.set_data(new_world, "viewports", {})
	World.set_data(new_world, "free_flight_viewports", {})
	World.set_data(new_world, "render_queue", {})

	self._worlds[arg_2_1] = new_world
	self._wwise_worlds[new_world] = Wwise.wwise_world(new_world)

	self:_sort_update_queue()

	return new_world
end

WorldManager.wwise_world = function (self, arg_3_1)
	-- function 3
	return self._wwise_worlds[arg_3_1]
end

WorldManager.destroy_world = function (self, arg_4_1)
	-- function 4
	if not self.locked then
		self._queued_worlds_to_release[arg_4_1] = true

		return
	end

	local var_4_0

	if type(arg_4_1) == "string" then
		var_4_0 = arg_4_1
	else
		var_4_0 = World.get_data(arg_4_1, "name")
	end

	local var_4_1 = self._worlds[var_4_0]

	if var_4_1 == nil then
		var_4_1 = self._disabled_worlds[var_4_0]
	end

	assert(var_4_1, "World %q doesn't exist", var_4_0)

	local free_overlaps = PhysicsWorld.free_overlaps

	if not free_overlaps and not World.get_data(var_4_1, "has_physics_world") then
		local get_data = World.get_data(var_4_1, "physics_world")

		free_overlaps(get_data)
	end

	Application.release_world(var_4_1)

	self._worlds[var_4_0] = nil
	self._disabled_worlds[var_4_0] = nil
	self._anim_update_callbacks[var_4_1] = nil
	self._scene_update_callbacks[var_4_1] = nil
	self._update_done_callbacks[var_4_1] = nil
	self._wwise_worlds[var_4_1] = nil

	self:_sort_update_queue()
end

WorldManager.has_world = function (self, arg_5_1)
	-- function 5
	local _worlds = self._worlds

	_worlds = not _worlds and self._worlds[arg_5_1] ~= nil

	return _worlds
end

WorldManager.world = function (self, arg_6_1)
	-- function 6
	fassert(self._worlds[arg_6_1], "World %q doesn't exist", arg_6_1)

	return self._worlds[arg_6_1]
end

WorldManager.update = function (self, arg_7_1, arg_7_2)
	-- function 7
	self.locked = true

	for i, v in ipairs(self._update_queue) do
		ScriptWorld.update(v, arg_7_1, arg_7_2, self._anim_update_callbacks[v], self._scene_update_callbacks[v], self._update_done_callbacks[v])
	end

	self.locked = false

	for k, v_2 in pairs(self._queued_worlds_to_release) do
		self:destroy_world(k)

		self._queued_worlds_to_release[k] = nil
	end
end

WorldManager.render = function (self)
	-- function 8
	for i, v in ipairs(self._update_queue) do
		ScriptWorld.render(v)
	end
end

WorldManager.enable_world = function (self, arg_9_1, arg_9_2)
	-- function 9
	if not arg_9_2 then
		local var_9_0 = self._disabled_worlds[arg_9_1]

		assert(var_9_0, "Tried to enable world %q that wasn't disabled", arg_9_1)

		self._worlds[arg_9_1] = var_9_0
		self._disabled_worlds[arg_9_1] = nil
	else
		local var_9_1 = self._worlds[arg_9_1]

		assert(var_9_1, "Tried to disable world %q that wasn't enabled", arg_9_1)

		self._disabled_worlds[arg_9_1] = var_9_1
		self._worlds[arg_9_1] = nil
	end

	self:_sort_update_queue()
end

WorldManager.destroy = function (self)
	-- function 10
	for k, v in pairs(self._worlds) do
		self:destroy_world(k)
	end
end

WorldManager._sort_update_queue = function (self)
	-- function 11
	self._update_queue = {}

	for k, v in pairs(self._worlds) do
		self._update_queue[#self._update_queue + 1] = v
	end

	local function fn(arg_12_0, arg_12_1)
		-- function 12
		return World.get_data(arg_12_0, "layer") < World.get_data(arg_12_1, "layer")
	end

	table.sort(self._update_queue, fn)
end

WorldManager.set_anim_update_callback = function (arg_13_0, arg_13_1, arg_13_2)
	-- function 13
	arg_13_0._anim_update_callbacks[arg_13_1] = arg_13_2
end

WorldManager.set_scene_update_callback = function (arg_14_0, arg_14_1, arg_14_2)
	-- function 14
	arg_14_0._scene_update_callbacks[arg_14_1] = arg_14_2
end

WorldManager.set_update_done_callback = function (arg_15_0, arg_15_1, arg_15_2)
	-- function 15
	arg_15_0._update_done_callbacks[arg_15_1] = arg_15_2
end
