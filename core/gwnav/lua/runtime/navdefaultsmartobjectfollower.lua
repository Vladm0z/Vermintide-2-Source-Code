-- chunkname: @core/gwnav/lua/runtime/navdefaultsmartobjectfollower.lua

require("core/gwnav/lua/safe_require")

local var_0_0 = safe_require_guard()
local var_0_1 = safe_require("core/gwnav/lua/runtime/navclass")(var_0_0)
local Math = stingray.Math
local Vector3 = stingray.Vector3
local Vector3Box = stingray.Vector3Box
local Unit = stingray.Unit
local Level = stingray.Level
local GwNavBot = stingray.GwNavBot
local GwNavSmartObjectInterval = stingray.GwNavSmartObjectInterval
local Mover = stingray.Mover

var_0_1.init = function (self, arg_1_1)
	-- function 1
	self.navbot = arg_1_1
	self.free_fall_acceleration = 9.81
	self.jump_start = Vector3Box(0, 0, 0)
	self.jump_target = Vector3Box(0, 0, 0)
	self.jump_height = 1
	self.jump_velocity = Vector3Box(0, 0, 0)
	self.jump_forward = Vector3Box(0, 0, 0)
end

var_0_1.initial_jump_velocity = function (self)
	-- function 2
	local unbox = self.jump_start:unbox()
	local unbox_2 = self.jump_target:unbox()
	local z = Vector3.z(unbox)
	local z_2 = Vector3.z(unbox_2)
	local num = math.max(z, z_2) + self.jump_height
	local sqrt = math.sqrt(2 * self.free_fall_acceleration * (num - z))
	local num_2 = sqrt * sqrt + 2 * self.free_fall_acceleration * (z - z_2)
	local num_3 = (sqrt + math.sqrt(num_2)) / self.free_fall_acceleration
	local num_4 = unbox_2 - unbox

	Vector3.set_z(num_4, 0)

	local num_5 = num_4 / num_3

	self.jump_forward:store(Vector3.normalize(num_5))
	Vector3.set_z(num_5, sqrt)
	self.jump_velocity:store(num_5)
end

var_0_1.update_follow = function (self, arg_3_1)
	-- function 3
	if not (not (0.5 > Vector3.distance(self.jump_target:unbox(), self.navbot:get_position())) or GwNavBot.exit_manual_control(self.navbot.gwnavbot) ~= true) then
		self.navbot.is_smartobject_driven = false
	end
end

var_0_1.move_unit = function (self, arg_4_1)
	-- function 4
	local get_position = self.navbot:get_position()
	local unbox = self.jump_velocity:unbox()
	local unbox_2 = self.jump_forward:unbox()

	self.navbot:update_pose(unbox_2, get_position + unbox * arg_4_1)
	self.jump_velocity:store(unbox - Vector3(0, 0, self.free_fall_acceleration) * arg_4_1)
end

var_0_1.move_unit_with_mover = function (self, arg_5_1, arg_5_2)
	-- function 5
	local get_position = self.navbot:get_position()
	local unbox = self.jump_velocity:unbox()
	local unbox_2 = self.jump_forward:unbox()

	Mover.set_position(arg_5_2, get_position + unbox * arg_5_1)
	self.navbot:update_pose(unbox_2, Mover.position(arg_5_2))
	self.jump_velocity:store(unbox - Vector3(0, 0, self.free_fall_acceleration) * arg_5_1)
end

var_0_1.get_smartobject_type = function (self, arg_6_1)
	-- function 6
	return self.navbot.navworld:get_smartobject_type(GwNavSmartObjectInterval.smartobject_id(arg_6_1))
end

var_0_1.handle_next_smartobject = function (self, arg_7_1, arg_7_2, arg_7_3, arg_7_4, arg_7_5, arg_7_6)
	-- function 7
	local num = 1
	local get_smartobject_type = self:get_smartobject_type(arg_7_2)

	if get_smartobject_type == "Door" then
		self:manage_door_smartobject(arg_7_1, arg_7_2, arg_7_3, num)
	elseif get_smartobject_type == "Jump" then
		self:manage_jump_smartobject(arg_7_1, arg_7_2, arg_7_3, arg_7_5, num)
	end
end

var_0_1.manage_door_smartobject = function (self, arg_8_1, arg_8_2, arg_8_3, arg_8_4)
	-- function 8
	if not (not (arg_8_4 > Vector3.distance(arg_8_3, arg_8_1)) or GwNavSmartObjectInterval.can_traverse_smartobject(arg_8_2) ~= false) then
		self.navbot:repath()
	end
end

var_0_1.start_follow = function (self, arg_9_1, arg_9_2)
	-- function 9
	self.navbot.is_smartobject_driven = true

	self.jump_start:store(self.navbot:get_position())
	self.jump_target:store(arg_9_1)
	Unit.animation_event(self.navbot.unit, arg_9_2)
end

var_0_1.manage_jump_smartobject = function (self, arg_10_1, arg_10_2, arg_10_3, arg_10_4, arg_10_5)
	-- function 10
	if arg_10_5 > Vector3.distance(arg_10_3, arg_10_1) then
		if not (self.navbot.is_smartobject_driven ~= false or GwNavSmartObjectInterval.can_traverse_smartobject(arg_10_2) ~= false) then
			self.navbot:repath()
		end

		if not (self.navbot.is_smartobject_driven ~= false or GwNavBot.enter_manual_control(self.navbot.gwnavbot, arg_10_2) ~= true) then
			self:start_follow(arg_10_4, "Jump")
			self:initial_jump_velocity()
		end
	end
end

return var_0_1
