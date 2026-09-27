-- chunkname: @scripts/unit_extensions/camera/states/camera_state.lua

CameraState = class(CameraState)

CameraState.init = function (self, arg_1_1, arg_1_2)
	-- function 1
	self.name = arg_1_2
	self.world = arg_1_1.world
	self.unit = arg_1_1.unit
	self.csm = arg_1_1.csm
	self.temp_params = {}
	self.camera_extension = ScriptUnit.extension(self.unit, "camera_system")
end
