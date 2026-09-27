-- chunkname: @scripts/entity_system/systems/unit_flow_override_system/unit_flow_override_system.lua

require("scripts/entity_system/systems/unit_flow_override_system/unit_flow_event_override_settings")

UnitFlowOverrideSystem = class(UnitFlowOverrideSystem, ExtensionSystemBase)

local UNIT_FLOW_EVENT = UNIT_FLOW_EVENT

UNIT_FLOW_EVENT = UNIT_FLOW_EVENT or Unit.flow_event
UNIT_FLOW_EVENT = UNIT_FLOW_EVENT

if not UNIT_FLOW_EVENT_OVERRIDDEN then
	Unit.flow_event = function (arg_1_0, arg_1_1, arg_1_2)
		-- function 1
		local has_extension = ScriptUnit.has_extension(arg_1_0, "unit_flow_override_system")

		if not has_extension and not UnitFlowEventOverrideSettings[arg_1_1] then
			has_extension.handle_flow_event(arg_1_0, arg_1_1, arg_1_2)
		else
			UNIT_FLOW_EVENT(arg_1_0, arg_1_1, arg_1_2)
		end
	end

	UNIT_FLOW_EVENT_OVERRIDDEN = true
end

local tbl = {
	"UnitFlowOverrideExtension"
}

UnitFlowOverrideSystem.init = function (self, arg_2_1, arg_2_2)
	-- function 2
	UnitFlowOverrideSystem.super.init(self, arg_2_1, arg_2_2, tbl)

	self._unit_extensions = {}
	self._unit_event_data = {}
	self._frozen_unit_extensions = {}
	self._dynamic_events = {}
	self._entity_system_creation_context = arg_2_1
end

UnitFlowOverrideSystem.add_ext_functions = {
	UnitFlowOverrideExtension = function (arg_3_0, arg_3_1)
		-- function 3
		arg_3_1.handle_flow_event = callback(arg_3_0, "handle_flow_event")
	end
}

UnitFlowOverrideSystem.on_add_extension = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3)
	-- function 4
	local tbl = {}

	UnitFlowOverrideSystem.add_ext_functions[arg_4_3](arg_4_0, tbl)
	ScriptUnit.set_extension(arg_4_2, "unit_flow_override_system", tbl)

	arg_4_0._unit_extensions[arg_4_2] = tbl
	arg_4_0._unit_event_data[arg_4_2] = {}

	return tbl
end

UnitFlowOverrideSystem.handle_flow_event = function (self, arg_5_1, arg_5_2, arg_5_3)
	-- function 5
	local var_5_0 = self._unit_event_data[arg_5_1]
	local var_5_1 = var_5_0[arg_5_2]

	var_5_1 = var_5_1 or {}
	var_5_0[arg_5_2] = var_5_1

	local var_5_2 = var_5_0[arg_5_2]
	local var_5_3 = UnitFlowEventOverrideSettings[arg_5_2]

	var_5_3.init(self, var_5_2, arg_5_1, arg_5_2, arg_5_3)

	if not var_5_3.run_flow_event then
		local flow_event_name = var_5_3.flow_event_name

		flow_event_name = flow_event_name or arg_5_2

		UNIT_FLOW_EVENT(arg_5_1, flow_event_name, arg_5_3)
	end

	if not var_5_3.is_dynamic then
		self:_add_dynamic_event_data(arg_5_1, arg_5_2, var_5_2)
	end
end

UnitFlowOverrideSystem._add_dynamic_event_data = function (self, arg_6_1, arg_6_2, arg_6_3)
	-- function 6
	local _dynamic_events = self._dynamic_events
	local var_6_1 = _dynamic_events[arg_6_1]

	var_6_1 = var_6_1 or {}
	var_6_1[arg_6_2] = arg_6_3
	_dynamic_events[arg_6_1] = var_6_1
end

local tbl_2 = {}

UnitFlowOverrideSystem.destroy_data = function (self, arg_7_1, arg_7_2)
	-- function 7
	local var_7_0 = self._dynamic_events[arg_7_1]

	var_7_0 = var_7_0 or tbl_2

	local var_7_1 = self._unit_event_data[arg_7_1]
	local flag = not var_7_1 and var_7_1[arg_7_2]

	if not flag then
		local var_7_3 = UnitFlowEventOverrideSettings[arg_7_2]

		if not var_7_3.destroy then
			var_7_3.destroy(self, arg_7_1, arg_7_2, flag)
		end
	end

	var_7_0[arg_7_2] = nil
end

UnitFlowOverrideSystem.update = function (self, arg_8_1, arg_8_2)
	-- function 8
	local _dynamic_events = self._dynamic_events

	for k, v in pairs(_dynamic_events) do
		for k_2, v_2 in pairs(v) do
			local var_8_1 = UnitFlowEventOverrideSettings[k_2]

			if not var_8_1.update(self, k, k_2, v_2, arg_8_2) then
				var_8_1.destroy(self, k, k_2, v_2)

				v[k_2] = nil
			end
		end
	end
end

UnitFlowOverrideSystem.on_remove_extension = function (self, arg_9_1, arg_9_2)
	-- function 9
	self._frozen_unit_extensions[arg_9_1] = nil

	self:_cleanup_extension(arg_9_1, arg_9_2)
	ScriptUnit.remove_extension(arg_9_1, self.NAME)
end

UnitFlowOverrideSystem.on_freeze_extension = function (self, arg_10_1, arg_10_2)
	-- function 10
	local var_10_0 = self._unit_extensions[arg_10_1]

	fassert(var_10_0, "Unit was already frozen.")

	self._frozen_unit_extensions[arg_10_1] = var_10_0

	self:_cleanup_extension(arg_10_1, arg_10_2)
end

UnitFlowOverrideSystem.freeze = function (self, arg_11_1, arg_11_2, arg_11_3)
	-- function 11
	local _frozen_unit_extensions = self._frozen_unit_extensions

	if not _frozen_unit_extensions[arg_11_1] then
		return
	end

	local var_11_1 = self._unit_extensions[arg_11_1]

	fassert(var_11_1, "Unit to freeze didn't have unfrozen extension")
	self:_cleanup_extension(arg_11_1, arg_11_2)

	self._unit_extensions[arg_11_1] = nil
	_frozen_unit_extensions[arg_11_1] = var_11_1
end

UnitFlowOverrideSystem.unfreeze = function (self, arg_12_1)
	-- function 12
	local var_12_0 = self._frozen_unit_extensions[arg_12_1]

	fassert(var_12_0, "Unit to unfreeze didn't have frozen extension")

	self._frozen_unit_extensions[arg_12_1] = nil
	self._unit_extensions[arg_12_1] = var_12_0
end

UnitFlowOverrideSystem._cleanup_extension = function (self, arg_13_1, arg_13_2)
	-- function 13
	if self._unit_extensions[arg_13_1] == nil then
		return
	end

	local var_13_0 = self._unit_event_data[arg_13_1]

	var_13_0 = var_13_0 or tbl_2

	for k, v in pairs(var_13_0) do
		local var_13_1 = UnitFlowEventOverrideSettings[k]

		if not var_13_1.destroy then
			var_13_1.destroy(self, arg_13_1, k, v)
		end
	end

	self._dynamic_events[arg_13_1] = nil
	self._unit_extensions[arg_13_1] = nil

	table.clear(self._unit_event_data[arg_13_1])
end
