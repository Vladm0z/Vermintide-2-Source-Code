-- chunkname: @core/gwnav/lua/runtime/navroute.lua

require("core/gwnav/lua/safe_require")

local var_0_0 = safe_require_guard()
local var_0_1 = safe_require("core/gwnav/lua/runtime/navclass")(var_0_0)
local Vector3Box = stingray.Vector3Box

var_0_1.init = function (self)
	-- function 1
	self._positions = {}
end

var_0_1.add_position = function (arg_2_0, arg_2_1)
	-- function 2
	arg_2_0._positions[#arg_2_0._positions + 1] = Vector3Box(arg_2_1)
end

var_0_1.positions = function (self)
	-- function 3
	return self._positions
end

return var_0_1
