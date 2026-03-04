-- chunkname: @core/gwnav/lua/runtime/navmeshcamera.lua

require("core/gwnav/lua/safe_require")

local var_0_0 = safe_require_guard()
local var_0_1 = safe_require("core/gwnav/lua/runtime/navclass")(var_0_0)
local var_0_2 = stingray.Math
local var_0_3 = stingray.Vector2
local var_0_4 = stingray.Vector3
local var_0_5 = stingray.Vector3Box
local var_0_6 = stingray.Matrix4x4
local var_0_7 = stingray.Matrix4x4Box
local var_0_8 = stingray.Quaternion
local var_0_9 = stingray.QuaternionBox
local var_0_10 = stingray.Gui
local var_0_11 = stingray.World
local var_0_12 = stingray.Unit
local var_0_13 = stingray.Camera
local var_0_14 = stingray.ShadingEnvironment
local var_0_15 = stingray.Application
local var_0_16 = stingray.Color
local var_0_17 = stingray.LineObject
local var_0_18 = stingray.PhysicsWorld
local var_0_19 = stingray.Level
local var_0_20

if stingray.Window then
	local var_0_21 = stingray.Window
end

local var_0_22 = stingray.Script
local var_0_23 = stingray.BakedLighting
local var_0_24 = stingray.Keyboard
local var_0_25 = stingray.Mouse
local var_0_26 = stingray.GwNavWorld
local var_0_27 = stingray.GwNavBot
local var_0_28 = stingray.GwNavSmartObjectInterval
local var_0_29 = stingray.GwNavQueries
local var_0_30 = stingray.GwNavAStar
local var_0_31 = stingray.GwNavTagVolume
local var_0_32 = stingray.GwNavBoxObstacle
local var_0_33 = stingray.GwNavCylinderObstacle
local var_0_34 = stingray.GwNavGraph
local var_0_35 = stingray.GwNavTraversal
local var_0_36 = stingray.GwNavGeneration

function var_0_1.init(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
	arg_1_0.camera = arg_1_1
	arg_1_0.unit = arg_1_2
	arg_1_0.nav_world = arg_1_3
	arg_1_0.translation_speed = 3

	if var_0_15.platform() == "win32" then
		arg_1_0.rotation_speed = 0.003
	else
		arg_1_0.rotation_speed = 0.03
	end
end

function var_0_1.update(arg_2_0, arg_2_1)
	local var_2_0 = {}

	if var_0_15.platform() == "win32" or var_0_15.platform() == "macosx" then
		var_2_0.pan = var_0_25.axis(var_0_25.axis_id("mouse"))
		var_2_0.accelerate = var_0_4.y(var_0_25.axis(var_0_25.axis_id("wheel")))
		var_2_0.move = var_0_4(var_0_24.button(var_0_24.button_id("d")) - var_0_24.button(var_0_24.button_id("a")), var_0_24.button(var_0_24.button_id("w")) - var_0_24.button(var_0_24.button_id("s")), var_0_24.button(var_0_24.button_id("e")) - var_0_24.button(var_0_24.button_id("q")))
	else
		return
	end

	local var_2_1 = arg_2_0.translation_speed * 0.1

	arg_2_0.translation_speed = arg_2_0.translation_speed + var_2_0.accelerate * var_2_1

	if arg_2_0.translation_speed < 0.001 then
		arg_2_0.translation_speed = 0.001
	end

	if arg_2_0.translation_speed > 1000 then
		arg_2_0.translation_speed = 1000
	end

	local var_2_2 = var_0_13.local_pose(arg_2_0.camera)
	local var_2_3 = var_0_6.translation(var_2_2)

	var_0_6.set_translation(var_2_2, var_0_4(0, 0, 0))

	local var_2_4 = var_0_8(var_0_4(0, 0, 1), -var_0_4.x(var_2_0.pan) * arg_2_0.rotation_speed)
	local var_2_5 = var_0_8(var_0_6.x(var_2_2), -var_0_4.y(var_2_0.pan) * arg_2_0.rotation_speed)
	local var_2_6 = var_0_8.multiply(var_2_4, var_2_5)
	local var_2_7 = var_0_6.multiply(var_2_2, var_0_6.from_quaternion(var_2_6))
	local var_2_8 = var_0_6.transform(var_2_7, var_2_0.move * arg_2_0.translation_speed)
	local var_2_9 = var_0_29.move_on_navmesh(arg_2_0.nav_world, var_2_3, var_2_8, arg_2_1)

	var_0_6.set_translation(var_2_7, var_2_9)
	var_0_13.set_local_pose(arg_2_0.camera, arg_2_0.unit, var_2_7)
end

return var_0_1
