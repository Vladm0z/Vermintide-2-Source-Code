-- chunkname: @core/gwnav/lua/runtime/navmeshcamera.lua

require("core/gwnav/lua/safe_require")

local var_0_0 = safe_require_guard()
local var_0_1 = safe_require("core/gwnav/lua/runtime/navclass")(var_0_0)
local Math = stingray.Math
local Vector2 = stingray.Vector2
local Vector3 = stingray.Vector3
local Vector3Box = stingray.Vector3Box
local Matrix4x4 = stingray.Matrix4x4
local Matrix4x4Box = stingray.Matrix4x4Box
local Quaternion = stingray.Quaternion
local QuaternionBox = stingray.QuaternionBox
local Gui = stingray.Gui
local World = stingray.World
local Unit = stingray.Unit
local Camera = stingray.Camera
local ShadingEnvironment = stingray.ShadingEnvironment
local Application = stingray.Application
local Color = stingray.Color
local LineObject = stingray.LineObject
local PhysicsWorld = stingray.PhysicsWorld
local Level = stingray.Level
local var_0_20

if not stingray.Window then
	local Window = stingray.Window
end

local Script = stingray.Script
local BakedLighting = stingray.BakedLighting
local Keyboard = stingray.Keyboard
local Mouse = stingray.Mouse
local GwNavWorld = stingray.GwNavWorld
local GwNavBot = stingray.GwNavBot
local GwNavSmartObjectInterval = stingray.GwNavSmartObjectInterval
local GwNavQueries = stingray.GwNavQueries
local GwNavAStar = stingray.GwNavAStar
local GwNavTagVolume = stingray.GwNavTagVolume
local GwNavBoxObstacle = stingray.GwNavBoxObstacle
local GwNavCylinderObstacle = stingray.GwNavCylinderObstacle
local GwNavGraph = stingray.GwNavGraph
local GwNavTraversal = stingray.GwNavTraversal
local GwNavGeneration = stingray.GwNavGeneration

var_0_1.init = function (self, arg_1_1, arg_1_2, arg_1_3)
	-- function 1
	self.camera = arg_1_1
	self.unit = arg_1_2
	self.nav_world = arg_1_3
	self.translation_speed = 3

	if Application.platform() == "win32" then
		self.rotation_speed = 0.003
	else
		self.rotation_speed = 0.03
	end
end

var_0_1.update = function (self, arg_2_1)
	-- function 2
	local tbl = {}

	if not (Application.platform() == "win32" or Application.platform() ~= "macosx") then
		tbl.pan = Mouse.axis(Mouse.axis_id("mouse"))
		tbl.accelerate = Vector3.y(Mouse.axis(Mouse.axis_id("wheel")))
		tbl.move = Vector3(Keyboard.button(Keyboard.button_id("d")) - Keyboard.button(Keyboard.button_id("a")), Keyboard.button(Keyboard.button_id("w")) - Keyboard.button(Keyboard.button_id("s")), Keyboard.button(Keyboard.button_id("e")) - Keyboard.button(Keyboard.button_id("q")))
	else
		return
	end

	local num = self.translation_speed * 0.1

	self.translation_speed = self.translation_speed + tbl.accelerate * num

	if self.translation_speed < 0.001 then
		self.translation_speed = 0.001
	end

	if self.translation_speed > 1000 then
		self.translation_speed = 1000
	end

	local local_pose = Camera.local_pose(self.camera)
	local translation = Matrix4x4.translation(local_pose)

	Matrix4x4.set_translation(local_pose, Vector3(0, 0, 0))

	local var_2_4 = Quaternion(Vector3(0, 0, 1), -Vector3.x(tbl.pan) * self.rotation_speed)
	local var_2_5 = Quaternion(Matrix4x4.x(local_pose), -Vector3.y(tbl.pan) * self.rotation_speed)
	local multiply = Quaternion.multiply(var_2_4, var_2_5)
	local multiply_2 = Matrix4x4.multiply(local_pose, Matrix4x4.from_quaternion(multiply))
	local transform = Matrix4x4.transform(multiply_2, tbl.move * self.translation_speed)
	local move_on_navmesh = GwNavQueries.move_on_navmesh(self.nav_world, translation, transform, arg_2_1)

	Matrix4x4.set_translation(multiply_2, move_on_navmesh)
	Camera.set_local_pose(self.camera, self.unit, multiply_2)
end

return var_0_1
