-- chunkname: @scripts/entity_system/systems/unit_flow_override_system/unit_flow_override_system.lua

require("scripts/entity_system/systems/unit_flow_override_system/unit_flow_event_override_settings")

UnitFlowOverrideSystem = class(UnitFlowOverrideSystem, ExtensionSystemBase)
UNIT_FLOW_EVENT = UNIT_FLOW_EVENT or Unit.flow_event

if not UNIT_FLOW_EVENT_OVERRIDDEN then
	Unit.flow_event = function (arg_1_0, arg_1_1, arg_1_2)
		local var_1_0 = ScriptUnit.has_extension(arg_1_0, "unit_flow_override_system")

		if var_1_0 and UnitFlowEventOverrideSettings[arg_1_1] then
			var_1_0.handle_flow_event(arg_1_0, arg_1_1, arg_1_2)
		else
			UNIT_FLOW_EVENT(arg_1_0, arg_1_1, arg_1_2)
		end
	end

	UNIT_FLOW_EVENT_OVERRIDDEN = true
end

local var_0_0 = {
	"UnitFlowOverrideExtension"
}

UnitFlowOverrideSystem.init = function (arg_2_0, arg_2_1, arg_2_2)
	UnitFlowOverrideSystem.super.init(arg_2_0, arg_2_1, arg_2_2, var_0_0)

	arg_2_0._unit_extensions = {}
	arg_2_0._unit_event_data = {}
	arg_2_0._frozen_unit_extensions = {}
	arg_2_0._dynamic_events = {}
	arg_2_0._entity_system_creation_context = arg_2_1
end

UnitFlowOverrideSystem.add_ext_functions = {
	UnitFlowOverrideExtension = function (arg_3_0, arg_3_1)
		arg_3_1.handle_flow_event = callback(arg_3_0, "handle_flow_event")
	end
}

UnitFlowOverrideSystem.on_add_extension = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3)
	local var_4_0 = {}

	UnitFlowOverrideSystem.add_ext_functions[arg_4_3](arg_4_0, var_4_0)
	ScriptUnit.set_extension(arg_4_2, "unit_flow_override_system", var_4_0)

	arg_4_0._unit_extensions[arg_4_2] = var_4_0
	arg_4_0._unit_event_data[arg_4_2] = {}

	return var_4_0
end

UnitFlowOverrideSystem.handle_flow_event = function (arg_5_0, arg_5_1, arg_5_2, arg_5_3)
	local var_5_0 = arg_5_0._unit_event_data[arg_5_1]

	var_5_0[arg_5_2] = var_5_0[arg_5_2] or {}

	local var_5_1 = var_5_0[arg_5_2]
	local var_5_2 = UnitFlowEventOverrideSettings[arg_5_2]

	var_5_2.init(arg_5_0, var_5_1, arg_5_1, arg_5_2, arg_5_3)

	if var_5_2.run_flow_event then
		local var_5_3 = var_5_2.flow_event_name or arg_5_2

		UNIT_FLOW_EVENT(arg_5_1, var_5_3, arg_5_3)
	end

	if var_5_2.is_dynamic then
		arg_5_0:_add_dynamic_event_data(arg_5_1, arg_5_2, var_5_1)
	end
end

UnitFlowOverrideSystem._add_dynamic_event_data = function (arg_6_0, arg_6_1, arg_6_2, arg_6_3)
	local var_6_0 = arg_6_0._dynamic_events
	local var_6_1 = var_6_0[arg_6_1] or {}

	var_6_1[arg_6_2] = arg_6_3
	var_6_0[arg_6_1] = var_6_1
end

local var_0_1 = {}

UnitFlowOverrideSystem.destroy_data = function (arg_7_0, arg_7_1, arg_7_2)
	local var_7_0 = arg_7_0._dynamic_events[arg_7_1] or var_0_1
	local var_7_1 = arg_7_0._unit_event_data[arg_7_1]
	local var_7_2 = var_7_1 and var_7_1[arg_7_2]

	if var_7_2 then
		local var_7_3 = UnitFlowEventOverrideSettings[arg_7_2]

		if var_7_3.destroy then
			var_7_3.destroy(arg_7_0, arg_7_1, arg_7_2, var_7_2)
		end
	end

	var_7_0[arg_7_2] = nil
end

UnitFlowOverrideSystem.update = function (arg_8_0, arg_8_1, arg_8_2)
	local var_8_0 = arg_8_0._dynamic_events

	for iter_8_0, iter_8_1 in pairs(var_8_0) do
		for iter_8_2, iter_8_3 in pairs(iter_8_1) do
			local var_8_1 = UnitFlowEventOverrideSettings[iter_8_2]

			if var_8_1.update(arg_8_0, iter_8_0, iter_8_2, iter_8_3, arg_8_2) then
				var_8_1.destroy(arg_8_0, iter_8_0, iter_8_2, iter_8_3)

				iter_8_1[iter_8_2] = nil
			end
		end
	end
end

UnitFlowOverrideSystem.on_remove_extension = function (arg_9_0, arg_9_1, arg_9_2)
	arg_9_0._frozen_unit_extensions[arg_9_1] = nil

	arg_9_0:_cleanup_extension(arg_9_1, arg_9_2)
	ScriptUnit.remove_extension(arg_9_1, arg_9_0.NAME)
end

UnitFlowOverrideSystem.on_freeze_extension = function (arg_10_0, arg_10_1, arg_10_2)
	local var_10_0 = arg_10_0._unit_extensions[arg_10_1]

	fassert(var_10_0, "Unit was already frozen.")

	arg_10_0._frozen_unit_extensions[arg_10_1] = var_10_0

	arg_10_0:_cleanup_extension(arg_10_1, arg_10_2)
end

UnitFlowOverrideSystem.freeze = function (arg_11_0, arg_11_1, arg_11_2, arg_11_3)
	local var_11_0 = arg_11_0._frozen_unit_extensions

	if var_11_0[arg_11_1] then
		return
	end

	local var_11_1 = arg_11_0._unit_extensions[arg_11_1]

	fassert(var_11_1, "Unit to freeze didn't have unfrozen extension")
	arg_11_0:_cleanup_extension(arg_11_1, arg_11_2)

	arg_11_0._unit_extensions[arg_11_1] = nil
	var_11_0[arg_11_1] = var_11_1
end

UnitFlowOverrideSystem.unfreeze = function (arg_12_0, arg_12_1)
	local var_12_0 = arg_12_0._frozen_unit_extensions[arg_12_1]

	fassert(var_12_0, "Unit to unfreeze didn't have frozen extension")

	arg_12_0._frozen_unit_extensions[arg_12_1] = nil
	arg_12_0._unit_extensions[arg_12_1] = var_12_0
end

UnitFlowOverrideSystem._cleanup_extension = function (arg_13_0, arg_13_1, arg_13_2)
	if arg_13_0._unit_extensions[arg_13_1] == nil then
		return
	end

	local var_13_0 = arg_13_0._unit_event_data[arg_13_1] or var_0_1

	for iter_13_0, iter_13_1 in pairs(var_13_0) do
		local var_13_1 = UnitFlowEventOverrideSettings[iter_13_0]

		if var_13_1.destroy then
			var_13_1.destroy(arg_13_0, arg_13_1, iter_13_0, iter_13_1)
		end
	end

	arg_13_0._dynamic_events[arg_13_1] = nil
	arg_13_0._unit_extensions[arg_13_1] = nil

	table.clear(arg_13_0._unit_event_data[arg_13_1])
end
