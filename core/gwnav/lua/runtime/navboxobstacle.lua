-- chunkname: @core/gwnav/lua/runtime/navboxobstacle.lua

require("core/gwnav/lua/safe_require")

local NavBoxObstacle = safe_require_guard()
local NavClass = safe_require("core/gwnav/lua/runtime/navclass")

NavBoxObstacle = NavClass(NavBoxObstacle)

local NavHelpers = safe_require("core/gwnav/lua/runtime/navhelpers")
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
local _navboxstacles = {}

NavBoxObstacle.get_navboxstacle = function (unit)
	-- function 1
	return _navboxstacles[unit]
end

NavBoxObstacle.init = function (self, navworld, unit)
	-- function 2
	self.unit = unit
	self.navworld = navworld

	local half_extents = Vector3(NavHelpers.unit_script_data(unit, 0.2, "GwNavBoxObstacle", "half_extent", "x"), NavHelpers.unit_script_data(unit, 1, "GwNavBoxObstacle", "half_extent", "y"), NavHelpers.unit_script_data(unit, 2, "GwNavBoxObstacle", "half_extent", "z"))
	local local_center = Vector3(NavHelpers.unit_script_data(unit, 0, "GwNavBoxObstacle", "offset", "x"), NavHelpers.unit_script_data(unit, 0, "GwNavBoxObstacle", "offset", "y"), NavHelpers.unit_script_data(unit, 0, "GwNavBoxObstacle", "offset", "z"))
	local is_exclusive, color, layer_id, smartobject_id, user_data_id = NavHelpers.get_layer_and_smartobject(unit, "GwNavBoxObstacle")
	local unitPos = Matrix4x4.transform(navworld.transform:unbox(), Unit.world_position(unit, 1))

	self.lastpos = Vector3Box(unitPos)
	self.last_rotation = QuaternionBox()
	self.nav_boxobstacle = GwNavBoxObstacle.create(self.navworld.gwnavworld, unitPos, local_center, half_extents, is_exclusive, color, layer_id, smartobject_id, user_data_id)
	self.does_trigger_tag_volume = NavHelpers.unit_script_data(unit, false, "GwNavBoxObstacle", "does_trigger_tag_volume")

	self:set_does_trigger_tagvolume(trigger_tag_volume)

	self.rotation_mode = NavHelpers.unit_script_data(unit, "free", "GwNavBoxObstacle", "rotation_mode") == "yaw"

	self:set_rotation_mode_around_yaw(self.rotation_mode)

	_navboxstacles[self.unit] = self
end

NavBoxObstacle.set_does_trigger_tagvolume = function (self, does_trigger_tag_volume)
	-- function 3
	GwNavBoxObstacle.set_does_trigger_tagvolume(self.nav_boxobstacle, does_trigger_tag_volume)
end

NavBoxObstacle.set_rotation_mode_around_yaw = function (self, rotation_mode_around_yaw_only)
	-- function 4
	GwNavBoxObstacle.set_rotation_mode_around_yaw_only(self.nav_boxobstacle, rotation_mode_around_yaw_only)
end

NavBoxObstacle.set_next_update_config = function (self, transform, linear_velocity, angular_velocity)
	-- function 5
	GwNavBoxObstacle.set_transform(self.nav_boxobstacle, transform)
	GwNavBoxObstacle.set_linear_velocity(self.nav_boxobstacle, linear_velocity)
	GwNavBoxObstacle.set_angular_velocity(self.nav_boxobstacle, angular_velocity)
end

NavBoxObstacle.update = function (self, dt)
	-- function 6
	local transform = Unit.local_pose(self.unit, 1)
	local pos = Matrix4x4.translation(transform)
	local linear_velocity = (pos - self.lastpos:unbox()) / dt
	local rotation = Unit.local_rotation(self.unit, 1)

	self:set_does_trigger_tagvolume(not not self.does_trigger_tag_volume)

	local angular_velocity = Vector3(0, 0, 0)
	local last_rot = self.last_rotation:unbox()

	if Quaternion.is_valid(rotation) and Quaternion.is_valid(last_rot) then
		local rotation_delta = Quaternion.multiply(Quaternion.inverse(rotation), last_rot)
		local angular_velocity_vector, angular_delta = Quaternion.decompose(rotation_delta)

		angular_velocity = angular_velocity_vector * angular_delta / dt
	end

	self:set_next_update_config(transform, linear_velocity, angular_velocity)
	self.lastpos:store(pos)
	self.last_rotation:store(rotation)
end

NavBoxObstacle.shutdown = function (self)
	-- function 7
	self.navworld:remove_boxobstacle(self.unit)
	GwNavBoxObstacle.destroy(self.nav_boxobstacle)

	self.nav_boxobstacle = nil
	_navboxstacles[self.unit] = nil
end

NavBoxObstacle.add_to_world = function (self)
	-- function 8
	GwNavBoxObstacle.add_to_world(self.nav_boxobstacle)
end

NavBoxObstacle.remove_from_world = function (self)
	-- function 9
	GwNavBoxObstacle.remove_from_world(self.nav_boxobstacle)
end

return NavBoxObstacle
