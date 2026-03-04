-- chunkname: @scripts/entity_system/systems/ai/ai_commander_system.lua

require("scripts/unit_extensions/ai_commander/command_states")
require("scripts/unit_extensions/ai_commander/controlled_unit_templates")

local var_0_0 = {
	"rpc_add_controlled_unit",
	"rpc_remove_controlled_unit",
	"rpc_cancel_current_command",
	"rpc_command_stand_ground",
	"rpc_command_attack",
	"rpc_set_controlled_unit_template"
}
local var_0_1 = {
	"AICommanderExtension"
}

AICommanderSystem = class(AICommanderSystem, ExtensionSystemBase)

AICommanderSystem.init = function (arg_1_0, arg_1_1, arg_1_2)
	AICommanderSystem.super.init(arg_1_0, arg_1_1, arg_1_2, var_0_1)

	arg_1_0._is_server = arg_1_1.is_server
	arg_1_0._unit_storage = arg_1_1.unit_storage
	arg_1_0._network_transmit = arg_1_1.network_transmit
	arg_1_0._network_event_delegate = arg_1_1.network_event_delegate

	arg_1_0._network_event_delegate:register(arg_1_0, unpack(var_0_0))

	arg_1_0._commander_unit_lookup = {}
	arg_1_0._extensions = {}
end

AICommanderSystem.destroy = function (arg_2_0)
	arg_2_0._network_event_delegate:unregister(arg_2_0)
end

AICommanderSystem.register_commander_unit = function (arg_3_0, arg_3_1, arg_3_2)
	assert(arg_3_0._commander_unit_lookup[arg_3_2] == nil, "unit [%s] already has a commander [%s]", arg_3_2, arg_3_0._commander_unit_lookup[arg_3_2])

	arg_3_0._commander_unit_lookup[arg_3_2] = arg_3_1
end

AICommanderSystem.clear_commander_unit = function (arg_4_0, arg_4_1)
	arg_4_0._commander_unit_lookup[arg_4_1] = nil
end

AICommanderSystem.get_commander_unit = function (arg_5_0, arg_5_1)
	return arg_5_0._commander_unit_lookup[arg_5_1]
end

AICommanderSystem.on_add_extension = function (arg_6_0, arg_6_1, arg_6_2, arg_6_3, arg_6_4)
	local var_6_0 = AICommanderSystem.super.on_add_extension(arg_6_0, arg_6_1, arg_6_2, arg_6_3, arg_6_4)

	arg_6_0._extensions[arg_6_2] = var_6_0

	return var_6_0
end

AICommanderSystem.on_remove_extension = function (arg_7_0, arg_7_1, arg_7_2)
	local var_7_0 = arg_7_0._extensions[arg_7_1]

	arg_7_0:_cleanup_extension(var_7_0)

	arg_7_0._extensions[arg_7_1] = nil

	AICommanderSystem.super.on_remove_extension(arg_7_0, arg_7_1, arg_7_2)
end

AICommanderSystem._cleanup_extension = function (arg_8_0, arg_8_1)
	local var_8_0 = arg_8_1:get_controlled_units()

	for iter_8_0 in pairs(var_8_0) do
		local var_8_1 = true

		arg_8_1:remove_controlled_unit(iter_8_0, var_8_1)
	end
end

AICommanderSystem.rpc_add_controlled_unit = function (arg_9_0, arg_9_1, arg_9_2, arg_9_3, arg_9_4)
	local var_9_0 = arg_9_0._unit_storage:unit(arg_9_2)
	local var_9_1 = arg_9_0._unit_storage:unit(arg_9_3)

	if ALIVE[var_9_0] and ALIVE[var_9_1] then
		local var_9_2 = arg_9_0._extensions[var_9_0]
		local var_9_3 = NetworkLookup.controlled_unit_templates[arg_9_4]
		local var_9_4 = true
		local var_9_5 = Managers.time:time("game")

		var_9_2:add_controlled_unit(var_9_1, var_9_3, var_9_5, var_9_4)
	end
end

AICommanderSystem.rpc_remove_controlled_unit = function (arg_10_0, arg_10_1, arg_10_2, arg_10_3)
	local var_10_0 = arg_10_0._unit_storage:unit(arg_10_2)
	local var_10_1 = arg_10_0._unit_storage:unit(arg_10_3)

	if ALIVE[var_10_0] and ALIVE[var_10_1] then
		local var_10_2 = arg_10_0._extensions[var_10_0]
		local var_10_3 = true

		var_10_2:remove_controlled_unit(var_10_1, var_10_3)
	end
end

AICommanderSystem.rpc_cancel_current_command = function (arg_11_0, arg_11_1, arg_11_2)
	local var_11_0 = arg_11_0._unit_storage:unit(arg_11_2)
	local var_11_1 = arg_11_0:get_commander_unit(var_11_0)

	if not var_11_1 then
		return
	end

	local var_11_2 = arg_11_0._extensions[var_11_1]

	if not var_11_2 then
		return
	end

	var_11_2:cancel_current_command(var_11_0)
end

AICommanderSystem.rpc_command_stand_ground = function (arg_12_0, arg_12_1, arg_12_2, arg_12_3, arg_12_4)
	local var_12_0 = arg_12_0._unit_storage:unit(arg_12_2)
	local var_12_1 = arg_12_0:get_commander_unit(var_12_0)

	if not var_12_1 then
		return
	end

	local var_12_2 = arg_12_0._extensions[var_12_1]

	if not var_12_2 then
		return
	end

	var_12_2:command_stand_ground(var_12_0, arg_12_3, arg_12_4)
end

AICommanderSystem.rpc_command_attack = function (arg_13_0, arg_13_1, arg_13_2, arg_13_3)
	local var_13_0 = arg_13_0._unit_storage:unit(arg_13_2)
	local var_13_1 = arg_13_0:get_commander_unit(var_13_0)

	if not var_13_1 then
		return
	end

	local var_13_2 = arg_13_0._extensions[var_13_1]

	if not var_13_2 then
		return
	end

	local var_13_3 = arg_13_0._unit_storage:unit(arg_13_3)

	if not ALIVE[var_13_3] then
		return
	end

	var_13_2:command_attack(var_13_0, var_13_3)
end

AICommanderSystem.rpc_set_controlled_unit_template = function (arg_14_0, arg_14_1, arg_14_2, arg_14_3)
	local var_14_0 = arg_14_0._unit_storage:unit(arg_14_2)
	local var_14_1 = arg_14_0:get_commander_unit(var_14_0)

	if not var_14_1 then
		return
	end

	local var_14_2 = arg_14_0._extensions[var_14_1]

	if not var_14_2 then
		return
	end

	local var_14_3 = NetworkLookup.controlled_unit_templates[arg_14_3]

	var_14_2:set_controlled_unit_template(var_14_0, var_14_3, true)
end
