-- chunkname: @core/gwnav/lua/runtime/navhelpers.lua

require("core/gwnav/lua/safe_require")

local var_0_0 = safe_require_guard()
local var_0_1 = stingray.Color
local var_0_2 = stingray.Unit

function var_0_0.unit_script_data(arg_1_0, arg_1_1, ...)
	if arg_1_0 and var_0_2.alive(arg_1_0) and var_0_2.has_data(arg_1_0, ...) then
		return var_0_2.get_data(arg_1_0, ...)
	else
		return arg_1_1
	end
end

function var_0_0.get_layer_and_smartobject(arg_2_0, arg_2_1)
	local var_2_0 = var_0_0.unit_script_data(arg_2_0, false, arg_2_1, "is_exclusive")

	if var_2_0 then
		return var_2_0, var_0_1(255, 0, 0), -1, -1, -1
	end

	local var_2_1 = var_0_0.unit_script_data(arg_2_0, -1, arg_2_1, "layer_id")
	local var_2_2 = var_0_0.unit_script_data(arg_2_0, -1, arg_2_1, "smartobject_id")
	local var_2_3 = var_0_0.unit_script_data(arg_2_0, -1, arg_2_1, "user_data_id")
	local var_2_4 = var_0_1(var_0_0.unit_script_data(arg_2_0, 0, arg_2_1, "color", "r"), var_0_0.unit_script_data(arg_2_0, 255, arg_2_1, "color", "g"), var_0_0.unit_script_data(arg_2_0, 0, arg_2_1, "color", "b"))

	return var_2_0, var_2_4, var_2_1, var_2_2, var_2_3
end

return var_0_0
