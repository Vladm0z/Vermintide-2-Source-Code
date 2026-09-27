-- chunkname: @core/gwnav/lua/runtime/navboxobstacle.lua

require("core/gwnav/lua/safe_require")

local var_0_0 = safe_require_guard()
local var_0_1 = safe_require("core/gwnav/lua/runtime/navclass")(var_0_0)
local var_0_2 = safe_require("core/gwnav/lua/runtime/navhelpers")
local Math = stingray.Math
local Vector3 = stingray.Vector3
local Vector3Box = stingray.Vector3Box
local Matrix4x4 = stingray.Matrix4x4
local Matrix4x4Box = stingray.Matrix4x4Box
local Quaternion = stingray.Quaternion
local QuaternionBox = stingray.QuaternionBox
local Unit = stingray.Unit
local GwNavWorld = stingray.GwNavWorld
local GwNavTagVolume = stingray.GwNavTagVolume
local GwNavBoxObstacle = stingray.GwNavBoxObstacle
local tbl = {}

var_0_1.get_navboxstacle = function (arg_1_0)
	-- function 1
	return tbl[arg_1_0]
end

var_0_1.init = function (self, arg_2_1, arg_2_2)
	-- function 2
	self.unit = arg_2_2
	self.navworld = arg_2_1

	local var_2_0 = Vector3(var_0_2.unit_script_data(arg_2_2, 0.2, "GwNavBoxObstacle", "half_extent", "x"), var_0_2.unit_script_data(arg_2_2, 1, "GwNavBoxObstacle", "half_extent", "y"), var_0_2.unit_script_data(arg_2_2, 2, "GwNavBoxObstacle", "half_extent", "z"))
	local var_2_1 = Vector3(var_0_2.unit_script_data(arg_2_2, 0, "GwNavBoxObstacle", "offset", "x"), var_0_2.unit_script_data(arg_2_2, 0, "GwNavBoxObstacle", "offset", "y"), var_0_2.unit_script_data(arg_2_2, 0, "GwNavBoxObstacle", "offset", "z"))
	local get_layer_and_smartobject, var_2_3, var_2_4, var_2_5, var_2_6 = var_0_2.get_layer_and_smartobject(arg_2_2, "GwNavBoxObstacle")
	local transform = Matrix4x4.transform(arg_2_1.transform:unbox(), Unit.world_position(arg_2_2, 1))

	self.lastpos = Vector3Box(transform)
	self.last_rotation = QuaternionBox()
	self.nav_boxobstacle = GwNavBoxObstacle.create(self.navworld.gwnavworld, transform, var_2_1, var_2_0, get_layer_and_smartobject, var_2_3, var_2_4, var_2_5, var_2_6)
	self.does_trigger_tag_volume = var_0_2.unit_script_data(arg_2_2, false, "GwNavBoxObstacle", "does_trigger_tag_volume")

	self:set_does_trigger_tagvolume(trigger_tag_volume)

	self.rotation_mode = var_0_2.unit_script_data(arg_2_2, "free", "GwNavBoxObstacle", "rotation_mode") == "yaw"

	self:set_rotation_mode_around_yaw(self.rotation_mode)

	tbl[self.unit] = self
end

var_0_1.set_does_trigger_tagvolume = function (self, arg_3_1)
	-- function 3
	GwNavBoxObstacle.set_does_trigger_tagvolume(self.nav_boxobstacle, arg_3_1)
end

var_0_1.set_rotation_mode_around_yaw = function (self, arg_4_1)
	-- function 4
	GwNavBoxObstacle.set_rotation_mode_around_yaw_only(self.nav_boxobstacle, arg_4_1)
end

var_0_1.set_next_update_config = function (self, arg_5_1, arg_5_2, arg_5_3)
	-- function 5
	GwNavBoxObstacle.set_transform(self.nav_boxobstacle, arg_5_1)
	GwNavBoxObstacle.set_linear_velocity(self.nav_boxobstacle, arg_5_2)
	GwNavBoxObstacle.set_angular_velocity(self.nav_boxobstacle, arg_5_3)
end

var_0_1.update = function (self, arg_6_1)
	-- function 6
	local local_pose = Unit.local_pose(self.unit, 1)
	local translation = Matrix4x4.translation(local_pose)
	local num = (translation - self.lastpos:unbox()) / arg_6_1
	local local_rotation = Unit.local_rotation(self.unit, 1)
	local var_6_4 = self
	local set_does_trigger_tagvolume = self.set_does_trigger_tagvolume
	local does_trigger_tag_volume = self.does_trigger_tag_volume

	does_trigger_tag_volume = not does_trigger_tag_volume and Vector3.length(num) == 0

	set_does_trigger_tagvolume(var_6_4, does_trigger_tag_volume)

	local var_6_7 = Vector3(0, 0, 0)
	local unbox = self.last_rotation:unbox()

	if not Quaternion.is_valid(local_rotation) and not Quaternion.is_valid(unbox) then
		local multiply = Quaternion.multiply(Quaternion.inverse(local_rotation), unbox)
		local decompose, var_6_11 = Quaternion.decompose(multiply)

		var_6_7 = decompose * var_6_11 / arg_6_1
	end

	self:set_next_update_config(local_pose, num, var_6_7)
	self.lastpos:store(translation)
	self.last_rotation:store(local_rotation)
end

var_0_1.shutdown = function (self)
	-- function 7
	self.navworld:remove_boxobstacle(self.unit)
	GwNavBoxObstacle.destroy(self.nav_boxobstacle)

	self.nav_boxobstacle = nil
	tbl[self.unit] = nil
end

var_0_1.add_to_world = function (self)
	-- function 8
	GwNavBoxObstacle.add_to_world(self.nav_boxobstacle)
end

var_0_1.remove_from_world = function (self)
	-- function 9
	GwNavBoxObstacle.remove_from_world(self.nav_boxobstacle)
end

return var_0_1
