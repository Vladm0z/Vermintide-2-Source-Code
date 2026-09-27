-- chunkname: @core/gwnav/lua/runtime/navcylinderobstacle.lua

require("core/gwnav/lua/safe_require")

local var_0_0 = safe_require_guard()
local var_0_1 = safe_require("core/gwnav/lua/runtime/navclass")(var_0_0)
local var_0_2 = safe_require("core/gwnav/lua/runtime/navhelpers")
local Math = stingray.Math
local Vector3 = stingray.Vector3
local Vector3Box = stingray.Vector3Box
local Matrix4x4 = stingray.Matrix4x4
local Matrix4x4Box = stingray.Matrix4x4Box
local Unit = stingray.Unit
local GwNavWorld = stingray.GwNavWorld
local GwNavCylinderObstacle = stingray.GwNavCylinderObstacle
local tbl = {}

var_0_1.get_navcylinderostacle = function (arg_1_0)
	-- function 1
	return tbl[arg_1_0]
end

var_0_1.init = function (self, arg_2_1, arg_2_2)
	-- function 2
	self.unit = arg_2_2
	self.navworld = arg_2_1

	local unit_script_data = var_0_2.unit_script_data(arg_2_2, 0.5, "GwNavCylinderObstacle", "radius")
	local unit_script_data_2 = var_0_2.unit_script_data(arg_2_2, 2, "GwNavCylinderObstacle", "height")
	local get_layer_and_smartobject, var_2_3, var_2_4, var_2_5, var_2_6 = var_0_2.get_layer_and_smartobject(arg_2_2, "GwNavCylinderObstacle")
	local transform = Matrix4x4.transform(arg_2_1.transform:unbox(), Unit.world_position(arg_2_2, 1))

	self.lastpos = Vector3Box(transform)
	self.nav_cylinderobstacle = GwNavCylinderObstacle.create(self.navworld.gwnavworld, transform, unit_script_data_2, unit_script_data, get_layer_and_smartobject, var_2_3, var_2_4, var_2_5, var_2_6)
	self.does_trigger_tag_volume = var_0_2.unit_script_data(arg_2_2, false, "GwNavCylinderObstacle", "does_trigger_tag_volume")

	self:set_does_trigger_tagvolume(self.does_trigger_tag_volume)

	tbl[self.unit] = self
end

var_0_1.set_does_trigger_tagvolume = function (self, arg_3_1)
	-- function 3
	GwNavCylinderObstacle.set_does_trigger_tagvolume(self.nav_cylinderobstacle, arg_3_1)
end

var_0_1.set_next_update_config = function (self, arg_4_1, arg_4_2)
	-- function 4
	GwNavCylinderObstacle.set_position(self.nav_cylinderobstacle, arg_4_1)
	GwNavCylinderObstacle.set_velocity(self.nav_cylinderobstacle, arg_4_2)
end

var_0_1.update = function (self, arg_5_1)
	-- function 5
	local world_position = Unit.world_position(self.unit, 1)
	local num = (world_position - self.lastpos:unbox()) / arg_5_1
	local var_5_2 = self
	local set_does_trigger_tagvolume = self.set_does_trigger_tagvolume
	local does_trigger_tag_volume = does_trigger_tag_volume

	does_trigger_tag_volume = not does_trigger_tag_volume and Vector3.length(num) == 0

	set_does_trigger_tagvolume(var_5_2, does_trigger_tag_volume)
	self:set_next_update_config(world_position, num)
	self.lastpos:store(world_position)
end

var_0_1.shutdown = function (self)
	-- function 6
	self.navworld:remove_cylinderobstacle(self.unit)
	GwNavCylinderObstacle.destroy(self.nav_cylinderobstacle)

	self.nav_cylinderobstacle = nil
	tbl[self.unit] = nil
end

var_0_1.add_to_world = function (self)
	-- function 7
	GwNavCylinderObstacle.add_to_world(self.nav_cylinderobstacle)
end

var_0_1.remove_from_world = function (self)
	-- function 8
	GwNavCylinderObstacle.remove_from_world(self.nav_cylinderobstacle)
end

return var_0_1
