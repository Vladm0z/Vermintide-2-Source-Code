-- chunkname: @core/gwnav/lua/runtime/navdefaultsmartobjectfollower.lua

require("core/gwnav/lua/safe_require")

local var_0_0 = safe_require_guard()
local var_0_1 = safe_require("core/gwnav/lua/runtime/navclass")(var_0_0)
local var_0_2 = stingray.Math
local var_0_3 = stingray.Vector3
local var_0_4 = stingray.Vector3Box
local var_0_5 = stingray.Unit
local var_0_6 = stingray.Level
local var_0_7 = stingray.GwNavBot
local var_0_8 = stingray.GwNavSmartObjectInterval
local var_0_9 = stingray.Mover

var_0_1.init = function (arg_1_0, arg_1_1)
	arg_1_0.navbot = arg_1_1
	arg_1_0.free_fall_acceleration = 9.81
	arg_1_0.jump_start = var_0_4(0, 0, 0)
	arg_1_0.jump_target = var_0_4(0, 0, 0)
	arg_1_0.jump_height = 1
	arg_1_0.jump_velocity = var_0_4(0, 0, 0)
	arg_1_0.jump_forward = var_0_4(0, 0, 0)
end

var_0_1.initial_jump_velocity = function (arg_2_0)
	local var_2_0 = arg_2_0.jump_start:unbox()
	local var_2_1 = arg_2_0.jump_target:unbox()
	local var_2_2 = var_0_3.z(var_2_0)
	local var_2_3 = var_0_3.z(var_2_1)
	local var_2_4 = math.max(var_2_2, var_2_3) + arg_2_0.jump_height
	local var_2_5 = math.sqrt(2 * arg_2_0.free_fall_acceleration * (var_2_4 - var_2_2))
	local var_2_6 = var_2_5 * var_2_5 + 2 * arg_2_0.free_fall_acceleration * (var_2_2 - var_2_3)
	local var_2_7 = (var_2_5 + math.sqrt(var_2_6)) / arg_2_0.free_fall_acceleration
	local var_2_8 = var_2_1 - var_2_0

	var_0_3.set_z(var_2_8, 0)

	local var_2_9 = var_2_8 / var_2_7

	arg_2_0.jump_forward:store(var_0_3.normalize(var_2_9))
	var_0_3.set_z(var_2_9, var_2_5)
	arg_2_0.jump_velocity:store(var_2_9)
end

var_0_1.update_follow = function (arg_3_0, arg_3_1)
	if 0.5 > var_0_3.distance(arg_3_0.jump_target:unbox(), arg_3_0.navbot:get_position()) and var_0_7.exit_manual_control(arg_3_0.navbot.gwnavbot) == true then
		arg_3_0.navbot.is_smartobject_driven = false
	end
end

var_0_1.move_unit = function (arg_4_0, arg_4_1)
	local var_4_0 = arg_4_0.navbot:get_position()
	local var_4_1 = arg_4_0.jump_velocity:unbox()
	local var_4_2 = arg_4_0.jump_forward:unbox()

	arg_4_0.navbot:update_pose(var_4_2, var_4_0 + var_4_1 * arg_4_1)
	arg_4_0.jump_velocity:store(var_4_1 - var_0_3(0, 0, arg_4_0.free_fall_acceleration) * arg_4_1)
end

var_0_1.move_unit_with_mover = function (arg_5_0, arg_5_1, arg_5_2)
	local var_5_0 = arg_5_0.navbot:get_position()
	local var_5_1 = arg_5_0.jump_velocity:unbox()
	local var_5_2 = arg_5_0.jump_forward:unbox()

	var_0_9.set_position(arg_5_2, var_5_0 + var_5_1 * arg_5_1)
	arg_5_0.navbot:update_pose(var_5_2, var_0_9.position(arg_5_2))
	arg_5_0.jump_velocity:store(var_5_1 - var_0_3(0, 0, arg_5_0.free_fall_acceleration) * arg_5_1)
end

var_0_1.get_smartobject_type = function (arg_6_0, arg_6_1)
	return arg_6_0.navbot.navworld:get_smartobject_type(var_0_8.smartobject_id(arg_6_1))
end

var_0_1.handle_next_smartobject = function (arg_7_0, arg_7_1, arg_7_2, arg_7_3, arg_7_4, arg_7_5, arg_7_6)
	local var_7_0 = 1
	local var_7_1 = arg_7_0:get_smartobject_type(arg_7_2)

	if var_7_1 == "Door" then
		arg_7_0:manage_door_smartobject(arg_7_1, arg_7_2, arg_7_3, var_7_0)
	elseif var_7_1 == "Jump" then
		arg_7_0:manage_jump_smartobject(arg_7_1, arg_7_2, arg_7_3, arg_7_5, var_7_0)
	end
end

var_0_1.manage_door_smartobject = function (arg_8_0, arg_8_1, arg_8_2, arg_8_3, arg_8_4)
	if arg_8_4 > var_0_3.distance(arg_8_3, arg_8_1) and var_0_8.can_traverse_smartobject(arg_8_2) == false then
		arg_8_0.navbot:repath()
	end
end

var_0_1.start_follow = function (arg_9_0, arg_9_1, arg_9_2)
	arg_9_0.navbot.is_smartobject_driven = true

	arg_9_0.jump_start:store(arg_9_0.navbot:get_position())
	arg_9_0.jump_target:store(arg_9_1)
	var_0_5.animation_event(arg_9_0.navbot.unit, arg_9_2)
end

var_0_1.manage_jump_smartobject = function (arg_10_0, arg_10_1, arg_10_2, arg_10_3, arg_10_4, arg_10_5)
	if arg_10_5 > var_0_3.distance(arg_10_3, arg_10_1) then
		if arg_10_0.navbot.is_smartobject_driven == false and var_0_8.can_traverse_smartobject(arg_10_2) == false then
			arg_10_0.navbot:repath()
		end

		if arg_10_0.navbot.is_smartobject_driven == false and var_0_7.enter_manual_control(arg_10_0.navbot.gwnavbot, arg_10_2) == true then
			arg_10_0:start_follow(arg_10_4, "Jump")
			arg_10_0:initial_jump_velocity()
		end
	end
end

return var_0_1
