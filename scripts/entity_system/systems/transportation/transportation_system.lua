-- chunkname: @scripts/entity_system/systems/transportation/transportation_system.lua

require("scripts/unit_extensions/generic/linker_transportation_extension")

TransportationSystem = class(TransportationSystem, ExtensionSystemBase)

local tbl = {
	"LinkerTransportationExtension"
}
local tbl_2 = {
	"rpc_hot_join_sync_linker_transporting",
	"rpc_hot_join_sync_linker_transport_state",
	"rpc_hot_join_sync_linker_transport_generic_units",
	"rpc_add_transporting_ai_units",
	"rpc_add_transporting_generic_unit",
	"rpc_remove_transporting_ai_units"
}

TransportationSystem.init = function (self, arg_1_1, arg_1_2)
	-- function 1
	TransportationSystem.super.init(self, arg_1_1, arg_1_2, tbl)

	local network_event_delegate = arg_1_1.network_event_delegate

	self.network_event_delegate = network_event_delegate

	network_event_delegate:register(self, unpack(tbl_2))

	self._transporting_extension_by_unit = {}
	self._extension_lut = {}
end

TransportationSystem.on_add_extension = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4)
	-- function 2
	local on_add_extension = TransportationSystem.super.on_add_extension(arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4)

	arg_2_0._extension_lut[arg_2_2] = on_add_extension

	return on_add_extension
end

TransportationSystem.on_remove_extension = function (arg_3_0, arg_3_1, arg_3_2)
	-- function 3
	arg_3_0._extension_lut[arg_3_1] = nil

	return TransportationSystem.super.on_remove_extension(arg_3_0, arg_3_1, arg_3_2)
end

TransportationSystem.world_updated = function (self, arg_4_1, arg_4_2, arg_4_3)
	-- function 4
	for k, v in pairs(self._extension_lut) do
		v:world_updated(arg_4_1, arg_4_2, arg_4_3)
	end
end

TransportationSystem.clear_transporter_by_linked_unit = function (arg_5_0, arg_5_1)
	-- function 5
	arg_5_0._transporting_extension_by_unit[arg_5_1] = nil
end

TransportationSystem.try_claim_unit = function (self, arg_6_1, arg_6_2, arg_6_3)
	-- function 6
	local var_6_0 = self._transporting_extension_by_unit[arg_6_1]

	if not var_6_0 then
		self._transporting_extension_by_unit[arg_6_1] = arg_6_2

		return true
	end

	if not arg_6_3 then
		if not var_6_0:transporting() then
			return false
		end

		if not (arg_6_2:beginning() ~= var_6_0:beginning() or arg_6_2:transporting() or not (Level.unit_index(LevelHelper:current_level(self.world), arg_6_2.unit) > Level.unit_index(LevelHelper:current_level(self.world), var_6_0.unit))) then
			return
		end
	end

	var_6_0:force_unlink_unit(arg_6_1)

	self._transporting_extension_by_unit[arg_6_1] = arg_6_2

	return true
end

TransportationSystem.destroy = function (self)
	-- function 7
	self.network_event_delegate:unregister(self)

	self.network_event_delegate = nil
end

TransportationSystem.rpc_hot_join_sync_linker_transporting = function (self, arg_8_1, arg_8_2, arg_8_3)
	-- function 8
	local unit_by_index = Level.unit_by_index(LevelHelper:current_level(self.world), arg_8_2)

	ScriptUnit.extension(unit_by_index, "transportation_system"):rpc_hot_join_sync_linker_transporting(arg_8_3)
end

TransportationSystem.rpc_hot_join_sync_linker_transport_state = function (self, arg_9_1, arg_9_2, arg_9_3, arg_9_4)
	-- function 9
	local unit_by_index = Level.unit_by_index(LevelHelper:current_level(self.world), arg_9_2)

	ScriptUnit.extension(unit_by_index, "transportation_system"):rpc_hot_join_sync_linker_transport_state(arg_9_3, arg_9_4)
end

TransportationSystem.rpc_add_transporting_ai_units = function (self, arg_10_1, arg_10_2, arg_10_3, arg_10_4)
	-- function 10
	local unit_by_index = Level.unit_by_index(LevelHelper:current_level(self.world), arg_10_2)
	local extension = ScriptUnit.extension(unit_by_index, "transportation_system")
	local unit_storage = Managers.state.network.unit_storage

	for i = 1, #arg_10_3 do
		local unit = unit_storage:unit(arg_10_3[i])

		if not unit then
			extension:add_transporting_ai_unit(unit, arg_10_4[i])
		end
	end
end

TransportationSystem.rpc_remove_transporting_ai_units = function (self, arg_11_1, arg_11_2, arg_11_3)
	-- function 11
	local unit_by_index = Level.unit_by_index(LevelHelper:current_level(self.world), arg_11_2)
	local extension = ScriptUnit.extension(unit_by_index, "transportation_system")
	local unit_storage = Managers.state.network.unit_storage

	for i = 1, #arg_11_3 do
		local unit = unit_storage:unit(arg_11_3[i])

		extension:remove_transporting_ai_unit(unit)
	end
end

TransportationSystem.rpc_hot_join_sync_linker_transport_generic_units = function (self, arg_12_1, arg_12_2, arg_12_3, arg_12_4, arg_12_5, arg_12_6)
	-- function 12
	local unit_by_index = Level.unit_by_index(LevelHelper:current_level(self.world), arg_12_2)
	local extension = ScriptUnit.extension(unit_by_index, "transportation_system")
	local network = Managers.state.network

	for i = 1, #arg_12_3 do
		local var_12_3 = arg_12_4[i]
		local game_object_or_level_unit = network:game_object_or_level_unit(arg_12_3[i], var_12_3)

		if not Unit.alive(game_object_or_level_unit) then
			local from_quaternion_position = Matrix4x4.from_quaternion_position(arg_12_6[i], arg_12_5[i])

			extension:add_transporting_generic_unit(game_object_or_level_unit, from_quaternion_position, true)
		end
	end
end

TransportationSystem.rpc_add_transporting_generic_unit = function (self, arg_13_1, arg_13_2, arg_13_3, arg_13_4, arg_13_5, arg_13_6)
	-- function 13
	local game_object_or_level_unit = Managers.state.network:game_object_or_level_unit(arg_13_3, arg_13_4)

	if not game_object_or_level_unit then
		local unit_by_index = Level.unit_by_index(LevelHelper:current_level(self.world), arg_13_2)
		local from_quaternion_position = Matrix4x4.from_quaternion_position(arg_13_6, arg_13_5)

		ScriptUnit.extension(unit_by_index, "transportation_system"):add_transporting_generic_unit(game_object_or_level_unit, from_quaternion_position, true)
	end
end
