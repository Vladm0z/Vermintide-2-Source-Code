-- chunkname: @foundation/scripts/managers/world/world_manager.lua

require("foundation/scripts/util/script_world")

WorldManager = class(WorldManager)

function WorldManager.init(arg_1_0)
	arg_1_0._worlds = {}
	arg_1_0._disabled_worlds = {}
	arg_1_0._update_queue = {}
	arg_1_0._anim_update_callbacks = {}
	arg_1_0._scene_update_callbacks = {}
	arg_1_0._update_done_callbacks = {}
	arg_1_0._queued_worlds_to_release = {}
	arg_1_0._wwise_worlds = {}
end

function WorldManager.create_world(arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4, ...)
	fassert(arg_2_0._worlds[arg_2_1] == nil, "World %q already exists", arg_2_1)

	local var_2_0 = true
	local var_2_1 = select("#", ...)

	for iter_2_0 = 1, var_2_1 do
		if select(iter_2_0, ...) == Application.DISABLE_PHYSICS then
			var_2_0 = false
		end
	end

	local var_2_2 = Application.new_world(arg_2_1, ...)

	World.set_data(var_2_2, "name", arg_2_1)
	World.set_data(var_2_2, "layer", arg_2_4 or 1)
	World.set_data(var_2_2, "active", true)
	World.set_data(var_2_2, "has_physics_world", var_2_0)

	if var_2_0 then
		local var_2_3 = World.physics_world(var_2_2)

		World.set_data(var_2_2, "physics_world", var_2_3)
	end

	if arg_2_2 then
		ScriptWorld.create_shading_environment(var_2_2, arg_2_2, arg_2_3, "default")
	end

	World.set_data(var_2_2, "levels", {})
	World.set_data(var_2_2, "viewports", {})
	World.set_data(var_2_2, "free_flight_viewports", {})
	World.set_data(var_2_2, "render_queue", {})

	arg_2_0._worlds[arg_2_1] = var_2_2
	arg_2_0._wwise_worlds[var_2_2] = Wwise.wwise_world(var_2_2)

	arg_2_0:_sort_update_queue()

	return var_2_2
end

function WorldManager.wwise_world(arg_3_0, arg_3_1)
	return arg_3_0._wwise_worlds[arg_3_1]
end

function WorldManager.destroy_world(arg_4_0, arg_4_1)
	if arg_4_0.locked then
		arg_4_0._queued_worlds_to_release[arg_4_1] = true

		return
	end

	local var_4_0

	if type(arg_4_1) == "string" then
		var_4_0 = arg_4_1
	else
		var_4_0 = World.get_data(arg_4_1, "name")
	end

	local var_4_1 = arg_4_0._worlds[var_4_0]

	if var_4_1 == nil then
		var_4_1 = arg_4_0._disabled_worlds[var_4_0]
	end

	assert(var_4_1, "World %q doesn't exist", var_4_0)

	local var_4_2 = PhysicsWorld.free_overlaps

	if var_4_2 and World.get_data(var_4_1, "has_physics_world") then
		local var_4_3 = World.get_data(var_4_1, "physics_world")

		var_4_2(var_4_3)
	end

	Application.release_world(var_4_1)

	arg_4_0._worlds[var_4_0] = nil
	arg_4_0._disabled_worlds[var_4_0] = nil
	arg_4_0._anim_update_callbacks[var_4_1] = nil
	arg_4_0._scene_update_callbacks[var_4_1] = nil
	arg_4_0._update_done_callbacks[var_4_1] = nil
	arg_4_0._wwise_worlds[var_4_1] = nil

	arg_4_0:_sort_update_queue()
end

function WorldManager.has_world(arg_5_0, arg_5_1)
	return arg_5_0._worlds and arg_5_0._worlds[arg_5_1] ~= nil
end

function WorldManager.world(arg_6_0, arg_6_1)
	fassert(arg_6_0._worlds[arg_6_1], "World %q doesn't exist", arg_6_1)

	return arg_6_0._worlds[arg_6_1]
end

function WorldManager.update(arg_7_0, arg_7_1, arg_7_2)
	arg_7_0.locked = true

	for iter_7_0, iter_7_1 in ipairs(arg_7_0._update_queue) do
		ScriptWorld.update(iter_7_1, arg_7_1, arg_7_2, arg_7_0._anim_update_callbacks[iter_7_1], arg_7_0._scene_update_callbacks[iter_7_1], arg_7_0._update_done_callbacks[iter_7_1])
	end

	arg_7_0.locked = false

	for iter_7_2, iter_7_3 in pairs(arg_7_0._queued_worlds_to_release) do
		arg_7_0:destroy_world(iter_7_2)

		arg_7_0._queued_worlds_to_release[iter_7_2] = nil
	end
end

function WorldManager.render(arg_8_0)
	for iter_8_0, iter_8_1 in ipairs(arg_8_0._update_queue) do
		ScriptWorld.render(iter_8_1)
	end
end

function WorldManager.enable_world(arg_9_0, arg_9_1, arg_9_2)
	if arg_9_2 then
		local var_9_0 = arg_9_0._disabled_worlds[arg_9_1]

		assert(var_9_0, "Tried to enable world %q that wasn't disabled", arg_9_1)

		arg_9_0._worlds[arg_9_1] = var_9_0
		arg_9_0._disabled_worlds[arg_9_1] = nil
	else
		local var_9_1 = arg_9_0._worlds[arg_9_1]

		assert(var_9_1, "Tried to disable world %q that wasn't enabled", arg_9_1)

		arg_9_0._disabled_worlds[arg_9_1] = var_9_1
		arg_9_0._worlds[arg_9_1] = nil
	end

	arg_9_0:_sort_update_queue()
end

function WorldManager.destroy(arg_10_0)
	for iter_10_0, iter_10_1 in pairs(arg_10_0._worlds) do
		arg_10_0:destroy_world(iter_10_0)
	end
end

function WorldManager._sort_update_queue(arg_11_0)
	arg_11_0._update_queue = {}

	for iter_11_0, iter_11_1 in pairs(arg_11_0._worlds) do
		arg_11_0._update_queue[#arg_11_0._update_queue + 1] = iter_11_1
	end

	local function var_11_0(arg_12_0, arg_12_1)
		return World.get_data(arg_12_0, "layer") < World.get_data(arg_12_1, "layer")
	end

	table.sort(arg_11_0._update_queue, var_11_0)
end

function WorldManager.set_anim_update_callback(arg_13_0, arg_13_1, arg_13_2)
	arg_13_0._anim_update_callbacks[arg_13_1] = arg_13_2
end

function WorldManager.set_scene_update_callback(arg_14_0, arg_14_1, arg_14_2)
	arg_14_0._scene_update_callbacks[arg_14_1] = arg_14_2
end

function WorldManager.set_update_done_callback(arg_15_0, arg_15_1, arg_15_2)
	arg_15_0._update_done_callbacks[arg_15_1] = arg_15_2
end
