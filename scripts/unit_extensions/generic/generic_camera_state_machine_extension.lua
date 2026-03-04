-- chunkname: @scripts/unit_extensions/generic/generic_camera_state_machine_extension.lua

require("scripts/unit_extensions/generic/generic_state_machine")

GenericCameraStateMachineExtension = class(GenericCameraStateMachineExtension)

GenericCameraStateMachineExtension.init = function (arg_1_0, arg_1_1, arg_1_2, arg_1_3)
	arg_1_0.world = arg_1_1.world
	arg_1_0.unit = arg_1_2
	arg_1_0.start_state = arg_1_3.start_state
	arg_1_0.camera_state_class_list = arg_1_3.camera_state_class_list
	arg_1_0.state_machine = GenericStateMachine:new(arg_1_0.world, arg_1_0.unit)
end

GenericCameraStateMachineExtension.extensions_ready = function (arg_2_0)
	local var_2_0 = {
		world = arg_2_0.world,
		unit = arg_2_0.unit,
		csm = arg_2_0.state_machine
	}
	local var_2_1 = {}
	local var_2_2 = arg_2_0.camera_state_class_list

	for iter_2_0 = 1, #var_2_2 do
		local var_2_3 = var_2_2[iter_2_0]:new(var_2_0)
		local var_2_4 = var_2_3.name

		assert(var_2_4 and var_2_1[var_2_4] == nil)

		var_2_1[var_2_4] = var_2_3
	end

	local var_2_5 = arg_2_0.start_state

	arg_2_0.state_machine:post_init(var_2_1, var_2_5)
end

GenericCameraStateMachineExtension.destroy = function (arg_3_0)
	return
end

GenericCameraStateMachineExtension.reset = function (arg_4_0)
	arg_4_0.state_machine:reset()
end

GenericCameraStateMachineExtension.update = function (arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4, arg_5_5)
	arg_5_0.state_machine:update(arg_5_1, arg_5_2, arg_5_3, arg_5_4, arg_5_5)
end

GenericCameraStateMachineExtension.reinitialize_camera_states = function (arg_6_0, arg_6_1, arg_6_2)
	arg_6_2 = arg_6_2 or arg_6_0.start_state
	arg_6_1 = arg_6_1 or table.clone(arg_6_0.camera_state_class_list)
	arg_6_0.state_machine = nil

	table.clear(arg_6_0.camera_state_class_list)

	arg_6_0.camera_state_class_list = arg_6_1
	arg_6_0.state_machine = GenericStateMachine:new(arg_6_0.world, arg_6_0.unit)

	arg_6_0:extensions_ready()
end
