-- chunkname: @scripts/entity_system/systems/transportation/transportation_system.lua

require("scripts/unit_extensions/generic/linker_transportation_extension")

TransportationSystem = class(TransportationSystem, ExtensionSystemBase)

local var_0_0 = {
	"LinkerTransportationExtension"
}
local var_0_1 = {
	"rpc_hot_join_sync_linker_transporting",
	"rpc_hot_join_sync_linker_transport_state",
	"rpc_hot_join_sync_linker_transport_generic_units",
	"rpc_add_transporting_ai_units",
	"rpc_add_transporting_generic_unit",
	"rpc_remove_transporting_ai_units"
}

TransportationSystem.init = function (arg_1_0, arg_1_1, arg_1_2)
	TransportationSystem.super.init(arg_1_0, arg_1_1, arg_1_2, var_0_0)

	local var_1_0 = arg_1_1.network_event_delegate

	arg_1_0.network_event_delegate = var_1_0

	var_1_0:register(arg_1_0, unpack(var_0_1))

	arg_1_0._transporting_extension_by_unit = {}
	arg_1_0._extension_lut = {}
end

TransportationSystem.on_add_extension = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4)
	local var_2_0 = TransportationSystem.super.on_add_extension(arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4)

	arg_2_0._extension_lut[arg_2_2] = var_2_0

	return var_2_0
end

TransportationSystem.on_remove_extension = function (arg_3_0, arg_3_1, arg_3_2)
	arg_3_0._extension_lut[arg_3_1] = nil

	return TransportationSystem.super.on_remove_extension(arg_3_0, arg_3_1, arg_3_2)
end

TransportationSystem.world_updated = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3)
	for iter_4_0, iter_4_1 in pairs(arg_4_0._extension_lut) do
		iter_4_1:world_updated(arg_4_1, arg_4_2, arg_4_3)
	end
end

TransportationSystem.clear_transporter_by_linked_unit = function (arg_5_0, arg_5_1)
	arg_5_0._transporting_extension_by_unit[arg_5_1] = nil
end

TransportationSystem.try_claim_unit = function (arg_6_0, arg_6_1, arg_6_2, arg_6_3)
	local var_6_0 = arg_6_0._transporting_extension_by_unit[arg_6_1]

	if not var_6_0 then
		arg_6_0._transporting_extension_by_unit[arg_6_1] = arg_6_2

		return true
	end

	if not arg_6_3 then
		if var_6_0:transporting() then
			return false
		end

		if arg_6_2:beginning() == var_6_0:beginning() and not arg_6_2:transporting() and Level.unit_index(LevelHelper:current_level(arg_6_0.world), arg_6_2.unit) > Level.unit_index(LevelHelper:current_level(arg_6_0.world), var_6_0.unit) then
			return
		end
	end

	var_6_0:force_unlink_unit(arg_6_1)

	arg_6_0._transporting_extension_by_unit[arg_6_1] = arg_6_2

	return true
end

TransportationSystem.destroy = function (arg_7_0)
	arg_7_0.network_event_delegate:unregister(arg_7_0)

	arg_7_0.network_event_delegate = nil
end

TransportationSystem.rpc_hot_join_sync_linker_transporting = function (arg_8_0, arg_8_1, arg_8_2, arg_8_3)
	local var_8_0 = Level.unit_by_index(LevelHelper:current_level(arg_8_0.world), arg_8_2)

	ScriptUnit.extension(var_8_0, "transportation_system"):rpc_hot_join_sync_linker_transporting(arg_8_3)
end

TransportationSystem.rpc_hot_join_sync_linker_transport_state = function (arg_9_0, arg_9_1, arg_9_2, arg_9_3, arg_9_4)
	local var_9_0 = Level.unit_by_index(LevelHelper:current_level(arg_9_0.world), arg_9_2)

	ScriptUnit.extension(var_9_0, "transportation_system"):rpc_hot_join_sync_linker_transport_state(arg_9_3, arg_9_4)
end

TransportationSystem.rpc_add_transporting_ai_units = function (arg_10_0, arg_10_1, arg_10_2, arg_10_3, arg_10_4)
	local var_10_0 = Level.unit_by_index(LevelHelper:current_level(arg_10_0.world), arg_10_2)
	local var_10_1 = ScriptUnit.extension(var_10_0, "transportation_system")
	local var_10_2 = Managers.state.network.unit_storage

	for iter_10_0 = 1, #arg_10_3 do
		local var_10_3 = var_10_2:unit(arg_10_3[iter_10_0])

		if var_10_3 then
			var_10_1:add_transporting_ai_unit(var_10_3, arg_10_4[iter_10_0])
		end
	end
end

TransportationSystem.rpc_remove_transporting_ai_units = function (arg_11_0, arg_11_1, arg_11_2, arg_11_3)
	local var_11_0 = Level.unit_by_index(LevelHelper:current_level(arg_11_0.world), arg_11_2)
	local var_11_1 = ScriptUnit.extension(var_11_0, "transportation_system")
	local var_11_2 = Managers.state.network.unit_storage

	for iter_11_0 = 1, #arg_11_3 do
		local var_11_3 = var_11_2:unit(arg_11_3[iter_11_0])

		var_11_1:remove_transporting_ai_unit(var_11_3)
	end
end

TransportationSystem.rpc_hot_join_sync_linker_transport_generic_units = function (arg_12_0, arg_12_1, arg_12_2, arg_12_3, arg_12_4, arg_12_5, arg_12_6)
	local var_12_0 = Level.unit_by_index(LevelHelper:current_level(arg_12_0.world), arg_12_2)
	local var_12_1 = ScriptUnit.extension(var_12_0, "transportation_system")
	local var_12_2 = Managers.state.network

	for iter_12_0 = 1, #arg_12_3 do
		local var_12_3 = arg_12_4[iter_12_0]
		local var_12_4 = var_12_2:game_object_or_level_unit(arg_12_3[iter_12_0], var_12_3)

		if Unit.alive(var_12_4) then
			local var_12_5 = Matrix4x4.from_quaternion_position(arg_12_6[iter_12_0], arg_12_5[iter_12_0])

			var_12_1:add_transporting_generic_unit(var_12_4, var_12_5, true)
		end
	end
end

TransportationSystem.rpc_add_transporting_generic_unit = function (arg_13_0, arg_13_1, arg_13_2, arg_13_3, arg_13_4, arg_13_5, arg_13_6)
	local var_13_0 = Managers.state.network:game_object_or_level_unit(arg_13_3, arg_13_4)

	if var_13_0 then
		local var_13_1 = Level.unit_by_index(LevelHelper:current_level(arg_13_0.world), arg_13_2)
		local var_13_2 = Matrix4x4.from_quaternion_position(arg_13_6, arg_13_5)

		ScriptUnit.extension(var_13_1, "transportation_system"):add_transporting_generic_unit(var_13_0, var_13_2, true)
	end
end
