-- chunkname: @core/gwnav/lua/runtime/navcylinderobstacle.lua

require("core/gwnav/lua/safe_require")

local var_0_0 = safe_require_guard()
local var_0_1 = safe_require("core/gwnav/lua/runtime/navclass")(var_0_0)
local var_0_2 = safe_require("core/gwnav/lua/runtime/navhelpers")
local var_0_3 = stingray.Math
local var_0_4 = stingray.Vector3
local var_0_5 = stingray.Vector3Box
local var_0_6 = stingray.Matrix4x4
local var_0_7 = stingray.Matrix4x4Box
local var_0_8 = stingray.Unit
local var_0_9 = stingray.GwNavWorld
local var_0_10 = stingray.GwNavCylinderObstacle
local var_0_11 = {}

var_0_1.get_navcylinderostacle = function (arg_1_0)
	return var_0_11[arg_1_0]
end

var_0_1.init = function (arg_2_0, arg_2_1, arg_2_2)
	arg_2_0.unit = arg_2_2
	arg_2_0.navworld = arg_2_1

	local var_2_0 = var_0_2.unit_script_data(arg_2_2, 0.5, "GwNavCylinderObstacle", "radius")
	local var_2_1 = var_0_2.unit_script_data(arg_2_2, 2, "GwNavCylinderObstacle", "height")
	local var_2_2, var_2_3, var_2_4, var_2_5, var_2_6 = var_0_2.get_layer_and_smartobject(arg_2_2, "GwNavCylinderObstacle")
	local var_2_7 = var_0_6.transform(arg_2_1.transform:unbox(), var_0_8.world_position(arg_2_2, 1))

	arg_2_0.lastpos = var_0_5(var_2_7)
	arg_2_0.nav_cylinderobstacle = var_0_10.create(arg_2_0.navworld.gwnavworld, var_2_7, var_2_1, var_2_0, var_2_2, var_2_3, var_2_4, var_2_5, var_2_6)
	arg_2_0.does_trigger_tag_volume = var_0_2.unit_script_data(arg_2_2, false, "GwNavCylinderObstacle", "does_trigger_tag_volume")

	arg_2_0:set_does_trigger_tagvolume(arg_2_0.does_trigger_tag_volume)

	var_0_11[arg_2_0.unit] = arg_2_0
end

var_0_1.set_does_trigger_tagvolume = function (arg_3_0, arg_3_1)
	var_0_10.set_does_trigger_tagvolume(arg_3_0.nav_cylinderobstacle, arg_3_1)
end

var_0_1.set_next_update_config = function (arg_4_0, arg_4_1, arg_4_2)
	var_0_10.set_position(arg_4_0.nav_cylinderobstacle, arg_4_1)
	var_0_10.set_velocity(arg_4_0.nav_cylinderobstacle, arg_4_2)
end

var_0_1.update = function (arg_5_0, arg_5_1)
	local var_5_0 = var_0_8.world_position(arg_5_0.unit, 1)
	local var_5_1 = (var_5_0 - arg_5_0.lastpos:unbox()) / arg_5_1

	arg_5_0:set_does_trigger_tagvolume(does_trigger_tag_volume and var_0_4.length(var_5_1) == 0)
	arg_5_0:set_next_update_config(var_5_0, var_5_1)
	arg_5_0.lastpos:store(var_5_0)
end

var_0_1.shutdown = function (arg_6_0)
	arg_6_0.navworld:remove_cylinderobstacle(arg_6_0.unit)
	var_0_10.destroy(arg_6_0.nav_cylinderobstacle)

	arg_6_0.nav_cylinderobstacle = nil
	var_0_11[arg_6_0.unit] = nil
end

var_0_1.add_to_world = function (arg_7_0)
	var_0_10.add_to_world(arg_7_0.nav_cylinderobstacle)
end

var_0_1.remove_from_world = function (arg_8_0)
	var_0_10.remove_from_world(arg_8_0.nav_cylinderobstacle)
end

return var_0_1
