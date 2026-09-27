-- chunkname: @scripts/entity_system/systems/ai/ai_commander_system.lua

require("scripts/unit_extensions/ai_commander/command_states")
require("scripts/unit_extensions/ai_commander/controlled_unit_templates")

local tbl = {
	"rpc_add_controlled_unit",
	"rpc_remove_controlled_unit",
	"rpc_cancel_current_command",
	"rpc_command_stand_ground",
	"rpc_command_attack",
	"rpc_set_controlled_unit_template"
}
local tbl_2 = {
	"AICommanderExtension"
}

AICommanderSystem = class(AICommanderSystem, ExtensionSystemBase)

AICommanderSystem.init = function (self, arg_1_1, arg_1_2)
	-- function 1
	AICommanderSystem.super.init(self, arg_1_1, arg_1_2, tbl_2)

	self._is_server = arg_1_1.is_server
	self._unit_storage = arg_1_1.unit_storage
	self._network_transmit = arg_1_1.network_transmit
	self._network_event_delegate = arg_1_1.network_event_delegate

	self._network_event_delegate:register(self, unpack(tbl))

	self._commander_unit_lookup = {}
	self._extensions = {}
end

AICommanderSystem.destroy = function (self)
	-- function 2
	self._network_event_delegate:unregister(self)
end

AICommanderSystem.register_commander_unit = function (self, arg_3_1, arg_3_2)
	-- function 3
	assert(self._commander_unit_lookup[arg_3_2] == nil, "unit [%s] already has a commander [%s]", arg_3_2, self._commander_unit_lookup[arg_3_2])

	self._commander_unit_lookup[arg_3_2] = arg_3_1
end

AICommanderSystem.clear_commander_unit = function (arg_4_0, arg_4_1)
	-- function 4
	arg_4_0._commander_unit_lookup[arg_4_1] = nil
end

AICommanderSystem.get_commander_unit = function (self, arg_5_1)
	-- function 5
	return self._commander_unit_lookup[arg_5_1]
end

AICommanderSystem.on_add_extension = function (arg_6_0, arg_6_1, arg_6_2, arg_6_3, arg_6_4)
	-- function 6
	local on_add_extension = AICommanderSystem.super.on_add_extension(arg_6_0, arg_6_1, arg_6_2, arg_6_3, arg_6_4)

	arg_6_0._extensions[arg_6_2] = on_add_extension

	return on_add_extension
end

AICommanderSystem.on_remove_extension = function (self, arg_7_1, arg_7_2)
	-- function 7
	local var_7_0 = self._extensions[arg_7_1]

	self:_cleanup_extension(var_7_0)

	self._extensions[arg_7_1] = nil

	AICommanderSystem.super.on_remove_extension(self, arg_7_1, arg_7_2)
end

AICommanderSystem._cleanup_extension = function (arg_8_0, arg_8_1)
	-- function 8
	local get_controlled_units = arg_8_1:get_controlled_units()

	for k in pairs(get_controlled_units) do
		local flag = true

		arg_8_1:remove_controlled_unit(k, flag)
	end
end

AICommanderSystem.rpc_add_controlled_unit = function (self, arg_9_1, arg_9_2, arg_9_3, arg_9_4)
	-- function 9
	local unit = self._unit_storage:unit(arg_9_2)
	local unit_2 = self._unit_storage:unit(arg_9_3)

	if not ALIVE[unit] and not ALIVE[unit_2] then
		local var_9_2 = self._extensions[unit]
		local var_9_3 = NetworkLookup.controlled_unit_templates[arg_9_4]
		local flag = true
		local time = Managers.time:time("game")

		var_9_2:add_controlled_unit(unit_2, var_9_3, time, flag)
	end
end

AICommanderSystem.rpc_remove_controlled_unit = function (self, arg_10_1, arg_10_2, arg_10_3)
	-- function 10
	local unit = self._unit_storage:unit(arg_10_2)
	local unit_2 = self._unit_storage:unit(arg_10_3)

	if not ALIVE[unit] and not ALIVE[unit_2] then
		local var_10_2 = self._extensions[unit]
		local flag = true

		var_10_2:remove_controlled_unit(unit_2, flag)
	end
end

AICommanderSystem.rpc_cancel_current_command = function (self, arg_11_1, arg_11_2)
	-- function 11
	local unit = self._unit_storage:unit(arg_11_2)
	local get_commander_unit = self:get_commander_unit(unit)

	if not get_commander_unit then
		return
	end

	local var_11_2 = self._extensions[get_commander_unit]

	if not var_11_2 then
		return
	end

	var_11_2:cancel_current_command(unit)
end

AICommanderSystem.rpc_command_stand_ground = function (self, arg_12_1, arg_12_2, arg_12_3, arg_12_4)
	-- function 12
	local unit = self._unit_storage:unit(arg_12_2)
	local get_commander_unit = self:get_commander_unit(unit)

	if not get_commander_unit then
		return
	end

	local var_12_2 = self._extensions[get_commander_unit]

	if not var_12_2 then
		return
	end

	var_12_2:command_stand_ground(unit, arg_12_3, arg_12_4)
end

AICommanderSystem.rpc_command_attack = function (self, arg_13_1, arg_13_2, arg_13_3)
	-- function 13
	local unit = self._unit_storage:unit(arg_13_2)
	local get_commander_unit = self:get_commander_unit(unit)

	if not get_commander_unit then
		return
	end

	local var_13_2 = self._extensions[get_commander_unit]

	if not var_13_2 then
		return
	end

	local unit_2 = self._unit_storage:unit(arg_13_3)

	if not ALIVE[unit_2] then
		return
	end

	var_13_2:command_attack(unit, unit_2)
end

AICommanderSystem.rpc_set_controlled_unit_template = function (self, arg_14_1, arg_14_2, arg_14_3)
	-- function 14
	local unit = self._unit_storage:unit(arg_14_2)
	local get_commander_unit = self:get_commander_unit(unit)

	if not get_commander_unit then
		return
	end

	local var_14_2 = self._extensions[get_commander_unit]

	if not var_14_2 then
		return
	end

	local var_14_3 = NetworkLookup.controlled_unit_templates[arg_14_3]

	var_14_2:set_controlled_unit_template(unit, var_14_3, true)
end
