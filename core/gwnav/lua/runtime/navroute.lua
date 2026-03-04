-- chunkname: @core/gwnav/lua/runtime/navroute.lua

require("core/gwnav/lua/safe_require")

local var_0_0 = safe_require_guard()
local var_0_1 = safe_require("core/gwnav/lua/runtime/navclass")(var_0_0)
local var_0_2 = stingray.Vector3Box

var_0_1.init = function (arg_1_0)
	arg_1_0._positions = {}
end

var_0_1.add_position = function (arg_2_0, arg_2_1)
	arg_2_0._positions[#arg_2_0._positions + 1] = var_0_2(arg_2_1)
end

var_0_1.positions = function (arg_3_0)
	return arg_3_0._positions
end

return var_0_1
