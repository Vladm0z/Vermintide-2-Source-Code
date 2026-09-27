-- chunkname: @core/gwnav/lua/runtime/navtagvolume.lua

require("core/gwnav/lua/safe_require")

local var_0_0 = safe_require_guard()
local var_0_1 = safe_require("core/gwnav/lua/runtime/navclass")(var_0_0)
local GwNavTagVolume = stingray.GwNavTagVolume

var_0_1.init = function (self, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7, arg_1_8, arg_1_9)
	-- function 1
	self.nav_tagvolume = GwNavTagVolume.create(arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7, arg_1_8, arg_1_9)
end

var_0_1.shutdown = function (self)
	-- function 2
	GwNavTagVolume.destroy(self.nav_tagvolume)

	self.nav_tagvolume = nil
end

var_0_1.add_to_world = function (self)
	-- function 3
	GwNavTagVolume.add_to_world(self.nav_tagvolume)
end

var_0_1.remove_from_world = function (self)
	-- function 4
	GwNavTagVolume.remove_from_world(self.nav_tagvolume)
end

return var_0_1
