-- chunkname: @scripts/entity_system/systems/unit_flow_override_system/unit_flow_event_override_settings.lua

local scripts_entity_system_systems_unit_flow_override_system_breed_unit_flow_event_overrides = require("scripts/entity_system/systems/unit_flow_override_system/breed_unit_flow_event_overrides")

if not unit_alive then
	local alive = Unit.alive
end

local tbl = {}

UnitFlowEventOverrideSettings = {}
