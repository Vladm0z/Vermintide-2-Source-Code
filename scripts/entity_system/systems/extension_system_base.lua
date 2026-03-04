-- chunkname: @scripts/entity_system/systems/extension_system_base.lua

ExtensionSystemBase = class(ExtensionSystemBase)

function ExtensionSystemBase.init(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
	arg_1_0.is_server = arg_1_1.is_server
	arg_1_0.world = arg_1_1.world
	arg_1_0.name = arg_1_2

	local var_1_0 = arg_1_1.entity_manager

	var_1_0:register_system(arg_1_0, arg_1_2, arg_1_3)

	arg_1_0.entity_manager = var_1_0
	arg_1_0.unit_storage = arg_1_1.unit_storage
	arg_1_0.network_transmit = arg_1_1.network_transmit
	arg_1_0.system_api = arg_1_1.system_api
	arg_1_0.statistics_db = arg_1_1.statistics_db
	arg_1_0.extension_init_context = {
		world = arg_1_0.world,
		unit_storage = arg_1_0.unit_storage,
		entity_manager = arg_1_0.entity_manager,
		network_transmit = arg_1_0.network_transmit,
		system_api = arg_1_0.system_api,
		statistics_db = arg_1_0.statistics_db,
		ingame_ui = arg_1_1.ingame_ui,
		is_server = arg_1_1.is_server,
		owning_system = arg_1_0
	}
	arg_1_0.update_list = {}
	arg_1_0.extensions = {}
	arg_1_0.profiler_names = {}

	for iter_1_0 = 1, #arg_1_3 do
		local var_1_1 = arg_1_3[iter_1_0]

		arg_1_0.update_list[var_1_1] = {
			pre_update = {},
			update = {},
			post_update = {}
		}
		arg_1_0.extensions[var_1_1] = 0
		arg_1_0.profiler_names[var_1_1] = var_1_1 .. " [ALL]"
	end
end

function ExtensionSystemBase.on_add_extension(arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4)
	local var_2_0 = arg_2_0.NAME
	local var_2_1
	local var_2_2 = ScriptUnit.add_extension(arg_2_0.extension_init_context, arg_2_2, arg_2_3, var_2_0, arg_2_4, var_2_1)

	arg_2_0.extensions[arg_2_3] = (arg_2_0.extensions[arg_2_3] or 0) + 1

	if var_2_2.pre_update then
		arg_2_0.update_list[arg_2_3].pre_update[arg_2_2] = var_2_2
	end

	if var_2_2.update then
		arg_2_0.update_list[arg_2_3].update[arg_2_2] = var_2_2
	end

	if var_2_2.post_update then
		arg_2_0.update_list[arg_2_3].post_update[arg_2_2] = var_2_2
	end

	return var_2_2
end

function ExtensionSystemBase.on_remove_extension(arg_3_0, arg_3_1, arg_3_2)
	local var_3_0 = ScriptUnit.has_extension(arg_3_1, arg_3_0.NAME)

	assert(var_3_0, "Trying to remove non-existing extension %q from unit %s", arg_3_2, arg_3_1)
	ScriptUnit.remove_extension(arg_3_1, arg_3_0.NAME)

	arg_3_0.extensions[arg_3_2] = arg_3_0.extensions[arg_3_2] - 1
	arg_3_0.update_list[arg_3_2].pre_update[arg_3_1] = nil
	arg_3_0.update_list[arg_3_2].update[arg_3_1] = nil
	arg_3_0.update_list[arg_3_2].post_update[arg_3_1] = nil
end

function ExtensionSystemBase.on_freeze_extension(arg_4_0, arg_4_1, arg_4_2)
	return
end

local var_0_0 = {}

function ExtensionSystemBase.pre_update(arg_5_0, arg_5_1, arg_5_2)
	local var_5_0 = arg_5_1.dt
	local var_5_1 = arg_5_0.update_list
	local var_5_2 = var_0_0

	for iter_5_0, iter_5_1 in pairs(arg_5_0.extensions) do
		local var_5_3 = arg_5_0.profiler_names[iter_5_0]

		for iter_5_2, iter_5_3 in pairs(var_5_1[iter_5_0].pre_update) do
			iter_5_3:pre_update(iter_5_2, var_5_2, var_5_0, arg_5_1, arg_5_2)
		end
	end
end

function ExtensionSystemBase.enable_update_function(arg_6_0, arg_6_1, arg_6_2, arg_6_3, arg_6_4)
	arg_6_0.update_list[arg_6_1][arg_6_2][arg_6_3] = arg_6_4
end

function ExtensionSystemBase.disable_update_function(arg_7_0, arg_7_1, arg_7_2, arg_7_3)
	arg_7_0.update_list[arg_7_1][arg_7_2][arg_7_3] = nil
end

function ExtensionSystemBase.update(arg_8_0, arg_8_1, arg_8_2)
	local var_8_0 = arg_8_1.dt
	local var_8_1 = arg_8_0.update_list
	local var_8_2 = var_0_0

	for iter_8_0, iter_8_1 in pairs(arg_8_0.extensions) do
		local var_8_3 = arg_8_0.profiler_names[iter_8_0]

		for iter_8_2, iter_8_3 in pairs(var_8_1[iter_8_0].update) do
			iter_8_3:update(iter_8_2, var_8_2, var_8_0, arg_8_1, arg_8_2)
		end
	end
end

function ExtensionSystemBase.post_update(arg_9_0, arg_9_1, arg_9_2)
	local var_9_0 = arg_9_1.dt
	local var_9_1 = arg_9_0.update_list
	local var_9_2 = var_0_0

	for iter_9_0, iter_9_1 in pairs(arg_9_0.extensions) do
		local var_9_3 = arg_9_0.profiler_names[iter_9_0]

		for iter_9_2, iter_9_3 in pairs(var_9_1[iter_9_0].post_update) do
			iter_9_3:post_update(iter_9_2, var_9_2, var_9_0, arg_9_1, arg_9_2)
		end
	end
end

function ExtensionSystemBase.pre_update_extension(arg_10_0, arg_10_1, arg_10_2, arg_10_3, arg_10_4)
	local var_10_0 = var_0_0

	for iter_10_0, iter_10_1 in pairs(arg_10_0.update_list[arg_10_1].pre_update) do
		iter_10_1:pre_update(iter_10_0, var_10_0, arg_10_2, arg_10_3, arg_10_4)
	end
end

function ExtensionSystemBase.update_extension(arg_11_0, arg_11_1, arg_11_2, arg_11_3, arg_11_4)
	local var_11_0 = var_0_0

	for iter_11_0, iter_11_1 in pairs(arg_11_0.update_list[arg_11_1].update) do
		iter_11_1:update(iter_11_0, var_11_0, arg_11_2, arg_11_3, arg_11_4)
	end
end

function ExtensionSystemBase.post_update_extension(arg_12_0, arg_12_1, arg_12_2, arg_12_3, arg_12_4)
	local var_12_0 = var_0_0

	for iter_12_0, iter_12_1 in pairs(arg_12_0.update_list[arg_12_1].post_update) do
		iter_12_1:post_update(iter_12_0, var_12_0, arg_12_2, arg_12_3, arg_12_4)
	end
end

function ExtensionSystemBase.hot_join_sync(arg_13_0, arg_13_1)
	for iter_13_0, iter_13_1 in pairs(arg_13_0.extensions) do
		arg_13_0:_hot_join_sync_extension(iter_13_0, arg_13_1)
	end
end

function ExtensionSystemBase._hot_join_sync_extension(arg_14_0, arg_14_1, arg_14_2)
	local var_14_0 = arg_14_0.entity_manager:get_entities(arg_14_1)

	for iter_14_0, iter_14_1 in pairs(var_14_0) do
		if iter_14_1.hot_join_sync then
			iter_14_1:hot_join_sync(arg_14_2)
		end
	end
end

function ExtensionSystemBase.destroy(arg_15_0)
	return
end

local var_0_1 = {}

function ExtensionSystemBase.get_extensions_from_extension_name(arg_16_0, arg_16_1)
	fassert(arg_16_0.update_list[arg_16_1], "[ExtensionSystemBase:get_extensions_from_type] There is no extension called %q", arg_16_1)
	table.clear(var_0_1)

	for iter_16_0, iter_16_1 in pairs(arg_16_0.update_list[arg_16_1].pre_update) do
		var_0_1[iter_16_0] = iter_16_1
	end

	for iter_16_2, iter_16_3 in pairs(arg_16_0.update_list[arg_16_1].update) do
		var_0_1[iter_16_2] = iter_16_3
	end

	for iter_16_4, iter_16_5 in pairs(arg_16_0.update_list[arg_16_1].post_update) do
		var_0_1[iter_16_4] = iter_16_5
	end

	return var_0_1
end
