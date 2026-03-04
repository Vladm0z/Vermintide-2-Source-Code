-- chunkname: @scripts/managers/input/script_input_source.lua

require("scripts/settings/script_input_settings")

ScriptInputSource = class(ScriptInputSource, InputSource)

ScriptInputSource.init = function (arg_1_0, arg_1_1, arg_1_2)
	ScriptInputSource.super.init(arg_1_0, arg_1_1, arg_1_2)

	arg_1_0._active = false
end

ScriptInputSource.start = function (arg_2_0, arg_2_1, arg_2_2)
	arg_2_0._input_settings = arg_2_1
	arg_2_0._input_settings_copy = table.clone(arg_2_1)
	arg_2_0._input = {}
	arg_2_0._active = true
	arg_2_0._active_time = 0
	arg_2_0._loop = arg_2_2
end

ScriptInputSource.clear = function (arg_3_0)
	ScriptInputSource.super.clear(arg_3_0)

	arg_3_0._active = false
end

ScriptInputSource.get = function (arg_4_0, arg_4_1)
	fassert(arg_4_0.mapping_table, "Trying to access unmapped input source.")

	local var_4_0 = arg_4_0.mapping_table[arg_4_1]

	fassert(var_4_0, "No input description for %q", arg_4_1)

	local var_4_1 = arg_4_0.controllers[var_4_0.controller_type]

	fassert(var_4_1, "No controller of type %q", var_4_0.controller_type)
	fassert(var_4_0.func, "No input_desc.func")

	return arg_4_0._active and arg_4_0._input[arg_4_1] or ScriptInputSource.super.get(arg_4_0, arg_4_1)
end

ScriptInputSource.update = function (arg_5_0, arg_5_1, arg_5_2)
	if arg_5_0._active then
		arg_5_0:_update_input(arg_5_1, arg_5_2)
	end
end

ScriptInputSource._update_input = function (arg_6_0, arg_6_1, arg_6_2)
	local var_6_0 = {}

	for iter_6_0 = #arg_6_0._input_settings_copy, 1, -1 do
		local var_6_1 = arg_6_0._input_settings_copy[iter_6_0]

		if arg_6_0._active_time > var_6_1.start then
			local var_6_2 = arg_6_0.mapping_table[var_6_1.name]

			if var_6_2.func == "button" then
				var_6_0[var_6_1.name] = var_6_1.value or 1
			elseif var_6_2.func == "pressed" or var_6_2.func == "released" then
				var_6_0[var_6_1.name] = true
			elseif var_6_2.func == "axis" then
				var_6_0[var_6_1.name] = Vector3(var_6_1.value[1], var_6_1.value[2], var_6_1.value[3])
			elseif var_6_2.func == "filter" then
				var_6_0[var_6_1.name] = Vector3(var_6_1.value[1], var_6_1.value[2], var_6_1.value[3])
			end

			if not var_6_1.duration or arg_6_0._active_time > var_6_1.start + var_6_1.duration then
				table.remove(arg_6_0._input_settings_copy, iter_6_0)
			end
		end
	end

	arg_6_0._input = var_6_0
	arg_6_0._active_time = arg_6_0._active_time + arg_6_1

	if #arg_6_0._input_settings_copy == 0 and arg_6_0._loop then
		arg_6_0:start(arg_6_0._input_settings, true)
	end
end
