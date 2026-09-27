-- chunkname: @scripts/entity_system/systems/target_override/target_override_system.lua

TargetOverrideSystem = class(TargetOverrideSystem, ExtensionSystemBase)

TargetOverrideSystem.init = function (self, arg_1_1, arg_1_2, arg_1_3)
	-- function 1
	TargetOverrideSystem.super.init(self, arg_1_1, arg_1_2, arg_1_3)

	local network_event_delegate = arg_1_1.network_event_delegate

	self._network_event_delegate = network_event_delegate

	network_event_delegate:register(self, "rpc_taunt")
end

TargetOverrideSystem.destroy = function (self)
	-- function 2
	TargetOverrideSystem.super.destroy(self)
	self._network_event_delegate:unregister(self)

	self._network_event_delegate = nil
end

TargetOverrideSystem.rpc_taunt = function (self, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5, arg_3_6)
	-- function 3
	local unit = self.unit_storage:unit(arg_3_2)

	ScriptUnit.extension(unit, "target_override_system"):taunt(arg_3_3, arg_3_4, arg_3_5, arg_3_6)
end
