-- chunkname: @scripts/entity_system/systems/ward/ward_system.lua

WardSystem = class(WardSystem, ExtensionSystemBase)

local var_0_0 = {
	"WardExtension"
}

function WardSystem.init(arg_1_0, arg_1_1, arg_1_2, ...)
	WardSystem.super.init(arg_1_0, arg_1_1, arg_1_2, var_0_0, ...)

	arg_1_0._update_index = 1
	arg_1_0._units = {}
	arg_1_0._to_update = {}
	arg_1_0._lookup = {}
	arg_1_0._profiler_name = arg_1_0.profiler_names.WardExtension
end

function WardSystem.on_add_extension(arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4)
	local var_2_0 = arg_2_0.NAME
	local var_2_1
	local var_2_2 = ScriptUnit.add_extension(arg_2_0.extension_init_context, arg_2_2, arg_2_3, var_2_0, arg_2_4, var_2_1)

	arg_2_0.extensions[arg_2_3] = (arg_2_0.extensions[arg_2_3] or 0) + 1

	local var_2_3 = arg_2_0.extensions[arg_2_3]

	arg_2_0._units[var_2_3] = arg_2_2
	arg_2_0._lookup[arg_2_2] = var_2_3

	if var_2_2.update then
		arg_2_0._to_update[(#arg_2_0._to_update or 0) + 1] = var_2_2
	end

	return var_2_2
end

function WardSystem.update(arg_3_0, arg_3_1, arg_3_2)
	local var_3_0 = #arg_3_0._to_update
	local var_3_1 = arg_3_1.dt

	if var_3_0 == 0 then
		return
	end

	local var_3_2 = arg_3_0._update_index
	local var_3_3 = arg_3_0._to_update[var_3_2]

	if var_3_3 then
		var_3_3:update(arg_3_0._units[var_3_2], nil, var_3_1, arg_3_1, arg_3_2)
	end

	if var_3_2 == var_3_0 then
		arg_3_0._update_index = 1
	else
		arg_3_0._update_index = var_3_2 + 1
	end
end

function WardSystem.on_remove_extension(arg_4_0, arg_4_1, arg_4_2)
	if not ScriptUnit.has_extension(arg_4_1, arg_4_0.NAME) then
		return
	end

	local var_4_0 = arg_4_0.extensions[arg_4_2]
	local var_4_1 = arg_4_0._lookup[arg_4_1]

	if var_4_1 == var_4_0 then
		arg_4_0._units[var_4_1] = nil
		arg_4_0._to_update[var_4_1] = nil
		arg_4_0._lookup[var_4_1] = nil
	else
		arg_4_0._units[var_4_1] = arg_4_0._units[var_4_0]
		arg_4_0._units[var_4_0] = nil
		arg_4_0._to_update[var_4_1] = arg_4_0._to_update[var_4_0]
		arg_4_0._to_update[var_4_0] = nil
		arg_4_0._lookup[arg_4_0._units[var_4_1]] = var_4_1
		arg_4_0._lookup[var_4_0] = nil
	end

	arg_4_0._update_index = 1
	arg_4_0.extensions[arg_4_2] = arg_4_0.extensions[arg_4_2] - 1

	ScriptUnit.remove_extension(arg_4_1, arg_4_0.NAME)
end
