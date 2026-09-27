-- chunkname: @scripts/unit_extensions/generic/generic_camera_state_machine_extension.lua

require("scripts/unit_extensions/generic/generic_state_machine")

GenericCameraStateMachineExtension = class(GenericCameraStateMachineExtension)

GenericCameraStateMachineExtension.init = function (self, arg_1_1, arg_1_2, arg_1_3)
	-- function 1
	self.world = arg_1_1.world
	self.unit = arg_1_2
	self.start_state = arg_1_3.start_state
	self.camera_state_class_list = arg_1_3.camera_state_class_list
	self.state_machine = GenericStateMachine:new(self.world, self.unit)
end

GenericCameraStateMachineExtension.extensions_ready = function (self)
	-- function 2
	local tbl = {
		world = self.world,
		unit = self.unit,
		csm = self.state_machine
	}
	local tbl_2 = {}
	local camera_state_class_list = self.camera_state_class_list

	for i = 1, #camera_state_class_list do
		local var_2_3 = camera_state_class_list[i]:new(tbl)
		local name = var_2_3.name

		assert(not name and tbl_2[name] == nil)

		tbl_2[name] = var_2_3
	end

	local start_state = self.start_state

	self.state_machine:post_init(tbl_2, start_state)
end

GenericCameraStateMachineExtension.destroy = function (arg_3_0)
	-- function 3
	return
end

GenericCameraStateMachineExtension.reset = function (self)
	-- function 4
	self.state_machine:reset()
end

GenericCameraStateMachineExtension.update = function (self, arg_5_1, arg_5_2, arg_5_3, arg_5_4, arg_5_5)
	-- function 5
	self.state_machine:update(arg_5_1, arg_5_2, arg_5_3, arg_5_4, arg_5_5)
end

GenericCameraStateMachineExtension.reinitialize_camera_states = function (self, arg_6_1, arg_6_2)
	-- function 6
	arg_6_2 = arg_6_2 or self.start_state
	arg_6_1 = arg_6_1 or table.clone(self.camera_state_class_list)
	self.state_machine = nil

	table.clear(self.camera_state_class_list)

	self.camera_state_class_list = arg_6_1
	self.state_machine = GenericStateMachine:new(self.world, self.unit)

	self:extensions_ready()
end
