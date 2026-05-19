-- chunkname: @core/gwnav/lua/runtime/navgraph.lua

require("core/gwnav/lua/safe_require")

local var_0_0 = safe_require_guard()
local var_0_1 = safe_require("core/gwnav/lua/runtime/navclass")(var_0_0)
local var_0_2 = stingray.GwNavGraph

function var_0_1.init(arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7)
	arg_1_0.nav_navgraph = var_0_2.create(arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7)
end

function var_0_1.shutdown(arg_2_0)
	var_0_2.destroy(arg_2_0.nav_navgraph)

	arg_2_0.nav_navgraph = nil
end

function var_0_1.add_to_database(arg_3_0)
	var_0_2.add_to_database(arg_3_0.nav_navgraph)
end

function var_0_1.remove_from_database(arg_4_0)
	var_0_2.remove_from_database(arg_4_0.nav_navgraph)
end

return var_0_1
