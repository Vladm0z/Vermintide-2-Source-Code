-- chunkname: @scripts/network/network_unit.lua

NetworkUnit = NetworkUnit or {}
NetworkUnitData = NetworkUnitData or {}

local var_0_0 = NetworkUnitData

function NetworkUnit.reset_unit_data()
	NetworkUnitData = {}
	var_0_0 = NetworkUnitData
end

function NetworkUnit.add_unit(arg_2_0)
	assert(var_0_0[arg_2_0] == nil)

	var_0_0[arg_2_0] = {}
end

function NetworkUnit.remove_unit(arg_3_0)
	assert(var_0_0[arg_3_0] ~= nil)

	var_0_0[arg_3_0] = nil
end

function NetworkUnit.reset_unit(arg_4_0)
	assert(var_0_0[arg_4_0] ~= nil)

	local var_4_0 = var_0_0[arg_4_0]

	var_4_0.go_type = nil
	var_4_0.go_id = nil
	var_4_0.owner = nil
	var_4_0.is_husk = nil
end

function NetworkUnit.set_game_object_type(arg_5_0, arg_5_1)
	var_0_0[arg_5_0].go_type = arg_5_1
end

function NetworkUnit.game_object_type(arg_6_0)
	return var_0_0[arg_6_0].go_type
end

function NetworkUnit.game_object_type_level(arg_7_0)
	return var_0_0[arg_7_0].go_type .. "_level"
end

function NetworkUnit.set_game_object_id(arg_8_0, arg_8_1)
	var_0_0[arg_8_0].go_id = arg_8_1
end

function NetworkUnit.game_object_id(arg_9_0)
	return var_0_0[arg_9_0].go_id
end

function NetworkUnit.set_owner_peer_id(arg_10_0, arg_10_1)
	var_0_0[arg_10_0].owner = arg_10_1
end

function NetworkUnit.owner_peer_id(arg_11_0)
	return var_0_0[arg_11_0].peer_id
end

function NetworkUnit.set_is_husk_unit(arg_12_0, arg_12_1)
	var_0_0[arg_12_0].is_husk = arg_12_1
end

function NetworkUnit.is_husk_unit(arg_13_0)
	return not not var_0_0[arg_13_0].is_husk
end

function NetworkUnit.is_network_unit(arg_14_0)
	return var_0_0[arg_14_0] ~= nil
end

function NetworkUnit.on_extensions_registered(arg_15_0)
	Unit.set_flow_variable(arg_15_0, "is_husk_unit", NetworkUnit.is_husk_unit(arg_15_0))
	Unit.flow_event(arg_15_0, "on_extensions_registered")
end

function NetworkUnit.on_game_object_sync_done(arg_16_0)
	Unit.set_flow_variable(arg_16_0, "is_husk_unit", NetworkUnit.is_husk_unit(arg_16_0))
	Unit.flow_event(arg_16_0, "on_game_object_sync_done")
end

function NetworkUnit.transfer_unit(arg_17_0, arg_17_1)
	var_0_0[arg_17_1] = var_0_0[arg_17_0]
	var_0_0[arg_17_0] = nil
end
