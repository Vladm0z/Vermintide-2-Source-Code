-- chunkname: @scripts/entity_system/systems/disrupt_ritual/disrupt_ritual_system.lua

DisruptRitualSystem = class(DisruptRitualSystem, ExtensionSystemBase)

local var_0_0 = "DisruptRitualExtension"

DisruptRitualSystem.init = function (arg_1_0, arg_1_1, ...)
	DisruptRitualSystem.super.init(arg_1_0, arg_1_1, ...)

	arg_1_0._update_index = 1
	arg_1_0._units = {}
	arg_1_0._is_server = arg_1_1.is_server
	arg_1_0._extension_list = {}
	arg_1_0._profiler_name = arg_1_0.profiler_names.DisruptRitualExtension
end

DisruptRitualSystem.on_add_extension = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4)
	local var_2_0 = arg_2_0.NAME
	local var_2_1
	local var_2_2 = ScriptUnit.add_extension(arg_2_0.extension_init_context, arg_2_2, arg_2_3, var_2_0, arg_2_4, var_2_1)

	arg_2_0.extensions[arg_2_3] = (arg_2_0.extensions[arg_2_3] or 0) + 1

	local var_2_3 = arg_2_0.extensions[arg_2_3]

	arg_2_0._units[var_2_3] = arg_2_2
	arg_2_0._extension_list[#arg_2_0._extension_list + 1] = var_2_2

	return var_2_2
end

DisruptRitualSystem.update = function (arg_3_0, arg_3_1, arg_3_2)
	if not arg_3_0._is_server then
		return
	end

	local var_3_0 = arg_3_0.extensions.DisruptRitualExtension

	if var_3_0 == 0 then
		return
	end

	local var_3_1 = arg_3_0._update_index
	local var_3_2 = arg_3_1.dt

	arg_3_0._extension_list[var_3_1]:update(arg_3_2)

	if var_3_1 == var_3_0 then
		arg_3_0._update_index = 1
	else
		arg_3_0._update_index = var_3_1 + 1
	end
end

DisruptRitualSystem.hot_join_sync = function (arg_4_0, arg_4_1)
	for iter_4_0, iter_4_1 in pairs(arg_4_0.extensions) do
		arg_4_0:_hot_join_sync_extension(iter_4_0, arg_4_1)
	end
end

DisruptRitualSystem._hot_join_sync_extension = function (arg_5_0, arg_5_1, arg_5_2)
	local var_5_0 = arg_5_0.entity_manager:get_entities(arg_5_1)

	for iter_5_0, iter_5_1 in pairs(var_5_0) do
		if iter_5_1.hot_join_sync then
			iter_5_1:hot_join_sync(arg_5_2)
		end
	end
end
