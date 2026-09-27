-- chunkname: @core/gwnav/lua/runtime/navgraph.lua

require("core/gwnav/lua/safe_require")

local var_0_0 = safe_require_guard()
local var_0_1 = safe_require("core/gwnav/lua/runtime/navclass")(var_0_0)
local GwNavGraph = stingray.GwNavGraph

var_0_1.init = function (self, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7)
	-- function 1
	self.nav_navgraph = GwNavGraph.create(arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7)
end

var_0_1.shutdown = function (self)
	-- function 2
	GwNavGraph.destroy(self.nav_navgraph)

	self.nav_navgraph = nil
end

var_0_1.add_to_database = function (self)
	-- function 3
	GwNavGraph.add_to_database(self.nav_navgraph)
end

var_0_1.remove_from_database = function (self)
	-- function 4
	GwNavGraph.remove_from_database(self.nav_navgraph)
end

return var_0_1
