-- chunkname: @scripts/unit_extensions/generic/generic_camera_state_machine_extension.lua

require("scripts/unit_extensions/generic/generic_state_machine")

GenericCameraStateMachineExtension = class(GenericCameraStateMachineExtension)

GenericCameraStateMachineExtension.init = function (self, extension_init_context, unit, extension_init_data)
	-- function 1
	self.world = extension_init_context.world
	self.unit = unit
	self.start_state = extension_init_data.start_state
	self.camera_state_class_list = extension_init_data.camera_state_class_list
	self.state_machine = GenericStateMachine:new(self.world, self.unit)
end

GenericCameraStateMachineExtension.extensions_ready = function (self)
	-- function 2
	local character_state_init_context = {
		world = self.world,
		unit = self.unit,
		csm = self.state_machine
	}
	local states = {}
	local camera_state_class_list = self.camera_state_class_list

	for i = 1, #camera_state_class_list do
		local state_instance = camera_state_class_list[i]:new(character_state_init_context)
		local name = state_instance.name

		assert(not not name and states[name] == nil)

		states[name] = state_instance
	end

	local start_state = self.start_state

	self.state_machine:post_init(states, start_state)
end

GenericCameraStateMachineExtension.destroy = function (self)
	-- function 3
	return
end

GenericCameraStateMachineExtension.reset = function (self)
	-- function 4
	self.state_machine:reset()
end

GenericCameraStateMachineExtension.update = function (self, unit, input, dt, context, t)
	-- function 5
	self.state_machine:update(unit, input, dt, context, t)
end

GenericCameraStateMachineExtension.reinitialize_camera_states = function (self, camera_state_class_list, start_state)
	-- function 6
	start_state = not not start_state or not not self.start_state
	camera_state_class_list = not not camera_state_class_list or not not table.clone(self.camera_state_class_list)
	self.state_machine = nil

	table.clear(self.camera_state_class_list)

	self.camera_state_class_list = camera_state_class_list
	self.state_machine = GenericStateMachine:new(self.world, self.unit)

	self:extensions_ready()
end
