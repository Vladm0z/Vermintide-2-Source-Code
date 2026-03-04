-- chunkname: @scripts/network/network_unit.lua

NetworkUnit = NetworkUnit or {}
NetworkUnitData = NetworkUnitData or {}

local var_0_0 = NetworkUnitData

NetworkUnit.reset_unit_data = function ()
	NetworkUnitData = {}
	var_0_0 = NetworkUnitData
end

NetworkUnit.add_unit = function (arg_2_0)
	assert(var_0_0[arg_2_0] == nil)

	var_0_0[arg_2_0] = {}
end

NetworkUnit.remove_unit = function (arg_3_0)
	assert(var_0_0[arg_3_0] ~= nil)

	var_0_0[arg_3_0] = nil
end

NetworkUnit.reset_unit = function (arg_4_0)
	assert(var_0_0[arg_4_0] ~= nil)

	local var_4_0 = var_0_0[arg_4_0]

	var_4_0.go_type = nil
	var_4_0.go_id = nil
	var_4_0.owner = nil
	var_4_0.is_husk = nil
end

NetworkUnit.set_game_object_type = function (arg_5_0, arg_5_1)
	var_0_0[arg_5_0].go_type = arg_5_1
end

NetworkUnit.game_object_type = function (arg_6_0)
	return var_0_0[arg_6_0].go_type
end

NetworkUnit.game_object_type_level = function (arg_7_0)
	return var_0_0[arg_7_0].go_type .. "_level"
end

NetworkUnit.set_game_object_id = function (arg_8_0, arg_8_1)
	var_0_0[arg_8_0].go_id = arg_8_1
end

NetworkUnit.game_object_id = function (arg_9_0)
	return var_0_0[arg_9_0].go_id
end

NetworkUnit.set_owner_peer_id = function (arg_10_0, arg_10_1)
	var_0_0[arg_10_0].owner = arg_10_1
end

NetworkUnit.owner_peer_id = function (arg_11_0)
	return var_0_0[arg_11_0].peer_id
end

NetworkUnit.set_is_husk_unit = function (arg_12_0, arg_12_1)
	var_0_0[arg_12_0].is_husk = arg_12_1
end

NetworkUnit.is_husk_unit = function (arg_13_0)
	return not not var_0_0[arg_13_0].is_husk
end

NetworkUnit.is_network_unit = function (arg_14_0)
	return var_0_0[arg_14_0] ~= nil
end

NetworkUnit.on_extensions_registered = function (arg_15_0)
	Unit.set_flow_variable(arg_15_0, "is_husk_unit", NetworkUnit.is_husk_unit(arg_15_0))
	Unit.flow_event(arg_15_0, "on_extensions_registered")
end

NetworkUnit.on_game_object_sync_done = function (arg_16_0)
	Unit.set_flow_variable(arg_16_0, "is_husk_unit", NetworkUnit.is_husk_unit(arg_16_0))
	Unit.flow_event(arg_16_0, "on_game_object_sync_done")
end

NetworkUnit.transfer_unit = function (arg_17_0, arg_17_1)
	var_0_0[arg_17_1] = var_0_0[arg_17_0]
	var_0_0[arg_17_0] = nil
end
