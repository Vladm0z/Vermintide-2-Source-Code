-- chunkname: @core/gwnav/lua/runtime/navtagvolume.lua

require("core/gwnav/lua/safe_require")

local var_0_0 = safe_require_guard()
local var_0_1 = safe_require("core/gwnav/lua/runtime/navclass")(var_0_0)
local var_0_2 = stingray.GwNavTagVolume

var_0_1.init = function (arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7, arg_1_8, arg_1_9)
	arg_1_0.nav_tagvolume = var_0_2.create(arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7, arg_1_8, arg_1_9)
end

var_0_1.shutdown = function (arg_2_0)
	var_0_2.destroy(arg_2_0.nav_tagvolume)

	arg_2_0.nav_tagvolume = nil
end

var_0_1.add_to_world = function (arg_3_0)
	var_0_2.add_to_world(arg_3_0.nav_tagvolume)
end

var_0_1.remove_from_world = function (arg_4_0)
	var_0_2.remove_from_world(arg_4_0.nav_tagvolume)
end

return var_0_1
