-- chunkname: @scripts/entity_system/systems/target_override/target_override_system.lua

TargetOverrideSystem = class(TargetOverrideSystem, ExtensionSystemBase)

function TargetOverrideSystem.init(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
	TargetOverrideSystem.super.init(arg_1_0, arg_1_1, arg_1_2, arg_1_3)

	local var_1_0 = arg_1_1.network_event_delegate

	arg_1_0._network_event_delegate = var_1_0

	var_1_0:register(arg_1_0, "rpc_taunt")
end

function TargetOverrideSystem.destroy(arg_2_0)
	TargetOverrideSystem.super.destroy(arg_2_0)
	arg_2_0._network_event_delegate:unregister(arg_2_0)

	arg_2_0._network_event_delegate = nil
end

function TargetOverrideSystem.rpc_taunt(arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5, arg_3_6)
	local var_3_0 = arg_3_0.unit_storage:unit(arg_3_2)

	ScriptUnit.extension(var_3_0, "target_override_system"):taunt(arg_3_3, arg_3_4, arg_3_5, arg_3_6)
end
