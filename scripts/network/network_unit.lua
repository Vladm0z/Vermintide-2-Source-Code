-- chunkname: @scripts/network/network_unit.lua

local NetworkUnit = NetworkUnit

NetworkUnit = NetworkUnit or {}
NetworkUnit = NetworkUnit

local NetworkUnitData = NetworkUnitData

NetworkUnitData = NetworkUnitData or {}
NetworkUnitData = NetworkUnitData

local NetworkUnitData_2 = NetworkUnitData

NetworkUnit.reset_unit_data = function ()
	-- function 1
	NetworkUnitData = {}
	NetworkUnitData_2 = NetworkUnitData
end

NetworkUnit.add_unit = function (arg_2_0)
	-- function 2
	assert(NetworkUnitData_2[arg_2_0] == nil)

	NetworkUnitData_2[arg_2_0] = {}
end

NetworkUnit.remove_unit = function (arg_3_0)
	-- function 3
	assert(NetworkUnitData_2[arg_3_0] ~= nil)

	NetworkUnitData_2[arg_3_0] = nil
end

NetworkUnit.reset_unit = function (arg_4_0)
	-- function 4
	assert(NetworkUnitData_2[arg_4_0] ~= nil)

	local var_4_0 = NetworkUnitData_2[arg_4_0]

	var_4_0.go_type = nil
	var_4_0.go_id = nil
	var_4_0.owner = nil
	var_4_0.is_husk = nil
end

NetworkUnit.set_game_object_type = function (arg_5_0, arg_5_1)
	-- function 5
	NetworkUnitData_2[arg_5_0].go_type = arg_5_1
end

NetworkUnit.game_object_type = function (arg_6_0)
	-- function 6
	return NetworkUnitData_2[arg_6_0].go_type
end

NetworkUnit.game_object_type_level = function (arg_7_0)
	-- function 7
	return NetworkUnitData_2[arg_7_0].go_type .. "_level"
end

NetworkUnit.set_game_object_id = function (arg_8_0, arg_8_1)
	-- function 8
	NetworkUnitData_2[arg_8_0].go_id = arg_8_1
end

NetworkUnit.game_object_id = function (arg_9_0)
	-- function 9
	return NetworkUnitData_2[arg_9_0].go_id
end

NetworkUnit.set_owner_peer_id = function (arg_10_0, arg_10_1)
	-- function 10
	NetworkUnitData_2[arg_10_0].owner = arg_10_1
end

NetworkUnit.owner_peer_id = function (arg_11_0)
	-- function 11
	return NetworkUnitData_2[arg_11_0].peer_id
end

NetworkUnit.set_is_husk_unit = function (arg_12_0, arg_12_1)
	-- function 12
	NetworkUnitData_2[arg_12_0].is_husk = arg_12_1
end

NetworkUnit.is_husk_unit = function (arg_13_0)
	-- function 13
	return not not NetworkUnitData_2[arg_13_0].is_husk
end

NetworkUnit.is_network_unit = function (arg_14_0)
	-- function 14
	return NetworkUnitData_2[arg_14_0] ~= nil
end

NetworkUnit.on_extensions_registered = function (arg_15_0)
	-- function 15
	Unit.set_flow_variable(arg_15_0, "is_husk_unit", NetworkUnit.is_husk_unit(arg_15_0))
	Unit.flow_event(arg_15_0, "on_extensions_registered")
end

NetworkUnit.on_game_object_sync_done = function (arg_16_0)
	-- function 16
	Unit.set_flow_variable(arg_16_0, "is_husk_unit", NetworkUnit.is_husk_unit(arg_16_0))
	Unit.flow_event(arg_16_0, "on_game_object_sync_done")
end

NetworkUnit.transfer_unit = function (arg_17_0, arg_17_1)
	-- function 17
	NetworkUnitData_2[arg_17_1] = NetworkUnitData_2[arg_17_0]
	NetworkUnitData_2[arg_17_0] = nil
end
