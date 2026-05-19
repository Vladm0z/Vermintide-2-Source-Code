-- chunkname: @scripts/unit_extensions/limited_item_track/limited_item_track_spawner.lua

require("scripts/unit_extensions/limited_item_track/limited_item_track_spawner_templates")

LimitedItemTrackSpawner = class(LimitedItemTrackSpawner)

function LimitedItemTrackSpawner.init(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
	assert(Managers.player.is_server, "Spawner should only exist on server")
	assert(arg_1_3.pool > 0, "Can't have pool less than 1")

	arg_1_0.world = arg_1_1
	arg_1_0.unit = arg_1_2
	arg_1_0.num_items = 0
	arg_1_0.items = {}
	arg_1_0.socketed_items = {}
	arg_1_0.num_socketed_items = 0
	arg_1_0.pool = arg_1_3.pool
	arg_1_0.template_name = arg_1_3.template_name
	arg_1_0.time_between_spawns = 2
	arg_1_0.time_to_spawn = 0
	arg_1_0.pool_exhausted = false
	arg_1_0.network_manager = arg_1_3.network_manager

	local var_1_0 = arg_1_0.template_name

	arg_1_0.spawn_data = LimitedItemTrackSpawnerTemplates[var_1_0].init_func(arg_1_1, arg_1_2, arg_1_3)
end

function LimitedItemTrackSpawner.extensions_ready(arg_2_0)
	Unit.flow_event(arg_2_0.unit, "lua_spawner_initialized")
end

function LimitedItemTrackSpawner.destroy(arg_3_0)
	return
end

function LimitedItemTrackSpawner.update(arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4, arg_4_5)
	return
end

function LimitedItemTrackSpawner.socket_item(arg_5_0, arg_5_1)
	local var_5_0 = arg_5_0:find_item_id(arg_5_1)

	arg_5_0.socketed_items[var_5_0] = arg_5_1
	arg_5_0.num_socketed_items = table.size(arg_5_0.socketed_items)
end

function LimitedItemTrackSpawner.spawn_item(arg_6_0)
	local var_6_0 = arg_6_0.unit
	local var_6_1 = arg_6_0:find_empty_id()

	fassert(var_6_1, "Found no empty id")

	arg_6_0.spawn_data.id = var_6_1

	local var_6_2 = arg_6_0.template_name
	local var_6_3 = LimitedItemTrackSpawnerTemplates[var_6_2].spawn_func(arg_6_0.world, var_6_0, arg_6_0.spawn_data)

	arg_6_0.items[var_6_1] = var_6_3
	arg_6_0.num_items = arg_6_0.num_items + 1

	Unit.flow_event(var_6_0, "lua_spawner_spawn_item")
end

function LimitedItemTrackSpawner.find_item_id(arg_7_0, arg_7_1)
	local var_7_0 = arg_7_0.pool
	local var_7_1 = arg_7_0.items

	for iter_7_0 = 1, var_7_0 do
		if var_7_1[iter_7_0] == arg_7_1 then
			return iter_7_0
		end
	end
end

function LimitedItemTrackSpawner.find_empty_id(arg_8_0)
	local var_8_0 = arg_8_0.pool
	local var_8_1 = arg_8_0.items

	for iter_8_0 = 1, var_8_0 do
		if not var_8_1[iter_8_0] then
			return iter_8_0
		end
	end
end

function LimitedItemTrackSpawner.remove(arg_9_0, arg_9_1)
	local var_9_0 = arg_9_0.items

	if var_9_0[arg_9_1] then
		var_9_0[arg_9_1] = nil
		arg_9_0.num_items = arg_9_0.num_items - 1
		arg_9_0.pool_exhausted = false
	end
end

function LimitedItemTrackSpawner.transform(arg_10_0, arg_10_1)
	local var_10_0 = arg_10_0.items

	if var_10_0[arg_10_1] then
		var_10_0[arg_10_1] = true
	end
end

function LimitedItemTrackSpawner.is_transformed(arg_11_0, arg_11_1)
	local var_11_0 = arg_11_0.items[arg_11_1]

	if type(var_11_0) == "boolean" then
		return true
	else
		return false
	end
end

function LimitedItemTrackSpawner.is_any_transformed(arg_12_0)
	local var_12_0 = arg_12_0.pool
	local var_12_1 = arg_12_0.items

	for iter_12_0 = 1, var_12_0 do
		if arg_12_0:is_transformed(iter_12_0) then
			return true
		end
	end

	return false
end

function LimitedItemTrackSpawner.is_any_item_spawned(arg_13_0)
	local var_13_0 = arg_13_0.pool

	return #arg_13_0.items > 0
end
