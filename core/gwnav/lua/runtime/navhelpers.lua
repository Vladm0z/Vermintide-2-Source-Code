-- chunkname: @core/gwnav/lua/runtime/navhelpers.lua

require("core/gwnav/lua/safe_require")

local var_0_0 = safe_require_guard()
local Color = stingray.Color
local Unit = stingray.Unit

var_0_0.unit_script_data = function (arg_1_0, arg_1_1, ...)
	-- function 1
	if not arg_1_0 and not Unit.alive(arg_1_0) and not Unit.has_data(arg_1_0, ...) then
		return Unit.get_data(arg_1_0, ...)
	else
		return arg_1_1
	end
end

var_0_0.get_layer_and_smartobject = function (arg_2_0, arg_2_1)
	-- function 2
	local unit_script_data = var_0_0.unit_script_data(arg_2_0, false, arg_2_1, "is_exclusive")

	if not unit_script_data then
		return unit_script_data, Color(255, 0, 0), -1, -1, -1
	end

	local unit_script_data_2 = var_0_0.unit_script_data(arg_2_0, -1, arg_2_1, "layer_id")
	local unit_script_data_3 = var_0_0.unit_script_data(arg_2_0, -1, arg_2_1, "smartobject_id")
	local unit_script_data_4 = var_0_0.unit_script_data(arg_2_0, -1, arg_2_1, "user_data_id")
	local var_2_4 = Color(var_0_0.unit_script_data(arg_2_0, 0, arg_2_1, "color", "r"), var_0_0.unit_script_data(arg_2_0, 255, arg_2_1, "color", "g"), var_0_0.unit_script_data(arg_2_0, 0, arg_2_1, "color", "b"))

	return unit_script_data, var_2_4, unit_script_data_2, unit_script_data_3, unit_script_data_4
end

return var_0_0
