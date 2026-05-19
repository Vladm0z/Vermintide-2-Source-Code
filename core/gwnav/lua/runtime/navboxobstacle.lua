-- chunkname: @core/gwnav/lua/runtime/navboxobstacle.lua

require("core/gwnav/lua/safe_require")

local var_0_0 = safe_require_guard()
local var_0_1 = safe_require("core/gwnav/lua/runtime/navclass")(var_0_0)
local var_0_2 = safe_require("core/gwnav/lua/runtime/navhelpers")
local var_0_3 = stingray.Math
local var_0_4 = stingray.Vector3
local var_0_5 = stingray.Vector3Box
local var_0_6 = stingray.Matrix4x4
local var_0_7 = stingray.Matrix4x4Box
local var_0_8 = stingray.Quaternion
local var_0_9 = stingray.QuaternionBox
local var_0_10 = stingray.Unit
local var_0_11 = stingray.GwNavWorld
local var_0_12 = stingray.GwNavTagVolume
local var_0_13 = stingray.GwNavBoxObstacle
local var_0_14 = {}

function var_0_1.get_navboxstacle(arg_1_0)
	return var_0_14[arg_1_0]
end

function var_0_1.init(arg_2_0, arg_2_1, arg_2_2)
	arg_2_0.unit = arg_2_2
	arg_2_0.navworld = arg_2_1

	local var_2_0 = var_0_4(var_0_2.unit_script_data(arg_2_2, 0.2, "GwNavBoxObstacle", "half_extent", "x"), var_0_2.unit_script_data(arg_2_2, 1, "GwNavBoxObstacle", "half_extent", "y"), var_0_2.unit_script_data(arg_2_2, 2, "GwNavBoxObstacle", "half_extent", "z"))
	local var_2_1 = var_0_4(var_0_2.unit_script_data(arg_2_2, 0, "GwNavBoxObstacle", "offset", "x"), var_0_2.unit_script_data(arg_2_2, 0, "GwNavBoxObstacle", "offset", "y"), var_0_2.unit_script_data(arg_2_2, 0, "GwNavBoxObstacle", "offset", "z"))
	local var_2_2, var_2_3, var_2_4, var_2_5, var_2_6 = var_0_2.get_layer_and_smartobject(arg_2_2, "GwNavBoxObstacle")
	local var_2_7 = var_0_6.transform(arg_2_1.transform:unbox(), var_0_10.world_position(arg_2_2, 1))

	arg_2_0.lastpos = var_0_5(var_2_7)
	arg_2_0.last_rotation = var_0_9()
	arg_2_0.nav_boxobstacle = var_0_13.create(arg_2_0.navworld.gwnavworld, var_2_7, var_2_1, var_2_0, var_2_2, var_2_3, var_2_4, var_2_5, var_2_6)
	arg_2_0.does_trigger_tag_volume = var_0_2.unit_script_data(arg_2_2, false, "GwNavBoxObstacle", "does_trigger_tag_volume")

	arg_2_0:set_does_trigger_tagvolume(trigger_tag_volume)

	arg_2_0.rotation_mode = var_0_2.unit_script_data(arg_2_2, "free", "GwNavBoxObstacle", "rotation_mode") == "yaw"

	arg_2_0:set_rotation_mode_around_yaw(arg_2_0.rotation_mode)

	var_0_14[arg_2_0.unit] = arg_2_0
end

function var_0_1.set_does_trigger_tagvolume(arg_3_0, arg_3_1)
	var_0_13.set_does_trigger_tagvolume(arg_3_0.nav_boxobstacle, arg_3_1)
end

function var_0_1.set_rotation_mode_around_yaw(arg_4_0, arg_4_1)
	var_0_13.set_rotation_mode_around_yaw_only(arg_4_0.nav_boxobstacle, arg_4_1)
end

function var_0_1.set_next_update_config(arg_5_0, arg_5_1, arg_5_2, arg_5_3)
	var_0_13.set_transform(arg_5_0.nav_boxobstacle, arg_5_1)
	var_0_13.set_linear_velocity(arg_5_0.nav_boxobstacle, arg_5_2)
	var_0_13.set_angular_velocity(arg_5_0.nav_boxobstacle, arg_5_3)
end

function var_0_1.update(arg_6_0, arg_6_1)
	local var_6_0 = var_0_10.local_pose(arg_6_0.unit, 1)
	local var_6_1 = var_0_6.translation(var_6_0)
	local var_6_2 = (var_6_1 - arg_6_0.lastpos:unbox()) / arg_6_1
	local var_6_3 = var_0_10.local_rotation(arg_6_0.unit, 1)

	arg_6_0:set_does_trigger_tagvolume(arg_6_0.does_trigger_tag_volume and var_0_4.length(var_6_2) == 0)

	local var_6_4 = var_0_4(0, 0, 0)
	local var_6_5 = arg_6_0.last_rotation:unbox()

	if var_0_8.is_valid(var_6_3) and var_0_8.is_valid(var_6_5) then
		local var_6_6 = var_0_8.multiply(var_0_8.inverse(var_6_3), var_6_5)
		local var_6_7, var_6_8 = var_0_8.decompose(var_6_6)

		var_6_4 = var_6_7 * var_6_8 / arg_6_1
	end

	arg_6_0:set_next_update_config(var_6_0, var_6_2, var_6_4)
	arg_6_0.lastpos:store(var_6_1)
	arg_6_0.last_rotation:store(var_6_3)
end

function var_0_1.shutdown(arg_7_0)
	arg_7_0.navworld:remove_boxobstacle(arg_7_0.unit)
	var_0_13.destroy(arg_7_0.nav_boxobstacle)

	arg_7_0.nav_boxobstacle = nil
	var_0_14[arg_7_0.unit] = nil
end

function var_0_1.add_to_world(arg_8_0)
	var_0_13.add_to_world(arg_8_0.nav_boxobstacle)
end

function var_0_1.remove_from_world(arg_9_0)
	var_0_13.remove_from_world(arg_9_0.nav_boxobstacle)
end

return var_0_1
