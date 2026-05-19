-- chunkname: @scripts/unit_extensions/camera/states/camera_state.lua

CameraState = class(CameraState)

function CameraState.init(arg_1_0, arg_1_1, arg_1_2)
	arg_1_0.name = arg_1_2
	arg_1_0.world = arg_1_1.world
	arg_1_0.unit = arg_1_1.unit
	arg_1_0.csm = arg_1_1.csm
	arg_1_0.temp_params = {}
	arg_1_0.camera_extension = ScriptUnit.extension(arg_1_0.unit, "camera_system")
end
